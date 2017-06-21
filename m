Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35015 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752155AbdFUQxv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 12:53:51 -0400
Received: by mail-wr0-f193.google.com with SMTP id z45so28009057wrb.2
        for <linux-media@vger.kernel.org>; Wed, 21 Jun 2017 09:53:50 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: liplianin@netup.ru, rjkm@metzlerbros.de
Subject: [PATCH] [media] ddbridge: use dev_* macros in favor of printk
Date: Wed, 21 Jun 2017 18:53:47 +0200
Message-Id: <20170621165347.19409-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Side effect: KERN_DEBUG messages aren't written to the kernel log anymore.
This also improves the tda18212_ping reporting a bit so users know that if
pinging wasn't successful, bad things will happen.

Since in module_init_ddbridge() there's no dev yet, pr_info is used
instead.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 78 ++++++++++++++++++------------
 1 file changed, 46 insertions(+), 32 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 9420479bee9a..540a121eadd6 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -17,6 +17,8 @@
  * http://www.gnu.org/copyleft/gpl.html
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -124,10 +126,10 @@ static int ddb_i2c_cmd(struct ddb_i2c *i2c, u32 adr, u32 cmd)
 	ddbwritel((adr << 9) | cmd, i2c->regs + I2C_COMMAND);
 	stat = wait_event_timeout(i2c->wq, i2c->done == 1, HZ);
 	if (stat == 0) {
-		printk(KERN_ERR "I2C timeout\n");
+		dev_err(&dev->pdev->dev, "I2C timeout\n");
 		{ /* MSI debugging*/
 			u32 istat = ddbreadl(INTERRUPT_STATUS);
-			printk(KERN_ERR "IRS %08x\n", istat);
+			dev_err(&dev->pdev->dev, "IRS %08x\n", istat);
 			ddbwritel(istat, INTERRUPT_ACK);
 		}
 		return -EIO;
@@ -533,7 +535,7 @@ static u32 ddb_input_avail(struct ddb_input *input)
 	off = (stat & 0x7ff) << 7;
 
 	if (ctrl & 4) {
-		printk(KERN_ERR "IA %d %d %08x\n", idx, off, ctrl);
+		dev_err(&dev->pdev->dev, "IA %d %d %08x\n", idx, off, ctrl);
 		ddbwritel(input->stat, DMA_BUFFER_ACK(input->nr));
 		return 0;
 	}
@@ -611,6 +613,7 @@ static int demod_attach_drxk(struct ddb_input *input)
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
 	struct dvb_frontend *fe;
 	struct drxk_config config;
+	struct device *dev = &input->port->dev->pdev->dev;
 
 	memset(&config, 0, sizeof(config));
 	config.microcode_name = "drxk_a3.mc";
@@ -619,7 +622,7 @@ static int demod_attach_drxk(struct ddb_input *input)
 
 	fe = input->fe = dvb_attach(drxk_attach, &config, i2c);
 	if (!input->fe) {
-		printk(KERN_ERR "No DRXK found!\n");
+		dev_err(dev, "No DRXK found!\n");
 		return -ENODEV;
 	}
 	fe->sec_priv = input;
@@ -632,12 +635,13 @@ static int tuner_attach_tda18271(struct ddb_input *input)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
 	struct dvb_frontend *fe;
+	struct device *dev = &input->port->dev->pdev->dev;
 
 	if (input->fe->ops.i2c_gate_ctrl)
 		input->fe->ops.i2c_gate_ctrl(input->fe, 1);
 	fe = dvb_attach(tda18271c2dd_attach, input->fe, i2c, 0x60);
 	if (!fe) {
-		printk(KERN_ERR "No TDA18271 found!\n");
+		dev_err(dev, "No TDA18271 found!\n");
 		return -ENODEV;
 	}
 	if (input->fe->ops.i2c_gate_ctrl)
@@ -670,13 +674,14 @@ static struct stv0367_config ddb_stv0367_config[] = {
 static int demod_attach_stv0367(struct ddb_input *input)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct device *dev = &input->port->dev->pdev->dev;
 
 	/* attach frontend */
 	input->fe = dvb_attach(stv0367ddb_attach,
 		&ddb_stv0367_config[(input->nr & 1)], i2c);
 
 	if (!input->fe) {
-		printk(KERN_ERR "stv0367ddb_attach failed (not found?)\n");
+		dev_err(dev, "stv0367ddb_attach failed (not found?)\n");
 		return -ENODEV;
 	}
 
@@ -690,17 +695,19 @@ static int demod_attach_stv0367(struct ddb_input *input)
 static int tuner_tda18212_ping(struct ddb_input *input, unsigned short adr)
 {
 	struct i2c_adapter *adapter = &input->port->i2c->adap;
+	struct device *dev = &input->port->dev->pdev->dev;
+
 	u8 tda_id[2];
 	u8 subaddr = 0x00;
 
-	printk(KERN_DEBUG "stv0367-tda18212 tuner ping\n");
+	dev_dbg(dev, "stv0367-tda18212 tuner ping\n");
 	if (input->fe->ops.i2c_gate_ctrl)
 		input->fe->ops.i2c_gate_ctrl(input->fe, 1);
 
 	if (i2c_read_regs(adapter, adr, subaddr, tda_id, sizeof(tda_id)) < 0)
-		printk(KERN_DEBUG "tda18212 ping 1 fail\n");
+		dev_dbg(dev, "tda18212 ping 1 fail\n");
 	if (i2c_read_regs(adapter, adr, subaddr, tda_id, sizeof(tda_id)) < 0)
-		printk(KERN_DEBUG "tda18212 ping 2 fail\n");
+		dev_warn(dev, "tda18212 ping failed, expect problems\n");
 
 	if (input->fe->ops.i2c_gate_ctrl)
 		input->fe->ops.i2c_gate_ctrl(input->fe, 0);
@@ -711,6 +718,7 @@ static int tuner_tda18212_ping(struct ddb_input *input, unsigned short adr)
 static int demod_attach_cxd28xx(struct ddb_input *input, int par, int osc24)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct device *dev = &input->port->dev->pdev->dev;
 	struct cxd2841er_config cfg;
 
 	/* the cxd2841er driver expects 8bit/shifted I2C addresses */
@@ -728,7 +736,7 @@ static int demod_attach_cxd28xx(struct ddb_input *input, int par, int osc24)
 	input->fe = dvb_attach(cxd2841er_attach_t_c, &cfg, i2c);
 
 	if (!input->fe) {
-		printk(KERN_ERR "No Sony CXD28xx found!\n");
+		dev_err(dev, "No Sony CXD28xx found!\n");
 		return -ENODEV;
 	}
 
@@ -742,6 +750,7 @@ static int demod_attach_cxd28xx(struct ddb_input *input, int par, int osc24)
 static int tuner_attach_tda18212(struct ddb_input *input, u32 porttype)
 {
 	struct i2c_adapter *adapter = &input->port->i2c->adap;
+	struct device *dev = &input->port->dev->pdev->dev;
 	struct i2c_client *client;
 	struct tda18212_config config = {
 		.fe = input->fe,
@@ -786,7 +795,7 @@ static int tuner_attach_tda18212(struct ddb_input *input, u32 porttype)
 
 	return 0;
 err:
-	printk(KERN_INFO "TDA18212 tuner not found. Device is not fully operational.\n");
+	dev_warn(dev, "TDA18212 tuner not found. Device is not fully operational.\n");
 	return -ENODEV;
 }
 
@@ -847,19 +856,20 @@ static struct stv6110x_config stv6110b = {
 static int demod_attach_stv0900(struct ddb_input *input, int type)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct device *dev = &input->port->dev->pdev->dev;
 	struct stv090x_config *feconf = type ? &stv0900_aa : &stv0900;
 
 	input->fe = dvb_attach(stv090x_attach, feconf, i2c,
 			       (input->nr & 1) ? STV090x_DEMODULATOR_1
 			       : STV090x_DEMODULATOR_0);
 	if (!input->fe) {
-		printk(KERN_ERR "No STV0900 found!\n");
+		dev_err(dev, "No STV0900 found!\n");
 		return -ENODEV;
 	}
 	if (!dvb_attach(lnbh24_attach, input->fe, i2c, 0,
 			0, (input->nr & 1) ?
 			(0x09 - type) : (0x0b - type))) {
-		printk(KERN_ERR "No LNBH24 found!\n");
+		dev_err(dev, "No LNBH24 found!\n");
 		return -ENODEV;
 	}
 	return 0;
@@ -868,6 +878,7 @@ static int demod_attach_stv0900(struct ddb_input *input, int type)
 static int tuner_attach_stv6110(struct ddb_input *input, int type)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct device *dev = &input->port->dev->pdev->dev;
 	struct stv090x_config *feconf = type ? &stv0900_aa : &stv0900;
 	struct stv6110x_config *tunerconf = (input->nr & 1) ?
 		&stv6110b : &stv6110a;
@@ -875,10 +886,10 @@ static int tuner_attach_stv6110(struct ddb_input *input, int type)
 
 	ctl = dvb_attach(stv6110x_attach, input->fe, tunerconf, i2c);
 	if (!ctl) {
-		printk(KERN_ERR "No STV6110X found!\n");
+		dev_err(dev, "No STV6110X found!\n");
 		return -ENODEV;
 	}
-	printk(KERN_INFO "attach tuner input %d adr %02x\n",
+	dev_info(dev, "attach tuner input %d adr %02x\n",
 			 input->nr, tunerconf->addr);
 
 	feconf->tuner_init          = ctl->tuner_init;
@@ -1009,13 +1020,14 @@ static int dvb_input_attach(struct ddb_input *input)
 	struct ddb_port *port = input->port;
 	struct dvb_adapter *adap = &input->adap;
 	struct dvb_demux *dvbdemux = &input->demux;
+	struct device *dev = &input->port->dev->pdev->dev;
 	int sony_osc24 = 0, sony_tspar = 0;
 
 	ret = dvb_register_adapter(adap, "DDBridge", THIS_MODULE,
 				   &input->port->dev->pdev->dev,
 				   adapter_nr);
 	if (ret < 0) {
-		printk(KERN_ERR "ddbridge: Could not register adapter.Check if you enabled enough adapters in dvb-core!\n");
+		dev_err(dev, "Could not register adapter. Check if you enabled enough adapters in dvb-core!\n");
 		return ret;
 	}
 	input->attached = 1;
@@ -1241,7 +1253,7 @@ static void input_tasklet(unsigned long data)
 
 	if (input->port->class == DDB_PORT_TUNER) {
 		if (4&ddbreadl(DMA_BUFFER_CONTROL(input->nr)))
-			printk(KERN_ERR "Overflow input %d\n", input->nr);
+			dev_err(&dev->pdev->dev, "Overflow input %d\n", input->nr);
 		while (input->cbuf != ((input->stat >> 11) & 0x1f)
 		       || (4&ddbreadl(DMA_BUFFER_CONTROL(input->nr)))) {
 			dvb_dmx_swfilter_packets(&input->demux,
@@ -1310,6 +1322,7 @@ static int ddb_ci_attach(struct ddb_port *port)
 
 static int ddb_port_attach(struct ddb_port *port)
 {
+	struct device *dev = &port->dev->pdev->dev;
 	int ret = 0;
 
 	switch (port->class) {
@@ -1326,7 +1339,7 @@ static int ddb_port_attach(struct ddb_port *port)
 		break;
 	}
 	if (ret < 0)
-		printk(KERN_ERR "port_attach on port %d failed\n", port->nr);
+		dev_err(dev, "port_attach on port %d failed\n", port->nr);
 	return ret;
 }
 
@@ -1377,6 +1390,7 @@ static void ddb_ports_detach(struct ddb *dev)
 static int init_xo2(struct ddb_port *port)
 {
 	struct i2c_adapter *i2c = &port->i2c->adap;
+	struct device *dev = &port->dev->pdev->dev;
 	u8 val, data[2];
 	int res;
 
@@ -1385,7 +1399,7 @@ static int init_xo2(struct ddb_port *port)
 		return res;
 
 	if (data[0] != 0x01)  {
-		pr_info("Port %d: invalid XO2\n", port->nr);
+		dev_info(dev, "Port %d: invalid XO2\n", port->nr);
 		return -1;
 	}
 
@@ -1511,7 +1525,7 @@ static void ddb_port_probe(struct ddb_port *port)
 		port->class = DDB_PORT_CI;
 		ddbwritel(I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
 	} else if (port_has_xo2(port, &xo2_type, &xo2_id)) {
-		printk(KERN_INFO "Port %d (TAB %d): XO2 type: %d, id: %d\n",
+		dev_dbg(&dev->pdev->dev, "Port %d (TAB %d): XO2 type: %d, id: %d\n",
 			port->nr, port->nr+1, xo2_type, xo2_id);
 
 		ddbwritel(I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
@@ -1556,10 +1570,10 @@ static void ddb_port_probe(struct ddb_port *port)
 			}
 			break;
 		case DDB_XO2_TYPE_CI:
-			printk(KERN_INFO "DuoFlex CI modules not supported\n");
+			dev_info(&dev->pdev->dev, "DuoFlex CI modules not supported\n");
 			break;
 		default:
-			printk(KERN_INFO "Unknown XO2 DuoFlex module\n");
+			dev_info(&dev->pdev->dev, "Unknown XO2 DuoFlex module\n");
 			break;
 		}
 	} else if (port_has_cxd28xx(port, &cxd_id)) {
@@ -1611,7 +1625,7 @@ static void ddb_port_probe(struct ddb_port *port)
 		ddbwritel(I2C_SPEED_100, port->i2c->regs + I2C_TIMING);
 	}
 
-	printk(KERN_INFO "Port %d (TAB %d): %s\n",
+	dev_info(&dev->pdev->dev, "Port %d (TAB %d): %s\n",
 			 port->nr, port->nr+1, modname);
 }
 
@@ -1993,7 +2007,7 @@ static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dev->pdev = pdev;
 	pci_set_drvdata(pdev, dev);
 	dev->info = (struct ddb_info *) id->driver_data;
-	printk(KERN_INFO "DDBridge driver detected: %s\n", dev->info->name);
+	dev_info(&pdev->dev, "Detected %s\n", dev->info->name);
 
 	dev->regs = ioremap(pci_resource_start(dev->pdev, 0),
 			    pci_resource_len(dev->pdev, 0));
@@ -2001,13 +2015,13 @@ static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		stat = -ENOMEM;
 		goto fail;
 	}
-	printk(KERN_INFO "HW %08x FW %08x\n", ddbreadl(0), ddbreadl(4));
+	dev_info(&pdev->dev, "HW %08x FW %08x\n", ddbreadl(0), ddbreadl(4));
 
 #ifdef CONFIG_PCI_MSI
 	if (pci_msi_enabled())
 		stat = pci_enable_msi(dev->pdev);
 	if (stat) {
-		printk(KERN_INFO ": MSI not available.\n");
+		dev_info(&pdev->dev, "MSI not available.\n");
 	} else {
 		irq_flag = 0;
 		dev->msi = 1;
@@ -2040,7 +2054,7 @@ static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto fail1;
 	ddb_ports_init(dev);
 	if (ddb_buffers_alloc(dev) < 0) {
-		printk(KERN_INFO ": Could not allocate buffer memory\n");
+		dev_err(&pdev->dev, "Could not allocate buffer memory\n");
 		goto fail2;
 	}
 	if (ddb_ports_attach(dev) < 0)
@@ -2050,19 +2064,19 @@ static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 fail3:
 	ddb_ports_detach(dev);
-	printk(KERN_ERR "fail3\n");
+	dev_err(&pdev->dev, "fail3\n");
 	ddb_ports_release(dev);
 fail2:
-	printk(KERN_ERR "fail2\n");
+	dev_err(&pdev->dev, "fail2\n");
 	ddb_buffers_free(dev);
 fail1:
-	printk(KERN_ERR "fail1\n");
+	dev_err(&pdev->dev, "fail1\n");
 	if (dev->msi)
 		pci_disable_msi(dev->pdev);
 	if (stat == 0)
 		free_irq(dev->pdev->irq, dev);
 fail:
-	printk(KERN_ERR "fail\n");
+	dev_err(&pdev->dev, "fail\n");
 	ddb_unmap(dev);
 	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
@@ -2242,7 +2256,7 @@ static __init int module_init_ddbridge(void)
 {
 	int ret;
 
-	printk(KERN_INFO "Digital Devices PCIE bridge driver, Copyright (C) 2010-11 Digital Devices GmbH\n");
+	pr_info("Digital Devices PCIE bridge driver, Copyright (C) 2010-11 Digital Devices GmbH\n");
 
 	ret = ddb_class_create();
 	if (ret < 0)
-- 
2.13.0
