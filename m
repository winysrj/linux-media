Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36683 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932180AbdC2Qn3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 12:43:29 -0400
Received: by mail-wr0-f195.google.com with SMTP id k6so3304199wre.3
        for <linux-media@vger.kernel.org>; Wed, 29 Mar 2017 09:43:27 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org
Cc: liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi
Subject: [PATCH v3 13/13] [media] ddbridge: support STV0367-based cards and modules
Date: Wed, 29 Mar 2017 18:43:13 +0200
Message-Id: <20170329164313.14636-14-d.scheller.oss@gmail.com>
In-Reply-To: <20170329164313.14636-1-d.scheller.oss@gmail.com>
References: <20170329164313.14636-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This adds detection and activation for STV0367-based tuner hardware (namely
CineCTv6 bridge cards and older DuoFlex CT addon modules). Utilises the
extended stv0367 demod driver.

TDA18212 i2c_client/regmap-api code was originally implemented by
Antti Palosaari <crope@iki.fi> in a variant to update the ddbridge code
from the vendor dddvb package (formal ack for these parts received).
Original patch at [1].

When boards with STV0367 are cold-started, there might be issues with the
I2C gate, causing the TDA18212 detection/probe to fail. For these demods,
a workaround (tuner_tda18212_ping) is implemented which probes the tuner
twice on this hardware constellation which will resolve the problem and
put all components into a working state. Other demod/port types won't be
retried.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>

[1] https://patchwork.linuxtv.org/patch/25146/
---
 drivers/media/pci/ddbridge/Kconfig         |   3 +
 drivers/media/pci/ddbridge/ddbridge-core.c | 158 ++++++++++++++++++++++++++++-
 drivers/media/pci/ddbridge/ddbridge.h      |   1 +
 3 files changed, 161 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/Kconfig b/drivers/media/pci/ddbridge/Kconfig
index 44e5dc1..16ede23 100644
--- a/drivers/media/pci/ddbridge/Kconfig
+++ b/drivers/media/pci/ddbridge/Kconfig
@@ -6,6 +6,8 @@ config DVB_DDBRIDGE
 	select DVB_STV090x if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_DRXK if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TDA18271C2DD if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0367 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA18212 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  Support for cards with the Digital Devices PCI express bridge:
 	  - Octopus PCIe Bridge
@@ -14,5 +16,6 @@ config DVB_DDBRIDGE
 	  - DuoFlex S2 Octopus
 	  - DuoFlex CT Octopus
 	  - cineS2(v6)
+	  - CineCTv6 and DuoFlex CT (STV0367-based)
 
 	  Say Y if you own such a card and want to use it.
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index acb9cbe..12f5aa3 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -39,6 +39,9 @@
 #include "stv090x.h"
 #include "lnbh24.h"
 #include "drxk.h"
+#include "stv0367.h"
+#include "stv0367_priv.h"
+#include "tda18212.h"
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
@@ -615,6 +618,120 @@ static int tuner_attach_tda18271(struct ddb_input *input)
 /******************************************************************************/
 /******************************************************************************/
 
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
+static int demod_attach_stv0367(struct ddb_input *input)
+{
+	struct i2c_adapter *i2c = &input->port->i2c->adap;
+
+	/* attach frontend */
+	input->fe = dvb_attach(stv0367ddb_attach,
+		&ddb_stv0367_config[(input->nr & 1)], i2c);
+
+	if (!input->fe) {
+		printk(KERN_ERR "stv0367ddb_attach failed (not found?)\n");
+		return -ENODEV;
+	}
+
+	input->fe->sec_priv = input;
+	input->gate_ctrl = input->fe->ops.i2c_gate_ctrl;
+	input->fe->ops.i2c_gate_ctrl = drxk_gate_ctrl;
+
+	return 0;
+}
+
+static int tuner_tda18212_ping(struct ddb_input *input, unsigned short adr)
+{
+	struct i2c_adapter *adapter = &input->port->i2c->adap;
+	u8 tda_id[2];
+	u8 subaddr = 0x00;
+
+	printk(KERN_DEBUG "stv0367-tda18212 tuner ping\n");
+	if (input->fe->ops.i2c_gate_ctrl)
+		input->fe->ops.i2c_gate_ctrl(input->fe, 1);
+
+	if (i2c_read_regs(adapter, adr, subaddr, tda_id, sizeof(tda_id)) < 0)
+		printk(KERN_DEBUG "tda18212 ping 1 fail\n");
+	if (i2c_read_regs(adapter, adr, subaddr, tda_id, sizeof(tda_id)) < 0)
+		printk(KERN_DEBUG "tda18212 ping 2 fail\n");
+
+	if (input->fe->ops.i2c_gate_ctrl)
+		input->fe->ops.i2c_gate_ctrl(input->fe, 0);
+
+	return 0;
+}
+
+static int tuner_attach_tda18212(struct ddb_input *input, u32 porttype)
+{
+	struct i2c_adapter *adapter = &input->port->i2c->adap;
+	struct i2c_client *client;
+	struct tda18212_config config = {
+		.fe = input->fe,
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
+	if (input->nr & 1)
+		board_info.addr = 0x63;
+	else
+		board_info.addr = 0x60;
+
+	/* due to a hardware quirk with the I2C gate on the stv0367+tda18212
+	 * combo, the tda18212 must be probed by reading it's id _twice_ when
+	 * cold started, or it very likely will fail.
+	 */
+	if (porttype == DDB_TUNER_DVBCT_ST)
+		tuner_tda18212_ping(input, board_info.addr);
+
+	request_module(board_info.type);
+
+	/* perform tuner init/attach */
+	client = i2c_new_device(adapter, &board_info);
+	if (client == NULL || client->dev.driver == NULL)
+		goto err;
+
+	if (!try_module_get(client->dev.driver->owner)) {
+		i2c_unregister_device(client);
+		goto err;
+	}
+
+	input->i2c_client[0] = client;
+
+	return 0;
+err:
+	printk(KERN_INFO "TDA18212 tuner not found. Device is not fully operational.\n");
+	return -ENODEV;
+}
+
+/******************************************************************************/
+/******************************************************************************/
+/******************************************************************************/
+
 static struct stv090x_config stv0900 = {
 	.device         = STV0900,
 	.demod_mode     = STV090x_DUAL,
@@ -785,11 +902,19 @@ static void dvb_input_detach(struct ddb_input *input)
 {
 	struct dvb_adapter *adap = &input->adap;
 	struct dvb_demux *dvbdemux = &input->demux;
+	struct i2c_client *client;
 
 	switch (input->attached) {
 	case 5:
-		if (input->fe2)
+		client = input->i2c_client[0];
+		if (client) {
+			module_put(client->dev.driver->owner);
+			i2c_unregister_device(client);
+		}
+		if (input->fe2) {
 			dvb_unregister_frontend(input->fe2);
+			input->fe2 = NULL;
+		}
 		if (input->fe) {
 			dvb_unregister_frontend(input->fe);
 			dvb_frontend_detach(input->fe);
@@ -888,7 +1013,18 @@ static int dvb_input_attach(struct ddb_input *input)
 			       sizeof(struct dvb_tuner_ops));
 		}
 		break;
+	case DDB_TUNER_DVBCT_ST:
+		if (demod_attach_stv0367(input) < 0)
+			return -ENODEV;
+		if (tuner_attach_tda18212(input, port->type) < 0)
+			return -ENODEV;
+		if (input->fe) {
+			if (dvb_register_frontend(adap, input->fe) < 0)
+				return -ENODEV;
+		}
+		break;
 	}
+
 	input->attached = 5;
 	return 0;
 }
@@ -1168,6 +1304,20 @@ static int port_has_drxks(struct ddb_port *port)
 	return 1;
 }
 
+static int port_has_stv0367(struct ddb_port *port)
+{
+	u8 val;
+	if (i2c_read_reg16(&port->i2c->adap, 0x1e, 0xf000, &val) < 0)
+		return 0;
+	if (val != 0x60)
+		return 0;
+	if (i2c_read_reg16(&port->i2c->adap, 0x1f, 0xf000, &val) < 0)
+		return 0;
+	if (val != 0x60)
+		return 0;
+	return 1;
+}
+
 static void ddb_port_probe(struct ddb_port *port)
 {
 	struct ddb *dev = port->dev;
@@ -1194,7 +1344,13 @@ static void ddb_port_probe(struct ddb_port *port)
 		port->class = DDB_PORT_TUNER;
 		port->type = DDB_TUNER_DVBCT_TR;
 		ddbwritel(I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
+	} else if (port_has_stv0367(port)) {
+		modname = "DUAL DVB-C/T";
+		port->class = DDB_PORT_TUNER;
+		port->type = DDB_TUNER_DVBCT_ST;
+		ddbwritel(I2C_SPEED_100, port->i2c->regs + I2C_TIMING);
 	}
+
 	printk(KERN_INFO "Port %d (TAB %d): %s\n",
 			 port->nr, port->nr+1, modname);
 }
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 185b423..0898f60 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -86,6 +86,7 @@ struct ddb_input {
 
 	struct dvb_adapter     adap;
 	struct dvb_device     *dev;
+	struct i2c_client     *i2c_client[1];
 	struct dvb_frontend   *fe;
 	struct dvb_frontend   *fe2;
 	struct dmxdev          dmxdev;
-- 
2.10.2
