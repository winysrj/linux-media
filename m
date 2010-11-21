Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39753 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab0KUUcx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Nov 2010 15:32:53 -0500
Received: from localhost.localdomain (unknown [91.178.49.10])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5FBD535C96
	for <linux-media@vger.kernel.org>; Sun, 21 Nov 2010 20:32:52 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/5] uvcvideo: Lock stream mutex when accessing format-related information
Date: Sun, 21 Nov 2010 21:32:52 +0100
Message-Id: <1290371573-14907-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1290371573-14907-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1290371573-14907-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The stream mutex protects access to the struct uvc_streaming ctrl,
cur_format and cur_frame fields as well as to the hardware probe
control. Lock it appropriately.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_v4l2.c  |   76 +++++++++++++++++++++++++----------
 drivers/media/video/uvc/uvc_video.c |    3 -
 drivers/media/video/uvc/uvcvideo.h  |    4 +-
 3 files changed, 57 insertions(+), 26 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 07dd235..b4615e2 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -226,12 +226,14 @@ static int uvc_v4l2_try_format(struct uvc_streaming *stream,
 	 * developers test their webcams with the Linux driver as well as with
 	 * the Windows driver).
 	 */
+	mutex_lock(&stream->mutex);
 	if (stream->dev->quirks & UVC_QUIRK_PROBE_EXTRAFIELDS)
 		probe->dwMaxVideoFrameSize =
 			stream->ctrl.dwMaxVideoFrameSize;
 
 	/* Probe the device. */
 	ret = uvc_probe_video(stream, probe);
+	mutex_unlock(&stream->mutex);
 	if (ret < 0)
 		goto done;
 
@@ -255,14 +257,21 @@ done:
 static int uvc_v4l2_get_format(struct uvc_streaming *stream,
 	struct v4l2_format *fmt)
 {
-	struct uvc_format *format = stream->cur_format;
-	struct uvc_frame *frame = stream->cur_frame;
+	struct uvc_format *format;
+	struct uvc_frame *frame;
+	int ret = 0;
 
 	if (fmt->type != stream->type)
 		return -EINVAL;
 
-	if (format == NULL || frame == NULL)
-		return -EINVAL;
+	mutex_lock(&stream->mutex);
+	format = stream->cur_format;
+	frame = stream->cur_frame;
+
+	if (format == NULL || frame == NULL) {
+		ret = -EINVAL;
+		goto done;
+	}
 
 	fmt->fmt.pix.pixelformat = format->fcc;
 	fmt->fmt.pix.width = frame->wWidth;
@@ -273,6 +282,8 @@ static int uvc_v4l2_get_format(struct uvc_streaming *stream,
 	fmt->fmt.pix.colorspace = format->colorspace;
 	fmt->fmt.pix.priv = 0;
 
+done:
+	mutex_unlock(&stream->mutex);
 	return 0;
 }
 
@@ -287,18 +298,24 @@ static int uvc_v4l2_set_format(struct uvc_streaming *stream,
 	if (fmt->type != stream->type)
 		return -EINVAL;
 
-	if (uvc_queue_allocated(&stream->queue))
-		return -EBUSY;
-
 	ret = uvc_v4l2_try_format(stream, fmt, &probe, &format, &frame);
 	if (ret < 0)
 		return ret;
 
+	mutex_lock(&stream->mutex);
+
+	if (uvc_queue_allocated(&stream->queue)) {
+		ret = -EBUSY;
+		goto done;
+	}
+
 	memcpy(&stream->ctrl, &probe, sizeof probe);
 	stream->cur_format = format;
 	stream->cur_frame = frame;
 
-	return 0;
+done:
+	mutex_unlock(&stream->mutex);
+	return ret;
 }
 
 static int uvc_v4l2_get_streamparm(struct uvc_streaming *stream,
@@ -309,7 +326,10 @@ static int uvc_v4l2_get_streamparm(struct uvc_streaming *stream,
 	if (parm->type != stream->type)
 		return -EINVAL;
 
+	mutex_lock(&stream->mutex);
 	numerator = stream->ctrl.dwFrameInterval;
+	mutex_unlock(&stream->mutex);
+
 	denominator = 10000000;
 	uvc_simplify_fraction(&numerator, &denominator, 8, 333);
 
@@ -336,7 +356,6 @@ static int uvc_v4l2_get_streamparm(struct uvc_streaming *stream,
 static int uvc_v4l2_set_streamparm(struct uvc_streaming *stream,
 		struct v4l2_streamparm *parm)
 {
-	struct uvc_frame *frame = stream->cur_frame;
 	struct uvc_streaming_control probe;
 	struct v4l2_fract timeperframe;
 	uint32_t interval;
@@ -345,28 +364,36 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming *stream,
 	if (parm->type != stream->type)
 		return -EINVAL;
 
-	if (uvc_queue_streaming(&stream->queue))
-		return -EBUSY;
-
 	if (parm->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		timeperframe = parm->parm.capture.timeperframe;
 	else
 		timeperframe = parm->parm.output.timeperframe;
 
-	memcpy(&probe, &stream->ctrl, sizeof probe);
 	interval = uvc_fraction_to_interval(timeperframe.numerator,
 		timeperframe.denominator);
-
 	uvc_trace(UVC_TRACE_FORMAT, "Setting frame interval to %u/%u (%u).\n",
 		timeperframe.numerator, timeperframe.denominator, interval);
-	probe.dwFrameInterval = uvc_try_frame_interval(frame, interval);
+
+	mutex_lock(&stream->mutex);
+
+	if (uvc_queue_streaming(&stream->queue)) {
+		mutex_unlock(&stream->mutex);
+		return -EBUSY;
+	}
+
+	memcpy(&probe, &stream->ctrl, sizeof probe);
+	probe.dwFrameInterval =
+		uvc_try_frame_interval(stream->cur_frame, interval);
 
 	/* Probe the device with the new settings. */
 	ret = uvc_probe_video(stream, &probe);
-	if (ret < 0)
+	if (ret < 0) {
+		mutex_unlock(&stream->mutex);
 		return ret;
+	}
 
 	memcpy(&stream->ctrl, &probe, sizeof probe);
+	mutex_unlock(&stream->mutex);
 
 	/* Return the actual frame period. */
 	timeperframe.numerator = probe.dwFrameInterval;
@@ -869,15 +896,17 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_CROPCAP:
 	{
 		struct v4l2_cropcap *ccap = arg;
-		struct uvc_frame *frame = stream->cur_frame;
 
 		if (ccap->type != stream->type)
 			return -EINVAL;
 
 		ccap->bounds.left = 0;
 		ccap->bounds.top = 0;
-		ccap->bounds.width = frame->wWidth;
-		ccap->bounds.height = frame->wHeight;
+
+		mutex_lock(&stream->mutex);
+		ccap->bounds.width = stream->cur_frame->wWidth;
+		ccap->bounds.height = stream->cur_frame->wHeight;
+		mutex_unlock(&stream->mutex);
 
 		ccap->defrect = ccap->bounds;
 
@@ -894,8 +923,6 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_REQBUFS:
 	{
 		struct v4l2_requestbuffers *rb = arg;
-		unsigned int bufsize =
-			stream->ctrl.dwMaxVideoFrameSize;
 
 		if (rb->type != stream->type ||
 		    rb->memory != V4L2_MEMORY_MMAP)
@@ -904,7 +931,10 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if ((ret = uvc_acquire_privileges(handle)) < 0)
 			return ret;
 
-		ret = uvc_alloc_buffers(&stream->queue, rb->count, bufsize);
+		mutex_lock(&stream->mutex);
+		ret = uvc_alloc_buffers(&stream->queue, rb->count,
+					stream->ctrl.dwMaxVideoFrameSize);
+		mutex_unlock(&stream->mutex);
 		if (ret < 0)
 			return ret;
 
@@ -952,7 +982,9 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (!uvc_has_privileges(handle))
 			return -EBUSY;
 
+		mutex_lock(&stream->mutex);
 		ret = uvc_video_enable(stream, 1);
+		mutex_unlock(&stream->mutex);
 		if (ret < 0)
 			return ret;
 		break;
diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 5555f01..5673d67 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -293,8 +293,6 @@ int uvc_probe_video(struct uvc_streaming *stream,
 	unsigned int i;
 	int ret;
 
-	mutex_lock(&stream->mutex);
-
 	/* Perform probing. The device should adjust the requested values
 	 * according to its capabilities. However, some devices, namely the
 	 * first generation UVC Logitech webcams, don't implement the Video
@@ -346,7 +344,6 @@ int uvc_probe_video(struct uvc_streaming *stream,
 	}
 
 done:
-	mutex_unlock(&stream->mutex);
 	return ret;
 }
 
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index ea893bc..45f01e7 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -436,7 +436,9 @@ struct uvc_streaming {
 	struct uvc_streaming_control ctrl;
 	struct uvc_format *cur_format;
 	struct uvc_frame *cur_frame;
-
+	/* Protect access to ctrl, cur_format, cur_frame and hardware video
+	 * probe control.
+	 */
 	struct mutex mutex;
 
 	unsigned int frozen : 1;
-- 
1.7.2.2

