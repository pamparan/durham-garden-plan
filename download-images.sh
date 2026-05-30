#!/bin/bash
# Downloads all pest identification images from Wikimedia Commons
# Run: bash download-images.sh

set -e
mkdir -p images

python3 << 'PYEOF'
import urllib.request
import json
import os
import sys

IMAGES = {
    "svb.jpg": "Melittia cucurbitae P1440822a.jpg",
    "hornworm.jpg": "Tobacco Hornworm 1.jpg",
    "cucumber-beetle-striped.jpg": "Acalymma vittatum 1323034.jpg",
    "cucumber-beetle-spotted.jpg": "Spotted Cucumber Beetle (Diabrotica undecimpunctata).jpg",
    "squash-beetle.jpg": "Squash beetle (Epilachna borealis) (23270398320).jpg",
    "flea-beetle.jpg": "Phyllotreta.vittula.jpg",
    "aphids.jpg": "Aphids May 2010-3.jpg",
    "japanese-beetle.jpg": "Japanese Beetles, Ottawa.jpg",
    "stink-bug.jpg": "Marmorierte Baumwanze Halyomorpha halys 1.jpg",
    "whitefly.jpg": "CSIRO ScienceImage 7704 Silverleaf whitefly Bemisia tabaci biotype B.jpg",
    "spider-mites.jpg": "Tetranychus urticae with silk threads.jpg",
    "blossom-end-rot.jpg": "Calcium deficiency - Loss of form and Blossom end rot.jpg",
    "gloomy-scale.jpg": "Melanaspis tenebricosa (gloomy scale) on Acer rubrum.jpg",
    "fire-blight.jpg": "Apple tree with fire blight.jpg",
}

API = "https://en.wikipedia.org/w/api.php"
UA = "DurhamGardenPlan/1.0 (pest guide image downloader)"

def get_thumb_url(filename, width=500):
    """Use the MediaWiki API to get the correct thumbnail URL."""
    params = {
        "action": "query",
        "titles": f"File:{filename}",
        "prop": "imageinfo",
        "iiprop": "url",
        "iiurlwidth": str(width),
        "format": "json",
    }
    url = API + "?" + "&".join(f"{k}={urllib.parse.quote(str(v))}" for k, v in params.items())
    req = urllib.request.Request(url, headers={"User-Agent": UA})
    with urllib.request.urlopen(req, timeout=15) as resp:
        data = json.loads(resp.read())
    pages = data.get("query", {}).get("pages", {})
    for page_id, page_data in pages.items():
        if page_id == "-1":
            return None
        imageinfo = page_data.get("imageinfo", [{}])
        if imageinfo:
            return imageinfo[0].get("thumburl") or imageinfo[0].get("url")
    return None

def download(url, dest):
    req = urllib.request.Request(url, headers={"User-Agent": UA})
    with urllib.request.urlopen(req, timeout=30) as resp:
        data = resp.read()
    with open(dest, "wb") as f:
        f.write(data)
    return len(data)

ok = 0
fail = 0
for i, (local_name, commons_name) in enumerate(IMAGES.items(), 1):
    dest = os.path.join("images", local_name)
    sys.stdout.write(f"  {i:2d}/14 {local_name:40s} ")
    sys.stdout.flush()
    try:
        thumb_url = get_thumb_url(commons_name)
        if not thumb_url:
            print("SKIP (file not found on Commons)")
            fail += 1
            continue
        size = download(thumb_url, dest)
        print(f"OK ({size:,d} bytes)")
        ok += 1
    except Exception as e:
        print(f"FAIL ({e})")
        fail += 1

print(f"\nDone: {ok} succeeded, {fail} failed")
if fail == 0:
    print("Now run: git add images/ && git commit -m 'Add pest images' && git push")
PYEOF
