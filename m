Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53648 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab2IXLaC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 07:30:02 -0400
Received: by padhz1 with SMTP id hz1so860987pad.19
        for <linux-media@vger.kernel.org>; Mon, 24 Sep 2012 04:30:02 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] [media] media-devnode: Replace printk with pr_*
Date: Mon, 24 Sep 2012 16:56:24 +0530
Message-Id: <1348485984-22198-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes checkpatch warnings related to printk.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/media-devnode.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index f6b52d5..023b2a1 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -30,6 +30,8 @@
  * counting.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -215,7 +217,7 @@ int __must_check media_devnode_register(struct media_devnode *mdev)
 	minor = find_next_zero_bit(media_devnode_nums, MEDIA_NUM_DEVICES, 0);
 	if (minor == MEDIA_NUM_DEVICES) {
 		mutex_unlock(&media_devnode_lock);
-		printk(KERN_ERR "could not get a free minor\n");
+		pr_err("could not get a free minor\n");
 		return -ENFILE;
 	}
 
@@ -230,7 +232,7 @@ int __must_check media_devnode_register(struct media_devnode *mdev)
 
 	ret = cdev_add(&mdev->cdev, MKDEV(MAJOR(media_dev_t), mdev->minor), 1);
 	if (ret < 0) {
-		printk(KERN_ERR "%s: cdev_add failed\n", __func__);
+		pr_err("%s: cdev_add failed\n", __func__);
 		goto error;
 	}
 
@@ -243,7 +245,7 @@ int __must_check media_devnode_register(struct media_devnode *mdev)
 	dev_set_name(&mdev->dev, "media%d", mdev->minor);
 	ret = device_register(&mdev->dev);
 	if (ret < 0) {
-		printk(KERN_ERR "%s: device_register failed\n", __func__);
+		pr_err("%s: device_register failed\n", __func__);
 		goto error;
 	}
 
@@ -287,18 +289,18 @@ static int __init media_devnode_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "Linux media interface: v0.10\n");
+	pr_info("Linux media interface: v0.10\n");
 	ret = alloc_chrdev_region(&media_dev_t, 0, MEDIA_NUM_DEVICES,
 				  MEDIA_NAME);
 	if (ret < 0) {
-		printk(KERN_WARNING "media: unable to allocate major\n");
+		pr_warn("unable to allocate major\n");
 		return ret;
 	}
 
 	ret = bus_register(&media_bus_type);
 	if (ret < 0) {
 		unregister_chrdev_region(media_dev_t, MEDIA_NUM_DEVICES);
-		printk(KERN_WARNING "media: bus_register failed\n");
+		pr_warn("bus_register failed\n");
 		return -EIO;
 	}
 
-- 
1.7.4.1

