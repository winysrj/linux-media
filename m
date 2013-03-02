Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4994 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3CBXp5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 18:45:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 12/20] solo6x10: rename the spinlock 'lock' to 'slock'.
Date: Sun,  3 Mar 2013 00:45:28 +0100
Message-Id: <1d4957107e1073d07d53b3e2112fb9e6c180ef32.1362266529.git.hans.verkuil@cisco.com>
In-Reply-To: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
References: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
References: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The next patch will add a mutex called 'lock', so we have to rename this
spinlock first.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/solo6x10.h |    2 +-
 drivers/staging/media/solo6x10/v4l2-enc.c |   52 ++++++++++++++---------------
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index fcbe8ecf..2ab64cf 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -160,7 +160,7 @@ struct solo_enc_dev {
 	struct video_device	*vfd;
 	/* General accounting */
 	wait_queue_head_t	thread_wait;
-	spinlock_t		lock;
+	spinlock_t		slock;
 	atomic_t		readers;
 	u8			ch;
 	u8			mode, gop, qp, interlaced, interval;
diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index 32f812f..800719e 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -52,7 +52,7 @@ static void solo_motion_toggle(struct solo_enc_dev *solo_enc, int on)
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	u8 ch = solo_enc->ch;
 
-	spin_lock(&solo_enc->lock);
+	spin_lock(&solo_enc->slock);
 
 	if (on)
 		solo_dev->motion_mask |= (1 << ch);
@@ -73,15 +73,15 @@ static void solo_motion_toggle(struct solo_enc_dev *solo_enc, int on)
 	else
 		solo_irq_off(solo_dev, SOLO_IRQ_MOTION);
 
-	spin_unlock(&solo_enc->lock);
+	spin_unlock(&solo_enc->slock);
 }
 
-/* Should be called with solo_enc->lock held */
+/* Should be called with solo_enc->slock held */
 static void solo_update_mode(struct solo_enc_dev *solo_enc)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
-	assert_spin_locked(&solo_enc->lock);
+	assert_spin_locked(&solo_enc->slock);
 
 	solo_enc->interlaced = (solo_enc->mode & 0x08) ? 1 : 0;
 	solo_enc->bw_weight = max(solo_dev->fps / solo_enc->interval, 1);
@@ -101,14 +101,14 @@ static void solo_update_mode(struct solo_enc_dev *solo_enc)
 	}
 }
 
-/* Should be called with solo_enc->lock held */
+/* Should be called with solo_enc->slock held */
 static int solo_enc_on(struct solo_enc_dev *solo_enc)
 {
 	u8 ch = solo_enc->ch;
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	u8 interval;
 
-	assert_spin_locked(&solo_enc->lock);
+	assert_spin_locked(&solo_enc->slock);
 
 	if (solo_enc->enc_on)
 		return 0;
@@ -175,7 +175,7 @@ static void solo_enc_off(struct solo_enc_dev *solo_enc)
 		solo_enc->kthread = NULL;
 	}
 
-	spin_lock(&solo_enc->lock);
+	spin_lock(&solo_enc->slock);
 	solo_dev->enc_bw_remain += solo_enc->bw_weight;
 	solo_enc->enc_on = 0;
 
@@ -185,7 +185,7 @@ static void solo_enc_off(struct solo_enc_dev *solo_enc)
 	solo_reg_write(solo_dev, SOLO_CAP_CH_SCALE(solo_enc->ch), 0);
 	solo_reg_write(solo_dev, SOLO_CAP_CH_COMP_ENA_E(solo_enc->ch), 0);
 unlock:
-	spin_unlock(&solo_enc->lock);
+	spin_unlock(&solo_enc->slock);
 }
 
 static int solo_start_thread(struct solo_enc_dev *solo_enc)
@@ -699,7 +699,7 @@ static void solo_enc_thread_try(struct solo_enc_dev *solo_enc)
 	struct videobuf_buffer *vb;
 
 	for (;;) {
-		spin_lock(&solo_enc->lock);
+		spin_lock(&solo_enc->slock);
 
 		if (solo_enc->rd_idx == solo_dev->enc_wr_idx)
 			break;
@@ -715,13 +715,13 @@ static void solo_enc_thread_try(struct solo_enc_dev *solo_enc)
 
 		list_del(&vb->queue);
 
-		spin_unlock(&solo_enc->lock);
+		spin_unlock(&solo_enc->slock);
 
 		solo_enc_fillbuf(solo_enc, vb);
 	}
 
-	assert_spin_locked(&solo_enc->lock);
-	spin_unlock(&solo_enc->lock);
+	assert_spin_locked(&solo_enc->slock);
+	spin_unlock(&solo_enc->slock);
 }
 
 static int solo_enc_thread(void *data)
@@ -944,9 +944,9 @@ static ssize_t solo_enc_read(struct file *file, char __user *data,
 	if (!solo_enc->enc_on) {
 		int ret;
 
-		spin_lock(&solo_enc->lock);
+		spin_lock(&solo_enc->slock);
 		ret = solo_enc_on(solo_enc);
-		spin_unlock(&solo_enc->lock);
+		spin_unlock(&solo_enc->slock);
 		if (ret)
 			return ret;
 
@@ -1097,7 +1097,7 @@ static int solo_enc_set_fmt_cap(struct file *file, void *priv,
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	int ret;
 
-	spin_lock(&solo_enc->lock);
+	spin_lock(&solo_enc->slock);
 
 	ret = solo_enc_try_fmt_cap(file, priv, f);
 	if (ret)
@@ -1110,7 +1110,7 @@ static int solo_enc_set_fmt_cap(struct file *file, void *priv,
 			ret = -EBUSY;
 	}
 	if (ret) {
-		spin_unlock(&solo_enc->lock);
+		spin_unlock(&solo_enc->slock);
 		return ret;
 	}
 
@@ -1126,7 +1126,7 @@ static int solo_enc_set_fmt_cap(struct file *file, void *priv,
 		solo_enc->type = SOLO_ENC_TYPE_EXT;
 	ret = solo_enc_on(solo_enc);
 
-	spin_unlock(&solo_enc->lock);
+	spin_unlock(&solo_enc->slock);
 
 	if (ret)
 		return ret;
@@ -1183,9 +1183,9 @@ static int solo_enc_dqbuf(struct file *file, void *priv,
 
 	/* Make sure the encoder is on */
 	if (!solo_enc->enc_on) {
-		spin_lock(&solo_enc->lock);
+		spin_lock(&solo_enc->slock);
 		ret = solo_enc_on(solo_enc);
-		spin_unlock(&solo_enc->lock);
+		spin_unlock(&solo_enc->slock);
 		if (ret)
 			return ret;
 
@@ -1336,10 +1336,10 @@ static int solo_s_parm(struct file *file, void *priv,
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct v4l2_captureparm *cp = &sp->parm.capture;
 
-	spin_lock(&solo_enc->lock);
+	spin_lock(&solo_enc->slock);
 
 	if (atomic_read(&solo_enc->readers) > 0) {
-		spin_unlock(&solo_enc->lock);
+		spin_unlock(&solo_enc->slock);
 		return -EBUSY;
 	}
 
@@ -1364,7 +1364,7 @@ static int solo_s_parm(struct file *file, void *priv,
 	solo_enc->gop = max(solo_dev->fps / solo_enc->interval, 1);
 	solo_update_mode(solo_enc);
 
-	spin_unlock(&solo_enc->lock);
+	spin_unlock(&solo_enc->slock);
 
 	return 0;
 }
@@ -1539,7 +1539,7 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev, u8 ch)
 	solo_enc->fmt = V4L2_PIX_FMT_MPEG;
 	solo_enc->type = SOLO_ENC_TYPE_STD;
 
-	spin_lock_init(&solo_enc->lock);
+	spin_lock_init(&solo_enc->slock);
 	init_waitqueue_head(&solo_enc->thread_wait);
 	atomic_set(&solo_enc->readers, 0);
 
@@ -1549,13 +1549,13 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev, u8 ch)
 	solo_enc->mode = SOLO_ENC_MODE_CIF;
 	solo_enc->motion_thresh = SOLO_DEF_MOT_THRESH;
 
-	spin_lock(&solo_enc->lock);
+	spin_lock(&solo_enc->slock);
 	solo_update_mode(solo_enc);
-	spin_unlock(&solo_enc->lock);
+	spin_unlock(&solo_enc->slock);
 
 	videobuf_queue_sg_init(&solo_enc->vidq, &solo_enc_video_qops,
 			       &solo_enc->solo_dev->pdev->dev,
-			       &solo_enc->lock,
+			       &solo_enc->slock,
 			       V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			       V4L2_FIELD_INTERLACED,
 			       sizeof(struct videobuf_buffer), solo_enc, NULL);
-- 
1.7.10.4

