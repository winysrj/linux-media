Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:55530 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751761AbeBYMbt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Feb 2018 07:31:49 -0500
Received: by mail-wm0-f65.google.com with SMTP id q83so12559466wme.5
        for <linux-media@vger.kernel.org>; Sun, 25 Feb 2018 04:31:48 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH v2 05/12] [media] ngene: add XO2 module support
Date: Sun, 25 Feb 2018 13:31:33 +0100
Message-Id: <20180225123140.19486-6-d.scheller.oss@gmail.com>
In-Reply-To: <20180225123140.19486-1-d.scheller.oss@gmail.com>
References: <20180225123140.19486-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Detect and initialise modules equipped with XO2 interfaces (Lattice
MachXO2). This requires a few more I2C transfer functions which this adds
aswell. Defines for the different possible (available) module types are
added to ngene.h. The support for the actual tuners contained on these
addon modules is kept separate from this commit and is being added with
the next commits.

The xo2names array is temporarily marked __maybe_unused to silence a
corresponding compiler warning at this stage.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ngene/ngene-cards.c | 144 +++++++++++++++++++++++++++++++++-
 drivers/media/pci/ngene/ngene.h       |  12 +++
 2 files changed, 155 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index 7ec5f68b1ec7..05b8e56999ec 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -50,6 +50,32 @@
 /* I2C transfer functions used for demod/tuner probing***********************/
 /****************************************************************************/
 
+static int i2c_io(struct i2c_adapter *adapter, u8 adr,
+		  u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
+{
+	struct i2c_msg msgs[2] = {{.addr = adr,  .flags = 0,
+				   .buf  = wbuf, .len   = wlen },
+				  {.addr = adr,  .flags = I2C_M_RD,
+				   .buf  = rbuf,  .len   = rlen } };
+	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
+}
+
+static int i2c_write(struct i2c_adapter *adap, u8 adr, u8 *data, int len)
+{
+	struct i2c_msg msg = {.addr = adr, .flags = 0,
+			      .buf = data, .len = len};
+
+	return (i2c_transfer(adap, &msg, 1) == 1) ? 0 : -1;
+}
+
+static int i2c_write_reg(struct i2c_adapter *adap, u8 adr,
+			 u8 reg, u8 val)
+{
+	u8 msg[2] = {reg, val};
+
+	return i2c_write(adap, adr, msg, 2);
+}
+
 static int i2c_read(struct i2c_adapter *adapter, u8 adr, u8 *val)
 {
 	struct i2c_msg msgs[1] = {{.addr = adr,  .flags = I2C_M_RD,
@@ -78,6 +104,12 @@ static int i2c_read_regs(struct i2c_adapter *adapter,
 
 	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
 }
+
+static int i2c_read_reg(struct i2c_adapter *adapter, u8 adr, u8 reg, u8 *val)
+{
+	return i2c_read_regs(adapter, adr, reg, val, 1);
+}
+
 /****************************************************************************/
 /* Demod/tuner attachment ***************************************************/
 /****************************************************************************/
@@ -390,12 +422,98 @@ static int demod_attach_drxk(struct ngene_channel *chan,
 	return 0;
 }
 
+/****************************************************************************/
+/* XO2 related lists and functions ******************************************/
+/****************************************************************************/
+
+static char __maybe_unused *xo2names[] = {
+	"DUAL DVB-S2",
+	"DUAL DVB-C/T/T2",
+	"DUAL DVB-ISDBT",
+	"DUAL DVB-C/C2/T/T2",
+	"DUAL ATSC",
+	"DUAL DVB-C/C2/T/T2/I",
+};
+
+static int init_xo2(struct ngene_channel *chan, struct i2c_adapter *i2c)
+{
+	struct device *pdev = &chan->dev->pci_dev->dev;
+	u8 addr = 0x10;
+	u8 val, data[2];
+	int res;
+
+	res = i2c_read_regs(i2c, addr, 0x04, data, 2);
+	if (res < 0)
+		return res;
+
+	if (data[0] != 0x01)  {
+		dev_info(pdev, "Invalid XO2 on channel %d\n", chan->number);
+		return -1;
+	}
+
+	i2c_read_reg(i2c, addr, 0x08, &val);
+	if (val != 0) {
+		i2c_write_reg(i2c, addr, 0x08, 0x00);
+		msleep(100);
+	}
+	/* Enable tuner power, disable pll, reset demods */
+	i2c_write_reg(i2c, addr, 0x08, 0x04);
+	usleep_range(2000, 3000);
+	/* Release demod resets */
+	i2c_write_reg(i2c, addr, 0x08, 0x07);
+
+	/*
+	 * speed: 0=55,1=75,2=90,3=104 MBit/s
+	 * Note: The ngene hardware must be run at 75 MBit/s compared
+	 * to more modern ddbridge hardware which runs at 90 MBit/s,
+	 * else there will be issues with the data transport and non-
+	 * working secondary/slave demods/tuners.
+	 */
+	i2c_write_reg(i2c, addr, 0x09, 1);
+
+	i2c_write_reg(i2c, addr, 0x0a, 0x01);
+	i2c_write_reg(i2c, addr, 0x0b, 0x01);
+
+	usleep_range(2000, 3000);
+	/* Start XO2 PLL */
+	i2c_write_reg(i2c, addr, 0x08, 0x87);
+
+	return 0;
+}
+
+static int port_has_xo2(struct i2c_adapter *i2c, u8 *type, u8 *id)
+{
+	u8 probe[1] = { 0x00 }, data[4];
+	u8 addr = 0x10;
+
+	*type = NGENE_XO2_TYPE_NONE;
+
+	if (i2c_io(i2c, addr, probe, 1, data, 4))
+		return 0;
+	if (data[0] == 'D' && data[1] == 'F') {
+		*id = data[2];
+		*type = NGENE_XO2_TYPE_DUOFLEX;
+		return 1;
+	}
+	if (data[0] == 'C' && data[1] == 'I') {
+		*id = data[2];
+		*type = NGENE_XO2_TYPE_CI;
+		return 1;
+	}
+	return 0;
+}
+
+/****************************************************************************/
+/* Probing and port/channel handling ****************************************/
+/****************************************************************************/
+
 static int cineS2_probe(struct ngene_channel *chan)
 {
 	struct device *pdev = &chan->dev->pci_dev->dev;
 	struct i2c_adapter *i2c;
 	struct stv090x_config *fe_conf;
 	u8 buf[3];
+	u8 xo2_type, xo2_id;
 	struct i2c_msg i2c_msg = { .flags = 0, .buf = buf };
 	int rc;
 
@@ -405,7 +523,31 @@ static int cineS2_probe(struct ngene_channel *chan)
 	else
 		i2c = &chan->dev->channel[1].i2c_adapter;
 
-	if (port_has_stv0900(i2c, chan->number)) {
+	if (port_has_xo2(i2c, &xo2_type, &xo2_id)) {
+		xo2_id >>= 2;
+		dev_dbg(pdev, "XO2 on channel %d (type %d, id %d)\n",
+			chan->number, xo2_type, xo2_id);
+
+		switch (xo2_type) {
+		case NGENE_XO2_TYPE_DUOFLEX:
+			if (chan->number & 1)
+				dev_dbg(pdev,
+					"skipping XO2 init on odd channel %d",
+					chan->number);
+			else
+				init_xo2(chan, i2c);
+
+			/* TODO: implement support for XO2 module types */
+			dev_warn(pdev, "XO2 not supported\n");
+			return -ENODEV;
+		case NGENE_XO2_TYPE_CI:
+			dev_info(pdev, "DuoFlex CI modules not supported\n");
+			return -ENODEV;
+		default:
+			dev_info(pdev, "Unsupported XO2 module type\n");
+			return -ENODEV;
+		}
+	} else if (port_has_stv0900(i2c, chan->number)) {
 		chan->demod_type = DEMOD_TYPE_STV090X;
 		fe_conf = chan->dev->card_info->fe_config[chan->number];
 		/* demod found, attach it */
diff --git a/drivers/media/pci/ngene/ngene.h b/drivers/media/pci/ngene/ngene.h
index 1b88a9aa7aac..72195f6552b3 100644
--- a/drivers/media/pci/ngene/ngene.h
+++ b/drivers/media/pci/ngene/ngene.h
@@ -55,6 +55,18 @@
 #define DEMOD_TYPE_DRXK		1
 #define DEMOD_TYPE_STV0367	2
 
+#define DEMOD_TYPE_XO2		32
+#define DEMOD_TYPE_STV0910	(DEMOD_TYPE_XO2 + 0)
+#define DEMOD_TYPE_SONY_CT2	(DEMOD_TYPE_XO2 + 1)
+#define DEMOD_TYPE_SONY_ISDBT	(DEMOD_TYPE_XO2 + 2)
+#define DEMOD_TYPE_SONY_C2T2	(DEMOD_TYPE_XO2 + 3)
+#define DEMOD_TYPE_ST_ATSC	(DEMOD_TYPE_XO2 + 4)
+#define DEMOD_TYPE_SONY_C2T2I	(DEMOD_TYPE_XO2 + 5)
+
+#define NGENE_XO2_TYPE_NONE	0
+#define NGENE_XO2_TYPE_DUOFLEX	1
+#define NGENE_XO2_TYPE_CI	2
+
 enum STREAM {
 	STREAM_VIDEOIN1 = 0,        /* ITU656 or TS Input */
 	STREAM_VIDEOIN2,
-- 
2.16.1
