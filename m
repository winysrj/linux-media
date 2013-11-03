Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.swsoft.eu ([109.70.220.8]:51727 "EHLO relay.swsoft.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab3KCAof (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Nov 2013 20:44:35 -0400
Received: from mail.swsoft.eu ([109.70.220.2])
	by relay.swsoft.eu with esmtps (TLSv1:AES128-SHA:128)
	(Exim 4.77)
	(envelope-from <mbroemme@parallels.com>)
	id 1Vclnt-0001ud-Hd
	for linux-media@vger.kernel.org; Sun, 03 Nov 2013 01:44:33 +0100
Received: from parallels.com (cable-78-34-76-230.netcologne.de [78.34.76.230])
	by code.dyndns.org (Postfix) with ESMTPSA id 40CC7140CAF	for
 <linux-media@vger.kernel.org>; Sun,  3 Nov 2013 01:44:32 +0100 (CET)
Date: Sun, 3 Nov 2013 01:44:32 +0100
From: Maik Broemme <mbroemme@parallels.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 10/12] ddbridge: Update ddbridge driver to version 0.9.10
Message-ID: <20131103004432.GN7956@parallels.com>
References: <20131103002235.GD7956@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131103002235.GD7956@parallels.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Updated ddbridge driver to version 0.9.10.

Signed-off-by: Maik Broemme <mbroemme@parallels.com>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 3085 ++++++++++++++++++++--------
 1 file changed, 2236 insertions(+), 849 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 9375f30..1d8ee74 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1,284 +1,216 @@
 /*
- * ddbridge.c: Digital Devices PCIe bridge driver
+ *  ddbridge-core.c: Digital Devices PCIe bridge driver
  *
- * Copyright (C) 2010-2011 Digital Devices GmbH
+ *  Copyright (C) 2010-2013 Digital Devices GmbH
+ *  Copyright (C) 2013 Maik Broemme <mbroemme@parallels.com>
  *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 only, as published by the Free Software Foundation.
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  version 2 only, as published by the Free Software Foundation.
  *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
  *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA
- * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ *  02110-1301, USA
  */
 
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/delay.h>
-#include <linux/slab.h>
-#include <linux/poll.h>
-#include <linux/io.h>
-#include <linux/pci.h>
-#include <linux/pci_ids.h>
-#include <linux/timer.h>
-#include <linux/i2c.h>
-#include <linux/swab.h>
-#include <linux/vmalloc.h>
 #include "ddbridge.h"
-
 #include "ddbridge-regs.h"
 
-#include "tda18271c2dd.h"
+#include "cxd2843.h"
+#include "lnbh24.h"
 #include "stv6110x.h"
 #include "stv090x.h"
-#include "lnbh24.h"
+#include "tda18212dd.h"
+#include "stv0367dd.h"
+#ifdef CONFIG_DVB_TDA18212
+#include "tda18212.h"
+#endif
+#ifdef CONFIG_DVB_DRXK
 #include "drxk.h"
+#include "tda18271c2dd.h"
+#endif
 
-DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
-
-/* MSI had problems with lost interrupts, fixed but needs testing */
-#undef CONFIG_PCI_MSI
+static DEFINE_MUTEX(redirect_lock);
 
-/******************************************************************************/
+static struct workqueue_struct *ddb_wq;
+static int adapter_alloc;
 
-static int i2c_read(struct i2c_adapter *adapter, u8 adr, u8 *val)
-{
-	struct i2c_msg msgs[1] = {{.addr = adr,  .flags = I2C_M_RD,
-				   .buf  = val,  .len   = 1 } };
-	return (i2c_transfer(adapter, msgs, 1) == 1) ? 0 : -1;
-}
+module_param(adapter_alloc, int, 0444);
+MODULE_PARM_DESC(adapter_alloc, "0-one adapter per io, 1-one per tab with io, 2-one per tab, 3-one for all");
 
-static int i2c_read_reg(struct i2c_adapter *adapter, u8 adr, u8 reg, u8 *val)
-{
-	struct i2c_msg msgs[2] = {{.addr = adr,  .flags = 0,
-				   .buf  = &reg, .len   = 1 },
-				  {.addr = adr,  .flags = I2C_M_RD,
-				   .buf  = val,  .len   = 1 } };
-	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
-}
+static int ci_bitrate = 72000;
+module_param(ci_bitrate, int, 0444);
+MODULE_PARM_DESC(ci_bitrate, " Bitrate for output to CI.");
 
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
+static int ts_loop = -1;
+module_param(ts_loop, int, 0444);
+MODULE_PARM_DESC(ts_loop, "TS in/out test loop on port ts_loop");
 
-static int ddb_i2c_cmd(struct ddb_i2c *i2c, u32 adr, u32 cmd)
-{
-	struct ddb *dev = i2c->dev;
-	int stat;
-	u32 val;
+#define DDB_MAX_ADAPTER 32
+static struct ddb *ddbs[DDB_MAX_ADAPTER];
 
-	i2c->done = 0;
-	ddbwritel((adr << 9) | cmd, i2c->regs + I2C_COMMAND);
-	stat = wait_event_timeout(i2c->wq, i2c->done == 1, HZ);
-	if (stat <= 0) {
-		printk(KERN_ERR "I2C timeout\n");
-		{ /* MSI debugging*/
-			u32 istat = ddbreadl(INTERRUPT_STATUS);
-			printk(KERN_ERR "IRS %08x\n", istat);
-			ddbwritel(istat, INTERRUPT_ACK);
-		}
-		return -EIO;
-	}
-	val = ddbreadl(i2c->regs+I2C_COMMAND);
-	if (val & 0x70000)
-		return -EIO;
-	return 0;
-}
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-static int ddb_i2c_master_xfer(struct i2c_adapter *adapter,
-			       struct i2c_msg msg[], int num)
+static void ddb_set_dma_table(struct ddb *dev, struct ddb_dma *dma)
 {
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
+	u32 i, base;
+	u64 mem;
 
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
+	if (!dma)
+		return;
+	base = DMA_BASE_ADDRESS_TABLE + dma->nr * 0x100;
+	for (i = 0; i < dma->num; i++) {
+		mem = dma->pbuf[i];
+		ddbwritel(dev, mem & 0xffffffff, base + i * 8);
+		ddbwritel(dev, mem >> 32, base + i * 8 + 4);
 	}
-	return -EIO;
+	dma->bufreg = (dma->div << 16) | 
+		((dma->num & 0x1f) << 11) | 
+		((dma->size >> 7) & 0x7ff);
 }
 
-
-static u32 ddb_i2c_functionality(struct i2c_adapter *adap)
+static void ddb_set_dma_tables(struct ddb *dev)
 {
-	return I2C_FUNC_SMBUS_EMUL;
-}
+	u32 i;
 
-struct i2c_algorithm ddb_i2c_algo = {
-	.master_xfer   = ddb_i2c_master_xfer,
-	.functionality = ddb_i2c_functionality,
-};
+	for (i = 0; i < dev->info->port_num * 2; i++)
+		ddb_set_dma_table(dev, dev->input[i].dma);
+	for (i = 0; i < dev->info->port_num; i++)
+		ddb_set_dma_table(dev, dev->output[i].dma);
+}
 
-static void ddb_i2c_release(struct ddb *dev)
+static void ddb_redirect_dma(struct ddb *dev,
+			     struct ddb_dma *sdma,
+			     struct ddb_dma *ddma)
 {
-	int i;
-	struct ddb_i2c *i2c;
-	struct i2c_adapter *adap;
+	u32 i, base;
+	u64 mem;
 
-	for (i = 0; i < dev->info->port_num; i++) {
-		i2c = &dev->i2c[i];
-		adap = &i2c->adap;
-		i2c_del_adapter(adap);
+	sdma->bufreg = ddma->bufreg;
+	base = DMA_BASE_ADDRESS_TABLE + sdma->nr * 0x100;
+	for (i = 0; i < ddma->num; i++) {
+		mem = ddma->pbuf[i];
+		ddbwritel(dev, mem & 0xffffffff, base + i * 8);
+		ddbwritel(dev, mem >> 32, base + i * 8 + 4);
 	}
 }
 
-static int ddb_i2c_init(struct ddb *dev)
+static int ddb_unredirect(struct ddb_port *port)
 {
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
+	struct ddb_input *oredi, *iredi = 0;
+	struct ddb_output *iredo = 0;
+	
+	// printk("unredirect %d.%d\n", port->dev->nr, port->nr);
+	mutex_lock(&redirect_lock);
+	if (port->output->dma->running) {
+		mutex_unlock(&redirect_lock);
+		return -EBUSY;
 	}
-	if (stat)
-		for (j = 0; j < i; j++) {
-			i2c = &dev->i2c[j];
-			adap = &i2c->adap;
-			i2c_del_adapter(adap);
-		}
-	return stat;
+	oredi = port->output->redi;
+	if (!oredi)
+		goto done;
+	if (port->input[0]) {
+		iredi = port->input[0]->redi;
+		iredo = port->input[0]->redo;
+		
+		if (iredo) {
+			iredo->port->output->redi = oredi;
+			if (iredo->port->input[0]) {
+				iredo->port->input[0]->redi = iredi;
+				ddb_redirect_dma(oredi->port->dev, 
+						 oredi->dma, iredo->dma);
+			}
+			port->input[0]->redo = 0;
+			ddb_set_dma_table(port->dev, port->input[0]->dma);
+		} 
+		oredi->redi = iredi;
+		port->input[0]->redi = 0;
+	}
+	oredi->redo = 0;
+	port->output->redi = 0;
+
+	ddb_set_dma_table(oredi->port->dev, oredi->dma);
+done:
+	mutex_unlock(&redirect_lock);
+	return 0;
 }
 
+static int ddb_redirect(u32 i, u32 p)
+{
+	struct ddb *idev = ddbs[(i >> 4) & 0x1f];
+	struct ddb_input *input, *input2;
+	struct ddb *pdev = ddbs[(p >> 4) & 0x1f];
+	struct ddb_port *port;
 
-/******************************************************************************/
-/******************************************************************************/
-/******************************************************************************/
+	if (!idev->has_dma || !pdev->has_dma)
+		return -EINVAL;
+	if (!idev || !pdev)
+		return -EINVAL;
 
-#if 0
-static void set_table(struct ddb *dev, u32 off,
-		      dma_addr_t *pbuf, u32 num)
-{
-	u32 i, base;
-	u64 mem;
+	port = &pdev->port[p & 0x0f];
+	if (!port->output)
+		return -EINVAL;
+	if (ddb_unredirect(port))
+		return -EBUSY;
 
-	base = DMA_BASE_ADDRESS_TABLE + off;
-	for (i = 0; i < num; i++) {
-		mem = pbuf[i];
-		ddbwritel(mem & 0xffffffff, base + i * 8);
-		ddbwritel(mem >> 32, base + i * 8 + 4);
-	}
-}
-#endif
+	if (i == 8)
+		return 0;
 
-static void ddb_address_table(struct ddb *dev)
-{
-	u32 i, j, base;
-	u64 mem;
-	dma_addr_t *pbuf;
-
-	for (i = 0; i < dev->info->port_num * 2; i++) {
-		base = DMA_BASE_ADDRESS_TABLE + i * 0x100;
-		pbuf = dev->input[i].pbuf;
-		for (j = 0; j < dev->input[i].dma_buf_num; j++) {
-			mem = pbuf[j];
-			ddbwritel(mem & 0xffffffff, base + j * 8);
-			ddbwritel(mem >> 32, base + j * 8 + 4);
-		}
+	input = &idev->input[i & 7];
+	if (!input) 
+		return -EINVAL;
+
+	mutex_lock(&redirect_lock);
+	if (port->output->dma->running || input->dma->running) {
+		mutex_unlock(&redirect_lock);
+		return -EBUSY;
 	}
-	for (i = 0; i < dev->info->port_num; i++) {
-		base = DMA_BASE_ADDRESS_TABLE + 0x800 + i * 0x100;
-		pbuf = dev->output[i].pbuf;
-		for (j = 0; j < dev->output[i].dma_buf_num; j++) {
-			mem = pbuf[j];
-			ddbwritel(mem & 0xffffffff, base + j * 8);
-			ddbwritel(mem >> 32, base + j * 8 + 4);
-		}
+	if ((input2 = port->input[0])) {
+		if (input->redi) {
+			input2->redi = input->redi;
+			input->redi = 0;
+		} else
+			input2->redi = input;
 	}
+	input->redo = port->output;
+	port->output->redi = input;
+
+	ddb_redirect_dma(input->port->dev, input->dma, port->output->dma);
+	mutex_unlock(&redirect_lock);
+	return 0;
 }
 
-static void io_free(struct pci_dev *pdev, u8 **vbuf,
-		    dma_addr_t *pbuf, u32 size, int num)
+static void dma_free(struct pci_dev *pdev, struct ddb_dma *dma, int dir)
 {
 	int i;
 
-	for (i = 0; i < num; i++) {
-		if (vbuf[i]) {
-			pci_free_consistent(pdev, size, vbuf[i], pbuf[i]);
-			vbuf[i] = 0;
+	if (!dma)
+		return;
+	for (i = 0; i < dma->num; i++) {
+		if (dma->vbuf[i]) {
+			pci_free_consistent(pdev, dma->size,
+					    dma->vbuf[i], dma->pbuf[i]);
+			dma->vbuf[i] = 0;
 		}
 	}
 }
 
-static int io_alloc(struct pci_dev *pdev, u8 **vbuf,
-		    dma_addr_t *pbuf, u32 size, int num)
+static int dma_alloc(struct pci_dev *pdev, struct ddb_dma *dma, int dir)
 {
 	int i;
 
-	for (i = 0; i < num; i++) {
-		vbuf[i] = pci_alloc_consistent(pdev, size, &pbuf[i]);
-		if (!vbuf[i])
+	if (!dma)
+		return 0;
+	for (i = 0; i < dma->num; i++) {
+		dma->vbuf[i] = pci_alloc_consistent(pdev, dma->size,
+						    &dma->pbuf[i]);
+		if (!dma->vbuf[i])
 			return -ENOMEM;
 	}
 	return 0;
@@ -293,34 +225,24 @@ static int ddb_buffers_alloc(struct ddb *dev)
 		port = &dev->port[i];
 		switch (port->class) {
 		case DDB_PORT_TUNER:
-			if (io_alloc(dev->pdev, port->input[0]->vbuf,
-				     port->input[0]->pbuf,
-				     port->input[0]->dma_buf_size,
-				     port->input[0]->dma_buf_num) < 0)
+			if (dma_alloc(dev->pdev, port->input[0]->dma, 0) < 0)
 				return -1;
-			if (io_alloc(dev->pdev, port->input[1]->vbuf,
-				     port->input[1]->pbuf,
-				     port->input[1]->dma_buf_size,
-				     port->input[1]->dma_buf_num) < 0)
+			if (dma_alloc(dev->pdev, port->input[1]->dma, 0) < 0)
 				return -1;
 			break;
 		case DDB_PORT_CI:
-			if (io_alloc(dev->pdev, port->input[0]->vbuf,
-				     port->input[0]->pbuf,
-				     port->input[0]->dma_buf_size,
-				     port->input[0]->dma_buf_num) < 0)
+		case DDB_PORT_LOOP:
+			if (dma_alloc(dev->pdev, port->input[0]->dma, 0) < 0)
 				return -1;
-			if (io_alloc(dev->pdev, port->output->vbuf,
-				     port->output->pbuf,
-				     port->output->dma_buf_size,
-				     port->output->dma_buf_num) < 0)
+		case DDB_PORT_MOD:
+			if (dma_alloc(dev->pdev, port->output->dma, 1) < 0)
 				return -1;
 			break;
 		default:
 			break;
 		}
 	}
-	ddb_address_table(dev);
+	ddb_set_dma_tables(dev);
 	return 0;
 }
 
@@ -328,112 +250,171 @@ static void ddb_buffers_free(struct ddb *dev)
 {
 	int i;
 	struct ddb_port *port;
-
+	
 	for (i = 0; i < dev->info->port_num; i++) {
 		port = &dev->port[i];
-		io_free(dev->pdev, port->input[0]->vbuf,
-			port->input[0]->pbuf,
-			port->input[0]->dma_buf_size,
-			port->input[0]->dma_buf_num);
-		io_free(dev->pdev, port->input[1]->vbuf,
-			port->input[1]->pbuf,
-			port->input[1]->dma_buf_size,
-			port->input[1]->dma_buf_num);
-		io_free(dev->pdev, port->output->vbuf,
-			port->output->pbuf,
-			port->output->dma_buf_size,
-			port->output->dma_buf_num);
+		
+		if (port->input[0])
+			dma_free(dev->pdev, port->input[0]->dma, 0);
+		if (port->input[1])
+			dma_free(dev->pdev, port->input[1]->dma, 0);
+		if (port->output)
+			dma_free(dev->pdev, port->output->dma, 1);
 	}
 }
 
-static void ddb_input_start(struct ddb_input *input)
+static void ddb_output_start(struct ddb_output *output)
 {
-	struct ddb *dev = input->port->dev;
+	struct ddb *dev = output->port->dev;
+	u32 con2;
 
-	spin_lock_irq(&input->lock);
-	input->cbuf = 0;
-	input->coff = 0;
+	con2 = ((output->port->obr << 13) + 71999) / 72000; 
+	con2 = (con2 << 16) | output->port->gap;
 
-	/* reset */
-	ddbwritel(0, TS_INPUT_CONTROL(input->nr));
-	ddbwritel(2, TS_INPUT_CONTROL(input->nr));
-	ddbwritel(0, TS_INPUT_CONTROL(input->nr));
+	if (output->dma) {
+		spin_lock_irq(&output->dma->lock);
+		output->dma->cbuf = 0;
+		output->dma->coff = 0;
+		ddbwritel(dev, 0, DMA_BUFFER_CONTROL(output->dma->nr));
+	}
+	if (output->port->class == DDB_PORT_MOD) 
+		ddbridge_mod_output_start(output);
+	else {
+		ddbwritel(dev, 0, TS_OUTPUT_CONTROL(output->nr));
+		ddbwritel(dev, 2, TS_OUTPUT_CONTROL(output->nr));
+		ddbwritel(dev, 0, TS_OUTPUT_CONTROL(output->nr));
+		ddbwritel(dev, 0x3c, TS_OUTPUT_CONTROL(output->nr));
+		ddbwritel(dev, con2, TS_OUTPUT_CONTROL2(output->nr));
+	}
+	if (output->dma) {
+		ddbwritel(dev, output->dma->bufreg, DMA_BUFFER_SIZE(output->dma->nr));
+		ddbwritel(dev, 0, DMA_BUFFER_ACK(output->dma->nr));
+		ddbwritel(dev, 1, DMA_BASE_READ);
+		ddbwritel(dev, 3, DMA_BUFFER_CONTROL(output->dma->nr));
+	}
+	if (output->port->class != DDB_PORT_MOD) {
+		if (output->port->input[0]->port->class == DDB_PORT_LOOP)
+			// ddbwritel(dev, 0x15, TS_OUTPUT_CONTROL(output->nr));
+			// ddbwritel(dev, 0x45, TS_OUTPUT_CONTROL(output->nr));
+			ddbwritel(dev, (1 << 13) | 0x15, TS_OUTPUT_CONTROL(output->nr));
+		else
+			ddbwritel(dev, 0x1d, TS_OUTPUT_CONTROL(output->nr));
+	}
+	if (output->dma) { 
+		output->dma->running = 1;
+		spin_unlock_irq(&output->dma->lock);
+	}
+}
 
-	ddbwritel((1 << 16) |
-		  (input->dma_buf_num << 11) |
-		  (input->dma_buf_size >> 7),
-		  DMA_BUFFER_SIZE(input->nr));
-	ddbwritel(0, DMA_BUFFER_ACK(input->nr));
+static void ddb_output_stop(struct ddb_output *output)
+{
+	struct ddb *dev = output->port->dev;
 
-	ddbwritel(1, DMA_BASE_WRITE);
-	ddbwritel(3, DMA_BUFFER_CONTROL(input->nr));
-	ddbwritel(9, TS_INPUT_CONTROL(input->nr));
-	input->running = 1;
-	spin_unlock_irq(&input->lock);
+	if (output->dma)
+		spin_lock_irq(&output->dma->lock);
+	if (output->port->class == DDB_PORT_MOD) 
+		ddbridge_mod_output_stop(output);
+	else
+		ddbwritel(dev, 0, TS_OUTPUT_CONTROL(output->nr));
+	if (output->dma) {
+		ddbwritel(dev, 0, DMA_BUFFER_CONTROL(output->dma->nr));
+		output->dma->running = 0;
+		spin_unlock_irq(&output->dma->lock);
+	}
 }
 
 static void ddb_input_stop(struct ddb_input *input)
 {
 	struct ddb *dev = input->port->dev;
 
-	spin_lock_irq(&input->lock);
-	ddbwritel(0, TS_INPUT_CONTROL(input->nr));
-	ddbwritel(0, DMA_BUFFER_CONTROL(input->nr));
-	input->running = 0;
-	spin_unlock_irq(&input->lock);
+	if (input->dma)
+		spin_lock_irq(&input->dma->lock);
+	ddbwritel(dev, 0, TS_INPUT_CONTROL(input->nr));
+	if (input->dma) {
+		ddbwritel(dev, 0, DMA_BUFFER_CONTROL(input->dma->nr));
+		input->dma->running = 0;
+		spin_unlock_irq(&input->dma->lock);
+	}
+	// printk("input_stop %d.%d\n", dev->nr, input->nr);
 }
 
-static void ddb_output_start(struct ddb_output *output)
+static void ddb_input_start(struct ddb_input *input)
 {
-	struct ddb *dev = output->port->dev;
+	struct ddb *dev = input->port->dev;
 
-	spin_lock_irq(&output->lock);
-	output->cbuf = 0;
-	output->coff = 0;
-	ddbwritel(0, TS_OUTPUT_CONTROL(output->nr));
-	ddbwritel(2, TS_OUTPUT_CONTROL(output->nr));
-	ddbwritel(0, TS_OUTPUT_CONTROL(output->nr));
-	ddbwritel(0x3c, TS_OUTPUT_CONTROL(output->nr));
-	ddbwritel((1 << 16) |
-		  (output->dma_buf_num << 11) |
-		  (output->dma_buf_size >> 7),
-		  DMA_BUFFER_SIZE(output->nr + 8));
-	ddbwritel(0, DMA_BUFFER_ACK(output->nr + 8));
-
-	ddbwritel(1, DMA_BASE_READ);
-	ddbwritel(3, DMA_BUFFER_CONTROL(output->nr + 8));
-	/* ddbwritel(0xbd, TS_OUTPUT_CONTROL(output->nr)); */
-	ddbwritel(0x1d, TS_OUTPUT_CONTROL(output->nr));
-	output->running = 1;
-	spin_unlock_irq(&output->lock);
+	if (input->dma) {
+		spin_lock_irq(&input->dma->lock);
+		input->dma->cbuf = 0;
+		input->dma->coff = 0;
+		ddbwritel(dev, 0, DMA_BUFFER_CONTROL(input->dma->nr));
+	}
+	ddbwritel(dev, 0, TS_INPUT_CONTROL2(input->nr));
+	ddbwritel(dev, 0, TS_INPUT_CONTROL(input->nr));
+	ddbwritel(dev, 2, TS_INPUT_CONTROL(input->nr));
+	ddbwritel(dev, 0, TS_INPUT_CONTROL(input->nr));
+
+	if (input->dma) {
+		ddbwritel(dev, input->dma->bufreg, DMA_BUFFER_SIZE(input->dma->nr));
+		ddbwritel(dev, 0, DMA_BUFFER_ACK(input->dma->nr));
+		ddbwritel(dev, 1, DMA_BASE_WRITE);
+		ddbwritel(dev, 3, DMA_BUFFER_CONTROL(input->dma->nr));
+	}
+	if (dev->info->type == DDB_OCTONET) 
+		ddbwritel(dev, 0x01, TS_INPUT_CONTROL(input->nr));
+	else
+		ddbwritel(dev, 0x09, TS_INPUT_CONTROL(input->nr));
+	if (input->dma) {
+		input->dma->running = 1;
+		spin_unlock_irq(&input->dma->lock);
+	}
+	// printk("input_start %d.%d\n", dev->nr, input->nr);
 }
 
-static void ddb_output_stop(struct ddb_output *output)
+static void ddb_input_start_all(struct ddb_input *input)
 {
-	struct ddb *dev = output->port->dev;
+	struct ddb_input *i = input;
+	struct ddb_output *o;
+	
+	mutex_lock(&redirect_lock);
+	while (i && (o = i->redo)) {
+		ddb_output_start(o);
+		if ((i = o->port->input[0]))
+			ddb_input_start(i);
+	}
+	ddb_input_start(input);
+	mutex_unlock(&redirect_lock);
+}
 
-	spin_lock_irq(&output->lock);
-	ddbwritel(0, TS_OUTPUT_CONTROL(output->nr));
-	ddbwritel(0, DMA_BUFFER_CONTROL(output->nr + 8));
-	output->running = 0;
-	spin_unlock_irq(&output->lock);
+static void ddb_input_stop_all(struct ddb_input *input)
+{
+	struct ddb_input *i = input;
+	struct ddb_output *o;
+	
+	mutex_lock(&redirect_lock);
+	ddb_input_stop(input);
+	while (i && (o = i->redo)) {
+		ddb_output_stop(o);
+		if ((i = o->port->input[0]))
+			ddb_input_stop(i);
+	}
+	mutex_unlock(&redirect_lock);
 }
 
 static u32 ddb_output_free(struct ddb_output *output)
 {
-	u32 idx, off, stat = output->stat;
+	u32 idx, off, stat = output->dma->stat;
 	s32 diff;
 
 	idx = (stat >> 11) & 0x1f;
 	off = (stat & 0x7ff) << 7;
-
-	if (output->cbuf != idx) {
-		if ((((output->cbuf + 1) % output->dma_buf_num) == idx) &&
-		    (output->dma_buf_size - output->coff <= 188))
+ 
+	if (output->dma->cbuf != idx) {
+		if ((((output->dma->cbuf + 1) % output->dma->num) == idx) &&
+		    (output->dma->size - output->dma->coff <= 188))
 			return 0;
 		return 188;
 	}
-	diff = off - output->coff;
+	diff = off - output->dma->coff;
 	if (diff <= 0 || diff > 188)
 		return 188;
 	return 0;
@@ -443,46 +424,46 @@ static ssize_t ddb_output_write(struct ddb_output *output,
 				const u8 *buf, size_t count)
 {
 	struct ddb *dev = output->port->dev;
-	u32 idx, off, stat = output->stat;
+	u32 idx, off, stat = output->dma->stat;
 	u32 left = count, len;
 
 	idx = (stat >> 11) & 0x1f;
 	off = (stat & 0x7ff) << 7;
 
 	while (left) {
-		len = output->dma_buf_size - output->coff;
-		if ((((output->cbuf + 1) % output->dma_buf_num) == idx) &&
+		len = output->dma->size - output->dma->coff;
+		if ((((output->dma->cbuf + 1) % output->dma->num) == idx) &&
 		    (off == 0)) {
 			if (len <= 188)
 				break;
 			len -= 188;
 		}
-		if (output->cbuf == idx) {
-			if (off > output->coff) {
-#if 1
-				len = off - output->coff;
+		if (output->dma->cbuf == idx) {
+			if (off > output->dma->coff) {
+				len = off - output->dma->coff;
 				len -= (len % 188);
 				if (len <= 188)
-
-#endif
 					break;
 				len -= 188;
 			}
 		}
 		if (len > left)
 			len = left;
-		if (copy_from_user(output->vbuf[output->cbuf] + output->coff,
+		if (copy_from_user(output->dma->vbuf[output->dma->cbuf] +
+				   output->dma->coff,
 				   buf, len))
 			return -EIO;
 		left -= len;
 		buf += len;
-		output->coff += len;
-		if (output->coff == output->dma_buf_size) {
-			output->coff = 0;
-			output->cbuf = ((output->cbuf + 1) % output->dma_buf_num);
+		output->dma->coff += len;
+		if (output->dma->coff == output->dma->size) {
+			output->dma->coff = 0;
+			output->dma->cbuf = ((output->dma->cbuf + 1) %
+					     output->dma->num);
 		}
-		ddbwritel((output->cbuf << 11) | (output->coff >> 7),
-			  DMA_BUFFER_ACK(output->nr + 8));
+		ddbwritel(dev, 
+			  (output->dma->cbuf << 11) | (output->dma->coff >> 7),
+			  DMA_BUFFER_ACK(output->dma->nr));
 	}
 	return count - left;
 }
@@ -490,139 +471,410 @@ static ssize_t ddb_output_write(struct ddb_output *output,
 static u32 ddb_input_avail(struct ddb_input *input)
 {
 	struct ddb *dev = input->port->dev;
-	u32 idx, off, stat = input->stat;
-	u32 ctrl = ddbreadl(DMA_BUFFER_CONTROL(input->nr));
+	u32 idx, off, stat = input->dma->stat;
+	u32 ctrl = ddbreadl(dev, DMA_BUFFER_CONTROL(input->dma->nr));
 
 	idx = (stat >> 11) & 0x1f;
 	off = (stat & 0x7ff) << 7;
 
 	if (ctrl & 4) {
 		printk(KERN_ERR "IA %d %d %08x\n", idx, off, ctrl);
-		ddbwritel(input->stat, DMA_BUFFER_ACK(input->nr));
+		ddbwritel(dev, stat, DMA_BUFFER_ACK(input->dma->nr));
 		return 0;
 	}
-	if (input->cbuf != idx)
+	if (input->dma->cbuf != idx || off < input->dma->coff)
 		return 188;
 	return 0;
 }
 
-static ssize_t ddb_input_read(struct ddb_input *input, u8 *buf, size_t count)
+static size_t ddb_input_read(struct ddb_input *input, u8 *buf, size_t count)
 {
 	struct ddb *dev = input->port->dev;
 	u32 left = count;
-	u32 idx, free, stat = input->stat;
+	u32 idx, off, free, stat = input->dma->stat;
 	int ret;
 
 	idx = (stat >> 11) & 0x1f;
+	off = (stat & 0x7ff) << 7;
 
 	while (left) {
-		if (input->cbuf == idx)
+		if (input->dma->cbuf == idx)
 			return count - left;
-		free = input->dma_buf_size - input->coff;
+		free = input->dma->size - input->dma->coff;
 		if (free > left)
 			free = left;
-		ret = copy_to_user(buf, input->vbuf[input->cbuf] +
-				   input->coff, free);
+		ret = copy_to_user(buf, input->dma->vbuf[input->dma->cbuf] +
+				   input->dma->coff, free);
 		if (ret)
 			return -EFAULT;
-		input->coff += free;
-		if (input->coff == input->dma_buf_size) {
-			input->coff = 0;
-			input->cbuf = (input->cbuf+1) % input->dma_buf_num;
+		input->dma->coff += free;
+		if (input->dma->coff == input->dma->size) {
+			input->dma->coff = 0;
+			input->dma->cbuf = (input->dma->cbuf + 1) %
+				input->dma->num;
 		}
 		left -= free;
-		ddbwritel((input->cbuf << 11) | (input->coff >> 7),
-			  DMA_BUFFER_ACK(input->nr));
+		ddbwritel(dev, 
+			  (input->dma->cbuf << 11) | (input->dma->coff >> 7),
+			  DMA_BUFFER_ACK(input->dma->nr));
 	}
 	return count;
 }
 
-/******************************************************************************/
-/******************************************************************************/
-/******************************************************************************/
+static ssize_t ts_write(struct file *file, const char *buf,
+			size_t count, loff_t *ppos)
+{
+	struct dvb_device *dvbdev = file->private_data;
+	struct ddb_output *output = dvbdev->priv;
+	struct ddb *dev = output->port->dev;
+	size_t left = count;
+	int stat;
+
+	if (!dev->has_dma)
+		return -EINVAL;
+	while (left) {
+		if (ddb_output_free(output) < 188) {
+			if (file->f_flags & O_NONBLOCK) 
+				break;
+			if (wait_event_interruptible(
+				    output->dma->wq,
+				    ddb_output_free(output) >= 188) < 0) 
+				break;
+		}
+		stat = ddb_output_write(output, buf, left);
+		if (stat < 0)
+			return stat;
+		buf += stat;
+		left -= stat;
+	}
+	return (left == count) ? -EAGAIN : (count - left);
+}
+
+static ssize_t ts_read(struct file *file, char *buf,
+		       size_t count, loff_t *ppos)
+{
+	struct dvb_device *dvbdev = file->private_data;
+	struct ddb_output *output = dvbdev->priv;
+	struct ddb_input *input = output->port->input[0];
+	struct ddb *dev = output->port->dev;
+	int left, read;
+
+	if (!dev->has_dma)
+		return -EINVAL;
+	count -= count % 188;
+	left = count;
+	while (left) {
+		if (ddb_input_avail(input) < 188) {
+			if (file->f_flags & O_NONBLOCK)
+				break;
+			if (wait_event_interruptible(
+				    input->dma->wq, 
+				    ddb_input_avail(input) >= 188) < 0)
+				break;
+		}
+		read = ddb_input_read(input, buf, left);
+		left -= read;
+		buf += read;
+	}
+	return (left == count) ? -EAGAIN : (count - left);
+}
 
-#if 0
-static struct ddb_input *fe2input(struct ddb *dev, struct dvb_frontend *fe)
+static unsigned int ts_poll(struct file *file, poll_table *wait)
 {
-	int i;
+	struct dvb_device *dvbdev = file->private_data;
+	struct ddb_output *output = dvbdev->priv;
+	struct ddb_input *input = output->port->input[0];
+
+	unsigned int mask = 0;
+
+	poll_wait(file, &input->dma->wq, wait);
+	poll_wait(file, &output->dma->wq, wait);
+	if (ddb_input_avail(input) >= 188)
+		mask |= POLLIN | POLLRDNORM;
+	if (ddb_output_free(output) >= 188)
+		mask |= POLLOUT | POLLWRNORM;
+	return mask;
+}
+
+static int ts_release(struct inode *inode, struct file *file)
+{
+	struct dvb_device *dvbdev = file->private_data;
+	struct ddb_output *output = dvbdev->priv;
+	struct ddb_input *input = output->port->input[0];
+	
+	if ((file->f_flags & O_ACCMODE) == O_RDONLY) {
+		if (!input)
+			return -EINVAL;
+		ddb_input_stop(input);
+	} else if ((file->f_flags & O_ACCMODE) == O_WRONLY) {
+		if (!output)
+			return -EINVAL;
+		ddb_output_stop(output);
+	}
+	return dvb_generic_release(inode, file);
+}
 
-	for (i = 0; i < dev->info->port_num * 2; i++) {
-		if (dev->input[i].fe == fe)
-			return &dev->input[i];
+static int ts_open(struct inode *inode, struct file *file)
+{
+	int err;
+	struct dvb_device *dvbdev = file->private_data;
+	struct ddb_output *output = dvbdev->priv;
+	struct ddb_input *input = output->port->input[0];
+	
+	if ((file->f_flags & O_ACCMODE) == O_RDONLY) {
+		if (!input)
+			return -EINVAL;
+		if (input->redo || input->redi)
+			return -EBUSY;
+	} else if ((file->f_flags & O_ACCMODE) == O_WRONLY) {
+		if (!output)
+			return -EINVAL;
 	}
-	return NULL;
+	if ((err = dvb_generic_open(inode, file)) < 0)
+		return err;
+	if ((file->f_flags & O_ACCMODE) == O_RDONLY) 
+		ddb_input_start(input);
+	else if ((file->f_flags & O_ACCMODE) == O_WRONLY) 
+		ddb_output_start(output);
+	return err;
 }
-#endif
 
-static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
+static int mod_release(struct inode *inode, struct file *file)
+{
+	struct dvb_device *dvbdev = file->private_data;
+	struct ddb_output *output = dvbdev->priv;
+	
+	if ((file->f_flags & O_ACCMODE) == O_WRONLY) {
+		if (!output)
+			return -EINVAL;
+		ddb_output_stop(output);
+	}
+	return dvb_generic_release(inode, file);
+}
+
+static int mod_open(struct inode *inode, struct file *file)
+{
+	int err;
+	struct dvb_device *dvbdev = file->private_data;
+	struct ddb_output *output = dvbdev->priv;
+	
+	if ((file->f_flags & O_ACCMODE) == O_WRONLY) {
+		if (!output)
+			return -EINVAL;
+	}
+	if ((err = dvb_generic_open(inode, file)) < 0)
+		return err;
+	if ((file->f_flags & O_ACCMODE) == O_WRONLY) 
+		ddb_output_start(output);
+	return err;
+}
+static const struct file_operations ci_fops = {
+	.owner   = THIS_MODULE,
+	.read    = ts_read,
+	.write   = ts_write,
+	.open    = ts_open,
+	.release = ts_release,
+	.poll    = ts_poll,
+	.mmap    = 0,
+};
+
+static struct dvb_device dvbdev_ci = {
+	.priv    = 0,
+	.readers = 1,
+	.writers = 1,
+	.users   = 2,
+	.fops    = &ci_fops,
+};
+
+static long mod_ioctl(struct file *file,
+		      unsigned int cmd, unsigned long arg)
+{
+	return dvb_usercopy(file, cmd, arg, ddbridge_mod_do_ioctl);
+}
+
+static const struct file_operations mod_fops = {
+	.owner   = THIS_MODULE,
+	.read    = ts_read,
+	.write   = ts_write,
+	.open    = mod_open,
+	.release = mod_release,
+	.poll    = ts_poll,
+	.mmap    = 0,
+	.unlocked_ioctl = mod_ioctl,
+};
+
+static struct dvb_device dvbdev_mod = {
+	.priv    = 0,
+	.readers = 1,
+	.writers = 1,
+	.users   = 2,
+	.fops    = &mod_fops,
+};
+
+static int locked_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct ddb_input *input = fe->sec_priv;
 	struct ddb_port *port = input->port;
+	struct ddb_dvb *dvb = &port->dvb[input->nr & 1];
 	int status;
 
 	if (enable) {
 		mutex_lock(&port->i2c_gate_lock);
-		status = input->gate_ctrl(fe, 1);
+		status = dvb->gate_ctrl(fe, 1); 
 	} else {
-		status = input->gate_ctrl(fe, 0);
+		status = dvb->gate_ctrl(fe, 0);
 		mutex_unlock(&port->i2c_gate_lock);
 	}
 	return status;
 }
 
+#ifdef CONFIG_DVB_DRXK
 static int demod_attach_drxk(struct ddb_input *input)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
 	struct dvb_frontend *fe;
-	struct drxk_config config;
 
-	memset(&config, 0, sizeof(config));
-	config.microcode_name = "drxk_a3.mc";
-	config.qam_demod_parameter_count = 4;
-	config.adr = 0x29 + (input->nr & 1);
-
-	fe = input->fe = dvb_attach(drxk_attach, &config, i2c);
-	if (!input->fe) {
+	fe = dvb->fe = dvb_attach(drxk_attach,
+				  i2c, 0x29 + (input->nr&1),
+				  &dvb->fe2);
+	if (!fe) {
 		printk(KERN_ERR "No DRXK found!\n");
 		return -ENODEV;
 	}
 	fe->sec_priv = input;
-	input->gate_ctrl = fe->ops.i2c_gate_ctrl;
-	fe->ops.i2c_gate_ctrl = drxk_gate_ctrl;
+	dvb->gate_ctrl = fe->ops.i2c_gate_ctrl;
+	fe->ops.i2c_gate_ctrl = locked_gate_ctrl;
 	return 0;
 }
+#endif
 
-static int tuner_attach_tda18271(struct ddb_input *input)
+struct cxd2843_cfg cxd2843_0 = {
+	.adr = 0x6c,
+};
+
+struct cxd2843_cfg cxd2843_1 = {
+	.adr = 0x6d,
+};
+
+static int demod_attach_cxd2843(struct ddb_input *input)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
 	struct dvb_frontend *fe;
-
-	if (input->fe->ops.i2c_gate_ctrl)
-		input->fe->ops.i2c_gate_ctrl(input->fe, 1);
-	fe = dvb_attach(tda18271c2dd_attach, input->fe, i2c, 0x60);
-	if (!fe) {
-		printk(KERN_ERR "No TDA18271 found!\n");
+	
+	fe = dvb->fe = dvb_attach(cxd2843_attach, i2c,
+				  (input->nr & 1) ? &cxd2843_1 : &cxd2843_0);
+	if (!dvb->fe) {
+		printk(KERN_ERR "No cxd2843 found!\n");
 		return -ENODEV;
 	}
-	if (input->fe->ops.i2c_gate_ctrl)
-		input->fe->ops.i2c_gate_ctrl(input->fe, 0);
+	fe->sec_priv = input;
+	dvb->gate_ctrl = fe->ops.i2c_gate_ctrl;
+	fe->ops.i2c_gate_ctrl = locked_gate_ctrl;
 	return 0;
 }
 
-/******************************************************************************/
-/******************************************************************************/
-/******************************************************************************/
+struct stv0367_cfg stv0367dd_0 = {
+	.adr = 0x1f,
+	.xtal = 27000000,
+};
 
-static struct stv090x_config stv0900 = {
-	.device         = STV0900,
-	.demod_mode     = STV090x_DUAL,
-	.clk_mode       = STV090x_CLK_EXT,
+struct stv0367_cfg stv0367dd_1 = {
+	.adr = 0x1e,
+	.xtal = 27000000,
+};
 
-	.xtal           = 27000000,
-	.address        = 0x69,
+static int demod_attach_stv0367dd(struct ddb_input *input)
+{
+	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct dvb_frontend *fe;
 
-	.ts1_mode       = STV090x_TSMODE_SERIAL_PUNCTURED,
-	.ts2_mode       = STV090x_TSMODE_SERIAL_PUNCTURED,
+	fe = dvb->fe = dvb_attach(stv0367_attach, i2c,
+				  (input->nr & 1) ? &stv0367dd_1 : &stv0367dd_0,
+				  &dvb->fe2);
+	if (!dvb->fe) {
+		printk(KERN_ERR "No stv0367 found!\n");
+		return -ENODEV;
+	}
+	fe->sec_priv = input;
+	dvb->gate_ctrl = fe->ops.i2c_gate_ctrl;
+	fe->ops.i2c_gate_ctrl = locked_gate_ctrl;
+	return 0;
+}
+
+#ifdef CONFIG_DVB_DRXK
+static int tuner_attach_tda18271(struct ddb_input *input)
+{
+	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct dvb_frontend *fe;
+
+	if (dvb->fe->ops.i2c_gate_ctrl)
+		dvb->fe->ops.i2c_gate_ctrl(dvb->fe, 1);
+	fe = dvb_attach(tda18271c2dd_attach, dvb->fe, i2c, 0x60);
+	if (dvb->fe->ops.i2c_gate_ctrl)
+		dvb->fe->ops.i2c_gate_ctrl(dvb->fe, 0);
+	if (!fe) {
+		printk(KERN_ERR "No TDA18271 found!\n");
+		return -ENODEV;
+	}
+	return 0;
+}
+#endif
+
+static int tuner_attach_tda18212dd(struct ddb_input *input)
+{
+	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct dvb_frontend *fe;
+
+	fe = dvb_attach(tda18212dd_attach, dvb->fe, i2c,
+			(input->nr & 1) ? 0x63 : 0x60);
+	if (!fe) {
+		printk(KERN_ERR "No TDA18212 found!\n");
+		return -ENODEV;
+	}
+	return 0;
+}
+
+#ifdef CONFIG_DVB_TDA18212
+struct tda18212_config tda18212_0 = {
+	.i2c_address = 0x60,
+};
+
+struct tda18212_config tda18212_1 = {
+	.i2c_address = 0x63,
+};
+
+static int tuner_attach_tda18212(struct ddb_input *input)
+{
+	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct dvb_frontend *fe;
+	struct tda18212_config *cfg;
+
+	cfg = (input->nr & 1) ? &tda18212_1 : &tda18212_0;
+	fe = dvb_attach(tda18212_attach, dvb->fe, i2c, cfg);
+	if (!fe) {
+		printk(KERN_ERR "No TDA18212 found!\n");
+		return -ENODEV;
+	}
+	return 0;
+}
+#endif
+
+static struct stv090x_config stv0900 = {
+	.device         = STV0900,
+	.demod_mode     = STV090x_DUAL,
+	.clk_mode       = STV090x_CLK_EXT,
+
+	.xtal           = 27000000,
+	.address        = 0x69,
+
+	.ts1_mode       = STV090x_TSMODE_SERIAL_PUNCTURED,
+	.ts2_mode       = STV090x_TSMODE_SERIAL_PUNCTURED,
 
 	.repeater_level = STV090x_RPTLEVEL_16,
 
@@ -667,15 +919,16 @@ static int demod_attach_stv0900(struct ddb_input *input, int type)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
 	struct stv090x_config *feconf = type ? &stv0900_aa : &stv0900;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
 
-	input->fe = dvb_attach(stv090x_attach, feconf, i2c,
-			       (input->nr & 1) ? STV090x_DEMODULATOR_1
-			       : STV090x_DEMODULATOR_0);
-	if (!input->fe) {
+	dvb->fe = dvb_attach(stv090x_attach, feconf, i2c,
+			     (input->nr & 1) ? STV090x_DEMODULATOR_1
+			     : STV090x_DEMODULATOR_0);
+	if (!dvb->fe) {
 		printk(KERN_ERR "No STV0900 found!\n");
 		return -ENODEV;
 	}
-	if (!dvb_attach(lnbh24_attach, input->fe, i2c, 0,
+	if (!dvb_attach(lnbh24_attach, dvb->fe, i2c, 0,
 			0, (input->nr & 1) ?
 			(0x09 - type) : (0x0b - type))) {
 		printk(KERN_ERR "No LNBH24 found!\n");
@@ -687,18 +940,19 @@ static int demod_attach_stv0900(struct ddb_input *input, int type)
 static int tuner_attach_stv6110(struct ddb_input *input, int type)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
 	struct stv090x_config *feconf = type ? &stv0900_aa : &stv0900;
 	struct stv6110x_config *tunerconf = (input->nr & 1) ?
 		&stv6110b : &stv6110a;
 	struct stv6110x_devctl *ctl;
 
-	ctl = dvb_attach(stv6110x_attach, input->fe, tunerconf, i2c);
+	ctl = dvb_attach(stv6110x_attach, dvb->fe, tunerconf, i2c);
 	if (!ctl) {
 		printk(KERN_ERR "No STV6110X found!\n");
 		return -ENODEV;
 	}
 	printk(KERN_INFO "attach tuner input %d adr %02x\n",
-			 input->nr, tunerconf->addr);
+	       input->nr, tunerconf->addr);
 
 	feconf->tuner_init          = ctl->tuner_init;
 	feconf->tuner_sleep         = ctl->tuner_sleep;
@@ -716,9 +970,9 @@ static int tuner_attach_stv6110(struct ddb_input *input, int type)
 }
 
 static int my_dvb_dmx_ts_card_init(struct dvb_demux *dvbdemux, char *id,
-			    int (*start_feed)(struct dvb_demux_feed *),
-			    int (*stop_feed)(struct dvb_demux_feed *),
-			    void *priv)
+				   int (*start_feed)(struct dvb_demux_feed *),
+				   int (*stop_feed)(struct dvb_demux_feed *),
+				   void *priv)
 {
 	dvbdemux->priv = priv;
 
@@ -734,10 +988,10 @@ static int my_dvb_dmx_ts_card_init(struct dvb_demux *dvbdemux, char *id,
 }
 
 static int my_dvb_dmxdev_ts_card_init(struct dmxdev *dmxdev,
-			       struct dvb_demux *dvbdemux,
-			       struct dmx_frontend *hw_frontend,
-			       struct dmx_frontend *mem_frontend,
-			       struct dvb_adapter *dvb_adapter)
+				      struct dvb_demux *dvbdemux,
+				      struct dmx_frontend *hw_frontend,
+				      struct dmx_frontend *mem_frontend,
+				      struct dvb_adapter *dvb_adapter)
 {
 	int ret;
 
@@ -759,318 +1013,610 @@ static int start_feed(struct dvb_demux_feed *dvbdmxfeed)
 {
 	struct dvb_demux *dvbdmx = dvbdmxfeed->demux;
 	struct ddb_input *input = dvbdmx->priv;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
 
-	if (!input->users)
-		ddb_input_start(input);
+	if (!dvb->users)
+		ddb_input_start_all(input);
 
-	return ++input->users;
+	return ++dvb->users;
 }
 
 static int stop_feed(struct dvb_demux_feed *dvbdmxfeed)
 {
 	struct dvb_demux *dvbdmx = dvbdmxfeed->demux;
 	struct ddb_input *input = dvbdmx->priv;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
 
-	if (--input->users)
-		return input->users;
+	if (--dvb->users)
+		return dvb->users;
 
-	ddb_input_stop(input);
+	ddb_input_stop_all(input);
 	return 0;
 }
 
-
 static void dvb_input_detach(struct ddb_input *input)
 {
-	struct dvb_adapter *adap = &input->adap;
-	struct dvb_demux *dvbdemux = &input->demux;
-
-	switch (input->attached) {
-	case 5:
-		if (input->fe2)
-			dvb_unregister_frontend(input->fe2);
-		if (input->fe) {
-			dvb_unregister_frontend(input->fe);
-			dvb_frontend_detach(input->fe);
-			input->fe = NULL;
-		}
-	case 4:
-		dvb_net_release(&input->dvbnet);
-
-	case 3:
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct dvb_demux *dvbdemux = &dvb->demux;
+
+	switch (dvb->attached) {
+	case 0x31:
+		if (dvb->fe2)
+			dvb_unregister_frontend(dvb->fe2);
+		if (dvb->fe)
+			dvb_unregister_frontend(dvb->fe);
+	case 0x30:
+		dvb_frontend_detach(dvb->fe);
+		dvb->fe = dvb->fe2 = NULL;
+	case 0x20:
+		dvb_net_release(&dvb->dvbnet);
+	case 0x11:
 		dvbdemux->dmx.close(&dvbdemux->dmx);
 		dvbdemux->dmx.remove_frontend(&dvbdemux->dmx,
-					      &input->hw_frontend);
+					      &dvb->hw_frontend);
 		dvbdemux->dmx.remove_frontend(&dvbdemux->dmx,
-					      &input->mem_frontend);
-		dvb_dmxdev_release(&input->dmxdev);
+					      &dvb->mem_frontend);
+		dvb_dmxdev_release(&dvb->dmxdev);
+	case 0x10:
+		dvb_dmx_release(&dvb->demux);
+	case 0x01:
+		break;
+	}
+	dvb->attached = 0x00;
+}
+
+static int dvb_register_adapters(struct ddb *dev)
+{
+	int i, ret = 0;
+	struct ddb_port *port;
+	struct dvb_adapter *adap;
+
+	if (adapter_alloc == 3 || dev->info->type == DDB_MOD) {
+		port = &dev->port[0];
+		adap = port->dvb[0].adap;
+		ret = dvb_register_adapter(adap, "DDBridge", THIS_MODULE,
+					   port->dev->dev,
+					   adapter_nr);
+		if (ret < 0)
+			return ret;
+		port->dvb[0].adap_registered = 1;
+		for (i = 0; i < dev->info->port_num; i++) {
+			port = &dev->port[i];
+			port->dvb[0].adap = adap;
+			port->dvb[1].adap = adap;
+		}
+		return 0;
+	}
+
+	for (i = 0; i < dev->info->port_num; i++) {
+		port = &dev->port[i];
+		switch (port->class) {
+		case DDB_PORT_TUNER:
+			adap = port->dvb[0].adap;
+			ret = dvb_register_adapter(adap, "DDBridge", 
+						   THIS_MODULE,
+						   port->dev->dev,
+						   adapter_nr);
+			if (ret < 0)
+				return ret;
+			port->dvb[0].adap_registered = 1;
+
+			if (adapter_alloc > 0) {
+				port->dvb[1].adap = port->dvb[0].adap;
+				break;
+			}
+			adap = port->dvb[1].adap;
+			ret = dvb_register_adapter(adap, "DDBridge", 
+						   THIS_MODULE,
+						   port->dev->dev,
+						   adapter_nr);
+			if (ret < 0)
+				return ret;
+			port->dvb[1].adap_registered = 1;
+			break;
+
+		case DDB_PORT_CI:
+		case DDB_PORT_LOOP:
+			adap = port->dvb[0].adap;
+			ret = dvb_register_adapter(adap, "DDBridge",
+						   THIS_MODULE,
+						   port->dev->dev,
+						   adapter_nr);
+			if (ret < 0)
+				return ret;
+			port->dvb[0].adap_registered = 1;
+			break;
+		default:
+			if (adapter_alloc < 2)
+				break;
+			adap = port->dvb[0].adap;
+			ret = dvb_register_adapter(adap, "DDBridge",
+						   THIS_MODULE,
+						   port->dev->dev,
+						   adapter_nr);
+			if (ret < 0)
+				return ret;
+			port->dvb[0].adap_registered = 1;
+			break;
+		}
+	}
+	return ret;
+}
+
+static void dvb_unregister_adapters(struct ddb *dev)
+{
+	int i;
+	struct ddb_port *port;
+	struct ddb_dvb *dvb;
 
-	case 2:
-		dvb_dmx_release(&input->demux);
+	for (i = 0; i < dev->info->port_num; i++) {
+		port = &dev->port[i];
 
-	case 1:
-		dvb_unregister_adapter(adap);
+		dvb = &port->dvb[0];
+		if (dvb->adap_registered)
+			dvb_unregister_adapter(dvb->adap);
+		dvb->adap_registered = 0;
+		
+		dvb = &port->dvb[1];
+		if (dvb->adap_registered)
+			dvb_unregister_adapter(dvb->adap);
+		dvb->adap_registered = 0;
 	}
-	input->attached = 0;
 }
 
 static int dvb_input_attach(struct ddb_input *input)
 {
-	int ret;
+	int ret = 0;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
 	struct ddb_port *port = input->port;
-	struct dvb_adapter *adap = &input->adap;
-	struct dvb_demux *dvbdemux = &input->demux;
-
-	ret = dvb_register_adapter(adap, "DDBridge", THIS_MODULE,
-				   &input->port->dev->pdev->dev,
-				   adapter_nr);
-	if (ret < 0) {
-		printk(KERN_ERR "ddbridge: Could not register adapter."
-		       "Check if you enabled enough adapters in dvb-core!\n");
-		return ret;
-	}
-	input->attached = 1;
+	struct dvb_adapter *adap = dvb->adap;
+	struct dvb_demux *dvbdemux = &dvb->demux;
+
+	dvb->attached = 0x01;
 
 	ret = my_dvb_dmx_ts_card_init(dvbdemux, "SW demux",
 				      start_feed,
 				      stop_feed, input);
 	if (ret < 0)
 		return ret;
-	input->attached = 2;
+	dvb->attached = 0x10;
 
-	ret = my_dvb_dmxdev_ts_card_init(&input->dmxdev, &input->demux,
-					 &input->hw_frontend,
-					 &input->mem_frontend, adap);
+	ret = my_dvb_dmxdev_ts_card_init(&dvb->dmxdev,
+					 &dvb->demux,
+					 &dvb->hw_frontend,
+					 &dvb->mem_frontend, adap);
 	if (ret < 0)
 		return ret;
-	input->attached = 3;
+	dvb->attached = 0x11;
 
-	ret = dvb_net_init(adap, &input->dvbnet, input->dmxdev.demux);
+	ret = dvb_net_init(adap, &dvb->dvbnet, dvb->dmxdev.demux);
 	if (ret < 0)
 		return ret;
-	input->attached = 4;
+	dvb->attached = 0x20;
 
-	input->fe = 0;
+	dvb->fe = dvb->fe2 = 0;
 	switch (port->type) {
 	case DDB_TUNER_DVBS_ST:
 		if (demod_attach_stv0900(input, 0) < 0)
 			return -ENODEV;
 		if (tuner_attach_stv6110(input, 0) < 0)
 			return -ENODEV;
-		if (input->fe) {
-			if (dvb_register_frontend(adap, input->fe) < 0)
-				return -ENODEV;
-		}
 		break;
 	case DDB_TUNER_DVBS_ST_AA:
 		if (demod_attach_stv0900(input, 1) < 0)
 			return -ENODEV;
 		if (tuner_attach_stv6110(input, 1) < 0)
 			return -ENODEV;
-		if (input->fe) {
-			if (dvb_register_frontend(adap, input->fe) < 0)
-				return -ENODEV;
-		}
 		break;
+#ifdef CONFIG_DVB_DRXK
 	case DDB_TUNER_DVBCT_TR:
 		if (demod_attach_drxk(input) < 0)
 			return -ENODEV;
 		if (tuner_attach_tda18271(input) < 0)
 			return -ENODEV;
-		if (input->fe) {
-			if (dvb_register_frontend(adap, input->fe) < 0)
-				return -ENODEV;
-		}
-		if (input->fe2) {
-			if (dvb_register_frontend(adap, input->fe2) < 0)
-				return -ENODEV;
-			input->fe2->tuner_priv = input->fe->tuner_priv;
-			memcpy(&input->fe2->ops.tuner_ops,
-			       &input->fe->ops.tuner_ops,
-			       sizeof(struct dvb_tuner_ops));
-		}
 		break;
+#endif
+	case DDB_TUNER_DVBCT_ST:
+		if (demod_attach_stv0367dd(input) < 0)
+			return -ENODEV;
+		if (tuner_attach_tda18212dd(input) < 0)
+			return -ENODEV;
+		break;
+	case DDB_TUNER_DVBCT2_SONY:
+	case DDB_TUNER_DVBC2T2_SONY:
+	case DDB_TUNER_ISDBT_SONY:
+		if (demod_attach_cxd2843(input) < 0)
+			return -ENODEV;
+		if (tuner_attach_tda18212dd(input) < 0)
+			return -ENODEV;
+		break;
+	default:
+		return 0;
+	}
+	dvb->attached = 0x30;
+	if (dvb->fe) {
+		if (dvb_register_frontend(adap, dvb->fe) < 0)
+			return -ENODEV;
+	}
+	if (dvb->fe2) {
+		if (dvb_register_frontend(adap, dvb->fe2) < 0)
+			return -ENODEV;
+		dvb->fe2->tuner_priv = dvb->fe->tuner_priv;
+		memcpy(&dvb->fe2->ops.tuner_ops,
+		       &dvb->fe->ops.tuner_ops,
+		       sizeof(struct dvb_tuner_ops));
 	}
-	input->attached = 5;
+	dvb->attached = 0x31;
 	return 0;
 }
 
-/****************************************************************************/
-/****************************************************************************/
-
-static ssize_t ts_write(struct file *file, const char *buf,
-			size_t count, loff_t *ppos)
+static int port_has_encti(struct ddb_port *port)
 {
-	struct dvb_device *dvbdev = file->private_data;
-	struct ddb_output *output = dvbdev->priv;
-	size_t left = count;
-	int stat;
+	u8 val;
+	int ret = ddb_i2c_read_reg(&port->i2c->adap, 0x20, 0, &val);
 
-	while (left) {
-		if (ddb_output_free(output) < 188) {
-			if (file->f_flags & O_NONBLOCK)
-				break;
-			if (wait_event_interruptible(
-				    output->wq, ddb_output_free(output) >= 188) < 0)
-				break;
-		}
-		stat = ddb_output_write(output, buf, left);
-		if (stat < 0)
-			break;
-		buf += stat;
-		left -= stat;
-	}
-	return (left == count) ? -EAGAIN : (count - left);
+	if (!ret) 
+		printk("[0x20]=0x%02x\n", val);
+
+	return ret ? 0 : 1;
 }
 
-static ssize_t ts_read(struct file *file, char *buf,
-		       size_t count, loff_t *ppos)
+static int port_has_cxd(struct ddb_port *port)
 {
-	struct dvb_device *dvbdev = file->private_data;
-	struct ddb_output *output = dvbdev->priv;
-	struct ddb_input *input = output->port->input[0];
-	int left, read;
+	u8 val;
+	u8 probe[4] = { 0xe0, 0x00, 0x00, 0x00 }, data[4]; 
+	struct i2c_msg msgs[2] = {{ .addr = 0x40,  .flags = 0,
+				    .buf  = probe, .len   = 4 },
+				  { .addr = 0x40,  .flags = I2C_M_RD,
+				    .buf  = data,  .len   = 4 }};
+	val = i2c_transfer(&port->i2c->adap, msgs, 2);
+	if (val != 2)
+		return 0;
 
-	count -= count % 188;
-	left = count;
-	while (left) {
-		if (ddb_input_avail(input) < 188) {
-			if (file->f_flags & O_NONBLOCK)
-				break;
-			if (wait_event_interruptible(
-				    input->wq, ddb_input_avail(input) >= 188) < 0)
-				break;
-		}
-		read = ddb_input_read(input, buf, left);
-		if (read < 0)
-			return read;
-		left -= read;
-		buf += read;
-	}
-	return (left == count) ? -EAGAIN : (count - left);
+	if (data[0] == 0x02 && data[1] == 0x2b && data[3] == 0x43)
+		return 2;
+	return 1;
 }
 
-static unsigned int ts_poll(struct file *file, poll_table *wait)
+static int port_has_mach(struct ddb_port *port, u8 *id)
 {
-	/*
-	struct dvb_device *dvbdev = file->private_data;
-	struct ddb_output *output = dvbdev->priv;
-	struct ddb_input *input = output->port->input[0];
-	*/
-	unsigned int mask = 0;
+	u8 val;
+	u8 probe[1] = { 0x00 }, data[4]; 
+	struct i2c_msg msgs[2] = {{ .addr = 0x10,  .flags = 0,
+				    .buf  = probe, .len   = 1 },
+				  { .addr = 0x10,  .flags = I2C_M_RD,
+				    .buf  = data,  .len   = 4 }};
+	val = i2c_transfer(&port->i2c->adap, msgs, 2);
+	if (val != 2)
+		return 0;
+	
+	if (data[0] != 'D' || data[1] != 'F')
+		return 0;
 
-#if 0
-	if (data_avail_to_read)
-		mask |= POLLIN | POLLRDNORM;
-	if (data_avail_to_write)
-		mask |= POLLOUT | POLLWRNORM;
+	*id = data[2];
+	return 1;
+}
 
-	poll_wait(file, &read_queue, wait);
-	poll_wait(file, &write_queue, wait);
-#endif
-	return mask;
+static int port_has_stv0900(struct ddb_port *port)
+{
+	u8 val;
+	if (ddb_i2c_read_reg16(&port->i2c->adap, 0x69, 0xf100, &val) < 0)
+		return 0;
+	return 1;
 }
 
-static const struct file_operations ci_fops = {
-	.owner   = THIS_MODULE,
-	.read    = ts_read,
-	.write   = ts_write,
-	.open    = dvb_generic_open,
-	.release = dvb_generic_release,
-	.poll    = ts_poll,
-	.mmap    = 0,
-};
+static int port_has_stv0900_aa(struct ddb_port *port)
+{
+	u8 val;
+	if (ddb_i2c_read_reg16(&port->i2c->adap, 0x68, 0xf100, &val) < 0)
+		return 0;
+	return 1;
+}
 
-static struct dvb_device dvbdev_ci = {
-	.priv    = 0,
-	.readers = -1,
-	.writers = -1,
-	.users   = -1,
-	.fops    = &ci_fops,
-};
+static int port_has_drxks(struct ddb_port *port)
+{
+	u8 val;
+	if (ddb_i2c_read(&port->i2c->adap, 0x29, &val) < 0)
+		return 0;
+	if (ddb_i2c_read(&port->i2c->adap, 0x2a, &val) < 0)
+		return 0;
+	return 1;
+}
 
-/****************************************************************************/
-/****************************************************************************/
-/****************************************************************************/
+static int port_has_stv0367(struct ddb_port *port)
+{
+	u8 val;
+
+	if (ddb_i2c_read_reg16(&port->i2c->adap, 0x1e, 0xf000, &val) < 0)
+		return 0;
+	if (val != 0x60)
+		return 0;
+	if (ddb_i2c_read_reg16(&port->i2c->adap, 0x1f, 0xf000, &val) < 0)
+		return 0;
+	if (val != 0x60)
+		return 0;
+	return 1;
+}
 
-static void input_tasklet(unsigned long data)
+static int init_xo2(struct ddb_port *port)
 {
-	struct ddb_input *input = (struct ddb_input *) data;
-	struct ddb *dev = input->port->dev;
+	struct i2c_adapter *i2c =&port->i2c->adap;
+	u8 val, data[2];
+	int res;
+	
+	res = ddb_i2c_read_regs(i2c, 0x10, 0x04, data, 2);
+	if (res < 0)
+		return res;
 
-	spin_lock(&input->lock);
-	if (!input->running) {
-		spin_unlock(&input->lock);
-		return;
+	if (data[0] != 0x01)  {
+		printk(KERN_INFO "Port %d: invalid XO2\n", port->nr);
+		return -1;
 	}
-	input->stat = ddbreadl(DMA_BUFFER_CURRENT(input->nr));
 
-	if (input->port->class == DDB_PORT_TUNER) {
-		if (4&ddbreadl(DMA_BUFFER_CONTROL(input->nr)))
-			printk(KERN_ERR "Overflow input %d\n", input->nr);
-		while (input->cbuf != ((input->stat >> 11) & 0x1f)
-		       || (4&ddbreadl(DMA_BUFFER_CONTROL(input->nr)))) {
-			dvb_dmx_swfilter_packets(&input->demux,
-						 input->vbuf[input->cbuf],
-						 input->dma_buf_size / 188);
-
-			input->cbuf = (input->cbuf + 1) % input->dma_buf_num;
-			ddbwritel((input->cbuf << 11),
-				  DMA_BUFFER_ACK(input->nr));
-			input->stat = ddbreadl(DMA_BUFFER_CURRENT(input->nr));
-		       }
+	ddb_i2c_read_reg(i2c, 0x10, 0x08, &val);
+	if (val != 0) {
+		ddb_i2c_write_reg(i2c, 0x10, 0x08, 0x00); 
+		msleep(100);
 	}
-	if (input->port->class == DDB_PORT_CI)
-		wake_up(&input->wq);
-	spin_unlock(&input->lock);
+        /* Enable tuner power, disable pll, reset demods */
+	ddb_i2c_write_reg(i2c, 0x10, 0x08, 0x04); 
+	msleep(2);
+        /* Release demod resets */
+	ddb_i2c_write_reg(i2c, 0x10, 0x08, 0x07); 
+	msleep(2);
+
+        /* Start XO2 PLL */
+	ddb_i2c_write_reg(i2c, 0x10, 0x08, 0x87); 
+
+	return 0;
 }
 
-static void output_tasklet(unsigned long data)
+static void ddb_port_probe(struct ddb_port *port)
 {
-	struct ddb_output *output = (struct ddb_output *) data;
-	struct ddb *dev = output->port->dev;
+	struct ddb *dev = port->dev;
+	char *modname = "NO MODULE";
+	int val;
+	u8 id;
+
+	port->class = DDB_PORT_NONE;
 
-	spin_lock(&output->lock);
-	if (!output->running) {
-		spin_unlock(&output->lock);
+	if (dev->info->type == DDB_MOD) {
+		modname = "MOD";
+		port->class = DDB_PORT_MOD;
+		printk(KERN_INFO "Port %d: MOD\n", port->nr);
 		return;
 	}
-	output->stat = ddbreadl(DMA_BUFFER_CURRENT(output->nr + 8));
-	wake_up(&output->wq);
-	spin_unlock(&output->lock);
-}
 
+	if (port->nr > 1 && dev->info->type == DDB_OCTOPUS_CI) {
+		modname = "CI internal";
+		port->class = DDB_PORT_CI;
+		port->type = DDB_CI_INTERNAL;
+	} else if ((val = port_has_cxd(port)) > 0) {
+		if (val == 1) {
+			modname = "CI";
+			port->class = DDB_PORT_CI;
+			port->type = DDB_CI_EXTERNAL_SONY;
+			ddbwritel(dev, I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
+		} else {
+			printk(KERN_INFO "Port %d: Uninitialized DuoFlex\n", port->nr);
+			return;
+		}
+	} else if (port_has_mach(port, &id)) {
+		char *xo2names[] = { "DUAL DVB-S2", "DUAL DVB-C/T/T2", "DUAL DVB-ISDBT",
+		                     "DUAL DVB-C/C2/T/T2", "DUAL ATSC", "DUAL DVB-C/C2/T/T2" };
+
+		ddbwritel(dev, I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
+		id >>= 2;
+		if (id > 5) {
+			modname = "unknown XO2 DuoFlex";
+		} else {
+			port->class = DDB_PORT_TUNER;
+			port->type = DDB_TUNER_XO2 + id;
+			modname = xo2names[id];
+			init_xo2(port);
+		}
+	} else if (port_has_stv0900(port)) {
+		modname = "DUAL DVB-S2";
+		port->class = DDB_PORT_TUNER;
+		port->type = DDB_TUNER_DVBS_ST;
+		ddbwritel(dev, I2C_SPEED_100, port->i2c->regs + I2C_TIMING);
+	} else if (port_has_stv0900_aa(port)) {
+		modname = "DUAL DVB-S2";
+		port->class = DDB_PORT_TUNER;
+		port->type = DDB_TUNER_DVBS_ST_AA;
+		ddbwritel(dev, I2C_SPEED_100, port->i2c->regs + I2C_TIMING);
+	} else if (port_has_drxks(port)) {
+		modname = "DUAL DVB-C/T";
+		port->class = DDB_PORT_TUNER;
+		port->type = DDB_TUNER_DVBCT_TR;
+		ddbwritel(dev, I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
+	} else if (port_has_stv0367(port)) {
+		modname = "DUAL DVB-C/T";
+		port->class = DDB_PORT_TUNER;
+		port->type = DDB_TUNER_DVBCT_ST;
+		ddbwritel(dev, I2C_SPEED_100, port->i2c->regs + I2C_TIMING);
+	} else if (port_has_encti(port)) {
+		modname = "ENCTI";
+		port->class = DDB_PORT_LOOP;
+	} else if (port->nr == ts_loop) {
+		modname = "TS LOOP";
+		port->class = DDB_PORT_LOOP;
+	}
+	printk(KERN_INFO "Port %d (TAB %d): %s\n", port->nr, port->nr + 1, modname);
+}
 
-struct cxd2099_cfg cxd_cfg = {
-	.bitrate =  62000,
-	.adr     =  0x40,
-	.polarity = 1,
-	.clock_mode = 1,
-};
+static int wait_ci_ready(struct ddb_ci *ci)
+{
+	u32 count = 10;
+	
+	ndelay(500);
+	do {
+		if (ddbreadl(ci->port->dev, 
+			     CI_CONTROL(ci->nr)) & CI_READY)
+			break;
+		usleep_range(1, 2);
+		if ((--count) == 0)
+			return -1;
+	} while (1);
+	return 0;
+}
 
-static int ddb_ci_attach(struct ddb_port *port)
+static int read_attribute_mem(struct dvb_ca_en50221 *ca,
+			      int slot, int address)
 {
-	int ret;
+	struct ddb_ci *ci = ca->data;
+	u32 val, off = (address >> 1) & (CI_BUFFER_SIZE-1);
 
-	ret = dvb_register_adapter(&port->output->adap,
-				   "DDBridge",
-				   THIS_MODULE,
-				   &port->dev->pdev->dev,
-				   adapter_nr);
-	if (ret < 0)
-		return ret;
-	port->en = cxd2099_attach(&cxd_cfg, port, &port->i2c->adap);
-	if (!port->en) {
-		dvb_unregister_adapter(&port->output->adap);
-		return -ENODEV;
+	if (address > CI_BUFFER_SIZE)
+		return -1;
+	ddbwritel(ci->port->dev, CI_READ_CMD | (1 << 16) | address,
+		  CI_DO_READ_ATTRIBUTES(ci->nr));
+	wait_ci_ready(ci);
+	val = 0xff & ddbreadl(ci->port->dev, CI_BUFFER(ci->nr) + off);
+	return val;
+}
+
+static int write_attribute_mem(struct dvb_ca_en50221 *ca, int slot,
+			       int address, u8 value)
+{
+	struct ddb_ci *ci = ca->data;
+
+	ddbwritel(ci->port->dev, CI_WRITE_CMD | (value << 16) | address,
+		  CI_DO_ATTRIBUTE_RW(ci->nr));
+	wait_ci_ready(ci);
+	return 0;
+}
+
+static int read_cam_control(struct dvb_ca_en50221 *ca,
+			    int slot, u8 address)
+{
+	u32 count = 100;
+	struct ddb_ci *ci = ca->data;
+	u32 res;
+
+	ddbwritel(ci->port->dev, CI_READ_CMD | address,
+		  CI_DO_IO_RW(ci->nr));
+	ndelay(500);
+	do {
+		res = ddbreadl(ci->port->dev, CI_READDATA(ci->nr));
+		if (res & CI_READY)
+			break;
+		usleep_range(1, 2);
+		if ((--count) == 0)
+			return -1;
+	} while (1);
+	return (0xff & res);
+}
+
+static int write_cam_control(struct dvb_ca_en50221 *ca, int slot,
+			     u8 address, u8 value)
+{
+	struct ddb_ci *ci = ca->data;
+
+	ddbwritel(ci->port->dev, CI_WRITE_CMD | (value << 16) | address,
+		  CI_DO_IO_RW(ci->nr));
+	wait_ci_ready(ci);
+	return 0;
+}
+
+static int slot_reset(struct dvb_ca_en50221 *ca, int slot)
+{
+	struct ddb_ci *ci = ca->data;
+
+	ddbwritel(ci->port->dev, CI_POWER_ON,
+		  CI_CONTROL(ci->nr));
+	msleep(100);
+	ddbwritel(ci->port->dev, CI_POWER_ON | CI_RESET_CAM,
+		  CI_CONTROL(ci->nr));
+	ddbwritel(ci->port->dev, CI_ENABLE | CI_POWER_ON | CI_RESET_CAM,
+		  CI_CONTROL(ci->nr));
+	udelay(20);
+	ddbwritel(ci->port->dev, CI_ENABLE | CI_POWER_ON,
+		  CI_CONTROL(ci->nr));
+	return 0;
+}
+
+static int slot_shutdown(struct dvb_ca_en50221 *ca, int slot)
+{
+	struct ddb_ci *ci = ca->data;
+
+	ddbwritel(ci->port->dev, 0, CI_CONTROL(ci->nr));
+	msleep(300);
+	return 0;
+}
+
+static int slot_ts_enable(struct dvb_ca_en50221 *ca, int slot)
+{
+	struct ddb_ci *ci = ca->data;
+	u32 val = ddbreadl(ci->port->dev, CI_CONTROL(ci->nr));
+
+	ddbwritel(ci->port->dev, val | CI_BYPASS_DISABLE,
+		  CI_CONTROL(ci->nr));
+	return 0;
+}
+
+static int poll_slot_status(struct dvb_ca_en50221 *ca, int slot, int open)
+{
+	struct ddb_ci *ci = ca->data;
+	u32 val = ddbreadl(ci->port->dev, CI_CONTROL(ci->nr));
+	int stat = 0;
+	
+	if (val & CI_CAM_DETECT)
+		stat |= DVB_CA_EN50221_POLL_CAM_PRESENT;
+	if (val & CI_CAM_READY)
+		stat |= DVB_CA_EN50221_POLL_CAM_READY;
+	return stat;
+}
+
+static struct dvb_ca_en50221 en_templ = {
+	.read_attribute_mem  = read_attribute_mem,
+	.write_attribute_mem = write_attribute_mem,
+	.read_cam_control    = read_cam_control,
+	.write_cam_control   = write_cam_control,
+	.slot_reset          = slot_reset,
+	.slot_shutdown       = slot_shutdown,
+	.slot_ts_enable      = slot_ts_enable,
+	.poll_slot_status    = poll_slot_status,
+};
+
+static void ci_attach(struct ddb_port *port)
+{
+	struct ddb_ci *ci = 0;
+
+	ci = kzalloc(sizeof(*ci), GFP_KERNEL);
+	if (!ci)
+		return;
+	memcpy(&ci->en, &en_templ, sizeof(en_templ));
+	ci->en.data = ci;
+	port->en = &ci->en;
+	ci->port = port;
+	ci->nr = port->nr - 2;
+}
+
+struct cxd2099_cfg cxd_cfg = {
+	.bitrate =  72000,
+	.adr     =  0x40,
+	.polarity = 1,
+	.clock_mode = 1, // 2,
+};
+
+static int ddb_ci_attach(struct ddb_port *port)
+{
+	if (port->type == DDB_CI_EXTERNAL_SONY) {
+		cxd_cfg.bitrate = ci_bitrate;
+		port->en = cxd2099_attach(&cxd_cfg, port, &port->i2c->adap);
+		if (!port->en) 
+			return -ENODEV;
+		dvb_ca_en50221_init(port->dvb[0].adap,
+				    port->en, 0, 1);
 	}
-	ddb_input_start(port->input[0]);
-	ddb_output_start(port->output);
-	dvb_ca_en50221_init(&port->output->adap,
-			    port->en, 0, 1);
-	ret = dvb_register_device(&port->output->adap, &port->output->dev,
-				  &dvbdev_ci, (void *) port->output,
-				  DVB_DEVICE_SEC);
-	return ret;
+	if (port->type == DDB_CI_INTERNAL) {
+		ci_attach(port);
+		if (!port->en) 
+			return -ENODEV;
+		dvb_ca_en50221_init(port->dvb[0].adap, port->en, 0, 1);
+	}
+	return 0;
 }
 
 static int ddb_port_attach(struct ddb_port *port)
@@ -1083,9 +1629,26 @@ static int ddb_port_attach(struct ddb_port *port)
 		if (ret < 0)
 			break;
 		ret = dvb_input_attach(port->input[1]);
+		if (ret < 0)
+			break;
+		port->input[0]->redi = port->input[0];
+		port->input[1]->redi = port->input[1];
 		break;
 	case DDB_PORT_CI:
 		ret = ddb_ci_attach(port);
+		if (ret < 0)
+			break;
+	case DDB_PORT_LOOP:
+		ret = dvb_register_device(port->dvb[0].adap,
+					  &port->dvb[0].dev,
+					  &dvbdev_ci, (void *) port->output,
+					  DVB_DEVICE_CI);
+		break;
+	case DDB_PORT_MOD:
+		ret = dvb_register_device(port->dvb[0].adap,
+					  &port->dvb[0].dev,
+					  &dvbdev_mod, (void *) port->output,
+					  DVB_DEVICE_MOD);
 		break;
 	default:
 		break;
@@ -1100,6 +1663,11 @@ static int ddb_ports_attach(struct ddb *dev)
 	int i, ret = 0;
 	struct ddb_port *port;
 
+	if (dev->info->port_num) {
+		ret = dvb_register_adapters(dev);
+		if (ret < 0)
+			return ret;
+	}
 	for (i = 0; i < dev->info->port_num; i++) {
 		port = &dev->port[i];
 		ret = ddb_port_attach(port);
@@ -1116,125 +1684,210 @@ static void ddb_ports_detach(struct ddb *dev)
 
 	for (i = 0; i < dev->info->port_num; i++) {
 		port = &dev->port[i];
+	
 		switch (port->class) {
 		case DDB_PORT_TUNER:
 			dvb_input_detach(port->input[0]);
 			dvb_input_detach(port->input[1]);
 			break;
 		case DDB_PORT_CI:
-			if (port->output->dev)
-				dvb_unregister_device(port->output->dev);
+		case DDB_PORT_LOOP:
+			if (port->dvb[0].dev)
+				dvb_unregister_device(port->dvb[0].dev);
 			if (port->en) {
-				ddb_input_stop(port->input[0]);
-				ddb_output_stop(port->output);
 				dvb_ca_en50221_release(port->en);
 				kfree(port->en);
 				port->en = 0;
-				dvb_unregister_adapter(&port->output->adap);
 			}
 			break;
+		case DDB_PORT_MOD:
+			if (port->dvb[0].dev)
+				dvb_unregister_device(port->dvb[0].dev);
+			break;
 		}
 	}
+	dvb_unregister_adapters(dev);
 }
 
-/****************************************************************************/
-/****************************************************************************/
+/* Copy input DMA pointers to output DMA and ACK. */
+static void input_write_output(struct ddb_input *input,
+			       struct ddb_output *output)
+{
+	ddbwritel(output->port->dev,
+		  input->dma->stat, DMA_BUFFER_ACK(output->dma->nr));
+	output->dma->cbuf = (input->dma->stat >> 11) & 0x1f;
+	output->dma->coff = (input->dma->stat & 0x7ff) << 7;
+}
 
-static int port_has_ci(struct ddb_port *port)
+static void output_ack_input(struct ddb_output *output,
+			     struct ddb_input *input)
 {
-	u8 val;
-	return i2c_read_reg(&port->i2c->adap, 0x40, 0, &val) ? 0 : 1;
+	ddbwritel(input->port->dev,
+		  output->dma->stat, DMA_BUFFER_ACK(input->dma->nr));
 }
 
-static int port_has_stv0900(struct ddb_port *port)
+static void input_write_dvb(struct ddb_input *input, 
+			    struct ddb_input *input2)
 {
-	u8 val;
-	if (i2c_read_reg16(&port->i2c->adap, 0x69, 0xf100, &val) < 0)
-		return 0;
-	return 1;
+	struct ddb_dvb *dvb = &input2->port->dvb[input2->nr & 1];
+	struct ddb_dma *dma, *dma2;
+	struct ddb *dev = input->port->dev;
+	int noack = 0;
+
+	dma = dma2 = input->dma;
+	/* if there also is an output connected, do not ACK. 
+	   input_write_output will ACK. */
+	if (input->redo) {
+		dma2 = input->redo->dma;
+		noack = 1;
+	}
+	while (dma->cbuf != ((dma->stat >> 11) & 0x1f)
+	       || (4 & dma->ctrl)) {
+		if (4 & dma->ctrl) {
+			// printk(KERN_ERR "Overflow dma %d\n", dma->nr);
+			if (noack) 
+				noack = 0;
+		}
+		dvb_dmx_swfilter_packets(&dvb->demux,
+					 dma2->vbuf[dma->cbuf],
+					 dma2->size / 188);
+		dma->cbuf = (dma->cbuf + 1) % dma2->num;
+		if (!noack)
+			ddbwritel(dev, (dma->cbuf << 11),  
+				  DMA_BUFFER_ACK(dma->nr));
+		dma->stat = ddbreadl(dev, DMA_BUFFER_CURRENT(dma->nr));
+		dma->ctrl = ddbreadl(dev, DMA_BUFFER_CONTROL(dma->nr));
+	}
 }
 
-static int port_has_stv0900_aa(struct ddb_port *port)
+static void input_work(struct work_struct *work)
 {
-	u8 val;
-	if (i2c_read_reg16(&port->i2c->adap, 0x68, 0xf100, &val) < 0)
-		return 0;
-	return 1;
+	struct ddb_dma *dma = container_of(work, struct ddb_dma, work);
+	struct ddb_input *input = (struct ddb_input *) dma->io;
+	struct ddb *dev = input->port->dev;
+
+	spin_lock(&dma->lock);
+	if (!dma->running) {
+		spin_unlock(&dma->lock);
+		return;
+	}
+	dma->stat = ddbreadl(dev, DMA_BUFFER_CURRENT(dma->nr));
+	dma->ctrl = ddbreadl(dev, DMA_BUFFER_CONTROL(dma->nr));
+
+	if (input->redi)
+		input_write_dvb(input, input->redi);
+	if (input->redo)
+		input_write_output(input, input->redo);	
+	wake_up(&dma->wq);
+	spin_unlock(&dma->lock);
 }
 
-static int port_has_drxks(struct ddb_port *port)
+static void input_handler(unsigned long data)
 {
-	u8 val;
-	if (i2c_read(&port->i2c->adap, 0x29, &val) < 0)
-		return 0;
-	if (i2c_read(&port->i2c->adap, 0x2a, &val) < 0)
-		return 0;
-	return 1;
+	struct ddb_input *input = (struct ddb_input *) data;
+	struct ddb_dma *dma = input->dma;
+
+	/* If there is no input connected, input_tasklet() will
+           just copy pointers and ACK. So, there is no need to go 
+	   through the tasklet scheduler. */
+	if (input->redi)
+		queue_work(ddb_wq, &dma->work);
+	else
+		input_work(&dma->work);
 }
 
-static void ddb_port_probe(struct ddb_port *port)
+/* TODO: hmm, don't really need this anymore. 
+   The output IRQ just copies some pointers, acks and wakes. */
+static void output_work(struct work_struct *work)
 {
-	struct ddb *dev = port->dev;
-	char *modname = "NO MODULE";
+}
 
-	port->class = DDB_PORT_NONE;
+static void output_handler(unsigned long data)
+{
+	struct ddb_output *output = (struct ddb_output *) data;
+	struct ddb_dma *dma = output->dma;
+	struct ddb *dev = output->port->dev;
 
-	if (port_has_ci(port)) {
-		modname = "CI";
-		port->class = DDB_PORT_CI;
-		ddbwritel(I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
-	} else if (port_has_stv0900(port)) {
-		modname = "DUAL DVB-S2";
-		port->class = DDB_PORT_TUNER;
-		port->type = DDB_TUNER_DVBS_ST;
-		ddbwritel(I2C_SPEED_100, port->i2c->regs + I2C_TIMING);
-	} else if (port_has_stv0900_aa(port)) {
-		modname = "DUAL DVB-S2";
-		port->class = DDB_PORT_TUNER;
-		port->type = DDB_TUNER_DVBS_ST_AA;
-		ddbwritel(I2C_SPEED_100, port->i2c->regs + I2C_TIMING);
-	} else if (port_has_drxks(port)) {
-		modname = "DUAL DVB-C/T";
-		port->class = DDB_PORT_TUNER;
-		port->type = DDB_TUNER_DVBCT_TR;
-		ddbwritel(I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
+	spin_lock(&dma->lock);
+	if (!dma->running) {
+		spin_unlock(&dma->lock);
+		return;
+	}
+	dma->stat = ddbreadl(dev, DMA_BUFFER_CURRENT(dma->nr));
+	dma->ctrl = ddbreadl(dev, DMA_BUFFER_CONTROL(dma->nr));
+	if (output->redi) 
+		output_ack_input(output, output->redi);
+	wake_up(&dma->wq);
+	spin_unlock(&dma->lock);
+}
+
+static void ddb_dma_init(struct ddb_dma *dma, int nr, void *io, int out)
+{
+	dma->io = io;
+	dma->nr = nr;
+	spin_lock_init(&dma->lock);
+	init_waitqueue_head(&dma->wq);
+	if (out) {
+		INIT_WORK(&dma->work, output_work);
+		dma->num = OUTPUT_DMA_BUFS;
+		dma->size = OUTPUT_DMA_SIZE;
+		dma->div = OUTPUT_DMA_IRQ_DIV;
+	} else {
+		INIT_WORK(&dma->work, input_work);
+		dma->num = INPUT_DMA_BUFS;
+		dma->size = INPUT_DMA_SIZE;
+		dma->div = INPUT_DMA_IRQ_DIV;
 	}
-	printk(KERN_INFO "Port %d (TAB %d): %s\n",
-			 port->nr, port->nr+1, modname);
 }
 
-static void ddb_input_init(struct ddb_port *port, int nr)
+static void ddb_input_init(struct ddb_port *port, int nr, int pnr, int dma_nr)
 {
 	struct ddb *dev = port->dev;
 	struct ddb_input *input = &dev->input[nr];
 
+	if (dev->has_dma) {
+		dev->handler[dma_nr + 8] = input_handler;
+		dev->handler_data[dma_nr + 8] = (unsigned long) input;
+	}
+	port->input[pnr] = input;
 	input->nr = nr;
 	input->port = port;
-	input->dma_buf_num = INPUT_DMA_BUFS;
-	input->dma_buf_size = INPUT_DMA_SIZE;
-	ddbwritel(0, TS_INPUT_CONTROL(nr));
-	ddbwritel(2, TS_INPUT_CONTROL(nr));
-	ddbwritel(0, TS_INPUT_CONTROL(nr));
-	ddbwritel(0, DMA_BUFFER_ACK(nr));
-	tasklet_init(&input->tasklet, input_tasklet, (unsigned long) input);
-	spin_lock_init(&input->lock);
-	init_waitqueue_head(&input->wq);
+	if (dev->has_dma) {
+		input->dma = &dev->dma[dma_nr];
+		ddb_dma_init(input->dma, dma_nr, (void *) input, 0);
+	}
+	ddbwritel(dev, 0, TS_INPUT_CONTROL(nr));
+	ddbwritel(dev, 2, TS_INPUT_CONTROL(nr));
+	ddbwritel(dev, 0, TS_INPUT_CONTROL(nr));
+	if (dev->has_dma) 
+		ddbwritel(dev, 0, DMA_BUFFER_ACK(input->dma->nr));
 }
 
-static void ddb_output_init(struct ddb_port *port, int nr)
+static void ddb_output_init(struct ddb_port *port, int nr, int dma_nr)
 {
 	struct ddb *dev = port->dev;
 	struct ddb_output *output = &dev->output[nr];
+
+	if (dev->has_dma) {
+		dev->handler[dma_nr + 8] = output_handler;
+		dev->handler_data[dma_nr + 8] = (unsigned long) output;
+	}
+	port->output = output;
 	output->nr = nr;
 	output->port = port;
-	output->dma_buf_num = OUTPUT_DMA_BUFS;
-	output->dma_buf_size = OUTPUT_DMA_SIZE;
-
-	ddbwritel(0, TS_OUTPUT_CONTROL(nr));
-	ddbwritel(2, TS_OUTPUT_CONTROL(nr));
-	ddbwritel(0, TS_OUTPUT_CONTROL(nr));
-	tasklet_init(&output->tasklet, output_tasklet, (unsigned long) output);
-	init_waitqueue_head(&output->wq);
+	if (dev->has_dma) {
+		output->dma = &dev->dma[dma_nr];
+		ddb_dma_init(output->dma, dma_nr, (void *) output, 1);
+	}
+	if (output->port->class == DDB_PORT_MOD) {
+		// ddbwritel(dev, 0, CHANNEL_CONTROL(output->nr));
+	} else {
+		ddbwritel(dev, 0, TS_OUTPUT_CONTROL(nr));
+		ddbwritel(dev, 2, TS_OUTPUT_CONTROL(nr));
+		ddbwritel(dev, 0, TS_OUTPUT_CONTROL(nr));
+	}
+	if (dev->has_dma) 
+		ddbwritel(dev, 0, DMA_BUFFER_ACK(output->dma->nr));
 }
 
 static void ddb_ports_init(struct ddb *dev)
@@ -1247,15 +1900,31 @@ static void ddb_ports_init(struct ddb *dev)
 		port->dev = dev;
 		port->nr = i;
 		port->i2c = &dev->i2c[i];
-		port->input[0] = &dev->input[2 * i];
-		port->input[1] = &dev->input[2 * i + 1];
-		port->output = &dev->output[i];
-
+		port->gap = 4;
+		port->obr = ci_bitrate;
 		mutex_init(&port->i2c_gate_lock);
 		ddb_port_probe(port);
-		ddb_input_init(port, 2 * i);
-		ddb_input_init(port, 2 * i + 1);
-		ddb_output_init(port, i);
+		port->dvb[0].adap = &dev->adap[2 * i];
+		port->dvb[1].adap = &dev->adap[2 * i + 1];
+
+		if ((dev->info->type == DDB_OCTOPUS_CI) || 
+		    (dev->info->type == DDB_OCTONET) ||
+		    (dev->info->type == DDB_OCTOPUS)) {
+			if (i >= 2 && dev->info->type == DDB_OCTOPUS_CI) {
+				ddb_input_init(port, 2 + i, 0, 2 + i);
+				ddb_input_init(port, 4 + i, 1, 4 + i);
+			} else {
+				ddb_input_init(port, 2 * i, 0, 2 * i);
+				ddb_input_init(port, 2 * i + 1, 1, 2 * i + 1);
+			}
+			ddb_output_init(port, i, i + 8);
+		} 
+		if (dev->info->type == DDB_MOD) {
+			ddb_output_init(port, i, i);
+			dev->handler[i + 18] = ddbridge_mod_rate_handler;
+			dev->handler_data[i + 18] = 
+				(unsigned long) &dev->output[i];
+		}
 	}
 }
 
@@ -1266,101 +1935,130 @@ static void ddb_ports_release(struct ddb *dev)
 
 	for (i = 0; i < dev->info->port_num; i++) {
 		port = &dev->port[i];
-		port->dev = dev;
-		tasklet_kill(&port->input[0]->tasklet);
-		tasklet_kill(&port->input[1]->tasklet);
-		tasklet_kill(&port->output->tasklet);
+		if (port->input[0])
+			cancel_work_sync(&port->input[0]->dma->work);
+		if (port->input[1])
+			cancel_work_sync(&port->input[1]->dma->work);
+		if (port->output)
+			cancel_work_sync(&port->output->dma->work);
 	}
 }
 
-/****************************************************************************/
-/****************************************************************************/
-/****************************************************************************/
+#define IRQ_HANDLE(_nr) if ((s & (1UL << _nr)) && dev->handler[_nr]) \
+		dev->handler[_nr](dev->handler_data[_nr]);
+
+static void irq_handle_msg(struct ddb *dev, u32 s)
+{
+	dev->i2c_irq++;
+	IRQ_HANDLE(0);
+	IRQ_HANDLE(1);
+	IRQ_HANDLE(2);
+	IRQ_HANDLE(3);
+}
+
+static void irq_handle_io(struct ddb *dev, u32 s)
+{
+	dev->ts_irq++;
+	IRQ_HANDLE(8);
+	IRQ_HANDLE(9);
+	IRQ_HANDLE(10);
+	IRQ_HANDLE(11);
+	IRQ_HANDLE(12);
+	IRQ_HANDLE(13);
+	IRQ_HANDLE(14);
+	IRQ_HANDLE(15);
+	IRQ_HANDLE(16);
+	IRQ_HANDLE(17);
+	IRQ_HANDLE(18);
+	IRQ_HANDLE(19);
+	if (dev->info->type != DDB_MOD)
+		return;
+	IRQ_HANDLE(20);
+	IRQ_HANDLE(21);
+	IRQ_HANDLE(22);
+	IRQ_HANDLE(23);
+	IRQ_HANDLE(24);
+	IRQ_HANDLE(25);
+	IRQ_HANDLE(26);
+	IRQ_HANDLE(27);
+}
+
+static irqreturn_t irq_handler0(int irq, void *dev_id)
+{
+	struct ddb *dev = (struct ddb *) dev_id;
+	u32 s = ddbreadl(dev, INTERRUPT_STATUS);
+
+	do {
+		if (s & 0x80000000)
+			return IRQ_NONE;
+		if (!(s & 0xfff00))
+			return IRQ_NONE;
+		ddbwritel(dev, s, INTERRUPT_ACK);
+		irq_handle_io(dev, s);
+	} while ((s = ddbreadl(dev, INTERRUPT_STATUS)));
+	
+	return IRQ_HANDLED;
+}
 
-static void irq_handle_i2c(struct ddb *dev, int n)
+static irqreturn_t irq_handler1(int irq, void *dev_id)
 {
-	struct ddb_i2c *i2c = &dev->i2c[n];
+	struct ddb *dev = (struct ddb *) dev_id;
+	u32 s = ddbreadl(dev, INTERRUPT_STATUS);
 
-	i2c->done = 1;
-	wake_up(&i2c->wq);
+	do {
+		if (s & 0x80000000)
+			return IRQ_NONE;
+		if (!(s & 0x0000f))
+			return IRQ_NONE;
+		ddbwritel(dev, s, INTERRUPT_ACK);
+		irq_handle_msg(dev, s);
+	} while ((s = ddbreadl(dev, INTERRUPT_STATUS)));
+	
+	return IRQ_HANDLED;
 }
 
 static irqreturn_t irq_handler(int irq, void *dev_id)
 {
 	struct ddb *dev = (struct ddb *) dev_id;
-	u32 s = ddbreadl(INTERRUPT_STATUS);
+	u32 s = ddbreadl(dev, INTERRUPT_STATUS);
+	int ret = IRQ_HANDLED;
 
 	if (!s)
 		return IRQ_NONE;
-
 	do {
-		ddbwritel(s, INTERRUPT_ACK);
-
-		if (s & 0x00000001)
-			irq_handle_i2c(dev, 0);
-		if (s & 0x00000002)
-			irq_handle_i2c(dev, 1);
-		if (s & 0x00000004)
-			irq_handle_i2c(dev, 2);
-		if (s & 0x00000008)
-			irq_handle_i2c(dev, 3);
-
-		if (s & 0x00000100)
-			tasklet_schedule(&dev->input[0].tasklet);
-		if (s & 0x00000200)
-			tasklet_schedule(&dev->input[1].tasklet);
-		if (s & 0x00000400)
-			tasklet_schedule(&dev->input[2].tasklet);
-		if (s & 0x00000800)
-			tasklet_schedule(&dev->input[3].tasklet);
-		if (s & 0x00001000)
-			tasklet_schedule(&dev->input[4].tasklet);
-		if (s & 0x00002000)
-			tasklet_schedule(&dev->input[5].tasklet);
-		if (s & 0x00004000)
-			tasklet_schedule(&dev->input[6].tasklet);
-		if (s & 0x00008000)
-			tasklet_schedule(&dev->input[7].tasklet);
-
-		if (s & 0x00010000)
-			tasklet_schedule(&dev->output[0].tasklet);
-		if (s & 0x00020000)
-			tasklet_schedule(&dev->output[1].tasklet);
-		if (s & 0x00040000)
-			tasklet_schedule(&dev->output[2].tasklet);
-		if (s & 0x00080000)
-			tasklet_schedule(&dev->output[3].tasklet);
-
-		/* if (s & 0x000f0000)	printk(KERN_DEBUG "%08x\n", istat); */
-	} while ((s = ddbreadl(INTERRUPT_STATUS)));
-
-	return IRQ_HANDLED;
+		if (s & 0x80000000)
+			return IRQ_NONE;
+		ddbwritel(dev, s, INTERRUPT_ACK);
+		
+		if (s & 0x0000000f)
+			irq_handle_msg(dev, s);
+		if (s & 0x0fffff00)
+			irq_handle_io(dev, s);
+	} while ((s = ddbreadl(dev, INTERRUPT_STATUS)));
+	
+	return ret;
 }
 
-/******************************************************************************/
-/******************************************************************************/
-/******************************************************************************/
-
 static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
 {
 	u32 data, shift;
 
 	if (wlen > 4)
-		ddbwritel(1, SPI_CONTROL);
+		ddbwritel(dev, 1, SPI_CONTROL);
 	while (wlen > 4) {
 		/* FIXME: check for big-endian */
 		data = swab32(*(u32 *)wbuf);
 		wbuf += 4;
 		wlen -= 4;
-		ddbwritel(data, SPI_DATA);
-		while (ddbreadl(SPI_CONTROL) & 0x0004)
+		ddbwritel(dev, data, SPI_DATA);
+		while (ddbreadl(dev, SPI_CONTROL) & 0x0004)
 			;
 	}
 
 	if (rlen)
-		ddbwritel(0x0001 | ((wlen << (8 + 3)) & 0x1f00), SPI_CONTROL);
+		ddbwritel(dev, 0x0001 | ((wlen << (8 + 3)) & 0x1f00), SPI_CONTROL);
 	else
-		ddbwritel(0x0003 | ((wlen << (8 + 3)) & 0x1f00), SPI_CONTROL);
+		ddbwritel(dev, 0x0003 | ((wlen << (8 + 3)) & 0x1f00), SPI_CONTROL);
 
 	data = 0;
 	shift = ((4 - wlen) * 8);
@@ -1372,33 +2070,33 @@ static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
 	}
 	if (shift)
 		data <<= shift;
-	ddbwritel(data, SPI_DATA);
-	while (ddbreadl(SPI_CONTROL) & 0x0004)
+	ddbwritel(dev, data, SPI_DATA);
+	while (ddbreadl(dev, SPI_CONTROL) & 0x0004)
 		;
 
 	if (!rlen) {
-		ddbwritel(0, SPI_CONTROL);
+		ddbwritel(dev, 0, SPI_CONTROL);
 		return 0;
 	}
 	if (rlen > 4)
-		ddbwritel(1, SPI_CONTROL);
+		ddbwritel(dev, 1, SPI_CONTROL);
 
 	while (rlen > 4) {
-		ddbwritel(0xffffffff, SPI_DATA);
-		while (ddbreadl(SPI_CONTROL) & 0x0004)
+		ddbwritel(dev, 0xffffffff, SPI_DATA);
+		while (ddbreadl(dev, SPI_CONTROL) & 0x0004)
 			;
-		data = ddbreadl(SPI_DATA);
+		data = ddbreadl(dev, SPI_DATA);
 		*(u32 *) rbuf = swab32(data);
 		rbuf += 4;
 		rlen -= 4;
 	}
-	ddbwritel(0x0003 | ((rlen << (8 + 3)) & 0x1F00), SPI_CONTROL);
-	ddbwritel(0xffffffff, SPI_DATA);
-	while (ddbreadl(SPI_CONTROL) & 0x0004)
+	ddbwritel(dev, 0x0003 | ((rlen << (8 + 3)) & 0x1F00), SPI_CONTROL);
+	ddbwritel(dev, 0xffffffff, SPI_DATA);
+	while (ddbreadl(dev, SPI_CONTROL) & 0x0004)
 		;
 
-	data = ddbreadl(SPI_DATA);
-	ddbwritel(0, SPI_CONTROL);
+	data = ddbreadl(dev, SPI_DATA);
+	ddbwritel(dev, 0, SPI_CONTROL);
 
 	if (rlen < 4)
 		data <<= ((4 - rlen) * 8);
@@ -1412,6 +2110,33 @@ static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
 	return 0;
 }
 
+int ddbridge_flashread(struct ddb *dev, u8 *buf, u32 addr, u32 len)
+{
+	u8 cmd[4] = {0x03, (addr >> 16) & 0xff, 
+		     (addr >> 8) & 0xff, addr & 0xff};
+	
+	return flashio(dev, cmd, 4, buf, len);
+}
+
+static int mdio_write(struct ddb *dev, u8 adr, u8 reg, u16 val)
+{
+	ddbwritel(dev, adr, MDIO_ADR);
+	ddbwritel(dev, reg, MDIO_REG);
+	ddbwritel(dev, val, MDIO_VAL);
+	ddbwritel(dev, 0x03, MDIO_CTRL);
+	while (ddbreadl(dev, MDIO_CTRL) & 0x02);
+	return 0;
+}
+
+static u16 mdio_read(struct ddb *dev, u8 adr, u8 reg)
+{
+	ddbwritel(dev, adr, MDIO_ADR);
+	ddbwritel(dev, reg, MDIO_REG);
+	ddbwritel(dev, 0x07, MDIO_CTRL);
+	while (ddbreadl(dev, MDIO_CTRL) & 0x02);
+	return ddbreadl(dev, MDIO_VAL);
+}
+
 #define DDB_MAGIC 'd'
 
 struct ddb_flashio {
@@ -1421,19 +2146,69 @@ struct ddb_flashio {
 	__u32 read_len;
 };
 
-#define IOCTL_DDB_FLASHIO  _IOWR(DDB_MAGIC, 0x00, struct ddb_flashio)
+struct ddb_gpio {
+	__u32 mask;
+	__u32 data;
+};
+
+struct ddb_id {
+	__u16 vendor;
+	__u16 device;
+	__u16 subvendor;
+	__u16 subdevice;
+	__u32 hw;
+	__u32 regmap;
+};
+
+struct ddb_reg {
+	__u32 reg;
+	__u32 val;
+};
+
+struct ddb_mem {
+	__u32  off;
+	__u8  *buf;
+	__u32  len;
+};
+
+struct ddb_mdio {
+	__u8   adr;
+	__u8   reg;
+	__u16  val;
+};
+
+#define IOCTL_DDB_FLASHIO    _IOWR(DDB_MAGIC, 0x00, struct ddb_flashio)
+#define IOCTL_DDB_GPIO_IN    _IOWR(DDB_MAGIC, 0x01, struct ddb_gpio)
+#define IOCTL_DDB_GPIO_OUT   _IOWR(DDB_MAGIC, 0x02, struct ddb_gpio)
+#define IOCTL_DDB_ID         _IOR(DDB_MAGIC, 0x03, struct ddb_id)
+#define IOCTL_DDB_READ_REG   _IOWR(DDB_MAGIC, 0x04, struct ddb_reg)
+#define IOCTL_DDB_WRITE_REG  _IOW(DDB_MAGIC, 0x05, struct ddb_reg)
+#define IOCTL_DDB_READ_MEM   _IOWR(DDB_MAGIC, 0x06, struct ddb_mem)
+#define IOCTL_DDB_WRITE_MEM  _IOR(DDB_MAGIC, 0x07, struct ddb_mem)
+#define IOCTL_DDB_READ_MDIO  _IOWR(DDB_MAGIC, 0x08, struct ddb_mdio)
+#define IOCTL_DDB_WRITE_MDIO _IOR(DDB_MAGIC, 0x09, struct ddb_mdio)
 
 #define DDB_NAME "ddbridge"
 
 static u32 ddb_num;
-static struct ddb *ddbs[32];
-static struct class *ddb_class;
 static int ddb_major;
+static DEFINE_MUTEX(ddb_mutex);
+
+static int ddb_release(struct inode *inode, struct file *file)
+{
+	struct ddb *dev = file->private_data;
+	
+	dev->ddb_dev_users--;
+	return 0;
+}
 
 static int ddb_open(struct inode *inode, struct file *file)
 {
 	struct ddb *dev = ddbs[iminor(inode)];
 
+	if (dev->ddb_dev_users)
+		return -EBUSY;
+	dev->ddb_dev_users++;
 	file->private_data = dev;
 	return 0;
 }
@@ -1470,6 +2245,103 @@ static long ddb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			return -EFAULT;
 		break;
 	}
+	case IOCTL_DDB_GPIO_OUT:
+	{
+		struct ddb_gpio gpio;
+		if (copy_from_user(&gpio, parg, sizeof(gpio))) 
+			return -EFAULT;
+		ddbwritel(dev, gpio.mask, GPIO_DIRECTION);
+		ddbwritel(dev, gpio.data, GPIO_OUTPUT);
+		break;
+	}
+	case IOCTL_DDB_ID:
+	{
+		struct ddb_id ddbid;
+		
+		ddbid.vendor = dev->id->vendor;
+		ddbid.device = dev->id->device;
+		ddbid.subvendor = dev->id->subvendor;
+		ddbid.subdevice = dev->id->subdevice;
+		ddbid.hw = ddbreadl(dev, 0);
+		ddbid.regmap = ddbreadl(dev, 4);
+		if (copy_to_user(parg, &ddbid, sizeof(ddbid))) 
+			return -EFAULT;
+		break;
+	}
+	case IOCTL_DDB_READ_REG:
+	{
+		struct ddb_reg reg;
+		
+		if (copy_from_user(&reg, parg, sizeof(reg))) 
+			return -EFAULT;
+		if (reg.reg >= dev->regs_len)
+			return -EINVAL;
+		reg.val = ddbreadl(dev, reg.reg);
+		if (copy_to_user(parg, &reg, sizeof(reg))) 
+			return -EFAULT;
+		break;
+	}
+	case IOCTL_DDB_WRITE_REG:
+	{
+		struct ddb_reg reg;
+		
+		if (copy_from_user(&reg, parg, sizeof(reg))) 
+			return -EFAULT;
+		if (reg.reg >= dev->regs_len)
+			return -EINVAL;
+		ddbwritel(dev, reg.val, reg.reg);
+		break;
+	}
+	case IOCTL_DDB_READ_MDIO:
+	{
+		struct ddb_mdio mdio;
+		
+		if (copy_from_user(&mdio, parg, sizeof(mdio))) 
+			return -EFAULT;
+		mdio.val = mdio_read(dev, mdio.adr, mdio.reg);
+		if (copy_to_user(parg, &mdio, sizeof(mdio))) 
+			return -EFAULT;
+		break;
+	}
+	case IOCTL_DDB_WRITE_MDIO:
+	{
+		struct ddb_mdio mdio;
+		
+		if (copy_from_user(&mdio, parg, sizeof(mdio))) 
+			return -EFAULT;
+		mdio_write(dev, mdio.adr, mdio.reg, mdio.val);
+		break;
+	}
+	case IOCTL_DDB_READ_MEM:
+	{
+		struct ddb_mem mem;
+		u8 *buf = &dev->iobuf[0];
+
+		if (copy_from_user(&mem, parg, sizeof(mem)))
+			return -EFAULT;
+		if ((mem.len + mem.off > dev->regs_len) ||
+		    mem.len > 1024)
+			return -EINVAL;
+		ddbcpyfrom(dev, buf, mem.off, mem.len);
+		if (copy_to_user(mem.buf, buf, mem.len))
+			return -EFAULT;
+		break;
+	}
+	case IOCTL_DDB_WRITE_MEM:
+	{
+		struct ddb_mem mem;
+		u8 *buf = &dev->iobuf[0];
+		
+		if (copy_from_user(&mem, parg, sizeof(mem)))
+			return -EFAULT;
+		if ((mem.len + mem.off > dev->regs_len) ||
+		    mem.len > 1024)
+			return -EINVAL;
+		if (copy_from_user(buf, mem.buf, mem.len))
+			return -EFAULT;
+		ddbcpyto(dev, mem.off, buf, mem.len);
+		break;
+	}
 	default:
 		return -ENOTTY;
 	}
@@ -1479,61 +2351,425 @@ static long ddb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 static const struct file_operations ddb_fops = {
 	.unlocked_ioctl = ddb_ioctl,
 	.open           = ddb_open,
+	.release        = ddb_release,
 };
 
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0))
+static char *ddb_devnode(struct device *device, mode_t *mode)
+#else
 static char *ddb_devnode(struct device *device, umode_t *mode)
+#endif
 {
 	struct ddb *dev = dev_get_drvdata(device);
 
 	return kasprintf(GFP_KERNEL, "ddbridge/card%d", dev->nr);
 }
 
+#define __ATTR_MRO(_name, _show) {				\
+	.attr	= { .name = __stringify(_name), .mode = 0444 },	\
+	.show	= _show,					\
+}
+
+#define __ATTR_MWO(_name, _store) {				\
+	.attr	= { .name = __stringify(_name), .mode = 0222 },	\
+	.store	= _store,					\
+}
+
+static ssize_t ports_show(struct device *device, struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+
+	return sprintf(buf, "%d\n", dev->info->port_num);
+}
+
+static ssize_t ts_irq_show(struct device *device, struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+
+	return sprintf(buf, "%d\n", dev->ts_irq);
+}
+
+static ssize_t i2c_irq_show(struct device *device, struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+
+	return sprintf(buf, "%d\n", dev->i2c_irq);
+}
+
+static char *class_name[] = {
+	"NONE", "CI", "TUNER", "LOOP"
+};
+
+static char *type_name[] = {
+	"NONE", "DVBS_ST", "DVBS_ST_AA", "DVBCT_TR", "DVBCT_ST", "INTERNAL", "CXD2099", 
+};
+
+static ssize_t fan_show(struct device *device, struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+	u32 val;
+
+	val = ddbreadl(dev, GPIO_OUTPUT) & 1;
+	return sprintf(buf, "%d\n", val);
+}
+
+static ssize_t fan_store(struct device *device, struct device_attribute *d,
+			 const char *buf, size_t count)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+	unsigned val;
+
+	if (sscanf(buf, "%u\n", &val) != 1)
+		return -EINVAL;
+	ddbwritel(dev, 1, GPIO_DIRECTION);
+	ddbwritel(dev, val & 1, GPIO_OUTPUT);
+	return count;
+}
+
+static ssize_t temp_show(struct device *device, struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+	struct i2c_adapter *adap;
+	int temp, temp2;
+	u8 tmp[2];
+
+	if (dev->info->type == DDB_MOD) {
+		ddbwritel(dev, 1, TEMPMON_CONTROL);
+		msleep(5);
+		temp = ddbreadl(dev, TEMPMON_SENSOR1);
+		temp2 = ddbreadl(dev, TEMPMON_SENSOR2);
+		temp = (temp * 1000) >> 8;
+		temp2 = (temp2 * 1000) >> 8;
+		return sprintf(buf, "%d %d\n", temp, temp2);
+	}
+	if (!dev->info->temp_num)
+		return sprintf(buf, "no sensor\n");
+	adap = &dev->i2c[dev->info->temp_bus].adap;
+	if (ddb_i2c_read_regs(adap, 0x48, 0, tmp, 2) < 0)
+		return sprintf(buf, "read_error\n");
+	temp = (tmp[0] << 3) | (tmp[1] >> 5);
+	temp *= 125;
+	if (dev->info->temp_num == 2) {
+		if (ddb_i2c_read_regs(adap, 0x49, 0, tmp, 2) < 0)
+			return sprintf(buf, "read_error\n");
+		temp2 = (tmp[0] << 3) | (tmp[1] >> 5);
+		temp2 *= 125;
+		return sprintf(buf, "%d %d\n", temp, temp2);
+	}
+	return sprintf(buf, "%d\n", temp);
+}
+
+static ssize_t mod_show(struct device *device, struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+	int num = attr->attr.name[3] - 0x30;
+
+	return sprintf(buf, "%s:%s\n",
+		       class_name[dev->port[num].class],
+		       type_name[dev->port[num].type]);
+}
+
+static ssize_t led_show(struct device *device, struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+	int num = attr->attr.name[3] - 0x30;
+
+	return sprintf(buf, "%d\n", dev->leds & (1 << num) ? 1 : 0);
+}
+
+static void ddb_set_led(struct ddb *dev, int num, int val)
+{
+	if (!dev->info->led_num)
+		return;
+	switch (dev->port[num].class) {
+	case DDB_PORT_TUNER:
+		switch (dev->port[num].type) {
+		case DDB_TUNER_DVBS_ST:
+			ddb_i2c_write_reg16(&dev->i2c[num].adap,
+					0x69, 0xf14c, val ? 2 : 0);
+			break;
+		case DDB_TUNER_DVBCT_ST:
+			ddb_i2c_write_reg16(&dev->i2c[num].adap, 
+					0x1f, 0xf00e, 0);
+			ddb_i2c_write_reg16(&dev->i2c[num].adap, 
+					0x1f, 0xf00f, val ? 1 : 0);
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static ssize_t led_store(struct device *device, struct device_attribute *attr,
+			 const char *buf, size_t count)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+	int num = attr->attr.name[3] - 0x30;
+	unsigned val;
+
+	if (sscanf(buf, "%u\n", &val) != 1)
+		return -EINVAL;
+	if (val)
+		dev->leds |= (1 << num);
+	else
+		dev->leds &= ~(1 << num);
+	ddb_set_led(dev, num, val);
+	return count;
+}
+
+static ssize_t snr_show(struct device *device, struct device_attribute *attr, char *buf) 
+{
+	struct ddb *dev = dev_get_drvdata(device); 
+	char snr[32];
+	int num = attr->attr.name[3] - 0x30;
+	
+	/* serial number at 0x100-0x11f */
+	if (ddb_i2c_read_regs16(&dev->i2c[num].adap, 0x50, 0x100, snr, 32) < 0)
+		if (ddb_i2c_read_regs16(&dev->i2c[num].adap, 0x57, 0x100, snr, 32) < 0)
+			return sprintf(buf, "NO SNR\n");
+	snr[31]=0; /* in case it is not terminated on EEPROM */
+	return sprintf(buf, "%s\n", snr); 
+}
+
+static ssize_t snr_store(struct device *device, struct device_attribute *attr,
+			 const char *buf, size_t count)
+{
+	struct ddb *dev = dev_get_drvdata(device); 
+	int num = attr->attr.name[3] - 0x30;
+	u8 snr[34] = { 0x01, 0x00 };
+	
+	if (count > 31)
+		return -EINVAL;
+	memcpy(snr + 2, buf, count);
+	ddb_i2c_write(&dev->i2c[num].adap, 0x57, snr, 34);
+	ddb_i2c_write(&dev->i2c[num].adap, 0x50, snr, 34);
+	return count;
+}
+
+static ssize_t bsnr_show(struct device *device, struct device_attribute *attr, char *buf) 
+{
+	struct ddb *dev = dev_get_drvdata(device); 
+	char snr[16];
+
+	ddbridge_flashread(dev, snr, 0x10, 15);
+	snr[15]=0; /* in case it is not terminated on EEPROM */
+	return sprintf(buf, "%s\n", snr); 
+}
+
+static ssize_t redirect_show(struct device *device, struct device_attribute *attr, char *buf) 
+{
+	return 0;
+}
+
+static ssize_t redirect_store(struct device *device, struct device_attribute *attr,
+			 const char *buf, size_t count)
+{
+	unsigned int i, p;
+	int res;
+	
+	if (sscanf(buf, "%x %x\n", &i, &p) != 2)
+		return -EINVAL;
+	res = ddb_redirect(i, p);
+	if (res < 0)
+		return res;
+	printk(KERN_INFO "redirect: %02x, %02x\n", i, p);
+	return count;
+}
+
+static ssize_t gap_show(struct device *device, struct device_attribute *attr, char *buf) 
+{
+	struct ddb *dev = dev_get_drvdata(device); 
+	int num = attr->attr.name[3] - 0x30;
+	
+	return sprintf(buf, "%d\n", dev->port[num].gap);
+
+}
+static ssize_t gap_store(struct device *device, struct device_attribute *attr,
+			 const char *buf, size_t count)
+{
+	struct ddb *dev = dev_get_drvdata(device); 
+	int num = attr->attr.name[3] - 0x30;
+	unsigned int val;
+	
+	if (sscanf(buf, "%u\n", &val) != 1)
+		return -EINVAL;
+	if (val > 20)
+		return -EINVAL;
+	dev->port[num].gap = val;
+	return count;
+}
+
+static ssize_t version_show(struct device *device, struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+	
+	return sprintf(buf, "%08x %08x\n", ddbreadl(dev, 0), ddbreadl(dev, 4));
+}
+
+static ssize_t hwid_show(struct device *device,
+			 struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+
+	return sprintf(buf, "0x%08X\n", dev->hwid);
+}
+
+static ssize_t regmap_show(struct device *device, 
+			   struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+	
+	return sprintf(buf, "0x%08X\n", dev->regmapid);
+}
+
+static struct device_attribute ddb_attrs[] = {
+	__ATTR_RO(version),
+	__ATTR_RO(ports),
+	__ATTR_RO(ts_irq),
+	__ATTR_RO(i2c_irq),
+	__ATTR(gap0, 0666, gap_show, gap_store),
+	__ATTR(gap1, 0666, gap_show, gap_store),
+	__ATTR(gap2, 0666, gap_show, gap_store),
+	__ATTR(gap3, 0666, gap_show, gap_store),
+	__ATTR_RO(hwid),
+	__ATTR_RO(regmap),
+	__ATTR(redirect, 0666, redirect_show, redirect_store),
+	__ATTR_MRO(snr,  bsnr_show),
+	__ATTR_NULL,
+};
+
+static struct device_attribute ddb_attrs_temp[] = {
+	__ATTR_RO(temp),
+};
+
+static struct device_attribute ddb_attrs_mod[] = {
+	__ATTR_MRO(mod0, mod_show),
+	__ATTR_MRO(mod1, mod_show),
+	__ATTR_MRO(mod2, mod_show),
+	__ATTR_MRO(mod3, mod_show),
+};
+
+static struct device_attribute ddb_attrs_fan[] = {
+	__ATTR(fan, 0666, fan_show, fan_store),
+};
+
+static struct device_attribute ddb_attrs_snr[] = {
+	__ATTR(snr0, 0666, snr_show, snr_store),
+	__ATTR(snr1, 0666, snr_show, snr_store),
+	__ATTR(snr2, 0666, snr_show, snr_store),
+	__ATTR(snr3, 0666, snr_show, snr_store),
+};
+
+static struct device_attribute ddb_attrs_led[] = {
+	__ATTR(led0, 0666, led_show, led_store),
+	__ATTR(led1, 0666, led_show, led_store),
+	__ATTR(led2, 0666, led_show, led_store),
+	__ATTR(led3, 0666, led_show, led_store),
+};
+
+static struct class ddb_class = {
+	.name		= "ddbridge",
+	.owner          = THIS_MODULE,
+	.dev_attrs	= ddb_attrs,
+	.devnode        = ddb_devnode,
+};
+
 static int ddb_class_create(void)
 {
 	ddb_major = register_chrdev(0, DDB_NAME, &ddb_fops);
 	if (ddb_major < 0)
 		return ddb_major;
-
-	ddb_class = class_create(THIS_MODULE, DDB_NAME);
-	if (IS_ERR(ddb_class)) {
-		unregister_chrdev(ddb_major, DDB_NAME);
-		return PTR_ERR(ddb_class);
-	}
-	ddb_class->devnode = ddb_devnode;
+	if (class_register(&ddb_class) < 0)
+		return -1;
 	return 0;
 }
 
 static void ddb_class_destroy(void)
 {
-	class_destroy(ddb_class);
+	class_unregister(&ddb_class);
 	unregister_chrdev(ddb_major, DDB_NAME);
 }
 
+static void ddb_device_attrs_del(struct ddb *dev)
+{
+	int i;
+
+	for (i = 0; i < dev->info->temp_num; i++)
+		device_remove_file(dev->ddb_dev, &ddb_attrs_temp[0]);
+	for (i = 0; i < dev->info->port_num; i++)
+		device_remove_file(dev->ddb_dev, &ddb_attrs_mod[i]);
+	for (i = 0; i < dev->info->fan_num; i++)
+		device_remove_file(dev->ddb_dev, &ddb_attrs_fan[0]);
+	for (i = 0; i < dev->info->i2c_num; i++) {
+		if (dev->info->led_num)
+			device_remove_file(dev->ddb_dev, &ddb_attrs_led[i]);
+		device_remove_file(dev->ddb_dev, &ddb_attrs_snr[i]);
+	}
+}
+
+static int ddb_device_attrs_add(struct ddb *dev)
+{
+	int i, res = 0;
+	
+	for (i = 0; i < dev->info->temp_num; i++)
+		if ((res = device_create_file(dev->ddb_dev, &ddb_attrs_temp[0])))
+			goto fail;
+	for (i = 0; i < dev->info->port_num; i++)
+		if ((res = device_create_file(dev->ddb_dev, &ddb_attrs_mod[i])))
+			goto fail;
+	for (i = 0; i < dev->info->fan_num; i++)
+		if ((res = device_create_file(dev->ddb_dev, &ddb_attrs_fan[0])))
+			goto fail;
+	for (i = 0; i < dev->info->i2c_num; i++) {
+		if ((res = device_create_file(dev->ddb_dev, &ddb_attrs_snr[i])))
+			goto fail;
+		if (dev->info->led_num)
+			if ((res = device_create_file(dev->ddb_dev, &ddb_attrs_led[i])))
+				goto fail;
+	}
+fail:
+	return res;
+}
+
 static int ddb_device_create(struct ddb *dev)
 {
-	dev->nr = ddb_num++;
-	dev->ddb_dev = device_create(ddb_class, NULL,
+	int res = 0;
+
+	if (ddb_num == DDB_MAX_ADAPTER)
+		return -ENOMEM;
+	mutex_lock(&ddb_mutex);
+	dev->nr = ddb_num;
+	ddbs[dev->nr] = dev;
+	dev->ddb_dev = device_create(&ddb_class, dev->dev,
 				     MKDEV(ddb_major, dev->nr),
 				     dev, "ddbridge%d", dev->nr);
-	ddbs[dev->nr] = dev;
-	if (IS_ERR(dev->ddb_dev))
-		return -1;
-	return 0;
+	if (IS_ERR(dev->ddb_dev)) {
+		res = PTR_ERR(dev->ddb_dev);
+		printk(KERN_INFO "Could not create ddbridge%d\n", dev->nr); 
+		goto fail;
+	}
+	res = ddb_device_attrs_add(dev);
+	if (res) {
+		ddb_device_attrs_del(dev);
+		device_destroy(&ddb_class, MKDEV(ddb_major, dev->nr));
+		ddbs[dev->nr] = 0;
+		dev->ddb_dev = ERR_PTR(-ENODEV);
+	} else
+		ddb_num++;
+fail:
+	mutex_unlock(&ddb_mutex);
+	return res;
 }
 
 static void ddb_device_destroy(struct ddb *dev)
 {
-	ddb_num--;
 	if (IS_ERR(dev->ddb_dev))
 		return;
-	device_destroy(ddb_class, MKDEV(ddb_major, 0));
+	ddb_device_attrs_del(dev);
+	device_destroy(&ddb_class, MKDEV(ddb_major, dev->nr));
 }
 
-
-/****************************************************************************/
-/****************************************************************************/
-/****************************************************************************/
-
 static void ddb_unmap(struct ddb *dev)
 {
 	if (dev->regs)
@@ -1541,20 +2777,20 @@ static void ddb_unmap(struct ddb *dev)
 	vfree(dev);
 }
 
-
-static void ddb_remove(struct pci_dev *pdev)
+static void __devexit ddb_remove(struct pci_dev *pdev)
 {
-	struct ddb *dev = pci_get_drvdata(pdev);
+	struct ddb *dev = (struct ddb *) pci_get_drvdata(pdev);
 
 	ddb_ports_detach(dev);
 	ddb_i2c_release(dev);
 
-	ddbwritel(0, INTERRUPT_ENABLE);
+	ddbwritel(dev, 0, INTERRUPT_ENABLE);
+	ddbwritel(dev, 0, MSI1_ENABLE);
+	if (dev->msi == 2)
+		free_irq(dev->pdev->irq + 1, dev);
 	free_irq(dev->pdev->irq, dev);
-#ifdef CONFIG_PCI_MSI
 	if (dev->msi)
 		pci_disable_msi(dev->pdev);
-#endif
 	ddb_ports_release(dev);
 	ddb_buffers_free(dev);
 	ddb_device_destroy(dev);
@@ -1564,8 +2800,13 @@ static void ddb_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,8,0))
+#define __devinit 
+#define __devinitdata 
+#endif 
 
-static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+static int __devinit ddb_probe(struct pci_dev *pdev,
+			       const struct pci_device_id *id)
 {
 	struct ddb *dev;
 	int stat = 0;
@@ -1574,44 +2815,91 @@ static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (pci_enable_device(pdev) < 0)
 		return -ENODEV;
 
-	dev = vmalloc(sizeof(struct ddb));
+	dev = vzalloc(sizeof(struct ddb));
 	if (dev == NULL)
 		return -ENOMEM;
-	memset(dev, 0, sizeof(struct ddb));
 
+	dev->has_dma = 1;
 	dev->pdev = pdev;
+	dev->dev = &pdev->dev;
 	pci_set_drvdata(pdev, dev);
+	dev->id = id;
 	dev->info = (struct ddb_info *) id->driver_data;
 	printk(KERN_INFO "DDBridge driver detected: %s\n", dev->info->name);
 
+	dev->regs_len = pci_resource_len(dev->pdev, 0);
 	dev->regs = ioremap(pci_resource_start(dev->pdev, 0),
 			    pci_resource_len(dev->pdev, 0));
 	if (!dev->regs) {
+		printk("DDBridge: not enough memory for register map\n");
 		stat = -ENOMEM;
 		goto fail;
 	}
-	printk(KERN_INFO "HW %08x FW %08x\n", ddbreadl(0), ddbreadl(4));
+	if (ddbreadl(dev, 0) == 0xffffffff) {
+		printk("DDBridge: cannot read registers\n");
+		stat = -ENODEV;
+		goto fail;
+	}
 
-#ifdef CONFIG_PCI_MSI
-	if (pci_msi_enabled())
-		stat = pci_enable_msi(dev->pdev);
-	if (stat) {
-		printk(KERN_INFO ": MSI not available.\n");
+	dev->hwid = ddbreadl(dev, 0);
+	dev->regmapid = ddbreadl(dev, 4);
+	
+	printk(KERN_INFO "HW %08x REGMAP %08x\n",
+	       dev->hwid, dev->regmapid);
+	
+	ddbwritel(dev, 0x00000000, INTERRUPT_ENABLE);
+	ddbwritel(dev, 0x00000000, MSI1_ENABLE);
+	ddbwritel(dev, 0x00000000, MSI2_ENABLE);
+	ddbwritel(dev, 0x00000000, MSI3_ENABLE);
+	ddbwritel(dev, 0x00000000, MSI4_ENABLE);
+	ddbwritel(dev, 0x00000000, MSI5_ENABLE);
+	ddbwritel(dev, 0x00000000, MSI6_ENABLE);
+	ddbwritel(dev, 0x00000000, MSI7_ENABLE);
+
+	if (pci_msi_enabled()) {
+		stat = pci_enable_msi_block(dev->pdev, 2);
+		if (stat == 0) {
+			dev->msi = 1;
+			printk("DDBrige using 2 MSI interrupts\n");
+		}
+		if (stat == 1) 
+			stat = pci_enable_msi(dev->pdev);
+		if (stat < 0) {
+			printk(KERN_INFO ": MSI not available.\n");
+		} else {
+			irq_flag = 0;
+			dev->msi++;
+		}
+	}
+	if (dev->msi == 2) {
+		stat = request_irq(dev->pdev->irq, irq_handler0,
+				   irq_flag, "ddbridge", (void *) dev);
+		if (stat < 0)
+			goto fail0;
+		stat = request_irq(dev->pdev->irq + 1, irq_handler1,
+				   irq_flag, "ddbridge", (void *) dev);
+		if (stat < 0) {
+			free_irq(dev->pdev->irq, dev);
+			goto fail0;
+		} 
 	} else {
-		irq_flag = 0;
-		dev->msi = 1;
+		stat = request_irq(dev->pdev->irq, irq_handler, 
+				   irq_flag, "ddbridge", (void *) dev);
+		if (stat < 0)
+			goto fail0;
+	}
+	ddbwritel(dev, 0, DMA_BASE_READ);
+	if (dev->info->type != DDB_MOD)
+		ddbwritel(dev, 0, DMA_BASE_WRITE);
+	
+	// ddbwritel(dev, 0xffffffff, INTERRUPT_ACK);
+	if (dev->msi == 2) {
+		ddbwritel(dev, 0x0fffff00, INTERRUPT_ENABLE);
+		ddbwritel(dev, 0x0000000f, MSI1_ENABLE);
+	} else {
+		ddbwritel(dev, 0x0fffff0f, INTERRUPT_ENABLE);
+		ddbwritel(dev, 0x00000000, MSI1_ENABLE);
 	}
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
 	if (ddb_i2c_init(dev) < 0)
 		goto fail1;
 	ddb_ports_init(dev);
@@ -1621,7 +2909,17 @@ static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 	if (ddb_ports_attach(dev) < 0)
 		goto fail3;
+
+	/* ignore if this fails */
 	ddb_device_create(dev);
+
+	if (dev->info->fan_num)	{
+		ddbwritel(dev, 1, GPIO_DIRECTION);
+		ddbwritel(dev, 1, GPIO_OUTPUT);
+	}
+	if (dev->info->type == DDB_MOD)
+		ddbridge_mod_init(dev);
+
 	return 0;
 
 fail3:
@@ -1631,11 +2929,18 @@ fail3:
 fail2:
 	printk(KERN_ERR "fail2\n");
 	ddb_buffers_free(dev);
+	ddb_i2c_release(dev);
 fail1:
 	printk(KERN_ERR "fail1\n");
+	ddbwritel(dev, 0, INTERRUPT_ENABLE);
+	ddbwritel(dev, 0, MSI1_ENABLE);
+	free_irq(dev->pdev->irq, dev);
+	if (dev->msi == 2) 
+		free_irq(dev->pdev->irq + 1, dev);
+fail0:
+	printk(KERN_ERR "fail0\n");
 	if (dev->msi)
 		pci_disable_msi(dev->pdev);
-	free_irq(dev->pdev->irq, dev);
 fail:
 	printk(KERN_ERR "fail\n");
 	ddb_unmap(dev);
@@ -1644,55 +2949,130 @@ fail:
 	return -1;
 }
 
-/******************************************************************************/
-/******************************************************************************/
-/******************************************************************************/
-
 static struct ddb_info ddb_none = {
 	.type     = DDB_NONE,
-	.name     = "Digital Devices PCIe bridge",
+	.name     = "unknown Digital Devices PCIe card, install newer driver",
 };
 
 static struct ddb_info ddb_octopus = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Octopus DVB adapter",
 	.port_num = 4,
+	.i2c_num  = 4,
+};
+
+static struct ddb_info ddb_octopusv3 = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Octopus V3 DVB adapter",
+	.port_num = 4,
+	.i2c_num  = 4,
 };
 
 static struct ddb_info ddb_octopus_le = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Octopus LE DVB adapter",
 	.port_num = 2,
+	.i2c_num  = 2,
+};
+
+static struct ddb_info ddb_octopus_oem = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Octopus OEM",
+	.port_num = 4,
+	.i2c_num  = 4,
+	.led_num  = 1,
+	.fan_num  = 1,
+	.temp_num = 1,
+	.temp_bus = 0,
+};
+
+static struct ddb_info ddb_octopus_mini = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Octopus Mini",
+	.port_num = 4,
+	.i2c_num  = 4,
 };
 
 static struct ddb_info ddb_v6 = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Cine S2 V6 DVB adapter",
 	.port_num = 3,
+	.i2c_num  = 3,
+};
+
+static struct ddb_info ddb_v6_5 = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Cine S2 V6.5 DVB adapter",
+	.port_num = 4,
+	.i2c_num  = 4,
+};
+
+static struct ddb_info ddb_satixS2v3 = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Mystique SaTiX-S2 V3 DVB adapter",
+	.port_num = 3,
+	.i2c_num  = 3,
+};
+
+static struct ddb_info ddb_ci = {
+	.type     = DDB_OCTOPUS_CI,
+	.name     = "Digital Devices Octopus CI",
+	.port_num = 4,
+	.i2c_num  = 2,
+};
+
+static struct ddb_info ddb_cis = {
+	.type     = DDB_OCTOPUS_CI,
+	.name     = "Digital Devices Octopus CI single",
+	.port_num = 3,
+	.i2c_num  = 2,
+};
+
+static struct ddb_info ddb_dvbct = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices DVBCT V6.1 DVB adapter",
+	.port_num = 3,
+	.i2c_num  = 3,
+};
+
+static struct ddb_info ddb_mod = {
+	.type     = DDB_MOD,
+	.name     = "Digital Devices DVB-C modulator",
+	.port_num = 10,
+	.temp_num = 1,
 };
 
 #define DDVID 0xdd01 /* Digital Devices Vendor ID */
 
-#define DDB_ID(_vend, _dev, _subvend, _subdev, _driverdata) {	\
+#define DDB_ID(_vend, _dev, _subvend, _subdev, _driverdata) { \
 	.vendor      = _vend,    .device    = _dev, \
 	.subvendor   = _subvend, .subdevice = _subdev, \
 	.driver_data = (unsigned long)&_driverdata }
 
-static const struct pci_device_id ddb_id_tbl[] = {
+static const struct pci_device_id ddb_id_tbl[] __devinitdata = {
 	DDB_ID(DDVID, 0x0002, DDVID, 0x0001, ddb_octopus),
 	DDB_ID(DDVID, 0x0003, DDVID, 0x0001, ddb_octopus),
+	DDB_ID(DDVID, 0x0005, DDVID, 0x0004, ddb_octopusv3),
 	DDB_ID(DDVID, 0x0003, DDVID, 0x0002, ddb_octopus_le),
-	DDB_ID(DDVID, 0x0003, DDVID, 0x0010, ddb_octopus),
+	DDB_ID(DDVID, 0x0003, DDVID, 0x0003, ddb_octopus_oem),
+	DDB_ID(DDVID, 0x0003, DDVID, 0x0010, ddb_octopus_mini),
 	DDB_ID(DDVID, 0x0003, DDVID, 0x0020, ddb_v6),
+	DDB_ID(DDVID, 0x0003, DDVID, 0x0021, ddb_v6_5),
+	DDB_ID(DDVID, 0x0003, DDVID, 0x0030, ddb_dvbct),
+	DDB_ID(DDVID, 0x0003, DDVID, 0xdb03, ddb_satixS2v3),
+	DDB_ID(DDVID, 0x0011, DDVID, 0x0040, ddb_ci),
+	DDB_ID(DDVID, 0x0011, DDVID, 0x0041, ddb_cis),
+	DDB_ID(DDVID, 0x0201, DDVID, 0x0001, ddb_mod),
 	/* in case sub-ids got deleted in flash */
 	DDB_ID(DDVID, 0x0003, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	DDB_ID(DDVID, 0x0011, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	DDB_ID(DDVID, 0x0201, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
 	{0}
 };
 MODULE_DEVICE_TABLE(pci, ddb_id_tbl);
 
-
 static struct pci_driver ddb_pci_driver = {
-	.name        = "DDBridge",
+	.name        = "ddbridge",
 	.id_table    = ddb_id_tbl,
 	.probe       = ddb_probe,
 	.remove      = ddb_remove,
@@ -1700,23 +3080,30 @@ static struct pci_driver ddb_pci_driver = {
 
 static __init int module_init_ddbridge(void)
 {
-	int ret;
-
-	printk(KERN_INFO "Digital Devices PCIE bridge driver, "
-	       "Copyright (C) 2010-11 Digital Devices GmbH\n");
+	int stat = -1;
 
-	ret = ddb_class_create();
-	if (ret < 0)
-		return ret;
-	ret = pci_register_driver(&ddb_pci_driver);
-	if (ret < 0)
-		ddb_class_destroy();
-	return ret;
+	printk(KERN_INFO "Digital Devices PCIE bridge driver 0.9.9, "
+	       "Copyright (C) 2010-13 Digital Devices GmbH\n");
+	if (ddb_class_create() < 0)
+		return -1;
+	ddb_wq = create_workqueue("ddbridge");
+	if (ddb_wq == NULL)
+		goto exit1;
+	stat = pci_register_driver(&ddb_pci_driver);
+	if (stat < 0)
+		goto exit2;
+	return stat;
+exit2:
+	destroy_workqueue(ddb_wq);
+exit1:
+	ddb_class_destroy();
+	return stat;
 }
 
 static __exit void module_exit_ddbridge(void)
 {
 	pci_unregister_driver(&ddb_pci_driver);
+	destroy_workqueue(ddb_wq);
 	ddb_class_destroy();
 }
 
@@ -1724,6 +3111,6 @@ module_init(module_init_ddbridge);
 module_exit(module_exit_ddbridge);
 
 MODULE_DESCRIPTION("Digital Devices PCIe Bridge");
-MODULE_AUTHOR("Ralph Metzler");
+MODULE_AUTHOR("Ralph Metzler, Metzler Brothers Systementwicklung");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("0.5");
+MODULE_VERSION("0.9.10");
-- 
1.8.4.2
