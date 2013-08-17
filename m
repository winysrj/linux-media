Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:32970 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab3HQQbW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Aug 2013 12:31:22 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Ming Lei <ming.lei@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: [PATCH v1 37/49] media: usb: cx231xx: prepare for enabling irq in complete()
Date: Sun, 18 Aug 2013 00:25:02 +0800
Message-Id: <1376756714-25479-38-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1376756714-25479-1-git-send-email-ming.lei@canonical.com>
References: <1376756714-25479-1-git-send-email-ming.lei@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Complete() will be run with interrupt enabled, so change to
spin_lock_irqsave().

Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/media/usb/cx231xx/cx231xx-audio.c |   10 ++++++----
 drivers/media/usb/cx231xx/cx231xx-core.c  |   10 ++++++----
 drivers/media/usb/cx231xx/cx231xx-vbi.c   |    5 +++--
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-audio.c b/drivers/media/usb/cx231xx/cx231xx-audio.c
index 81a1d97..f6fa0af 100644
--- a/drivers/media/usb/cx231xx/cx231xx-audio.c
+++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
@@ -136,6 +136,7 @@ static void cx231xx_audio_isocirq(struct urb *urb)
 		stride = runtime->frame_bits >> 3;
 
 		for (i = 0; i < urb->number_of_packets; i++) {
+			unsigned long flags;
 			int length = urb->iso_frame_desc[i].actual_length /
 				     stride;
 			cp = (unsigned char *)urb->transfer_buffer +
@@ -158,7 +159,7 @@ static void cx231xx_audio_isocirq(struct urb *urb)
 				       length * stride);
 			}
 
-			snd_pcm_stream_lock(substream);
+			snd_pcm_stream_lock_irqsave(substream, flags);
 
 			dev->adev.hwptr_done_capture += length;
 			if (dev->adev.hwptr_done_capture >=
@@ -173,7 +174,7 @@ static void cx231xx_audio_isocirq(struct urb *urb)
 						runtime->period_size;
 				period_elapsed = 1;
 			}
-			snd_pcm_stream_unlock(substream);
+			snd_pcm_stream_unlock_irqrestore(substream, flags);
 		}
 		if (period_elapsed)
 			snd_pcm_period_elapsed(substream);
@@ -224,6 +225,7 @@ static void cx231xx_audio_bulkirq(struct urb *urb)
 		stride = runtime->frame_bits >> 3;
 
 		if (1) {
+			unsigned long flags;
 			int length = urb->actual_length /
 				     stride;
 			cp = (unsigned char *)urb->transfer_buffer;
@@ -242,7 +244,7 @@ static void cx231xx_audio_bulkirq(struct urb *urb)
 				       length * stride);
 			}
 
-			snd_pcm_stream_lock(substream);
+			snd_pcm_stream_lock_irqsave(substream, flags);
 
 			dev->adev.hwptr_done_capture += length;
 			if (dev->adev.hwptr_done_capture >=
@@ -257,7 +259,7 @@ static void cx231xx_audio_bulkirq(struct urb *urb)
 						runtime->period_size;
 				period_elapsed = 1;
 			}
-			snd_pcm_stream_unlock(substream);
+			snd_pcm_stream_unlock_irqrestore(substream,flags);
 		}
 		if (period_elapsed)
 			snd_pcm_period_elapsed(substream);
diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 4ba3ce0..593b397 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -798,6 +798,7 @@ static void cx231xx_isoc_irq_callback(struct urb *urb)
 	    container_of(dma_q, struct cx231xx_video_mode, vidq);
 	struct cx231xx *dev = container_of(vmode, struct cx231xx, video_mode);
 	int i;
+	unsigned long flags;
 
 	switch (urb->status) {
 	case 0:		/* success */
@@ -813,9 +814,9 @@ static void cx231xx_isoc_irq_callback(struct urb *urb)
 	}
 
 	/* Copy data from URB */
-	spin_lock(&dev->video_mode.slock);
+	spin_lock_irqsave(&dev->video_mode.slock, flags);
 	dev->video_mode.isoc_ctl.isoc_copy(dev, urb);
-	spin_unlock(&dev->video_mode.slock);
+	spin_unlock_irqrestore(&dev->video_mode.slock, flags);
 
 	/* Reset urb buffers */
 	for (i = 0; i < urb->number_of_packets; i++) {
@@ -842,6 +843,7 @@ static void cx231xx_bulk_irq_callback(struct urb *urb)
 	struct cx231xx_video_mode *vmode =
 	    container_of(dma_q, struct cx231xx_video_mode, vidq);
 	struct cx231xx *dev = container_of(vmode, struct cx231xx, video_mode);
+	unsigned long flags;
 
 	switch (urb->status) {
 	case 0:		/* success */
@@ -857,9 +859,9 @@ static void cx231xx_bulk_irq_callback(struct urb *urb)
 	}
 
 	/* Copy data from URB */
-	spin_lock(&dev->video_mode.slock);
+	spin_lock_irqsave(&dev->video_mode.slock, flags);
 	dev->video_mode.bulk_ctl.bulk_copy(dev, urb);
-	spin_unlock(&dev->video_mode.slock);
+	spin_unlock_irqrestore(&dev->video_mode.slock, flags);
 
 	/* Reset urb buffers */
 	urb->status = usb_submit_urb(urb, GFP_ATOMIC);
diff --git a/drivers/media/usb/cx231xx/cx231xx-vbi.c b/drivers/media/usb/cx231xx/cx231xx-vbi.c
index c027942..38e78f8 100644
--- a/drivers/media/usb/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/usb/cx231xx/cx231xx-vbi.c
@@ -306,6 +306,7 @@ static void cx231xx_irq_vbi_callback(struct urb *urb)
 	struct cx231xx_video_mode *vmode =
 	    container_of(dma_q, struct cx231xx_video_mode, vidq);
 	struct cx231xx *dev = container_of(vmode, struct cx231xx, vbi_mode);
+	unsigned long flags;
 
 	switch (urb->status) {
 	case 0:		/* success */
@@ -322,9 +323,9 @@ static void cx231xx_irq_vbi_callback(struct urb *urb)
 	}
 
 	/* Copy data from URB */
-	spin_lock(&dev->vbi_mode.slock);
+	spin_lock_irqsave(&dev->vbi_mode.slock, flags);
 	dev->vbi_mode.bulk_ctl.bulk_copy(dev, urb);
-	spin_unlock(&dev->vbi_mode.slock);
+	spin_unlock_irqrestore(&dev->vbi_mode.slock, flags);
 
 	/* Reset status */
 	urb->status = 0;
-- 
1.7.9.5

