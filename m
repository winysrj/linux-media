Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40476 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752155AbcGNWfZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 18:35:25 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [RFC 07/16] media-device: struct media_device requires struct device
Date: Fri, 15 Jul 2016 01:35:02 +0300
Message-Id: <1468535711-13836-8-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media device always has a device around. Require one as an argument
for media_device_alloc().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 13 +++++++++++--
 include/media/media-device.h |  4 +++-
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 1bab2c6..1eadf02 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -701,15 +701,23 @@ void media_device_init(struct media_device *mdev)
 }
 EXPORT_SYMBOL_GPL(media_device_init);
 
-struct media_device *media_device_alloc(void)
+struct media_device *media_device_alloc(struct device *dev)
 {
 	struct media_device *mdev;
 
+	dev = get_device(dev);
+	if (!dev)
+		return NULL;
+
 	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
-	if (!mdev)
+	if (!mdev) {
+		put_device(dev);
 		return NULL;
+	}
 
 	media_devnode_init(&mdev->devnode);
+
+	mdev->dev = dev;
 	media_device_init(mdev);
 
 	return mdev;
@@ -722,6 +730,7 @@ void media_device_cleanup(struct media_device *mdev)
 	mdev->entity_internal_idx_max = 0;
 	media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
 	mutex_destroy(&mdev->graph_mutex);
+	put_device(mdev->dev);
 }
 EXPORT_SYMBOL_GPL(media_device_cleanup);
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index cb5722b..5bf97e5 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -430,6 +430,8 @@ void media_device_init(struct media_device *mdev);
 /**
  * media_device_alloc() - Allocate and initialise a media device
  *
+ * @dev:	The associated struct device pointer
+ *
  * Allocate and initialise a media device. Returns a media device.
  * The media device is refcounted, and this function returns a media
  * device the refcount of which is one (1).
@@ -437,7 +439,7 @@ void media_device_init(struct media_device *mdev);
  * References are taken and given using media_device_get() and
  * media_device_put().
  */
-struct media_device *media_device_alloc(void);
+struct media_device *media_device_alloc(struct device *dev);
 
 /**
  * media_device_get() - Get a reference to a media device
-- 
2.1.4

