Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:55447 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755152AbdGVLbB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Jul 2017 07:31:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 1/6] media-device: set driver_version directly
Date: Sat, 22 Jul 2017 13:30:52 +0200
Message-Id: <20170722113057.45202-2-hverkuil@xs4all.nl>
In-Reply-To: <20170722113057.45202-1-hverkuil@xs4all.nl>
References: <20170722113057.45202-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Don't use driver_version from struct media_device, just return
LINUX_VERSION_CODE as the other media subsystems do.

The driver_version field in struct media_device will be removed
in the following patches.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/media-device.c | 2 +-
 include/media/media-device.h | 5 -----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index fce91b543c14..7ff8e2d5bb07 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -71,7 +71,7 @@ static int media_device_get_info(struct media_device *dev,
 
 	info->media_version = MEDIA_API_VERSION;
 	info->hw_revision = dev->hw_revision;
-	info->driver_version = dev->driver_version;
+	info->driver_version = LINUX_VERSION_CODE;
 
 	return 0;
 }
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 6896266031b9..7ae200d89a9f 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -249,11 +249,6 @@ void media_device_cleanup(struct media_device *mdev);
  *    driver-specific format. When possible the revision should be formatted
  *    with the KERNEL_VERSION() macro.
  *
- *  - &media_entity.driver_version is formatted with the KERNEL_VERSION()
- *    macro. The version minor must be incremented when new features are added
- *    to the userspace API without breaking binary compatibility. The version
- *    major must be incremented when binary compatibility is broken.
- *
  * .. note::
  *
  *    #) Upon successful registration a character device named media[0-9]+ is created. The device major and minor numbers are dynamic. The model name is exported as a sysfs attribute.
-- 
2.13.2
