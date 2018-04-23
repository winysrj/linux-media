Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor2.renesas.com ([210.160.252.172]:52480 "EHLO
        relmlie1.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753791AbeDWCKa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Apr 2018 22:10:30 -0400
Message-ID: <87in8ibrql.wl%kuninori.morimoto.gx@renesas.com>
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
To: Mark Brown <broonie@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Linux-ALSA <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: [PATCH v3][RESEND] media: i2c: tda1997: replace codec to component
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
Date: Mon, 23 Apr 2018 02:10:26 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

Now we can replace Codec to Component. Let's do it.

Note:
	xxx_codec_xxx()		->	xxx_component_xxx()
	.idle_bias_off = 0	->	.idle_bias_on = 1
	.ignore_pmdown_time = 0	->	.use_pmdown_time = 1
	-			->	.endianness = 1
	-			->	.non_legacy_dai_naming = 1

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
---
Tim, Mauro

2 weeks passed. I re-send.
This replace patch is needed for ALSA SoC, otherwise it can't probe anymore.

v2 -> v3

 - fixup driver name (= tda1997)

 drivers/media/i2c/tda1997x.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/tda1997x.c b/drivers/media/i2c/tda1997x.c
index 3021913..33d7fcf 100644
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
@@ -2479,20 +2479,22 @@ static int tda1997x_pcm_startup(struct snd_pcm_substream *substream,
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
1.9.1

_______________________________________________
Alsa-devel mailing list
Alsa-devel@alsa-project.org
http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
