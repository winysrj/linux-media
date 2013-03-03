Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:63851 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab3CCThQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Mar 2013 14:37:16 -0500
Received: by mail-ee0-f51.google.com with SMTP id d17so3380060eek.24
        for <linux-media@vger.kernel.org>; Sun, 03 Mar 2013 11:37:15 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 09/11] em28xx: do not store eeprom content permanently
Date: Sun,  3 Mar 2013 20:37:42 +0100
Message-Id: <1362339464-3373-10-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1362339464-3373-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1362339464-3373-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We currently reserve an array of 256 bytes for the eeprom content in the device
struct. For eeproms with 16 bit address width it might even be necessary to
increase the buffer size further.

Having such a big chunk of memory reserved even if the device has no eeprom and
keeping it after it has already been processed seems to be a waste of memory.

Change the code to allocate + free the eeprom memory dynamically.
This also makes it possible to handle different dataset sizes depending on what
is stored/found in the eeprom.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    9 +++++++-
 drivers/media/usb/em28xx/em28xx-i2c.c   |   35 +++++++++++++++++++------------
 drivers/media/usb/em28xx/em28xx.h       |    2 +-
 3 Dateien geändert, 31 Zeilen hinzugefügt(+), 15 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index fa51f81..2e3d3ad 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2743,6 +2743,9 @@ static void em28xx_card_setup(struct em28xx *dev)
 	case EM2883_BOARD_HAUPPAUGE_WINTV_HVR_950:
 	{
 		struct tveeprom tv;
+
+		if (dev->eedata == NULL)
+			break;
 #if defined(CONFIG_MODULES) && defined(MODULE)
 		request_module("tveeprom");
 #endif
@@ -2796,7 +2799,7 @@ static void em28xx_card_setup(struct em28xx *dev)
 		em28xx_set_mode(dev, EM28XX_ANALOG_MODE);
 		break;
 
-/*
+		/*
 		 * The Dikom DK300 is detected as an Kworld VS-DVB-T 323UR.
 		 *
 		 * This occurs because they share identical USB vendor and
@@ -2831,6 +2834,10 @@ static void em28xx_card_setup(struct em28xx *dev)
 				"addresses)\n\n");
 	}
 
+	/* Free eeprom data memory */
+	kfree(dev->eedata);
+	dev->eedata = NULL;
+
 	/* Allow override tuner type by a module parameter */
 	if (tuner >= 0)
 		dev->tuner_type = tuner;
diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index a3e9547..dfbc22e 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -405,27 +405,33 @@ static int em28xx_i2c_read_block(struct em28xx *dev, u16 addr, bool addr_w16,
 	return len;
 }
 
-static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char *eedata, int len)
+static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char **eedata, int len)
 {
-	unsigned char buf, *p = eedata;
-	struct em28xx_eeprom *em_eeprom = (void *)eedata;
+	u8 buf, *data;
+	struct em28xx_eeprom *em_eeprom;
 	int i, err;
 
+	*eedata = NULL;
+
 	dev->i2c_client.addr = 0xa0 >> 1;
 
 	/* Check if board has eeprom */
 	err = i2c_master_recv(&dev->i2c_client, &buf, 0);
 	if (err < 0) {
 		em28xx_info("board has no eeprom\n");
-		memset(eedata, 0, len);
 		return -ENODEV;
 	}
 
+	data = kzalloc(len, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
 	/* Read EEPROM content */
 	err = em28xx_i2c_read_block(dev, 0x0000, dev->eeprom_addrwidth_16bit,
-				    len, p);
+				    len, data);
 	if (err != len) {
 		em28xx_errdev("failed to read eeprom (err=%d)\n", err);
+		kfree(data);
 		return err;
 	}
 
@@ -437,19 +443,19 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char *eedata, int len)
 			else
 				em28xx_info("i2c eeprom %02x:", i);
 		}
-		printk(" %02x", eedata[i]);
+		printk(" %02x", data[i]);
 		if (15 == (i % 16))
 			printk("\n");
 	}
 
 	if (dev->eeprom_addrwidth_16bit &&
-	    eedata[0] == 0x26 && eedata[3] == 0x00) {
+	    data[0] == 0x26 && data[3] == 0x00) {
 		/* new eeprom format; size 4-64kb */
-		dev->hash = em28xx_hash_mem(eedata, len, 32);
+		dev->hash = em28xx_hash_mem(data, len, 32);
 		em28xx_info("EEPROM hash = 0x%08lx\n", dev->hash);
 		em28xx_info("EEPROM info: boot page address = 0x%02x04, "
 			    "boot configuration = 0x%02x\n",
-			    eedata[1], eedata[2]);
+			    data[1], data[2]);
 		/* boot configuration (address 0x0002):
 		 * [0]   microcode download speed: 1 = 400 kHz; 0 = 100 kHz
 		 * [1]   always selects 12 kb RAM
@@ -467,13 +473,16 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char *eedata, int len)
 		 */
 
 		return 0;
-	} else if (em_eeprom->id[0] != 0x1a || em_eeprom->id[1] != 0xeb ||
-		   em_eeprom->id[2] != 0x67 || em_eeprom->id[3] != 0x95   ) {
+	} else if (data[0] != 0x1a || data[1] != 0xeb ||
+		   data[2] != 0x67 || data[3] != 0x95   ) {
 		em28xx_info("unknown eeprom format or eeprom corrupted !\n");
 		return -ENODEV;
 	}
 
-	dev->hash = em28xx_hash_mem(eedata, len, 32);
+	*eedata = data;
+	em_eeprom = (void *)eedata;
+
+	dev->hash = em28xx_hash_mem(data, len, 32);
 
 	em28xx_info("EEPROM ID = %02x %02x %02x %02x, EEPROM hash = 0x%08lx\n",
 		    em_eeprom->id[0], em_eeprom->id[1],
@@ -631,7 +640,7 @@ int em28xx_i2c_register(struct em28xx *dev)
 	dev->i2c_client = em28xx_client_template;
 	dev->i2c_client.adapter = &dev->i2c_adap;
 
-	retval = em28xx_i2c_eeprom(dev, dev->eedata, sizeof(dev->eedata));
+	retval = em28xx_i2c_eeprom(dev, &dev->eedata, 256);
 	if ((retval < 0) && (retval != -ENODEV)) {
 		em28xx_errdev("%s: em28xx_i2_eeprom failed! retval [%d]\n",
 			__func__, retval);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 139dfe5..77f600d 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -562,7 +562,7 @@ struct em28xx {
 	/* resources in use */
 	unsigned int resources;
 
-	unsigned char eedata[256];
+	u8 *eedata;	/* currently always 256 bytes */
 
 	/* Isoc control struct */
 	struct em28xx_dmaqueue vidq;
-- 
1.7.10.4

