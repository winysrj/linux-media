Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56907 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab3FVOZr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jun 2013 10:25:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Jim Davis <jim.epost@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] uvc: Depend on VIDEO_V4L2
Date: Sat, 22 Jun 2013 16:25:57 +0200
Message-Id: <1371911157-11955-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The uvcvideo driver lost its dependency on VIDEO_V4L2 during the big
media directory reorganization. Add it back.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/uvc/Kconfig b/drivers/media/usb/uvc/Kconfig
index 541c9f1..6ed85ef 100644
--- a/drivers/media/usb/uvc/Kconfig
+++ b/drivers/media/usb/uvc/Kconfig
@@ -1,5 +1,6 @@
 config USB_VIDEO_CLASS
 	tristate "USB Video Class (UVC)"
+	depends on VIDEO_V4L2
 	select VIDEOBUF2_VMALLOC
 	---help---
 	  Support for the USB Video Class (UVC).  Currently only video
-- 
Regards,

Laurent Pinchart

