Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44651 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291AbbLQIlC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 03:41:02 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH/RFC 22/48] media: Add per-file-handle data support
Date: Thu, 17 Dec 2015 10:40:00 +0200
Message-Id: <1450341626-6695-23-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
 drivers/media/media-device.c  | 22 ++++++++++++++++++++++
 drivers/media/media-devnode.c | 19 +++++++++----------
 include/media/media-devnode.h | 18 +++++++++++++++++-
 3 files changed, 48 insertions(+), 11 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 7b39440192d6..285f7d79d848 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -24,23 +24,45 @@
 #include <linux/export.h>
 #include <linux/ioctl.h>
 #include <linux/media.h>
+#include <linux/slab.h>
 #include <linux/types.h>
 
 #include <media/media-device.h>
 #include <media/media-devnode.h>
 #include <media/media-entity.h>
 
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
 
 static int media_device_open(struct file *filp)
 {
+	struct media_device_fh *fh;
+
+	fh = kzalloc(sizeof(*media_device_fh), GFP_KERNEL);
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
index ebf9626e5ae5..67bac29838d3 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -154,6 +154,7 @@ static long media_compat_ioctl(struct file *filp, unsigned int cmd,
 /* Override for the open function */
 static int media_open(struct inode *inode, struct file *filp)
 {
+	struct media_devnode_fh *fh;
 	struct media_devnode *mdev;
 	int ret;
 
@@ -175,16 +176,15 @@ static int media_open(struct inode *inode, struct file *filp)
 	get_device(&mdev->dev);
 	mutex_unlock(&media_devnode_lock);
 
-	filp->private_data = mdev;
-
-	if (mdev->fops->open) {
-		ret = mdev->fops->open(filp);
-		if (ret) {
-			put_device(&mdev->dev);
-			return ret;
-		}
+	ret = mdev->fops->open(filp);
+	if (ret) {
+		put_device(&mdev->dev);
+		return ret;
 	}
 
+	fh = filp->private_data;
+	fh->devnode = mdev;
+
 	return 0;
 }
 
@@ -193,8 +193,7 @@ static int media_release(struct inode *inode, struct file *filp)
 {
 	struct media_devnode *mdev = media_devnode_data(filp);
 
-	if (mdev->fops->release)
-		mdev->fops->release(filp);
+	mdev->fops->release(filp);
 
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */
diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
index 17ddae32060d..ce81047cb4fc 100644
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -52,6 +52,20 @@ struct media_file_operations {
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
  * @fops:	pointer to struct media_file_operations with media device ops
  * @dev:	struct device pointer for the media controller device
@@ -92,7 +106,9 @@ void media_devnode_unregister(struct media_devnode *mdev);
 
 static inline struct media_devnode *media_devnode_data(struct file *filp)
 {
-	return filp->private_data;
+	struct media_devnode_fh *fh = filp->private_data;
+
+	return fh->devnode;
 }
 
 static inline int media_devnode_is_registered(struct media_devnode *mdev)
-- 
2.4.10

