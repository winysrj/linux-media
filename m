Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1559 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3CBXpz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 18:45:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 09/20] solo6x10: move global fields in solo_enc_fh to solo_enc_dev.
Date: Sun,  3 Mar 2013 00:45:25 +0100
Message-Id: <72bbf66b9fbd73d335b2d8c785a77519db4ffea0.1362266529.git.hans.verkuil@cisco.com>
In-Reply-To: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
References: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
References: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

All fields in solo_enc_fh do not belong there since they refer to global
properties. After moving all these fields to solo_enc_dev the solo_dev_fh
struct can be removed completely.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/solo6x10.h |    9 +
 drivers/staging/media/solo6x10/v4l2-enc.c |  287 ++++++++++++-----------------
 2 files changed, 127 insertions(+), 169 deletions(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index 4e32065..ef18abd 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -171,6 +171,15 @@ struct solo_enc_dev {
 	u16			width;
 	u16			height;
 	char			osd_text[OSD_TEXT_MAX + 1];
+
+	u32			fmt;
+	u16			rd_idx;
+	u8			enc_on;
+	enum solo_enc_types	type;
+	struct videobuf_queue	vidq;
+	struct list_head	vidq_active;
+	struct task_struct	*kthread;
+	struct p2m_desc		desc[SOLO_NR_P2M_DESC];
 };
 
 struct solo_enc_buf {
diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index 453bdba..cb78ea2 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -37,19 +37,6 @@ static int solo_enc_thread(void *data);
 
 extern unsigned video_nr;
 
-struct solo_enc_fh {
-	struct v4l2_fh		fh;
-	struct solo_enc_dev	*enc;
-	u32			fmt;
-	u16			rd_idx;
-	u8			enc_on;
-	enum solo_enc_types	type;
-	struct videobuf_queue	vidq;
-	struct list_head	vidq_active;
-	struct task_struct	*kthread;
-	struct p2m_desc		desc[SOLO_NR_P2M_DESC];
-};
-
 static int solo_is_motion_on(struct solo_enc_dev *solo_enc)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
@@ -115,16 +102,15 @@ static void solo_update_mode(struct solo_enc_dev *solo_enc)
 }
 
 /* Should be called with solo_enc->lock held */
-static int solo_enc_on(struct solo_enc_fh *fh)
+static int solo_enc_on(struct solo_enc_dev *solo_enc)
 {
-	struct solo_enc_dev *solo_enc = fh->enc;
 	u8 ch = solo_enc->ch;
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	u8 interval;
 
 	assert_spin_locked(&solo_enc->lock);
 
-	if (fh->enc_on)
+	if (solo_enc->enc_on)
 		return 0;
 
 	solo_update_mode(solo_enc);
@@ -137,10 +123,10 @@ static int solo_enc_on(struct solo_enc_fh *fh)
 			solo_dev->enc_bw_remain -= solo_enc->bw_weight;
 	}
 
-	fh->enc_on = 1;
-	fh->rd_idx = solo_enc->solo_dev->enc_wr_idx;
+	solo_enc->enc_on = 1;
+	solo_enc->rd_idx = solo_enc->solo_dev->enc_wr_idx;
 
-	if (fh->type == SOLO_ENC_TYPE_EXT)
+	if (solo_enc->type == SOLO_ENC_TYPE_EXT)
 		solo_reg_write(solo_dev, SOLO_CAP_CH_COMP_ENA_E(ch), 1);
 
 	if (atomic_inc_return(&solo_enc->readers) > 1)
@@ -177,22 +163,21 @@ static int solo_enc_on(struct solo_enc_fh *fh)
 	return 0;
 }
 
-static void solo_enc_off(struct solo_enc_fh *fh)
+static void solo_enc_off(struct solo_enc_dev *solo_enc)
 {
-	struct solo_enc_dev *solo_enc = fh->enc;
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
-	if (!fh->enc_on)
+	if (!solo_enc->enc_on)
 		return;
 
-	if (fh->kthread) {
-		kthread_stop(fh->kthread);
-		fh->kthread = NULL;
+	if (solo_enc->kthread) {
+		kthread_stop(solo_enc->kthread);
+		solo_enc->kthread = NULL;
 	}
 
 	spin_lock(&solo_enc->lock);
 	solo_dev->enc_bw_remain += solo_enc->bw_weight;
-	fh->enc_on = 0;
+	solo_enc->enc_on = 0;
 
 	if (atomic_dec_return(&solo_enc->readers) > 0)
 		goto unlock;
@@ -203,15 +188,15 @@ unlock:
 	spin_unlock(&solo_enc->lock);
 }
 
-static int solo_start_fh_thread(struct solo_enc_fh *fh)
+static int solo_start_thread(struct solo_enc_dev *solo_enc)
 {
-	fh->kthread = kthread_run(solo_enc_thread, fh, SOLO6X10_NAME "_enc");
+	solo_enc->kthread = kthread_run(solo_enc_thread, solo_enc, SOLO6X10_NAME "_enc");
 
 	/* Oops, we had a problem */
-	if (IS_ERR(fh->kthread)) {
-		solo_enc_off(fh);
+	if (IS_ERR(solo_enc->kthread)) {
+		solo_enc_off(solo_enc);
 
-		return PTR_ERR(fh->kthread);
+		return PTR_ERR(solo_enc->kthread);
 	}
 
 	return 0;
@@ -384,20 +369,20 @@ static void solo_jpeg_header(struct solo_enc_dev *solo_enc,
 	}
 }
 
-static int solo_fill_jpeg(struct solo_enc_fh *fh, struct solo_enc_buf *enc_buf,
+static int solo_fill_jpeg(struct solo_enc_dev *solo_enc, struct solo_enc_buf *enc_buf,
 			  struct videobuf_buffer *vb,
 			  struct videobuf_dmabuf *vbuf)
 {
-	struct solo_dev *solo_dev = fh->enc->solo_dev;
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	int size = enc_buf->jpeg_size;
 
 	/* Copy the header first (direct write) */
-	solo_jpeg_header(fh->enc, vbuf);
+	solo_jpeg_header(solo_enc, vbuf);
 
 	vb->size = size + sizeof(jpeg_header);
 
 	/* Grab the jpeg frame */
-	return enc_get_jpeg_dma_sg(solo_dev, fh->desc, vbuf->sglist,
+	return enc_get_jpeg_dma_sg(solo_dev, solo_enc->desc, vbuf->sglist,
 				   sizeof(jpeg_header),
 				   enc_buf->jpeg_off, size);
 }
@@ -584,11 +569,10 @@ static void h264_write_vol(u8 **out, struct solo_dev *solo_dev, __le32 *vh)
 	write_h264_end(out, &bits, 1);
 }
 
-static int solo_fill_mpeg(struct solo_enc_fh *fh, struct solo_enc_buf *enc_buf,
+static int solo_fill_mpeg(struct solo_enc_dev *solo_enc, struct solo_enc_buf *enc_buf,
 			  struct videobuf_buffer *vb,
 			  struct videobuf_dmabuf *vbuf)
 {
-	struct solo_enc_dev *solo_enc = fh->enc;
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
 #define VH_WORDS 16
@@ -634,23 +618,22 @@ static int solo_fill_mpeg(struct solo_enc_fh *fh, struct solo_enc_buf *enc_buf,
 	frame_off = (enc_buf->off + sizeof(vh)) % SOLO_MP4E_EXT_SIZE(solo_dev);
 	frame_size = enc_buf->size - sizeof(vh);
 
-	ret = enc_get_mpeg_dma_sg(solo_dev, fh->desc, vbuf->sglist,
+	ret = enc_get_mpeg_dma_sg(solo_dev, solo_enc->desc, vbuf->sglist,
 				  skip, frame_off, frame_size);
 	WARN_ON_ONCE(ret);
 
 	return ret;
 }
 
-static void solo_enc_fillbuf(struct solo_enc_fh *fh,
+static void solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
 			    struct videobuf_buffer *vb)
 {
-	struct solo_enc_dev *solo_enc = fh->enc;
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct solo_enc_buf *enc_buf = NULL;
 	struct videobuf_dmabuf *vbuf;
 	int ret;
 	int error = 1;
-	u16 idx = fh->rd_idx;
+	u16 idx = solo_enc->rd_idx;
 
 	while (idx != solo_dev->enc_wr_idx) {
 		struct solo_enc_buf *ebuf = &solo_dev->enc_buf[idx];
@@ -660,8 +643,8 @@ static void solo_enc_fillbuf(struct solo_enc_fh *fh,
 		if (ebuf->ch != solo_enc->ch)
 			continue;
 
-		if (fh->fmt == V4L2_PIX_FMT_MPEG) {
-			if (fh->type == ebuf->type) {
+		if (solo_enc->fmt == V4L2_PIX_FMT_MPEG) {
+			if (solo_enc->type == ebuf->type) {
 				enc_buf = ebuf;
 				break;
 			}
@@ -671,14 +654,14 @@ static void solo_enc_fillbuf(struct solo_enc_fh *fh,
 		}
 	}
 
-	fh->rd_idx = idx;
+	solo_enc->rd_idx = idx;
 
 	if (WARN_ON_ONCE(!enc_buf))
 		goto buf_err;
 
-	if ((fh->fmt == V4L2_PIX_FMT_MPEG &&
+	if ((solo_enc->fmt == V4L2_PIX_FMT_MPEG &&
 	     vb->bsize < enc_buf->size) ||
-	    (fh->fmt == V4L2_PIX_FMT_MJPEG &&
+	    (solo_enc->fmt == V4L2_PIX_FMT_MJPEG &&
 	     vb->bsize < (enc_buf->jpeg_size + sizeof(jpeg_header)))) {
 		WARN_ON_ONCE(1);
 		goto buf_err;
@@ -688,10 +671,10 @@ static void solo_enc_fillbuf(struct solo_enc_fh *fh,
 	if (WARN_ON_ONCE(!vbuf))
 		goto buf_err;
 
-	if (fh->fmt == V4L2_PIX_FMT_MPEG)
-		ret = solo_fill_mpeg(fh, enc_buf, vb, vbuf);
+	if (solo_enc->fmt == V4L2_PIX_FMT_MPEG)
+		ret = solo_fill_mpeg(solo_enc, enc_buf, vb, vbuf);
 	else
-		ret = solo_fill_jpeg(fh, enc_buf, vb, vbuf);
+		ret = solo_fill_jpeg(solo_enc, enc_buf, vb, vbuf);
 
 	if (!ret)
 		error = 0;
@@ -710,22 +693,21 @@ buf_err:
 	return;
 }
 
-static void solo_enc_thread_try(struct solo_enc_fh *fh)
+static void solo_enc_thread_try(struct solo_enc_dev *solo_enc)
 {
-	struct solo_enc_dev *solo_enc = fh->enc;
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct videobuf_buffer *vb;
 
 	for (;;) {
 		spin_lock(&solo_enc->lock);
 
-		if (fh->rd_idx == solo_dev->enc_wr_idx)
+		if (solo_enc->rd_idx == solo_dev->enc_wr_idx)
 			break;
 
-		if (list_empty(&fh->vidq_active))
+		if (list_empty(&solo_enc->vidq_active))
 			break;
 
-		vb = list_first_entry(&fh->vidq_active,
+		vb = list_first_entry(&solo_enc->vidq_active,
 				      struct videobuf_buffer, queue);
 
 		if (!waitqueue_active(&vb->done))
@@ -735,7 +717,7 @@ static void solo_enc_thread_try(struct solo_enc_fh *fh)
 
 		spin_unlock(&solo_enc->lock);
 
-		solo_enc_fillbuf(fh, vb);
+		solo_enc_fillbuf(solo_enc, vb);
 	}
 
 	assert_spin_locked(&solo_enc->lock);
@@ -744,8 +726,7 @@ static void solo_enc_thread_try(struct solo_enc_fh *fh)
 
 static int solo_enc_thread(void *data)
 {
-	struct solo_enc_fh *fh = data;
-	struct solo_enc_dev *solo_enc = fh->enc;
+	struct solo_enc_dev *solo_enc = data;
 	DECLARE_WAITQUEUE(wait, current);
 
 	set_freezable();
@@ -755,7 +736,7 @@ static int solo_enc_thread(void *data)
 		long timeout = schedule_timeout_interruptible(HZ);
 		if (timeout == -ERESTARTSYS || kthread_should_stop())
 			break;
-		solo_enc_thread_try(fh);
+		solo_enc_thread_try(solo_enc);
 		try_to_freeze();
 	}
 
@@ -882,8 +863,7 @@ static int solo_enc_buf_prepare(struct videobuf_queue *vq,
 				struct videobuf_buffer *vb,
 				enum v4l2_field field)
 {
-	struct solo_enc_fh *fh = vq->priv_data;
-	struct solo_enc_dev *solo_enc = fh->enc;
+	struct solo_enc_dev *solo_enc = vq->priv_data;
 
 	vb->size = FRAME_BUF_SIZE;
 	if (vb->baddr != 0 && vb->bsize < vb->size)
@@ -912,11 +892,11 @@ static int solo_enc_buf_prepare(struct videobuf_queue *vq,
 static void solo_enc_buf_queue(struct videobuf_queue *vq,
 			       struct videobuf_buffer *vb)
 {
-	struct solo_enc_fh *fh = vq->priv_data;
+	struct solo_enc_dev *solo_enc = vq->priv_data;
 
 	vb->state = VIDEOBUF_QUEUED;
-	list_add_tail(&vb->queue, &fh->vidq_active);
-	wake_up_interruptible(&fh->enc->thread_wait);
+	list_add_tail(&vb->queue, &solo_enc->vidq_active);
+	wake_up_interruptible(&solo_enc->thread_wait);
 }
 
 static void solo_enc_buf_release(struct videobuf_queue *vq,
@@ -939,94 +919,61 @@ static struct videobuf_queue_ops solo_enc_video_qops = {
 static unsigned int solo_enc_poll(struct file *file,
 				  struct poll_table_struct *wait)
 {
-	struct solo_enc_fh *fh = file->private_data;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	unsigned long req_events = poll_requested_events(wait);
 	unsigned res = v4l2_ctrl_poll(file, wait);
 
 	if (!(req_events & (POLLIN | POLLRDNORM)))
 		return res;
-	return videobuf_poll_stream(file, &fh->vidq, wait);
+	return videobuf_poll_stream(file, &solo_enc->vidq, wait);
 }
 
 static int solo_enc_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct solo_enc_fh *fh = file->private_data;
-
-	return videobuf_mmap_mapper(&fh->vidq, vma);
-}
-
-static int solo_enc_open(struct file *file)
-{
 	struct solo_enc_dev *solo_enc = video_drvdata(file);
-	struct solo_enc_fh *fh;
-
-	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (fh == NULL)
-		return -ENOMEM;
-
-	v4l2_fh_init(&fh->fh, video_devdata(file));
-	fh->enc = solo_enc;
-	file->private_data = fh;
-	INIT_LIST_HEAD(&fh->vidq_active);
-	fh->fmt = V4L2_PIX_FMT_MPEG;
-	fh->type = SOLO_ENC_TYPE_STD;
 
-	videobuf_queue_sg_init(&fh->vidq, &solo_enc_video_qops,
-			       &solo_enc->solo_dev->pdev->dev,
-			       &solo_enc->lock,
-			       V4L2_BUF_TYPE_VIDEO_CAPTURE,
-			       V4L2_FIELD_INTERLACED,
-			       sizeof(struct videobuf_buffer), fh, NULL);
-	v4l2_fh_add(&fh->fh);
-	return 0;
+	return videobuf_mmap_mapper(&solo_enc->vidq, vma);
 }
 
 static ssize_t solo_enc_read(struct file *file, char __user *data,
 			     size_t count, loff_t *ppos)
 {
-	struct solo_enc_fh *fh = file->private_data;
-	struct solo_enc_dev *solo_enc = fh->enc;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 
 	/* Make sure the encoder is on */
-	if (!fh->enc_on) {
+	if (!solo_enc->enc_on) {
 		int ret;
 
 		spin_lock(&solo_enc->lock);
-		ret = solo_enc_on(fh);
+		ret = solo_enc_on(solo_enc);
 		spin_unlock(&solo_enc->lock);
 		if (ret)
 			return ret;
 
-		ret = solo_start_fh_thread(fh);
+		ret = solo_start_thread(solo_enc);
 		if (ret)
 			return ret;
 	}
 
-	return videobuf_read_stream(&fh->vidq, data, count, ppos, 0,
+	return videobuf_read_stream(&solo_enc->vidq, data, count, ppos, 0,
 				    file->f_flags & O_NONBLOCK);
 }
 
 static int solo_enc_release(struct file *file)
 {
-	struct solo_enc_fh *fh = file->private_data;
-
-	videobuf_stop(&fh->vidq);
-	videobuf_mmap_free(&fh->vidq);
-
-	solo_enc_off(fh);
-	v4l2_fh_del(&fh->fh);
-	v4l2_fh_exit(&fh->fh);
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 
-	kfree(fh);
+	videobuf_stop(&solo_enc->vidq);
+	videobuf_mmap_free(&solo_enc->vidq);
 
-	return 0;
+	solo_enc_off(solo_enc);
+	return v4l2_fh_release(file);
 }
 
 static int solo_enc_querycap(struct file *file, void  *priv,
 			     struct v4l2_capability *cap)
 {
-	struct solo_enc_fh *fh = priv;
-	struct solo_enc_dev *solo_enc = fh->enc;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
 	strcpy(cap->driver, SOLO6X10_NAME);
@@ -1043,8 +990,7 @@ static int solo_enc_querycap(struct file *file, void  *priv,
 static int solo_enc_enum_input(struct file *file, void *priv,
 			       struct v4l2_input *input)
 {
-	struct solo_enc_fh *fh = priv;
-	struct solo_enc_dev *solo_enc = fh->enc;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
 	if (input->index)
@@ -1105,8 +1051,7 @@ static int solo_enc_enum_fmt_cap(struct file *file, void *priv,
 static int solo_enc_try_fmt_cap(struct file *file, void *priv,
 			    struct v4l2_format *f)
 {
-	struct solo_enc_fh *fh = priv;
-	struct solo_enc_dev *solo_enc = fh->enc;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 
@@ -1147,8 +1092,7 @@ static int solo_enc_try_fmt_cap(struct file *file, void *priv,
 static int solo_enc_set_fmt_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
-	struct solo_enc_fh *fh = priv;
-	struct solo_enc_dev *solo_enc = fh->enc;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	int ret;
@@ -1176,30 +1120,29 @@ static int solo_enc_set_fmt_cap(struct file *file, void *priv,
 		solo_enc->mode = SOLO_ENC_MODE_CIF;
 
 	/* This does not change the encoder at all */
-	fh->fmt = pix->pixelformat;
+	solo_enc->fmt = pix->pixelformat;
 
 	if (pix->priv)
-		fh->type = SOLO_ENC_TYPE_EXT;
-	ret = solo_enc_on(fh);
+		solo_enc->type = SOLO_ENC_TYPE_EXT;
+	ret = solo_enc_on(solo_enc);
 
 	spin_unlock(&solo_enc->lock);
 
 	if (ret)
 		return ret;
 
-	return solo_start_fh_thread(fh);
+	return solo_start_thread(solo_enc);
 }
 
 static int solo_enc_get_fmt_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
-	struct solo_enc_fh *fh = priv;
-	struct solo_enc_dev *solo_enc = fh->enc;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 
 	pix->width = solo_enc->width;
 	pix->height = solo_enc->height;
-	pix->pixelformat = fh->fmt;
+	pix->pixelformat = solo_enc->fmt;
 	pix->field = solo_enc->interlaced ? V4L2_FIELD_INTERLACED :
 		     V4L2_FIELD_NONE;
 	pix->sizeimage = FRAME_BUF_SIZE;
@@ -1212,47 +1155,46 @@ static int solo_enc_get_fmt_cap(struct file *file, void *priv,
 static int solo_enc_reqbufs(struct file *file, void *priv,
 			    struct v4l2_requestbuffers *req)
 {
-	struct solo_enc_fh *fh = priv;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 
-	return videobuf_reqbufs(&fh->vidq, req);
+	return videobuf_reqbufs(&solo_enc->vidq, req);
 }
 
 static int solo_enc_querybuf(struct file *file, void *priv,
 			     struct v4l2_buffer *buf)
 {
-	struct solo_enc_fh *fh = priv;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 
-	return videobuf_querybuf(&fh->vidq, buf);
+	return videobuf_querybuf(&solo_enc->vidq, buf);
 }
 
 static int solo_enc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 {
-	struct solo_enc_fh *fh = priv;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 
-	return videobuf_qbuf(&fh->vidq, buf);
+	return videobuf_qbuf(&solo_enc->vidq, buf);
 }
 
 static int solo_enc_dqbuf(struct file *file, void *priv,
 			  struct v4l2_buffer *buf)
 {
-	struct solo_enc_fh *fh = priv;
-	struct solo_enc_dev *solo_enc = fh->enc;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	int ret;
 
 	/* Make sure the encoder is on */
-	if (!fh->enc_on) {
+	if (!solo_enc->enc_on) {
 		spin_lock(&solo_enc->lock);
-		ret = solo_enc_on(fh);
+		ret = solo_enc_on(solo_enc);
 		spin_unlock(&solo_enc->lock);
 		if (ret)
 			return ret;
 
-		ret = solo_start_fh_thread(fh);
+		ret = solo_start_thread(solo_enc);
 		if (ret)
 			return ret;
 	}
 
-	ret = videobuf_dqbuf(&fh->vidq, buf, file->f_flags & O_NONBLOCK);
+	ret = videobuf_dqbuf(&solo_enc->vidq, buf, file->f_flags & O_NONBLOCK);
 	if (ret)
 		return ret;
 
@@ -1268,9 +1210,9 @@ static int solo_enc_dqbuf(struct file *file, void *priv,
 	}
 
 	/* Check for key frame on mpeg data */
-	if (fh->fmt == V4L2_PIX_FMT_MPEG) {
+	if (solo_enc->fmt == V4L2_PIX_FMT_MPEG) {
 		struct videobuf_dmabuf *vbuf =
-				videobuf_to_dma(fh->vidq.bufs[buf->index]);
+				videobuf_to_dma(solo_enc->vidq.bufs[buf->index]);
 
 		if (vbuf) {
 			u8 *p = sg_virt(vbuf->sglist);
@@ -1287,23 +1229,23 @@ static int solo_enc_dqbuf(struct file *file, void *priv,
 static int solo_enc_streamon(struct file *file, void *priv,
 			     enum v4l2_buf_type i)
 {
-	struct solo_enc_fh *fh = priv;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 
 	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	return videobuf_streamon(&fh->vidq);
+	return videobuf_streamon(&solo_enc->vidq);
 }
 
 static int solo_enc_streamoff(struct file *file, void *priv,
 			      enum v4l2_buf_type i)
 {
-	struct solo_enc_fh *fh = priv;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 
 	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	return videobuf_streamoff(&fh->vidq);
+	return videobuf_streamoff(&solo_enc->vidq);
 }
 
 static int solo_enc_s_std(struct file *file, void *priv, v4l2_std_id *i)
@@ -1314,8 +1256,8 @@ static int solo_enc_s_std(struct file *file, void *priv, v4l2_std_id *i)
 static int solo_enum_framesizes(struct file *file, void *priv,
 				struct v4l2_frmsizeenum *fsize)
 {
-	struct solo_enc_fh *fh = priv;
-	struct solo_dev *solo_dev = fh->enc->solo_dev;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
 	if (fsize->pixel_format != V4L2_PIX_FMT_MPEG &&
 	    fsize->pixel_format != V4L2_PIX_FMT_MJPEG)
@@ -1342,8 +1284,8 @@ static int solo_enum_framesizes(struct file *file, void *priv,
 static int solo_enum_frameintervals(struct file *file, void *priv,
 				    struct v4l2_frmivalenum *fintv)
 {
-	struct solo_enc_fh *fh = priv;
-	struct solo_dev *solo_dev = fh->enc->solo_dev;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
 	if (fintv->pixel_format != V4L2_PIX_FMT_MPEG &&
 	    fintv->pixel_format != V4L2_PIX_FMT_MJPEG)
@@ -1373,8 +1315,7 @@ static int solo_enum_frameintervals(struct file *file, void *priv,
 static int solo_g_parm(struct file *file, void *priv,
 		       struct v4l2_streamparm *sp)
 {
-	struct solo_enc_fh *fh = priv;
-	struct solo_enc_dev *solo_enc = fh->enc;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct v4l2_captureparm *cp = &sp->parm.capture;
 
@@ -1391,8 +1332,7 @@ static int solo_g_parm(struct file *file, void *priv,
 static int solo_s_parm(struct file *file, void *priv,
 		       struct v4l2_streamparm *sp)
 {
-	struct solo_enc_fh *fh = priv;
-	struct solo_enc_dev *solo_enc = fh->enc;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct v4l2_captureparm *cp = &sp->parm.capture;
 
@@ -1471,7 +1411,7 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 
 static const struct v4l2_file_operations solo_enc_fops = {
 	.owner			= THIS_MODULE,
-	.open			= solo_enc_open,
+	.open			= v4l2_fh_open,
 	.release		= solo_enc_release,
 	.read			= solo_enc_read,
 	.poll			= solo_enc_poll,
@@ -1593,6 +1533,33 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev, u8 ch)
 		return ERR_PTR(ret);
 	}
 
+	solo_enc->solo_dev = solo_dev;
+	solo_enc->ch = ch;
+	INIT_LIST_HEAD(&solo_enc->vidq_active);
+	solo_enc->fmt = V4L2_PIX_FMT_MPEG;
+	solo_enc->type = SOLO_ENC_TYPE_STD;
+
+	spin_lock_init(&solo_enc->lock);
+	init_waitqueue_head(&solo_enc->thread_wait);
+	atomic_set(&solo_enc->readers, 0);
+
+	solo_enc->qp = SOLO_DEFAULT_QP;
+	solo_enc->gop = solo_dev->fps;
+	solo_enc->interval = 1;
+	solo_enc->mode = SOLO_ENC_MODE_CIF;
+	solo_enc->motion_thresh = SOLO_DEF_MOT_THRESH;
+
+	spin_lock(&solo_enc->lock);
+	solo_update_mode(solo_enc);
+	spin_unlock(&solo_enc->lock);
+
+	videobuf_queue_sg_init(&solo_enc->vidq, &solo_enc_video_qops,
+			       &solo_enc->solo_dev->pdev->dev,
+			       &solo_enc->lock,
+			       V4L2_BUF_TYPE_VIDEO_CAPTURE,
+			       V4L2_FIELD_INTERLACED,
+			       sizeof(struct videobuf_buffer), solo_enc, NULL);
+
 	solo_enc->vfd = video_device_alloc();
 	if (!solo_enc->vfd) {
 		v4l2_ctrl_handler_free(hdl);
@@ -1600,13 +1567,11 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev, u8 ch)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	solo_enc->solo_dev = solo_dev;
-	solo_enc->ch = ch;
-
 	*solo_enc->vfd = solo_enc_template;
 	solo_enc->vfd->v4l2_dev = &solo_dev->v4l2_dev;
 	solo_enc->vfd->ctrl_handler = hdl;
 	set_bit(V4L2_FL_USE_FH_PRIO, &solo_enc->vfd->flags);
+	video_set_drvdata(solo_enc->vfd, solo_enc);
 	ret = video_register_device(solo_enc->vfd, VFL_TYPE_GRABBER,
 				    video_nr);
 	if (ret < 0) {
@@ -1616,8 +1581,6 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev, u8 ch)
 		return ERR_PTR(ret);
 	}
 
-	video_set_drvdata(solo_enc->vfd, solo_enc);
-
 	snprintf(solo_enc->vfd->name, sizeof(solo_enc->vfd->name),
 		 "%s-enc (%i/%i)", SOLO6X10_NAME, solo_dev->vfd->num,
 		 solo_enc->vfd->num);
@@ -1625,20 +1588,6 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev, u8 ch)
 	if (video_nr != -1)
 		video_nr++;
 
-	spin_lock_init(&solo_enc->lock);
-	init_waitqueue_head(&solo_enc->thread_wait);
-	atomic_set(&solo_enc->readers, 0);
-
-	solo_enc->qp = SOLO_DEFAULT_QP;
-	solo_enc->gop = solo_dev->fps;
-	solo_enc->interval = 1;
-	solo_enc->mode = SOLO_ENC_MODE_CIF;
-	solo_enc->motion_thresh = SOLO_DEF_MOT_THRESH;
-
-	spin_lock(&solo_enc->lock);
-	solo_update_mode(solo_enc);
-	spin_unlock(&solo_enc->lock);
-
 	return solo_enc;
 }
 
-- 
1.7.10.4

