Return-path: <linux-media-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:47912 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751736AbeEEBvA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 21:51:00 -0400
From: Mark Brown <broonie@kernel.org>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Tim Harvey <tharvey@gateworks.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux-ALSA <alsa-devel@alsa-project.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Applied "media: i2c: tda1997: replace codec to component" to the asoc tree
In-Reply-To: <87in94lwmq.wl%kuninori.morimoto.gx@renesas.com>
Message-Id: <20180505015049.5225644007A@finisterre.ee.mobilebroadband>
Date: Sat,  5 May 2018 02:50:49 +0100 (BST)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch

   media: i2c: tda1997: replace codec to component

has been applied to the asoc tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git 

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

>From 2d8102cc9a27577ffa4335aaaed4a26060688de2 Mon Sep 17 00:00:00 2001
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Date: Mon, 23 Apr 2018 02:10:26 +0000
Subject: [PATCH] media: i2c: tda1997: replace codec to component

Now we can replace Codec to Component. Let's do it.

Note:
	xxx_codec_xxx()		->	xxx_component_xxx()
	.idle_bias_off = 0	->	.idle_bias_on = 1
	.ignore_pmdown_time = 0	->	.use_pmdown_time = 1
	-			->	.endianness = 1
	-			->	.non_legacy_dai_naming = 1

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Tested-by: Tim Harvey <tharvey@gateworks.com>
Acked-by: Tim Harvey <tharvey@gateworks.com>
Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/media/i2c/tda1997x.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/tda1997x.c b/drivers/media/i2c/tda1997x.c
index 3021913c28fa..33d7fcf541fc 100644
--- a/drivers/media/i2c/tda1997x.c
+++ b/drivers/media/i2c/tda1997x.c
@@ -2444,7 +2444,7 @@ static int tda1997x_pcm_startup(struct snd_pcm_substream *substream,
 				struct snd_soc_dai *dai)
 {
 	struct tda1997x_state *state = snd_soc_dai_get_drvdata(dai);
-	struct snd_soc_codec *codec = dai->codec;
+	struct snd_soc_component *component = dai->component;
 	struct snd_pcm_runtime *rtd = substream->runtime;
 	int rate, err;
 
@@ -2452,11 +2452,11 @@ static int tda1997x_pcm_startup(struct snd_pcm_substream *substream,
 	err = snd_pcm_hw_constraint_minmax(rtd, SNDRV_PCM_HW_PARAM_RATE,
 					   rate, rate);
 	if (err < 0) {
-		dev_err(codec->dev, "failed to constrain samplerate to %dHz\n",
+		dev_err(component->dev, "failed to constrain samplerate to %dHz\n",
 			rate);
 		return err;
 	}
-	dev_info(codec->dev, "set samplerate constraint to %dHz\n", rate);
+	dev_info(component->dev, "set samplerate constraint to %dHz\n", rate);
 
 	return 0;
 }
@@ -2479,20 +2479,22 @@ static struct snd_soc_dai_driver tda1997x_audio_dai = {
 	.ops = &tda1997x_dai_ops,
 };
 
-static int tda1997x_codec_probe(struct snd_soc_codec *codec)
+static int tda1997x_codec_probe(struct snd_soc_component *component)
 {
 	return 0;
 }
 
-static int tda1997x_codec_remove(struct snd_soc_codec *codec)
+static void tda1997x_codec_remove(struct snd_soc_component *component)
 {
-	return 0;
 }
 
-static struct snd_soc_codec_driver tda1997x_codec_driver = {
-	.probe = tda1997x_codec_probe,
-	.remove = tda1997x_codec_remove,
-	.reg_word_size = sizeof(u16),
+static struct snd_soc_component_driver tda1997x_codec_driver = {
+	.probe			= tda1997x_codec_probe,
+	.remove			= tda1997x_codec_remove,
+	.idle_bias_on		= 1,
+	.use_pmdown_time	= 1,
+	.endianness		= 1,
+	.non_legacy_dai_naming	= 1,
 };
 
 static int tda1997x_probe(struct i2c_client *client,
@@ -2737,7 +2739,7 @@ static int tda1997x_probe(struct i2c_client *client,
 		else
 			formats = SNDRV_PCM_FMTBIT_S16_LE;
 		tda1997x_audio_dai.capture.formats = formats;
-		ret = snd_soc_register_codec(&state->client->dev,
+		ret = devm_snd_soc_register_component(&state->client->dev,
 					     &tda1997x_codec_driver,
 					     &tda1997x_audio_dai, 1);
 		if (ret) {
@@ -2782,7 +2784,6 @@ static int tda1997x_remove(struct i2c_client *client)
 	struct tda1997x_platform_data *pdata = &state->pdata;
 
 	if (pdata->audout_format) {
-		snd_soc_unregister_codec(&client->dev);
 		mutex_destroy(&state->audio_lock);
 	}
 
-- 
2.17.0
