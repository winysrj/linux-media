Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42240 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbaGaWdZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jul 2014 18:33:25 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/4] ddbridge: add support for DVB-C/C2/T/T2 extension card
Date: Fri,  1 Aug 2014 01:33:08 +0300
Message-Id: <1406845988-2871-4-git-send-email-crope@iki.fi>
In-Reply-To: <1406845988-2871-1-git-send-email-crope@iki.fi>
References: <1406845988-2871-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for DD DuoFlex C/C2/T/T2 Expansion card. These are for
card revision that has Sony CXD2843ER, CXD2837ER or CXD2838ER
ISDB-T demodulator.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/pci/ddbridge/Kconfig         |   2 +
 drivers/media/pci/ddbridge/ddbridge-core.c | 127 +++++++++++++++++++++++++++++
 drivers/media/pci/ddbridge/ddbridge.h      |   3 +
 3 files changed, 132 insertions(+)

diff --git a/drivers/media/pci/ddbridge/Kconfig b/drivers/media/pci/ddbridge/Kconfig
index 44e5dc1..15f33a2 100644
--- a/drivers/media/pci/ddbridge/Kconfig
+++ b/drivers/media/pci/ddbridge/Kconfig
@@ -6,6 +6,8 @@ config DVB_DDBRIDGE
 	select DVB_STV090x if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_DRXK if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TDA18271C2DD if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_CXD2843 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA18212 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  Support for cards with the Digital Devices PCI express bridge:
 	  - Octopus PCIe Bridge
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index da8f848..9f5837f 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -43,6 +43,8 @@
 #include "stv090x.h"
 #include "lnbh24.h"
 #include "drxk.h"
+#include "cxd2843.h"
+#include "tda18212.h"
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
@@ -78,6 +80,21 @@ static int i2c_read_reg16(struct i2c_adapter *adapter, u8 adr,
 	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
 }
 
+static int i2c_write(struct i2c_adapter *adap, u8 adr, u8 *data, int len)
+{
+	struct i2c_msg msg = {.addr = adr, .flags = 0,
+			      .buf = data, .len = len};
+
+	return (i2c_transfer(adap, &msg, 1) == 1) ? 0 : -1;
+}
+
+static int i2c_write_reg(struct i2c_adapter *adap, u8 adr, u8 reg, u8 val)
+{
+	u8 msg[2] = {reg, val};
+
+	return i2c_write(adap, adr, msg, 2);
+}
+
 static int ddb_i2c_cmd(struct ddb_i2c *i2c, u32 adr, u32 cmd)
 {
 	struct ddb *dev = i2c->dev;
@@ -592,6 +609,30 @@ static int demod_attach_drxk(struct ddb_input *input)
 	return 0;
 }
 
+static int demod_attach_cxd2843(struct ddb_input *input)
+{
+	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct dvb_frontend *fe;
+	struct cxd2843_cfg cxd2843_0 = {
+		.adr = 0x6c,
+	};
+	struct cxd2843_cfg cxd2843_1 = {
+		.adr = 0x6d,
+	};
+
+	fe = input->fe = dvb_attach(cxd2843_attach, i2c,
+				  (input->nr & 1) ?
+				  &cxd2843_1 : &cxd2843_0);
+	if (!input->fe) {
+		pr_err("No cxd2837/38/43 found!\n");
+		return -ENODEV;
+	}
+	fe->sec_priv = input;
+	input->gate_ctrl = fe->ops.i2c_gate_ctrl;
+	fe->ops.i2c_gate_ctrl = drxk_gate_ctrl;
+	return 0;
+}
+
 static int tuner_attach_tda18271(struct ddb_input *input)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
@@ -609,6 +650,47 @@ static int tuner_attach_tda18271(struct ddb_input *input)
 	return 0;
 }
 
+static struct tda18212_config tda18212_config_60 = {
+	.i2c_address = 0x60,
+	.if_dvbt_6 = 3550,
+	.if_dvbt_7 = 3700,
+	.if_dvbt_8 = 4150,
+	.if_dvbt2_6 = 3250,
+	.if_dvbt2_7 = 4000,
+	.if_dvbt2_8 = 4000,
+	.if_dvbc = 5000,
+};
+
+static struct tda18212_config tda18212_config_63 = {
+	.i2c_address = 0x63,
+	.if_dvbt_6 = 3550,
+	.if_dvbt_7 = 3700,
+	.if_dvbt_8 = 4150,
+	.if_dvbt2_6 = 3250,
+	.if_dvbt2_7 = 4000,
+	.if_dvbt2_8 = 4000,
+	.if_dvbc = 5000,
+};
+
+static int tuner_attach_tda18212(struct ddb_input *input)
+{
+	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct dvb_frontend *fe;
+	struct tda18212_config *config;
+
+	if (input->nr & 1)
+		config = &tda18212_config_63;
+	else
+		config = &tda18212_config_60;
+
+	fe = dvb_attach(tda18212_attach, input->fe, i2c, config);
+	if (!fe) {
+		pr_err("No TDA18212 found!\n");
+		return -ENODEV;
+	}
+	return 0;
+}
+
 /******************************************************************************/
 /******************************************************************************/
 /******************************************************************************/
@@ -887,6 +969,18 @@ static int dvb_input_attach(struct ddb_input *input)
 			       sizeof(struct dvb_tuner_ops));
 		}
 		break;
+	case DDB_TUNER_DVBCT2_SONY:
+	case DDB_TUNER_DVBC2T2_SONY:
+	case DDB_TUNER_ISDBT_SONY:
+		if (demod_attach_cxd2843(input) < 0)
+			return -ENODEV;
+		if (tuner_attach_tda18212(input) < 0)
+			return -ENODEV;
+		if (input->fe) {
+			if (dvb_register_frontend(adap, input->fe) < 0)
+				return -ENODEV;
+		}
+		break;
 	}
 	input->attached = 5;
 	return 0;
@@ -1170,10 +1264,24 @@ static int port_has_drxks(struct ddb_port *port)
 	return 1;
 }
 
+static int port_has_cxd28xx(struct ddb_port *port, u8 *id)
+{
+	int status;
+
+	status = i2c_write_reg(&port->i2c->adap, 0x6e, 0, 0);
+	if (status)
+		return 0;
+	status = i2c_read_reg(&port->i2c->adap, 0x6e, 0xfd, id);
+	if (status)
+		return 0;
+	return 1;
+}
+
 static void ddb_port_probe(struct ddb_port *port)
 {
 	struct ddb *dev = port->dev;
 	char *modname = "NO MODULE";
+	u8 id;
 
 	port->class = DDB_PORT_NONE;
 
@@ -1196,6 +1304,25 @@ static void ddb_port_probe(struct ddb_port *port)
 		port->class = DDB_PORT_TUNER;
 		port->type = DDB_TUNER_DVBCT_TR;
 		ddbwritel(I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
+	} else if (port_has_cxd28xx(port, &id)) {
+		switch (id) {
+		case 0xa4:
+			modname = "DUAL DVB-C2T2 CXD2843";
+			port->type = DDB_TUNER_DVBC2T2_SONY;
+			break;
+		case 0xb1:
+			modname = "DUAL DVB-CT2 CXD2837";
+			port->type = DDB_TUNER_DVBCT2_SONY;
+			break;
+		case 0xb0:
+			modname = "DUAL ISDB-T CXD2838";
+			port->type = DDB_TUNER_ISDBT_SONY;
+			break;
+		default:
+			return;
+		}
+		port->class = DDB_PORT_TUNER;
+		ddbwritel(I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
 	}
 	printk(KERN_INFO "Port %d (TAB %d): %s\n",
 			 port->nr, port->nr+1, modname);
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 8b1b41d..04c56c2 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -147,6 +147,9 @@ struct ddb_port {
 #define DDB_TUNER_DVBS_ST_AA    2
 #define DDB_TUNER_DVBCT_TR     16
 #define DDB_TUNER_DVBCT_ST     17
+#define DDB_TUNER_DVBCT2_SONY  18
+#define DDB_TUNER_ISDBT_SONY   19
+#define DDB_TUNER_DVBC2T2_SONY 20
 	u32                    adr;
 
 	struct ddb_input      *input[2];
-- 
http://palosaari.fi/

