Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54480 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab3CXS5Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Mar 2013 14:57:16 -0400
Received: by mail-ee0-f46.google.com with SMTP id e49so2870252eek.19
        for <linux-media@vger.kernel.org>; Sun, 24 Mar 2013 11:57:14 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx-i2c: do not break strings across lines
Date: Sun, 24 Mar 2013 19:58:03 +0100
Message-Id: <1364151483-14379-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c |   45 +++++++++++++++------------------
 1 Datei geändert, 20 Zeilen hinzugefügt(+), 25 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 9e2fa41..db40835 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -68,8 +68,8 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 	/* trigger write */
 	ret = dev->em28xx_write_regs(dev, 4 - len, &b2[4 - len], 2 + len);
 	if (ret != 2 + len) {
-		em28xx_warn("failed to trigger write to i2c address 0x%x "
-			    "(error=%i)\n", addr, ret);
+		em28xx_warn("failed to trigger write to i2c address 0x%x (error=%i)\n",
+			    addr, ret);
 		return (ret < 0) ? ret : -EIO;
 	}
 	/* wait for completion */
@@ -81,8 +81,8 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 		} else if (ret == 0x94 + len - 1) {
 			return -ENODEV;
 		} else if (ret < 0) {
-			em28xx_warn("failed to get i2c transfer status from "
-				    "bridge register (error=%i)\n", ret);
+			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
+				    ret);
 			return ret;
 		}
 		msleep(5);
@@ -110,8 +110,8 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 	buf2[0] = addr;
 	ret = dev->em28xx_write_regs(dev, 0x04, buf2, 2);
 	if (ret != 2) {
-		em28xx_warn("failed to trigger read from i2c address 0x%x "
-			    "(error=%i)\n", addr, ret);
+		em28xx_warn("failed to trigger read from i2c address 0x%x (error=%i)\n",
+			    addr, ret);
 		return (ret < 0) ? ret : -EIO;
 	}
 
@@ -124,8 +124,8 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 		} else if (ret == 0x94 + len - 1) {
 			return -ENODEV;
 		} else if (ret < 0) {
-			em28xx_warn("failed to get i2c transfer status from "
-				    "bridge register (error=%i)\n", ret);
+			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
+				    ret);
 			return ret;
 		}
 		msleep(5);
@@ -136,9 +136,8 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 	/* get the received message */
 	ret = dev->em28xx_read_reg_req_len(dev, 0x00, 4-len, buf2, len);
 	if (ret != len) {
-		em28xx_warn("reading from i2c device at 0x%x failed: "
-			    "couldn't get the received message from the bridge "
-			    "(error=%i)\n", addr, ret);
+		em28xx_warn("reading from i2c device at 0x%x failed: couldn't get the received message from the bridge (error=%i)\n",
+			    addr, ret);
 		return (ret < 0) ? ret : -EIO;
 	}
 	for (i = 0; i < len; i++)
@@ -179,12 +178,11 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	ret = dev->em28xx_write_regs_req(dev, stop ? 2 : 3, addr, buf, len);
 	if (ret != len) {
 		if (ret < 0) {
-			em28xx_warn("writing to i2c device at 0x%x failed "
-				    "(error=%i)\n", addr, ret);
+			em28xx_warn("writing to i2c device at 0x%x failed (error=%i)\n",
+				    addr, ret);
 			return ret;
 		} else {
-			em28xx_warn("%i bytes write to i2c device at 0x%x "
-				    "requested, but %i bytes written\n",
+			em28xx_warn("%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
 				    len, addr, ret);
 			return -EIO;
 		}
@@ -199,8 +197,8 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		} else if (ret == 0x10) {
 			return -ENODEV;
 		} else if (ret < 0) {
-			em28xx_warn("failed to read i2c transfer status from "
-				    "bridge (error=%i)\n", ret);
+			em28xx_warn("failed to read i2c transfer status from bridge (error=%i)\n",
+				    ret);
 			return ret;
 		}
 		msleep(5);
@@ -243,8 +241,8 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 	/* Check success of the i2c operation */
 	ret = dev->em28xx_read_reg(dev, 0x05);
 	if (ret < 0) {
-		em28xx_warn("failed to read i2c transfer status from "
-			    "bridge (error=%i)\n", ret);
+		em28xx_warn("failed to read i2c transfer status from bridge (error=%i)\n",
+			    ret);
 		return ret;
 	}
 	if (ret > 0) {
@@ -494,12 +492,10 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 		dev->hash = em28xx_hash_mem(data, len, 32);
 		mc_start = (data[1] << 8) + 4;	/* usually 0x0004 */
 
-		em28xx_info("EEPROM ID = %02x %02x %02x %02x, "
-			    "EEPROM hash = 0x%08lx\n",
+		em28xx_info("EEPROM ID = %02x %02x %02x %02x, EEPROM hash = 0x%08lx\n",
 			    data[0], data[1], data[2], data[3], dev->hash);
 		em28xx_info("EEPROM info:\n");
-		em28xx_info("\tmicrocode start address = 0x%04x, "
-			    "boot configuration = 0x%02x\n",
+		em28xx_info("\tmicrocode start address = 0x%04x, boot configuration = 0x%02x\n",
 			    mc_start, data[2]);
 		/* boot configuration (address 0x0002):
 		 * [0]   microcode download speed: 1 = 400 kHz; 0 = 100 kHz
@@ -552,8 +548,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 		   data[0] == 0x1a && data[1] == 0xeb &&
 		   data[2] == 0x67 && data[3] == 0x95) {
 		dev->hash = em28xx_hash_mem(data, len, 32);
-		em28xx_info("EEPROM ID = %02x %02x %02x %02x, "
-			    "EEPROM hash = 0x%08lx\n",
+		em28xx_info("EEPROM ID = %02x %02x %02x %02x, EEPROM hash = 0x%08lx\n",
 			    data[0], data[1], data[2], data[3], dev->hash);
 		em28xx_info("EEPROM info:\n");
 	} else {
-- 
1.7.10.4

