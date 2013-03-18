Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2042 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab3CRMcf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 08:32:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 08/19] solo6x10: move global fields in solo_enc_fh to solo_enc_dev.
Date: Mon, 18 Mar 2013 13:32:07 +0100
Message-Id: <1363609938-21735-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
References: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

All fields in solo_enc_fh do not belong there since they refer to global
properties. After moving all these fields to solo_enc_dev the solo_dev_fh
struct can be removed completely.

Note that this also kills the 'listener' feature of this driver. This
feature (where multiple filehandles can read the video) is illegal in the
V4L2 API. Do this in userspace: it's much more efficient to copy memory
than it is to DMA to every listener.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/solo6x10.h |   17 +-
 drivers/staging/media/solo6x10/v4l2-enc.c |  379 ++++++++++++-----------------
 2 files changed, 175 insertions(+), 221 deletions(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index 361f41f..cf88db3 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -135,6 +135,11 @@ struct solo_p2m_dev {
 
 #define OSD_TEXT_MAX		44
 
+enum solo_enc_types {
+	SOLO_ENC_TYPE_STD,
+	SOLO_ENC_TYPE_EXT,
+};
+
 struct solo_enc_dev {
 	struct solo_dev	*solo_dev;
 	/* V4L2 Items */
@@ -163,8 +168,16 @@ struct solo_enc_dev {
 	unsigned char		jpeg_header[1024];
 	int			jpeg_len;
 
-	/* File handles that are listening for buffers */
-	struct list_head	listeners;
+	u32			fmt;
+	u8			enc_on;
+	enum solo_enc_types	type;
+	struct videobuf_queue	vidq;
+	struct list_head	vidq_active;
+	int			desc_count;
+	int			desc_nelts;
+	struct solo_p2m_desc	*desc_items;
+	dma_addr_t		desc_dma;
+	spinlock_t		av_lock;
 };
 
 /* The SOLO6x10 PCI Device */
diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index 366f2b3..65609c1 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -41,27 +41,6 @@
 #define MP4_QS			16
 #define DMA_ALIGN		4096
 
-enum solo_enc_types {
-	SOLO_ENC_TYPE_STD,
-	SOLO_ENC_TYPE_EXT,
-};
-
-struct solo_enc_fh {
-	struct v4l2_fh		fh;
-	struct solo_enc_dev	*enc;
-	u32			fmt;
-	u8			enc_on;
-	enum solo_enc_types	type;
-	struct videobuf_queue	vidq;
-	struct list_head	vidq_active;
-	int			desc_count;
-	int			desc_nelts;
-	struct solo_p2m_desc	*desc_items;
-	dma_addr_t		desc_dma;
-	spinlock_t		av_lock;
-	struct list_head	list;
-};
-
 struct solo_videobuf {
 	struct videobuf_buffer	vb;
 	unsigned int		flags;
@@ -286,16 +265,15 @@ static void solo_update_mode(struct solo_enc_dev *solo_enc)
 }
 
 /* MUST be called with solo_enc->enable_lock held */
-static int __solo_enc_on(struct solo_enc_fh *fh)
+static int __solo_enc_on(struct solo_enc_dev *solo_enc)
 {
-	struct solo_enc_dev *solo_enc = fh->enc;
 	u8 ch = solo_enc->ch;
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	u8 interval;
 
 	BUG_ON(!mutex_is_locked(&solo_enc->enable_lock));
 
-	if (fh->enc_on)
+	if (solo_enc->enc_on)
 		return 0;
 
 	solo_update_mode(solo_enc);
@@ -308,15 +286,14 @@ static int __solo_enc_on(struct solo_enc_fh *fh)
 			solo_dev->enc_bw_remain -= solo_enc->bw_weight;
 	}
 
-	fh->enc_on = 1;
-	list_add(&fh->list, &solo_enc->listeners);
+	solo_enc->enc_on = 1;
 
-	if (fh->type == SOLO_ENC_TYPE_EXT)
+	if (solo_enc->type == SOLO_ENC_TYPE_EXT)
 		solo_reg_write(solo_dev, SOLO_CAP_CH_COMP_ENA_E(ch), 1);
 
 	/* Reset the encoder if we are the first mpeg reader, else only reset
 	 * on the first mjpeg reader. */
-	if (fh->fmt == V4L2_PIX_FMT_MPEG) {
+	if (solo_enc->fmt == V4L2_PIX_FMT_MPEG) {
 		atomic_inc(&solo_enc->readers);
 		if (atomic_inc_return(&solo_enc->mpeg_readers) > 1)
 			return 0;
@@ -352,32 +329,29 @@ static int __solo_enc_on(struct solo_enc_fh *fh)
 	return 0;
 }
 
-static int solo_enc_on(struct solo_enc_fh *fh)
+static int solo_enc_on(struct solo_enc_dev *solo_enc)
 {
-	struct solo_enc_dev *solo_enc = fh->enc;
 	int ret;
 
 	mutex_lock(&solo_enc->enable_lock);
-	ret = __solo_enc_on(fh);
+	ret = __solo_enc_on(solo_enc);
 	mutex_unlock(&solo_enc->enable_lock);
 
 	return ret;
 }
 
-static void __solo_enc_off(struct solo_enc_fh *fh)
+static void __solo_enc_off(struct solo_enc_dev *solo_enc)
 {
-	struct solo_enc_dev *solo_enc = fh->enc;
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
 	BUG_ON(!mutex_is_locked(&solo_enc->enable_lock));
 
-	if (!fh->enc_on)
+	if (!solo_enc->enc_on)
 		return;
 
-	list_del(&fh->list);
-	fh->enc_on = 0;
+	solo_enc->enc_on = 0;
 
-	if (fh->fmt == V4L2_PIX_FMT_MPEG)
+	if (solo_enc->fmt == V4L2_PIX_FMT_MPEG)
 		atomic_dec(&solo_enc->mpeg_readers);
 
 	if (atomic_dec_return(&solo_enc->readers) > 0)
@@ -389,12 +363,10 @@ static void __solo_enc_off(struct solo_enc_fh *fh)
 	solo_reg_write(solo_dev, SOLO_CAP_CH_COMP_ENA_E(solo_enc->ch), 0);
 }
 
-static void solo_enc_off(struct solo_enc_fh *fh)
+static void solo_enc_off(struct solo_enc_dev *solo_enc)
 {
-	struct solo_enc_dev *solo_enc = fh->enc;
-
 	mutex_lock(&solo_enc->enable_lock);
-	__solo_enc_off(fh);
+	__solo_enc_off(solo_enc);
 	mutex_unlock(&solo_enc->enable_lock);
 }
 
@@ -430,11 +402,11 @@ static int enc_get_mpeg_dma(struct solo_dev *solo_dev, dma_addr_t dma,
 
 /* Build a descriptor queue out of an SG list and send it to the P2M for
  * processing. */
-static int solo_send_desc(struct solo_enc_fh *fh, int skip,
+static int solo_send_desc(struct solo_enc_dev *solo_enc, int skip,
 			  struct videobuf_dmabuf *vbuf, int off, int size,
 			  unsigned int base, unsigned int base_size)
 {
-	struct solo_dev *solo_dev = fh->enc->solo_dev;
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct scatterlist *sg;
 	int i;
 	int ret;
@@ -442,7 +414,7 @@ static int solo_send_desc(struct solo_enc_fh *fh, int skip,
 	if (WARN_ON_ONCE(size > FRAME_BUF_SIZE))
 		return -EINVAL;
 
-	fh->desc_count = 1;
+	solo_enc->desc_count = 1;
 
 	for_each_sg(vbuf->sglist, sg, vbuf->sglen, i) {
 		struct solo_p2m_desc *desc;
@@ -450,7 +422,7 @@ static int solo_send_desc(struct solo_enc_fh *fh, int skip,
 		int len;
 		int left = base_size - off;
 
-		desc = &fh->desc_items[fh->desc_count++];
+		desc = &solo_enc->desc_items[solo_enc->desc_count++];
 		dma = sg_dma_address(sg);
 		len = sg_dma_len(sg);
 
@@ -486,7 +458,7 @@ static int solo_send_desc(struct solo_enc_fh *fh, int skip,
 			if (ret)
 				return ret;
 
-			fh->desc_count--;
+			solo_enc->desc_count--;
 		}
 
 		size -= len;
@@ -498,27 +470,26 @@ static int solo_send_desc(struct solo_enc_fh *fh, int skip,
 			off -= base_size;
 
 		/* Because we may use two descriptors per loop */
-		if (fh->desc_count >= (fh->desc_nelts - 1)) {
-			ret = solo_p2m_dma_desc(solo_dev, fh->desc_items,
-						fh->desc_dma,
-						fh->desc_count - 1);
+		if (solo_enc->desc_count >= (solo_enc->desc_nelts - 1)) {
+			ret = solo_p2m_dma_desc(solo_dev, solo_enc->desc_items,
+						solo_enc->desc_dma,
+						solo_enc->desc_count - 1);
 			if (ret)
 				return ret;
-			fh->desc_count = 1;
+			solo_enc->desc_count = 1;
 		}
 	}
 
-	if (fh->desc_count <= 1)
+	if (solo_enc->desc_count <= 1)
 		return 0;
 
-	return solo_p2m_dma_desc(solo_dev, fh->desc_items, fh->desc_dma,
-				 fh->desc_count - 1);
+	return solo_p2m_dma_desc(solo_dev, solo_enc->desc_items, solo_enc->desc_dma,
+				 solo_enc->desc_count - 1);
 }
 
-static int solo_fill_jpeg(struct solo_enc_fh *fh, struct videobuf_buffer *vb,
+static int solo_fill_jpeg(struct solo_enc_dev *solo_enc, struct videobuf_buffer *vb,
 			  struct videobuf_dmabuf *vbuf, struct vop_header *vh)
 {
-	struct solo_enc_dev *solo_enc = fh->enc;
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct solo_videobuf *svb = (struct solo_videobuf *)vb;
 	int frame_size;
@@ -539,15 +510,14 @@ static int solo_fill_jpeg(struct solo_enc_fh *fh, struct videobuf_buffer *vb,
 	frame_size = (vh->jpeg_size + solo_enc->jpeg_len + (DMA_ALIGN - 1))
 		& ~(DMA_ALIGN - 1);
 
-	return solo_send_desc(fh, solo_enc->jpeg_len, vbuf, vh->jpeg_off,
+	return solo_send_desc(solo_enc, solo_enc->jpeg_len, vbuf, vh->jpeg_off,
 			      frame_size, SOLO_JPEG_EXT_ADDR(solo_dev),
 			      SOLO_JPEG_EXT_SIZE(solo_dev));
 }
 
-static int solo_fill_mpeg(struct solo_enc_fh *fh, struct videobuf_buffer *vb,
+static int solo_fill_mpeg(struct solo_enc_dev *solo_enc, struct videobuf_buffer *vb,
 			  struct videobuf_dmabuf *vbuf, struct vop_header *vh)
 {
-	struct solo_enc_dev *solo_enc = fh->enc;
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct solo_videobuf *svb = (struct solo_videobuf *)vb;
 	int frame_off, frame_size;
@@ -580,16 +550,15 @@ static int solo_fill_mpeg(struct solo_enc_fh *fh, struct videobuf_buffer *vb,
 	frame_size = (vh->mpeg_size + skip + (DMA_ALIGN - 1))
 		& ~(DMA_ALIGN - 1);
 
-	return solo_send_desc(fh, skip, vbuf, frame_off, frame_size,
+	return solo_send_desc(solo_enc, skip, vbuf, frame_off, frame_size,
 			      SOLO_MP4E_EXT_ADDR(solo_dev),
 			      SOLO_MP4E_EXT_SIZE(solo_dev));
 }
 
-static int solo_enc_fillbuf(struct solo_enc_fh *fh,
+static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
 			    struct videobuf_buffer *vb,
 			    struct solo_enc_buf *enc_buf)
 {
-	struct solo_enc_dev *solo_enc = fh->enc;
 	struct solo_videobuf *svb = (struct solo_videobuf *)vb;
 	struct videobuf_dmabuf *vbuf = NULL;
 	struct vop_header *vh = enc_buf->vh;
@@ -613,10 +582,10 @@ static int solo_enc_fillbuf(struct solo_enc_fh *fh,
 			svb->flags |= V4L2_BUF_FLAG_MOTION_DETECTED;
 	}
 
-	if (fh->fmt == V4L2_PIX_FMT_MPEG)
-		ret = solo_fill_mpeg(fh, vb, vbuf, vh);
+	if (solo_enc->fmt == V4L2_PIX_FMT_MPEG)
+		ret = solo_fill_mpeg(solo_enc, vb, vbuf, vh);
 	else
-		ret = solo_fill_jpeg(fh, vb, vbuf, vh);
+		ret = solo_fill_jpeg(solo_enc, vb, vbuf, vh);
 
 vbuf_error:
 	/* On error, we push this buffer back into the queue. The
@@ -625,10 +594,10 @@ vbuf_error:
 	if (ret) {
 		unsigned long flags;
 
-		spin_lock_irqsave(&fh->av_lock, flags);
-		list_add(&vb->queue, &fh->vidq_active);
+		spin_lock_irqsave(&solo_enc->av_lock, flags);
+		list_add(&vb->queue, &solo_enc->vidq_active);
 		vb->state = VIDEOBUF_QUEUED;
-		spin_unlock_irqrestore(&fh->av_lock, flags);
+		spin_unlock_irqrestore(&solo_enc->av_lock, flags);
 	} else {
 		vb->state = VIDEOBUF_DONE;
 		vb->field_count++;
@@ -644,34 +613,29 @@ vbuf_error:
 static void solo_enc_handle_one(struct solo_enc_dev *solo_enc,
 				struct solo_enc_buf *enc_buf)
 {
-	struct solo_enc_fh *fh;
+	struct videobuf_buffer *vb;
+	unsigned long flags;
 
 	mutex_lock(&solo_enc->enable_lock);
 
-	list_for_each_entry(fh, &solo_enc->listeners, list) {
-		struct videobuf_buffer *vb;
-		unsigned long flags;
-
-		if (fh->type != enc_buf->type)
-			continue;
-
-
-		if (list_empty(&fh->vidq_active))
-			continue;
+	if (solo_enc->type != enc_buf->type)
+		goto unlock;
 
-		spin_lock_irqsave(&fh->av_lock, flags);
+	if (list_empty(&solo_enc->vidq_active))
+		goto unlock;
 
-		vb = list_first_entry(&fh->vidq_active,
-				      struct videobuf_buffer, queue);
+	spin_lock_irqsave(&solo_enc->av_lock, flags);
 
-		list_del(&vb->queue);
-		vb->state = VIDEOBUF_ACTIVE;
+	vb = list_first_entry(&solo_enc->vidq_active,
+			struct videobuf_buffer, queue);
 
-		spin_unlock_irqrestore(&fh->av_lock, flags);
+	list_del(&vb->queue);
+	vb->state = VIDEOBUF_ACTIVE;
 
-		solo_enc_fillbuf(fh, vb, enc_buf);
-	}
+	spin_unlock_irqrestore(&solo_enc->av_lock, flags);
 
+	solo_enc_fillbuf(solo_enc, vb, enc_buf);
+unlock:
 	mutex_unlock(&solo_enc->enable_lock);
 }
 
@@ -799,10 +763,10 @@ static int solo_enc_buf_prepare(struct videobuf_queue *vq,
 static void solo_enc_buf_queue(struct videobuf_queue *vq,
 			       struct videobuf_buffer *vb)
 {
-	struct solo_enc_fh *fh = vq->priv_data;
+	struct solo_enc_dev *solo_enc = vq->priv_data;
 
 	vb->state = VIDEOBUF_QUEUED;
-	list_add_tail(&vb->queue, &fh->vidq_active);
+	list_add_tail(&vb->queue, &solo_enc->vidq_active);
 }
 
 static void solo_enc_buf_release(struct videobuf_queue *vq,
@@ -824,20 +788,20 @@ static const struct videobuf_queue_ops solo_enc_video_qops = {
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
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 
-	return videobuf_mmap_mapper(&fh->vidq, vma);
+	return videobuf_mmap_mapper(&solo_enc->vidq, vma);
 }
 
 static int solo_ring_start(struct solo_dev *solo_dev)
@@ -875,91 +839,50 @@ static int solo_enc_open(struct file *file)
 {
 	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
-	struct solo_enc_fh *fh;
-	int ret;
+	int ret = v4l2_fh_open(file);
 
-	ret = solo_ring_start(solo_dev);
 	if (ret)
 		return ret;
-
-	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (fh == NULL) {
-		solo_ring_stop(solo_dev);
-		return -ENOMEM;
-	}
-
-	fh->desc_nelts = 32;
-	fh->desc_items = pci_alloc_consistent(solo_dev->pdev,
-				      sizeof(struct solo_p2m_desc) *
-				      fh->desc_nelts, &fh->desc_dma);
-	if (fh->desc_items == NULL) {
-		kfree(fh);
-		solo_ring_stop(solo_dev);
-		return -ENOMEM;
+	ret = solo_ring_start(solo_dev);
+	if (ret) {
+		v4l2_fh_release(file);
+		return ret;
 	}
-
-	v4l2_fh_init(&fh->fh, video_devdata(file));
-	fh->enc = solo_enc;
-	spin_lock_init(&fh->av_lock);
-	file->private_data = fh;
-	INIT_LIST_HEAD(&fh->vidq_active);
-	fh->fmt = V4L2_PIX_FMT_MPEG;
-	fh->type = SOLO_ENC_TYPE_STD;
-
-	videobuf_queue_sg_init(&fh->vidq, &solo_enc_video_qops,
-				&solo_dev->pdev->dev,
-				&fh->av_lock,
-				V4L2_BUF_TYPE_VIDEO_CAPTURE,
-				V4L2_FIELD_INTERLACED,
-				sizeof(struct solo_videobuf),
-				fh, NULL);
-	v4l2_fh_add(&fh->fh);
 	return 0;
 }
 
 static ssize_t solo_enc_read(struct file *file, char __user *data,
 			     size_t count, loff_t *ppos)
 {
-	struct solo_enc_fh *fh = file->private_data;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	int ret;
 
 	/* Make sure the encoder is on */
-	ret = solo_enc_on(fh);
+	ret = solo_enc_on(solo_enc);
 	if (ret)
 		return ret;
 
-	return videobuf_read_stream(&fh->vidq, data, count, ppos, 0,
+	return videobuf_read_stream(&solo_enc->vidq, data, count, ppos, 0,
 				    file->f_flags & O_NONBLOCK);
 }
 
 static int solo_enc_release(struct file *file)
 {
-	struct solo_enc_fh *fh = file->private_data;
-	struct solo_dev *solo_dev = fh->enc->solo_dev;
-
-	solo_enc_off(fh);
-	v4l2_fh_del(&fh->fh);
-	v4l2_fh_exit(&fh->fh);
-
-	videobuf_stop(&fh->vidq);
-	videobuf_mmap_free(&fh->vidq);
-
-	pci_free_consistent(fh->enc->solo_dev->pdev,
-			    sizeof(struct solo_p2m_desc) *
-			    fh->desc_nelts, fh->desc_items, fh->desc_dma);
-
-	kfree(fh);
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
+	solo_enc_off(solo_enc);
+	videobuf_stop(&solo_enc->vidq);
+	videobuf_mmap_free(&solo_enc->vidq);
 	solo_ring_stop(solo_dev);
 
-	return 0;
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
@@ -976,8 +899,7 @@ static int solo_enc_querycap(struct file *file, void  *priv,
 static int solo_enc_enum_input(struct file *file, void *priv,
 			       struct v4l2_input *input)
 {
-	struct solo_enc_fh *fh = priv;
-	struct solo_enc_dev *solo_enc = fh->enc;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
 	if (input->index)
@@ -1039,8 +961,7 @@ static int solo_enc_enum_fmt_cap(struct file *file, void *priv,
 static int solo_enc_try_fmt_cap(struct file *file, void *priv,
 			    struct v4l2_format *f)
 {
-	struct solo_enc_fh *fh = priv;
-	struct solo_enc_dev *solo_enc = fh->enc;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 
@@ -1081,8 +1002,7 @@ static int solo_enc_try_fmt_cap(struct file *file, void *priv,
 static int solo_enc_set_fmt_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
-	struct solo_enc_fh *fh = priv;
-	struct solo_enc_dev *solo_enc = fh->enc;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	int ret;
@@ -1110,10 +1030,10 @@ static int solo_enc_set_fmt_cap(struct file *file, void *priv,
 		solo_enc->mode = SOLO_ENC_MODE_CIF;
 
 	/* This does not change the encoder at all */
-	fh->fmt = pix->pixelformat;
+	solo_enc->fmt = pix->pixelformat;
 
 	if (pix->priv)
-		fh->type = SOLO_ENC_TYPE_EXT;
+		solo_enc->type = SOLO_ENC_TYPE_EXT;
 
 	mutex_unlock(&solo_enc->enable_lock);
 
@@ -1123,13 +1043,12 @@ static int solo_enc_set_fmt_cap(struct file *file, void *priv,
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
@@ -1142,45 +1061,45 @@ static int solo_enc_get_fmt_cap(struct file *file, void *priv,
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
 
 static int solo_enc_qbuf(struct file *file, void *priv,
 			 struct v4l2_buffer *buf)
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
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	struct solo_videobuf *svb;
 	int ret;
 
 	/* Make sure the encoder is on */
-	ret = solo_enc_on(fh);
+	ret = solo_enc_on(solo_enc);
 	if (ret)
 		return ret;
 
-	ret = videobuf_dqbuf(&fh->vidq, buf, file->f_flags & O_NONBLOCK);
+	ret = videobuf_dqbuf(&solo_enc->vidq, buf, file->f_flags & O_NONBLOCK);
 	if (ret)
 		return ret;
 
 	/* Copy over the flags */
-	svb = (struct solo_videobuf *)fh->vidq.bufs[buf->index];
+	svb = (struct solo_videobuf *)solo_enc->vidq.bufs[buf->index];
 	buf->flags |= svb->flags;
 
 	return 0;
@@ -1189,26 +1108,26 @@ static int solo_enc_dqbuf(struct file *file, void *priv,
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
 	int ret;
 
 	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	ret = videobuf_streamoff(&fh->vidq);
+	ret = videobuf_streamoff(&solo_enc->vidq);
 	if (!ret)
-		solo_enc_off(fh);
+		solo_enc_off(solo_enc);
 
 	return ret;
 }
@@ -1221,8 +1140,8 @@ static int solo_enc_s_std(struct file *file, void *priv, v4l2_std_id *i)
 static int solo_enum_framesizes(struct file *file, void *priv,
 				struct v4l2_frmsizeenum *fsize)
 {
-	struct solo_enc_fh *fh = priv;
-	struct solo_dev *solo_dev = fh->enc->solo_dev;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
 	if (fsize->pixel_format != V4L2_PIX_FMT_MPEG &&
 	    fsize->pixel_format != V4L2_PIX_FMT_MJPEG)
@@ -1249,8 +1168,8 @@ static int solo_enum_framesizes(struct file *file, void *priv,
 static int solo_enum_frameintervals(struct file *file, void *priv,
 				    struct v4l2_frmivalenum *fintv)
 {
-	struct solo_enc_fh *fh = priv;
-	struct solo_dev *solo_dev = fh->enc->solo_dev;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
 	if (fintv->pixel_format != V4L2_PIX_FMT_MPEG &&
 	    fintv->pixel_format != V4L2_PIX_FMT_MJPEG)
@@ -1280,8 +1199,7 @@ static int solo_enum_frameintervals(struct file *file, void *priv,
 static int solo_g_parm(struct file *file, void *priv,
 		       struct v4l2_streamparm *sp)
 {
-	struct solo_enc_fh *fh = priv;
-	struct solo_enc_dev *solo_enc = fh->enc;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct v4l2_captureparm *cp = &sp->parm.capture;
 
@@ -1298,8 +1216,7 @@ static int solo_g_parm(struct file *file, void *priv,
 static int solo_s_parm(struct file *file, void *priv,
 		       struct v4l2_streamparm *sp)
 {
-	struct solo_enc_fh *fh = priv;
-	struct solo_enc_dev *solo_enc = fh->enc;
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct v4l2_captureparm *cp = &sp->parm.capture;
 
@@ -1512,45 +1429,17 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 	v4l2_ctrl_new_custom(hdl, &solo_osd_text_ctrl, NULL);
 	if (hdl->error) {
 		ret = hdl->error;
-		v4l2_ctrl_handler_free(hdl);
-		kfree(solo_enc);
-		return ERR_PTR(ret);
-	}
-
-	solo_enc->vfd = video_device_alloc();
-	if (!solo_enc->vfd) {
-		v4l2_ctrl_handler_free(hdl);
-		kfree(solo_enc);
-		return ERR_PTR(-ENOMEM);
+		goto hdl_free;
 	}
 
 	solo_enc->solo_dev = solo_dev;
 	solo_enc->ch = ch;
-
-	*solo_enc->vfd = solo_enc_template;
-	solo_enc->vfd->v4l2_dev = &solo_dev->v4l2_dev;
-	solo_enc->vfd->ctrl_handler = hdl;
-	set_bit(V4L2_FL_USE_FH_PRIO, &solo_enc->vfd->flags);
-	ret = video_register_device(solo_enc->vfd, VFL_TYPE_GRABBER, nr);
-	if (ret < 0) {
-		video_device_release(solo_enc->vfd);
-		v4l2_ctrl_handler_free(hdl);
-		kfree(solo_enc);
-		return ERR_PTR(ret);
-	}
-
-	video_set_drvdata(solo_enc->vfd, solo_enc);
-
-	snprintf(solo_enc->vfd->name, sizeof(solo_enc->vfd->name),
-		 "%s-enc (%i/%i)", SOLO6X10_NAME, solo_dev->vfd->num,
-		 solo_enc->vfd->num);
-
-	INIT_LIST_HEAD(&solo_enc->listeners);
-	mutex_init(&solo_enc->enable_lock);
-	spin_lock_init(&solo_enc->motion_lock);
+	spin_lock_init(&solo_enc->av_lock);
+	INIT_LIST_HEAD(&solo_enc->vidq_active);
+	solo_enc->fmt = V4L2_PIX_FMT_MPEG;
+	solo_enc->type = SOLO_ENC_TYPE_STD;
 
 	atomic_set(&solo_enc->readers, 0);
-	atomic_set(&solo_enc->mpeg_readers, 0);
 
 	solo_enc->qp = SOLO_DEFAULT_QP;
 	solo_enc->gop = solo_dev->fps;
@@ -1558,15 +1447,65 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 	solo_enc->mode = SOLO_ENC_MODE_CIF;
 	solo_enc->motion_thresh = SOLO_DEF_MOT_THRESH;
 
-	mutex_lock(&solo_enc->enable_lock);
+	spin_lock(&solo_enc->av_lock);
 	solo_update_mode(solo_enc);
-	mutex_unlock(&solo_enc->enable_lock);
+	spin_unlock(&solo_enc->av_lock);
+
+	mutex_init(&solo_enc->enable_lock);
+	spin_lock_init(&solo_enc->motion_lock);
+
+	atomic_set(&solo_enc->readers, 0);
+	atomic_set(&solo_enc->mpeg_readers, 0);
 
 	/* Initialize this per encoder */
 	solo_enc->jpeg_len = sizeof(jpeg_header);
 	memcpy(solo_enc->jpeg_header, jpeg_header, solo_enc->jpeg_len);
 
+	solo_enc->desc_nelts = 32;
+	solo_enc->desc_items = pci_alloc_consistent(solo_dev->pdev,
+				      sizeof(struct solo_p2m_desc) *
+				      solo_enc->desc_nelts, &solo_enc->desc_dma);
+	ret = -ENOMEM;
+	if (solo_enc->desc_items == NULL)
+		goto hdl_free;
+
+	videobuf_queue_sg_init(&solo_enc->vidq, &solo_enc_video_qops,
+				&solo_dev->pdev->dev,
+				&solo_enc->av_lock,
+				V4L2_BUF_TYPE_VIDEO_CAPTURE,
+				V4L2_FIELD_INTERLACED,
+				sizeof(struct solo_videobuf),
+				solo_enc, NULL);
+
+	solo_enc->vfd = video_device_alloc();
+	if (!solo_enc->vfd)
+		goto pci_free;
+
+	*solo_enc->vfd = solo_enc_template;
+	solo_enc->vfd->v4l2_dev = &solo_dev->v4l2_dev;
+	solo_enc->vfd->ctrl_handler = hdl;
+	set_bit(V4L2_FL_USE_FH_PRIO, &solo_enc->vfd->flags);
+	video_set_drvdata(solo_enc->vfd, solo_enc);
+	ret = video_register_device(solo_enc->vfd, VFL_TYPE_GRABBER, nr);
+	if (ret < 0)
+		goto vdev_release;
+
+	snprintf(solo_enc->vfd->name, sizeof(solo_enc->vfd->name),
+		 "%s-enc (%i/%i)", SOLO6X10_NAME, solo_dev->vfd->num,
+		 solo_enc->vfd->num);
+
 	return solo_enc;
+
+vdev_release:
+	video_device_release(solo_enc->vfd);
+pci_free:
+	pci_free_consistent(solo_enc->solo_dev->pdev,
+			sizeof(struct solo_p2m_desc) * solo_enc->desc_nelts,
+			solo_enc->desc_items, solo_enc->desc_dma);
+hdl_free:
+	v4l2_ctrl_handler_free(hdl);
+	kfree(solo_enc);
+	return ERR_PTR(ret);
 }
 
 static void solo_enc_free(struct solo_enc_dev *solo_enc)
@@ -1605,6 +1544,7 @@ int solo_enc_v4l2_init(struct solo_dev *solo_dev, unsigned nr)
 			solo_enc_free(solo_dev->v4l2_enc[i]);
 		pci_free_consistent(solo_dev->pdev, solo_dev->vh_size,
 				    solo_dev->vh_buf, solo_dev->vh_dma);
+		solo_dev->vh_buf = NULL;
 		return ret;
 	}
 
@@ -1627,6 +1567,7 @@ void solo_enc_v4l2_exit(struct solo_dev *solo_dev)
 	for (i = 0; i < solo_dev->nr_chans; i++)
 		solo_enc_free(solo_dev->v4l2_enc[i]);
 
-	pci_free_consistent(solo_dev->pdev, solo_dev->vh_size,
+	if (solo_dev->vh_buf)
+		pci_free_consistent(solo_dev->pdev, solo_dev->vh_size,
 			    solo_dev->vh_buf, solo_dev->vh_dma);
 }
-- 
1.7.10.4

