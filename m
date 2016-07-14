Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40488 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752226AbcGNWf0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 18:35:26 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [RFC 11/16] v4l: Acquire a reference to the media device for every video device
Date: Fri, 15 Jul 2016 01:35:06 +0300
Message-Id: <1468535711-13836-12-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video device depends on the existence of its media device --- if there
is one. Acquire a reference to it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-dev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 70b559d..80cc675 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -171,6 +171,7 @@ static void v4l2_device_release(struct device *cd)
 {
 	struct video_device *vdev = to_video_device(cd);
 	struct v4l2_device *v4l2_dev = vdev->v4l2_dev;
+	struct media_device *mdev = v4l2_dev->mdev;
 
 	mutex_lock(&videodev_lock);
 	if (WARN_ON(video_device[vdev->minor] != vdev)) {
@@ -194,7 +195,7 @@ static void v4l2_device_release(struct device *cd)
 	mutex_unlock(&videodev_lock);
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
-	if (v4l2_dev->mdev) {
+	if (mdev) {
 		/* Remove interfaces and interface links */
 		media_devnode_remove(vdev->intf_devnode);
 		if (vdev->entity.function != MEDIA_ENT_F_UNKNOWN)
@@ -220,6 +221,11 @@ static void v4l2_device_release(struct device *cd)
 	/* Decrease v4l2_device refcount */
 	if (v4l2_dev)
 		v4l2_device_put(v4l2_dev);
+
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	if (mdev)
+		media_device_put(mdev);
+#endif
 }
 
 static struct class video_class = {
@@ -808,6 +814,7 @@ static int video_register_media_controller(struct video_device *vdev, int type)
 
 	/* FIXME: how to create the other interface links? */
 
+	media_device_get(vdev->v4l2_dev->mdev);
 #endif
 	return 0;
 }
-- 
2.1.4

