Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.seznam.cz ([77.75.72.43]:35807 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759829AbZDNSoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2009 14:44:16 -0400
From: =?utf-8?q?Old=C5=99ich_Jedli=C4=8Dka?= <oldium.pro@seznam.cz>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH] Use correct sampling rate for TV/FM radio
Date: Tue, 14 Apr 2009 20:44:08 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904142044.08714.oldium.pro@seznam.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is the fix for using the 32kHz sampling rate for TV and FM radio (ALSA).
The TV uses 32kHz anyway (mode 0; 32kHz demdec on), radio works only with
32kHz (mode 1; 32kHz baseband). The ALSA wrongly reported 32kHz and 48kHz for
everything (TV, radio, LINE1/2).

Now it should be possible to just use the card without the need to change the
capture rate from 48kHz to 32kHz. Enjoy :-)

Signed-off-by: Oldřich Jedlička <oldium.pro@seznam.cz>
---
diff -r dba0b6fae413 linux/drivers/media/video/saa7134/saa7134-alsa.c
--- a/linux/drivers/media/video/saa7134/saa7134-alsa.c	Thu Apr 09 08:21:42 
2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-alsa.c	Mon Apr 13 23:07:22 
2009 +0200
@@ -465,6 +465,29 @@
 	.periods_max =		1024,
 };
 
+static struct snd_pcm_hardware snd_card_saa7134_capture_32kHz_only =
+{
+	.info =                 (SNDRV_PCM_INFO_MMAP | SNDRV_PCM_INFO_INTERLEAVED |
+				 SNDRV_PCM_INFO_BLOCK_TRANSFER |
+				 SNDRV_PCM_INFO_MMAP_VALID),
+	.formats =		SNDRV_PCM_FMTBIT_S16_LE | \
+				SNDRV_PCM_FMTBIT_S16_BE | \
+				SNDRV_PCM_FMTBIT_S8 | \
+				SNDRV_PCM_FMTBIT_U8 | \
+				SNDRV_PCM_FMTBIT_U16_LE | \
+				SNDRV_PCM_FMTBIT_U16_BE,
+	.rates =		SNDRV_PCM_RATE_32000,
+	.rate_min =		32000,
+	.rate_max =		32000,
+	.channels_min =		1,
+	.channels_max =		2,
+	.buffer_bytes_max =	(256*1024),
+	.period_bytes_min =	64,
+	.period_bytes_max =	(256*1024),
+	.periods_min =		4,
+	.periods_max =		1024,
+};
+
 static void snd_card_saa7134_runtime_free(struct snd_pcm_runtime *runtime)
 {
 	snd_card_saa7134_pcm_t *pcm = runtime->private_data;
@@ -651,7 +674,13 @@
 	pcm->substream = substream;
 	runtime->private_data = pcm;
 	runtime->private_free = snd_card_saa7134_runtime_free;
-	runtime->hw = snd_card_saa7134_capture;
+
+	if (amux == TV || &card(dev).radio == dev->input) {
+		/* TV uses 32kHz sampling, AM/FM radio is locked to 32kHz */
+		runtime->hw = snd_card_saa7134_capture_32kHz_only;
+	} else {
+		runtime->hw = snd_card_saa7134_capture;
+	}
 
 	if (dev->ctl_mute != 0) {
 		saa7134->mute_was_on = 1;
