Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54120 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754701AbcHZXoq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Aug 2016 19:44:46 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v3 09/21] media: Split initialising and adding media devnode
Date: Sat, 27 Aug 2016 02:43:17 +0300
Message-Id: <1472255009-28719-10-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As registering a device node of an entity belonging to a media device
will require a reference to the struct device. Taking that reference is
only possible once the device has been initialised, which took place only
when it was registered. Split this in two, and initialise the device when
the media device is allocated.

Don't distribute the effects of these changes yet. Add media_device_get()
and media_device_put() first.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c  | 18 +++++++++++++-----
 drivers/media/media-devnode.c | 17 +++++++++++------
 include/media/media-devnode.h | 19 ++++++++++++++-----
 3 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 6eca50c..9765031 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -722,19 +722,26 @@ int __must_check __media_device_register(struct media_device *mdev,
 	/* Set version 0 to indicate user-space that the graph is static */
 	mdev->topology_version = 0;
 
+	media_devnode_init(&mdev->devnode);
+
 	ret = media_devnode_register(&mdev->devnode, owner);
 	if (ret < 0)
-		return ret;
+		goto out_put;
 
 	ret = device_create_file(&mdev->devnode.dev, &dev_attr_model);
-	if (ret < 0) {
-		media_devnode_unregister(&mdev->devnode);
-		return ret;
-	}
+	if (ret < 0)
+		goto out_unregister;
 
 	dev_dbg(mdev->dev, "Media device registered\n");
 
 	return 0;
+
+out_unregister:
+	media_devnode_unregister(&mdev->devnode);
+out_put:
+	put_device(&mdev->devnode.dev);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(__media_device_register);
 
@@ -805,6 +812,7 @@ void media_device_unregister(struct media_device *mdev)
 	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
 	dev_dbg(mdev->dev, "Media device unregistering\n");
 	media_devnode_unregister(&mdev->devnode);
+	put_device(&mdev->devnode.dev);
 }
 EXPORT_SYMBOL_GPL(media_device_unregister);
 
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index a8302fc..178d692 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -216,6 +216,11 @@ static const struct file_operations media_devnode_fops = {
 	.llseek = no_llseek,
 };
 
+void media_devnode_init(struct media_devnode *devnode)
+{
+	device_initialize(&devnode->dev);
+}
+
 int __must_check media_devnode_register(struct media_devnode *devnode,
 					struct module *owner)
 {
@@ -254,7 +259,7 @@ int __must_check media_devnode_register(struct media_devnode *devnode,
 	if (devnode->parent)
 		devnode->dev.parent = devnode->parent;
 	dev_set_name(&devnode->dev, "media%d", devnode->minor);
-	ret = device_register(&devnode->dev);
+	ret = device_add(&devnode->dev);
 	if (ret < 0) {
 		pr_err("%s: device_register failed\n", __func__);
 		goto error;
@@ -284,13 +289,13 @@ void media_devnode_unregister(struct media_devnode *devnode)
 	clear_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
 	mutex_unlock(&media_devnode_lock);
 	cdev_del(&devnode->cdev);
-	device_unregister(&devnode->dev);
+	device_del(&devnode->dev);
 }
 
 /*
  *	Initialise media for linux
  */
-static int __init media_devnode_init(void)
+static int __init media_devnode_module_init(void)
 {
 	int ret;
 
@@ -312,14 +317,14 @@ static int __init media_devnode_init(void)
 	return 0;
 }
 
-static void __exit media_devnode_exit(void)
+static void __exit media_devnode_module_exit(void)
 {
 	bus_unregister(&media_bus_type);
 	unregister_chrdev_region(media_dev_t, MEDIA_NUM_DEVICES);
 }
 
-subsys_initcall(media_devnode_init);
-module_exit(media_devnode_exit)
+subsys_initcall(media_devnode_module_init);
+module_exit(media_devnode_module_exit)
 
 MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
 MODULE_DESCRIPTION("Device node registration for media drivers");
diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
index a0f6823..68f4b2f 100644
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -102,6 +102,17 @@ struct media_devnode {
 #define to_media_devnode(cd) container_of(cd, struct media_devnode, dev)
 
 /**
+ * media_devnode_init - initialise a media devnode
+ *
+ * @devnode: struct media_devnode we want to initialise
+ *
+ * Initialise a media devnode. Note that after initialising the media
+ * devnode is refcounted. Releasing references to it may be done using
+ * put_device().
+ */
+void media_devnode_init(struct media_devnode *devnode);
+
+/**
  * media_devnode_register - register a media device node
  *
  * @devnode: struct media_devnode we want to register a device node
@@ -111,11 +122,9 @@ struct media_devnode {
  * with the kernel. An error is returned if no free minor number can be found,
  * or if the registration of the device node fails.
  *
- * Zero is returned on success.
- *
- * Note that if the media_devnode_register call fails, the release() callback of
- * the media_devnode structure is *not* called, so the caller is responsible for
- * freeing any data.
+ * Zero is returned on success. Note that in case
+ * media_devnode_register() fails, the caller is responsible for
+ * releasing the reference to the device using put_device().
  */
 int __must_check media_devnode_register(struct media_devnode *devnode,
 					struct module *owner);
-- 
2.1.4

