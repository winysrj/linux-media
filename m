Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51710 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933439AbaJaPJr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 11:09:47 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 50D7F217D2
	for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 16:07:34 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 02/10] uvcvideo: Move to video_ioctl2
Date: Fri, 31 Oct 2014 17:09:43 +0200
Message-Id: <1414768191-4536-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1414768191-4536-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1414768191-4536-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify ioctl handling by using video_ioctl2.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

---

Changes since v1:

- Don't memset cap to 0 in uvc_ioctl_querycap
---
 drivers/media/usb/uvc/uvc_driver.c |    1 +
 drivers/media/usb/uvc/uvc_v4l2.c   | 1010 ++++++++++++++++++++----------------
 drivers/media/usb/uvc/uvcvideo.h   |    2 +-
 3 files changed, 559 insertions(+), 454 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index a327f3d..30163432 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1760,6 +1760,7 @@ static int uvc_register_video(struct uvc_device *dev,
 	 */
 	vdev->v4l2_dev = &dev->vdev;
 	vdev->fops = &uvc_fops;
+	vdev->ioctl_ops = &uvc_ioctl_ops;
 	vdev->release = uvc_release;
 	vdev->prio = &stream->chain->prio;
 	if (stream->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 378ae02..a16fe21 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -551,553 +551,635 @@ static int uvc_v4l2_release(struct file *file)
 	return 0;
 }
 
-static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
+static int uvc_ioctl_querycap(struct file *file, void *fh,
+			      struct v4l2_capability *cap)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct uvc_fh *handle = file->private_data;
 	struct uvc_video_chain *chain = handle->chain;
 	struct uvc_streaming *stream = handle->stream;
-	long ret = 0;
 
-	switch (cmd) {
-	/* Query capabilities */
-	case VIDIOC_QUERYCAP:
-	{
-		struct v4l2_capability *cap = arg;
-
-		memset(cap, 0, sizeof *cap);
-		strlcpy(cap->driver, "uvcvideo", sizeof cap->driver);
-		strlcpy(cap->card, vdev->name, sizeof cap->card);
-		usb_make_path(stream->dev->udev,
-			      cap->bus_info, sizeof(cap->bus_info));
-		cap->version = LINUX_VERSION_CODE;
-		cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
-				  | chain->caps;
-		if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-			cap->device_caps = V4L2_CAP_VIDEO_CAPTURE
-					 | V4L2_CAP_STREAMING;
-		else
-			cap->device_caps = V4L2_CAP_VIDEO_OUTPUT
-					 | V4L2_CAP_STREAMING;
-		break;
-	}
+	strlcpy(cap->driver, "uvcvideo", sizeof(cap->driver));
+	strlcpy(cap->card, vdev->name, sizeof(cap->card));
+	usb_make_path(stream->dev->udev, cap->bus_info, sizeof(cap->bus_info));
+	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
+			  | chain->caps;
+	if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	else
+		cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
 
-	/* Priority */
-	case VIDIOC_G_PRIORITY:
-		*(u32 *)arg = v4l2_prio_max(vdev->prio);
-		break;
+	return 0;
+}
 
-	case VIDIOC_S_PRIORITY:
-		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
-		if (ret < 0)
-			return ret;
+static int uvc_ioctl_enum_fmt(struct uvc_streaming *stream,
+			      struct v4l2_fmtdesc *fmt)
+{
+	struct uvc_format *format;
+	enum v4l2_buf_type type = fmt->type;
+	__u32 index = fmt->index;
 
-		return v4l2_prio_change(vdev->prio, &handle->vfh.prio,
-					*(u32 *)arg);
+	if (fmt->type != stream->type || fmt->index >= stream->nformats)
+		return -EINVAL;
 
-	/* Get, Set & Query control */
-	case VIDIOC_QUERYCTRL:
-		return uvc_query_v4l2_ctrl(chain, arg);
+	memset(fmt, 0, sizeof(*fmt));
+	fmt->index = index;
+	fmt->type = type;
+
+	format = &stream->format[fmt->index];
+	fmt->flags = 0;
+	if (format->flags & UVC_FMT_FLAG_COMPRESSED)
+		fmt->flags |= V4L2_FMT_FLAG_COMPRESSED;
+	strlcpy(fmt->description, format->name, sizeof(fmt->description));
+	fmt->description[sizeof(fmt->description) - 1] = 0;
+	fmt->pixelformat = format->fcc;
+	return 0;
+}
 
-	case VIDIOC_G_CTRL:
-	{
-		struct v4l2_control *ctrl = arg;
-		struct v4l2_ext_control xctrl;
+static int uvc_ioctl_enum_fmt_vid_cap(struct file *file, void *fh,
+				      struct v4l2_fmtdesc *fmt)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_streaming *stream = handle->stream;
 
-		memset(&xctrl, 0, sizeof xctrl);
-		xctrl.id = ctrl->id;
+	return uvc_ioctl_enum_fmt(stream, fmt);
+}
 
-		ret = uvc_ctrl_begin(chain);
-		if (ret < 0)
-			return ret;
+static int uvc_ioctl_enum_fmt_vid_out(struct file *file, void *fh,
+				      struct v4l2_fmtdesc *fmt)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_streaming *stream = handle->stream;
 
-		ret = uvc_ctrl_get(chain, &xctrl);
-		uvc_ctrl_rollback(handle);
-		if (ret >= 0)
-			ctrl->value = xctrl.value;
-		break;
-	}
+	return uvc_ioctl_enum_fmt(stream, fmt);
+}
 
-	case VIDIOC_S_CTRL:
-	{
-		struct v4l2_control *ctrl = arg;
-		struct v4l2_ext_control xctrl;
+static int uvc_ioctl_g_fmt_vid_cap(struct file *file, void *fh,
+				   struct v4l2_format *fmt)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_streaming *stream = handle->stream;
 
-		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
-		if (ret < 0)
-			return ret;
+	return uvc_v4l2_get_format(stream, fmt);
+}
 
-		memset(&xctrl, 0, sizeof xctrl);
-		xctrl.id = ctrl->id;
-		xctrl.value = ctrl->value;
+static int uvc_ioctl_g_fmt_vid_out(struct file *file, void *fh,
+				   struct v4l2_format *fmt)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_streaming *stream = handle->stream;
 
-		ret = uvc_ctrl_begin(chain);
-		if (ret < 0)
-			return ret;
+	return uvc_v4l2_get_format(stream, fmt);
+}
 
-		ret = uvc_ctrl_set(chain, &xctrl);
-		if (ret < 0) {
-			uvc_ctrl_rollback(handle);
-			return ret;
-		}
-		ret = uvc_ctrl_commit(handle, &xctrl, 1);
-		if (ret == 0)
-			ctrl->value = xctrl.value;
-		break;
-	}
+static int uvc_ioctl_s_fmt_vid_cap(struct file *file, void *fh,
+				   struct v4l2_format *fmt)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_streaming *stream = handle->stream;
+	int ret;
 
-	case VIDIOC_QUERYMENU:
-		return uvc_query_v4l2_menu(chain, arg);
+	ret = uvc_acquire_privileges(handle);
+	if (ret < 0)
+		return ret;
 
-	case VIDIOC_G_EXT_CTRLS:
-	{
-		struct v4l2_ext_controls *ctrls = arg;
-		struct v4l2_ext_control *ctrl = ctrls->controls;
-		unsigned int i;
+	return uvc_v4l2_set_format(stream, fmt);
+}
 
-		ret = uvc_ctrl_begin(chain);
-		if (ret < 0)
-			return ret;
+static int uvc_ioctl_s_fmt_vid_out(struct file *file, void *fh,
+				   struct v4l2_format *fmt)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_streaming *stream = handle->stream;
+	int ret;
 
-		for (i = 0; i < ctrls->count; ++ctrl, ++i) {
-			ret = uvc_ctrl_get(chain, ctrl);
-			if (ret < 0) {
-				uvc_ctrl_rollback(handle);
-				ctrls->error_idx = i;
-				return ret;
-			}
-		}
-		ctrls->error_idx = 0;
-		ret = uvc_ctrl_rollback(handle);
-		break;
-	}
+	ret = uvc_acquire_privileges(handle);
+	if (ret < 0)
+		return ret;
 
-	case VIDIOC_S_EXT_CTRLS:
-		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
-		if (ret < 0)
-			return ret;
-		/* Fall through */
-	case VIDIOC_TRY_EXT_CTRLS:
-	{
-		struct v4l2_ext_controls *ctrls = arg;
-		struct v4l2_ext_control *ctrl = ctrls->controls;
-		unsigned int i;
-
-		ret = uvc_ctrl_begin(chain);
-		if (ret < 0)
-			return ret;
+	return uvc_v4l2_set_format(stream, fmt);
+}
 
-		for (i = 0; i < ctrls->count; ++ctrl, ++i) {
-			ret = uvc_ctrl_set(chain, ctrl);
-			if (ret < 0) {
-				uvc_ctrl_rollback(handle);
-				ctrls->error_idx = cmd == VIDIOC_S_EXT_CTRLS
-						 ? ctrls->count : i;
-				return ret;
-			}
-		}
+static int uvc_ioctl_try_fmt_vid_cap(struct file *file, void *fh,
+				     struct v4l2_format *fmt)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_streaming *stream = handle->stream;
+	struct uvc_streaming_control probe;
 
-		ctrls->error_idx = 0;
+	return uvc_v4l2_try_format(stream, fmt, &probe, NULL, NULL);
+}
 
-		if (cmd == VIDIOC_S_EXT_CTRLS)
-			ret = uvc_ctrl_commit(handle,
-					      ctrls->controls, ctrls->count);
-		else
-			ret = uvc_ctrl_rollback(handle);
-		break;
-	}
+static int uvc_ioctl_try_fmt_vid_out(struct file *file, void *fh,
+				     struct v4l2_format *fmt)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_streaming *stream = handle->stream;
+	struct uvc_streaming_control probe;
 
-	/* Get, Set & Enum input */
-	case VIDIOC_ENUMINPUT:
-	{
-		const struct uvc_entity *selector = chain->selector;
-		struct v4l2_input *input = arg;
-		struct uvc_entity *iterm = NULL;
-		u32 index = input->index;
-		int pin = 0;
-
-		if (selector == NULL ||
-		    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
-			if (index != 0)
-				return -EINVAL;
-			list_for_each_entry(iterm, &chain->entities, chain) {
-				if (UVC_ENTITY_IS_ITERM(iterm))
-					break;
-			}
-			pin = iterm->id;
-		} else if (index < selector->bNrInPins) {
-			pin = selector->baSourceID[index];
-			list_for_each_entry(iterm, &chain->entities, chain) {
-				if (!UVC_ENTITY_IS_ITERM(iterm))
-					continue;
-				if (iterm->id == pin)
-					break;
-			}
-		}
+	return uvc_v4l2_try_format(stream, fmt, &probe, NULL, NULL);
+}
 
-		if (iterm == NULL || iterm->id != pin)
-			return -EINVAL;
+static int uvc_ioctl_reqbufs(struct file *file, void *fh,
+			     struct v4l2_requestbuffers *rb)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_streaming *stream = handle->stream;
+	int ret;
 
-		memset(input, 0, sizeof *input);
-		input->index = index;
-		strlcpy(input->name, iterm->name, sizeof input->name);
-		if (UVC_ENTITY_TYPE(iterm) == UVC_ITT_CAMERA)
-			input->type = V4L2_INPUT_TYPE_CAMERA;
-		break;
-	}
+	ret = uvc_acquire_privileges(handle);
+	if (ret < 0)
+		return ret;
 
-	case VIDIOC_G_INPUT:
-	{
-		u8 input;
+	mutex_lock(&stream->mutex);
+	ret = uvc_alloc_buffers(&stream->queue, rb);
+	mutex_unlock(&stream->mutex);
+	if (ret < 0)
+		return ret;
 
-		if (chain->selector == NULL ||
-		    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
-			*(int *)arg = 0;
-			break;
-		}
+	if (ret == 0)
+		uvc_dismiss_privileges(handle);
 
-		ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR,
-			chain->selector->id, chain->dev->intfnum,
-			UVC_SU_INPUT_SELECT_CONTROL, &input, 1);
-		if (ret < 0)
-			return ret;
+	return 0;
+}
 
-		*(int *)arg = input - 1;
-		break;
-	}
+static int uvc_ioctl_querybuf(struct file *file, void *fh,
+			      struct v4l2_buffer *buf)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_streaming *stream = handle->stream;
 
-	case VIDIOC_S_INPUT:
-	{
-		u32 input = *(u32 *)arg + 1;
+	if (!uvc_has_privileges(handle))
+		return -EBUSY;
 
-		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
-		if (ret < 0)
-			return ret;
+	return uvc_query_buffer(&stream->queue, buf);
+}
 
-		if ((ret = uvc_acquire_privileges(handle)) < 0)
-			return ret;
+static int uvc_ioctl_qbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_streaming *stream = handle->stream;
 
-		if (chain->selector == NULL ||
-		    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
-			if (input != 1)
-				return -EINVAL;
-			break;
-		}
+	if (!uvc_has_privileges(handle))
+		return -EBUSY;
 
-		if (input == 0 || input > chain->selector->bNrInPins)
-			return -EINVAL;
+	return uvc_queue_buffer(&stream->queue, buf);
+}
 
-		return uvc_query_ctrl(chain->dev, UVC_SET_CUR,
-			chain->selector->id, chain->dev->intfnum,
-			UVC_SU_INPUT_SELECT_CONTROL, &input, 1);
-	}
+static int uvc_ioctl_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_streaming *stream = handle->stream;
 
-	/* Try, Get, Set & Enum format */
-	case VIDIOC_ENUM_FMT:
-	{
-		struct v4l2_fmtdesc *fmt = arg;
-		struct uvc_format *format;
-		enum v4l2_buf_type type = fmt->type;
-		__u32 index = fmt->index;
+	if (!uvc_has_privileges(handle))
+		return -EBUSY;
 
-		if (fmt->type != stream->type ||
-		    fmt->index >= stream->nformats)
-			return -EINVAL;
+	return uvc_dequeue_buffer(&stream->queue, buf,
+				  file->f_flags & O_NONBLOCK);
+}
 
-		memset(fmt, 0, sizeof(*fmt));
-		fmt->index = index;
-		fmt->type = type;
-
-		format = &stream->format[fmt->index];
-		fmt->flags = 0;
-		if (format->flags & UVC_FMT_FLAG_COMPRESSED)
-			fmt->flags |= V4L2_FMT_FLAG_COMPRESSED;
-		strlcpy(fmt->description, format->name,
-			sizeof fmt->description);
-		fmt->description[sizeof fmt->description - 1] = 0;
-		fmt->pixelformat = format->fcc;
-		break;
-	}
+static int uvc_ioctl_create_bufs(struct file *file, void *fh,
+				  struct v4l2_create_buffers *cb)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_streaming *stream = handle->stream;
+	int ret;
 
-	case VIDIOC_TRY_FMT:
-	{
-		struct uvc_streaming_control probe;
+	ret = uvc_acquire_privileges(handle);
+	if (ret < 0)
+		return ret;
 
-		return uvc_v4l2_try_format(stream, arg, &probe, NULL, NULL);
-	}
+	return uvc_create_buffers(&stream->queue, cb);
+}
 
-	case VIDIOC_S_FMT:
-		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
-		if (ret < 0)
-			return ret;
+static int uvc_ioctl_streamon(struct file *file, void *fh,
+			      enum v4l2_buf_type type)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_streaming *stream = handle->stream;
+	int ret;
 
-		if ((ret = uvc_acquire_privileges(handle)) < 0)
-			return ret;
+	if (type != stream->type)
+		return -EINVAL;
+
+	if (!uvc_has_privileges(handle))
+		return -EBUSY;
+
+	mutex_lock(&stream->mutex);
+	ret = uvc_video_enable(stream, 1);
+	mutex_unlock(&stream->mutex);
 
-		return uvc_v4l2_set_format(stream, arg);
+	return ret;
+}
 
-	case VIDIOC_G_FMT:
-		return uvc_v4l2_get_format(stream, arg);
+static int uvc_ioctl_streamoff(struct file *file, void *fh,
+			       enum v4l2_buf_type type)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_streaming *stream = handle->stream;
+	int ret;
 
-	/* Frame size enumeration */
-	case VIDIOC_ENUM_FRAMESIZES:
-	{
-		struct v4l2_frmsizeenum *fsize = arg;
-		struct uvc_format *format = NULL;
-		struct uvc_frame *frame;
-		int i;
+	if (type != stream->type)
+		return -EINVAL;
 
-		/* Look for the given pixel format */
-		for (i = 0; i < stream->nformats; i++) {
-			if (stream->format[i].fcc ==
-					fsize->pixel_format) {
-				format = &stream->format[i];
-				break;
-			}
-		}
-		if (format == NULL)
-			return -EINVAL;
+	if (!uvc_has_privileges(handle))
+		return -EBUSY;
 
-		if (fsize->index >= format->nframes)
-			return -EINVAL;
+	mutex_lock(&stream->mutex);
+	ret = uvc_video_enable(stream, 0);
+	mutex_unlock(&stream->mutex);
 
-		frame = &format->frame[fsize->index];
-		fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
-		fsize->discrete.width = frame->wWidth;
-		fsize->discrete.height = frame->wHeight;
-		break;
-	}
+	return ret;
+}
 
-	/* Frame interval enumeration */
-	case VIDIOC_ENUM_FRAMEINTERVALS:
-	{
-		struct v4l2_frmivalenum *fival = arg;
-		struct uvc_format *format = NULL;
-		struct uvc_frame *frame = NULL;
-		int i;
-
-		/* Look for the given pixel format and frame size */
-		for (i = 0; i < stream->nformats; i++) {
-			if (stream->format[i].fcc ==
-					fival->pixel_format) {
-				format = &stream->format[i];
-				break;
-			}
-		}
-		if (format == NULL)
+static int uvc_ioctl_enum_input(struct file *file, void *fh,
+				struct v4l2_input *input)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_video_chain *chain = handle->chain;
+	const struct uvc_entity *selector = chain->selector;
+	struct uvc_entity *iterm = NULL;
+	u32 index = input->index;
+	int pin = 0;
+
+	if (selector == NULL ||
+	    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
+		if (index != 0)
 			return -EINVAL;
-
-		for (i = 0; i < format->nframes; i++) {
-			if (format->frame[i].wWidth == fival->width &&
-			    format->frame[i].wHeight == fival->height) {
-				frame = &format->frame[i];
+		list_for_each_entry(iterm, &chain->entities, chain) {
+			if (UVC_ENTITY_IS_ITERM(iterm))
 				break;
-			}
 		}
-		if (frame == NULL)
-			return -EINVAL;
-
-		if (frame->bFrameIntervalType) {
-			if (fival->index >= frame->bFrameIntervalType)
-				return -EINVAL;
-
-			fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
-			fival->discrete.numerator =
-				frame->dwFrameInterval[fival->index];
-			fival->discrete.denominator = 10000000;
-			uvc_simplify_fraction(&fival->discrete.numerator,
-				&fival->discrete.denominator, 8, 333);
-		} else {
-			fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
-			fival->stepwise.min.numerator =
-				frame->dwFrameInterval[0];
-			fival->stepwise.min.denominator = 10000000;
-			fival->stepwise.max.numerator =
-				frame->dwFrameInterval[1];
-			fival->stepwise.max.denominator = 10000000;
-			fival->stepwise.step.numerator =
-				frame->dwFrameInterval[2];
-			fival->stepwise.step.denominator = 10000000;
-			uvc_simplify_fraction(&fival->stepwise.min.numerator,
-				&fival->stepwise.min.denominator, 8, 333);
-			uvc_simplify_fraction(&fival->stepwise.max.numerator,
-				&fival->stepwise.max.denominator, 8, 333);
-			uvc_simplify_fraction(&fival->stepwise.step.numerator,
-				&fival->stepwise.step.denominator, 8, 333);
+		pin = iterm->id;
+	} else if (index < selector->bNrInPins) {
+		pin = selector->baSourceID[index];
+		list_for_each_entry(iterm, &chain->entities, chain) {
+			if (!UVC_ENTITY_IS_ITERM(iterm))
+				continue;
+			if (iterm->id == pin)
+				break;
 		}
-		break;
 	}
 
-	/* Get & Set streaming parameters */
-	case VIDIOC_G_PARM:
-		return uvc_v4l2_get_streamparm(stream, arg);
+	if (iterm == NULL || iterm->id != pin)
+		return -EINVAL;
 
-	case VIDIOC_S_PARM:
-		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
-		if (ret < 0)
-			return ret;
+	memset(input, 0, sizeof(*input));
+	input->index = index;
+	strlcpy(input->name, iterm->name, sizeof(input->name));
+	if (UVC_ENTITY_TYPE(iterm) == UVC_ITT_CAMERA)
+		input->type = V4L2_INPUT_TYPE_CAMERA;
 
-		if ((ret = uvc_acquire_privileges(handle)) < 0)
-			return ret;
+	return 0;
+}
 
-		return uvc_v4l2_set_streamparm(stream, arg);
+static int uvc_ioctl_g_input(struct file *file, void *fh, unsigned int *input)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_video_chain *chain = handle->chain;
+	int ret;
+	u8 i;
 
-	/* Cropping and scaling */
-	case VIDIOC_CROPCAP:
-	{
-		struct v4l2_cropcap *ccap = arg;
+	if (chain->selector == NULL ||
+	    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
+		*input = 0;
+		return 0;
+	}
 
-		if (ccap->type != stream->type)
-			return -EINVAL;
+	ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR, chain->selector->id,
+			     chain->dev->intfnum,  UVC_SU_INPUT_SELECT_CONTROL,
+			     &i, 1);
+	if (ret < 0)
+		return ret;
 
-		ccap->bounds.left = 0;
-		ccap->bounds.top = 0;
+	*input = i - 1;
+	return 0;
+}
 
-		mutex_lock(&stream->mutex);
-		ccap->bounds.width = stream->cur_frame->wWidth;
-		ccap->bounds.height = stream->cur_frame->wHeight;
-		mutex_unlock(&stream->mutex);
+static int uvc_ioctl_s_input(struct file *file, void *fh, unsigned int input)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_video_chain *chain = handle->chain;
+	int ret;
+	u32 i;
 
-		ccap->defrect = ccap->bounds;
+	ret = uvc_acquire_privileges(handle);
+	if (ret < 0)
+		return ret;
 
-		ccap->pixelaspect.numerator = 1;
-		ccap->pixelaspect.denominator = 1;
-		break;
+	if (chain->selector == NULL ||
+	    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
+		if (input)
+			return -EINVAL;
+		return 0;
 	}
 
-	case VIDIOC_G_CROP:
-	case VIDIOC_S_CROP:
-		return -ENOTTY;
+	if (input >= chain->selector->bNrInPins)
+		return -EINVAL;
 
-	/* Buffers & streaming */
-	case VIDIOC_REQBUFS:
-		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
-		if (ret < 0)
-			return ret;
+	i = input + 1;
+	return uvc_query_ctrl(chain->dev, UVC_SET_CUR, chain->selector->id,
+			      chain->dev->intfnum, UVC_SU_INPUT_SELECT_CONTROL,
+			      &i, 1);
+}
 
-		if ((ret = uvc_acquire_privileges(handle)) < 0)
-			return ret;
+static int uvc_ioctl_queryctrl(struct file *file, void *fh,
+			       struct v4l2_queryctrl *qc)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_video_chain *chain = handle->chain;
 
-		mutex_lock(&stream->mutex);
-		ret = uvc_alloc_buffers(&stream->queue, arg);
-		mutex_unlock(&stream->mutex);
-		if (ret < 0)
-			return ret;
+	return uvc_query_v4l2_ctrl(chain, qc);
+}
 
-		if (ret == 0)
-			uvc_dismiss_privileges(handle);
+static int uvc_ioctl_g_ctrl(struct file *file, void *fh,
+			    struct v4l2_control *ctrl)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_video_chain *chain = handle->chain;
+	struct v4l2_ext_control xctrl;
+	int ret;
 
-		ret = 0;
-		break;
+	memset(&xctrl, 0, sizeof(xctrl));
+	xctrl.id = ctrl->id;
 
-	case VIDIOC_QUERYBUF:
-	{
-		struct v4l2_buffer *buf = arg;
+	ret = uvc_ctrl_begin(chain);
+	if (ret < 0)
+		return ret;
 
-		if (!uvc_has_privileges(handle))
-			return -EBUSY;
+	ret = uvc_ctrl_get(chain, &xctrl);
+	uvc_ctrl_rollback(handle);
+	if (ret < 0)
+		return ret;
 
-		return uvc_query_buffer(&stream->queue, buf);
-	}
+	ctrl->value = xctrl.value;
+	return 0;
+}
 
-	case VIDIOC_CREATE_BUFS:
-	{
-		struct v4l2_create_buffers *cb = arg;
+static int uvc_ioctl_s_ctrl(struct file *file, void *fh,
+			    struct v4l2_control *ctrl)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_video_chain *chain = handle->chain;
+	struct v4l2_ext_control xctrl;
+	int ret;
 
-		ret = uvc_acquire_privileges(handle);
-		if (ret < 0)
-			return ret;
+	memset(&xctrl, 0, sizeof(xctrl));
+	xctrl.id = ctrl->id;
+	xctrl.value = ctrl->value;
 
-		return uvc_create_buffers(&stream->queue, cb);
+	ret = uvc_ctrl_begin(chain);
+	if (ret < 0)
+		return ret;
+
+	ret = uvc_ctrl_set(chain, &xctrl);
+	if (ret < 0) {
+		uvc_ctrl_rollback(handle);
+		return ret;
 	}
 
-	case VIDIOC_QBUF:
-		if (!uvc_has_privileges(handle))
-			return -EBUSY;
+	ret = uvc_ctrl_commit(handle, &xctrl, 1);
+	if (ret < 0)
+		return ret;
 
-		return uvc_queue_buffer(&stream->queue, arg);
+	ctrl->value = xctrl.value;
+	return 0;
+}
 
-	case VIDIOC_DQBUF:
-		if (!uvc_has_privileges(handle))
-			return -EBUSY;
+static int uvc_ioctl_g_ext_ctrls(struct file *file, void *fh,
+				 struct v4l2_ext_controls *ctrls)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_video_chain *chain = handle->chain;
+	struct v4l2_ext_control *ctrl = ctrls->controls;
+	unsigned int i;
+	int ret;
 
-		return uvc_dequeue_buffer(&stream->queue, arg,
-			file->f_flags & O_NONBLOCK);
+	ret = uvc_ctrl_begin(chain);
+	if (ret < 0)
+		return ret;
 
-	case VIDIOC_STREAMON:
-	{
-		int *type = arg;
+	for (i = 0; i < ctrls->count; ++ctrl, ++i) {
+		ret = uvc_ctrl_get(chain, ctrl);
+		if (ret < 0) {
+			uvc_ctrl_rollback(handle);
+			ctrls->error_idx = i;
+			return ret;
+		}
+	}
 
-		if (*type != stream->type)
-			return -EINVAL;
+	ctrls->error_idx = 0;
 
-		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
-		if (ret < 0)
-			return ret;
+	return uvc_ctrl_rollback(handle);
+}
 
-		if (!uvc_has_privileges(handle))
-			return -EBUSY;
+static int uvc_ioctl_s_try_ext_ctrls(struct uvc_fh *handle,
+				     struct v4l2_ext_controls *ctrls,
+				     bool commit)
+{
+	struct v4l2_ext_control *ctrl = ctrls->controls;
+	struct uvc_video_chain *chain = handle->chain;
+	unsigned int i;
+	int ret;
 
-		mutex_lock(&stream->mutex);
-		ret = uvc_video_enable(stream, 1);
-		mutex_unlock(&stream->mutex);
-		if (ret < 0)
+	ret = uvc_ctrl_begin(chain);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < ctrls->count; ++ctrl, ++i) {
+		ret = uvc_ctrl_set(chain, ctrl);
+		if (ret < 0) {
+			uvc_ctrl_rollback(handle);
+			ctrls->error_idx = commit ? ctrls->count : i;
 			return ret;
-		break;
+		}
 	}
 
-	case VIDIOC_STREAMOFF:
-	{
-		int *type = arg;
+	ctrls->error_idx = 0;
 
-		if (*type != stream->type)
-			return -EINVAL;
+	if (commit)
+		return uvc_ctrl_commit(handle, ctrls->controls, ctrls->count);
+	else
+		return uvc_ctrl_rollback(handle);
+}
 
-		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
-		if (ret < 0)
-			return ret;
+static int uvc_ioctl_s_ext_ctrls(struct file *file, void *fh,
+				 struct v4l2_ext_controls *ctrls)
+{
+	struct uvc_fh *handle = fh;
 
-		if (!uvc_has_privileges(handle))
-			return -EBUSY;
+	return uvc_ioctl_s_try_ext_ctrls(handle, ctrls, true);
+}
+
+static int uvc_ioctl_try_ext_ctrls(struct file *file, void *fh,
+				   struct v4l2_ext_controls *ctrls)
+{
+	struct uvc_fh *handle = fh;
+
+	return uvc_ioctl_s_try_ext_ctrls(handle, ctrls, false);
+}
 
-		return uvc_video_enable(stream, 0);
+static int uvc_ioctl_querymenu(struct file *file, void *fh,
+			       struct v4l2_querymenu *qm)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_video_chain *chain = handle->chain;
+
+	return uvc_query_v4l2_menu(chain, qm);
+}
+
+static int uvc_ioctl_cropcap(struct file *file, void *fh,
+			     struct v4l2_cropcap *ccap)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_streaming *stream = handle->stream;
+
+	if (ccap->type != stream->type)
+		return -EINVAL;
+
+	ccap->bounds.left = 0;
+	ccap->bounds.top = 0;
+	mutex_lock(&stream->mutex);
+	ccap->bounds.width = stream->cur_frame->wWidth;
+	ccap->bounds.height = stream->cur_frame->wHeight;
+	mutex_unlock(&stream->mutex);
+
+	ccap->defrect = ccap->bounds;
+
+	ccap->pixelaspect.numerator = 1;
+	ccap->pixelaspect.denominator = 1;
+	return 0;
+}
+
+static int uvc_ioctl_g_parm(struct file *file, void *fh,
+			    struct v4l2_streamparm *parm)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_streaming *stream = handle->stream;
+
+	return uvc_v4l2_get_streamparm(stream, parm);
+}
+
+static int uvc_ioctl_s_parm(struct file *file, void *fh,
+			    struct v4l2_streamparm *parm)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_streaming *stream = handle->stream;
+	int ret;
+
+	ret = uvc_acquire_privileges(handle);
+	if (ret < 0)
+		return ret;
+
+	return uvc_v4l2_set_streamparm(stream, parm);
+}
+
+static int uvc_ioctl_enum_framesizes(struct file *file, void *fh,
+				     struct v4l2_frmsizeenum *fsize)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_streaming *stream = handle->stream;
+	struct uvc_format *format = NULL;
+	struct uvc_frame *frame;
+	int i;
+
+	/* Look for the given pixel format */
+	for (i = 0; i < stream->nformats; i++) {
+		if (stream->format[i].fcc == fsize->pixel_format) {
+			format = &stream->format[i];
+			break;
+		}
 	}
+	if (format == NULL)
+		return -EINVAL;
 
-	case VIDIOC_SUBSCRIBE_EVENT:
-	{
-		struct v4l2_event_subscription *sub = arg;
+	if (fsize->index >= format->nframes)
+		return -EINVAL;
 
-		switch (sub->type) {
-		case V4L2_EVENT_CTRL:
-			return v4l2_event_subscribe(&handle->vfh, sub, 0,
-						    &uvc_ctrl_sub_ev_ops);
-		default:
-			return -EINVAL;
+	frame = &format->frame[fsize->index];
+	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+	fsize->discrete.width = frame->wWidth;
+	fsize->discrete.height = frame->wHeight;
+	return 0;
+}
+
+static int uvc_ioctl_enum_frameintervals(struct file *file, void *fh,
+					 struct v4l2_frmivalenum *fival)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_streaming *stream = handle->stream;
+	struct uvc_format *format = NULL;
+	struct uvc_frame *frame = NULL;
+	int i;
+
+	/* Look for the given pixel format and frame size */
+	for (i = 0; i < stream->nformats; i++) {
+		if (stream->format[i].fcc == fival->pixel_format) {
+			format = &stream->format[i];
+			break;
 		}
 	}
+	if (format == NULL)
+		return -EINVAL;
 
-	case VIDIOC_UNSUBSCRIBE_EVENT:
-		return v4l2_event_unsubscribe(&handle->vfh, arg);
+	for (i = 0; i < format->nframes; i++) {
+		if (format->frame[i].wWidth == fival->width &&
+		    format->frame[i].wHeight == fival->height) {
+			frame = &format->frame[i];
+			break;
+		}
+	}
+	if (frame == NULL)
+		return -EINVAL;
 
-	case VIDIOC_DQEVENT:
-		return v4l2_event_dequeue(&handle->vfh, arg,
-					  file->f_flags & O_NONBLOCK);
+	if (frame->bFrameIntervalType) {
+		if (fival->index >= frame->bFrameIntervalType)
+			return -EINVAL;
 
-	/* Analog video standards make no sense for digital cameras. */
-	case VIDIOC_ENUMSTD:
-	case VIDIOC_QUERYSTD:
-	case VIDIOC_G_STD:
-	case VIDIOC_S_STD:
+		fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+		fival->discrete.numerator =
+			frame->dwFrameInterval[fival->index];
+		fival->discrete.denominator = 10000000;
+		uvc_simplify_fraction(&fival->discrete.numerator,
+			&fival->discrete.denominator, 8, 333);
+	} else {
+		fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
+		fival->stepwise.min.numerator = frame->dwFrameInterval[0];
+		fival->stepwise.min.denominator = 10000000;
+		fival->stepwise.max.numerator = frame->dwFrameInterval[1];
+		fival->stepwise.max.denominator = 10000000;
+		fival->stepwise.step.numerator = frame->dwFrameInterval[2];
+		fival->stepwise.step.denominator = 10000000;
+		uvc_simplify_fraction(&fival->stepwise.min.numerator,
+			&fival->stepwise.min.denominator, 8, 333);
+		uvc_simplify_fraction(&fival->stepwise.max.numerator,
+			&fival->stepwise.max.denominator, 8, 333);
+		uvc_simplify_fraction(&fival->stepwise.step.numerator,
+			&fival->stepwise.step.denominator, 8, 333);
+	}
 
-	case VIDIOC_OVERLAY:
+	return 0;
+}
 
-	case VIDIOC_ENUMAUDIO:
-	case VIDIOC_ENUMAUDOUT:
+static int uvc_ioctl_subscribe_event(struct v4l2_fh *fh,
+				     const struct v4l2_event_subscription *sub)
+{
+	switch (sub->type) {
+	case V4L2_EVENT_CTRL:
+		return v4l2_event_subscribe(fh, sub, 0, &uvc_ctrl_sub_ev_ops);
+	default:
+		return -EINVAL;
+	}
+}
 
-	case VIDIOC_ENUMOUTPUT:
-		uvc_trace(UVC_TRACE_IOCTL, "Unsupported ioctl 0x%08x\n", cmd);
-		return -ENOTTY;
+static long uvc_ioctl_default(struct file *file, void *fh, bool valid_prio,
+			      unsigned int cmd, void *arg)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_video_chain *chain = handle->chain;
 
+	switch (cmd) {
+	/* Dynamic controls. */
 	case UVCIOC_CTRL_MAP:
 		return uvc_ioctl_ctrl_map(chain, arg);
 
@@ -1105,23 +1187,8 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		return uvc_xu_ctrl_query(chain, arg);
 
 	default:
-		uvc_trace(UVC_TRACE_IOCTL, "Unknown ioctl 0x%08x\n", cmd);
 		return -ENOTTY;
 	}
-
-	return ret;
-}
-
-static long uvc_v4l2_ioctl(struct file *file,
-		     unsigned int cmd, unsigned long arg)
-{
-	if (uvc_trace_param & UVC_TRACE_IOCTL) {
-		uvc_printk(KERN_DEBUG, "uvc_v4l2_ioctl(");
-		v4l_printk_ioctl(NULL, cmd);
-		printk(")\n");
-	}
-
-	return video_usercopy(file, cmd, arg, uvc_v4l2_do_ioctl);
 }
 
 #ifdef CONFIG_COMPAT
@@ -1304,7 +1371,7 @@ static long uvc_v4l2_compat_ioctl32(struct file *file,
 
 	old_fs = get_fs();
 	set_fs(KERNEL_DS);
-	ret = uvc_v4l2_ioctl(file, cmd, (unsigned long)&karg);
+	ret = video_ioctl2(file, cmd, (unsigned long)&karg);
 	set_fs(old_fs);
 
 	if (ret < 0)
@@ -1365,11 +1432,48 @@ static unsigned long uvc_v4l2_get_unmapped_area(struct file *file,
 }
 #endif
 
+const struct v4l2_ioctl_ops uvc_ioctl_ops = {
+	.vidioc_querycap = uvc_ioctl_querycap,
+	.vidioc_enum_fmt_vid_cap = uvc_ioctl_enum_fmt_vid_cap,
+	.vidioc_enum_fmt_vid_out = uvc_ioctl_enum_fmt_vid_out,
+	.vidioc_g_fmt_vid_cap = uvc_ioctl_g_fmt_vid_cap,
+	.vidioc_g_fmt_vid_out = uvc_ioctl_g_fmt_vid_out,
+	.vidioc_s_fmt_vid_cap = uvc_ioctl_s_fmt_vid_cap,
+	.vidioc_s_fmt_vid_out = uvc_ioctl_s_fmt_vid_out,
+	.vidioc_try_fmt_vid_cap = uvc_ioctl_try_fmt_vid_cap,
+	.vidioc_try_fmt_vid_out = uvc_ioctl_try_fmt_vid_out,
+	.vidioc_reqbufs = uvc_ioctl_reqbufs,
+	.vidioc_querybuf = uvc_ioctl_querybuf,
+	.vidioc_qbuf = uvc_ioctl_qbuf,
+	.vidioc_dqbuf = uvc_ioctl_dqbuf,
+	.vidioc_create_bufs = uvc_ioctl_create_bufs,
+	.vidioc_streamon = uvc_ioctl_streamon,
+	.vidioc_streamoff = uvc_ioctl_streamoff,
+	.vidioc_enum_input = uvc_ioctl_enum_input,
+	.vidioc_g_input = uvc_ioctl_g_input,
+	.vidioc_s_input = uvc_ioctl_s_input,
+	.vidioc_queryctrl = uvc_ioctl_queryctrl,
+	.vidioc_g_ctrl = uvc_ioctl_g_ctrl,
+	.vidioc_s_ctrl = uvc_ioctl_s_ctrl,
+	.vidioc_g_ext_ctrls = uvc_ioctl_g_ext_ctrls,
+	.vidioc_s_ext_ctrls = uvc_ioctl_s_ext_ctrls,
+	.vidioc_try_ext_ctrls = uvc_ioctl_try_ext_ctrls,
+	.vidioc_querymenu = uvc_ioctl_querymenu,
+	.vidioc_cropcap = uvc_ioctl_cropcap,
+	.vidioc_g_parm = uvc_ioctl_g_parm,
+	.vidioc_s_parm = uvc_ioctl_s_parm,
+	.vidioc_enum_framesizes = uvc_ioctl_enum_framesizes,
+	.vidioc_enum_frameintervals = uvc_ioctl_enum_frameintervals,
+	.vidioc_subscribe_event = uvc_ioctl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+	.vidioc_default = uvc_ioctl_default,
+};
+
 const struct v4l2_file_operations uvc_fops = {
 	.owner		= THIS_MODULE,
 	.open		= uvc_v4l2_open,
 	.release	= uvc_v4l2_release,
-	.unlocked_ioctl	= uvc_v4l2_ioctl,
+	.unlocked_ioctl	= video_ioctl2,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl32	= uvc_v4l2_compat_ioctl32,
 #endif
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 2600c96..53db7ed 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -580,7 +580,6 @@ struct uvc_driver {
 #define UVC_TRACE_FORMAT	(1 << 3)
 #define UVC_TRACE_CAPTURE	(1 << 4)
 #define UVC_TRACE_CALLS		(1 << 5)
-#define UVC_TRACE_IOCTL		(1 << 6)
 #define UVC_TRACE_FRAME		(1 << 7)
 #define UVC_TRACE_SUSPEND	(1 << 8)
 #define UVC_TRACE_STATUS	(1 << 9)
@@ -654,6 +653,7 @@ static inline int uvc_queue_streaming(struct uvc_video_queue *queue)
 }
 
 /* V4L2 interface */
+extern const struct v4l2_ioctl_ops uvc_ioctl_ops;
 extern const struct v4l2_file_operations uvc_fops;
 
 /* Media controller */
-- 
2.0.4

