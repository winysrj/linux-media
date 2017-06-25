Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:44750 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751359AbdFYVhY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 17:37:24 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH v2 4/7] [staging] cxd2099/cxd2099.c/.h: Fixed buffer mode
Date: Sun, 25 Jun 2017 23:37:08 +0200
Message-Id: <1498426631-17376-5-git-send-email-jasmin@anw.at>
In-Reply-To: <1498426631-17376-1-git-send-email-jasmin@anw.at>
References: <1498426631-17376-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ralph Metzler <rjkm@metzlerbros.de>

The buffer mode was already implemented in this driver, but it did not work
as expected. This has been fixed now, but it is still deactivated and can
be activated by removing a comment at the begin of the file.

Original code change by Ralph Metzler, modified by Jasmin Jessich and
Daniel Scheller to match Kernel code style.

Signed-off-by: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/pci/ddbridge/ddbridge-core.c |   1 +
 drivers/staging/media/cxd2099/cxd2099.c    | 162 +++++++++++++++++++++--------
 drivers/staging/media/cxd2099/cxd2099.h    |   6 +-
 3 files changed, 123 insertions(+), 46 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 32f4d37..cd1723e 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1305,6 +1305,7 @@ static struct cxd2099_cfg cxd_cfg = {
 	.adr     =  0x40,
 	.polarity = 1,
 	.clock_mode = 1,
+	.max_i2c = 512,
 };
 
 static int ddb_ci_attach(struct ddb_port *port)
diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
index 370ecb9..60d8dd0 100644
--- a/drivers/staging/media/cxd2099/cxd2099.c
+++ b/drivers/staging/media/cxd2099/cxd2099.c
@@ -1,7 +1,7 @@
 /*
  * cxd2099.c: Driver for the CXD2099AR Common Interface Controller
  *
- * Copyright (C) 2010-2011 Digital Devices GmbH
+ * Copyright (C) 2010-2013 Digital Devices GmbH
  *
  *
  * This program is free software; you can redistribute it and/or
@@ -33,7 +33,9 @@
 
 #include "cxd2099.h"
 
-#define MAX_BUFFER_SIZE 248
+/* #define BUFFER_MODE 1 */
+
+static int read_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount);
 
 struct cxd {
 	struct dvb_ca_en50221 en;
@@ -48,6 +50,7 @@ struct cxd {
 	int    mode;
 	int    ready;
 	int    dr;
+	int    write_busy;
 	int    slot_stat;
 
 	u8     amem[1024];
@@ -55,6 +58,9 @@ struct cxd {
 
 	int    cammode;
 	struct mutex lock;
+
+	u8     rbuf[1028];
+	u8     wbuf[1028];
 };
 
 static int i2c_write_reg(struct i2c_adapter *adapter, u8 adr,
@@ -73,7 +79,7 @@ static int i2c_write_reg(struct i2c_adapter *adapter, u8 adr,
 }
 
 static int i2c_write(struct i2c_adapter *adapter, u8 adr,
-		     u8 *data, u8 len)
+		     u8 *data, u16 len)
 {
 	struct i2c_msg msg = {.addr = adr, .flags = 0, .buf = data, .len = len};
 
@@ -100,12 +106,12 @@ static int i2c_read_reg(struct i2c_adapter *adapter, u8 adr,
 }
 
 static int i2c_read(struct i2c_adapter *adapter, u8 adr,
-		    u8 reg, u8 *data, u8 n)
+		    u8 reg, u8 *data, u16 n)
 {
 	struct i2c_msg msgs[2] = {{.addr = adr, .flags = 0,
-				 .buf = &reg, .len = 1},
-				{.addr = adr, .flags = I2C_M_RD,
-				 .buf = data, .len = n} };
+				   .buf = &reg, .len = 1},
+				  {.addr = adr, .flags = I2C_M_RD,
+				   .buf = data, .len = n} };
 
 	if (i2c_transfer(adapter, msgs, 2) != 2) {
 		dev_err(&adapter->dev, "error in i2c_read\n");
@@ -114,14 +120,26 @@ static int i2c_read(struct i2c_adapter *adapter, u8 adr,
 	return 0;
 }
 
-static int read_block(struct cxd *ci, u8 adr, u8 *data, u8 n)
+static int read_block(struct cxd *ci, u8 adr, u8 *data, u16 n)
 {
-	int status;
+	int status = 0;
 
-	status = i2c_write_reg(ci->i2c, ci->cfg.adr, 0, adr);
+	if (ci->lastaddress != adr)
+		status = i2c_write_reg(ci->i2c, ci->cfg.adr, 0, adr);
 	if (!status) {
 		ci->lastaddress = adr;
-		status = i2c_read(ci->i2c, ci->cfg.adr, 1, data, n);
+
+		while (n) {
+			int len = n;
+
+			if (ci->cfg.max_i2c && (len > ci->cfg.max_i2c))
+				len = ci->cfg.max_i2c;
+			status = i2c_read(ci->i2c, ci->cfg.adr, 1, data, len);
+			if (status)
+				return status;
+			data += len;
+			n -= len;
+		}
 	}
 	return status;
 }
@@ -182,16 +200,16 @@ static int write_io(struct cxd *ci, u16 address, u8 val)
 
 static int write_regm(struct cxd *ci, u8 reg, u8 val, u8 mask)
 {
-	int status;
+	int status = 0;
 
-	status = i2c_write_reg(ci->i2c, ci->cfg.adr, 0, reg);
+	if (ci->lastaddress != reg)
+		status = i2c_write_reg(ci->i2c, ci->cfg.adr, 0, reg);
 	if (!status && reg >= 6 && reg <= 8 && mask != 0xff)
 		status = i2c_read_reg(ci->i2c, ci->cfg.adr, 1, &ci->regs[reg]);
+	ci->lastaddress = reg;
 	ci->regs[reg] = (ci->regs[reg] & (~mask)) | val;
-	if (!status) {
-		ci->lastaddress = reg;
+	if (!status)
 		status = i2c_write_reg(ci->i2c, ci->cfg.adr, 1, ci->regs[reg]);
-	}
 	if (reg == 0x20)
 		ci->regs[reg] &= 0x7f;
 	return status;
@@ -203,16 +221,31 @@ static int write_reg(struct cxd *ci, u8 reg, u8 val)
 }
 
 #ifdef BUFFER_MODE
-static int write_block(struct cxd *ci, u8 adr, u8 *data, int n)
+static int write_block(struct cxd *ci, u8 adr, u8 *data, u16 n)
 {
-	int status;
-	u8 buf[256] = {1};
-
-	status = i2c_write_reg(ci->i2c, ci->cfg.adr, 0, adr);
-	if (!status) {
-		ci->lastaddress = adr;
-		memcpy(buf + 1, data, n);
-		status = i2c_write(ci->i2c, ci->cfg.adr, buf, n + 1);
+	int status = 0;
+	u8 *buf = ci->wbuf;
+
+	if (ci->lastaddress != adr)
+		status = i2c_write_reg(ci->i2c, ci->cfg.adr, 0, adr);
+	if (status)
+		return status;
+	dev_info(&ci->i2c->dev, "write_block %d\n", n);
+
+	ci->lastaddress = adr;
+	buf[0] = 1;
+	while (n) {
+		int len = n;
+
+		if (ci->cfg.max_i2c && (len + 1 > ci->cfg.max_i2c))
+			len = ci->cfg.max_i2c - 1;
+		dev_info(&ci->i2c->dev, "write %d\n", len);
+		memcpy(buf + 1, data, len);
+		status = i2c_write(ci->i2c, ci->cfg.adr, buf, len + 1);
+		if (status)
+			return status;
+		n -= len;
+		data += len;
 	}
 	return status;
 }
@@ -238,6 +271,8 @@ static void set_mode(struct cxd *ci, int mode)
 
 static void cam_mode(struct cxd *ci, int mode)
 {
+	u8 dummy;
+
 	if (mode == ci->cammode)
 		return;
 
@@ -246,16 +281,15 @@ static void cam_mode(struct cxd *ci, int mode)
 		write_regm(ci, 0x20, 0x80, 0x80);
 		break;
 	case 0x01:
-#ifdef BUFFER_MODE
 		if (!ci->en.read_data)
 			return;
+		ci->write_busy = 0;
 		dev_info(&ci->i2c->dev, "enable cam buffer mode\n");
-		/* write_reg(ci, 0x0d, 0x00); */
-		/* write_reg(ci, 0x0e, 0x01); */
+		write_reg(ci, 0x0d, 0x00);
+		write_reg(ci, 0x0e, 0x01);
 		write_regm(ci, 0x08, 0x40, 0x40);
-		/* read_reg(ci, 0x12, &dummy); */
+		read_reg(ci, 0x12, &dummy);
 		write_regm(ci, 0x08, 0x80, 0x80);
-#endif
 		break;
 	default:
 		break;
@@ -325,7 +359,10 @@ static int init(struct cxd *ci)
 		if (status < 0)
 			break;
 
-		if (ci->cfg.clock_mode) {
+		if (ci->cfg.clock_mode == 2) {
+			/* bitrate*2^13/ 72000 */
+			u32 reg = ((ci->cfg.bitrate << 13) + 71999) / 72000;
+
 			if (ci->cfg.polarity) {
 				status = write_reg(ci, 0x09, 0x6f);
 				if (status < 0)
@@ -335,6 +372,25 @@ static int init(struct cxd *ci)
 				if (status < 0)
 					break;
 			}
+			status = write_reg(ci, 0x20, 0x08);
+			if (status < 0)
+				break;
+			status = write_reg(ci, 0x21, (reg >> 8) & 0xff);
+			if (status < 0)
+				break;
+			status = write_reg(ci, 0x22, reg & 0xff);
+			if (status < 0)
+				break;
+		} else if (ci->cfg.clock_mode == 1) {
+			if (ci->cfg.polarity) {
+				status = write_reg(ci, 0x09, 0x6f); /* D */
+				if (status < 0)
+					break;
+			} else {
+				status = write_reg(ci, 0x09, 0x6d);
+				if (status < 0)
+					break;
+			}
 			status = write_reg(ci, 0x20, 0x68);
 			if (status < 0)
 				break;
@@ -346,7 +402,7 @@ static int init(struct cxd *ci)
 				break;
 		} else {
 			if (ci->cfg.polarity) {
-				status = write_reg(ci, 0x09, 0x4f);
+				status = write_reg(ci, 0x09, 0x4f); /* C */
 				if (status < 0)
 					break;
 			} else {
@@ -354,7 +410,6 @@ static int init(struct cxd *ci)
 				if (status < 0)
 					break;
 			}
-
 			status = write_reg(ci, 0x20, 0x28);
 			if (status < 0)
 				break;
@@ -401,7 +456,6 @@ static int read_attribute_mem(struct dvb_ca_en50221 *ca,
 	set_mode(ci, 1);
 	read_pccard(ci, address, &val, 1);
 	mutex_unlock(&ci->lock);
-	/* printk(KERN_INFO "%02x:%02x\n", address,val); */
 	return val;
 }
 
@@ -446,6 +500,9 @@ static int slot_reset(struct dvb_ca_en50221 *ca, int slot)
 {
 	struct cxd *ci = ca->data;
 
+	if (ci->cammode)
+		read_data(ca, slot, ci->rbuf, 0);
+
 	mutex_lock(&ci->lock);
 	cam_mode(ci, 0);
 	write_reg(ci, 0x00, 0x21);
@@ -465,7 +522,6 @@ static int slot_reset(struct dvb_ca_en50221 *ca, int slot)
 		}
 	}
 	mutex_unlock(&ci->lock);
-	/* msleep(500); */
 	return 0;
 }
 
@@ -474,11 +530,19 @@ static int slot_shutdown(struct dvb_ca_en50221 *ca, int slot)
 	struct cxd *ci = ca->data;
 
 	dev_info(&ci->i2c->dev, "%s\n", __func__);
+	if (ci->cammode)
+		read_data(ca, slot, ci->rbuf, 0);
 	mutex_lock(&ci->lock);
+	write_reg(ci, 0x00, 0x21);
+	write_reg(ci, 0x06, 0x1F);
+	msleep(300);
+
 	write_regm(ci, 0x09, 0x08, 0x08);
 	write_regm(ci, 0x20, 0x80, 0x80); /* Reset CAM Mode */
 	write_regm(ci, 0x06, 0x07, 0x07); /* Clear IO Mode */
+
 	ci->mode = -1;
+	ci->write_busy = 0;
 	mutex_unlock(&ci->lock);
 	return 0;
 }
@@ -490,9 +554,7 @@ static int slot_ts_enable(struct dvb_ca_en50221 *ca, int slot)
 	mutex_lock(&ci->lock);
 	write_regm(ci, 0x09, 0x00, 0x08);
 	set_mode(ci, 0);
-#ifdef BUFFER_MODE
 	cam_mode(ci, 1);
-#endif
 	mutex_unlock(&ci->lock);
 	return 0;
 }
@@ -510,8 +572,10 @@ static int campoll(struct cxd *ci)
 		ci->dr = 1;
 		dev_info(&ci->i2c->dev, "DR\n");
 	}
-	if (istat & 0x20)
+	if (istat & 0x20) {
+		ci->write_busy = 0;
 		dev_info(&ci->i2c->dev, "WC\n");
+	}
 
 	if (istat & 2) {
 		u8 slotstat;
@@ -519,7 +583,8 @@ static int campoll(struct cxd *ci)
 		read_reg(ci, 0x01, &slotstat);
 		if (!(2 & slotstat)) {
 			if (!ci->slot_stat) {
-				ci->slot_stat = DVB_CA_EN50221_POLL_CAM_PRESENT;
+				ci->slot_stat |=
+					      DVB_CA_EN50221_POLL_CAM_PRESENT;
 				write_regm(ci, 0x03, 0x08, 0x08);
 			}
 
@@ -531,8 +596,8 @@ static int campoll(struct cxd *ci)
 				ci->ready = 0;
 			}
 		}
-		if (istat & 8 &&
-		    ci->slot_stat == DVB_CA_EN50221_POLL_CAM_PRESENT) {
+		if ((istat & 8) &&
+		    (ci->slot_stat == DVB_CA_EN50221_POLL_CAM_PRESENT)) {
 			ci->ready = 1;
 			ci->slot_stat |= DVB_CA_EN50221_POLL_CAM_READY;
 		}
@@ -553,7 +618,6 @@ static int poll_slot_status(struct dvb_ca_en50221 *ca, int slot, int open)
 	return ci->slot_stat;
 }
 
-#ifdef BUFFER_MODE
 static int read_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
 {
 	struct cxd *ci = ca->data;
@@ -571,23 +635,33 @@ static int read_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
 	mutex_lock(&ci->lock);
 	read_reg(ci, 0x0f, &msb);
 	read_reg(ci, 0x10, &lsb);
-	len = (msb << 8) | lsb;
+	len = ((u16)msb << 8) | lsb;
+	if (len > ecount || len < 2) {
+		/* read it anyway or cxd may hang */
+		read_block(ci, 0x12, ci->rbuf, len);
+		mutex_unlock(&ci->lock);
+		return -EIO;
+	}
 	read_block(ci, 0x12, ebuf, len);
 	ci->dr = 0;
 	mutex_unlock(&ci->lock);
-
 	return len;
 }
 
+#ifdef BUFFER_MODE
+
 static int write_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
 {
 	struct cxd *ci = ca->data;
 
+	if (ci->write_busy)
+		return -EAGAIN;
 	mutex_lock(&ci->lock);
 	dev_info(&ci->i2c->dev, "%s %d\n", __func__, ecount);
 	write_reg(ci, 0x0d, ecount >> 8);
 	write_reg(ci, 0x0e, ecount & 0xff);
 	write_block(ci, 0x11, ebuf, ecount);
+	ci->write_busy = 1;
 	mutex_unlock(&ci->lock);
 	return ecount;
 }
diff --git a/drivers/staging/media/cxd2099/cxd2099.h b/drivers/staging/media/cxd2099/cxd2099.h
index 0eb607c..f4b29b1 100644
--- a/drivers/staging/media/cxd2099/cxd2099.h
+++ b/drivers/staging/media/cxd2099/cxd2099.h
@@ -30,8 +30,10 @@
 struct cxd2099_cfg {
 	u32 bitrate;
 	u8  adr;
-	u8  polarity:1;
-	u8  clock_mode:1;
+	u8  polarity;
+	u8  clock_mode;
+
+	u32 max_i2c;
 };
 
 #if defined(CONFIG_DVB_CXD2099) || \
-- 
2.7.4
