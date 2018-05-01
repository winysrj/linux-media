Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:36353 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753323AbeEAJAz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 1 May 2018 05:00:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv12 PATCH 01/29] v4l2-device.h: always expose mdev
Date: Tue,  1 May 2018 11:00:23 +0200
Message-Id: <20180501090051.9321-2-hverkuil@xs4all.nl>
In-Reply-To: <20180501090051.9321-1-hverkuil@xs4all.nl>
References: <20180501090051.9321-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The mdev field is only present if CONFIG_MEDIA_CONTROLLER is set.
But since we will need to pass the media_device to vb2 and the
control framework it is very convenient to just make this field
available all the time. If CONFIG_MEDIA_CONTROLLER is not set,
then it will just be NULL.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/v4l2-device.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index 0c9e4da55499..b330e4a08a6b 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -33,7 +33,7 @@ struct v4l2_ctrl_handler;
  * struct v4l2_device - main struct to for V4L2 device drivers
  *
  * @dev: pointer to struct device.
- * @mdev: pointer to struct media_device
+ * @mdev: pointer to struct media_device, may be NULL.
  * @subdevs: used to keep track of the registered subdevs
  * @lock: lock this struct; can be used by the driver as well
  *	if this struct is embedded into a larger struct.
@@ -58,9 +58,7 @@ struct v4l2_ctrl_handler;
  */
 struct v4l2_device {
 	struct device *dev;
-#if defined(CONFIG_MEDIA_CONTROLLER)
 	struct media_device *mdev;
-#endif
 	struct list_head subdevs;
 	spinlock_t lock;
 	char name[V4L2_DEVICE_NAME_SIZE];
-- 
2.17.0
