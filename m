Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:34277 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754556AbbCIQgU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 12:36:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 14/19] gadget/uvc: embed video_device
Date: Mon,  9 Mar 2015 17:34:08 +0100
Message-Id: <1425918853-12371-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
References: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Embed the video_device struct to simplify the error handling and in
order to (eventually) get rid of video_device_alloc/release.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/usb/gadget/function/f_uvc.c | 44 +++++++++++++++----------------------
 drivers/usb/gadget/function/uvc.h   |  2 +-
 2 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/drivers/usb/gadget/function/f_uvc.c b/drivers/usb/gadget/function/f_uvc.c
index 3242bc6..cf0df8f 100644
--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -222,7 +222,7 @@ uvc_function_ep0_complete(struct usb_ep *ep, struct usb_request *req)
 		v4l2_event.type = UVC_EVENT_DATA;
 		uvc_event->data.length = req->actual;
 		memcpy(&uvc_event->data.data, req->buf, req->actual);
-		v4l2_event_queue(uvc->vdev, &v4l2_event);
+		v4l2_event_queue(&uvc->vdev, &v4l2_event);
 	}
 }
 
@@ -256,7 +256,7 @@ uvc_function_setup(struct usb_function *f, const struct usb_ctrlrequest *ctrl)
 	memset(&v4l2_event, 0, sizeof(v4l2_event));
 	v4l2_event.type = UVC_EVENT_SETUP;
 	memcpy(&uvc_event->req, ctrl, sizeof(uvc_event->req));
-	v4l2_event_queue(uvc->vdev, &v4l2_event);
+	v4l2_event_queue(&uvc->vdev, &v4l2_event);
 
 	return 0;
 }
@@ -315,7 +315,7 @@ uvc_function_set_alt(struct usb_function *f, unsigned interface, unsigned alt)
 			memset(&v4l2_event, 0, sizeof(v4l2_event));
 			v4l2_event.type = UVC_EVENT_CONNECT;
 			uvc_event->speed = cdev->gadget->speed;
-			v4l2_event_queue(uvc->vdev, &v4l2_event);
+			v4l2_event_queue(&uvc->vdev, &v4l2_event);
 
 			uvc->state = UVC_STATE_CONNECTED;
 		}
@@ -343,7 +343,7 @@ uvc_function_set_alt(struct usb_function *f, unsigned interface, unsigned alt)
 
 		memset(&v4l2_event, 0, sizeof(v4l2_event));
 		v4l2_event.type = UVC_EVENT_STREAMOFF;
-		v4l2_event_queue(uvc->vdev, &v4l2_event);
+		v4l2_event_queue(&uvc->vdev, &v4l2_event);
 
 		uvc->state = UVC_STATE_CONNECTED;
 		return 0;
@@ -370,7 +370,7 @@ uvc_function_set_alt(struct usb_function *f, unsigned interface, unsigned alt)
 
 		memset(&v4l2_event, 0, sizeof(v4l2_event));
 		v4l2_event.type = UVC_EVENT_STREAMON;
-		v4l2_event_queue(uvc->vdev, &v4l2_event);
+		v4l2_event_queue(&uvc->vdev, &v4l2_event);
 		return USB_GADGET_DELAYED_STATUS;
 
 	default:
@@ -388,7 +388,7 @@ uvc_function_disable(struct usb_function *f)
 
 	memset(&v4l2_event, 0, sizeof(v4l2_event));
 	v4l2_event.type = UVC_EVENT_DISCONNECT;
-	v4l2_event_queue(uvc->vdev, &v4l2_event);
+	v4l2_event_queue(&uvc->vdev, &v4l2_event);
 
 	uvc->state = UVC_STATE_DISCONNECTED;
 
@@ -435,25 +435,19 @@ static int
 uvc_register_video(struct uvc_device *uvc)
 {
 	struct usb_composite_dev *cdev = uvc->func.config->cdev;
-	struct video_device *video;
 
 	/* TODO reference counting. */
-	video = video_device_alloc();
-	if (video == NULL)
-		return -ENOMEM;
-
-	video->v4l2_dev = &uvc->v4l2_dev;
-	video->fops = &uvc_v4l2_fops;
-	video->ioctl_ops = &uvc_v4l2_ioctl_ops;
-	video->release = video_device_release;
-	video->vfl_dir = VFL_DIR_TX;
-	video->lock = &uvc->video.mutex;
-	strlcpy(video->name, cdev->gadget->name, sizeof(video->name));
-
-	uvc->vdev = video;
-	video_set_drvdata(video, uvc);
-
-	return video_register_device(video, VFL_TYPE_GRABBER, -1);
+	uvc->vdev.v4l2_dev = &uvc->v4l2_dev;
+	uvc->vdev.fops = &uvc_v4l2_fops;
+	uvc->vdev.ioctl_ops = &uvc_v4l2_ioctl_ops;
+	uvc->vdev.release = video_device_release_empty;
+	uvc->vdev.vfl_dir = VFL_DIR_TX;
+	uvc->vdev.lock = &uvc->video.mutex;
+	strlcpy(uvc->vdev.name, cdev->gadget->name, sizeof(uvc->vdev.name));
+
+	video_set_drvdata(&uvc->vdev, uvc);
+
+	return video_register_device(&uvc->vdev, VFL_TYPE_GRABBER, -1);
 }
 
 #define UVC_COPY_DESCRIPTOR(mem, dst, desc) \
@@ -766,8 +760,6 @@ uvc_function_bind(struct usb_configuration *c, struct usb_function *f)
 
 error:
 	v4l2_device_unregister(&uvc->v4l2_dev);
-	if (uvc->vdev)
-		video_device_release(uvc->vdev);
 
 	if (uvc->control_ep)
 		uvc->control_ep->driver_data = NULL;
@@ -898,7 +890,7 @@ static void uvc_unbind(struct usb_configuration *c, struct usb_function *f)
 
 	INFO(cdev, "%s\n", __func__);
 
-	video_unregister_device(uvc->vdev);
+	video_unregister_device(&uvc->vdev);
 	v4l2_device_unregister(&uvc->v4l2_dev);
 	uvc->control_ep->driver_data = NULL;
 	uvc->video.ep->driver_data = NULL;
diff --git a/drivers/usb/gadget/function/uvc.h b/drivers/usb/gadget/function/uvc.h
index 3390ecd..ebe409b 100644
--- a/drivers/usb/gadget/function/uvc.h
+++ b/drivers/usb/gadget/function/uvc.h
@@ -144,7 +144,7 @@ enum uvc_state
 
 struct uvc_device
 {
-	struct video_device *vdev;
+	struct video_device vdev;
 	struct v4l2_device v4l2_dev;
 	enum uvc_state state;
 	struct usb_function func;
-- 
2.1.4

