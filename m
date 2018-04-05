Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:60898 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751195AbeDEKeo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 06:34:44 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH] media: v4l2-dev: use pr_foo() for printing messages
Date: Thu,  5 Apr 2018 07:34:39 -0300
Message-Id: <3cead57d0a484bf589f4da3b86f4470cde6a1480.1522924475.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using printk() directly, use the pr_foo()
macros.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/v4l2-dev.c | 45 ++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 1d0b2208e8fb..530db8e482fb 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -16,6 +16,8 @@
  *		- Added procfs support
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -34,6 +36,12 @@
 #define VIDEO_NUM_DEVICES	256
 #define VIDEO_NAME              "video4linux"
 
+#define dprintk(fmt, arg...) do {					\
+		printk(KERN_DEBUG pr_fmt("%s: " fmt),			\
+		       __func__, ##arg);				\
+} while (0)
+
+
 /*
  *	sysfs stuff
  */
@@ -309,7 +317,7 @@ static ssize_t v4l2_read(struct file *filp, char __user *buf,
 		ret = vdev->fops->read(filp, buf, sz, off);
 	if ((vdev->dev_debug & V4L2_DEV_DEBUG_FOP) &&
 	    (vdev->dev_debug & V4L2_DEV_DEBUG_STREAMING))
-		printk(KERN_DEBUG "%s: read: %zd (%d)\n",
+		dprintk("%s: read: %zd (%d)\n",
 			video_device_node_name(vdev), sz, ret);
 	return ret;
 }
@@ -326,7 +334,7 @@ static ssize_t v4l2_write(struct file *filp, const char __user *buf,
 		ret = vdev->fops->write(filp, buf, sz, off);
 	if ((vdev->dev_debug & V4L2_DEV_DEBUG_FOP) &&
 	    (vdev->dev_debug & V4L2_DEV_DEBUG_STREAMING))
-		printk(KERN_DEBUG "%s: write: %zd (%d)\n",
+		dprintk("%s: write: %zd (%d)\n",
 			video_device_node_name(vdev), sz, ret);
 	return ret;
 }
@@ -341,7 +349,7 @@ static __poll_t v4l2_poll(struct file *filp, struct poll_table_struct *poll)
 	if (video_is_registered(vdev))
 		res = vdev->fops->poll(filp, poll);
 	if (vdev->dev_debug & V4L2_DEV_DEBUG_POLL)
-		printk(KERN_DEBUG "%s: poll: %08x\n",
+		dprintk("%s: poll: %08x\n",
 			video_device_node_name(vdev), res);
 	return res;
 }
@@ -382,7 +390,7 @@ static unsigned long v4l2_get_unmapped_area(struct file *filp,
 		return -ENODEV;
 	ret = vdev->fops->get_unmapped_area(filp, addr, len, pgoff, flags);
 	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
-		printk(KERN_DEBUG "%s: get_unmapped_area (%d)\n",
+		dprintk("%s: get_unmapped_area (%d)\n",
 			video_device_node_name(vdev), ret);
 	return ret;
 }
@@ -398,7 +406,7 @@ static int v4l2_mmap(struct file *filp, struct vm_area_struct *vm)
 	if (video_is_registered(vdev))
 		ret = vdev->fops->mmap(filp, vm);
 	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
-		printk(KERN_DEBUG "%s: mmap (%d)\n",
+		dprintk("%s: mmap (%d)\n",
 			video_device_node_name(vdev), ret);
 	return ret;
 }
@@ -428,7 +436,7 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 	}
 
 	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
-		printk(KERN_DEBUG "%s: open (%d)\n",
+		dprintk("%s: open (%d)\n",
 			video_device_node_name(vdev), ret);
 	/* decrease the refcount in case of an error */
 	if (ret)
@@ -445,7 +453,7 @@ static int v4l2_release(struct inode *inode, struct file *filp)
 	if (vdev->fops->release)
 		ret = vdev->fops->release(filp);
 	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
-		printk(KERN_DEBUG "%s: release\n",
+		dprintk("%s: release\n",
 			video_device_node_name(vdev));
 
 	/* decrease the refcount unconditionally since the release()
@@ -786,8 +794,7 @@ static int video_register_media_controller(struct video_device *vdev, int type)
 		ret = media_device_register_entity(vdev->v4l2_dev->mdev,
 						   &vdev->entity);
 		if (ret < 0) {
-			printk(KERN_WARNING
-				"%s: media_device_register_entity failed\n",
+			pr_warn("%s: media_device_register_entity failed\n",
 				__func__);
 			return ret;
 		}
@@ -869,7 +876,7 @@ int __video_register_device(struct video_device *vdev,
 		name_base = "v4l-touch";
 		break;
 	default:
-		printk(KERN_ERR "%s called with unknown type: %d\n",
+		pr_err("%s called with unknown type: %d\n",
 		       __func__, type);
 		return -EINVAL;
 	}
@@ -918,7 +925,7 @@ int __video_register_device(struct video_device *vdev,
 	if (nr == minor_cnt)
 		nr = devnode_find(vdev, 0, minor_cnt);
 	if (nr == minor_cnt) {
-		printk(KERN_ERR "could not get a free device node number\n");
+		pr_err("could not get a free device node number\n");
 		mutex_unlock(&videodev_lock);
 		return -ENFILE;
 	}
@@ -933,7 +940,7 @@ int __video_register_device(struct video_device *vdev,
 			break;
 	if (i == VIDEO_NUM_DEVICES) {
 		mutex_unlock(&videodev_lock);
-		printk(KERN_ERR "could not get a free minor\n");
+		pr_err("could not get a free minor\n");
 		return -ENFILE;
 	}
 #endif
@@ -943,7 +950,7 @@ int __video_register_device(struct video_device *vdev,
 	/* Should not happen since we thought this minor was free */
 	if (WARN_ON(video_device[vdev->minor])) {
 		mutex_unlock(&videodev_lock);
-		printk(KERN_ERR "video_device not empty!\n");
+		pr_err("video_device not empty!\n");
 		return -ENFILE;
 	}
 	devnode_set(vdev);
@@ -964,7 +971,7 @@ int __video_register_device(struct video_device *vdev,
 	vdev->cdev->owner = owner;
 	ret = cdev_add(vdev->cdev, MKDEV(VIDEO_MAJOR, vdev->minor), 1);
 	if (ret < 0) {
-		printk(KERN_ERR "%s: cdev_add failed\n", __func__);
+		pr_err("%s: cdev_add failed\n", __func__);
 		kfree(vdev->cdev);
 		vdev->cdev = NULL;
 		goto cleanup;
@@ -977,7 +984,7 @@ int __video_register_device(struct video_device *vdev,
 	dev_set_name(&vdev->dev, "%s%d", name_base, vdev->num);
 	ret = device_register(&vdev->dev);
 	if (ret < 0) {
-		printk(KERN_ERR "%s: device_register failed\n", __func__);
+		pr_err("%s: device_register failed\n", __func__);
 		goto cleanup;
 	}
 	/* Register the release callback that will be called when the last
@@ -985,7 +992,7 @@ int __video_register_device(struct video_device *vdev,
 	vdev->dev.release = v4l2_device_release;
 
 	if (nr != -1 && nr != vdev->num && warn_if_nr_in_use)
-		printk(KERN_WARNING "%s: requested %s%d, got %s\n", __func__,
+		pr_warn("%s: requested %s%d, got %s\n", __func__,
 			name_base, nr, video_device_node_name(vdev));
 
 	/* Increase v4l2_device refcount */
@@ -1043,10 +1050,10 @@ static int __init videodev_init(void)
 	dev_t dev = MKDEV(VIDEO_MAJOR, 0);
 	int ret;
 
-	printk(KERN_INFO "Linux video capture interface: v2.00\n");
+	pr_info("Linux video capture interface: v2.00\n");
 	ret = register_chrdev_region(dev, VIDEO_NUM_DEVICES, VIDEO_NAME);
 	if (ret < 0) {
-		printk(KERN_WARNING "videodev: unable to get major %d\n",
+		pr_warn("videodev: unable to get major %d\n",
 				VIDEO_MAJOR);
 		return ret;
 	}
@@ -1054,7 +1061,7 @@ static int __init videodev_init(void)
 	ret = class_register(&video_class);
 	if (ret < 0) {
 		unregister_chrdev_region(dev, VIDEO_NUM_DEVICES);
-		printk(KERN_WARNING "video_dev: class_register failed\n");
+		pr_warn("video_dev: class_register failed\n");
 		return -EIO;
 	}
 
-- 
2.14.3
