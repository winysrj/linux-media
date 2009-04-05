Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfilter6.ihug.co.nz ([203.109.136.6]:28270 "EHLO
	mailfilter6.ihug.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043AbZDEAo4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Apr 2009 20:44:56 -0400
Message-ID: <49D7FF52.40003@yahoo.co.nz>
Date: Sun, 05 Apr 2009 12:46:10 +1200
From: Kevin Wells <wells_kevin@yahoo.co.nz>
MIME-Version: 1.0
To: Steven Toth <stoth@linuxtv.org>
CC: linux-media@vger.kernel.org
Subject: [PATCH 2/4] tm6000: More robust error handling in tm6000_usb_probe()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Kevin Wells <kevin.wells@kahusoft.com>
# Date 1238841558 -46800
# Node ID 3140e621a17b536eb1487f8f9ad5b7b6a8ff8341
# Parent  a293d5babca03bb5a7f21ecb659d55e447194e49
More robust error handling in tm6000_usb_probe()

From: Kevin Wells <kevin.wells@kahusoft.com>

Priority: normal

Signed-off-by: Kevin Wells <kevin.wells@kahusoft.com>

diff -r a293d5babca0 -r 3140e621a17b 
linux/drivers/media/video/tm6000/tm6000-cards.c
--- a/linux/drivers/media/video/tm6000/tm6000-cards.c    Sat Apr 04 
23:07:00 2009 +1300
+++ b/linux/drivers/media/video/tm6000/tm6000-cards.c    Sat Apr 04 
23:39:18 2009 +1300
@@ -373,22 +373,22 @@
     /* Selects the proper interface */
     rc=usb_set_interface(usbdev,0,1);
     if (rc<0)
-        goto err;
+        goto err1;
 
     /* Check to see next free device and mark as used */
     nr=find_first_zero_bit(&tm6000_devused,TM6000_MAXBOARDS);
     if (nr >= TM6000_MAXBOARDS) {
         printk("tm6000: Only supports %i boards.\n", TM6000_MAXBOARDS);
-        usb_put_dev(usbdev);
-        return -ENOMEM;
+        rc = -ENOMEM;
+        goto err1;
     }
 
     /* Create and initialize dev struct */
     dev = kzalloc(sizeof(*dev), GFP_KERNEL);
     if (dev == NULL) {
         printk ("tm6000" ": out of memory!\n");
-        usb_put_dev(usbdev);
-        return -ENOMEM;
+        rc = -ENOMEM;
+        goto err1;
     }
     spin_lock_init(&dev->slock);
 
@@ -495,8 +495,7 @@
     if (!dev->isoc_in) {
         printk("tm6000: probing error: no IN ISOC endpoint!\n");
         rc= -ENODEV;
-
-        goto err;
+        goto err2;
     }
 
     /* save our data pointer in this interface device */
@@ -514,15 +513,17 @@
     rc=tm6000_init_dev(dev);
 
     if (rc<0)
-        goto err;
+        goto err3;
 
     return 0;
 
-err:
+err3:
+    usb_set_intfdata(interface, NULL);
+err2:
     tm6000_devused&=~(1<<nr);
+    kfree(dev);
+err1:
     usb_put_dev(usbdev);
-
-    kfree(dev);
     return rc;
 }
 
