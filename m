Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:51646 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751340Ab1GCRCv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 13:02:51 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 14/16] cxd2099: Codingstyle fixes
Date: Sun, 3 Jul 2011 19:02:24 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201107031831.20378@orion.escape-edv.de>
In-Reply-To: <201107031831.20378@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107031902.25443@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Codingstyle fixes.

Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
---
 drivers/staging/cxd2099/cxd2099.c |   75 ++++++++++++++++++-------------------
 drivers/staging/cxd2099/cxd2099.h |    6 +-
 2 files changed, 40 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/cxd2099/cxd2099.c b/drivers/staging/cxd2099/cxd2099.c
index 803a592..6ec30c1 100644
--- a/drivers/staging/cxd2099/cxd2099.c
+++ b/drivers/staging/cxd2099/cxd2099.c
@@ -64,7 +64,7 @@ static int i2c_write_reg(struct i2c_adapter *adapter, u8 adr,
 			 u8 reg, u8 data)
 {
 	u8 m[2] = {reg, data};
-	struct i2c_msg msg = {.addr=adr, .flags=0, .buf=m, .len=2};
+	struct i2c_msg msg = {.addr = adr, .flags = 0, .buf = m, .len = 2};
 
 	if (i2c_transfer(adapter, &msg, 1) != 1) {
 		printk(KERN_ERR "Failed to write to I2C register %02x@%02x!\n",
@@ -77,7 +77,7 @@ static int i2c_write_reg(struct i2c_adapter *adapter, u8 adr,
 static int i2c_write(struct i2c_adapter *adapter, u8 adr,
 		     u8 *data, u8 len)
 {
-	struct i2c_msg msg = {.addr=adr, .flags=0, .buf=data, .len=len};
+	struct i2c_msg msg = {.addr = adr, .flags = 0, .buf = data, .len = len};
 
 	if (i2c_transfer(adapter, &msg, 1) != 1) {
 		printk(KERN_ERR "Failed to write to I2C!\n");
@@ -92,7 +92,7 @@ static int i2c_read_reg(struct i2c_adapter *adapter, u8 adr,
 	struct i2c_msg msgs[2] = {{.addr = adr, .flags = 0,
 				   .buf = &reg, .len = 1},
 				  {.addr = adr, .flags = I2C_M_RD,
-				   .buf = val, .len = 1}};
+				   .buf = val, .len = 1} };
 
 	if (i2c_transfer(adapter, msgs, 2) != 2) {
 		printk(KERN_ERR "error in i2c_read_reg\n");
@@ -107,7 +107,7 @@ static int i2c_read(struct i2c_adapter *adapter, u8 adr,
 	struct i2c_msg msgs[2] = {{.addr = adr, .flags = 0,
 				 .buf = &reg, .len = 1},
 				{.addr = adr, .flags = I2C_M_RD,
-				 .buf = data, .len = n}};
+				 .buf = data, .len = n} };
 
 	if (i2c_transfer(adapter, msgs, 2) != 2) {
 		printk(KERN_ERR "error in i2c_read\n");
@@ -139,7 +139,7 @@ static int read_pccard(struct cxd *ci, u16 address, u8 *data, u8 n)
 	int status;
 	u8 addr[3] = {2, address & 0xff, address >> 8};
 
-	status=i2c_write(ci->i2c, ci->cfg.adr, addr, 3);
+	status = i2c_write(ci->i2c, ci->cfg.adr, addr, 3);
 	if (!status)
 		status = i2c_read(ci->i2c, ci->cfg.adr, 3, data, n);
 	return status;
@@ -150,7 +150,7 @@ static int write_pccard(struct cxd *ci, u16 address, u8 *data, u8 n)
 	int status;
 	u8 addr[3] = {2, address & 0xff, address >> 8};
 
-	status=i2c_write(ci->i2c, ci->cfg.adr, addr, 3);
+	status = i2c_write(ci->i2c, ci->cfg.adr, addr, 3);
 	if (!status) {
 		u8 buf[256] = {3};
 		memcpy(buf+1, data, n);
@@ -213,8 +213,8 @@ static int write_regm(struct cxd *ci, u8 reg, u8 val, u8 mask)
 {
 	int status;
 
-	status=i2c_write_reg(ci->i2c, ci->cfg.adr, 0, reg);
-	if (!status && reg >= 6 && reg <=8 && mask != 0xff)
+	status = i2c_write_reg(ci->i2c, ci->cfg.adr, 0, reg);
+	if (!status && reg >= 6 && reg <= 8 && mask != 0xff)
 		status = i2c_read_reg(ci->i2c, ci->cfg.adr, 1, &ci->regs[reg]);
 	ci->regs[reg] = (ci->regs[reg] & (~mask)) | val;
 	if (!status) {
@@ -294,14 +294,14 @@ static void cam_mode(struct cxd *ci, int mode)
 
 
 
-#define CHK_ERROR(s) if( (status = s) ) break
+#define CHK_ERROR(s) if ((status = s)) break
 
 static int init(struct cxd *ci)
 {
 	int status;
 
 	mutex_lock(&ci->lock);
-	ci->mode=-1;
+	ci->mode = -1;
 	do {
 		CHK_ERROR(write_reg(ci, 0x00, 0x00));
 		CHK_ERROR(write_reg(ci, 0x01, 0x00));
@@ -322,7 +322,7 @@ static int init(struct cxd *ci)
 		CHK_ERROR(write_regm(ci, 0x14, 0x00, 0x0F));
 		CHK_ERROR(write_reg(ci, 0x15, ci->clk_reg_b));
 		CHK_ERROR(write_regm(ci, 0x16, 0x00, 0x0F));
-		CHK_ERROR(write_reg(ci, 0x17,ci->clk_reg_f));
+		CHK_ERROR(write_reg(ci, 0x17, ci->clk_reg_f));
 
 		if (ci->cfg.clock_mode) {
 			if (ci->cfg.polarity) {
@@ -352,9 +352,9 @@ static int init(struct cxd *ci)
 
 		/* Put TS in bypass */
 		CHK_ERROR(write_regm(ci, 0x09, 0x08, 0x08));
-		ci->cammode=-1;
+		ci->cammode = -1;
 		cam_mode(ci, 0);
-	} while(0);
+	} while (0);
 	mutex_unlock(&ci->lock);
 
 	return 0;
@@ -366,7 +366,7 @@ static int read_attribute_mem(struct dvb_ca_en50221 *ca,
 	struct cxd *ci = ca->data;
 #if 0
 	if (ci->amem_read) {
-		if (address <=0 || address>1024)
+		if (address <= 0 || address > 1024)
 			return -EIO;
 		return ci->amem[address];
 	}
@@ -386,7 +386,7 @@ static int read_attribute_mem(struct dvb_ca_en50221 *ca,
 	set_mode(ci, 1);
 	read_pccard(ci, address, &val, 1);
 	mutex_unlock(&ci->lock);
-	//printk("%02x:%02x\n", address,val);
+	/* printk(KERN_INFO "%02x:%02x\n", address,val); */
 	return val;
 #endif
 }
@@ -448,19 +448,19 @@ static int slot_reset(struct dvb_ca_en50221 *ca, int slot)
 	write_reg(ci, 0x00, 0x31);
 	write_regm(ci, 0x20, 0x80, 0x80);
 	write_reg(ci, 0x03, 0x02);
-	ci->ready=0;
+	ci->ready = 0;
 #endif
 #endif
-	ci->mode=-1;
+	ci->mode = -1;
 	{
 		int i;
 #if 0
 		u8 val;
 #endif
-		for (i=0; i<100;i++) {
+		for (i = 0; i < 100; i++) {
 			msleep(10);
 #if 0
-			read_reg(ci, 0x06,&val);
+			read_reg(ci, 0x06, &val);
 			printk(KERN_INFO "%d:%02x\n", i, val);
 			if (!(val&0x10))
 				break;
@@ -514,7 +514,7 @@ static int campoll(struct cxd *ci)
 	write_reg(ci, 0x05, istat);
 
 	if (istat&0x40) {
-		ci->dr=1;
+		ci->dr = 1;
 		printk(KERN_INFO "DR\n");
 	}
 	if (istat&0x20)
@@ -526,21 +526,21 @@ static int campoll(struct cxd *ci)
 		read_reg(ci, 0x01, &slotstat);
 		if (!(2&slotstat)) {
 			if (!ci->slot_stat) {
-				ci->slot_stat|=DVB_CA_EN50221_POLL_CAM_PRESENT;
+				ci->slot_stat |= DVB_CA_EN50221_POLL_CAM_PRESENT;
 				write_regm(ci, 0x03, 0x08, 0x08);
 			}
 
 		} else {
 			if (ci->slot_stat) {
-				ci->slot_stat=0;
+				ci->slot_stat = 0;
 				write_regm(ci, 0x03, 0x00, 0x08);
 				printk(KERN_INFO "NO CAM\n");
-				ci->ready=0;
+				ci->ready = 0;
 			}
 		}
-		if (istat&8 && ci->slot_stat==DVB_CA_EN50221_POLL_CAM_PRESENT) {
-			ci->ready=1;
-			ci->slot_stat|=DVB_CA_EN50221_POLL_CAM_READY;
+		if (istat&8 && ci->slot_stat == DVB_CA_EN50221_POLL_CAM_PRESENT) {
+			ci->ready = 1;
+			ci->slot_stat |= DVB_CA_EN50221_POLL_CAM_READY;
 		}
 	}
 	return 0;
@@ -561,7 +561,7 @@ static int poll_slot_status(struct dvb_ca_en50221 *ca, int slot, int open)
 }
 
 #ifdef BUFFER_MODE
-static int read_data(struct dvb_ca_en50221* ca, int slot, u8 *ebuf, int ecount)
+static int read_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
 {
 	struct cxd *ci = ca->data;
 	u8 msb, lsb;
@@ -578,20 +578,20 @@ static int read_data(struct dvb_ca_en50221* ca, int slot, u8 *ebuf, int ecount)
 	mutex_lock(&ci->lock);
 	read_reg(ci, 0x0f, &msb);
 	read_reg(ci, 0x10, &lsb);
-	len=(msb<<8)|lsb;
+	len = (msb<<8)|lsb;
 	read_block(ci, 0x12, ebuf, len);
-	ci->dr=0;
+	ci->dr = 0;
 	mutex_unlock(&ci->lock);
 
 	return len;
 }
 
-static int write_data(struct dvb_ca_en50221* ca, int slot, u8 * ebuf, int ecount)
+static int write_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
 {
 	struct cxd *ci = ca->data;
 
 	mutex_lock(&ci->lock);
-	printk("write_data %d\n", ecount);
+	printk(kern_INFO "write_data %d\n", ecount);
 	write_reg(ci, 0x0d, ecount>>8);
 	write_reg(ci, 0x0e, ecount&0xff);
 	write_block(ci, 0x11, ebuf, ecount);
@@ -623,8 +623,8 @@ struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
 	struct cxd *ci = 0;
 	u8 val;
 
-	if (i2c_read_reg(i2c, cfg->adr, 0, &val)<0) {
-		printk("No CXD2099 detected at %02x\n", cfg->adr);
+	if (i2c_read_reg(i2c, cfg->adr, 0, &val) < 0) {
+		printk(KERN_INFO "No CXD2099 detected at %02x\n", cfg->adr);
 		return 0;
 	}
 
@@ -636,17 +636,16 @@ struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
 	mutex_init(&ci->lock);
 	memcpy(&ci->cfg, cfg, sizeof(struct cxd2099_cfg));
 	ci->i2c = i2c;
-	ci->lastaddress=0xff;
-	ci->clk_reg_b=0x4a;
-	ci->clk_reg_f=0x1b;
+	ci->lastaddress = 0xff;
+	ci->clk_reg_b = 0x4a;
+	ci->clk_reg_f = 0x1b;
 
 	memcpy(&ci->en, &en_templ, sizeof(en_templ));
-	ci->en.data=ci;
+	ci->en.data = ci;
 	init(ci);
 	printk(KERN_INFO "Attached CXD2099AR at %02x\n", ci->cfg.adr);
 	return &ci->en;
 }
-
 EXPORT_SYMBOL(cxd2099_attach);
 
 MODULE_DESCRIPTION("cxd2099");
diff --git a/drivers/staging/cxd2099/cxd2099.h b/drivers/staging/cxd2099/cxd2099.h
index cf26c93..75459d4 100644
--- a/drivers/staging/cxd2099/cxd2099.h
+++ b/drivers/staging/cxd2099/cxd2099.h
@@ -30,12 +30,12 @@
 struct cxd2099_cfg {
 	u32 bitrate;
 	u8  adr;
-	u8  polarity : 1;
-	u8  clock_mode : 1;
+	u8  polarity:1;
+	u8  clock_mode:1;
 };
 
 #if defined(CONFIG_DVB_CXD2099) || \
-        (defined(CONFIG_DVB_CXD2099_MODULE) && defined(MODULE))
+	(defined(CONFIG_DVB_CXD2099_MODULE) && defined(MODULE))
 struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
 				      void *priv, struct i2c_adapter *i2c);
 #else
-- 
1.7.4.1

