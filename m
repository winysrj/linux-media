Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:35876 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752449AbeGAPjg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 1 Jul 2018 11:39:36 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: tglx@linutronix.de, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH REPOST 3/5] media: go7007: use irqsave() in USB's complete callback
Date: Sun,  1 Jul 2018 17:39:19 +0200
Message-Id: <20180701153921.13129-4-bigeasy@linutronix.de>
In-Reply-To: <20180701153921.13129-1-bigeasy@linutronix.de>
References: <20180701153921.13129-1-bigeasy@linutronix.de>
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

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/media/usb/go7007/go7007-driver.c |  9 +++++----
 drivers/media/usb/go7007/snd-go7007.c    | 11 ++++++-----
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/go7007/go7007-driver.c b/drivers/media/usb/g=
o7007/go7007-driver.c
index 05b1126f263e..62aeebcdd7f7 100644
--- a/drivers/media/usb/go7007/go7007-driver.c
+++ b/drivers/media/usb/go7007/go7007-driver.c
@@ -448,13 +448,14 @@ static struct go7007_buffer *frame_boundary(struct go=
7007 *go, struct go7007_buf
 {
 	u32 *bytesused;
 	struct go7007_buffer *vb_tmp =3D NULL;
+	unsigned long flags;
=20
 	if (vb =3D=3D NULL) {
-		spin_lock(&go->spinlock);
+		spin_lock_irqsave(&go->spinlock, flags);
 		if (!list_empty(&go->vidq_active))
 			vb =3D go->active_buf =3D
 				list_first_entry(&go->vidq_active, struct go7007_buffer, list);
-		spin_unlock(&go->spinlock);
+		spin_unlock_irqrestore(&go->spinlock, flags);
 		go->next_seq++;
 		return vb;
 	}
@@ -468,7 +469,7 @@ static struct go7007_buffer *frame_boundary(struct go70=
07 *go, struct go7007_buf
=20
 	vb->vb.vb2_buf.timestamp =3D ktime_get_ns();
 	vb_tmp =3D vb;
-	spin_lock(&go->spinlock);
+	spin_lock_irqsave(&go->spinlock, flags);
 	list_del(&vb->list);
 	if (list_empty(&go->vidq_active))
 		vb =3D NULL;
@@ -476,7 +477,7 @@ static struct go7007_buffer *frame_boundary(struct go70=
07 *go, struct go7007_buf
 		vb =3D list_first_entry(&go->vidq_active,
 				struct go7007_buffer, list);
 	go->active_buf =3D vb;
-	spin_unlock(&go->spinlock);
+	spin_unlock_irqrestore(&go->spinlock, flags);
 	vb2_buffer_done(&vb_tmp->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	return vb;
 }
diff --git a/drivers/media/usb/go7007/snd-go7007.c b/drivers/media/usb/go70=
07/snd-go7007.c
index f84a2130f033..137fc253b122 100644
--- a/drivers/media/usb/go7007/snd-go7007.c
+++ b/drivers/media/usb/go7007/snd-go7007.c
@@ -75,13 +75,14 @@ static void parse_audio_stream_data(struct go7007 *go, =
u8 *buf, int length)
 	struct go7007_snd *gosnd =3D go->snd_context;
 	struct snd_pcm_runtime *runtime =3D gosnd->substream->runtime;
 	int frames =3D bytes_to_frames(runtime, length);
+	unsigned long flags;
=20
-	spin_lock(&gosnd->lock);
+	spin_lock_irqsave(&gosnd->lock, flags);
 	gosnd->hw_ptr +=3D frames;
 	if (gosnd->hw_ptr >=3D runtime->buffer_size)
 		gosnd->hw_ptr -=3D runtime->buffer_size;
 	gosnd->avail +=3D frames;
-	spin_unlock(&gosnd->lock);
+	spin_unlock_irqrestore(&gosnd->lock, flags);
 	if (gosnd->w_idx + length > runtime->dma_bytes) {
 		int cpy =3D runtime->dma_bytes - gosnd->w_idx;
=20
@@ -92,13 +93,13 @@ static void parse_audio_stream_data(struct go7007 *go, =
u8 *buf, int length)
 	}
 	memcpy(runtime->dma_area + gosnd->w_idx, buf, length);
 	gosnd->w_idx +=3D length;
-	spin_lock(&gosnd->lock);
+	spin_lock_irqsave(&gosnd->lock, flags);
 	if (gosnd->avail < runtime->period_size) {
-		spin_unlock(&gosnd->lock);
+		spin_unlock_irqrestore(&gosnd->lock, flags);
 		return;
 	}
 	gosnd->avail -=3D runtime->period_size;
-	spin_unlock(&gosnd->lock);
+	spin_unlock_irqrestore(&gosnd->lock, flags);
 	if (gosnd->capturing)
 		snd_pcm_period_elapsed(gosnd->substream);
 }
--=20
2.18.0
