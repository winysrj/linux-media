Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:56899 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbcF2NVD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 09:21:03 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH 05/15] lirc_dev: simplify goto paths
Date: Wed, 29 Jun 2016 22:20:34 +0900
Message-id: <1467206444-9935-6-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
References: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The code can be rearranged so that some goto paths can be removed

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index b11ab5c..400ab80 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -241,52 +241,44 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 
 	if (!d) {
 		pr_err("lirc_dev: driver pointer must be not NULL!\n");
-		err = -EBADRQC;
-		goto out;
+		return -EBADRQC;
 	}
 
 	if (!d->dev) {
 		pr_err("%s: dev pointer not filled in!\n", __func__);
-		err = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	if (MAX_IRCTL_DEVICES <= d->minor) {
 		dev_err(d->dev, "minor must be between 0 and %d!\n",
 						MAX_IRCTL_DEVICES - 1);
-		err = -EBADRQC;
-		goto out;
+		return -EBADRQC;
 	}
 
 	if (1 > d->code_length || (BUFLEN * 8) < d->code_length) {
 		dev_err(d->dev, "code length must be less than %d bits\n",
 								BUFLEN * 8);
-		err = -EBADRQC;
-		goto out;
+		return -EBADRQC;
 	}
 
 	if (d->sample_rate) {
 		if (2 > d->sample_rate || HZ < d->sample_rate) {
 			dev_err(d->dev, "invalid %d sample rate\n",
 							d->sample_rate);
-			err = -EBADRQC;
-			goto out;
+			return -EBADRQC;
 		}
 		if (!d->add_to_buf) {
 			dev_err(d->dev, "add_to_buf not set\n");
-			err = -EBADRQC;
-			goto out;
+			return -EBADRQC;
 		}
 	} else if (!(d->fops && d->fops->read) && !d->rbuf) {
 		dev_err(d->dev, "fops->read and rbuf are NULL!\n");
-		err = -EBADRQC;
-		goto out;
+		return -EBADRQC;
 	} else if (!d->rbuf) {
 		if (!(d->fops && d->fops->read && d->fops->poll &&
 		      d->fops->unlocked_ioctl)) {
 			dev_err(d->dev, "undefined read, poll, ioctl\n");
-			err = -EBADRQC;
-			goto out;
+			return -EBADRQC;
 		}
 	}
 
@@ -364,7 +356,7 @@ out_sysfs:
 	device_destroy(lirc_class, MKDEV(MAJOR(lirc_base_dev), ir->d.minor));
 out_lock:
 	mutex_unlock(&lirc_dev_lock);
-out:
+
 	return err;
 }
 
@@ -793,9 +785,8 @@ static int __init lirc_dev_init(void)
 
 	lirc_class = class_create(THIS_MODULE, "lirc");
 	if (IS_ERR(lirc_class)) {
-		retval = PTR_ERR(lirc_class);
 		pr_err("lirc_dev: class_create failed\n");
-		goto error;
+		return PTR_ERR(lirc_class);
 	}
 
 	retval = alloc_chrdev_region(&lirc_base_dev, 0, MAX_IRCTL_DEVICES,
@@ -803,15 +794,14 @@ static int __init lirc_dev_init(void)
 	if (retval) {
 		class_destroy(lirc_class);
 		pr_err("lirc_dev: alloc_chrdev_region failed\n");
-		goto error;
+		return retval;
 	}
 
 
 	pr_info("lirc_dev: IR Remote Control driver registered, major %d\n",
 							MAJOR(lirc_base_dev));
 
-error:
-	return retval;
+	return 0;
 }
 
 
-- 
2.8.1

