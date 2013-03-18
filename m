Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1887 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3CRMci (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 08:32:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 09/19] solo6x10: convert encoder nodes to vb2.
Date: Mon, 18 Mar 2013 13:32:08 +0100
Message-Id: <1363609938-21735-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
References: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

As a consequence the ioctl op has been replaced by unlocked_ioctl.

Since we are now using the core lock the locking scheme has been
simplified as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/Kconfig    |    1 +
 drivers/staging/media/solo6x10/solo6x10.h |   13 +-
 drivers/staging/media/solo6x10/v4l2-enc.c |  505 ++++++++---------------------
 3 files changed, 140 insertions(+), 379 deletions(-)

diff --git a/drivers/staging/media/solo6x10/Kconfig b/drivers/staging/media/solo6x10/Kconfig
index 63352de..f93b4ca 100644
--- a/drivers/staging/media/solo6x10/Kconfig
+++ b/drivers/staging/media/solo6x10/Kconfig
@@ -2,6 +2,7 @@ config SOLO6X10
 	tristate "Softlogic 6x10 MPEG codec cards"
 	depends on PCI && VIDEO_DEV && SND && I2C
 	select VIDEOBUF_DMA_SG
+	select VIDEOBUF2_DMA_SG
 	select SND_PCM
 	---help---
 	  This driver supports the Softlogic based MPEG-4 and h.264 codec
diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index cf88db3..5b21178 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -40,6 +40,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 #include <media/videobuf-core.h>
+#include <media/videobuf2-core.h>
 
 #include "registers.h"
 
@@ -135,6 +136,11 @@ struct solo_p2m_dev {
 
 #define OSD_TEXT_MAX		44
 
+struct solo_vb2_buf {
+	struct vb2_buffer vb;
+	struct list_head list;
+};
+
 enum solo_enc_types {
 	SOLO_ENC_TYPE_STD,
 	SOLO_ENC_TYPE_EXT,
@@ -146,10 +152,8 @@ struct solo_enc_dev {
 	struct v4l2_ctrl_handler hdl;
 	struct video_device	*vfd;
 	/* General accounting */
-	struct mutex		enable_lock;
+	struct mutex		lock;
 	spinlock_t		motion_lock;
-	atomic_t		readers;
-	atomic_t		mpeg_readers;
 	u8			ch;
 	u8			mode, gop, qp, interlaced, interval;
 	u8			bw_weight;
@@ -169,9 +173,8 @@ struct solo_enc_dev {
 	int			jpeg_len;
 
 	u32			fmt;
-	u8			enc_on;
 	enum solo_enc_types	type;
-	struct videobuf_queue	vidq;
+	struct vb2_queue	vidq;
 	struct list_head	vidq_active;
 	int			desc_count;
 	int			desc_nelts;
diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index 65609c1..eb82299 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -30,7 +30,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-event.h>
-#include <media/videobuf-dma-sg.h>
+#include <media/videobuf2-dma-sg.h>
 
 #include "solo6x10.h"
 #include "tw28.h"
@@ -181,7 +181,6 @@ static void solo_motion_toggle(struct solo_enc_dev *solo_enc, int on)
 	spin_unlock_irqrestore(&solo_enc->motion_lock, flags);
 }
 
-/* MUST be called with solo_enc->enable_lock held */
 static void solo_update_mode(struct solo_enc_dev *solo_enc)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
@@ -264,43 +263,22 @@ static void solo_update_mode(struct solo_enc_dev *solo_enc)
 	       jpeg_dqt[solo_g_jpeg_qp(solo_dev, solo_enc->ch)], DQT_LEN);
 }
 
-/* MUST be called with solo_enc->enable_lock held */
-static int __solo_enc_on(struct solo_enc_dev *solo_enc)
+static int solo_enc_on(struct solo_enc_dev *solo_enc)
 {
 	u8 ch = solo_enc->ch;
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	u8 interval;
 
-	BUG_ON(!mutex_is_locked(&solo_enc->enable_lock));
-
-	if (solo_enc->enc_on)
-		return 0;
-
 	solo_update_mode(solo_enc);
 
-	/* Make sure to bw check on first reader */
-	if (!atomic_read(&solo_enc->readers)) {
-		if (solo_enc->bw_weight > solo_dev->enc_bw_remain)
-			return -EBUSY;
-		else
-			solo_dev->enc_bw_remain -= solo_enc->bw_weight;
-	}
-
-	solo_enc->enc_on = 1;
+	/* Make sure to do a bandwidth check */
+	if (solo_enc->bw_weight > solo_dev->enc_bw_remain)
+		return -EBUSY;
+	solo_dev->enc_bw_remain -= solo_enc->bw_weight;
 
 	if (solo_enc->type == SOLO_ENC_TYPE_EXT)
 		solo_reg_write(solo_dev, SOLO_CAP_CH_COMP_ENA_E(ch), 1);
 
-	/* Reset the encoder if we are the first mpeg reader, else only reset
-	 * on the first mjpeg reader. */
-	if (solo_enc->fmt == V4L2_PIX_FMT_MPEG) {
-		atomic_inc(&solo_enc->readers);
-		if (atomic_inc_return(&solo_enc->mpeg_readers) > 1)
-			return 0;
-	} else if (atomic_inc_return(&solo_enc->readers) > 1) {
-		return 0;
-	}
-
 	/* Disable all encoding for this channel */
 	solo_reg_write(solo_dev, SOLO_CAP_CH_SCALE(ch), 0);
 
@@ -329,47 +307,16 @@ static int __solo_enc_on(struct solo_enc_dev *solo_enc)
 	return 0;
 }
 
-static int solo_enc_on(struct solo_enc_dev *solo_enc)
-{
-	int ret;
-
-	mutex_lock(&solo_enc->enable_lock);
-	ret = __solo_enc_on(solo_enc);
-	mutex_unlock(&solo_enc->enable_lock);
-
-	return ret;
-}
-
-static void __solo_enc_off(struct solo_enc_dev *solo_enc)
+static void solo_enc_off(struct solo_enc_dev *solo_enc)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
-	BUG_ON(!mutex_is_locked(&solo_enc->enable_lock));
-
-	if (!solo_enc->enc_on)
-		return;
-
-	solo_enc->enc_on = 0;
-
-	if (solo_enc->fmt == V4L2_PIX_FMT_MPEG)
-		atomic_dec(&solo_enc->mpeg_readers);
-
-	if (atomic_dec_return(&solo_enc->readers) > 0)
-		return;
-
 	solo_dev->enc_bw_remain += solo_enc->bw_weight;
 
 	solo_reg_write(solo_dev, SOLO_CAP_CH_SCALE(solo_enc->ch), 0);
 	solo_reg_write(solo_dev, SOLO_CAP_CH_COMP_ENA_E(solo_enc->ch), 0);
 }
 
-static void solo_enc_off(struct solo_enc_dev *solo_enc)
-{
-	mutex_lock(&solo_enc->enable_lock);
-	__solo_enc_off(solo_enc);
-	mutex_unlock(&solo_enc->enable_lock);
-}
-
 static int enc_get_mpeg_dma(struct solo_dev *solo_dev, dma_addr_t dma,
 			      unsigned int off, unsigned int size)
 {
@@ -403,7 +350,7 @@ static int enc_get_mpeg_dma(struct solo_dev *solo_dev, dma_addr_t dma,
 /* Build a descriptor queue out of an SG list and send it to the P2M for
  * processing. */
 static int solo_send_desc(struct solo_enc_dev *solo_enc, int skip,
-			  struct videobuf_dmabuf *vbuf, int off, int size,
+			  struct vb2_dma_sg_desc *vbuf, int off, int size,
 			  unsigned int base, unsigned int base_size)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
@@ -416,7 +363,7 @@ static int solo_send_desc(struct solo_enc_dev *solo_enc, int skip,
 
 	solo_enc->desc_count = 1;
 
-	for_each_sg(vbuf->sglist, sg, vbuf->sglen, i) {
+	for_each_sg(vbuf->sglist, sg, vbuf->num_pages, i) {
 		struct solo_p2m_desc *desc;
 		dma_addr_t dma;
 		int len;
@@ -487,61 +434,62 @@ static int solo_send_desc(struct solo_enc_dev *solo_enc, int skip,
 				 solo_enc->desc_count - 1);
 }
 
-static int solo_fill_jpeg(struct solo_enc_dev *solo_enc, struct videobuf_buffer *vb,
-			  struct videobuf_dmabuf *vbuf, struct vop_header *vh)
+static int solo_fill_jpeg(struct solo_enc_dev *solo_enc,
+		struct vb2_buffer *vb, struct vop_header *vh)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
-	struct solo_videobuf *svb = (struct solo_videobuf *)vb;
+	struct vb2_dma_sg_desc *vbuf = vb2_dma_sg_plane_desc(vb, 0);
 	int frame_size;
+	int ret;
 
-	svb->flags |= V4L2_BUF_FLAG_KEYFRAME;
+	vb->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
 
-	if (vb->bsize < (vh->jpeg_size + solo_enc->jpeg_len))
+	if (vb2_plane_size(vb, 0) < vh->jpeg_size + solo_enc->jpeg_len)
 		return -EIO;
 
-	vb->width = solo_enc->width;
-	vb->height = solo_enc->height;
-	vb->size = vh->jpeg_size + solo_enc->jpeg_len;
-
-	sg_copy_from_buffer(vbuf->sglist, vbuf->sglen,
-			    solo_enc->jpeg_header,
-			    solo_enc->jpeg_len);
+	sg_copy_from_buffer(vbuf->sglist, vbuf->num_pages,
+			solo_enc->jpeg_header,
+			solo_enc->jpeg_len);
 
 	frame_size = (vh->jpeg_size + solo_enc->jpeg_len + (DMA_ALIGN - 1))
 		& ~(DMA_ALIGN - 1);
-
-	return solo_send_desc(solo_enc, solo_enc->jpeg_len, vbuf, vh->jpeg_off,
-			      frame_size, SOLO_JPEG_EXT_ADDR(solo_dev),
-			      SOLO_JPEG_EXT_SIZE(solo_dev));
+	vb2_set_plane_payload(vb, 0, vh->jpeg_size + solo_enc->jpeg_len);
+
+	dma_map_sg(&solo_dev->pdev->dev, vbuf->sglist, vbuf->num_pages,
+			DMA_FROM_DEVICE);
+	ret = solo_send_desc(solo_enc, solo_enc->jpeg_len, vbuf, vh->jpeg_off,
+			frame_size, SOLO_JPEG_EXT_ADDR(solo_dev),
+			SOLO_JPEG_EXT_SIZE(solo_dev));
+	dma_unmap_sg(&solo_dev->pdev->dev, vbuf->sglist, vbuf->num_pages,
+			DMA_FROM_DEVICE);
+	return ret;
 }
 
-static int solo_fill_mpeg(struct solo_enc_dev *solo_enc, struct videobuf_buffer *vb,
-			  struct videobuf_dmabuf *vbuf, struct vop_header *vh)
+static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
+		struct vb2_buffer *vb, struct vop_header *vh)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
-	struct solo_videobuf *svb = (struct solo_videobuf *)vb;
+	struct vb2_dma_sg_desc *vbuf = vb2_dma_sg_plane_desc(vb, 0);
 	int frame_off, frame_size;
 	int skip = 0;
+	int ret;
 
-	if (vb->bsize < vh->mpeg_size)
+	if (vb2_plane_size(vb, 0) < vh->mpeg_size)
 		return -EIO;
 
-	vb->width = vh->hsize << 4;
-	vb->height = vh->vsize << 4;
-	vb->size = vh->mpeg_size;
-
 	/* If this is a key frame, add extra header */
 	if (!vh->vop_type) {
-		sg_copy_from_buffer(vbuf->sglist, vbuf->sglen,
-				    solo_enc->vop,
-				    solo_enc->vop_len);
+		sg_copy_from_buffer(vbuf->sglist, vbuf->num_pages,
+				solo_enc->vop,
+				solo_enc->vop_len);
 
 		skip = solo_enc->vop_len;
-		vb->size += solo_enc->vop_len;
 
-		svb->flags |= V4L2_BUF_FLAG_KEYFRAME;
+		vb->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
+		vb2_set_plane_payload(vb, 0, vh->mpeg_size + solo_enc->vop_len);
 	} else {
-		svb->flags |= V4L2_BUF_FLAG_PFRAME;
+		vb->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
+		vb2_set_plane_payload(vb, 0, vh->mpeg_size);
 	}
 
 	/* Now get the actual mpeg payload */
@@ -550,93 +498,67 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc, struct videobuf_buffer
 	frame_size = (vh->mpeg_size + skip + (DMA_ALIGN - 1))
 		& ~(DMA_ALIGN - 1);
 
-	return solo_send_desc(solo_enc, skip, vbuf, frame_off, frame_size,
-			      SOLO_MP4E_EXT_ADDR(solo_dev),
-			      SOLO_MP4E_EXT_SIZE(solo_dev));
+	dma_map_sg(&solo_dev->pdev->dev, vbuf->sglist, vbuf->num_pages,
+			DMA_FROM_DEVICE);
+	ret = solo_send_desc(solo_enc, skip, vbuf, frame_off, frame_size,
+			SOLO_MP4E_EXT_ADDR(solo_dev),
+			SOLO_MP4E_EXT_SIZE(solo_dev));
+	dma_unmap_sg(&solo_dev->pdev->dev, vbuf->sglist, vbuf->num_pages,
+			DMA_FROM_DEVICE);
+	return ret;
 }
 
 static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
-			    struct videobuf_buffer *vb,
-			    struct solo_enc_buf *enc_buf)
+			    struct vb2_buffer *vb, struct solo_enc_buf *enc_buf)
 {
-	struct solo_videobuf *svb = (struct solo_videobuf *)vb;
-	struct videobuf_dmabuf *vbuf = NULL;
 	struct vop_header *vh = enc_buf->vh;
 	int ret;
 
-	vbuf = videobuf_to_dma(vb);
-	if (WARN_ON_ONCE(!vbuf)) {
-		ret = -EIO;
-		goto vbuf_error;
-	}
-
-	/* Setup some common flags for both types */
-	svb->flags = V4L2_BUF_FLAG_TIMECODE;
-	vb->ts.tv_sec = vh->sec;
-	vb->ts.tv_usec = vh->usec;
-
 	/* Check for motion flags */
 	if (solo_is_motion_on(solo_enc)) {
-		svb->flags |= V4L2_BUF_FLAG_MOTION_ON;
+		vb->v4l2_buf.flags |= V4L2_BUF_FLAG_MOTION_ON;
 		if (enc_buf->motion)
-			svb->flags |= V4L2_BUF_FLAG_MOTION_DETECTED;
+			vb->v4l2_buf.flags |= V4L2_BUF_FLAG_MOTION_DETECTED;
 	}
 
 	if (solo_enc->fmt == V4L2_PIX_FMT_MPEG)
-		ret = solo_fill_mpeg(solo_enc, vb, vbuf, vh);
+		ret = solo_fill_mpeg(solo_enc, vb, vh);
 	else
-		ret = solo_fill_jpeg(solo_enc, vb, vbuf, vh);
-
-vbuf_error:
-	/* On error, we push this buffer back into the queue. The
-	 * videobuf-core doesn't handle error packets very well. Plus
-	 * we recover nicely internally anyway. */
-	if (ret) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&solo_enc->av_lock, flags);
-		list_add(&vb->queue, &solo_enc->vidq_active);
-		vb->state = VIDEOBUF_QUEUED;
-		spin_unlock_irqrestore(&solo_enc->av_lock, flags);
-	} else {
-		vb->state = VIDEOBUF_DONE;
-		vb->field_count++;
-		vb->width = solo_enc->width;
-		vb->height = solo_enc->height;
+		ret = solo_fill_jpeg(solo_enc, vb, vh);
 
-		wake_up(&vb->done);
+	if (!ret) {
+		vb->v4l2_buf.sequence++;
+		vb->v4l2_buf.timestamp.tv_sec = vh->sec;
+		vb->v4l2_buf.timestamp.tv_usec = vh->usec;
 	}
 
+	vb2_buffer_done(vb, ret ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+
 	return ret;
 }
 
 static void solo_enc_handle_one(struct solo_enc_dev *solo_enc,
 				struct solo_enc_buf *enc_buf)
 {
-	struct videobuf_buffer *vb;
+	struct solo_vb2_buf *vb;
 	unsigned long flags;
 
-	mutex_lock(&solo_enc->enable_lock);
-
+	mutex_lock(&solo_enc->lock);
 	if (solo_enc->type != enc_buf->type)
 		goto unlock;
 
-	if (list_empty(&solo_enc->vidq_active))
-		goto unlock;
-
 	spin_lock_irqsave(&solo_enc->av_lock, flags);
-
-	vb = list_first_entry(&solo_enc->vidq_active,
-			struct videobuf_buffer, queue);
-
-	list_del(&vb->queue);
-	vb->state = VIDEOBUF_ACTIVE;
-
+	if (list_empty(&solo_enc->vidq_active)) {
+		spin_unlock_irqrestore(&solo_enc->av_lock, flags);
+		goto unlock;
+	}
+	vb = list_first_entry(&solo_enc->vidq_active, struct solo_vb2_buf, list);
+	list_del(&vb->list);
 	spin_unlock_irqrestore(&solo_enc->av_lock, flags);
 
-	solo_enc_fillbuf(solo_enc, vb, enc_buf);
+	solo_enc_fillbuf(solo_enc, &vb->vb, enc_buf);
 unlock:
-	mutex_unlock(&solo_enc->enable_lock);
+	mutex_unlock(&solo_enc->lock);
 }
 
 void solo_enc_v4l2_isr(struct solo_dev *solo_dev)
@@ -723,85 +645,29 @@ static int solo_ring_thread(void *data)
 	return 0;
 }
 
-static int solo_enc_buf_setup(struct videobuf_queue *vq, unsigned int *count,
-			      unsigned int *size)
-{
-	*size = FRAME_BUF_SIZE;
-
-	if (*count < MIN_VID_BUFFERS)
-		*count = MIN_VID_BUFFERS;
-
-	return 0;
-}
-
-static int solo_enc_buf_prepare(struct videobuf_queue *vq,
-				struct videobuf_buffer *vb,
-				enum v4l2_field field)
+static int solo_enc_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+			   unsigned int *num_buffers, unsigned int *num_planes,
+			   unsigned int sizes[], void *alloc_ctxs[])
 {
-	vb->size = FRAME_BUF_SIZE;
-	if (vb->baddr != 0 && vb->bsize < vb->size)
-		return -EINVAL;
-
-	/* This property only change when queue is idle */
-	vb->field = field;
+	sizes[0] = FRAME_BUF_SIZE;
+	*num_planes = 1;
 
-	if (vb->state == VIDEOBUF_NEEDS_INIT) {
-		int rc = videobuf_iolock(vq, vb, NULL);
-		if (rc < 0) {
-			struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
-			videobuf_dma_unmap(vq->dev, dma);
-			videobuf_dma_free(dma);
-
-			return rc;
-		}
-	}
-	vb->state = VIDEOBUF_PREPARED;
+	if (*num_buffers < MIN_VID_BUFFERS)
+		*num_buffers = MIN_VID_BUFFERS;
 
 	return 0;
 }
 
-static void solo_enc_buf_queue(struct videobuf_queue *vq,
-			       struct videobuf_buffer *vb)
+static void solo_enc_buf_queue(struct vb2_buffer *vb)
 {
-	struct solo_enc_dev *solo_enc = vq->priv_data;
-
-	vb->state = VIDEOBUF_QUEUED;
-	list_add_tail(&vb->queue, &solo_enc->vidq_active);
-}
-
-static void solo_enc_buf_release(struct videobuf_queue *vq,
-				 struct videobuf_buffer *vb)
-{
-	struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
-	videobuf_dma_unmap(vq->dev, dma);
-	videobuf_dma_free(dma);
-	vb->state = VIDEOBUF_NEEDS_INIT;
-}
-
-static const struct videobuf_queue_ops solo_enc_video_qops = {
-	.buf_setup	= solo_enc_buf_setup,
-	.buf_prepare	= solo_enc_buf_prepare,
-	.buf_queue	= solo_enc_buf_queue,
-	.buf_release	= solo_enc_buf_release,
-};
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct solo_enc_dev *solo_enc = vb2_get_drv_priv(vq);
+	struct solo_vb2_buf *solo_vb =
+		container_of(vb, struct solo_vb2_buf, vb);
 
-static unsigned int solo_enc_poll(struct file *file,
-				  struct poll_table_struct *wait)
-{
-	struct solo_enc_dev *solo_enc = video_drvdata(file);
-	unsigned long req_events = poll_requested_events(wait);
-	unsigned res = v4l2_ctrl_poll(file, wait);
-
-	if (!(req_events & (POLLIN | POLLRDNORM)))
-		return res;
-	return videobuf_poll_stream(file, &solo_enc->vidq, wait);
-}
-
-static int solo_enc_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct solo_enc_dev *solo_enc = video_drvdata(file);
-
-	return videobuf_mmap_mapper(&solo_enc->vidq, vma);
+	spin_lock(&solo_enc->av_lock);
+	list_add_tail(&solo_vb->list, &solo_enc->vidq_active);
+	spin_unlock(&solo_enc->av_lock);
 }
 
 static int solo_ring_start(struct solo_dev *solo_dev)
@@ -835,50 +701,36 @@ static void solo_ring_stop(struct solo_dev *solo_dev)
 	solo_irq_off(solo_dev, SOLO_IRQ_ENCODER);
 }
 
-static int solo_enc_open(struct file *file)
+static int solo_enc_start_streaming(struct vb2_queue *q, unsigned int count)
 {
-	struct solo_enc_dev *solo_enc = video_drvdata(file);
-	struct solo_dev *solo_dev = solo_enc->solo_dev;
-	int ret = v4l2_fh_open(file);
-
-	if (ret)
-		return ret;
-	ret = solo_ring_start(solo_dev);
-	if (ret) {
-		v4l2_fh_release(file);
-		return ret;
-	}
-	return 0;
-}
-
-static ssize_t solo_enc_read(struct file *file, char __user *data,
-			     size_t count, loff_t *ppos)
-{
-	struct solo_enc_dev *solo_enc = video_drvdata(file);
+	struct solo_enc_dev *solo_enc = vb2_get_drv_priv(q);
 	int ret;
 
-	/* Make sure the encoder is on */
 	ret = solo_enc_on(solo_enc);
 	if (ret)
 		return ret;
-
-	return videobuf_read_stream(&solo_enc->vidq, data, count, ppos, 0,
-				    file->f_flags & O_NONBLOCK);
+	return solo_ring_start(solo_enc->solo_dev);
 }
 
-static int solo_enc_release(struct file *file)
+static int solo_enc_stop_streaming(struct vb2_queue *q)
 {
-	struct solo_enc_dev *solo_enc = video_drvdata(file);
-	struct solo_dev *solo_dev = solo_enc->solo_dev;
+	struct solo_enc_dev *solo_enc = vb2_get_drv_priv(q);
 
 	solo_enc_off(solo_enc);
-	videobuf_stop(&solo_enc->vidq);
-	videobuf_mmap_free(&solo_enc->vidq);
-	solo_ring_stop(solo_dev);
-
-	return v4l2_fh_release(file);
+	INIT_LIST_HEAD(&solo_enc->vidq_active);
+	solo_ring_stop(solo_enc->solo_dev);
+	return 0;
 }
 
+static struct vb2_ops solo_enc_video_qops = {
+	.queue_setup	= solo_enc_queue_setup,
+	.buf_queue	= solo_enc_buf_queue,
+	.start_streaming = solo_enc_start_streaming,
+	.stop_streaming = solo_enc_stop_streaming,
+	.wait_prepare	= vb2_ops_wait_prepare,
+	.wait_finish	= vb2_ops_wait_finish,
+};
+
 static int solo_enc_querycap(struct file *file, void  *priv,
 			     struct v4l2_capability *cap)
 {
@@ -1007,23 +859,13 @@ static int solo_enc_set_fmt_cap(struct file *file, void *priv,
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	int ret;
 
-	mutex_lock(&solo_enc->enable_lock);
+	if (vb2_is_busy(&solo_enc->vidq))
+		return -EBUSY;
 
 	ret = solo_enc_try_fmt_cap(file, priv, f);
 	if (ret)
 		return ret;
 
-	/* We cannot change width/height in mid read */
-	if (!ret && atomic_read(&solo_enc->readers) > 0) {
-		if (pix->width != solo_enc->width ||
-		    pix->height != solo_enc->height)
-			ret = -EBUSY;
-	}
-	if (ret) {
-		mutex_unlock(&solo_enc->enable_lock);
-		return ret;
-	}
-
 	if (pix->width == solo_dev->video_hsize)
 		solo_enc->mode = SOLO_ENC_MODE_D1;
 	else
@@ -1034,9 +876,6 @@ static int solo_enc_set_fmt_cap(struct file *file, void *priv,
 
 	if (pix->priv)
 		solo_enc->type = SOLO_ENC_TYPE_EXT;
-
-	mutex_unlock(&solo_enc->enable_lock);
-
 	return 0;
 }
 
@@ -1058,80 +897,6 @@ static int solo_enc_get_fmt_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int solo_enc_reqbufs(struct file *file, void *priv,
-			    struct v4l2_requestbuffers *req)
-{
-	struct solo_enc_dev *solo_enc = video_drvdata(file);
-
-	return videobuf_reqbufs(&solo_enc->vidq, req);
-}
-
-static int solo_enc_querybuf(struct file *file, void *priv,
-			     struct v4l2_buffer *buf)
-{
-	struct solo_enc_dev *solo_enc = video_drvdata(file);
-
-	return videobuf_querybuf(&solo_enc->vidq, buf);
-}
-
-static int solo_enc_qbuf(struct file *file, void *priv,
-			 struct v4l2_buffer *buf)
-{
-	struct solo_enc_dev *solo_enc = video_drvdata(file);
-
-	return videobuf_qbuf(&solo_enc->vidq, buf);
-}
-
-static int solo_enc_dqbuf(struct file *file, void *priv,
-			  struct v4l2_buffer *buf)
-{
-	struct solo_enc_dev *solo_enc = video_drvdata(file);
-	struct solo_videobuf *svb;
-	int ret;
-
-	/* Make sure the encoder is on */
-	ret = solo_enc_on(solo_enc);
-	if (ret)
-		return ret;
-
-	ret = videobuf_dqbuf(&solo_enc->vidq, buf, file->f_flags & O_NONBLOCK);
-	if (ret)
-		return ret;
-
-	/* Copy over the flags */
-	svb = (struct solo_videobuf *)solo_enc->vidq.bufs[buf->index];
-	buf->flags |= svb->flags;
-
-	return 0;
-}
-
-static int solo_enc_streamon(struct file *file, void *priv,
-			     enum v4l2_buf_type i)
-{
-	struct solo_enc_dev *solo_enc = video_drvdata(file);
-
-	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	return videobuf_streamon(&solo_enc->vidq);
-}
-
-static int solo_enc_streamoff(struct file *file, void *priv,
-			      enum v4l2_buf_type i)
-{
-	struct solo_enc_dev *solo_enc = video_drvdata(file);
-	int ret;
-
-	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	ret = videobuf_streamoff(&solo_enc->vidq);
-	if (!ret)
-		solo_enc_off(solo_enc);
-
-	return ret;
-}
-
 static int solo_enc_s_std(struct file *file, void *priv, v4l2_std_id *i)
 {
 	return 0;
@@ -1220,12 +985,8 @@ static int solo_s_parm(struct file *file, void *priv,
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct v4l2_captureparm *cp = &sp->parm.capture;
 
-	mutex_lock(&solo_enc->enable_lock);
-
-	if (atomic_read(&solo_enc->mpeg_readers) > 0) {
-		mutex_unlock(&solo_enc->enable_lock);
+	if (vb2_is_streaming(&solo_enc->vidq))
 		return -EBUSY;
-	}
 
 	if ((cp->timeperframe.numerator == 0) ||
 	    (cp->timeperframe.denominator == 0)) {
@@ -1246,9 +1007,6 @@ static int solo_s_parm(struct file *file, void *priv,
 	cp->readbuffers = 2;
 
 	solo_update_mode(solo_enc);
-
-	mutex_unlock(&solo_enc->enable_lock);
-
 	return 0;
 }
 
@@ -1297,10 +1055,8 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 		solo_motion_toggle(solo_enc, ctrl->val);
 		return 0;
 	case V4L2_CID_OSD_TEXT:
-		mutex_lock(&solo_enc->enable_lock);
 		strcpy(solo_enc->osd_text, ctrl->string);
 		err = solo_osd_print(solo_enc);
-		mutex_unlock(&solo_enc->enable_lock);
 		return err;
 	default:
 		return -EINVAL;
@@ -1311,12 +1067,12 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 
 static const struct v4l2_file_operations solo_enc_fops = {
 	.owner			= THIS_MODULE,
-	.open			= solo_enc_open,
-	.release		= solo_enc_release,
-	.read			= solo_enc_read,
-	.poll			= solo_enc_poll,
-	.mmap			= solo_enc_mmap,
-	.ioctl			= video_ioctl2,
+	.open			= v4l2_fh_open,
+	.release		= vb2_fop_release,
+	.read			= vb2_fop_read,
+	.poll			= vb2_fop_poll,
+	.mmap			= vb2_fop_mmap,
+	.unlocked_ioctl		= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops solo_enc_ioctl_ops = {
@@ -1332,12 +1088,12 @@ static const struct v4l2_ioctl_ops solo_enc_ioctl_ops = {
 	.vidioc_s_fmt_vid_cap		= solo_enc_set_fmt_cap,
 	.vidioc_g_fmt_vid_cap		= solo_enc_get_fmt_cap,
 	/* Streaming I/O */
-	.vidioc_reqbufs			= solo_enc_reqbufs,
-	.vidioc_querybuf		= solo_enc_querybuf,
-	.vidioc_qbuf			= solo_enc_qbuf,
-	.vidioc_dqbuf			= solo_enc_dqbuf,
-	.vidioc_streamon		= solo_enc_streamon,
-	.vidioc_streamoff		= solo_enc_streamoff,
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
 	/* Frame size and interval */
 	.vidioc_enum_framesizes		= solo_enum_framesizes,
 	.vidioc_enum_frameintervals	= solo_enum_frameintervals,
@@ -1434,29 +1190,36 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 
 	solo_enc->solo_dev = solo_dev;
 	solo_enc->ch = ch;
+	mutex_init(&solo_enc->lock);
 	spin_lock_init(&solo_enc->av_lock);
 	INIT_LIST_HEAD(&solo_enc->vidq_active);
 	solo_enc->fmt = V4L2_PIX_FMT_MPEG;
 	solo_enc->type = SOLO_ENC_TYPE_STD;
 
-	atomic_set(&solo_enc->readers, 0);
-
 	solo_enc->qp = SOLO_DEFAULT_QP;
 	solo_enc->gop = solo_dev->fps;
 	solo_enc->interval = 1;
 	solo_enc->mode = SOLO_ENC_MODE_CIF;
 	solo_enc->motion_thresh = SOLO_DEF_MOT_THRESH;
 
+	solo_enc->vidq.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	solo_enc->vidq.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
+	solo_enc->vidq.ops = &solo_enc_video_qops;
+	solo_enc->vidq.mem_ops = &vb2_dma_sg_memops;
+	solo_enc->vidq.drv_priv = solo_enc;
+	solo_enc->vidq.gfp_flags = __GFP_DMA32;
+	solo_enc->vidq.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	solo_enc->vidq.buf_struct_size = sizeof(struct solo_vb2_buf);
+	solo_enc->vidq.lock = &solo_enc->lock;
+	ret = vb2_queue_init(&solo_enc->vidq);
+	if (ret)
+		goto hdl_free;
 	spin_lock(&solo_enc->av_lock);
 	solo_update_mode(solo_enc);
 	spin_unlock(&solo_enc->av_lock);
 
-	mutex_init(&solo_enc->enable_lock);
 	spin_lock_init(&solo_enc->motion_lock);
 
-	atomic_set(&solo_enc->readers, 0);
-	atomic_set(&solo_enc->mpeg_readers, 0);
-
 	/* Initialize this per encoder */
 	solo_enc->jpeg_len = sizeof(jpeg_header);
 	memcpy(solo_enc->jpeg_header, jpeg_header, solo_enc->jpeg_len);
@@ -1469,14 +1232,6 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 	if (solo_enc->desc_items == NULL)
 		goto hdl_free;
 
-	videobuf_queue_sg_init(&solo_enc->vidq, &solo_enc_video_qops,
-				&solo_dev->pdev->dev,
-				&solo_enc->av_lock,
-				V4L2_BUF_TYPE_VIDEO_CAPTURE,
-				V4L2_FIELD_INTERLACED,
-				sizeof(struct solo_videobuf),
-				solo_enc, NULL);
-
 	solo_enc->vfd = video_device_alloc();
 	if (!solo_enc->vfd)
 		goto pci_free;
@@ -1484,6 +1239,8 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 	*solo_enc->vfd = solo_enc_template;
 	solo_enc->vfd->v4l2_dev = &solo_dev->v4l2_dev;
 	solo_enc->vfd->ctrl_handler = hdl;
+	solo_enc->vfd->queue = &solo_enc->vidq;
+	solo_enc->vfd->lock = &solo_enc->lock;
 	set_bit(V4L2_FL_USE_FH_PRIO, &solo_enc->vfd->flags);
 	video_set_drvdata(solo_enc->vfd, solo_enc);
 	ret = video_register_device(solo_enc->vfd, VFL_TYPE_GRABBER, nr);
-- 
1.7.10.4

