Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:45332 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab3CZRh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 13:37:56 -0400
Received: by mail-bk0-f43.google.com with SMTP id jm19so3415228bkc.2
        for <linux-media@vger.kernel.org>; Tue, 26 Mar 2013 10:37:54 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v3 1/5] em28xx: add support for em25xx i2c bus B read/write/check device operations
Date: Tue, 26 Mar 2013 18:38:36 +0100
Message-Id: <1364319520-6628-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1364319520-6628-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1364319520-6628-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The webcam "SpeedLink VAD Laplace" (em2765 + ov2640) uses a special algorithm
for i2c communication with the sensor, which is connected to a second i2c bus.

We don't know yet how to find out which devices support/use it.
It's very likely used by all em25xx and em276x+ bridges.
Tests with other em28xx chips (em2820, em2882/em2883) show, that this
algorithm always succeeds there although no slave device is connected.

The algorithm likely also works for real i2c client devices (OV2640 uses SCCB),
because the Windows driver seems to use it for probing Samsung and Kodak
sensors.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    8 +-
 drivers/media/usb/em28xx/em28xx-i2c.c   |  236 ++++++++++++++++++++++++++-----
 drivers/media/usb/em28xx/em28xx.h       |   10 +-
 3 Dateien geändert, 212 Zeilen hinzugefügt(+), 42 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index cb7cdd3..033b6cb 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3139,15 +3139,19 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 	rt_mutex_init(&dev->i2c_bus_lock);
 
 	/* register i2c bus 0 */
-	retval = em28xx_i2c_register(dev, 0);
+	if (dev->board.is_em2800)
+		retval = em28xx_i2c_register(dev, 0, EM28XX_I2C_ALGO_EM2800);
+	else
+		retval = em28xx_i2c_register(dev, 0, EM28XX_I2C_ALGO_EM28XX);
 	if (retval < 0) {
 		em28xx_errdev("%s: em28xx_i2c_register bus 0 - error [%d]!\n",
 			__func__, retval);
 		goto unregister_dev;
 	}
 
+	/* register i2c bus 1 */
 	if (dev->def_i2c_bus) {
-		retval = em28xx_i2c_register(dev, 1);
+		retval = em28xx_i2c_register(dev, 1, EM28XX_I2C_ALGO_EM28XX);
 		if (retval < 0) {
 			em28xx_errdev("%s: em28xx_i2c_register bus 1 - error [%d]!\n",
 				__func__, retval);
diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 704f283..4851cc2 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -5,6 +5,7 @@
 		      Markus Rechberger <mrechberger@gmail.com>
 		      Mauro Carvalho Chehab <mchehab@infradead.org>
 		      Sascha Sommer <saschasommer@freenet.de>
+   Copyright (C) 2013 Frank Schäfer <fschaefer.oss@googlemail.com>
 
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -279,6 +280,183 @@ static int em28xx_i2c_check_for_device(struct em28xx *dev, u16 addr)
 }
 
 /*
+ * em25xx_bus_B_send_bytes
+ * write bytes to the i2c device
+ */
+static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
+				   u16 len)
+{
+	int ret;
+
+	if (len < 1 || len > 64)
+		return -EOPNOTSUPP;
+	/*
+	 * NOTE: limited by the USB ctrl message constraints
+	 * Zero length reads always succeed, even if no device is connected
+	 */
+
+	/* Set register and write value */
+	ret = dev->em28xx_write_regs_req(dev, 0x06, addr, buf, len);
+	if (ret != len) {
+		if (ret < 0) {
+			em28xx_warn("writing to i2c device at 0x%x failed (error=%i)\n",
+				    addr, ret);
+			return ret;
+		} else {
+			em28xx_warn("%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
+				    len, addr, ret);
+			return -EIO;
+		}
+	}
+	/* Check success */
+	ret = dev->em28xx_read_reg_req(dev, 0x08, 0x0000);
+	/*
+	 * NOTE: the only error we've seen so far is
+	 * 0x01 when the slave device is not present
+	 */
+	if (!ret)
+		return len;
+	else if (ret > 0)
+		return -ENODEV;
+
+	return ret;
+	/*
+	 * NOTE: With chip types (other chip IDs) which actually don't support
+	 * this operation, it seems to succeed ALWAYS ! (even if there is no
+	 * slave device or even no second i2c bus provided)
+	 */
+}
+
+/*
+ * em25xx_bus_B_recv_bytes
+ * read bytes from the i2c device
+ */
+static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
+				   u16 len)
+{
+	int ret;
+
+	if (len < 1 || len > 64)
+		return -EOPNOTSUPP;
+	/*
+	 * NOTE: limited by the USB ctrl message constraints
+	 * Zero length reads always succeed, even if no device is connected
+	 */
+
+	/* Read value */
+	ret = dev->em28xx_read_reg_req_len(dev, 0x06, addr, buf, len);
+	if (ret < 0) {
+		em28xx_warn("reading from i2c device at 0x%x failed (error=%i)\n",
+			    addr, ret);
+		return ret;
+	}
+	/*
+	 * NOTE: some devices with two i2c busses have the bad habit to return 0
+	 * bytes if we are on bus B AND there was no write attempt to the
+	 * specified slave address before AND no device is present at the
+	 * requested slave address.
+	 * Anyway, the next check will fail with -ENODEV in this case, so avoid
+	 * spamming the system log on device probing and do nothing here.
+	 */
+
+	/* Check success */
+	ret = dev->em28xx_read_reg_req(dev, 0x08, 0x0000);
+	/*
+	 * NOTE: the only error we've seen so far is
+	 * 0x01 when the slave device is not present
+	 */
+	if (!ret)
+		return len;
+	else if (ret > 0)
+		return -ENODEV;
+
+	return ret;
+	/*
+	 * NOTE: With chip types (other chip IDs) which actually don't support
+	 * this operation, it seems to succeed ALWAYS ! (even if there is no
+	 * slave device or even no second i2c bus provided)
+	 */
+}
+
+/*
+ * em25xx_bus_B_check_for_device()
+ * check if there is a i2c device at the supplied address
+ */
+static int em25xx_bus_B_check_for_device(struct em28xx *dev, u16 addr)
+{
+	u8 buf;
+	int ret;
+
+	ret = em25xx_bus_B_recv_bytes(dev, addr, &buf, 1);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+	/*
+	 * NOTE: With chips which do not support this operation,
+	 * it seems to succeed ALWAYS ! (even if no device connected)
+	 */
+}
+
+static inline int i2c_check_for_device(struct em28xx_i2c_bus *i2c_bus, u16 addr)
+{
+	struct em28xx *dev = i2c_bus->dev;
+	int rc = -EOPNOTSUPP;
+
+	if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM28XX)
+		rc = em28xx_i2c_check_for_device(dev, addr);
+	else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM2800)
+		rc = em2800_i2c_check_for_device(dev, addr);
+	else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B)
+		rc = em25xx_bus_B_check_for_device(dev, addr);
+	if (rc == -ENODEV) {
+		if (i2c_debug)
+			printk(" no device\n");
+	}
+	return rc;
+}
+
+static inline int i2c_recv_bytes(struct em28xx_i2c_bus *i2c_bus,
+				 struct i2c_msg msg)
+{
+	struct em28xx *dev = i2c_bus->dev;
+	u16 addr = msg.addr << 1;
+	int byte, rc = -EOPNOTSUPP;
+
+	if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM28XX)
+		rc = em28xx_i2c_recv_bytes(dev, addr, msg.buf, msg.len);
+	else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM2800)
+		rc = em2800_i2c_recv_bytes(dev, addr, msg.buf, msg.len);
+	else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B)
+		rc = em25xx_bus_B_recv_bytes(dev, addr, msg.buf, msg.len);
+	if (i2c_debug) {
+		for (byte = 0; byte < msg.len; byte++)
+			printk(" %02x", msg.buf[byte]);
+	}
+	return rc;
+}
+
+static inline int i2c_send_bytes(struct em28xx_i2c_bus *i2c_bus,
+				 struct i2c_msg msg, int stop)
+{
+	struct em28xx *dev = i2c_bus->dev;
+	u16 addr = msg.addr << 1;
+	int byte, rc = -EOPNOTSUPP;
+
+	if (i2c_debug) {
+		for (byte = 0; byte < msg.len; byte++)
+			printk(" %02x", msg.buf[byte]);
+	}
+	if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM28XX)
+		rc = em28xx_i2c_send_bytes(dev, addr, msg.buf, msg.len, stop);
+	else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM2800)
+		rc = em2800_i2c_send_bytes(dev, addr, msg.buf, msg.len);
+	else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B)
+		rc = em25xx_bus_B_send_bytes(dev, addr, msg.buf, msg.len);
+	return rc;
+}
+
+/*
  * em28xx_i2c_xfer()
  * the main i2c transfer function
  */
@@ -288,7 +466,7 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 	struct em28xx_i2c_bus *i2c_bus = i2c_adap->algo_data;
 	struct em28xx *dev = i2c_bus->dev;
 	unsigned bus = i2c_bus->bus;
-	int addr, rc, i, byte;
+	int addr, rc, i;
 	u8 reg;
 
 	rc = rt_mutex_trylock(&dev->i2c_bus_lock);
@@ -296,7 +474,8 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 		return rc;
 
 	/* Switch I2C bus if needed */
-	if (bus != dev->cur_i2c_bus) {
+	if (bus != dev->cur_i2c_bus &&
+	    i2c_bus->algo_type == EM28XX_I2C_ALGO_EM28XX) {
 		if (bus == 1)
 			reg = EM2874_I2C_SECONDARY_BUS_SELECT;
 		else
@@ -319,45 +498,17 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 			       i == num - 1 ? "stop" : "nonstop",
 			       addr, msgs[i].len);
 		if (!msgs[i].len) { /* no len: check only for device presence */
-			if (dev->board.is_em2800)
-				rc = em2800_i2c_check_for_device(dev, addr);
-			else
-				rc = em28xx_i2c_check_for_device(dev, addr);
+			rc = i2c_check_for_device(i2c_bus, addr);
 			if (rc == -ENODEV) {
-				if (i2c_debug)
-					printk(" no device\n");
 				rt_mutex_unlock(&dev->i2c_bus_lock);
 				return rc;
 			}
 		} else if (msgs[i].flags & I2C_M_RD) {
 			/* read bytes */
-			if (dev->board.is_em2800)
-				rc = em2800_i2c_recv_bytes(dev, addr,
-							   msgs[i].buf,
-							   msgs[i].len);
-			else
-				rc = em28xx_i2c_recv_bytes(dev, addr,
-							   msgs[i].buf,
-							   msgs[i].len);
-			if (i2c_debug) {
-				for (byte = 0; byte < msgs[i].len; byte++)
-					printk(" %02x", msgs[i].buf[byte]);
-			}
+			rc = i2c_recv_bytes(i2c_bus, msgs[i]);
 		} else {
 			/* write bytes */
-			if (i2c_debug) {
-				for (byte = 0; byte < msgs[i].len; byte++)
-					printk(" %02x", msgs[i].buf[byte]);
-			}
-			if (dev->board.is_em2800)
-				rc = em2800_i2c_send_bytes(dev, addr,
-							   msgs[i].buf,
-							   msgs[i].len);
-			else
-				rc = em28xx_i2c_send_bytes(dev, addr,
-							   msgs[i].buf,
-							   msgs[i].len,
-							   i == num - 1);
+			rc = i2c_send_bytes(i2c_bus, msgs[i], i == num - 1);
 		}
 		if (rc < 0) {
 			if (i2c_debug)
@@ -633,12 +784,17 @@ error:
 static u32 functionality(struct i2c_adapter *i2c_adap)
 {
 	struct em28xx_i2c_bus *i2c_bus = i2c_adap->algo_data;
-	struct em28xx *dev = i2c_bus->dev;
 
-	u32 func_flags = I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
-	if (dev->board.is_em2800)
-		func_flags &= ~I2C_FUNC_SMBUS_WRITE_BLOCK_DATA;
-	return func_flags;
+	if ((i2c_bus->algo_type == EM28XX_I2C_ALGO_EM28XX) ||
+	    (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B)) {
+		return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+	} else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM2800)  {
+		return (I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL) &
+			~I2C_FUNC_SMBUS_WRITE_BLOCK_DATA;
+	}
+
+	WARN(1, "Unknown i2c bus algorithm.\n");
+	return 0;
 }
 
 static struct i2c_algorithm em28xx_algo = {
@@ -712,7 +868,8 @@ void em28xx_do_i2c_scan(struct em28xx *dev, unsigned bus)
  * em28xx_i2c_register()
  * register i2c bus
  */
-int em28xx_i2c_register(struct em28xx *dev, unsigned bus)
+int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
+			enum em28xx_i2c_algo_type algo_type)
 {
 	int retval;
 
@@ -727,6 +884,7 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned bus)
 	strcpy(dev->i2c_adap[bus].name, dev->name);
 
 	dev->i2c_bus[bus].bus = bus;
+	dev->i2c_bus[bus].algo_type = algo_type;
 	dev->i2c_bus[bus].dev = dev;
 	dev->i2c_adap[bus].algo_data = &dev->i2c_bus[bus];
 	i2c_set_adapdata(&dev->i2c_adap[bus], &dev->v4l2_dev);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 4c667fd..aeee896 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -461,10 +461,17 @@ struct em28xx_fh {
 	enum v4l2_buf_type           type;
 };
 
+enum em28xx_i2c_algo_type {
+	EM28XX_I2C_ALGO_EM28XX = 0,
+	EM28XX_I2C_ALGO_EM2800,
+	EM28XX_I2C_ALGO_EM25XX_BUS_B,
+};
+
 struct em28xx_i2c_bus {
 	struct em28xx *dev;
 
 	unsigned bus;
+	enum em28xx_i2c_algo_type algo_type;
 };
 
 
@@ -651,7 +658,8 @@ struct em28xx_ops {
 
 /* Provided by em28xx-i2c.c */
 void em28xx_do_i2c_scan(struct em28xx *dev, unsigned bus);
-int  em28xx_i2c_register(struct em28xx *dev, unsigned bus);
+int  em28xx_i2c_register(struct em28xx *dev, unsigned bus,
+			 enum em28xx_i2c_algo_type algo_type);
 int  em28xx_i2c_unregister(struct em28xx *dev, unsigned bus);
 
 /* Provided by em28xx-core.c */
-- 
1.7.10.4

