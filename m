Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:48875 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758690Ab0JFI7k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 04:59:40 -0400
Received: from localhost.localdomain (unknown [91.178.188.185])
	by perceval.irobotique.be (Postfix) with ESMTPSA id 0261935DA5
	for <linux-media@vger.kernel.org>; Wed,  6 Oct 2010 08:59:38 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 03/14] uvcvideo: Blacklist more controls for Hercules Dualpix Exchange
Date: Wed,  6 Oct 2010 10:59:41 +0200
Message-Id: <1286355592-13603-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The Hercules Dualpix Exchange (06f8:3005) camera expose an absolute zoom
that is not implemented. Blacklist it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |   36 ++++++++++++++++++++++++++++--------
 1 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index a350fad..bce29fd 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -1499,26 +1499,46 @@ end:
 static void
 uvc_ctrl_prune_entity(struct uvc_device *dev, struct uvc_entity *entity)
 {
-	static const struct {
+	struct uvc_ctrl_blacklist {
 		struct usb_device_id id;
 		u8 index;
-	} blacklist[] = {
+	};
+
+	static const struct uvc_ctrl_blacklist processing_blacklist[] = {
 		{ { USB_DEVICE(0x13d3, 0x509b) }, 9 }, /* Gain */
 		{ { USB_DEVICE(0x1c4f, 0x3000) }, 6 }, /* WB Temperature */
 		{ { USB_DEVICE(0x5986, 0x0241) }, 2 }, /* Hue */
 	};
+	static const struct uvc_ctrl_blacklist camera_blacklist[] = {
+		{ { USB_DEVICE(0x06f8, 0x3005) }, 9 }, /* Zoom, Absolute */
+	};
 
-	u8 *controls;
+	const struct uvc_ctrl_blacklist *blacklist;
 	unsigned int size;
+	unsigned int count;
 	unsigned int i;
+	u8 *controls;
 
-	if (UVC_ENTITY_TYPE(entity) != UVC_VC_PROCESSING_UNIT)
-		return;
+	switch (UVC_ENTITY_TYPE(entity)) {
+	case UVC_VC_PROCESSING_UNIT:
+		blacklist = processing_blacklist;
+		count = ARRAY_SIZE(processing_blacklist);
+		controls = entity->processing.bmControls;
+		size = entity->processing.bControlSize;
+		break;
+
+	case UVC_ITT_CAMERA:
+		blacklist = camera_blacklist;
+		count = ARRAY_SIZE(camera_blacklist);
+		controls = entity->camera.bmControls;
+		size = entity->camera.bControlSize;
+		break;
 
-	controls = entity->processing.bmControls;
-	size = entity->processing.bControlSize;
+	default:
+		return;
+	}
 
-	for (i = 0; i < ARRAY_SIZE(blacklist); ++i) {
+	for (i = 0; i < count; ++i) {
 		if (!usb_match_one_id(dev->intf, &blacklist[i].id))
 			continue;
 
-- 
1.7.2.2

