Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:36451 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S945233AbcJaRwc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Oct 2016 13:52:32 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 8/9] [media] lirc: prevent use-after free
Date: Mon, 31 Oct 2016 17:52:26 +0000
Message-Id: <1477936347-9029-9-git-send-email-sean@mess.org>
In-Reply-To: <1477936347-9029-1-git-send-email-sean@mess.org>
References: <1477936347-9029-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If you unplug an lirc device while reading from it, you will get an
use after free as the cdev is freed while still in use.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/lirc_dev.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index bf4309f..60fd106 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -164,15 +164,15 @@ static int lirc_cdev_add(struct irctl *ir)
 	struct lirc_driver *d = &ir->d;
 	struct cdev *cdev;
 
-	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
+	cdev = cdev_alloc();
 	if (!cdev)
 		goto err_out;
 
 	if (d->fops) {
-		cdev_init(cdev, d->fops);
+		cdev->ops = d->fops;
 		cdev->owner = d->owner;
 	} else {
-		cdev_init(cdev, &lirc_dev_fops);
+		cdev->ops = &lirc_dev_fops;
 		cdev->owner = THIS_MODULE;
 	}
 	retval = kobject_set_name(&cdev->kobj, "lirc%d", d->minor);
@@ -190,7 +190,7 @@ static int lirc_cdev_add(struct irctl *ir)
 	return 0;
 
 err_out:
-	kfree(cdev);
+	cdev_del(cdev);
 	return retval;
 }
 
@@ -420,7 +420,6 @@ int lirc_unregister_driver(int minor)
 	} else {
 		lirc_irctl_cleanup(ir);
 		cdev_del(cdev);
-		kfree(cdev);
 		kfree(ir);
 		irctls[minor] = NULL;
 	}
@@ -521,7 +520,6 @@ int lirc_dev_fop_close(struct inode *inode, struct file *file)
 		lirc_irctl_cleanup(ir);
 		cdev_del(cdev);
 		irctls[ir->d.minor] = NULL;
-		kfree(cdev);
 		kfree(ir);
 	}
 
-- 
2.7.4

