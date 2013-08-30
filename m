Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:60858 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab3H3CRf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 22:17:35 -0400
Received: by mail-pd0-f174.google.com with SMTP id y13so1218036pdi.5
        for <linux-media@vger.kernel.org>; Thu, 29 Aug 2013 19:17:34 -0700 (PDT)
From: Pawel Osciak <posciak@chromium.org>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Pawel Osciak <posciak@chromium.org>
Subject: [PATCH v1 04/19] uvcvideo: Create separate debugfs entries for each streaming interface.
Date: Fri, 30 Aug 2013 11:17:03 +0900
Message-Id: <1377829038-4726-5-git-send-email-posciak@chromium.org>
In-Reply-To: <1377829038-4726-1-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add interface number to debugfs entry name to be able to create separate
entries for each streaming interface for devices exposing more than one,
instead of failing to create more than one.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
---
 drivers/media/usb/uvc/uvc_debugfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_debugfs.c b/drivers/media/usb/uvc/uvc_debugfs.c
index 14561a5..0663fbd 100644
--- a/drivers/media/usb/uvc/uvc_debugfs.c
+++ b/drivers/media/usb/uvc/uvc_debugfs.c
@@ -84,7 +84,8 @@ int uvc_debugfs_init_stream(struct uvc_streaming *stream)
 	if (uvc_debugfs_root_dir == NULL)
 		return -ENODEV;
 
-	sprintf(dir_name, "%u-%u", udev->bus->busnum, udev->devnum);
+	sprintf(dir_name, "%u-%u-%u", udev->bus->busnum, udev->devnum,
+			stream->intfnum);
 
 	dent = debugfs_create_dir(dir_name, uvc_debugfs_root_dir);
 	if (IS_ERR_OR_NULL(dent)) {
-- 
1.8.4

