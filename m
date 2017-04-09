Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33448 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752618AbdDITit (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Apr 2017 15:38:49 -0400
Received: by mail-wm0-f68.google.com with SMTP id o81so6391489wmb.0
        for <linux-media@vger.kernel.org>; Sun, 09 Apr 2017 12:38:48 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: aospan@netup.ru, serjk@netup.ru, mchehab@kernel.org,
        linux-media@vger.kernel.org
Cc: rjkm@metzlerbros.de
Subject: [PATCH 18/19] [media] ddbridge: support for Sony CXD28xx C/C2/T/T2 tuner modules
Date: Sun,  9 Apr 2017 21:38:27 +0200
Message-Id: <20170409193828.18458-19-d.scheller.oss@gmail.com>
In-Reply-To: <20170409193828.18458-1-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Properly detect and attach Ports and Flex modules with the Sony CXD28xxER
series demods. This makes newer Cine cards and most DuoFlex C/C2/T/T2 (or
any combination of these systems) work, PCI IDs need to be added though.

Note: This utilises the CXD2841ER demod driver, which requires the changes
from this patch series to properly work. Without those changes, it won't
function properly (if at all).

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/Kconfig         |   2 +
 drivers/media/pci/ddbridge/ddbridge-core.c | 130 +++++++++++++++++++++++++++--
 drivers/media/pci/ddbridge/ddbridge.h      |  14 ++--
 3 files changed, 132 insertions(+), 14 deletions(-)

diff --git a/drivers/media/pci/ddbridge/Kconfig b/drivers/media/pci/ddbridge/Kconfig
index 16ede23..ac6a48d7 100644
--- a/drivers/media/pci/ddbridge/Kconfig
+++ b/drivers/media/pci/ddbridge/Kconfig
@@ -7,6 +7,7 @@ config DVB_DDBRIDGE
 	select DVB_DRXK if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TDA18271C2DD if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_STV0367 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_CXD2841ER if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18212 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  Support for cards with the Digital Devices PCI express bridge:
@@ -17,5 +18,6 @@ config DVB_DDBRIDGE
 	  - DuoFlex CT Octopus
 	  - cineS2(v6)
 	  - CineCTv6 and DuoFlex CT (STV0367-based)
+	  - DuoFlex CT2/C2T2/C2T2I (Sony CXD28xx-based)
 
 	  Say Y if you own such a card and want to use it.
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index ab88fcf..7df0489 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -41,6 +41,7 @@
 #include "drxk.h"
 #include "stv0367.h"
 #include "stv0367_priv.h"
+#include "cxd2841er.h"
 #include "tda18212.h"
 
 static int xo2_speed = 2;
@@ -707,6 +708,37 @@ static int tuner_tda18212_ping(struct ddb_input *input, unsigned short adr)
 	return 0;
 }
 
+static int demod_attach_cxd28xx(struct ddb_input *input, int par, int osc24)
+{
+	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct cxd2841er_config cfg;
+
+	/* the cxd2841er driver expects 8bit/shifted I2C addresses */
+	cfg.i2c_addr = ((input->nr & 1) ? 0x6d : 0x6c) << 1;
+
+	cfg.xtal = osc24 ? SONY_XTAL_24000 : SONY_XTAL_20500;
+	cfg.flags = CXD2841ER_AUTO_IFHZ | CXD2841ER_EARLY_TUNE |
+		CXD2841ER_NO_WAIT_LOCK | CXD2841ER_NO_AGCNEG |
+		CXD2841ER_TSBITS;
+
+	if (!par)
+		cfg.flags |= CXD2841ER_TS_SERIAL;
+
+	/* attach frontend */
+	input->fe = dvb_attach(cxd2841er_attach_t_c, &cfg, i2c);
+
+	if (!input->fe) {
+		printk(KERN_ERR "No Sony CXD28xx found!\n");
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
 static int tuner_attach_tda18212(struct ddb_input *input, u32 porttype)
 {
 	struct i2c_adapter *adapter = &input->port->i2c->adap;
@@ -976,6 +1008,7 @@ static int dvb_input_attach(struct ddb_input *input)
 	struct ddb_port *port = input->port;
 	struct dvb_adapter *adap = &input->adap;
 	struct dvb_demux *dvbdemux = &input->demux;
+	int sony_osc24 = 0, sony_tspar = 0;
 
 	ret = dvb_register_adapter(adap, "DDBridge", THIS_MODULE,
 				   &input->port->dev->pdev->dev,
@@ -1053,6 +1086,44 @@ static int dvb_input_attach(struct ddb_input *input)
 				return -ENODEV;
 		}
 		break;
+	case DDB_TUNER_DVBC2T2I_SONY_P:
+	case DDB_TUNER_DVBCT2_SONY_P:
+	case DDB_TUNER_DVBC2T2_SONY_P:
+	case DDB_TUNER_ISDBT_SONY_P:
+		if (port->type == DDB_TUNER_DVBC2T2I_SONY_P)
+			sony_osc24 = 1;
+		if (input->port->dev->info->ts_quirks & TS_QUIRK_ALT_OSC)
+			sony_osc24 = 0;
+		if (input->port->dev->info->ts_quirks & TS_QUIRK_SERIAL)
+			sony_tspar = 0;
+		else
+			sony_tspar = 1;
+
+		if (demod_attach_cxd28xx(input, sony_tspar, sony_osc24) < 0)
+			return -ENODEV;
+		if (tuner_attach_tda18212(input, port->type) < 0)
+			return -ENODEV;
+		if (input->fe) {
+			if (dvb_register_frontend(adap, input->fe) < 0)
+				return -ENODEV;
+		}
+		break;
+	case DDB_TUNER_XO2_DVBC2T2I_SONY:
+	case DDB_TUNER_XO2_DVBCT2_SONY:
+	case DDB_TUNER_XO2_DVBC2T2_SONY:
+	case DDB_TUNER_XO2_ISDBT_SONY:
+		if (port->type == DDB_TUNER_XO2_DVBC2T2I_SONY)
+			sony_osc24 = 1;
+
+		if (demod_attach_cxd28xx(input, 0, sony_osc24) < 0)
+			return -ENODEV;
+		if (tuner_attach_tda18212(input, port->type) < 0)
+			return -ENODEV;
+		if (input->fe) {
+			if (dvb_register_frontend(adap, input->fe) < 0)
+				return -ENODEV;
+		}
+		break;
 	}
 
 	input->attached = 5;
@@ -1412,11 +1483,25 @@ static int port_has_stv0367(struct ddb_port *port)
 	return 1;
 }
 
+static int port_has_cxd28xx(struct ddb_port *port, u8 *id)
+{
+	struct i2c_adapter *i2c = &port->i2c->adap;
+	int status;
+
+	status = i2c_write_reg(&port->i2c->adap, 0x6e, 0, 0);
+	if (status)
+		return 0;
+	status = i2c_read_reg(i2c, 0x6e, 0xfd, id);
+	if (status)
+		return 0;
+	return 1;
+}
+
 static void ddb_port_probe(struct ddb_port *port)
 {
 	struct ddb *dev = port->dev;
 	char *modname = "NO MODULE";
-	u8 xo2_type, xo2_id;
+	u8 xo2_type, xo2_id, cxd_id;
 
 	port->class = DDB_PORT_NONE;
 
@@ -1440,18 +1525,18 @@ static void ddb_port_probe(struct ddb_port *port)
 				port->type = DDB_TUNER_XO2_DVBS_STV0910;
 				break;
 			case 1:
-				modname = "DUAL DVB-C/T/T2 (unsupported)";
-				port->class = DDB_PORT_NONE;
+				modname = "DUAL DVB-C/T/T2";
+				port->class = DDB_PORT_TUNER;
 				port->type = DDB_TUNER_XO2_DVBCT2_SONY;
 				break;
 			case 2:
-				modname = "DUAL DVB-ISDBT (unsupported)";
-				port->class = DDB_PORT_NONE;
+				modname = "DUAL DVB-ISDBT";
+				port->class = DDB_PORT_TUNER;
 				port->type = DDB_TUNER_XO2_ISDBT_SONY;
 				break;
 			case 3:
-				modname = "DUAL DVB-C/C2/T/T2 (unsupported)";
-				port->class = DDB_PORT_NONE;
+				modname = "DUAL DVB-C/C2/T/T2";
+				port->class = DDB_PORT_TUNER;
 				port->type = DDB_TUNER_XO2_DVBC2T2_SONY;
 				break;
 			case 4:
@@ -1460,8 +1545,8 @@ static void ddb_port_probe(struct ddb_port *port)
 				port->type = DDB_TUNER_XO2_ATSC_ST;
 				break;
 			case 5:
-				modname = "DUAL DVB-C/C2/T/T2/ISDBT (unsupported)";
-				port->class = DDB_PORT_NONE;
+				modname = "DUAL DVB-C/C2/T/T2/ISDBT";
+				port->class = DDB_PORT_TUNER;
 				port->type = DDB_TUNER_XO2_DVBC2T2I_SONY;
 				break;
 			default:
@@ -1476,6 +1561,33 @@ static void ddb_port_probe(struct ddb_port *port)
 			printk(KERN_INFO "Unknown XO2 DuoFlex module\n");
 			break;
 		}
+	} else if (port_has_cxd28xx(port, &cxd_id)) {
+		switch (cxd_id) {
+		case 0xa4:
+			modname = "DUAL DVB-C2T2 CXD2843";
+			port->class = DDB_PORT_TUNER;
+			port->type = DDB_TUNER_DVBC2T2_SONY_P;
+			break;
+		case 0xb1:
+			modname = "DUAL DVB-CT2 CXD2837";
+			port->class = DDB_PORT_TUNER;
+			port->type = DDB_TUNER_DVBCT2_SONY_P;
+			break;
+		case 0xb0:
+			modname = "DUAL ISDB-T CXD2838";
+			port->class = DDB_PORT_TUNER;
+			port->type = DDB_TUNER_ISDBT_SONY_P;
+			break;
+		case 0xc1:
+			modname = "DUAL DVB-C2T2 ISDB-T CXD2854";
+			port->class = DDB_PORT_TUNER;
+			port->type = DDB_TUNER_DVBC2T2I_SONY_P;
+			break;
+		default:
+			modname = "Unknown CXD28xx tuner";
+			break;
+		}
+		ddbwritel(I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
 	} else if (port_has_stv0900(port)) {
 		modname = "DUAL DVB-S2";
 		port->class = DDB_PORT_TUNER;
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 4e49faa..58baddb 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -153,11 +153,15 @@ struct ddb_port {
 #define DDB_PORT_CI             1
 #define DDB_PORT_TUNER          2
 	u32                    type;
-#define DDB_TUNER_NONE          0
-#define DDB_TUNER_DVBS_ST       1
-#define DDB_TUNER_DVBS_ST_AA    2
-#define DDB_TUNER_DVBCT_TR     16
-#define DDB_TUNER_DVBCT_ST     17
+#define DDB_TUNER_NONE			0
+#define DDB_TUNER_DVBS_ST		1
+#define DDB_TUNER_DVBS_ST_AA		2
+#define DDB_TUNER_DVBCT2_SONY_P		7
+#define DDB_TUNER_DVBC2T2_SONY_P	8
+#define DDB_TUNER_ISDBT_SONY_P		9
+#define DDB_TUNER_DVBC2T2I_SONY_P	15
+#define DDB_TUNER_DVBCT_TR		16
+#define DDB_TUNER_DVBCT_ST		17
 #define DDB_TUNER_XO2_DVBS_STV0910	32
 #define DDB_TUNER_XO2_DVBCT2_SONY	33
 #define DDB_TUNER_XO2_ISDBT_SONY	34
-- 
2.10.2
