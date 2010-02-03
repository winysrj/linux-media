Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:37043 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757904Ab0BCU0U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 15:26:20 -0500
Message-ID: <4B69DBCC.50108@arcor.de>
Date: Wed, 03 Feb 2010 21:25:48 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 9/15] -  tm6000 analog digital switch
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de> <4B675B19.3080705@redhat.com> <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com> <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com> <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de> <4B69D8CC.2030008@arcor.de>
In-Reply-To: <4B69D8CC.2030008@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -15,6 +15,7 @@
 #include <linux/delay.h>
 #include <media/tuner.h>
 #include <linux/mutex.h>
+#include "compat.h"
 #include <asm/unaligned.h>
 #include "tuner-i2c.h"
 #include "tuner-xc2028.h"
@@ -994,6 +995,13 @@ static int generic_set_freq(struct dvb_frontend
*fe, u32 freq /* in HZ */,
            buf[0], buf[1], buf[2], buf[3],
            freq / 1000000, (freq % 1000000) / 1000);
 
+    if (priv->ctrl.switch_mode) {
+        if (new_mode == T_ANALOG_TV)
+            do_tuner_callback(fe, SWITCH_TV_MODE, 0);
+        if (new_mode == T_DIGITAL_TV)
+            do_tuner_callback(fe, SWITCH_TV_MODE, 1);
+    }
+   
     rc = 0;
 
 ret:
--- a/drivers/media/common/tuners/tuner-xc2028.h
+++ b/drivers/media/common/tuners/tuner-xc2028.h
@@ -42,6 +42,7 @@ struct xc2028_ctrl {
     unsigned int        disable_power_mgmt:1;
     unsigned int            read_not_reliable:1;
     unsigned int        demod;
+    unsigned int        switch_mode:1;
     enum firmware_type    type:2;
 };
 
@@ -54,6 +55,7 @@ struct xc2028_config {
 /* xc2028 commands for callback */
 #define XC2028_TUNER_RESET    0
 #define XC2028_RESET_CLK    1
+#define SWITCH_TV_MODE        2
 
 #if defined(CONFIG_MEDIA_TUNER_XC2028) ||
(defined(CONFIG_MEDIA_TUNER_XC2028_MODULE) && defined(MODULE))
 extern struct dvb_frontend *xc2028_attach(struct dvb_frontend *fe,
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -269,13 +291,33 @@ static int tm6000_tuner_callback(void *ptr, int
component, int command, int arg)
                         TM6000_GPIO_CLK, 0);
             if (rc<0)
                 return rc;
-            msleep(100);
+            msleep(10);
             rc=tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
                         TM6000_GPIO_CLK, 1);
-            msleep(100);
+            msleep(10);
+            break;
+        }
+        break;
+       
+    case SWITCH_TV_MODE:
+        /* switch between analog and  digital */
+        switch (arg) {
+        case 0:
+            printk(KERN_INFO "switch to analog");
+            tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
+                    TM6010_GPIO_5, 1);
+            printk(KERN_INFO "analog");
+            break;
+        case 1:
+            printk(KERN_INFO "switch to digital");
+            tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
+                    TM6010_GPIO_5, 0);
+            printk(KERN_INFO "digital");
             break;
         }
+    break;
     }
+   
     return (rc);
 }
 
--- a/drivers/staging/tm6000/tm6000-dvb.c
+++ b/drivers/staging/tm6000/tm6000-dvb.c
@@ -235,7 +268,8 @@ int tm6000_dvb_register(struct tm6000_core *dev)
             .i2c_adap = &dev->i2c_adap,
             .i2c_addr = dev->tuner_addr,
         };
-
+       
+        dvb->frontend->callback = tm6000_tuner_callback;
         ret = dvb_register_frontend(&dvb->adapter, dvb->frontend);
         if (ret < 0) {
             printk(KERN_ERR
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -269,13 +291,33 @@ static int tm6000_tuner_callback(void *ptr, int
component, int command, int arg)
                         TM6000_GPIO_CLK, 0);
             if (rc<0)
                 return rc;
-            msleep(100);
+            msleep(10);
             rc=tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
                         TM6000_GPIO_CLK, 1);
-            msleep(100);
+            msleep(10);
+            break;
+        }
+        break;
+       
+    case SWITCH_TV_MODE:
+        /* switch between analog and  digital */
+        switch (arg) {
+        case 0:
+            printk(KERN_INFO "switch to analog");
+            tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
+                    TM6010_GPIO_5, 1);
+            printk(KERN_INFO "analog");
+            break;
+        case 1:
+            printk(KERN_INFO "switch to digital");
+            tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
+                    TM6010_GPIO_5, 0);
+            printk(KERN_INFO "digital");
             break;
         }
+    break;
     }
+   
     return (rc);
 }
 

-- 
Stefan Ringel <stefan.ringel@arcor.de>

