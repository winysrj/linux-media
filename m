Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42755 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab2LNQ3D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 11:29:03 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so2052180eek.19
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2012 08:29:02 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, dheitmueller@kernellabs.com,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 3/5] em28xx: fix two severe bugs in function em2800_i2c_recv_bytes()
Date: Fri, 14 Dec 2012 17:28:51 +0100
Message-Id: <1355502533-25636-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1355502533-25636-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1355502533-25636-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Function em2800_i2c_recv_bytes() has 2 severe bugs:
1) It does not wait for the i2c read to complete before reading the received
   message content from the bridge registers
2) Reading more than 1 byte doesn't work

The former can result in data corruption, the latter always does.

The rewritten code also superseds the content of function
em2800_i2c_check_for_device().

Tested with device "Terratec Cinergy 200 USB".

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c |  104 ++++++++++++++++++---------------
 drivers/media/usb/em28xx/em28xx.h     |    2 +-
 2 Dateien geändert, 58 Zeilen hinzugefügt(+), 48 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index c508c12..940ff4d 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -73,12 +73,14 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 	if (len > 3)
 		b2[0] = buf[3];
 
+	/* trigger write */
 	ret = dev->em28xx_write_regs(dev, 4 - len, &b2[4 - len], 2 + len);
 	if (ret != 2 + len) {
 		em28xx_warn("writing to i2c device failed (error=%i)\n", ret);
 		return -EIO;
 	}
-	for (write_timeout = EM2800_I2C_WRITE_TIMEOUT; write_timeout > 0;
+	/* wait for completion */
+	for (write_timeout = EM2800_I2C_XFER_TIMEOUT; write_timeout > 0;
 	     write_timeout -= 5) {
 		ret = dev->em28xx_read_reg(dev, 0x05);
 		if (ret == 0x80 + len - 1)
@@ -90,66 +92,74 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 }
 
 /*
- * em2800_i2c_check_for_device()
- * check if there is a i2c_device at the supplied address
+ * em2800_i2c_recv_bytes()
+ * read up to 4 bytes from the em2800 i2c device
  */
-static int em2800_i2c_check_for_device(struct em28xx *dev, u8 addr)
+static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 {
-	u8 msg;
+	u8 buf2[4];
 	int ret;
-	int write_timeout;
-	msg = addr;
-	ret = dev->em28xx_write_regs(dev, 0x04, &msg, 1);
-	if (ret < 0) {
-		em28xx_warn("setting i2c device address failed (error=%i)\n",
-			    ret);
-		return ret;
-	}
-	msg = 0x84;
-	ret = dev->em28xx_write_regs(dev, 0x05, &msg, 1);
-	if (ret < 0) {
-		em28xx_warn("preparing i2c read failed (error=%i)\n", ret);
-		return ret;
+	int read_timeout;
+	int i;
+
+	if (len < 1 || len > 4)
+		return -EOPNOTSUPP;
+
+	/* trigger read */
+	buf2[1] = 0x84 + len - 1;
+	buf2[0] = addr;
+	ret = dev->em28xx_write_regs(dev, 0x04, buf2, 2);
+	if (ret != 2) {
+		em28xx_warn("failed to trigger read from i2c address 0x%x "
+			    "(error=%i)\n", addr, ret);
+		return (ret < 0) ? ret : -EIO;
 	}
-	for (write_timeout = EM2800_I2C_WRITE_TIMEOUT; write_timeout > 0;
-	     write_timeout -= 5) {
-		unsigned reg = dev->em28xx_read_reg(dev, 0x5);
 
-		if (reg == 0x94)
+	/* wait for completion */
+	for (read_timeout = EM2800_I2C_XFER_TIMEOUT; read_timeout > 0;
+	     read_timeout -= 5) {
+		ret = dev->em28xx_read_reg(dev, 0x05);
+		if (ret == 0x84 + len - 1) {
+			break;
+		} else if (ret == 0x94 + len - 1) {
 			return -ENODEV;
-		else if (reg == 0x84)
-			return 0;
+		} else if (ret < 0) {
+			em28xx_warn("failed to get i2c transfer status from "
+				    "bridge register (error=%i)\n", ret);
+			return ret;
+		}
 		msleep(5);
 	}
-	return -ENODEV;
+	if (ret != 0x84 + len - 1)
+		em28xx_warn("read from i2c device at 0x%x timed out\n", addr);
+
+	/* get the received message */
+	ret = dev->em28xx_read_reg_req_len(dev, 0x00, 4-len, buf2, len);
+	if (ret != len) {
+		em28xx_warn("reading from i2c device at 0x%x failed: "
+			    "couldn't get the received message from the bridge "
+			    "(error=%i)\n", addr, ret);
+		return (ret < 0) ? ret : -EIO;
+	}
+	for (i=0; i<len; i++)
+		buf[i] = buf2[len-1-i];
+
+	return ret;
 }
 
 /*
- * em2800_i2c_recv_bytes()
- * read from the i2c device
+ * em2800_i2c_check_for_device()
+ * check if there is an i2c device at the supplied address
  */
-static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
+static int em2800_i2c_check_for_device(struct em28xx *dev, u8 addr)
 {
+	u8 buf;
 	int ret;
 
-	if (len < 1 || len > 4)
-		return -EOPNOTSUPP;
-
-	/* check for the device and set i2c read address */
-	ret = em2800_i2c_check_for_device(dev, addr);
-	if (ret) {
-		em28xx_warn
-		    ("preparing read at i2c address 0x%x failed (error=%i)\n",
-		     addr, ret);
-		return ret;
-	}
-	ret = dev->em28xx_read_reg_req_len(dev, 0x0, 0x3, buf, len);
-	if (ret < 0) {
-		em28xx_warn("reading from i2c device at 0x%x failed (error=%i)",
-			    addr, ret);
-		return ret;
-	}
-	return ret;
+	ret = em2800_i2c_recv_bytes(dev, addr, &buf, 1);
+	if (ret == 1)
+		return 0;
+	return (ret < 0) ? ret : -EIO;
 }
 
 /*
@@ -167,7 +177,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	wrcount = dev->em28xx_write_regs_req(dev, stop ? 2 : 3, addr, buf, len);
 
 	/* Seems to be required after a write */
-	for (write_timeout = EM2800_I2C_WRITE_TIMEOUT; write_timeout > 0;
+	for (write_timeout = EM2800_I2C_XFER_TIMEOUT; write_timeout > 0;
 	     write_timeout -= 5) {
 		ret = dev->em28xx_read_reg(dev, 0x05);
 		if (!ret)
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 062841e..dc89aaf 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -195,7 +195,7 @@
 */
 
 /* time in msecs to wait for i2c writes to finish */
-#define EM2800_I2C_WRITE_TIMEOUT 20
+#define EM2800_I2C_XFER_TIMEOUT		20
 
 enum em28xx_mode {
 	EM28XX_SUSPEND,
-- 
1.7.10.4

