Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33794 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753748AbZI2ATD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2009 20:19:03 -0400
From: Peter Huewe <PeterHuewe@gmx.de>
To: Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] media/video:  adding __init/__exit macros to various drivers
Date: Tue, 29 Sep 2009 02:19:00 +0200
Cc: kernel-janitors@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Andy Walls <awalls@radix.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Steven Toth <stoth@kernellabs.com>,
	Michael Krufky <mkrufky@kernellabs.com>,
	Laurent Pinchart <laurent.pinchart@skynet.be>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Martin Dauskardt <martin.dauskardt@gmx.de>,
	"Beholder Intl. Ltd. Dmitry Belimov" <d.belimov@gmail.com>,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909290219.01623.PeterHuewe@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init/__exit macros to the module_init/
module_exit functions of the following drivers in media video:
    drivers/media/video/ivtv/ivtv-driver.c
    drivers/media/video/cx18/cx18-driver.c
    drivers/media/video/davinci/dm355_ccdc.c
    drivers/media/video/davinci/dm644x_ccdc.c
    drivers/media/video/saa7164/saa7164-core.c
    drivers/media/video/saa7134/saa7134-core.c
    drivers/media/video/cx23885/cx23885-core.c

Please have a look at the small patch and either pull it through
your tree, or please ack' it so Jiri can pull it through the trivial tree.

linux version v2.6.32-rc1 - linus git tree, Di 29. Sep 01:10:18 CEST 2009

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
index 6dd51e2..e12082b 100644
--- a/drivers/media/video/cx18/cx18-driver.c
+++ b/drivers/media/video/cx18/cx18-driver.c
@@ -1200,7 +1200,7 @@ static struct pci_driver cx18_pci_driver = {
       .remove =   cx18_remove,
 };
 
-static int module_start(void)
+static int __init module_start(void)
 {
 	printk(KERN_INFO "cx18:  Start initialization, version %s\n", CX18_VERSION);
 
@@ -1224,7 +1224,7 @@ static int module_start(void)
 	return 0;
 }
 
-static void module_cleanup(void)
+static void __exit module_cleanup(void)
 {
 	pci_unregister_driver(&cx18_pci_driver);
 }
diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index c31284b..fa2d350 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -1957,7 +1957,7 @@ static struct pci_driver cx23885_pci_driver = {
 	.resume   = NULL,
 };
 
-static int cx23885_init(void)
+static int __init cx23885_init(void)
 {
 	printk(KERN_INFO "cx23885 driver version %d.%d.%d loaded\n",
 	       (CX23885_VERSION_CODE >> 16) & 0xff,
@@ -1970,7 +1970,7 @@ static int cx23885_init(void)
 	return pci_register_driver(&cx23885_pci_driver);
 }
 
-static void cx23885_fini(void)
+static void __exit cx23885_fini(void)
 {
 	pci_unregister_driver(&cx23885_pci_driver);
 }
diff --git a/drivers/media/video/davinci/dm355_ccdc.c b/drivers/media/video/davinci/dm355_ccdc.c
index 4629cab..56fbefe 100644
--- a/drivers/media/video/davinci/dm355_ccdc.c
+++ b/drivers/media/video/davinci/dm355_ccdc.c
@@ -959,7 +959,7 @@ static struct ccdc_hw_device ccdc_hw_dev = {
 	},
 };
 
-static int dm355_ccdc_init(void)
+static int __init dm355_ccdc_init(void)
 {
 	printk(KERN_NOTICE "dm355_ccdc_init\n");
 	if (vpfe_register_ccdc_device(&ccdc_hw_dev) < 0)
@@ -969,7 +969,7 @@ static int dm355_ccdc_init(void)
 	return 0;
 }
 
-static void dm355_ccdc_exit(void)
+static void __exit dm355_ccdc_exit(void)
 {
 	vpfe_unregister_ccdc_device(&ccdc_hw_dev);
 }
diff --git a/drivers/media/video/davinci/dm644x_ccdc.c b/drivers/media/video/davinci/dm644x_ccdc.c
index 2f19a91..d5fa193 100644
--- a/drivers/media/video/davinci/dm644x_ccdc.c
+++ b/drivers/media/video/davinci/dm644x_ccdc.c
@@ -859,7 +859,7 @@ static struct ccdc_hw_device ccdc_hw_dev = {
 	},
 };
 
-static int dm644x_ccdc_init(void)
+static int __init dm644x_ccdc_init(void)
 {
 	printk(KERN_NOTICE "dm644x_ccdc_init\n");
 	if (vpfe_register_ccdc_device(&ccdc_hw_dev) < 0)
@@ -869,7 +869,7 @@ static int dm644x_ccdc_init(void)
 	return 0;
 }
 
-static void dm644x_ccdc_exit(void)
+static void __exit dm644x_ccdc_exit(void)
 {
 	vpfe_unregister_ccdc_device(&ccdc_hw_dev);
 }
diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
index 463ec34..7cdbc1a 100644
--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -1361,7 +1361,7 @@ static struct pci_driver ivtv_pci_driver = {
       .remove =   ivtv_remove,
 };
 
-static int module_start(void)
+static int __init module_start(void)
 {
 	printk(KERN_INFO "ivtv: Start initialization, version %s\n", IVTV_VERSION);
 
@@ -1385,7 +1385,7 @@ static int module_start(void)
 	return 0;
 }
 
-static void module_cleanup(void)
+static void __exit module_cleanup(void)
 {
 	pci_unregister_driver(&ivtv_pci_driver);
 }
diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index f87757f..c673901 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -1319,7 +1319,7 @@ static struct pci_driver saa7134_pci_driver = {
 #endif
 };
 
-static int saa7134_init(void)
+static int __init saa7134_init(void)
 {
 	INIT_LIST_HEAD(&saa7134_devlist);
 	printk(KERN_INFO "saa7130/34: v4l2 driver version %d.%d.%d loaded\n",
@@ -1333,7 +1333,7 @@ static int saa7134_init(void)
 	return pci_register_driver(&saa7134_pci_driver);
 }
 
-static void saa7134_fini(void)
+static void __exit saa7134_fini(void)
 {
 	pci_unregister_driver(&saa7134_pci_driver);
 }
diff --git a/drivers/media/video/saa7164/saa7164-core.c b/drivers/media/video/saa7164/saa7164-core.c
index 709affc..e6aa0fb 100644
--- a/drivers/media/video/saa7164/saa7164-core.c
+++ b/drivers/media/video/saa7164/saa7164-core.c
@@ -724,13 +724,13 @@ static struct pci_driver saa7164_pci_driver = {
 	.resume   = NULL,
 };
 
-static int saa7164_init(void)
+static int __init saa7164_init(void)
 {
 	printk(KERN_INFO "saa7164 driver loaded\n");
 	return pci_register_driver(&saa7164_pci_driver);
 }
 
-static void saa7164_fini(void)
+static void __exit saa7164_fini(void)
 {
 	pci_unregister_driver(&saa7164_pci_driver);
 }
