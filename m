Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33505 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750885AbdHLL41 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Aug 2017 07:56:27 -0400
Received: by mail-wr0-f196.google.com with SMTP id y43so4103674wrd.0
        for <linux-media@vger.kernel.org>; Sat, 12 Aug 2017 04:56:26 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: r.scobie@clear.net.nz, jasmin@anw.at, d_spingler@freenet.de,
        Manfred.Knick@t-online.de, rjkm@metzlerbros.de
Subject: [PATCH v4 01/11] [media] ddbridge: bump ddbridge code to version 0.9.29
Date: Sat, 12 Aug 2017 13:55:52 +0200
Message-Id: <20170812115602.18124-2-d.scheller.oss@gmail.com>
In-Reply-To: <20170812115602.18124-1-d.scheller.oss@gmail.com>
References: <20170812115602.18124-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This huge patch bumps the ddbridge driver to version 0.9.29. Compared to
the vendor driver package, DD OctoNET including GTL link support, and all
DVB-C Modulator card support has been removed since this requires large
changes to the underlying DVB core API, which should eventually be done
separately, and, after that, the functionality/device support can be added
back rather easy.

While the diff is rather large, the bump is mostly a big refactor of all
data structures. Yet, the MSI support (message signaled interrupts) is
greatly improved, also all currently available CI single/duo bridge cards
are fully supported.

More changes compared to the upstream driver:
 - the DDB_USE_WORKER flag/define was removed, kernel worker functionality
   will be used.
 - coding style is properly fixed (zero complaints from checkpatch)
 - all (not much though) CamelCase has been fixed to kernel_case
 - (private) IOCTLs temporarily removed (which are mainly used to provide
   rarely-used FPGA update functionality)

Great care has been taken to keep all previous changes and fixes (e.g.
kernel logging via dev_*(), pointer annotations and such) intact.

Permission to reuse and mainline the driver code was formally granted by
Ralph Metzler <rjkm@metzlerbros.de>.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <r.scobie@clear.net.nz>
Tested-by: Jasmin Jessich <jasmin@anw.at>
Tested-by: Dietmar Spingler <d_spingler@freenet.de>
Tested-by: Manfred Knick <Manfred.Knick@t-online.de>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 3289 +++++++++++++++++++++-------
 drivers/media/pci/ddbridge/ddbridge-i2c.c  |  217 +-
 drivers/media/pci/ddbridge/ddbridge-i2c.h  |   41 +-
 drivers/media/pci/ddbridge/ddbridge-main.c |  490 +++--
 drivers/media/pci/ddbridge/ddbridge-regs.h |  138 +-
 drivers/media/pci/ddbridge/ddbridge.h      |  364 ++-
 6 files changed, 3376 insertions(+), 1163 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 7e164a370273..6cda798a80a4 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1,7 +1,10 @@
 /*
- * ddbridge.c: Digital Devices PCIe bridge driver
+ * ddbridge-core.c: Digital Devices bridge core functions
+ *
+ * Copyright (C) 2010-2017 Digital Devices GmbH
+ *                         Marcus Metzler <mocm@metzlerbros.de>
+ *                         Ralph Metzler <rjkm@metzlerbros.de>
  *
- * Copyright (C) 2010-2011 Digital Devices GmbH
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -17,8 +20,6 @@
  * http://www.gnu.org/copyleft/gpl.html
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -49,77 +50,290 @@
 #include "stv0910.h"
 #include "stv6111.h"
 #include "lnbh25.h"
+#include "cxd2099.h"
+
+/****************************************************************************/
+
+#define DDB_MAX_ADAPTER 64
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-/******************************************************************************/
-/******************************************************************************/
-/******************************************************************************/
+DEFINE_MUTEX(redirect_lock);
+
+static struct ddb *ddbs[DDB_MAX_ADAPTER];
+
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+
+static struct ddb_regset octopus_input = {
+	.base = 0x200,
+	.num  = 0x08,
+	.size = 0x10,
+};
+
+static struct ddb_regset octopus_output = {
+	.base = 0x280,
+	.num  = 0x08,
+	.size = 0x10,
+};
+
+static struct ddb_regset octopus_idma = {
+	.base = 0x300,
+	.num  = 0x08,
+	.size = 0x10,
+};
+
+static struct ddb_regset octopus_idma_buf = {
+	.base = 0x2000,
+	.num  = 0x08,
+	.size = 0x100,
+};
+
+static struct ddb_regset octopus_odma = {
+	.base = 0x380,
+	.num  = 0x04,
+	.size = 0x10,
+};
+
+static struct ddb_regset octopus_odma_buf = {
+	.base = 0x2800,
+	.num  = 0x04,
+	.size = 0x100,
+};
+
+static struct ddb_regset octopus_i2c = {
+	.base = 0x80,
+	.num  = 0x04,
+	.size = 0x20,
+};
+
+static struct ddb_regset octopus_i2c_buf = {
+	.base = 0x1000,
+	.num  = 0x04,
+	.size = 0x200,
+};
+
+/****************************************************************************/
+
+struct ddb_regmap octopus_map = {
+	.irq_base_i2c = 0,
+	.irq_base_idma = 8,
+	.irq_base_odma = 16,
+	.i2c = &octopus_i2c,
+	.i2c_buf = &octopus_i2c_buf,
+	.idma = &octopus_idma,
+	.idma_buf = &octopus_idma_buf,
+	.odma = &octopus_odma,
+	.odma_buf = &octopus_odma_buf,
+	.input = &octopus_input,
+	.output = &octopus_output,
+};
+
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
 
-#if 0
-static void set_table(struct ddb *dev, u32 off,
-		      dma_addr_t *pbuf, u32 num)
+static void ddb_set_dma_table(struct ddb_io *io)
 {
-	u32 i, base;
+	struct ddb *dev = io->port->dev;
+	struct ddb_dma *dma = io->dma;
+	u32 i;
 	u64 mem;
 
-	base = DMA_BASE_ADDRESS_TABLE + off;
-	for (i = 0; i < num; i++) {
-		mem = pbuf[i];
-		ddbwritel(mem & 0xffffffff, base + i * 8);
-		ddbwritel(mem >> 32, base + i * 8 + 4);
+	if (!dma)
+		return;
+	for (i = 0; i < dma->num; i++) {
+		mem = dma->pbuf[i];
+		ddbwritel(dev, mem & 0xffffffff, dma->bufregs + i * 8);
+		ddbwritel(dev, mem >> 32, dma->bufregs + i * 8 + 4);
+	}
+	dma->bufval = ((dma->div & 0x0f) << 16) |
+		((dma->num & 0x1f) << 11) |
+		((dma->size >> 7) & 0x7ff);
+}
+
+static void ddb_set_dma_tables(struct ddb *dev)
+{
+	u32 i;
+
+	for (i = 0; i < DDB_MAX_PORT; i++) {
+		if (dev->port[i].input[0])
+			ddb_set_dma_table(dev->port[i].input[0]);
+		if (dev->port[i].input[1])
+			ddb_set_dma_table(dev->port[i].input[1]);
+		if (dev->port[i].output)
+			ddb_set_dma_table(dev->port[i].output);
 	}
 }
-#endif
 
-static void ddb_address_table(struct ddb *dev)
+
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+
+static void ddb_redirect_dma(struct ddb *dev,
+			     struct ddb_dma *sdma,
+			     struct ddb_dma *ddma)
 {
-	u32 i, j, base;
+	u32 i, base;
 	u64 mem;
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
+
+	sdma->bufval = ddma->bufval;
+	base = sdma->bufregs;
+	for (i = 0; i < ddma->num; i++) {
+		mem = ddma->pbuf[i];
+		ddbwritel(dev, mem & 0xffffffff, base + i * 8);
+		ddbwritel(dev, mem >> 32, base + i * 8 + 4);
+	}
+}
+
+static int ddb_unredirect(struct ddb_port *port)
+{
+	struct ddb_input *oredi, *iredi = 0;
+	struct ddb_output *iredo = 0;
+
+	/* dev_info(port->dev->dev,
+	 * "unredirect %d.%d\n", port->dev->nr, port->nr);
+	 */
+	mutex_lock(&redirect_lock);
+	if (port->output->dma->running) {
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
+			ddb_set_dma_table(port->input[0]);
 		}
+		oredi->redi = iredi;
+		port->input[0]->redi = 0;
+	}
+	oredi->redo = 0;
+	port->output->redi = 0;
+
+	ddb_set_dma_table(oredi);
+done:
+	mutex_unlock(&redirect_lock);
+	return 0;
+}
+
+static int ddb_redirect(u32 i, u32 p)
+{
+	struct ddb *idev = ddbs[(i >> 4) & 0x3f];
+	struct ddb_input *input, *input2;
+	struct ddb *pdev = ddbs[(p >> 4) & 0x3f];
+	struct ddb_port *port;
+
+	if (!idev->has_dma || !pdev->has_dma)
+		return -EINVAL;
+	if (!idev || !pdev)
+		return -EINVAL;
+
+	port = &pdev->port[p & 0x0f];
+	if (!port->output)
+		return -EINVAL;
+	if (ddb_unredirect(port))
+		return -EBUSY;
+
+	if (i == 8)
+		return 0;
+
+	input = &idev->input[i & 7];
+	if (!input)
+		return -EINVAL;
+
+	mutex_lock(&redirect_lock);
+	if (port->output->dma->running || input->dma->running) {
+		mutex_unlock(&redirect_lock);
+		return -EBUSY;
 	}
+	input2 = port->input[0];
+	if (input2) {
+		if (input->redi) {
+			input2->redi = input->redi;
+			input->redi = 0;
+		} else
+			input2->redi = input;
+	}
+	input->redo = port->output;
+	port->output->redi = input;
+
+	ddb_redirect_dma(input->port->dev, input->dma, port->output->dma);
+	mutex_unlock(&redirect_lock);
+	return 0;
 }
 
-static void io_free(struct pci_dev *pdev, u8 **vbuf,
-		    dma_addr_t *pbuf, u32 size, int num)
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+
+static void dma_free(struct pci_dev *pdev, struct ddb_dma *dma, int dir)
 {
 	int i;
 
-	for (i = 0; i < num; i++) {
-		if (vbuf[i]) {
-			pci_free_consistent(pdev, size, vbuf[i], pbuf[i]);
-			vbuf[i] = NULL;
+	if (!dma)
+		return;
+	for (i = 0; i < dma->num; i++) {
+		if (dma->vbuf[i]) {
+			if (alt_dma) {
+				dma_unmap_single(&pdev->dev, dma->pbuf[i],
+						 dma->size,
+						 dir ? DMA_TO_DEVICE :
+						 DMA_FROM_DEVICE);
+				kfree(dma->vbuf[i]);
+				dma->vbuf[i] = NULL;
+			} else {
+				dma_free_coherent(&pdev->dev, dma->size,
+						  dma->vbuf[i], dma->pbuf[i]);
+			}
+
+			dma->vbuf[i] = NULL;
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
-			return -ENOMEM;
+	if (!dma)
+		return 0;
+	for (i = 0; i < dma->num; i++) {
+		if (alt_dma) {
+			dma->vbuf[i] = kmalloc(dma->size, __GFP_RETRY_MAYFAIL);
+			if (!dma->vbuf[i])
+				return -ENOMEM;
+			dma->pbuf[i] = dma_map_single(&pdev->dev,
+						      dma->vbuf[i],
+						      dma->size,
+						      dir ? DMA_TO_DEVICE :
+						      DMA_FROM_DEVICE);
+			if (dma_mapping_error(&pdev->dev, dma->pbuf[i])) {
+				kfree(dma->vbuf[i]);
+				dma->vbuf[i] = NULL;
+				return -ENOMEM;
+			}
+		} else {
+			dma->vbuf[i] = dma_alloc_coherent(&pdev->dev,
+							  dma->size,
+							  &dma->pbuf[i],
+							  GFP_KERNEL);
+			if (!dma->vbuf[i])
+				return -ENOMEM;
+		}
 	}
 	return 0;
 }
@@ -129,38 +343,35 @@ int ddb_buffers_alloc(struct ddb *dev)
 	int i;
 	struct ddb_port *port;
 
-	for (i = 0; i < dev->info->port_num; i++) {
+	for (i = 0; i < dev->port_num; i++) {
 		port = &dev->port[i];
 		switch (port->class) {
 		case DDB_PORT_TUNER:
-			if (io_alloc(dev->pdev, port->input[0]->vbuf,
-				     port->input[0]->pbuf,
-				     port->input[0]->dma_buf_size,
-				     port->input[0]->dma_buf_num) < 0)
-				return -1;
-			if (io_alloc(dev->pdev, port->input[1]->vbuf,
-				     port->input[1]->pbuf,
-				     port->input[1]->dma_buf_size,
-				     port->input[1]->dma_buf_num) < 0)
-				return -1;
+			if (port->input[0]->dma)
+				if (dma_alloc(dev->pdev, port->input[0]->dma, 0)
+					< 0)
+					return -1;
+			if (port->input[1]->dma)
+				if (dma_alloc(dev->pdev, port->input[1]->dma, 0)
+					< 0)
+					return -1;
 			break;
 		case DDB_PORT_CI:
-			if (io_alloc(dev->pdev, port->input[0]->vbuf,
-				     port->input[0]->pbuf,
-				     port->input[0]->dma_buf_size,
-				     port->input[0]->dma_buf_num) < 0)
-				return -1;
-			if (io_alloc(dev->pdev, port->output->vbuf,
-				     port->output->pbuf,
-				     port->output->dma_buf_size,
-				     port->output->dma_buf_num) < 0)
-				return -1;
+		case DDB_PORT_LOOP:
+			if (port->input[0]->dma)
+				if (dma_alloc(dev->pdev, port->input[0]->dma, 0)
+					< 0)
+					return -1;
+			if (port->output->dma)
+				if (dma_alloc(dev->pdev, port->output->dma, 1)
+					< 0)
+					return -1;
 			break;
 		default:
 			break;
 		}
 	}
-	ddb_address_table(dev);
+	ddb_set_dma_tables(dev);
 	return 0;
 }
 
@@ -169,111 +380,233 @@ void ddb_buffers_free(struct ddb *dev)
 	int i;
 	struct ddb_port *port;
 
-	for (i = 0; i < dev->info->port_num; i++) {
+	for (i = 0; i < dev->port_num; i++) {
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
+		if (port->input[0] && port->input[0]->dma)
+			dma_free(dev->pdev, port->input[0]->dma, 0);
+		if (port->input[1] && port->input[1]->dma)
+			dma_free(dev->pdev, port->input[1]->dma, 0);
+		if (port->output && port->output->dma)
+			dma_free(dev->pdev, port->output->dma, 1);
+	}
+}
+
+static void calc_con(struct ddb_output *output, u32 *con, u32 *con2, u32 flags)
+{
+	struct ddb *dev = output->port->dev;
+	u32 bitrate = output->port->obr, max_bitrate = 72000;
+	u32 gap = 4, nco = 0;
+
+	*con = 0x1c;
+	if (output->port->gap != 0xffffffff) {
+		flags |= 1;
+		gap = output->port->gap;
+	}
+	if (dev->link[0].info->type == DDB_OCTOPUS_CI && output->port->nr > 1) {
+		*con = 0x10c;
+		if (dev->link[0].ids.regmapid >= 0x10003 && !(flags & 1)) {
+			if (!(flags & 2)) {
+				/* NCO */
+				max_bitrate = 0;
+				gap = 0;
+				if (bitrate != 72000) {
+					if (bitrate >= 96000)
+						*con |= 0x800;
+					else {
+						*con |= 0x1000;
+						nco = (bitrate * 8192 + 71999)
+							/ 72000;
+					}
+				}
+			} else {
+				/* Divider and gap */
+				*con |= 0x1810;
+				if (bitrate <= 64000) {
+					max_bitrate = 64000;
+					nco = 8;
+				} else if (bitrate <= 72000) {
+					max_bitrate = 72000;
+					nco = 7;
+				} else {
+					max_bitrate = 96000;
+					nco = 5;
+				}
+			}
+		} else {
+			if (bitrate > 72000) {
+				*con |= 0x810; /* 96 MBit/s and gap */
+				max_bitrate = 96000;
+			}
+		}
 	}
+	if (max_bitrate > 0) {
+		if (bitrate > max_bitrate)
+			bitrate = max_bitrate;
+		if (bitrate < 31000)
+			bitrate = 31000;
+		gap = ((max_bitrate - bitrate) * 94) / bitrate;
+		if (gap < 2)
+			*con &= ~0x10; /* Disable gap */
+		else
+			gap -= 2;
+		if (gap > 127)
+			gap = 127;
+	}
+
+	*con2 = (nco << 16) | gap;
 }
 
 static void ddb_output_start(struct ddb_output *output)
 {
 	struct ddb *dev = output->port->dev;
+	u32 con = 0x11c, con2 = 0;
+
+	if (output->dma) {
+		spin_lock_irq(&output->dma->lock);
+		output->dma->cbuf = 0;
+		output->dma->coff = 0;
+		output->dma->stat = 0;
+		ddbwritel(dev, 0, DMA_BUFFER_CONTROL(output->dma));
+	}
+
+	if (output->port->input[0]->port->class == DDB_PORT_LOOP)
+		con = (1UL << 13) | 0x14;
+	else
+		calc_con(output, &con, &con2, 0);
+
+	ddbwritel(dev, 0, TS_CONTROL(output));
+	ddbwritel(dev, 2, TS_CONTROL(output));
+	ddbwritel(dev, 0, TS_CONTROL(output));
+	ddbwritel(dev, con, TS_CONTROL(output));
+	ddbwritel(dev, con2, TS_CONTROL2(output));
+
+	if (output->dma) {
+		ddbwritel(dev, output->dma->bufval,
+			  DMA_BUFFER_SIZE(output->dma));
+		ddbwritel(dev, 0, DMA_BUFFER_ACK(output->dma));
+		ddbwritel(dev, 1, DMA_BASE_READ);
+		ddbwritel(dev, 7, DMA_BUFFER_CONTROL(output->dma));
+	}
+
+	ddbwritel(dev, con | 1, TS_CONTROL(output));
 
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
+	if (output->dma) {
+		output->dma->running = 1;
+		spin_unlock_irq(&output->dma->lock);
+	}
 }
 
 static void ddb_output_stop(struct ddb_output *output)
 {
 	struct ddb *dev = output->port->dev;
 
-	spin_lock_irq(&output->lock);
-	ddbwritel(0, TS_OUTPUT_CONTROL(output->nr));
-	ddbwritel(0, DMA_BUFFER_CONTROL(output->nr + 8));
-	output->running = 0;
-	spin_unlock_irq(&output->lock);
+	if (output->dma)
+		spin_lock_irq(&output->dma->lock);
+
+	ddbwritel(dev, 0, TS_CONTROL(output));
+
+	if (output->dma) {
+		ddbwritel(dev, 0, DMA_BUFFER_CONTROL(output->dma));
+		output->dma->running = 0;
+		spin_unlock_irq(&output->dma->lock);
+	}
 }
 
 static void ddb_input_stop(struct ddb_input *input)
 {
 	struct ddb *dev = input->port->dev;
-
-	spin_lock_irq(&input->lock);
-	ddbwritel(0, TS_INPUT_CONTROL(input->nr));
-	ddbwritel(0, DMA_BUFFER_CONTROL(input->nr));
-	input->running = 0;
-	spin_unlock_irq(&input->lock);
+	u32 tag = DDB_LINK_TAG(input->port->lnr);
+
+	if (input->dma)
+		spin_lock_irq(&input->dma->lock);
+	ddbwritel(dev, 0, tag | TS_CONTROL(input));
+	if (input->dma) {
+		ddbwritel(dev, 0, DMA_BUFFER_CONTROL(input->dma));
+		input->dma->running = 0;
+		spin_unlock_irq(&input->dma->lock);
+	}
 }
 
 static void ddb_input_start(struct ddb_input *input)
 {
 	struct ddb *dev = input->port->dev;
 
-	spin_lock_irq(&input->lock);
-	input->cbuf = 0;
-	input->coff = 0;
+	if (input->dma) {
+		spin_lock_irq(&input->dma->lock);
+		input->dma->cbuf = 0;
+		input->dma->coff = 0;
+		input->dma->stat = 0;
+		ddbwritel(dev, 0, DMA_BUFFER_CONTROL(input->dma));
+	}
+	ddbwritel(dev, 0, TS_CONTROL(input));
+	ddbwritel(dev, 2, TS_CONTROL(input));
+	ddbwritel(dev, 0, TS_CONTROL(input));
+
+	if (input->dma) {
+		ddbwritel(dev, input->dma->bufval,
+			  DMA_BUFFER_SIZE(input->dma));
+		ddbwritel(dev, 0, DMA_BUFFER_ACK(input->dma));
+		ddbwritel(dev, 1, DMA_BASE_WRITE);
+		ddbwritel(dev, 3, DMA_BUFFER_CONTROL(input->dma));
+	}
+
+	ddbwritel(dev, 0x09, TS_CONTROL(input));
+
+	if (input->dma) {
+		input->dma->running = 1;
+		spin_unlock_irq(&input->dma->lock);
+	}
+}
+
+
+static void ddb_input_start_all(struct ddb_input *input)
+{
+	struct ddb_input *i = input;
+	struct ddb_output *o;
 
-	/* reset */
-	ddbwritel(0, TS_INPUT_CONTROL(input->nr));
-	ddbwritel(2, TS_INPUT_CONTROL(input->nr));
-	ddbwritel(0, TS_INPUT_CONTROL(input->nr));
+	mutex_lock(&redirect_lock);
+	while (i && (o = i->redo)) {
+		ddb_output_start(o);
+		i = o->port->input[0];
+		if (i)
+			ddb_input_start(i);
+	}
+	ddb_input_start(input);
+	mutex_unlock(&redirect_lock);
+}
 
-	ddbwritel((1 << 16) |
-		  (input->dma_buf_num << 11) |
-		  (input->dma_buf_size >> 7),
-		  DMA_BUFFER_SIZE(input->nr));
-	ddbwritel(0, DMA_BUFFER_ACK(input->nr));
+static void ddb_input_stop_all(struct ddb_input *input)
+{
+	struct ddb_input *i = input;
+	struct ddb_output *o;
 
-	ddbwritel(1, DMA_BASE_WRITE);
-	ddbwritel(3, DMA_BUFFER_CONTROL(input->nr));
-	ddbwritel(9, TS_INPUT_CONTROL(input->nr));
-	input->running = 1;
-	spin_unlock_irq(&input->lock);
+	mutex_lock(&redirect_lock);
+	ddb_input_stop(input);
+	while (i && (o = i->redo)) {
+		ddb_output_stop(o);
+		i = o->port->input[0];
+		if (i)
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
 
-	if (output->cbuf != idx) {
-		if ((((output->cbuf + 1) % output->dma_buf_num) == idx) &&
-		    (output->dma_buf_size - output->coff <= 188))
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
@@ -283,46 +616,51 @@ static ssize_t ddb_output_write(struct ddb_output *output,
 				const __user u8 *buf, size_t count)
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
+		if (alt_dma)
+			dma_sync_single_for_device(dev->dev,
+				output->dma->pbuf[output->dma->cbuf],
+				output->dma->size, DMA_TO_DEVICE);
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
+			  (output->dma->cbuf << 11) |
+			  (output->dma->coff >> 7),
+			  DMA_BUFFER_ACK(output->dma));
 	}
 	return count - left;
 }
@@ -330,49 +668,57 @@ static ssize_t ddb_output_write(struct ddb_output *output,
 static u32 ddb_input_avail(struct ddb_input *input)
 {
 	struct ddb *dev = input->port->dev;
-	u32 idx, off, stat = input->stat;
-	u32 ctrl = ddbreadl(DMA_BUFFER_CONTROL(input->nr));
+	u32 idx, off, stat = input->dma->stat;
+	u32 ctrl = ddbreadl(dev, DMA_BUFFER_CONTROL(input->dma));
 
 	idx = (stat >> 11) & 0x1f;
 	off = (stat & 0x7ff) << 7;
 
 	if (ctrl & 4) {
-		dev_err(&dev->pdev->dev, "IA %d %d %08x\n", idx, off, ctrl);
-		ddbwritel(input->stat, DMA_BUFFER_ACK(input->nr));
+		dev_err(dev->dev, "IA %d %d %08x\n", idx, off, ctrl);
+		ddbwritel(dev, stat, DMA_BUFFER_ACK(input->dma));
 		return 0;
 	}
-	if (input->cbuf != idx)
+	if (input->dma->cbuf != idx)
 		return 188;
 	return 0;
 }
 
-static ssize_t ddb_input_read(struct ddb_input *input, __user u8 *buf, size_t count)
+static ssize_t ddb_input_read(struct ddb_input *input,
+		__user u8 *buf, size_t count)
 {
 	struct ddb *dev = input->port->dev;
 	u32 left = count;
-	u32 idx, free, stat = input->stat;
+	u32 idx, free, stat = input->dma->stat;
 	int ret;
 
 	idx = (stat >> 11) & 0x1f;
 
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
+		if (alt_dma)
+			dma_sync_single_for_cpu(dev->dev,
+				input->dma->pbuf[input->dma->cbuf],
+				input->dma->size, DMA_FROM_DEVICE);
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
+		buf += free;
+		ddbwritel(dev,
+			  (input->dma->cbuf << 11) | (input->dma->coff >> 7),
+			  DMA_BUFFER_ACK(input->dma));
 	}
 	return count;
 }
@@ -385,20 +731,24 @@ static ssize_t ts_write(struct file *file, const __user char *buf,
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct ddb_output *output = dvbdev->priv;
+	struct ddb *dev = output->port->dev;
 	size_t left = count;
 	int stat;
 
+	if (!dev->has_dma)
+		return -EINVAL;
 	while (left) {
 		if (ddb_output_free(output) < 188) {
 			if (file->f_flags & O_NONBLOCK)
 				break;
 			if (wait_event_interruptible(
-				    output->wq, ddb_output_free(output) >= 188) < 0)
+				    output->dma->wq,
+				    ddb_output_free(output) >= 188) < 0)
 				break;
 		}
 		stat = ddb_output_write(output, buf, left);
 		if (stat < 0)
-			break;
+			return stat;
 		buf += stat;
 		left -= stat;
 	}
@@ -411,91 +761,126 @@ static ssize_t ts_read(struct file *file, __user char *buf,
 	struct dvb_device *dvbdev = file->private_data;
 	struct ddb_output *output = dvbdev->priv;
 	struct ddb_input *input = output->port->input[0];
-	int left, read;
+	struct ddb *dev = output->port->dev;
+	size_t left = count;
+	int stat;
 
-	count -= count % 188;
-	left = count;
+	if (!dev->has_dma)
+		return -EINVAL;
 	while (left) {
 		if (ddb_input_avail(input) < 188) {
 			if (file->f_flags & O_NONBLOCK)
 				break;
 			if (wait_event_interruptible(
-				    input->wq, ddb_input_avail(input) >= 188) < 0)
+				    input->dma->wq,
+				    ddb_input_avail(input) >= 188) < 0)
 				break;
 		}
-		read = ddb_input_read(input, buf, left);
-		if (read < 0)
-			return read;
-		left -= read;
-		buf += read;
+		stat = ddb_input_read(input, buf, left);
+		if (stat < 0)
+			return stat;
+		left -= stat;
+		buf += stat;
 	}
-	return (left == count) ? -EAGAIN : (count - left);
+	return (count && (left == count)) ? -EAGAIN : (count - left);
 }
 
 static unsigned int ts_poll(struct file *file, poll_table *wait)
 {
-	/*
 	struct dvb_device *dvbdev = file->private_data;
 	struct ddb_output *output = dvbdev->priv;
 	struct ddb_input *input = output->port->input[0];
-	*/
+
 	unsigned int mask = 0;
 
-#if 0
-	if (data_avail_to_read)
+	poll_wait(file, &input->dma->wq, wait);
+	poll_wait(file, &output->dma->wq, wait);
+	if (ddb_input_avail(input) >= 188)
 		mask |= POLLIN | POLLRDNORM;
-	if (data_avail_to_write)
+	if (ddb_output_free(output) >= 188)
 		mask |= POLLOUT | POLLWRNORM;
-
-	poll_wait(file, &read_queue, wait);
-	poll_wait(file, &write_queue, wait);
-#endif
 	return mask;
 }
 
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
+
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
+	} else
+		return -EINVAL;
+	err = dvb_generic_open(inode, file);
+	if (err < 0)
+		return err;
+	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
+		ddb_input_start(input);
+	else if ((file->f_flags & O_ACCMODE) == O_WRONLY)
+		ddb_output_start(output);
+	return err;
+}
+
 static const struct file_operations ci_fops = {
 	.owner   = THIS_MODULE,
 	.read    = ts_read,
 	.write   = ts_write,
-	.open    = dvb_generic_open,
-	.release = dvb_generic_release,
+	.open    = ts_open,
+	.release = ts_release,
 	.poll    = ts_poll,
+	.mmap    = 0,
 };
 
 static struct dvb_device dvbdev_ci = {
-	.readers = -1,
-	.writers = -1,
-	.users   = -1,
+	.priv    = 0,
+	.readers = 1,
+	.writers = 1,
+	.users   = 2,
 	.fops    = &ci_fops,
 };
 
-/******************************************************************************/
-/******************************************************************************/
-
-#if 0
-static struct ddb_input *fe2input(struct ddb *dev, struct dvb_frontend *fe)
-{
-	int i;
 
-	for (i = 0; i < dev->info->port_num * 2; i++) {
-		if (dev->input[i].fe == fe)
-			return &dev->input[i];
-	}
-	return NULL;
-}
-#endif
+/****************************************************************************/
+/****************************************************************************/
 
-static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
+static int locked_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct ddb_input *input = fe->sec_priv;
 	struct ddb_port *port = input->port;
+	struct ddb_dvb *dvb = &port->dvb[input->nr & 1];
 	int status;
 
 	if (enable) {
 		mutex_lock(&port->i2c_gate_lock);
-		status = input->gate_ctrl(fe, 1);
+		status = dvb->i2c_gate_ctrl(fe, 1);
 	} else {
-		status = input->gate_ctrl(fe, 0);
+		status = dvb->i2c_gate_ctrl(fe, 0);
 		mutex_unlock(&port->i2c_gate_lock);
 	}
 	return status;
@@ -504,41 +889,42 @@ static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 static int demod_attach_drxk(struct ddb_input *input)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct device *dev = input->port->dev->dev;
 	struct dvb_frontend *fe;
 	struct drxk_config config;
-	struct device *dev = &input->port->dev->pdev->dev;
 
 	memset(&config, 0, sizeof(config));
-	config.microcode_name = "drxk_a3.mc";
-	config.qam_demod_parameter_count = 4;
 	config.adr = 0x29 + (input->nr & 1);
+	config.microcode_name = "drxk_a3.mc";
 
-	fe = input->fe = dvb_attach(drxk_attach, &config, i2c);
-	if (!input->fe) {
+	fe = dvb->fe = dvb_attach(drxk_attach, &config, i2c);
+	if (!fe) {
 		dev_err(dev, "No DRXK found!\n");
 		return -ENODEV;
 	}
 	fe->sec_priv = input;
-	input->gate_ctrl = fe->ops.i2c_gate_ctrl;
-	fe->ops.i2c_gate_ctrl = drxk_gate_ctrl;
+	dvb->i2c_gate_ctrl = fe->ops.i2c_gate_ctrl;
+	fe->ops.i2c_gate_ctrl = locked_gate_ctrl;
 	return 0;
 }
 
 static int tuner_attach_tda18271(struct ddb_input *input)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct device *dev = input->port->dev->dev;
 	struct dvb_frontend *fe;
-	struct device *dev = &input->port->dev->pdev->dev;
 
-	if (input->fe->ops.i2c_gate_ctrl)
-		input->fe->ops.i2c_gate_ctrl(input->fe, 1);
-	fe = dvb_attach(tda18271c2dd_attach, input->fe, i2c, 0x60);
+	if (dvb->fe->ops.i2c_gate_ctrl)
+		dvb->fe->ops.i2c_gate_ctrl(dvb->fe, 1);
+	fe = dvb_attach(tda18271c2dd_attach, dvb->fe, i2c, 0x60);
+	if (dvb->fe->ops.i2c_gate_ctrl)
+		dvb->fe->ops.i2c_gate_ctrl(dvb->fe, 0);
 	if (!fe) {
 		dev_err(dev, "No TDA18271 found!\n");
 		return -ENODEV;
 	}
-	if (input->fe->ops.i2c_gate_ctrl)
-		input->fe->ops.i2c_gate_ctrl(input->fe, 0);
 	return 0;
 }
 
@@ -567,43 +953,43 @@ static struct stv0367_config ddb_stv0367_config[] = {
 static int demod_attach_stv0367(struct ddb_input *input)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
-	struct device *dev = &input->port->dev->pdev->dev;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct device *dev = input->port->dev->dev;
+	struct dvb_frontend *fe;
 
 	/* attach frontend */
-	input->fe = dvb_attach(stv0367ddb_attach,
+	fe = dvb->fe = dvb_attach(stv0367ddb_attach,
 		&ddb_stv0367_config[(input->nr & 1)], i2c);
 
-	if (!input->fe) {
-		dev_err(dev, "stv0367ddb_attach failed (not found?)\n");
+	if (!dvb->fe) {
+		dev_err(dev, "No stv0367 found!\n");
 		return -ENODEV;
 	}
-
-	input->fe->sec_priv = input;
-	input->gate_ctrl = input->fe->ops.i2c_gate_ctrl;
-	input->fe->ops.i2c_gate_ctrl = drxk_gate_ctrl;
-
+	fe->sec_priv = input;
+	dvb->i2c_gate_ctrl = fe->ops.i2c_gate_ctrl;
+	fe->ops.i2c_gate_ctrl = locked_gate_ctrl;
 	return 0;
 }
 
 static int tuner_tda18212_ping(struct ddb_input *input, unsigned short adr)
 {
 	struct i2c_adapter *adapter = &input->port->i2c->adap;
-	struct device *dev = &input->port->dev->pdev->dev;
-
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct device *dev = input->port->dev->dev;
 	u8 tda_id[2];
 	u8 subaddr = 0x00;
 
 	dev_dbg(dev, "stv0367-tda18212 tuner ping\n");
-	if (input->fe->ops.i2c_gate_ctrl)
-		input->fe->ops.i2c_gate_ctrl(input->fe, 1);
+	if (dvb->fe->ops.i2c_gate_ctrl)
+		dvb->fe->ops.i2c_gate_ctrl(dvb->fe, 1);
 
 	if (i2c_read_regs(adapter, adr, subaddr, tda_id, sizeof(tda_id)) < 0)
 		dev_dbg(dev, "tda18212 ping 1 fail\n");
 	if (i2c_read_regs(adapter, adr, subaddr, tda_id, sizeof(tda_id)) < 0)
 		dev_warn(dev, "tda18212 ping failed, expect problems\n");
 
-	if (input->fe->ops.i2c_gate_ctrl)
-		input->fe->ops.i2c_gate_ctrl(input->fe, 0);
+	if (dvb->fe->ops.i2c_gate_ctrl)
+		dvb->fe->ops.i2c_gate_ctrl(dvb->fe, 0);
 
 	return 0;
 }
@@ -611,7 +997,9 @@ static int tuner_tda18212_ping(struct ddb_input *input, unsigned short adr)
 static int demod_attach_cxd28xx(struct ddb_input *input, int par, int osc24)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
-	struct device *dev = &input->port->dev->pdev->dev;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct device *dev = input->port->dev->dev;
+	struct dvb_frontend *fe;
 	struct cxd2841er_config cfg;
 
 	/* the cxd2841er driver expects 8bit/shifted I2C addresses */
@@ -626,27 +1014,26 @@ static int demod_attach_cxd28xx(struct ddb_input *input, int par, int osc24)
 		cfg.flags |= CXD2841ER_TS_SERIAL;
 
 	/* attach frontend */
-	input->fe = dvb_attach(cxd2841er_attach_t_c, &cfg, i2c);
+	fe = dvb->fe = dvb_attach(cxd2841er_attach_t_c, &cfg, i2c);
 
-	if (!input->fe) {
-		dev_err(dev, "No Sony CXD28xx found!\n");
+	if (!dvb->fe) {
+		dev_err(dev, "No cxd2837/38/43/54 found!\n");
 		return -ENODEV;
 	}
-
-	input->fe->sec_priv = input;
-	input->gate_ctrl = input->fe->ops.i2c_gate_ctrl;
-	input->fe->ops.i2c_gate_ctrl = drxk_gate_ctrl;
-
+	fe->sec_priv = input;
+	dvb->i2c_gate_ctrl = fe->ops.i2c_gate_ctrl;
+	fe->ops.i2c_gate_ctrl = locked_gate_ctrl;
 	return 0;
 }
 
 static int tuner_attach_tda18212(struct ddb_input *input, u32 porttype)
 {
 	struct i2c_adapter *adapter = &input->port->i2c->adap;
-	struct device *dev = &input->port->dev->pdev->dev;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct device *dev = input->port->dev->dev;
 	struct i2c_client *client;
 	struct tda18212_config config = {
-		.fe = input->fe,
+		.fe = dvb->fe,
 		.if_dvbt_6 = 3550,
 		.if_dvbt_7 = 3700,
 		.if_dvbt_8 = 4150,
@@ -684,17 +1071,17 @@ static int tuner_attach_tda18212(struct ddb_input *input, u32 porttype)
 		goto err;
 	}
 
-	input->i2c_client[0] = client;
+	dvb->i2c_client[0] = client;
 
 	return 0;
 err:
-	dev_warn(dev, "TDA18212 tuner not found. Device is not fully operational.\n");
+	dev_notice(dev, "TDA18212 tuner not found. Device is not fully operational.\n");
 	return -ENODEV;
 }
 
-/******************************************************************************/
-/******************************************************************************/
-/******************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
 
 static struct stv090x_config stv0900 = {
 	.device         = STV0900,
@@ -707,6 +1094,9 @@ static struct stv090x_config stv0900 = {
 	.ts1_mode       = STV090x_TSMODE_SERIAL_PUNCTURED,
 	.ts2_mode       = STV090x_TSMODE_SERIAL_PUNCTURED,
 
+	.ts1_tei        = 1,
+	.ts2_tei        = 1,
+
 	.repeater_level = STV090x_RPTLEVEL_16,
 
 	.adc1_range	= STV090x_ADC_1Vpp,
@@ -726,6 +1116,9 @@ static struct stv090x_config stv0900_aa = {
 	.ts1_mode       = STV090x_TSMODE_SERIAL_PUNCTURED,
 	.ts2_mode       = STV090x_TSMODE_SERIAL_PUNCTURED,
 
+	.ts1_tei        = 1,
+	.ts2_tei        = 1,
+
 	.repeater_level = STV090x_RPTLEVEL_16,
 
 	.adc1_range	= STV090x_ADC_1Vpp,
@@ -749,17 +1142,18 @@ static struct stv6110x_config stv6110b = {
 static int demod_attach_stv0900(struct ddb_input *input, int type)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
-	struct device *dev = &input->port->dev->pdev->dev;
 	struct stv090x_config *feconf = type ? &stv0900_aa : &stv0900;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct device *dev = input->port->dev->dev;
 
-	input->fe = dvb_attach(stv090x_attach, feconf, i2c,
-			       (input->nr & 1) ? STV090x_DEMODULATOR_1
-			       : STV090x_DEMODULATOR_0);
-	if (!input->fe) {
+	dvb->fe = dvb_attach(stv090x_attach, feconf, i2c,
+			     (input->nr & 1) ? STV090x_DEMODULATOR_1
+			     : STV090x_DEMODULATOR_0);
+	if (!dvb->fe) {
 		dev_err(dev, "No STV0900 found!\n");
 		return -ENODEV;
 	}
-	if (!dvb_attach(lnbh24_attach, input->fe, i2c, 0,
+	if (!dvb_attach(lnbh24_attach, dvb->fe, i2c, 0,
 			0, (input->nr & 1) ?
 			(0x09 - type) : (0x0b - type))) {
 		dev_err(dev, "No LNBH24 found!\n");
@@ -771,19 +1165,20 @@ static int demod_attach_stv0900(struct ddb_input *input, int type)
 static int tuner_attach_stv6110(struct ddb_input *input, int type)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
-	struct device *dev = &input->port->dev->pdev->dev;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct device *dev = input->port->dev->dev;
 	struct stv090x_config *feconf = type ? &stv0900_aa : &stv0900;
 	struct stv6110x_config *tunerconf = (input->nr & 1) ?
 		&stv6110b : &stv6110a;
 	const struct stv6110x_devctl *ctl;
 
-	ctl = dvb_attach(stv6110x_attach, input->fe, tunerconf, i2c);
+	ctl = dvb_attach(stv6110x_attach, dvb->fe, tunerconf, i2c);
 	if (!ctl) {
 		dev_err(dev, "No STV6110X found!\n");
 		return -ENODEV;
 	}
 	dev_info(dev, "attach tuner input %d adr %02x\n",
-			 input->nr, tunerconf->addr);
+		input->nr, tunerconf->addr);
 
 	feconf->tuner_init          = ctl->tuner_init;
 	feconf->tuner_sleep         = ctl->tuner_sleep;
@@ -815,7 +1210,8 @@ static struct lnbh25_config lnbh25_cfg = {
 static int demod_attach_stv0910(struct ddb_input *input, int type)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
-	struct device *dev = &input->port->dev->pdev->dev;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct device *dev = input->port->dev->dev;
 	struct stv0910_cfg cfg = stv0910_p;
 	struct lnbh25_config lnbcfg = lnbh25_cfg;
 
@@ -824,13 +1220,13 @@ static int demod_attach_stv0910(struct ddb_input *input, int type)
 
 	if (type)
 		cfg.parallel = 2;
-	input->fe = dvb_attach(stv0910_attach, i2c, &cfg, (input->nr & 1));
-	if (!input->fe) {
+	dvb->fe = dvb_attach(stv0910_attach, i2c, &cfg, (input->nr & 1));
+	if (!dvb->fe) {
 		cfg.adr = 0x6c;
-		input->fe = dvb_attach(stv0910_attach, i2c,
-					&cfg, (input->nr & 1));
+		dvb->fe = dvb_attach(stv0910_attach, i2c,
+				     &cfg, (input->nr & 1));
 	}
-	if (!input->fe) {
+	if (!dvb->fe) {
 		dev_err(dev, "No STV0910 found!\n");
 		return -ENODEV;
 	}
@@ -839,9 +1235,9 @@ static int demod_attach_stv0910(struct ddb_input *input, int type)
 	 * i2c addresses
 	 */
 	lnbcfg.i2c_address = (((input->nr & 1) ? 0x0d : 0x0c) << 1);
-	if (!dvb_attach(lnbh25_attach, input->fe, &lnbcfg, i2c)) {
+	if (!dvb_attach(lnbh25_attach, dvb->fe, &lnbcfg, i2c)) {
 		lnbcfg.i2c_address = (((input->nr & 1) ? 0x09 : 0x08) << 1);
-		if (!dvb_attach(lnbh25_attach, input->fe, &lnbcfg, i2c)) {
+		if (!dvb_attach(lnbh25_attach, dvb->fe, &lnbcfg, i2c)) {
 			dev_err(dev, "No LNBH25 found!\n");
 			return -ENODEV;
 		}
@@ -853,13 +1249,14 @@ static int demod_attach_stv0910(struct ddb_input *input, int type)
 static int tuner_attach_stv6111(struct ddb_input *input, int type)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
-	struct device *dev = &input->port->dev->pdev->dev;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct device *dev = input->port->dev->dev;
 	struct dvb_frontend *fe;
 	u8 adr = (type ? 0 : 4) + ((input->nr & 1) ? 0x63 : 0x60);
 
-	fe = dvb_attach(stv6111_attach, input->fe, i2c, adr);
+	fe = dvb_attach(stv6111_attach, dvb->fe, i2c, adr);
 	if (!fe) {
-		fe = dvb_attach(stv6111_attach, input->fe, i2c, adr & ~4);
+		fe = dvb_attach(stv6111_attach, dvb->fe, i2c, adr & ~4);
 		if (!fe) {
 			dev_err(dev, "No STV6111 found at 0x%02x!\n", adr);
 			return -ENODEV;
@@ -868,294 +1265,375 @@ static int tuner_attach_stv6111(struct ddb_input *input, int type)
 	return 0;
 }
 
-static int my_dvb_dmx_ts_card_init(struct dvb_demux *dvbdemux, char *id,
-			    int (*start_feed)(struct dvb_demux_feed *),
-			    int (*stop_feed)(struct dvb_demux_feed *),
-			    void *priv)
-{
-	dvbdemux->priv = priv;
-
-	dvbdemux->filternum = 256;
-	dvbdemux->feednum = 256;
-	dvbdemux->start_feed = start_feed;
-	dvbdemux->stop_feed = stop_feed;
-	dvbdemux->write_to_decoder = NULL;
-	dvbdemux->dmx.capabilities = (DMX_TS_FILTERING |
-				      DMX_SECTION_FILTERING |
-				      DMX_MEMORY_BASED_FILTERING);
-	return dvb_dmx_init(dvbdemux);
-}
-
-static int my_dvb_dmxdev_ts_card_init(struct dmxdev *dmxdev,
-			       struct dvb_demux *dvbdemux,
-			       struct dmx_frontend *hw_frontend,
-			       struct dmx_frontend *mem_frontend,
-			       struct dvb_adapter *dvb_adapter)
-{
-	int ret;
-
-	dmxdev->filternum = 256;
-	dmxdev->demux = &dvbdemux->dmx;
-	dmxdev->capabilities = 0;
-	ret = dvb_dmxdev_init(dmxdev, dvb_adapter);
-	if (ret < 0)
-		return ret;
-
-	hw_frontend->source = DMX_FRONTEND_0;
-	dvbdemux->dmx.add_frontend(&dvbdemux->dmx, hw_frontend);
-	mem_frontend->source = DMX_MEMORY_FE;
-	dvbdemux->dmx.add_frontend(&dvbdemux->dmx, mem_frontend);
-	return dvbdemux->dmx.connect_frontend(&dvbdemux->dmx, hw_frontend);
-}
-
 static int start_feed(struct dvb_demux_feed *dvbdmxfeed)
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
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct dvb_demux *dvbdemux = &dvb->demux;
 	struct i2c_client *client;
 
-	switch (input->attached) {
-	case 5:
-		client = input->i2c_client[0];
+	switch (dvb->attached) {
+	case 0x31:
+		client = dvb->i2c_client[0];
 		if (client) {
 			module_put(client->dev.driver->owner);
 			i2c_unregister_device(client);
 		}
-		if (input->fe2) {
-			dvb_unregister_frontend(input->fe2);
-			input->fe2 = NULL;
-		}
-		if (input->fe) {
-			dvb_unregister_frontend(input->fe);
-			dvb_frontend_detach(input->fe);
-			input->fe = NULL;
-		}
-		/* fall-through */
-	case 4:
-		dvb_net_release(&input->dvbnet);
-		/* fall-through */
-	case 3:
-		dvbdemux->dmx.close(&dvbdemux->dmx);
+		if (dvb->fe2)
+			dvb_unregister_frontend(dvb->fe2);
+		if (dvb->fe)
+			dvb_unregister_frontend(dvb->fe);
+		/* fallthrough */
+	case 0x30:
+		if (dvb->fe2)
+			dvb_frontend_detach(dvb->fe2);
+		if (dvb->fe)
+			dvb_frontend_detach(dvb->fe);
+		dvb->fe = dvb->fe2 = NULL;
+		/* fallthrough */
+	case 0x20:
+		dvb_net_release(&dvb->dvbnet);
+		/* fallthrough */
+	case 0x12:
 		dvbdemux->dmx.remove_frontend(&dvbdemux->dmx,
-					      &input->hw_frontend);
+					      &dvb->hw_frontend);
 		dvbdemux->dmx.remove_frontend(&dvbdemux->dmx,
-					      &input->mem_frontend);
-		dvb_dmxdev_release(&input->dmxdev);
-		/* fall-through */
-	case 2:
-		dvb_dmx_release(&input->demux);
-		/* fall-through */
-	case 1:
-		dvb_unregister_adapter(adap);
+					      &dvb->mem_frontend);
+		/* fallthrough */
+	case 0x11:
+		dvb_dmxdev_release(&dvb->dmxdev);
+		/* fallthrough */
+	case 0x10:
+		dvb_dmx_release(&dvb->demux);
+		/* fallthrough */
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
+	if (adapter_alloc == 3) {
+		port = &dev->port[0];
+		adap = port->dvb[0].adap;
+		ret = dvb_register_adapter(adap, "DDBridge", THIS_MODULE,
+					   port->dev->dev,
+					   adapter_nr);
+		if (ret < 0)
+			return ret;
+		port->dvb[0].adap_registered = 1;
+		for (i = 0; i < dev->port_num; i++) {
+			port = &dev->port[i];
+			port->dvb[0].adap = adap;
+			port->dvb[1].adap = adap;
+		}
+		return 0;
+	}
+
+	for (i = 0; i < dev->port_num; i++) {
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
+
+	for (i = 0; i < dev->link[0].info->port_num; i++) {
+		port = &dev->port[i];
+
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
-	struct device *dev = &input->port->dev->pdev->dev;
-	int sony_osc24 = 0, sony_tspar = 0;
-
-	ret = dvb_register_adapter(adap, "DDBridge", THIS_MODULE,
-				   &input->port->dev->pdev->dev,
-				   adapter_nr);
-	if (ret < 0) {
-		dev_err(dev, "Could not register adapter. Check if you enabled enough adapters in dvb-core!\n");
+	struct dvb_adapter *adap = dvb->adap;
+	struct dvb_demux *dvbdemux = &dvb->demux;
+	int par = 0, osc24 = 0;
+
+	dvb->attached = 0x01;
+
+	dvbdemux->priv = input;
+	dvbdemux->dmx.capabilities = DMX_TS_FILTERING |
+		DMX_SECTION_FILTERING | DMX_MEMORY_BASED_FILTERING;
+	dvbdemux->start_feed = start_feed;
+	dvbdemux->stop_feed = stop_feed;
+	dvbdemux->filternum = dvbdemux->feednum = 256;
+	ret = dvb_dmx_init(dvbdemux);
+	if (ret < 0)
 		return ret;
-	}
-	input->attached = 1;
+	dvb->attached = 0x10;
 
-	ret = my_dvb_dmx_ts_card_init(dvbdemux, "SW demux",
-				      start_feed,
-				      stop_feed, input);
+	dvb->dmxdev.filternum = 256;
+	dvb->dmxdev.demux = &dvbdemux->dmx;
+	ret = dvb_dmxdev_init(&dvb->dmxdev, adap);
 	if (ret < 0)
 		return ret;
-	input->attached = 2;
+	dvb->attached = 0x11;
 
-	ret = my_dvb_dmxdev_ts_card_init(&input->dmxdev, &input->demux,
-					 &input->hw_frontend,
-					 &input->mem_frontend, adap);
+	dvb->mem_frontend.source = DMX_MEMORY_FE;
+	dvb->demux.dmx.add_frontend(&dvb->demux.dmx, &dvb->mem_frontend);
+	dvb->hw_frontend.source = DMX_FRONTEND_0;
+	dvb->demux.dmx.add_frontend(&dvb->demux.dmx, &dvb->hw_frontend);
+	ret = dvbdemux->dmx.connect_frontend(&dvbdemux->dmx, &dvb->hw_frontend);
 	if (ret < 0)
 		return ret;
-	input->attached = 3;
+	dvb->attached = 0x12;
 
-	ret = dvb_net_init(adap, &input->dvbnet, input->dmxdev.demux);
+	ret = dvb_net_init(adap, &dvb->dvbnet, dvb->dmxdev.demux);
 	if (ret < 0)
 		return ret;
-	input->attached = 4;
+	dvb->attached = 0x20;
 
-	input->fe = NULL;
+	dvb->fe = dvb->fe2 = NULL;
 	switch (port->type) {
+	case DDB_TUNER_MXL5XX:
+		dev_notice(port->dev->dev, "MaxLinear MxL5xx not supported\n");
+		return -ENODEV;
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
-	case DDB_TUNER_XO2_DVBS_STV0910:
+	case DDB_TUNER_DVBS_STV0910:
 		if (demod_attach_stv0910(input, 0) < 0)
 			return -ENODEV;
 		if (tuner_attach_stv6111(input, 0) < 0)
 			return -ENODEV;
-		if (input->fe) {
-			if (dvb_register_frontend(adap, input->fe) < 0)
-				return -ENODEV;
-		}
 		break;
 	case DDB_TUNER_DVBS_STV0910_PR:
 		if (demod_attach_stv0910(input, 1) < 0)
 			return -ENODEV;
 		if (tuner_attach_stv6111(input, 1) < 0)
 			return -ENODEV;
-		if (input->fe) {
-			if (dvb_register_frontend(adap, input->fe) < 0)
-				return -ENODEV;
-		}
 		break;
 	case DDB_TUNER_DVBS_STV0910_P:
 		if (demod_attach_stv0910(input, 0) < 0)
 			return -ENODEV;
 		if (tuner_attach_stv6111(input, 1) < 0)
 			return -ENODEV;
-		if (input->fe) {
-			if (dvb_register_frontend(adap, input->fe) < 0)
-				return -ENODEV;
-		}
 		break;
 	case DDB_TUNER_DVBCT_TR:
 		if (demod_attach_drxk(input) < 0)
 			return -ENODEV;
 		if (tuner_attach_tda18271(input) < 0)
 			return -ENODEV;
-		if (dvb_register_frontend(adap, input->fe) < 0)
-			return -ENODEV;
-		if (input->fe2) {
-			if (dvb_register_frontend(adap, input->fe2) < 0)
-				return -ENODEV;
-			input->fe2->tuner_priv = input->fe->tuner_priv;
-			memcpy(&input->fe2->ops.tuner_ops,
-			       &input->fe->ops.tuner_ops,
-			       sizeof(struct dvb_tuner_ops));
-		}
 		break;
 	case DDB_TUNER_DVBCT_ST:
 		if (demod_attach_stv0367(input) < 0)
 			return -ENODEV;
-		if (tuner_attach_tda18212(input, port->type) < 0)
+		if (tuner_attach_tda18212(input, port->type) < 0) {
+			if (dvb->fe2)
+				dvb_frontend_detach(dvb->fe2);
+			if (dvb->fe)
+				dvb_frontend_detach(dvb->fe);
 			return -ENODEV;
-		if (input->fe) {
-			if (dvb_register_frontend(adap, input->fe) < 0)
-				return -ENODEV;
 		}
 		break;
 	case DDB_TUNER_DVBC2T2I_SONY_P:
+		if (input->port->dev->link[input->port->lnr].info->ts_quirks &
+		    TS_QUIRK_ALT_OSC)
+			osc24 = 0;
+		else
+			osc24 = 1;
 	case DDB_TUNER_DVBCT2_SONY_P:
 	case DDB_TUNER_DVBC2T2_SONY_P:
 	case DDB_TUNER_ISDBT_SONY_P:
-		if (port->type == DDB_TUNER_DVBC2T2I_SONY_P)
-			sony_osc24 = 1;
-		if (input->port->dev->info->ts_quirks & TS_QUIRK_ALT_OSC)
-			sony_osc24 = 0;
-		if (input->port->dev->info->ts_quirks & TS_QUIRK_SERIAL)
-			sony_tspar = 0;
+		if (input->port->dev->link[input->port->lnr].info->ts_quirks
+			& TS_QUIRK_SERIAL)
+			par = 0;
 		else
-			sony_tspar = 1;
-
-		if (demod_attach_cxd28xx(input, sony_tspar, sony_osc24) < 0)
+			par = 1;
+		if (demod_attach_cxd28xx(input, par, osc24) < 0)
 			return -ENODEV;
-		if (tuner_attach_tda18212(input, port->type) < 0)
+		if (tuner_attach_tda18212(input, port->type) < 0) {
+			if (dvb->fe2)
+				dvb_frontend_detach(dvb->fe2);
+			if (dvb->fe)
+				dvb_frontend_detach(dvb->fe);
 			return -ENODEV;
-		if (input->fe) {
-			if (dvb_register_frontend(adap, input->fe) < 0)
-				return -ENODEV;
 		}
 		break;
-	case DDB_TUNER_XO2_DVBC2T2I_SONY:
-	case DDB_TUNER_XO2_DVBCT2_SONY:
-	case DDB_TUNER_XO2_DVBC2T2_SONY:
-	case DDB_TUNER_XO2_ISDBT_SONY:
-		if (port->type == DDB_TUNER_XO2_DVBC2T2I_SONY)
-			sony_osc24 = 1;
-
-		if (demod_attach_cxd28xx(input, 0, sony_osc24) < 0)
+	case DDB_TUNER_DVBC2T2I_SONY:
+		osc24 = 1;
+	case DDB_TUNER_DVBCT2_SONY:
+	case DDB_TUNER_DVBC2T2_SONY:
+	case DDB_TUNER_ISDBT_SONY:
+		if (demod_attach_cxd28xx(input, 0, osc24) < 0)
 			return -ENODEV;
-		if (tuner_attach_tda18212(input, port->type) < 0)
+		if (tuner_attach_tda18212(input, port->type) < 0) {
+			if (dvb->fe2)
+				dvb_frontend_detach(dvb->fe2);
+			if (dvb->fe)
+				dvb_frontend_detach(dvb->fe);
 			return -ENODEV;
-		if (input->fe) {
-			if (dvb_register_frontend(adap, input->fe) < 0)
-				return -ENODEV;
 		}
 		break;
+	default:
+		return 0;
 	}
-
-	input->attached = 5;
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
+	}
+	dvb->attached = 0x31;
 	return 0;
 }
 
-static int port_has_ci(struct ddb_port *port)
+
+static int port_has_encti(struct ddb_port *port)
+{
+	struct device *dev = port->dev->dev;
+	u8 val;
+	int ret = i2c_read_reg(&port->i2c->adap, 0x20, 0, &val);
+
+	if (!ret)
+		dev_info(dev, "[0x20]=0x%02x\n", val);
+	return ret ? 0 : 1;
+}
+
+static int port_has_cxd(struct ddb_port *port, u8 *type)
 {
 	u8 val;
-	return i2c_read_reg(&port->i2c->adap, 0x40, 0, &val) ? 0 : 1;
+	u8 probe[4] = { 0xe0, 0x00, 0x00, 0x00 }, data[4];
+	struct i2c_msg msgs[2] = {{ .addr = 0x40,  .flags = 0,
+				    .buf  = probe, .len   = 4 },
+				  { .addr = 0x40,  .flags = I2C_M_RD,
+				    .buf  = data,  .len   = 4 } };
+	val = i2c_transfer(&port->i2c->adap, msgs, 2);
+	if (val != 2)
+		return 0;
+
+	if (data[0] == 0x02 && data[1] == 0x2b && data[3] == 0x43)
+		*type = 2;
+	else
+		*type = 1;
+	return 1;
 }
 
 static int port_has_xo2(struct ddb_port *port, u8 *type, u8 *id)
 {
 	u8 probe[1] = { 0x00 }, data[4];
 
-	*type = DDB_XO2_TYPE_NONE;
-
 	if (i2c_io(&port->i2c->adap, 0x10, probe, 1, data, 4))
 		return 0;
 	if (data[0] == 'D' && data[1] == 'F') {
 		*id = data[2];
-		*type = DDB_XO2_TYPE_DUOFLEX;
+		*type = 1;
 		return 1;
 	}
 	if (data[0] == 'C' && data[1] == 'I') {
 		*id = data[2];
-		*type = DDB_XO2_TYPE_CI;
+		*type = 2;
 		return 1;
 	}
 	return 0;
@@ -1164,6 +1642,7 @@ static int port_has_xo2(struct ddb_port *port, u8 *type, u8 *id)
 static int port_has_stv0900(struct ddb_port *port)
 {
 	u8 val;
+
 	if (i2c_read_reg16(&port->i2c->adap, 0x69, 0xf100, &val) < 0)
 		return 0;
 	return 1;
@@ -1179,6 +1658,7 @@ static int port_has_stv0900_aa(struct ddb_port *port, u8 *id)
 static int port_has_drxks(struct ddb_port *port)
 {
 	u8 val;
+
 	if (i2c_read(&port->i2c->adap, 0x29, &val) < 0)
 		return 0;
 	if (i2c_read(&port->i2c->adap, 0x2a, &val) < 0)
@@ -1189,6 +1669,7 @@ static int port_has_drxks(struct ddb_port *port)
 static int port_has_stv0367(struct ddb_port *port)
 {
 	u8 val;
+
 	if (i2c_read_reg16(&port->i2c->adap, 0x1e, 0xf000, &val) < 0)
 		return 0;
 	if (val != 0x60)
@@ -1203,7 +1684,7 @@ static int port_has_stv0367(struct ddb_port *port)
 static int init_xo2(struct ddb_port *port)
 {
 	struct i2c_adapter *i2c = &port->i2c->adap;
-	struct device *dev = &port->dev->pdev->dev;
+	struct ddb *dev = port->dev;
 	u8 val, data[2];
 	int res;
 
@@ -1212,7 +1693,7 @@ static int init_xo2(struct ddb_port *port)
 		return res;
 
 	if (data[0] != 0x01)  {
-		dev_info(dev, "Port %d: invalid XO2\n", port->nr);
+		dev_info(dev->dev, "Port %d: invalid XO2\n", port->nr);
 		return -1;
 	}
 
@@ -1228,11 +1709,16 @@ static int init_xo2(struct ddb_port *port)
 	i2c_write_reg(i2c, 0x10, 0x08, 0x07);
 
 	/* speed: 0=55,1=75,2=90,3=104 MBit/s */
-	i2c_write_reg(i2c, 0x10, 0x09,
-		((xo2_speed >= 0 && xo2_speed <= 3) ? xo2_speed : 2));
+	i2c_write_reg(i2c, 0x10, 0x09, xo2_speed);
 
-	i2c_write_reg(i2c, 0x10, 0x0a, 0x01);
-	i2c_write_reg(i2c, 0x10, 0x0b, 0x01);
+	if (dev->link[port->lnr].info->con_clock) {
+		dev_info(dev->dev, "Setting continuous clock for XO2\n");
+		i2c_write_reg(i2c, 0x10, 0x0a, 0x03);
+		i2c_write_reg(i2c, 0x10, 0x0b, 0x03);
+	} else {
+		i2c_write_reg(i2c, 0x10, 0x0a, 0x01);
+		i2c_write_reg(i2c, 0x10, 0x0b, 0x01);
+	}
 
 	usleep_range(2000, 3000);
 	/* Start XO2 PLL */
@@ -1241,6 +1727,52 @@ static int init_xo2(struct ddb_port *port)
 	return 0;
 }
 
+static int init_xo2_ci(struct ddb_port *port)
+{
+	struct i2c_adapter *i2c = &port->i2c->adap;
+	struct ddb *dev = port->dev;
+	u8 val, data[2];
+	int res;
+
+	res = i2c_read_regs(i2c, 0x10, 0x04, data, 2);
+	if (res < 0)
+		return res;
+
+	if (data[0] > 1)  {
+		dev_info(dev->dev, "Port %d: invalid XO2 CI %02x\n",
+			port->nr, data[0]);
+		return -1;
+	}
+	dev_info(dev->dev, "Port %d: DuoFlex CI %u.%u\n",
+		port->nr, data[0], data[1]);
+
+	i2c_read_reg(i2c, 0x10, 0x08, &val);
+	if (val != 0) {
+		i2c_write_reg(i2c, 0x10, 0x08, 0x00);
+		msleep(100);
+	}
+	/* Enable both CI */
+	i2c_write_reg(i2c, 0x10, 0x08, 3);
+	usleep_range(2000, 3000);
+
+
+	/* speed: 0=55,1=75,2=90,3=104 MBit/s */
+	i2c_write_reg(i2c, 0x10, 0x09, 1);
+
+	i2c_write_reg(i2c, 0x10, 0x08, 0x83);
+	usleep_range(2000, 3000);
+
+	if (dev->link[port->lnr].info->con_clock) {
+		dev_info(dev->dev, "Setting continuous clock for DuoFlex CI\n");
+		i2c_write_reg(i2c, 0x10, 0x0a, 0x03);
+		i2c_write_reg(i2c, 0x10, 0x0b, 0x03);
+	} else {
+		i2c_write_reg(i2c, 0x10, 0x0a, 0x01);
+		i2c_write_reg(i2c, 0x10, 0x0b, 0x01);
+	}
+	return 0;
+}
+
 static int port_has_cxd28xx(struct ddb_port *port, u8 *id)
 {
 	struct i2c_adapter *i2c = &port->i2c->adap;
@@ -1255,140 +1787,453 @@ static int port_has_cxd28xx(struct ddb_port *port, u8 *id)
 	return 1;
 }
 
+static char *xo2names[] = {
+	"DUAL DVB-S2", "DUAL DVB-C/T/T2",
+	"DUAL DVB-ISDBT", "DUAL DVB-C/C2/T/T2",
+	"DUAL ATSC", "DUAL DVB-C/C2/T/T2,ISDB-T",
+	"", ""
+};
+
+static char *xo2types[] = {
+	"DVBS_ST", "DVBCT2_SONY",
+	"ISDBT_SONY", "DVBC2T2_SONY",
+	"ATSC_ST", "DVBC2T2I_SONY"
+};
+
 static void ddb_port_probe(struct ddb_port *port)
 {
 	struct ddb *dev = port->dev;
-	char *modname = "NO MODULE";
-	u8 xo2_type, xo2_id, cxd_id, stv_id;
+	u32 l = port->lnr;
+	u8 id, type;
 
+	port->name = "NO MODULE";
+	port->type_name = "NONE";
 	port->class = DDB_PORT_NONE;
 
-	if (port_has_ci(port)) {
-		modname = "CI";
+	/* Handle missing ports and ports without I2C */
+
+	if (port->nr == ts_loop) {
+		port->name = "TS LOOP";
+		port->class = DDB_PORT_LOOP;
+		return;
+	}
+
+	if (port->nr == 1 && dev->link[l].info->type == DDB_OCTOPUS_CI &&
+	    dev->link[l].info->i2c_mask == 1) {
+		port->name = "NO TAB";
+		port->class = DDB_PORT_NONE;
+		return;
+	}
+
+	if (port->nr > 1 && dev->link[l].info->type == DDB_OCTOPUS_CI) {
+		port->name = "CI internal";
+		port->type_name = "INTERNAL";
 		port->class = DDB_PORT_CI;
-		ddbwritel(I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
-	} else if (port_has_xo2(port, &xo2_type, &xo2_id)) {
-		dev_dbg(&dev->pdev->dev, "Port %d (TAB %d): XO2 type: %d, id: %d\n",
-			port->nr, port->nr+1, xo2_type, xo2_id);
+		port->type = DDB_CI_INTERNAL;
+	}
 
-		ddbwritel(I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
+	if (!port->i2c)
+		return;
 
-		switch (xo2_type) {
-		case DDB_XO2_TYPE_DUOFLEX:
+	/* Probe ports with I2C */
+
+	if (port_has_cxd(port, &id)) {
+		if (id == 1) {
+			port->name = "CI";
+			port->type_name = "CXD2099";
+			port->class = DDB_PORT_CI;
+			port->type = DDB_CI_EXTERNAL_SONY;
+			ddbwritel(dev, I2C_SPEED_400,
+				  port->i2c->regs + I2C_TIMING);
+		} else {
+			dev_info(dev->dev, "Port %d: Uninitialized DuoFlex\n",
+			       port->nr);
+			return;
+		}
+	} else if (port_has_xo2(port, &type, &id)) {
+		ddbwritel(dev, I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
+		/*dev_info(dev->dev, "XO2 ID %02x\n", id);*/
+		if (type == 2) {
+			port->name = "DuoFlex CI";
+			port->class = DDB_PORT_CI;
+			port->type = DDB_CI_EXTERNAL_XO2;
+			port->type_name = "CI_XO2";
+			init_xo2_ci(port);
+			return;
+		}
+		id >>= 2;
+		if (id > 5) {
+			port->name = "unknown XO2 DuoFlex";
+			port->type_name = "UNKNOWN";
+		} else {
+			port->name = xo2names[id];
+			port->class = DDB_PORT_TUNER;
+			port->type = DDB_TUNER_XO2 + id;
+			port->type_name = xo2types[id];
 			init_xo2(port);
-			switch (xo2_id >> 2) {
-			case 0:
-				modname = "DUAL DVB-S2";
-				port->class = DDB_PORT_TUNER;
-				port->type = DDB_TUNER_XO2_DVBS_STV0910;
-				break;
-			case 1:
-				modname = "DUAL DVB-C/T/T2";
-				port->class = DDB_PORT_TUNER;
-				port->type = DDB_TUNER_XO2_DVBCT2_SONY;
-				break;
-			case 2:
-				modname = "DUAL DVB-ISDBT";
-				port->class = DDB_PORT_TUNER;
-				port->type = DDB_TUNER_XO2_ISDBT_SONY;
-				break;
-			case 3:
-				modname = "DUAL DVB-C/C2/T/T2";
-				port->class = DDB_PORT_TUNER;
-				port->type = DDB_TUNER_XO2_DVBC2T2_SONY;
-				break;
-			case 4:
-				modname = "DUAL ATSC (unsupported)";
-				port->class = DDB_PORT_NONE;
-				port->type = DDB_TUNER_XO2_ATSC_ST;
-				break;
-			case 5:
-				modname = "DUAL DVB-C/C2/T/T2/ISDBT";
-				port->class = DDB_PORT_TUNER;
-				port->type = DDB_TUNER_XO2_DVBC2T2I_SONY;
-				break;
-			default:
-				modname = "Unknown XO2 DuoFlex module\n";
-				break;
-			}
-			break;
-		case DDB_XO2_TYPE_CI:
-			dev_info(&dev->pdev->dev, "DuoFlex CI modules not supported\n");
-			break;
-		default:
-			dev_info(&dev->pdev->dev, "Unknown XO2 DuoFlex module\n");
-			break;
 		}
-	} else if (port_has_cxd28xx(port, &cxd_id)) {
-		switch (cxd_id) {
+	} else if (port_has_cxd28xx(port, &id)) {
+		switch (id) {
 		case 0xa4:
-			modname = "DUAL DVB-C2T2 CXD2843";
-			port->class = DDB_PORT_TUNER;
+			port->name = "DUAL DVB-C2T2 CXD2843";
 			port->type = DDB_TUNER_DVBC2T2_SONY_P;
+			port->type_name = "DVBC2T2_SONY";
 			break;
 		case 0xb1:
-			modname = "DUAL DVB-CT2 CXD2837";
-			port->class = DDB_PORT_TUNER;
+			port->name = "DUAL DVB-CT2 CXD2837";
 			port->type = DDB_TUNER_DVBCT2_SONY_P;
+			port->type_name = "DVBCT2_SONY";
 			break;
 		case 0xb0:
-			modname = "DUAL ISDB-T CXD2838";
-			port->class = DDB_PORT_TUNER;
+			port->name = "DUAL ISDB-T CXD2838";
 			port->type = DDB_TUNER_ISDBT_SONY_P;
+			port->type_name = "ISDBT_SONY";
 			break;
 		case 0xc1:
-			modname = "DUAL DVB-C2T2 ISDB-T CXD2854";
-			port->class = DDB_PORT_TUNER;
+			port->name = "DUAL DVB-C2T2 ISDB-T CXD2854";
 			port->type = DDB_TUNER_DVBC2T2I_SONY_P;
+			port->type_name = "DVBC2T2I_ISDBT_SONY";
 			break;
 		default:
-			modname = "Unknown CXD28xx tuner";
-			break;
+			return;
 		}
-		ddbwritel(I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
+		port->class = DDB_PORT_TUNER;
+		ddbwritel(dev, I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
 	} else if (port_has_stv0900(port)) {
-		modname = "DUAL DVB-S2";
+		port->name = "DUAL DVB-S2";
 		port->class = DDB_PORT_TUNER;
 		port->type = DDB_TUNER_DVBS_ST;
-		ddbwritel(I2C_SPEED_100, port->i2c->regs + I2C_TIMING);
-	} else if (port_has_stv0900_aa(port, &stv_id)) {
-		modname = "DUAL DVB-S2";
+		port->type_name = "DVBS_ST";
+		ddbwritel(dev, I2C_SPEED_100, port->i2c->regs + I2C_TIMING);
+	} else if (port_has_stv0900_aa(port, &id)) {
+		port->name = "DUAL DVB-S2";
 		port->class = DDB_PORT_TUNER;
-		switch (stv_id) {
-		case 0x51:
-			if (dev->info->ts_quirks & TS_QUIRK_REVERSED &&
-					port->nr == 0)
+		if (id == 0x51) {
+			if (port->nr == 0 &&
+			    dev->link[l].info->ts_quirks & TS_QUIRK_REVERSED)
 				port->type = DDB_TUNER_DVBS_STV0910_PR;
 			else
 				port->type = DDB_TUNER_DVBS_STV0910_P;
-			break;
-		default:
+			port->type_name = "DVBS_ST_0910";
+		} else {
 			port->type = DDB_TUNER_DVBS_ST_AA;
-			break;
+			port->type_name = "DVBS_ST_AA";
 		}
-		ddbwritel(I2C_SPEED_100, port->i2c->regs + I2C_TIMING);
+		ddbwritel(dev, I2C_SPEED_100, port->i2c->regs + I2C_TIMING);
 	} else if (port_has_drxks(port)) {
-		modname = "DUAL DVB-C/T";
+		port->name = "DUAL DVB-C/T";
 		port->class = DDB_PORT_TUNER;
 		port->type = DDB_TUNER_DVBCT_TR;
-		ddbwritel(I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
+		port->type_name = "DVBCT_TR";
+		ddbwritel(dev, I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
 	} else if (port_has_stv0367(port)) {
-		modname = "DUAL DVB-C/T";
+		port->name = "DUAL DVB-C/T";
 		port->class = DDB_PORT_TUNER;
 		port->type = DDB_TUNER_DVBCT_ST;
-		ddbwritel(I2C_SPEED_100, port->i2c->regs + I2C_TIMING);
+		port->type_name = "DVBCT_ST";
+		ddbwritel(dev, I2C_SPEED_100, port->i2c->regs + I2C_TIMING);
+	} else if (port_has_encti(port)) {
+		port->name = "ENCTI";
+		port->class = DDB_PORT_LOOP;
 	}
+}
+
+
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+
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
+
+static int read_attribute_mem(struct dvb_ca_en50221 *ca,
+			      int slot, int address)
+{
+	struct ddb_ci *ci = ca->data;
+	u32 val, off = (address >> 1) & (CI_BUFFER_SIZE - 1);
+
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
+	return 0xff & res;
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
 
-	dev_info(&dev->pdev->dev, "Port %d (TAB %d): %s\n",
-			 port->nr, port->nr+1, modname);
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
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+
+static int write_creg(struct ddb_ci *ci, u8 data, u8 mask)
+{
+	struct i2c_adapter *i2c = &ci->port->i2c->adap;
+	u8 adr = (ci->port->type == DDB_CI_EXTERNAL_XO2) ? 0x12 : 0x13;
+
+	ci->port->creg = (ci->port->creg & ~mask) | data;
+	return i2c_write_reg(i2c, adr, 0x02, ci->port->creg);
+}
+
+static int read_attribute_mem_xo2(struct dvb_ca_en50221 *ca,
+				  int slot, int address)
+{
+	struct ddb_ci *ci = ca->data;
+	struct i2c_adapter *i2c = &ci->port->i2c->adap;
+	u8 adr = (ci->port->type == DDB_CI_EXTERNAL_XO2) ? 0x12 : 0x13;
+	int res;
+	u8 val;
+
+	res = i2c_read_reg16(i2c, adr, 0x8000 | address, &val);
+	return res ? res : val;
+}
+
+static int write_attribute_mem_xo2(struct dvb_ca_en50221 *ca, int slot,
+				   int address, u8 value)
+{
+	struct ddb_ci *ci = ca->data;
+	struct i2c_adapter *i2c = &ci->port->i2c->adap;
+	u8 adr = (ci->port->type == DDB_CI_EXTERNAL_XO2) ? 0x12 : 0x13;
+
+	return i2c_write_reg16(i2c, adr, 0x8000 | address, value);
+}
+
+static int read_cam_control_xo2(struct dvb_ca_en50221 *ca,
+				int slot, u8 address)
+{
+	struct ddb_ci *ci = ca->data;
+	struct i2c_adapter *i2c = &ci->port->i2c->adap;
+	u8 adr = (ci->port->type == DDB_CI_EXTERNAL_XO2) ? 0x12 : 0x13;
+	u8 val;
+	int res;
+
+	res = i2c_read_reg(i2c, adr, 0x20 | (address & 3), &val);
+	return res ? res : val;
+}
+
+static int write_cam_control_xo2(struct dvb_ca_en50221 *ca, int slot,
+				 u8 address, u8 value)
+{
+	struct ddb_ci *ci = ca->data;
+	struct i2c_adapter *i2c = &ci->port->i2c->adap;
+	u8 adr = (ci->port->type == DDB_CI_EXTERNAL_XO2) ? 0x12 : 0x13;
+
+	return i2c_write_reg(i2c, adr, 0x20 | (address & 3), value);
+}
+
+static int slot_reset_xo2(struct dvb_ca_en50221 *ca, int slot)
+{
+	struct ddb_ci *ci = ca->data;
+
+	dev_dbg(ci->port->dev->dev, "%s\n", __func__);
+	write_creg(ci, 0x01, 0x01);
+	write_creg(ci, 0x04, 0x04);
+	msleep(20);
+	write_creg(ci, 0x02, 0x02);
+	write_creg(ci, 0x00, 0x04);
+	write_creg(ci, 0x18, 0x18);
+	return 0;
+}
+
+static int slot_shutdown_xo2(struct dvb_ca_en50221 *ca, int slot)
+{
+	struct ddb_ci *ci = ca->data;
+
+	dev_dbg(ci->port->dev->dev, "%s\n", __func__);
+	write_creg(ci, 0x10, 0xff);
+	write_creg(ci, 0x08, 0x08);
+	return 0;
+}
+
+static int slot_ts_enable_xo2(struct dvb_ca_en50221 *ca, int slot)
+{
+	struct ddb_ci *ci = ca->data;
+
+	dev_info(ci->port->dev->dev, "%s\n", __func__);
+	write_creg(ci, 0x00, 0x10);
+	return 0;
+}
+
+static int poll_slot_status_xo2(struct dvb_ca_en50221 *ca, int slot, int open)
+{
+	struct ddb_ci *ci = ca->data;
+	struct i2c_adapter *i2c = &ci->port->i2c->adap;
+	u8 adr = (ci->port->type == DDB_CI_EXTERNAL_XO2) ? 0x12 : 0x13;
+	u8 val = 0;
+	int stat = 0;
+
+	i2c_read_reg(i2c, adr, 0x01, &val);
+
+	if (val & 2)
+		stat |= DVB_CA_EN50221_POLL_CAM_PRESENT;
+	if (val & 1)
+		stat |= DVB_CA_EN50221_POLL_CAM_READY;
+	return stat;
+}
+
+static struct dvb_ca_en50221 en_xo2_templ = {
+	.read_attribute_mem  = read_attribute_mem_xo2,
+	.write_attribute_mem = write_attribute_mem_xo2,
+	.read_cam_control    = read_cam_control_xo2,
+	.write_cam_control   = write_cam_control_xo2,
+	.slot_reset          = slot_reset_xo2,
+	.slot_shutdown       = slot_shutdown_xo2,
+	.slot_ts_enable      = slot_ts_enable_xo2,
+	.poll_slot_status    = poll_slot_status_xo2,
+};
+
+static void ci_xo2_attach(struct ddb_port *port)
+{
+	struct ddb_ci *ci;
+
+	ci = kzalloc(sizeof(*ci), GFP_KERNEL);
+	if (!ci)
+		return;
+	memcpy(&ci->en, &en_xo2_templ, sizeof(en_xo2_templ));
+	ci->en.data = ci;
+	port->en = &ci->en;
+	ci->port = port;
+	ci->nr = port->nr - 2;
+	ci->port->creg = 0;
+	write_creg(ci, 0x10, 0xff);
+	write_creg(ci, 0x08, 0x08);
 }
 
 /****************************************************************************/
 /****************************************************************************/
 /****************************************************************************/
 
-static struct cxd2099_cfg cxd_cfg = {
-	.bitrate =  62000,
+struct cxd2099_cfg cxd_cfg = {
+	.bitrate =  72000,
 	.adr     =  0x40,
 	.polarity = 1,
 	.clock_mode = 1,
@@ -1397,33 +2242,36 @@ static struct cxd2099_cfg cxd_cfg = {
 
 static int ddb_ci_attach(struct ddb_port *port)
 {
-	int ret;
+	switch (port->type) {
+	case DDB_CI_EXTERNAL_SONY:
+		cxd_cfg.bitrate = ci_bitrate;
+		port->en = cxd2099_attach(&cxd_cfg, port, &port->i2c->adap);
+		if (!port->en)
+			return -ENODEV;
+		dvb_ca_en50221_init(port->dvb[0].adap,
+				    port->en, 0, 1);
+		break;
 
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
+	case DDB_CI_EXTERNAL_XO2:
+	case DDB_CI_EXTERNAL_XO2_B:
+		ci_xo2_attach(port);
+		if (!port->en)
+			return -ENODEV;
+		dvb_ca_en50221_init(port->dvb[0].adap, port->en, 0, 1);
+		break;
+
+	case DDB_CI_INTERNAL:
+		ci_attach(port);
+		if (!port->en)
+			return -ENODEV;
+		dvb_ca_en50221_init(port->dvb[0].adap, port->en, 0, 1);
+		break;
 	}
-	ddb_input_start(port->input[0]);
-	ddb_output_start(port->output);
-	dvb_ca_en50221_init(&port->output->adap,
-			    port->en, 0, 1);
-	ret = dvb_register_device(&port->output->adap, &port->output->dev,
-				  &dvbdev_ci, (void *) port->output,
-				  DVB_DEVICE_SEC, 0);
-	return ret;
+	return 0;
 }
 
 static int ddb_port_attach(struct ddb_port *port)
 {
-	struct device *dev = &port->dev->pdev->dev;
 	int ret = 0;
 
 	switch (port->class) {
@@ -1432,15 +2280,27 @@ static int ddb_port_attach(struct ddb_port *port)
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
+					  DVB_DEVICE_SEC, 0);
 		break;
 	default:
 		break;
 	}
 	if (ret < 0)
-		dev_err(dev, "port_attach on port %d failed\n", port->nr);
+		dev_err(port->dev->dev, "port_attach on port %d failed\n",
+			port->nr);
 	return ret;
 }
 
@@ -1449,11 +2309,16 @@ int ddb_ports_attach(struct ddb *dev)
 	int i, ret = 0;
 	struct ddb_port *port;
 
-	for (i = 0; i < dev->info->port_num; i++) {
+	if (dev->port_num) {
+		ret = dvb_register_adapters(dev);
+		if (ret < 0) {
+			dev_err(dev->dev, "Registering adapters failed. Check DVB_MAX_ADAPTERS in config.\n");
+			return ret;
+		}
+	}
+	for (i = 0; i < dev->port_num; i++) {
 		port = &dev->port[i];
 		ret = ddb_port_attach(port);
-		if (ret < 0)
-			break;
 	}
 	return ret;
 }
@@ -1463,132 +2328,346 @@ void ddb_ports_detach(struct ddb *dev)
 	int i;
 	struct ddb_port *port;
 
-	for (i = 0; i < dev->info->port_num; i++) {
+	for (i = 0; i < dev->port_num; i++) {
 		port = &dev->port[i];
+
 		switch (port->class) {
 		case DDB_PORT_TUNER:
 			dvb_input_detach(port->input[0]);
 			dvb_input_detach(port->input[1]);
 			break;
 		case DDB_PORT_CI:
-			dvb_unregister_device(port->output->dev);
+		case DDB_PORT_LOOP:
+			if (port->dvb[0].dev)
+				dvb_unregister_device(port->dvb[0].dev);
 			if (port->en) {
-				ddb_input_stop(port->input[0]);
-				ddb_output_stop(port->output);
 				dvb_ca_en50221_release(port->en);
 				kfree(port->en);
 				port->en = NULL;
-				dvb_unregister_adapter(&port->output->adap);
 			}
 			break;
 		}
 	}
+	dvb_unregister_adapters(dev);
+}
+
+
+/* Copy input DMA pointers to output DMA and ACK. */
+
+static void input_write_output(struct ddb_input *input,
+			       struct ddb_output *output)
+{
+	ddbwritel(output->port->dev,
+		  input->dma->stat, DMA_BUFFER_ACK(output->dma));
+	output->dma->cbuf = (input->dma->stat >> 11) & 0x1f;
+	output->dma->coff = (input->dma->stat & 0x7ff) << 7;
 }
 
-static void input_tasklet(unsigned long data)
+static void output_ack_input(struct ddb_output *output,
+			     struct ddb_input *input)
 {
-	struct ddb_input *input = (struct ddb_input *) data;
+	ddbwritel(input->port->dev,
+		  output->dma->stat, DMA_BUFFER_ACK(input->dma));
+}
+
+static void input_write_dvb(struct ddb_input *input,
+			    struct ddb_input *input2)
+{
+	struct ddb_dvb *dvb = &input2->port->dvb[input2->nr & 1];
+	struct ddb_dma *dma, *dma2;
 	struct ddb *dev = input->port->dev;
+	int ack = 1;
 
-	spin_lock(&input->lock);
-	if (!input->running) {
-		spin_unlock(&input->lock);
-		return;
+	dma = dma2 = input->dma;
+	/* if there also is an output connected, do not ACK.
+	 * input_write_output will ACK.
+	 */
+	if (input->redo) {
+		dma2 = input->redo->dma;
+		ack = 0;
+	}
+	while (dma->cbuf != ((dma->stat >> 11) & 0x1f)
+	       || (4 & dma->ctrl)) {
+		if (4 & dma->ctrl) {
+			/* dev_err(dev->dev, "Overflow dma %d\n", dma->nr); */
+			ack = 1;
+		}
+		if (alt_dma)
+			dma_sync_single_for_cpu(dev->dev, dma2->pbuf[dma->cbuf],
+						dma2->size, DMA_FROM_DEVICE);
+		dvb_dmx_swfilter_packets(&dvb->demux,
+					 dma2->vbuf[dma->cbuf],
+					 dma2->size / 188);
+		dma->cbuf = (dma->cbuf + 1) % dma2->num;
+		if (ack)
+			ddbwritel(dev, (dma->cbuf << 11),
+				  DMA_BUFFER_ACK(dma));
+		dma->stat = safe_ddbreadl(dev, DMA_BUFFER_CURRENT(dma));
+		dma->ctrl = safe_ddbreadl(dev, DMA_BUFFER_CONTROL(dma));
 	}
-	input->stat = ddbreadl(DMA_BUFFER_CURRENT(input->nr));
+}
 
-	if (input->port->class == DDB_PORT_TUNER) {
-		if (4&ddbreadl(DMA_BUFFER_CONTROL(input->nr)))
-			dev_err(&dev->pdev->dev, "Overflow input %d\n", input->nr);
-		while (input->cbuf != ((input->stat >> 11) & 0x1f)
-		       || (4 & safe_ddbreadl(dev, DMA_BUFFER_CONTROL(input->nr)))) {
-			dvb_dmx_swfilter_packets(&input->demux,
-						 input->vbuf[input->cbuf],
-						 input->dma_buf_size / 188);
+static void input_work(struct work_struct *work)
+{
+	struct ddb_dma *dma = container_of(work, struct ddb_dma, work);
+	struct ddb_input *input = (struct ddb_input *) dma->io;
+	struct ddb *dev = input->port->dev;
+	unsigned long flags;
 
-			input->cbuf = (input->cbuf + 1) % input->dma_buf_num;
-			ddbwritel((input->cbuf << 11),
-				  DMA_BUFFER_ACK(input->nr));
-			input->stat = ddbreadl(DMA_BUFFER_CURRENT(input->nr));
-		       }
+	spin_lock_irqsave(&dma->lock, flags);
+	if (!dma->running) {
+		spin_unlock_irqrestore(&dma->lock, flags);
+		return;
 	}
-	if (input->port->class == DDB_PORT_CI)
-		wake_up(&input->wq);
-	spin_unlock(&input->lock);
+	dma->stat = ddbreadl(dev, DMA_BUFFER_CURRENT(dma));
+	dma->ctrl = ddbreadl(dev, DMA_BUFFER_CONTROL(dma));
+
+	if (input->redi)
+		input_write_dvb(input, input->redi);
+	if (input->redo)
+		input_write_output(input, input->redo);
+	wake_up(&dma->wq);
+	spin_unlock_irqrestore(&dma->lock, flags);
+}
+
+static void input_handler(unsigned long data)
+{
+	struct ddb_input *input = (struct ddb_input *) data;
+	struct ddb_dma *dma = input->dma;
+
+
+	/* If there is no input connected, input_tasklet() will
+	 * just copy pointers and ACK. So, there is no need to go
+	 * through the tasklet scheduler.
+	 */
+	if (input->redi)
+		queue_work(ddb_wq, &dma->work);
+	else
+		input_work(&dma->work);
 }
 
-static void output_tasklet(unsigned long data)
+static void output_handler(unsigned long data)
 {
 	struct ddb_output *output = (struct ddb_output *) data;
+	struct ddb_dma *dma = output->dma;
 	struct ddb *dev = output->port->dev;
 
-	spin_lock(&output->lock);
-	if (!output->running) {
-		spin_unlock(&output->lock);
+	spin_lock(&dma->lock);
+	if (!dma->running) {
+		spin_unlock(&dma->lock);
 		return;
 	}
-	output->stat = ddbreadl(DMA_BUFFER_CURRENT(output->nr + 8));
-	wake_up(&output->wq);
-	spin_unlock(&output->lock);
+	dma->stat = ddbreadl(dev, DMA_BUFFER_CURRENT(dma));
+	dma->ctrl = ddbreadl(dev, DMA_BUFFER_CONTROL(dma));
+	if (output->redi)
+		output_ack_input(output, output->redi);
+	wake_up(&dma->wq);
+	spin_unlock(&dma->lock);
 }
 
 /****************************************************************************/
 /****************************************************************************/
 
-static void ddb_input_init(struct ddb_port *port, int nr)
+static struct ddb_regmap *io_regmap(struct ddb_io *io, int link)
+{
+	struct ddb_info *info;
+
+	if (link)
+		info = io->port->dev->link[io->port->lnr].info;
+	else
+		info = io->port->dev->link[0].info;
+
+	if (!info)
+		return NULL;
+
+	return info->regmap;
+}
+
+static void ddb_dma_init(struct ddb_io *io, int nr, int out)
+{
+	struct ddb_dma *dma;
+	struct ddb_regmap *rm = io_regmap(io, 0);
+
+	dma = out ? &io->port->dev->odma[nr] : &io->port->dev->idma[nr];
+	io->dma = dma;
+	dma->io = io;
+
+	spin_lock_init(&dma->lock);
+	init_waitqueue_head(&dma->wq);
+	if (out) {
+		dma->regs = rm->odma->base + rm->odma->size * nr;
+		dma->bufregs = rm->odma_buf->base + rm->odma_buf->size * nr;
+		dma->num = OUTPUT_DMA_BUFS;
+		dma->size = OUTPUT_DMA_SIZE;
+		dma->div = OUTPUT_DMA_IRQ_DIV;
+	} else {
+		INIT_WORK(&dma->work, input_work);
+		dma->regs = rm->idma->base + rm->idma->size * nr;
+		dma->bufregs = rm->idma_buf->base + rm->idma_buf->size * nr;
+		dma->num = INPUT_DMA_BUFS;
+		dma->size = INPUT_DMA_SIZE;
+		dma->div = INPUT_DMA_IRQ_DIV;
+	}
+	ddbwritel(io->port->dev, 0, DMA_BUFFER_ACK(dma));
+	dev_dbg(io->port->dev->dev, "init link %u, io %u, dma %u, dmaregs %08x bufregs %08x\n",
+		io->port->lnr, io->nr, nr, dma->regs, dma->bufregs);
+}
+
+static void ddb_input_init(struct ddb_port *port, int nr, int pnr, int anr)
 {
 	struct ddb *dev = port->dev;
-	struct ddb_input *input = &dev->input[nr];
+	struct ddb_input *input = &dev->input[anr];
+	struct ddb_regmap *rm;
 
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
+	rm = io_regmap(input, 1);
+	input->regs = DDB_LINK_TAG(port->lnr) |
+		(rm->input->base + rm->input->size * nr);
+	dev_dbg(dev->dev, "init link %u, input %u, regs %08x\n",
+		port->lnr, nr, input->regs);
+
+	if (dev->has_dma) {
+		struct ddb_regmap *rm0 = io_regmap(input, 0);
+		u32 base = rm0->irq_base_idma;
+		u32 dma_nr = nr;
+
+		if (port->lnr)
+			dma_nr += 32 + (port->lnr - 1) * 8;
+
+		dev_dbg(dev->dev, "init link %u, input %u, handler %u\n",
+			 port->lnr, nr, dma_nr + base);
+
+		dev->handler[0][dma_nr + base] = input_handler;
+		dev->handler_data[0][dma_nr + base] = (unsigned long) input;
+		ddb_dma_init(input, dma_nr, 0);
+	}
 }
 
 static void ddb_output_init(struct ddb_port *port, int nr)
 {
 	struct ddb *dev = port->dev;
 	struct ddb_output *output = &dev->output[nr];
+	struct ddb_regmap *rm;
+
+	port->output = output;
 	output->nr = nr;
 	output->port = port;
-	output->dma_buf_num = OUTPUT_DMA_BUFS;
-	output->dma_buf_size = OUTPUT_DMA_SIZE;
+	rm = io_regmap(output, 1);
+	output->regs = DDB_LINK_TAG(port->lnr) |
+		(rm->output->base + rm->output->size * nr);
+
+	dev_dbg(dev->dev, "init link %u, output %u, regs %08x\n",
+		 port->lnr, nr, output->regs);
 
-	ddbwritel(0, TS_OUTPUT_CONTROL(nr));
-	ddbwritel(2, TS_OUTPUT_CONTROL(nr));
-	ddbwritel(0, TS_OUTPUT_CONTROL(nr));
-	tasklet_init(&output->tasklet, output_tasklet, (unsigned long) output);
-	init_waitqueue_head(&output->wq);
+	if (dev->has_dma) {
+		struct ddb_regmap *rm0 = io_regmap(output, 0);
+		u32 base = rm0->irq_base_odma;
+
+		dev->handler[0][nr + base] = output_handler;
+		dev->handler_data[0][nr + base] = (unsigned long) output;
+		ddb_dma_init(output, nr, 1);
+	}
+}
+
+static int ddb_port_match_i2c(struct ddb_port *port)
+{
+	struct ddb *dev = port->dev;
+	u32 i;
+
+	for (i = 0; i < dev->i2c_num; i++) {
+		if (dev->i2c[i].link == port->lnr &&
+		    dev->i2c[i].nr == port->nr) {
+			port->i2c = &dev->i2c[i];
+			return 1;
+		}
+	}
+	return 0;
 }
 
 void ddb_ports_init(struct ddb *dev)
 {
-	int i;
+	u32 i, l, p;
 	struct ddb_port *port;
+	struct ddb_info *info;
+	struct ddb_regmap *rm;
+
+	for (p = l = 0; l < DDB_MAX_LINK; l++) {
+		info = dev->link[l].info;
+		if (!info)
+			continue;
+		rm = info->regmap;
+		if (!rm)
+			continue;
+		for (i = 0; i < info->port_num; i++, p++) {
+			port = &dev->port[p];
+			port->dev = dev;
+			port->nr = i;
+			port->lnr = l;
+			port->pnr = p;
+			port->gap = 0xffffffff;
+			port->obr = ci_bitrate;
+			mutex_init(&port->i2c_gate_lock);
+
+			ddb_port_match_i2c(port);
+			ddb_port_probe(port);
+
+			port->dvb[0].adap = &dev->adap[2 * p];
+			port->dvb[1].adap = &dev->adap[2 * p + 1];
+
+			if ((port->class == DDB_PORT_NONE) && i &&
+			    dev->port[p - 1].type == DDB_CI_EXTERNAL_XO2) {
+				port->class = DDB_PORT_CI;
+				port->type = DDB_CI_EXTERNAL_XO2_B;
+				port->name = "DuoFlex CI_B";
+				port->i2c = dev->port[p - 1].i2c;
+			}
 
-	for (i = 0; i < dev->info->port_num; i++) {
-		port = &dev->port[i];
-		port->dev = dev;
-		port->nr = i;
-		port->i2c = &dev->i2c[i];
-		port->input[0] = &dev->input[2 * i];
-		port->input[1] = &dev->input[2 * i + 1];
-		port->output = &dev->output[i];
+			dev_info(dev->dev, "Port %u: Link %u, Link Port %u (TAB %u): %s\n",
+				port->pnr, port->lnr, port->nr, port->nr + 1,
+				port->name);
 
-		mutex_init(&port->i2c_gate_lock);
-		ddb_port_probe(port);
-		ddb_input_init(port, 2 * i);
-		ddb_input_init(port, 2 * i + 1);
-		ddb_output_init(port, i);
+			if (port->class == DDB_PORT_CI &&
+			    port->type == DDB_CI_EXTERNAL_XO2) {
+				ddb_input_init(port, 2 * i, 0, 2 * i);
+				ddb_output_init(port, i);
+				continue;
+			}
+
+			if (port->class == DDB_PORT_CI &&
+			    port->type == DDB_CI_EXTERNAL_XO2_B) {
+				ddb_input_init(port, 2 * i - 1, 0, 2 * i - 1);
+				ddb_output_init(port, i);
+				continue;
+			}
+
+			if (port->class == DDB_PORT_NONE)
+				continue;
+
+			switch (dev->link[l].info->type) {
+			case DDB_OCTOPUS_CI:
+				if (i >= 2) {
+					ddb_input_init(port, 2 + i, 0, 2 + i);
+					ddb_input_init(port, 4 + i, 1, 4 + i);
+					ddb_output_init(port, i);
+					break;
+				} /* fallthrough */
+			case DDB_OCTOPUS:
+				ddb_input_init(port, 2 * i, 0, 2 * i);
+				ddb_input_init(port, 2 * i + 1, 1, 2 * i + 1);
+				ddb_output_init(port, i);
+				break;
+			case DDB_OCTOPUS_MAX_CT:
+				ddb_input_init(port, 2 * i, 0, 2 * p);
+				ddb_input_init(port, 2 * i + 1, 1, 2 * p + 1);
+				break;
+			default:
+				break;
+			}
+		}
 	}
+	dev->port_num = p;
 }
 
 void ddb_ports_release(struct ddb *dev)
@@ -1596,12 +2675,14 @@ void ddb_ports_release(struct ddb *dev)
 	int i;
 	struct ddb_port *port;
 
-	for (i = 0; i < dev->info->port_num; i++) {
+	for (i = 0; i < dev->port_num; i++) {
 		port = &dev->port[i];
-		port->dev = dev;
-		tasklet_kill(&port->input[0]->tasklet);
-		tasklet_kill(&port->input[1]->tasklet);
-		tasklet_kill(&port->output->tasklet);
+		if (port->input[0] && port->input[0]->dma)
+			cancel_work_sync(&port->input[0]->dma->work);
+		if (port->input[1] && port->input[1]->dma)
+			cancel_work_sync(&port->input[1]->dma->work);
+		if (port->output && port->output->dma)
+			cancel_work_sync(&port->output->dma->work);
 	}
 }
 
@@ -1609,90 +2690,158 @@ void ddb_ports_release(struct ddb *dev)
 /****************************************************************************/
 /****************************************************************************/
 
-static void irq_handle_i2c(struct ddb *dev, int n)
+#define IRQ_HANDLE(_nr) \
+	do { if ((s & (1UL << ((_nr) & 0x1f))) && dev->handler[0][_nr]) \
+		dev->handler[0][_nr](dev->handler_data[0][_nr]); } \
+	while (0)
+
+static void irq_handle_msg(struct ddb *dev, u32 s)
 {
-	struct ddb_i2c *i2c = &dev->i2c[n];
+	dev->i2c_irq++;
+	IRQ_HANDLE(0);
+	IRQ_HANDLE(1);
+	IRQ_HANDLE(2);
+	IRQ_HANDLE(3);
+}
 
-	i2c->done = 1;
-	wake_up(&i2c->wq);
+static void irq_handle_io(struct ddb *dev, u32 s)
+{
+	dev->ts_irq++;
+	if ((s & 0x000000f0)) {
+		IRQ_HANDLE(4);
+		IRQ_HANDLE(5);
+		IRQ_HANDLE(6);
+		IRQ_HANDLE(7);
+	}
+	if ((s & 0x0000ff00)) {
+		IRQ_HANDLE(8);
+		IRQ_HANDLE(9);
+		IRQ_HANDLE(10);
+		IRQ_HANDLE(11);
+		IRQ_HANDLE(12);
+		IRQ_HANDLE(13);
+		IRQ_HANDLE(14);
+		IRQ_HANDLE(15);
+	}
+	if ((s & 0x00ff0000)) {
+		IRQ_HANDLE(16);
+		IRQ_HANDLE(17);
+		IRQ_HANDLE(18);
+		IRQ_HANDLE(19);
+		IRQ_HANDLE(20);
+		IRQ_HANDLE(21);
+		IRQ_HANDLE(22);
+		IRQ_HANDLE(23);
+	}
+	if ((s & 0xff000000)) {
+		IRQ_HANDLE(24);
+		IRQ_HANDLE(25);
+		IRQ_HANDLE(26);
+		IRQ_HANDLE(27);
+		IRQ_HANDLE(28);
+		IRQ_HANDLE(29);
+		IRQ_HANDLE(30);
+		IRQ_HANDLE(31);
+	}
 }
 
-irqreturn_t irq_handler(int irq, void *dev_id)
+irqreturn_t ddb_irq_handler0(int irq, void *dev_id)
 {
 	struct ddb *dev = (struct ddb *) dev_id;
-	u32 s = ddbreadl(INTERRUPT_STATUS);
+	u32 s = ddbreadl(dev, INTERRUPT_STATUS);
 
-	if (!s)
-		return IRQ_NONE;
+	do {
+		if (s & 0x80000000)
+			return IRQ_NONE;
+		if (!(s & 0xfffff00))
+			return IRQ_NONE;
+		ddbwritel(dev, s & 0xfffff00, INTERRUPT_ACK);
+		irq_handle_io(dev, s);
+	} while ((s = ddbreadl(dev, INTERRUPT_STATUS)));
+
+	return IRQ_HANDLED;
+}
+
+irqreturn_t ddb_irq_handler1(int irq, void *dev_id)
+{
+	struct ddb *dev = (struct ddb *) dev_id;
+	u32 s = ddbreadl(dev, INTERRUPT_STATUS);
 
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
+		if (s & 0x80000000)
+			return IRQ_NONE;
+		if (!(s & 0x0000f))
+			return IRQ_NONE;
+		ddbwritel(dev, s & 0x0000f, INTERRUPT_ACK);
+		irq_handle_msg(dev, s);
+	} while ((s = ddbreadl(dev, INTERRUPT_STATUS)));
 
 	return IRQ_HANDLED;
 }
 
-/******************************************************************************/
-/******************************************************************************/
-/******************************************************************************/
+irqreturn_t ddb_irq_handler(int irq, void *dev_id)
+{
+	struct ddb *dev = (struct ddb *) dev_id;
+	u32 s = ddbreadl(dev, INTERRUPT_STATUS);
+	int ret = IRQ_HANDLED;
+
+	if (!s)
+		return IRQ_NONE;
+	do {
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
+}
+
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
 
-static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
+static int reg_wait(struct ddb *dev, u32 reg, u32 bit)
+{
+	u32 count = 0;
+
+	while (safe_ddbreadl(dev, reg) & bit) {
+		ndelay(10);
+		if (++count == 100)
+			return -1;
+	}
+	return 0;
+}
+
+static int flashio(struct ddb *dev, u32 lnr, u8 *wbuf, u32 wlen, u8 *rbuf,
+	u32 rlen)
 {
 	u32 data, shift;
+	u32 tag = DDB_LINK_TAG(lnr);
+	struct ddb_link *link = &dev->link[lnr];
 
+	mutex_lock(&link->flash_mutex);
 	if (wlen > 4)
-		ddbwritel(1, SPI_CONTROL);
+		ddbwritel(dev, 1, tag | SPI_CONTROL);
 	while (wlen > 4) {
 		/* FIXME: check for big-endian */
-		data = swab32(*(u32 *)wbuf);
+		data = swab32(*(u32 *) wbuf);
 		wbuf += 4;
 		wlen -= 4;
-		ddbwritel(data, SPI_DATA);
-		while (safe_ddbreadl(dev, SPI_CONTROL) & 0x0004)
-			;
+		ddbwritel(dev, data, tag | SPI_DATA);
+		if (reg_wait(dev, tag | SPI_CONTROL, 4))
+			goto fail;
 	}
-
 	if (rlen)
-		ddbwritel(0x0001 | ((wlen << (8 + 3)) & 0x1f00), SPI_CONTROL);
+		ddbwritel(dev, 0x0001 | ((wlen << (8 + 3)) & 0x1f00),
+			  tag | SPI_CONTROL);
 	else
-		ddbwritel(0x0003 | ((wlen << (8 + 3)) & 0x1f00), SPI_CONTROL);
+		ddbwritel(dev, 0x0003 | ((wlen << (8 + 3)) & 0x1f00),
+			  tag | SPI_CONTROL);
 
 	data = 0;
 	shift = ((4 - wlen) * 8);
@@ -1704,33 +2853,34 @@ static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
 	}
 	if (shift)
 		data <<= shift;
-	ddbwritel(data, SPI_DATA);
-	while (safe_ddbreadl(dev, SPI_CONTROL) & 0x0004)
-		;
+	ddbwritel(dev, data, tag | SPI_DATA);
+	if (reg_wait(dev, tag | SPI_CONTROL, 4))
+		goto fail;
 
 	if (!rlen) {
-		ddbwritel(0, SPI_CONTROL);
-		return 0;
+		ddbwritel(dev, 0, tag | SPI_CONTROL);
+		goto exit;
 	}
 	if (rlen > 4)
-		ddbwritel(1, SPI_CONTROL);
+		ddbwritel(dev, 1, tag | SPI_CONTROL);
 
 	while (rlen > 4) {
-		ddbwritel(0xffffffff, SPI_DATA);
-		while (safe_ddbreadl(dev, SPI_CONTROL) & 0x0004)
-			;
-		data = ddbreadl(SPI_DATA);
+		ddbwritel(dev, 0xffffffff, tag | SPI_DATA);
+		if (reg_wait(dev, tag | SPI_CONTROL, 4))
+			goto fail;
+		data = ddbreadl(dev, tag | SPI_DATA);
 		*(u32 *) rbuf = swab32(data);
 		rbuf += 4;
 		rlen -= 4;
 	}
-	ddbwritel(0x0003 | ((rlen << (8 + 3)) & 0x1F00), SPI_CONTROL);
-	ddbwritel(0xffffffff, SPI_DATA);
-	while (safe_ddbreadl(dev, SPI_CONTROL) & 0x0004)
-		;
+	ddbwritel(dev, 0x0003 | ((rlen << (8 + 3)) & 0x1F00),
+		tag | SPI_CONTROL);
+	ddbwritel(dev, 0xffffffff, tag | SPI_DATA);
+	if (reg_wait(dev, tag | SPI_CONTROL, 4))
+		goto fail;
 
-	data = ddbreadl(SPI_DATA);
-	ddbwritel(0, SPI_CONTROL);
+	data = ddbreadl(dev, tag | SPI_DATA);
+	ddbwritel(dev, 0, tag | SPI_CONTROL);
 
 	if (rlen < 4)
 		data <<= ((4 - rlen) * 8);
@@ -1741,31 +2891,47 @@ static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
 		rbuf++;
 		rlen--;
 	}
+exit:
+	mutex_unlock(&link->flash_mutex);
 	return 0;
+fail:
+	mutex_unlock(&link->flash_mutex);
+	return -1;
 }
 
-#define DDB_MAGIC 'd'
+int ddbridge_flashread(struct ddb *dev, u32 link, u8 *buf, u32 addr, u32 len)
+{
+	u8 cmd[4] = {0x03, (addr >> 16) & 0xff,
+		     (addr >> 8) & 0xff, addr & 0xff};
 
-struct ddb_flashio {
-	__user __u8 *write_buf;
-	__u32 write_len;
-	__user __u8 *read_buf;
-	__u32 read_len;
-};
+	return flashio(dev, link, cmd, 4, buf, len);
+}
 
-#define IOCTL_DDB_FLASHIO  _IOWR(DDB_MAGIC, 0x00, struct ddb_flashio)
+/*
+ * TODO/FIXME: add/implement IOCTLs from upstream driver
+ */
 
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
@@ -1773,90 +2939,685 @@ static int ddb_open(struct inode *inode, struct file *file)
 static long ddb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct ddb *dev = file->private_data;
-	__user void *parg = (__user void *)arg;
-	int res;
 
-	switch (cmd) {
-	case IOCTL_DDB_FLASHIO:
-	{
-		struct ddb_flashio fio;
-		u8 *rbuf, *wbuf;
+	dev_warn(dev->dev, "DDB IOCTLs unsupported (cmd: %d, arg: %lu)\n",
+		 cmd, arg);
 
-		if (copy_from_user(&fio, parg, sizeof(fio)))
-			return -EFAULT;
+	return -ENOTTY;
+}
 
-		if (fio.write_len > 1028 || fio.read_len > 1028)
-			return -EINVAL;
-		if (fio.write_len + fio.read_len > 1028)
-			return -EINVAL;
+static const struct file_operations ddb_fops = {
+	.unlocked_ioctl = ddb_ioctl,
+	.open           = ddb_open,
+	.release        = ddb_release,
+};
+
+static char *ddb_devnode(struct device *device, umode_t *mode)
+{
+	struct ddb *dev = dev_get_drvdata(device);
 
-		wbuf = &dev->iobuf[0];
-		rbuf = wbuf + fio.write_len;
+	return kasprintf(GFP_KERNEL, "ddbridge/card%d", dev->nr);
+}
 
-		if (copy_from_user(wbuf, fio.write_buf, fio.write_len))
-			return -EFAULT;
-		res = flashio(dev, wbuf, fio.write_len, rbuf, fio.read_len);
-		if (res)
-			return res;
-		if (copy_to_user(fio.read_buf, rbuf, fio.read_len))
-			return -EFAULT;
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
+static ssize_t ports_show(struct device *device,
+			  struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+
+	return sprintf(buf, "%d\n", dev->port_num);
+}
+
+static ssize_t ts_irq_show(struct device *device,
+			   struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+
+	return sprintf(buf, "%d\n", dev->ts_irq);
+}
+
+static ssize_t i2c_irq_show(struct device *device,
+			    struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+
+	return sprintf(buf, "%d\n", dev->i2c_irq);
+}
+
+static ssize_t fan_show(struct device *device,
+			struct device_attribute *attr, char *buf)
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
+	u32 val;
+
+	if (sscanf(buf, "%u\n", &val) != 1)
+		return -EINVAL;
+	ddbwritel(dev, 1, GPIO_DIRECTION);
+	ddbwritel(dev, val & 1, GPIO_OUTPUT);
+	return count;
+}
+
+static ssize_t fanspeed_show(struct device *device,
+			struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+	int num = attr->attr.name[8] - 0x30;
+	struct ddb_link *link = &dev->link[num];
+	u32 spd;
+
+	spd = ddblreadl(link, TEMPMON_FANCONTROL) & 0xff;
+	return sprintf(buf, "%u\n", spd * 100);
+}
+
+static ssize_t temp_show(struct device *device,
+			 struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+	struct ddb_link *link = &dev->link[0];
+	struct i2c_adapter *adap;
+	int temp, temp2;
+	u8 tmp[2];
+
+	if (!link->info->temp_num)
+		return sprintf(buf, "no sensor\n");
+	adap = &dev->i2c[link->info->temp_bus].adap;
+	if (i2c_read_regs(adap, 0x48, 0, tmp, 2) < 0)
+		return sprintf(buf, "read_error\n");
+	temp = (tmp[0] << 3) | (tmp[1] >> 5);
+	temp *= 125;
+	if (link->info->temp_num == 2) {
+		if (i2c_read_regs(adap, 0x49, 0, tmp, 2) < 0)
+			return sprintf(buf, "read_error\n");
+		temp2 = (tmp[0] << 3) | (tmp[1] >> 5);
+		temp2 *= 125;
+		return sprintf(buf, "%d %d\n", temp, temp2);
+	}
+	return sprintf(buf, "%d\n", temp);
+}
+
+static ssize_t ctemp_show(struct device *device,
+		struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+	struct i2c_adapter *adap;
+	int temp;
+	u8 tmp[2];
+	int num = attr->attr.name[4] - 0x30;
+
+	adap = &dev->i2c[num].adap;
+	if (!adap)
+		return 0;
+	if (i2c_read_regs(adap, 0x49, 0, tmp, 2) < 0)
+		if (i2c_read_regs(adap, 0x4d, 0, tmp, 2) < 0)
+			return sprintf(buf, "no sensor\n");
+	temp = tmp[0] * 1000;
+	return sprintf(buf, "%d\n", temp);
+}
+
+static ssize_t led_show(struct device *device,
+			struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+	int num = attr->attr.name[3] - 0x30;
+
+	return sprintf(buf, "%d\n", dev->leds & (1 << num) ? 1 : 0);
+}
+
+
+static void ddb_set_led(struct ddb *dev, int num, int val)
+{
+	if (!dev->link[0].info->led_num)
+		return;
+	switch (dev->port[num].class) {
+	case DDB_PORT_TUNER:
+		switch (dev->port[num].type) {
+		case DDB_TUNER_DVBS_ST:
+			i2c_write_reg16(&dev->i2c[num].adap,
+					0x69, 0xf14c, val ? 2 : 0);
+			break;
+		case DDB_TUNER_DVBCT_ST:
+			i2c_write_reg16(&dev->i2c[num].adap,
+					0x1f, 0xf00e, 0);
+			i2c_write_reg16(&dev->i2c[num].adap,
+					0x1f, 0xf00f, val ? 1 : 0);
+			break;
+		case DDB_TUNER_XO2 ... DDB_TUNER_DVBC2T2I_SONY:
+		{
+			u8 v;
+
+			i2c_read_reg(&dev->i2c[num].adap, 0x10, 0x08, &v);
+			v = (v & ~0x10) | (val ? 0x10 : 0);
+			i2c_write_reg(&dev->i2c[num].adap, 0x10, 0x08, v);
+			break;
+		}
+		default:
+			break;
+		}
 		break;
 	}
-	default:
-		return -ENOTTY;
+}
+
+static ssize_t led_store(struct device *device,
+			 struct device_attribute *attr,
+			 const char *buf, size_t count)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+	int num = attr->attr.name[3] - 0x30;
+	u32 val;
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
+static ssize_t snr_show(struct device *device,
+			struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+	char snr[32];
+	int num = attr->attr.name[3] - 0x30;
+
+	if (dev->port[num].type >= DDB_TUNER_XO2) {
+		if (i2c_read_regs(&dev->i2c[num].adap, 0x10, 0x10, snr, 16) < 0)
+			return sprintf(buf, "NO SNR\n");
+		snr[16] = 0;
+	} else {
+		/* serial number at 0x100-0x11f */
+		if (i2c_read_regs16(&dev->i2c[num].adap,
+				    0x57, 0x100, snr, 32) < 0)
+			if (i2c_read_regs16(&dev->i2c[num].adap,
+					    0x50, 0x100, snr, 32) < 0)
+				return sprintf(buf, "NO SNR\n");
+		snr[31] = 0; /* in case it is not terminated on EEPROM */
 	}
+	return sprintf(buf, "%s\n", snr);
+}
+
+
+static ssize_t snr_store(struct device *device, struct device_attribute *attr,
+			 const char *buf, size_t count)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+	int num = attr->attr.name[3] - 0x30;
+	u8 snr[34] = { 0x01, 0x00 };
+
+	return 0; /* NOE: remove completely? */
+	if (count > 31)
+		return -EINVAL;
+	if (dev->port[num].type >= DDB_TUNER_XO2)
+		return -EINVAL;
+	memcpy(snr + 2, buf, count);
+	i2c_write(&dev->i2c[num].adap, 0x57, snr, 34);
+	i2c_write(&dev->i2c[num].adap, 0x50, snr, 34);
+	return count;
+}
+
+static ssize_t bsnr_show(struct device *device,
+			 struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+	char snr[16];
+
+	ddbridge_flashread(dev, 0, snr, 0x10, 15);
+	snr[15] = 0; /* in case it is not terminated on EEPROM */
+	return sprintf(buf, "%s\n", snr);
+}
+
+static ssize_t bpsnr_show(struct device *device,
+			 struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+	char snr[32];
+
+	if (!dev->i2c_num)
+		return 0;
+
+	if (i2c_read_regs16(&dev->i2c[0].adap,
+			    0x50, 0x0000, snr, 32) < 0 ||
+	    snr[0] == 0xff)
+		return sprintf(buf, "NO SNR\n");
+	snr[31] = 0; /* in case it is not terminated on EEPROM */
+	return sprintf(buf, "%s\n", snr);
+}
+
+static ssize_t redirect_show(struct device *device,
+			     struct device_attribute *attr, char *buf)
+{
 	return 0;
 }
 
-static const struct file_operations ddb_fops = {
-	.unlocked_ioctl = ddb_ioctl,
-	.open           = ddb_open,
-};
+static ssize_t redirect_store(struct device *device,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	unsigned int i, p;
+	int res;
 
-static char *ddb_devnode(struct device *device, umode_t *mode)
+	if (sscanf(buf, "%x %x\n", &i, &p) != 2)
+		return -EINVAL;
+	res = ddb_redirect(i, p);
+	if (res < 0)
+		return res;
+	dev_info(device, "redirect: %02x, %02x\n", i, p);
+	return count;
+}
+
+static ssize_t gap_show(struct device *device,
+			struct device_attribute *attr, char *buf)
 {
 	struct ddb *dev = dev_get_drvdata(device);
+	int num = attr->attr.name[3] - 0x30;
 
-	return kasprintf(GFP_KERNEL, "ddbridge/card%d", dev->nr);
+	return sprintf(buf, "%d\n", dev->port[num].gap);
+
+}
+
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
+static ssize_t version_show(struct device *device,
+			    struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+
+	return sprintf(buf, "%08x %08x\n",
+		       dev->link[0].ids.hwid, dev->link[0].ids.regmapid);
 }
 
+static ssize_t hwid_show(struct device *device,
+			 struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+
+	return sprintf(buf, "0x%08X\n", dev->link[0].ids.hwid);
+}
+
+static ssize_t regmap_show(struct device *device,
+			   struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+
+	return sprintf(buf, "0x%08X\n", dev->link[0].ids.regmapid);
+}
+
+static ssize_t devid_show(struct device *device,
+			  struct device_attribute *attr, char *buf)
+{
+	int num = attr->attr.name[5] - 0x30;
+	struct ddb *dev = dev_get_drvdata(device);
+
+	return sprintf(buf, "%08x\n", dev->link[num].ids.devid);
+}
+
+static struct device_attribute ddb_attrs[] = {
+	__ATTR_RO(version),
+	__ATTR_RO(ports),
+	__ATTR_RO(ts_irq),
+	__ATTR_RO(i2c_irq),
+	__ATTR(gap0, 0664, gap_show, gap_store),
+	__ATTR(gap1, 0664, gap_show, gap_store),
+	__ATTR(gap2, 0664, gap_show, gap_store),
+	__ATTR(gap3, 0664, gap_show, gap_store),
+	__ATTR_MRO(devid0, devid_show),
+	__ATTR_MRO(devid1, devid_show),
+	__ATTR_MRO(devid2, devid_show),
+	__ATTR_MRO(devid3, devid_show),
+	__ATTR_RO(hwid),
+	__ATTR_RO(regmap),
+	__ATTR(redirect, 0664, redirect_show, redirect_store),
+	__ATTR_MRO(snr,  bsnr_show),
+	__ATTR_RO(bpsnr),
+	__ATTR_NULL,
+};
+
+static struct device_attribute ddb_attrs_temp[] = {
+	__ATTR_RO(temp),
+};
+
+static struct device_attribute ddb_attrs_fan[] = {
+	__ATTR(fan, 0664, fan_show, fan_store),
+};
+
+static struct device_attribute ddb_attrs_snr[] = {
+	__ATTR(snr0, 0664, snr_show, snr_store),
+	__ATTR(snr1, 0664, snr_show, snr_store),
+	__ATTR(snr2, 0664, snr_show, snr_store),
+	__ATTR(snr3, 0664, snr_show, snr_store),
+};
+
+static struct device_attribute ddb_attrs_ctemp[] = {
+	__ATTR_MRO(temp0, ctemp_show),
+	__ATTR_MRO(temp1, ctemp_show),
+	__ATTR_MRO(temp2, ctemp_show),
+	__ATTR_MRO(temp3, ctemp_show),
+};
+
+static struct device_attribute ddb_attrs_led[] = {
+	__ATTR(led0, 0664, led_show, led_store),
+	__ATTR(led1, 0664, led_show, led_store),
+	__ATTR(led2, 0664, led_show, led_store),
+	__ATTR(led3, 0664, led_show, led_store),
+};
+
+static struct device_attribute ddb_attrs_fanspeed[] = {
+	__ATTR_MRO(fanspeed0, fanspeed_show),
+	__ATTR_MRO(fanspeed1, fanspeed_show),
+	__ATTR_MRO(fanspeed2, fanspeed_show),
+	__ATTR_MRO(fanspeed3, fanspeed_show),
+};
+
+static struct class ddb_class = {
+	.name		= "ddbridge",
+	.owner          = THIS_MODULE,
+	.devnode        = ddb_devnode,
+};
+
 int ddb_class_create(void)
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
 
 void ddb_class_destroy(void)
 {
-	class_destroy(ddb_class);
+	class_unregister(&ddb_class);
 	unregister_chrdev(ddb_major, DDB_NAME);
 }
 
+static void ddb_device_attrs_del(struct ddb *dev)
+{
+	int i;
+
+	for (i = 0; i < 4; i++)
+		if (dev->link[i].info && dev->link[i].info->tempmon_irq)
+			device_remove_file(dev->ddb_dev,
+					   &ddb_attrs_fanspeed[i]);
+	for (i = 0; i < dev->link[0].info->temp_num; i++)
+		device_remove_file(dev->ddb_dev, &ddb_attrs_temp[i]);
+	for (i = 0; i < dev->link[0].info->fan_num; i++)
+		device_remove_file(dev->ddb_dev, &ddb_attrs_fan[i]);
+	for (i = 0; i < dev->i2c_num && i < 4; i++) {
+		if (dev->link[0].info->led_num)
+			device_remove_file(dev->ddb_dev, &ddb_attrs_led[i]);
+		device_remove_file(dev->ddb_dev, &ddb_attrs_snr[i]);
+		device_remove_file(dev->ddb_dev, &ddb_attrs_ctemp[i]);
+	}
+	for (i = 0; ddb_attrs[i].attr.name != NULL; i++)
+		device_remove_file(dev->ddb_dev, &ddb_attrs[i]);
+}
+
+static int ddb_device_attrs_add(struct ddb *dev)
+{
+	int i;
+
+	for (i = 0; ddb_attrs[i].attr.name != NULL; i++)
+		if (device_create_file(dev->ddb_dev, &ddb_attrs[i]))
+			goto fail;
+	for (i = 0; i < dev->link[0].info->temp_num; i++)
+		if (device_create_file(dev->ddb_dev, &ddb_attrs_temp[i]))
+			goto fail;
+	for (i = 0; i < dev->link[0].info->fan_num; i++)
+		if (device_create_file(dev->ddb_dev, &ddb_attrs_fan[i]))
+			goto fail;
+	for (i = 0; (i < dev->i2c_num) && (i < 4); i++) {
+		if (device_create_file(dev->ddb_dev, &ddb_attrs_snr[i]))
+			goto fail;
+		if (device_create_file(dev->ddb_dev, &ddb_attrs_ctemp[i]))
+			goto fail;
+		if (dev->link[0].info->led_num)
+			if (device_create_file(dev->ddb_dev,
+					       &ddb_attrs_led[i]))
+				goto fail;
+	}
+	for (i = 0; i < 4; i++)
+		if (dev->link[i].info && dev->link[i].info->tempmon_irq)
+			if (device_create_file(dev->ddb_dev,
+					       &ddb_attrs_fanspeed[i]))
+				goto fail;
+	return 0;
+fail:
+	return -1;
+}
+
 int ddb_device_create(struct ddb *dev)
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
+		dev_info(dev->dev, "Could not create ddbridge%d\n", dev->nr);
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
 
 void ddb_device_destroy(struct ddb *dev)
 {
-	ddb_num--;
 	if (IS_ERR(dev->ddb_dev))
 		return;
-	device_destroy(ddb_class, MKDEV(ddb_major, 0));
+	ddb_device_attrs_del(dev);
+	device_destroy(&ddb_class, MKDEV(ddb_major, dev->nr));
+}
+
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+
+static void tempmon_setfan(struct ddb_link *link)
+{
+	u32 temp, temp2, pwm;
+
+	if ((ddblreadl(link, TEMPMON_CONTROL) &
+	    TEMPMON_CONTROL_OVERTEMP) != 0) {
+		dev_info(link->dev->dev, "Over temperature condition\n");
+		link->overtemperature_error = 1;
+	}
+	temp  = (ddblreadl(link, TEMPMON_SENSOR0) >> 8) & 0xFF;
+	if (temp & 0x80)
+		temp = 0;
+	temp2  = (ddblreadl(link, TEMPMON_SENSOR1) >> 8) & 0xFF;
+	if (temp2 & 0x80)
+		temp2 = 0;
+	if (temp2 > temp)
+		temp = temp2;
+
+	pwm = (ddblreadl(link, TEMPMON_FANCONTROL) >> 8) & 0x0F;
+	if (pwm > 10)
+		pwm = 10;
+
+	if (temp >= link->temp_tab[pwm]) {
+		while (pwm < 10 && temp >= link->temp_tab[pwm + 1])
+			pwm += 1;
+	} else {
+		while (pwm > 1 && temp < link->temp_tab[pwm - 2])
+			pwm -= 1;
+	}
+	ddblwritel(link, (pwm << 8), TEMPMON_FANCONTROL);
+}
+
+static void temp_handler(unsigned long data)
+{
+	struct ddb_link *link = (struct ddb_link *) data;
+
+	spin_lock(&link->temp_lock);
+	tempmon_setfan(link);
+	spin_unlock(&link->temp_lock);
+}
+
+static int tempmon_init(struct ddb_link *link, int first_time)
+{
+	struct ddb *dev = link->dev;
+	int status = 0;
+	u32 l = link->nr;
+
+	spin_lock_irq(&link->temp_lock);
+	if (first_time) {
+		static u8 temperature_table[11] = {
+			30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80 };
+
+		memcpy(link->temp_tab, temperature_table,
+			sizeof(temperature_table));
+	}
+	dev->handler[l][link->info->tempmon_irq] = temp_handler;
+	dev->handler_data[l][link->info->tempmon_irq] = (unsigned long) link;
+	ddblwritel(link, (TEMPMON_CONTROL_OVERTEMP | TEMPMON_CONTROL_AUTOSCAN |
+			  TEMPMON_CONTROL_INTENABLE),
+		   TEMPMON_CONTROL);
+	ddblwritel(link, (3 << 8), TEMPMON_FANCONTROL);
+
+	link->overtemperature_error =
+		((ddblreadl(link, TEMPMON_CONTROL) &
+			TEMPMON_CONTROL_OVERTEMP) != 0);
+	if (link->overtemperature_error) {
+		dev_info(link->dev->dev, "Over temperature condition\n");
+		status = -1;
+	}
+	tempmon_setfan(link);
+	spin_unlock_irq(&link->temp_lock);
+	return status;
+}
+
+static int ddb_init_tempmon(struct ddb_link *link)
+{
+	struct ddb_info *info = link->info;
+
+	if (!info->tempmon_irq)
+		return 0;
+	if (info->type == DDB_OCTOPUS_MAX_CT)
+		if (link->ids.regmapid < 0x00010002)
+			return 0;
+	spin_lock_init(&link->temp_lock);
+	dev_dbg(link->dev->dev, "init_tempmon\n");
+	return tempmon_init(link, 1);
+}
+
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+
+static int ddb_init_boards(struct ddb *dev)
+{
+	struct ddb_info *info;
+	struct ddb_link *link;
+	u32 l;
+
+	for (l = 0; l < DDB_MAX_LINK; l++) {
+		link = &dev->link[l];
+		info = link->info;
+
+		if (!info)
+			continue;
+		if (info->board_control) {
+			ddbwritel(dev, 0, DDB_LINK_TAG(l) | BOARD_CONTROL);
+			msleep(100);
+			ddbwritel(dev, info->board_control_2,
+				DDB_LINK_TAG(l) | BOARD_CONTROL);
+			usleep_range(2000, 3000);
+			ddbwritel(dev,
+				info->board_control_2 | info->board_control,
+				DDB_LINK_TAG(l) | BOARD_CONTROL);
+			usleep_range(2000, 3000);
+		}
+		ddb_init_tempmon(link);
+	}
+	return 0;
+}
+
+int ddb_init(struct ddb *dev)
+{
+	mutex_init(&dev->link[0].flash_mutex);
+	if (no_init) {
+		ddb_device_create(dev);
+		return 0;
+	}
+
+	ddb_init_boards(dev);
+
+	if (ddb_i2c_init(dev) < 0)
+		goto fail;
+	ddb_ports_init(dev);
+	if (ddb_buffers_alloc(dev) < 0) {
+		dev_info(dev->dev, "Could not allocate buffer memory\n");
+		goto fail2;
+	}
+	if (ddb_ports_attach(dev) < 0)
+		goto fail3;
+
+	ddb_device_create(dev);
+
+	if (dev->link[0].info->fan_num)	{
+		ddbwritel(dev, 1, GPIO_DIRECTION);
+		ddbwritel(dev, 1, GPIO_OUTPUT);
+	}
+	return 0;
+
+fail3:
+	ddb_ports_detach(dev);
+	dev_err(dev->dev, "fail3\n");
+	ddb_ports_release(dev);
+fail2:
+	dev_err(dev->dev, "fail2\n");
+	ddb_buffers_free(dev);
+	ddb_i2c_release(dev);
+fail:
+	dev_err(dev->dev, "fail1\n");
+	return -1;
 }
diff --git a/drivers/media/pci/ddbridge/ddbridge-i2c.c b/drivers/media/pci/ddbridge/ddbridge-i2c.c
index 45287f98ee92..376d8a7ca0b9 100644
--- a/drivers/media/pci/ddbridge/ddbridge-i2c.c
+++ b/drivers/media/pci/ddbridge/ddbridge-i2c.c
@@ -1,24 +1,21 @@
 /*
- * ddbridge.c: Digital Devices PCIe bridge driver
+ * ddbridge-i2c.c: Digital Devices bridge i2c driver
  *
- * Copyright (C) 2010-2011 Digital Devices GmbH
+ * Copyright (C) 2010-2017 Digital Devices GmbH
+ *                         Ralph Metzler <rjkm@metzlerbros.de>
+ *                         Marcus Metzler <mocm@metzlerbros.de>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 only, as published by the Free Software Foundation.
  *
- *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * To obtain the license, point your browser to
- * http://www.gnu.org/copyleft/gpl.html
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -34,30 +31,47 @@
 #include <linux/vmalloc.h>
 
 #include "ddbridge.h"
-#include "ddbridge-regs.h"
 #include "ddbridge-i2c.h"
+#include "ddbridge-regs.h"
 
 /******************************************************************************/
 
 static int ddb_i2c_cmd(struct ddb_i2c *i2c, u32 adr, u32 cmd)
 {
 	struct ddb *dev = i2c->dev;
-	long stat;
+	unsigned long stat;
 	u32 val;
 
-	i2c->done = 0;
-	ddbwritel((adr << 9) | cmd, i2c->regs + I2C_COMMAND);
-	stat = wait_event_timeout(i2c->wq, i2c->done == 1, HZ);
+	ddbwritel(dev, (adr << 9) | cmd, i2c->regs + I2C_COMMAND);
+	stat = wait_for_completion_timeout(&i2c->completion, HZ);
+	val = ddbreadl(dev, i2c->regs + I2C_COMMAND);
 	if (stat == 0) {
-		dev_err(&dev->pdev->dev, "I2C timeout\n");
-		{ /* MSI debugging*/
-			u32 istat = ddbreadl(INTERRUPT_STATUS);
-			dev_err(&dev->pdev->dev, "IRS %08x\n", istat);
-			ddbwritel(istat, INTERRUPT_ACK);
+		dev_err(dev->dev, "I2C timeout, card %d, port %d, link %u\n",
+			dev->nr, i2c->nr, i2c->link);
+		{
+			u32 istat = ddbreadl(dev, INTERRUPT_STATUS);
+
+			dev_err(dev->dev, "DDBridge IRS %08x\n", istat);
+			if (i2c->link) {
+				u32 listat = ddbreadl(dev,
+					DDB_LINK_TAG(i2c->link) |
+					INTERRUPT_STATUS);
+
+				dev_err(dev->dev, "DDBridge link %u IRS %08x\n",
+					i2c->link, listat);
+			}
+			if (istat & 1) {
+				ddbwritel(dev, istat & 1, INTERRUPT_ACK);
+			} else {
+				u32 mon = ddbreadl(dev,
+					i2c->regs + I2C_MONITOR);
+
+				dev_err(dev->dev, "I2C cmd=%08x mon=%08x\n",
+					val, mon);
+			}
 		}
 		return -EIO;
 	}
-	val = ddbreadl(i2c->regs+I2C_COMMAND);
 	if (val & 0x70000)
 		return -EIO;
 	return 0;
@@ -66,48 +80,54 @@ static int ddb_i2c_cmd(struct ddb_i2c *i2c, u32 adr, u32 cmd)
 static int ddb_i2c_master_xfer(struct i2c_adapter *adapter,
 			       struct i2c_msg msg[], int num)
 {
-	struct ddb_i2c *i2c = (struct ddb_i2c *)i2c_get_adapdata(adapter);
+	struct ddb_i2c *i2c = (struct ddb_i2c *) i2c_get_adapdata(adapter);
 	struct ddb *dev = i2c->dev;
 	u8 addr = 0;
 
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
+	addr = msg[0].addr;
+	if (msg[0].len > i2c->bsize)
+		return -EIO;
+	switch (num) {
+	case 1:
+		if (msg[0].flags & I2C_M_RD) {
+			ddbwritel(dev, msg[0].len << 16,
+				  i2c->regs + I2C_TASKLENGTH);
+			if (ddb_i2c_cmd(i2c, addr, 3))
+				break;
+			ddbcpyfrom(dev, msg[0].buf,
+				   i2c->rbuf, msg[0].len);
 			return num;
 		}
+		ddbcpyto(dev, i2c->wbuf, msg[0].buf, msg[0].len);
+		ddbwritel(dev, msg[0].len, i2c->regs + I2C_TASKLENGTH);
+		if (ddb_i2c_cmd(i2c, addr, 2))
+			break;
+		return num;
+	case 2:
+		if ((msg[0].flags & I2C_M_RD) == I2C_M_RD)
+			break;
+		if ((msg[1].flags & I2C_M_RD) != I2C_M_RD)
+			break;
+		if (msg[1].len > i2c->bsize)
+			break;
+		ddbcpyto(dev, i2c->wbuf, msg[0].buf, msg[0].len);
+		ddbwritel(dev, msg[0].len | (msg[1].len << 16),
+			  i2c->regs + I2C_TASKLENGTH);
+		if (ddb_i2c_cmd(i2c, addr, 1))
+			break;
+		ddbcpyfrom(dev, msg[1].buf,
+			   i2c->rbuf,
+			   msg[1].len);
+		return num;
+	default:
+		break;
 	}
 	return -EIO;
 }
 
-
 static u32 ddb_i2c_functionality(struct i2c_adapter *adap)
 {
-	return I2C_FUNC_SMBUS_EMUL;
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
 }
 
 static const struct i2c_algorithm ddb_i2c_algo = {
@@ -119,55 +139,90 @@ void ddb_i2c_release(struct ddb *dev)
 {
 	int i;
 	struct ddb_i2c *i2c;
-	struct i2c_adapter *adap;
 
-	for (i = 0; i < dev->info->port_num; i++) {
+	for (i = 0; i < dev->i2c_num; i++) {
 		i2c = &dev->i2c[i];
-		adap = &i2c->adap;
-		i2c_del_adapter(adap);
+		i2c_del_adapter(&i2c->adap);
 	}
 }
 
-int ddb_i2c_init(struct ddb *dev)
+static void i2c_handler(unsigned long priv)
+{
+	struct ddb_i2c *i2c = (struct ddb_i2c *) priv;
+
+	complete(&i2c->completion);
+}
+
+static int ddb_i2c_add(struct ddb *dev, struct ddb_i2c *i2c,
+		       struct ddb_regmap *regmap, int link, int i, int num)
 {
-	int i, j, stat = 0;
-	struct ddb_i2c *i2c;
 	struct i2c_adapter *adap;
 
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
+	i2c->nr = i;
+	i2c->dev = dev;
+	i2c->link = link;
+	i2c->bsize = regmap->i2c_buf->size;
+	i2c->wbuf = DDB_LINK_TAG(link) |
+		(regmap->i2c_buf->base + i2c->bsize * i);
+	i2c->rbuf = i2c->wbuf; /* + i2c->bsize / 2 */
+	i2c->regs = DDB_LINK_TAG(link) |
+		(regmap->i2c->base + regmap->i2c->size * i);
+	ddbwritel(dev, I2C_SPEED_100, i2c->regs + I2C_TIMING);
+	ddbwritel(dev, ((i2c->rbuf & 0xffff) << 16) | (i2c->wbuf & 0xffff),
+		i2c->regs + I2C_TASKADDRESS);
+	init_completion(&i2c->completion);
+
+	adap = &i2c->adap;
+	i2c_set_adapdata(adap, i2c);
 #ifdef I2C_ADAP_CLASS_TV_DIGITAL
-		adap->class = I2C_ADAP_CLASS_TV_DIGITAL|I2C_CLASS_TV_ANALOG;
+	adap->class = I2C_ADAP_CLASS_TV_DIGITAL|I2C_CLASS_TV_ANALOG;
 #else
 #ifdef I2C_CLASS_TV_ANALOG
-		adap->class = I2C_CLASS_TV_ANALOG;
+	adap->class = I2C_CLASS_TV_ANALOG;
 #endif
 #endif
-		strcpy(adap->name, "ddbridge");
-		adap->algo = &ddb_i2c_algo;
-		adap->algo_data = (void *)i2c;
-		adap->dev.parent = &dev->pdev->dev;
-		stat = i2c_add_adapter(adap);
-		if (stat)
-			break;
+	snprintf(adap->name, I2C_NAME_SIZE, "ddbridge_%02x.%x.%x",
+		dev->nr, i2c->link, i);
+	adap->algo = &ddb_i2c_algo;
+	adap->algo_data = (void *)i2c;
+	adap->dev.parent = dev->dev;
+	return i2c_add_adapter(adap);
+}
+
+int ddb_i2c_init(struct ddb *dev)
+{
+	int stat = 0;
+	u32 i, j, num = 0, l, base;
+	struct ddb_i2c *i2c;
+	struct i2c_adapter *adap;
+	struct ddb_regmap *regmap;
+
+	for (l = 0; l < DDB_MAX_LINK; l++) {
+		if (!dev->link[l].info)
+			continue;
+		regmap = dev->link[l].info->regmap;
+		if (!regmap || !regmap->i2c)
+			continue;
+		base = regmap->irq_base_i2c;
+		for (i = 0; i < regmap->i2c->num; i++) {
+			if (!(dev->link[l].info->i2c_mask & (1 << i)))
+				continue;
+			i2c = &dev->i2c[num];
+			dev->handler_data[l][i + base] = (unsigned long) i2c;
+			dev->handler[l][i + base] = i2c_handler;
+			stat = ddb_i2c_add(dev, i2c, regmap, l, i, num);
+			if (stat)
+				break;
+			num++;
+		}
 	}
-	if (stat)
-		for (j = 0; j < i; j++) {
+	if (stat) {
+		for (j = 0; j < num; j++) {
 			i2c = &dev->i2c[j];
 			adap = &i2c->adap;
 			i2c_del_adapter(adap);
 		}
+	} else
+		dev->i2c_num = num;
 	return stat;
 }
diff --git a/drivers/media/pci/ddbridge/ddbridge-i2c.h b/drivers/media/pci/ddbridge/ddbridge-i2c.h
index e1aa3b74f672..7ed220506c05 100644
--- a/drivers/media/pci/ddbridge/ddbridge-i2c.h
+++ b/drivers/media/pci/ddbridge/ddbridge-i2c.h
@@ -1,20 +1,19 @@
 /*
- * ddbridge.c: Digital Devices PCIe bridge driver
+ * ddbridge-i2c.c: Digital Devices bridge i2c driver
  *
- * Copyright (C) 2010-2011 Digital Devices GmbH
+ * Copyright (C) 2010-2017 Digital Devices GmbH
+ *                         Ralph Metzler <rjkm@metzlerbros.de>
+ *                         Marcus Metzler <mocm@metzlerbros.de>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 only, as published by the Free Software Foundation.
  *
- *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * To obtain the license, point your browser to
- * http://www.gnu.org/copyleft/gpl.html
  */
 
 #ifndef __DDBRIDGE_I2C_H__
@@ -70,24 +69,26 @@ static int __maybe_unused i2c_read_regs(struct i2c_adapter *adapter,
 	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
 }
 
-static int __maybe_unused i2c_read_reg(struct i2c_adapter *adapter, u8 adr,
-				       u8 reg, u8 *val)
-{
-	return i2c_read_regs(adapter, adr, reg, val, 1);
-}
-
-static int __maybe_unused i2c_read_reg16(struct i2c_adapter *adapter,
-					 u8 adr, u16 reg, u8 *val)
+static int __maybe_unused i2c_read_regs16(struct i2c_adapter *adapter,
+					  u8 adr, u16 reg, u8 *val, u8 len)
 {
 	u8 msg[2] = { reg >> 8, reg & 0xff };
 	struct i2c_msg msgs[2] = { { .addr = adr, .flags = 0,
 				     .buf  = msg, .len   = 2 },
 				   { .addr = adr, .flags = I2C_M_RD,
-				     .buf  = val, .len   = 1 } };
+				     .buf  = val, .len   = len } };
 
 	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
 }
 
+static int __maybe_unused i2c_write_reg16(struct i2c_adapter *adap,
+					  u8 adr, u16 reg, u8 val)
+{
+	u8 msg[3] = { reg >> 8, reg & 0xff, val };
+
+	return i2c_write(adap, adr, msg, 3);
+}
+
 static int __maybe_unused i2c_write_reg(struct i2c_adapter *adap,
 					u8 adr, u8 reg, u8 val)
 {
@@ -96,4 +97,16 @@ static int __maybe_unused i2c_write_reg(struct i2c_adapter *adap,
 	return i2c_write(adap, adr, msg, 2);
 }
 
+static int __maybe_unused i2c_read_reg16(struct i2c_adapter *adapter,
+					 u8 adr, u16 reg, u8 *val)
+{
+	return i2c_read_regs16(adapter, adr, reg, val, 1);
+}
+
+static int __maybe_unused i2c_read_reg(struct i2c_adapter *adapter,
+				       u8 adr, u8 reg, u8 *val)
+{
+	return i2c_read_regs(adapter, adr, reg, val, 1);
+}
+
 #endif /* __DDBRIDGE_I2C_H__ */
diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
index 41c0adc176b1..73b041118bbf 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -1,20 +1,19 @@
 /*
  * ddbridge.c: Digital Devices PCIe bridge driver
  *
- * Copyright (C) 2010-2011 Digital Devices GmbH
+ * Copyright (C) 2010-2017 Digital Devices GmbH
+ *                         Ralph Metzler <rjkm@metzlerbros.de>
+ *                         Marcus Metzler <mocm@metzlerbros.de>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 only, as published by the Free Software Foundation.
  *
- *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * To obtain the license, point your browser to
- * http://www.gnu.org/copyleft/gpl.html
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -37,15 +36,56 @@
 #include "ddbridge-i2c.h"
 #include "ddbridge-regs.h"
 
+/****************************************************************************/
+/* module parameters */
+
+int adapter_alloc;
+module_param(adapter_alloc, int, 0444);
+MODULE_PARM_DESC(adapter_alloc,
+		 "0-one adapter per io, 1-one per tab with io, 2-one per tab, 3-one for all");
+
+#ifdef CONFIG_PCI_MSI
+int msi = 1;
+module_param(msi, int, 0444);
+MODULE_PARM_DESC(msi,
+		 " Control MSI interrupts: 0-disable, 1-enable (default)");
+#endif
+
+int ci_bitrate = 70000;
+module_param(ci_bitrate, int, 0444);
+MODULE_PARM_DESC(ci_bitrate, " Bitrate in KHz for output to CI.");
+
+int ts_loop = -1;
+module_param(ts_loop, int, 0444);
+MODULE_PARM_DESC(ts_loop, "TS in/out test loop on port ts_loop");
+
 int xo2_speed = 2;
 module_param(xo2_speed, int, 0444);
 MODULE_PARM_DESC(xo2_speed, "default transfer speed for xo2 based duoflex, 0=55,1=75,2=90,3=104 MBit/s, default=2, use attribute to change for individual cards");
 
+#ifdef __arm__
+int alt_dma = 1;
+#else
+int alt_dma;
+#endif
+module_param(alt_dma, int, 0444);
+MODULE_PARM_DESC(alt_dma, "use alternative DMA buffer handling");
+
+int no_init;
+module_param(no_init, int, 0444);
+MODULE_PARM_DESC(no_init, "do not initialize most devices");
+
 int stv0910_single;
 module_param(stv0910_single, int, 0444);
 MODULE_PARM_DESC(stv0910_single, "use stv0910 cards as single demods");
 
-/******************************************************************************/
+/****************************************************************************/
+
+struct workqueue_struct *ddb_wq;
+
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
 
 static void ddb_unmap(struct ddb *dev)
 {
@@ -54,170 +94,261 @@ static void ddb_unmap(struct ddb *dev)
 	vfree(dev);
 }
 
-
-static void ddb_remove(struct pci_dev *pdev)
+static void ddb_irq_disable(struct ddb *dev)
 {
-	struct ddb *dev = pci_get_drvdata(pdev);
-
-	ddb_ports_detach(dev);
-	ddb_i2c_release(dev);
+	ddbwritel(dev, 0, INTERRUPT_ENABLE);
+	ddbwritel(dev, 0, MSI1_ENABLE);
+}
 
-	ddbwritel(0, INTERRUPT_ENABLE);
+static void ddb_irq_exit(struct ddb *dev)
+{
+	ddb_irq_disable(dev);
+	if (dev->msi == 2)
+		free_irq(dev->pdev->irq + 1, dev);
 	free_irq(dev->pdev->irq, dev);
 #ifdef CONFIG_PCI_MSI
 	if (dev->msi)
 		pci_disable_msi(dev->pdev);
 #endif
+}
+
+static void ddb_remove(struct pci_dev *pdev)
+{
+	struct ddb *dev = (struct ddb *) pci_get_drvdata(pdev);
+
+	ddb_device_destroy(dev);
+	ddb_ports_detach(dev);
+	ddb_i2c_release(dev);
+
+	ddb_irq_exit(dev);
 	ddb_ports_release(dev);
 	ddb_buffers_free(dev);
-	ddb_device_destroy(dev);
 
 	ddb_unmap(dev);
 	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
 }
 
+#ifdef CONFIG_PCI_MSI
+static void ddb_irq_msi(struct ddb *dev, int nr)
+{
+	int stat;
+
+	if (msi && pci_msi_enabled()) {
+		stat = pci_alloc_irq_vectors(dev->pdev, 1, nr, PCI_IRQ_MSI);
+		if (stat >= 1) {
+			dev->msi = stat;
+			dev_info(dev->dev, "using %d MSI interrupt(s)\n",
+				dev->msi);
+		} else
+			dev_info(dev->dev, "MSI not available.\n");
+	}
+}
+#endif
 
-static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+static int ddb_irq_init(struct ddb *dev)
+{
+	int stat;
+	int irq_flag = IRQF_SHARED;
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
+#ifdef CONFIG_PCI_MSI
+	ddb_irq_msi(dev, 2);
+
+	if (dev->msi)
+		irq_flag = 0;
+	if (dev->msi == 2) {
+		stat = request_irq(dev->pdev->irq, ddb_irq_handler0,
+				   irq_flag, "ddbridge", (void *) dev);
+		if (stat < 0)
+			return stat;
+		stat = request_irq(dev->pdev->irq + 1, ddb_irq_handler1,
+				   irq_flag, "ddbridge", (void *) dev);
+		if (stat < 0) {
+			free_irq(dev->pdev->irq, dev);
+			return stat;
+		}
+	} else
+#endif
+	{
+		stat = request_irq(dev->pdev->irq, ddb_irq_handler,
+				   irq_flag, "ddbridge", (void *) dev);
+		if (stat < 0)
+			return stat;
+	}
+	if (dev->msi == 2) {
+		ddbwritel(dev, 0x0fffff00, INTERRUPT_ENABLE);
+		ddbwritel(dev, 0x0000000f, MSI1_ENABLE);
+	} else {
+		ddbwritel(dev, 0x0fffff0f, INTERRUPT_ENABLE);
+		ddbwritel(dev, 0x00000000, MSI1_ENABLE);
+	}
+	return stat;
+}
+
+static int ddb_probe(struct pci_dev *pdev,
+			       const struct pci_device_id *id)
 {
 	struct ddb *dev;
 	int stat = 0;
-	int irq_flag = IRQF_SHARED;
 
 	if (pci_enable_device(pdev) < 0)
 		return -ENODEV;
 
+	pci_set_master(pdev);
+
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)))
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))
+			return -ENODEV;
+
 	dev = vzalloc(sizeof(struct ddb));
 	if (dev == NULL)
 		return -ENOMEM;
 
+	mutex_init(&dev->mutex);
+	dev->has_dma = 1;
 	dev->pdev = pdev;
+	dev->dev = &pdev->dev;
 	pci_set_drvdata(pdev, dev);
-	dev->info = (struct ddb_info *) id->driver_data;
-	dev_info(&pdev->dev, "Detected %s\n", dev->info->name);
 
+	dev->link[0].ids.vendor = id->vendor;
+	dev->link[0].ids.device = id->device;
+	dev->link[0].ids.subvendor = id->subvendor;
+	dev->link[0].ids.subdevice = id->subdevice;
+
+	dev->link[0].dev = dev;
+	dev->link[0].info = (struct ddb_info *) id->driver_data;
+	dev_info(&pdev->dev, "detected %s\n", dev->link[0].info->name);
+
+	dev->regs_len = pci_resource_len(dev->pdev, 0);
 	dev->regs = ioremap(pci_resource_start(dev->pdev, 0),
 			    pci_resource_len(dev->pdev, 0));
+
 	if (!dev->regs) {
+		dev_err(&pdev->dev, "not enough memory for register map\n");
 		stat = -ENOMEM;
 		goto fail;
 	}
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
+	if (ddbreadl(dev, 0) == 0xffffffff) {
+		dev_err(&pdev->dev, "cannot read registers\n");
+		stat = -ENODEV;
+		goto fail;
 	}
-#endif
-	stat = request_irq(dev->pdev->irq, irq_handler,
-			   irq_flag, "DDBridge", (void *) dev);
+
+	dev->link[0].ids.hwid = ddbreadl(dev, 0);
+	dev->link[0].ids.regmapid = ddbreadl(dev, 4);
+
+	dev_info(&pdev->dev, "HW %08x REGMAP %08x\n",
+		dev->link[0].ids.hwid, dev->link[0].ids.regmapid);
+
+	ddbwritel(dev, 0, DMA_BASE_READ);
+	ddbwritel(dev, 0, DMA_BASE_WRITE);
+
+	stat = ddb_irq_init(dev);
 	if (stat < 0)
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
+		goto fail0;
 
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
+	if (ddb_init(dev) == 0)
+		return 0;
 
-fail3:
-	ddb_ports_detach(dev);
-	dev_err(&pdev->dev, "fail3\n");
-	ddb_ports_release(dev);
-fail2:
-	dev_err(&pdev->dev, "fail2\n");
-	ddb_buffers_free(dev);
-fail1:
-	dev_err(&pdev->dev, "fail1\n");
+	ddb_irq_exit(dev);
+fail0:
+	dev_err(&pdev->dev, "fail0\n");
 	if (dev->msi)
 		pci_disable_msi(dev->pdev);
-	if (stat == 0)
-		free_irq(dev->pdev->irq, dev);
 fail:
 	dev_err(&pdev->dev, "fail\n");
+
 	ddb_unmap(dev);
 	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
 	return -1;
 }
 
-/******************************************************************************/
-/******************************************************************************/
-/******************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
 
 static const struct ddb_info ddb_none = {
 	.type     = DDB_NONE,
-	.name     = "Digital Devices PCIe bridge",
+	.name     = "unknown Digital Devices PCIe card, install newer driver",
+	.regmap   = &octopus_map,
 };
 
 static const struct ddb_info ddb_octopus = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Octopus DVB adapter",
+	.regmap   = &octopus_map,
+	.port_num = 4,
+	.i2c_mask = 0x0f,
+};
+
+static const struct ddb_info ddb_octopusv3 = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Octopus V3 DVB adapter",
+	.regmap   = &octopus_map,
 	.port_num = 4,
+	.i2c_mask = 0x0f,
 };
 
 static const struct ddb_info ddb_octopus_le = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Octopus LE DVB adapter",
+	.regmap   = &octopus_map,
 	.port_num = 2,
+	.i2c_mask = 0x03,
 };
 
 static const struct ddb_info ddb_octopus_oem = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Octopus OEM",
+	.regmap   = &octopus_map,
 	.port_num = 4,
+	.i2c_mask = 0x0f,
+	.led_num  = 1,
+	.fan_num  = 1,
+	.temp_num = 1,
+	.temp_bus = 0,
 };
 
 static const struct ddb_info ddb_octopus_mini = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Octopus Mini",
+	.regmap   = &octopus_map,
 	.port_num = 4,
+	.i2c_mask = 0x0f,
 };
 
 static const struct ddb_info ddb_v6 = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Cine S2 V6 DVB adapter",
+	.regmap   = &octopus_map,
 	.port_num = 3,
+	.i2c_mask = 0x07,
 };
+
 static const struct ddb_info ddb_v6_5 = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Cine S2 V6.5 DVB adapter",
+	.regmap   = &octopus_map,
 	.port_num = 4,
+	.i2c_mask = 0x0f,
 };
 
 static const struct ddb_info ddb_v7 = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Cine S2 V7 DVB adapter",
+	.regmap   = &octopus_map,
 	.port_num = 4,
+	.i2c_mask = 0x0f,
 	.board_control   = 2,
 	.board_control_2 = 4,
 	.ts_quirks = TS_QUIRK_REVERSED,
@@ -226,22 +357,20 @@ static const struct ddb_info ddb_v7 = {
 static const struct ddb_info ddb_v7a = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Cine S2 V7 Advanced DVB adapter",
+	.regmap   = &octopus_map,
 	.port_num = 4,
+	.i2c_mask = 0x0f,
 	.board_control   = 2,
 	.board_control_2 = 4,
 	.ts_quirks = TS_QUIRK_REVERSED,
 };
 
-static const struct ddb_info ddb_dvbct = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices DVBCT V6.1 DVB adapter",
-	.port_num = 3,
-};
-
 static const struct ddb_info ddb_ctv7 = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Cine CT V7 DVB adapter",
+	.regmap   = &octopus_map,
 	.port_num = 4,
+	.i2c_mask = 0x0f,
 	.board_control   = 3,
 	.board_control_2 = 4,
 };
@@ -249,134 +378,217 @@ static const struct ddb_info ddb_ctv7 = {
 static const struct ddb_info ddb_satixS2v3 = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Mystique SaTiX-S2 V3 DVB adapter",
+	.regmap   = &octopus_map,
 	.port_num = 3,
+	.i2c_mask = 0x07,
 };
 
-static const struct ddb_info ddb_octopusv3 = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices Octopus V3 DVB adapter",
+static const struct ddb_info ddb_ci = {
+	.type     = DDB_OCTOPUS_CI,
+	.name     = "Digital Devices Octopus CI",
+	.regmap   = &octopus_map,
 	.port_num = 4,
+	.i2c_mask = 0x03,
+};
+
+static const struct ddb_info ddb_cis = {
+	.type     = DDB_OCTOPUS_CI,
+	.name     = "Digital Devices Octopus CI single",
+	.regmap   = &octopus_map,
+	.port_num = 3,
+	.i2c_mask = 0x03,
 };
 
-/*** MaxA8 adapters ***********************************************************/
+static const struct ddb_info ddb_ci_s2_pro = {
+	.type     = DDB_OCTOPUS_CI,
+	.name     = "Digital Devices Octopus CI S2 Pro",
+	.regmap   = &octopus_map,
+	.port_num = 4,
+	.i2c_mask = 0x01,
+	.board_control   = 2,
+	.board_control_2 = 4,
+};
+
+static const struct ddb_info ddb_ci_s2_pro_a = {
+	.type     = DDB_OCTOPUS_CI,
+	.name     = "Digital Devices Octopus CI S2 Pro Advanced",
+	.regmap   = &octopus_map,
+	.port_num = 4,
+	.i2c_mask = 0x01,
+	.board_control   = 2,
+	.board_control_2 = 4,
+};
+
+static const struct ddb_info ddb_dvbct = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices DVBCT V6.1 DVB adapter",
+	.regmap   = &octopus_map,
+	.port_num = 3,
+	.i2c_mask = 0x07,
+};
+
+/****************************************************************************/
 
 static struct ddb_info ddb_ct2_8 = {
 	.type     = DDB_OCTOPUS_MAX_CT,
 	.name     = "Digital Devices MAX A8 CT2",
+	.regmap   = &octopus_map,
 	.port_num = 4,
+	.i2c_mask = 0x0f,
 	.board_control   = 0x0ff,
 	.board_control_2 = 0xf00,
 	.ts_quirks = TS_QUIRK_SERIAL,
+	.tempmon_irq = 24,
 };
 
 static struct ddb_info ddb_c2t2_8 = {
 	.type     = DDB_OCTOPUS_MAX_CT,
 	.name     = "Digital Devices MAX A8 C2T2",
+	.regmap   = &octopus_map,
 	.port_num = 4,
+	.i2c_mask = 0x0f,
 	.board_control   = 0x0ff,
 	.board_control_2 = 0xf00,
 	.ts_quirks = TS_QUIRK_SERIAL,
+	.tempmon_irq = 24,
 };
 
 static struct ddb_info ddb_isdbt_8 = {
 	.type     = DDB_OCTOPUS_MAX_CT,
 	.name     = "Digital Devices MAX A8 ISDBT",
+	.regmap   = &octopus_map,
 	.port_num = 4,
+	.i2c_mask = 0x0f,
 	.board_control   = 0x0ff,
 	.board_control_2 = 0xf00,
 	.ts_quirks = TS_QUIRK_SERIAL,
+	.tempmon_irq = 24,
 };
 
 static struct ddb_info ddb_c2t2i_v0_8 = {
 	.type     = DDB_OCTOPUS_MAX_CT,
 	.name     = "Digital Devices MAX A8 C2T2I V0",
+	.regmap   = &octopus_map,
 	.port_num = 4,
+	.i2c_mask = 0x0f,
 	.board_control   = 0x0ff,
 	.board_control_2 = 0xf00,
 	.ts_quirks = TS_QUIRK_SERIAL | TS_QUIRK_ALT_OSC,
+	.tempmon_irq = 24,
 };
 
 static struct ddb_info ddb_c2t2i_8 = {
 	.type     = DDB_OCTOPUS_MAX_CT,
 	.name     = "Digital Devices MAX A8 C2T2I",
+	.regmap   = &octopus_map,
 	.port_num = 4,
+	.i2c_mask = 0x0f,
 	.board_control   = 0x0ff,
 	.board_control_2 = 0xf00,
 	.ts_quirks = TS_QUIRK_SERIAL,
+	.tempmon_irq = 24,
 };
 
-/******************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
 
 #define DDVID 0xdd01 /* Digital Devices Vendor ID */
 
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
+#define DDB_DEVICE(_device, _subdevice, _driver_data) { \
+		PCI_DEVICE_SUB(DDVID, _device, DDVID, _subdevice), \
+			.driver_data = (kernel_ulong_t) &_driver_data }
+
+#define DDB_DEVICE_ANY(_device) { \
+		PCI_DEVICE_SUB(DDVID, _device, DDVID, PCI_ANY_ID), \
+			.driver_data = (kernel_ulong_t) &ddb_none }
+
+static const struct pci_device_id ddb_id_table[] = {
+	DDB_DEVICE(0x0002, 0x0001, ddb_octopus),
+	DDB_DEVICE(0x0003, 0x0001, ddb_octopus),
+	DDB_DEVICE(0x0005, 0x0004, ddb_octopusv3),
+	DDB_DEVICE(0x0003, 0x0002, ddb_octopus_le),
+	DDB_DEVICE(0x0003, 0x0003, ddb_octopus_oem),
+	DDB_DEVICE(0x0003, 0x0010, ddb_octopus_mini),
+	DDB_DEVICE(0x0005, 0x0011, ddb_octopus_mini),
+	DDB_DEVICE(0x0003, 0x0020, ddb_v6),
+	DDB_DEVICE(0x0003, 0x0021, ddb_v6_5),
+	DDB_DEVICE(0x0006, 0x0022, ddb_v7),
+	DDB_DEVICE(0x0006, 0x0024, ddb_v7a),
+	DDB_DEVICE(0x0003, 0x0030, ddb_dvbct),
+	DDB_DEVICE(0x0003, 0xdb03, ddb_satixS2v3),
+	DDB_DEVICE(0x0006, 0x0031, ddb_ctv7),
+	DDB_DEVICE(0x0006, 0x0032, ddb_ctv7),
+	DDB_DEVICE(0x0006, 0x0033, ddb_ctv7),
+	DDB_DEVICE(0x0008, 0x0034, ddb_ct2_8),
+	DDB_DEVICE(0x0008, 0x0035, ddb_c2t2_8),
+	DDB_DEVICE(0x0008, 0x0036, ddb_isdbt_8),
+	DDB_DEVICE(0x0008, 0x0037, ddb_c2t2i_v0_8),
+	DDB_DEVICE(0x0008, 0x0038, ddb_c2t2i_8),
+	DDB_DEVICE(0x0006, 0x0039, ddb_ctv7),
+	DDB_DEVICE(0x0011, 0x0040, ddb_ci),
+	DDB_DEVICE(0x0011, 0x0041, ddb_cis),
+	DDB_DEVICE(0x0012, 0x0042, ddb_ci),
+	DDB_DEVICE(0x0013, 0x0043, ddb_ci_s2_pro),
+	DDB_DEVICE(0x0013, 0x0044, ddb_ci_s2_pro_a),
 	/* in case sub-ids got deleted in flash */
-	DDB_ID(DDVID, 0x0003, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
-	DDB_ID(DDVID, 0x0005, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
-	DDB_ID(DDVID, 0x0006, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
-	DDB_ID(DDVID, 0x0007, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
-	DDB_ID(DDVID, 0x0008, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
-	DDB_ID(DDVID, 0x0011, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
-	DDB_ID(DDVID, 0x0013, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
-	DDB_ID(DDVID, 0x0201, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
-	DDB_ID(DDVID, 0x0320, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	DDB_DEVICE_ANY(0x0003),
+	DDB_DEVICE_ANY(0x0005),
+	DDB_DEVICE_ANY(0x0006),
+	DDB_DEVICE_ANY(0x0007),
+	DDB_DEVICE_ANY(0x0008),
+	DDB_DEVICE_ANY(0x0011),
+	DDB_DEVICE_ANY(0x0012),
+	DDB_DEVICE_ANY(0x0013),
+	DDB_DEVICE_ANY(0x0201),
+	DDB_DEVICE_ANY(0x0203),
+	DDB_DEVICE_ANY(0x0210),
+	DDB_DEVICE_ANY(0x0220),
+	DDB_DEVICE_ANY(0x0320),
+	DDB_DEVICE_ANY(0x0321),
+	DDB_DEVICE_ANY(0x0322),
+	DDB_DEVICE_ANY(0x0323),
+	DDB_DEVICE_ANY(0x0328),
+	DDB_DEVICE_ANY(0x0329),
 	{0}
 };
-MODULE_DEVICE_TABLE(pci, ddb_id_tbl);
 
+MODULE_DEVICE_TABLE(pci, ddb_id_table);
 
 static struct pci_driver ddb_pci_driver = {
-	.name        = "DDBridge",
-	.id_table    = ddb_id_tbl,
+	.name        = "ddbridge",
+	.id_table    = ddb_id_table,
 	.probe       = ddb_probe,
 	.remove      = ddb_remove,
 };
 
 static __init int module_init_ddbridge(void)
 {
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
+	int stat = -1;
+
+	pr_info("Digital Devices PCIE bridge driver "
+		DDBRIDGE_VERSION
+		", Copyright (C) 2010-17 Digital Devices GmbH\n");
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
 
@@ -384,6 +596,6 @@ module_init(module_init_ddbridge);
 module_exit(module_exit_ddbridge);
 
 MODULE_DESCRIPTION("Digital Devices PCIe Bridge");
-MODULE_AUTHOR("Ralph Metzler");
+MODULE_AUTHOR("Ralph and Marcus Metzler, Metzler Brothers Systementwicklung GbR");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("0.5");
+MODULE_VERSION(DDBRIDGE_VERSION);
diff --git a/drivers/media/pci/ddbridge/ddbridge-regs.h b/drivers/media/pci/ddbridge/ddbridge-regs.h
index 98cebb97d64f..03a34e1ddadf 100644
--- a/drivers/media/pci/ddbridge/ddbridge-regs.h
+++ b/drivers/media/pci/ddbridge/ddbridge-regs.h
@@ -1,7 +1,7 @@
 /*
  * ddbridge-regs.h: Digital Devices PCIe bridge driver
  *
- * Copyright (C) 2010-2011 Digital Devices GmbH
+ * Copyright (C) 2010-2017 Digital Devices GmbH
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -17,20 +17,26 @@
  * http://www.gnu.org/copyleft/gpl.html
  */
 
-/* DD-DVBBridgeV1.h 273 2010-09-17 05:03:16Z manfred */
+/* ------------------------------------------------------------------------- */
+/* SPI Controller */
 
-/* Register Definitions */
+#define SPI_CONTROL     0x10
+#define SPI_DATA        0x14
 
-#define CUR_REGISTERMAP_VERSION 0x10000
+/* ------------------------------------------------------------------------- */
+/* GPIO */
 
-#define HARDWARE_VERSION       0x00
-#define REGISTERMAP_VERSION    0x04
+#define GPIO_OUTPUT      0x20
+#define GPIO_INPUT       0x24
+#define GPIO_DIRECTION   0x28
 
 /* ------------------------------------------------------------------------- */
-/* SPI Controller */
+/* MDIO */
 
-#define SPI_CONTROL     0x10
-#define SPI_DATA        0x14
+#define MDIO_CTRL        0x20
+#define MDIO_ADR         0x24
+#define MDIO_REG         0x28
+#define MDIO_VAL         0x2C
 
 /* ------------------------------------------------------------------------- */
 
@@ -38,14 +44,14 @@
 
 /* ------------------------------------------------------------------------- */
 
-/* Interrupt controller                                     */
-/* How many MSI's are available depends on HW (Min 2 max 8) */
-/* How many are usable also depends on Host platform        */
+/* Interrupt controller
+ * How many MSI's are available depends on HW (Min 2 max 8)
+ * How many are usable also depends on Host platform
+ */
 
 #define INTERRUPT_BASE   (0x40)
 
 #define INTERRUPT_ENABLE (INTERRUPT_BASE + 0x00)
-#define MSI0_ENABLE      (INTERRUPT_BASE + 0x00)
 #define MSI1_ENABLE      (INTERRUPT_BASE + 0x04)
 #define MSI2_ENABLE      (INTERRUPT_BASE + 0x08)
 #define MSI3_ENABLE      (INTERRUPT_BASE + 0x0C)
@@ -57,59 +63,31 @@
 #define INTERRUPT_STATUS (INTERRUPT_BASE + 0x20)
 #define INTERRUPT_ACK    (INTERRUPT_BASE + 0x20)
 
-#define INTMASK_I2C1        (0x00000001)
-#define INTMASK_I2C2        (0x00000002)
-#define INTMASK_I2C3        (0x00000004)
-#define INTMASK_I2C4        (0x00000008)
-
-#define INTMASK_CIRQ1       (0x00000010)
-#define INTMASK_CIRQ2       (0x00000020)
-#define INTMASK_CIRQ3       (0x00000040)
-#define INTMASK_CIRQ4       (0x00000080)
-
-#define INTMASK_TSINPUT1    (0x00000100)
-#define INTMASK_TSINPUT2    (0x00000200)
-#define INTMASK_TSINPUT3    (0x00000400)
-#define INTMASK_TSINPUT4    (0x00000800)
-#define INTMASK_TSINPUT5    (0x00001000)
-#define INTMASK_TSINPUT6    (0x00002000)
-#define INTMASK_TSINPUT7    (0x00004000)
-#define INTMASK_TSINPUT8    (0x00008000)
-
-#define INTMASK_TSOUTPUT1   (0x00010000)
-#define INTMASK_TSOUTPUT2   (0x00020000)
-#define INTMASK_TSOUTPUT3   (0x00040000)
-#define INTMASK_TSOUTPUT4   (0x00080000)
+/* Temperature Monitor ( 2x LM75A @ 0x90,0x92 I2c ) */
+#define TEMPMON_BASE			(0x1c0)
+#define TEMPMON_CONTROL			(TEMPMON_BASE + 0x00)
+
+#define TEMPMON_CONTROL_AUTOSCAN	(0x00000002)
+#define TEMPMON_CONTROL_INTENABLE	(0x00000004)
+#define TEMPMON_CONTROL_OVERTEMP	(0x00008000)
+
+/* SHORT Temperature in Celsius x 256 */
+#define TEMPMON_SENSOR0			(TEMPMON_BASE + 0x04)
+#define TEMPMON_SENSOR1			(TEMPMON_BASE + 0x08)
+
+#define TEMPMON_FANCONTROL		(TEMPMON_BASE + 0x10)
 
 /* ------------------------------------------------------------------------- */
 /* I2C Master Controller */
 
-#define I2C_BASE        (0x80)  /* Byte offset */
-
 #define I2C_COMMAND     (0x00)
 #define I2C_TIMING      (0x04)
 #define I2C_TASKLENGTH  (0x08)     /* High read, low write */
 #define I2C_TASKADDRESS (0x0C)     /* High read, low write */
-
 #define I2C_MONITOR     (0x1C)
 
-#define I2C_BASE_1      (I2C_BASE + 0x00)
-#define I2C_BASE_2      (I2C_BASE + 0x20)
-#define I2C_BASE_3      (I2C_BASE + 0x40)
-#define I2C_BASE_4      (I2C_BASE + 0x60)
-
-#define I2C_BASE_N(i)   (I2C_BASE + (i) * 0x20)
-
-#define I2C_TASKMEM_BASE    (0x1000)    /* Byte offset */
-#define I2C_TASKMEM_SIZE    (0x1000)
-
 #define I2C_SPEED_400   (0x04030404)
-#define I2C_SPEED_200   (0x09080909)
-#define I2C_SPEED_154   (0x0C0B0C0C)
 #define I2C_SPEED_100   (0x13121313)
-#define I2C_SPEED_77    (0x19181919)
-#define I2C_SPEED_50    (0x27262727)
-
 
 /* ------------------------------------------------------------------------- */
 /* DMA  Controller */
@@ -117,35 +95,41 @@
 #define DMA_BASE_WRITE        (0x100)
 #define DMA_BASE_READ         (0x140)
 
-#define DMA_CONTROL     (0x00)                  /* 64 */
-#define DMA_ERROR       (0x04)                  /* 65 ( only read instance ) */
-
-#define DMA_DIAG_CONTROL                (0x1C)  /* 71 */
-#define DMA_DIAG_PACKETCOUNTER_LOW      (0x20)  /* 72 */
-#define DMA_DIAG_PACKETCOUNTER_HIGH     (0x24)  /* 73 */
-#define DMA_DIAG_TIMECOUNTER_LOW        (0x28)  /* 74 */
-#define DMA_DIAG_TIMECOUNTER_HIGH       (0x2C)  /* 75 */
-#define DMA_DIAG_RECHECKCOUNTER         (0x30)  /* 76  ( Split completions on read ) */
-#define DMA_DIAG_WAITTIMEOUTINIT        (0x34)  /* 77 */
-#define DMA_DIAG_WAITOVERFLOWCOUNTER    (0x38)  /* 78 */
-#define DMA_DIAG_WAITCOUNTER            (0x3C)  /* 79 */
+#define TS_CONTROL(_io)         (_io->regs + 0x00)
+#define TS_CONTROL2(_io)        (_io->regs + 0x04)
 
 /* ------------------------------------------------------------------------- */
 /* DMA  Buffer */
 
-#define TS_INPUT_BASE       (0x200)
-#define TS_INPUT_CONTROL(i)         (TS_INPUT_BASE + (i) * 16 + 0x00)
+#define DMA_BUFFER_CONTROL(_dma)       (_dma->regs + 0x00)
+#define DMA_BUFFER_ACK(_dma)           (_dma->regs + 0x04)
+#define DMA_BUFFER_CURRENT(_dma)       (_dma->regs + 0x08)
+#define DMA_BUFFER_SIZE(_dma)          (_dma->regs + 0x0c)
+
+/* ------------------------------------------------------------------------- */
+/* CI Interface (only CI-Bridge) */
+
+#define CI_BASE                     (0x400)
+#define CI_CONTROL(i)               (CI_BASE + (i) * 32 + 0x00)
+
+#define CI_DO_ATTRIBUTE_RW(i)       (CI_BASE + (i) * 32 + 0x04)
+#define CI_DO_IO_RW(i)              (CI_BASE + (i) * 32 + 0x08)
+#define CI_READDATA(i)              (CI_BASE + (i) * 32 + 0x0c)
+#define CI_DO_READ_ATTRIBUTES(i)    (CI_BASE + (i) * 32 + 0x10)
 
-#define TS_OUTPUT_BASE       (0x280)
-#define TS_OUTPUT_CONTROL(i)         (TS_OUTPUT_BASE + (i) * 16 + 0x00)
+#define CI_RESET_CAM                    (0x00000001)
+#define CI_POWER_ON                     (0x00000002)
+#define CI_ENABLE                       (0x00000004)
+#define CI_BYPASS_DISABLE               (0x00000010)
 
-#define DMA_BUFFER_BASE     (0x300)
+#define CI_CAM_READY                    (0x00010000)
+#define CI_CAM_DETECT                   (0x00020000)
+#define CI_READY                        (0x80000000)
 
-#define DMA_BUFFER_CONTROL(i)       (DMA_BUFFER_BASE + (i) * 16 + 0x00)
-#define DMA_BUFFER_ACK(i)           (DMA_BUFFER_BASE + (i) * 16 + 0x04)
-#define DMA_BUFFER_CURRENT(i)       (DMA_BUFFER_BASE + (i) * 16 + 0x08)
-#define DMA_BUFFER_SIZE(i)          (DMA_BUFFER_BASE + (i) * 16 + 0x0c)
+#define CI_READ_CMD                     (0x40000000)
+#define CI_WRITE_CMD                    (0x80000000)
 
-#define DMA_BASE_ADDRESS_TABLE  (0x2000)
-#define DMA_BASE_ADDRESS_TABLE_ENTRIES (512)
+#define CI_BUFFER_BASE                  (0x3000)
+#define CI_BUFFER_SIZE                  (0x0800)
 
+#define CI_BUFFER(i)                  (CI_BUFFER_BASE + (i) * CI_BUFFER_SIZE)
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 4290a1e28531..65b3f6b38bd7 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -1,7 +1,8 @@
 /*
  * ddbridge.h: Digital Devices PCIe bridge driver
  *
- * Copyright (C) 2010-2011 Digital Devices GmbH
+ * Copyright (C) 2010-2017 Digital Devices GmbH
+ *                         Ralph Metzler <rmetzler@digitaldevices.de>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -20,15 +21,39 @@
 #ifndef _DDBRIDGE_H_
 #define _DDBRIDGE_H_
 
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/poll.h>
+#include <linux/io.h>
+#include <linux/pci.h>
+#include <linux/timer.h>
+#include <linux/i2c.h>
+#include <linux/swab.h>
+#include <linux/vmalloc.h>
+#include <linux/workqueue.h>
+#include <linux/kthread.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/spi/spi.h>
+#include <linux/gpio.h>
+#include <linux/completion.h>
+
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
-#include <linux/i2c.h>
 #include <linux/mutex.h>
 #include <asm/dma.h>
-#include <linux/dvb/frontend.h>
+#include <asm/irq.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+
 #include <linux/dvb/ca.h>
 #include <linux/socket.h>
+#include <linux/device.h>
+#include <linux/io.h>
 
 #include "dmxdev.h"
 #include "dvbdev.h"
@@ -37,72 +62,121 @@
 #include "dvb_ringbuffer.h"
 #include "dvb_ca_en50221.h"
 #include "dvb_net.h"
-#include "cxd2099.h"
 
-/* MSI had problems with lost interrupts, fixed but needs testing */
-#undef CONFIG_PCI_MSI
+#define DDBRIDGE_VERSION "0.9.29-integrated"
 
-#define DDB_MAX_I2C     4
-#define DDB_MAX_PORT    4
-#define DDB_MAX_INPUT   8
-#define DDB_MAX_OUTPUT  4
+#define DDB_MAX_I2C    32
+#define DDB_MAX_PORT   32
+#define DDB_MAX_INPUT  64
+#define DDB_MAX_OUTPUT 32
 #define DDB_MAX_LINK    4
 #define DDB_LINK_SHIFT 28
 
 #define DDB_LINK_TAG(_x) (_x << DDB_LINK_SHIFT)
 
-#define DDB_XO2_TYPE_NONE	0
-#define DDB_XO2_TYPE_DUOFLEX	1
-#define DDB_XO2_TYPE_CI		2
+struct ddb_regset {
+	u32 base;
+	u32 num;
+	u32 size;
+};
+
+struct ddb_regmap {
+	u32 irq_base_i2c;
+	u32 irq_base_idma;
+	u32 irq_base_odma;
+
+	struct ddb_regset *i2c;
+	struct ddb_regset *i2c_buf;
+	struct ddb_regset *idma;
+	struct ddb_regset *idma_buf;
+	struct ddb_regset *odma;
+	struct ddb_regset *odma_buf;
+
+	struct ddb_regset *input;
+	struct ddb_regset *output;
+
+	struct ddb_regset *channel;
+};
+
+struct ddb_ids {
+	u16 vendor;
+	u16 device;
+	u16 subvendor;
+	u16 subdevice;
+
+	u32 hwid;
+	u32 regmapid;
+	u32 devid;
+	u32 mac;
+};
 
 struct ddb_info {
 	int   type;
-#define DDB_NONE		0
-#define DDB_OCTOPUS		1
-#define DDB_OCTOPUS_MAX_CT	6
+#define DDB_NONE         0
+#define DDB_OCTOPUS      1
+#define DDB_OCTOPUS_CI   2
+#define DDB_OCTOPUS_MAX_CT  6
 	char *name;
-	int   port_num;
-	u32   port_type[DDB_MAX_PORT];
+	u32   i2c_mask;
+	u8    port_num;
+	u8    led_num;
+	u8    fan_num;
+	u8    temp_num;
+	u8    temp_bus;
 	u32   board_control;
 	u32   board_control_2;
+	u8    mdio_num;
+	u8    con_clock; /* use a continuous clock */
 	u8    ts_quirks;
 #define TS_QUIRK_SERIAL   1
 #define TS_QUIRK_REVERSED 2
 #define TS_QUIRK_ALT_OSC  8
+	u32   tempmon_irq;
+	struct ddb_regmap *regmap;
 };
 
-/* DMA_SIZE MUST be divisible by 188 and 128 !!! */
+/* DMA_SIZE MUST be smaller than 256k and
+ * MUST be divisible by 188 and 128 !!!
+ */
+
+#define DMA_MAX_BUFS 32      /* hardware table limit */
 
-#define INPUT_DMA_MAX_BUFS 32      /* hardware table limit */
 #define INPUT_DMA_BUFS 8
 #define INPUT_DMA_SIZE (128*47*21)
+#define INPUT_DMA_IRQ_DIV 1
 
-#define OUTPUT_DMA_MAX_BUFS 32
 #define OUTPUT_DMA_BUFS 8
 #define OUTPUT_DMA_SIZE (128*47*21)
+#define OUTPUT_DMA_IRQ_DIV 1
 
 struct ddb;
 struct ddb_port;
 
-struct ddb_input {
-	struct ddb_port       *port;
-	u32                    nr;
-	int                    attached;
+struct ddb_dma {
+	void                  *io;
+	u32                    regs;
+	u32                    bufregs;
 
-	dma_addr_t             pbuf[INPUT_DMA_MAX_BUFS];
-	u8                    *vbuf[INPUT_DMA_MAX_BUFS];
-	u32                    dma_buf_num;
-	u32                    dma_buf_size;
+	dma_addr_t             pbuf[DMA_MAX_BUFS];
+	u8                    *vbuf[DMA_MAX_BUFS];
+	u32                    num;
+	u32                    size;
+	u32                    div;
+	u32                    bufval;
 
-	struct tasklet_struct  tasklet;
+	struct work_struct     work;
 	spinlock_t             lock;
 	wait_queue_head_t      wq;
 	int                    running;
 	u32                    stat;
+	u32                    ctrl;
 	u32                    cbuf;
 	u32                    coff;
+};
 
-	struct dvb_adapter     adap;
+struct ddb_dvb {
+	struct dvb_adapter    *adap;
+	int                    adap_registered;
 	struct dvb_device     *dev;
 	struct i2c_client     *i2c_client[1];
 	struct dvb_frontend   *fe;
@@ -113,131 +187,245 @@ struct ddb_input {
 	struct dmx_frontend    hw_frontend;
 	struct dmx_frontend    mem_frontend;
 	int                    users;
-	int (*gate_ctrl)(struct dvb_frontend *, int);
+	u32                    attached;
+	u8                     input;
+
+	enum fe_sec_tone_mode  tone;
+	enum fe_sec_voltage    voltage;
+
+	int (*i2c_gate_ctrl)(struct dvb_frontend *, int);
+	int (*set_voltage)(struct dvb_frontend *fe,
+		enum fe_sec_voltage voltage);
+	int (*set_input)(struct dvb_frontend *fe, int input);
+	int (*diseqc_send_master_cmd)(struct dvb_frontend *fe,
+		struct dvb_diseqc_master_cmd *cmd);
 };
 
-struct ddb_output {
+struct ddb_ci {
+	struct dvb_ca_en50221  en;
 	struct ddb_port       *port;
 	u32                    nr;
-	dma_addr_t             pbuf[OUTPUT_DMA_MAX_BUFS];
-	u8                    *vbuf[OUTPUT_DMA_MAX_BUFS];
-	u32                    dma_buf_num;
-	u32                    dma_buf_size;
-	struct tasklet_struct  tasklet;
-	spinlock_t             lock;
-	wait_queue_head_t      wq;
-	int                    running;
-	u32                    stat;
-	u32                    cbuf;
-	u32                    coff;
+	struct mutex           lock;
+};
 
-	struct dvb_adapter     adap;
-	struct dvb_device     *dev;
+struct ddb_io {
+	struct ddb_port       *port;
+	u32                    nr;
+	u32                    regs;
+	struct ddb_dma        *dma;
+	struct ddb_io         *redo;
+	struct ddb_io         *redi;
 };
 
+#define ddb_output ddb_io
+#define ddb_input ddb_io
+
 struct ddb_i2c {
 	struct ddb            *dev;
 	u32                    nr;
-	struct i2c_adapter     adap;
-	struct i2c_adapter     adap2;
 	u32                    regs;
+	u32                    link;
+	struct i2c_adapter     adap;
 	u32                    rbuf;
 	u32                    wbuf;
-	int                    done;
-	wait_queue_head_t      wq;
+	u32                    bsize;
+	struct completion      completion;
 };
 
 struct ddb_port {
 	struct ddb            *dev;
 	u32                    nr;
+	u32                    pnr;
+	u32                    regs;
+	u32                    lnr;
 	struct ddb_i2c        *i2c;
 	struct mutex           i2c_gate_lock;
 	u32                    class;
 #define DDB_PORT_NONE           0
 #define DDB_PORT_CI             1
 #define DDB_PORT_TUNER          2
-	u32                    type;
-#define DDB_TUNER_NONE			0
-#define DDB_TUNER_DVBS_ST		1
-#define DDB_TUNER_DVBS_ST_AA		2
-#define DDB_TUNER_DVBCT2_SONY_P		7
-#define DDB_TUNER_DVBC2T2_SONY_P	8
-#define DDB_TUNER_ISDBT_SONY_P		9
-#define DDB_TUNER_DVBS_STV0910_P	10
-#define DDB_TUNER_DVBS_STV0910_PR	14
-#define DDB_TUNER_DVBC2T2I_SONY_P	15
-#define DDB_TUNER_DVBCT_TR		16
-#define DDB_TUNER_DVBCT_ST		17
-#define DDB_TUNER_XO2_DVBS_STV0910	32
-#define DDB_TUNER_XO2_DVBCT2_SONY	33
-#define DDB_TUNER_XO2_ISDBT_SONY	34
-#define DDB_TUNER_XO2_DVBC2T2_SONY	35
-#define DDB_TUNER_XO2_ATSC_ST		36
-#define DDB_TUNER_XO2_DVBC2T2I_SONY	37
-
-	u32                    adr;
+#define DDB_PORT_LOOP           3
+	char                   *name;
+	char                   *type_name;
+	u32                     type;
+#define DDB_TUNER_NONE           0
+#define DDB_TUNER_DVBS_ST        1
+#define DDB_TUNER_DVBS_ST_AA     2
+#define DDB_TUNER_DVBCT_TR       3
+#define DDB_TUNER_DVBCT_ST       4
+#define DDB_CI_INTERNAL          5
+#define DDB_CI_EXTERNAL_SONY     6
+#define DDB_TUNER_DVBCT2_SONY_P  7
+#define DDB_TUNER_DVBC2T2_SONY_P 8
+#define DDB_TUNER_ISDBT_SONY_P   9
+#define DDB_TUNER_DVBS_STV0910_P 10
+#define DDB_TUNER_MXL5XX         11
+#define DDB_CI_EXTERNAL_XO2      12
+#define DDB_CI_EXTERNAL_XO2_B    13
+#define DDB_TUNER_DVBS_STV0910_PR 14
+#define DDB_TUNER_DVBC2T2I_SONY_P 15
+
+#define DDB_TUNER_XO2            32
+#define DDB_TUNER_DVBS_STV0910   (DDB_TUNER_XO2 + 0)
+#define DDB_TUNER_DVBCT2_SONY    (DDB_TUNER_XO2 + 1)
+#define DDB_TUNER_ISDBT_SONY     (DDB_TUNER_XO2 + 2)
+#define DDB_TUNER_DVBC2T2_SONY   (DDB_TUNER_XO2 + 3)
+#define DDB_TUNER_ATSC_ST        (DDB_TUNER_XO2 + 4)
+#define DDB_TUNER_DVBC2T2I_SONY  (DDB_TUNER_XO2 + 5)
 
 	struct ddb_input      *input[2];
 	struct ddb_output     *output;
 	struct dvb_ca_en50221 *en;
+	struct ddb_dvb         dvb[2];
+	u32                    gap;
+	u32                    obr;
+	u8                     creg;
+};
+
+#define CM_STARTUP_DELAY 2
+#define CM_AVERAGE  20
+#define CM_GAIN     10
+
+#define HW_LSB_SHIFT    12
+#define HW_LSB_MASK     0x1000
+
+#define CM_IDLE    0
+#define CM_STARTUP 1
+#define CM_ADJUST  2
+
+#define TS_CAPTURE_LEN  (4096)
+
+struct ddb_link {
+	struct ddb            *dev;
+	struct ddb_info       *info;
+	u32                    nr;
+	u32                    regs;
+	spinlock_t             lock;
+	struct mutex           flash_mutex;
+	struct tasklet_struct  tasklet;
+	struct ddb_ids         ids;
+
+	spinlock_t             temp_lock;
+	int                    overtemperature_error;
+	u8                     temp_tab[11];
 };
 
 struct ddb {
 	struct pci_dev        *pdev;
+	struct platform_device *pfdev;
+	struct device         *dev;
+
+	int                    msi;
+	struct workqueue_struct *wq;
+	u32                    has_dma;
+
+	struct ddb_link        link[DDB_MAX_LINK];
 	unsigned char __iomem *regs;
+	u32                    regs_len;
+	u32                    port_num;
 	struct ddb_port        port[DDB_MAX_PORT];
+	u32                    i2c_num;
 	struct ddb_i2c         i2c[DDB_MAX_I2C];
 	struct ddb_input       input[DDB_MAX_INPUT];
 	struct ddb_output      output[DDB_MAX_OUTPUT];
+	struct dvb_adapter     adap[DDB_MAX_INPUT];
+	struct ddb_dma         idma[DDB_MAX_INPUT];
+	struct ddb_dma         odma[DDB_MAX_OUTPUT];
+
+	void                   (*handler[4][256])(unsigned long);
+	unsigned long          handler_data[4][256];
 
 	struct device         *ddb_dev;
-	int                    nr;
+	u32                    ddb_dev_users;
+	u32                    nr;
 	u8                     iobuf[1028];
 
-	struct ddb_info       *info;
-	int                    msi;
+	u8                     leds;
+	u32                    ts_irq;
+	u32                    i2c_irq;
+
+	struct mutex           mutex;
+
+	u8                     tsbuf[TS_CAPTURE_LEN];
 };
 
-/****************************************************************************/
+static inline u32 ddblreadl(struct ddb_link *link, u32 adr)
+{
+	return readl((char *) (link->dev->regs + (adr)));
+}
 
-#define ddbwritel(_val, _adr)        writel((_val), \
-				     dev->regs+(_adr))
-#define ddbreadl(_adr)               readl(dev->regs+(_adr))
-#define ddbcpyto(_adr, _src, _count) memcpy_toio(dev->regs+(_adr), (_src), (_count))
-#define ddbcpyfrom(_dst, _adr, _count) memcpy_fromio((_dst), dev->regs+(_adr), (_count))
+static inline void ddblwritel(struct ddb_link *link, u32 val, u32 adr)
+{
+	writel(val, (char *) (link->dev->regs + (adr)));
+}
 
-/****************************************************************************/
+static inline u32 ddbreadl(struct ddb *dev, u32 adr)
+{
+	return readl((char *) (dev->regs + (adr)));
+}
+
+static inline void ddbwritel(struct ddb *dev, u32 val, u32 adr)
+{
+	writel(val, (char *) (dev->regs + (adr)));
+}
+
+static inline void ddbcpyto(struct ddb *dev, u32 adr, void *src, long count)
+{
+	return memcpy_toio((char *) (dev->regs + adr), src, count);
+}
+
+static inline void ddbcpyfrom(struct ddb *dev, void *dst, u32 adr, long count)
+{
+	return memcpy_fromio(dst, (char *) (dev->regs + adr), count);
+}
 
 static inline u32 safe_ddbreadl(struct ddb *dev, u32 adr)
 {
-        u32 val = ddbreadl(adr);
+	u32 val = ddbreadl(dev, adr);
 
-        /* (ddb)readl returns (uint)-1 (all bits set) on failure, catch that */
-        if (val == ~0) {
-                dev_err(&dev->pdev->dev, "ddbreadl failure, adr=%08x\n", adr);
-                return 0;
-        }
+	/* (ddb)readl returns (uint)-1 (all bits set) on failure, catch that */
+	if (val == ~0) {
+		dev_err(&dev->pdev->dev, "ddbreadl failure, adr=%08x\n", adr);
+		return 0;
+	}
 
 	return val;
 }
 
 /****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+
+int ddbridge_flashread(struct ddb *dev, u32 link, u8 *buf, u32 addr, u32 len);
+
+/****************************************************************************/
 
 /* ddbridge-main.c (modparams) */
+extern int adapter_alloc;
+extern int msi;
+extern int ci_bitrate;
+extern int ts_loop;
 extern int xo2_speed;
+extern int alt_dma;
+extern int no_init;
 extern int stv0910_single;
+extern struct workqueue_struct *ddb_wq;
 
 /* ddbridge-core.c */
+extern struct ddb_regmap octopus_map;
 void ddb_ports_detach(struct ddb *dev);
 void ddb_ports_release(struct ddb *dev);
 void ddb_buffers_free(struct ddb *dev);
 void ddb_device_destroy(struct ddb *dev);
-irqreturn_t irq_handler(int irq, void *dev_id);
+irqreturn_t ddb_irq_handler0(int irq, void *dev_id);
+irqreturn_t ddb_irq_handler1(int irq, void *dev_id);
+irqreturn_t ddb_irq_handler(int irq, void *dev_id);
 void ddb_ports_init(struct ddb *dev);
 int ddb_buffers_alloc(struct ddb *dev);
 int ddb_ports_attach(struct ddb *dev);
 int ddb_device_create(struct ddb *dev);
 int ddb_class_create(void);
 void ddb_class_destroy(void);
+int ddb_init(struct ddb *dev);
 
-#endif
+#endif /* DDBRIDGE_H */
-- 
2.13.0
