Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward13j.cmail.yandex.net ([5.255.227.177]:58066 "EHLO
	forward13j.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868AbbJRVIX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Oct 2015 17:08:23 -0400
From: "Anton V. Shokurov" <shokurov.anton.v@yandex.ru>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	"Anton V . Shokurov" <shokurov.anton.v@yandex.ru>
Subject: [PATCH 1/1] x86: Fix reading the current exposure value of UVC
Date: Sun, 18 Oct 2015 17:01:26 -0400
Message-Id: <1445202086-3689-1-git-send-email-shokurov.anton.v@yandex.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2_CID_EXPOSURE_ABSOLUTE property does not return an updated value when
autoexposure (V4L2_CID_EXPOSURE_AUTO) is turned on. This patch fixes this
issue by adding the UVC_CTRL_FLAG_AUTO_UPDATE flag.

Tested on a C920 camera.

Signed-off-by: Anton V. Shokurov <shokurov.anton.v@yandex.ru>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 3e59b28..c2ee6e3 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -227,7 +227,8 @@ static struct uvc_control_info uvc_ctrls[] = {
 		.size		= 4,
 		.flags		= UVC_CTRL_FLAG_SET_CUR
 				| UVC_CTRL_FLAG_GET_RANGE
-				| UVC_CTRL_FLAG_RESTORE,
+				| UVC_CTRL_FLAG_RESTORE
+				| UVC_CTRL_FLAG_AUTO_UPDATE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_CAMERA,
-- 
2.6.0

