Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43841 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbaHRRFv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Aug 2014 13:05:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-usb@vger.kernel.org
Cc: linux-media@vger.kernel.org,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Michael Grzeschik <mgr@pengutronix.de>
Subject: [PATCH 2/2] usb: gadget: f_uvc: Move to video_ioctl2
Date: Mon, 18 Aug 2014 19:06:17 +0200
Message-Id: <1408381577-31901-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1408381577-31901-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1408381577-31901-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify ioctl handling by using video_ioctl2.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/usb/gadget/function/f_uvc.c    |   1 +
 drivers/usb/gadget/function/uvc_v4l2.c | 298 +++++++++++++++++----------------
 2 files changed, 158 insertions(+), 141 deletions(-)

diff --git a/drivers/usb/gadget/function/f_uvc.c b/drivers/usb/gadget/function/f_uvc.c
index e9d625b..0b86aea 100644
--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -414,6 +414,7 @@ uvc_register_video(struct uvc_device *uvc)
 
 	video->v4l2_dev = &uvc->v4l2_dev;
 	video->fops = &uvc_v4l2_fops;
+	video->ioctl_ops = &uvc_v4l2_ioctl_ops;
 	video->release = video_device_release;
 	strlcpy(video->name, cdev->gadget->name, sizeof(video->name));
 
diff --git a/drivers/usb/gadget/function/uvc_v4l2.c b/drivers/usb/gadget/function/uvc_v4l2.c
index f22b878..14c3a37 100644
--- a/drivers/usb/gadget/function/uvc_v4l2.c
+++ b/drivers/usb/gadget/function/uvc_v4l2.c
@@ -48,7 +48,7 @@ uvc_send_response(struct uvc_device *uvc, struct uvc_request_data *data)
 }
 
 /* --------------------------------------------------------------------------
- * V4L2
+ * V4L2 ioctls
  */
 
 struct uvc_format
@@ -63,8 +63,29 @@ static struct uvc_format uvc_formats[] = {
 };
 
 static int
-uvc_v4l2_get_format(struct uvc_video *video, struct v4l2_format *fmt)
+uvc_v4l2_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct uvc_device *uvc = video_get_drvdata(vdev);
+	struct usb_composite_dev *cdev = uvc->func.config->cdev;
+
+	strlcpy(cap->driver, "g_uvc", sizeof(cap->driver));
+	strlcpy(cap->card, cdev->gadget->name, sizeof(cap->card));
+	strlcpy(cap->bus_info, dev_name(&cdev->gadget->dev),
+		sizeof(cap->bus_info));
+
+	cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+static int
+uvc_v4l2_get_format(struct file *file, void *fh, struct v4l2_format *fmt)
 {
+	struct video_device *vdev = video_devdata(file);
+	struct uvc_device *uvc = video_get_drvdata(vdev);
+	struct uvc_video *video = &uvc->video;
+
 	fmt->fmt.pix.pixelformat = video->fcc;
 	fmt->fmt.pix.width = video->width;
 	fmt->fmt.pix.height = video->height;
@@ -78,8 +99,11 @@ uvc_v4l2_get_format(struct uvc_video *video, struct v4l2_format *fmt)
 }
 
 static int
-uvc_v4l2_set_format(struct uvc_video *video, struct v4l2_format *fmt)
+uvc_v4l2_set_format(struct file *file, void *fh, struct v4l2_format *fmt)
 {
+	struct video_device *vdev = video_devdata(file);
+	struct uvc_device *uvc = video_get_drvdata(vdev);
+	struct uvc_video *video = &uvc->video;
 	struct uvc_format *format;
 	unsigned int imagesize;
 	unsigned int bpl;
@@ -116,192 +140,184 @@ uvc_v4l2_set_format(struct uvc_video *video, struct v4l2_format *fmt)
 }
 
 static int
-uvc_v4l2_open(struct file *file)
+uvc_v4l2_reqbufs(struct file *file, void *fh, struct v4l2_requestbuffers *b)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct uvc_device *uvc = video_get_drvdata(vdev);
-	struct uvc_file_handle *handle;
-
-	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
-	if (handle == NULL)
-		return -ENOMEM;
-
-	v4l2_fh_init(&handle->vfh, vdev);
-	v4l2_fh_add(&handle->vfh);
+	struct uvc_video *video = &uvc->video;
 
-	handle->device = &uvc->video;
-	file->private_data = &handle->vfh;
+	if (b->type != video->queue.queue.type)
+		return -EINVAL;
 
-	uvc_function_connect(uvc);
-	return 0;
+	return uvc_alloc_buffers(&video->queue, b);
 }
 
 static int
-uvc_v4l2_release(struct file *file)
+uvc_v4l2_querybuf(struct file *file, void *fh, struct v4l2_buffer *b)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct uvc_device *uvc = video_get_drvdata(vdev);
-	struct uvc_file_handle *handle = to_uvc_file_handle(file->private_data);
-	struct uvc_video *video = handle->device;
-
-	uvc_function_disconnect(uvc);
-
-	uvc_video_enable(video, 0);
-	uvc_free_buffers(&video->queue);
-
-	file->private_data = NULL;
-	v4l2_fh_del(&handle->vfh);
-	v4l2_fh_exit(&handle->vfh);
-	kfree(handle);
+	struct uvc_video *video = &uvc->video;
 
-	return 0;
+	return uvc_query_buffer(&video->queue, b);
 }
 
-static long
-uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
+static int
+uvc_v4l2_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct uvc_device *uvc = video_get_drvdata(vdev);
-	struct uvc_file_handle *handle = to_uvc_file_handle(file->private_data);
-	struct usb_composite_dev *cdev = uvc->func.config->cdev;
 	struct uvc_video *video = &uvc->video;
-	int ret = 0;
-
-	switch (cmd) {
-	/* Query capabilities */
-	case VIDIOC_QUERYCAP:
-	{
-		struct v4l2_capability *cap = arg;
-
-		memset(cap, 0, sizeof *cap);
-		strlcpy(cap->driver, "g_uvc", sizeof(cap->driver));
-		strlcpy(cap->card, cdev->gadget->name, sizeof(cap->card));
-		strlcpy(cap->bus_info, dev_name(&cdev->gadget->dev),
-			sizeof cap->bus_info);
-		cap->version = LINUX_VERSION_CODE;
-		cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
-		break;
-	}
-
-	/* Get & Set format */
-	case VIDIOC_G_FMT:
-	{
-		struct v4l2_format *fmt = arg;
+	int ret;
 
-		if (fmt->type != video->queue.queue.type)
-			return -EINVAL;
-
-		return uvc_v4l2_get_format(video, fmt);
-	}
+	ret = uvc_queue_buffer(&video->queue, b);
+	if (ret < 0)
+		return ret;
 
-	case VIDIOC_S_FMT:
-	{
-		struct v4l2_format *fmt = arg;
+	return uvc_video_pump(video);
+}
 
-		if (fmt->type != video->queue.queue.type)
-			return -EINVAL;
+static int
+uvc_v4l2_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct uvc_device *uvc = video_get_drvdata(vdev);
+	struct uvc_video *video = &uvc->video;
 
-		return uvc_v4l2_set_format(video, fmt);
-	}
+	return uvc_dequeue_buffer(&video->queue, b, file->f_flags & O_NONBLOCK);
+}
 
-	/* Buffers & streaming */
-	case VIDIOC_REQBUFS:
-	{
-		struct v4l2_requestbuffers *rb = arg;
+static int
+uvc_v4l2_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct uvc_device *uvc = video_get_drvdata(vdev);
+	struct uvc_video *video = &uvc->video;
+	int ret;
 
-		if (rb->type != video->queue.queue.type)
-			return -EINVAL;
+	if (type != video->queue.queue.type)
+		return -EINVAL;
 
-		ret = uvc_alloc_buffers(&video->queue, rb);
-		if (ret < 0)
-			return ret;
+	/* Enable UVC video. */
+	ret = uvc_video_enable(video, 1);
+	if (ret < 0)
+		return ret;
 
-		ret = 0;
-		break;
-	}
+	/*
+	 * Complete the alternate setting selection setup phase now that
+	 * userspace is ready to provide video frames.
+	 */
+	uvc_function_setup_continue(uvc);
+	uvc->state = UVC_STATE_STREAMING;
 
-	case VIDIOC_QUERYBUF:
-	{
-		struct v4l2_buffer *buf = arg;
+	return 0;
+}
 
-		return uvc_query_buffer(&video->queue, buf);
-	}
+static int
+uvc_v4l2_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct uvc_device *uvc = video_get_drvdata(vdev);
+	struct uvc_video *video = &uvc->video;
 
-	case VIDIOC_QBUF:
-		if ((ret = uvc_queue_buffer(&video->queue, arg)) < 0)
-			return ret;
+	if (type != video->queue.queue.type)
+		return -EINVAL;
 
-		return uvc_video_pump(video);
+	return uvc_video_enable(video, 0);
+}
 
-	case VIDIOC_DQBUF:
-		return uvc_dequeue_buffer(&video->queue, arg,
-			file->f_flags & O_NONBLOCK);
+static int
+uvc_v4l2_subscribe_event(struct v4l2_fh *fh,
+			 const struct v4l2_event_subscription *sub)
+{
+	if (sub->type < UVC_EVENT_FIRST || sub->type > UVC_EVENT_LAST)
+		return -EINVAL;
 
-	case VIDIOC_STREAMON:
-	{
-		int *type = arg;
+	return v4l2_event_subscribe(fh, sub, 2, NULL);
+}
 
-		if (*type != video->queue.queue.type)
-			return -EINVAL;
+static int
+uvc_v4l2_unsubscribe_event(struct v4l2_fh *fh,
+			   const struct v4l2_event_subscription *sub)
+{
+	return v4l2_event_unsubscribe(fh, sub);
+}
 
-		/* Enable UVC video. */
-		ret = uvc_video_enable(video, 1);
-		if (ret < 0)
-			return ret;
+static long
+uvc_v4l2_ioctl_default(struct file *file, void *fh, bool valid_prio,
+		       unsigned int cmd, void *arg)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct uvc_device *uvc = video_get_drvdata(vdev);
 
-		/*
-		 * Complete the alternate setting selection setup phase now that
-		 * userspace is ready to provide video frames.
-		 */
-		uvc_function_setup_continue(uvc);
-		uvc->state = UVC_STATE_STREAMING;
+	switch (cmd) {
+	case UVCIOC_SEND_RESPONSE:
+		return uvc_send_response(uvc, arg);
 
-		return 0;
+	default:
+		return -ENOIOCTLCMD;
 	}
+}
 
-	case VIDIOC_STREAMOFF:
-	{
-		int *type = arg;
+static const struct v4l2_ioctl_ops uvc_v4l2_ioctl_ops = {
+	.vidioc_querycap = uvc_v4l2_querycap,
+	.vidioc_g_fmt_vid_out = uvc_v4l2_get_format,
+	.vidioc_s_fmt_vid_out = uvc_v4l2_set_format,
+	.vidioc_reqbufs = uvc_v4l2_reqbufs,
+	.vidioc_querybuf = uvc_v4l2_querybuf,
+	.vidioc_qbuf = uvc_v4l2_qbuf,
+	.vidioc_dqbuf = uvc_v4l2_dqbuf,
+	.vidioc_streamon = uvc_v4l2_streamon,
+	.vidioc_streamoff = uvc_v4l2_streamoff,
+	.vidioc_subscribe_event = uvc_v4l2_subscribe_event,
+	.vidioc_unsubscribe_event = uvc_v4l2_unsubscribe_event,
+	.vidioc_default = uvc_v4l2_ioctl_default,
+};
 
-		if (*type != video->queue.queue.type)
-			return -EINVAL;
+/* --------------------------------------------------------------------------
+ * V4L2
+ */
 
-		return uvc_video_enable(video, 0);
-	}
+static int
+uvc_v4l2_open(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct uvc_device *uvc = video_get_drvdata(vdev);
+	struct uvc_file_handle *handle;
 
-	/* Events */
-	case VIDIOC_DQEVENT:
-		return v4l2_event_dequeue(&handle->vfh, arg,
-					 file->f_flags & O_NONBLOCK);
+	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
+	if (handle == NULL)
+		return -ENOMEM;
 
-	case VIDIOC_SUBSCRIBE_EVENT:
-	{
-		struct v4l2_event_subscription *sub = arg;
+	v4l2_fh_init(&handle->vfh, vdev);
+	v4l2_fh_add(&handle->vfh);
 
-		if (sub->type < UVC_EVENT_FIRST || sub->type > UVC_EVENT_LAST)
-			return -EINVAL;
+	handle->device = &uvc->video;
+	file->private_data = &handle->vfh;
 
-		return v4l2_event_subscribe(&handle->vfh, arg, 2, NULL);
-	}
+	uvc_function_connect(uvc);
+	return 0;
+}
 
-	case VIDIOC_UNSUBSCRIBE_EVENT:
-		return v4l2_event_unsubscribe(&handle->vfh, arg);
+static int
+uvc_v4l2_release(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct uvc_device *uvc = video_get_drvdata(vdev);
+	struct uvc_file_handle *handle = to_uvc_file_handle(file->private_data);
+	struct uvc_video *video = handle->device;
 
-	case UVCIOC_SEND_RESPONSE:
-		ret = uvc_send_response(uvc, arg);
-		break;
+	uvc_function_disconnect(uvc);
 
-	default:
-		return -ENOIOCTLCMD;
-	}
+	uvc_video_enable(video, 0);
+	uvc_free_buffers(&video->queue);
 
-	return ret;
-}
+	file->private_data = NULL;
+	v4l2_fh_del(&handle->vfh);
+	v4l2_fh_exit(&handle->vfh);
+	kfree(handle);
 
-static long
-uvc_v4l2_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	return video_usercopy(file, cmd, arg, uvc_v4l2_do_ioctl);
+	return 0;
 }
 
 static int
@@ -338,7 +354,7 @@ static struct v4l2_file_operations uvc_v4l2_fops = {
 	.owner		= THIS_MODULE,
 	.open		= uvc_v4l2_open,
 	.release	= uvc_v4l2_release,
-	.ioctl		= uvc_v4l2_ioctl,
+	.ioctl		= video_ioctl2,
 	.mmap		= uvc_v4l2_mmap,
 	.poll		= uvc_v4l2_poll,
 #ifndef CONFIG_MMU
-- 
1.8.5.5

