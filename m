Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46816 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754245AbcHSKYG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 06:24:06 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: m.chehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v2 09/17] media-device: struct media_device requires struct device
Date: Fri, 19 Aug 2016 13:23:40 +0300
Message-Id: <1471602228-30722-10-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1471602228-30722-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1471602228-30722-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media device always has a device around. Require one as an argument
for media_device_alloc().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 12 ++++++++++--
 include/media/media-device.h |  4 +++-
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index d527491..6c8b689 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -699,15 +699,22 @@ void media_device_init(struct media_device *mdev)
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
+	mdev->dev = dev;
 	media_device_init(mdev);
 
 	return mdev;
@@ -720,6 +727,7 @@ void media_device_cleanup(struct media_device *mdev)
 	mdev->entity_internal_idx_max = 0;
 	media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
 	mutex_destroy(&mdev->graph_mutex);
+	put_device(mdev->dev);
 }
 EXPORT_SYMBOL_GPL(media_device_cleanup);
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index d1d45ab..8ccc8e8 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -199,6 +199,8 @@ void media_device_init(struct media_device *mdev);
 /**
  * media_device_alloc() - Allocate and initialise a media device
  *
+ * @dev:	The associated struct device pointer
+ *
  * Allocate and initialise a media device. Returns a media device.
  * The media device is refcounted, and this function returns a media
  * device the refcount of which is one (1).
@@ -206,7 +208,7 @@ void media_device_init(struct media_device *mdev);
  * References are taken and given using media_device_get() and
  * media_device_put().
  */
-struct media_device *media_device_alloc(void);
+struct media_device *media_device_alloc(struct device *dev);
 
 /**
  * media_device_get() - Get a reference to a media device
-- 
2.1.4

