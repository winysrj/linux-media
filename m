Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4018 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab3CBXp5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 18:45:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 13/20] solo6x10: convert encoder nodes to vb2.
Date: Sun,  3 Mar 2013 00:45:29 +0100
Message-Id: <6f2aa585c403c0d866be9ecc058af28d558ddd91.1362266529.git.hans.verkuil@cisco.com>
In-Reply-To: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
References: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
References: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

As a consequence the ioctl op has been replaced by unlocked_ioctl.

Since we are now using the core lock the locking scheme has been
simplified as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/Kconfig    |    1 +
 drivers/staging/media/solo6x10/solo6x10.h |   11 +-
 drivers/staging/media/solo6x10/v4l2-enc.c |  425 +++++++++--------------------
 3 files changed, 138 insertions(+), 299 deletions(-)

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
index 2ab64cf..05c9840 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -36,6 +36,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 #include <media/videobuf-core.h>
+#include <media/videobuf2-core.h>
 #include "registers.h"
 
 #ifndef PCI_VENDOR_ID_SOFTLOGIC
@@ -153,6 +154,11 @@ enum solo_enc_types {
 	SOLO_ENC_TYPE_EXT,
 };
 
+struct solo_vb2_buf {
+	struct vb2_buffer vb;
+	struct list_head list;
+};
+
 struct solo_enc_dev {
 	struct solo_dev		*solo_dev;
 	/* V4L2 Items */
@@ -160,8 +166,8 @@ struct solo_enc_dev {
 	struct video_device	*vfd;
 	/* General accounting */
 	wait_queue_head_t	thread_wait;
+	struct mutex		lock;
 	spinlock_t		slock;
-	atomic_t		readers;
 	u8			ch;
 	u8			mode, gop, qp, interlaced, interval;
 	u8			reset_gop;
@@ -174,9 +180,8 @@ struct solo_enc_dev {
 
 	u32			fmt;
 	u16			rd_idx;
-	u8			enc_on;
 	enum solo_enc_types	type;
-	struct videobuf_queue	vidq;
+	struct vb2_queue	vidq;
 	struct list_head	vidq_active;
 	struct task_struct	*kthread;
 	struct p2m_desc		desc[SOLO_NR_P2M_DESC];
diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index 800719e..4fc8d84 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -24,7 +24,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-event.h>
-#include <media/videobuf-dma-sg.h>
+#include <media/videobuf2-dma-sg.h>
 #include "solo6x10.h"
 #include "tw28.h"
 #include "solo6x10-jpeg.h"
@@ -76,13 +76,10 @@ static void solo_motion_toggle(struct solo_enc_dev *solo_enc, int on)
 	spin_unlock(&solo_enc->slock);
 }
 
-/* Should be called with solo_enc->slock held */
 static void solo_update_mode(struct solo_enc_dev *solo_enc)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
-	assert_spin_locked(&solo_enc->slock);
-
 	solo_enc->interlaced = (solo_enc->mode & 0x08) ? 1 : 0;
 	solo_enc->bw_weight = max(solo_dev->fps / solo_enc->interval, 1);
 
@@ -101,37 +98,24 @@ static void solo_update_mode(struct solo_enc_dev *solo_enc)
 	}
 }
 
-/* Should be called with solo_enc->slock held */
 static int solo_enc_on(struct solo_enc_dev *solo_enc)
 {
 	u8 ch = solo_enc->ch;
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	u8 interval;
 
-	assert_spin_locked(&solo_enc->slock);
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
+	/* Make sure to do a bandwidth check */
+	if (solo_enc->bw_weight > solo_dev->enc_bw_remain)
+		return -EBUSY;
+	solo_dev->enc_bw_remain -= solo_enc->bw_weight;
 
-	solo_enc->enc_on = 1;
 	solo_enc->rd_idx = solo_enc->solo_dev->enc_wr_idx;
 
 	if (solo_enc->type == SOLO_ENC_TYPE_EXT)
 		solo_reg_write(solo_dev, SOLO_CAP_CH_COMP_ENA_E(ch), 1);
 
-	if (atomic_inc_return(&solo_enc->readers) > 1)
-		return 0;
-
 	/* Disable all encoding for this channel */
 	solo_reg_write(solo_dev, SOLO_CAP_CH_SCALE(ch), 0);
 
@@ -167,25 +151,14 @@ static void solo_enc_off(struct solo_enc_dev *solo_enc)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
-	if (!solo_enc->enc_on)
-		return;
-
 	if (solo_enc->kthread) {
 		kthread_stop(solo_enc->kthread);
 		solo_enc->kthread = NULL;
 	}
 
-	spin_lock(&solo_enc->slock);
 	solo_dev->enc_bw_remain += solo_enc->bw_weight;
-	solo_enc->enc_on = 0;
-
-	if (atomic_dec_return(&solo_enc->readers) > 0)
-		goto unlock;
-
 	solo_reg_write(solo_dev, SOLO_CAP_CH_SCALE(solo_enc->ch), 0);
 	solo_reg_write(solo_dev, SOLO_CAP_CH_COMP_ENA_E(solo_enc->ch), 0);
-unlock:
-	spin_unlock(&solo_enc->slock);
 }
 
 static int solo_start_thread(struct solo_enc_dev *solo_enc)
@@ -229,7 +202,7 @@ static void enc_write_sg(struct scatterlist *sglist, void *buf, int size)
 
 	for (sg = sglist; sg && size > 0; sg = sg_next(sg)) {
 		u8 *p = sg_virt(sg);
-		size_t len = sg_dma_len(sg);
+		size_t len = sg->length;
 		int i;
 
 		for (i = 0; i < len && size; i++, size--)
@@ -340,7 +313,7 @@ static int enc_get_jpeg_dma_sg(struct solo_dev *solo_dev,
 	((__off <= __chk) && ((__off + __range) >= __chk))
 
 static void solo_jpeg_header(struct solo_enc_dev *solo_enc,
-			     struct videobuf_dmabuf *vbuf)
+			     struct vb2_dma_sg_desc *vbuf)
 {
 	struct scatterlist *sg;
 	void *src = jpeg_header;
@@ -348,7 +321,7 @@ static void solo_jpeg_header(struct solo_enc_dev *solo_enc,
 	size_t to_copy = sizeof(jpeg_header);
 
 	for (sg = vbuf->sglist; sg && copied < to_copy; sg = sg_next(sg)) {
-		size_t this_copy = min(sg_dma_len(sg),
+		size_t this_copy = min(sg->length,
 				       (unsigned int)(to_copy - copied));
 		u8 *p = sg_virt(sg);
 
@@ -370,39 +343,45 @@ static void solo_jpeg_header(struct solo_enc_dev *solo_enc,
 }
 
 static int solo_fill_jpeg(struct solo_enc_dev *solo_enc, struct solo_enc_buf *enc_buf,
-			  struct videobuf_buffer *vb,
-			  struct videobuf_dmabuf *vbuf)
+			  struct vb2_buffer *vb)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
+	struct vb2_dma_sg_desc *vbuf = vb2_dma_sg_plane_desc(vb, 0);
 	int size = enc_buf->jpeg_size;
+	int ret;
+
+	vb2_set_plane_payload(vb, 0, size + sizeof(jpeg_header));
 
 	/* Copy the header first (direct write) */
 	solo_jpeg_header(solo_enc, vbuf);
 
-	vb->size = size + sizeof(jpeg_header);
-
+        dma_map_sg(&solo_enc->solo_dev->pdev->dev, vbuf->sglist, vbuf->num_pages,
+                        DMA_FROM_DEVICE);
 	/* Grab the jpeg frame */
-	return enc_get_jpeg_dma_sg(solo_dev, solo_enc->desc, vbuf->sglist,
+	ret = enc_get_jpeg_dma_sg(solo_dev, solo_enc->desc, vbuf->sglist,
 				   sizeof(jpeg_header),
 				   enc_buf->jpeg_off, size);
+        dma_unmap_sg(&solo_enc->solo_dev->pdev->dev, vbuf->sglist, vbuf->num_pages,
+                        DMA_FROM_DEVICE);
+	return ret;
 }
 
-static inline int vop_interlaced(__le32 *vh)
+static inline int vop_interlaced(const __le32 *vh)
 {
 	return (__le32_to_cpu(vh[0]) >> 30) & 1;
 }
 
-static inline u32 vop_size(__le32 *vh)
+static inline u32 vop_size(const __le32 *vh)
 {
 	return __le32_to_cpu(vh[0]) & 0xFFFFF;
 }
 
-static inline u8 vop_hsize(__le32 *vh)
+static inline u8 vop_hsize(const __le32 *vh)
 {
 	return (__le32_to_cpu(vh[1]) >> 8) & 0xFF;
 }
 
-static inline u8 vop_vsize(__le32 *vh)
+static inline u8 vop_vsize(const __le32 *vh)
 {
 	return __le32_to_cpu(vh[1]) & 0xFF;
 }
@@ -468,7 +447,7 @@ static void write_h264_end(u8 **out, unsigned *bits, int align)
 }
 
 static void mpeg4_write_vol(u8 **out, struct solo_dev *solo_dev,
-			    __le32 *vh, unsigned fps, unsigned interval)
+			    const __le32 *vh, unsigned fps, unsigned interval)
 {
 	static const u8 hdr[] = {
 		0, 0, 1, 0x00 /* video_object_start_code */,
@@ -521,7 +500,7 @@ static void mpeg4_write_vol(u8 **out, struct solo_dev *solo_dev,
 	write_mpeg4_end(out, &bits);
 }
 
-static void h264_write_vol(u8 **out, struct solo_dev *solo_dev, __le32 *vh)
+static void h264_write_vol(u8 **out, struct solo_dev *solo_dev, const __le32 *vh)
 {
 	static const u8 sps[] = {
 		0, 0, 0, 1 /* start code */, 0x67, 66 /* profile_idc */,
@@ -570,10 +549,10 @@ static void h264_write_vol(u8 **out, struct solo_dev *solo_dev, __le32 *vh)
 }
 
 static int solo_fill_mpeg(struct solo_enc_dev *solo_enc, struct solo_enc_buf *enc_buf,
-			  struct videobuf_buffer *vb,
-			  struct videobuf_dmabuf *vbuf)
+			  struct vb2_buffer *vb)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
+	struct vb2_dma_sg_desc *vbuf = vb2_dma_sg_plane_desc(vb, 0);
 
 #define VH_WORDS 16
 #define MAX_VOL_HEADER_LENGTH 64
@@ -594,9 +573,7 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc, struct solo_enc_buf *en
 	if (WARN_ON_ONCE(vop_size(vh) > enc_buf->size))
 		return -EINVAL;
 
-	vb->width = vop_hsize(vh) << 4;
-	vb->height = vop_vsize(vh) << 4;
-	vb->size = vop_size(vh);
+	vb2_set_plane_payload(vb, 0, vop_size(vh));
 
 	/* If this is a key frame, add extra m4v header */
 	if (!enc_buf->vop) {
@@ -611,8 +588,10 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc, struct solo_enc_buf *en
 		skip = out - header;
 		enc_write_sg(vbuf->sglist, header, skip);
 		/* Adjust the dma buffer past this header */
-		vb->size += skip;
+		vb2_set_plane_payload(vb, 0, vop_size(vh) + skip);
 	}
+        dma_map_sg(&solo_enc->solo_dev->pdev->dev, vbuf->sglist, vbuf->num_pages,
+                        DMA_FROM_DEVICE);
 
 	/* Now get the actual mpeg payload */
 	frame_off = (enc_buf->off + sizeof(vh)) % SOLO_MP4E_EXT_SIZE(solo_dev);
@@ -620,17 +599,20 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc, struct solo_enc_buf *en
 
 	ret = enc_get_mpeg_dma_sg(solo_dev, solo_enc->desc, vbuf->sglist,
 				  skip, frame_off, frame_size);
+        dma_unmap_sg(&solo_enc->solo_dev->pdev->dev, vbuf->sglist, vbuf->num_pages,
+                        DMA_FROM_DEVICE);
+
 	WARN_ON_ONCE(ret);
 
 	return ret;
 }
 
 static void solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
-			    struct videobuf_buffer *vb)
+			    struct vb2_buffer *vb)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct solo_enc_buf *enc_buf = NULL;
-	struct videobuf_dmabuf *vbuf;
+	struct vb2_dma_sg_desc *vbuf;
 	int ret;
 	int error = 1;
 	u16 idx = solo_enc->rd_idx;
@@ -660,43 +642,38 @@ static void solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
 		goto buf_err;
 
 	if ((solo_enc->fmt == V4L2_PIX_FMT_MPEG &&
-	     vb->bsize < enc_buf->size) ||
+	     vb2_plane_size(vb, 0) < enc_buf->size) ||
 	    (solo_enc->fmt == V4L2_PIX_FMT_MJPEG &&
-	     vb->bsize < (enc_buf->jpeg_size + sizeof(jpeg_header)))) {
+	     vb2_plane_size(vb, 0) < (enc_buf->jpeg_size + sizeof(jpeg_header)))) {
 		WARN_ON_ONCE(1);
 		goto buf_err;
 	}
 
-	vbuf = videobuf_to_dma(vb);
+	vbuf = vb2_dma_sg_plane_desc(vb, 0);
 	if (WARN_ON_ONCE(!vbuf))
 		goto buf_err;
 
 	if (solo_enc->fmt == V4L2_PIX_FMT_MPEG)
-		ret = solo_fill_mpeg(solo_enc, enc_buf, vb, vbuf);
+		ret = solo_fill_mpeg(solo_enc, enc_buf, vb);
 	else
-		ret = solo_fill_jpeg(solo_enc, enc_buf, vb, vbuf);
+		ret = solo_fill_jpeg(solo_enc, enc_buf, vb);
 
 	if (!ret)
 		error = 0;
 
 buf_err:
-	if (error) {
-		vb->state = VIDEOBUF_ERROR;
-	} else {
-		vb->field_count++;
-		vb->ts = enc_buf->ts;
-		vb->state = VIDEOBUF_DONE;
+	if (!error) {
+		vb->v4l2_buf.sequence++;
+		vb->v4l2_buf.timestamp = enc_buf->ts;
 	}
 
-	wake_up(&vb->done);
-
-	return;
+	vb2_buffer_done(vb, error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 }
 
 static void solo_enc_thread_try(struct solo_enc_dev *solo_enc)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
-	struct videobuf_buffer *vb;
+	struct solo_vb2_buf *vb;
 
 	for (;;) {
 		spin_lock(&solo_enc->slock);
@@ -708,16 +685,16 @@ static void solo_enc_thread_try(struct solo_enc_dev *solo_enc)
 			break;
 
 		vb = list_first_entry(&solo_enc->vidq_active,
-				      struct videobuf_buffer, queue);
+				      struct solo_vb2_buf, list);
 
-		if (!waitqueue_active(&vb->done))
-			break;
+		//if (!waitqueue_active(&vb->vb.vb2_queue->done_wq))
+		//	break;
 
-		list_del(&vb->queue);
+		list_del(&vb->list);
 
 		spin_unlock(&solo_enc->slock);
 
-		solo_enc_fillbuf(solo_enc, vb);
+		solo_enc_fillbuf(solo_enc, &vb->vb);
 	}
 
 	assert_spin_locked(&solo_enc->slock);
@@ -848,128 +825,61 @@ void solo_enc_v4l2_isr(struct solo_dev *solo_dev)
 	return;
 }
 
-static int solo_enc_buf_setup(struct videobuf_queue *vq, unsigned int *count,
-			      unsigned int *size)
+static int solo_enc_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+			   unsigned int *num_buffers, unsigned int *num_planes,
+			   unsigned int sizes[], void *alloc_ctxs[])
 {
-	*size = FRAME_BUF_SIZE;
+	sizes[0] = FRAME_BUF_SIZE;
+	*num_planes = 1;
 
-	if (*count < MIN_VID_BUFFERS)
-		*count = MIN_VID_BUFFERS;
+	if (*num_buffers < MIN_VID_BUFFERS)
+		*num_buffers = MIN_VID_BUFFERS;
 
 	return 0;
 }
 
-static int solo_enc_buf_prepare(struct videobuf_queue *vq,
-				struct videobuf_buffer *vb,
-				enum v4l2_field field)
+static void solo_enc_buf_queue(struct vb2_buffer *vb)
 {
-	struct solo_enc_dev *solo_enc = vq->priv_data;
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct solo_enc_dev *solo_enc = vb2_get_drv_priv(vq);
+	struct solo_vb2_buf *solo_vb =
+		container_of(vb, struct solo_vb2_buf, vb);
 
-	vb->size = FRAME_BUF_SIZE;
-	if (vb->baddr != 0 && vb->bsize < vb->size)
-		return -EINVAL;
-
-	/* These properties only change when queue is idle */
-	vb->width = solo_enc->width;
-	vb->height = solo_enc->height;
-	vb->field  = field;
-
-	if (vb->state == VIDEOBUF_NEEDS_INIT) {
-		int rc = videobuf_iolock(vq, vb, NULL);
-		if (rc < 0) {
-			struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
-			videobuf_dma_unmap(vq->dev, dma);
-			videobuf_dma_free(dma);
-			vb->state = VIDEOBUF_NEEDS_INIT;
-			return rc;
-		}
-	}
-	vb->state = VIDEOBUF_PREPARED;
-
-	return 0;
+	spin_lock(&solo_enc->slock);
+	list_add_tail(&solo_vb->list, &solo_enc->vidq_active);
+	spin_unlock(&solo_enc->slock);
+	wake_up_interruptible(&solo_enc->thread_wait);
 }
 
-static void solo_enc_buf_queue(struct videobuf_queue *vq,
-			       struct videobuf_buffer *vb)
+static int solo_enc_start_streaming(struct vb2_queue *q, unsigned int count)
 {
-	struct solo_enc_dev *solo_enc = vq->priv_data;
+	struct solo_enc_dev *solo_enc = vb2_get_drv_priv(q);
+	int ret;
 
-	vb->state = VIDEOBUF_QUEUED;
-	list_add_tail(&vb->queue, &solo_enc->vidq_active);
-	wake_up_interruptible(&solo_enc->thread_wait);
+	ret = solo_enc_on(solo_enc);
+	if (ret)
+		return ret;
+	return solo_start_thread(solo_enc);
 }
 
-static void solo_enc_buf_release(struct videobuf_queue *vq,
-				 struct videobuf_buffer *vb)
+static int solo_enc_stop_streaming(struct vb2_queue *q)
 {
-	struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
+	struct solo_enc_dev *solo_enc = vb2_get_drv_priv(q);
 
-	videobuf_dma_unmap(vq->dev, dma);
-	videobuf_dma_free(dma);
-	vb->state = VIDEOBUF_NEEDS_INIT;
+	solo_enc_off(solo_enc);
+	INIT_LIST_HEAD(&solo_enc->vidq_active);
+	return 0;
 }
 
-static struct videobuf_queue_ops solo_enc_video_qops = {
-	.buf_setup	= solo_enc_buf_setup,
-	.buf_prepare	= solo_enc_buf_prepare,
+static struct vb2_ops solo_enc_video_qops = {
+	.queue_setup	= solo_enc_queue_setup,
 	.buf_queue	= solo_enc_buf_queue,
-	.buf_release	= solo_enc_buf_release,
+	.start_streaming = solo_enc_start_streaming,
+	.stop_streaming = solo_enc_stop_streaming,
+	.wait_prepare	= vb2_ops_wait_prepare,
+	.wait_finish	= vb2_ops_wait_finish,
 };
 
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
-}
-
-static ssize_t solo_enc_read(struct file *file, char __user *data,
-			     size_t count, loff_t *ppos)
-{
-	struct solo_enc_dev *solo_enc = video_drvdata(file);
-
-	/* Make sure the encoder is on */
-	if (!solo_enc->enc_on) {
-		int ret;
-
-		spin_lock(&solo_enc->slock);
-		ret = solo_enc_on(solo_enc);
-		spin_unlock(&solo_enc->slock);
-		if (ret)
-			return ret;
-
-		ret = solo_start_thread(solo_enc);
-		if (ret)
-			return ret;
-	}
-
-	return videobuf_read_stream(&solo_enc->vidq, data, count, ppos, 0,
-				    file->f_flags & O_NONBLOCK);
-}
-
-static int solo_enc_release(struct file *file)
-{
-	struct solo_enc_dev *solo_enc = video_drvdata(file);
-
-	videobuf_stop(&solo_enc->vidq);
-	videobuf_mmap_free(&solo_enc->vidq);
-
-	solo_enc_off(solo_enc);
-	return v4l2_fh_release(file);
-}
-
 static int solo_enc_querycap(struct file *file, void  *priv,
 			     struct v4l2_capability *cap)
 {
@@ -1097,23 +1007,13 @@ static int solo_enc_set_fmt_cap(struct file *file, void *priv,
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	int ret;
 
-	spin_lock(&solo_enc->slock);
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
-		spin_unlock(&solo_enc->slock);
-		return ret;
-	}
-
 	if (pix->width == solo_dev->video_hsize)
 		solo_enc->mode = SOLO_ENC_MODE_D1;
 	else
@@ -1122,16 +1022,9 @@ static int solo_enc_set_fmt_cap(struct file *file, void *priv,
 	/* This does not change the encoder at all */
 	solo_enc->fmt = pix->pixelformat;
 
-	if (pix->priv)
-		solo_enc->type = SOLO_ENC_TYPE_EXT;
-	ret = solo_enc_on(solo_enc);
-
-	spin_unlock(&solo_enc->slock);
-
-	if (ret)
-		return ret;
-
-	return solo_start_thread(solo_enc);
+//	if (pix->priv) /* FIXME */
+//		solo_enc->type = SOLO_ENC_TYPE_EXT;
+	return 0;
 }
 
 static int solo_enc_get_fmt_cap(struct file *file, void *priv,
@@ -1152,49 +1045,13 @@ static int solo_enc_get_fmt_cap(struct file *file, void *priv,
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
-static int solo_enc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
-{
-	struct solo_enc_dev *solo_enc = video_drvdata(file);
-
-	return videobuf_qbuf(&solo_enc->vidq, buf);
-}
-
 static int solo_enc_dqbuf(struct file *file, void *priv,
 			  struct v4l2_buffer *buf)
 {
 	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	int ret;
 
-	/* Make sure the encoder is on */
-	if (!solo_enc->enc_on) {
-		spin_lock(&solo_enc->slock);
-		ret = solo_enc_on(solo_enc);
-		spin_unlock(&solo_enc->slock);
-		if (ret)
-			return ret;
-
-		ret = solo_start_thread(solo_enc);
-		if (ret)
-			return ret;
-	}
-
-	ret = videobuf_dqbuf(&solo_enc->vidq, buf, file->f_flags & O_NONBLOCK);
+	ret = vb2_ioctl_dqbuf(file, priv, buf);
 	if (ret)
 		return ret;
 
@@ -1211,8 +1068,8 @@ static int solo_enc_dqbuf(struct file *file, void *priv,
 
 	/* Check for key frame on mpeg data */
 	if (solo_enc->fmt == V4L2_PIX_FMT_MPEG) {
-		struct videobuf_dmabuf *vbuf =
-				videobuf_to_dma(solo_enc->vidq.bufs[buf->index]);
+		struct vb2_dma_sg_desc *vbuf =
+			vb2_dma_sg_plane_desc(solo_enc->vidq.bufs[buf->index], 0);
 
 		if (vbuf) {
 			u8 *p = sg_virt(vbuf->sglist);
@@ -1226,28 +1083,6 @@ static int solo_enc_dqbuf(struct file *file, void *priv,
 	return 0;
 }
 
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
-
-	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	return videobuf_streamoff(&solo_enc->vidq);
-}
-
 static int solo_enc_s_std(struct file *file, void *priv, v4l2_std_id *i)
 {
 	return 0;
@@ -1336,12 +1171,8 @@ static int solo_s_parm(struct file *file, void *priv,
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct v4l2_captureparm *cp = &sp->parm.capture;
 
-	spin_lock(&solo_enc->slock);
-
-	if (atomic_read(&solo_enc->readers) > 0) {
-		spin_unlock(&solo_enc->slock);
+	if (vb2_is_streaming(&solo_enc->vidq))
 		return -EBUSY;
-	}
 
 	if ((cp->timeperframe.numerator == 0) ||
 	    (cp->timeperframe.denominator == 0)) {
@@ -1364,8 +1195,6 @@ static int solo_s_parm(struct file *file, void *priv,
 	solo_enc->gop = max(solo_dev->fps / solo_enc->interval, 1);
 	solo_update_mode(solo_enc);
 
-	spin_unlock(&solo_enc->slock);
-
 	return 0;
 }
 
@@ -1412,11 +1241,11 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 static const struct v4l2_file_operations solo_enc_fops = {
 	.owner			= THIS_MODULE,
 	.open			= v4l2_fh_open,
-	.release		= solo_enc_release,
-	.read			= solo_enc_read,
-	.poll			= solo_enc_poll,
-	.mmap			= solo_enc_mmap,
-	.ioctl			= video_ioctl2,
+	.release		= vb2_fop_release,
+	.read			= vb2_fop_read,
+	.poll			= vb2_fop_poll,
+	.mmap			= vb2_fop_mmap,
+	.unlocked_ioctl		= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops solo_enc_ioctl_ops = {
@@ -1432,12 +1261,12 @@ static const struct v4l2_ioctl_ops solo_enc_ioctl_ops = {
 	.vidioc_s_fmt_vid_cap		= solo_enc_set_fmt_cap,
 	.vidioc_g_fmt_vid_cap		= solo_enc_get_fmt_cap,
 	/* Streaming I/O */
-	.vidioc_reqbufs			= solo_enc_reqbufs,
-	.vidioc_querybuf		= solo_enc_querybuf,
-	.vidioc_qbuf			= solo_enc_qbuf,
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
 	.vidioc_dqbuf			= solo_enc_dqbuf,
-	.vidioc_streamon		= solo_enc_streamon,
-	.vidioc_streamoff		= solo_enc_streamoff,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
 	/* Frame size and interval */
 	.vidioc_enum_framesizes		= solo_enum_framesizes,
 	.vidioc_enum_frameintervals	= solo_enum_frameintervals,
@@ -1528,9 +1357,7 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev, u8 ch)
 	v4l2_ctrl_new_custom(hdl, &solo_osd_text_ctrl, NULL);
 	if (hdl->error) {
 		ret = hdl->error;
-		v4l2_ctrl_handler_free(hdl);
-		kfree(solo_enc);
-		return ERR_PTR(ret);
+		goto fail;
 	}
 
 	solo_enc->solo_dev = solo_dev;
@@ -1540,8 +1367,8 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev, u8 ch)
 	solo_enc->type = SOLO_ENC_TYPE_STD;
 
 	spin_lock_init(&solo_enc->slock);
+	mutex_init(&solo_enc->lock);
 	init_waitqueue_head(&solo_enc->thread_wait);
-	atomic_set(&solo_enc->readers, 0);
 
 	solo_enc->qp = SOLO_DEFAULT_QP;
 	solo_enc->gop = solo_dev->fps;
@@ -1549,37 +1376,37 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev, u8 ch)
 	solo_enc->mode = SOLO_ENC_MODE_CIF;
 	solo_enc->motion_thresh = SOLO_DEF_MOT_THRESH;
 
-	spin_lock(&solo_enc->slock);
 	solo_update_mode(solo_enc);
-	spin_unlock(&solo_enc->slock);
 
-	videobuf_queue_sg_init(&solo_enc->vidq, &solo_enc_video_qops,
-			       &solo_enc->solo_dev->pdev->dev,
-			       &solo_enc->slock,
-			       V4L2_BUF_TYPE_VIDEO_CAPTURE,
-			       V4L2_FIELD_INTERLACED,
-			       sizeof(struct videobuf_buffer), solo_enc, NULL);
+	solo_enc->vidq.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	solo_enc->vidq.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
+	solo_enc->vidq.ops = &solo_enc_video_qops;
+	solo_enc->vidq.mem_ops = &vb2_dma_sg_memops;
+	solo_enc->vidq.drv_priv = solo_enc;
+	solo_enc->vidq.gfp_flags = __GFP_DMA32;
+	solo_enc->vidq.buf_struct_size = sizeof(struct solo_vb2_buf);
+	solo_enc->vidq.lock = &solo_enc->lock;
+	ret = vb2_queue_init(&solo_enc->vidq);
+	if (ret)
+		goto fail;
 
 	solo_enc->vfd = video_device_alloc();
 	if (!solo_enc->vfd) {
-		v4l2_ctrl_handler_free(hdl);
-		kfree(solo_enc);
-		return ERR_PTR(-ENOMEM);
+		ret = -ENOMEM;
+		goto fail;
 	}
 
 	*solo_enc->vfd = solo_enc_template;
 	solo_enc->vfd->v4l2_dev = &solo_dev->v4l2_dev;
 	solo_enc->vfd->ctrl_handler = hdl;
+	solo_enc->vfd->queue = &solo_enc->vidq;
+	solo_enc->vfd->lock = &solo_enc->lock;
 	set_bit(V4L2_FL_USE_FH_PRIO, &solo_enc->vfd->flags);
 	video_set_drvdata(solo_enc->vfd, solo_enc);
 	ret = video_register_device(solo_enc->vfd, VFL_TYPE_GRABBER,
 				    video_nr);
-	if (ret < 0) {
-		video_device_release(solo_enc->vfd);
-		v4l2_ctrl_handler_free(hdl);
-		kfree(solo_enc);
-		return ERR_PTR(ret);
-	}
+	if (ret < 0)
+		goto fail;
 
 	snprintf(solo_enc->vfd->name, sizeof(solo_enc->vfd->name),
 		 "%s-enc (%i/%i)", SOLO6X10_NAME, solo_dev->vfd->num,
@@ -1589,6 +1416,12 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev, u8 ch)
 		video_nr++;
 
 	return solo_enc;
+
+fail:
+	video_device_release(solo_enc->vfd);
+	v4l2_ctrl_handler_free(hdl);
+	kfree(solo_enc);
+	return ERR_PTR(ret);
 }
 
 static void solo_enc_free(struct solo_enc_dev *solo_enc, int ch)
-- 
1.7.10.4

