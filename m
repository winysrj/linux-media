Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:39285 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752054AbeBHTxZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Feb 2018 14:53:25 -0500
Received: by mail-wm0-f66.google.com with SMTP id b21so12203597wme.4
        for <linux-media@vger.kernel.org>; Thu, 08 Feb 2018 11:53:24 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at
Subject: [PATCH 2/7] [media] staging/cxd2099: convert to regmap API
Date: Thu,  8 Feb 2018 20:53:13 +0100
Message-Id: <20180208195318.612-3-d.scheller.oss@gmail.com>
In-Reply-To: <20180208195318.612-1-d.scheller.oss@gmail.com>
References: <20180208195318.612-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Convert the cxd2099 driver to use regmap for I2C accesses, removing all
own i2c_*() functions. With that, make the driver a proper I2C client
driver. This also adds the benefit of having a proper cleanup function
(cxd2099_remove() in this case) that takes care of resource cleanup
upon I2C client deregistration.

At this point, keep the static inline declared cxd2099_attach()
function so that drivers using the legacy/proprietary style attach way
still compile, albeit lacking the cxd2099 driver functionality. This
is taken care of in the next two patches.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/staging/media/cxd2099/cxd2099.c | 209 ++++++++++++++++----------------
 drivers/staging/media/cxd2099/cxd2099.h |  11 +-
 2 files changed, 108 insertions(+), 112 deletions(-)

diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
index dc9cbd8f2104..c0a5849b76bb 100644
--- a/drivers/staging/media/cxd2099/cxd2099.c
+++ b/drivers/staging/media/cxd2099/cxd2099.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
+#include <linux/regmap.h>
 #include <linux/wait.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
@@ -33,8 +34,9 @@ static int read_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount);
 struct cxd {
 	struct dvb_ca_en50221 en;
 
-	struct i2c_adapter *i2c;
 	struct cxd2099_cfg cfg;
+	struct i2c_client *client;
+	struct regmap *regmap;
 
 	u8     regs[0x23];
 	u8     lastaddress;
@@ -56,69 +58,12 @@ struct cxd {
 	u8     wbuf[1028];
 };
 
-static int i2c_write_reg(struct i2c_adapter *adapter, u8 adr,
-			 u8 reg, u8 data)
-{
-	u8 m[2] = {reg, data};
-	struct i2c_msg msg = {.addr = adr, .flags = 0, .buf = m, .len = 2};
-
-	if (i2c_transfer(adapter, &msg, 1) != 1) {
-		dev_err(&adapter->dev,
-			"Failed to write to I2C register %02x@%02x!\n",
-			reg, adr);
-		return -1;
-	}
-	return 0;
-}
-
-static int i2c_write(struct i2c_adapter *adapter, u8 adr,
-		     u8 *data, u16 len)
-{
-	struct i2c_msg msg = {.addr = adr, .flags = 0, .buf = data, .len = len};
-
-	if (i2c_transfer(adapter, &msg, 1) != 1) {
-		dev_err(&adapter->dev, "Failed to write to I2C!\n");
-		return -1;
-	}
-	return 0;
-}
-
-static int i2c_read_reg(struct i2c_adapter *adapter, u8 adr,
-			u8 reg, u8 *val)
-{
-	struct i2c_msg msgs[2] = {{.addr = adr, .flags = 0,
-				   .buf = &reg, .len = 1},
-				  {.addr = adr, .flags = I2C_M_RD,
-				   .buf = val, .len = 1} };
-
-	if (i2c_transfer(adapter, msgs, 2) != 2) {
-		dev_err(&adapter->dev, "error in %s()\n", __func__);
-		return -1;
-	}
-	return 0;
-}
-
-static int i2c_read(struct i2c_adapter *adapter, u8 adr,
-		    u8 reg, u8 *data, u16 n)
-{
-	struct i2c_msg msgs[2] = {{.addr = adr, .flags = 0,
-				   .buf = &reg, .len = 1},
-				  {.addr = adr, .flags = I2C_M_RD,
-				   .buf = data, .len = n} };
-
-	if (i2c_transfer(adapter, msgs, 2) != 2) {
-		dev_err(&adapter->dev, "error in %s()\n", __func__);
-		return -1;
-	}
-	return 0;
-}
-
 static int read_block(struct cxd *ci, u8 adr, u8 *data, u16 n)
 {
 	int status = 0;
 
 	if (ci->lastaddress != adr)
-		status = i2c_write_reg(ci->i2c, ci->cfg.adr, 0, adr);
+		status = regmap_write(ci->regmap, 0, adr);
 	if (!status) {
 		ci->lastaddress = adr;
 
@@ -127,7 +72,7 @@ static int read_block(struct cxd *ci, u8 adr, u8 *data, u16 n)
 
 			if (ci->cfg.max_i2c && len > ci->cfg.max_i2c)
 				len = ci->cfg.max_i2c;
-			status = i2c_read(ci->i2c, ci->cfg.adr, 1, data, len);
+			status = regmap_raw_read(ci->regmap, 1, data, len);
 			if (status)
 				return status;
 			data += len;
@@ -145,64 +90,66 @@ static int read_reg(struct cxd *ci, u8 reg, u8 *val)
 static int read_pccard(struct cxd *ci, u16 address, u8 *data, u8 n)
 {
 	int status;
-	u8 addr[3] = {2, address & 0xff, address >> 8};
+	u8 addr[2] = {address & 0xff, address >> 8};
 
-	status = i2c_write(ci->i2c, ci->cfg.adr, addr, 3);
+	status = regmap_raw_write(ci->regmap, 2, addr, 2);
 	if (!status)
-		status = i2c_read(ci->i2c, ci->cfg.adr, 3, data, n);
+		status = regmap_raw_read(ci->regmap, 3, data, n);
 	return status;
 }
 
 static int write_pccard(struct cxd *ci, u16 address, u8 *data, u8 n)
 {
 	int status;
-	u8 addr[3] = {2, address & 0xff, address >> 8};
+	u8 addr[2] = {address & 0xff, address >> 8};
 
-	status = i2c_write(ci->i2c, ci->cfg.adr, addr, 3);
+	status = regmap_raw_write(ci->regmap, 2, addr, 2);
 	if (!status) {
-		u8 buf[256] = {3};
+		u8 buf[256];
 
-		memcpy(buf + 1, data, n);
-		status = i2c_write(ci->i2c, ci->cfg.adr, buf, n + 1);
+		memcpy(buf, data, n);
+		status = regmap_raw_write(ci->regmap, 3, buf, n);
 	}
 	return status;
 }
 
-static int read_io(struct cxd *ci, u16 address, u8 *val)
+static int read_io(struct cxd *ci, u16 address, unsigned int *val)
 {
 	int status;
-	u8 addr[3] = {2, address & 0xff, address >> 8};
+	u8 addr[2] = {address & 0xff, address >> 8};
 
-	status = i2c_write(ci->i2c, ci->cfg.adr, addr, 3);
+	status = regmap_raw_write(ci->regmap, 2, addr, 2);
 	if (!status)
-		status = i2c_read(ci->i2c, ci->cfg.adr, 3, val, 1);
+		status = regmap_read(ci->regmap, 3, val);
 	return status;
 }
 
 static int write_io(struct cxd *ci, u16 address, u8 val)
 {
 	int status;
-	u8 addr[3] = {2, address & 0xff, address >> 8};
-	u8 buf[2] = {3, val};
+	u8 addr[2] = {address & 0xff, address >> 8};
 
-	status = i2c_write(ci->i2c, ci->cfg.adr, addr, 3);
+	status = regmap_raw_write(ci->regmap, 2, addr, 2);
 	if (!status)
-		status = i2c_write(ci->i2c, ci->cfg.adr, buf, 2);
+		status = regmap_write(ci->regmap, 3, val);
 	return status;
 }
 
 static int write_regm(struct cxd *ci, u8 reg, u8 val, u8 mask)
 {
 	int status = 0;
+	unsigned int regval;
 
 	if (ci->lastaddress != reg)
-		status = i2c_write_reg(ci->i2c, ci->cfg.adr, 0, reg);
-	if (!status && reg >= 6 && reg <= 8 && mask != 0xff)
-		status = i2c_read_reg(ci->i2c, ci->cfg.adr, 1, &ci->regs[reg]);
+		status = regmap_write(ci->regmap, 0, reg);
+	if (!status && reg >= 6 && reg <= 8 && mask != 0xff) {
+		status = regmap_read(ci->regmap, 1, &regval);
+		ci->regs[reg] = regval;
+	}
 	ci->lastaddress = reg;
 	ci->regs[reg] = (ci->regs[reg] & (~mask)) | val;
 	if (!status)
-		status = i2c_write_reg(ci->i2c, ci->cfg.adr, 1, ci->regs[reg]);
+		status = regmap_write(ci->regmap, 1, ci->regs[reg]);
 	if (reg == 0x20)
 		ci->regs[reg] &= 0x7f;
 	return status;
@@ -219,19 +166,18 @@ static int write_block(struct cxd *ci, u8 adr, u8 *data, u16 n)
 	u8 *buf = ci->wbuf;
 
 	if (ci->lastaddress != adr)
-		status = i2c_write_reg(ci->i2c, ci->cfg.adr, 0, adr);
+		status = regmap_write(ci->regmap, 0, adr);
 	if (status)
 		return status;
 
 	ci->lastaddress = adr;
-	buf[0] = 1;
 	while (n) {
 		int len = n;
 
 		if (ci->cfg.max_i2c && (len + 1 > ci->cfg.max_i2c))
 			len = ci->cfg.max_i2c - 1;
-		memcpy(buf + 1, data, len);
-		status = i2c_write(ci->i2c, ci->cfg.adr, buf, len + 1);
+		memcpy(buf, data, len);
+		status = regmap_raw_write(ci->regmap, 1, buf, len);
 		if (status)
 			return status;
 		n -= len;
@@ -273,7 +219,7 @@ static void cam_mode(struct cxd *ci, int mode)
 		if (!ci->en.read_data)
 			return;
 		ci->write_busy = 0;
-		dev_info(&ci->i2c->dev, "enable cam buffer mode\n");
+		dev_info(&ci->client->dev, "enable cam buffer mode\n");
 		write_reg(ci, 0x0d, 0x00);
 		write_reg(ci, 0x0e, 0x01);
 		write_regm(ci, 0x08, 0x40, 0x40);
@@ -464,7 +410,7 @@ static int read_cam_control(struct dvb_ca_en50221 *ca,
 			    int slot, u8 address)
 {
 	struct cxd *ci = ca->data;
-	u8 val;
+	unsigned int val;
 
 	mutex_lock(&ci->lock);
 	set_mode(ci, 0);
@@ -518,7 +464,7 @@ static int slot_shutdown(struct dvb_ca_en50221 *ca, int slot)
 {
 	struct cxd *ci = ca->data;
 
-	dev_dbg(&ci->i2c->dev, "%s\n", __func__);
+	dev_dbg(&ci->client->dev, "%s\n", __func__);
 	if (ci->cammode)
 		read_data(ca, slot, ci->rbuf, 0);
 	mutex_lock(&ci->lock);
@@ -577,7 +523,7 @@ static int campoll(struct cxd *ci)
 			if (ci->slot_stat) {
 				ci->slot_stat = 0;
 				write_regm(ci, 0x03, 0x00, 0x08);
-				dev_info(&ci->i2c->dev, "NO CAM\n");
+				dev_info(&ci->client->dev, "NO CAM\n");
 				ci->ready = 0;
 			}
 		}
@@ -660,26 +606,41 @@ static struct dvb_ca_en50221 en_templ = {
 	.write_data          = write_data,
 };
 
-struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
-				      void *priv,
-				      struct i2c_adapter *i2c)
+static int cxd2099_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
 {
 	struct cxd *ci;
-	u8 val;
+	struct cxd2099_cfg *cfg = client->dev.platform_data;
+	static const struct regmap_config rm_cfg = {
+		.reg_bits = 8,
+		.val_bits = 8,
+	};
+	unsigned int val;
+	int ret;
 
-	if (i2c_read_reg(i2c, cfg->adr, 0, &val) < 0) {
-		dev_info(&i2c->dev, "No CXD2099AR detected at 0x%02x\n",
-			 cfg->adr);
-		return NULL;
+	ci = kzalloc(sizeof(*ci), GFP_KERNEL);
+	if (!ci) {
+		ret = -ENOMEM;
+		goto err;
 	}
 
-	ci = kzalloc(sizeof(*ci), GFP_KERNEL);
-	if (!ci)
-		return NULL;
+	ci->client = client;
+	memcpy(&ci->cfg, cfg, sizeof(ci->cfg));
+
+	ci->regmap = regmap_init_i2c(client, &rm_cfg);
+	if (IS_ERR(ci->regmap)) {
+		ret = PTR_ERR(ci->regmap);
+		goto err_kfree;
+	}
+
+	ret = regmap_read(ci->regmap, 0x00, &val);
+	if (ret < 0) {
+		dev_info(&client->dev, "No CXD2099AR detected at 0x%02x\n",
+			 client->addr);
+		goto err_rmexit;
+	}
 
 	mutex_init(&ci->lock);
-	ci->cfg = *cfg;
-	ci->i2c = i2c;
 	ci->lastaddress = 0xff;
 	ci->clk_reg_b = 0x4a;
 	ci->clk_reg_f = 0x1b;
@@ -687,18 +648,56 @@ struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
 	ci->en = en_templ;
 	ci->en.data = ci;
 	init(ci);
-	dev_info(&i2c->dev, "Attached CXD2099AR at 0x%02x\n", ci->cfg.adr);
+	dev_info(&client->dev, "Attached CXD2099AR at 0x%02x\n", client->addr);
+
+	*cfg->en = &ci->en;
 
 	if (!buffermode) {
 		ci->en.read_data = NULL;
 		ci->en.write_data = NULL;
 	} else {
-		dev_info(&i2c->dev, "Using CXD2099AR buffer mode");
+		dev_info(&client->dev, "Using CXD2099AR buffer mode");
 	}
 
-	return &ci->en;
+	i2c_set_clientdata(client, ci);
+
+	return 0;
+
+err_rmexit:
+	regmap_exit(ci->regmap);
+err_kfree:
+	kfree(ci);
+err:
+
+	return ret;
 }
-EXPORT_SYMBOL(cxd2099_attach);
+
+static int cxd2099_remove(struct i2c_client *client)
+{
+	struct cxd *ci = i2c_get_clientdata(client);
+
+	regmap_exit(ci->regmap);
+	kfree(ci);
+
+	return 0;
+}
+
+static const struct i2c_device_id cxd2099_id[] = {
+	{"cxd2099", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, cxd2099_id);
+
+static struct i2c_driver cxd2099_driver = {
+	.driver = {
+		.name	= "cxd2099",
+	},
+	.probe		= cxd2099_probe,
+	.remove		= cxd2099_remove,
+	.id_table	= cxd2099_id,
+};
+
+module_i2c_driver(cxd2099_driver);
 
 MODULE_DESCRIPTION("CXD2099AR Common Interface controller driver");
 MODULE_AUTHOR("Ralph Metzler");
diff --git a/drivers/staging/media/cxd2099/cxd2099.h b/drivers/staging/media/cxd2099/cxd2099.h
index 253e3155a6df..679e87512799 100644
--- a/drivers/staging/media/cxd2099/cxd2099.h
+++ b/drivers/staging/media/cxd2099/cxd2099.h
@@ -25,14 +25,12 @@ struct cxd2099_cfg {
 	u8  clock_mode;
 
 	u32 max_i2c;
-};
 
-#if defined(CONFIG_DVB_CXD2099) || \
-	(defined(CONFIG_DVB_CXD2099_MODULE) && defined(MODULE))
-struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
-				      void *priv, struct i2c_adapter *i2c);
-#else
+	/* ptr to DVB CA struct */
+	struct dvb_ca_en50221 **en;
+};
 
+/* TODO: remove when done */
 static inline struct
 dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg, void *priv,
 			       struct i2c_adapter *i2c)
@@ -40,6 +38,5 @@ dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg, void *priv,
 	dev_warn(&i2c->dev, "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
-#endif
 
 #endif
-- 
2.13.6
