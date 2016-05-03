Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:41343 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbcECSCU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2016 14:02:20 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, lars@metafoo.de
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] media: fix use-after-free in cdev_put() when app exits after driver unbind
Date: Tue,  3 May 2016 12:02:09 -0600
Message-Id: <1462298529-6270-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When driver unbinds while media_ioctl is in progress, cdev_put() fails with
when app exits after driver unbinds.

Add devnode struct device kobj as the cdev parent kobject. cdev_add() holds
a reference to it and releases the reference in cdev_del() ensuring that the
media_devnode is not deallocated as long as the application has the device
file open. media_devnode_register() now initializes the struct device kobj
before calling cdev_add(). media_devnode_unregister() does cdev_del() and
then deletes the device. devnode is released when the last reference to the
struct device is gone.

This problem is found on uvcvideo, em28xx, and au0828 drivers and fix has
been tested on all three.

kernel: [  193.599736] BUG: KASAN: use-after-free in cdev_put+0x4e/0x50
kernel: [  193.599745] Read of size 8 by task media_device_te/1851
kernel: [  193.599792] INFO: Allocated in __media_device_register+0x54
kernel: [  193.599951] INFO: Freed in media_devnode_release+0xa4/0xc0

kernel: [  193.601083] Call Trace:
kernel: [  193.601093]  [<ffffffff81aecac3>] dump_stack+0x67/0x94
kernel: [  193.601102]  [<ffffffff815359b2>] print_trailer+0x112/0x1a0
kernel: [  193.601111]  [<ffffffff8153b5e4>] object_err+0x34/0x40
kernel: [  193.601119]  [<ffffffff8153d9d4>] kasan_report_error+0x224/0x530
kernel: [  193.601128]  [<ffffffff814a2c3d>] ? kzfree+0x2d/0x40
kernel: [  193.601137]  [<ffffffff81539d72>] ? kfree+0x1d2/0x1f0
kernel: [  193.601154]  [<ffffffff8157ca7e>] ? cdev_put+0x4e/0x50
kernel: [  193.601162]  [<ffffffff8157ca7e>] cdev_put+0x4e/0x50
kernel: [  193.601170]  [<ffffffff815767eb>] __fput+0x52b/0x6c0
kernel: [  193.601179]  [<ffffffff8117743a>] ? switch_task_namespaces+0x2a
kernel: [  193.601188]  [<ffffffff815769ee>] ____fput+0xe/0x10
kernel: [  193.601196]  [<ffffffff81170023>] task_work_run+0x133/0x1f0
kernel: [  193.601204]  [<ffffffff8117746e>] ? switch_task_namespaces+0x5e
kernel: [  193.601213]  [<ffffffff8111b50c>] do_exit+0x72c/0x2c20
kernel: [  193.601224]  [<ffffffff8111ade0>] ? release_task+0x1250/0x1250
-
-
-
kernel: [  193.601360]  [<ffffffff81003587>] ? exit_to_usermode_loop+0xe7
kernel: [  193.601368]  [<ffffffff810035c0>] exit_to_usermode_loop+0x120
kernel: [  193.601376]  [<ffffffff810061da>] syscall_return_slowpath+0x16a
kernel: [  193.601386]  [<ffffffff82848b33>] entry_SYSCALL_64_fastpath+0xa6

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---

Changes since v1:
- Addressed review comments from Lars-Peter Clausen

 drivers/media/media-device.c  |  6 ++++--
 drivers/media/media-devnode.c | 45 ++++++++++++++++++++++++++-----------------
 2 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 84e6a0b..a853384 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -742,16 +742,16 @@ int __must_check __media_device_register(struct media_device *mdev,
 
 	ret = media_devnode_register(mdev, devnode, owner);
 	if (ret < 0) {
+		/* devnode free is handled in media_devnode_*() */
 		mdev->devnode = NULL;
-		kfree(devnode);
 		return ret;
 	}
 
 	ret = device_create_file(&devnode->dev, &dev_attr_model);
 	if (ret < 0) {
+		/* devnode free is handled in media_devnode_*() */
 		mdev->devnode = NULL;
 		media_devnode_unregister(devnode);
-		kfree(devnode);
 		return ret;
 	}
 
@@ -829,6 +829,8 @@ void media_device_unregister(struct media_device *mdev)
 	if (media_devnode_is_registered(mdev->devnode)) {
 		device_remove_file(&mdev->devnode->dev, &dev_attr_model);
 		media_devnode_unregister(mdev->devnode);
+		/* devnode free is handled in media_devnode_*() */
+		mdev->devnode = NULL;
 	}
 
 	dev_dbg(mdev->dev, "Media device unregistered\n");
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index ca7c4b9..9b5bd2e 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -63,13 +63,8 @@ static void media_devnode_release(struct device *cd)
 	struct media_devnode *devnode = to_media_devnode(cd);
 
 	mutex_lock(&media_devnode_lock);
-
-	/* Delete the cdev on this minor as well */
-	cdev_del(&devnode->cdev);
-
 	/* Mark device node number as free */
 	clear_bit(devnode->minor, media_devnode_nums);
-
 	mutex_unlock(&media_devnode_lock);
 
 	/* Release media_devnode and perform other cleanups as needed. */
@@ -77,6 +72,7 @@ static void media_devnode_release(struct device *cd)
 		devnode->release(devnode);
 
 	kfree(devnode);
+	pr_info("%s: Media Devnode Deallocated\n", __func__);
 }
 
 static struct bus_type media_bus_type = {
@@ -204,6 +200,7 @@ static int media_release(struct inode *inode, struct file *filp)
 	   return value is ignored. */
 	put_device(&devnode->dev);
 	filp->private_data = NULL;
+	pr_info("%s: Media Release\n", __func__);
 	return 0;
 }
 
@@ -234,6 +231,7 @@ int __must_check media_devnode_register(struct media_device *mdev,
 	if (minor == MEDIA_NUM_DEVICES) {
 		mutex_unlock(&media_devnode_lock);
 		pr_err("could not get a free minor\n");
+		kfree(devnode);
 		return -ENFILE;
 	}
 
@@ -243,27 +241,31 @@ int __must_check media_devnode_register(struct media_device *mdev,
 	devnode->minor = minor;
 	devnode->media_dev = mdev;
 
+	/* Part 1: Initialize dev now to use dev.kobj for cdev.kobj.parent */
+	devnode->dev.bus = &media_bus_type;
+	devnode->dev.devt = MKDEV(MAJOR(media_dev_t), devnode->minor);
+	devnode->dev.release = media_devnode_release;
+	if (devnode->parent)
+		devnode->dev.parent = devnode->parent;
+	dev_set_name(&devnode->dev, "media%d", devnode->minor);
+	device_initialize(&devnode->dev);
+
 	/* Part 2: Initialize and register the character device */
 	cdev_init(&devnode->cdev, &media_devnode_fops);
 	devnode->cdev.owner = owner;
+	devnode->cdev.kobj.parent = &devnode->dev.kobj;
 
 	ret = cdev_add(&devnode->cdev, MKDEV(MAJOR(media_dev_t), devnode->minor), 1);
 	if (ret < 0) {
 		pr_err("%s: cdev_add failed\n", __func__);
-		goto error;
+		goto cdev_add_error;
 	}
 
-	/* Part 3: Register the media device */
-	devnode->dev.bus = &media_bus_type;
-	devnode->dev.devt = MKDEV(MAJOR(media_dev_t), devnode->minor);
-	devnode->dev.release = media_devnode_release;
-	if (devnode->parent)
-		devnode->dev.parent = devnode->parent;
-	dev_set_name(&devnode->dev, "media%d", devnode->minor);
-	ret = device_register(&devnode->dev);
+	/* Part 3: Add the media device */
+	ret = device_add(&devnode->dev);
 	if (ret < 0) {
-		pr_err("%s: device_register failed\n", __func__);
-		goto error;
+		pr_err("%s: device_add failed\n", __func__);
+		goto device_add_error;
 	}
 
 	/* Part 4: Activate this minor. The char device can now be used. */
@@ -271,9 +273,12 @@ int __must_check media_devnode_register(struct media_device *mdev,
 
 	return 0;
 
-error:
+device_add_error:
 	cdev_del(&devnode->cdev);
+cdev_add_error:
 	clear_bit(devnode->minor, media_devnode_nums);
+	devnode->media_dev = NULL;
+	put_device(&devnode->dev);
 	return ret;
 }
 
@@ -285,8 +290,12 @@ void media_devnode_unregister(struct media_devnode *devnode)
 
 	mutex_lock(&media_devnode_lock);
 	clear_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
+	/* Delete the cdev on this minor as well */
+	cdev_del(&devnode->cdev);
 	mutex_unlock(&media_devnode_lock);
-	device_unregister(&devnode->dev);
+	device_del(&devnode->dev);
+	devnode->media_dev = NULL;
+	put_device(&devnode->dev);
 }
 
 /*
-- 
2.7.4

