Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:48648 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757867Ab0BCUTE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 15:19:04 -0500
Message-ID: <4B69DA18.8040201@arcor.de>
Date: Wed, 03 Feb 2010 21:18:32 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 5/15] -  tm6000 bugfix i2c transfer
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de> <4B675B19.3080705@redhat.com> <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com> <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com> <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de> <4B69D8CC.2030008@arcor.de>
In-Reply-To: <4B69D8CC.2030008@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -86,6 +86,11 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
                 msgs[i].len == 1 ? 0 : msgs[i].buf[1],
                 msgs[i + 1].buf, msgs[i + 1].len);
             i++;
+           
+            if ((dev->dev_type == TM6010) && (addr == 0xc2)) {
+                tm6000_set_reg(dev, 0x32, 0,0);
+                tm6000_set_reg(dev, 0x33, 0,0);
+            }
             if (i2c_debug >= 2)
                 for (byte = 0; byte < msgs[i].len; byte++)
                     printk(" %02x", msgs[i].buf[byte]);
@@ -99,6 +104,12 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
                 REQ_16_SET_GET_I2C_WR1_RDN,
                 addr | msgs[i].buf[0] << 8, 0,
                 msgs[i].buf + 1, msgs[i].len - 1);
+               
+           
+            if ((dev->dev_type == TM6010) && (addr == 0xc2)) {
+                tm6000_set_reg(dev, 0x32, 0,0);
+                tm6000_set_reg(dev, 0x33, 0,0);
+            }
         }
         if (i2c_debug >= 2)
             printk("\n");
@@ -198,7 +209,7 @@ static struct i2c_algorithm tm6000_algo = {
 
 static struct i2c_adapter tm6000_adap_template = {
     .owner = THIS_MODULE,
-    .class = I2C_CLASS_TV_ANALOG,
+    .class = I2C_CLASS_TV_ANALOG | I2C_CLASS_TV_DIGITAL,
     .name = "tm6000",
     .id = I2C_HW_B_TM6000,
     .algo = &tm6000_algo

-- 
Stefan Ringel <stefan.ringel@arcor.de>

