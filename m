Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51544 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451AbaHBDtP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Aug 2014 23:49:15 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/5] ddbridge: add needed files from manufacturer driver 0.9.15a
Date: Sat,  2 Aug 2014 06:48:54 +0300
Message-Id: <1406951335-24026-5-git-send-email-crope@iki.fi>
In-Reply-To: <1406951335-24026-1-git-send-email-crope@iki.fi>
References: <1406951335-24026-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add files:
ddbridge.c
ddbridge-core.c
ddbridge.h
ddbridge-i2c.c
ddbridge-regs.h

These files are taken, without any modification, from the latest
Digital Devices (device manufacturer) Linux driver version 0.9.15a.

md5sum dddvb-0.9.15a.tar.bz2 e7f313ce5b548aeb55d168ad8b34b91a

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 3735 ++++++++++++++++++++++++++++
 drivers/media/pci/ddbridge/ddbridge-i2c.c  |  257 ++
 drivers/media/pci/ddbridge/ddbridge-regs.h |  436 ++++
 drivers/media/pci/ddbridge/ddbridge.c      |  460 ++++
 drivers/media/pci/ddbridge/ddbridge.h      |  499 ++++
 5 files changed, 5387 insertions(+)
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-core.c
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-i2c.c
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-regs.h
 create mode 100644 drivers/media/pci/ddbridge/ddbridge.c
 create mode 100644 drivers/media/pci/ddbridge/ddbridge.h

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
new file mode 100644
index 0000000..a301be6
--- /dev/null
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -0,0 +1,3735 @@
+/*
+ * ddbridge-core.c: Digital Devices bridge core functions
+ *
+ * Copyright (C) 2010-2013 Digital Devices GmbH
+ *                         Ralph Metzler <rmetzler@digitaldevices.de>
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA
+ * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
+ */
+
+DEFINE_MUTEX(redirect_lock);
+
+static int ci_bitrate = 72000;
+module_param(ci_bitrate, int, 0444);
+MODULE_PARM_DESC(ci_bitrate, " Bitrate for output to CI.");
+
+static int ts_loop = -1;
+module_param(ts_loop, int, 0444);
+MODULE_PARM_DESC(ts_loop, "TS in/out test loop on port ts_loop");
+
+static int vlan;
+module_param(vlan, int, 0444);
+MODULE_PARM_DESC(vlan, "VLAN and QoS IDs enabled");
+
+static int tt;
+module_param(tt, int, 0444);
+MODULE_PARM_DESC(tt, "");
+
+#define DDB_MAX_ADAPTER 32
+static struct ddb *ddbs[DDB_MAX_ADAPTER];
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+#include "ddbridge-mod.c"
+#include "ddbridge-i2c.c"
+#include "ddbridge-ns.c"
+
+
+static void ddb_set_dma_table(struct ddb *dev, struct ddb_dma *dma)
+{
+	u32 i, base;
+	u64 mem;
+
+	if (!dma)
+		return;
+	base = DMA_BASE_ADDRESS_TABLE + dma->nr * 0x100;
+	for (i = 0; i < dma->num; i++) {
+		mem = dma->pbuf[i];
+		ddbwritel(dev, mem & 0xffffffff, base + i * 8);
+		ddbwritel(dev, mem >> 32, base + i * 8 + 4);
+	}
+	dma->bufreg = (dma->div << 16) |
+		((dma->num & 0x1f) << 11) |
+		((dma->size >> 7) & 0x7ff);
+}
+
+static void ddb_set_dma_tables(struct ddb *dev)
+{
+	u32 i;
+
+	for (i = 0; i < dev->info->port_num * 2; i++)
+		ddb_set_dma_table(dev, dev->input[i].dma);
+	for (i = 0; i < dev->info->port_num; i++)
+		ddb_set_dma_table(dev, dev->output[i].dma);
+}
+
+
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+
+static void ddb_redirect_dma(struct ddb *dev,
+			     struct ddb_dma *sdma,
+			     struct ddb_dma *ddma)
+{
+	u32 i, base;
+	u64 mem;
+
+	sdma->bufreg = ddma->bufreg;
+	base = DMA_BASE_ADDRESS_TABLE + sdma->nr * 0x100;
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
+	/*pr_info("unredirect %d.%d\n", port->dev->nr, port->nr);*/
+	mutex_lock(&redirect_lock);
+	if (port->output->dma->running) {
+		mutex_unlock(&redirect_lock);
+		return -EBUSY;
+	}
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
+}
+
+static int ddb_redirect(u32 i, u32 p)
+{
+	struct ddb *idev = ddbs[(i >> 4) & 0x1f];
+	struct ddb_input *input, *input2;
+	struct ddb *pdev = ddbs[(p >> 4) & 0x1f];
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
+	}
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
+}
+
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+
+#ifdef DDB_ALT_DMA
+static void dma_free(struct pci_dev *pdev, struct ddb_dma *dma, int dir)
+{
+	int i;
+
+	if (!dma)
+		return;
+	for (i = 0; i < dma->num; i++) {
+		if (dma->vbuf[i]) {
+			dma_unmap_single(&pdev->dev, dma->pbuf[i],
+					 dma->size,
+					 dir ? DMA_TO_DEVICE :
+					 DMA_FROM_DEVICE);
+			kfree(dma->vbuf[i]);
+			dma->vbuf[i] = 0;
+		}
+	}
+}
+
+static int dma_alloc(struct pci_dev *pdev, struct ddb_dma *dma, int dir)
+{
+	int i;
+
+	if (!dma)
+		return 0;
+	for (i = 0; i < dma->num; i++) {
+		dma->vbuf[i] = kmalloc(dma->size, __GFP_REPEAT);
+		if (!dma->vbuf[i])
+			return -ENOMEM;
+		dma->pbuf[i] = dma_map_single(&pdev->dev, dma->vbuf[i],
+					      dma->size,
+					      dir ? DMA_TO_DEVICE :
+					      DMA_FROM_DEVICE);
+		if (dma_mapping_error(&pdev->dev, dma->pbuf[i])) {
+			kfree(dma->vbuf[i]);
+			return -ENOMEM;
+		}
+	}
+	return 0;
+}
+#else
+
+static void dma_free(struct pci_dev *pdev, struct ddb_dma *dma, int dir)
+{
+	int i;
+
+	if (!dma)
+		return;
+	for (i = 0; i < dma->num; i++) {
+		if (dma->vbuf[i]) {
+			pci_free_consistent(pdev, dma->size,
+					    dma->vbuf[i], dma->pbuf[i]);
+			dma->vbuf[i] = 0;
+		}
+	}
+}
+
+static int dma_alloc(struct pci_dev *pdev, struct ddb_dma *dma, int dir)
+{
+	int i;
+
+	if (!dma)
+		return 0;
+	for (i = 0; i < dma->num; i++) {
+		dma->vbuf[i] = pci_alloc_consistent(pdev, dma->size,
+						    &dma->pbuf[i]);
+		if (!dma->vbuf[i])
+			return -ENOMEM;
+	}
+	return 0;
+}
+#endif
+
+static int ddb_buffers_alloc(struct ddb *dev)
+{
+	int i;
+	struct ddb_port *port;
+
+	for (i = 0; i < dev->info->port_num; i++) {
+		port = &dev->port[i];
+		switch (port->class) {
+		case DDB_PORT_TUNER:
+			if (dma_alloc(dev->pdev, port->input[0]->dma, 0) < 0)
+				return -1;
+			if (dma_alloc(dev->pdev, port->input[1]->dma, 0) < 0)
+				return -1;
+			break;
+		case DDB_PORT_CI:
+		case DDB_PORT_LOOP:
+			if (dma_alloc(dev->pdev, port->input[0]->dma, 0) < 0)
+				return -1;
+		case DDB_PORT_MOD:
+			if (dma_alloc(dev->pdev, port->output->dma, 1) < 0)
+				return -1;
+			break;
+		default:
+			break;
+		}
+	}
+	ddb_set_dma_tables(dev);
+	return 0;
+}
+
+static void ddb_buffers_free(struct ddb *dev)
+{
+	int i;
+	struct ddb_port *port;
+
+	for (i = 0; i < dev->info->port_num; i++) {
+		port = &dev->port[i];
+
+		if (port->input[0])
+			dma_free(dev->pdev, port->input[0]->dma, 0);
+		if (port->input[1])
+			dma_free(dev->pdev, port->input[1]->dma, 0);
+		if (port->output)
+			dma_free(dev->pdev, port->output->dma, 1);
+	}
+}
+
+static void ddb_output_start(struct ddb_output *output)
+{
+	struct ddb *dev = output->port->dev;
+	u32 con2;
+
+	con2 = ((output->port->obr << 13) + 71999) / 72000;
+	con2 = (con2 << 16) | output->port->gap;
+
+	if (output->dma) {
+		spin_lock_irq(&output->dma->lock);
+		output->dma->cbuf = 0;
+		output->dma->coff = 0;
+		output->dma->stat = 0;
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
+		ddbwritel(dev, output->dma->bufreg,
+			  DMA_BUFFER_SIZE(output->dma->nr));
+		ddbwritel(dev, 0, DMA_BUFFER_ACK(output->dma->nr));
+		ddbwritel(dev, 1, DMA_BASE_READ);
+		ddbwritel(dev, 3, DMA_BUFFER_CONTROL(output->dma->nr));
+	}
+	if (output->port->class != DDB_PORT_MOD) {
+		if (output->port->input[0]->port->class == DDB_PORT_LOOP)
+			/*ddbwritel(dev, 0x15, TS_OUTPUT_CONTROL(output->nr));
+			  ddbwritel(dev, 0x45,
+			  TS_OUTPUT_CONTROL(output->nr));*/
+			ddbwritel(dev, (1 << 13) | 0x15,
+				  TS_OUTPUT_CONTROL(output->nr));
+		else
+			ddbwritel(dev, 0x1d, TS_OUTPUT_CONTROL(output->nr));
+	}
+	if (output->dma) {
+		output->dma->running = 1;
+		spin_unlock_irq(&output->dma->lock);
+	}
+}
+
+static void ddb_output_stop(struct ddb_output *output)
+{
+	struct ddb *dev = output->port->dev;
+
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
+}
+
+static void ddb_input_stop(struct ddb_input *input)
+{
+	struct ddb *dev = input->port->dev;
+
+	if (input->dma)
+		spin_lock_irq(&input->dma->lock);
+	ddbwritel(dev, 0, TS_INPUT_CONTROL(input->nr));
+	if (input->dma) {
+		ddbwritel(dev, 0, DMA_BUFFER_CONTROL(input->dma->nr));
+		input->dma->running = 0;
+		spin_unlock_irq(&input->dma->lock);
+	}
+	/*pr_info("input_stop %d.%d\n", dev->nr, input->nr);*/
+}
+
+static void ddb_input_start(struct ddb_input *input)
+{
+	struct ddb *dev = input->port->dev;
+
+	if (input->dma) {
+		spin_lock_irq(&input->dma->lock);
+		input->dma->cbuf = 0;
+		input->dma->coff = 0;
+		input->dma->stat = 0;
+		ddbwritel(dev, 0, DMA_BUFFER_CONTROL(input->dma->nr));
+	}
+	ddbwritel(dev, 0, TS_INPUT_CONTROL2(input->nr));
+	ddbwritel(dev, 0, TS_INPUT_CONTROL(input->nr));
+	ddbwritel(dev, 2, TS_INPUT_CONTROL(input->nr));
+	ddbwritel(dev, 0, TS_INPUT_CONTROL(input->nr));
+
+	if (input->dma) {
+		ddbwritel(dev, input->dma->bufreg,
+			  DMA_BUFFER_SIZE(input->dma->nr));
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
+	/*pr_info("input_start %d.%d\n", dev->nr, input->nr);*/
+}
+
+
+static int ddb_dvb_input_start(struct ddb_input *input)
+{
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+
+	if (!dvb->users)
+		ddb_input_start(input);
+
+	return ++dvb->users;
+}
+
+static int ddb_dvb_input_stop(struct ddb_input *input)
+{
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+
+	if (--dvb->users)
+		return dvb->users;
+
+	ddb_input_stop(input);
+	return 0;
+}
+
+static void ddb_input_start_all(struct ddb_input *input)
+{
+	struct ddb_input *i = input;
+	struct ddb_output *o;
+
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
+
+static void ddb_input_stop_all(struct ddb_input *input)
+{
+	struct ddb_input *i = input;
+	struct ddb_output *o;
+
+	mutex_lock(&redirect_lock);
+	ddb_input_stop(input);
+	while (i && (o = i->redo)) {
+		ddb_output_stop(o);
+		i = o->port->input[0];
+		if (i)
+			ddb_input_stop(i);
+	}
+	mutex_unlock(&redirect_lock);
+}
+
+static u32 ddb_output_free(struct ddb_output *output)
+{
+	u32 idx, off, stat = output->dma->stat;
+	s32 diff;
+
+	idx = (stat >> 11) & 0x1f;
+	off = (stat & 0x7ff) << 7;
+
+	if (output->dma->cbuf != idx) {
+		if ((((output->dma->cbuf + 1) % output->dma->num) == idx) &&
+		    (output->dma->size - output->dma->coff <= 188))
+			return 0;
+		return 188;
+	}
+	diff = off - output->dma->coff;
+	if (diff <= 0 || diff > 188)
+		return 188;
+	return 0;
+}
+
+#if 0
+static u32 ddb_dma_free(struct ddb_dma *dma)
+{
+	u32 idx, off, stat = dma->stat;
+	s32 p1, p2, diff;
+
+	idx = (stat >> 11) & 0x1f;
+	off = (stat & 0x7ff) << 7;
+
+	p1 = idx * dma->size + off;
+	p2 = dma->cbuf * dma->size + dma->coff;
+
+	diff = p1 - p2;
+	if (diff <= 0)
+		diff += dma->num * dma->size;
+	return diff;
+}
+#endif
+
+static ssize_t ddb_output_write(struct ddb_output *output,
+				const u8 *buf, size_t count)
+{
+	struct ddb *dev = output->port->dev;
+	u32 idx, off, stat = output->dma->stat;
+	u32 left = count, len;
+
+	idx = (stat >> 11) & 0x1f;
+	off = (stat & 0x7ff) << 7;
+
+	while (left) {
+		len = output->dma->size - output->dma->coff;
+		if ((((output->dma->cbuf + 1) % output->dma->num) == idx) &&
+		    (off == 0)) {
+			if (len <= 188)
+				break;
+			len -= 188;
+		}
+		if (output->dma->cbuf == idx) {
+			if (off > output->dma->coff) {
+				len = off - output->dma->coff;
+				len -= (len % 188);
+				if (len <= 188)
+					break;
+				len -= 188;
+			}
+		}
+		if (len > left)
+			len = left;
+		if (copy_from_user(output->dma->vbuf[output->dma->cbuf] +
+				   output->dma->coff,
+				   buf, len))
+			return -EIO;
+#ifdef DDB_ALT_DMA
+		dma_sync_single_for_device(dev->dev,
+					   output->dma->pbuf[
+						   output->dma->cbuf],
+					   output->dma->size, DMA_TO_DEVICE);
+#endif
+		left -= len;
+		buf += len;
+		output->dma->coff += len;
+		if (output->dma->coff == output->dma->size) {
+			output->dma->coff = 0;
+			output->dma->cbuf = ((output->dma->cbuf + 1) %
+					     output->dma->num);
+		}
+		ddbwritel(dev,
+			  (output->dma->cbuf << 11) |
+			  (output->dma->coff >> 7),
+			  DMA_BUFFER_ACK(output->dma->nr));
+	}
+	return count - left;
+}
+
+#if 0
+static u32 ddb_input_free_bytes(struct ddb_input *input)
+{
+	struct ddb *dev = input->port->dev;
+	u32 idx, off, stat = input->dma->stat;
+	u32 ctrl = ddbreadl(dev, DMA_BUFFER_CONTROL(input->dma->nr));
+
+	idx = (stat >> 11) & 0x1f;
+	off = (stat & 0x7ff) << 7;
+
+	if (ctrl & 4)
+		return 0;
+	if (input->dma->cbuf != idx)
+		return 1;
+	return 0;
+}
+
+
+
+static s32 ddb_output_used_bufs(struct ddb_output *output)
+{
+	u32 idx, off, stat, ctrl;
+	s32 diff;
+
+	spin_lock_irq(&output->dma->lock);
+	stat = output->dma->stat;
+	ctrl = output->dma->ctrl;
+	spin_unlock_irq(&output->dma->lock);
+
+	idx = (stat >> 11) & 0x1f;
+	off = (stat & 0x7ff) << 7;
+
+	if (ctrl & 4)
+		return 0;
+	diff = output->dma->cbuf - idx;
+	if (diff == 0 && off < output->dma->coff)
+		return 0;
+	if (diff <= 0)
+		diff += output->dma->num;
+	return diff;
+}
+
+static s32 ddb_input_free_bufs(struct ddb_input *input)
+{
+	u32 idx, off, stat, ctrl;
+	s32 free;
+
+	spin_lock_irq(&input->dma->lock);
+	ctrl = input->dma->ctrl;
+	stat = input->dma->stat;
+	spin_unlock_irq(&input->dma->lock);
+	if (ctrl & 4)
+		return 0;
+	idx = (stat >> 11) & 0x1f;
+	off = (stat & 0x7ff) << 7;
+	free = input->dma->cbuf - idx;
+	if (free == 0 && off < input->dma->coff)
+		return 0;
+	if (free <= 0)
+		free += input->dma->num;
+	return free - 1;
+}
+
+static u32 ddb_output_ok(struct ddb_output *output)
+{
+	struct ddb_input *input = output->port->input[0];
+	s32 diff;
+
+	diff = ddb_input_free_bufs(input) - ddb_output_used_bufs(output);
+	if (diff > 0)
+		return 1;
+	return 0;
+}
+#endif
+
+static u32 ddb_input_avail(struct ddb_input *input)
+{
+	struct ddb *dev = input->port->dev;
+	u32 idx, off, stat = input->dma->stat;
+	u32 ctrl = ddbreadl(dev, DMA_BUFFER_CONTROL(input->dma->nr));
+
+	idx = (stat >> 11) & 0x1f;
+	off = (stat & 0x7ff) << 7;
+
+	if (ctrl & 4) {
+		pr_err("IA %d %d %08x\n", idx, off, ctrl);
+		ddbwritel(dev, stat, DMA_BUFFER_ACK(input->dma->nr));
+		return 0;
+	}
+	if (input->dma->cbuf != idx)
+		return 188;
+	return 0;
+}
+
+static size_t ddb_input_read(struct ddb_input *input, u8 *buf, size_t count)
+{
+	struct ddb *dev = input->port->dev;
+	u32 left = count;
+	u32 idx, off, free, stat = input->dma->stat;
+	int ret;
+
+	idx = (stat >> 11) & 0x1f;
+	off = (stat & 0x7ff) << 7;
+
+	while (left) {
+		if (input->dma->cbuf == idx)
+			return count - left;
+		free = input->dma->size - input->dma->coff;
+		if (free > left)
+			free = left;
+#ifdef DDB_ALT_DMA
+		dma_sync_single_for_cpu(dev->dev,
+					input->dma->pbuf[input->dma->cbuf],
+					input->dma->size, DMA_FROM_DEVICE);
+#endif
+		ret = copy_to_user(buf, input->dma->vbuf[input->dma->cbuf] +
+				   input->dma->coff, free);
+		if (ret)
+			return -EFAULT;
+		input->dma->coff += free;
+		if (input->dma->coff == input->dma->size) {
+			input->dma->coff = 0;
+			input->dma->cbuf = (input->dma->cbuf + 1) %
+				input->dma->num;
+		}
+		left -= free;
+		ddbwritel(dev,
+			  (input->dma->cbuf << 11) | (input->dma->coff >> 7),
+			  DMA_BUFFER_ACK(input->dma->nr));
+	}
+	return count;
+}
+
+/****************************************************************************/
+/****************************************************************************/
+
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
+	size_t left = count;
+	int stat;
+
+	if (!dev->has_dma)
+		return -EINVAL;
+	while (left) {
+		if (ddb_input_avail(input) < 188) {
+			if (file->f_flags & O_NONBLOCK)
+				break;
+			if (wait_event_interruptible(
+				    input->dma->wq,
+				    ddb_input_avail(input) >= 188) < 0)
+				break;
+		}
+		stat = ddb_input_read(input, buf, left);
+		if (stat < 0)
+			return stat;
+		left -= stat;
+		buf += stat;
+	}
+	return (count && (left == count)) ? -EAGAIN : (count - left);
+}
+
+static unsigned int ts_poll(struct file *file, poll_table *wait)
+{
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
+	}
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
+	err = dvb_generic_open(inode, file);
+	if (err < 0)
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
+
+/****************************************************************************/
+/****************************************************************************/
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
+
+#if 0
+static struct ddb_input *fe2input(struct ddb *dev, struct dvb_frontend *fe)
+{
+	int i;
+
+	for (i = 0; i < dev->info->port_num * 2; i++) {
+		if (dev->input[i].fe == fe)
+			return &dev->input[i];
+	}
+	return NULL;
+}
+#endif
+
+static int locked_gate_ctrl(struct dvb_frontend *fe, int enable)
+{
+	struct ddb_input *input = fe->sec_priv;
+	struct ddb_port *port = input->port;
+	struct ddb_dvb *dvb = &port->dvb[input->nr & 1];
+	int status;
+
+	if (enable) {
+		mutex_lock(&port->i2c_gate_lock);
+		status = dvb->i2c_gate_ctrl(fe, 1);
+	} else {
+		status = dvb->i2c_gate_ctrl(fe, 0);
+		mutex_unlock(&port->i2c_gate_lock);
+	}
+	return status;
+}
+
+#ifdef CONFIG_DVB_DRXK
+static int demod_attach_drxk(struct ddb_input *input)
+{
+	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct dvb_frontend *fe;
+
+	fe = dvb->fe = dvb_attach(drxk_attach,
+				  i2c, 0x29 + (input->nr&1),
+				  &dvb->fe2);
+	if (!fe) {
+		pr_err("No DRXK found!\n");
+		return -ENODEV;
+	}
+	fe->sec_priv = input;
+	dvb->i2c_gate_ctrl = fe->ops.i2c_gate_ctrl;
+	fe->ops.i2c_gate_ctrl = locked_gate_ctrl;
+	return 0;
+}
+#endif
+
+#if 0
+struct stv0367_config stv0367_0 = {
+	.demod_address = 0x1f,
+	.xtal = 27000000,
+	.if_khz = 5000,
+	.if_iq_mode = FE_TER_NORMAL_IF_TUNER,
+	.ts_mode = STV0367_SERIAL_PUNCT_CLOCK,
+	.clk_pol = STV0367_RISINGEDGE_CLOCK,
+};
+
+struct stv0367_config stv0367_1 = {
+	.demod_address = 0x1e,
+	.xtal = 27000000,
+	.if_khz = 5000,
+	.if_iq_mode = FE_TER_NORMAL_IF_TUNER,
+	.ts_mode = STV0367_SERIAL_PUNCT_CLOCK,
+	.clk_pol = STV0367_RISINGEDGE_CLOCK,
+};
+
+
+static int demod_attach_stv0367(struct ddb_input *input)
+{
+	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct dvb_frontend *fe;
+
+	fe = dvb->fe = dvb_attach(stv0367ter_attach,
+				  (input->nr & 1) ? &stv0367_1 : &stv0367_0,
+				  i2c);
+	if (!dvb->fe) {
+		pr_err("No stv0367 found!\n");
+		return -ENODEV;
+	}
+	fe->sec_priv = input;
+	dvb->i2c_gate_ctrl = fe->ops.i2c_gate_ctrl;
+	fe->ops.i2c_gate_ctrl = locked_gate_ctrl;
+	return 0;
+}
+#endif
+
+struct cxd2843_cfg cxd2843_0 = {
+	.adr = 0x6c,
+};
+
+struct cxd2843_cfg cxd2843_1 = {
+	.adr = 0x6d,
+};
+
+struct cxd2843_cfg cxd2843p_0 = {
+	.adr = 0x6c,
+	.parallel = 1,
+};
+
+struct cxd2843_cfg cxd2843p_1 = {
+	.adr = 0x6d,
+	.parallel = 1,
+};
+
+static int demod_attach_cxd2843(struct ddb_input *input, int par)
+{
+	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct dvb_frontend *fe;
+
+	if (par)
+		fe = dvb->fe = dvb_attach(cxd2843_attach, i2c,
+					  (input->nr & 1) ?
+					  &cxd2843p_1 : &cxd2843p_0);
+	else
+		fe = dvb->fe = dvb_attach(cxd2843_attach, i2c,
+					  (input->nr & 1) ?
+					  &cxd2843_1 : &cxd2843_0);
+	if (!dvb->fe) {
+		pr_err("No cxd2837/38/43 found!\n");
+		return -ENODEV;
+	}
+	fe->sec_priv = input;
+	dvb->i2c_gate_ctrl = fe->ops.i2c_gate_ctrl;
+	fe->ops.i2c_gate_ctrl = locked_gate_ctrl;
+	return 0;
+}
+
+struct stv0367_cfg stv0367dd_0 = {
+	.adr = 0x1f,
+	.xtal = 27000000,
+};
+
+struct stv0367_cfg stv0367dd_1 = {
+	.adr = 0x1e,
+	.xtal = 27000000,
+};
+
+static int demod_attach_stv0367dd(struct ddb_input *input)
+{
+	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct dvb_frontend *fe;
+
+	fe = dvb->fe = dvb_attach(stv0367_attach, i2c,
+				  (input->nr & 1) ?
+				  &stv0367dd_1 : &stv0367dd_0,
+				  &dvb->fe2);
+	if (!dvb->fe) {
+		pr_err("No stv0367 found!\n");
+		return -ENODEV;
+	}
+	fe->sec_priv = input;
+	dvb->i2c_gate_ctrl = fe->ops.i2c_gate_ctrl;
+	fe->ops.i2c_gate_ctrl = locked_gate_ctrl;
+	return 0;
+}
+
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
+		pr_err("No TDA18271 found!\n");
+		return -ENODEV;
+	}
+	return 0;
+}
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
+		pr_err("No TDA18212 found!\n");
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
+		pr_err("No TDA18212 found!\n");
+		return -ENODEV;
+	}
+	return 0;
+}
+#endif
+
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
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
+
+	.ts1_tei        = 1,
+	.ts2_tei        = 1,
+
+	.repeater_level = STV090x_RPTLEVEL_16,
+
+	.adc1_range	= STV090x_ADC_1Vpp,
+	.adc2_range	= STV090x_ADC_1Vpp,
+
+	.diseqc_envelope_mode = true,
+};
+
+static struct stv090x_config stv0900_aa = {
+	.device         = STV0900,
+	.demod_mode     = STV090x_DUAL,
+	.clk_mode       = STV090x_CLK_EXT,
+
+	.xtal           = 27000000,
+	.address        = 0x68,
+
+	.ts1_mode       = STV090x_TSMODE_SERIAL_PUNCTURED,
+	.ts2_mode       = STV090x_TSMODE_SERIAL_PUNCTURED,
+
+	.ts1_tei        = 1,
+	.ts2_tei        = 1,
+
+	.repeater_level = STV090x_RPTLEVEL_16,
+
+	.adc1_range	= STV090x_ADC_1Vpp,
+	.adc2_range	= STV090x_ADC_1Vpp,
+
+	.diseqc_envelope_mode = true,
+};
+
+static struct stv6110x_config stv6110a = {
+	.addr    = 0x60,
+	.refclk	 = 27000000,
+	.clk_div = 1,
+};
+
+static struct stv6110x_config stv6110b = {
+	.addr    = 0x63,
+	.refclk	 = 27000000,
+	.clk_div = 1,
+};
+
+static int demod_attach_stv0900(struct ddb_input *input, int type)
+{
+	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct stv090x_config *feconf = type ? &stv0900_aa : &stv0900;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+
+	dvb->fe = dvb_attach(stv090x_attach, feconf, i2c,
+			     (input->nr & 1) ? STV090x_DEMODULATOR_1
+			     : STV090x_DEMODULATOR_0);
+	if (!dvb->fe) {
+		pr_err("No STV0900 found!\n");
+		return -ENODEV;
+	}
+	if (!dvb_attach(lnbh24_attach, dvb->fe, i2c, 0,
+			0, (input->nr & 1) ?
+			(0x09 - type) : (0x0b - type))) {
+		pr_err("No LNBH24 found!\n");
+		return -ENODEV;
+	}
+	return 0;
+}
+
+static int tuner_attach_stv6110(struct ddb_input *input, int type)
+{
+	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct stv090x_config *feconf = type ? &stv0900_aa : &stv0900;
+	struct stv6110x_config *tunerconf = (input->nr & 1) ?
+		&stv6110b : &stv6110a;
+	struct stv6110x_devctl *ctl;
+
+	ctl = dvb_attach(stv6110x_attach, dvb->fe, tunerconf, i2c);
+	if (!ctl) {
+		pr_err("No STV6110X found!\n");
+		return -ENODEV;
+	}
+	pr_info("attach tuner input %d adr %02x\n",
+		input->nr, tunerconf->addr);
+
+	feconf->tuner_init          = ctl->tuner_init;
+	feconf->tuner_sleep         = ctl->tuner_sleep;
+	feconf->tuner_set_mode      = ctl->tuner_set_mode;
+	feconf->tuner_set_frequency = ctl->tuner_set_frequency;
+	feconf->tuner_get_frequency = ctl->tuner_get_frequency;
+	feconf->tuner_set_bandwidth = ctl->tuner_set_bandwidth;
+	feconf->tuner_get_bandwidth = ctl->tuner_get_bandwidth;
+	feconf->tuner_set_bbgain    = ctl->tuner_set_bbgain;
+	feconf->tuner_get_bbgain    = ctl->tuner_get_bbgain;
+	feconf->tuner_set_refclk    = ctl->tuner_set_refclk;
+	feconf->tuner_get_status    = ctl->tuner_get_status;
+
+	return 0;
+}
+
+static struct stv0910_cfg stv0910 = {
+	.adr      = 0x68,
+	.parallel = 1,
+	.rptlvl   = 4,
+	.clk      = 30000000,
+};
+
+static int demod_attach_stv0910(struct ddb_input *input, int type)
+{
+	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+
+	dvb->fe = dvb_attach(stv0910_attach, i2c, &stv0910, (input->nr & 1));
+	if (!dvb->fe) {
+		pr_err("No STV0910 found!\n");
+		return -ENODEV;
+	}
+	if (!dvb_attach(lnbh25_attach, dvb->fe, i2c,
+			(input->nr & 1) ? 0x09 : 0x08)) {
+		pr_err("No LNBH25 found!\n");
+		return -ENODEV;
+	}
+	return 0;
+}
+
+static int tuner_attach_stv6111(struct ddb_input *input)
+{
+	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct dvb_frontend *fe;
+
+	fe = dvb_attach(stv6111_attach, dvb->fe, i2c,
+			(input->nr & 1) ? 0x63 : 0x60);
+	if (!fe) {
+		pr_err("No STV6111 found!\n");
+		return -ENODEV;
+	}
+	return 0;
+}
+
+static struct mxl5xx_cfg mxl5xx = {
+	.adr      = 0x60,
+	.type     = 0x01,
+	.clk      = 27000000,
+	.cap      = 12,
+};
+
+static int lnb_command(struct ddb *dev, u32 lnb, u32 cmd)
+{
+	u32 c, v = 0;
+
+	v = LNB_TONE & (dev->lnb_tone << (15 - lnb));
+	pr_info("lnb_control[%u] = %08x\n", lnb, cmd | v);
+	ddbwritel(dev, cmd | v, LNB_CONTROL(lnb));
+	for (c = 0; c < 10; c++) {
+		v = ddbreadl(dev, LNB_CONTROL(lnb));
+		pr_info("ctrl = %08x\n", v);
+		if ((v & LNB_BUSY) == 0)
+			break;
+		msleep(20);
+	}
+	return 0;
+}
+
+static int dd_send_master_cmd(struct dvb_frontend *fe,
+			      struct dvb_diseqc_master_cmd *cmd)
+{
+	struct ddb_input *input = fe->sec_priv;
+	struct ddb_port *port = input->port;
+	struct ddb *dev = port->dev;
+	struct ddb_dvb *dvb = &port->dvb[input->nr & 1];
+	int i;
+
+	mutex_lock(&dev->lnb_lock);
+	ddbwritel(dev, 0, LNB_BUF_LEVEL(dvb->input));
+	for (i = 0; i < cmd->msg_len; i++)
+		ddbwritel(dev, cmd->msg[i], LNB_BUF_WRITE(dvb->input));
+	lnb_command(dev, dvb->input, LNB_CMD_DISEQC);
+	mutex_unlock(&dev->lnb_lock);
+	return 0;
+}
+
+static int dd_set_tone(struct dvb_frontend *fe, fe_sec_tone_mode_t tone)
+{
+	struct ddb_input *input = fe->sec_priv;
+	struct ddb_port *port = input->port;
+	struct ddb *dev = port->dev;
+	struct ddb_dvb *dvb = &port->dvb[input->nr & 1];
+	int s = 0;
+
+	mutex_lock(&dev->lnb_lock);
+	switch (tone) {
+	case SEC_TONE_OFF:
+		dev->lnb_tone &= ~(1ULL << dvb->input);
+		break;
+	case SEC_TONE_ON:
+		dev->lnb_tone |= (1ULL << dvb->input);
+		break;
+	default:
+		s = -EINVAL;
+		break;
+	};
+	if (!s)
+		s = lnb_command(dev, dvb->input, LNB_CMD_NOP);
+	mutex_unlock(&dev->lnb_lock);
+	return 0;
+}
+
+static int dd_enable_high_lnb_voltage(struct dvb_frontend *fe, long arg)
+{
+
+	return 0;
+}
+
+static int dd_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
+{
+	struct ddb_input *input = fe->sec_priv;
+	struct ddb_port *port = input->port;
+	struct ddb *dev = port->dev;
+	struct ddb_dvb *dvb = &port->dvb[input->nr & 1];
+	int s = 0;
+
+	mutex_lock(&dev->lnb_lock);
+	switch (voltage) {
+	case SEC_VOLTAGE_OFF:
+		lnb_command(dev, dvb->input, LNB_CMD_OFF);
+		break;
+	case SEC_VOLTAGE_13:
+		lnb_command(dev, dvb->input, LNB_CMD_LOW);
+		break;
+	case SEC_VOLTAGE_18:
+		lnb_command(dev, dvb->input, LNB_CMD_HIGH);
+		break;
+	default:
+		s = -EINVAL;
+		break;
+	};
+	mutex_unlock(&dev->lnb_lock);
+	return s;
+}
+
+static int dd_set_input(struct dvb_frontend *fe)
+{
+	
+	return 0;
+}
+
+static int fe_attach_mxl5xx(struct ddb_input *input)
+{
+	struct ddb *dev = input->port->dev;
+	struct i2c_adapter *i2c = &dev->i2c[0].adap;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	int demod, tuner;
+
+	demod = input->nr;
+	tuner = demod & 3;
+	dvb->fe = dvb_attach(mxl5xx_attach, i2c, &mxl5xx,
+			     demod, tuner);
+	if (!dvb->fe) {
+		pr_err("No MXL5XX found!\n");
+		return -ENODEV;
+	}
+	if (input->nr < 4) 
+		lnb_command(dev, input->nr, LNB_CMD_INIT);
+	dvb->fe->ops.set_voltage = dd_set_voltage;
+	dvb->fe->ops.enable_high_lnb_voltage = dd_enable_high_lnb_voltage;
+	dvb->fe->ops.set_tone = dd_set_tone;
+	dvb->fe->ops.diseqc_send_master_cmd = dd_send_master_cmd;
+	dvb->fe->sec_priv = input;
+	dvb->set_input = dvb->fe->ops.set_input;
+	dvb->fe->ops.set_input = dd_set_input;
+	dvb->input = tuner;
+	return 0;
+}
+
+static int my_dvb_dmx_ts_card_init(struct dvb_demux *dvbdemux, char *id,
+				   int (*start_feed)(struct dvb_demux_feed *),
+				   int (*stop_feed)(struct dvb_demux_feed *),
+				   void *priv)
+{
+	dvbdemux->priv = priv;
+
+	dvbdemux->filternum = 256;
+	dvbdemux->feednum = 256;
+	dvbdemux->start_feed = start_feed;
+	dvbdemux->stop_feed = stop_feed;
+	dvbdemux->write_to_decoder = NULL;
+	dvbdemux->dmx.capabilities = (DMX_TS_FILTERING |
+				      DMX_SECTION_FILTERING |
+				      DMX_MEMORY_BASED_FILTERING);
+	return dvb_dmx_init(dvbdemux);
+}
+
+static int my_dvb_dmxdev_ts_card_init(struct dmxdev *dmxdev,
+				      struct dvb_demux *dvbdemux,
+				      struct dmx_frontend *hw_frontend,
+				      struct dmx_frontend *mem_frontend,
+				      struct dvb_adapter *dvb_adapter)
+{
+	int ret;
+
+	dmxdev->filternum = 256;
+	dmxdev->demux = &dvbdemux->dmx;
+	dmxdev->capabilities = 0;
+	ret = dvb_dmxdev_init(dmxdev, dvb_adapter);
+	if (ret < 0)
+		return ret;
+
+	hw_frontend->source = DMX_FRONTEND_0;
+	dvbdemux->dmx.add_frontend(&dvbdemux->dmx, hw_frontend);
+	mem_frontend->source = DMX_MEMORY_FE;
+	dvbdemux->dmx.add_frontend(&dvbdemux->dmx, mem_frontend);
+	return dvbdemux->dmx.connect_frontend(&dvbdemux->dmx, hw_frontend);
+}
+
+#if 0
+static int start_input(struct ddb_input *input)
+{
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+
+	if (!dvb->users)
+		ddb_input_start_all(input);
+
+	return ++dvb->users;
+}
+
+static int stop_input(struct ddb_input *input)
+{
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+
+	if (--dvb->users)
+		return dvb->users;
+
+	ddb_input_stop_all(input);
+	return 0;
+}
+#endif
+
+static int start_feed(struct dvb_demux_feed *dvbdmxfeed)
+{
+	struct dvb_demux *dvbdmx = dvbdmxfeed->demux;
+	struct ddb_input *input = dvbdmx->priv;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+
+	if (!dvb->users)
+		ddb_input_start_all(input);
+
+	return ++dvb->users;
+}
+
+static int stop_feed(struct dvb_demux_feed *dvbdmxfeed)
+{
+	struct dvb_demux *dvbdmx = dvbdmxfeed->demux;
+	struct ddb_input *input = dvbdmx->priv;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+
+	if (--dvb->users)
+		return dvb->users;
+
+	ddb_input_stop_all(input);
+	return 0;
+}
+
+static void dvb_input_detach(struct ddb_input *input)
+{
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct dvb_demux *dvbdemux = &dvb->demux;
+
+	switch (dvb->attached) {
+	case 0x31:
+		if (dvb->fe2)
+			dvb_unregister_frontend(dvb->fe2);
+		if (dvb->fe)
+			dvb_unregister_frontend(dvb->fe);
+		/* fallthrough */
+	case 0x30:
+		dvb_frontend_detach(dvb->fe);
+		dvb->fe = dvb->fe2 = NULL;
+		/* fallthrough */
+	case 0x21:
+		if (input->port->dev->ns_num)
+			dvb_netstream_release(&dvb->dvbns);
+		/* fallthrough */
+	case 0x20:
+		dvb_net_release(&dvb->dvbnet);
+		/* fallthrough */
+	case 0x11:
+		dvbdemux->dmx.close(&dvbdemux->dmx);
+		dvbdemux->dmx.remove_frontend(&dvbdemux->dmx,
+					      &dvb->hw_frontend);
+		dvbdemux->dmx.remove_frontend(&dvbdemux->dmx,
+					      &dvb->mem_frontend);
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
+
+	for (i = 0; i < dev->info->port_num; i++) {
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
+	}
+}
+
+static int dvb_input_attach(struct ddb_input *input)
+{
+	int ret = 0;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct ddb_port *port = input->port;
+	struct dvb_adapter *adap = dvb->adap;
+	struct dvb_demux *dvbdemux = &dvb->demux;
+
+	dvb->attached = 0x01;
+
+	ret = my_dvb_dmx_ts_card_init(dvbdemux, "SW demux",
+				      start_feed,
+				      stop_feed, input);
+	if (ret < 0)
+		return ret;
+	dvb->attached = 0x10;
+
+	ret = my_dvb_dmxdev_ts_card_init(&dvb->dmxdev,
+					 &dvb->demux,
+					 &dvb->hw_frontend,
+					 &dvb->mem_frontend, adap);
+	if (ret < 0)
+		return ret;
+	dvb->attached = 0x11;
+
+	ret = dvb_net_init(adap, &dvb->dvbnet, dvb->dmxdev.demux);
+	if (ret < 0)
+		return ret;
+	dvb->attached = 0x20;
+
+	if (input->port->dev->ns_num) {
+		ret = netstream_init(input);
+		if (ret < 0)
+			return ret;
+		dvb->attached = 0x21;
+	}
+	dvb->fe = dvb->fe2 = 0;
+	switch (port->type) {
+	case DDB_TUNER_MXL5XX:
+		fe_attach_mxl5xx(input);
+		break;
+	case DDB_TUNER_DVBS_ST:
+		if (demod_attach_stv0900(input, 0) < 0)
+			return -ENODEV;
+		if (tuner_attach_stv6110(input, 0) < 0)
+			return -ENODEV;
+		break;
+	case DDB_TUNER_DVBS_STV0910:
+	case DDB_TUNER_DVBS_STV0910_P:
+		if (demod_attach_stv0910(input, 0) < 0)
+			return -ENODEV;
+		if (tuner_attach_stv6111(input) < 0)
+			return -ENODEV;
+		break;
+	case DDB_TUNER_DVBS_ST_AA:
+		if (demod_attach_stv0900(input, 1) < 0)
+			return -ENODEV;
+		if (tuner_attach_stv6110(input, 1) < 0)
+			return -ENODEV;
+		break;
+#ifdef CONFIG_DVB_DRXK
+	case DDB_TUNER_DVBCT_TR:
+		if (demod_attach_drxk(input) < 0)
+			return -ENODEV;
+		if (tuner_attach_tda18271(input) < 0)
+			return -ENODEV;
+		break;
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
+		if (demod_attach_cxd2843(input, 0) < 0)
+			return -ENODEV;
+		if (tuner_attach_tda18212dd(input) < 0)
+			return -ENODEV;
+		break;
+	case DDB_TUNER_DVBCT2_SONY_P:
+	case DDB_TUNER_DVBC2T2_SONY_P:
+	case DDB_TUNER_ISDBT_SONY_P:
+		if (demod_attach_cxd2843(input, 1) < 0)
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
+	}
+	dvb->attached = 0x31;
+	return 0;
+}
+
+
+static int port_has_encti(struct ddb_port *port)
+{
+	u8 val;
+	int ret = i2c_read_reg(&port->i2c->adap, 0x20, 0, &val);
+
+	if (!ret)
+		pr_info("[0x20]=0x%02x\n", val);
+	return ret ? 0 : 1;
+}
+
+static int port_has_cxd(struct ddb_port *port, u8 *type)
+{
+	u8 val;
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
+}
+
+static int port_has_xo2(struct ddb_port *port, u8 *id)
+{
+	u8 val;
+	u8 probe[1] = { 0x00 }, data[4];
+	struct i2c_msg msgs[2] = {{ .addr = 0x10,  .flags = 0,
+				    .buf  = probe, .len   = 1 },
+				  { .addr = 0x10,  .flags = I2C_M_RD,
+				    .buf  = data,  .len   = 4 } };
+	val = i2c_transfer(&port->i2c->adap, msgs, 2);
+	if (val != 2)
+		return 0;
+
+	if (data[0] != 'D' || data[1] != 'F')
+		return 0;
+
+	*id = data[2];
+	return 1;
+}
+
+static int port_has_stv0900(struct ddb_port *port)
+{
+	u8 val;
+	if (i2c_read_reg16(&port->i2c->adap, 0x69, 0xf100, &val) < 0)
+		return 0;
+	return 1;
+}
+
+static int port_has_stv0900_aa(struct ddb_port *port, u8 *id)
+{
+	if (i2c_read_reg16(&port->i2c->adap, 0x68, 0xf100, id) < 0)
+		return 0;
+	return 1;
+}
+
+static int port_has_drxks(struct ddb_port *port)
+{
+	u8 val;
+	if (i2c_read(&port->i2c->adap, 0x29, &val) < 0)
+		return 0;
+	if (i2c_read(&port->i2c->adap, 0x2a, &val) < 0)
+		return 0;
+	return 1;
+}
+
+static int port_has_stv0367(struct ddb_port *port)
+{
+	u8 val;
+
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
+#if 0
+static int init_xo2_old(struct ddb_port *port)
+{
+	struct i2c_adapter *i2c = &port->i2c->adap;
+	u8 val;
+	int res;
+
+	res = i2c_read_reg(i2c, 0x10, 0x04, &val);
+	if (res < 0)
+		return res;
+
+	if (val != 0x02)  {
+		pr_info("Port %d: invalid XO2\n", port->nr);
+		return -1;
+	}
+	i2c_write_reg(i2c, 0x10, 0xc0, 0x00); /* Disable XO2 I2C master */
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
+	usleep_range(2000, 3000);
+	/* Start XO2 PLL */
+	i2c_write_reg(i2c, 0x10, 0x08, 0x87);
+
+	return 0;
+}
+#endif
+
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
+	usleep_range(2000, 3000);
+	/* Start XO2 PLL */
+	i2c_write_reg(i2c, 0x10, 0x08, 0x87);
+
+	return 0;
+}
+
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
+static char *xo2names[] = {
+	"DUAL DVB-S2", "DUAL DVB-C/T/T2",
+	"DUAL DVB-ISDBT", "DUAL DVB-C/C2/T/T2",
+	"DUAL ATSC", "DUAL DVB-C/C2/T/T2",
+	"", ""
+};
+
+static void ddb_port_probe(struct ddb_port *port)
+{
+	struct ddb *dev = port->dev;
+	u8 id;
+
+	port->name = "NO MODULE";
+	port->class = DDB_PORT_NONE;
+
+	if (dev->info->type == DDB_MOD) {
+		port->name = "MOD";
+		port->class = DDB_PORT_MOD;
+		return;
+	}
+
+	if (dev->info->type == DDB_OCTOPUS_MAX) {
+		port->name = "DUAL DVB-S2 MX";
+		port->class = DDB_PORT_TUNER;
+		port->type = DDB_TUNER_MXL5XX;
+		if (port->i2c)
+			ddbwritel(dev, I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
+		return;
+	}
+
+	if (port->nr > 1 && dev->info->type == DDB_OCTOPUS_CI) {
+		port->name = "CI internal";
+		port->class = DDB_PORT_CI;
+		port->type = DDB_CI_INTERNAL;
+	} else if (port_has_cxd(port, &id)) {
+		if (id == 1) {
+			port->name = "CI";
+			port->class = DDB_PORT_CI;
+			port->type = DDB_CI_EXTERNAL_SONY;
+			ddbwritel(dev, I2C_SPEED_400,
+				  port->i2c->regs + I2C_TIMING);
+		} else {
+			pr_info(KERN_INFO "Port %d: Uninitialized DuoFlex\n",
+			       port->nr);
+			return;
+		}
+	} else if (port_has_xo2(port, &id)) {
+		ddbwritel(dev, I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
+		id >>= 2;
+		if (id > 5) {
+			port->name = "unknown XO2 DuoFlex";
+		} else {
+			port->class = DDB_PORT_TUNER;
+			port->type = DDB_TUNER_XO2 + id;
+			port->name = xo2names[id];
+			init_xo2(port);
+		}
+	} else if (port_has_cxd28xx(port, &id)) {
+		switch (id) {
+		case 0xa4:
+			port->name = "DUAL DVB-CT2 CXD2843";
+			port->type = DDB_TUNER_DVBC2T2_SONY_P;
+			break;
+		case 0xb1:
+			port->name = "DUAL DVB-CT2 CXD2837";
+			port->type = DDB_TUNER_DVBCT2_SONY_P;
+			break;
+		case 0xb0:
+			port->name = "DUAL ISDB-T CXD2838";
+			port->type = DDB_TUNER_ISDBT_SONY_P;
+			break;
+		default:
+			return;
+		}
+		port->class = DDB_PORT_TUNER;
+		ddbwritel(dev, I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
+	} else if (port_has_stv0900(port)) {
+		port->name = "DUAL DVB-S2";
+		port->class = DDB_PORT_TUNER;
+		port->type = DDB_TUNER_DVBS_ST;
+		ddbwritel(dev, I2C_SPEED_100, port->i2c->regs + I2C_TIMING);
+	} else if (port_has_stv0900_aa(port, &id)) {
+		port->name = "DUAL DVB-S2";
+		port->class = DDB_PORT_TUNER;
+		port->type = DDB_TUNER_DVBS_ST_AA;
+		if (id == 0x51)
+			port->type = DDB_TUNER_DVBS_STV0910_P;
+		else
+			port->type = DDB_TUNER_DVBS_ST_AA;
+		ddbwritel(dev, I2C_SPEED_100, port->i2c->regs + I2C_TIMING);
+	} else if (port_has_drxks(port)) {
+		port->name = "DUAL DVB-C/T";
+		port->class = DDB_PORT_TUNER;
+		port->type = DDB_TUNER_DVBCT_TR;
+		ddbwritel(dev, I2C_SPEED_400, port->i2c->regs + I2C_TIMING);
+	} else if (port_has_stv0367(port)) {
+		port->name = "DUAL DVB-C/T";
+		port->class = DDB_PORT_TUNER;
+		port->type = DDB_TUNER_DVBCT_ST;
+		ddbwritel(dev, I2C_SPEED_100, port->i2c->regs + I2C_TIMING);
+	} else if (port_has_encti(port)) {
+		port->name = "ENCTI";
+		port->class = DDB_PORT_LOOP;
+	} else if (port->nr == ts_loop) {
+		port->name = "TS LOOP";
+		port->class = DDB_PORT_LOOP;
+	}
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
+	u32 val, off = (address >> 1) & (CI_BUFFER_SIZE-1);
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
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+
+
+struct cxd2099_cfg cxd_cfg = {
+	.bitrate =  72000,
+	.adr     =  0x40,
+	.polarity = 1,
+	.clock_mode = 1,
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
+	}
+	if (port->type == DDB_CI_INTERNAL) {
+		ci_attach(port);
+		if (!port->en)
+			return -ENODEV;
+		dvb_ca_en50221_init(port->dvb[0].adap, port->en, 0, 1);
+	}
+	return 0;
+}
+
+static int ddb_port_attach(struct ddb_port *port)
+{
+	int ret = 0;
+
+	switch (port->class) {
+	case DDB_PORT_TUNER:
+		ret = dvb_input_attach(port->input[0]);
+		if (ret < 0)
+			break;
+		ret = dvb_input_attach(port->input[1]);
+		if (ret < 0)
+			break;
+		port->input[0]->redi = port->input[0];
+		port->input[1]->redi = port->input[1];
+		break;
+	case DDB_PORT_CI:
+		ret = ddb_ci_attach(port);
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
+		break;
+	default:
+		break;
+	}
+	if (ret < 0)
+		pr_err("port_attach on port %d failed\n", port->nr);
+	return ret;
+}
+
+static int ddb_ports_attach(struct ddb *dev)
+{
+	int i, ret = 0;
+	struct ddb_port *port;
+
+	if (dev->ids.devid == 0x0301dd01)
+		dev->ns_num = 15;
+	else
+		dev->ns_num = dev->info->ns_num;
+	for (i = 0; i < dev->ns_num; i++)
+		dev->ns[i].nr = i;
+	pr_info("%d netstream channels\n", dev->ns_num);
+
+	if (dev->info->port_num) {
+		ret = dvb_register_adapters(dev);
+		if (ret < 0) {
+			pr_err("Registering adapters failed. Check DVB_MAX_ADAPTERS in config.\n");
+			return ret;
+		}
+	}
+	for (i = 0; i < dev->info->port_num; i++) {
+		port = &dev->port[i];
+		ret = ddb_port_attach(port);
+		if (ret < 0)
+			break;
+	}
+	return ret;
+}
+
+static void ddb_ports_detach(struct ddb *dev)
+{
+	int i;
+	struct ddb_port *port;
+
+	for (i = 0; i < dev->info->port_num; i++) {
+		port = &dev->port[i];
+
+		switch (port->class) {
+		case DDB_PORT_TUNER:
+			dvb_input_detach(port->input[0]);
+			dvb_input_detach(port->input[1]);
+			break;
+		case DDB_PORT_CI:
+		case DDB_PORT_LOOP:
+			if (port->dvb[0].dev)
+				dvb_unregister_device(port->dvb[0].dev);
+			if (port->en) {
+				dvb_ca_en50221_release(port->en);
+				kfree(port->en);
+				port->en = 0;
+			}
+			break;
+		case DDB_PORT_MOD:
+			if (port->dvb[0].dev)
+				dvb_unregister_device(port->dvb[0].dev);
+			break;
+		}
+	}
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
+		  input->dma->stat, DMA_BUFFER_ACK(output->dma->nr));
+	output->dma->cbuf = (input->dma->stat >> 11) & 0x1f;
+	output->dma->coff = (input->dma->stat & 0x7ff) << 7;
+}
+
+static void output_ack_input(struct ddb_output *output,
+			     struct ddb_input *input)
+{
+	ddbwritel(input->port->dev,
+		  output->dma->stat, DMA_BUFFER_ACK(input->dma->nr));
+}
+
+static void input_write_dvb(struct ddb_input *input,
+			    struct ddb_input *input2)
+{
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
+			/*pr_err("Overflow dma %d\n", dma->nr);*/
+			if (noack)
+				noack = 0;
+		}
+#ifdef DDB_ALT_DMA
+		dma_sync_single_for_cpu(dev->dev, dma2->pbuf[dma->cbuf],
+					dma2->size, DMA_FROM_DEVICE);
+#endif
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
+}
+
+#ifdef DDB_USE_WORK
+static void input_work(struct work_struct *work)
+{
+	struct ddb_dma *dma = container_of(work, struct ddb_dma, work);
+	struct ddb_input *input = (struct ddb_input *) dma->io;
+#else
+static void input_tasklet(unsigned long data)
+{
+	struct ddb_input *input = (struct ddb_input *) data;
+	struct ddb_dma *dma = input->dma;
+#endif
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
+#if 0
+	if (4 & dma->ctrl)
+		pr_err("Overflow dma %d\n", dma->nr);
+#endif
+	if (input->redi)
+		input_write_dvb(input, input->redi);
+	if (input->redo)
+		input_write_output(input, input->redo);
+	wake_up(&dma->wq);
+	spin_unlock(&dma->lock);
+}
+
+static void input_handler(unsigned long data)
+{
+	struct ddb_input *input = (struct ddb_input *) data;
+	struct ddb_dma *dma = input->dma;
+
+
+	/* If there is no input connected, input_tasklet() will
+	   just copy pointers and ACK. So, there is no need to go
+	   through the tasklet scheduler. */
+#ifdef DDB_USE_WORK
+	if (input->redi)
+		queue_work(ddb_wq, &dma->work);
+	else
+		input_work(&dma->work);
+#else
+	if (input->redi)
+		tasklet_schedule(&dma->tasklet);
+	else
+		input_tasklet(data);
+#endif
+}
+
+/* hmm, don't really need this anymore.
+   The output IRQ just copies some pointers, acks and wakes. */
+
+#ifdef DDB_USE_WORK
+static void output_work(struct work_struct *work)
+{
+}
+#else
+static void output_tasklet(unsigned long data)
+{
+}
+#endif
+
+static void output_handler(unsigned long data)
+{
+	struct ddb_output *output = (struct ddb_output *) data;
+	struct ddb_dma *dma = output->dma;
+	struct ddb *dev = output->port->dev;
+
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
+
+/****************************************************************************/
+/****************************************************************************/
+
+
+static void ddb_dma_init(struct ddb_dma *dma, int nr, void *io, int out)
+{
+#ifndef DDB_USE_WORK
+	unsigned long priv = (unsigned long) io;
+#endif
+
+	dma->io = io;
+	dma->nr = nr;
+	spin_lock_init(&dma->lock);
+	init_waitqueue_head(&dma->wq);
+	if (out) {
+#ifdef DDB_USE_WORK
+		INIT_WORK(&dma->work, output_work);
+#else
+		tasklet_init(&dma->tasklet, output_tasklet, priv);
+#endif
+		dma->num = OUTPUT_DMA_BUFS;
+		dma->size = OUTPUT_DMA_SIZE;
+		dma->div = OUTPUT_DMA_IRQ_DIV;
+	} else {
+#ifdef DDB_USE_WORK
+		INIT_WORK(&dma->work, input_work);
+#else
+		tasklet_init(&dma->tasklet, input_tasklet, priv);
+#endif
+		dma->num = INPUT_DMA_BUFS;
+		dma->size = INPUT_DMA_SIZE;
+		dma->div = INPUT_DMA_IRQ_DIV;
+	}
+}
+
+static void ddb_input_init(struct ddb_port *port, int nr, int pnr, int dma_nr)
+{
+	struct ddb *dev = port->dev;
+	struct ddb_input *input = &dev->input[nr];
+
+	if (dev->has_dma) {
+		dev->handler[dma_nr + 8] = input_handler;
+		dev->handler_data[dma_nr + 8] = (unsigned long) input;
+	}
+	port->input[pnr] = input;
+	input->nr = nr;
+	input->port = port;
+	if (dev->has_dma) {
+		input->dma = &dev->dma[dma_nr];
+		ddb_dma_init(input->dma, dma_nr, (void *) input, 0);
+	}
+	ddbwritel(dev, 0, TS_INPUT_CONTROL(nr));
+	ddbwritel(dev, 2, TS_INPUT_CONTROL(nr));
+	ddbwritel(dev, 0, TS_INPUT_CONTROL(nr));
+	if (dev->has_dma)
+		ddbwritel(dev, 0, DMA_BUFFER_ACK(input->dma->nr));
+}
+
+static void ddb_output_init(struct ddb_port *port, int nr, int dma_nr)
+{
+	struct ddb *dev = port->dev;
+	struct ddb_output *output = &dev->output[nr];
+
+	if (dev->has_dma) {
+		dev->handler[dma_nr + 8] = output_handler;
+		dev->handler_data[dma_nr + 8] = (unsigned long) output;
+	}
+	port->output = output;
+	output->nr = nr;
+	output->port = port;
+	if (dev->has_dma) {
+		output->dma = &dev->dma[dma_nr];
+		ddb_dma_init(output->dma, dma_nr, (void *) output, 1);
+	}
+	if (output->port->class == DDB_PORT_MOD) {
+		/*ddbwritel(dev, 0, CHANNEL_CONTROL(output->nr));*/
+	} else {
+		ddbwritel(dev, 0, TS_OUTPUT_CONTROL(nr));
+		ddbwritel(dev, 2, TS_OUTPUT_CONTROL(nr));
+		ddbwritel(dev, 0, TS_OUTPUT_CONTROL(nr));
+	}
+	if (dev->has_dma)
+		ddbwritel(dev, 0, DMA_BUFFER_ACK(output->dma->nr));
+}
+
+static void ddb_ports_init(struct ddb *dev)
+{
+	int i;
+	struct ddb_port *port;
+
+	if (dev->info->board_control) {
+		ddbwritel(dev, 0, BOARD_CONTROL);
+		msleep(100);
+		ddbwritel(dev, 4, BOARD_CONTROL);
+		usleep_range(2000, 3000);
+		ddbwritel(dev, 4 | dev->info->board_control, BOARD_CONTROL);
+		usleep_range(2000, 3000);
+	}
+
+	for (i = 0; i < dev->info->port_num; i++) {
+		port = &dev->port[i];
+		port->dev = dev;
+		port->nr = i;
+		if (dev->info->i2c_num > i)
+			port->i2c = &dev->i2c[i];
+		port->gap = 4;
+		port->obr = ci_bitrate;
+		mutex_init(&port->i2c_gate_lock);
+		ddb_port_probe(port);
+		pr_info("Port %d (TAB %d): %s\n",
+			port->nr, port->nr + 1, port->name);
+
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
+		if (dev->info->type == DDB_OCTOPUS_MAX) {
+			ddb_input_init(port, 2 * i, 0, 2 * i);
+			ddb_input_init(port, 2 * i + 1, 1, 2 * i + 1);
+		}
+		if (dev->info->type == DDB_MOD) {
+			ddb_output_init(port, i, i);
+			dev->handler[i + 18] = ddbridge_mod_rate_handler;
+			dev->handler_data[i + 18] =
+				(unsigned long) &dev->output[i];
+		}
+	}
+}
+
+static void ddb_ports_release(struct ddb *dev)
+{
+	int i;
+	struct ddb_port *port;
+
+	if (!dev->has_dma)
+		return;
+	for (i = 0; i < dev->info->port_num; i++) {
+		port = &dev->port[i];
+#ifdef DDB_USE_WORK
+		if (port->input[0])
+			cancel_work_sync(&port->input[0]->dma->work);
+		if (port->input[1])
+			cancel_work_sync(&port->input[1]->dma->work);
+		if (port->output)
+			cancel_work_sync(&port->output->dma->work);
+#else
+		if (port->input[0])
+			tasklet_kill(&port->input[0]->dma->tasklet);
+		if (port->input[1])
+			tasklet_kill(&port->input[1]->dma->tasklet);
+		if (port->output)
+			tasklet_kill(&port->output->dma->tasklet);
+#endif
+	}
+}
+
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+
+#define IRQ_HANDLE(_nr) \
+	do { if ((s & (1UL << _nr)) && dev->handler[_nr]) \
+		dev->handler[_nr](dev->handler_data[_nr]); } \
+	while (0)
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
+
+static irqreturn_t irq_handler1(int irq, void *dev_id)
+{
+	struct ddb *dev = (struct ddb *) dev_id;
+	u32 s = ddbreadl(dev, INTERRUPT_STATUS);
+
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
+}
+
+static irqreturn_t irq_handler(int irq, void *dev_id)
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
+		if (s & 0x0fffff00) {
+			irq_handle_io(dev, s);
+#ifdef DDB_TEST_THREADED
+			ret = IRQ_WAKE_THREAD;
+#endif
+		}
+	} while ((s = ddbreadl(dev, INTERRUPT_STATUS)));
+
+	return ret;
+}
+
+#ifdef DDB_TEST_THREADED
+static irqreturn_t irq_thread(int irq, void *dev_id)
+{
+	/* struct ddb *dev = (struct ddb *) dev_id; */
+
+	/*pr_info("%s\n", __func__);*/
+
+	return IRQ_HANDLED;
+}
+#endif
+
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+
+#ifdef DVB_NSD
+
+static ssize_t nsd_read(struct file *file, char *buf,
+			size_t count, loff_t *ppos)
+{
+	return 0;
+}
+
+static unsigned int nsd_poll(struct file *file, poll_table *wait)
+{
+	return 0;
+}
+
+static int nsd_release(struct inode *inode, struct file *file)
+{
+	return dvb_generic_release(inode, file);
+}
+
+static int nsd_open(struct inode *inode, struct file *file)
+{
+	return dvb_generic_open(inode, file);
+}
+
+static int nsd_do_ioctl(struct file *file, unsigned int cmd, void *parg)
+{
+	struct dvb_device *dvbdev = file->private_data;
+	struct ddb *dev = dvbdev->priv;
+
+	/* unsigned long arg = (unsigned long) parg; */
+	int ret = 0;
+
+	switch (cmd) {
+	case NSD_START_GET_TS:
+	{
+		struct dvb_nsd_ts *ts = parg;
+		u32 ctrl = ((ts->input & 7) << 8) |
+			((ts->filter_mask & 3) << 2);
+		u32 to;
+
+		if (ddbreadl(dev, TS_CAPTURE_CONTROL) & 1) {
+			pr_info("ts capture busy\n");
+			return -EBUSY;
+		}
+		ddb_dvb_input_start(&dev->input[ts->input & 7]);
+
+		ddbwritel(dev, ctrl, TS_CAPTURE_CONTROL);
+		ddbwritel(dev, ts->pid, TS_CAPTURE_PID);
+		ddbwritel(dev, (ts->section_id << 16) |
+			  (ts->table << 8) | ts->section,
+			  TS_CAPTURE_TABLESECTION);
+		/* 1024 ms default timeout if timeout set to 0 */
+		if (ts->timeout)
+			to = ts->timeout;
+		else
+			to = 1024;
+		/* 21 packets default if num set to 0 */
+		if (ts->num)
+			to |= ((u32) ts->num << 16);
+		else
+			to |= (21 << 16);
+		ddbwritel(dev, to, TS_CAPTURE_TIMEOUT);
+		if (ts->mode)
+			ctrl |= 2;
+		ddbwritel(dev, ctrl | 1, TS_CAPTURE_CONTROL);
+		break;
+	}
+	case NSD_POLL_GET_TS:
+	{
+		struct dvb_nsd_ts *ts = parg;
+		u32 ctrl = ddbreadl(dev, TS_CAPTURE_CONTROL);
+
+		if (ctrl & 1)
+			return -EBUSY;
+		if (ctrl & (1 << 14)) {
+			/*pr_info("ts capture timeout\n");*/
+			return -EAGAIN;
+		}
+		ddbcpyfrom(dev, dev->tsbuf, TS_CAPTURE_MEMORY,
+			   TS_CAPTURE_LEN);
+		ts->len = ddbreadl(dev, TS_CAPTURE_RECEIVED) & 0x1fff;
+		if (copy_to_user(ts->ts, dev->tsbuf, ts->len))
+			return -EIO;
+		break;
+	}
+	case NSD_CANCEL_GET_TS:
+	{
+		u32 ctrl = 0;
+		pr_info("cancel ts capture: 0x%x\n", ctrl);
+		ddbwritel(dev, ctrl, TS_CAPTURE_CONTROL);
+		ctrl = ddbreadl(dev, TS_CAPTURE_CONTROL);
+		/*pr_info("control register is 0x%x\n", ctrl);*/
+		break;
+	}
+	case NSD_STOP_GET_TS:
+	{
+		struct dvb_nsd_ts *ts = parg;
+		u32 ctrl = ddbreadl(dev, TS_CAPTURE_CONTROL);
+
+		if (ctrl & 1) {
+			pr_info("cannot stop ts capture, while it was neither finished not canceled\n");
+			return -EBUSY;
+		}
+		/*pr_info("ts capture stopped\n");*/
+		ddb_dvb_input_stop(&dev->input[ts->input & 7]);
+		break;
+	}
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static long nsd_ioctl(struct file *file,
+		      unsigned int cmd, unsigned long arg)
+{
+	return dvb_usercopy(file, cmd, arg, nsd_do_ioctl);
+}
+
+static const struct file_operations nsd_fops = {
+	.owner   = THIS_MODULE,
+	.read    = nsd_read,
+	.open    = nsd_open,
+	.release = nsd_release,
+	.poll    = nsd_poll,
+	.unlocked_ioctl = nsd_ioctl,
+};
+
+static struct dvb_device dvbdev_nsd = {
+	.priv    = 0,
+	.readers = 1,
+	.writers = 1,
+	.users   = 1,
+	.fops    = &nsd_fops,
+};
+
+static int ddb_nsd_attach(struct ddb *dev)
+{
+	int ret;
+
+	ret = dvb_register_device(&dev->adap[0],
+				  &dev->nsd_dev,
+				  &dvbdev_nsd, (void *) dev,
+				  DVB_DEVICE_NSD);
+	return ret;
+}
+
+static void ddb_nsd_detach(struct ddb *dev)
+{
+	if (dev->nsd_dev->users > 2) {
+		wait_event(dev->nsd_dev->wait_queue,
+			   dev->nsd_dev->users == 2);
+	}
+	dvb_unregister_device(dev->nsd_dev);
+}
+
+#endif
+
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+
+static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
+{
+	u32 data, shift;
+
+	if (wlen > 4)
+		ddbwritel(dev, 1, SPI_CONTROL);
+	while (wlen > 4) {
+		/* FIXME: check for big-endian */
+		data = swab32(*(u32 *)wbuf);
+		wbuf += 4;
+		wlen -= 4;
+		ddbwritel(dev, data, SPI_DATA);
+		while (ddbreadl(dev, SPI_CONTROL) & 0x0004)
+			;
+	}
+
+	if (rlen)
+		ddbwritel(dev, 0x0001 | ((wlen << (8 + 3)) & 0x1f00),
+			  SPI_CONTROL);
+	else
+		ddbwritel(dev, 0x0003 | ((wlen << (8 + 3)) & 0x1f00),
+			  SPI_CONTROL);
+
+	data = 0;
+	shift = ((4 - wlen) * 8);
+	while (wlen) {
+		data <<= 8;
+		data |= *wbuf;
+		wlen--;
+		wbuf++;
+	}
+	if (shift)
+		data <<= shift;
+	ddbwritel(dev, data, SPI_DATA);
+	while (ddbreadl(dev, SPI_CONTROL) & 0x0004)
+		;
+
+	if (!rlen) {
+		ddbwritel(dev, 0, SPI_CONTROL);
+		return 0;
+	}
+	if (rlen > 4)
+		ddbwritel(dev, 1, SPI_CONTROL);
+
+	while (rlen > 4) {
+		ddbwritel(dev, 0xffffffff, SPI_DATA);
+		while (ddbreadl(dev, SPI_CONTROL) & 0x0004)
+			;
+		data = ddbreadl(dev, SPI_DATA);
+		*(u32 *) rbuf = swab32(data);
+		rbuf += 4;
+		rlen -= 4;
+	}
+	ddbwritel(dev, 0x0003 | ((rlen << (8 + 3)) & 0x1F00), SPI_CONTROL);
+	ddbwritel(dev, 0xffffffff, SPI_DATA);
+	while (ddbreadl(dev, SPI_CONTROL) & 0x0004)
+		;
+
+	data = ddbreadl(dev, SPI_DATA);
+	ddbwritel(dev, 0, SPI_CONTROL);
+
+	if (rlen < 4)
+		data <<= ((4 - rlen) * 8);
+
+	while (rlen > 0) {
+		*rbuf = ((data >> 24) & 0xff);
+		data <<= 8;
+		rbuf++;
+		rlen--;
+	}
+	return 0;
+}
+
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
+	while (ddbreadl(dev, MDIO_CTRL) & 0x02)
+		ndelay(500);
+	return 0;
+}
+
+static u16 mdio_read(struct ddb *dev, u8 adr, u8 reg)
+{
+	ddbwritel(dev, adr, MDIO_ADR);
+	ddbwritel(dev, reg, MDIO_REG);
+	ddbwritel(dev, 0x07, MDIO_CTRL);
+	while (ddbreadl(dev, MDIO_CTRL) & 0x02)
+		ndelay(500);
+	return ddbreadl(dev, MDIO_VAL);
+}
+
+#define DDB_MAGIC 'd'
+
+struct ddb_flashio {
+	__u8 *write_buf;
+	__u32 write_len;
+	__u8 *read_buf;
+	__u32 read_len;
+};
+
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
+
+#define DDB_NAME "ddbridge"
+
+static u32 ddb_num;
+static int ddb_major;
+static DEFINE_MUTEX(ddb_mutex);
+
+static int ddb_release(struct inode *inode, struct file *file)
+{
+	struct ddb *dev = file->private_data;
+
+	dev->ddb_dev_users--;
+	return 0;
+}
+
+static int ddb_open(struct inode *inode, struct file *file)
+{
+	struct ddb *dev = ddbs[iminor(inode)];
+
+	if (dev->ddb_dev_users)
+		return -EBUSY;
+	dev->ddb_dev_users++;
+	file->private_data = dev;
+	return 0;
+}
+
+static long ddb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct ddb *dev = file->private_data;
+	void *parg = (void *)arg;
+	int res;
+
+	switch (cmd) {
+	case IOCTL_DDB_FLASHIO:
+	{
+		struct ddb_flashio fio;
+		u8 *rbuf, *wbuf;
+
+		if (copy_from_user(&fio, parg, sizeof(fio)))
+			return -EFAULT;
+		if (fio.write_len > 1028 || fio.read_len > 1028)
+			return -EINVAL;
+		if (fio.write_len + fio.read_len > 1028)
+			return -EINVAL;
+
+		wbuf = &dev->iobuf[0];
+		rbuf = wbuf + fio.write_len;
+
+		if (copy_from_user(wbuf, fio.write_buf, fio.write_len))
+			return -EFAULT;
+		res = flashio(dev, wbuf, fio.write_len, rbuf, fio.read_len);
+		if (res)
+			return res;
+		if (copy_to_user(fio.read_buf, rbuf, fio.read_len))
+			return -EFAULT;
+		break;
+	}
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
+		ddbid.vendor = dev->ids.vendor;
+		ddbid.device = dev->ids.device;
+		ddbid.subvendor = dev->ids.subvendor;
+		ddbid.subdevice = dev->ids.subdevice;
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
+		if (!dev->info->mdio_num)
+			return -EIO;
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
+		if (!dev->info->mdio_num)
+			return -EIO;
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
+	default:
+		return -ENOTTY;
+	}
+	return 0;
+}
+
+static const struct file_operations ddb_fops = {
+	.unlocked_ioctl = ddb_ioctl,
+	.open           = ddb_open,
+	.release        = ddb_release,
+};
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3, 4, 0))
+static char *ddb_devnode(struct device *device, mode_t *mode)
+#else
+static char *ddb_devnode(struct device *device, umode_t *mode)
+#endif
+{
+	struct ddb *dev = dev_get_drvdata(device);
+
+	return kasprintf(GFP_KERNEL, "ddbridge/card%d", dev->nr);
+}
+
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
+	return sprintf(buf, "%d\n", dev->info->port_num);
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
+static char *class_name[] = {
+	"NONE", "CI", "TUNER", "LOOP"
+};
+
+static char *type_name[] = {
+	"NONE", "DVBS_ST", "DVBS_ST_AA", "DVBCT_TR",
+	"DVBCT_ST", "INTERNAL", "CXD2099", "TYPE07",
+	"TYPE08", "TYPE09", "TYPE0A", "TYPE0B",
+	"TYPE0C", "TYPE0D", "TYPE0E", "TYPE0F",
+	"DVBS", "DVBCT2_SONY", "ISDBT_SONY", "DVBC2T2_SONY",
+	"ATSC_ST", "DVBC2T2_ST"
+};
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
+	unsigned val;
+
+	if (sscanf(buf, "%u\n", &val) != 1)
+		return -EINVAL;
+	ddbwritel(dev, 1, GPIO_DIRECTION);
+	ddbwritel(dev, val & 1, GPIO_OUTPUT);
+	return count;
+}
+
+static ssize_t temp_show(struct device *device,
+			 struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+	struct i2c_adapter *adap;
+	int temp, temp2, temp3, i;
+	u8 tmp[2];
+
+	if (dev->info->type == DDB_MOD) {
+		ddbwritel(dev, 1, TEMPMON_CONTROL);
+		for (i = 0; i < 10; i++) {
+			if (0 == (1 & ddbreadl(dev, TEMPMON_CONTROL)))
+				break;
+			usleep_range(1000, 2000);
+		}
+		temp = ddbreadl(dev, TEMPMON_SENSOR1);
+		temp2 = ddbreadl(dev, TEMPMON_SENSOR2);
+		temp = (temp * 1000) >> 8;
+		temp2 = (temp2 * 1000) >> 8;
+		if (ddbreadl(dev, TEMPMON_CONTROL) & 0x8000) {
+			temp3 = ddbreadl(dev, TEMPMON_CORE);
+			temp3 = (temp3 * 1000) >> 8;
+			return sprintf(buf, "%d %d %d\n", temp, temp2, temp3);
+		}
+		return sprintf(buf, "%d %d\n", temp, temp2);
+	}
+	if (!dev->info->temp_num)
+		return sprintf(buf, "no sensor\n");
+	adap = &dev->i2c[dev->info->temp_bus].adap;
+	if (i2c_read_regs(adap, 0x48, 0, tmp, 2) < 0)
+		return sprintf(buf, "read_error\n");
+	temp = (tmp[0] << 3) | (tmp[1] >> 5);
+	temp *= 125;
+	if (dev->info->temp_num == 2) {
+		if (i2c_read_regs(adap, 0x49, 0, tmp, 2) < 0)
+			return sprintf(buf, "read_error\n");
+		temp2 = (tmp[0] << 3) | (tmp[1] >> 5);
+		temp2 *= 125;
+		return sprintf(buf, "%d %d\n", temp, temp2);
+	}
+	return sprintf(buf, "%d\n", temp);
+}
+
+#if 0
+static ssize_t qam_show(struct device *device,
+			struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+	struct i2c_adapter *adap;
+	u8 tmp[4];
+	s16 i, q;
+
+	adap = &dev->i2c[1].adap;
+	if (i2c_read_regs16(adap, 0x1f, 0xf480, tmp, 4) < 0)
+		return sprintf(buf, "read_error\n");
+	i = (s16) (((u16) tmp[1]) << 14) | (((u16) tmp[0]) << 6);
+	q = (s16) (((u16) tmp[3]) << 14) | (((u16) tmp[2]) << 6);
+
+	return sprintf(buf, "%d %d\n", i, q);
+}
+#endif
+
+static ssize_t mod_show(struct device *device,
+			struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+	int num = attr->attr.name[3] - 0x30;
+
+	return sprintf(buf, "%s:%s\n",
+		       class_name[dev->port[num].class],
+		       type_name[dev->port[num].type]);
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
+	if (!dev->info->led_num)
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
+		case DDB_TUNER_XO2 ... DDB_TUNER_DVBC2T2_ST:
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
+		break;
+	}
+}
+
+static ssize_t led_store(struct device *device,
+			 struct device_attribute *attr,
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
+				    0x50, 0x100, snr, 32) < 0)
+			if (i2c_read_regs16(&dev->i2c[num].adap,
+					    0x57, 0x100, snr, 32) < 0)
+				return sprintf(buf, "NO SNR\n");
+		snr[31] = 0; /* in case it is not terminated on EEPROM */
+	}
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
+	ddbridge_flashread(dev, snr, 0x10, 15);
+	snr[15] = 0; /* in case it is not terminated on EEPROM */
+	return sprintf(buf, "%s\n", snr);
+}
+
+static ssize_t redirect_show(struct device *device,
+			     struct device_attribute *attr, char *buf)
+{
+	return 0;
+}
+
+static ssize_t redirect_store(struct device *device,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	unsigned int i, p;
+	int res;
+
+	if (sscanf(buf, "%x %x\n", &i, &p) != 2)
+		return -EINVAL;
+	res = ddb_redirect(i, p);
+	if (res < 0)
+		return res;
+	pr_info("redirect: %02x, %02x\n", i, p);
+	return count;
+}
+
+static ssize_t gap_show(struct device *device,
+			struct device_attribute *attr, char *buf)
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
+static ssize_t version_show(struct device *device,
+			    struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+
+	return sprintf(buf, "%08x %08x\n",
+		       ddbreadl(dev, 0), ddbreadl(dev, 4));
+}
+
+static ssize_t hwid_show(struct device *device,
+			 struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+
+	return sprintf(buf, "0x%08X\n", dev->ids.hwid);
+}
+
+static ssize_t regmap_show(struct device *device,
+			   struct device_attribute *attr, char *buf)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+
+	return sprintf(buf, "0x%08X\n", dev->ids.regmapid);
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
+#if 0
+	__ATTR_RO(qam),
+#endif
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
+	__ATTR_MRO(mod4, mod_show),
+	__ATTR_MRO(mod5, mod_show),
+	__ATTR_MRO(mod6, mod_show),
+	__ATTR_MRO(mod7, mod_show),
+	__ATTR_MRO(mod8, mod_show),
+	__ATTR_MRO(mod9, mod_show),
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
+#if 0
+	.dev_attrs	= ddb_attrs,
+#endif
+	.devnode        = ddb_devnode,
+};
+
+static int ddb_class_create(void)
+{
+	ddb_major = register_chrdev(0, DDB_NAME, &ddb_fops);
+	if (ddb_major < 0)
+		return ddb_major;
+	if (class_register(&ddb_class) < 0)
+		return -1;
+	return 0;
+}
+
+static void ddb_class_destroy(void)
+{
+	class_unregister(&ddb_class);
+	unregister_chrdev(ddb_major, DDB_NAME);
+}
+
+static void ddb_device_attrs_del(struct ddb *dev)
+{
+	int i;
+
+	for (i = 0; i < dev->info->temp_num; i++)
+		device_remove_file(dev->ddb_dev, &ddb_attrs_temp[i]);
+	for (i = 0; i < dev->info->port_num; i++)
+		device_remove_file(dev->ddb_dev, &ddb_attrs_mod[i]);
+	for (i = 0; i < dev->info->fan_num; i++)
+		device_remove_file(dev->ddb_dev, &ddb_attrs_fan[i]);
+	for (i = 0; i < dev->info->i2c_num; i++) {
+		if (dev->info->led_num)
+			device_remove_file(dev->ddb_dev, &ddb_attrs_led[i]);
+		device_remove_file(dev->ddb_dev, &ddb_attrs_snr[i]);
+	}
+	for (i = 0; ddb_attrs[i].attr.name; i++)
+		device_remove_file(dev->ddb_dev, &ddb_attrs[i]);
+}
+
+static int ddb_device_attrs_add(struct ddb *dev)
+{
+	int i;
+
+	for (i = 0; ddb_attrs[i].attr.name; i++)
+		if (device_create_file(dev->ddb_dev, &ddb_attrs[i]))
+			goto fail;
+	for (i = 0; i < dev->info->temp_num; i++)
+		if (device_create_file(dev->ddb_dev, &ddb_attrs_temp[i]))
+			goto fail;
+	for (i = 0; i < dev->info->port_num; i++)
+		if (device_create_file(dev->ddb_dev, &ddb_attrs_mod[i]))
+			goto fail;
+	for (i = 0; i < dev->info->fan_num; i++)
+		if (device_create_file(dev->ddb_dev, &ddb_attrs_fan[i]))
+			goto fail;
+	for (i = 0; i < dev->info->i2c_num; i++) {
+		if (device_create_file(dev->ddb_dev, &ddb_attrs_snr[i]))
+			goto fail;
+		if (dev->info->led_num)
+			if (device_create_file(dev->ddb_dev,
+					       &ddb_attrs_led[i]))
+				goto fail;
+	}
+	return 0;
+fail:
+	return -1;
+}
+
+static int ddb_device_create(struct ddb *dev)
+{
+	int res = 0;
+
+	if (ddb_num == DDB_MAX_ADAPTER)
+		return -ENOMEM;
+	mutex_lock(&ddb_mutex);
+	dev->nr = ddb_num;
+	ddbs[dev->nr] = dev;
+	dev->ddb_dev = device_create(&ddb_class, dev->dev,
+				     MKDEV(ddb_major, dev->nr),
+				     dev, "ddbridge%d", dev->nr);
+	if (IS_ERR(dev->ddb_dev)) {
+		res = PTR_ERR(dev->ddb_dev);
+		pr_info("Could not create ddbridge%d\n", dev->nr);
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
+}
+
+static void ddb_device_destroy(struct ddb *dev)
+{
+	if (IS_ERR(dev->ddb_dev))
+		return;
+	ddb_device_attrs_del(dev);
+	device_destroy(&ddb_class, MKDEV(ddb_major, dev->nr));
+}
diff --git a/drivers/media/pci/ddbridge/ddbridge-i2c.c b/drivers/media/pci/ddbridge/ddbridge-i2c.c
new file mode 100644
index 0000000..bd0d9b1
--- /dev/null
+++ b/drivers/media/pci/ddbridge/ddbridge-i2c.c
@@ -0,0 +1,257 @@
+/*
+ * ddbridge-i2c.c: Digital Devices bridge i2c driver
+ *
+ * Copyright (C) 2010-2014 Digital Devices GmbH
+ *                         Ralph Metzler <rmetzler@digitaldevices.de>
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA
+ * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
+ */
+
+static int i2c_write(struct i2c_adapter *adap, u8 adr, u8 *data, int len)
+{
+	struct i2c_msg msg = {.addr = adr, .flags = 0,
+			      .buf = data, .len = len};
+
+	return (i2c_transfer(adap, &msg, 1) == 1) ? 0 : -1;
+}
+
+static int i2c_read(struct i2c_adapter *adapter, u8 adr, u8 *val)
+{
+	struct i2c_msg msgs[1] = {{.addr = adr,  .flags = I2C_M_RD,
+				   .buf  = val,  .len   = 1 } };
+	return (i2c_transfer(adapter, msgs, 1) == 1) ? 0 : -1;
+}
+
+static int i2c_read_regs(struct i2c_adapter *adapter,
+			 u8 adr, u8 reg, u8 *val, u8 len)
+{
+	struct i2c_msg msgs[2] = {{.addr = adr,  .flags = 0,
+				   .buf  = &reg, .len   = 1 },
+				  {.addr = adr,  .flags = I2C_M_RD,
+				   .buf  = val,  .len   = len } };
+	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
+}
+
+static int i2c_read_regs16(struct i2c_adapter *adapter,
+			   u8 adr, u16 reg, u8 *val, u8 len)
+{
+	u8 reg16[2] = { reg >> 8, reg };
+	struct i2c_msg msgs[2] = {{.addr = adr,  .flags = 0,
+				   .buf  = reg16, .len   = 2 },
+				  {.addr = adr,  .flags = I2C_M_RD,
+				   .buf  = val,  .len   = len } };
+	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
+}
+
+static int i2c_read_reg(struct i2c_adapter *adapter, u8 adr, u8 reg, u8 *val)
+{
+	struct i2c_msg msgs[2] = {{.addr = adr,  .flags = 0,
+				   .buf  = &reg, .len   = 1},
+				  {.addr = adr,  .flags = I2C_M_RD,
+				   .buf  = val,  .len   = 1 } };
+	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
+}
+
+static int i2c_read_reg16(struct i2c_adapter *adapter, u8 adr,
+			  u16 reg, u8 *val)
+{
+	u8 msg[2] = {reg >> 8, reg & 0xff};
+	struct i2c_msg msgs[2] = {{.addr = adr, .flags = 0,
+				   .buf  = msg, .len   = 2},
+				  {.addr = adr, .flags = I2C_M_RD,
+				   .buf  = val, .len   = 1 } };
+	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
+}
+
+static int i2c_write_reg16(struct i2c_adapter *adap, u8 adr,
+			   u16 reg, u8 val)
+{
+	u8 msg[3] = {reg >> 8, reg & 0xff, val};
+
+	return i2c_write(adap, adr, msg, 3);
+}
+
+static int i2c_write_reg(struct i2c_adapter *adap, u8 adr,
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
+	int stat;
+	u32 val;
+
+	ddbwritel(dev, (adr << 9) | cmd, i2c->regs + I2C_COMMAND);
+	stat = wait_for_completion_timeout(&i2c->completion, HZ);
+	if (stat <= 0) {
+		pr_err("DDBridge I2C timeout, card %d, port %d\n",
+		       dev->nr, i2c->nr);
+#ifdef CONFIG_PCI_MSI
+		{ /* MSI debugging*/
+			u32 istat = ddbreadl(dev, INTERRUPT_STATUS);
+			dev_err(dev->dev, "DDBridge IRS %08x\n", istat);
+			ddbwritel(dev, istat, INTERRUPT_ACK);
+		}
+#endif
+		return -EIO;
+	}
+	val = ddbreadl(dev, i2c->regs + I2C_COMMAND);
+	if (val & 0x70000)
+		return -EIO;
+	return 0;
+}
+
+static int ddb_i2c_master_xfer(struct i2c_adapter *adapter,
+			       struct i2c_msg msg[], int num)
+{
+	struct ddb_i2c *i2c = (struct ddb_i2c *) i2c_get_adapdata(adapter);
+	struct ddb *dev = i2c->dev;
+	u8 addr = 0;
+
+	if (num)
+		addr = msg[0].addr;
+	if (num == 2 && msg[1].flags & I2C_M_RD &&
+	    !(msg[0].flags & I2C_M_RD)) {
+		memcpy_toio(dev->regs + I2C_TASKMEM_BASE + i2c->wbuf,
+			    msg[0].buf, msg[0].len);
+		ddbwritel(dev, msg[0].len|(msg[1].len << 16),
+			  i2c->regs + I2C_TASKLENGTH);
+		if (!ddb_i2c_cmd(i2c, addr, 1)) {
+			memcpy_fromio(msg[1].buf,
+				      dev->regs + I2C_TASKMEM_BASE +
+				      i2c->rbuf,
+				      msg[1].len);
+			return num;
+		}
+	}
+	if (num == 1 && !(msg[0].flags & I2C_M_RD)) {
+		ddbcpyto(dev, I2C_TASKMEM_BASE + i2c->wbuf,
+			 msg[0].buf, msg[0].len);
+		ddbwritel(dev, msg[0].len, i2c->regs + I2C_TASKLENGTH);
+		if (!ddb_i2c_cmd(i2c, addr, 2))
+			return num;
+	}
+	if (num == 1 && (msg[0].flags & I2C_M_RD)) {
+		ddbwritel(dev, msg[0].len << 16, i2c->regs + I2C_TASKLENGTH);
+		if (!ddb_i2c_cmd(i2c, addr, 3)) {
+			ddbcpyfrom(dev, msg[0].buf,
+				   I2C_TASKMEM_BASE + i2c->rbuf, msg[0].len);
+			return num;
+		}
+	}
+	return -EIO;
+}
+
+#if 0
+static int ddb_i2c_master_xfer(struct i2c_adapter *adapter,
+			       struct i2c_msg msg[], int num)
+{
+	struct ddb_i2c *i2c = (struct ddb_i2c *) i2c_get_adapdata(adapter);
+	struct ddb *dev = i2c->dev;
+	int ret;
+
+	if (dev->info->type != DDB_OCTONET || i2c->nr == 0 || i2c->nr == 3)
+		return ddb_i2c_master_xfer_locked(adapter, msg, num);
+
+	mutex_lock(&dev->octonet_i2c_lock);
+	ret = ddb_i2c_master_xfer_locked(adapter, msg, num);
+	mutex_unlock(&dev->octonet_i2c_lock);
+	return ret;
+}
+#endif
+
+static u32 ddb_i2c_functionality(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_SMBUS_EMUL;
+}
+
+struct i2c_algorithm ddb_i2c_algo = {
+	.master_xfer   = ddb_i2c_master_xfer,
+	.functionality = ddb_i2c_functionality,
+};
+
+static void ddb_i2c_release(struct ddb *dev)
+{
+	int i;
+	struct ddb_i2c *i2c;
+	struct i2c_adapter *adap;
+
+	for (i = 0; i < dev->info->i2c_num; i++) {
+		i2c = &dev->i2c[i];
+		adap = &i2c->adap;
+		i2c_del_adapter(adap);
+	}
+}
+
+static void i2c_handler(unsigned long priv)
+{
+	struct ddb_i2c *i2c = (struct ddb_i2c *) priv;
+
+	complete(&i2c->completion);
+}
+
+static int ddb_i2c_init(struct ddb *dev)
+{
+	int i, j, stat = 0;
+	struct ddb_i2c *i2c;
+	struct i2c_adapter *adap;
+
+	for (i = 0; i < dev->info->i2c_num; i++) {
+		i2c = &dev->i2c[i];
+		dev->handler[i] = i2c_handler;
+		dev->handler_data[i] = (unsigned long) i2c;
+		i2c->dev = dev;
+		i2c->nr = i;
+		i2c->wbuf = i * (I2C_TASKMEM_SIZE / 4);
+		i2c->rbuf = i2c->wbuf + (I2C_TASKMEM_SIZE / 8);
+		i2c->regs = 0x80 + i * 0x20;
+		ddbwritel(dev, I2C_SPEED_100, i2c->regs + I2C_TIMING);
+		ddbwritel(dev, (i2c->rbuf << 16) | i2c->wbuf,
+			  i2c->regs + I2C_TASKADDRESS);
+		init_completion(&i2c->completion);
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
+		adap->dev.parent = dev->dev;
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
+
diff --git a/drivers/media/pci/ddbridge/ddbridge-regs.h b/drivers/media/pci/ddbridge/ddbridge-regs.h
new file mode 100644
index 0000000..eca8574
--- /dev/null
+++ b/drivers/media/pci/ddbridge/ddbridge-regs.h
@@ -0,0 +1,436 @@
+/*
+ * ddbridge-regs.h: Digital Devices PCIe bridge driver
+ *
+ * Copyright (C) 2010-2014 Digital Devices GmbH
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA
+ * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
+ */
+
+/* Register Definitions */
+
+#define CUR_REGISTERMAP_VERSION     0x10003
+#define CUR_REGISTERMAP_VERSION_CI  0x10000
+#define CUR_REGISTERMAP_VERSION_MOD 0x10000
+
+#define HARDWARE_VERSION       0x00
+#define REGISTERMAP_VERSION    0x04
+
+/* ------------------------------------------------------------------------- */
+/* SPI Controller */
+
+#define SPI_CONTROL     0x10
+#define SPI_DATA        0x14
+
+/* ------------------------------------------------------------------------- */
+/* GPIO */
+
+#define GPIO_OUTPUT      0x20
+#define GPIO_INPUT       0x24
+#define GPIO_DIRECTION   0x28
+
+/* ------------------------------------------------------------------------- */
+/* MDIO */
+
+#define MDIO_CTRL        0x20
+#define MDIO_ADR         0x24
+#define MDIO_REG         0x28
+#define MDIO_VAL         0x2C
+
+/* ------------------------------------------------------------------------- */
+
+#define BOARD_CONTROL    0x30
+
+/* ------------------------------------------------------------------------- */
+
+/* Interrupt controller
+   How many MSI's are available depends on HW (Min 2 max 8)
+   How many are usable also depends on Host platform
+*/
+
+#define INTERRUPT_BASE   (0x40)
+
+#define INTERRUPT_ENABLE (INTERRUPT_BASE + 0x00)
+#define MSI0_ENABLE      (INTERRUPT_BASE + 0x00)
+#define MSI1_ENABLE      (INTERRUPT_BASE + 0x04)
+#define MSI2_ENABLE      (INTERRUPT_BASE + 0x08)
+#define MSI3_ENABLE      (INTERRUPT_BASE + 0x0C)
+#define MSI4_ENABLE      (INTERRUPT_BASE + 0x10)
+#define MSI5_ENABLE      (INTERRUPT_BASE + 0x14)
+#define MSI6_ENABLE      (INTERRUPT_BASE + 0x18)
+#define MSI7_ENABLE      (INTERRUPT_BASE + 0x1C)
+
+#define INTERRUPT_STATUS (INTERRUPT_BASE + 0x20)
+#define INTERRUPT_ACK    (INTERRUPT_BASE + 0x20)
+
+#define INTMASK_CLOCKGEN    (0x00000001)
+#define INTMASK_TEMPMON     (0x00000002)
+
+#define INTMASK_I2C1        (0x00000001)
+#define INTMASK_I2C2        (0x00000002)
+#define INTMASK_I2C3        (0x00000004)
+#define INTMASK_I2C4        (0x00000008)
+
+#define INTMASK_CIRQ1       (0x00000010)
+#define INTMASK_CIRQ2       (0x00000020)
+#define INTMASK_CIRQ3       (0x00000040)
+#define INTMASK_CIRQ4       (0x00000080)
+
+#define INTMASK_TSINPUT1    (0x00000100)
+#define INTMASK_TSINPUT2    (0x00000200)
+#define INTMASK_TSINPUT3    (0x00000400)
+#define INTMASK_TSINPUT4    (0x00000800)
+#define INTMASK_TSINPUT5    (0x00001000)
+#define INTMASK_TSINPUT6    (0x00002000)
+#define INTMASK_TSINPUT7    (0x00004000)
+#define INTMASK_TSINPUT8    (0x00008000)
+
+#define INTMASK_TSOUTPUT1   (0x00010000)
+#define INTMASK_TSOUTPUT2   (0x00020000)
+#define INTMASK_TSOUTPUT3   (0x00040000)
+#define INTMASK_TSOUTPUT4   (0x00080000)
+
+
+/*  Clock Generator ( Sil598 @ 0xAA I2c ) */
+#define CLOCKGEN_BASE       (0x80)
+#define CLOCKGEN_CONTROL    (CLOCKGEN_BASE + 0x00)
+#define CLOCKGEN_INDEX      (CLOCKGEN_BASE + 0x04)
+#define CLOCKGEN_WRITEDATA  (CLOCKGEN_BASE + 0x08)
+#define CLOCKGEN_READDATA   (CLOCKGEN_BASE + 0x0C)
+
+/* DAC ( AD9781/AD9783 SPI ) */
+#define DAC_BASE            (0x090)
+#define DAC_CONTROL         (DAC_BASE)
+#define DAC_WRITE_DATA      (DAC_BASE+4)
+#define DAC_READ_DATA       (DAC_BASE+8)
+
+#define DAC_CONTROL_INSTRUCTION_REG (0xFF)
+#define DAC_CONTROL_STARTIO         (0x100)
+#define DAC_CONTROL_RESET           (0x200)
+
+/* Temperature Monitor ( 2x LM75A @ 0x90,0x92 I2c ) */
+#define TEMPMON_BASE        (0xA0)
+#define TEMPMON_CONTROL    (TEMPMON_BASE + 0x00)
+/* SHORT Temperature in °C x 256 */
+#define TEMPMON_CORE       (TEMPMON_BASE + 0x04)
+#define TEMPMON_SENSOR1    (TEMPMON_BASE + 0x08)
+#define TEMPMON_SENSOR2    (TEMPMON_BASE + 0x0C)
+
+/* ------------------------------------------------------------------------- */
+/* I2C Master Controller */
+
+#define I2C_BASE        (0x80)  /* Byte offset */
+
+#define I2C_COMMAND     (0x00)
+#define I2C_TIMING      (0x04)
+#define I2C_TASKLENGTH  (0x08)     /* High read, low write */
+#define I2C_TASKADDRESS (0x0C)     /* High read, low write */
+#define I2C_MONITOR     (0x1C)
+
+#define I2C_BASE_N(i)   (I2C_BASE + (i) * 0x20)
+
+#define I2C_TASKMEM_BASE    (0x1000)    /* Byte offset */
+#define I2C_TASKMEM_SIZE    (0x0800)
+
+#define I2C_SPEED_666   (0x02010202)
+#define I2C_SPEED_400   (0x04030404)
+#define I2C_SPEED_200   (0x09080909)
+#define I2C_SPEED_154   (0x0C0B0C0C)
+#define I2C_SPEED_100   (0x13121313)
+#define I2C_SPEED_77    (0x19181919)
+#define I2C_SPEED_50    (0x27262727)
+
+
+/* ------------------------------------------------------------------------- */
+/* DMA  Controller */
+
+#define DMA_BASE_WRITE        (0x100)
+#define DMA_BASE_READ         (0x140)
+
+#define DMA_CONTROL     (0x00)
+#define DMA_ERROR       (0x04)
+
+#define DMA_DIAG_CONTROL                (0x1C)
+#define DMA_DIAG_PACKETCOUNTER_LOW      (0x20)
+#define DMA_DIAG_PACKETCOUNTER_HIGH     (0x24)
+#define DMA_DIAG_TIMECOUNTER_LOW        (0x28)
+#define DMA_DIAG_TIMECOUNTER_HIGH       (0x2C)
+#define DMA_DIAG_RECHECKCOUNTER         (0x30)
+#define DMA_DIAG_WAITTIMEOUTINIT        (0x34)
+#define DMA_DIAG_WAITOVERFLOWCOUNTER    (0x38)
+#define DMA_DIAG_WAITCOUNTER            (0x3C)
+
+/* ------------------------------------------------------------------------- */
+/* DMA  Buffer */
+
+#define TS_INPUT_BASE       (0x200)
+#define TS_INPUT_CONTROL(i)         (TS_INPUT_BASE + (i) * 0x10 + 0x00)
+#define TS_INPUT_CONTROL2(i)        (TS_INPUT_BASE + (i) * 0x10 + 0x04)
+
+#define TS_OUTPUT_BASE       (0x280)
+#define TS_OUTPUT_CONTROL(i)        (TS_OUTPUT_BASE + (i) * 0x10 + 0x00)
+#define TS_OUTPUT_CONTROL2(i)       (TS_OUTPUT_BASE + (i) * 0x10 + 0x04)
+
+#define DMA_BUFFER_BASE     (0x300)
+
+#define DMA_BUFFER_CONTROL(i)       (DMA_BUFFER_BASE + (i) * 0x10 + 0x00)
+#define DMA_BUFFER_ACK(i)           (DMA_BUFFER_BASE + (i) * 0x10 + 0x04)
+#define DMA_BUFFER_CURRENT(i)       (DMA_BUFFER_BASE + (i) * 0x10 + 0x08)
+#define DMA_BUFFER_SIZE(i)          (DMA_BUFFER_BASE + (i) * 0x10 + 0x0c)
+
+#define DMA_BASE_ADDRESS_TABLE  (0x2000)
+#define DMA_BASE_ADDRESS_TABLE_ENTRIES (512)
+
+
+/* ------------------------------------------------------------------------- */
+
+#define LNB_BASE                     (0x400)
+#define LNB_CONTROL(i)               (LNB_BASE + (i) * 0x20 + 0x00)
+#define LNB_CMD   (7ULL <<  0)
+#define LNB_CMD_NOP    0
+#define LNB_CMD_INIT   1
+#define LNB_CMD_STATUS 2
+#define LNB_CMD_LOW    3
+#define LNB_CMD_HIGH   4
+#define LNB_CMD_OFF    5
+#define LNB_CMD_DISEQC 6
+#define LNB_CMD_UNI    7
+
+#define LNB_BUSY  (1ULL <<  4)
+#define LNB_TONE  (1ULL << 15)
+
+#define LNB_STATUS(i)                (LNB_BASE + (i) * 0x20 + 0x04)
+#define LNB_VOLTAGE(i)               (LNB_BASE + (i) * 0x20 + 0x08)
+#define LNB_CONFIG(i)                (LNB_BASE + (i) * 0x20 + 0x0c)
+#define LNB_BUF_LEVEL(i)             (LNB_BASE + (i) * 0x20 + 0x10)
+#define LNB_BUF_WRITE(i)             (LNB_BASE + (i) * 0x20 + 0x14)
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
+
+#define CI_RESET_CAM                    (0x00000001)
+#define CI_POWER_ON                     (0x00000002)
+#define CI_ENABLE                       (0x00000004)
+#define CI_BLOCKIO_ENABLE               (0x00000008)
+#define CI_BYPASS_DISABLE               (0x00000010)
+#define CI_DISABLE_AUTO_OFF             (0x00000020)
+
+#define CI_CAM_READY                    (0x00010000)
+#define CI_CAM_DETECT                   (0x00020000)
+#define CI_READY                        (0x80000000)
+#define CI_BLOCKIO_ACTIVE               (0x40000000)
+#define CI_BLOCKIO_RCVDATA              (0x20000000)
+#define CI_BLOCKIO_SEND_PENDING         (0x10000000)
+#define CI_BLOCKIO_SEND_COMPLETE        (0x08000000)
+
+#define CI_READ_CMD                     (0x40000000)
+#define CI_WRITE_CMD                    (0x80000000)
+
+#define CI_BLOCKIO_SEND(i)              (CI_BASE + (i) * 32 + 0x14)
+#define CI_BLOCKIO_RECEIVE(i)           (CI_BASE + (i) * 32 + 0x18)
+
+#define CI_BLOCKIO_SEND_COMMAND         (0x80000000)
+#define CI_BLOCKIO_SEND_COMPLETE_ACK    (0x40000000)
+#define CI_BLOCKIO_RCVDATA_ACK          (0x40000000)
+
+#define CI_BUFFER_BASE                  (0x3000)
+#define CI_BUFFER_SIZE                  (0x0800)
+#define CI_BLOCKIO_BUFFER_SIZE          (CI_BUFFER_SIZE/2)
+
+#define CI_BUFFER(i)                  (CI_BUFFER_BASE + (i) * CI_BUFFER_SIZE)
+#define CI_BLOCKIO_RECEIVE_BUFFER(i)  (CI_BUFFER_BASE + (i) * CI_BUFFER_SIZE)
+#define CI_BLOCKIO_SEND_BUFFER(i)  \
+	(CI_BUFFER_BASE + (i) * CI_BUFFER_SIZE + CI_BLOCKIO_BUFFER_SIZE)
+
+#define VCO1_BASE           (0xC0)
+#define VCO1_CONTROL        (VCO1_BASE + 0x00)
+#define VCO1_DATA           (VCO1_BASE + 0x04)  /* 24 Bit */
+/* 1 = Trigger write, resets when done */
+#define VCO1_CONTROL_WRITE  (0x00000001)
+/* 0 = Put VCO into power down */
+#define VCO1_CONTROL_CE     (0x00000002)
+/* Muxout from VCO (usually = Lock) */
+#define VCO1_CONTROL_MUXOUT (0x00000004)
+
+#define VCO2_BASE           (0xC8)
+#define VCO2_CONTROL        (VCO2_BASE + 0x00)
+#define VCO2_DATA           (VCO2_BASE + 0x04)  /* 24 Bit */
+/* 1 = Trigger write, resets when done */
+#define VCO2_CONTROL_WRITE  (0x00000001)
+/* 0 = Put VCO into power down */
+#define VCO2_CONTROL_CE     (0x00000002)
+/* Muxout from VCO (usually = Lock) */
+#define VCO2_CONTROL_MUXOUT (0x00000004)
+
+#define VCO3_BASE           (0xD0)
+#define VCO3_CONTROL        (VCO3_BASE + 0x00)
+#define VCO3_DATA           (VCO3_BASE + 0x04)  /* 32 Bit */
+/* 1 = Trigger write, resets when done */
+#define VCO3_CONTROL_WRITE  (0x00000001)
+/* 0 = Put VCO into power down */
+#define VCO3_CONTROL_CE     (0x00000002)
+/* Muxout from VCO (usually = Lock) */
+#define VCO3_CONTROL_MUXOUT (0x00000004)
+
+#define RF_ATTENUATOR   (0xD8)
+/*  0x00 =  0 dB
+    0x01 =  1 dB
+      ...
+    0x1F = 31 dB
+*/
+
+#define RF_POWER        (0xE0)
+#define RF_POWER_BASE       (0xE0)
+#define RF_POWER_CONTROL    (RF_POWER_BASE + 0x00)
+#define RF_POWER_DATA       (RF_POWER_BASE + 0x04)
+
+#define RF_POWER_CONTROL_START     (0x00000001)
+#define RF_POWER_CONTROL_DONE      (0x00000002)
+#define RF_POWER_CONTROL_VALIDMASK (0x00000700)
+#define RF_POWER_CONTROL_VALID     (0x00000500)
+
+
+/* --------------------------------------------------------------------------
+   Output control
+*/
+
+#define IQOUTPUT_BASE           (0x240)
+#define IQOUTPUT_CONTROL        (IQOUTPUT_BASE + 0x00)
+#define IQOUTPUT_CONTROL2       (IQOUTPUT_BASE + 0x04)
+#define IQOUTPUT_PEAK_DETECTOR  (IQOUTPUT_BASE + 0x08)
+#define IQOUTPUT_POSTSCALER     (IQOUTPUT_BASE + 0x0C)
+#define IQOUTPUT_PRESCALER      (IQOUTPUT_BASE + 0x10)
+
+#define IQOUTPUT_EQUALIZER_0    (IQOUTPUT_BASE + 0x14)
+#define IQOUTPUT_EQUALIZER_1    (IQOUTPUT_BASE + 0x18)
+#define IQOUTPUT_EQUALIZER_2    (IQOUTPUT_BASE + 0x1C)
+#define IQOUTPUT_EQUALIZER_3    (IQOUTPUT_BASE + 0x20)
+#define IQOUTPUT_EQUALIZER_4    (IQOUTPUT_BASE + 0x24)
+#define IQOUTPUT_EQUALIZER_5    (IQOUTPUT_BASE + 0x28)
+#define IQOUTPUT_EQUALIZER_6    (IQOUTPUT_BASE + 0x2C)
+#define IQOUTPUT_EQUALIZER_7    (IQOUTPUT_BASE + 0x30)
+#define IQOUTPUT_EQUALIZER_8    (IQOUTPUT_BASE + 0x34)
+#define IQOUTPUT_EQUALIZER_9    (IQOUTPUT_BASE + 0x38)
+#define IQOUTPUT_EQUALIZER_10   (IQOUTPUT_BASE + 0x3C)
+
+#define IQOUTPUT_EQUALIZER(i)   (IQOUTPUT_EQUALIZER_0 + (i) * 4)
+
+#define IQOUTPUT_CONTROL_RESET              (0x00000001)
+#define IQOUTPUT_CONTROL_ENABLE             (0x00000002)
+#define IQOUTPUT_CONTROL_RESET_PEAK         (0x00000004)
+#define IQOUTPUT_CONTROL_ENABLE_PEAK        (0x00000008)
+#define IQOUTPUT_CONTROL_BYPASS_EQUALIZER   (0x00000010)
+
+
+/* Modulator Base */
+
+#define MODULATOR_BASE          (0x200)
+#define MODULATOR_CONTROL         (MODULATOR_BASE)
+#define MODULATOR_IQTABLE_END     (MODULATOR_BASE+4)
+#define MODULATOR_IQTABLE_INDEX   (MODULATOR_BASE+8)
+#define MODULATOR_IQTABLE_DATA    (MODULATOR_BASE+12)
+
+#define MODULATOR_IQTABLE_INDEX_CHANNEL_MASK  (0x000F0000)
+#define MODULATOR_IQTABLE_INDEX_IQ_MASK       (0x00008000)
+#define MODULATOR_IQTABLE_INDEX_ADDRESS_MASK  (0x000007FF)
+#define MODULATOR_IQTABLE_INDEX_SEL_I         (0x00000000)
+#define MODULATOR_IQTABLE_INDEX_SEL_Q     (MODULATOR_IQTABLE_INDEX_IQ_MASK)
+#define MODULATOR_IQTABLE_SIZE    (2048)
+
+
+/* Modulator Channels */
+
+#define CHANNEL_BASE                (0x400)
+#define CHANNEL_CONTROL(i)          (CHANNEL_BASE + (i) * 64 + 0x00)
+#define CHANNEL_SETTINGS(i)         (CHANNEL_BASE + (i) * 64 + 0x04)
+#define CHANNEL_RATE_INCR(i)        (CHANNEL_BASE + (i) * 64 + 0x0C)
+#define CHANNEL_PCR_ADJUST_OUTL(i)  (CHANNEL_BASE + (i) * 64 + 0x10)
+#define CHANNEL_PCR_ADJUST_OUTH(i)  (CHANNEL_BASE + (i) * 64 + 0x14)
+#define CHANNEL_PCR_ADJUST_INL(i)   (CHANNEL_BASE + (i) * 64 + 0x18)
+#define CHANNEL_PCR_ADJUST_INH(i)   (CHANNEL_BASE + (i) * 64 + 0x1C)
+#define CHANNEL_PCR_ADJUST_ACCUL(i) (CHANNEL_BASE + (i) * 64 + 0x20)
+#define CHANNEL_PCR_ADJUST_ACCUH(i) (CHANNEL_BASE + (i) * 64 + 0x24)
+#define CHANNEL_PKT_COUNT_OUT(i)    (CHANNEL_BASE + (i) * 64 + 0x28)
+#define CHANNEL_PKT_COUNT_IN(i)     (CHANNEL_BASE + (i) * 64 + 0x2C)
+
+#define CHANNEL_CONTROL_RESET               (0x00000001)
+#define CHANNEL_CONTROL_ENABLE_DVB          (0x00000002)
+#define CHANNEL_CONTROL_ENABLE_IQ           (0x00000004)
+#define CHANNEL_CONTROL_ENABLE_SOURCE       (0x00000008)
+#define CHANNEL_CONTROL_ENABLE_PCRADJUST    (0x00000010)
+#define CHANNEL_CONTROL_FREEZE_STATUS       (0x00000100)
+
+#define CHANNEL_CONTROL_RESET_ERROR         (0x00010000)
+#define CHANNEL_CONTROL_BUSY                (0x01000000)
+#define CHANNEL_CONTROL_ERROR_SYNC          (0x20000000)
+#define CHANNEL_CONTROL_ERROR_UNDERRUN      (0x40000000)
+#define CHANNEL_CONTROL_ERROR_FATAL         (0x80000000)
+
+#define CHANNEL_SETTINGS_QAM_MASK           (0x00000007)
+#define CHANNEL_SETTINGS_QAM16              (0x00000000)
+#define CHANNEL_SETTINGS_QAM32              (0x00000001)
+#define CHANNEL_SETTINGS_QAM64              (0x00000002)
+#define CHANNEL_SETTINGS_QAM128             (0x00000003)
+#define CHANNEL_SETTINGS_QAM256             (0x00000004)
+
+
+/* OCTONET */
+
+#define ETHER_BASE       (0x100)
+#define ETHER_CONTROL    (ETHER_BASE + 0x00)
+#define ETHER_LENGTH     (ETHER_BASE + 0x04)
+
+#define RTP_MASTER_BASE      (0x120)
+#define RTP_MASTER_CONTROL          (RTP_MASTER_BASE + 0x00)
+#define RTP_RTCP_INTERRUPT          (RTP_MASTER_BASE + 0x04)
+#define RTP_MASTER_RTCP_SETTINGS    (RTP_MASTER_BASE + 0x0c)
+
+#define STREAM_BASE       (0x400)
+#define STREAM_CONTROL(i)        (STREAM_BASE + (i) * 0x20 + 0x00)
+#define STREAM_RTP_PACKET(i)        (STREAM_BASE + (i) * 0x20 + 0x04)
+#define STREAM_RTCP_PACKET(i)       (STREAM_BASE + (i) * 0x20 + 0x08)
+#define STREAM_RTP_SETTINGS(i)      (STREAM_BASE + (i) * 0x20 + 0x0c)
+#define STREAM_INSERT_PACKET(i)     (STREAM_BASE + (i) * 0x20 + 0x10)
+
+#define STREAM_PACKET_OFF(i) ((i) * 0x200)
+#define STREAM_PACKET_ADR(i) (0x2000 + (STREAM_PACKET_OFF(i)))
+
+#define STREAM_PIDS(i) (0x4000 + (i) * 0x400)
+
+#define TS_CAPTURE_BASE (0x0140)
+#define TS_CAPTURE_CONTROL       (TS_CAPTURE_BASE + 0x00)
+#define TS_CAPTURE_PID           (TS_CAPTURE_BASE + 0x04)
+#define TS_CAPTURE_RECEIVED      (TS_CAPTURE_BASE + 0x08)
+#define TS_CAPTURE_TIMEOUT       (TS_CAPTURE_BASE + 0x0c)
+#define TS_CAPTURE_TABLESECTION  (TS_CAPTURE_BASE + 0x10)
+
+#define TS_CAPTURE_MEMORY (0x7000)
+
+#define PID_FILTER_BASE       (0x800)
+#define PID_FILTER_SYSTEM_PIDS(i)     (PID_FILTER_BASE + (i) * 0x20)
+#define PID_FILTER_PID(i, j)     (PID_FILTER_BASE + (i) * 0x20 + (j) * 4)
+
+
+
diff --git a/drivers/media/pci/ddbridge/ddbridge.c b/drivers/media/pci/ddbridge/ddbridge.c
new file mode 100644
index 0000000..70c7ef0
--- /dev/null
+++ b/drivers/media/pci/ddbridge/ddbridge.c
@@ -0,0 +1,460 @@
+/*
+ * ddbridge.c: Digital Devices PCIe bridge driver
+ *
+ * Copyright (C) 2010-2013 Digital Devices GmbH
+ *                         Ralph Metzler <rmetzler@digitaldevices.de>
+ *                         Marcus Metzler <mmetzler@digitaldevices.de>
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA
+ * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
+ */
+
+/*#define DDB_ALT_DMA*/
+#define DDB_USE_WORK
+/*#define DDB_TEST_THREADED*/
+
+#include "ddbridge.h"
+#include "ddbridge-regs.h"
+
+static struct workqueue_struct *ddb_wq;
+
+static int adapter_alloc;
+module_param(adapter_alloc, int, 0444);
+MODULE_PARM_DESC(adapter_alloc,
+		 "0-one adapter per io, 1-one per tab with io, 2-one per tab, 3-one for all");
+
+#ifdef CONFIG_PCI_MSI
+static int msi = 1;
+module_param(msi, int, 0444);
+MODULE_PARM_DESC(msi,
+		 " Control MSI interrupts: 0-disable, 1-enable (default)");
+#endif
+
+#include "ddbridge-core.c"
+
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+
+static void ddb_unmap(struct ddb *dev)
+{
+	if (dev->regs)
+		iounmap(dev->regs);
+	vfree(dev);
+}
+
+
+static void __devexit ddb_remove(struct pci_dev *pdev)
+{
+	struct ddb *dev = (struct ddb *) pci_get_drvdata(pdev);
+
+	ddb_ports_detach(dev);
+	ddb_i2c_release(dev);
+
+	ddbwritel(dev, 0, INTERRUPT_ENABLE);
+	ddbwritel(dev, 0, MSI1_ENABLE);
+	if (dev->msi == 2)
+		free_irq(dev->pdev->irq + 1, dev);
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
+	pci_set_drvdata(pdev, 0);
+	pci_disable_device(pdev);
+}
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3, 8, 0))
+#define __devinit
+#define __devinitdata
+#endif
+
+static int __devinit ddb_probe(struct pci_dev *pdev,
+			       const struct pci_device_id *id)
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
+	dev->has_dma = 1;
+	dev->pdev = pdev;
+	dev->dev = &pdev->dev;
+	pci_set_drvdata(pdev, dev);
+
+	dev->ids.vendor = id->vendor;
+	dev->ids.device = id->device;
+	dev->ids.subvendor = id->subvendor;
+	dev->ids.subdevice = id->subdevice;
+
+	dev->info = (struct ddb_info *) id->driver_data;
+	pr_info("DDBridge driver detected: %s\n", dev->info->name);
+
+	dev->regs_len = pci_resource_len(dev->pdev, 0);
+	dev->regs = ioremap(pci_resource_start(dev->pdev, 0),
+			    pci_resource_len(dev->pdev, 0));
+	if (!dev->regs) {
+		pr_err("DDBridge: not enough memory for register map\n");
+		stat = -ENOMEM;
+		goto fail;
+	}
+	if (ddbreadl(dev, 0) == 0xffffffff) {
+		pr_err("DDBridge: cannot read registers\n");
+		stat = -ENODEV;
+		goto fail;
+	}
+
+	dev->ids.hwid = ddbreadl(dev, 0);
+	dev->ids.regmapid = ddbreadl(dev, 4);
+
+	pr_info("HW %08x REGMAP %08x\n",
+		dev->ids.hwid, dev->ids.regmapid);
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
+	if (msi && pci_msi_enabled()) {
+		stat = pci_enable_msi_block(dev->pdev, 2);
+		if (stat == 0) {
+			dev->msi = 1;
+			pr_info("DDBrige using 2 MSI interrupts\n");
+		}
+		if (stat == 1)
+			stat = pci_enable_msi(dev->pdev);
+		if (stat < 0) {
+			pr_info(": MSI not available.\n");
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
+	} else
+#endif
+	{
+#ifdef DDB_TEST_THREADED
+		stat = request_threaded_irq(dev->pdev->irq, irq_handler,
+					    irq_thread,
+					    irq_flag,
+					    "ddbridge", (void *) dev);
+#else
+		stat = request_irq(dev->pdev->irq, irq_handler,
+				   irq_flag, "ddbridge", (void *) dev);
+#endif
+		if (stat < 0)
+			goto fail0;
+	}
+	ddbwritel(dev, 0, DMA_BASE_READ);
+	if (dev->info->type != DDB_MOD)
+		ddbwritel(dev, 0, DMA_BASE_WRITE);
+
+	/*ddbwritel(dev, 0xffffffff, INTERRUPT_ACK);*/
+	if (dev->msi == 2) {
+		ddbwritel(dev, 0x0fffff00, INTERRUPT_ENABLE);
+		ddbwritel(dev, 0x0000000f, MSI1_ENABLE);
+	} else {
+		ddbwritel(dev, 0x0fffff0f, INTERRUPT_ENABLE);
+		ddbwritel(dev, 0x00000000, MSI1_ENABLE);
+	}
+	mutex_init(&dev->lnb_lock);
+	if (ddb_i2c_init(dev) < 0)
+		goto fail1;
+	ddb_ports_init(dev);
+	if (ddb_buffers_alloc(dev) < 0) {
+		pr_info(": Could not allocate buffer memory\n");
+		goto fail2;
+	}
+	if (ddb_ports_attach(dev) < 0)
+		goto fail3;
+
+	/* ignore if this fails */
+	ddb_device_create(dev);
+
+	if (dev->info->fan_num)	{
+		ddbwritel(dev, 1, GPIO_DIRECTION);
+		ddbwritel(dev, 1, GPIO_OUTPUT);
+	}
+	if (dev->info->type == DDB_MOD)
+		ddbridge_mod_init(dev);
+
+	return 0;
+
+fail3:
+	ddb_ports_detach(dev);
+	pr_err("fail3\n");
+	ddb_ports_release(dev);
+fail2:
+	pr_err("fail2\n");
+	ddb_buffers_free(dev);
+	ddb_i2c_release(dev);
+fail1:
+	pr_err("fail1\n");
+	ddbwritel(dev, 0, INTERRUPT_ENABLE);
+	ddbwritel(dev, 0, MSI1_ENABLE);
+	free_irq(dev->pdev->irq, dev);
+	if (dev->msi == 2)
+		free_irq(dev->pdev->irq + 1, dev);
+fail0:
+	pr_err("fail0\n");
+	if (dev->msi)
+		pci_disable_msi(dev->pdev);
+fail:
+	pr_err("fail\n");
+	ddb_unmap(dev);
+	pci_set_drvdata(pdev, 0);
+	pci_disable_device(pdev);
+	return -1;
+}
+
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+
+static struct ddb_regset octopus_i2c = {
+	.base = 0x80,
+	.num  = 0x04,
+	.size = 0x20,
+};
+
+static struct ddb_regmap octopus_map = {
+	.i2c = &octopus_i2c,
+};
+
+static struct ddb_info ddb_none = {
+	.type     = DDB_NONE,
+	.name     = "unknown Digital Devices PCIe card, install newer driver",
+	.regmap   = &octopus_map,
+};
+
+static struct ddb_info ddb_octopus = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Octopus DVB adapter",
+	.port_num = 4,
+	.i2c_num  = 4,
+};
+
+static struct ddb_info ddb_octopusv3 = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Octopus V3 DVB adapter",
+	.port_num = 4,
+	.i2c_num  = 4,
+};
+
+static struct ddb_info ddb_octopus_le = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Octopus LE DVB adapter",
+	.port_num = 2,
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
+};
+
+static struct ddb_info ddb_v6 = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Cine S2 V6 DVB adapter",
+	.port_num = 3,
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
+static struct ddb_info ddb_v7 = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Cine S2 V7 DVB adapter",
+	.port_num = 4,
+	.i2c_num  = 4,
+	.board_control = 2,
+};
+
+static struct ddb_info ddb_s2_48 = {
+	.type     = DDB_OCTOPUS_MAX,
+	.name     = "Digital Devices Cine S2 4/8",
+	.port_num = 4,
+	.i2c_num  = 1,
+	.board_control = 1,
+};
+
+static struct ddb_info ddb_ctv7 = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Cine CT V7 DVB adapter",
+	.port_num = 4,
+	.i2c_num  = 4,
+	.board_control = 3,
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
+};
+
+#define DDVID 0xdd01 /* Digital Devices Vendor ID */
+
+#define DDB_ID(_vend, _dev, _subvend, _subdev, _driverdata) { \
+	.vendor      = _vend,    .device    = _dev, \
+	.subvendor   = _subvend, .subdevice = _subdev, \
+	.driver_data = (unsigned long)&_driverdata }
+
+static const struct pci_device_id ddb_id_tbl[] __devinitconst = {
+	DDB_ID(DDVID, 0x0002, DDVID, 0x0001, ddb_octopus),
+	DDB_ID(DDVID, 0x0003, DDVID, 0x0001, ddb_octopus),
+	DDB_ID(DDVID, 0x0005, DDVID, 0x0004, ddb_octopusv3),
+	DDB_ID(DDVID, 0x0003, DDVID, 0x0002, ddb_octopus_le),
+	DDB_ID(DDVID, 0x0003, DDVID, 0x0003, ddb_octopus_oem),
+	DDB_ID(DDVID, 0x0003, DDVID, 0x0010, ddb_octopus_mini),
+	DDB_ID(DDVID, 0x0003, DDVID, 0x0020, ddb_v6),
+	DDB_ID(DDVID, 0x0003, DDVID, 0x0021, ddb_v6_5),
+	DDB_ID(DDVID, 0x0006, DDVID, 0x0022, ddb_v7),
+	DDB_ID(DDVID, 0x0003, DDVID, 0x0030, ddb_dvbct),
+	DDB_ID(DDVID, 0x0003, DDVID, 0xdb03, ddb_satixS2v3),
+	DDB_ID(DDVID, 0x0006, DDVID, 0x0031, ddb_ctv7),
+	DDB_ID(DDVID, 0x0006, DDVID, 0x0032, ddb_ctv7),
+	DDB_ID(DDVID, 0x0006, DDVID, 0x0033, ddb_ctv7),
+	DDB_ID(DDVID, 0x0007, DDVID, 0x0023, ddb_s2_48),
+	DDB_ID(DDVID, 0x0011, DDVID, 0x0040, ddb_ci),
+	DDB_ID(DDVID, 0x0011, DDVID, 0x0041, ddb_cis),
+	DDB_ID(DDVID, 0x0201, DDVID, 0x0001, ddb_mod),
+	/* in case sub-ids got deleted in flash */
+	DDB_ID(DDVID, 0x0003, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	DDB_ID(DDVID, 0x0011, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	DDB_ID(DDVID, 0x0201, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	{0}
+};
+MODULE_DEVICE_TABLE(pci, ddb_id_tbl);
+
+static struct pci_driver ddb_pci_driver = {
+	.name        = "ddbridge",
+	.id_table    = ddb_id_tbl,
+	.probe       = ddb_probe,
+	.remove      = ddb_remove,
+};
+
+static __init int module_init_ddbridge(void)
+{
+	int stat = -1;
+
+	pr_info("Digital Devices PCIE bridge driver "
+		DDBRIDGE_VERSION
+		", Copyright (C) 2010-14 Digital Devices GmbH\n");
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
+}
+
+static __exit void module_exit_ddbridge(void)
+{
+	pci_unregister_driver(&ddb_pci_driver);
+	destroy_workqueue(ddb_wq);
+	ddb_class_destroy();
+}
+
+module_init(module_init_ddbridge);
+module_exit(module_exit_ddbridge);
+
+MODULE_DESCRIPTION("Digital Devices PCIe Bridge");
+MODULE_AUTHOR("Ralph Metzler, Metzler Brothers Systementwicklung");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DDBRIDGE_VERSION); 
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
new file mode 100644
index 0000000..1d028cf
--- /dev/null
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -0,0 +1,499 @@
+/*
+ * ddbridge.h: Digital Devices PCIe bridge driver
+ *
+ * Copyright (C) 2010-2014 Digital Devices GmbH
+ *                         Ralph Metzler <rmetzler@digitaldevices.de>
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA
+ * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
+ */
+
+#ifndef _DDBRIDGE_H_
+#define _DDBRIDGE_H_
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3, 8, 0))
+#define __devexit
+#define __devinit
+#define __devinitconst
+#endif
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
+#include <linux/workqueue.h>
+#include <linux/kthread.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/spi/spi.h>
+#include <linux/gpio.h>
+#include <linux/completion.h>
+
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/i2c.h>
+#include <linux/mutex.h>
+#include <asm/dma.h>
+#include <asm/irq.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+
+#include <linux/dvb/ca.h>
+#include <linux/socket.h>
+#include <linux/device.h>
+#include <linux/io.h>
+
+#include "dvb_netstream.h"
+#include "dmxdev.h"
+#include "dvbdev.h"
+#include "dvb_demux.h"
+#include "dvb_frontend.h"
+#include "dvb_ringbuffer.h"
+#include "dvb_ca_en50221.h"
+#include "dvb_net.h"
+
+#include "tda18271c2dd.h"
+#include "stv6110x.h"
+#include "stv090x.h"
+#include "lnbh24.h"
+#include "drxk.h"
+#include "stv0367.h"
+#include "stv0367dd.h"
+#include "tda18212.h"
+#include "tda18212dd.h"
+#include "cxd2843.h"
+#include "cxd2099.h"
+#include "stv0910.h"
+#include "stv6111.h"
+#include "lnbh25.h"
+#include "mxl5xx.h"
+
+#define DDB_MAX_I2C     4
+#define DDB_MAX_PORT   10
+#define DDB_MAX_INPUT   8
+#define DDB_MAX_OUTPUT 10
+
+struct ddb_regset {
+	u32 base;
+	u32 num;
+	u32 size;
+};
+
+struct ddb_regmap {
+	struct ddb_regset *i2c;
+	struct ddb_regset *i2c_buf;
+	struct ddb_regset *dma;
+	struct ddb_regset *dma_buf;
+	struct ddb_regset *input;
+	struct ddb_regset *output;
+	struct ddb_regset *channel;
+	struct ddb_regset *ci;
+	struct ddb_regset *pid_filter;
+	struct ddb_regset *ns;
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
+
+struct ddb_info {
+	int   type;
+#define DDB_NONE         0
+#define DDB_OCTOPUS      1
+#define DDB_OCTOPUS_CI   2
+#define DDB_MOD          3
+#define DDB_OCTONET      4
+#define DDB_OCTOPUS_MAX  5
+	char *name;
+	u8    port_num;
+	u8    i2c_num;
+	u8    led_num;
+	u8    fan_num;
+	u8    temp_num;
+	u8    temp_bus;
+	u8    board_control;
+	u8    ns_num;
+	u8    mdio_num;
+	struct ddb_regmap *regmap;
+};
+
+
+/* DMA_SIZE MUST be smaller than 256k and
+   MUST be divisible by 188 and 128 !!! */
+
+#define DMA_MAX_BUFS 32      /* hardware table limit */
+
+#define INPUT_DMA_BUFS 8
+#define INPUT_DMA_SIZE (128*47*21)
+#define INPUT_DMA_IRQ_DIV 1
+
+#define OUTPUT_DMA_BUFS 8
+#define OUTPUT_DMA_SIZE (128*47*21)
+#define OUTPUT_DMA_IRQ_DIV 1
+
+struct ddb;
+struct ddb_port;
+
+struct ddb_dma {
+	void                  *io;
+	u32                    nr;
+	dma_addr_t             pbuf[DMA_MAX_BUFS];
+	u8                    *vbuf[DMA_MAX_BUFS];
+	u32                    num;
+	u32                    size;
+	u32                    div;
+	u32                    bufreg;
+
+#ifdef DDB_USE_WORK
+	struct work_struct     work;
+#else
+	struct tasklet_struct  tasklet;
+#endif
+	spinlock_t             lock;
+	wait_queue_head_t      wq;
+	int                    running;
+	u32                    stat;
+	u32                    ctrl;
+	u32                    cbuf;
+	u32                    coff;
+};
+
+struct ddb_dvb {
+	struct dvb_adapter    *adap;
+	int                    adap_registered;
+	struct dvb_device     *dev;
+	struct dvb_frontend   *fe;
+	struct dvb_frontend   *fe2;
+	struct dmxdev          dmxdev;
+	struct dvb_demux       demux;
+	struct dvb_net         dvbnet;
+	struct dvb_netstream   dvbns;
+	struct dmx_frontend    hw_frontend;
+	struct dmx_frontend    mem_frontend;
+	int                    users;
+	u32                    attached;
+	u8                     input;
+
+	int (*i2c_gate_ctrl)(struct dvb_frontend *, int);
+	int (*set_voltage)(struct dvb_frontend* fe, fe_sec_voltage_t voltage);
+	int (*set_input)(struct dvb_frontend *fe);
+};
+
+struct ddb_ci {
+	struct dvb_ca_en50221  en;
+	struct ddb_port       *port;
+	u32                    nr;
+	struct mutex           lock;
+};
+
+struct ddb_io {
+	struct ddb_port       *port;
+	u32                    nr;
+	struct ddb_dma        *dma;
+	struct ddb_io         *redo;
+	struct ddb_io         *redi;
+};
+
+#define ddb_output ddb_io
+#define ddb_input ddb_io
+
+struct ddb_i2c {
+	struct ddb            *dev;
+	u32                    nr;
+	struct i2c_adapter     adap;
+	u32                    regs;
+	u32                    rbuf;
+	u32                    wbuf;
+	struct completion      completion;
+};
+
+struct ddb_port {
+	struct ddb            *dev;
+	u32                    nr;
+	struct ddb_i2c        *i2c;
+	struct mutex           i2c_gate_lock;
+	u32                    class;
+#define DDB_PORT_NONE           0
+#define DDB_PORT_CI             1
+#define DDB_PORT_TUNER          2
+#define DDB_PORT_LOOP           3
+#define DDB_PORT_MOD            4
+	char                   *name;
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
+
+#define DDB_TUNER_XO2           16
+#define DDB_TUNER_DVBS_STV0910  16
+#define DDB_TUNER_DVBCT2_SONY   17
+#define DDB_TUNER_ISDBT_SONY    18
+#define DDB_TUNER_DVBC2T2_SONY  19
+#define DDB_TUNER_ATSC_ST       20
+#define DDB_TUNER_DVBC2T2_ST    21
+
+	/*u32                    adr;*/
+	struct ddb_input      *input[2];
+	struct ddb_output     *output;
+	struct dvb_ca_en50221 *en;
+	struct ddb_dvb         dvb[2];
+	u32                    gap;
+	u32                    obr;
+};
+
+
+struct mod_base {
+	u32                    frequency;
+
+	u32                    flat_start;
+	u32                    flat_end;
+};
+
+struct mod_state {
+	u32                    modulation;
+	u64                    obitrate;
+	u64                    ibitrate;
+	u32                    pcr_correction;
+
+	u32                    rate_inc;
+	u32                    Control;
+	u32                    State;
+	u32                    StateCounter;
+	s32                    LastPCRAdjust;
+	s32                    PCRAdjustSum;
+	s32                    InPacketsSum;
+	s32                    OutPacketsSum;
+	s64                    PCRIncrement;
+	s64                    PCRDecrement;
+	s32                    PCRRunningCorr;
+	u32                    OutOverflowPacketCount;
+	u32                    InOverflowPacketCount;
+	u32                    LastOutPacketCount;
+	u32                    LastInPacketCount;
+	u64                    LastOutPackets;
+	u64                    LastInPackets;
+	u32                    MinInputPackets;
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
+/* net streaming hardware block */
+
+#define DDB_NS_MAX 15
+
+struct ddb_ns {
+	struct ddb_input      *input;
+	int                    nr;
+	int                    fe;
+	u32                    rtcp_udplen;
+	u32                    rtcp_len;
+	u32                    ts_offset;
+	u32                    udplen;
+	u8                     p[512];
+};
+
+struct ddb {
+	struct pci_dev        *pdev;
+	struct platform_device *pfdev;
+	struct device         *dev;
+	struct ddb_ids         ids;
+	struct ddb_info       *info;
+	int                    msi;
+	struct workqueue_struct *wq;
+	u32                    has_dma;
+	u32                    has_ns;
+
+	struct ddb_regmap      regmap;
+	unsigned char         *regs;
+	u32                    regs_len;
+	struct ddb_port        port[DDB_MAX_PORT];
+	struct ddb_i2c         i2c[DDB_MAX_I2C];
+	struct ddb_input       input[DDB_MAX_INPUT];
+	struct ddb_output      output[DDB_MAX_OUTPUT];
+	struct dvb_adapter     adap[DDB_MAX_INPUT];
+	struct ddb_dma         dma[DDB_MAX_INPUT + DDB_MAX_OUTPUT];
+
+	void                   (*handler[32])(unsigned long);
+	unsigned long          handler_data[32];
+
+	struct device         *ddb_dev;
+	u32                    ddb_dev_users;
+	u32                    nr;
+	u8                     iobuf[1028];
+
+	u8                     leds;
+	u32                    ts_irq;
+	u32                    i2c_irq;
+
+	int                    ns_num;
+	struct ddb_ns          ns[DDB_NS_MAX];
+	struct mutex           mutex;
+
+	struct dvb_device     *nsd_dev;
+	u8                     tsbuf[TS_CAPTURE_LEN];
+
+	struct mod_base        mod_base;
+	struct mod_state       mod[10];
+
+	struct mutex           octonet_i2c_lock;
+	struct mutex           lnb_lock;
+	u32                    lnb_tone;
+};
+
+
+/****************************************************************************/
+
+static inline void ddbwriteb(struct ddb *dev, u32 val, u32 adr)
+{
+	writeb(val, (char *) (dev->regs+(adr)));
+}
+
+static inline void ddbwritel(struct ddb *dev, u32 val, u32 adr)
+{
+	writel(val, (char *) (dev->regs+(adr)));
+}
+
+static inline void ddbwritew(struct ddb *dev, u16 val, u32 adr)
+{
+	writew(val, (char *) (dev->regs+(adr)));
+}
+
+static inline u32 ddbreadl(struct ddb *dev, u32 adr)
+{
+	return readl((char *) (dev->regs+(adr)));
+}
+
+static inline u32 ddbreadb(struct ddb *dev, u32 adr)
+{
+	return readb((char *) (dev->regs+(adr)));
+}
+
+#define ddbcpyto(_dev, _adr, _src, _count) \
+	memcpy_toio((char *) (_dev->regs + (_adr)), (_src), (_count))
+
+#define ddbcpyfrom(_dev, _dst, _adr, _count) \
+	memcpy_fromio((_dst), (char *) (_dev->regs + (_adr)), (_count))
+
+#define ddbmemset(_dev, _adr, _val, _count) \
+	memset_io((char *) (_dev->regs + (_adr)), (_val), (_count))
+
+
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+
+#define dd_uint8    u8
+#define dd_uint16   u16
+#define dd_int16    s16
+#define dd_uint32   u32
+#define dd_int32    s32
+#define dd_uint64   u64
+#define dd_int64    s64
+
+#define DDMOD_FLASH_START  0x1000
+
+struct DDMOD_FLASH_DS {
+	dd_uint32   Symbolrate;             /* kSymbols/s */
+	dd_uint32   DACFrequency;           /* kHz        */
+	dd_uint16   FrequencyResolution;    /* kHz        */
+	dd_uint16   IQTableLength;
+	dd_uint16   FrequencyFactor;
+	dd_int16    PhaseCorr;              /* TBD        */
+	dd_uint32   Control2;
+	dd_uint16   PostScaleI;
+	dd_uint16   PostScaleQ;
+	dd_uint16   PreScale;
+	dd_int16    EQTap[11];
+	dd_uint16   FlatStart;
+	dd_uint16   FlatEnd;
+	dd_uint32   FlashOffsetPrecalculatedIQTables;       /* 0 = none */
+	dd_uint8    Reserved[28];
+
+};
+
+struct DDMOD_FLASH {
+	dd_uint32   Magic;
+	dd_uint16   Version;
+	dd_uint16   DataSets;
+
+	dd_uint16   VCORefFrequency;    /* MHz */
+	dd_uint16   VCO1Frequency;      /* MHz */
+	dd_uint16   VCO2Frequency;      /* MHz */
+
+	dd_uint16   DACAux1;    /* TBD */
+	dd_uint16   DACAux2;    /* TBD */
+
+	dd_uint8    Reserved1[238];
+
+	struct DDMOD_FLASH_DS DataSet[1];
+};
+
+#define DDMOD_FLASH_MAGIC   0x5F564d5F
+
+
+int ddbridge_mod_do_ioctl(struct file *file, unsigned int cmd, void *parg);
+int ddbridge_mod_init(struct ddb *dev);
+void ddbridge_mod_output_stop(struct ddb_output *output);
+void ddbridge_mod_output_start(struct ddb_output *output);
+void ddbridge_mod_rate_handler(unsigned long data);
+
+
+int ddbridge_flashread(struct ddb *dev, u8 *buf, u32 addr, u32 len);
+
+#define DDBRIDGE_VERSION "0.9.15"
+
+#endif
-- 
http://palosaari.fi/

