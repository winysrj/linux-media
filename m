Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55244 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbcGFJn7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 05:43:59 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Joe Perches <joe@perches.com>, Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH v3 05/15] [media] lirc_dev: simplify goto paths
Date: Wed, 06 Jul 2016 18:01:17 +0900
Message-id: <1467795687-10737-6-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467795687-10737-1-git-send-email-andi.shyti@samsung.com>
References: <1467795687-10737-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The code can be rearranged so that some goto paths can be removed

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 59f4c93..b11d026 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -243,52 +243,44 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 
 	if (!d) {
 		pr_err("driver pointer must be not NULL!\n");
-		err = -EBADRQC;
-		goto out;
+		return -EBADRQC;
 	}
 
 	if (!d->dev) {
 		pr_err("dev pointer not filled in!\n");
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
 
@@ -366,7 +358,7 @@ out_sysfs:
 	device_destroy(lirc_class, MKDEV(MAJOR(lirc_base_dev), ir->d.minor));
 out_lock:
 	mutex_unlock(&lirc_dev_lock);
-out:
+
 	return err;
 }
 
@@ -790,9 +782,8 @@ static int __init lirc_dev_init(void)
 
 	lirc_class = class_create(THIS_MODULE, "lirc");
 	if (IS_ERR(lirc_class)) {
-		retval = PTR_ERR(lirc_class);
 		pr_err("class_create failed\n");
-		goto error;
+		return PTR_ERR(lirc_class);
 	}
 
 	retval = alloc_chrdev_region(&lirc_base_dev, 0, MAX_IRCTL_DEVICES,
@@ -800,15 +791,14 @@ static int __init lirc_dev_init(void)
 	if (retval) {
 		class_destroy(lirc_class);
 		pr_err("alloc_chrdev_region failed\n");
-		goto error;
+		return retval;
 	}
 
 
 	pr_info("IR Remote Control driver registered, major %d\n",
 						MAJOR(lirc_base_dev));
 
-error:
-	return retval;
+	return 0;
 }
 
 
-- 
2.8.1

