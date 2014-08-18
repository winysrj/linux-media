Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43838 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaHRRFs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Aug 2014 13:05:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-usb@vger.kernel.org
Cc: linux-media@vger.kernel.org,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Michael Grzeschik <mgr@pengutronix.de>
Subject: [PATCH 1/2] usb: gadget: f_uvc: Store EP0 control request state during setup stage
Date: Mon, 18 Aug 2014 19:06:16 +0200
Message-Id: <1408381577-31901-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1408381577-31901-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1408381577-31901-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To handle class requests received on ep0, the driver needs to access the
length and direction of the request after the setup stage. It currently
stores them in a v4l2 event during the setup stage, and then copies them
from the event structure to the driver internal state structure when the
event is dequeued.

This two-steps approach isn't necessary. Simplify the driver by storing
the needed information in the driver internal state structure directly
during the setup stage.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/usb/gadget/function/f_uvc.c    |  6 ++++++
 drivers/usb/gadget/function/uvc_v4l2.c | 19 +------------------
 2 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/gadget/function/f_uvc.c b/drivers/usb/gadget/function/f_uvc.c
index ff4340a..e9d625b 100644
--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -251,6 +251,12 @@ uvc_function_setup(struct usb_function *f, const struct usb_ctrlrequest *ctrl)
 	if (le16_to_cpu(ctrl->wLength) > UVC_MAX_REQUEST_SIZE)
 		return -EINVAL;
 
+	/* Tell the complete callback to generate an event for the next request
+	 * that will be enqueued by UVCIOC_SEND_RESPONSE.
+	 */
+	uvc->event_setup_out = !(ctrl->bRequestType & USB_DIR_IN);
+	uvc->event_length = le16_to_cpu(ctrl->wLength);
+
 	memset(&v4l2_event, 0, sizeof(v4l2_event));
 	v4l2_event.type = UVC_EVENT_SETUP;
 	memcpy(&uvc_event->req, ctrl, sizeof(uvc_event->req));
diff --git a/drivers/usb/gadget/function/uvc_v4l2.c b/drivers/usb/gadget/function/uvc_v4l2.c
index bcd71ce..f22b878 100644
--- a/drivers/usb/gadget/function/uvc_v4l2.c
+++ b/drivers/usb/gadget/function/uvc_v4l2.c
@@ -271,25 +271,8 @@ uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 	/* Events */
 	case VIDIOC_DQEVENT:
-	{
-		struct v4l2_event *event = arg;
-
-		ret = v4l2_event_dequeue(&handle->vfh, event,
+		return v4l2_event_dequeue(&handle->vfh, arg,
 					 file->f_flags & O_NONBLOCK);
-		if (ret == 0 && event->type == UVC_EVENT_SETUP) {
-			struct uvc_event *uvc_event = (void *)&event->u.data;
-
-			/* Tell the complete callback to generate an event for
-			 * the next request that will be enqueued by
-			 * uvc_event_write.
-			 */
-			uvc->event_setup_out =
-				!(uvc_event->req.bRequestType & USB_DIR_IN);
-			uvc->event_length = uvc_event->req.wLength;
-		}
-
-		return ret;
-	}
 
 	case VIDIOC_SUBSCRIBE_EVENT:
 	{
-- 
1.8.5.5

