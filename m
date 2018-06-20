Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59891 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754059AbeFTLB1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:27 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 04/27] media: cx231xx: use irqsave() in USB's complete callback
Date: Wed, 20 Jun 2018 13:00:42 +0200
Message-Id: <20180620110105.19955-5-bigeasy@linutronix.de>
In-Reply-To: <20180620110105.19955-1-bigeasy@linutronix.de>
References: <20180620110105.19955-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
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
 drivers/media/usb/cx231xx/cx231xx-audio.c | 10 ++++++----
 drivers/media/usb/cx231xx/cx231xx-core.c  | 10 ++++++----
 drivers/media/usb/cx231xx/cx231xx-vbi.c   |  5 +++--
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-audio.c b/drivers/media/usb/=
cx231xx/cx231xx-audio.c
index 5d7a0c085902..79a368d5f9dd 100644
--- a/drivers/media/usb/cx231xx/cx231xx-audio.c
+++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
@@ -126,6 +126,7 @@ static void cx231xx_audio_isocirq(struct urb *urb)
 		stride =3D runtime->frame_bits >> 3;
=20
 		for (i =3D 0; i < urb->number_of_packets; i++) {
+			unsigned long flags;
 			int length =3D urb->iso_frame_desc[i].actual_length /
 				     stride;
 			cp =3D (unsigned char *)urb->transfer_buffer +
@@ -148,7 +149,7 @@ static void cx231xx_audio_isocirq(struct urb *urb)
 				       length * stride);
 			}
=20
-			snd_pcm_stream_lock(substream);
+			snd_pcm_stream_lock_irqsave(substream, flags);
=20
 			dev->adev.hwptr_done_capture +=3D length;
 			if (dev->adev.hwptr_done_capture >=3D
@@ -163,7 +164,7 @@ static void cx231xx_audio_isocirq(struct urb *urb)
 						runtime->period_size;
 				period_elapsed =3D 1;
 			}
-			snd_pcm_stream_unlock(substream);
+			snd_pcm_stream_unlock_irqrestore(substream, flags);
 		}
 		if (period_elapsed)
 			snd_pcm_period_elapsed(substream);
@@ -216,6 +217,7 @@ static void cx231xx_audio_bulkirq(struct urb *urb)
 		stride =3D runtime->frame_bits >> 3;
=20
 		if (1) {
+			unsigned long flags;
 			int length =3D urb->actual_length /
 				     stride;
 			cp =3D (unsigned char *)urb->transfer_buffer;
@@ -234,7 +236,7 @@ static void cx231xx_audio_bulkirq(struct urb *urb)
 				       length * stride);
 			}
=20
-			snd_pcm_stream_lock(substream);
+			snd_pcm_stream_lock_irqsave(substream, flags);
=20
 			dev->adev.hwptr_done_capture +=3D length;
 			if (dev->adev.hwptr_done_capture >=3D
@@ -249,7 +251,7 @@ static void cx231xx_audio_bulkirq(struct urb *urb)
 						runtime->period_size;
 				period_elapsed =3D 1;
 			}
-			snd_pcm_stream_unlock(substream);
+			snd_pcm_stream_unlock_irqrestore(substream, flags);
 		}
 		if (period_elapsed)
 			snd_pcm_period_elapsed(substream);
diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/c=
x231xx/cx231xx-core.c
index 53d846dea3d2..493c2dca6244 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -799,6 +799,7 @@ static void cx231xx_isoc_irq_callback(struct urb *urb)
 	struct cx231xx_video_mode *vmode =3D
 	    container_of(dma_q, struct cx231xx_video_mode, vidq);
 	struct cx231xx *dev =3D container_of(vmode, struct cx231xx, video_mode);
+	unsigned long flags;
 	int i;
=20
 	switch (urb->status) {
@@ -815,9 +816,9 @@ static void cx231xx_isoc_irq_callback(struct urb *urb)
 	}
=20
 	/* Copy data from URB */
-	spin_lock(&dev->video_mode.slock);
+	spin_lock_irqsave(&dev->video_mode.slock, flags);
 	dev->video_mode.isoc_ctl.isoc_copy(dev, urb);
-	spin_unlock(&dev->video_mode.slock);
+	spin_unlock_irqrestore(&dev->video_mode.slock, flags);
=20
 	/* Reset urb buffers */
 	for (i =3D 0; i < urb->number_of_packets; i++) {
@@ -844,6 +845,7 @@ static void cx231xx_bulk_irq_callback(struct urb *urb)
 	struct cx231xx_video_mode *vmode =3D
 	    container_of(dma_q, struct cx231xx_video_mode, vidq);
 	struct cx231xx *dev =3D container_of(vmode, struct cx231xx, video_mode);
+	unsigned long flags;
=20
 	switch (urb->status) {
 	case 0:		/* success */
@@ -862,9 +864,9 @@ static void cx231xx_bulk_irq_callback(struct urb *urb)
 	}
=20
 	/* Copy data from URB */
-	spin_lock(&dev->video_mode.slock);
+	spin_lock_irqsave(&dev->video_mode.slock, flags);
 	dev->video_mode.bulk_ctl.bulk_copy(dev, urb);
-	spin_unlock(&dev->video_mode.slock);
+	spin_unlock_irqrestore(&dev->video_mode.slock, flags);
=20
 	/* Reset urb buffers */
 	urb->status =3D usb_submit_urb(urb, GFP_ATOMIC);
diff --git a/drivers/media/usb/cx231xx/cx231xx-vbi.c b/drivers/media/usb/cx=
231xx/cx231xx-vbi.c
index b621cf1aa96b..920417baf893 100644
--- a/drivers/media/usb/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/usb/cx231xx/cx231xx-vbi.c
@@ -305,6 +305,7 @@ static void cx231xx_irq_vbi_callback(struct urb *urb)
 	struct cx231xx_video_mode *vmode =3D
 	    container_of(dma_q, struct cx231xx_video_mode, vidq);
 	struct cx231xx *dev =3D container_of(vmode, struct cx231xx, vbi_mode);
+	unsigned long flags;
=20
 	switch (urb->status) {
 	case 0:		/* success */
@@ -321,9 +322,9 @@ static void cx231xx_irq_vbi_callback(struct urb *urb)
 	}
=20
 	/* Copy data from URB */
-	spin_lock(&dev->vbi_mode.slock);
+	spin_lock_irqsave(&dev->vbi_mode.slock, flags);
 	dev->vbi_mode.bulk_ctl.bulk_copy(dev, urb);
-	spin_unlock(&dev->vbi_mode.slock);
+	spin_unlock_irqrestore(&dev->vbi_mode.slock, flags);
=20
 	/* Reset status */
 	urb->status =3D 0;
--=20
2.17.1
