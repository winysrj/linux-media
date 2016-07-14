Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40480 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752149AbcGNWfZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 18:35:25 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [RFC 09/16] media: Add release callback for media device
Date: Fri, 15 Jul 2016 01:35:04 +0300
Message-Id: <1468535711-13836-10-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The release callback may be used by the driver to signal the release of
the media device. This makes it possible to embed a driver private struct
to the same memory allocation.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 11 ++++++++++-
 include/media/media-device.h |  8 +++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index eae57c6..7538572 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -553,6 +553,9 @@ static void media_device_release(struct media_devnode *devnode)
 	mutex_destroy(&mdev->graph_mutex);
 	dev_dbg(devnode->parent, "Media device released\n");
 
+	if (mdev->release)
+		mdev->release(mdev);
+
 	if (devnode->use_kref)
 		kfree(mdev);
 }
@@ -701,10 +704,16 @@ void media_device_init(struct media_device *mdev)
 }
 EXPORT_SYMBOL_GPL(media_device_init);
 
-struct media_device *media_device_alloc(struct device *dev, void *priv)
+struct media_device *media_device_alloc(struct device *dev, void *priv,
+					size_t size)
 {
 	struct media_device *mdev;
 
+	if (!size)
+		size = sizeof(*mdev);
+	else if (WARN_ON(size < sizeof(*mdev)))
+		return NULL;
+
 	dev = get_device(dev);
 	if (!dev)
 		return NULL;
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 8582e23..34671e1 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -383,6 +383,7 @@ struct media_device {
 
 	int (*link_notify)(struct media_link *link, u32 flags,
 			   unsigned int notification);
+	void (*release)(struct media_device *mdev);
 };
 
 /* We don't need to include pci.h or usb.h here */
@@ -434,15 +435,20 @@ void media_device_init(struct media_device *mdev);
  *
  * @dev:	The associated struct device pointer
  * @priv:	pointer to a driver private data structure
+ * @size:	size of a driver structure containing the media device
  *
  * Allocate and initialise a media device. Returns a media device.
  * The media device is refcounted, and this function returns a media
  * device the refcount of which is one (1).
  *
+ * The size parameter can be zero if the media_device is not embedded
+ * in another struct.
+ *
  * References are taken and given using media_device_get() and
  * media_device_put().
  */
-struct media_device *media_device_alloc(struct device *dev, void *priv);
+struct media_device *media_device_alloc(struct device *dev, void *priv,
+					size_t size);
 
 /**
  * media_device_get() - Get a reference to a media device
-- 
2.1.4

