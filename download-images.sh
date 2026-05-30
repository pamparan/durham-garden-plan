#!/bin/bash
# Downloads all pest identification images from Wikimedia Commons (freely licensed)
# Run once: bash download-images.sh

set -e
mkdir -p images
cd images

echo "Downloading pest images from Wikimedia Commons..."

curl -sL -A "Mozilla/5.0" -o svb.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Melittia_cucurbitae_P1440822a.jpg/480px-Melittia_cucurbitae_P1440822a.jpg"
echo "  1/14 Squash vine borer"

curl -sL -A "Mozilla/5.0" -o hornworm.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/Tobacco_hornworm.jpg/480px-Tobacco_hornworm.jpg"
echo "  2/14 Tomato hornworm"

curl -sL -A "Mozilla/5.0" -o cucumber-beetle-striped.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Striped_cucumber_beetle.jpg/480px-Striped_cucumber_beetle.jpg"
echo "  3/14 Striped cucumber beetle"

curl -sL -A "Mozilla/5.0" -o cucumber-beetle-spotted.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Spotted_Cucumber_Beetle_%28Diabrotica_undecimpunctata%29.jpg/480px-Spotted_Cucumber_Beetle_%28Diabrotica_undecimpunctata%29.jpg"
echo "  4/14 Spotted cucumber beetle"

curl -sL -A "Mozilla/5.0" -o squash-beetle.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Squash_beetle_%28Epilachna_borealis%29_%2823270398320%29.jpg/480px-Squash_beetle_%28Epilachna_borealis%29_%2823270398320%29.jpg"
echo "  5/14 Squash lady beetle"

curl -sL -A "Mozilla/5.0" -o flea-beetle.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/6/61/Flea_beetle.jpg/480px-Flea_beetle.jpg"
echo "  6/14 Flea beetle"

curl -sL -A "Mozilla/5.0" -o aphids.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Aphids_on_broccoli.jpg/480px-Aphids_on_broccoli.jpg"
echo "  7/14 Aphids"

curl -sL -A "Mozilla/5.0" -o japanese-beetle.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/d/de/Popillia_japonica.jpg/480px-Popillia_japonica.jpg"
echo "  8/14 Japanese beetle"

curl -sL -A "Mozilla/5.0" -o stink-bug.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/Halyomorpha_halys_lab.jpg/480px-Halyomorpha_halys_lab.jpg"
echo "  9/14 Stink bug"

curl -sL -A "Mozilla/5.0" -o whitefly.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Trialeurodes_vaporariorum.jpg/480px-Trialeurodes_vaporariorum.jpg"
echo " 10/14 Whitefly"

curl -sL -A "Mozilla/5.0" -o spider-mites.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/55/Tetranychus_urticae_with_silk_threads.jpg/480px-Tetranychus_urticae_with_silk_threads.jpg"
echo " 11/14 Spider mites"

curl -sL -A "Mozilla/5.0" -o blossom-end-rot.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/1/13/Blossom_end_rot.jpg/480px-Blossom_end_rot.jpg"
echo " 12/14 Blossom end rot"

curl -sL -A "Mozilla/5.0" -o gloomy-scale.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Melanaspis_tenebricosa_%28gloomy_scale%29_on_Acer_rubrum.jpg/480px-Melanaspis_tenebricosa_%28gloomy_scale%29_on_Acer_rubrum.jpg"
echo " 13/14 Gloomy scale"

curl -sL -A "Mozilla/5.0" -o fire-blight.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Fire_blight_%28Erwinia_amylovora%29.jpg/480px-Fire_blight_%28Erwinia_amylovora%29.jpg"
echo " 14/14 Fire blight"

echo ""
echo "Done! All images saved to images/"
echo "Now run: cd .. && git add images/ && git commit -m 'Add pest images' && git push"
