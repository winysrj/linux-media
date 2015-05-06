Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:34791 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753469AbbEFG5t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 May 2015 02:57:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 4/8] media: add major/minor/entity_id to struct media_device_info
Date: Wed,  6 May 2015 08:57:19 +0200
Message-Id: <1430895443-41839-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1430895443-41839-1-git-send-email-hverkuil@xs4all.nl>
References: <1430895443-41839-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Device nodes associated with entities should support the MEDIA_IOC_DEVICE_INFO
ioctl in order to let userspace find the media device node from an entity
device node. To be able to do that the major and minor numbers of the
media device node should be available in struct media_device_info and
the function filling in struct media_device_info should be exported.

In addition it will export the entity_id of said device node (which will be
0 for the media controller device node itself).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/media-device.c  | 29 +++++++++++++++++++----------
 drivers/media/media-devnode.c |  5 +++--
 include/media/media-device.h  |  3 +++
 include/media/media-devnode.h |  1 +
 include/uapi/linux/media.h    |  5 ++++-
 5 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 7b39440..6a6ea68 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -44,21 +44,30 @@ static int media_device_close(struct file *filp)
 	return 0;
 }
 
+void media_device_fill_info(const struct media_device *dev,
+			    struct media_device_info *info)
+{
+	memset(info, 0, sizeof(*info));
+
+	strlcpy(info->driver, dev->dev->driver->name, sizeof(info->driver));
+	strlcpy(info->model, dev->model, sizeof(info->model));
+	strlcpy(info->serial, dev->serial, sizeof(info->serial));
+	strlcpy(info->bus_info, dev->bus_info, sizeof(info->bus_info));
+
+	info->media_version = MEDIA_API_VERSION;
+	info->hw_revision = dev->hw_revision;
+	info->driver_version = dev->driver_version;
+	info->major = dev->devnode.major;
+	info->minor = dev->devnode.minor;
+}
+EXPORT_SYMBOL_GPL(media_device_fill_info);
+
 static int media_device_get_info(struct media_device *dev,
 				 struct media_device_info __user *__info)
 {
 	struct media_device_info info;
 
-	memset(&info, 0, sizeof(info));
-
-	strlcpy(info.driver, dev->dev->driver->name, sizeof(info.driver));
-	strlcpy(info.model, dev->model, sizeof(info.model));
-	strlcpy(info.serial, dev->serial, sizeof(info.serial));
-	strlcpy(info.bus_info, dev->bus_info, sizeof(info.bus_info));
-
-	info.media_version = MEDIA_API_VERSION;
-	info.hw_revision = dev->hw_revision;
-	info.driver_version = dev->driver_version;
+	media_device_fill_info(dev, &info);
 
 	if (copy_to_user(__info, &info, sizeof(*__info)))
 		return -EFAULT;
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index ebf9626..aaf7e59 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -249,13 +249,14 @@ int __must_check media_devnode_register(struct media_devnode *mdev,
 	set_bit(minor, media_devnode_nums);
 	mutex_unlock(&media_devnode_lock);
 
+	mdev->major = MAJOR(media_dev_t);
 	mdev->minor = minor;
 
 	/* Part 2: Initialize and register the character device */
 	cdev_init(&mdev->cdev, &media_devnode_fops);
 	mdev->cdev.owner = owner;
 
-	ret = cdev_add(&mdev->cdev, MKDEV(MAJOR(media_dev_t), mdev->minor), 1);
+	ret = cdev_add(&mdev->cdev, MKDEV(mdev->major, mdev->minor), 1);
 	if (ret < 0) {
 		pr_err("%s: cdev_add failed\n", __func__);
 		goto error;
@@ -263,7 +264,7 @@ int __must_check media_devnode_register(struct media_devnode *mdev,
 
 	/* Part 3: Register the media device */
 	mdev->dev.bus = &media_bus_type;
-	mdev->dev.devt = MKDEV(MAJOR(media_dev_t), mdev->minor);
+	mdev->dev.devt = MKDEV(mdev->major, mdev->minor);
 	mdev->dev.release = media_devnode_release;
 	if (mdev->parent)
 		mdev->dev.parent = mdev->parent;
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 6e6db78..99f8ec7 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -96,6 +96,9 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 					      struct media_entity *entity);
 void media_device_unregister_entity(struct media_entity *entity);
 
+void media_device_fill_info(const struct media_device *dev,
+			    struct media_device_info *__info);
+
 /* Iterate over all entities. */
 #define media_device_for_each_entity(entity, mdev)			\
 	list_for_each_entry(entity, &(mdev)->entities, list)
diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
index 0dc7060..f3ba663 100644
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -72,6 +72,7 @@ struct media_devnode {
 	struct device *parent;		/* device parent */
 
 	/* device info */
+	int major;
 	int minor;
 	unsigned long flags;		/* Use bitops to access flags */
 
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 4e816be..7e1d8d0 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -37,7 +37,10 @@ struct media_device_info {
 	__u32 media_version;
 	__u32 hw_revision;
 	__u32 driver_version;
-	__u32 reserved[31];
+	__u32 major;
+	__u32 minor;
+	__u32 entity_id;
+	__u32 reserved[28];
 };
 
 #define MEDIA_ENT_ID_FLAG_NEXT		(1 << 31)
-- 
2.1.4

