Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50890 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaAMKK4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 05:10:56 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] em28xx: adjust period size at runtime
Date: Mon, 13 Jan 2014 05:07:15 -0200
Message-Id: <1389596835-6427-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While the current hardcoded period is ok for the current values,
we may latter change the driver to work with different bit rates
or with different latencies than 64ms.

So, adust the period size at runtime.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 8 ++++++++
 drivers/media/usb/em28xx/em28xx.h       | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 0ec4742c3ab0..1fe85f45924e 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -293,7 +293,12 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 		mutex_unlock(&dev->lock);
 	}
 
+	/* Dynamically adjust the period size */
 	snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
+	snd_pcm_hw_constraint_minmax(runtime, SNDRV_PCM_HW_PARAM_PERIOD_BYTES,
+				     dev->adev.period * 95 / 100,
+				     dev->adev.period * 105 / 100);
+
 	dev->adev.capture_pcm_substream = substream;
 
 	return 0;
@@ -807,6 +812,9 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 	em28xx_info("Number of URBs: %d, with %d packets and %d size",
 		    num_urb, npackets, urb_size);
 
+	/* Estimate the bytes per period */
+	dev->adev.period = urb_size * npackets;
+
 	/* Allocate space to store the number of URBs to be used */
 
 	dev->adev.transfer_buffer = kcalloc(num_urb,
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index d38c08e4da60..8b3438891bb3 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -506,6 +506,8 @@ struct em28xx_audio {
 	unsigned int hwptr_done_capture;
 	struct snd_card            *sndcard;
 
+	size_t period;
+
 	int users;
 	spinlock_t slock;
 };
-- 
1.8.3.1

