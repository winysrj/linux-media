Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab2AUQEn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:43 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4gNu023666
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:42 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 04/35] [media] az6007: Fix the I2C code in order to handle mt2063
Date: Sat, 21 Jan 2012 14:04:06 -0200
Message-Id: <1327161877-16784-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-4-git-send-email-mchehab@redhat.com>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
 <1327161877-16784-2-git-send-email-mchehab@redhat.com>
 <1327161877-16784-3-git-send-email-mchehab@redhat.com>
 <1327161877-16784-4-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

mt2063 uses a one-byte transfer. This requires a special handling
inside the i2c code. Fix it to properly accept i2c reads. This
is needed to make the mt2063 to be detected.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |   47 +++++++++++++++++++++++-------------
 1 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 6a21f92..56126d4 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -42,7 +42,7 @@ struct az6007_device_state {
 struct drxk_config terratec_h7_drxk = {
 	.adr = 0x29,
 	.single_master = 1,
-	.no_i2c_bridge = 1,
+	.no_i2c_bridge = 0,
 	.microcode_name = "dvb-usb-terratec-h5-drxk.fw",
 };
 
@@ -451,7 +451,6 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap,struct i2c_msg msgs[],int nu
 
 	for (i = 0; i < num; i++) {
 		addr = msgs[i].addr << 1;
-
 		if (((i + 1) < num)
 		    && (msgs[i].len == 1)
 		    && (!msgs[i].flags & I2C_M_RD)
@@ -462,44 +461,55 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap,struct i2c_msg msgs[],int nu
 			 * the first xfer has just 1 byte length.
 			 * Need to join both into one operation
 			 */
-			printk("az6007 I2C xfer write+read addr=0x%x len=%d/%d: ",
-				addr, msgs[i].len, msgs[i + 1].len);
+			if (dvb_usb_az6007_debug & 2)
+				printk(KERN_DEBUG
+				       "az6007 I2C xfer write+read addr=0x%x len=%d/%d: ",
+				       addr, msgs[i].len, msgs[i + 1].len);
 			req = 0xb9;
-			index = 0;
-			value = addr;
-			for (j = 0; j < msgs[i].len; j++)
-				data[j] = msgs[i].buf[j];
+			index = msgs[i].buf[0];
+			value = addr | (1 << 8);
 			length = 6 + msgs[i + 1].len;
 			len = msgs[i + 1].len;
 			ret = az6007_usb_in_op(d,req,value,index,data,length);
 			if (ret >= len) {
 				for (j = 0; j < len; j++) {
 					msgs[i + 1].buf[j] = data[j + 5];
-					printk("0x%02x ", msgs[i + 1].buf[j]);
+					if (dvb_usb_az6007_debug & 2)
+						printk(KERN_CONT
+						       "0x%02x ",
+						       msgs[i + 1].buf[j]);
 				}
 			} else
 				ret = -EIO;
 			i++;
 		} else if (!(msgs[i].flags & I2C_M_RD)) {
 			/* write bytes */
-//			printk("az6007 I2C xfer write addr=0x%x len=%d: ",
-//				 addr, msgs[i].len);
+			if (dvb_usb_az6007_debug & 2)
+				printk(KERN_DEBUG
+				       "az6007 I2C xfer write addr=0x%x len=%d: ",
+				       addr, msgs[i].len);
 			req = 0xbd;
 			index = msgs[i].buf[0];
 			value = addr | (1 << 8);
 			length = msgs[i].len - 1;
 			len = msgs[i].len - 1;
-//			printk("(0x%02x) ", msgs[i].buf[0]);
+			if (dvb_usb_az6007_debug & 2)
+				printk(KERN_CONT
+				       "(0x%02x) ", msgs[i].buf[0]);
 			for (j = 0; j < len; j++)
 			{
 				data[j] = msgs[i].buf[j + 1];
-//				printk("0x%02x ", data[j]);
+				if (dvb_usb_az6007_debug & 2)
+					printk(KERN_CONT
+					       "0x%02x ", data[j]);
 			}
 			ret = az6007_usb_out_op(d,req,value,index,data,length);
 		} else {
 			/* read bytes */
-//			printk("az6007 I2C xfer read addr=0x%x len=%d: ",
-//				 addr, msgs[i].len);
+			if (dvb_usb_az6007_debug & 2)
+				printk(KERN_DEBUG
+				       "az6007 I2C xfer read addr=0x%x len=%d: ",
+				       addr, msgs[i].len);
 			req = 0xb9;
 			index = msgs[i].buf[0];
 			value = addr;
@@ -509,10 +519,13 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap,struct i2c_msg msgs[],int nu
 			for (j = 0; j < len; j++)
 			{
 				msgs[i].buf[j] = data[j + 5];
-//				printk("0x%02x ", data[j + 5]);
+				if (dvb_usb_az6007_debug & 2)
+					printk(KERN_CONT
+					       "0x%02x ", data[j + 5]);
 			}
 		}
-//		printk("\n");
+		if (dvb_usb_az6007_debug & 2)
+			printk(KERN_CONT "\n");
 		if (ret < 0)
 			goto err;
 	}
-- 
1.7.8

