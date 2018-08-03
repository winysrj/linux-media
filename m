Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:38107 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727193AbeHCNcz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Aug 2018 09:32:55 -0400
Date: Fri, 3 Aug 2018 13:36:56 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 1/2] uvcvideo: rename UVC_QUIRK_INFO to UVC_INFO_QUIRK
Message-ID: <alpine.DEB.2.20.1808031334440.13762@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This macro defines "information about quirks," not "quirks for
information."

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index d46dc43..699984b 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2344,7 +2344,7 @@ static int uvc_clock_param_set(const char *val, const struct kernel_param *kp)
 	.quirks = UVC_QUIRK_FORCE_Y8,
 };
 
-#define UVC_QUIRK_INFO(q) (kernel_ulong_t)&(struct uvc_device_info){.quirks = q}
+#define UVC_INFO_QUIRK(q) (kernel_ulong_t)&(struct uvc_device_info){.quirks = q}
 
 /*
  * The Logitech cameras listed below have their interface class set to
@@ -2453,7 +2453,7 @@ static int uvc_clock_param_set(const char *val, const struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_RESTORE_CTRLS_ON_INIT) },
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_RESTORE_CTRLS_ON_INIT) },
 	/* Chicony CNF7129 (Asus EEE 100HE) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2462,7 +2462,7 @@ static int uvc_clock_param_set(const char *val, const struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_RESTRICT_FRAME_RATE) },
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_RESTRICT_FRAME_RATE) },
 	/* Alcor Micro AU3820 (Future Boy PC USB Webcam) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2525,7 +2525,7 @@ static int uvc_clock_param_set(const char *val, const struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_PROBE_MINMAX
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_PROBE_MINMAX
 					| UVC_QUIRK_BUILTIN_ISIGHT) },
 	/* Apple Built-In iSight via iBridge */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
@@ -2607,7 +2607,7 @@ static int uvc_clock_param_set(const char *val, const struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_PROBE_MINMAX
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_PROBE_MINMAX
 					| UVC_QUIRK_PROBE_DEF) },
 	/* IMC Networks (Medion Akoya) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
@@ -2707,7 +2707,7 @@ static int uvc_clock_param_set(const char *val, const struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_PROBE_MINMAX
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_PROBE_MINMAX
 					| UVC_QUIRK_PROBE_EXTRAFIELDS) },
 	/* Aveo Technology USB 2.0 Camera (Tasco USB Microscope) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
@@ -2725,7 +2725,7 @@ static int uvc_clock_param_set(const char *val, const struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_PROBE_EXTRAFIELDS) },
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_PROBE_EXTRAFIELDS) },
 	/* Manta MM-353 Plako */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2771,7 +2771,7 @@ static int uvc_clock_param_set(const char *val, const struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_STATUS_INTERVAL) },
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_STATUS_INTERVAL) },
 	/* MSI StarCam 370i */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2798,7 +2798,7 @@ static int uvc_clock_param_set(const char *val, const struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_PROBE_MINMAX
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_PROBE_MINMAX
 					| UVC_QUIRK_IGNORE_SELECTOR_UNIT) },
 	/* Oculus VR Positional Tracker DK2 */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
-- 
1.9.3
