Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:45085 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752406AbcK0TB0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Nov 2016 14:01:26 -0500
Date: Sun, 27 Nov 2016 19:01:23 +0000
From: Sean Young <sean@mess.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] [media] lirc: fix error paths in lirc_cdev_add()
Message-ID: <20161127190123.GA19669@gofer.mess.org>
References: <20161126095717.GA3150@mwanda>
 <20161126112614.GA18806@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161126112614.GA18806@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"c77d17c0 [media] lirc: use-after free" introduces two problems:
cdev_del() can be called with a NULL argument, and the kobject_put()
path will cause a double free.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/lirc_dev.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index d3039ef..3854809 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -157,13 +157,13 @@ static const struct file_operations lirc_dev_fops = {
 
 static int lirc_cdev_add(struct irctl *ir)
 {
-	int retval = -ENOMEM;
 	struct lirc_driver *d = &ir->d;
 	struct cdev *cdev;
+	int retval;
 
 	cdev = cdev_alloc();
 	if (!cdev)
-		goto err_out;
+		return -ENOMEM;
 
 	if (d->fops) {
 		cdev->ops = d->fops;
@@ -177,10 +177,8 @@ static int lirc_cdev_add(struct irctl *ir)
 		goto err_out;
 
 	retval = cdev_add(cdev, MKDEV(MAJOR(lirc_base_dev), d->minor), 1);
-	if (retval) {
-		kobject_put(&cdev->kobj);
+	if (retval)
 		goto err_out;
-	}
 
 	ir->cdev = cdev;
 
-- 
2.9.3

