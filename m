Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013Ab2FDRF0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jun 2012 13:05:26 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q54H5QQ1021456
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 4 Jun 2012 13:05:26 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] [media] lirc_sir: make device registration work
Date: Mon,  4 Jun 2012 13:05:24 -0400
Message-Id: <1338829524-29623-1-git-send-email-jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For one, the driver device pointer needs to be filled in, or the lirc core
will refuse to load the driver. And we really need to wire up all the
platform_device bits. This has been tested via the lirc sourceforge tree
and verified to work, been sitting there for months, finally getting
around to sending it. :\

CC: Josh Boyer <jwboyer@redhat.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/staging/media/lirc/lirc_sir.c |   60 +++++++++++++++++++++++++++++++-
 1 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index 945d962..4afc3b4 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -52,6 +52,7 @@
 #include <linux/io.h>
 #include <asm/irq.h>
 #include <linux/fcntl.h>
+#include <linux/platform_device.h>
 #ifdef LIRC_ON_SA1100
 #include <asm/hardware.h>
 #ifdef CONFIG_SA1100_COLLIE
@@ -487,9 +488,11 @@ static struct lirc_driver driver = {
 	.owner		= THIS_MODULE,
 };
 
+static struct platform_device *lirc_sir_dev;
 
 static int init_chrdev(void)
 {
+	driver.dev = &lirc_sir_dev->dev;
 	driver.minor = lirc_register_driver(&driver);
 	if (driver.minor < 0) {
 		printk(KERN_ERR LIRC_DRIVER_NAME ": init_chrdev() failed.\n");
@@ -1215,20 +1218,71 @@ static int init_lirc_sir(void)
 	return 0;
 }
 
+static int __devinit lirc_sir_probe(struct platform_device *dev)
+{
+	return 0;
+}
+
+static int __devexit lirc_sir_remove(struct platform_device *dev)
+{
+	return 0;
+}
+
+static struct platform_driver lirc_sir_driver = {
+	.probe		= lirc_sir_probe,
+	.remove		= __devexit_p(lirc_sir_remove),
+	.driver		= {
+		.name	= "lirc_sir",
+		.owner	= THIS_MODULE,
+	},
+};
 
 static int __init lirc_sir_init(void)
 {
 	int retval;
 
+	retval = platform_driver_register(&lirc_sir_driver);
+	if (retval) {
+		printk(KERN_ERR LIRC_DRIVER_NAME ": Platform driver register "
+		       "failed!\n");
+		return -ENODEV;
+	}
+
+	lirc_sir_dev = platform_device_alloc("lirc_dev", 0);
+	if (!lirc_sir_dev) {
+		printk(KERN_ERR LIRC_DRIVER_NAME ": Platform device alloc "
+		       "failed!\n");
+		retval = -ENOMEM;
+		goto pdev_alloc_fail;
+	}
+
+	retval = platform_device_add(lirc_sir_dev);
+	if (retval) {
+		printk(KERN_ERR LIRC_DRIVER_NAME ": Platform device add "
+		       "failed!\n");
+		retval = -ENODEV;
+		goto pdev_add_fail;
+	}
+
 	retval = init_chrdev();
 	if (retval < 0)
-		return retval;
+		goto fail;
+
 	retval = init_lirc_sir();
 	if (retval) {
 		drop_chrdev();
-		return retval;
+		goto fail;
 	}
+
 	return 0;
+
+fail:
+	platform_device_del(lirc_sir_dev);
+pdev_add_fail:
+	platform_device_put(lirc_sir_dev);
+pdev_alloc_fail:
+	platform_driver_unregister(&lirc_sir_driver);
+	return retval;
 }
 
 static void __exit lirc_sir_exit(void)
@@ -1236,6 +1290,8 @@ static void __exit lirc_sir_exit(void)
 	drop_hardware();
 	drop_chrdev();
 	drop_port();
+	platform_device_unregister(lirc_sir_dev);
+	platform_driver_unregister(&lirc_sir_driver);
 	printk(KERN_INFO LIRC_DRIVER_NAME ": Uninstalled.\n");
 }
 
-- 
1.7.1

