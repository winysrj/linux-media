Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35484 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755587AbdCGUCN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 15:02:13 -0500
Received: by mail-wm0-f65.google.com with SMTP id z63so2772137wmg.2
        for <linux-media@vger.kernel.org>; Tue, 07 Mar 2017 12:02:12 -0800 (PST)
Received: from dvbdev.wuest.de (ip-178-201-73-185.hsi08.unitymediagroup.de. [178.201.73.185])
        by smtp.gmail.com with ESMTPSA id m186sm13760369wmd.21.2017.03.07.10.58.39
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 07 Mar 2017 10:58:39 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 13/13] [media] ddbridge: support STV0367-based cards and modules
Date: Tue,  7 Mar 2017 19:57:27 +0100
Message-Id: <20170307185727.564-14-d.scheller.oss@gmail.com>
In-Reply-To: <20170307185727.564-1-d.scheller.oss@gmail.com>
References: <20170307185727.564-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This adds detection and activation for STV0367-based tuner hardware (namely
CineCTv6 bridge cards and older DuoFlex CT addon modules). Utilises the
extended stv0367 demod driver, and needs the init_retry when attaching the
TDA18212 tuner.

TDA18212 i2c_client/regmap-api code was originally implemented by
Antti Palosaari <crope@iki.fi> in a variant to update the ddbridge code
from the vendor dddvb package (formal ack for these parts received).
Original patch at [1].

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>

[1] https://patchwork.linuxtv.org/patch/25146/
---
 drivers/media/pci/ddbridge/Kconfig         |   3 +
 drivers/media/pci/ddbridge/ddbridge-core.c | 127 +++++++++++++++++++++++++++++
 drivers/media/pci/ddbridge/ddbridge.h      |   1 +
 3 files changed, 131 insertions(+)

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
index 340cff0..5082340 100644
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
 
@@ -609,6 +612,92 @@ static int tuner_attach_tda18271(struct ddb_input *input)
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
+static int tuner_attach_tda18212(struct ddb_input *input)
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
+		.init_flags = TDA18212_INIT_RETRY,
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
+	request_module(board_info.type);
+
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
@@ -779,11 +868,18 @@ static void dvb_input_detach(struct ddb_input *input)
 {
 	struct dvb_adapter *adap = &input->adap;
 	struct dvb_demux *dvbdemux = &input->demux;
+	struct i2c_client *client;
 
 	switch (input->attached) {
 	case 5:
+		client = input->i2c_client[0];
+		if (client) {
+			module_put(client->dev.driver->owner);
+			i2c_unregister_device(client);
+		}
 		if (input->fe2)
 			dvb_unregister_frontend(input->fe2);
+			input->fe2 = NULL;
 		if (input->fe) {
 			dvb_unregister_frontend(input->fe);
 			dvb_frontend_detach(input->fe);
@@ -882,7 +978,18 @@ static int dvb_input_attach(struct ddb_input *input)
 			       sizeof(struct dvb_tuner_ops));
 		}
 		break;
+	case DDB_TUNER_DVBCT_ST:
+		if (demod_attach_stv0367(input) < 0)
+			return -ENODEV;
+		if (tuner_attach_tda18212(input) < 0)
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
@@ -1162,6 +1269,20 @@ static int port_has_drxks(struct ddb_port *port)
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
@@ -1188,7 +1309,13 @@ static void ddb_port_probe(struct ddb_port *port)
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
