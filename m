Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60830 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab2LNQ3G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 11:29:06 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so2052213eek.19
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2012 08:29:05 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, dheitmueller@kernellabs.com,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 5/5] em28xx: fix+improve+unify i2c error handling, debug messages and code comments
Date: Fri, 14 Dec 2012 17:28:53 +0100
Message-Id: <1355502533-25636-6-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1355502533-25636-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1355502533-25636-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- check i2c slave address range (only 7 bit addresses supported)
- do not pass USB specific error codes to userspace/i2c-subsystem
- unify the returned error codes and make them compliant with
  the i2c subsystem spec
- check number of actually transferred bytes (via USB) everywehere
- fix/improve debug messages
- improve code comments

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-core.c |    5 +-
 drivers/media/usb/em28xx/em28xx-i2c.c  |  116 +++++++++++++++++++++++---------
 2 Dateien geändert, 89 Zeilen hinzugefügt(+), 32 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index c78d38b..cd808bf 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -101,7 +101,7 @@ int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
 		if (reg_debug)
 			printk(" failed!\n");
 		mutex_unlock(&dev->ctrl_urb_lock);
-		return ret;
+		return usb_translate_errors(ret);
 	}
 
 	if (len)
@@ -182,6 +182,9 @@ int em28xx_write_regs_req(struct em28xx *dev, u8 req, u16 reg, char *buf,
 			      0x0000, reg, dev->urb_buf, len, HZ);
 	mutex_unlock(&dev->ctrl_urb_lock);
 
+	if (ret < 0)
+		return usb_translate_errors(ret);
+
 	if (dev->wait_after_write)
 		msleep(dev->wait_after_write);
 
diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 7118535..508c3e1 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -76,18 +76,26 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 	/* trigger write */
 	ret = dev->em28xx_write_regs(dev, 4 - len, &b2[4 - len], 2 + len);
 	if (ret != 2 + len) {
-		em28xx_warn("writing to i2c device failed (error=%i)\n", ret);
-		return -EIO;
+		em28xx_warn("failed to trigger write to i2c address 0x%x "
+			    "(error=%i)\n", addr, ret);
+		return (ret < 0) ? ret : -EIO;
 	}
 	/* wait for completion */
 	for (write_timeout = EM2800_I2C_XFER_TIMEOUT; write_timeout > 0;
 	     write_timeout -= 5) {
 		ret = dev->em28xx_read_reg(dev, 0x05);
-		if (ret == 0x80 + len - 1)
+		if (ret == 0x80 + len - 1) {
 			return len;
+		} else if (ret == 0x94 + len - 1) {
+			return -ENODEV;
+		} else if (ret < 0) {
+			em28xx_warn("failed to get i2c transfer status from "
+				    "bridge register (error=%i)\n", ret);
+			return ret;
+		}
 		msleep(5);
 	}
-	em28xx_warn("i2c write timed out\n");
+	em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
 	return -EIO;
 }
 
@@ -168,24 +176,46 @@ static int em2800_i2c_check_for_device(struct em28xx *dev, u8 addr)
 static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 				 u16 len, int stop)
 {
-	int wrcount = 0;
 	int write_timeout, ret;
 
 	if (len < 1 || len > 64)
 		return -EOPNOTSUPP;
 
-	wrcount = dev->em28xx_write_regs_req(dev, stop ? 2 : 3, addr, buf, len);
+	/* Write to i2c device */
+	ret = dev->em28xx_write_regs_req(dev, stop ? 2 : 3, addr, buf, len);
+	if (ret != len) {
+		if (ret < 0) {
+			em28xx_warn("writing to i2c device at 0x%x failed "
+				    "(error=%i)\n", addr, ret);
+			return ret;
+		} else {
+			em28xx_warn("%i bytes write to i2c device at 0x%x "
+				    "requested, but %i bytes written\n",
+				    len, addr, ret);
+			return -EIO;
+		}
+	}
 
-	/* Seems to be required after a write */
+	/* Check success of the i2c operation */
 	for (write_timeout = EM2800_I2C_XFER_TIMEOUT; write_timeout > 0;
 	     write_timeout -= 5) {
 		ret = dev->em28xx_read_reg(dev, 0x05);
-		if (!ret)
-			break;
+		if (ret == 0) { /* success */
+			return len;
+		} else if (ret == 0x10) {
+			return -ENODEV;
+		} else if (ret < 0) {
+			em28xx_warn("failed to read i2c transfer status from "
+				    "bridge (error=%i)\n", ret);
+			return ret;
+		}
 		msleep(5);
+		/* NOTE: do we really have to wait for success ?
+		   Never seen anything else than 0x00 or 0x10
+		   (even with high payload) ...			*/
 	}
-
-	return wrcount;
+	em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
+	return -EIO;
 }
 
 /*
@@ -199,14 +229,37 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 	if (len < 1 || len > 64)
 		return -EOPNOTSUPP;
 
+	/* Read data from i2c device */
 	ret = dev->em28xx_read_reg_req_len(dev, 2, addr, buf, len);
+	if (ret != len) {
+		if (ret < 0) {
+			em28xx_warn("reading from i2c device at 0x%x failed "
+				    "(error=%i)\n", addr, ret);
+			return ret;
+		} else {
+			em28xx_warn("%i bytes requested from i2c device at "
+				    "0x%x, but %i bytes received\n",
+				    len, addr, ret);
+			return -EIO;
+		}
+	}
+
+	/* Check success of the i2c operation */
+	ret = dev->em28xx_read_reg(dev, 0x05);
 	if (ret < 0) {
-		em28xx_warn("reading i2c device failed (error=%i)\n", ret);
+		em28xx_warn("failed to read i2c transfer status from "
+			    "bridge (error=%i)\n", ret);
 		return ret;
 	}
-	if (dev->em28xx_read_reg(dev, 0x5) != 0)
-		return -ENODEV;
-	return ret;
+	if (ret > 0) {
+		if (ret == 0x10) {
+			return -ENODEV;
+		} else {
+			em28xx_warn("unknown i2c error (status=%i)\n", ret);
+			return -EIO;
+		}
+	}
+	return len;
 }
 
 /*
@@ -216,15 +269,12 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 static int em28xx_i2c_check_for_device(struct em28xx *dev, u16 addr)
 {
 	int ret;
+	u8 buf;
 
-	ret = dev->em28xx_read_reg_req(dev, 2, addr);
-	if (ret < 0) {
-		em28xx_warn("reading from i2c device failed (error=%i)\n", ret);
-		return ret;
-	}
-	if (dev->em28xx_read_reg(dev, 0x5) != 0)
-		return -ENODEV;
-	return 0;
+	ret = em28xx_i2c_recv_bytes(dev, addr, &buf, 1);
+	if (ret == 1)
+		return 0;
+	return (ret < 0) ? ret : -EIO;
 }
 
 /*
@@ -244,16 +294,20 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 		dprintk2(2, "%s %s addr=%x len=%d:",
 			 (msgs[i].flags & I2C_M_RD) ? "read" : "write",
 			 i == num - 1 ? "stop" : "nonstop", addr, msgs[i].len);
+		if (addr > 0xff) {
+			dprintk2(2, " ERROR: 10 bit addresses not supported\n");
+			return -EOPNOTSUPP;
+		}
 		if (!msgs[i].len) { /* no len: check only for device presence */
 			if (dev->board.is_em2800)
 				rc = em2800_i2c_check_for_device(dev, addr);
 			else
 				rc = em28xx_i2c_check_for_device(dev, addr);
-			if (rc < 0) {
-				dprintk2(2, " no device\n");
+			if (rc == -ENODEV) {
+				if (i2c_debug >= 2)
+					printk(" no device\n");
 				return rc;
 			}
-
 		} else if (msgs[i].flags & I2C_M_RD) {
 			/* read bytes */
 			if (dev->board.is_em2800)
@@ -284,16 +338,16 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 							   msgs[i].len,
 							   i == num - 1);
 		}
-		if (rc < 0)
-			goto err;
+		if (rc < 0) {
+			if (i2c_debug >= 2)
+				printk(" ERROR: %i\n", rc);
+			return rc;
+		}
 		if (i2c_debug >= 2)
 			printk("\n");
 	}
 
 	return num;
-err:
-	dprintk2(2, " ERROR: %i\n", rc);
-	return rc;
 }
 
 /* based on linux/sunrpc/svcauth.h and linux/hash.h
-- 
1.7.10.4

