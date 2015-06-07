Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:41402 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543AbbFGI6n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2015 04:58:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 11/11] sh-vou: convert to vb2
Date: Sun,  7 Jun 2015 10:58:05 +0200
Message-Id: <1433667485-35711-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433667485-35711-1-git-send-email-hverkuil@xs4all.nl>
References: <1433667485-35711-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This converts this driver to videobuf2. As usual it is a big and hard to review
patch, but this is always a big-bang change.

It has been tested with my Renesas board.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/sh_vou.c | 590 +++++++++++++++++-----------------------
 1 file changed, 250 insertions(+), 340 deletions(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 22b32ec..8f60f82 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -27,7 +27,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-mediabus.h>
-#include <media/videobuf-dma-contig.h>
+#include <media/videobuf2-dma-contig.h>
 
 /* Mirror addresses are not available for all registers */
 #define VOUER	0
@@ -57,8 +57,19 @@ enum sh_vou_status {
 	SH_VOU_RUNNING,
 };
 
+#define VOU_MIN_IMAGE_WIDTH	16
 #define VOU_MAX_IMAGE_WIDTH	720
-#define VOU_MAX_IMAGE_HEIGHT	576
+#define VOU_MIN_IMAGE_HEIGHT	16
+
+struct sh_vou_buffer {
+	struct vb2_buffer vb;
+	struct list_head list;
+};
+
+static inline struct sh_vou_buffer *to_sh_vou_buffer(struct vb2_buffer *vb2)
+{
+	return container_of(vb2, struct sh_vou_buffer, vb);
+}
 
 struct sh_vou_device {
 	struct v4l2_device v4l2_dev;
@@ -69,19 +80,17 @@ struct sh_vou_device {
 	/* State information */
 	struct v4l2_pix_format pix;
 	struct v4l2_rect rect;
-	struct list_head queue;
+	struct list_head buf_list;
 	v4l2_std_id std;
 	int pix_idx;
-	struct videobuf_buffer *active;
+	struct vb2_queue queue;
+	struct vb2_alloc_ctx *alloc_ctx;
+	struct sh_vou_buffer *active;
 	enum sh_vou_status status;
+	unsigned sequence;
 	struct mutex fop_lock;
 };
 
-struct sh_vou_file {
-	struct v4l2_fh fh;
-	struct videobuf_queue vbq;
-};
-
 /* Register access routines for sides A, B and mirror addresses */
 static void sh_vou_reg_a_write(struct sh_vou_device *vou_dev, unsigned int reg,
 			       u32 value)
@@ -184,11 +193,11 @@ static struct sh_vou_fmt vou_fmt[] = {
 };
 
 static void sh_vou_schedule_next(struct sh_vou_device *vou_dev,
-				 struct videobuf_buffer *vb)
+				 struct vb2_buffer *vb)
 {
 	dma_addr_t addr1, addr2;
 
-	addr1 = videobuf_to_dma_contig(vb);
+	addr1 = vb2_dma_contig_plane_dma_addr(vb, 0);
 	switch (vou_dev->pix.pixelformat) {
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV16:
@@ -202,8 +211,7 @@ static void sh_vou_schedule_next(struct sh_vou_device *vou_dev,
 	sh_vou_reg_m_write(vou_dev, VOUAD2R, addr2);
 }
 
-static void sh_vou_stream_start(struct sh_vou_device *vou_dev,
-				struct videobuf_buffer *vb)
+static void sh_vou_stream_config(struct sh_vou_device *vou_dev)
 {
 	unsigned int row_coeff;
 #ifdef __LITTLE_ENDIAN
@@ -230,167 +238,136 @@ static void sh_vou_stream_start(struct sh_vou_device *vou_dev,
 
 	sh_vou_reg_a_write(vou_dev, VOUSWR, dataswap);
 	sh_vou_reg_ab_write(vou_dev, VOUAIR, vou_dev->pix.width * row_coeff);
-	sh_vou_schedule_next(vou_dev, vb);
-}
-
-static void free_buffer(struct videobuf_queue *vq, struct videobuf_buffer *vb)
-{
-	BUG_ON(in_interrupt());
-
-	/* Wait until this buffer is no longer in STATE_QUEUED or STATE_ACTIVE */
-	videobuf_waiton(vq, vb, 0, 0);
-	videobuf_dma_contig_free(vq, vb);
-	vb->state = VIDEOBUF_NEEDS_INIT;
 }
 
 /* Locking: caller holds fop_lock mutex */
-static int sh_vou_buf_setup(struct videobuf_queue *vq, unsigned int *count,
-			    unsigned int *size)
+static int sh_vou_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+		       unsigned int *nbuffers, unsigned int *nplanes,
+		       unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct video_device *vdev = vq->priv_data;
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
-
-	*size = vou_fmt[vou_dev->pix_idx].bpp * vou_dev->pix.width *
-		vou_dev->pix.height / 8;
-
-	if (*count < 2)
-		*count = 2;
-
-	/* Taking into account maximum frame size, *count will stay >= 2 */
-	if (PAGE_ALIGN(*size) * *count > 4 * 1024 * 1024)
-		*count = 4 * 1024 * 1024 / PAGE_ALIGN(*size);
+	struct sh_vou_device *vou_dev = vb2_get_drv_priv(vq);
+	struct v4l2_pix_format *pix = &vou_dev->pix;
+	int bytes_per_line = vou_fmt[vou_dev->pix_idx].bpp * pix->width / 8;
 
-	dev_dbg(vou_dev->v4l2_dev.dev, "%s(): count=%d, size=%d\n", __func__,
-		*count, *size);
+	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
+	if (fmt && fmt->fmt.pix.sizeimage < pix->height * bytes_per_line)
+		return -EINVAL;
+	*nplanes = 1;
+	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : pix->height * bytes_per_line;
+	alloc_ctxs[0] = vou_dev->alloc_ctx;
 	return 0;
 }
 
-/* Locking: caller holds fop_lock mutex */
-static int sh_vou_buf_prepare(struct videobuf_queue *vq,
-			      struct videobuf_buffer *vb,
-			      enum v4l2_field field)
+static int sh_vou_buf_prepare(struct vb2_buffer *vb)
 {
-	struct video_device *vdev = vq->priv_data;
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
+	struct sh_vou_device *vou_dev = vb2_get_drv_priv(vb->vb2_queue);
 	struct v4l2_pix_format *pix = &vou_dev->pix;
-	int bytes_per_line = vou_fmt[vou_dev->pix_idx].bpp * pix->width / 8;
-	int ret;
+	unsigned bytes_per_line = vou_fmt[vou_dev->pix_idx].bpp * pix->width / 8;
+	unsigned size = pix->height * bytes_per_line;
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
-	if (vb->width	!= pix->width ||
-	    vb->height	!= pix->height ||
-	    vb->field	!= pix->field) {
-		vb->width	= pix->width;
-		vb->height	= pix->height;
-		vb->field	= field;
-		if (vb->state != VIDEOBUF_NEEDS_INIT)
-			free_buffer(vq, vb);
-	}
-
-	vb->size = vb->height * bytes_per_line;
-	if (vb->baddr && vb->bsize < vb->size) {
+	if (vb2_plane_size(vb, 0) < size) {
 		/* User buffer too small */
-		dev_warn(vq->dev, "User buffer too small: [%zu] @ %lx\n",
-			 vb->bsize, vb->baddr);
+		dev_warn(vou_dev->v4l2_dev.dev, "buffer too small (%lu < %u)\n",
+			 vb2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
 
-	if (vb->state == VIDEOBUF_NEEDS_INIT) {
-		ret = videobuf_iolock(vq, vb, NULL);
-		if (ret < 0) {
-			dev_warn(vq->dev, "IOLOCK buf-type %d: %d\n",
-				 vb->memory, ret);
-			return ret;
-		}
-		vb->state = VIDEOBUF_PREPARED;
-	}
-
-	dev_dbg(vou_dev->v4l2_dev.dev,
-		"%s(): fmt #%d, %u bytes per line, phys %pad, type %d, state %d\n",
-		__func__, vou_dev->pix_idx, bytes_per_line,
-		({ dma_addr_t addr = videobuf_to_dma_contig(vb); &addr; }),
-		vb->memory, vb->state);
-
+	vb2_set_plane_payload(vb, 0, size);
 	return 0;
 }
 
 /* Locking: caller holds fop_lock mutex and vq->irqlock spinlock */
-static void sh_vou_buf_queue(struct videobuf_queue *vq,
-			     struct videobuf_buffer *vb)
+static void sh_vou_buf_queue(struct vb2_buffer *vb)
 {
-	struct video_device *vdev = vq->priv_data;
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
+	struct sh_vou_device *vou_dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct sh_vou_buffer *shbuf = to_sh_vou_buffer(vb);
+	unsigned long flags;
 
-	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
+	spin_lock_irqsave(&vou_dev->lock, flags);
+	list_add_tail(&shbuf->list, &vou_dev->buf_list);
+	spin_unlock_irqrestore(&vou_dev->lock, flags);
+}
 
-	vb->state = VIDEOBUF_QUEUED;
-	list_add_tail(&vb->queue, &vou_dev->queue);
-
-	if (vou_dev->status == SH_VOU_RUNNING) {
-		return;
-	} else if (!vou_dev->active) {
-		vou_dev->active = vb;
-		/* Start from side A: we use mirror addresses, so, set B */
-		sh_vou_reg_a_write(vou_dev, VOURPR, 1);
-		dev_dbg(vou_dev->v4l2_dev.dev, "%s: first buffer status 0x%x\n",
-			__func__, sh_vou_reg_a_read(vou_dev, VOUSTR));
-		sh_vou_schedule_next(vou_dev, vb);
-		/* Only activate VOU after the second buffer */
-	} else if (vou_dev->active->queue.next == &vb->queue) {
-		/* Second buffer - initialise register side B */
-		sh_vou_reg_a_write(vou_dev, VOURPR, 0);
-		sh_vou_stream_start(vou_dev, vb);
-
-		/* Register side switching with frame VSYNC */
-		sh_vou_reg_a_write(vou_dev, VOURCR, 5);
-		dev_dbg(vou_dev->v4l2_dev.dev, "%s: second buffer status 0x%x\n",
-			__func__, sh_vou_reg_a_read(vou_dev, VOUSTR));
-
-		/* Enable End-of-Frame (VSYNC) interrupts */
-		sh_vou_reg_a_write(vou_dev, VOUIR, 0x10004);
-		/* Two buffers on the queue - activate the hardware */
-
-		vou_dev->status = SH_VOU_RUNNING;
-		sh_vou_reg_a_write(vou_dev, VOUER, 0x107);
+static int sh_vou_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct sh_vou_device *vou_dev = vb2_get_drv_priv(vq);
+	struct sh_vou_buffer *buf, *node;
+	int ret;
+
+	vou_dev->sequence = 0;
+	ret = v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0,
+					 video, s_stream, 1);
+	if (ret < 0 && ret != -ENOIOCTLCMD) {
+		list_for_each_entry_safe(buf, node, &vou_dev->buf_list, list) {
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			list_del(&buf->list);
+		}
+		vou_dev->active = NULL;
+		return ret;
 	}
+
+	buf = list_entry(vou_dev->buf_list.next, struct sh_vou_buffer, list);
+
+	vou_dev->active = buf;
+
+	/* Start from side A: we use mirror addresses, so, set B */
+	sh_vou_reg_a_write(vou_dev, VOURPR, 1);
+	dev_dbg(vou_dev->v4l2_dev.dev, "%s: first buffer status 0x%x\n",
+		__func__, sh_vou_reg_a_read(vou_dev, VOUSTR));
+	sh_vou_schedule_next(vou_dev, &buf->vb);
+
+	buf = list_entry(buf->list.next, struct sh_vou_buffer, list);
+
+	/* Second buffer - initialise register side B */
+	sh_vou_reg_a_write(vou_dev, VOURPR, 0);
+	sh_vou_schedule_next(vou_dev, &buf->vb);
+
+	/* Register side switching with frame VSYNC */
+	sh_vou_reg_a_write(vou_dev, VOURCR, 5);
+
+	sh_vou_stream_config(vou_dev);
+	/* Enable End-of-Frame (VSYNC) interrupts */
+	sh_vou_reg_a_write(vou_dev, VOUIR, 0x10004);
+
+	/* Two buffers on the queue - activate the hardware */
+	vou_dev->status = SH_VOU_RUNNING;
+	sh_vou_reg_a_write(vou_dev, VOUER, 0x107);
+	return 0;
 }
 
-static void sh_vou_buf_release(struct videobuf_queue *vq,
-			       struct videobuf_buffer *vb)
+static void sh_vou_stop_streaming(struct vb2_queue *vq)
 {
-	struct video_device *vdev = vq->priv_data;
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
+	struct sh_vou_device *vou_dev = vb2_get_drv_priv(vq);
+	struct sh_vou_buffer *buf, *node;
 	unsigned long flags;
 
-	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
-
+	v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0,
+					 video, s_stream, 0);
+	/* disable output */
+	sh_vou_reg_a_set(vou_dev, VOUER, 0, 1);
+	/* ...but the current frame will complete */
+	sh_vou_reg_a_set(vou_dev, VOUIR, 0, 0x30000);
+	msleep(50);
 	spin_lock_irqsave(&vou_dev->lock, flags);
-
-	if (vou_dev->active == vb) {
-		/* disable output */
-		sh_vou_reg_a_set(vou_dev, VOUER, 0, 1);
-		/* ...but the current frame will complete */
-		sh_vou_reg_a_set(vou_dev, VOUIR, 0, 0x30000);
-		vou_dev->active = NULL;
+	list_for_each_entry_safe(buf, node, &vou_dev->buf_list, list) {
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		list_del(&buf->list);
 	}
-
-	if ((vb->state == VIDEOBUF_ACTIVE || vb->state == VIDEOBUF_QUEUED)) {
-		vb->state = VIDEOBUF_ERROR;
-		list_del(&vb->queue);
-	}
-
+	vou_dev->active = NULL;
 	spin_unlock_irqrestore(&vou_dev->lock, flags);
-
-	free_buffer(vq, vb);
 }
 
-static struct videobuf_queue_ops sh_vou_video_qops = {
-	.buf_setup	= sh_vou_buf_setup,
-	.buf_prepare	= sh_vou_buf_prepare,
-	.buf_queue	= sh_vou_buf_queue,
-	.buf_release	= sh_vou_buf_release,
+static struct vb2_ops sh_vou_qops = {
+	.queue_setup		= sh_vou_queue_setup,
+	.buf_prepare		= sh_vou_buf_prepare,
+	.buf_queue		= sh_vou_buf_queue,
+	.start_streaming	= sh_vou_start_streaming,
+	.stop_streaming		= sh_vou_stop_streaming,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 };
 
 /* Video IOCTLs */
@@ -404,7 +381,8 @@ static int sh_vou_querycap(struct file *file, void  *priv,
 	strlcpy(cap->card, "SuperH VOU", sizeof(cap->card));
 	strlcpy(cap->driver, "sh-vou", sizeof(cap->driver));
 	strlcpy(cap->bus_info, "platform:sh-vou", sizeof(cap->bus_info));
-	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_READWRITE |
+			   V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
@@ -548,8 +526,10 @@ static void vou_adjust_input(struct sh_vou_geometry *geo, v4l2_std_id std)
 		img_height_max = 576;
 
 	/* Image width must be a multiple of 4 */
-	v4l_bound_align_image(&geo->in_width, 0, VOU_MAX_IMAGE_WIDTH, 2,
-			      &geo->in_height, 0, img_height_max, 1, 0);
+	v4l_bound_align_image(&geo->in_width,
+			      VOU_MIN_IMAGE_WIDTH, VOU_MAX_IMAGE_WIDTH, 2,
+			      &geo->in_height,
+			      VOU_MIN_IMAGE_HEIGHT, img_height_max, 1, 0);
 
 	/* Select scales to come as close as possible to the output image */
 	for (i = ARRAY_SIZE(vou_scale_h_num) - 1; i >= 0; i--) {
@@ -705,19 +685,19 @@ static int sh_vou_try_fmt_vid_out(struct file *file, void *priv,
 	else
 		img_height_max = 576;
 
-	v4l_bound_align_image(&pix->width, 0, VOU_MAX_IMAGE_WIDTH, 2,
-			      &pix->height, 0, img_height_max, 1, 0);
+	v4l_bound_align_image(&pix->width,
+			      VOU_MIN_IMAGE_WIDTH, VOU_MAX_IMAGE_WIDTH, 2,
+			      &pix->height,
+			      VOU_MIN_IMAGE_HEIGHT, img_height_max, 1, 0);
 	pix->bytesperline = pix->width * vou_fmt[pix_idx].bpl;
 	pix->sizeimage = pix->height * ((pix->width * vou_fmt[pix_idx].bpp) >> 3);
 
 	return 0;
 }
 
-static int sh_vou_s_fmt_vid_out(struct file *file, void *priv,
-				struct v4l2_format *fmt)
+static int sh_vou_set_fmt_vid_out(struct sh_vou_device *vou_dev,
+				struct v4l2_pix_format *pix)
 {
-	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct v4l2_pix_format *pix = &fmt->fmt.pix;
 	unsigned int img_height_max;
 	struct sh_vou_geometry geo;
 	struct v4l2_subdev_format format = {
@@ -728,11 +708,11 @@ static int sh_vou_s_fmt_vid_out(struct file *file, void *priv,
 		.format.colorspace = V4L2_COLORSPACE_SMPTE170M,
 	};
 	struct v4l2_mbus_framefmt *mbfmt = &format.format;
-	int ret = sh_vou_try_fmt_vid_out(file, priv, fmt);
 	int pix_idx;
+	int ret;
 
-	if (ret)
-		return ret;
+	if (vb2_is_busy(&vou_dev->queue))
+		return -EBUSY;
 
 	for (pix_idx = 0; pix_idx < ARRAY_SIZE(vou_fmt); pix_idx++)
 		if (vou_fmt[pix_idx].pfmt == pix->pixelformat)
@@ -792,85 +772,15 @@ static int sh_vou_s_fmt_vid_out(struct file *file, void *priv,
 	return 0;
 }
 
-static int sh_vou_reqbufs(struct file *file, void *priv,
-			  struct v4l2_requestbuffers *req)
-{
-	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct sh_vou_file *vou_file = priv;
-
-	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
-
-	if (req->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
-		return -EINVAL;
-
-	return videobuf_reqbufs(&vou_file->vbq, req);
-}
-
-static int sh_vou_querybuf(struct file *file, void *priv,
-			   struct v4l2_buffer *b)
-{
-	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct sh_vou_file *vou_file = priv;
-
-	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
-
-	return videobuf_querybuf(&vou_file->vbq, b);
-}
-
-static int sh_vou_qbuf(struct file *file, void *priv, struct v4l2_buffer *b)
-{
-	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct sh_vou_file *vou_file = priv;
-
-	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
-
-	return videobuf_qbuf(&vou_file->vbq, b);
-}
-
-static int sh_vou_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
-{
-	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct sh_vou_file *vou_file = priv;
-
-	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
-
-	return videobuf_dqbuf(&vou_file->vbq, b, file->f_flags & O_NONBLOCK);
-}
-
-static int sh_vou_streamon(struct file *file, void *priv,
-			   enum v4l2_buf_type buftype)
+static int sh_vou_s_fmt_vid_out(struct file *file, void *priv,
+				struct v4l2_format *fmt)
 {
 	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct sh_vou_file *vou_file = priv;
-	int ret;
-
-	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
+	int ret = sh_vou_try_fmt_vid_out(file, priv, fmt);
 
-	ret = v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0,
-					 video, s_stream, 1);
-	if (ret < 0 && ret != -ENOIOCTLCMD)
+	if (ret)
 		return ret;
-
-	/* This calls our .buf_queue() (== sh_vou_buf_queue) */
-	return videobuf_streamon(&vou_file->vbq);
-}
-
-static int sh_vou_streamoff(struct file *file, void *priv,
-			    enum v4l2_buf_type buftype)
-{
-	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct sh_vou_file *vou_file = priv;
-
-	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
-
-	/*
-	 * This calls buf_release from host driver's videobuf_queue_ops for all
-	 * remaining buffers. When the last buffer is freed, stop streaming
-	 */
-	videobuf_streamoff(&vou_file->vbq);
-	v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, video, s_stream, 0);
-
-	return 0;
+	return sh_vou_set_fmt_vid_out(vou_dev, &fmt->fmt.pix);
 }
 
 static int sh_vou_enum_output(struct file *file, void *fh,
@@ -919,8 +829,11 @@ static int sh_vou_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s(): 0x%llx\n", __func__, std_id);
 
-	if (std_id & ~vou_dev->vdev.tvnorms)
-		return -EINVAL;
+	if (std_id == vou_dev->std)
+		return 0;
+
+	if (vb2_is_busy(&vou_dev->queue))
+		return -EBUSY;
 
 	ret = v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, video,
 					 s_std_output, std_id);
@@ -928,13 +841,25 @@ static int sh_vou_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 	if (ret < 0 && ret != -ENOIOCTLCMD)
 		return ret;
 
-	if (std_id & V4L2_STD_525_60)
+	vou_dev->rect.top = vou_dev->rect.left = 0;
+	vou_dev->rect.width = VOU_MAX_IMAGE_WIDTH;
+	if (std_id & V4L2_STD_525_60) {
 		sh_vou_reg_ab_set(vou_dev, VOUCR,
 			sh_vou_ntsc_mode(vou_dev->pdata->bus_fmt) << 29, 7 << 29);
-	else
+		vou_dev->rect.height = 480;
+	} else {
 		sh_vou_reg_ab_set(vou_dev, VOUCR, 5 << 29, 7 << 29);
+		vou_dev->rect.height = 576;
+	}
 
+	vou_dev->pix.width = vou_dev->rect.width;
+	vou_dev->pix.height = vou_dev->rect.height;
+	vou_dev->pix.bytesperline =
+		vou_dev->pix.width * vou_fmt[vou_dev->pix_idx].bpl;
+	vou_dev->pix.sizeimage = vou_dev->pix.height *
+		((vou_dev->pix.width * vou_fmt[vou_dev->pix_idx].bpp) >> 3);
 	vou_dev->std = std_id;
+	sh_vou_set_fmt_vid_out(vou_dev, &vou_dev->pix);
 
 	return 0;
 }
@@ -994,7 +919,10 @@ static int sh_vou_g_selection(struct file *file, void *fh,
 		sel->r.left = 0;
 		sel->r.top = 0;
 		sel->r.width = VOU_MAX_IMAGE_WIDTH;
-		sel->r.height = VOU_MAX_IMAGE_HEIGHT;
+		if (vou_dev->std & V4L2_STD_525_60)
+			sel->r.height = 480;
+		else
+			sel->r.height = 576;
 		break;
 	default:
 		return -EINVAL;
@@ -1025,13 +953,18 @@ static int sh_vou_s_selection(struct file *file, void *fh,
 	    sel->target != V4L2_SEL_TGT_COMPOSE)
 		return -EINVAL;
 
+	if (vb2_is_busy(&vou_dev->queue))
+		return -EBUSY;
+
 	if (vou_dev->std & V4L2_STD_525_60)
 		img_height_max = 480;
 	else
 		img_height_max = 576;
 
-	v4l_bound_align_image(&rect->width, 0, VOU_MAX_IMAGE_WIDTH, 1,
-			      &rect->height, 0, img_height_max, 1, 0);
+	v4l_bound_align_image(&rect->width,
+			      VOU_MIN_IMAGE_WIDTH, VOU_MAX_IMAGE_WIDTH, 1,
+			      &rect->height,
+			      VOU_MIN_IMAGE_HEIGHT, img_height_max, 1, 0);
 
 	if (rect->width + rect->left > VOU_MAX_IMAGE_WIDTH)
 		rect->left = VOU_MAX_IMAGE_WIDTH - rect->width;
@@ -1090,7 +1023,7 @@ static irqreturn_t sh_vou_isr(int irq, void *dev_id)
 {
 	struct sh_vou_device *vou_dev = dev_id;
 	static unsigned long j;
-	struct videobuf_buffer *vb;
+	struct sh_vou_buffer *vb;
 	static int cnt;
 	u32 irq_status = sh_vou_reg_a_read(vou_dev, VOUIR), masked;
 	u32 vou_status = sh_vou_reg_a_read(vou_dev, VOUSTR);
@@ -1103,7 +1036,7 @@ static irqreturn_t sh_vou_isr(int irq, void *dev_id)
 	}
 
 	spin_lock(&vou_dev->lock);
-	if (!vou_dev->active || list_empty(&vou_dev->queue)) {
+	if (!vou_dev->active || list_empty(&vou_dev->buf_list)) {
 		if (printk_timed_ratelimit(&j, 500))
 			dev_warn(vou_dev->v4l2_dev.dev,
 				 "IRQ without active buffer: %x!\n", irq_status);
@@ -1125,33 +1058,30 @@ static irqreturn_t sh_vou_isr(int irq, void *dev_id)
 	sh_vou_reg_a_write(vou_dev, VOUIR, masked);
 
 	vb = vou_dev->active;
-	list_del(&vb->queue);
-
-	vb->state = VIDEOBUF_DONE;
-	v4l2_get_timestamp(&vb->ts);
-	vb->field_count++;
-	wake_up(&vb->done);
-
-	if (list_empty(&vou_dev->queue)) {
-		/* Stop VOU */
-		dev_dbg(vou_dev->v4l2_dev.dev, "%s: queue empty after %d\n",
-			__func__, cnt);
-		sh_vou_reg_a_set(vou_dev, VOUER, 0, 1);
-		vou_dev->active = NULL;
-		vou_dev->status = SH_VOU_INITIALISING;
-		/* Disable End-of-Frame (VSYNC) interrupts */
-		sh_vou_reg_a_set(vou_dev, VOUIR, 0, 0x30000);
+	if (list_is_singular(&vb->list)) {
+		/* Keep cycling while no next buffer is available */
+		sh_vou_schedule_next(vou_dev, &vb->vb);
 		spin_unlock(&vou_dev->lock);
 		return IRQ_HANDLED;
 	}
 
-	vou_dev->active = list_entry(vou_dev->queue.next,
-				     struct videobuf_buffer, queue);
+	list_del(&vb->list);
+
+	v4l2_get_timestamp(&vb->vb.v4l2_buf.timestamp);
+	vb->vb.v4l2_buf.sequence = vou_dev->sequence++;
+	vb->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
+	vb2_buffer_done(&vb->vb, VB2_BUF_STATE_DONE);
+
+	vou_dev->active = list_entry(vou_dev->buf_list.next,
+				     struct sh_vou_buffer, list);
 
-	if (vou_dev->active->queue.next != &vou_dev->queue) {
-		struct videobuf_buffer *new = list_entry(vou_dev->active->queue.next,
-						struct videobuf_buffer, queue);
-		sh_vou_schedule_next(vou_dev, new);
+	if (list_is_singular(&vou_dev->buf_list)) {
+		/* Keep cycling while no next buffer is available */
+		sh_vou_schedule_next(vou_dev, &vou_dev->active->vb);
+	} else {
+		struct sh_vou_buffer *new = list_entry(vou_dev->active->list.next,
+						struct sh_vou_buffer, list);
+		sh_vou_schedule_next(vou_dev, &new->vb);
 	}
 
 	spin_unlock(&vou_dev->lock);
@@ -1191,6 +1121,8 @@ static int sh_vou_hw_init(struct sh_vou_device *vou_dev)
 	/* Default - fixed HSYNC length, can be made configurable is required */
 	sh_vou_reg_ab_write(vou_dev, VOUMSR, 0x800000);
 
+	sh_vou_set_fmt_vid_out(vou_dev, &vou_dev->pix);
+
 	return 0;
 }
 
@@ -1198,104 +1130,49 @@ static int sh_vou_hw_init(struct sh_vou_device *vou_dev)
 static int sh_vou_open(struct file *file)
 {
 	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct sh_vou_file *vou_file = kzalloc(sizeof(struct sh_vou_file),
-					       GFP_KERNEL);
-
-	if (!vou_file)
-		return -ENOMEM;
-
-	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
+	int err;
 
-	v4l2_fh_init(&vou_file->fh, &vou_dev->vdev);
-	if (mutex_lock_interruptible(&vou_dev->fop_lock)) {
-		kfree(vou_file);
+	if (mutex_lock_interruptible(&vou_dev->fop_lock))
 		return -ERESTARTSYS;
-	}
-	v4l2_fh_add(&vou_file->fh);
-	if (v4l2_fh_is_singular(&vou_file->fh)) {
-		int ret;
 
+	err = v4l2_fh_open(file);
+	if (err)
+		goto done_open;
+	if (v4l2_fh_is_singular_file(file) &&
+	    vou_dev->status == SH_VOU_INITIALISING) {
 		/* First open */
-		vou_dev->status = SH_VOU_INITIALISING;
 		pm_runtime_get_sync(vou_dev->v4l2_dev.dev);
-		ret = sh_vou_hw_init(vou_dev);
-		if (ret < 0) {
+		err = sh_vou_hw_init(vou_dev);
+		if (err < 0) {
 			pm_runtime_put(vou_dev->v4l2_dev.dev);
+			v4l2_fh_release(file);
+		} else {
 			vou_dev->status = SH_VOU_IDLE;
-			v4l2_fh_del(&vou_file->fh);
-			v4l2_fh_exit(&vou_file->fh);
-			mutex_unlock(&vou_dev->fop_lock);
-			kfree(vou_file);
-			return ret;
 		}
 	}
-
-	videobuf_queue_dma_contig_init(&vou_file->vbq, &sh_vou_video_qops,
-				       vou_dev->v4l2_dev.dev, &vou_dev->lock,
-				       V4L2_BUF_TYPE_VIDEO_OUTPUT,
-				       V4L2_FIELD_NONE,
-				       sizeof(struct videobuf_buffer),
-				       &vou_dev->vdev, &vou_dev->fop_lock);
+done_open:
 	mutex_unlock(&vou_dev->fop_lock);
-
-	file->private_data = vou_file;
-
-	return 0;
+	return err;
 }
 
 static int sh_vou_release(struct file *file)
 {
 	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct sh_vou_file *vou_file = file->private_data;
-
-	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
+	bool is_last;
 
 	mutex_lock(&vou_dev->fop_lock);
-	if (v4l2_fh_is_singular(&vou_file->fh)) {
+	is_last = v4l2_fh_is_singular_file(file);
+	_vb2_fop_release(file, NULL);
+	if (is_last) {
 		/* Last close */
-		vou_dev->status = SH_VOU_IDLE;
+		vou_dev->status = SH_VOU_INITIALISING;
 		sh_vou_reg_a_set(vou_dev, VOUER, 0, 0x101);
 		pm_runtime_put(vou_dev->v4l2_dev.dev);
 	}
-	v4l2_fh_del(&vou_file->fh);
-	v4l2_fh_exit(&vou_file->fh);
 	mutex_unlock(&vou_dev->fop_lock);
-
-	file->private_data = NULL;
-	kfree(vou_file);
-
 	return 0;
 }
 
-static int sh_vou_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct sh_vou_file *vou_file = file->private_data;
-	int ret;
-
-	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
-
-	if (mutex_lock_interruptible(&vou_dev->fop_lock))
-		return -ERESTARTSYS;
-	ret = videobuf_mmap_mapper(&vou_file->vbq, vma);
-	mutex_unlock(&vou_dev->fop_lock);
-	return ret;
-}
-
-static unsigned int sh_vou_poll(struct file *file, poll_table *wait)
-{
-	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct sh_vou_file *vou_file = file->private_data;
-	unsigned int res;
-
-	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
-
-	mutex_lock(&vou_dev->fop_lock);
-	res = videobuf_poll_stream(file, &vou_file->vbq, wait);
-	mutex_unlock(&vou_dev->fop_lock);
-	return res;
-}
-
 /* sh_vou display ioctl operations */
 static const struct v4l2_ioctl_ops sh_vou_ioctl_ops = {
 	.vidioc_querycap        	= sh_vou_querycap,
@@ -1303,12 +1180,15 @@ static const struct v4l2_ioctl_ops sh_vou_ioctl_ops = {
 	.vidioc_g_fmt_vid_out		= sh_vou_g_fmt_vid_out,
 	.vidioc_s_fmt_vid_out		= sh_vou_s_fmt_vid_out,
 	.vidioc_try_fmt_vid_out		= sh_vou_try_fmt_vid_out,
-	.vidioc_reqbufs			= sh_vou_reqbufs,
-	.vidioc_querybuf		= sh_vou_querybuf,
-	.vidioc_qbuf			= sh_vou_qbuf,
-	.vidioc_dqbuf			= sh_vou_dqbuf,
-	.vidioc_streamon		= sh_vou_streamon,
-	.vidioc_streamoff		= sh_vou_streamoff,
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
+	.vidioc_expbuf			= vb2_ioctl_expbuf,
 	.vidioc_g_output		= sh_vou_g_output,
 	.vidioc_s_output		= sh_vou_s_output,
 	.vidioc_enum_output		= sh_vou_enum_output,
@@ -1324,8 +1204,9 @@ static const struct v4l2_file_operations sh_vou_fops = {
 	.open		= sh_vou_open,
 	.release	= sh_vou_release,
 	.unlocked_ioctl	= video_ioctl2,
-	.mmap		= sh_vou_mmap,
-	.poll		= sh_vou_poll,
+	.mmap		= vb2_fop_mmap,
+	.poll		= vb2_fop_poll,
+	.write		= vb2_fop_write,
 };
 
 static const struct video_device sh_vou_video_template = {
@@ -1346,6 +1227,7 @@ static int sh_vou_probe(struct platform_device *pdev)
 	struct sh_vou_device *vou_dev;
 	struct resource *reg_res;
 	struct v4l2_subdev *subdev;
+	struct vb2_queue *q;
 	int irq, ret;
 
 	reg_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1360,11 +1242,12 @@ static int sh_vou_probe(struct platform_device *pdev)
 	if (!vou_dev)
 		return -ENOMEM;
 
-	INIT_LIST_HEAD(&vou_dev->queue);
+	INIT_LIST_HEAD(&vou_dev->buf_list);
 	spin_lock_init(&vou_dev->lock);
 	mutex_init(&vou_dev->fop_lock);
 	vou_dev->pdata = vou_pdata;
-	vou_dev->status = SH_VOU_IDLE;
+	vou_dev->status = SH_VOU_INITIALISING;
+	vou_dev->pix_idx = 1;
 
 	rect = &vou_dev->rect;
 	pix = &vou_dev->pix;
@@ -1378,7 +1261,7 @@ static int sh_vou_probe(struct platform_device *pdev)
 	pix->width		= VOU_MAX_IMAGE_WIDTH;
 	pix->height		= 480;
 	pix->pixelformat	= V4L2_PIX_FMT_NV16;
-	pix->field		= V4L2_FIELD_NONE;
+	pix->field		= V4L2_FIELD_INTERLACED;
 	pix->bytesperline	= VOU_MAX_IMAGE_WIDTH;
 	pix->sizeimage		= VOU_MAX_IMAGE_WIDTH * 2 * 480;
 	pix->colorspace		= V4L2_COLORSPACE_SMPTE170M;
@@ -1407,6 +1290,30 @@ static int sh_vou_probe(struct platform_device *pdev)
 
 	video_set_drvdata(vdev, vou_dev);
 
+	/* Initialize the vb2 queue */
+	q = &vou_dev->queue;
+	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	q->io_modes = VB2_MMAP | VB2_DMABUF | VB2_WRITE;
+	q->drv_priv = vou_dev;
+	q->buf_struct_size = sizeof(struct sh_vou_buffer);
+	q->ops = &sh_vou_qops;
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->min_buffers_needed = 2;
+	q->lock = &vou_dev->fop_lock;
+	ret = vb2_queue_init(q);
+	if (ret)
+		goto einitctx;
+
+	vou_dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	if (IS_ERR(vou_dev->alloc_ctx)) {
+		dev_err(&pdev->dev, "Can't allocate buffer context");
+		ret = PTR_ERR(vou_dev->alloc_ctx);
+		goto einitctx;
+	}
+	vdev->queue = q;
+	INIT_LIST_HEAD(&vou_dev->buf_list);
+
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_resume(&pdev->dev);
 
@@ -1438,6 +1345,8 @@ ei2cnd:
 ereset:
 	i2c_put_adapter(i2c_adap);
 ei2cgadap:
+	vb2_dma_contig_cleanup_ctx(vou_dev->alloc_ctx);
+einitctx:
 	pm_runtime_disable(&pdev->dev);
 	v4l2_device_unregister(&vou_dev->v4l2_dev);
 	return ret;
@@ -1455,6 +1364,7 @@ static int sh_vou_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	video_unregister_device(&vou_dev->vdev);
 	i2c_put_adapter(client->adapter);
+	vb2_dma_contig_cleanup_ctx(vou_dev->alloc_ctx);
 	v4l2_device_unregister(&vou_dev->v4l2_dev);
 	return 0;
 }
-- 
2.1.4

