Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35384 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750987AbdFTRoq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 13:44:46 -0400
Received: by mail-wr0-f194.google.com with SMTP id z45so19154195wrb.2
        for <linux-media@vger.kernel.org>; Tue, 20 Jun 2017 10:44:46 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: liplianin@netup.ru, rjkm@metzlerbros.de
Subject: [PATCH] [media] ddbridge: use pr_* macros in favor of printk
Date: Tue, 20 Jun 2017 19:44:42 +0200
Message-Id: <20170620174442.7528-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Side effect: KERN_DEBUG messages aren't written to the kernel log anymore.
This also improves the tda18212_ping reporting a bit so users know that if
pinging wasn't successful, bad things might happen.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 64 +++++++++++++++---------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 9420479bee9a..fff03a332e08 100644
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
+		pr_err("I2C timeout\n");
 		{ /* MSI debugging*/
 			u32 istat = ddbreadl(INTERRUPT_STATUS);
-			printk(KERN_ERR "IRS %08x\n", istat);
+			pr_err("IRS %08x\n", istat);
 			ddbwritel(istat, INTERRUPT_ACK);
 		}
 		return -EIO;
@@ -533,7 +535,7 @@ static u32 ddb_input_avail(struct ddb_input *input)
 	off = (stat & 0x7ff) << 7;
 
 	if (ctrl & 4) {
-		printk(KERN_ERR "IA %d %d %08x\n", idx, off, ctrl);
+		pr_err("IA %d %d %08x\n", idx, off, ctrl);
 		ddbwritel(input->stat, DMA_BUFFER_ACK(input->nr));
 		return 0;
 	}
@@ -619,7 +621,7 @@ static int demod_attach_drxk(struct ddb_input *input)
 
 	fe = input->fe = dvb_attach(drxk_attach, &config, i2c);
 	if (!input->fe) {
-		printk(KERN_ERR "No DRXK found!\n");
+		pr_err("No DRXK found!\n");
 		return -ENODEV;
 	}
 	fe->sec_priv = input;
@@ -637,7 +639,7 @@ static int tuner_attach_tda18271(struct ddb_input *input)
 		input->fe->ops.i2c_gate_ctrl(input->fe, 1);
 	fe = dvb_attach(tda18271c2dd_attach, input->fe, i2c, 0x60);
 	if (!fe) {
-		printk(KERN_ERR "No TDA18271 found!\n");
+		pr_err("No TDA18271 found!\n");
 		return -ENODEV;
 	}
 	if (input->fe->ops.i2c_gate_ctrl)
@@ -676,7 +678,7 @@ static int demod_attach_stv0367(struct ddb_input *input)
 		&ddb_stv0367_config[(input->nr & 1)], i2c);
 
 	if (!input->fe) {
-		printk(KERN_ERR "stv0367ddb_attach failed (not found?)\n");
+		pr_err("stv0367ddb_attach failed (not found?)\n");
 		return -ENODEV;
 	}
 
@@ -693,14 +695,14 @@ static int tuner_tda18212_ping(struct ddb_input *input, unsigned short adr)
 	u8 tda_id[2];
 	u8 subaddr = 0x00;
 
-	printk(KERN_DEBUG "stv0367-tda18212 tuner ping\n");
+	pr_debug("stv0367-tda18212 tuner ping\n");
 	if (input->fe->ops.i2c_gate_ctrl)
 		input->fe->ops.i2c_gate_ctrl(input->fe, 1);
 
 	if (i2c_read_regs(adapter, adr, subaddr, tda_id, sizeof(tda_id)) < 0)
-		printk(KERN_DEBUG "tda18212 ping 1 fail\n");
+		pr_debug("tda18212 ping 1 fail\n");
 	if (i2c_read_regs(adapter, adr, subaddr, tda_id, sizeof(tda_id)) < 0)
-		printk(KERN_DEBUG "tda18212 ping 2 fail\n");
+		pr_warn("tda18212 ping failed, expect problems\n");
 
 	if (input->fe->ops.i2c_gate_ctrl)
 		input->fe->ops.i2c_gate_ctrl(input->fe, 0);
@@ -728,7 +730,7 @@ static int demod_attach_cxd28xx(struct ddb_input *input, int par, int osc24)
 	input->fe = dvb_attach(cxd2841er_attach_t_c, &cfg, i2c);
 
 	if (!input->fe) {
-		printk(KERN_ERR "No Sony CXD28xx found!\n");
+		pr_err("No Sony CXD28xx found!\n");
 		return -ENODEV;
 	}
 
@@ -786,7 +788,7 @@ static int tuner_attach_tda18212(struct ddb_input *input, u32 porttype)
 
 	return 0;
 err:
-	printk(KERN_INFO "TDA18212 tuner not found. Device is not fully operational.\n");
+	pr_warn("TDA18212 tuner not found. Device is not fully operational.\n");
 	return -ENODEV;
 }
 
@@ -853,13 +855,13 @@ static int demod_attach_stv0900(struct ddb_input *input, int type)
 			       (input->nr & 1) ? STV090x_DEMODULATOR_1
 			       : STV090x_DEMODULATOR_0);
 	if (!input->fe) {
-		printk(KERN_ERR "No STV0900 found!\n");
+		pr_err("No STV0900 found!\n");
 		return -ENODEV;
 	}
 	if (!dvb_attach(lnbh24_attach, input->fe, i2c, 0,
 			0, (input->nr & 1) ?
 			(0x09 - type) : (0x0b - type))) {
-		printk(KERN_ERR "No LNBH24 found!\n");
+		pr_err("No LNBH24 found!\n");
 		return -ENODEV;
 	}
 	return 0;
@@ -875,10 +877,10 @@ static int tuner_attach_stv6110(struct ddb_input *input, int type)
 
 	ctl = dvb_attach(stv6110x_attach, input->fe, tunerconf, i2c);
 	if (!ctl) {
-		printk(KERN_ERR "No STV6110X found!\n");
+		pr_err("No STV6110X found!\n");
 		return -ENODEV;
 	}
-	printk(KERN_INFO "attach tuner input %d adr %02x\n",
+	pr_info("attach tuner input %d adr %02x\n",
 			 input->nr, tunerconf->addr);
 
 	feconf->tuner_init          = ctl->tuner_init;
@@ -1015,7 +1017,7 @@ static int dvb_input_attach(struct ddb_input *input)
 				   &input->port->dev->pdev->dev,
 				   adapter_nr);
 	if (ret < 0) {
-		printk(KERN_ERR "ddbridge: Could not register adapter.Check if you enabled enough adapters in dvb-core!\n");
+		pr_err("Could not register adapter. Check if you enabled enough adapters in dvb-core!\n");
 		return ret;
 	}
 	input->attached = 1;
@@ -1241,7 +1243,7 @@ static void input_tasklet(unsigned long data)
 
 	if (input->port->class == DDB_PORT_TUNER) {
 		if (4&ddbreadl(DMA_BUFFER_CONTROL(input->nr)))
-			printk(KERN_ERR "Overflow input %d\n", input->nr);
+			pr_err("Overflow input %d\n", input->nr);
 		while (input->cbuf != ((input->stat >> 11) & 0x1f)
 		       || (4&ddbreadl(DMA_BUFFER_CONTROL(input->nr)))) {
 			dvb_dmx_swfilter_packets(&input->demux,
@@ -1326,7 +1328,7 @@ static int ddb_port_attach(struct ddb_port *port)
 		break;
 	}
 	if (ret < 0)
-		printk(KERN_ERR "port_attach on port %d failed\n", port->nr);
+		pr_err("port_attach on port %d failed\n", port->nr);
 	return ret;
 }
 
@@ -1511,7 +1513,7 @@ static void ddb_port_probe(struct ddb_port *port)
 		port->class = DDB_PORT_CI;
 		ddbwritel(I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
 	} else if (port_has_xo2(port, &xo2_type, &xo2_id)) {
-		printk(KERN_INFO "Port %d (TAB %d): XO2 type: %d, id: %d\n",
+		pr_debug("Port %d (TAB %d): XO2 type: %d, id: %d\n",
 			port->nr, port->nr+1, xo2_type, xo2_id);
 
 		ddbwritel(I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
@@ -1556,10 +1558,10 @@ static void ddb_port_probe(struct ddb_port *port)
 			}
 			break;
 		case DDB_XO2_TYPE_CI:
-			printk(KERN_INFO "DuoFlex CI modules not supported\n");
+			pr_info("DuoFlex CI modules not supported\n");
 			break;
 		default:
-			printk(KERN_INFO "Unknown XO2 DuoFlex module\n");
+			pr_info("Unknown XO2 DuoFlex module\n");
 			break;
 		}
 	} else if (port_has_cxd28xx(port, &cxd_id)) {
@@ -1611,7 +1613,7 @@ static void ddb_port_probe(struct ddb_port *port)
 		ddbwritel(I2C_SPEED_100, port->i2c->regs + I2C_TIMING);
 	}
 
-	printk(KERN_INFO "Port %d (TAB %d): %s\n",
+	pr_info("Port %d (TAB %d): %s\n",
 			 port->nr, port->nr+1, modname);
 }
 
@@ -1993,7 +1995,7 @@ static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dev->pdev = pdev;
 	pci_set_drvdata(pdev, dev);
 	dev->info = (struct ddb_info *) id->driver_data;
-	printk(KERN_INFO "DDBridge driver detected: %s\n", dev->info->name);
+	pr_info("Detected %s\n", dev->info->name);
 
 	dev->regs = ioremap(pci_resource_start(dev->pdev, 0),
 			    pci_resource_len(dev->pdev, 0));
@@ -2001,13 +2003,13 @@ static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		stat = -ENOMEM;
 		goto fail;
 	}
-	printk(KERN_INFO "HW %08x FW %08x\n", ddbreadl(0), ddbreadl(4));
+	pr_info("HW %08x FW %08x\n", ddbreadl(0), ddbreadl(4));
 
 #ifdef CONFIG_PCI_MSI
 	if (pci_msi_enabled())
 		stat = pci_enable_msi(dev->pdev);
 	if (stat) {
-		printk(KERN_INFO ": MSI not available.\n");
+		pr_info("MSI not available.\n");
 	} else {
 		irq_flag = 0;
 		dev->msi = 1;
@@ -2040,7 +2042,7 @@ static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto fail1;
 	ddb_ports_init(dev);
 	if (ddb_buffers_alloc(dev) < 0) {
-		printk(KERN_INFO ": Could not allocate buffer memory\n");
+		pr_info("Could not allocate buffer memory\n");
 		goto fail2;
 	}
 	if (ddb_ports_attach(dev) < 0)
@@ -2050,19 +2052,19 @@ static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 fail3:
 	ddb_ports_detach(dev);
-	printk(KERN_ERR "fail3\n");
+	pr_err("fail3\n");
 	ddb_ports_release(dev);
 fail2:
-	printk(KERN_ERR "fail2\n");
+	pr_err("fail2\n");
 	ddb_buffers_free(dev);
 fail1:
-	printk(KERN_ERR "fail1\n");
+	pr_err("fail1\n");
 	if (dev->msi)
 		pci_disable_msi(dev->pdev);
 	if (stat == 0)
 		free_irq(dev->pdev->irq, dev);
 fail:
-	printk(KERN_ERR "fail\n");
+	pr_err("fail\n");
 	ddb_unmap(dev);
 	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
@@ -2242,7 +2244,7 @@ static __init int module_init_ddbridge(void)
 {
 	int ret;
 
-	printk(KERN_INFO "Digital Devices PCIE bridge driver, Copyright (C) 2010-11 Digital Devices GmbH\n");
+	pr_info("Digital Devices PCIE bridge driver, Copyright (C) 2010-11 Digital Devices GmbH\n");
 
 	ret = ddb_class_create();
 	if (ret < 0)
-- 
2.13.0
