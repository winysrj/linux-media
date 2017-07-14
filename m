Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33470 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751112AbdGNUOe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 16:14:34 -0400
Received: by mail-wm0-f66.google.com with SMTP id j85so12565600wmj.0
        for <linux-media@vger.kernel.org>; Fri, 14 Jul 2017 13:14:34 -0700 (PDT)
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 1/3] [media] uvcvideo: variable size controls
Date: Fri, 14 Jul 2017 22:14:22 +0200
Message-Id: <20170714201424.23592-1-philipp.zabel@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some USB webcam controllers have extension unit controls that report
different lengths via GET_LEN, depending on internal state. Add a flag
to mark these controls as variable length and issue GET_LEN before
GET/SET_CUR transfers to verify the current length.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 26 +++++++++++++++++++++++++-
 include/uapi/linux/uvcvideo.h    |  2 ++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index c2ee6e39fd0c..ce69e2c6937d 100644
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
@@ -1799,6 +1799,30 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 		goto done;
 	}
 
+	if ((ctrl->info.flags & UVC_CTRL_FLAG_VARIABLE_LEN) && reqflags) {
+		data = kmalloc(2, GFP_KERNEL);
+		/* Check if the control length has changed */
+		ret = uvc_query_ctrl(chain->dev, UVC_GET_LEN, xqry->unit,
+				     chain->dev->intfnum, xqry->selector, data,
+				     2);
+		size = le16_to_cpup((__le16 *)data);
+		kfree(data);
+		if (ret < 0) {
+			uvc_trace(UVC_TRACE_CONTROL,
+				  "GET_LEN failed on control %pUl/%u (%d).\n",
+				  entity->extension.guidExtensionCode,
+				  xqry->selector, ret);
+			goto done;
+		}
+		if (ctrl->info.size != size) {
+			uvc_trace(UVC_TRACE_CONTROL,
+				  "XU control %pUl/%u queried: len %u -> %u\n",
+				  entity->extension.guidExtensionCode,
+				  xqry->selector, ctrl->info.size, size);
+			ctrl->info.size = size;
+		}
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
