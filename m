Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:36892 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933959Ab0BEWs4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 17:48:56 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 5/12] tm6000: update init table and sequence for tm6010
Date: Fri,  5 Feb 2010 23:48:10 +0100
Message-Id: <1265410096-11788-5-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1265410096-11788-4-git-send-email-stefan.ringel@arcor.de>
References: <1265410096-11788-1-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-2-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-3-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-4-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

---
 drivers/staging/tm6000/tm6000-core.c |  179 ++++++++++++++++++++++++----------
 1 files changed, 128 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 7ec13d5..a2e2af5 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -414,7 +414,15 @@ struct reg_init tm6010_init_tab[] = {
 	{ REQ_07_SET_GET_AVREG, 0x3f, 0x00 },
 
 	{ REQ_05_SET_GET_USBREG, 0x18, 0x00 },
-
+	
+	/* additional from Terratec Cinergy Hybrid XE */
+	{ REQ_07_SET_GET_AVREG, 0xdc, 0xaa },
+	{ REQ_07_SET_GET_AVREG, 0xdd, 0x30 },
+	{ REQ_07_SET_GET_AVREG, 0xde, 0x20 },
+	{ REQ_07_SET_GET_AVREG, 0xdf, 0xd0 },
+	{ REQ_04_EN_DISABLE_MCU_INT, 0x02, 0x00 },
+	{ REQ_07_SET_GET_AVREG, 0xd8, 0x2f },
+	
 	/* set remote wakeup key:any key wakeup */
 	{ REQ_07_SET_GET_AVREG,  0xe5,  0xfe },
 	{ REQ_07_SET_GET_AVREG,  0xda,  0xff },
@@ -424,6 +432,7 @@ int tm6000_init (struct tm6000_core *dev)
 {
 	int board, rc=0, i, size;
 	struct reg_init *tab;
+	u8 buf[40];
 
 	if (dev->dev_type == TM6010) {
 		tab = tm6010_init_tab;
@@ -444,61 +453,129 @@ int tm6000_init (struct tm6000_core *dev)
 		}
 	}
 
-	msleep(5); /* Just to be conservative */
-
-	/* Check board version - maybe 10Moons specific */
-	board=tm6000_get_reg16 (dev, 0x40, 0, 0);
-	if (board >=0) {
-		printk (KERN_INFO "Board version = 0x%04x\n",board);
-	} else {
-		printk (KERN_ERR "Error %i while retrieving board version\n",board);
-	}
-
+	/* hack */
 	if (dev->dev_type == TM6010) {
-		/* Turn xceive 3028 on */
-		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_3, 0x01);
-		msleep(11);
-	}
-
-	/* Reset GPIO1 and GPIO4. */
-	for (i=0; i< 2; i++) {
-		rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-					dev->tuner_reset_gpio, 0x00);
-		if (rc<0) {
-			printk (KERN_ERR "Error %i doing GPIO1 reset\n",rc);
-			return rc;
-		}
-
-		msleep(10); /* Just to be conservative */
-		rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-					dev->tuner_reset_gpio, 0x01);
-		if (rc<0) {
-			printk (KERN_ERR "Error %i doing GPIO1 reset\n",rc);
-			return rc;
-		}
-
-		msleep(10);
-		rc=tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_4, 0);
-		if (rc<0) {
-			printk (KERN_ERR "Error %i doing GPIO4 reset\n",rc);
-			return rc;
-		}
-
-		msleep(10);
-		rc=tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_4, 1);
-		if (rc<0) {
-			printk (KERN_ERR "Error %i doing GPIO4 reset\n",rc);
-			return rc;
-		}
-
-		if (!i) {
-			rc=tm6000_get_reg16(dev, 0x40,0,0);
-			if (rc>=0) {
-				printk ("board=%d\n", rc);
+		
+		msleep(15);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_4, 0);
+		msleep(15);
+				
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_1, 0);
+	
+		msleep(50);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_1, 1);
+		
+		msleep(15);
+		tm6000_read_write_usb (dev, 0xc0, 0x0e, 0x0010, 0x4400, buf, 2);
+		
+		msleep(15);
+		tm6000_read_write_usb (dev, 0xc0, 0x10, 0xf432, 0x0000, buf, 2);
+	
+		msleep(15);
+		buf[0] = 0x12;
+		buf[1] = 0x34;
+		tm6000_read_write_usb (dev, 0x40, 0x10, 0xf432, 0x0000, buf, 2);
+	
+		msleep(15);
+		tm6000_read_write_usb (dev, 0xc0, 0x10, 0xf432, 0x0000, buf, 2);
+	
+		msleep(15);
+		tm6000_read_write_usb (dev, 0xc0, 0x10, 0x0032, 0x0000, buf, 2);
+
+		msleep(15);
+		buf[0] = 0x00;
+		buf[1] = 0x01;
+		tm6000_read_write_usb (dev, 0x40, 0x10, 0xf332, 0x0000, buf, 2);
+	
+		msleep(15);
+		tm6000_read_write_usb (dev, 0xc0, 0x10, 0x00c0, 0x0000, buf, 39);
+	
+		msleep(15);
+		buf[0] = 0x00;
+		buf[1] = 0x00;
+		tm6000_read_write_usb (dev, 0x40, 0x10, 0xf332, 0x0000, buf, 2);
+	
+		msleep(15);
+		tm6000_read_write_usb (dev, 0xc0, 0x10, 0x7f1f, 0x0000, buf, 2);
+//		printk(KERN_INFO "buf %#x %#x \n", buf[0], buf [1]);
+		msleep(15);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_4, 1);
+		msleep(15);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+	    			TM6010_GPIO_0, 1);
+		msleep(15);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_7, 0);
+		msleep(15);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_5, 1);
+	
+		msleep(15);
+	
+		for (i=0; i< size; i++) {
+			rc= tm6000_set_reg (dev, tab[i].req, tab[i].reg, tab[i].val);
+			if (rc<0) {
+				printk (KERN_ERR "Error %i while setting req %d, "
+						 "reg %d to value %d\n", rc,
+						 tab[i].req,tab[i].reg, tab[i].val);
+				return rc;
 			}
 		}
+			
+		msleep(15);
+	
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_4, 0);
+		msleep(15);
+
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_1, 0);
+	
+		msleep(50);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_1, 1);
+		
+		msleep(15);
+		tm6000_read_write_usb (dev, 0xc0, 0x0e, 0x00c2, 0x0008, buf, 2);
+//		printk(KERN_INFO "buf %#x %#x \n", buf[0], buf[1]);
+		msleep(15);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_2, 1);
+		msleep(15);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_2, 0);
+		msleep(15);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_2, 1);
+		msleep(15);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_2, 1);
+		msleep(15);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_2, 0);
+		msleep(15);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_2, 1);
+		msleep(15);
 	}
+	/* hack end */
+	
+	msleep(5); /* Just to be conservative */
 
+	/* Check board version - maybe 10Moons specific */
+	if (dev->dev_type == TM5600) {
+		 board=tm6000_get_reg16 (dev, 0x40, 0, 0);
+		if (board >=0) {
+			printk (KERN_INFO "Board version = 0x%04x\n",board);
+		} else {
+			printk (KERN_ERR "Error %i while retrieving board version\n",board);
+		}
+	}
+	
 	msleep(50);
 
 	return 0;
-- 
1.6.4.2

