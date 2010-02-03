Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:32826 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932827Ab0BCUlV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 15:41:21 -0500
Message-ID: <4B69DF51.4020704@arcor.de>
Date: Wed, 03 Feb 2010 21:40:49 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 15/15] -  tm6000 hack with different demodulator parameter
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de> <4B675B19.3080705@redhat.com> <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com> <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com> <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de> <4B69D8CC.2030008@arcor.de>
In-Reply-To: <4B69D8CC.2030008@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

--- a/drivers/staging/tm6000/hack.c
+++ b/drivers/staging/tm6000/hack.c
@@ -37,7 +37,6 @@ static inline int tm6000_snd_control_msg(struct
tm6000_core *dev, __u8 request,
 
 static int pseudo_zl10353_pll(struct tm6000_core *tm6000_dev, struct
dvb_frontend_parameters *p)
 {
-    int ret;
     u8 *data = kzalloc(50*sizeof(u8), GFP_KERNEL);
 
 printk(KERN_ALERT "should set frequency %u\n", p->frequency);
@@ -51,7 +50,7 @@ printk(KERN_ALERT "and bandwith %u\n",
p->u.ofdm.bandwidth);
     }
 
     // init ZL10353
-    data[0] = 0x0b;
+/*    data[0] = 0x0b;
     ret = tm6000_snd_control_msg(tm6000_dev, 0x10, 0x501e, 0x00, data,
0x1);
     msleep(15);
     data[0] = 0x80;
@@ -159,7 +158,7 @@ printk(KERN_ALERT "and bandwith %u\n",
p->u.ofdm.bandwidth);
             msleep(15);
             data[0] = 0x5a;
             ret = tm6000_snd_control_msg(tm6000_dev, 0x10, 0x651e,
0x00, data, 0x1);
-            msleep(15);
+            msleep(15)
             data[0] = 0xe9;
             ret = tm6000_snd_control_msg(tm6000_dev, 0x10, 0x661e,
0x00, data, 0x1);
             msleep(15);
@@ -189,7 +188,162 @@ printk(KERN_ALERT "and bandwith %u\n",
p->u.ofdm.bandwidth);
             msleep(15);
         break;
     }
-
+*/
+    switch(p->u.ofdm.bandwidth) {
+        case BANDWIDTH_8_MHZ:
+            data[0] = 0x03;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x501e,0,data,1);
+            msleep(40);
+            data[0] = 0x44;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x511e,0,data,1);
+            msleep(40);
+            data[0] = 0x40;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x551e,0,data,1);
+            msleep(40);
+            data[0] = 0x46;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x521e,0,data,1);
+            msleep(40);
+            data[0] = 0x15;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x531e,0,data,1);
+            msleep(40);
+            data[0] = 0x0f;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x541e,0,data,1);
+            msleep(40);
+            data[0] = 0x80;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x551e,0,data,1);
+            msleep(40);
+            data[0] = 0x01;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0xea1e,0,data,1);
+            msleep(40);
+            data[0] = 0x00;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0xea1e,0,data,1);
+            msleep(40);
+            data[0] = 0x8b;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x631e,0,data,1);
+            msleep(40);
+            data[0] = 0x75;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0xcc1e,0,data,1);
+            msleep(40);
+            data[0] = 0xe6; //0x19;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x6c1e,0,data,1);
+            msleep(40);
+            data[0] = 0x09; //0xf7;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x6d1e,0,data,1);
+            msleep(40);
+            data[0] = 0x67;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x651e,0,data,1);
+            msleep(40);
+            data[0] = 0xe5;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x661e,0,data,1);
+            msleep(40);
+            data[0] = 0x75;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x5c1e,0,data,1);
+            msleep(40);
+            data[0] = 0x17;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x5f1e,0,data,1);
+            msleep(40);
+            data[0] = 0x40;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x5e1e,0,data,1);
+            msleep(40);
+            data[0] = 0x01;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x701e,0,data,1);
+            msleep(40);
+            break;
+        case BANDWIDTH_7_MHZ:
+            data[0] = 0x03;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x501e,0,data,1);
+            msleep(40);
+            data[0] = 0x44;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x511e,0,data,1);
+            msleep(40);
+            data[0] = 0x40;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x551e,0,data,1);
+            msleep(40);
+            data[0] = 0x46;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x521e,0,data,1);
+            msleep(40);
+            data[0] = 0x15;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x531e,0,data,1);
+            msleep(40);
+            data[0] = 0x0f;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x541e,0,data,1);
+            msleep(40);
+            data[0] = 0x80;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x551e,0,data,1);
+            msleep(40);
+            data[0] = 0x01;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0xea1e,0,data,1);
+            msleep(40);
+            data[0] = 0x00;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0xea1e,0,data,1);
+            msleep(40);
+            data[0] = 0x83;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x631e,0,data,1);
+            msleep(40);
+            data[0] = 0xa3;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0xcc1e,0,data,1);
+            msleep(40);
+            data[0] = 0xe6; //0x19;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x6c1e,0,data,1);
+            msleep(40);
+            data[0] = 0x09; //0xf7;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x6d1e,0,data,1);
+            msleep(40);
+            data[0] = 0x5a;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x651e,0,data,1);
+            msleep(40);
+            data[0] = 0xe9;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x661e,0,data,1);
+            msleep(40);
+            data[0] = 0x86;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x5c1e,0,data,1);
+            msleep(40);
+            data[0] = 0x17;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x5f1e,0,data,1);
+            msleep(40);
+            data[0] = 0x40;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x5e1e,0,data,1);
+            msleep(40);
+            data[0] = 0x01;
+            tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x701e,0,data,1);
+            msleep(40);
+            break;
+        default:
+            printk(KERN_ALERT "tm6000: bandwidth not supported\n");
+    }
+   
+    tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x051f,0,data,2);
+    printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+    msleep(40);
+   
+    tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x051f,0,data,2);
+    printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+    msleep(40);
+   
+    tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x051f,0,data,2);
+    printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+    msleep(40);
+   
+    tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x051f,0,data,2);
+    printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+    msleep(40);
+   
+    tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x051f,0,data,2);
+    printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+    msleep(40);
+   
+    tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x0f1f,0,data,2);
+    printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+    msleep(40);
+   
+    tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x091f,0,data,2);
+    printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+    msleep(40);
+   
+    tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x0b1f,0,data,2);
+    printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+    msleep(40);
+   
     kfree(data);
 
     return 0;

-- 
Stefan Ringel <stefan.ringel@arcor.de>

