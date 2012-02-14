Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe05.c2i.net ([212.247.154.130]:51985 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755364Ab2BNVWp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 16:22:45 -0500
Received: from [176.74.208.111] (account mc467741@c2i.net HELO laptop002.hselasky.homeunix.org)
  by mailfe05.swip.net (CommuniGate Pro SMTP 5.4.2)
  with ESMTPA id 237339976 for linux-media@vger.kernel.org; Tue, 14 Feb 2012 22:17:42 +0100
From: Hans Petter Selasky <hselasky@c2i.net>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH] Make the USB Video Class debug filesystem support compile  time optional.
Date: Tue, 14 Feb 2012 22:15:51 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201202142215.51388.hselasky@c2i.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following patch makes the recently added DEBUGFS for UVC optional.

--HPS

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
---
 drivers/media/video/uvc/Kconfig      |    9 +++++++++
 drivers/media/video/uvc/Makefile     |    5 ++++-
 drivers/media/video/uvc/uvc_driver.c |   12 ++++++++++--
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/uvc/Kconfig b/drivers/media/video/uvc/Kconfig
index 6c197da..45e89a9 100644
--- a/drivers/media/video/uvc/Kconfig
+++ b/drivers/media/video/uvc/Kconfig
@@ -7,6 +7,15 @@ config USB_VIDEO_CLASS
 
 	  For more information see: <http://linux-uvc.berlios.de/>
 
+config USB_VIDEO_CLASS_DEBUGFS
+	bool "UVC debugfs support"
+	default y
+	---help---
+	  This option makes the USB Video Class driver build with
+	  debugfs support.
+
+	  If you are in doubt, say Y.
+
 config USB_VIDEO_CLASS_INPUT_EVDEV
 	bool "UVC input events device support"
 	default y
diff --git a/drivers/media/video/uvc/Makefile b/drivers/media/video/uvc/Makefile
index c26d12f..a152a2a 100644
--- a/drivers/media/video/uvc/Makefile
+++ b/drivers/media/video/uvc/Makefile
@@ -1,5 +1,8 @@
 uvcvideo-objs  := uvc_driver.o uvc_queue.o uvc_v4l2.o uvc_video.o uvc_ctrl.o \
-		  uvc_status.o uvc_isight.o uvc_debugfs.o
+		  uvc_status.o uvc_isight.o
+ifeq ($(CONFIG_USB_VIDEO_CLASS_DEBUGFS),y)
+uvcvideo-objs  += uvc_debugfs.o
+endif
 ifeq ($(CONFIG_MEDIA_CONTROLLER),y)
 uvcvideo-objs  += uvc_entity.o
 endif
diff --git a/drivers/media/video/uvc/uvc_driver.c 
b/drivers/media/video/uvc/uvc_driver.c
index a240d43..291f77b 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -1676,7 +1676,9 @@ static void uvc_unregister_video(struct uvc_device *dev)
 		video_unregister_device(stream->vdev);
 		stream->vdev = NULL;
 
+#ifdef CONFIG_USB_VIDEO_CLASS_DEBUGFS
 		uvc_debugfs_cleanup_stream(stream);
+#endif
 	}
 
 	/* Decrement the stream count and call uvc_delete explicitly if there
@@ -1702,8 +1704,9 @@ static int uvc_register_video(struct uvc_device *dev,
 		return ret;
 	}
 
+#ifdef CONFIG_USB_VIDEO_CLASS_DEBUGFS
 	uvc_debugfs_init_stream(stream);
-
+#endif
 	/* Register the device with V4L. */
 	vdev = video_device_alloc();
 	if (vdev == NULL) {
@@ -2411,11 +2414,14 @@ static int __init uvc_init(void)
 {
 	int ret;
 
+#ifdef CONFIG_USB_VIDEO_CLASS_DEBUGFS
 	uvc_debugfs_init();
-
+#endif
 	ret = usb_register(&uvc_driver.driver);
 	if (ret < 0) {
+#ifdef CONFIG_USB_VIDEO_CLASS_DEBUGFS
 		uvc_debugfs_cleanup();
+#endif
 		return ret;
 	}
 
@@ -2426,7 +2432,9 @@ static int __init uvc_init(void)
 static void __exit uvc_cleanup(void)
 {
 	usb_deregister(&uvc_driver.driver);
+#ifdef CONFIG_USB_VIDEO_CLASS_DEBUGFS
 	uvc_debugfs_cleanup();
+#endif
 }
 
 module_init(uvc_init);
-- 
1.7.6
