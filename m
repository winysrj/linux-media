Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:34389 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754272Ab0BCU1y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 15:27:54 -0500
Message-ID: <4B69DC2B.9090300@arcor.de>
Date: Wed, 03 Feb 2010 21:27:23 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 2/15] -  tm6000 add digital init for tm6010
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de> <4B675B19.3080705@redhat.com> <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com> <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com> <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de> <4B69D8CC.2030008@arcor.de>
In-Reply-To: <4B69D8CC.2030008@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -219,33 +219,53 @@ int tm6000_init_analog_mode (struct tm6000_core *dev)
 
 int tm6000_init_digital_mode (struct tm6000_core *dev)
 {
-	tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00ff, 0x08);
-	tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00ff, 0x00);
-	tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x003f, 0x01);
-	tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00df, 0x08);
-	tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00e2, 0x0c);
-	tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00e8, 0xff);
-	tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00eb, 0xd8);
-	tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00c0, 0x40);
-	tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00c1, 0xd0);
-	tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00c3, 0x09);
-	tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00da, 0x37);
-	tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00d1, 0xd8);
-	tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00d2, 0xc0);
-	tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00d6, 0x60);
-
-	tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00e2, 0x0c);
-	tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00e8, 0xff);
-	tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00eb, 0x08);
-	msleep(50);
-
-	tm6000_set_reg (dev, REQ_04_EN_DISABLE_MCU_INT, 0x0020, 0x00);
-	msleep(50);
-	tm6000_set_reg (dev, REQ_04_EN_DISABLE_MCU_INT, 0x0020, 0x01);
-	msleep(50);
-	tm6000_set_reg (dev, REQ_04_EN_DISABLE_MCU_INT, 0x0020, 0x00);
-	msleep(100);
-
+	if (dev->dev_type == TM6010) {
+		int val;
+		u8 buf[2];
+		
+		/* digital init */
+		val = tm6000_get_reg(dev, REQ_07_SET_GET_AVREG, 0xcc, 0);
+		val &= ~0x60;
+		tm6000_set_reg(dev, REQ_07_SET_GET_AVREG, 0xcc, val);
+		val = tm6000_get_reg(dev, REQ_07_SET_GET_AVREG, 0xc0, 0);
+		val |= 0x40;
+		tm6000_set_reg(dev, REQ_07_SET_GET_AVREG, 0xc0, val);
+		tm6000_set_reg(dev, REQ_07_SET_GET_AVREG, 0xfe, 0x28);
+		tm6000_set_reg(dev, REQ_08_SET_GET_AVREG_BIT, 0xe2, 0xfc);
+		tm6000_set_reg(dev, REQ_08_SET_GET_AVREG_BIT, 0xe6, 0xff);
+		tm6000_set_reg(dev, REQ_08_SET_GET_AVREG_BIT, 0xf1, 0xfe);
+		tm6000_read_write_usb (dev, 0xc0, 0x0e, 0x00c2, 0x0008, buf, 2);
+		printk (KERN_INFO "buf %#x %#x \n", buf[0], buf[1]);
+		
+
+	} else  {
+		tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00ff, 0x08);
+		tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00ff, 0x00);
+		tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x003f, 0x01);
+		tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00df, 0x08);
+		tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00e2, 0x0c);
+		tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00e8, 0xff);
+		tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00eb, 0xd8);
+		tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00c0, 0x40);
+		tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00c1, 0xd0);
+		tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00c3, 0x09);
+		tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00da, 0x37);
+		tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00d1, 0xd8);
+		tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00d2, 0xc0);
+		tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00d6, 0x60);
+
+		tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00e2, 0x0c);
+		tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00e8, 0xff);
+		tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00eb, 0x08);
+		msleep(50);
+
+		tm6000_set_reg (dev, REQ_04_EN_DISABLE_MCU_INT, 0x0020, 0x00);
+		msleep(50);
+		tm6000_set_reg (dev, REQ_04_EN_DISABLE_MCU_INT, 0x0020, 0x01);
+		msleep(50);
+		tm6000_set_reg (dev, REQ_04_EN_DISABLE_MCU_INT, 0x0020, 0x00);
+		msleep(100);
+	}
 	return 0;
 }
 

-- 
Stefan Ringel <stefan.ringel@arcor.de>

