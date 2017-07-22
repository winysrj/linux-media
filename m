Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:55108 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752127AbdGVJHG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Jul 2017 05:07:06 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media: drop use of MEDIA_API_VERSION
Message-ID: <46b82486-56fa-9e66-53c9-071a7a03e32c@xs4all.nl>
Date: Sat, 22 Jul 2017 11:06:59 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set media_version to LINUX_VERSION_CODE, just as we did for
driver_version.

Nobody ever rememebers to update the version number, but
LINUX_VERSION_CODE will always be updated.

Move the MEDIA_API_VERSION define to the ifndef __KERNEL__ section of the
media.h header. That way kernelspace can't accidentally start to use
it again.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
This patch sits on top of the '[PATCHv2 0/5] media: drop driver_version from media_device'
patch series I posted yesterday.
---
 drivers/media/media-device.c | 3 +--
 include/uapi/linux/media.h   | 5 +++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 979e4307d248..3c99294e3ebf 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -69,9 +69,8 @@ static int media_device_get_info(struct media_device *dev,
 	strlcpy(info->serial, dev->serial, sizeof(info->serial));
 	strlcpy(info->bus_info, dev->bus_info, sizeof(info->bus_info));

-	info->media_version = MEDIA_API_VERSION;
+	info->media_version = info->driver_version = LINUX_VERSION_CODE;
 	info->hw_revision = dev->hw_revision;
-	info->driver_version = LINUX_VERSION_CODE;

 	return 0;
 }
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index fac96c64fe51..4865f1e71339 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -30,8 +30,6 @@
 #include <linux/types.h>
 #include <linux/version.h>

-#define MEDIA_API_VERSION	KERNEL_VERSION(0, 1, 0)
-
 struct media_device_info {
 	char driver[16];
 	char model[32];
@@ -187,6 +185,9 @@ struct media_device_info {
 #define MEDIA_ENT_T_V4L2_SUBDEV_LENS	MEDIA_ENT_F_LENS
 #define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	MEDIA_ENT_F_ATV_DECODER
 #define MEDIA_ENT_T_V4L2_SUBDEV_TUNER	MEDIA_ENT_F_TUNER
+
+/* Obsolete symbol for media_version, no longer used in the kernel */
+#define MEDIA_API_VERSION		KERNEL_VERSION(0, 1, 0)
 #endif

 /* Entity flags */
-- 
2.13.2
