Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:56412 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdFYMbh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 08:31:37 -0400
Subject: [PATCH 04/19] lirc_dev: use cdev_device_add() helper function
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Sun, 25 Jun 2017 14:31:35 +0200
Message-ID: <149839389507.28811.5252005887386871148.stgit@zeus.hardeman.nu>
In-Reply-To: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
References: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace calls to cdev_add() and device_add() with the cdev_device_add()
helper function.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/lirc_dev.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 591dee9f6ba2..61ed90a975ad 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -191,17 +191,11 @@ int lirc_register_driver(struct lirc_driver *d)
 
 	cdev_init(&ir->cdev, d->fops);
 	ir->cdev.owner = ir->d.owner;
-	ir->cdev.kobj.parent = &ir->dev.kobj;
-
-	err = cdev_add(&ir->cdev, ir->dev.devt, 1);
-	if (err)
-		goto out_free_dev;
-
 	ir->attached = 1;
 
-	err = device_add(&ir->dev);
+	err = cdev_device_add(&ir->cdev, &ir->dev);
 	if (err)
-		goto out_cdev;
+		goto out_dev;
 
 	mutex_unlock(&lirc_dev_lock);
 
@@ -210,9 +204,7 @@ int lirc_register_driver(struct lirc_driver *d)
 
 	return 0;
 
-out_cdev:
-	cdev_del(&ir->cdev);
-out_free_dev:
+out_dev:
 	put_device(&ir->dev);
 out_lock:
 	mutex_unlock(&lirc_dev_lock);
@@ -244,8 +236,7 @@ void lirc_unregister_driver(struct lirc_driver *d)
 
 	mutex_unlock(&lirc_dev_lock);
 
-	device_del(&ir->dev);
-	cdev_del(&ir->cdev);
+	cdev_device_del(&ir->cdev, &ir->dev);
 	put_device(&ir->dev);
 }
 EXPORT_SYMBOL(lirc_unregister_driver);
