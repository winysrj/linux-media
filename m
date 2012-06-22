Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2877 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706Ab2FVMV6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 08:21:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 30/34] vivi: use vb2 helper functions.
Date: Fri, 22 Jun 2012 14:21:24 +0200
Message-Id: <fc6d100b11b4859548404052e55a7a57f6564b34.1340366355.git.hans.verkuil@cisco.com>
In-Reply-To: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
References: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/vivi.c |  150 ++++----------------------------------------
 1 file changed, 12 insertions(+), 138 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 1e4da5e..f6d7c6e 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -790,27 +790,6 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	return 0;
 }
 
-static int buffer_init(struct vb2_buffer *vb)
-{
-	struct vivi_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
-
-	BUG_ON(NULL == dev->fmt);
-
-	/*
-	 * This callback is called once per buffer, after its allocation.
-	 *
-	 * Vivi does not allow changing format during streaming, but it is
-	 * possible to do so when streaming is paused (i.e. in streamoff state).
-	 * Buffers however are not freed when going into streamoff and so
-	 * buffer size verification has to be done in buffer_prepare, on each
-	 * qbuf.
-	 * It would be best to move verification code here to buf_init and
-	 * s_fmt though.
-	 */
-
-	return 0;
-}
-
 static int buffer_prepare(struct vb2_buffer *vb)
 {
 	struct vivi_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
@@ -848,20 +827,6 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static int buffer_finish(struct vb2_buffer *vb)
-{
-	struct vivi_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
-	dprintk(dev, 1, "%s\n", __func__);
-	return 0;
-}
-
-static void buffer_cleanup(struct vb2_buffer *vb)
-{
-	struct vivi_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
-	dprintk(dev, 1, "%s\n", __func__);
-
-}
-
 static void buffer_queue(struct vb2_buffer *vb)
 {
 	struct vivi_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
@@ -907,10 +872,7 @@ static void vivi_unlock(struct vb2_queue *vq)
 
 static struct vb2_ops vivi_video_qops = {
 	.queue_setup		= queue_setup,
-	.buf_init		= buffer_init,
 	.buf_prepare		= buffer_prepare,
-	.buf_finish		= buffer_finish,
-	.buf_cleanup		= buffer_cleanup,
 	.buf_queue		= buffer_queue,
 	.start_streaming	= start_streaming,
 	.stop_streaming		= stop_streaming,
@@ -1019,7 +981,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	if (ret < 0)
 		return ret;
 
-	if (vb2_is_streaming(q)) {
+	if (vb2_is_busy(q)) {
 		dprintk(dev, 1, "%s device busy\n", __func__);
 		return -EBUSY;
 	}
@@ -1033,43 +995,6 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_reqbufs(struct file *file, void *priv,
-			  struct v4l2_requestbuffers *p)
-{
-	struct vivi_dev *dev = video_drvdata(file);
-	return vb2_reqbufs(&dev->vb_vidq, p);
-}
-
-static int vidioc_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	struct vivi_dev *dev = video_drvdata(file);
-	return vb2_querybuf(&dev->vb_vidq, p);
-}
-
-static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	struct vivi_dev *dev = video_drvdata(file);
-	return vb2_qbuf(&dev->vb_vidq, p);
-}
-
-static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	struct vivi_dev *dev = video_drvdata(file);
-	return vb2_dqbuf(&dev->vb_vidq, p, file->f_flags & O_NONBLOCK);
-}
-
-static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-	struct vivi_dev *dev = video_drvdata(file);
-	return vb2_streamon(&dev->vb_vidq, i);
-}
-
-static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-	struct vivi_dev *dev = video_drvdata(file);
-	return vb2_streamoff(&dev->vb_vidq, i);
-}
-
 /* only one input in this sample driver */
 static int vidioc_enum_input(struct file *file, void *priv,
 				struct v4l2_input *inp)
@@ -1137,58 +1062,6 @@ static int vivi_s_ctrl(struct v4l2_ctrl *ctrl)
 	File operations for the device
    ------------------------------------------------------------------*/
 
-static ssize_t
-vivi_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
-{
-	struct vivi_dev *dev = video_drvdata(file);
-	int err;
-
-	dprintk(dev, 1, "read called\n");
-	mutex_lock(&dev->mutex);
-	err = vb2_read(&dev->vb_vidq, data, count, ppos,
-		       file->f_flags & O_NONBLOCK);
-	mutex_unlock(&dev->mutex);
-	return err;
-}
-
-static unsigned int
-vivi_poll(struct file *file, struct poll_table_struct *wait)
-{
-	struct vivi_dev *dev = video_drvdata(file);
-	struct vb2_queue *q = &dev->vb_vidq;
-
-	dprintk(dev, 1, "%s\n", __func__);
-	return vb2_poll(q, file, wait);
-}
-
-static int vivi_close(struct file *file)
-{
-	struct video_device  *vdev = video_devdata(file);
-	struct vivi_dev *dev = video_drvdata(file);
-
-	dprintk(dev, 1, "close called (dev=%s), file %p\n",
-		video_device_node_name(vdev), file);
-
-	if (v4l2_fh_is_singular_file(file))
-		vb2_queue_release(&dev->vb_vidq);
-	return v4l2_fh_release(file);
-}
-
-static int vivi_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct vivi_dev *dev = video_drvdata(file);
-	int ret;
-
-	dprintk(dev, 1, "mmap called, vma=0x%08lx\n", (unsigned long)vma);
-
-	ret = vb2_mmap(&dev->vb_vidq, vma);
-	dprintk(dev, 1, "vma start=0x%08lx, size=%ld, ret=%d\n",
-		(unsigned long)vma->vm_start,
-		(unsigned long)vma->vm_end - (unsigned long)vma->vm_start,
-		ret);
-	return ret;
-}
-
 static const struct v4l2_ctrl_ops vivi_ctrl_ops = {
 	.g_volatile_ctrl = vivi_g_volatile_ctrl,
 	.s_ctrl = vivi_s_ctrl,
@@ -1293,11 +1166,11 @@ static const struct v4l2_ctrl_config vivi_ctrl_int_menu = {
 static const struct v4l2_file_operations vivi_fops = {
 	.owner		= THIS_MODULE,
 	.open           = v4l2_fh_open,
-	.release        = vivi_close,
-	.read           = vivi_read,
-	.poll		= vivi_poll,
+	.release        = vb2_fop_release,
+	.read           = vb2_fop_read,
+	.poll		= vb2_fop_poll,
 	.unlocked_ioctl = video_ioctl2, /* V4L2 ioctl handler */
-	.mmap           = vivi_mmap,
+	.mmap           = vb2_fop_mmap,
 };
 
 static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
@@ -1306,15 +1179,15 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
 	.vidioc_g_fmt_vid_cap     = vidioc_g_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap   = vidioc_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap     = vidioc_s_fmt_vid_cap,
-	.vidioc_reqbufs       = vidioc_reqbufs,
-	.vidioc_querybuf      = vidioc_querybuf,
-	.vidioc_qbuf          = vidioc_qbuf,
-	.vidioc_dqbuf         = vidioc_dqbuf,
+	.vidioc_reqbufs       = vb2_ioctl_reqbufs,
+	.vidioc_querybuf      = vb2_ioctl_querybuf,
+	.vidioc_qbuf          = vb2_ioctl_qbuf,
+	.vidioc_dqbuf         = vb2_ioctl_dqbuf,
 	.vidioc_enum_input    = vidioc_enum_input,
 	.vidioc_g_input       = vidioc_g_input,
 	.vidioc_s_input       = vidioc_s_input,
-	.vidioc_streamon      = vidioc_streamon,
-	.vidioc_streamoff     = vidioc_streamoff,
+	.vidioc_streamon      = vb2_ioctl_streamon,
+	.vidioc_streamoff     = vb2_ioctl_streamoff,
 	.vidioc_log_status    = v4l2_ctrl_log_status,
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
@@ -1432,6 +1305,7 @@ static int __init vivi_create_instance(int inst)
 	*vfd = vivi_template;
 	vfd->debug = debug;
 	vfd->v4l2_dev = &dev->v4l2_dev;
+	vfd->queue = q;
 	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
 
 	/*
-- 
1.7.10

