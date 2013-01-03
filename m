Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50905 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab3ACSea (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 13:34:30 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 3/3] sh_vou: Use vou_dev instead of vou_file wherever possible
Date: Thu,  3 Jan 2013 19:35:57 +0100
Message-Id: <1357238157-18115-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1357238157-18115-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1357238157-18115-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This prepares for the removal of vou_file.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/sh_vou.c |   57 +++++++++++++++++++++-----------------
 1 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 02c1b5c..b65e2c0 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -253,7 +253,8 @@ static int sh_vou_buf_setup(struct videobuf_queue *vq, unsigned int *count,
 	if (PAGE_ALIGN(*size) * *count > 4 * 1024 * 1024)
 		*count = 4 * 1024 * 1024 / PAGE_ALIGN(*size);
 
-	dev_dbg(vq->dev, "%s(): count=%d, size=%d\n", __func__, *count, *size);
+	dev_dbg(vou_dev->v4l2_dev.dev, "%s(): count=%d, size=%d\n", __func__,
+		*count, *size);
 
 	return 0;
 }
@@ -269,7 +270,7 @@ static int sh_vou_buf_prepare(struct videobuf_queue *vq,
 	int bytes_per_line = vou_fmt[vou_dev->pix_idx].bpp * pix->width / 8;
 	int ret;
 
-	dev_dbg(vq->dev, "%s()\n", __func__);
+	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
 	if (vb->width	!= pix->width ||
 	    vb->height	!= pix->height ||
@@ -299,7 +300,7 @@ static int sh_vou_buf_prepare(struct videobuf_queue *vq,
 		vb->state = VIDEOBUF_PREPARED;
 	}
 
-	dev_dbg(vq->dev,
+	dev_dbg(vou_dev->v4l2_dev.dev,
 		"%s(): fmt #%d, %u bytes per line, phys 0x%x, type %d, state %d\n",
 		__func__, vou_dev->pix_idx, bytes_per_line,
 		videobuf_to_dma_contig(vb), vb->memory, vb->state);
@@ -314,7 +315,7 @@ static void sh_vou_buf_queue(struct videobuf_queue *vq,
 	struct video_device *vdev = vq->priv_data;
 	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
 
-	dev_dbg(vq->dev, "%s()\n", __func__);
+	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
 	vb->state = VIDEOBUF_QUEUED;
 	list_add_tail(&vb->queue, &vou_dev->queue);
@@ -325,8 +326,8 @@ static void sh_vou_buf_queue(struct videobuf_queue *vq,
 		vou_dev->active = vb;
 		/* Start from side A: we use mirror addresses, so, set B */
 		sh_vou_reg_a_write(vou_dev, VOURPR, 1);
-		dev_dbg(vq->dev, "%s: first buffer status 0x%x\n", __func__,
-			sh_vou_reg_a_read(vou_dev, VOUSTR));
+		dev_dbg(vou_dev->v4l2_dev.dev, "%s: first buffer status 0x%x\n",
+			__func__, sh_vou_reg_a_read(vou_dev, VOUSTR));
 		sh_vou_schedule_next(vou_dev, vb);
 		/* Only activate VOU after the second buffer */
 	} else if (vou_dev->active->queue.next == &vb->queue) {
@@ -336,8 +337,8 @@ static void sh_vou_buf_queue(struct videobuf_queue *vq,
 
 		/* Register side switching with frame VSYNC */
 		sh_vou_reg_a_write(vou_dev, VOURCR, 5);
-		dev_dbg(vq->dev, "%s: second buffer status 0x%x\n", __func__,
-			sh_vou_reg_a_read(vou_dev, VOUSTR));
+		dev_dbg(vou_dev->v4l2_dev.dev, "%s: second buffer status 0x%x\n",
+			__func__, sh_vou_reg_a_read(vou_dev, VOUSTR));
 
 		/* Enable End-of-Frame (VSYNC) interrupts */
 		sh_vou_reg_a_write(vou_dev, VOUIR, 0x10004);
@@ -355,7 +356,7 @@ static void sh_vou_buf_release(struct videobuf_queue *vq,
 	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
 	unsigned long flags;
 
-	dev_dbg(vq->dev, "%s()\n", __func__);
+	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
 	spin_lock_irqsave(&vou_dev->lock, flags);
 
@@ -388,9 +389,9 @@ static struct videobuf_queue_ops sh_vou_video_qops = {
 static int sh_vou_querycap(struct file *file, void  *priv,
 			   struct v4l2_capability *cap)
 {
-	struct sh_vou_file *vou_file = priv;
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 
-	dev_dbg(vou_file->vbq.dev, "%s()\n", __func__);
+	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
 	strlcpy(cap->card, "SuperH VOU", sizeof(cap->card));
 	cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
@@ -401,12 +402,12 @@ static int sh_vou_querycap(struct file *file, void  *priv,
 static int sh_vou_enum_fmt_vid_out(struct file *file, void  *priv,
 				   struct v4l2_fmtdesc *fmt)
 {
-	struct sh_vou_file *vou_file = priv;
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 
 	if (fmt->index >= ARRAY_SIZE(vou_fmt))
 		return -EINVAL;
 
-	dev_dbg(vou_file->vbq.dev, "%s()\n", __func__);
+	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
 	fmt->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
 	strlcpy(fmt->description, vou_fmt[fmt->index].desc,
@@ -762,11 +763,11 @@ static int sh_vou_s_fmt_vid_out(struct file *file, void *priv,
 static int sh_vou_try_fmt_vid_out(struct file *file, void *priv,
 				  struct v4l2_format *fmt)
 {
-	struct sh_vou_file *vou_file = priv;
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 	struct v4l2_pix_format *pix = &fmt->fmt.pix;
 	int i;
 
-	dev_dbg(vou_file->vbq.dev, "%s()\n", __func__);
+	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
 	fmt->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
 	pix->field = V4L2_FIELD_NONE;
@@ -786,9 +787,10 @@ static int sh_vou_try_fmt_vid_out(struct file *file, void *priv,
 static int sh_vou_reqbufs(struct file *file, void *priv,
 			  struct v4l2_requestbuffers *req)
 {
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 	struct sh_vou_file *vou_file = priv;
 
-	dev_dbg(vou_file->vbq.dev, "%s()\n", __func__);
+	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
 	if (req->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		return -EINVAL;
@@ -799,27 +801,30 @@ static int sh_vou_reqbufs(struct file *file, void *priv,
 static int sh_vou_querybuf(struct file *file, void *priv,
 			   struct v4l2_buffer *b)
 {
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 	struct sh_vou_file *vou_file = priv;
 
-	dev_dbg(vou_file->vbq.dev, "%s()\n", __func__);
+	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
 	return videobuf_querybuf(&vou_file->vbq, b);
 }
 
 static int sh_vou_qbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 {
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 	struct sh_vou_file *vou_file = priv;
 
-	dev_dbg(vou_file->vbq.dev, "%s()\n", __func__);
+	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
 	return videobuf_qbuf(&vou_file->vbq, b);
 }
 
 static int sh_vou_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 {
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 	struct sh_vou_file *vou_file = priv;
 
-	dev_dbg(vou_file->vbq.dev, "%s()\n", __func__);
+	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
 	return videobuf_dqbuf(&vou_file->vbq, b, file->f_flags & O_NONBLOCK);
 }
@@ -831,7 +836,7 @@ static int sh_vou_streamon(struct file *file, void *priv,
 	struct sh_vou_file *vou_file = priv;
 	int ret;
 
-	dev_dbg(vou_file->vbq.dev, "%s()\n", __func__);
+	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
 	ret = v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0,
 					 video, s_stream, 1);
@@ -848,7 +853,7 @@ static int sh_vou_streamoff(struct file *file, void *priv,
 	struct sh_vou_device *vou_dev = video_drvdata(file);
 	struct sh_vou_file *vou_file = priv;
 
-	dev_dbg(vou_file->vbq.dev, "%s()\n", __func__);
+	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
 	/*
 	 * This calls buf_release from host driver's videobuf_queue_ops for all
@@ -1019,9 +1024,9 @@ static int sh_vou_s_crop(struct file *file, void *fh, const struct v4l2_crop *a)
 static int sh_vou_cropcap(struct file *file, void *priv,
 			  struct v4l2_cropcap *a)
 {
-	struct sh_vou_file *vou_file = priv;
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 
-	dev_dbg(vou_file->vbq.dev, "%s()\n", __func__);
+	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
 	a->type				= V4L2_BUF_TYPE_VIDEO_OUTPUT;
 	a->bounds.left			= 0;
@@ -1195,7 +1200,7 @@ static int sh_vou_release(struct file *file)
 	struct sh_vou_device *vou_dev = video_drvdata(file);
 	struct sh_vou_file *vou_file = file->private_data;
 
-	dev_dbg(vou_file->vbq.dev, "%s()\n", __func__);
+	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
 	if (!atomic_dec_return(&vou_dev->use_count)) {
 		mutex_lock(&vou_dev->fop_lock);
@@ -1218,7 +1223,7 @@ static int sh_vou_mmap(struct file *file, struct vm_area_struct *vma)
 	struct sh_vou_file *vou_file = file->private_data;
 	int ret;
 
-	dev_dbg(vou_file->vbq.dev, "%s()\n", __func__);
+	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
 	if (mutex_lock_interruptible(&vou_dev->fop_lock))
 		return -ERESTARTSYS;
@@ -1233,7 +1238,7 @@ static unsigned int sh_vou_poll(struct file *file, poll_table *wait)
 	struct sh_vou_file *vou_file = file->private_data;
 	unsigned int res;
 
-	dev_dbg(vou_file->vbq.dev, "%s()\n", __func__);
+	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
 	mutex_lock(&vou_dev->fop_lock);
 	res = videobuf_poll_stream(file, &vou_file->vbq, wait);
-- 
1.7.8.6

