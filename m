Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35543 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755472AbdGCRVR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 13:21:17 -0400
Received: by mail-wr0-f195.google.com with SMTP id z45so45400197wrb.2
        for <linux-media@vger.kernel.org>; Mon, 03 Jul 2017 10:21:17 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH v3 08/10] [media] ddbridge: support for CineS2 V7(A) and DuoFlex S2 V4 hardware
Date: Mon,  3 Jul 2017 19:21:01 +0200
Message-Id: <20170703172104.27283-9-d.scheller.oss@gmail.com>
In-Reply-To: <20170703172104.27283-1-d.scheller.oss@gmail.com>
References: <20170703172104.27283-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This adds all required glue code to support - in conjunction with the new
stv0910 and stv6111 demod/tuner drivers and additionally the lnbh25 LNB
controller driver - all current DVB-S/S2 hardware (bridges and flex
modules) from Digital Devices like the DD CineS2 V7 and V7A, current
S2 V4 DuoFlex modules, and probably all upcoming devices based on this
STV0910/STV6111/LNBH25 hardware stack.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <r.scobie@clear.net.nz>
---
 drivers/media/pci/ddbridge/Kconfig         |   4 +
 drivers/media/pci/ddbridge/ddbridge-core.c | 135 ++++++++++++++++++++++++++++-
 drivers/media/pci/ddbridge/ddbridge.h      |   2 +
 3 files changed, 138 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/ddbridge/Kconfig b/drivers/media/pci/ddbridge/Kconfig
index ffed78c2ffb4..c79a58fa5fc3 100644
--- a/drivers/media/pci/ddbridge/Kconfig
+++ b/drivers/media/pci/ddbridge/Kconfig
@@ -8,6 +8,9 @@ config DVB_DDBRIDGE
 	select DVB_TDA18271C2DD if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_STV0367 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_CXD2841ER if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0910 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV6111 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LNBH25 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18212 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  Support for cards with the Digital Devices PCI express bridge:
@@ -20,5 +23,6 @@ config DVB_DDBRIDGE
 	  - CineCTv6 and DuoFlex CT (STV0367-based)
 	  - CineCTv7 and DuoFlex CT2/C2T2/C2T2I (Sony CXD28xx-based)
 	  - MaxA8 series
+	  - CineS2 V7/V7A and DuoFlex S2 V4 (ST STV0910-based)
 
 	  Say Y if you own such a card and want to use it.
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 3fbac7bee2d4..b3fc6a875279 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -45,6 +45,9 @@
 #include "stv0367_priv.h"
 #include "cxd2841er.h"
 #include "tda18212.h"
+#include "stv0910.h"
+#include "stv6111.h"
+#include "lnbh25.h"
 
 static int xo2_speed = 2;
 module_param(xo2_speed, int, 0444);
@@ -920,6 +923,71 @@ static int tuner_attach_stv6110(struct ddb_input *input, int type)
 	return 0;
 }
 
+static struct stv0910_cfg stv0910_p = {
+	.adr      = 0x68,
+	.parallel = 1,
+	.rptlvl   = 4,
+	.clk      = 30000000,
+};
+
+static struct lnbh25_config lnbh25_cfg = {
+	.i2c_address = 0x0c << 1,
+	.data2_config = LNBH25_TEN
+};
+
+static int demod_attach_stv0910(struct ddb_input *input, int type)
+{
+	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct device *dev = &input->port->dev->pdev->dev;
+	struct stv0910_cfg cfg = stv0910_p;
+	struct lnbh25_config lnbcfg = lnbh25_cfg;
+
+	if (type)
+		cfg.parallel = 2;
+	input->fe = dvb_attach(stv0910_attach, i2c, &cfg, (input->nr & 1));
+	if (!input->fe) {
+		cfg.adr = 0x6c;
+		input->fe = dvb_attach(stv0910_attach, i2c,
+					&cfg, (input->nr & 1));
+	}
+	if (!input->fe) {
+		dev_err(dev, "No STV0910 found!\n");
+		return -ENODEV;
+	}
+
+	/* attach lnbh25 - leftshift by one as the lnbh25 driver expects 8bit
+	 * i2c addresses
+	 */
+	lnbcfg.i2c_address = (((input->nr & 1) ? 0x0d : 0x0c) << 1);
+	if (!dvb_attach(lnbh25_attach, input->fe, &lnbcfg, i2c)) {
+		lnbcfg.i2c_address = (((input->nr & 1) ? 0x09 : 0x08) << 1);
+		if (!dvb_attach(lnbh25_attach, input->fe, &lnbcfg, i2c)) {
+			dev_err(dev, "No LNBH25 found!\n");
+			return -ENODEV;
+		}
+	}
+
+	return 0;
+}
+
+static int tuner_attach_stv6111(struct ddb_input *input, int type)
+{
+	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct device *dev = &input->port->dev->pdev->dev;
+	struct dvb_frontend *fe;
+	u8 adr = (type ? 0 : 4) + ((input->nr & 1) ? 0x63 : 0x60);
+
+	fe = dvb_attach(stv6111_attach, input->fe, i2c, adr);
+	if (!fe) {
+		fe = dvb_attach(stv6111_attach, input->fe, i2c, adr & ~4);
+		if (!fe) {
+			dev_err(dev, "No STV6111 found at 0x%02x!\n", adr);
+			return -ENODEV;
+		}
+	}
+	return 0;
+}
+
 static int my_dvb_dmx_ts_card_init(struct dvb_demux *dvbdemux, char *id,
 			    int (*start_feed)(struct dvb_demux_feed *),
 			    int (*stop_feed)(struct dvb_demux_feed *),
@@ -1086,6 +1154,36 @@ static int dvb_input_attach(struct ddb_input *input)
 				return -ENODEV;
 		}
 		break;
+	case DDB_TUNER_XO2_DVBS_STV0910:
+		if (demod_attach_stv0910(input, 0) < 0)
+			return -ENODEV;
+		if (tuner_attach_stv6111(input, 0) < 0)
+			return -ENODEV;
+		if (input->fe) {
+			if (dvb_register_frontend(adap, input->fe) < 0)
+				return -ENODEV;
+		}
+		break;
+	case DDB_TUNER_DVBS_STV0910_PR:
+		if (demod_attach_stv0910(input, 1) < 0)
+			return -ENODEV;
+		if (tuner_attach_stv6111(input, 1) < 0)
+			return -ENODEV;
+		if (input->fe) {
+			if (dvb_register_frontend(adap, input->fe) < 0)
+				return -ENODEV;
+		}
+		break;
+	case DDB_TUNER_DVBS_STV0910_P:
+		if (demod_attach_stv0910(input, 0) < 0)
+			return -ENODEV;
+		if (tuner_attach_stv6111(input, 1) < 0)
+			return -ENODEV;
+		if (input->fe) {
+			if (dvb_register_frontend(adap, input->fe) < 0)
+				return -ENODEV;
+		}
+		break;
 	case DDB_TUNER_DVBCT_TR:
 		if (demod_attach_drxk(input) < 0)
 			return -ENODEV;
@@ -1548,8 +1646,8 @@ static void ddb_port_probe(struct ddb_port *port)
 			init_xo2(port);
 			switch (xo2_id >> 2) {
 			case 0:
-				modname = "DUAL DVB-S2 (unsupported)";
-				port->class = DDB_PORT_NONE;
+				modname = "DUAL DVB-S2";
+				port->class = DDB_PORT_TUNER;
 				port->type = DDB_TUNER_XO2_DVBS_STV0910;
 				break;
 			case 1:
@@ -1624,7 +1722,18 @@ static void ddb_port_probe(struct ddb_port *port)
 	} else if (port_has_stv0900_aa(port, &stv_id)) {
 		modname = "DUAL DVB-S2";
 		port->class = DDB_PORT_TUNER;
-		port->type = DDB_TUNER_DVBS_ST_AA;
+		switch (stv_id) {
+		case 0x51:
+			if (dev->info->ts_quirks & TS_QUIRK_REVERSED &&
+					port->nr == 0)
+				port->type = DDB_TUNER_DVBS_STV0910_PR;
+			else
+				port->type = DDB_TUNER_DVBS_STV0910_P;
+			break;
+		default:
+			port->type = DDB_TUNER_DVBS_ST_AA;
+			break;
+		}
 		ddbwritel(I2C_SPEED_100, port->i2c->regs + I2C_TIMING);
 	} else if (port_has_drxks(port)) {
 		modname = "DUAL DVB-C/T";
@@ -2140,6 +2249,24 @@ static const struct ddb_info ddb_v6_5 = {
 	.port_num = 4,
 };
 
+static const struct ddb_info ddb_v7 = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Cine S2 V7 DVB adapter",
+	.port_num = 4,
+	.board_control   = 2,
+	.board_control_2 = 4,
+	.ts_quirks = TS_QUIRK_REVERSED,
+};
+
+static const struct ddb_info ddb_v7a = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Cine S2 V7 Advanced DVB adapter",
+	.port_num = 4,
+	.board_control   = 2,
+	.board_control_2 = 4,
+	.ts_quirks = TS_QUIRK_REVERSED,
+};
+
 static const struct ddb_info ddb_dvbct = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices DVBCT V6.1 DVB adapter",
@@ -2232,6 +2359,8 @@ static const struct pci_device_id ddb_id_tbl[] = {
 	DDB_ID(DDVID, 0x0005, DDVID, 0x0011, ddb_octopus_mini),
 	DDB_ID(DDVID, 0x0003, DDVID, 0x0020, ddb_v6),
 	DDB_ID(DDVID, 0x0003, DDVID, 0x0021, ddb_v6_5),
+	DDB_ID(DDVID, 0x0006, DDVID, 0x0022, ddb_v7),
+	DDB_ID(DDVID, 0x0006, DDVID, 0x0024, ddb_v7a),
 	DDB_ID(DDVID, 0x0003, DDVID, 0x0030, ddb_dvbct),
 	DDB_ID(DDVID, 0x0003, DDVID, 0xdb03, ddb_satixS2v3),
 	DDB_ID(DDVID, 0x0006, DDVID, 0x0031, ddb_ctv7),
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 4a0e3283d646..4783a17175a8 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -160,6 +160,8 @@ struct ddb_port {
 #define DDB_TUNER_DVBCT2_SONY_P		7
 #define DDB_TUNER_DVBC2T2_SONY_P	8
 #define DDB_TUNER_ISDBT_SONY_P		9
+#define DDB_TUNER_DVBS_STV0910_P	10
+#define DDB_TUNER_DVBS_STV0910_PR	14
 #define DDB_TUNER_DVBC2T2I_SONY_P	15
 #define DDB_TUNER_DVBCT_TR		16
 #define DDB_TUNER_DVBCT_ST		17
-- 
2.13.0
