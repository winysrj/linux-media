Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35467 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab1KHMGF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2011 07:06:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Yann Sionneau <yann@minet.net>
Subject: [PATCH 1/4] uvcvideo: Add debugfs support
Date: Tue,  8 Nov 2011 13:05:59 +0100
Message-Id: <1320753962-14079-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1320753962-14079-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1320753962-14079-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alexey Fisher <bug-track@fisher-privat.net>

Create a debugfs entry per UVC stream. This will be used to export
stream statistics.

Signed-off-by: Alexey Fisher <bug-track@fisher-privat.net>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/Makefile      |    2 +-
 drivers/media/video/uvc/uvc_debugfs.c |   76 +++++++++++++++++++++++++++++++++
 drivers/media/video/uvc/uvc_driver.c  |   21 +++++++--
 drivers/media/video/uvc/uvcvideo.h    |    9 ++++
 4 files changed, 102 insertions(+), 6 deletions(-)
 create mode 100644 drivers/media/video/uvc/uvc_debugfs.c

diff --git a/drivers/media/video/uvc/Makefile b/drivers/media/video/uvc/Makefile
index 2071ca8..c26d12f 100644
--- a/drivers/media/video/uvc/Makefile
+++ b/drivers/media/video/uvc/Makefile
@@ -1,5 +1,5 @@
 uvcvideo-objs  := uvc_driver.o uvc_queue.o uvc_v4l2.o uvc_video.o uvc_ctrl.o \
-		  uvc_status.o uvc_isight.o
+		  uvc_status.o uvc_isight.o uvc_debugfs.o
 ifeq ($(CONFIG_MEDIA_CONTROLLER),y)
 uvcvideo-objs  += uvc_entity.o
 endif
diff --git a/drivers/media/video/uvc/uvc_debugfs.c b/drivers/media/video/uvc/uvc_debugfs.c
new file mode 100644
index 0000000..f58969a
--- /dev/null
+++ b/drivers/media/video/uvc/uvc_debugfs.c
@@ -0,0 +1,76 @@
+/*
+ *      uvc_debugfs.c --  USB Video Class driver - Debugging support
+ *
+ *      Copyright (C) 2011
+ *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation; either version 2 of the License, or
+ *      (at your option) any later version.
+ *
+ */
+
+#include <linux/debugfs.h>
+#include <linux/slab.h>
+#include <linux/usb.h>
+
+#include "uvcvideo.h"
+
+/* -----------------------------------------------------------------------------
+ * Global and stream initialization/cleanup
+ */
+
+static struct dentry *uvc_debugfs_root_dir;
+
+int uvc_debugfs_init_stream(struct uvc_streaming *stream)
+{
+	struct usb_device *udev = stream->dev->udev;
+	struct dentry *dent;
+	char dir_name[32];
+
+	if (uvc_debugfs_root_dir == NULL)
+		return -ENODEV;
+
+	sprintf(dir_name, "%u-%u", udev->bus->busnum, udev->devnum);
+
+	dent = debugfs_create_dir(dir_name, uvc_debugfs_root_dir);
+	if (IS_ERR_OR_NULL(dent)) {
+		uvc_printk(KERN_INFO, "Unable to create debugfs %s directory.\n",
+			   dir_name);
+		return -ENODEV;
+	}
+
+	stream->debugfs_dir = dent;
+
+	return 0;
+}
+
+void uvc_debugfs_cleanup_stream(struct uvc_streaming *stream)
+{
+	if (stream->debugfs_dir == NULL)
+		return;
+
+	debugfs_remove_recursive(stream->debugfs_dir);
+	stream->debugfs_dir = NULL;
+}
+
+int uvc_debugfs_init(void)
+{
+	struct dentry *dir;
+
+	dir = debugfs_create_dir("uvcvideo", usb_debug_root);
+	if (IS_ERR_OR_NULL(dir)) {
+		uvc_printk(KERN_INFO, "Unable to create debugfs directory\n");
+		return -ENODATA;
+	}
+
+	uvc_debugfs_root_dir = dir;
+	return 0;
+}
+
+void uvc_debugfs_cleanup(void)
+{
+	if (uvc_debugfs_root_dir != NULL)
+		debugfs_remove_recursive(uvc_debugfs_root_dir);
+}
diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index 750ab68..a240d43 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -1675,6 +1675,8 @@ static void uvc_unregister_video(struct uvc_device *dev)
 
 		video_unregister_device(stream->vdev);
 		stream->vdev = NULL;
+
+		uvc_debugfs_cleanup_stream(stream);
 	}
 
 	/* Decrement the stream count and call uvc_delete explicitly if there
@@ -1700,6 +1702,8 @@ static int uvc_register_video(struct uvc_device *dev,
 		return ret;
 	}
 
+	uvc_debugfs_init_stream(stream);
+
 	/* Register the device with V4L. */
 	vdev = video_device_alloc();
 	if (vdev == NULL) {
@@ -2405,17 +2409,24 @@ struct uvc_driver uvc_driver = {
 
 static int __init uvc_init(void)
 {
-	int result;
+	int ret;
 
-	result = usb_register(&uvc_driver.driver);
-	if (result == 0)
-		printk(KERN_INFO DRIVER_DESC " (" DRIVER_VERSION ")\n");
-	return result;
+	uvc_debugfs_init();
+
+	ret = usb_register(&uvc_driver.driver);
+	if (ret < 0) {
+		uvc_debugfs_cleanup();
+		return ret;
+	}
+
+	printk(KERN_INFO DRIVER_DESC " (" DRIVER_VERSION ")\n");
+	return 0;
 }
 
 static void __exit uvc_cleanup(void)
 {
 	usb_deregister(&uvc_driver.driver);
+	uvc_debugfs_cleanup();
 }
 
 module_init(uvc_init);
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 2b84cbb..d975636 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -403,6 +403,9 @@ struct uvc_streaming {
 
 	__u32 sequence;
 	__u8 last_fid;
+
+	/* debugfs */
+	struct dentry *debugfs_dir;
 };
 
 enum uvc_device_state {
@@ -606,4 +609,10 @@ extern struct usb_host_endpoint *uvc_find_endpoint(
 void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream,
 		struct uvc_buffer *buf);
 
+/* debugfs */
+int uvc_debugfs_init(void);
+void uvc_debugfs_cleanup(void);
+int uvc_debugfs_init_stream(struct uvc_streaming *stream);
+void uvc_debugfs_cleanup_stream(struct uvc_streaming *stream);
+
 #endif
-- 
1.7.3.4

