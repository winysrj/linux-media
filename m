Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:37851 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbcD2Whg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 18:37:36 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, lars@metafoo.de
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: fix use-after-free in cdev_put() when app exits after driver unbind
Date: Fri, 29 Apr 2016 16:37:32 -0600
Message-Id: <1461969452-9276-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When driver unbinds while media_ioctl is in progress, cdev_put() fails with
when app exits after driver unbinds.

Add a kobject to the media_devnode structure and set this kobject as the
cdev parent kobject. This allows cdev_add() to hold a reference to it and
release the reference in cdev_del() ensuring that the media_devnode is not
deallocated as long as the application has the cdev open.

This problem is found on uvcvideo, em28xx, and au0828 drivers and fix has
been tested on all three.

cdev_put() error as follows:

kernel: [  193.599736] BUG: KASAN: use-after-free in cdev_put+0x4e/0x50 at addr ffff8801d31af2b8
kernel: [  193.599745] Read of size 8 by task media_device_te/1851

kernel: [  193.599792] INFO: Allocated in __media_device_register+0x54/0x2e0 [media] age=38615 cpu=0 pid=313

kernel: [  193.599951] INFO: Freed in media_devnode_release+0xa4/0xc0 [media] age=0 cpu=0 pid=1851

kernel: [  193.601083] Call Trace:
kernel: [  193.601093]  [<ffffffff81aecac3>] dump_stack+0x67/0x94
kernel: [  193.601102]  [<ffffffff815359b2>] print_trailer+0x112/0x1a0
kernel: [  193.601111]  [<ffffffff8153b5e4>] object_err+0x34/0x40
kernel: [  193.601119]  [<ffffffff8153d9d4>] kasan_report_error+0x224/0x530
kernel: [  193.601128]  [<ffffffff814a2c3d>] ? kzfree+0x2d/0x40
kernel: [  193.601137]  [<ffffffff81539d72>] ? kfree+0x1d2/0x1f0
kernel: [  193.601145]  [<ffffffff8153de13>] __asan_report_load8_noabort+0x43/0x50
kernel: [  193.601154]  [<ffffffff8157ca7e>] ? cdev_put+0x4e/0x50
kernel: [  193.601162]  [<ffffffff8157ca7e>] cdev_put+0x4e/0x50
kernel: [  193.601170]  [<ffffffff815767eb>] __fput+0x52b/0x6c0
kernel: [  193.601179]  [<ffffffff8117743a>] ? switch_task_namespaces+0x2a/0x90
kernel: [  193.601188]  [<ffffffff815769ee>] ____fput+0xe/0x10
kernel: [  193.601196]  [<ffffffff81170023>] task_work_run+0x133/0x1f0
kernel: [  193.601204]  [<ffffffff8117746e>] ? switch_task_namespaces+0x5e/0x90
anduin kernel: [  193.601213]  [<ffffffff8111b50c>] do_exit+0x72c/0x2c20
anduin kernel: [  193.601224]  [<ffffffff8111ade0>] ? release_task+0x1250/0x1250
-
-
-
kernel: [  193.601360]  [<ffffffff81003587>] ? exit_to_usermode_loop+0xe7/0x170
kernel: [  193.601368]  [<ffffffff810035c0>] exit_to_usermode_loop+0x120/0x170
kernel: [  193.601376]  [<ffffffff810061da>] syscall_return_slowpath+0x16a/0x1a0
kernel: [  193.601386]  [<ffffffff82848b33>] entry_SYSCALL_64_fastpath+0xa6/0xa8

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-device.c  |  6 ++++--
 drivers/media/media-devnode.c | 21 +++++++++++++++++++--
 include/media/media-devnode.h |  2 ++
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 84e6a0b..b388a0e 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -742,16 +742,16 @@ int __must_check __media_device_register(struct media_device *mdev,
 
 	ret = media_devnode_register(mdev, devnode, owner);
 	if (ret < 0) {
+		/* kfree devnode is done via kobject_put() handler */
 		mdev->devnode = NULL;
-		kfree(devnode);
 		return ret;
 	}
 
 	ret = device_create_file(&devnode->dev, &dev_attr_model);
 	if (ret < 0) {
+		/* kfree devnode is done via kobject_put() handler */
 		mdev->devnode = NULL;
 		media_devnode_unregister(devnode);
-		kfree(devnode);
 		return ret;
 	}
 
@@ -829,6 +829,8 @@ void media_device_unregister(struct media_device *mdev)
 	if (media_devnode_is_registered(mdev->devnode)) {
 		device_remove_file(&mdev->devnode->dev, &dev_attr_model);
 		media_devnode_unregister(mdev->devnode);
+		/* kfree devnode is done via kobject_put() handler */
+		mdev->devnode = NULL;
 	}
 
 	dev_dbg(mdev->dev, "Media device unregistered\n");
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index ca7c4b9..21f81f3 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -75,8 +75,6 @@ static void media_devnode_release(struct device *cd)
 	/* Release media_devnode and perform other cleanups as needed. */
 	if (devnode->release)
 		devnode->release(devnode);
-
-	kfree(devnode);
 }
 
 static struct bus_type media_bus_type = {
@@ -221,6 +219,19 @@ static const struct file_operations media_devnode_fops = {
 	.llseek = no_llseek,
 };
 
+static void media_devnode_free(struct kobject *kobj)
+{
+	struct media_devnode *devnode =
+			container_of(kobj, struct media_devnode, kobj);
+
+	kfree(devnode);
+	pr_info("%s: Media Devnode Deallocated\n", __func__);
+}
+
+static struct kobj_type media_devnode_ktype = {
+	.release = media_devnode_free,
+};
+
 int __must_check media_devnode_register(struct media_device *mdev,
 					struct media_devnode *devnode,
 					struct module *owner)
@@ -243,9 +254,12 @@ int __must_check media_devnode_register(struct media_device *mdev,
 	devnode->minor = minor;
 	devnode->media_dev = mdev;
 
+	kobject_init(&devnode->kobj, &media_devnode_ktype);
+
 	/* Part 2: Initialize and register the character device */
 	cdev_init(&devnode->cdev, &media_devnode_fops);
 	devnode->cdev.owner = owner;
+	devnode->cdev.kobj.parent = &devnode->kobj;
 
 	ret = cdev_add(&devnode->cdev, MKDEV(MAJOR(media_dev_t), devnode->minor), 1);
 	if (ret < 0) {
@@ -274,6 +288,7 @@ int __must_check media_devnode_register(struct media_device *mdev,
 error:
 	cdev_del(&devnode->cdev);
 	clear_bit(devnode->minor, media_devnode_nums);
+	kobject_put(&devnode->kobj);
 	return ret;
 }
 
@@ -287,6 +302,8 @@ void media_devnode_unregister(struct media_devnode *devnode)
 	clear_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
 	mutex_unlock(&media_devnode_lock);
 	device_unregister(&devnode->dev);
+	devnode->media_dev = NULL;
+	kobject_put(&devnode->kobj);
 }
 
 /*
diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
index 5bb3b0e..ce9b051 100644
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -72,6 +72,7 @@ struct media_file_operations {
  * @fops:	pointer to struct &media_file_operations with media device ops
  * @dev:	struct device pointer for the media controller device
  * @cdev:	struct cdev pointer character device
+ * @kobj:	struct kobject
  * @parent:	parent device
  * @minor:	device node minor number
  * @flags:	flags, combination of the MEDIA_FLAG_* constants
@@ -91,6 +92,7 @@ struct media_devnode {
 	/* sysfs */
 	struct device dev;		/* media device */
 	struct cdev cdev;		/* character device */
+	struct kobject kobj;		/* set as cdev parent kobj */
 	struct device *parent;		/* device parent */
 
 	/* device info */
-- 
2.5.0

