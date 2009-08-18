Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.seznam.cz ([77.75.72.43]:35683 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbZHRTY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2009 15:24:57 -0400
From: =?utf-8?q?Old=C5=99ich_Jedli=C4=8Dka?= <oldium.pro@seznam.cz>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH] Report only 32kHz for ALSA
Date: Tue, 18 Aug 2009 21:24:54 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	hermann pitton <hermann-pitton@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200908182124.54739.oldium.pro@seznam.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several reasons:

 - SAA7133/35 uses DDEP (DemDec Easy Programming mode), which works in 32kHz
   only
 - SAA7134 for TV mode uses DemDec mode (32kHz)
 - Radio works in 32kHz only
 - When recording 48kHz from Line1/Line2, switching of capture source to TV
   means switching to 32kHz without any frequency translation

Signed-off-by: Oldřich Jedlička <oldium.pro@seznam.cz>

diff --git a/linux/drivers/media/video/saa7134/saa7134-alsa.c b/linux/drivers/media/video/saa7134/saa7134-alsa.c
index c09ec3e..504186a 100644
--- a/linux/drivers/media/video/saa7134/saa7134-alsa.c
+++ b/linux/drivers/media/video/saa7134/saa7134-alsa.c
@@ -440,6 +440,16 @@ snd_card_saa7134_capture_pointer(struct snd_pcm_substream * substream)
 
 /*
  * ALSA hardware capabilities definition
+ *
+ *  Report only 32kHz for ALSA:
+ *
+ *  - SAA7133/35 uses DDEP (DemDec Easy Programming mode), which works in 32kHz
+ *    only
+ *  - SAA7134 for TV mode uses DemDec mode (32kHz)
+ *  - Radio works in 32kHz only
+ *  - When recording 48kHz from Line1/Line2, switching of capture source to TV
+ *    means
+ *    switching to 32kHz without any frequency translation
  */
 
 static struct snd_pcm_hardware snd_card_saa7134_capture =
@@ -453,9 +463,9 @@ static struct snd_pcm_hardware snd_card_saa7134_capture =
 				SNDRV_PCM_FMTBIT_U8 | \
 				SNDRV_PCM_FMTBIT_U16_LE | \
 				SNDRV_PCM_FMTBIT_U16_BE,
-	.rates =		SNDRV_PCM_RATE_32000 | SNDRV_PCM_RATE_48000,
+	.rates =		SNDRV_PCM_RATE_32000,
 	.rate_min =		32000,
-	.rate_max =		48000,
+	.rate_max =		32000,
 	.channels_min =		1,
 	.channels_max =		2,
 	.buffer_bytes_max =	(256*1024),
