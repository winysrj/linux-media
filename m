Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:28098 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaAILkP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jan 2014 06:40:15 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ400IS2TR20O10@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Jan 2014 06:40:14 -0500 (EST)
Received: from localhost.localdomain ([105.144.34.9])
 by ussync3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MZ400GIXTQZ4X30@ussync3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Jan 2014 06:40:14 -0500 (EST)
Date: Thu, 09 Jan 2014 09:40:10 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: LMML <linux-media@vger.kernel.org>
Subject: [RFC PATCHv1] Fix audio with USB 3.0
Message-id: <20140109094010.0d8559b5@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The PCM audio hardware is not properly described. This causes the driver
to use a period shorter than it should be, causing problems with USB 3.0.

This is a first attempt to fix it.

PS.: 

1) This patch is not to be applied. It contains an ugly debug added for
testing purposes, and uses a C99 comment;

2) em28xx can accept other sample rates. It would be good to add support
for those other rates, as some audio playback hardware may not support
48KHz (I have one such hardware here). 

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 30ee389a07f0..1de4fac3db97 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -87,6 +87,14 @@ static void em28xx_audio_isocirq(struct urb *urb)
 	struct snd_pcm_substream *substream;
 	struct snd_pcm_runtime   *runtime;
 
+size_t size = 0;
+
+if (!urb->status)
+for (i = 0; i < urb->number_of_packets; i++)
+	size =+ urb->iso_frame_desc[i].actual_length;
+
+printk("%s, status %d, %d packets (size %d)\n", __func__, urb->status, urb->number_of_packets, size);
+
 	switch (urb->status) {
 	case 0:             /* success */
 	case -ETIMEDOUT:    /* NAK */
@@ -215,14 +223,15 @@ static struct snd_pcm_hardware snd_em28xx_hw_capture = {
 
 	.formats = SNDRV_PCM_FMTBIT_S16_LE,
 
-	.rates = SNDRV_PCM_RATE_CONTINUOUS | SNDRV_PCM_RATE_KNOT,
+//	.rates = SNDRV_PCM_RATE_CONTINUOUS | SNDRV_PCM_RATE_KNOT,
+	.rates = SNDRV_PCM_RATE_48000,
 
 	.rate_min = 48000,
 	.rate_max = 48000,
 	.channels_min = 2,
 	.channels_max = 2,
 	.buffer_bytes_max = 62720 * 8,	/* just about the value in usbaudio.c */
-	.period_bytes_min = 64,		/* 12544/2, */
+	.period_bytes_min = 188,
 	.period_bytes_max = 12544,
 	.periods_min = 2,
 	.periods_max = 98,		/* 12544, */
