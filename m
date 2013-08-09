Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:52503 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757990Ab3HINLl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 09:11:41 -0400
From: oliver@neukum.org
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Cc: Oliver Neukum <oneukum@suse.de>
Subject: [PATCH] uvc: more buffers
Date: Fri,  9 Aug 2013 15:11:36 +0200
Message-Id: <1376053896-8931-1-git-send-email-oliver@neukum.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Oliver Neukum <oneukum@suse.de>

This is necessary to let the new generation of cameras
from LiteOn used in Haswell ULT notebook operate. Otherwise
the images will be truncated.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 drivers/media/usb/uvc/uvcvideo.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 9e35982..9f1930b 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -114,9 +114,9 @@
 /* Number of isochronous URBs. */
 #define UVC_URBS		5
 /* Maximum number of packets per URB. */
-#define UVC_MAX_PACKETS		32
+#define UVC_MAX_PACKETS		128	
 /* Maximum number of video buffers. */
-#define UVC_MAX_VIDEO_BUFFERS	32
+#define UVC_MAX_VIDEO_BUFFERS	128
 /* Maximum status buffer size in bytes of interrupt URB. */
 #define UVC_MAX_STATUS_SIZE	16
 
-- 
1.8.3.1

