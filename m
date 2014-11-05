Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24992 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982AbaKEQOb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Nov 2014 11:14:31 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: pj.assis@gmail.com
Cc: remi@remlab.net, notasas@gmail.com, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com
Subject: [RFC 2/2] uvc: Use UVC_QUIRK_BAD_TIMESTAMP quirk flag for Logitech C920
Date: Wed,  5 Nov 2014 18:12:34 +0200
Message-Id: <1415203954-16718-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1415203954-16718-1-git-send-email-sakari.ailus@linux.intel.com>
References: <20141105161147.GW3136@valkosipuli.retiisi.org.uk>
 <1415203954-16718-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 7c8322d..3908e2f 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2183,7 +2183,9 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_RESTORE_CTRLS_ON_INIT },
+	  .driver_info		= UVC_QUIRK_RESTORE_CTRLS_ON_INIT
+				| UVC_QUIRK_BAD_TIMESTAMP
+	},
 	/* Chicony CNF7129 (Asus EEE 100HE) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
2.1.0.231.g7484e3b

