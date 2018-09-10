Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:38755 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbeIJONN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 10:13:13 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/3] media: em28xx-audio: use irqsave() in USB's complete callback
Date: Mon, 10 Sep 2018 11:19:58 +0200
Message-Id: <20180910092000.14693-2-bigeasy@linutronix.de>
In-Reply-To: <20180910092000.14693-1-bigeasy@linutronix.de>
References: <20180910092000.14693-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The USB completion callback does not disable interrupts while acquiring
the lock. We want to remove the local_irq_disable() invocation from
__usb_hcd_giveback_urb() and therefore it is required for the callback
handler to disable the interrupts while acquiring the lock.
The callback may be invoked either in IRQ or BH context depending on the
USB host controller.
Use the _irqsave() variant of the locking primitives.

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 5 +++--
 drivers/media/usb/em28xx/em28xx-core.c  | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 8e799ae1df692..67481fc824458 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -116,6 +116,7 @@ static void em28xx_audio_isocirq(struct urb *urb)
 		stride = runtime->frame_bits >> 3;
 
 		for (i = 0; i < urb->number_of_packets; i++) {
+			unsigned long flags;
 			int length =
 			    urb->iso_frame_desc[i].actual_length / stride;
 			cp = (unsigned char *)urb->transfer_buffer +
@@ -137,7 +138,7 @@ static void em28xx_audio_isocirq(struct urb *urb)
 				       length * stride);
 			}
 
-			snd_pcm_stream_lock(substream);
+			snd_pcm_stream_lock_irqsave(substream, flags);
 
 			dev->adev.hwptr_done_capture += length;
 			if (dev->adev.hwptr_done_capture >=
@@ -153,7 +154,7 @@ static void em28xx_audio_isocirq(struct urb *urb)
 				period_elapsed = 1;
 			}
 
-			snd_pcm_stream_unlock(substream);
+			snd_pcm_stream_unlock_irqrestore(substream, flags);
 		}
 		if (period_elapsed)
 			snd_pcm_period_elapsed(substream);
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 5657f8710ca6b..2b8c84a5c9a8e 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -777,6 +777,7 @@ EXPORT_SYMBOL_GPL(em28xx_set_mode);
 static void em28xx_irq_callback(struct urb *urb)
 {
 	struct em28xx *dev = urb->context;
+	unsigned long flags;
 	int i;
 
 	switch (urb->status) {
@@ -793,9 +794,9 @@ static void em28xx_irq_callback(struct urb *urb)
 	}
 
 	/* Copy data from URB */
-	spin_lock(&dev->slock);
+	spin_lock_irqsave(&dev->slock, flags);
 	dev->usb_ctl.urb_data_copy(dev, urb);
-	spin_unlock(&dev->slock);
+	spin_unlock_irqrestore(&dev->slock, flags);
 
 	/* Reset urb buffers */
 	for (i = 0; i < urb->number_of_packets; i++) {
-- 
2.19.0.rc2
