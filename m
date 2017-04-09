Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33444 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752631AbdDITix (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Apr 2017 15:38:53 -0400
Received: by mail-wm0-f68.google.com with SMTP id o81so6391457wmb.0
        for <linux-media@vger.kernel.org>; Sun, 09 Apr 2017 12:38:47 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: aospan@netup.ru, serjk@netup.ru, mchehab@kernel.org,
        linux-media@vger.kernel.org
Cc: rjkm@metzlerbros.de
Subject: [PATCH 17/19] [media] ddbridge: add I2C functions, add XO2 module support
Date: Sun,  9 Apr 2017 21:38:26 +0200
Message-Id: <20170409193828.18458-18-d.scheller.oss@gmail.com>
In-Reply-To: <20170409193828.18458-1-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Some Flex modules (mostly with anyof C/C2/T/T2 demods based on the Sony
CXD28xxER series) are equipped with an interface named XO2 (which
appears to be the Lattice MachXO2). Add functionality to detect such
links and initialise them, so any tuner module with such an interface can
be used.

This also adds dummy detection for any possible connected module, telling
the user it isn't supported at this very moment.

Also adds i2c_io(), i2c_write() and i2c_write_reg(), all required for the
XO2 handling functionality.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 147 +++++++++++++++++++++++++++++
 drivers/media/pci/ddbridge/ddbridge.h      |  11 +++
 2 files changed, 158 insertions(+)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 6b49fa9..ab88fcf 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -43,6 +43,10 @@
 #include "stv0367_priv.h"
 #include "tda18212.h"
 
+static int xo2_speed = 2;
+module_param(xo2_speed, int, 0444);
+MODULE_PARM_DESC(xo2_speed, "default transfer speed for xo2 based duoflex, 0=55,1=75,2=90,3=104 MBit/s, default=2, use attribute to change for individual cards");
+
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 /* MSI had problems with lost interrupts, fixed but needs testing */
@@ -50,6 +54,24 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 /******************************************************************************/
 
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
 static int i2c_read(struct i2c_adapter *adapter, u8 adr, u8 *val)
 {
 	struct i2c_msg msgs[1] = {{.addr = adr,  .flags = I2C_M_RD,
@@ -83,6 +105,14 @@ static int i2c_read_reg16(struct i2c_adapter *adapter, u8 adr,
 	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
 }
 
+static int i2c_write_reg(struct i2c_adapter *adap, u8 adr,
+			 u8 reg, u8 val)
+{
+	u8 msg[2] = {reg, val};
+
+	return i2c_write(adap, adr, msg, 2);
+}
+
 static int ddb_i2c_cmd(struct ddb_i2c *i2c, u32 adr, u32 cmd)
 {
 	struct ddb *dev = i2c->dev;
@@ -1272,6 +1302,70 @@ static void ddb_ports_detach(struct ddb *dev)
 /****************************************************************************/
 /****************************************************************************/
 
+static int init_xo2(struct ddb_port *port)
+{
+	struct i2c_adapter *i2c = &port->i2c->adap;
+	u8 val, data[2];
+	int res;
+
+	res = i2c_read_regs(i2c, 0x10, 0x04, data, 2);
+	if (res < 0)
+		return res;
+
+	if (data[0] != 0x01)  {
+		pr_info("Port %d: invalid XO2\n", port->nr);
+		return -1;
+	}
+
+	i2c_read_reg(i2c, 0x10, 0x08, &val);
+	if (val != 0) {
+		i2c_write_reg(i2c, 0x10, 0x08, 0x00);
+		msleep(100);
+	}
+	/* Enable tuner power, disable pll, reset demods */
+	i2c_write_reg(i2c, 0x10, 0x08, 0x04);
+	usleep_range(2000, 3000);
+	/* Release demod resets */
+	i2c_write_reg(i2c, 0x10, 0x08, 0x07);
+
+	/* speed: 0=55,1=75,2=90,3=104 MBit/s */
+	i2c_write_reg(i2c, 0x10, 0x09,
+		((xo2_speed >= 0 && xo2_speed <= 3) ? xo2_speed : 2));
+
+	i2c_write_reg(i2c, 0x10, 0x0a, 0x01);
+	i2c_write_reg(i2c, 0x10, 0x0b, 0x01);
+
+	usleep_range(2000, 3000);
+	/* Start XO2 PLL */
+	i2c_write_reg(i2c, 0x10, 0x08, 0x87);
+
+	return 0;
+}
+
+static int port_has_xo2(struct ddb_port *port, u8 *type, u8 *id)
+{
+	u8 probe[1] = { 0x00 }, data[4];
+
+	*type = DDB_XO2_TYPE_NONE;
+
+	if (i2c_io(&port->i2c->adap, 0x10, probe, 1, data, 4))
+		return 0;
+	if (data[0] == 'D' && data[1] == 'F') {
+		*id = data[2];
+		*type = DDB_XO2_TYPE_DUOFLEX;
+		return 1;
+	}
+	if (data[0] == 'C' && data[1] == 'I') {
+		*id = data[2];
+		*type = DDB_XO2_TYPE_CI;
+		return 1;
+	}
+	return 0;
+}
+
+/****************************************************************************/
+/****************************************************************************/
+
 static int port_has_ci(struct ddb_port *port)
 {
 	u8 val;
@@ -1322,6 +1416,7 @@ static void ddb_port_probe(struct ddb_port *port)
 {
 	struct ddb *dev = port->dev;
 	char *modname = "NO MODULE";
+	u8 xo2_type, xo2_id;
 
 	port->class = DDB_PORT_NONE;
 
@@ -1329,6 +1424,58 @@ static void ddb_port_probe(struct ddb_port *port)
 		modname = "CI";
 		port->class = DDB_PORT_CI;
 		ddbwritel(I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
+	} else if (port_has_xo2(port, &xo2_type, &xo2_id)) {
+		printk(KERN_INFO "Port %d (TAB %d): XO2 type: %d, id: %d\n",
+			port->nr, port->nr+1, xo2_type, xo2_id);
+
+		ddbwritel(I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
+
+		switch (xo2_type) {
+		case DDB_XO2_TYPE_DUOFLEX:
+			init_xo2(port);
+			switch (xo2_id >> 2) {
+			case 0:
+				modname = "DUAL DVB-S2 (unsupported)";
+				port->class = DDB_PORT_NONE;
+				port->type = DDB_TUNER_XO2_DVBS_STV0910;
+				break;
+			case 1:
+				modname = "DUAL DVB-C/T/T2 (unsupported)";
+				port->class = DDB_PORT_NONE;
+				port->type = DDB_TUNER_XO2_DVBCT2_SONY;
+				break;
+			case 2:
+				modname = "DUAL DVB-ISDBT (unsupported)";
+				port->class = DDB_PORT_NONE;
+				port->type = DDB_TUNER_XO2_ISDBT_SONY;
+				break;
+			case 3:
+				modname = "DUAL DVB-C/C2/T/T2 (unsupported)";
+				port->class = DDB_PORT_NONE;
+				port->type = DDB_TUNER_XO2_DVBC2T2_SONY;
+				break;
+			case 4:
+				modname = "DUAL ATSC (unsupported)";
+				port->class = DDB_PORT_NONE;
+				port->type = DDB_TUNER_XO2_ATSC_ST;
+				break;
+			case 5:
+				modname = "DUAL DVB-C/C2/T/T2/ISDBT (unsupported)";
+				port->class = DDB_PORT_NONE;
+				port->type = DDB_TUNER_XO2_DVBC2T2I_SONY;
+				break;
+			default:
+				modname = "Unknown XO2 DuoFlex module\n";
+				break;
+			}
+			break;
+		case DDB_XO2_TYPE_CI:
+			printk(KERN_INFO "DuoFlex CI modules not supported\n");
+			break;
+		default:
+			printk(KERN_INFO "Unknown XO2 DuoFlex module\n");
+			break;
+		}
 	} else if (port_has_stv0900(port)) {
 		modname = "DUAL DVB-S2";
 		port->class = DDB_PORT_TUNER;
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 734e18e..4e49faa 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -48,6 +48,10 @@
 
 #define DDB_LINK_TAG(_x) (_x << DDB_LINK_SHIFT)
 
+#define DDB_XO2_TYPE_NONE	0
+#define DDB_XO2_TYPE_DUOFLEX	1
+#define DDB_XO2_TYPE_CI		2
+
 struct ddb_info {
 	int   type;
 #define DDB_NONE         0
@@ -154,6 +158,13 @@ struct ddb_port {
 #define DDB_TUNER_DVBS_ST_AA    2
 #define DDB_TUNER_DVBCT_TR     16
 #define DDB_TUNER_DVBCT_ST     17
+#define DDB_TUNER_XO2_DVBS_STV0910	32
+#define DDB_TUNER_XO2_DVBCT2_SONY	33
+#define DDB_TUNER_XO2_ISDBT_SONY	34
+#define DDB_TUNER_XO2_DVBC2T2_SONY	35
+#define DDB_TUNER_XO2_ATSC_ST		36
+#define DDB_TUNER_XO2_DVBC2T2I_SONY	37
+
 	u32                    adr;
 
 	struct ddb_input      *input[2];
-- 
2.10.2
