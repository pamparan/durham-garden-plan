#!/bin/bash
# Downloads all pest identification images from Wikimedia Commons
# Run: bash download-images.sh
# Safe to re-run -- skips images that already downloaded successfully

set -e
mkdir -p images

python3 << 'PYEOF'
import urllib.request
import urllib.error
import json
import os
import sys
import time

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
    "blossom-end-rot.jpg": "Blossom end rot.JPG",
    "gloomy-scale.jpg": "Melanaspis tenebricosa - inat 167116957.jpg",
    "fire-blight.jpg": "Apple tree with fire blight.jpg",
    "aphids-closeup.jpg": "Green Aphid (31290392556).jpg",
    "aphids-with-ants.jpg": "Aphids Macrosiphum rosae and ants on a red rose bud, by baby-bear.org.jpg",
    "spider-mites-closeup.jpg": "Red spider mite (Tetranychus urticae).jpg",
    "spider-mites-damage.jpg": "Spidermites-gardenia.jpg",
}

API = "https://commons.wikimedia.org/w/api.php"
UA = "DurhamGardenPlan/1.0 (garden pest guide; contact: github.com/pamparan)"

def is_valid_image(path):
    if not os.path.exists(path) or os.path.getsize(path) < 5000:
        return False
    with open(path, "rb") as f:
        header = f.read(3)
    return header[:2] == b'\xff\xd8' or header[:3] == b'\x89PN'

def get_thumb_url(filename, width=500):
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
skip = 0
fail = 0
for i, (local_name, commons_name) in enumerate(IMAGES.items(), 1):
    dest = os.path.join("images", local_name)
    sys.stdout.write(f"  {i:2d}/14 {local_name:40s} ")
    sys.stdout.flush()

    if is_valid_image(dest):
        sz = os.path.getsize(dest)
        print(f"EXISTS ({sz:,d} bytes)")
        ok += 1
        continue

    time.sleep(2)

    for attempt in range(3):
        try:
            thumb_url = get_thumb_url(commons_name)
            if not thumb_url:
                print("NOT FOUND on Commons")
                fail += 1
                break
            size = download(thumb_url, dest)
            print(f"OK ({size:,d} bytes)")
            ok += 1
            break
        except urllib.error.HTTPError as e:
            if e.code == 429 and attempt < 2:
                wait = 5 * (attempt + 1)
                sys.stdout.write(f"(rate limited, waiting {wait}s) ")
                sys.stdout.flush()
                time.sleep(wait)
            else:
                print(f"FAIL (HTTP {e.code})")
                fail += 1
                break
        except Exception as e:
            print(f"FAIL ({e})")
            fail += 1
            break

print(f"\nDone: {ok} succeeded, {fail} failed")
if fail == 0:
    print("All images ready! Run: git add images/ && git commit -m 'Add pest images' && git push")
else:
    print("Some failed. Run the script again to retry -- it skips images that already downloaded.")
PYEOF
