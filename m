Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:61951 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752681AbdKHQAT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Nov 2017 11:00:19 -0500
Received: from axis700.grange ([84.44.207.202]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0M8MyE-1f7Kc71aDa-00vuMj for
 <linux-media@vger.kernel.org>; Wed, 08 Nov 2017 17:00:17 +0100
Received: from 200r.grange (200r.grange [192.168.1.16])
        by axis700.grange (Postfix) with ESMTP id 8F46D618A6
        for <linux-media@vger.kernel.org>; Wed,  8 Nov 2017 17:00:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Subject: [PATCH 2/3 v7] uvcvideo: add extensible device information
Date: Wed,  8 Nov 2017 17:00:13 +0100
Message-Id: <1510156814-28645-3-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1510156814-28645-1-git-send-email-g.liakhovetski@gmx.de>
References: <1510156814-28645-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>

Currently the UVC driver assigns a quirk bitmask to the .driver_info
field of struct usb_device_id. This patch instroduces a struct to store
quirks and possibly other per-device parameters in the future.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
---

v7: this is a new patch in the series. Needed to enable specifying
private camera metadata formats

 drivers/media/usb/uvc/uvc_driver.c | 127 +++++++++++++++++++++++--------------
 1 file changed, 78 insertions(+), 49 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 6d22b22..cbf79b9 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2001,11 +2001,18 @@ static int uvc_register_chains(struct uvc_device *dev)
  * USB probe, disconnect, suspend and resume
  */
 
+struct uvc_device_info {
+	u32	quirks;
+};
+
 static int uvc_probe(struct usb_interface *intf,
 		     const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct uvc_device *dev;
+	const struct uvc_device_info *info =
+		(const struct uvc_device_info *)id->driver_info;
+	u32 quirks = info ? info->quirks : 0;
 	int function;
 	int ret;
 
@@ -2032,7 +2039,7 @@ static int uvc_probe(struct usb_interface *intf,
 	dev->intf = usb_get_intf(intf);
 	dev->intfnum = intf->cur_altsetting->desc.bInterfaceNumber;
 	dev->quirks = (uvc_quirks_param == -1)
-		    ? id->driver_info : uvc_quirks_param;
+		    ? quirks : uvc_quirks_param;
 
 	if (udev->product != NULL)
 		strlcpy(dev->name, udev->product, sizeof dev->name);
@@ -2073,7 +2080,7 @@ static int uvc_probe(struct usb_interface *intf,
 		le16_to_cpu(udev->descriptor.idVendor),
 		le16_to_cpu(udev->descriptor.idProduct));
 
-	if (dev->quirks != id->driver_info) {
+	if (dev->quirks != quirks) {
 		uvc_printk(KERN_INFO, "Forcing device quirks to 0x%x by module "
 			"parameter for testing purpose.\n", dev->quirks);
 		uvc_printk(KERN_INFO, "Please report required quirks to the "
@@ -2271,6 +2278,28 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
  * Driver initialization and cleanup
  */
 
+static struct uvc_device_info uvc_quirk_probe_minmax = {
+	.quirks = UVC_QUIRK_PROBE_MINMAX,
+};
+
+static struct uvc_device_info uvc_quirk_fix_bandwidth = {
+	.quirks = UVC_QUIRK_FIX_BANDWIDTH,
+};
+
+static struct uvc_device_info uvc_quirk_probe_def = {
+	.quirks = UVC_QUIRK_PROBE_DEF,
+};
+
+static struct uvc_device_info uvc_quirk_stream_no_fid = {
+	.quirks = UVC_QUIRK_STREAM_NO_FID,
+};
+
+static struct uvc_device_info uvc_quirk_force_y8 = {
+	.quirks = UVC_QUIRK_FORCE_Y8,
+};
+
+#define UVC_QUIRK_INFO(q) (kernel_ulong_t)&(struct uvc_device_info){.quirks = q}
+
 /*
  * The Logitech cameras listed below have their interface class set to
  * VENDOR_SPEC because they don't announce themselves as UVC devices, even
@@ -2285,7 +2314,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_probe_minmax },
 	/* Genius eFace 2025 */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2294,7 +2323,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_probe_minmax },
 	/* Microsoft Lifecam NX-6000 */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2303,7 +2332,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_probe_minmax },
 	/* Microsoft Lifecam NX-3000 */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2312,7 +2341,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_PROBE_DEF },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_probe_def },
 	/* Microsoft Lifecam VX-7000 */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2321,7 +2350,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_probe_minmax },
 	/* Logitech Quickcam Fusion */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2378,7 +2407,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_RESTORE_CTRLS_ON_INIT },
+	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_RESTORE_CTRLS_ON_INIT) },
 	/* Chicony CNF7129 (Asus EEE 100HE) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2387,7 +2416,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_RESTRICT_FRAME_RATE },
+	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_RESTRICT_FRAME_RATE) },
 	/* Alcor Micro AU3820 (Future Boy PC USB Webcam) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2396,7 +2425,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_probe_minmax },
 	/* Dell XPS m1530 */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2405,7 +2434,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info 		= UVC_QUIRK_PROBE_DEF },
+	  .driver_info 		= (kernel_ulong_t)&uvc_quirk_probe_def },
 	/* Dell SP2008WFP Monitor */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2414,7 +2443,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info 		= UVC_QUIRK_PROBE_DEF },
+	  .driver_info 		= (kernel_ulong_t)&uvc_quirk_probe_def },
 	/* Dell Alienware X51 */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2423,7 +2452,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info	= UVC_QUIRK_PROBE_DEF },
+	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_PROBE_DEF) },
 	/* Dell Studio Hybrid 140g (OmniVision webcam) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2432,7 +2461,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_PROBE_DEF },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_probe_def },
 	/* Dell XPS M1330 (OmniVision OV7670 webcam) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2441,7 +2470,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_PROBE_DEF },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_probe_def },
 	/* Apple Built-In iSight */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2450,8 +2479,8 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info 		= UVC_QUIRK_PROBE_MINMAX
-				| UVC_QUIRK_BUILTIN_ISIGHT },
+	  .driver_info 		= UVC_QUIRK_INFO(UVC_QUIRK_PROBE_MINMAX
+					| UVC_QUIRK_BUILTIN_ISIGHT) },
 	/* Apple Built-In iSight via iBridge */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2460,7 +2489,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_PROBE_DEF },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_probe_def },
 	/* Foxlink ("HP Webcam" on HP Mini 5103) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2469,7 +2498,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_FIX_BANDWIDTH },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_fix_bandwidth },
 	/* Genesys Logic USB 2.0 PC Camera */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2478,7 +2507,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_STREAM_NO_FID },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_stream_no_fid },
 	/* Hercules Classic Silver */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2487,7 +2516,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_FIX_BANDWIDTH },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_fix_bandwidth },
 	/* ViMicro Vega */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2496,7 +2525,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_FIX_BANDWIDTH },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_fix_bandwidth },
 	/* ViMicro - Minoru3D */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2505,7 +2534,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_FIX_BANDWIDTH },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_fix_bandwidth },
 	/* ViMicro Venus - Minoru3D */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2514,7 +2543,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_FIX_BANDWIDTH },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_fix_bandwidth },
 	/* Ophir Optronics - SPCAM 620U */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2523,7 +2552,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_probe_minmax },
 	/* MT6227 */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2532,8 +2561,8 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_PROBE_MINMAX
-				| UVC_QUIRK_PROBE_DEF },
+	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_PROBE_MINMAX
+					| UVC_QUIRK_PROBE_DEF) },
 	/* IMC Networks (Medion Akoya) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2542,7 +2571,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_STREAM_NO_FID },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_stream_no_fid },
 	/* JMicron USB2.0 XGA WebCam */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2551,7 +2580,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_probe_minmax },
 	/* Syntek (HP Spartan) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2560,7 +2589,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_STREAM_NO_FID },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_stream_no_fid },
 	/* Syntek (Samsung Q310) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2569,7 +2598,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_STREAM_NO_FID },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_stream_no_fid },
 	/* Syntek (Packard Bell EasyNote MX52 */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2578,7 +2607,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_STREAM_NO_FID },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_stream_no_fid },
 	/* Syntek (Asus F9SG) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2587,7 +2616,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_STREAM_NO_FID },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_stream_no_fid },
 	/* Syntek (Asus U3S) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2596,7 +2625,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_STREAM_NO_FID },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_stream_no_fid },
 	/* Syntek (JAOtech Smart Terminal) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2605,7 +2634,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_STREAM_NO_FID },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_stream_no_fid },
 	/* Miricle 307K */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2614,7 +2643,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_STREAM_NO_FID },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_stream_no_fid },
 	/* Lenovo Thinkpad SL400/SL500 */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2623,7 +2652,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_STREAM_NO_FID },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_stream_no_fid },
 	/* Aveo Technology USB 2.0 Camera */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2632,8 +2661,8 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_PROBE_MINMAX
-				| UVC_QUIRK_PROBE_EXTRAFIELDS },
+	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_PROBE_MINMAX
+					| UVC_QUIRK_PROBE_EXTRAFIELDS) },
 	/* Aveo Technology USB 2.0 Camera (Tasco USB Microscope) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2650,7 +2679,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_PROBE_EXTRAFIELDS },
+	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_PROBE_EXTRAFIELDS) },
 	/* Manta MM-353 Plako */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2659,7 +2688,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_probe_minmax },
 	/* FSC WebCam V30S */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2668,7 +2697,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_probe_minmax },
 	/* Arkmicro unbranded */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2677,7 +2706,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_PROBE_DEF },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_probe_def },
 	/* The Imaging Source USB CCD cameras */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2696,7 +2725,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_STATUS_INTERVAL },
+	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_STATUS_INTERVAL) },
 	/* MSI StarCam 370i */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2705,7 +2734,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_probe_minmax },
 	/* SiGma Micro USB Web Camera */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2714,8 +2743,8 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_PROBE_MINMAX
-				| UVC_QUIRK_IGNORE_SELECTOR_UNIT },
+	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_PROBE_MINMAX
+					| UVC_QUIRK_IGNORE_SELECTOR_UNIT) },
 	/* Oculus VR Positional Tracker DK2 */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2724,7 +2753,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_FORCE_Y8 },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_force_y8 },
 	/* Oculus VR Rift Sensor */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
@@ -2733,7 +2762,7 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_QUIRK_FORCE_Y8 },
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_force_y8 },
 	/* Generic USB Video Class */
 	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, UVC_PC_PROTOCOL_UNDEFINED) },
 	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, UVC_PC_PROTOCOL_15) },
-- 
1.9.3
