Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36540 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752470AbdGITm2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Jul 2017 15:42:28 -0400
Received: by mail-wr0-f194.google.com with SMTP id 77so20374491wrb.3
        for <linux-media@vger.kernel.org>; Sun, 09 Jul 2017 12:42:27 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, d_spingler@gmx.de, rjkm@metzlerbros.de
Subject: [PATCH 02/14] [media] ddbridge: split code into multiple files
Date: Sun,  9 Jul 2017 21:42:09 +0200
Message-Id: <20170709194221.10255-3-d.scheller.oss@gmail.com>
In-Reply-To: <20170709194221.10255-1-d.scheller.oss@gmail.com>
References: <20170709194221.10255-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

As of 0.9.9b, the ddbridge code has been split from one single file
(ddbridge-core.c) into multiple files, with the purpose of taking care of
different topics, and to be able to reuse code in different kernel modules
(ddbridge.ko and octonet.ko). This applies the same code split, with a
notable difference:

In the vendor package, the split was done by moving all code parts into
separate files, and in the "main" code files (ddbridge.c and octonet.c),
a simple "#include ddbridge-core.c" was done.

In this patch, the same split (codewise) is done, but all resulting .c/.o
files will be handled by the makefile, with proper prototyping of all
shared functions done in ddbridge.h.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/Makefile        |   2 +-
 drivers/media/pci/ddbridge/ddbridge-core.c | 588 +----------------------------
 drivers/media/pci/ddbridge/ddbridge-i2c.c  | 231 ++++++++++++
 drivers/media/pci/ddbridge/ddbridge-main.c | 388 +++++++++++++++++++
 drivers/media/pci/ddbridge/ddbridge.h      |  49 +++
 5 files changed, 681 insertions(+), 577 deletions(-)
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-i2c.c
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-main.c

diff --git a/drivers/media/pci/ddbridge/Makefile b/drivers/media/pci/ddbridge/Makefile
index 7446c8b677b5..fe8ff0c681ad 100644
--- a/drivers/media/pci/ddbridge/Makefile
+++ b/drivers/media/pci/ddbridge/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the ddbridge device driver
 #
 
-ddbridge-objs := ddbridge-core.o
+ddbridge-objs := ddbridge-main.o ddbridge-core.o ddbridge-i2c.o
 
 obj-$(CONFIG_DVB_DDBRIDGE) += ddbridge.o
 
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 4d6ab46cb635..ccbc9f41b10e 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -32,8 +32,8 @@
 #include <linux/i2c.h>
 #include <linux/swab.h>
 #include <linux/vmalloc.h>
-#include "ddbridge.h"
 
+#include "ddbridge.h"
 #include "ddbridge-regs.h"
 
 #include "tda18271c2dd.h"
@@ -49,227 +49,8 @@
 #include "stv6111.h"
 #include "lnbh25.h"
 
-static int xo2_speed = 2;
-module_param(xo2_speed, int, 0444);
-MODULE_PARM_DESC(xo2_speed, "default transfer speed for xo2 based duoflex, 0=55,1=75,2=90,3=104 MBit/s, default=2, use attribute to change for individual cards");
-
-static int stv0910_single;
-module_param(stv0910_single, int, 0444);
-MODULE_PARM_DESC(stv0910_single, "use stv0910 cards as single demods");
-
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-/* MSI had problems with lost interrupts, fixed but needs testing */
-#undef CONFIG_PCI_MSI
-
-/******************************************************************************/
-
-static int i2c_io(struct i2c_adapter *adapter, u8 adr,
-		  u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
-{
-	struct i2c_msg msgs[2] = {{.addr = adr,  .flags = 0,
-				   .buf  = wbuf, .len   = wlen },
-				  {.addr = adr,  .flags = I2C_M_RD,
-				   .buf  = rbuf,  .len   = rlen } };
-	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
-}
-
-static int i2c_write(struct i2c_adapter *adap, u8 adr, u8 *data, int len)
-{
-	struct i2c_msg msg = {.addr = adr, .flags = 0,
-			      .buf = data, .len = len};
-
-	return (i2c_transfer(adap, &msg, 1) == 1) ? 0 : -1;
-}
-
-static int i2c_read(struct i2c_adapter *adapter, u8 adr, u8 *val)
-{
-	struct i2c_msg msgs[1] = {{.addr = adr,  .flags = I2C_M_RD,
-				   .buf  = val,  .len   = 1 } };
-	return (i2c_transfer(adapter, msgs, 1) == 1) ? 0 : -1;
-}
-
-static int i2c_read_regs(struct i2c_adapter *adapter,
-			 u8 adr, u8 reg, u8 *val, u8 len)
-{
-	struct i2c_msg msgs[2] = {{.addr = adr,  .flags = 0,
-				   .buf  = &reg, .len   = 1 },
-				  {.addr = adr,  .flags = I2C_M_RD,
-				   .buf  = val,  .len   = len } };
-	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
-}
-
-static int i2c_read_reg(struct i2c_adapter *adapter, u8 adr, u8 reg, u8 *val)
-{
-	return i2c_read_regs(adapter, adr, reg, val, 1);
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
-static int i2c_write_reg(struct i2c_adapter *adap, u8 adr,
-			 u8 reg, u8 val)
-{
-	u8 msg[2] = {reg, val};
-
-	return i2c_write(adap, adr, msg, 2);
-}
-
-static inline u32 safe_ddbreadl(struct ddb *dev, u32 adr)
-{
-	u32 val = ddbreadl(adr);
-
-	/* (ddb)readl returns (uint)-1 (all bits set) on failure, catch that */
-	if (val == ~0) {
-		dev_err(&dev->pdev->dev, "ddbreadl failure, adr=%08x\n", adr);
-		return 0;
-	}
-
-	return val;
-}
-
-static int ddb_i2c_cmd(struct ddb_i2c *i2c, u32 adr, u32 cmd)
-{
-	struct ddb *dev = i2c->dev;
-	long stat;
-	u32 val;
-
-	i2c->done = 0;
-	ddbwritel((adr << 9) | cmd, i2c->regs + I2C_COMMAND);
-	stat = wait_event_timeout(i2c->wq, i2c->done == 1, HZ);
-	if (stat == 0) {
-		dev_err(&dev->pdev->dev, "I2C timeout\n");
-		{ /* MSI debugging*/
-			u32 istat = ddbreadl(INTERRUPT_STATUS);
-			dev_err(&dev->pdev->dev, "IRS %08x\n", istat);
-			ddbwritel(istat, INTERRUPT_ACK);
-		}
-		return -EIO;
-	}
-	val = ddbreadl(i2c->regs+I2C_COMMAND);
-	if (val & 0x70000)
-		return -EIO;
-	return 0;
-}
-
-static int ddb_i2c_master_xfer(struct i2c_adapter *adapter,
-			       struct i2c_msg msg[], int num)
-{
-	struct ddb_i2c *i2c = (struct ddb_i2c *)i2c_get_adapdata(adapter);
-	struct ddb *dev = i2c->dev;
-	u8 addr = 0;
-
-	if (num)
-		addr = msg[0].addr;
-
-	if (num == 2 && msg[1].flags & I2C_M_RD &&
-	    !(msg[0].flags & I2C_M_RD)) {
-		memcpy_toio(dev->regs + I2C_TASKMEM_BASE + i2c->wbuf,
-			    msg[0].buf, msg[0].len);
-		ddbwritel(msg[0].len|(msg[1].len << 16),
-			  i2c->regs+I2C_TASKLENGTH);
-		if (!ddb_i2c_cmd(i2c, addr, 1)) {
-			memcpy_fromio(msg[1].buf,
-				      dev->regs + I2C_TASKMEM_BASE + i2c->rbuf,
-				      msg[1].len);
-			return num;
-		}
-	}
-
-	if (num == 1 && !(msg[0].flags & I2C_M_RD)) {
-		ddbcpyto(I2C_TASKMEM_BASE + i2c->wbuf, msg[0].buf, msg[0].len);
-		ddbwritel(msg[0].len, i2c->regs + I2C_TASKLENGTH);
-		if (!ddb_i2c_cmd(i2c, addr, 2))
-			return num;
-	}
-	if (num == 1 && (msg[0].flags & I2C_M_RD)) {
-		ddbwritel(msg[0].len << 16, i2c->regs + I2C_TASKLENGTH);
-		if (!ddb_i2c_cmd(i2c, addr, 3)) {
-			ddbcpyfrom(msg[0].buf,
-				   I2C_TASKMEM_BASE + i2c->rbuf, msg[0].len);
-			return num;
-		}
-	}
-	return -EIO;
-}
-
-
-static u32 ddb_i2c_functionality(struct i2c_adapter *adap)
-{
-	return I2C_FUNC_SMBUS_EMUL;
-}
-
-static struct i2c_algorithm ddb_i2c_algo = {
-	.master_xfer   = ddb_i2c_master_xfer,
-	.functionality = ddb_i2c_functionality,
-};
-
-static void ddb_i2c_release(struct ddb *dev)
-{
-	int i;
-	struct ddb_i2c *i2c;
-	struct i2c_adapter *adap;
-
-	for (i = 0; i < dev->info->port_num; i++) {
-		i2c = &dev->i2c[i];
-		adap = &i2c->adap;
-		i2c_del_adapter(adap);
-	}
-}
-
-static int ddb_i2c_init(struct ddb *dev)
-{
-	int i, j, stat = 0;
-	struct ddb_i2c *i2c;
-	struct i2c_adapter *adap;
-
-	for (i = 0; i < dev->info->port_num; i++) {
-		i2c = &dev->i2c[i];
-		i2c->dev = dev;
-		i2c->nr = i;
-		i2c->wbuf = i * (I2C_TASKMEM_SIZE / 4);
-		i2c->rbuf = i2c->wbuf + (I2C_TASKMEM_SIZE / 8);
-		i2c->regs = 0x80 + i * 0x20;
-		ddbwritel(I2C_SPEED_100, i2c->regs + I2C_TIMING);
-		ddbwritel((i2c->rbuf << 16) | i2c->wbuf,
-			  i2c->regs + I2C_TASKADDRESS);
-		init_waitqueue_head(&i2c->wq);
-
-		adap = &i2c->adap;
-		i2c_set_adapdata(adap, i2c);
-#ifdef I2C_ADAP_CLASS_TV_DIGITAL
-		adap->class = I2C_ADAP_CLASS_TV_DIGITAL|I2C_CLASS_TV_ANALOG;
-#else
-#ifdef I2C_CLASS_TV_ANALOG
-		adap->class = I2C_CLASS_TV_ANALOG;
-#endif
-#endif
-		strcpy(adap->name, "ddbridge");
-		adap->algo = &ddb_i2c_algo;
-		adap->algo_data = (void *)i2c;
-		adap->dev.parent = &dev->pdev->dev;
-		stat = i2c_add_adapter(adap);
-		if (stat)
-			break;
-	}
-	if (stat)
-		for (j = 0; j < i; j++) {
-			i2c = &dev->i2c[j];
-			adap = &i2c->adap;
-			i2c_del_adapter(adap);
-		}
-	return stat;
-}
-
-
 /******************************************************************************/
 /******************************************************************************/
 /******************************************************************************/
@@ -342,7 +123,7 @@ static int io_alloc(struct pci_dev *pdev, u8 **vbuf,
 	return 0;
 }
 
-static int ddb_buffers_alloc(struct ddb *dev)
+int ddb_buffers_alloc(struct ddb *dev)
 {
 	int i;
 	struct ddb_port *port;
@@ -382,7 +163,7 @@ static int ddb_buffers_alloc(struct ddb *dev)
 	return 0;
 }
 
-static void ddb_buffers_free(struct ddb *dev)
+void ddb_buffers_free(struct ddb *dev)
 {
 	int i;
 	struct ddb_port *port;
@@ -1662,7 +1443,7 @@ static int ddb_port_attach(struct ddb_port *port)
 	return ret;
 }
 
-static int ddb_ports_attach(struct ddb *dev)
+int ddb_ports_attach(struct ddb *dev)
 {
 	int i, ret = 0;
 	struct ddb_port *port;
@@ -1676,7 +1457,7 @@ static int ddb_ports_attach(struct ddb *dev)
 	return ret;
 }
 
-static void ddb_ports_detach(struct ddb *dev)
+void ddb_ports_detach(struct ddb *dev)
 {
 	int i;
 	struct ddb_port *port;
@@ -1787,7 +1568,7 @@ static void ddb_output_init(struct ddb_port *port, int nr)
 	init_waitqueue_head(&output->wq);
 }
 
-static void ddb_ports_init(struct ddb *dev)
+void ddb_ports_init(struct ddb *dev)
 {
 	int i;
 	struct ddb_port *port;
@@ -1809,7 +1590,7 @@ static void ddb_ports_init(struct ddb *dev)
 	}
 }
 
-static void ddb_ports_release(struct ddb *dev)
+void ddb_ports_release(struct ddb *dev)
 {
 	int i;
 	struct ddb_port *port;
@@ -1835,7 +1616,7 @@ static void irq_handle_i2c(struct ddb *dev, int n)
 	wake_up(&i2c->wq);
 }
 
-static irqreturn_t irq_handler(int irq, void *dev_id)
+irqreturn_t irq_handler(int irq, void *dev_id)
 {
 	struct ddb *dev = (struct ddb *) dev_id;
 	u32 s = ddbreadl(INTERRUPT_STATUS);
@@ -2038,7 +1819,7 @@ static char *ddb_devnode(struct device *device, umode_t *mode)
 	return kasprintf(GFP_KERNEL, "ddbridge/card%d", dev->nr);
 }
 
-static int ddb_class_create(void)
+int ddb_class_create(void)
 {
 	ddb_major = register_chrdev(0, DDB_NAME, &ddb_fops);
 	if (ddb_major < 0)
@@ -2053,13 +1834,13 @@ static int ddb_class_create(void)
 	return 0;
 }
 
-static void ddb_class_destroy(void)
+void ddb_class_destroy(void)
 {
 	class_destroy(ddb_class);
 	unregister_chrdev(ddb_major, DDB_NAME);
 }
 
-static int ddb_device_create(struct ddb *dev)
+int ddb_device_create(struct ddb *dev)
 {
 	dev->nr = ddb_num++;
 	dev->ddb_dev = device_create(ddb_class, NULL,
@@ -2071,355 +1852,10 @@ static int ddb_device_create(struct ddb *dev)
 	return 0;
 }
 
-static void ddb_device_destroy(struct ddb *dev)
+void ddb_device_destroy(struct ddb *dev)
 {
 	ddb_num--;
 	if (IS_ERR(dev->ddb_dev))
 		return;
 	device_destroy(ddb_class, MKDEV(ddb_major, 0));
 }
-
-/****************************************************************************/
-/****************************************************************************/
-/****************************************************************************/
-
-static void ddb_unmap(struct ddb *dev)
-{
-	if (dev->regs)
-		iounmap(dev->regs);
-	vfree(dev);
-}
-
-
-static void ddb_remove(struct pci_dev *pdev)
-{
-	struct ddb *dev = pci_get_drvdata(pdev);
-
-	ddb_ports_detach(dev);
-	ddb_i2c_release(dev);
-
-	ddbwritel(0, INTERRUPT_ENABLE);
-	free_irq(dev->pdev->irq, dev);
-#ifdef CONFIG_PCI_MSI
-	if (dev->msi)
-		pci_disable_msi(dev->pdev);
-#endif
-	ddb_ports_release(dev);
-	ddb_buffers_free(dev);
-	ddb_device_destroy(dev);
-
-	ddb_unmap(dev);
-	pci_set_drvdata(pdev, NULL);
-	pci_disable_device(pdev);
-}
-
-
-static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
-{
-	struct ddb *dev;
-	int stat = 0;
-	int irq_flag = IRQF_SHARED;
-
-	if (pci_enable_device(pdev) < 0)
-		return -ENODEV;
-
-	dev = vzalloc(sizeof(struct ddb));
-	if (dev == NULL)
-		return -ENOMEM;
-
-	dev->pdev = pdev;
-	pci_set_drvdata(pdev, dev);
-	dev->info = (struct ddb_info *) id->driver_data;
-	dev_info(&pdev->dev, "Detected %s\n", dev->info->name);
-
-	dev->regs = ioremap(pci_resource_start(dev->pdev, 0),
-			    pci_resource_len(dev->pdev, 0));
-	if (!dev->regs) {
-		stat = -ENOMEM;
-		goto fail;
-	}
-	dev_info(&pdev->dev, "HW %08x FW %08x\n", ddbreadl(0), ddbreadl(4));
-
-#ifdef CONFIG_PCI_MSI
-	if (pci_msi_enabled())
-		stat = pci_enable_msi(dev->pdev);
-	if (stat) {
-		dev_info(&pdev->dev, "MSI not available.\n");
-	} else {
-		irq_flag = 0;
-		dev->msi = 1;
-	}
-#endif
-	stat = request_irq(dev->pdev->irq, irq_handler,
-			   irq_flag, "DDBridge", (void *) dev);
-	if (stat < 0)
-		goto fail1;
-	ddbwritel(0, DMA_BASE_WRITE);
-	ddbwritel(0, DMA_BASE_READ);
-	ddbwritel(0xffffffff, INTERRUPT_ACK);
-	ddbwritel(0xfff0f, INTERRUPT_ENABLE);
-	ddbwritel(0, MSI1_ENABLE);
-
-	/* board control */
-	if (dev->info->board_control) {
-		ddbwritel(0, DDB_LINK_TAG(0) | BOARD_CONTROL);
-		msleep(100);
-		ddbwritel(dev->info->board_control_2,
-			DDB_LINK_TAG(0) | BOARD_CONTROL);
-		usleep_range(2000, 3000);
-		ddbwritel(dev->info->board_control_2
-			| dev->info->board_control,
-			DDB_LINK_TAG(0) | BOARD_CONTROL);
-		usleep_range(2000, 3000);
-	}
-
-	if (ddb_i2c_init(dev) < 0)
-		goto fail1;
-	ddb_ports_init(dev);
-	if (ddb_buffers_alloc(dev) < 0) {
-		dev_err(&pdev->dev, "Could not allocate buffer memory\n");
-		goto fail2;
-	}
-	if (ddb_ports_attach(dev) < 0)
-		goto fail3;
-	ddb_device_create(dev);
-	return 0;
-
-fail3:
-	ddb_ports_detach(dev);
-	dev_err(&pdev->dev, "fail3\n");
-	ddb_ports_release(dev);
-fail2:
-	dev_err(&pdev->dev, "fail2\n");
-	ddb_buffers_free(dev);
-fail1:
-	dev_err(&pdev->dev, "fail1\n");
-	if (dev->msi)
-		pci_disable_msi(dev->pdev);
-	if (stat == 0)
-		free_irq(dev->pdev->irq, dev);
-fail:
-	dev_err(&pdev->dev, "fail\n");
-	ddb_unmap(dev);
-	pci_set_drvdata(pdev, NULL);
-	pci_disable_device(pdev);
-	return -1;
-}
-
-/******************************************************************************/
-/******************************************************************************/
-/******************************************************************************/
-
-static const struct ddb_info ddb_none = {
-	.type     = DDB_NONE,
-	.name     = "Digital Devices PCIe bridge",
-};
-
-static const struct ddb_info ddb_octopus = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices Octopus DVB adapter",
-	.port_num = 4,
-};
-
-static const struct ddb_info ddb_octopus_le = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices Octopus LE DVB adapter",
-	.port_num = 2,
-};
-
-static const struct ddb_info ddb_octopus_oem = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices Octopus OEM",
-	.port_num = 4,
-};
-
-static const struct ddb_info ddb_octopus_mini = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices Octopus Mini",
-	.port_num = 4,
-};
-
-static const struct ddb_info ddb_v6 = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices Cine S2 V6 DVB adapter",
-	.port_num = 3,
-};
-static const struct ddb_info ddb_v6_5 = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices Cine S2 V6.5 DVB adapter",
-	.port_num = 4,
-};
-
-static const struct ddb_info ddb_v7 = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices Cine S2 V7 DVB adapter",
-	.port_num = 4,
-	.board_control   = 2,
-	.board_control_2 = 4,
-	.ts_quirks = TS_QUIRK_REVERSED,
-};
-
-static const struct ddb_info ddb_v7a = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices Cine S2 V7 Advanced DVB adapter",
-	.port_num = 4,
-	.board_control   = 2,
-	.board_control_2 = 4,
-	.ts_quirks = TS_QUIRK_REVERSED,
-};
-
-static const struct ddb_info ddb_dvbct = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices DVBCT V6.1 DVB adapter",
-	.port_num = 3,
-};
-
-static const struct ddb_info ddb_ctv7 = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices Cine CT V7 DVB adapter",
-	.port_num = 4,
-	.board_control   = 3,
-	.board_control_2 = 4,
-};
-
-static const struct ddb_info ddb_satixS2v3 = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Mystique SaTiX-S2 V3 DVB adapter",
-	.port_num = 3,
-};
-
-static const struct ddb_info ddb_octopusv3 = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices Octopus V3 DVB adapter",
-	.port_num = 4,
-};
-
-/*** MaxA8 adapters ***********************************************************/
-
-static struct ddb_info ddb_ct2_8 = {
-	.type     = DDB_OCTOPUS_MAX_CT,
-	.name     = "Digital Devices MAX A8 CT2",
-	.port_num = 4,
-	.board_control   = 0x0ff,
-	.board_control_2 = 0xf00,
-	.ts_quirks = TS_QUIRK_SERIAL,
-};
-
-static struct ddb_info ddb_c2t2_8 = {
-	.type     = DDB_OCTOPUS_MAX_CT,
-	.name     = "Digital Devices MAX A8 C2T2",
-	.port_num = 4,
-	.board_control   = 0x0ff,
-	.board_control_2 = 0xf00,
-	.ts_quirks = TS_QUIRK_SERIAL,
-};
-
-static struct ddb_info ddb_isdbt_8 = {
-	.type     = DDB_OCTOPUS_MAX_CT,
-	.name     = "Digital Devices MAX A8 ISDBT",
-	.port_num = 4,
-	.board_control   = 0x0ff,
-	.board_control_2 = 0xf00,
-	.ts_quirks = TS_QUIRK_SERIAL,
-};
-
-static struct ddb_info ddb_c2t2i_v0_8 = {
-	.type     = DDB_OCTOPUS_MAX_CT,
-	.name     = "Digital Devices MAX A8 C2T2I V0",
-	.port_num = 4,
-	.board_control   = 0x0ff,
-	.board_control_2 = 0xf00,
-	.ts_quirks = TS_QUIRK_SERIAL | TS_QUIRK_ALT_OSC,
-};
-
-static struct ddb_info ddb_c2t2i_8 = {
-	.type     = DDB_OCTOPUS_MAX_CT,
-	.name     = "Digital Devices MAX A8 C2T2I",
-	.port_num = 4,
-	.board_control   = 0x0ff,
-	.board_control_2 = 0xf00,
-	.ts_quirks = TS_QUIRK_SERIAL,
-};
-
-/******************************************************************************/
-
-#define DDVID 0xdd01 /* Digital Devices Vendor ID */
-
-#define DDB_ID(_vend, _dev, _subvend, _subdev, _driverdata) {	\
-	.vendor      = _vend,    .device    = _dev, \
-	.subvendor   = _subvend, .subdevice = _subdev, \
-	.driver_data = (unsigned long)&_driverdata }
-
-static const struct pci_device_id ddb_id_tbl[] = {
-	DDB_ID(DDVID, 0x0002, DDVID, 0x0001, ddb_octopus),
-	DDB_ID(DDVID, 0x0003, DDVID, 0x0001, ddb_octopus),
-	DDB_ID(DDVID, 0x0005, DDVID, 0x0004, ddb_octopusv3),
-	DDB_ID(DDVID, 0x0003, DDVID, 0x0002, ddb_octopus_le),
-	DDB_ID(DDVID, 0x0003, DDVID, 0x0003, ddb_octopus_oem),
-	DDB_ID(DDVID, 0x0003, DDVID, 0x0010, ddb_octopus_mini),
-	DDB_ID(DDVID, 0x0005, DDVID, 0x0011, ddb_octopus_mini),
-	DDB_ID(DDVID, 0x0003, DDVID, 0x0020, ddb_v6),
-	DDB_ID(DDVID, 0x0003, DDVID, 0x0021, ddb_v6_5),
-	DDB_ID(DDVID, 0x0006, DDVID, 0x0022, ddb_v7),
-	DDB_ID(DDVID, 0x0006, DDVID, 0x0024, ddb_v7a),
-	DDB_ID(DDVID, 0x0003, DDVID, 0x0030, ddb_dvbct),
-	DDB_ID(DDVID, 0x0003, DDVID, 0xdb03, ddb_satixS2v3),
-	DDB_ID(DDVID, 0x0006, DDVID, 0x0031, ddb_ctv7),
-	DDB_ID(DDVID, 0x0006, DDVID, 0x0032, ddb_ctv7),
-	DDB_ID(DDVID, 0x0006, DDVID, 0x0033, ddb_ctv7),
-	DDB_ID(DDVID, 0x0008, DDVID, 0x0034, ddb_ct2_8),
-	DDB_ID(DDVID, 0x0008, DDVID, 0x0035, ddb_c2t2_8),
-	DDB_ID(DDVID, 0x0008, DDVID, 0x0036, ddb_isdbt_8),
-	DDB_ID(DDVID, 0x0008, DDVID, 0x0037, ddb_c2t2i_v0_8),
-	DDB_ID(DDVID, 0x0008, DDVID, 0x0038, ddb_c2t2i_8),
-	DDB_ID(DDVID, 0x0006, DDVID, 0x0039, ddb_ctv7),
-	/* in case sub-ids got deleted in flash */
-	DDB_ID(DDVID, 0x0003, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
-	DDB_ID(DDVID, 0x0005, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
-	DDB_ID(DDVID, 0x0006, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
-	DDB_ID(DDVID, 0x0007, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
-	DDB_ID(DDVID, 0x0008, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
-	DDB_ID(DDVID, 0x0011, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
-	DDB_ID(DDVID, 0x0013, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
-	DDB_ID(DDVID, 0x0201, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
-	DDB_ID(DDVID, 0x0320, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
-	{0}
-};
-MODULE_DEVICE_TABLE(pci, ddb_id_tbl);
-
-
-static struct pci_driver ddb_pci_driver = {
-	.name        = "DDBridge",
-	.id_table    = ddb_id_tbl,
-	.probe       = ddb_probe,
-	.remove      = ddb_remove,
-};
-
-static __init int module_init_ddbridge(void)
-{
-	int ret;
-
-	pr_info("Digital Devices PCIE bridge driver, Copyright (C) 2010-11 Digital Devices GmbH\n");
-
-	ret = ddb_class_create();
-	if (ret < 0)
-		return ret;
-	ret = pci_register_driver(&ddb_pci_driver);
-	if (ret < 0)
-		ddb_class_destroy();
-	return ret;
-}
-
-static __exit void module_exit_ddbridge(void)
-{
-	pci_unregister_driver(&ddb_pci_driver);
-	ddb_class_destroy();
-}
-
-module_init(module_init_ddbridge);
-module_exit(module_exit_ddbridge);
-
-MODULE_DESCRIPTION("Digital Devices PCIe Bridge");
-MODULE_AUTHOR("Ralph Metzler");
-MODULE_LICENSE("GPL");
-MODULE_VERSION("0.5");
diff --git a/drivers/media/pci/ddbridge/ddbridge-i2c.c b/drivers/media/pci/ddbridge/ddbridge-i2c.c
new file mode 100644
index 000000000000..ea3565efdd3b
--- /dev/null
+++ b/drivers/media/pci/ddbridge/ddbridge-i2c.c
@@ -0,0 +1,231 @@
+/*
+ * ddbridge.c: Digital Devices PCIe bridge driver
+ *
+ * Copyright (C) 2010-2011 Digital Devices GmbH
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 only, as published by the Free Software Foundation.
+ *
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * To obtain the license, point your browser to
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/poll.h>
+#include <linux/io.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/timer.h>
+#include <linux/i2c.h>
+#include <linux/swab.h>
+#include <linux/vmalloc.h>
+
+#include "ddbridge.h"
+#include "ddbridge-regs.h"
+
+/******************************************************************************/
+
+int i2c_io(struct i2c_adapter *adapter, u8 adr,
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
+int i2c_read(struct i2c_adapter *adapter, u8 adr, u8 *val)
+{
+	struct i2c_msg msgs[1] = {{.addr = adr,  .flags = I2C_M_RD,
+				   .buf  = val,  .len   = 1 } };
+	return (i2c_transfer(adapter, msgs, 1) == 1) ? 0 : -1;
+}
+
+int i2c_read_regs(struct i2c_adapter *adapter,
+			 u8 adr, u8 reg, u8 *val, u8 len)
+{
+	struct i2c_msg msgs[2] = {{.addr = adr,  .flags = 0,
+				   .buf  = &reg, .len   = 1 },
+				  {.addr = adr,  .flags = I2C_M_RD,
+				   .buf  = val,  .len   = len } };
+	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
+}
+
+int i2c_read_reg(struct i2c_adapter *adapter, u8 adr, u8 reg, u8 *val)
+{
+	return i2c_read_regs(adapter, adr, reg, val, 1);
+}
+
+int i2c_read_reg16(struct i2c_adapter *adapter, u8 adr,
+			  u16 reg, u8 *val)
+{
+	u8 msg[2] = {reg>>8, reg&0xff};
+	struct i2c_msg msgs[2] = {{.addr = adr, .flags = 0,
+				   .buf  = msg, .len   = 2},
+				  {.addr = adr, .flags = I2C_M_RD,
+				   .buf  = val, .len   = 1} };
+	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
+}
+
+int i2c_write_reg(struct i2c_adapter *adap, u8 adr,
+			 u8 reg, u8 val)
+{
+	u8 msg[2] = {reg, val};
+
+	return i2c_write(adap, adr, msg, 2);
+}
+
+static int ddb_i2c_cmd(struct ddb_i2c *i2c, u32 adr, u32 cmd)
+{
+	struct ddb *dev = i2c->dev;
+	long stat;
+	u32 val;
+
+	i2c->done = 0;
+	ddbwritel((adr << 9) | cmd, i2c->regs + I2C_COMMAND);
+	stat = wait_event_timeout(i2c->wq, i2c->done == 1, HZ);
+	if (stat == 0) {
+		dev_err(&dev->pdev->dev, "I2C timeout\n");
+		{ /* MSI debugging*/
+			u32 istat = ddbreadl(INTERRUPT_STATUS);
+			dev_err(&dev->pdev->dev, "IRS %08x\n", istat);
+			ddbwritel(istat, INTERRUPT_ACK);
+		}
+		return -EIO;
+	}
+	val = ddbreadl(i2c->regs+I2C_COMMAND);
+	if (val & 0x70000)
+		return -EIO;
+	return 0;
+}
+
+static int ddb_i2c_master_xfer(struct i2c_adapter *adapter,
+			       struct i2c_msg msg[], int num)
+{
+	struct ddb_i2c *i2c = (struct ddb_i2c *)i2c_get_adapdata(adapter);
+	struct ddb *dev = i2c->dev;
+	u8 addr = 0;
+
+	if (num)
+		addr = msg[0].addr;
+
+	if (num == 2 && msg[1].flags & I2C_M_RD &&
+	    !(msg[0].flags & I2C_M_RD)) {
+		memcpy_toio(dev->regs + I2C_TASKMEM_BASE + i2c->wbuf,
+			    msg[0].buf, msg[0].len);
+		ddbwritel(msg[0].len|(msg[1].len << 16),
+			  i2c->regs+I2C_TASKLENGTH);
+		if (!ddb_i2c_cmd(i2c, addr, 1)) {
+			memcpy_fromio(msg[1].buf,
+				      dev->regs + I2C_TASKMEM_BASE + i2c->rbuf,
+				      msg[1].len);
+			return num;
+		}
+	}
+
+	if (num == 1 && !(msg[0].flags & I2C_M_RD)) {
+		ddbcpyto(I2C_TASKMEM_BASE + i2c->wbuf, msg[0].buf, msg[0].len);
+		ddbwritel(msg[0].len, i2c->regs + I2C_TASKLENGTH);
+		if (!ddb_i2c_cmd(i2c, addr, 2))
+			return num;
+	}
+	if (num == 1 && (msg[0].flags & I2C_M_RD)) {
+		ddbwritel(msg[0].len << 16, i2c->regs + I2C_TASKLENGTH);
+		if (!ddb_i2c_cmd(i2c, addr, 3)) {
+			ddbcpyfrom(msg[0].buf,
+				   I2C_TASKMEM_BASE + i2c->rbuf, msg[0].len);
+			return num;
+		}
+	}
+	return -EIO;
+}
+
+
+static u32 ddb_i2c_functionality(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_SMBUS_EMUL;
+}
+
+static struct i2c_algorithm ddb_i2c_algo = {
+	.master_xfer   = ddb_i2c_master_xfer,
+	.functionality = ddb_i2c_functionality,
+};
+
+void ddb_i2c_release(struct ddb *dev)
+{
+	int i;
+	struct ddb_i2c *i2c;
+	struct i2c_adapter *adap;
+
+	for (i = 0; i < dev->info->port_num; i++) {
+		i2c = &dev->i2c[i];
+		adap = &i2c->adap;
+		i2c_del_adapter(adap);
+	}
+}
+
+int ddb_i2c_init(struct ddb *dev)
+{
+	int i, j, stat = 0;
+	struct ddb_i2c *i2c;
+	struct i2c_adapter *adap;
+
+	for (i = 0; i < dev->info->port_num; i++) {
+		i2c = &dev->i2c[i];
+		i2c->dev = dev;
+		i2c->nr = i;
+		i2c->wbuf = i * (I2C_TASKMEM_SIZE / 4);
+		i2c->rbuf = i2c->wbuf + (I2C_TASKMEM_SIZE / 8);
+		i2c->regs = 0x80 + i * 0x20;
+		ddbwritel(I2C_SPEED_100, i2c->regs + I2C_TIMING);
+		ddbwritel((i2c->rbuf << 16) | i2c->wbuf,
+			  i2c->regs + I2C_TASKADDRESS);
+		init_waitqueue_head(&i2c->wq);
+
+		adap = &i2c->adap;
+		i2c_set_adapdata(adap, i2c);
+#ifdef I2C_ADAP_CLASS_TV_DIGITAL
+		adap->class = I2C_ADAP_CLASS_TV_DIGITAL|I2C_CLASS_TV_ANALOG;
+#else
+#ifdef I2C_CLASS_TV_ANALOG
+		adap->class = I2C_CLASS_TV_ANALOG;
+#endif
+#endif
+		strcpy(adap->name, "ddbridge");
+		adap->algo = &ddb_i2c_algo;
+		adap->algo_data = (void *)i2c;
+		adap->dev.parent = &dev->pdev->dev;
+		stat = i2c_add_adapter(adap);
+		if (stat)
+			break;
+	}
+	if (stat)
+		for (j = 0; j < i; j++) {
+			i2c = &dev->i2c[j];
+			adap = &i2c->adap;
+			i2c_del_adapter(adap);
+		}
+	return stat;
+}
diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
new file mode 100644
index 000000000000..917fd116d92f
--- /dev/null
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -0,0 +1,388 @@
+/*
+ * ddbridge.c: Digital Devices PCIe bridge driver
+ *
+ * Copyright (C) 2010-2011 Digital Devices GmbH
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 only, as published by the Free Software Foundation.
+ *
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * To obtain the license, point your browser to
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/poll.h>
+#include <linux/io.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/timer.h>
+#include <linux/i2c.h>
+#include <linux/swab.h>
+#include <linux/vmalloc.h>
+
+#include "ddbridge.h"
+#include "ddbridge-regs.h"
+
+int xo2_speed = 2;
+module_param(xo2_speed, int, 0444);
+MODULE_PARM_DESC(xo2_speed, "default transfer speed for xo2 based duoflex, 0=55,1=75,2=90,3=104 MBit/s, default=2, use attribute to change for individual cards");
+
+int stv0910_single;
+module_param(stv0910_single, int, 0444);
+MODULE_PARM_DESC(stv0910_single, "use stv0910 cards as single demods");
+
+/******************************************************************************/
+
+static void ddb_unmap(struct ddb *dev)
+{
+	if (dev->regs)
+		iounmap(dev->regs);
+	vfree(dev);
+}
+
+
+static void ddb_remove(struct pci_dev *pdev)
+{
+	struct ddb *dev = pci_get_drvdata(pdev);
+
+	ddb_ports_detach(dev);
+	ddb_i2c_release(dev);
+
+	ddbwritel(0, INTERRUPT_ENABLE);
+	free_irq(dev->pdev->irq, dev);
+#ifdef CONFIG_PCI_MSI
+	if (dev->msi)
+		pci_disable_msi(dev->pdev);
+#endif
+	ddb_ports_release(dev);
+	ddb_buffers_free(dev);
+	ddb_device_destroy(dev);
+
+	ddb_unmap(dev);
+	pci_set_drvdata(pdev, NULL);
+	pci_disable_device(pdev);
+}
+
+
+static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct ddb *dev;
+	int stat = 0;
+	int irq_flag = IRQF_SHARED;
+
+	if (pci_enable_device(pdev) < 0)
+		return -ENODEV;
+
+	dev = vzalloc(sizeof(struct ddb));
+	if (dev == NULL)
+		return -ENOMEM;
+
+	dev->pdev = pdev;
+	pci_set_drvdata(pdev, dev);
+	dev->info = (struct ddb_info *) id->driver_data;
+	dev_info(&pdev->dev, "Detected %s\n", dev->info->name);
+
+	dev->regs = ioremap(pci_resource_start(dev->pdev, 0),
+			    pci_resource_len(dev->pdev, 0));
+	if (!dev->regs) {
+		stat = -ENOMEM;
+		goto fail;
+	}
+	dev_info(&pdev->dev, "HW %08x FW %08x\n", ddbreadl(0), ddbreadl(4));
+
+#ifdef CONFIG_PCI_MSI
+	if (pci_msi_enabled())
+		stat = pci_enable_msi(dev->pdev);
+	if (stat) {
+		dev_info(&pdev->dev, "MSI not available.\n");
+	} else {
+		irq_flag = 0;
+		dev->msi = 1;
+	}
+#endif
+	stat = request_irq(dev->pdev->irq, irq_handler,
+			   irq_flag, "DDBridge", (void *) dev);
+	if (stat < 0)
+		goto fail1;
+	ddbwritel(0, DMA_BASE_WRITE);
+	ddbwritel(0, DMA_BASE_READ);
+	ddbwritel(0xffffffff, INTERRUPT_ACK);
+	ddbwritel(0xfff0f, INTERRUPT_ENABLE);
+	ddbwritel(0, MSI1_ENABLE);
+
+	/* board control */
+	if (dev->info->board_control) {
+		ddbwritel(0, DDB_LINK_TAG(0) | BOARD_CONTROL);
+		msleep(100);
+		ddbwritel(dev->info->board_control_2,
+			DDB_LINK_TAG(0) | BOARD_CONTROL);
+		usleep_range(2000, 3000);
+		ddbwritel(dev->info->board_control_2
+			| dev->info->board_control,
+			DDB_LINK_TAG(0) | BOARD_CONTROL);
+		usleep_range(2000, 3000);
+	}
+
+	if (ddb_i2c_init(dev) < 0)
+		goto fail1;
+	ddb_ports_init(dev);
+	if (ddb_buffers_alloc(dev) < 0) {
+		dev_err(&pdev->dev, "Could not allocate buffer memory\n");
+		goto fail2;
+	}
+	if (ddb_ports_attach(dev) < 0)
+		goto fail3;
+	ddb_device_create(dev);
+	return 0;
+
+fail3:
+	ddb_ports_detach(dev);
+	dev_err(&pdev->dev, "fail3\n");
+	ddb_ports_release(dev);
+fail2:
+	dev_err(&pdev->dev, "fail2\n");
+	ddb_buffers_free(dev);
+fail1:
+	dev_err(&pdev->dev, "fail1\n");
+	if (dev->msi)
+		pci_disable_msi(dev->pdev);
+	if (stat == 0)
+		free_irq(dev->pdev->irq, dev);
+fail:
+	dev_err(&pdev->dev, "fail\n");
+	ddb_unmap(dev);
+	pci_set_drvdata(pdev, NULL);
+	pci_disable_device(pdev);
+	return -1;
+}
+
+/******************************************************************************/
+/******************************************************************************/
+/******************************************************************************/
+
+static const struct ddb_info ddb_none = {
+	.type     = DDB_NONE,
+	.name     = "Digital Devices PCIe bridge",
+};
+
+static const struct ddb_info ddb_octopus = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Octopus DVB adapter",
+	.port_num = 4,
+};
+
+static const struct ddb_info ddb_octopus_le = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Octopus LE DVB adapter",
+	.port_num = 2,
+};
+
+static const struct ddb_info ddb_octopus_oem = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Octopus OEM",
+	.port_num = 4,
+};
+
+static const struct ddb_info ddb_octopus_mini = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Octopus Mini",
+	.port_num = 4,
+};
+
+static const struct ddb_info ddb_v6 = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Cine S2 V6 DVB adapter",
+	.port_num = 3,
+};
+static const struct ddb_info ddb_v6_5 = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Cine S2 V6.5 DVB adapter",
+	.port_num = 4,
+};
+
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
+static const struct ddb_info ddb_dvbct = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices DVBCT V6.1 DVB adapter",
+	.port_num = 3,
+};
+
+static const struct ddb_info ddb_ctv7 = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Cine CT V7 DVB adapter",
+	.port_num = 4,
+	.board_control   = 3,
+	.board_control_2 = 4,
+};
+
+static const struct ddb_info ddb_satixS2v3 = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Mystique SaTiX-S2 V3 DVB adapter",
+	.port_num = 3,
+};
+
+static const struct ddb_info ddb_octopusv3 = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Octopus V3 DVB adapter",
+	.port_num = 4,
+};
+
+/*** MaxA8 adapters ***********************************************************/
+
+static struct ddb_info ddb_ct2_8 = {
+	.type     = DDB_OCTOPUS_MAX_CT,
+	.name     = "Digital Devices MAX A8 CT2",
+	.port_num = 4,
+	.board_control   = 0x0ff,
+	.board_control_2 = 0xf00,
+	.ts_quirks = TS_QUIRK_SERIAL,
+};
+
+static struct ddb_info ddb_c2t2_8 = {
+	.type     = DDB_OCTOPUS_MAX_CT,
+	.name     = "Digital Devices MAX A8 C2T2",
+	.port_num = 4,
+	.board_control   = 0x0ff,
+	.board_control_2 = 0xf00,
+	.ts_quirks = TS_QUIRK_SERIAL,
+};
+
+static struct ddb_info ddb_isdbt_8 = {
+	.type     = DDB_OCTOPUS_MAX_CT,
+	.name     = "Digital Devices MAX A8 ISDBT",
+	.port_num = 4,
+	.board_control   = 0x0ff,
+	.board_control_2 = 0xf00,
+	.ts_quirks = TS_QUIRK_SERIAL,
+};
+
+static struct ddb_info ddb_c2t2i_v0_8 = {
+	.type     = DDB_OCTOPUS_MAX_CT,
+	.name     = "Digital Devices MAX A8 C2T2I V0",
+	.port_num = 4,
+	.board_control   = 0x0ff,
+	.board_control_2 = 0xf00,
+	.ts_quirks = TS_QUIRK_SERIAL | TS_QUIRK_ALT_OSC,
+};
+
+static struct ddb_info ddb_c2t2i_8 = {
+	.type     = DDB_OCTOPUS_MAX_CT,
+	.name     = "Digital Devices MAX A8 C2T2I",
+	.port_num = 4,
+	.board_control   = 0x0ff,
+	.board_control_2 = 0xf00,
+	.ts_quirks = TS_QUIRK_SERIAL,
+};
+
+/******************************************************************************/
+
+#define DDVID 0xdd01 /* Digital Devices Vendor ID */
+
+#define DDB_ID(_vend, _dev, _subvend, _subdev, _driverdata) {	\
+	.vendor      = _vend,    .device    = _dev, \
+	.subvendor   = _subvend, .subdevice = _subdev, \
+	.driver_data = (unsigned long)&_driverdata }
+
+static const struct pci_device_id ddb_id_tbl[] = {
+	DDB_ID(DDVID, 0x0002, DDVID, 0x0001, ddb_octopus),
+	DDB_ID(DDVID, 0x0003, DDVID, 0x0001, ddb_octopus),
+	DDB_ID(DDVID, 0x0005, DDVID, 0x0004, ddb_octopusv3),
+	DDB_ID(DDVID, 0x0003, DDVID, 0x0002, ddb_octopus_le),
+	DDB_ID(DDVID, 0x0003, DDVID, 0x0003, ddb_octopus_oem),
+	DDB_ID(DDVID, 0x0003, DDVID, 0x0010, ddb_octopus_mini),
+	DDB_ID(DDVID, 0x0005, DDVID, 0x0011, ddb_octopus_mini),
+	DDB_ID(DDVID, 0x0003, DDVID, 0x0020, ddb_v6),
+	DDB_ID(DDVID, 0x0003, DDVID, 0x0021, ddb_v6_5),
+	DDB_ID(DDVID, 0x0006, DDVID, 0x0022, ddb_v7),
+	DDB_ID(DDVID, 0x0006, DDVID, 0x0024, ddb_v7a),
+	DDB_ID(DDVID, 0x0003, DDVID, 0x0030, ddb_dvbct),
+	DDB_ID(DDVID, 0x0003, DDVID, 0xdb03, ddb_satixS2v3),
+	DDB_ID(DDVID, 0x0006, DDVID, 0x0031, ddb_ctv7),
+	DDB_ID(DDVID, 0x0006, DDVID, 0x0032, ddb_ctv7),
+	DDB_ID(DDVID, 0x0006, DDVID, 0x0033, ddb_ctv7),
+	DDB_ID(DDVID, 0x0008, DDVID, 0x0034, ddb_ct2_8),
+	DDB_ID(DDVID, 0x0008, DDVID, 0x0035, ddb_c2t2_8),
+	DDB_ID(DDVID, 0x0008, DDVID, 0x0036, ddb_isdbt_8),
+	DDB_ID(DDVID, 0x0008, DDVID, 0x0037, ddb_c2t2i_v0_8),
+	DDB_ID(DDVID, 0x0008, DDVID, 0x0038, ddb_c2t2i_8),
+	DDB_ID(DDVID, 0x0006, DDVID, 0x0039, ddb_ctv7),
+	/* in case sub-ids got deleted in flash */
+	DDB_ID(DDVID, 0x0003, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	DDB_ID(DDVID, 0x0005, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	DDB_ID(DDVID, 0x0006, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	DDB_ID(DDVID, 0x0007, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	DDB_ID(DDVID, 0x0008, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	DDB_ID(DDVID, 0x0011, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	DDB_ID(DDVID, 0x0013, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	DDB_ID(DDVID, 0x0201, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	DDB_ID(DDVID, 0x0320, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	{0}
+};
+MODULE_DEVICE_TABLE(pci, ddb_id_tbl);
+
+
+static struct pci_driver ddb_pci_driver = {
+	.name        = "DDBridge",
+	.id_table    = ddb_id_tbl,
+	.probe       = ddb_probe,
+	.remove      = ddb_remove,
+};
+
+static __init int module_init_ddbridge(void)
+{
+	int ret;
+
+	pr_info("Digital Devices PCIE bridge driver, Copyright (C) 2010-11 Digital Devices GmbH\n");
+
+	ret = ddb_class_create();
+	if (ret < 0)
+		return ret;
+	ret = pci_register_driver(&ddb_pci_driver);
+	if (ret < 0)
+		ddb_class_destroy();
+	return ret;
+}
+
+static __exit void module_exit_ddbridge(void)
+{
+	pci_unregister_driver(&ddb_pci_driver);
+	ddb_class_destroy();
+}
+
+module_init(module_init_ddbridge);
+module_exit(module_exit_ddbridge);
+
+MODULE_DESCRIPTION("Digital Devices PCIe Bridge");
+MODULE_AUTHOR("Ralph Metzler");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("0.5");
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 4783a17175a8..810a4da1c10e 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -39,6 +39,9 @@
 #include "dvb_net.h"
 #include "cxd2099.h"
 
+/* MSI had problems with lost interrupts, fixed but needs testing */
+#undef CONFIG_PCI_MSI
+
 #define DDB_MAX_I2C     4
 #define DDB_MAX_PORT    4
 #define DDB_MAX_INPUT   8
@@ -205,4 +208,50 @@ struct ddb {
 
 /****************************************************************************/
 
+static inline u32 safe_ddbreadl(struct ddb *dev, u32 adr)
+{
+        u32 val = ddbreadl(adr);
+
+        /* (ddb)readl returns (uint)-1 (all bits set) on failure, catch that */
+        if (val == ~0) {
+                dev_err(&dev->pdev->dev, "ddbreadl failure, adr=%08x\n", adr);
+                return 0;
+        }
+
+	return val;
+}
+
+/****************************************************************************/
+
+/* ddbridge-main.c (modparams) */
+extern int xo2_speed;
+extern int stv0910_single;
+
+/* ddbridge-core.c */
+void ddb_ports_detach(struct ddb *dev);
+void ddb_ports_release(struct ddb *dev);
+void ddb_buffers_free(struct ddb *dev);
+void ddb_device_destroy(struct ddb *dev);
+irqreturn_t irq_handler(int irq, void *dev_id);
+void ddb_ports_init(struct ddb *dev);
+int ddb_buffers_alloc(struct ddb *dev);
+int ddb_ports_attach(struct ddb *dev);
+int ddb_device_create(struct ddb *dev);
+int ddb_class_create(void);
+void ddb_class_destroy(void);
+
+/* ddbridge-i2c.c */
+int i2c_io(struct i2c_adapter *adapter, u8 adr,
+	   u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen);
+int i2c_read(struct i2c_adapter *adapter, u8 adr, u8 *val);
+int i2c_read_regs(struct i2c_adapter *adapter,
+		  u8 adr, u8 reg, u8 *val, u8 len);
+int i2c_read_reg(struct i2c_adapter *adapter, u8 adr, u8 reg, u8 *val);
+int i2c_read_reg16(struct i2c_adapter *adapter, u8 adr,
+		   u16 reg, u8 *val);
+int i2c_write_reg(struct i2c_adapter *adap, u8 adr,
+		  u8 reg, u8 val);
+void ddb_i2c_release(struct ddb *dev);
+int ddb_i2c_init(struct ddb *dev);
+
 #endif
-- 
2.13.0
