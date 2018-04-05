Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:42549 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751259AbeDEK7M (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 06:59:12 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: tfiga@google.com, hverkuil@xs4all.nl
Subject: [v4l-utils RFC 3/6] libmediactl: Add open, close and fd to public API
Date: Thu,  5 Apr 2018 13:58:16 +0300
Message-Id: <1522925899-14073-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1522925899-14073-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1522925899-14073-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add functions to open and close the media device as well as to obtain its
fd.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/media-ctl/libmediactl.c | 9 +++++++--
 utils/media-ctl/mediactl.h    | 4 ++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index 1fd6525..e20ab97 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -175,7 +175,7 @@ const struct media_entity_desc *media_entity_get_info(struct media_entity *entit
  * Open/close
  */
 
-static int media_device_open(struct media_device *media)
+int media_device_open(struct media_device *media)
 {
 	int ret;
 
@@ -195,7 +195,12 @@ static int media_device_open(struct media_device *media)
 	return 0;
 }
 
-static void media_device_close(struct media_device *media)
+int media_device_fd(struct media_device *media)
+{
+	return media->fd;
+}
+
+void media_device_close(struct media_device *media)
 {
 	if (media->fd != -1) {
 		close(media->fd);
diff --git a/utils/media-ctl/mediactl.h b/utils/media-ctl/mediactl.h
index af36051..5e325c4 100644
--- a/utils/media-ctl/mediactl.h
+++ b/utils/media-ctl/mediactl.h
@@ -59,6 +59,10 @@ struct media_entity;
  */
 struct media_device *media_device_new(const char *devnode);
 
+int media_device_open(struct media_device *media);
+int media_device_fd(struct media_device *media);
+void media_device_close(struct media_device *media);
+
 /**
  * @brief Create a new emulated media device.
  * @param info - device information.
-- 
2.7.4
