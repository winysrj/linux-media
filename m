Return-path: <linux-media-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51085 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756033AbaCLSJM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Mar 2014 14:09:12 -0400
Received: from compute3.internal (compute3.nyi.mail.srv.osa [10.202.2.43])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 84AB020D56
	for <linux-media@vger.kernel.org>; Wed, 12 Mar 2014 14:09:11 -0400 (EDT)
From: William Manley <will@williammanley.net>
To: linux-media@vger.kernel.org
Cc: William Manley <will@williammanley.net>
Subject: [PATCH] uvcvideo: Work around buggy Logitech C920 firmware
Date: Wed, 12 Mar 2014 18:08:31 +0000
Message-Id: <1394647711-25291-1-git-send-email-will@williammanley.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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

This patch works around this camera bug by re-uploading the cached
controls to the camera immediately after initialising the camera.

Signed-off-by: William Manley <will@williammanley.net>
---
 drivers/media/usb/uvc/uvc_ctrl.c   | 2 +-
 drivers/media/usb/uvc/uvc_driver.c | 2 +-
 drivers/media/usb/uvc/uvc_video.c  | 5 +++++
 drivers/media/usb/uvc/uvcvideo.h   | 2 +-
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index a2f4501..f72d7eb 100644
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
index c3bb250..9f8a87e 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1981,7 +1981,7 @@ static int __uvc_resume(struct usb_interface *intf, int reset)
 		int ret = 0;
 
 		if (reset) {
-			ret = uvc_ctrl_resume_device(dev);
+			ret = uvc_ctrl_restore_values(dev);
 			if (ret < 0)
 				return ret;
 		}
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 3394c34..87cd57b 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1660,6 +1660,11 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 		}
 	}
 
+	/* The Logitech C920 temporarily forgets that it should not be
+	   adjusting Exposure Absolute during init so restore controls to
+	   stored values. */
+	uvc_ctrl_restore_values(stream->dev);
+
 	return 0;
 }
 
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 9e35982..3b365a3 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -676,7 +676,7 @@ extern int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 		const struct uvc_control_mapping *mapping);
 extern int uvc_ctrl_init_device(struct uvc_device *dev);
 extern void uvc_ctrl_cleanup_device(struct uvc_device *dev);
-extern int uvc_ctrl_resume_device(struct uvc_device *dev);
+extern int uvc_ctrl_restore_values(struct uvc_device *dev);
 
 extern int uvc_ctrl_begin(struct uvc_video_chain *chain);
 extern int __uvc_ctrl_commit(struct uvc_fh *handle, int rollback,
-- 
1.9.0

