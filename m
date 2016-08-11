Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50486 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbcHKKTQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 06:19:16 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id 5840820ADD
	for <linux-media@vger.kernel.org>; Thu, 11 Aug 2016 13:19:12 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] v4l: Do not allow re-registering sub-devices
Date: Thu, 11 Aug 2016 13:18:37 +0300
Message-Id: <1470910717-18575-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Albeit not prohibited explicitly, re-registering sub-devices generated a
big, loud warning which quite likely soon was followed by a crash. What
followed was re-initialising a media entity, driver's registered() callback
being called and re-adding a list entry to a list.

Prevent this by returning an error if a sub-device is already registered.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-device.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 06fa5f1..6136571 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -160,12 +160,9 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 	int err;
 
 	/* Check for valid input */
-	if (v4l2_dev == NULL || sd == NULL || !sd->name[0])
+	if (!v4l2_dev || sd->v4l2_dev || !sd || !sd->name[0])
 		return -EINVAL;
 
-	/* Warn if we apparently re-register a subdev */
-	WARN_ON(sd->v4l2_dev != NULL);
-
 	/*
 	 * The reason to acquire the module here is to avoid unloading
 	 * a module of sub-device which is registered to a media
-- 
2.7.4

