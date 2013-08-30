Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33993 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab3H3CRq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 22:17:46 -0400
Received: by mail-pa0-f49.google.com with SMTP id ld10so1693845pab.22
        for <linux-media@vger.kernel.org>; Thu, 29 Aug 2013 19:17:46 -0700 (PDT)
From: Pawel Osciak <posciak@chromium.org>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Pawel Osciak <posciak@chromium.org>
Subject: [PATCH v1 11/19] uvcvideo: Support V4L2_CTRL_TYPE_BITMASK controls.
Date: Fri, 30 Aug 2013 11:17:10 +0900
Message-Id: <1377829038-4726-12-git-send-email-posciak@chromium.org>
In-Reply-To: <1377829038-4726-1-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Pawel Osciak <posciak@chromium.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index b0a19b9..a0493d6 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1550,6 +1550,24 @@ int uvc_ctrl_set(struct uvc_video_chain *chain, struct v4l2_ext_control *xctrl,
 
 		break;
 
+	case V4L2_CTRL_TYPE_BITMASK:
+		value = xctrl->value;
+
+		/* If GET_RES is supported, it will return a bitmask of bits
+		 * that can be set. If it isn't, allow any value.
+		 */
+		if (ctrl->info.flags & UVC_CTRL_FLAG_GET_RES) {
+			if (!ctrl->cached) {
+				ret = uvc_ctrl_populate_cache(chain, ctrl);
+				if (ret < 0)
+					return ret;
+			}
+			step = mapping->get(mapping, UVC_GET_RES,
+					uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES));
+			if (value & ~step)
+				return -ERANGE;
+		}
+
 	default:
 		value = xctrl->value;
 		break;
-- 
1.8.4

