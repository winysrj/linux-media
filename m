Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:65006 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748Ab0AZTrB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2010 14:47:01 -0500
Date: Tue, 26 Jan 2010 20:46:58 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] dvb/bt8xx: Clean-up init and exit functions
Message-ID: <20100126204658.11047e14@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jean Delvare <khali@linux-fr.org>
Subject: dvb/bt8xx: Clean-up init and exit functions

The init and exit functions are needlessly complex. Remove the bloat:
* Drop irrelevant/outdated comments.
* Remove useless bt878_pci_driver_registered global variable.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 linux/drivers/media/dvb/bt8xx/bt878.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/dvb/bt8xx/bt878.c	2010-01-26 19:13:38.000000000 +0100
+++ v4l-dvb/linux/drivers/media/dvb/bt8xx/bt878.c	2010-01-26 20:40:37.000000000 +0100
@@ -580,8 +580,6 @@ static struct pci_driver bt878_pci_drive
       .remove	= __devexit_p(bt878_remove),
 };
 
-static int bt878_pci_driver_registered;
-
 /*******************************/
 /* Module management functions */
 /*******************************/
@@ -589,34 +587,23 @@ static int bt878_pci_driver_registered;
 static int __init bt878_init_module(void)
 {
 	bt878_num = 0;
-	bt878_pci_driver_registered = 0;
 
 	printk(KERN_INFO "bt878: AUDIO driver version %d.%d.%d loaded\n",
 	       (BT878_VERSION_CODE >> 16) & 0xff,
 	       (BT878_VERSION_CODE >> 8) & 0xff,
 	       BT878_VERSION_CODE & 0xff);
-/*
-	bt878_check_chipset();
-*/
-	/* later we register inside of bt878_find_audio_dma()
-	 * because we may want to ignore certain cards */
-	bt878_pci_driver_registered = 1;
+
 	return pci_register_driver(&bt878_pci_driver);
 }
 
 static void __exit bt878_cleanup_module(void)
 {
-	if (bt878_pci_driver_registered) {
-		bt878_pci_driver_registered = 0;
-		pci_unregister_driver(&bt878_pci_driver);
-	}
-	return;
+	pci_unregister_driver(&bt878_pci_driver);
 }
 
 module_init(bt878_init_module);
 module_exit(bt878_cleanup_module);
 
-//MODULE_AUTHOR("XXX");
 MODULE_LICENSE("GPL");
 
 /*


-- 
Jean Delvare
