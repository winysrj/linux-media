Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34079 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaFELHU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jun 2014 07:07:20 -0400
Received: from avalon.ideasonboard.com (unknown [91.178.128.233])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 7A1AC35A3C
	for <linux-media@vger.kernel.org>; Thu,  5 Jun 2014 13:06:53 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH ATTN] uvcvideo: Work around buggy Logitech C920 firmware
Date: Thu,  5 Jun 2014 13:07:43 +0200
Message-Id: <1401966463-2863-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: William Manley <will@williammanley.net>

The uvcvideo webcam driver exposes the v4l2 control "Exposure (Absolute)"
which allows the user to control the exposure time of the webcam,
essentially controlling the brightness of the received image.  By default
the webcam automatically adjusts the exposure time automatically but the
if you set the control "Exposure, Auto"="Manual Mode" the user can fix
the exposure time.

Unfortunately it seems that the Logitech C920 has a firmware bug where
it will forget that it's in manual mode temporarily during initialisation.
This means that the camera doesn't respect the exposure time that the user
requested if they request it before starting to stream video.  They end up
with a video stream which is either too bright or too dark and must reset
the controls after video starts streaming.

This patch introduces the quirk UVC_QUIRK_RESTORE_CTRLS_ON_INIT which
causes the cached controls to be re-uploaded to the camera immediately
after initialising the camera.  This quirk is applied to the C920 to work
around this camera bug.

Signed-off-by: William Manley <will@williammanley.net>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_ctrl.c   |  2 +-
 drivers/media/usb/uvc/uvc_driver.c | 11 ++++++++++-
 drivers/media/usb/uvc/uvc_video.c  |  6 ++++++
 drivers/media/usb/uvc/uvcvideo.h   |  3 ++-
 4 files changed, 19 insertions(+), 3 deletions(-)

Hi Mauro,

Here's a lone uvcvideo patch that managed to splip through the cracks of my
v3.16 pull requests. If you still find time to process it during this merge
window it would be greatly appreciated.

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 0eb82106..30f4fe9 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1795,7 +1795,7 @@ done:
  * - Handle restore order (Auto-Exposure Mode should be restored before
  *   Exposure Time).
  */
-int uvc_ctrl_resume_device(struct uvc_device *dev)
+int uvc_ctrl_restore_values(struct uvc_device *dev)
 {
 	struct uvc_control *ctrl;
 	struct uvc_entity *entity;
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index ad47c5c..895b004 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2001,7 +2001,7 @@ static int __uvc_resume(struct usb_interface *intf, int reset)
 		int ret = 0;
 
 		if (reset) {
-			ret = uvc_ctrl_resume_device(dev);
+			ret = uvc_ctrl_restore_values(dev);
 			if (ret < 0)
 				return ret;
 		}
@@ -2176,6 +2176,15 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0 },
+	/* Logitech HD Pro Webcam C920 */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x046d,
+	  .idProduct		= 0x082d,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_RESTORE_CTRLS_ON_INIT },
 	/* Chicony CNF7129 (Asus EEE 100HE) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 9144a2f..61eb857 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1678,6 +1678,12 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 		}
 	}
 
+	/* The Logitech C920 temporarily forgets that it should not be adjusting
+	 * Exposure Absolute during init so restore controls to stored values.
+	 */
+	if (stream->dev->quirks & UVC_QUIRK_RESTORE_CTRLS_ON_INIT)
+		uvc_ctrl_restore_values(stream->dev);
+
 	return 0;
 }
 
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index b1f69a6..39c4f94 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -147,6 +147,7 @@
 #define UVC_QUIRK_FIX_BANDWIDTH		0x00000080
 #define UVC_QUIRK_PROBE_DEF		0x00000100
 #define UVC_QUIRK_RESTRICT_FRAME_RATE	0x00000200
+#define UVC_QUIRK_RESTORE_CTRLS_ON_INIT	0x00000400
 
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
@@ -688,7 +689,7 @@ extern int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 		const struct uvc_control_mapping *mapping);
 extern int uvc_ctrl_init_device(struct uvc_device *dev);
 extern void uvc_ctrl_cleanup_device(struct uvc_device *dev);
-extern int uvc_ctrl_resume_device(struct uvc_device *dev);
+extern int uvc_ctrl_restore_values(struct uvc_device *dev);
 
 extern int uvc_ctrl_begin(struct uvc_video_chain *chain);
 extern int __uvc_ctrl_commit(struct uvc_fh *handle, int rollback,
-- 
Regards,

Laurent Pinchart

