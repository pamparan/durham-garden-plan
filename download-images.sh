#!/bin/bash
# Downloads all pest identification images from Wikimedia Commons (freely licensed)
# Uses Special:FilePath which redirects to the correct thumbnail URL automatically
# Run once: bash download-images.sh

set -e
mkdir -p images
cd images

UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)"
BASE="https://commons.wikimedia.org/wiki/Special:FilePath"

echo "Downloading pest images from Wikimedia Commons..."

curl -sL -A "$UA" -o svb.jpg \
  "$BASE/Melittia_cucurbitae_P1440822a.jpg?width=500"
echo "  1/14 Squash vine borer"

curl -sL -A "$UA" -o hornworm.jpg \
  "$BASE/Tobacco_Hornworm_1.jpg?width=500"
echo "  2/14 Tomato hornworm"

curl -sL -A "$UA" -o cucumber-beetle-striped.jpg \
  "$BASE/Acalymma_vittatum_1323034.jpg?width=500"
echo "  3/14 Striped cucumber beetle"

curl -sL -A "$UA" -o cucumber-beetle-spotted.jpg \
  "$BASE/Spotted_Cucumber_Beetle_%28Diabrotica_undecimpunctata%29.jpg?width=500"
echo "  4/14 Spotted cucumber beetle"

curl -sL -A "$UA" -o squash-beetle.jpg \
  "$BASE/Squash_beetle_%28Epilachna_borealis%29_%2823270398320%29.jpg?width=500"
echo "  5/14 Squash lady beetle"

curl -sL -A "$UA" -o flea-beetle.jpg \
  "$BASE/Phyllotreta.vittula.jpg?width=500"
echo "  6/14 Flea beetle"

curl -sL -A "$UA" -o aphids.jpg \
  "$BASE/Aphids_May_2010-3.jpg?width=500"
echo "  7/14 Aphids"

curl -sL -A "$UA" -o japanese-beetle.jpg \
  "$BASE/Japanese_Beetles%2C_Ottawa.jpg?width=500"
echo "  8/14 Japanese beetle"

curl -sL -A "$UA" -o stink-bug.jpg \
  "$BASE/Marmorierte_Baumwanze_Halyomorpha_halys_1.jpg?width=500"
echo "  9/14 Stink bug"

curl -sL -A "$UA" -o whitefly.jpg \
  "$BASE/Greenhouse_Whitefly_%28Trialeurodes_vaporariorum%29_-_Kitchener%2C_Ontario_2013-09-22.jpg?width=500"
echo " 10/14 Whitefly"

curl -sL -A "$UA" -o spider-mites.jpg \
  "$BASE/Tetranychus_urticae_with_silk_threads.jpg?width=500"
echo " 11/14 Spider mites"

curl -sL -A "$UA" -o blossom-end-rot.jpg \
  "$BASE/Blossom_end_rot_-_Calcium_deficiency.jpg?width=500"
echo " 12/14 Blossom end rot"

curl -sL -A "$UA" -o gloomy-scale.jpg \
  "$BASE/Melanaspis_tenebricosa_%28gloomy_scale%29_on_Acer_rubrum.jpg?width=500"
echo " 13/14 Gloomy scale"

curl -sL -A "$UA" -o fire-blight.jpg \
  "$BASE/Fire_blight_%28Erwinia_amylovora%29.jpg?width=500"
echo " 14/14 Fire blight"

echo ""
echo "Verifying downloads..."
FAIL=0
for f in svb.jpg hornworm.jpg cucumber-beetle-striped.jpg cucumber-beetle-spotted.jpg \
         squash-beetle.jpg flea-beetle.jpg aphids.jpg japanese-beetle.jpg \
         stink-bug.jpg whitefly.jpg spider-mites.jpg blossom-end-rot.jpg \
         gloomy-scale.jpg fire-blight.jpg; do
  TYPE=$(file -b "$f" | head -1)
  if echo "$TYPE" | grep -qi "image\|jpeg\|png"; then
    echo "  OK: $f ($TYPE)"
  else
    echo "  FAIL: $f ($TYPE)"
    FAIL=1
  fi
done

if [ "$FAIL" -eq 0 ]; then
  echo ""
  echo "All 14 images downloaded successfully!"
  echo "Now run: cd .. && git add images/ && git commit -m 'Add pest images' && git push"
else
  echo ""
  echo "Some images failed. Check the FAIL lines above."
fi
