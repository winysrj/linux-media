Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36753 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdGNUOj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 16:14:39 -0400
Received: by mail-wm0-f67.google.com with SMTP id 15so739026wmm.3
        for <linux-media@vger.kernel.org>; Fri, 14 Jul 2017 13:14:39 -0700 (PDT)
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 3/3] [media] uvcvideo: skip non-extension unit controls on Oculus Rift Sensors
Date: Fri, 14 Jul 2017 22:14:24 +0200
Message-Id: <20170714201424.23592-3-philipp.zabel@gmail.com>
In-Reply-To: <20170714201424.23592-1-philipp.zabel@gmail.com>
References: <20170714201424.23592-1-philipp.zabel@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Oculus Rift Sensors (DK2 and CV1) allow to configure their sensor chips
directly via I2C commands using extension unit controls. The processing and
camera unit controls do not function at all.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 86cb16a2e7f4..573e1f8735bf 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -2165,6 +2165,10 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
 {
 	struct uvc_entity *entity;
 	unsigned int i;
+	const struct usb_device_id xu_only[] = {
+		{ USB_DEVICE(0x2833, 0x0201) },
+		{ USB_DEVICE(0x2833, 0x0211) },
+	};
 
 	/* Walk the entities list and instantiate controls */
 	list_for_each_entry(entity, &dev->entities, list) {
@@ -2172,6 +2176,16 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
 		unsigned int bControlSize = 0, ncontrols;
 		__u8 *bmControls = NULL;
 
+		/* Oculus Sensors only handle extension unit controls */
+		if (UVC_ENTITY_TYPE(entity) != UVC_VC_EXTENSION_UNIT) {
+			for (i = 0; i < ARRAY_SIZE(xu_only); i++) {
+				if (usb_match_one_id(dev->intf, &xu_only[i]))
+					break;
+			}
+			if (i != ARRAY_SIZE(xu_only))
+				continue;
+		}
+
 		if (UVC_ENTITY_TYPE(entity) == UVC_VC_EXTENSION_UNIT) {
 			bmControls = entity->extension.bmControls;
 			bControlSize = entity->extension.bControlSize;
-- 
2.13.2
