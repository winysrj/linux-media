Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:50558 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751463AbeBXSzm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Feb 2018 13:55:42 -0500
Received: by mail-wm0-f67.google.com with SMTP id w128so4447053wmw.0
        for <linux-media@vger.kernel.org>; Sat, 24 Feb 2018 10:55:41 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 04/12] [media] ngene: support STV0367 DVB-C/T DuoFlex addons
Date: Sat, 24 Feb 2018 19:55:26 +0100
Message-Id: <20180224185534.13792-5-d.scheller.oss@gmail.com>
In-Reply-To: <20180224185534.13792-1-d.scheller.oss@gmail.com>
References: <20180224185534.13792-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Add support for STV0367+TDA18212 based DuoFlex CT addon modules. For this,
add a demod probe function and all necessary demod/tuner attach functions
which use existing auxiliary drivers (stv0367 and tda18212) to support
this hardware. As tda18212 is an I2C client driver, proper cleanup code
is added to the deregistration sequence in ngene-core. To not cause use-
after-free situations when there's a CXD2099 I2C client connected, which
is rather freed in ngene-core.c:cxd_detach(), add i2c_client_fe to struct
ngene_channel to keep track if the i2c_client was allocated by a frontend
driver, rather than the CI code paths. Also move the I2C access functions
to the top of the file and add the required read_regs() function for the
tda18212 ping to work.

This adds autoselection (if MEDIA_SUBDRV_AUTOSELECT) of the STV0367 demod
driver and TDA18212 tuner driver to Kconfig aswell.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
This and the following patches require the i2c_client variable that is
added by https://www.spinics.net/lists/linux-media/msg129187.html so
that makes it a somewhat hard-dependency.

 drivers/media/pci/ngene/Kconfig       |   2 +
 drivers/media/pci/ngene/ngene-cards.c | 194 ++++++++++++++++++++++++++++++----
 drivers/media/pci/ngene/ngene-core.c  |  12 +++
 drivers/media/pci/ngene/ngene.h       |   2 +
 4 files changed, 191 insertions(+), 19 deletions(-)

diff --git a/drivers/media/pci/ngene/Kconfig b/drivers/media/pci/ngene/Kconfig
index 390ed75fe438..c3254f9dc8ad 100644
--- a/drivers/media/pci/ngene/Kconfig
+++ b/drivers/media/pci/ngene/Kconfig
@@ -8,6 +8,8 @@ config DVB_NGENE
 	select DVB_DRXK if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TDA18271C2DD if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MT2131 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0367 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA18212 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_CXD2099 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  Support for Micronas PCI express cards with nGene bridge.
diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index 065b83ee569b..7ec5f68b1ec7 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -42,8 +42,42 @@
 #include "drxk.h"
 #include "drxd.h"
 #include "dvb-pll.h"
+#include "stv0367.h"
+#include "stv0367_priv.h"
+#include "tda18212.h"
 
+/****************************************************************************/
+/* I2C transfer functions used for demod/tuner probing***********************/
+/****************************************************************************/
+
+static int i2c_read(struct i2c_adapter *adapter, u8 adr, u8 *val)
+{
+	struct i2c_msg msgs[1] = {{.addr = adr,  .flags = I2C_M_RD,
+				   .buf  = val,  .len   = 1 } };
+	return (i2c_transfer(adapter, msgs, 1) == 1) ? 0 : -1;
+}
+
+static int i2c_read_reg16(struct i2c_adapter *adapter, u8 adr,
+			  u16 reg, u8 *val)
+{
+	u8 msg[2] = {reg >> 8, reg & 0xff};
+	struct i2c_msg msgs[2] = {{.addr = adr, .flags = 0,
+				   .buf  = msg, .len   = 2},
+				  {.addr = adr, .flags = I2C_M_RD,
+				   .buf  = val, .len   = 1} };
+	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
+}
 
+static int i2c_read_regs(struct i2c_adapter *adapter,
+			 u8 adr, u8 reg, u8 *val, u8 len)
+{
+	struct i2c_msg msgs[2] = {{.addr = adr,  .flags = 0,
+				   .buf  = &reg, .len   = 1},
+				  {.addr = adr,  .flags = I2C_M_RD,
+				   .buf  = val,  .len   = len} };
+
+	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
+}
 /****************************************************************************/
 /* Demod/tuner attachment ***************************************************/
 /****************************************************************************/
@@ -85,7 +119,6 @@ static int tuner_attach_stv6110(struct ngene_channel *chan)
 	return 0;
 }
 
-
 static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct ngene_channel *chan = fe->sec_priv;
@@ -121,6 +154,89 @@ static int tuner_attach_tda18271(struct ngene_channel *chan)
 	return 0;
 }
 
+static int tuner_tda18212_ping(struct ngene_channel *chan,
+			       struct i2c_adapter *i2c,
+			       unsigned short adr)
+{
+	struct device *pdev = &chan->dev->pci_dev->dev;
+	u8 tda_id[2];
+	u8 subaddr = 0x00;
+
+	dev_dbg(pdev, "stv0367-tda18212 tuner ping\n");
+	if (chan->fe->ops.i2c_gate_ctrl)
+		chan->fe->ops.i2c_gate_ctrl(chan->fe, 1);
+
+	if (i2c_read_regs(i2c, adr, subaddr, tda_id, sizeof(tda_id)) < 0)
+		dev_dbg(pdev, "tda18212 ping 1 fail\n");
+	if (i2c_read_regs(i2c, adr, subaddr, tda_id, sizeof(tda_id)) < 0)
+		dev_warn(pdev, "tda18212 ping failed, expect problems\n");
+
+	if (chan->fe->ops.i2c_gate_ctrl)
+		chan->fe->ops.i2c_gate_ctrl(chan->fe, 0);
+
+	return 0;
+}
+
+static int tuner_attach_tda18212(struct ngene_channel *chan, u32 dmdtype)
+{
+	struct device *pdev = &chan->dev->pci_dev->dev;
+	struct i2c_adapter *i2c;
+	struct i2c_client *client;
+	struct tda18212_config config = {
+		.fe = chan->fe,
+		.if_dvbt_6 = 3550,
+		.if_dvbt_7 = 3700,
+		.if_dvbt_8 = 4150,
+		.if_dvbt2_6 = 3250,
+		.if_dvbt2_7 = 4000,
+		.if_dvbt2_8 = 4000,
+		.if_dvbc = 5000,
+	};
+	struct i2c_board_info board_info = {
+		.type = "tda18212",
+		.platform_data = &config,
+	};
+
+	if (chan->number & 1)
+		board_info.addr = 0x63;
+	else
+		board_info.addr = 0x60;
+
+	/* tuner 1+2: i2c adapter #0, tuner 3+4: i2c adapter #1 */
+	if (chan->number < 2)
+		i2c = &chan->dev->channel[0].i2c_adapter;
+	else
+		i2c = &chan->dev->channel[1].i2c_adapter;
+
+	/*
+	 * due to a hardware quirk with the I2C gate on the stv0367+tda18212
+	 * combo, the tda18212 must be probed by reading it's id _twice_ when
+	 * cold started, or it very likely will fail.
+	 */
+	if (dmdtype == DEMOD_TYPE_STV0367)
+		tuner_tda18212_ping(chan, i2c, board_info.addr);
+
+	request_module(board_info.type);
+
+	/* perform tuner init/attach */
+	client = i2c_new_device(i2c, &board_info);
+	if (!client || !client->dev.driver)
+		goto err;
+
+	if (!try_module_get(client->dev.driver->owner)) {
+		i2c_unregister_device(client);
+		goto err;
+	}
+
+	chan->i2c_client[0] = client;
+	chan->i2c_client_fe = 1;
+
+	return 0;
+err:
+	dev_err(pdev, "TDA18212 tuner not found. Device is not fully operational.\n");
+	return -ENODEV;
+}
+
 static int tuner_attach_probe(struct ngene_channel *chan)
 {
 	switch (chan->demod_type) {
@@ -128,6 +244,8 @@ static int tuner_attach_probe(struct ngene_channel *chan)
 		return tuner_attach_stv6110(chan);
 	case DEMOD_TYPE_DRXK:
 		return tuner_attach_tda18271(chan);
+	case DEMOD_TYPE_STV0367:
+		return tuner_attach_tda18212(chan, chan->demod_type);
 	}
 
 	return -EINVAL;
@@ -171,6 +289,43 @@ static int demod_attach_stv0900(struct ngene_channel *chan)
 	return 0;
 }
 
+static struct stv0367_config ddb_stv0367_config[] = {
+	{
+		.demod_address = 0x1f,
+		.xtal = 27000000,
+		.if_khz = 0,
+		.if_iq_mode = FE_TER_NORMAL_IF_TUNER,
+		.ts_mode = STV0367_SERIAL_PUNCT_CLOCK,
+		.clk_pol = STV0367_CLOCKPOLARITY_DEFAULT,
+	}, {
+		.demod_address = 0x1e,
+		.xtal = 27000000,
+		.if_khz = 0,
+		.if_iq_mode = FE_TER_NORMAL_IF_TUNER,
+		.ts_mode = STV0367_SERIAL_PUNCT_CLOCK,
+		.clk_pol = STV0367_CLOCKPOLARITY_DEFAULT,
+	},
+};
+
+static int demod_attach_stv0367(struct ngene_channel *chan,
+				struct i2c_adapter *i2c)
+{
+	struct device *pdev = &chan->dev->pci_dev->dev;
+
+	chan->fe = dvb_attach(stv0367ddb_attach,
+			      &ddb_stv0367_config[(chan->number & 1)], i2c);
+
+	if (!chan->fe) {
+		dev_err(pdev, "stv0367ddb_attach() failed!\n");
+		return -ENODEV;
+	}
+
+	chan->fe->sec_priv = chan;
+	chan->gate_ctrl = chan->fe->ops.i2c_gate_ctrl;
+	chan->fe->ops.i2c_gate_ctrl = drxk_gate_ctrl;
+	return 0;
+}
+
 static void cineS2_tuner_i2c_lock(struct dvb_frontend *fe, int lock)
 {
 	struct ngene_channel *chan = fe->analog_demod_priv;
@@ -181,24 +336,6 @@ static void cineS2_tuner_i2c_lock(struct dvb_frontend *fe, int lock)
 		up(&chan->dev->pll_mutex);
 }
 
-static int i2c_read(struct i2c_adapter *adapter, u8 adr, u8 *val)
-{
-	struct i2c_msg msgs[1] = {{.addr = adr,  .flags = I2C_M_RD,
-				   .buf  = val,  .len   = 1 } };
-	return (i2c_transfer(adapter, msgs, 1) == 1) ? 0 : -1;
-}
-
-static int i2c_read_reg16(struct i2c_adapter *adapter, u8 adr,
-			  u16 reg, u8 *val)
-{
-	u8 msg[2] = {reg>>8, reg&0xff};
-	struct i2c_msg msgs[2] = {{.addr = adr, .flags = 0,
-				   .buf  = msg, .len   = 2},
-				  {.addr = adr, .flags = I2C_M_RD,
-				   .buf  = val, .len   = 1} };
-	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
-}
-
 static int port_has_stv0900(struct i2c_adapter *i2c, int port)
 {
 	u8 val;
@@ -216,6 +353,21 @@ static int port_has_drxk(struct i2c_adapter *i2c, int port)
 	return 1;
 }
 
+static int port_has_stv0367(struct i2c_adapter *i2c)
+{
+	u8 val;
+
+	if (i2c_read_reg16(i2c, 0x1e, 0xf000, &val) < 0)
+		return 0;
+	if (val != 0x60)
+		return 0;
+	if (i2c_read_reg16(i2c, 0x1f, 0xf000, &val) < 0)
+		return 0;
+	if (val != 0x60)
+		return 0;
+	return 1;
+}
+
 static int demod_attach_drxk(struct ngene_channel *chan,
 			     struct i2c_adapter *i2c)
 {
@@ -285,6 +437,10 @@ static int cineS2_probe(struct ngene_channel *chan)
 	} else if (port_has_drxk(i2c, chan->number^2)) {
 		chan->demod_type = DEMOD_TYPE_DRXK;
 		demod_attach_drxk(chan, i2c);
+	} else if (port_has_stv0367(i2c)) {
+		chan->demod_type = DEMOD_TYPE_STV0367;
+		dev_info(pdev, "STV0367 on channel %d\n", chan->number);
+		demod_attach_stv0367(chan, i2c);
 	} else {
 		dev_err(pdev, "No demod found on chan %d\n", chan->number);
 		return -ENODEV;
diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index a63f019fb62f..526d0adfa427 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -1408,6 +1408,7 @@ static void release_channel(struct ngene_channel *chan)
 {
 	struct dvb_demux *dvbdemux = &chan->demux;
 	struct ngene *dev = chan->dev;
+	struct i2c_client *client;
 
 	if (chan->running)
 		set_transfer(chan, 0);
@@ -1424,6 +1425,16 @@ static void release_channel(struct ngene_channel *chan)
 
 	if (chan->fe) {
 		dvb_unregister_frontend(chan->fe);
+
+		/* release I2C client (tuner) if needed */
+		client = chan->i2c_client[0];
+		if (chan->i2c_client_fe && client) {
+			module_put(client->dev.driver->owner);
+			i2c_unregister_device(client);
+			chan->i2c_client[0] = NULL;
+			client = NULL;
+		}
+
 		dvb_frontend_detach(chan->fe);
 		chan->fe = NULL;
 	}
@@ -1459,6 +1470,7 @@ static int init_channel(struct ngene_channel *chan)
 	chan->users = 0;
 	chan->type = io;
 	chan->mode = chan->type;	/* for now only one mode */
+	chan->i2c_client_fe = 0;	/* be sure this is set to zero */
 
 	if (io & NGENE_IO_TSIN) {
 		chan->fe = NULL;
diff --git a/drivers/media/pci/ngene/ngene.h b/drivers/media/pci/ngene/ngene.h
index 9724701a3274..1b88a9aa7aac 100644
--- a/drivers/media/pci/ngene/ngene.h
+++ b/drivers/media/pci/ngene/ngene.h
@@ -53,6 +53,7 @@
 
 #define DEMOD_TYPE_STV090X	0
 #define DEMOD_TYPE_DRXK		1
+#define DEMOD_TYPE_STV0367	2
 
 enum STREAM {
 	STREAM_VIDEOIN1 = 0,        /* ITU656 or TS Input */
@@ -634,6 +635,7 @@ struct ngene_channel {
 	struct device         device;
 	struct i2c_adapter    i2c_adapter;
 	struct i2c_client    *i2c_client[1];
+	int                   i2c_client_fe;
 
 	struct ngene         *dev;
 	int                   number;
-- 
2.16.1
