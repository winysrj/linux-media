Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:51598 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750842Ab1GCRCv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 13:02:51 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 13/16] cxd2099: Update to latest version
Date: Sun, 3 Jul 2011 19:00:57 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201107031831.20378@orion.escape-edv.de>
In-Reply-To: <201107031831.20378@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107031900.59010@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Ralph Metzler <rmetzler@digitaldevices.de>

Import latest driver from ddbridge-0.6.1.tar.bz2.

Signed-off-by: Ralph Metzler <rmetzler@digitaldevices.de>
Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
---
 drivers/staging/cxd2099/cxd2099.c |  250 ++++++++++++++++++++++++-------------
 drivers/staging/cxd2099/cxd2099.h |   16 ++-
 2 files changed, 178 insertions(+), 88 deletions(-)

diff --git a/drivers/staging/cxd2099/cxd2099.c b/drivers/staging/cxd2099/cxd2099.c
index b49186c..803a592 100644
--- a/drivers/staging/cxd2099/cxd2099.c
+++ b/drivers/staging/cxd2099/cxd2099.c
@@ -1,7 +1,7 @@
 /*
  * cxd2099.c: Driver for the CXD2099AR Common Interface Controller
  *
- * Copyright (C) 2010 DigitalDevices UG
+ * Copyright (C) 2010-2011 Digital Devices GmbH
  *
  *
  * This program is free software; you can redistribute it and/or
@@ -42,13 +42,13 @@ struct cxd {
 	struct dvb_ca_en50221 en;
 
 	struct i2c_adapter *i2c;
-	u8     adr;
+	struct cxd2099_cfg cfg;
+
 	u8     regs[0x23];
 	u8     lastaddress;
 	u8     clk_reg_f;
 	u8     clk_reg_b;
 	int    mode;
-	u32    bitrate;
 	int    ready;
 	int    dr;
 	int    slot_stat;
@@ -64,7 +64,7 @@ static int i2c_write_reg(struct i2c_adapter *adapter, u8 adr,
 			 u8 reg, u8 data)
 {
 	u8 m[2] = {reg, data};
-	struct i2c_msg msg = {.addr = adr, .flags = 0, .buf = m, .len = 2};
+	struct i2c_msg msg = {.addr=adr, .flags=0, .buf=m, .len=2};
 
 	if (i2c_transfer(adapter, &msg, 1) != 1) {
 		printk(KERN_ERR "Failed to write to I2C register %02x@%02x!\n",
@@ -77,7 +77,7 @@ static int i2c_write_reg(struct i2c_adapter *adapter, u8 adr,
 static int i2c_write(struct i2c_adapter *adapter, u8 adr,
 		     u8 *data, u8 len)
 {
-	struct i2c_msg msg = {.addr = adr, .flags = 0, .buf = data, .len = len};
+	struct i2c_msg msg = {.addr=adr, .flags=0, .buf=data, .len=len};
 
 	if (i2c_transfer(adapter, &msg, 1) != 1) {
 		printk(KERN_ERR "Failed to write to I2C!\n");
@@ -90,9 +90,9 @@ static int i2c_read_reg(struct i2c_adapter *adapter, u8 adr,
 			u8 reg, u8 *val)
 {
 	struct i2c_msg msgs[2] = {{.addr = adr, .flags = 0,
-				   .buf = &reg, .len = 1 },
+				   .buf = &reg, .len = 1},
 				  {.addr = adr, .flags = I2C_M_RD,
-				   .buf = val, .len = 1 } };
+				   .buf = val, .len = 1}};
 
 	if (i2c_transfer(adapter, msgs, 2) != 2) {
 		printk(KERN_ERR "error in i2c_read_reg\n");
@@ -105,9 +105,9 @@ static int i2c_read(struct i2c_adapter *adapter, u8 adr,
 		    u8 reg, u8 *data, u8 n)
 {
 	struct i2c_msg msgs[2] = {{.addr = adr, .flags = 0,
-				   .buf = &reg, .len = 1 },
-				  {.addr = adr, .flags = I2C_M_RD,
-				   .buf = data, .len = n } };
+				 .buf = &reg, .len = 1},
+				{.addr = adr, .flags = I2C_M_RD,
+				 .buf = data, .len = n}};
 
 	if (i2c_transfer(adapter, msgs, 2) != 2) {
 		printk(KERN_ERR "error in i2c_read\n");
@@ -120,10 +120,10 @@ static int read_block(struct cxd *ci, u8 adr, u8 *data, u8 n)
 {
 	int status;
 
-	status = i2c_write_reg(ci->i2c, ci->adr, 0, adr);
+	status = i2c_write_reg(ci->i2c, ci->cfg.adr, 0, adr);
 	if (!status) {
 		ci->lastaddress = adr;
-		status = i2c_read(ci->i2c, ci->adr, 1, data, n);
+		status = i2c_read(ci->i2c, ci->cfg.adr, 1, data, n);
 	}
 	return status;
 }
@@ -137,24 +137,24 @@ static int read_reg(struct cxd *ci, u8 reg, u8 *val)
 static int read_pccard(struct cxd *ci, u16 address, u8 *data, u8 n)
 {
 	int status;
-	u8 addr[3] = { 2, address&0xff, address>>8 };
+	u8 addr[3] = {2, address & 0xff, address >> 8};
 
-	status = i2c_write(ci->i2c, ci->adr, addr, 3);
+	status=i2c_write(ci->i2c, ci->cfg.adr, addr, 3);
 	if (!status)
-		status = i2c_read(ci->i2c, ci->adr, 3, data, n);
+		status = i2c_read(ci->i2c, ci->cfg.adr, 3, data, n);
 	return status;
 }
 
 static int write_pccard(struct cxd *ci, u16 address, u8 *data, u8 n)
 {
 	int status;
-	u8 addr[3] = { 2, address&0xff, address>>8 };
+	u8 addr[3] = {2, address & 0xff, address >> 8};
 
-	status = i2c_write(ci->i2c, ci->adr, addr, 3);
+	status=i2c_write(ci->i2c, ci->cfg.adr, addr, 3);
 	if (!status) {
 		u8 buf[256] = {3};
 		memcpy(buf+1, data, n);
-		status = i2c_write(ci->i2c, ci->adr, buf, n+1);
+		status = i2c_write(ci->i2c, ci->cfg.adr, buf, n+1);
 	}
 	return status;
 }
@@ -162,39 +162,64 @@ static int write_pccard(struct cxd *ci, u16 address, u8 *data, u8 n)
 static int read_io(struct cxd *ci, u16 address, u8 *val)
 {
 	int status;
-	u8 addr[3] = { 2, address&0xff, address>>8 };
+	u8 addr[3] = {2, address & 0xff, address >> 8};
 
-	status = i2c_write(ci->i2c, ci->adr, addr, 3);
+	status = i2c_write(ci->i2c, ci->cfg.adr, addr, 3);
 	if (!status)
-		status = i2c_read(ci->i2c, ci->adr, 3, val, 1);
+		status = i2c_read(ci->i2c, ci->cfg.adr, 3, val, 1);
 	return status;
 }
 
 static int write_io(struct cxd *ci, u16 address, u8 val)
 {
 	int status;
-	u8 addr[3] = { 2, address&0xff, address>>8 };
-	u8 buf[2] = { 3, val };
+	u8 addr[3] = {2, address & 0xff, address >> 8};
+	u8 buf[2] = {3, val};
 
-	status = i2c_write(ci->i2c, ci->adr, addr, 3);
+	status = i2c_write(ci->i2c, ci->cfg.adr, addr, 3);
 	if (!status)
-		status = i2c_write(ci->i2c, ci->adr, buf, 2);
-
+		status = i2c_write(ci->i2c, ci->cfg.adr, buf, 2);
 	return status;
 }
 
+#if 0
+static int read_io_data(struct cxd *ci, u8 *data, u8 n)
+{
+	int status;
+	u8 addr[3] = { 2, 0, 0 };
+
+	status = i2c_write(ci->i2c, ci->cfg.adr, addr, 3);
+	if (!status)
+		status = i2c_read(ci->i2c, ci->cfg.adr, 3, data, n);
+	return 0;
+}
+
+static int write_io_data(struct cxd *ci, u8 *data, u8 n)
+{
+	int status;
+	u8 addr[3] = {2, 0, 0};
+
+	status = i2c_write(ci->i2c, ci->cfg.adr, addr, 3);
+	if (!status) {
+		u8 buf[256] = {3};
+		memcpy(buf+1, data, n);
+		status = i2c_write(ci->i2c, ci->cfg.adr, buf, n + 1);
+	}
+	return 0;
+}
+#endif
 
 static int write_regm(struct cxd *ci, u8 reg, u8 val, u8 mask)
 {
 	int status;
 
-	status = i2c_write_reg(ci->i2c, ci->adr, 0, reg);
-	if (!status && reg >= 6 && reg <= 8 && mask != 0xff)
-		status = i2c_read_reg(ci->i2c, ci->adr, 1, &ci->regs[reg]);
-	ci->regs[reg] = (ci->regs[reg]&(~mask))|val;
+	status=i2c_write_reg(ci->i2c, ci->cfg.adr, 0, reg);
+	if (!status && reg >= 6 && reg <=8 && mask != 0xff)
+		status = i2c_read_reg(ci->i2c, ci->cfg.adr, 1, &ci->regs[reg]);
+	ci->regs[reg] = (ci->regs[reg] & (~mask)) | val;
 	if (!status) {
 		ci->lastaddress = reg;
-		status = i2c_write_reg(ci->i2c, ci->adr, 1, ci->regs[reg]);
+		status = i2c_write_reg(ci->i2c, ci->cfg.adr, 1, ci->regs[reg]);
 	}
 	if (reg == 0x20)
 		ci->regs[reg] &= 0x7f;
@@ -212,11 +237,11 @@ static int write_block(struct cxd *ci, u8 adr, u8 *data, int n)
 	int status;
 	u8 buf[256] = {1};
 
-	status = i2c_write_reg(ci->i2c, ci->adr, 0, adr);
+	status = i2c_write_reg(ci->i2c, ci->cfg.adr, 0, adr);
 	if (!status) {
 		ci->lastaddress = adr;
-		memcpy(buf+1, data, n);
-		status = i2c_write(ci->i2c, ci->adr, buf, n+1);
+		memcpy(buf + 1, data, n);
+		status = i2c_write(ci->i2c, ci->cfg.adr, buf, n + 1);
 	}
 	return status;
 }
@@ -250,12 +275,16 @@ static void cam_mode(struct cxd *ci, int mode)
 		write_regm(ci, 0x20, 0x80, 0x80);
 		break;
 	case 0x01:
+#ifdef BUFFER_MODE
+		if (!ci->en.read_data)
+			return;
 		printk(KERN_INFO "enable cam buffer mode\n");
 		/* write_reg(ci, 0x0d, 0x00); */
 		/* write_reg(ci, 0x0e, 0x01); */
 		write_regm(ci, 0x08, 0x40, 0x40);
 		/* read_reg(ci, 0x12, &dummy); */
 		write_regm(ci, 0x08, 0x80, 0x80);
+#endif
 		break;
 	default:
 		break;
@@ -265,14 +294,14 @@ static void cam_mode(struct cxd *ci, int mode)
 
 
 
-#define CHK_ERROR(s) if ((status = s)) break
+#define CHK_ERROR(s) if( (status = s) ) break
 
 static int init(struct cxd *ci)
 {
 	int status;
 
 	mutex_lock(&ci->lock);
-	ci->mode = -1;
+	ci->mode=-1;
 	do {
 		CHK_ERROR(write_reg(ci, 0x00, 0x00));
 		CHK_ERROR(write_reg(ci, 0x01, 0x00));
@@ -284,53 +313,84 @@ static int init(struct cxd *ci)
 		CHK_ERROR(write_reg(ci, 0x08, 0x28));
 		CHK_ERROR(write_reg(ci, 0x14, 0x20));
 
-		CHK_ERROR(write_reg(ci, 0x09, 0x4D)); /* Input Mode C, BYPass Serial, TIVAL = low, MSB */
+		/* CHK_ERROR(write_reg(ci, 0x09, 0x4D));*/ /* Input Mode C, BYPass Serial, TIVAL = low, MSB */
 		CHK_ERROR(write_reg(ci, 0x0A, 0xA7)); /* TOSTRT = 8, Mode B (gated clock), falling Edge, Serial, POL=HIGH, MSB */
 
-		/* Sync detector */
 		CHK_ERROR(write_reg(ci, 0x0B, 0x33));
 		CHK_ERROR(write_reg(ci, 0x0C, 0x33));
 
 		CHK_ERROR(write_regm(ci, 0x14, 0x00, 0x0F));
 		CHK_ERROR(write_reg(ci, 0x15, ci->clk_reg_b));
 		CHK_ERROR(write_regm(ci, 0x16, 0x00, 0x0F));
-		CHK_ERROR(write_reg(ci, 0x17, ci->clk_reg_f));
+		CHK_ERROR(write_reg(ci, 0x17,ci->clk_reg_f));
 
-		CHK_ERROR(write_reg(ci, 0x20, 0x28)); /* Integer Divider, Falling Edge, Internal Sync, */
-		CHK_ERROR(write_reg(ci, 0x21, 0x00)); /* MCLKI = TICLK/8 */
-		CHK_ERROR(write_reg(ci, 0x22, 0x07)); /* MCLKI = TICLK/8 */
+		if (ci->cfg.clock_mode) {
+			if (ci->cfg.polarity) {
+				CHK_ERROR(write_reg(ci, 0x09, 0x6f));
+			} else {
+				CHK_ERROR(write_reg(ci, 0x09, 0x6d));
+			}
+			CHK_ERROR(write_reg(ci, 0x20, 0x68));
+			CHK_ERROR(write_reg(ci, 0x21, 0x00));
+			CHK_ERROR(write_reg(ci, 0x22, 0x02));
+		} else {
+			if (ci->cfg.polarity) {
+				CHK_ERROR(write_reg(ci, 0x09, 0x4f));
+			} else {
+				CHK_ERROR(write_reg(ci, 0x09, 0x4d));
+			}
 
+			CHK_ERROR(write_reg(ci, 0x20, 0x28));
+			CHK_ERROR(write_reg(ci, 0x21, 0x00));
+			CHK_ERROR(write_reg(ci, 0x22, 0x07));
+		}
 
-		CHK_ERROR(write_regm(ci, 0x20, 0x80, 0x80)); /* Reset CAM state machine */
+		CHK_ERROR(write_regm(ci, 0x20, 0x80, 0x80));
+		CHK_ERROR(write_regm(ci, 0x03, 0x02, 0x02));
+		CHK_ERROR(write_reg(ci, 0x01, 0x04));
+		CHK_ERROR(write_reg(ci, 0x00, 0x31));
 
-		CHK_ERROR(write_regm(ci, 0x03, 0x02, 02));  /* Enable IREQA Interrupt */
-		CHK_ERROR(write_reg(ci, 0x01, 0x04));  /* Enable CD Interrupt */
-		CHK_ERROR(write_reg(ci, 0x00, 0x31));  /* Enable TS1,Hot Swap,Slot A */
-		CHK_ERROR(write_regm(ci, 0x09, 0x08, 0x08));  /* Put TS in bypass */
-		ci->cammode = -1;
-#ifdef BUFFER_MODE
+		/* Put TS in bypass */
+		CHK_ERROR(write_regm(ci, 0x09, 0x08, 0x08));
+		ci->cammode=-1;
 		cam_mode(ci, 0);
-#endif
-	} while (0);
+	} while(0);
 	mutex_unlock(&ci->lock);
 
 	return 0;
 }
 
-
 static int read_attribute_mem(struct dvb_ca_en50221 *ca,
 			      int slot, int address)
 {
 	struct cxd *ci = ca->data;
+#if 0
+	if (ci->amem_read) {
+		if (address <=0 || address>1024)
+			return -EIO;
+		return ci->amem[address];
+	}
+
+	mutex_lock(&ci->lock);
+	write_regm(ci, 0x06, 0x00, 0x05);
+	read_pccard(ci, 0, &ci->amem[0], 128);
+	read_pccard(ci, 128, &ci->amem[0], 128);
+	read_pccard(ci, 256, &ci->amem[0], 128);
+	read_pccard(ci, 384, &ci->amem[0], 128);
+	write_regm(ci, 0x06, 0x05, 0x05);
+	mutex_unlock(&ci->lock);
+	return ci->amem[address];
+#else
 	u8 val;
 	mutex_lock(&ci->lock);
 	set_mode(ci, 1);
 	read_pccard(ci, address, &val, 1);
 	mutex_unlock(&ci->lock);
+	//printk("%02x:%02x\n", address,val);
 	return val;
+#endif
 }
 
-
 static int write_attribute_mem(struct dvb_ca_en50221 *ca, int slot,
 			       int address, u8 value)
 {
@@ -373,20 +433,41 @@ static int slot_reset(struct dvb_ca_en50221 *ca, int slot)
 	struct cxd *ci = ca->data;
 
 	mutex_lock(&ci->lock);
+#if 0
+	write_reg(ci, 0x00, 0x21);
+	write_reg(ci, 0x06, 0x1F);
+	write_reg(ci, 0x00, 0x31);
+#else
+#if 0
+	write_reg(ci, 0x06, 0x1F);
+	write_reg(ci, 0x06, 0x2F);
+#else
 	cam_mode(ci, 0);
 	write_reg(ci, 0x00, 0x21);
 	write_reg(ci, 0x06, 0x1F);
 	write_reg(ci, 0x00, 0x31);
 	write_regm(ci, 0x20, 0x80, 0x80);
 	write_reg(ci, 0x03, 0x02);
-	ci->ready = 0;
-	ci->mode = -1;
+	ci->ready=0;
+#endif
+#endif
+	ci->mode=-1;
 	{
 		int i;
-		for (i = 0; i < 100; i++) {
+#if 0
+		u8 val;
+#endif
+		for (i=0; i<100;i++) {
 			msleep(10);
+#if 0
+			read_reg(ci, 0x06,&val);
+			printk(KERN_INFO "%d:%02x\n", i, val);
+			if (!(val&0x10))
+				break;
+#else
 			if (ci->ready)
 				break;
+#endif
 		}
 	}
 	mutex_unlock(&ci->lock);
@@ -400,12 +481,12 @@ static int slot_shutdown(struct dvb_ca_en50221 *ca, int slot)
 
 	printk(KERN_INFO "slot_shutdown\n");
 	mutex_lock(&ci->lock);
-	/* write_regm(ci, 0x09, 0x08, 0x08); */
-	write_regm(ci, 0x20, 0x80, 0x80);
-	write_regm(ci, 0x06, 0x07, 0x07);
+	write_regm(ci, 0x09, 0x08, 0x08);
+	write_regm(ci, 0x20, 0x80, 0x80); /* Reset CAM Mode */
+	write_regm(ci, 0x06, 0x07, 0x07); /* Clear IO Mode */
 	ci->mode = -1;
 	mutex_unlock(&ci->lock);
-	return 0; /* shutdown(ci); */
+	return 0;
 }
 
 static int slot_ts_enable(struct dvb_ca_en50221 *ca, int slot)
@@ -433,7 +514,7 @@ static int campoll(struct cxd *ci)
 	write_reg(ci, 0x05, istat);
 
 	if (istat&0x40) {
-		ci->dr = 1;
+		ci->dr=1;
 		printk(KERN_INFO "DR\n");
 	}
 	if (istat&0x20)
@@ -445,22 +526,21 @@ static int campoll(struct cxd *ci)
 		read_reg(ci, 0x01, &slotstat);
 		if (!(2&slotstat)) {
 			if (!ci->slot_stat) {
-				ci->slot_stat |= DVB_CA_EN50221_POLL_CAM_PRESENT;
+				ci->slot_stat|=DVB_CA_EN50221_POLL_CAM_PRESENT;
 				write_regm(ci, 0x03, 0x08, 0x08);
 			}
 
 		} else {
 			if (ci->slot_stat) {
-				ci->slot_stat = 0;
+				ci->slot_stat=0;
 				write_regm(ci, 0x03, 0x00, 0x08);
 				printk(KERN_INFO "NO CAM\n");
-				ci->ready = 0;
+				ci->ready=0;
 			}
 		}
-		if (istat&8 && ci->slot_stat == DVB_CA_EN50221_POLL_CAM_PRESENT) {
-			ci->ready = 1;
-			ci->slot_stat |= DVB_CA_EN50221_POLL_CAM_READY;
-			printk(KERN_INFO "READY\n");
+		if (istat&8 && ci->slot_stat==DVB_CA_EN50221_POLL_CAM_PRESENT) {
+			ci->ready=1;
+			ci->slot_stat|=DVB_CA_EN50221_POLL_CAM_READY;
 		}
 	}
 	return 0;
@@ -481,7 +561,7 @@ static int poll_slot_status(struct dvb_ca_en50221 *ca, int slot, int open)
 }
 
 #ifdef BUFFER_MODE
-static int read_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
+static int read_data(struct dvb_ca_en50221* ca, int slot, u8 *ebuf, int ecount)
 {
 	struct cxd *ci = ca->data;
 	u8 msb, lsb;
@@ -498,20 +578,20 @@ static int read_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
 	mutex_lock(&ci->lock);
 	read_reg(ci, 0x0f, &msb);
 	read_reg(ci, 0x10, &lsb);
-	len = (msb<<8)|lsb;
+	len=(msb<<8)|lsb;
 	read_block(ci, 0x12, ebuf, len);
-	ci->dr = 0;
+	ci->dr=0;
 	mutex_unlock(&ci->lock);
 
 	return len;
 }
 
-static int write_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
+static int write_data(struct dvb_ca_en50221* ca, int slot, u8 * ebuf, int ecount)
 {
 	struct cxd *ci = ca->data;
 
 	mutex_lock(&ci->lock);
-	printk(KERN_INFO "write_data %d\n", ecount);
+	printk("write_data %d\n", ecount);
 	write_reg(ci, 0x0d, ecount>>8);
 	write_reg(ci, 0x0e, ecount&0xff);
 	write_block(ci, 0x11, ebuf, ecount);
@@ -536,15 +616,15 @@ static struct dvb_ca_en50221 en_templ = {
 
 };
 
-struct dvb_ca_en50221 *cxd2099_attach(u8 adr, void *priv,
+struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
+				      void *priv,
 				      struct i2c_adapter *i2c)
 {
 	struct cxd *ci = 0;
-	u32 bitrate = 62000000;
 	u8 val;
 
-	if (i2c_read_reg(i2c, adr, 0, &val) < 0) {
-		printk(KERN_ERR "No CXD2099 detected at %02x\n", adr);
+	if (i2c_read_reg(i2c, cfg->adr, 0, &val)<0) {
+		printk("No CXD2099 detected at %02x\n", cfg->adr);
 		return 0;
 	}
 
@@ -554,21 +634,21 @@ struct dvb_ca_en50221 *cxd2099_attach(u8 adr, void *priv,
 	memset(ci, 0, sizeof(*ci));
 
 	mutex_init(&ci->lock);
+	memcpy(&ci->cfg, cfg, sizeof(struct cxd2099_cfg));
 	ci->i2c = i2c;
-	ci->adr = adr;
-	ci->lastaddress = 0xff;
-	ci->clk_reg_b = 0x4a;
-	ci->clk_reg_f = 0x1b;
-	ci->bitrate = bitrate;
+	ci->lastaddress=0xff;
+	ci->clk_reg_b=0x4a;
+	ci->clk_reg_f=0x1b;
 
 	memcpy(&ci->en, &en_templ, sizeof(en_templ));
-	ci->en.data = ci;
+	ci->en.data=ci;
 	init(ci);
-	printk(KERN_INFO "Attached CXD2099AR at %02x\n", ci->adr);
+	printk(KERN_INFO "Attached CXD2099AR at %02x\n", ci->cfg.adr);
 	return &ci->en;
 }
+
 EXPORT_SYMBOL(cxd2099_attach);
 
 MODULE_DESCRIPTION("cxd2099");
-MODULE_AUTHOR("Ralph Metzler <rjkm@metzlerbros.de>");
+MODULE_AUTHOR("Ralph Metzler");
 MODULE_LICENSE("GPL");
diff --git a/drivers/staging/cxd2099/cxd2099.h b/drivers/staging/cxd2099/cxd2099.h
index bed54ff..cf26c93 100644
--- a/drivers/staging/cxd2099/cxd2099.h
+++ b/drivers/staging/cxd2099/cxd2099.h
@@ -1,7 +1,7 @@
 /*
  * cxd2099.h: Driver for the CXD2099AR Common Interface Controller
  *
- * Copyright (C) 2010 DigitalDevices UG
+ * Copyright (C) 2010-2011 Digital Devices GmbH
  *
  *
  * This program is free software; you can redistribute it and/or
@@ -27,11 +27,21 @@
 
 #include <dvb_ca_en50221.h>
 
+struct cxd2099_cfg {
+	u32 bitrate;
+	u8  adr;
+	u8  polarity : 1;
+	u8  clock_mode : 1;
+};
+
 #if defined(CONFIG_DVB_CXD2099) || \
         (defined(CONFIG_DVB_CXD2099_MODULE) && defined(MODULE))
-struct dvb_ca_en50221 *cxd2099_attach(u8 adr, void *priv, struct i2c_adapter *i2c);
+struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
+				      void *priv, struct i2c_adapter *i2c);
 #else
-static inline struct dvb_ca_en50221 *cxd2099_attach(u8 adr, void *priv, struct i2c_adapter *i2c)
+
+static inline struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
+					void *priv, struct i2c_adapter *i2c);
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
-- 
1.7.4.1

