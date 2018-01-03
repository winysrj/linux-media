Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58877 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751701AbeACK7V (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Jan 2018 05:59:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Edgar Thier <info@edgarthier.net>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: [PATCH] uvcvideo: Apply flags from device to actual properties
Date: Wed,  3 Jan 2018 12:59:38 +0200
Message-Id: <20180103105938.4190-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Edgar Thier <info@edgarthier.net>

Use flags the device exposes for UVC controls.
This allows the device to define which property flags are set.

Since some cameras offer auto-adjustments for properties (e.g. auto-gain),
the values of other properties (e.g. gain) can change in the camera.
Examining the flags ensures that the driver is aware of such properties.

Signed-off-by: Edgar Thier <info@edgarthier.net>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 52 ++++++++++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 20397aba6849..586f0e94061b 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1590,6 +1590,36 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
  * Dynamic controls
  */
 
+/*
+ * Retrieve flags for a given control
+ */
+static int uvc_ctrl_get_flags(struct uvc_device *dev,
+			      const struct uvc_control *ctrl,
+			      struct uvc_control_info *info)
+{
+	u8 *data;
+	int ret;
+
+	data = kmalloc(1, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id, dev->intfnum,
+			     info->selector, data, 1);
+	if (!ret)
+		info->flags = UVC_CTRL_FLAG_GET_MIN | UVC_CTRL_FLAG_GET_MAX
+			    | UVC_CTRL_FLAG_GET_RES | UVC_CTRL_FLAG_GET_DEF
+			    | (data[0] & UVC_CONTROL_CAP_GET ?
+			       UVC_CTRL_FLAG_GET_CUR : 0)
+			    | (data[0] & UVC_CONTROL_CAP_SET ?
+			       UVC_CTRL_FLAG_SET_CUR : 0)
+			    | (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
+			       UVC_CTRL_FLAG_AUTO_UPDATE : 0);
+
+	kfree(data);
+	return ret;
+}
+
 static void uvc_ctrl_fixup_xu_info(struct uvc_device *dev,
 	const struct uvc_control *ctrl, struct uvc_control_info *info)
 {
@@ -1659,25 +1689,14 @@ static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
 
 	info->size = le16_to_cpup((__le16 *)data);
 
-	/* Query the control information (GET_INFO) */
-	ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id, dev->intfnum,
-			     info->selector, data, 1);
+	ret = uvc_ctrl_get_flags(dev, ctrl, info);
 	if (ret < 0) {
 		uvc_trace(UVC_TRACE_CONTROL,
-			  "GET_INFO failed on control %pUl/%u (%d).\n",
+			  "Failed to get flags for control %pUl/%u (%d).\n",
 			  info->entity, info->selector, ret);
 		goto done;
 	}
 
-	info->flags = UVC_CTRL_FLAG_GET_MIN | UVC_CTRL_FLAG_GET_MAX
-		    | UVC_CTRL_FLAG_GET_RES | UVC_CTRL_FLAG_GET_DEF
-		    | (data[0] & UVC_CONTROL_CAP_GET ?
-		       UVC_CTRL_FLAG_GET_CUR : 0)
-		    | (data[0] & UVC_CONTROL_CAP_SET ?
-		       UVC_CTRL_FLAG_SET_CUR : 0)
-		    | (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
-		       UVC_CTRL_FLAG_AUTO_UPDATE : 0);
-
 	uvc_ctrl_fixup_xu_info(dev, ctrl, info);
 
 	uvc_trace(UVC_TRACE_CONTROL, "XU control %pUl/%u queried: len %u, "
@@ -1902,6 +1921,13 @@ static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
 		goto done;
 	}
 
+	/*
+	 * Retrieve control flags from the device. Ignore errors and work with
+	 * default flag values from the uvc_ctrl array when the device doesn't
+	 * properly implement GET_INFO on standard controls.
+	 */
+	uvc_ctrl_get_flags(dev, ctrl, &ctrl->info);
+
 	ctrl->initialized = 1;
 
 	uvc_trace(UVC_TRACE_CONTROL, "Added control %pUl/%u to device %s "
-- 
Regards,

Laurent Pinchart
