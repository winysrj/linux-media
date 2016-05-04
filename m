Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:28966 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbcEDL2m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 07:28:42 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH 2/3] media: Add per-file-handle data support
Date: Wed,  4 May 2016 14:25:32 +0300
Message-Id: <1462361133-23887-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1462361133-23887-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1462361133-23887-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The media devnode core associates devnodes with files by storing the
devnode pointer in the file structure private_data field. In order to
allow tracking of per-file-handle data introduce a new media devnode
file handle structure that stores the devnode pointer, and store a
pointer to that structure in the file private_data field.

Users of the media devnode code (the only existing user being
media_device) are responsible for managing their own subclass of the
media_devnode_fh structure.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/media-device.c  | 21 +++++++++++++++++++++
 drivers/media/media-devnode.c | 21 ++++++++++-----------
 include/media/media-devnode.h | 18 +++++++++++++++++-
 3 files changed, 48 insertions(+), 12 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 898a3cf..89602a7 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -39,6 +39,15 @@
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 
+struct media_device_fh {
+	struct media_devnode_fh fh;
+};
+
+static inline struct media_device_fh *media_device_fh(struct file *filp)
+{
+	return container_of(filp->private_data, struct media_device_fh, fh);
+}
+
 /* -----------------------------------------------------------------------------
  * Userspace API
  */
@@ -50,11 +59,23 @@ static inline void __user *media_get_uptr(__u64 arg)
 
 static int media_device_open(struct file *filp)
 {
+	struct media_device_fh *fh;
+
+	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
+	if (!fh)
+		return -ENOMEM;
+
+	filp->private_data = &fh->fh;
+
 	return 0;
 }
 
 static int media_device_close(struct file *filp)
 {
+	struct media_device_fh *fh = media_device_fh(filp);
+
+	kfree(fh);
+
 	return 0;
 }
 
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 64a4b1e..d4d2917 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -154,6 +154,7 @@ static long media_compat_ioctl(struct file *filp, unsigned int cmd,
 /* Override for the open function */
 static int media_open(struct inode *inode, struct file *filp)
 {
+	struct media_devnode_fh *fh;
 	struct media_devnode *mdev;
 	int ret;
 
@@ -175,17 +176,16 @@ static int media_open(struct inode *inode, struct file *filp)
 	get_device(&mdev->dev);
 	mutex_unlock(&media_devnode_lock);
 
-	filp->private_data = mdev;
-
-	if (mdev->fops->open) {
-		ret = mdev->fops->open(filp);
-		if (ret) {
-			put_device(&mdev->dev);
-			filp->private_data = NULL;
-			return ret;
-		}
+	ret = mdev->fops->open(filp);
+	if (ret) {
+		put_device(&mdev->dev);
+		filp->private_data = NULL;
+		return ret;
 	}
 
+	fh = filp->private_data;
+	fh->devnode = mdev;
+
 	return 0;
 }
 
@@ -194,8 +194,7 @@ static int media_release(struct inode *inode, struct file *filp)
 {
 	struct media_devnode *mdev = media_devnode_data(filp);
 
-	if (mdev->fops->release)
-		mdev->fops->release(filp);
+	mdev->fops->release(filp);
 
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */
diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
index fe42f08..09aafc3 100644
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -66,6 +66,20 @@ struct media_file_operations {
 };
 
 /**
+ * struct media_devnode_fh - Media device node file handle
+ * @devnode:	pointer to the media device node
+ *
+ * This structure serves as a base for per-file-handle data storage. Media
+ * device node users embed media_devnode_fh in their custom file handle data
+ * structures and store the media_devnode_fh in the file private_data in order
+ * to let the media device node core locate the media_devnode corresponding to a
+ * file handle.
+ */
+struct media_devnode_fh {
+	struct media_devnode *devnode;
+};
+
+/**
  * struct media_devnode - Media device node
  * @fops:	pointer to struct &media_file_operations with media device ops
  * @dev:	struct device pointer for the media controller device
@@ -138,7 +152,9 @@ void media_devnode_unregister(struct media_devnode *mdev);
  */
 static inline struct media_devnode *media_devnode_data(struct file *filp)
 {
-	return filp->private_data;
+	struct media_devnode_fh *fh = filp->private_data;
+
+	return fh->devnode;
 }
 
 /**
-- 
1.9.1

