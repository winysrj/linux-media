Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:56424 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdFYMb5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 08:31:57 -0400
Subject: [PATCH 08/19] lirc_dev: change irctl->attached to be a boolean
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Sun, 25 Jun 2017 14:31:55 +0200
Message-ID: <149839391540.28811.8935888773074169278.stgit@zeus.hardeman.nu>
In-Reply-To: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
References: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "attached" member of struct irctl is a boolean value, so let the code
reflect that.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/lirc_dev.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 92048d945ba7..aece6b619796 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -35,7 +35,7 @@ static dev_t lirc_base_dev;
 
 struct irctl {
 	struct lirc_driver d;
-	int attached;
+	bool attached;
 	int open;
 
 	struct mutex irctl_lock;
@@ -191,7 +191,7 @@ int lirc_register_driver(struct lirc_driver *d)
 
 	cdev_init(&ir->cdev, d->fops);
 	ir->cdev.owner = ir->d.owner;
-	ir->attached = 1;
+	ir->attached = true;
 
 	err = cdev_device_add(&ir->cdev, &ir->dev);
 	if (err)
@@ -227,7 +227,7 @@ void lirc_unregister_driver(struct lirc_driver *d)
 	dev_dbg(ir->d.dev, "lirc_dev: driver %s unregistered from minor = %d\n",
 		d->name, d->minor);
 
-	ir->attached = 0;
+	ir->attached = false;
 	if (ir->open) {
 		dev_dbg(ir->d.dev, LOGHEAD "releasing opened driver\n",
 			d->name, d->minor);
