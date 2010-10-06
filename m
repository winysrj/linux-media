Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:48875 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab0JFI7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 04:59:46 -0400
Received: from localhost.localdomain (unknown [91.178.188.185])
	by perceval.irobotique.be (Postfix) with ESMTPSA id D72DC361E7
	for <linux-media@vger.kernel.org>; Wed,  6 Oct 2010 08:59:40 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 13/14] uvcvideo: Fix bogus XU controls information
Date: Wed,  6 Oct 2010 10:59:51 +0200
Message-Id: <1286355592-13603-14-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

XU control information is supposed to be entirely discoverable using
standard UVC queries. As some devices report bogus information (such as
reporting a read-only control as being read-write), add a fixup table
for XU controls.

This table can also be used to selectively disable requests supposed to
be supported by all XU controls (GET_MIN, GET_MAX, GET_DEF, GET_RES) but
not correctly (or at all) supported by the device.

The table currently disables GET_CUR on the Logitech motor control XU
pan/tilt controls.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |   41 ++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index a0c9d58..0d310c4 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -1164,6 +1164,45 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
  * Dynamic controls
  */
 
+static void uvc_ctrl_fixup_xu_info(struct uvc_device *dev,
+	const struct uvc_control *ctrl, struct uvc_control_info *info)
+{
+	struct uvc_ctrl_fixup {
+		struct usb_device_id id;
+		u8 entity;
+		u8 selector;
+		u8 flags;
+	};
+
+	static const struct uvc_ctrl_fixup fixups[] = {
+		{ { USB_DEVICE(0x046d, 0x08c2) }, 9, 1,
+			UVC_CONTROL_GET_MIN | UVC_CONTROL_GET_MAX |
+			UVC_CONTROL_GET_DEF | UVC_CONTROL_SET_CUR |
+			UVC_CONTROL_AUTO_UPDATE },
+		{ { USB_DEVICE(0x046d, 0x08cc) }, 9, 1,
+			UVC_CONTROL_GET_MIN | UVC_CONTROL_GET_MAX |
+			UVC_CONTROL_GET_DEF | UVC_CONTROL_SET_CUR |
+			UVC_CONTROL_AUTO_UPDATE },
+		{ { USB_DEVICE(0x046d, 0x0994) }, 9, 1,
+			UVC_CONTROL_GET_MIN | UVC_CONTROL_GET_MAX |
+			UVC_CONTROL_GET_DEF | UVC_CONTROL_SET_CUR |
+			UVC_CONTROL_AUTO_UPDATE },
+	};
+
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(fixups); ++i) {
+		if (!usb_match_one_id(dev->intf, &fixups[i].id))
+			continue;
+
+		if (fixups[i].entity == ctrl->entity->id &&
+		    fixups[i].selector == info->selector) {
+			info->flags = fixups[i].flags;
+			return;
+		}
+	}
+}
+
 /*
  * Query control information (size and flags) for XU controls.
  */
@@ -1211,6 +1250,8 @@ static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
 		    | (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
 		       UVC_CONTROL_AUTO_UPDATE : 0);
 
+	uvc_ctrl_fixup_xu_info(dev, ctrl, info);
+
 	uvc_trace(UVC_TRACE_CONTROL, "XU control %pUl/%u queried: len %u, "
 		  "flags { get %u set %u auto %u }.\n",
 		  info->entity, info->selector, info->size,
-- 
1.7.2.2

