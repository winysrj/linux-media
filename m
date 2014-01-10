Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44309 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaAKMvQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jan 2014 07:51:16 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/4] em28x-audio: fix the period size in bytes
Date: Fri, 10 Jan 2014 16:45:39 -0200
Message-Id: <1389379539-31550-5-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389379539-31550-1-git-send-email-m.chehab@samsung.com>
References: <1389379539-31550-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the period size is wrong, userspace will assume a wrong delay
any may negociate an inadequate value.

The em28xx devices use 8 for URB interval, in microframes,
and the driver programs it to have 64 packets.

That means that the IRQ sampling period is 125 * 8 * 64,
with is equal to 64 ms.

So, that's the minimal latency with the current settings. It is
possible to program a lower latency, by using less than 64 packets,
but that increases the amount of bandwitdh used, and the number of
IRQ events per second.

In any case, in order to support it, the driver logic should be
changed to fill those parameters in realtime.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 6c7d34600294..f6fcee3d4fb9 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -52,6 +52,7 @@ MODULE_PARM_DESC(debug, "activates debug info");
 
 #define EM28XX_MAX_AUDIO_BUFS		5
 #define EM28XX_MIN_AUDIO_PACKETS	64
+
 #define dprintk(fmt, arg...) do {					\
 	    if (debug)							\
 		printk(KERN_INFO "em28xx-audio %s: " fmt,		\
@@ -217,15 +218,26 @@ static struct snd_pcm_hardware snd_em28xx_hw_capture = {
 
 	.formats = SNDRV_PCM_FMTBIT_S16_LE,
 
-	.rates = SNDRV_PCM_RATE_CONTINUOUS | SNDRV_PCM_RATE_KNOT,
+	.rates = SNDRV_PCM_RATE_48000,
 
 	.rate_min = 48000,
 	.rate_max = 48000,
 	.channels_min = 2,
 	.channels_max = 2,
 	.buffer_bytes_max = 62720 * 8,	/* just about the value in usbaudio.c */
-	.period_bytes_min = 64,		/* 12544/2, */
-	.period_bytes_max = 12544,
+
+
+	/*
+	 * The period is 12.288 bytes. Allow a 10% of variation along its
+	 * value, in order to avoid overruns/underruns due to some clock
+	 * drift.
+	 *
+	 * FIXME: This period assumes 64 packets, and a 48000 PCM rate.
+	 * Calculate it dynamically.
+	 */
+	.period_bytes_min = 11059,
+	.period_bytes_max = 13516,
+
 	.periods_min = 2,
 	.periods_max = 98,		/* 12544, */
 };
-- 
1.8.3.1

