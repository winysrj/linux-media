Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:41648 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907AbcA1I5G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 03:57:06 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH 2/12] TW686x: Trivial changes suggested by Ezequiel Garcia
References: <m337tif6om.fsf@t19.piap.pl>
Date: Thu, 28 Jan 2016 09:57:04 +0100
In-Reply-To: <m337tif6om.fsf@t19.piap.pl> ("Krzysztof \=\?utf-8\?Q\?Ha\=C5\=82as\?\=
 \=\?utf-8\?Q\?a\=22's\?\= message of
	"Thu, 28 Jan 2016 09:29:29 +0100")
Message-ID: <m3powmdqu7.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/media/pci/tw686x/tw686x-core.c b/drivers/media/pci/tw686x/tw686x-core.c
index aa873c5..f22f485 100644
--- a/drivers/media/pci/tw686x/tw686x-core.c
+++ b/drivers/media/pci/tw686x/tw686x-core.c
@@ -1,13 +1,13 @@
 /*
-  Copyright (C) 2015 Industrial Research Institute for Automation
-  and Measurements PIAP
-
-  Written by Krzysztof Hałasa.
-
-  This program is free software; you can redistribute it and/or modify it
-  under the terms of version 2 of the GNU General Public License
-  as published by the Free Software Foundation.
-*/
+ * Copyright (C) 2015 Industrial Research Institute for Automation
+ * and Measurements PIAP
+ *
+ * Written by Krzysztof Hałasa.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
 
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -68,15 +68,13 @@ static int tw686x_probe(struct pci_dev *pci_dev,
 		goto disable;
 	}
 
-	if (!request_mem_region(pci_resource_start(pci_dev, 0),
-				pci_resource_len(pci_dev, 0), dev->name)) {
+	err = pci_request_regions(pci_dev, dev->name);
+	if (err < 0) {
 		pr_err("%s: Unable to get MMIO region\n", dev->name);
-		err = -EBUSY;
 		goto disable;
 	}
 
-	dev->mmio = ioremap_nocache(pci_resource_start(pci_dev, 0),
-				    pci_resource_len(pci_dev, 0));
+	dev->mmio = pci_ioremap_bar(pci_dev, 0);
 	if (!dev->mmio) {
 		pr_err("%s: Unable to remap MMIO region\n", dev->name);
 		err = -EIO;
@@ -158,19 +156,8 @@ static struct pci_driver tw686x_pci_driver = {
 	.remove = tw686x_remove,
 };
 
-static int tw686x_init(void)
-{
-	return pci_register_driver(&tw686x_pci_driver);
-}
-
-static void tw686x_exit(void)
-{
-	pci_unregister_driver(&tw686x_pci_driver);
-}
-
 MODULE_DESCRIPTION("Driver for video frame grabber cards based on Intersil/Techwell TW686[4589]");
 MODULE_AUTHOR("Krzysztof Halasa");
 MODULE_LICENSE("GPL v2");
 MODULE_DEVICE_TABLE(pci, tw686x_pci_tbl);
-module_init(tw686x_init);
-module_exit(tw686x_exit);
+module_pci_driver(tw686x_pci_driver);
diff --git a/drivers/media/pci/tw686x/tw686x-regs.h b/drivers/media/pci/tw686x/tw686x-regs.h
index f9ac413..33b492b 100644
--- a/drivers/media/pci/tw686x/tw686x-regs.h
+++ b/drivers/media/pci/tw686x/tw686x-regs.h
@@ -16,10 +16,10 @@
 						0xD6, 0xD8, 0xDA, 0xDC})
 #define DMA_PAGE_TABLE1_ADDR	((const u16[8]){0x09, 0xD1, 0xD3, 0xD5,	\
 						0xD7, 0xD9, 0xDB, 0xDD})
-#define DMA_CHANNEL_ENABLE	0x0a
-#define DMA_CONFIG		0x0b
-#define DMA_TIMER_INTERVAL	0x0c
-#define DMA_CHANNEL_TIMEOUT	0x0d
+#define DMA_CHANNEL_ENABLE	0x0A
+#define DMA_CONFIG		0x0B
+#define DMA_TIMER_INTERVAL	0x0C
+#define DMA_CHANNEL_TIMEOUT	0x0D
 #define VDMA_CHANNEL_CONFIG	REG8_1(0x10)
 #define ADMA_P_ADDR		REG8_2(0x18)
 #define ADMA_B_ADDR		REG8_2(0x19)
diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index bf4f12e..5a1b9ab 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -1,13 +1,13 @@
 /*
-  Copyright (C) 2015 Industrial Research Institute for Automation
-  and Measurements PIAP
-
-  Written by Krzysztof Hałasa.
-
-  This program is free software; you can redistribute it and/or modify it
-  under the terms of version 2 of the GNU General Public License
-  as published by the Free Software Foundation.
-*/
+ * Copyright (C) 2015 Industrial Research Institute for Automation
+ * and Measurements PIAP
+ *
+ * Written by Krzysztof Hałasa.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
 
 #include <linux/init.h>
 #include <linux/list.h>
diff --git a/drivers/media/pci/tw686x/tw686x.h b/drivers/media/pci/tw686x/tw686x.h
index 6a147d2..8b9d313 100644
--- a/drivers/media/pci/tw686x/tw686x.h
+++ b/drivers/media/pci/tw686x/tw686x.h
@@ -1,13 +1,13 @@
 /*
-  Copyright (C) 2015 Industrial Research Institute for Automation
-  and Measurements PIAP
-
-  Written by Krzysztof Hałasa.
-
-  This program is free software; you can redistribute it and/or modify it
-  under the terms of version 2 of the GNU General Public License
-  as published by the Free Software Foundation.
-*/
+ * Copyright (C) 2015 Industrial Research Institute for Automation
+ * and Measurements PIAP
+ *
+ * Written by Krzysztof Hałasa.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
 
 #include <linux/delay.h>
 #include <linux/freezer.h>
