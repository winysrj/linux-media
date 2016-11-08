Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35312 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752217AbcKHNzh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Nov 2016 08:55:37 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v4 15/21] media: Provide a way to the driver to set a private pointer
Date: Tue,  8 Nov 2016 15:55:24 +0200
Message-Id: <1478613330-24691-15-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk>
 <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the media device can be allocated dynamically, drivers have no
longer a way to conveniently obtain the driver private data structure.
Provide one again in the form of a private pointer passed to the
media_device_alloc() function.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/media-device.c |  3 ++-
 include/media/media-device.h | 15 ++++++++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 648c64c..7d9f76d 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -729,7 +729,7 @@ static void media_device_release(struct media_devnode *devnode)
 	kfree(mdev);
 }
 
-struct media_device *media_device_alloc(struct device *dev)
+struct media_device *media_device_alloc(struct device *dev, void *priv)
 {
 	struct media_device *mdev;
 
@@ -745,6 +745,7 @@ struct media_device *media_device_alloc(struct device *dev)
 
 	mdev->dev = dev;
 	media_device_init(mdev);
+	mdev->priv = priv;
 
 	mdev->devnode.release = media_device_release;
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index ae2bc08..94e96ef 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -62,6 +62,7 @@ struct media_device_ops {
  * struct media_device - Media device
  * @dev:	Parent device
  * @devnode:	Media device node
+ * @priv:	A pointer to driver private data
  * @driver_name: Optional device driver name. If not set, calls to
  *		%MEDIA_IOC_DEVICE_INFO will return ``dev->driver->name``.
  *		This is needed for USB drivers for example, as otherwise
@@ -128,6 +129,7 @@ struct media_device {
 	/* dev->driver_data points to this struct. */
 	struct device *dev;
 	struct media_devnode devnode;
+	void *priv;
 
 	char model[32];
 	char driver_name[32];
@@ -214,6 +216,7 @@ void media_device_init(struct media_device *mdev);
  * media_device_alloc() - Allocate and initialise a media device
  *
  * @dev:	The associated struct device pointer
+ * @priv:	pointer to a driver private data structure
  *
  * Allocate and initialise a media device. Returns a media device.
  * The media device is refcounted, and this function returns a media
@@ -222,7 +225,7 @@ void media_device_init(struct media_device *mdev);
  * References are taken and given using media_device_get() and
  * media_device_put().
  */
-struct media_device *media_device_alloc(struct device *dev);
+struct media_device *media_device_alloc(struct device *dev, void *priv);
 
 /**
  * media_device_get() - Get a reference to a media device
@@ -249,6 +252,16 @@ struct media_device *media_device_alloc(struct device *dev);
 	} while (0)
 
 /**
+ * media_device_priv() - Obtain the driver private pointer
+ *
+ * Returns a pointer passed to the media_device_alloc() function.
+ */
+static inline void *media_device_priv(struct media_device *mdev)
+{
+	return mdev->priv;
+}
+
+/**
  * media_device_cleanup() - Cleanups a media device element
  *
  * @mdev:	pointer to struct &media_device
-- 
2.1.4

