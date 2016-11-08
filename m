Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35262 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751100AbcKHNzh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Nov 2016 08:55:37 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v4 17/21] v4l: Acquire a reference to the media device for every video device
Date: Tue,  8 Nov 2016 15:55:26 +0200
Message-Id: <1478613330-24691-17-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk>
 <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video device depends on the existence of its media device --- if there
is one. Acquire a reference to it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-dev.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 8be561a..530d53e 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -171,6 +171,9 @@ static void v4l2_device_release(struct device *cd)
 {
 	struct video_device *vdev = to_video_device(cd);
 	struct v4l2_device *v4l2_dev = vdev->v4l2_dev;
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *mdev = v4l2_dev->mdev;
+#endif
 
 	mutex_lock(&videodev_lock);
 	if (WARN_ON(video_device[vdev->minor] != vdev)) {
@@ -193,8 +196,8 @@ static void v4l2_device_release(struct device *cd)
 
 	mutex_unlock(&videodev_lock);
 
-#if defined(CONFIG_MEDIA_CONTROLLER)
-	if (v4l2_dev->mdev) {
+#ifdef CONFIG_MEDIA_CONTROLLER
+	if (mdev) {
 		/* Remove interfaces and interface links */
 		media_devnode_remove(vdev->intf_devnode);
 		if (vdev->entity.function != MEDIA_ENT_F_UNKNOWN)
@@ -220,6 +223,11 @@ static void v4l2_device_release(struct device *cd)
 	/* Decrease v4l2_device refcount */
 	if (v4l2_dev)
 		v4l2_device_put(v4l2_dev);
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+	if (mdev)
+		media_device_put(mdev);
+#endif
 }
 
 static struct class video_class = {
@@ -813,6 +821,7 @@ static int video_register_media_controller(struct video_device *vdev, int type)
 
 	/* FIXME: how to create the other interface links? */
 
+	media_device_get(vdev->v4l2_dev->mdev);
 #endif
 	return 0;
 }
-- 
2.1.4

