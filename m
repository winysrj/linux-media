Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46219 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750729AbdHRKMb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 06:12:31 -0400
Subject: Re: [PATCH] uvcvideo: Apply flags from device to actual properties
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
References: <ca483e75-4519-2bc3-eb11-db647fc60860@edgarthier.net>
 <1516233.pKQSzG3xyp@avalon>
From: Edgar Thier <info@edgarthier.net>
Message-ID: <e6c92808-82e7-05bc-28b4-370ca51aa2de@edgarthier.net>
Date: Fri, 18 Aug 2017 12:12:29 +0200
MIME-Version: 1.0
In-Reply-To: <1516233.pKQSzG3xyp@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Use flags the device exposes for UVC controls.
This allows the device to define which property flags are set.

Since some cameras offer auto-adjustments for properties (e.g. auto-gain),
the values of other properties (e.g. gain) can change in the camera.
Examining the flags ensures that the driver is aware of such properties.

Signed-off-by: Edgar Thier <info@edgarthier.net>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 58 +++++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 18 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index c2ee6e3..6922c0cb 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1629,6 +1629,9 @@ static void uvc_ctrl_fixup_xu_info(struct uvc_device *dev,
 	}
 }

+static int uvc_ctrl_get_flags(struct uvc_device *dev, const struct uvc_control *ctrl,
+	const struct uvc_control_info *info);
+
 /*
  * Query control information (size and flags) for XU controls.
  */
@@ -1659,24 +1662,7 @@ static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,

 	info->size = le16_to_cpup((__le16 *)data);

-	/* Query the control information (GET_INFO) */
-	ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id, dev->intfnum,
-			     info->selector, data, 1);
-	if (ret < 0) {
-		uvc_trace(UVC_TRACE_CONTROL,
-			  "GET_INFO failed on control %pUl/%u (%d).\n",
-			  info->entity, info->selector, ret);
-		goto done;
-	}
-
-	info->flags = UVC_CTRL_FLAG_GET_MIN | UVC_CTRL_FLAG_GET_MAX
-		    | UVC_CTRL_FLAG_GET_RES | UVC_CTRL_FLAG_GET_DEF
-		    | (data[0] & UVC_CONTROL_CAP_GET ?
-		       UVC_CTRL_FLAG_GET_CUR : 0)
-		    | (data[0] & UVC_CONTROL_CAP_SET ?
-		       UVC_CTRL_FLAG_SET_CUR : 0)
-		    | (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
-		       UVC_CTRL_FLAG_AUTO_UPDATE : 0);
+	info->flags = uvc_ctrl_get_flags(dev, ctrl, info);

 	uvc_ctrl_fixup_xu_info(dev, ctrl, info);

@@ -1884,6 +1870,40 @@ int uvc_ctrl_restore_values(struct uvc_device *dev)
  */

 /*
+ * Retrieve flags for a given control
+ */
+static int uvc_ctrl_get_flags(struct uvc_device *dev, const struct uvc_control *ctrl,
+	const struct uvc_control_info *info)
+{
+	u8 *data;
+	int ret = 0;
+	int flags = 0;
+
+	data = kmalloc(2, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id, dev->intfnum,
+						 info->selector, data, 1);
+	if (ret < 0) {
+		uvc_trace(UVC_TRACE_CONTROL,
+				  "GET_INFO failed on control %pUl/%u (%d).\n",
+				  info->entity, info->selector, ret);
+	} else {
+		flags = UVC_CTRL_FLAG_GET_MIN | UVC_CTRL_FLAG_GET_MAX
+			| UVC_CTRL_FLAG_GET_RES | UVC_CTRL_FLAG_GET_DEF
+			| (data[0] & UVC_CONTROL_CAP_GET ?
+			   UVC_CTRL_FLAG_GET_CUR : 0)
+			| (data[0] & UVC_CONTROL_CAP_SET ?
+			   UVC_CTRL_FLAG_SET_CUR : 0)
+			| (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
+			   UVC_CTRL_FLAG_AUTO_UPDATE : 0);
+	}
+	kfree(data);
+	return flags;
+}
+
+/*
  * Add control information to a given control.
  */
 static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
@@ -1902,6 +1922,8 @@ static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
 		goto done;
 	}

+	ctrl->info.flags = uvc_ctrl_get_flags(dev, ctrl, info);
+
 	ctrl->initialized = 1;

 	uvc_trace(UVC_TRACE_CONTROL, "Added control %pUl/%u to device %s "
-- 
2.7.4
