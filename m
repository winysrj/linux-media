Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32818 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751326AbdGPOxO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Jul 2017 10:53:14 -0400
Received: by mail-wm0-f67.google.com with SMTP id j85so18791060wmj.0
        for <linux-media@vger.kernel.org>; Sun, 16 Jul 2017 07:53:13 -0700 (PDT)
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH v2 1/3] [media] uvcvideo: variable size controls
Date: Sun, 16 Jul 2017 16:53:03 +0200
Message-Id: <20170716145305.19934-1-philipp.zabel@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some USB webcam controllers have extension unit controls that report
different lengths via GET_LEN, depending on internal state. Add a flag
to mark these controls as variable length and issue GET_LEN before
GET/SET_CUR transfers to verify the current length.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
Changes since v1:
 - Split uvc_ctrl_fill_xu_info_size and uvc_ctrl_fill_xu_info_flags out of
   uvc_ctrl_fill_xu_info.
 - Add uvc_ctrl_update_xu_info_size and reuse uvc_ctrl_fill_xu_info_size.
 - Call uvc_ctrl_update_xu_info_size from uvc_xu_ctrl_query instead of open
   coding the size update, thereby fixing a double kfree.
---
 drivers/media/usb/uvc/uvc_ctrl.c | 98 ++++++++++++++++++++++++++++++++++------
 include/uapi/linux/uvcvideo.h    |  2 +
 2 files changed, 87 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index c2ee6e39fd0c..43e8851cc381 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1597,7 +1597,7 @@ static void uvc_ctrl_fixup_xu_info(struct uvc_device *dev,
 		struct usb_device_id id;
 		u8 entity;
 		u8 selector;
-		u8 flags;
+		u16 flags;
 	};
 
 	static const struct uvc_ctrl_fixup fixups[] = {
@@ -1629,10 +1629,7 @@ static void uvc_ctrl_fixup_xu_info(struct uvc_device *dev,
 	}
 }
 
-/*
- * Query control information (size and flags) for XU controls.
- */
-static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
+static int uvc_ctrl_fill_xu_info_size(struct uvc_device *dev,
 	const struct uvc_control *ctrl, struct uvc_control_info *info)
 {
 	u8 *data;
@@ -1642,11 +1639,6 @@ static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
 	if (data == NULL)
 		return -ENOMEM;
 
-	memcpy(info->entity, ctrl->entity->extension.guidExtensionCode,
-	       sizeof(info->entity));
-	info->index = ctrl->index;
-	info->selector = ctrl->index + 1;
-
 	/* Query and verify the control length (GET_LEN) */
 	ret = uvc_query_ctrl(dev, UVC_GET_LEN, ctrl->entity->id, dev->intfnum,
 			     info->selector, data, 2);
@@ -1659,6 +1651,21 @@ static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
 
 	info->size = le16_to_cpup((__le16 *)data);
 
+done:
+	kfree(data);
+	return ret;
+}
+
+static int uvc_ctrl_fill_xu_info_flags(struct uvc_device *dev,
+	const struct uvc_control *ctrl, struct uvc_control_info *info)
+{
+	u8 *data;
+	int ret;
+
+	data = kmalloc(1, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
 	/* Query the control information (GET_INFO) */
 	ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id, dev->intfnum,
 			     info->selector, data, 1);
@@ -1678,6 +1685,32 @@ static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
 		    | (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
 		       UVC_CTRL_FLAG_AUTO_UPDATE : 0);
 
+done:
+	kfree(data);
+	return ret;
+}
+
+/*
+ * Query control information (size and flags) for XU controls.
+ */
+static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
+	const struct uvc_control *ctrl, struct uvc_control_info *info)
+{
+	int ret;
+
+	memcpy(info->entity, ctrl->entity->extension.guidExtensionCode,
+	       sizeof(info->entity));
+	info->index = ctrl->index;
+	info->selector = ctrl->index + 1;
+
+	ret = uvc_ctrl_fill_xu_info_size(dev, ctrl, info);
+	if (ret < 0)
+		return ret;
+
+	ret = uvc_ctrl_fill_xu_info_flags(dev, ctrl, info);
+	if (ret < 0)
+		return ret;
+
 	uvc_ctrl_fixup_xu_info(dev, ctrl, info);
 
 	uvc_trace(UVC_TRACE_CONTROL, "XU control %pUl/%u queried: len %u, "
@@ -1687,9 +1720,7 @@ static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
 		  (info->flags & UVC_CTRL_FLAG_SET_CUR) ? 1 : 0,
 		  (info->flags & UVC_CTRL_FLAG_AUTO_UPDATE) ? 1 : 0);
 
-done:
-	kfree(data);
-	return ret;
+	return 0;
 }
 
 static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
@@ -1717,6 +1748,40 @@ static int uvc_ctrl_init_xu_ctrl(struct uvc_device *dev,
 	return ret;
 }
 
+/*
+ * Update control size for variable length XU controls.
+ */
+static int uvc_ctrl_update_xu_info_size(struct uvc_device *dev,
+	struct uvc_control *ctrl)
+{
+	u16 size = ctrl->info.size;
+	int ret;
+
+	if (!(ctrl->info.flags & UVC_CTRL_FLAG_VARIABLE_LEN))
+		return 0;
+
+	/* Check if the control size has changed */
+	ret = uvc_ctrl_fill_xu_info_size(dev, ctrl, &ctrl->info);
+	if (ret < 0)
+		return ret;
+
+	if (ctrl->info.size != size) {
+		uvc_trace(UVC_TRACE_CONTROL,
+			  "XU control %pUl/%u queried: len %u -> %u\n",
+			  ctrl->info.entity, ctrl->info.selector,
+			  size, ctrl->info.size);
+
+		/* Resize array for saved control values */
+		kfree(ctrl->uvc_data);
+		ctrl->uvc_data = kzalloc(ctrl->info.size * UVC_CTRL_DATA_LAST +
+					 1, GFP_KERNEL);
+		if (ctrl->uvc_data == NULL)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
 int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 	struct uvc_xu_control_query *xqry)
 {
@@ -1799,6 +1864,13 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 		goto done;
 	}
 
+	if (reqflags) {
+		ret = uvc_ctrl_update_xu_info_size(chain->dev, ctrl);
+		if (ret < 0)
+			goto done;
+		size = ctrl->info.size;
+	}
+
 	if (size != xqry->size) {
 		ret = -ENOBUFS;
 		goto done;
diff --git a/include/uapi/linux/uvcvideo.h b/include/uapi/linux/uvcvideo.h
index 3b081862b9e8..0f0d63e79045 100644
--- a/include/uapi/linux/uvcvideo.h
+++ b/include/uapi/linux/uvcvideo.h
@@ -27,6 +27,8 @@
 #define UVC_CTRL_FLAG_RESTORE		(1 << 6)
 /* Control can be updated by the camera. */
 #define UVC_CTRL_FLAG_AUTO_UPDATE	(1 << 7)
+/* Control can change LEN */
+#define UVC_CTRL_FLAG_VARIABLE_LEN	(1 << 8)
 
 #define UVC_CTRL_FLAG_GET_RANGE \
 	(UVC_CTRL_FLAG_GET_CUR | UVC_CTRL_FLAG_GET_MIN | \
-- 
2.13.2
