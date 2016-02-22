Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49830 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755475AbcBVUrI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 15:47:08 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	shuahkh@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 4/4] media: Move media_get_uptr() macro out of the media.h user space header
Date: Mon, 22 Feb 2016 22:47:04 +0200
Message-Id: <1456174024-11389-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1456174024-11389-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1456174024-11389-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

The media_get_uptr() macro is mostly useful only for the IOCTL handling
code in media-device.c so move it there.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 5 +++++
 include/uapi/linux/media.h   | 5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index f001c27..39afba0 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -38,6 +38,11 @@
  * Userspace API
  */
 
+static inline void __user *media_get_uptr(__u64 arg)
+{
+	return (void __user *)(uintptr_t)arg;
+}
+
 static int media_device_open(struct file *filp)
 {
 	return 0;
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 65991df..b989494 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -353,11 +353,6 @@ struct media_v2_topology {
 	__u32 reserved[18];
 };
 
-static inline void __user *media_get_uptr(__u64 arg)
-{
-	return (void __user *)(uintptr_t)arg;
-}
-
 /* ioctls */
 
 #define MEDIA_IOC_DEVICE_INFO		_IOWR('|', 0x00, struct media_device_info)
-- 
2.1.4

