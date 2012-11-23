Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56867 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab2KWMbK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 07:31:10 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v2 6/6] uvcvideo: Add VIDIOC_[GS]_PRIORITY support
Date: Fri, 23 Nov 2012 13:32:05 +0100
Message-Id: <1353673925-10050-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <201211161507.42201.hverkuil@xs4all.nl>
References: <201211161507.42201.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_driver.c |    3 ++
 drivers/media/usb/uvc/uvc_v4l2.c   |   45 ++++++++++++++++++++++++++++++++++++
 drivers/media/usb/uvc/uvcvideo.h   |    1 +
 3 files changed, 49 insertions(+), 0 deletions(-)

Resent with larger contexts to make review easier.

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index ae24f7d..22f14d2 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1560,10 +1560,11 @@ static int uvc_scan_device(struct uvc_device *dev)
 			return -ENOMEM;
 
 		INIT_LIST_HEAD(&chain->entities);
 		mutex_init(&chain->ctrl_mutex);
 		chain->dev = dev;
+		v4l2_prio_init(&chain->prio);
 
 		if (uvc_scan_chain(chain, term) < 0) {
 			kfree(chain);
 			continue;
 		}
@@ -1720,10 +1721,12 @@ static int uvc_register_video(struct uvc_device *dev,
 	 * get another one.
 	 */
 	vdev->v4l2_dev = &dev->vdev;
 	vdev->fops = &uvc_fops;
 	vdev->release = uvc_release;
+	vdev->prio = &stream->chain->prio;
+	set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);
 	if (stream->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		vdev->vfl_dir = VFL_DIR_TX;
 	strlcpy(vdev->name, dev->name, sizeof vdev->name);
 
 	/* Set the driver data before calling video_register_device, otherwise
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index bf9d073..d6aa402 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -574,10 +574,23 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 			cap->device_caps = V4L2_CAP_VIDEO_OUTPUT
 					 | V4L2_CAP_STREAMING;
 		break;
 	}
 
+	/* Priority */
+	case VIDIOC_G_PRIORITY:
+		*(u32 *)arg = v4l2_prio_max(vdev->prio);
+		break;
+
+	case VIDIOC_S_PRIORITY:
+		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
+		if (ret < 0)
+			return ret;
+
+		return v4l2_prio_change(vdev->prio, &handle->vfh.prio,
+					*(u32 *)arg);
+
 	/* Get, Set & Query control */
 	case VIDIOC_QUERYCTRL:
 		return uvc_query_v4l2_ctrl(chain, arg);
 
 	case VIDIOC_G_CTRL:
@@ -604,10 +617,14 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_S_CTRL:
 	{
 		struct v4l2_control *ctrl = arg;
 		struct v4l2_ext_control xctrl;
 
+		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
+		if (ret < 0)
+			return ret;
+
 		memset(&xctrl, 0, sizeof xctrl);
 		xctrl.id = ctrl->id;
 		xctrl.value = ctrl->value;
 
 		ret = uvc_ctrl_begin(chain);
@@ -651,10 +668,14 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		ret = uvc_ctrl_rollback(handle);
 		break;
 	}
 
 	case VIDIOC_S_EXT_CTRLS:
+		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
+		if (ret < 0)
+			return ret;
+
 	case VIDIOC_TRY_EXT_CTRLS:
 	{
 		struct v4l2_ext_controls *ctrls = arg;
 		struct v4l2_ext_control *ctrl = ctrls->controls;
 		unsigned int i;
@@ -745,10 +766,14 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 	case VIDIOC_S_INPUT:
 	{
 		u32 input = *(u32 *)arg + 1;
 
+		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
+		if (ret < 0)
+			return ret;
+
 		if ((ret = uvc_acquire_privileges(handle)) < 0)
 			return ret;
 
 		if (chain->selector == NULL ||
 		    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
@@ -798,10 +823,14 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 		return uvc_v4l2_try_format(stream, arg, &probe, NULL, NULL);
 	}
 
 	case VIDIOC_S_FMT:
+		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
+		if (ret < 0)
+			return ret;
+
 		if ((ret = uvc_acquire_privileges(handle)) < 0)
 			return ret;
 
 		return uvc_v4l2_set_format(stream, arg);
 
@@ -900,10 +929,14 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	/* Get & Set streaming parameters */
 	case VIDIOC_G_PARM:
 		return uvc_v4l2_get_streamparm(stream, arg);
 
 	case VIDIOC_S_PARM:
+		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
+		if (ret < 0)
+			return ret;
+
 		if ((ret = uvc_acquire_privileges(handle)) < 0)
 			return ret;
 
 		return uvc_v4l2_set_streamparm(stream, arg);
 
@@ -934,10 +967,14 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_S_CROP:
 		return -ENOTTY;
 
 	/* Buffers & streaming */
 	case VIDIOC_REQBUFS:
+		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
+		if (ret < 0)
+			return ret;
+
 		if ((ret = uvc_acquire_privileges(handle)) < 0)
 			return ret;
 
 		mutex_lock(&stream->mutex);
 		ret = uvc_alloc_buffers(&stream->queue, arg);
@@ -979,10 +1016,14 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		int *type = arg;
 
 		if (*type != stream->type)
 			return -EINVAL;
 
+		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
+		if (ret < 0)
+			return ret;
+
 		if (!uvc_has_privileges(handle))
 			return -EBUSY;
 
 		mutex_lock(&stream->mutex);
 		ret = uvc_video_enable(stream, 1);
@@ -997,10 +1038,14 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		int *type = arg;
 
 		if (*type != stream->type)
 			return -EINVAL;
 
+		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
+		if (ret < 0)
+			return ret;
+
 		if (!uvc_has_privileges(handle))
 			return -EBUSY;
 
 		return uvc_video_enable(stream, 0);
 	}
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index a6c561f..006ae27 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -370,10 +370,11 @@ struct uvc_video_chain {
 	struct uvc_entity *processing;		/* Processing unit */
 	struct uvc_entity *selector;		/* Selector unit */
 
 	struct mutex ctrl_mutex;		/* Protects ctrl.info */
 
+	struct v4l2_prio_state prio;		/* V4L2 priority state */
 	u32 caps;				/* V4L2 chain-wide caps */
 };
 
 struct uvc_stats_frame {
 	unsigned int size;		/* Number of bytes captured */
-- 
Regards,

Laurent Pinchart

