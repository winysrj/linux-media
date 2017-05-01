Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41296 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932939AbdEAQEY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:04:24 -0400
Subject: [PATCH 09/16] lirc_dev: remove lirc_irctl_init() and lirc_cdev_add()
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:04:21 +0200
Message-ID: <149365466173.12922.9961502664172853219.stgit@zeus.hardeman.nu>
In-Reply-To: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
References: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These two functions only make the logic in lirc_register_driver() harder to
follow.

(Note that almost no other driver calls kobject_set_name() on their cdev so I
simply removed that part).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/lirc_dev.c |   44 ++++++++++++-------------------------------
 1 file changed, 12 insertions(+), 32 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index fcc88a09b108..574f4dd416b8 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -65,15 +65,6 @@ static struct irctl *irctls[MAX_IRCTL_DEVICES];
 /* Only used for sysfs but defined to void otherwise */
 static struct class *lirc_class;
 
-/*  helper function
- *  initializes the irctl structure
- */
-static void lirc_irctl_init(struct irctl *ir)
-{
-	mutex_init(&ir->irctl_lock);
-	ir->d.minor = NOPLUG;
-}
-
 static void lirc_release(struct device *ld)
 {
 	struct irctl *ir = container_of(ld, struct irctl, dev);
@@ -91,27 +82,6 @@ static void lirc_release(struct device *ld)
 	kfree(ir);
 }
 
-static int lirc_cdev_add(struct irctl *ir)
-{
-	struct lirc_driver *d = &ir->d;
-	struct cdev *cdev;
-	int retval;
-
-	cdev = &ir->cdev;
-
-	if (!d->fops)
-		return -EINVAL;
-
-	cdev_init(cdev, d->fops);
-	cdev->owner = d->owner;
-	retval = kobject_set_name(&cdev->kobj, "lirc%d", d->minor);
-	if (retval)
-		return retval;
-
-	cdev->kobj.parent = &ir->dev.kobj;
-	return cdev_add(cdev, ir->dev.devt, 1);
-}
-
 static int lirc_allocate_buffer(struct irctl *ir)
 {
 	int err = 0;
@@ -167,6 +137,11 @@ int lirc_register_driver(struct lirc_driver *d)
 		return -EINVAL;
 	}
 
+	if (!d->fops) {
+		pr_err("fops pointer not filled in!\n");
+		return -EINVAL;
+	}
+
 	if (d->minor >= MAX_IRCTL_DEVICES) {
 		dev_err(d->dev, "minor must be between 0 and %d!\n",
 						MAX_IRCTL_DEVICES - 1);
@@ -210,7 +185,8 @@ int lirc_register_driver(struct lirc_driver *d)
 		err = -ENOMEM;
 		goto out_lock;
 	}
-	lirc_irctl_init(ir);
+
+	mutex_init(&ir->irctl_lock);
 	irctls[minor] = ir;
 	d->minor = minor;
 
@@ -238,7 +214,11 @@ int lirc_register_driver(struct lirc_driver *d)
 	ir->dev.release = lirc_release;
 	dev_set_name(&ir->dev, "lirc%d", ir->d.minor);
 
-	err = lirc_cdev_add(ir);
+	cdev_init(&ir->cdev, d->fops);
+	ir->cdev.owner = ir->d.owner;
+	ir->cdev.kobj.parent = &ir->dev.kobj;
+
+	err = cdev_add(&ir->cdev, ir->dev.devt, 1);
 	if (err)
 		goto out_free_dev;
 
