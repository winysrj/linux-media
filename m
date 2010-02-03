Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:50697 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757860Ab0BCU3l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 15:29:41 -0500
Message-ID: <4B69DC96.1040704@arcor.de>
Date: Wed, 03 Feb 2010 21:29:10 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 11/15] -  tm6000 add init for tm6010
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de> <4B675B19.3080705@redhat.com> <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com> <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com> <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de> <4B69D8CC.2030008@arcor.de>
In-Reply-To: <4B69D8CC.2030008@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -394,7 +414,15 @@ struct reg_init tm6010_init_tab[] = {
     { REQ_07_SET_GET_AVREG, 0x3f, 0x00 },
 
     { REQ_05_SET_GET_USBREG, 0x18, 0x00 },
-
+   
+    /* additional from Terratec Cinergy Hybrid XE */
+    { REQ_07_SET_GET_AVREG, 0xdc, 0xaa },
+    { REQ_07_SET_GET_AVREG, 0xdd, 0x30 },
+    { REQ_07_SET_GET_AVREG, 0xde, 0x20 },
+    { REQ_07_SET_GET_AVREG, 0xdf, 0xd0 },
+    { REQ_04_EN_DISABLE_MCU_INT, 0x02, 0x00 },
+    { REQ_07_SET_GET_AVREG, 0xd8, 0x2f },
+   
     /* set remote wakeup key:any key wakeup */
     { REQ_07_SET_GET_AVREG,  0xe5,  0xfe },
     { REQ_07_SET_GET_AVREG,  0xda,  0xff },
@@ -404,6 +432,7 @@ int tm6000_init (struct tm6000_core *dev)
 {
     int board, rc=0, i, size;
     struct reg_init *tab;
+    u8 buf[40];
 
     if (dev->dev_type == TM6010) {
         tab = tm6010_init_tab;
@@ -424,61 +453,129 @@ int tm6000_init (struct tm6000_core *dev)
         }
     }
 
-    msleep(5); /* Just to be conservative */
-
-    /* Check board version - maybe 10Moons specific */
-    board=tm6000_get_reg16 (dev, 0x40, 0, 0);
-    if (board >=0) {
-        printk (KERN_INFO "Board version = 0x%04x\n",board);
-    } else {
-        printk (KERN_ERR "Error %i while retrieving board
version\n",board);
-    }
-
+    /* hack */
     if (dev->dev_type == TM6010) {
-        /* Turn xceive 3028 on */
-        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_3, 0x01);
-        msleep(11);
-    }
-
-    /* Reset GPIO1 and GPIO4. */
-    for (i=0; i< 2; i++) {
-        rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-                    dev->tuner_reset_gpio, 0x00);
-        if (rc<0) {
-            printk (KERN_ERR "Error %i doing GPIO1 reset\n",rc);
-            return rc;
-        }
-
-        msleep(10); /* Just to be conservative */
-        rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-                    dev->tuner_reset_gpio, 0x01);
-        if (rc<0) {
-            printk (KERN_ERR "Error %i doing GPIO1 reset\n",rc);
-            return rc;
-        }
-
-        msleep(10);
-        rc=tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_4, 0);
-        if (rc<0) {
-            printk (KERN_ERR "Error %i doing GPIO4 reset\n",rc);
-            return rc;
-        }
-
-        msleep(10);
-        rc=tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_4, 1);
-        if (rc<0) {
-            printk (KERN_ERR "Error %i doing GPIO4 reset\n",rc);
-            return rc;
-        }
-
-        if (!i) {
-            rc=tm6000_get_reg16(dev, 0x40,0,0);
-            if (rc>=0) {
-                printk ("board=%d\n", rc);
+       
+        msleep(15);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_4, 0);
+        msleep(15);
+               
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_1, 0);
+   
+        msleep(50);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_1, 1);
+       
+        msleep(15);
+        tm6000_read_write_usb (dev, 0xc0, 0x0e, 0x0010, 0x4400, buf, 2);
+       
+        msleep(15);
+        tm6000_read_write_usb (dev, 0xc0, 0x10, 0xf432, 0x0000, buf, 2);
+   
+        msleep(15);
+        buf[0] = 0x12;
+        buf[1] = 0x34;
+        tm6000_read_write_usb (dev, 0x40, 0x10, 0xf432, 0x0000, buf, 2);
+   
+        msleep(15);
+        tm6000_read_write_usb (dev, 0xc0, 0x10, 0xf432, 0x0000, buf, 2);
+   
+        msleep(15);
+        tm6000_read_write_usb (dev, 0xc0, 0x10, 0x0032, 0x0000, buf, 2);
+
+        msleep(15);
+        buf[0] = 0x00;
+        buf[1] = 0x01;
+        tm6000_read_write_usb (dev, 0x40, 0x10, 0xf332, 0x0000, buf, 2);
+   
+        msleep(15);
+        tm6000_read_write_usb (dev, 0xc0, 0x10, 0x00c0, 0x0000, buf, 39);
+   
+        msleep(15);
+        buf[0] = 0x00;
+        buf[1] = 0x00;
+        tm6000_read_write_usb (dev, 0x40, 0x10, 0xf332, 0x0000, buf, 2);
+   
+        msleep(15);
+        tm6000_read_write_usb (dev, 0xc0, 0x10, 0x7f1f, 0x0000, buf, 2);
+//        printk(KERN_INFO "buf %#x %#x \n", buf[0], buf [1]);
+        msleep(15);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_4, 1);
+        msleep(15);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                    TM6010_GPIO_0, 1);
+        msleep(15);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_7, 0);
+        msleep(15);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_5, 1);
+   
+        msleep(15);
+   
+        for (i=0; i< size; i++) {
+            rc= tm6000_set_reg (dev, tab[i].req, tab[i].reg, tab[i].val);
+            if (rc<0) {
+                printk (KERN_ERR "Error %i while setting req %d, "
+                         "reg %d to value %d\n", rc,
+                         tab[i].req,tab[i].reg, tab[i].val);
+                return rc;
             }
         }
+           
+        msleep(15);
+   
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_4, 0);
+        msleep(15);
+
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_1, 0);
+   
+        msleep(50);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_1, 1);
+       
+        msleep(15);
+        tm6000_read_write_usb (dev, 0xc0, 0x0e, 0x00c2, 0x0008, buf, 2);
+//        printk(KERN_INFO "buf %#x %#x \n", buf[0], buf[1]);
+        msleep(15);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_2, 1);
+        msleep(15);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_2, 0);
+        msleep(15);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_2, 1);
+        msleep(15);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_2, 1);
+        msleep(15);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_2, 0);
+        msleep(15);
+        tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+                TM6010_GPIO_2, 1);
+        msleep(15);
     }
+    /* hack end */
+   
+    msleep(5); /* Just to be conservative */
 
+    /* Check board version - maybe 10Moons specific */
+    if (dev->dev_type == TM5600) {
+         board=tm6000_get_reg16 (dev, 0x40, 0, 0);
+        if (board >=0) {
+            printk (KERN_INFO "Board version = 0x%04x\n",board);
+        } else {
+            printk (KERN_ERR "Error %i while retrieving board
version\n",board);
+        }
+    }
+   
     msleep(50);
 
     return 0;

-- 
Stefan Ringel <stefan.ringel@arcor.de>

