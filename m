Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34067 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762745AbdALBca (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jan 2017 20:32:30 -0500
Received: by mail-pf0-f193.google.com with SMTP id y143so787776pfb.1
        for <linux-media@vger.kernel.org>; Wed, 11 Jan 2017 17:32:30 -0800 (PST)
From: Jaejoong Kim <climbbb.kim@gmail.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, Jaejoong Kim <climbbb.kim@gmail.com>
Subject: [PATCH] [media] uvcvideo: change result code of debugfs_init to void
Date: Thu, 12 Jan 2017 10:31:21 +0900
Message-Id: <1484184681-27384-1-git-send-email-climbbb.kim@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The device driver should keep going even if debugfs initialization fails.
So, change the return type to void.

Signed-off-by: Jaejoong Kim <climbbb.kim@gmail.com>
---
 drivers/media/usb/uvc/uvc_debugfs.c | 15 ++++++---------
 drivers/media/usb/uvc/uvcvideo.h    |  4 ++--
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_debugfs.c b/drivers/media/usb/uvc/uvc_debugfs.c
index 14561a5..368f8f8 100644
--- a/drivers/media/usb/uvc/uvc_debugfs.c
+++ b/drivers/media/usb/uvc/uvc_debugfs.c
@@ -75,14 +75,14 @@ static const struct file_operations uvc_debugfs_stats_fops = {
 
 static struct dentry *uvc_debugfs_root_dir;
 
-int uvc_debugfs_init_stream(struct uvc_streaming *stream)
+void uvc_debugfs_init_stream(struct uvc_streaming *stream)
 {
 	struct usb_device *udev = stream->dev->udev;
 	struct dentry *dent;
 	char dir_name[32];
 
 	if (uvc_debugfs_root_dir == NULL)
-		return -ENODEV;
+		return;
 
 	sprintf(dir_name, "%u-%u", udev->bus->busnum, udev->devnum);
 
@@ -90,7 +90,7 @@ int uvc_debugfs_init_stream(struct uvc_streaming *stream)
 	if (IS_ERR_OR_NULL(dent)) {
 		uvc_printk(KERN_INFO, "Unable to create debugfs %s "
 			   "directory.\n", dir_name);
-		return -ENODEV;
+		return;
 	}
 
 	stream->debugfs_dir = dent;
@@ -100,10 +100,8 @@ int uvc_debugfs_init_stream(struct uvc_streaming *stream)
 	if (IS_ERR_OR_NULL(dent)) {
 		uvc_printk(KERN_INFO, "Unable to create debugfs stats file.\n");
 		uvc_debugfs_cleanup_stream(stream);
-		return -ENODEV;
+		return;
 	}
-
-	return 0;
 }
 
 void uvc_debugfs_cleanup_stream(struct uvc_streaming *stream)
@@ -115,18 +113,17 @@ void uvc_debugfs_cleanup_stream(struct uvc_streaming *stream)
 	stream->debugfs_dir = NULL;
 }
 
-int uvc_debugfs_init(void)
+void uvc_debugfs_init(void)
 {
 	struct dentry *dir;
 
 	dir = debugfs_create_dir("uvcvideo", usb_debug_root);
 	if (IS_ERR_OR_NULL(dir)) {
 		uvc_printk(KERN_INFO, "Unable to create debugfs directory\n");
-		return -ENODATA;
+		return;
 	}
 
 	uvc_debugfs_root_dir = dir;
-	return 0;
 }
 
 void uvc_debugfs_cleanup(void)
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 7e4d3ee..1d1b992 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -745,9 +745,9 @@ void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream,
 		struct uvc_buffer *buf);
 
 /* debugfs and statistics */
-int uvc_debugfs_init(void);
+void uvc_debugfs_init(void);
 void uvc_debugfs_cleanup(void);
-int uvc_debugfs_init_stream(struct uvc_streaming *stream);
+void uvc_debugfs_init_stream(struct uvc_streaming *stream);
 void uvc_debugfs_cleanup_stream(struct uvc_streaming *stream);
 
 size_t uvc_video_stats_dump(struct uvc_streaming *stream, char *buf,
-- 
2.7.4

