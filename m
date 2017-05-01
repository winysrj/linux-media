Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41264 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932715AbdEAQED (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:04:03 -0400
Subject: [PATCH 05/16] lirc_dev: clarify error handling
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:04:01 +0200
Message-ID: <149365464135.12922.1126233823471662348.stgit@zeus.hardeman.nu>
In-Reply-To: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
References: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

out_sysfs is misleading, sysfs only comes into play after device_add(). Also,
calling device_init() before the rest of struct dev is filled out is clearer.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/lirc_dev.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 5c2b009b6d50..fb487c39b834 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -238,16 +238,16 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 
 	ir->d = *d;
 
+	device_initialize(&ir->dev);
 	ir->dev.devt = MKDEV(MAJOR(lirc_base_dev), ir->d.minor);
 	ir->dev.class = lirc_class;
 	ir->dev.parent = d->dev;
 	ir->dev.release = lirc_release;
 	dev_set_name(&ir->dev, "lirc%d", ir->d.minor);
-	device_initialize(&ir->dev);
 
 	err = lirc_cdev_add(ir);
 	if (err)
-		goto out_sysfs;
+		goto out_free_dev;
 
 	ir->attached = 1;
 
@@ -264,7 +264,7 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 	return minor;
 out_cdev:
 	cdev_del(&ir->cdev);
-out_sysfs:
+out_free_dev:
 	put_device(&ir->dev);
 out_lock:
 	mutex_unlock(&lirc_dev_lock);
