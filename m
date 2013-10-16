Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:47030 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415Ab3JPFhx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Oct 2013 01:37:53 -0400
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>
CC: <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>,
	<linux-omap@vger.kernel.org>, Archit Taneja <archit@ti.com>
Subject: [PATCH v5 1/4] v4l: ti-vpe: Create a vpdma helper library
Date: Wed, 16 Oct 2013 11:06:45 +0530
Message-ID: <1381901808-25119-2-git-send-email-archit@ti.com>
In-Reply-To: <1381901808-25119-1-git-send-email-archit@ti.com>
References: <1378462346-10880-1-git-send-email-archit@ti.com>
 <1381901808-25119-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The primary function of VPDMA is to move data between external memory and
internal processing modules(in our case, VPE) that source or sink data. VPDMA is
capable of buffering this data and then delivering the data as demanded to the
modules as programmed. The modules that source or sink data are referred to as
clients or ports. A channel is setup inside the VPDMA to connect a specific
memory buffer to a specific client. The VPDMA centralizes the DMA control
functions and buffering required to allow all the clients to minimize the
effect of long latency times.

Add the following to the VPDMA helper:

- A data struct which describe VPDMA channels. For now, these channels are the
  ones used only by VPE, the list of channels will increase when VIP(Video
  Input Port) also uses the VPDMA library. This channel information will be
  used to populate fields required by data descriptors.

- Data structs which describe the different data types supported by VPDMA. This
  data type information will be used to populate fields required by data
  descriptors and used by the VPE driver to map a V4L2 format to the
  corresponding VPDMA data type.

- Provide VPDMA register offset definitions, functions to read, write and modify
  VPDMA registers.

- Functions to create and submit a VPDMA list. A list is a group of descriptors
  that makes up a set of DMA transfers that need to be completed. Each
  descriptor will either perform a DMA transaction to fetch input buffers and
  write to output buffers(data descriptors), or configure the MMRs of sub blocks
  of VPE(configuration descriptors), or provide control information to VPDMA
  (control descriptors).

- Functions to allocate, map and unmap buffers needed for the descriptor list,
  payloads containing MMR values and scaler coefficients. These use the DMA
  mapping APIs to ensure exclusive access to VPDMA.

- Functions to enable VPDMA interrupts. VPDMA can trigger an interrupt on the
  VPE interrupt line when a descriptor list is parsed completely and the DMA
  transactions are completed. This requires masking the events in VPDMA
  registers and configuring some top level VPE interrupt registers.

- Enable some VPDMA specific parameters: frame start event(when to start DMA for
  a client) and line mode(whether each line fetched should be mirrored or not).

- Function to load firmware required by VPDMA. VPDMA requires a firmware for
  it's internal list manager. We add the required request_firmware apis to fetch
  this firmware from user space.

- Function to dump VPDMA registers.

- A function to initialize and create a VPDMA instance, this will be called by
  the VPE driver with it's platform device pointer, this function will take care
  of loading VPDMA firmware and returning a vpdma_data instance back to the VPE
  driver. The VIP driver will also call the same init function to initialize it's
  own VPDMA instance.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/vpdma.c      | 578 +++++++++++++++++++++++++++++
 drivers/media/platform/ti-vpe/vpdma.h      | 155 ++++++++
 drivers/media/platform/ti-vpe/vpdma_priv.h | 119 ++++++
 3 files changed, 852 insertions(+)
 create mode 100644 drivers/media/platform/ti-vpe/vpdma.c
 create mode 100644 drivers/media/platform/ti-vpe/vpdma.h
 create mode 100644 drivers/media/platform/ti-vpe/vpdma_priv.h

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
new file mode 100644
index 0000000..42db12c
--- /dev/null
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -0,0 +1,578 @@
+/*
+ * VPDMA helper library
+ *
+ * Copyright (c) 2013 Texas Instruments Inc.
+ *
+ * David Griego, <dagriego@biglakesoftware.com>
+ * Dale Farnsworth, <dale@farnsworth.org>
+ * Archit Taneja, <archit@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/firmware.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+
+#include "vpdma.h"
+#include "vpdma_priv.h"
+
+#define VPDMA_FIRMWARE	"vpdma-1b8.bin"
+
+const struct vpdma_data_format vpdma_yuv_fmts[] = {
+	[VPDMA_DATA_FMT_Y444] = {
+		.data_type	= DATA_TYPE_Y444,
+		.depth		= 8,
+	},
+	[VPDMA_DATA_FMT_Y422] = {
+		.data_type	= DATA_TYPE_Y422,
+		.depth		= 8,
+	},
+	[VPDMA_DATA_FMT_Y420] = {
+		.data_type	= DATA_TYPE_Y420,
+		.depth		= 8,
+	},
+	[VPDMA_DATA_FMT_C444] = {
+		.data_type	= DATA_TYPE_C444,
+		.depth		= 8,
+	},
+	[VPDMA_DATA_FMT_C422] = {
+		.data_type	= DATA_TYPE_C422,
+		.depth		= 8,
+	},
+	[VPDMA_DATA_FMT_C420] = {
+		.data_type	= DATA_TYPE_C420,
+		.depth		= 4,
+	},
+	[VPDMA_DATA_FMT_YC422] = {
+		.data_type	= DATA_TYPE_YC422,
+		.depth		= 16,
+	},
+	[VPDMA_DATA_FMT_YC444] = {
+		.data_type	= DATA_TYPE_YC444,
+		.depth		= 24,
+	},
+	[VPDMA_DATA_FMT_CY422] = {
+		.data_type	= DATA_TYPE_CY422,
+		.depth		= 16,
+	},
+};
+
+const struct vpdma_data_format vpdma_rgb_fmts[] = {
+	[VPDMA_DATA_FMT_RGB565] = {
+		.data_type	= DATA_TYPE_RGB16_565,
+		.depth		= 16,
+	},
+	[VPDMA_DATA_FMT_ARGB16_1555] = {
+		.data_type	= DATA_TYPE_ARGB_1555,
+		.depth		= 16,
+	},
+	[VPDMA_DATA_FMT_ARGB16] = {
+		.data_type	= DATA_TYPE_ARGB_4444,
+		.depth		= 16,
+	},
+	[VPDMA_DATA_FMT_RGBA16_5551] = {
+		.data_type	= DATA_TYPE_RGBA_5551,
+		.depth		= 16,
+	},
+	[VPDMA_DATA_FMT_RGBA16] = {
+		.data_type	= DATA_TYPE_RGBA_4444,
+		.depth		= 16,
+	},
+	[VPDMA_DATA_FMT_ARGB24] = {
+		.data_type	= DATA_TYPE_ARGB24_6666,
+		.depth		= 24,
+	},
+	[VPDMA_DATA_FMT_RGB24] = {
+		.data_type	= DATA_TYPE_RGB24_888,
+		.depth		= 24,
+	},
+	[VPDMA_DATA_FMT_ARGB32] = {
+		.data_type	= DATA_TYPE_ARGB32_8888,
+		.depth		= 32,
+	},
+	[VPDMA_DATA_FMT_RGBA24] = {
+		.data_type	= DATA_TYPE_RGBA24_6666,
+		.depth		= 24,
+	},
+	[VPDMA_DATA_FMT_RGBA32] = {
+		.data_type	= DATA_TYPE_RGBA32_8888,
+		.depth		= 32,
+	},
+	[VPDMA_DATA_FMT_BGR565] = {
+		.data_type	= DATA_TYPE_BGR16_565,
+		.depth		= 16,
+	},
+	[VPDMA_DATA_FMT_ABGR16_1555] = {
+		.data_type	= DATA_TYPE_ABGR_1555,
+		.depth		= 16,
+	},
+	[VPDMA_DATA_FMT_ABGR16] = {
+		.data_type	= DATA_TYPE_ABGR_4444,
+		.depth		= 16,
+	},
+	[VPDMA_DATA_FMT_BGRA16_5551] = {
+		.data_type	= DATA_TYPE_BGRA_5551,
+		.depth		= 16,
+	},
+	[VPDMA_DATA_FMT_BGRA16] = {
+		.data_type	= DATA_TYPE_BGRA_4444,
+		.depth		= 16,
+	},
+	[VPDMA_DATA_FMT_ABGR24] = {
+		.data_type	= DATA_TYPE_ABGR24_6666,
+		.depth		= 24,
+	},
+	[VPDMA_DATA_FMT_BGR24] = {
+		.data_type	= DATA_TYPE_BGR24_888,
+		.depth		= 24,
+	},
+	[VPDMA_DATA_FMT_ABGR32] = {
+		.data_type	= DATA_TYPE_ABGR32_8888,
+		.depth		= 32,
+	},
+	[VPDMA_DATA_FMT_BGRA24] = {
+		.data_type	= DATA_TYPE_BGRA24_6666,
+		.depth		= 24,
+	},
+	[VPDMA_DATA_FMT_BGRA32] = {
+		.data_type	= DATA_TYPE_BGRA32_8888,
+		.depth		= 32,
+	},
+};
+
+const struct vpdma_data_format vpdma_misc_fmts[] = {
+	[VPDMA_DATA_FMT_MV] = {
+		.data_type	= DATA_TYPE_MV,
+		.depth		= 4,
+	},
+};
+
+struct vpdma_channel_info {
+	int num;		/* VPDMA channel number */
+	int cstat_offset;	/* client CSTAT register offset */
+};
+
+static const struct vpdma_channel_info chan_info[] = {
+	[VPE_CHAN_LUMA1_IN] = {
+		.num		= VPE_CHAN_NUM_LUMA1_IN,
+		.cstat_offset	= VPDMA_DEI_LUMA1_CSTAT,
+	},
+	[VPE_CHAN_CHROMA1_IN] = {
+		.num		= VPE_CHAN_NUM_CHROMA1_IN,
+		.cstat_offset	= VPDMA_DEI_CHROMA1_CSTAT,
+	},
+	[VPE_CHAN_LUMA2_IN] = {
+		.num		= VPE_CHAN_NUM_LUMA2_IN,
+		.cstat_offset	= VPDMA_DEI_LUMA2_CSTAT,
+	},
+	[VPE_CHAN_CHROMA2_IN] = {
+		.num		= VPE_CHAN_NUM_CHROMA2_IN,
+		.cstat_offset	= VPDMA_DEI_CHROMA2_CSTAT,
+	},
+	[VPE_CHAN_LUMA3_IN] = {
+		.num		= VPE_CHAN_NUM_LUMA3_IN,
+		.cstat_offset	= VPDMA_DEI_LUMA3_CSTAT,
+	},
+	[VPE_CHAN_CHROMA3_IN] = {
+		.num		= VPE_CHAN_NUM_CHROMA3_IN,
+		.cstat_offset	= VPDMA_DEI_CHROMA3_CSTAT,
+	},
+	[VPE_CHAN_MV_IN] = {
+		.num		= VPE_CHAN_NUM_MV_IN,
+		.cstat_offset	= VPDMA_DEI_MV_IN_CSTAT,
+	},
+	[VPE_CHAN_MV_OUT] = {
+		.num		= VPE_CHAN_NUM_MV_OUT,
+		.cstat_offset	= VPDMA_DEI_MV_OUT_CSTAT,
+	},
+	[VPE_CHAN_LUMA_OUT] = {
+		.num		= VPE_CHAN_NUM_LUMA_OUT,
+		.cstat_offset	= VPDMA_VIP_UP_Y_CSTAT,
+	},
+	[VPE_CHAN_CHROMA_OUT] = {
+		.num		= VPE_CHAN_NUM_CHROMA_OUT,
+		.cstat_offset	= VPDMA_VIP_UP_UV_CSTAT,
+	},
+	[VPE_CHAN_RGB_OUT] = {
+		.num		= VPE_CHAN_NUM_RGB_OUT,
+		.cstat_offset	= VPDMA_VIP_UP_Y_CSTAT,
+	},
+};
+
+static u32 read_reg(struct vpdma_data *vpdma, int offset)
+{
+	return ioread32(vpdma->base + offset);
+}
+
+static void write_reg(struct vpdma_data *vpdma, int offset, u32 value)
+{
+	iowrite32(value, vpdma->base + offset);
+}
+
+static int read_field_reg(struct vpdma_data *vpdma, int offset,
+		u32 mask, int shift)
+{
+	return (read_reg(vpdma, offset) & (mask << shift)) >> shift;
+}
+
+static void write_field_reg(struct vpdma_data *vpdma, int offset, u32 field,
+		u32 mask, int shift)
+{
+	u32 val = read_reg(vpdma, offset);
+
+	val &= ~(mask << shift);
+	val |= (field & mask) << shift;
+
+	write_reg(vpdma, offset, val);
+}
+
+void vpdma_dump_regs(struct vpdma_data *vpdma)
+{
+	struct device *dev = &vpdma->pdev->dev;
+
+#define DUMPREG(r) dev_dbg(dev, "%-35s %08x\n", #r, read_reg(vpdma, VPDMA_##r))
+
+	dev_dbg(dev, "VPDMA Registers:\n");
+
+	DUMPREG(PID);
+	DUMPREG(LIST_ADDR);
+	DUMPREG(LIST_ATTR);
+	DUMPREG(LIST_STAT_SYNC);
+	DUMPREG(BG_RGB);
+	DUMPREG(BG_YUV);
+	DUMPREG(SETUP);
+	DUMPREG(MAX_SIZE1);
+	DUMPREG(MAX_SIZE2);
+	DUMPREG(MAX_SIZE3);
+
+	/*
+	 * dumping registers of only group0 and group3, because VPE channels
+	 * lie within group0 and group3 registers
+	 */
+	DUMPREG(INT_CHAN_STAT(0));
+	DUMPREG(INT_CHAN_MASK(0));
+	DUMPREG(INT_CHAN_STAT(3));
+	DUMPREG(INT_CHAN_MASK(3));
+	DUMPREG(INT_CLIENT0_STAT);
+	DUMPREG(INT_CLIENT0_MASK);
+	DUMPREG(INT_CLIENT1_STAT);
+	DUMPREG(INT_CLIENT1_MASK);
+	DUMPREG(INT_LIST0_STAT);
+	DUMPREG(INT_LIST0_MASK);
+
+	/*
+	 * these are registers specific to VPE clients, we can make this
+	 * function dump client registers specific to VPE or VIP based on
+	 * who is using it
+	 */
+	DUMPREG(DEI_CHROMA1_CSTAT);
+	DUMPREG(DEI_LUMA1_CSTAT);
+	DUMPREG(DEI_CHROMA2_CSTAT);
+	DUMPREG(DEI_LUMA2_CSTAT);
+	DUMPREG(DEI_CHROMA3_CSTAT);
+	DUMPREG(DEI_LUMA3_CSTAT);
+	DUMPREG(DEI_MV_IN_CSTAT);
+	DUMPREG(DEI_MV_OUT_CSTAT);
+	DUMPREG(VIP_UP_Y_CSTAT);
+	DUMPREG(VIP_UP_UV_CSTAT);
+	DUMPREG(VPI_CTL_CSTAT);
+}
+
+/*
+ * Allocate a DMA buffer
+ */
+int vpdma_alloc_desc_buf(struct vpdma_buf *buf, size_t size)
+{
+	buf->size = size;
+	buf->mapped = false;
+	buf->addr = kzalloc(size, GFP_KERNEL);
+	if (!buf->addr)
+		return -ENOMEM;
+
+	WARN_ON((u32) buf->addr & VPDMA_DESC_ALIGN);
+
+	return 0;
+}
+
+void vpdma_free_desc_buf(struct vpdma_buf *buf)
+{
+	WARN_ON(buf->mapped);
+	kfree(buf->addr);
+	buf->addr = NULL;
+	buf->size = 0;
+}
+
+/*
+ * map descriptor/payload DMA buffer, enabling DMA access
+ */
+int vpdma_map_desc_buf(struct vpdma_data *vpdma, struct vpdma_buf *buf)
+{
+	struct device *dev = &vpdma->pdev->dev;
+
+	WARN_ON(buf->mapped);
+	buf->dma_addr = dma_map_single(dev, buf->addr, buf->size,
+				DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, buf->dma_addr)) {
+		dev_err(dev, "failed to map buffer\n");
+		return -EINVAL;
+	}
+
+	buf->mapped = true;
+
+	return 0;
+}
+
+/*
+ * unmap descriptor/payload DMA buffer, disabling DMA access and
+ * allowing the main processor to acces the data
+ */
+void vpdma_unmap_desc_buf(struct vpdma_data *vpdma, struct vpdma_buf *buf)
+{
+	struct device *dev = &vpdma->pdev->dev;
+
+	if (buf->mapped)
+		dma_unmap_single(dev, buf->dma_addr, buf->size, DMA_TO_DEVICE);
+
+	buf->mapped = false;
+}
+
+/*
+ * create a descriptor list, the user of this list will append configuration,
+ * control and data descriptors to this list, this list will be submitted to
+ * VPDMA. VPDMA's list parser will go through each descriptor and perform the
+ * required DMA operations
+ */
+int vpdma_create_desc_list(struct vpdma_desc_list *list, size_t size, int type)
+{
+	int r;
+
+	r = vpdma_alloc_desc_buf(&list->buf, size);
+	if (r)
+		return r;
+
+	list->next = list->buf.addr;
+
+	list->type = type;
+
+	return 0;
+}
+
+/*
+ * once a descriptor list is parsed by VPDMA, we reset the list by emptying it,
+ * to allow new descriptors to be added to the list.
+ */
+void vpdma_reset_desc_list(struct vpdma_desc_list *list)
+{
+	list->next = list->buf.addr;
+}
+
+/*
+ * free the buffer allocated fot the VPDMA descriptor list, this should be
+ * called when the user doesn't want to use VPDMA any more.
+ */
+void vpdma_free_desc_list(struct vpdma_desc_list *list)
+{
+	vpdma_free_desc_buf(&list->buf);
+
+	list->next = NULL;
+}
+
+static bool vpdma_list_busy(struct vpdma_data *vpdma, int list_num)
+{
+	return read_reg(vpdma, VPDMA_LIST_STAT_SYNC) & BIT(list_num + 16);
+}
+
+/*
+ * submit a list of DMA descriptors to the VPE VPDMA, do not wait for completion
+ */
+int vpdma_submit_descs(struct vpdma_data *vpdma, struct vpdma_desc_list *list)
+{
+	/* we always use the first list */
+	int list_num = 0;
+	int list_size;
+
+	if (vpdma_list_busy(vpdma, list_num))
+		return -EBUSY;
+
+	/* 16-byte granularity */
+	list_size = (list->next - list->buf.addr) >> 4;
+
+	write_reg(vpdma, VPDMA_LIST_ADDR, (u32) list->buf.dma_addr);
+
+	write_reg(vpdma, VPDMA_LIST_ATTR,
+			(list_num << VPDMA_LIST_NUM_SHFT) |
+			(list->type << VPDMA_LIST_TYPE_SHFT) |
+			list_size);
+
+	return 0;
+}
+
+/* set or clear the mask for list complete interrupt */
+void vpdma_enable_list_complete_irq(struct vpdma_data *vpdma, int list_num,
+		bool enable)
+{
+	u32 val;
+
+	val = read_reg(vpdma, VPDMA_INT_LIST0_MASK);
+	if (enable)
+		val |= (1 << (list_num * 2));
+	else
+		val &= ~(1 << (list_num * 2));
+	write_reg(vpdma, VPDMA_INT_LIST0_MASK, val);
+}
+
+/* clear previosuly occured list intterupts in the LIST_STAT register */
+void vpdma_clear_list_stat(struct vpdma_data *vpdma)
+{
+	write_reg(vpdma, VPDMA_INT_LIST0_STAT,
+		read_reg(vpdma, VPDMA_INT_LIST0_STAT));
+}
+
+/*
+ * configures the output mode of the line buffer for the given client, the
+ * line buffer content can either be mirrored(each line repeated twice) or
+ * passed to the client as is
+ */
+void vpdma_set_line_mode(struct vpdma_data *vpdma, int line_mode,
+		enum vpdma_channel chan)
+{
+	int client_cstat = chan_info[chan].cstat_offset;
+
+	write_field_reg(vpdma, client_cstat, line_mode,
+		VPDMA_CSTAT_LINE_MODE_MASK, VPDMA_CSTAT_LINE_MODE_SHIFT);
+}
+
+/*
+ * configures the event which should trigger VPDMA transfer for the given
+ * client
+ */
+void vpdma_set_frame_start_event(struct vpdma_data *vpdma,
+		enum vpdma_frame_start_event fs_event,
+		enum vpdma_channel chan)
+{
+	int client_cstat = chan_info[chan].cstat_offset;
+
+	write_field_reg(vpdma, client_cstat, fs_event,
+		VPDMA_CSTAT_FRAME_START_MASK, VPDMA_CSTAT_FRAME_START_SHIFT);
+}
+
+static void vpdma_firmware_cb(const struct firmware *f, void *context)
+{
+	struct vpdma_data *vpdma = context;
+	struct vpdma_buf fw_dma_buf;
+	int i, r;
+
+	dev_dbg(&vpdma->pdev->dev, "firmware callback\n");
+
+	if (!f || !f->data) {
+		dev_err(&vpdma->pdev->dev, "couldn't get firmware\n");
+		return;
+	}
+
+	/* already initialized */
+	if (read_field_reg(vpdma, VPDMA_LIST_ATTR, VPDMA_LIST_RDY_MASK,
+			VPDMA_LIST_RDY_SHFT)) {
+		vpdma->ready = true;
+		return;
+	}
+
+	r = vpdma_alloc_desc_buf(&fw_dma_buf, f->size);
+	if (r) {
+		dev_err(&vpdma->pdev->dev,
+			"failed to allocate dma buffer for firmware\n");
+		goto rel_fw;
+	}
+
+	memcpy(fw_dma_buf.addr, f->data, f->size);
+
+	vpdma_map_desc_buf(vpdma, &fw_dma_buf);
+
+	write_reg(vpdma, VPDMA_LIST_ADDR, (u32) fw_dma_buf.dma_addr);
+
+	for (i = 0; i < 100; i++) {		/* max 1 second */
+		msleep_interruptible(10);
+
+		if (read_field_reg(vpdma, VPDMA_LIST_ATTR, VPDMA_LIST_RDY_MASK,
+				VPDMA_LIST_RDY_SHFT))
+			break;
+	}
+
+	if (i == 100) {
+		dev_err(&vpdma->pdev->dev, "firmware upload failed\n");
+		goto free_buf;
+	}
+
+	vpdma->ready = true;
+
+free_buf:
+	vpdma_unmap_desc_buf(vpdma, &fw_dma_buf);
+
+	vpdma_free_desc_buf(&fw_dma_buf);
+rel_fw:
+	release_firmware(f);
+}
+
+static int vpdma_load_firmware(struct vpdma_data *vpdma)
+{
+	int r;
+	struct device *dev = &vpdma->pdev->dev;
+
+	r = request_firmware_nowait(THIS_MODULE, 1,
+		(const char *) VPDMA_FIRMWARE, dev, GFP_KERNEL, vpdma,
+		vpdma_firmware_cb);
+	if (r) {
+		dev_err(dev, "firmware not available %s\n", VPDMA_FIRMWARE);
+		return r;
+	} else {
+		dev_info(dev, "loading firmware %s\n", VPDMA_FIRMWARE);
+	}
+
+	return 0;
+}
+
+struct vpdma_data *vpdma_create(struct platform_device *pdev)
+{
+	struct resource *res;
+	struct vpdma_data *vpdma;
+	int r;
+
+	dev_dbg(&pdev->dev, "vpdma_create\n");
+
+	vpdma = devm_kzalloc(&pdev->dev, sizeof(*vpdma), GFP_KERNEL);
+	if (!vpdma) {
+		dev_err(&pdev->dev, "couldn't alloc vpdma_dev\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	vpdma->pdev = pdev;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vpdma");
+	if (res == NULL) {
+		dev_err(&pdev->dev, "missing platform resources data\n");
+		return ERR_PTR(-ENODEV);
+	}
+
+	vpdma->base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (!vpdma->base) {
+		dev_err(&pdev->dev, "failed to ioremap\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	r = vpdma_load_firmware(vpdma);
+	if (r) {
+		pr_err("failed to load firmware %s\n", VPDMA_FIRMWARE);
+		return ERR_PTR(r);
+	}
+
+	return vpdma;
+}
+MODULE_FIRMWARE(VPDMA_FIRMWARE);
diff --git a/drivers/media/platform/ti-vpe/vpdma.h b/drivers/media/platform/ti-vpe/vpdma.h
new file mode 100644
index 0000000..8056689
--- /dev/null
+++ b/drivers/media/platform/ti-vpe/vpdma.h
@@ -0,0 +1,155 @@
+/*
+ * Copyright (c) 2013 Texas Instruments Inc.
+ *
+ * David Griego, <dagriego@biglakesoftware.com>
+ * Dale Farnsworth, <dale@farnsworth.org>
+ * Archit Taneja, <archit@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#ifndef __TI_VPDMA_H_
+#define __TI_VPDMA_H_
+
+/*
+ * A vpdma_buf tracks the size, DMA address and mapping status of each
+ * driver DMA area.
+ */
+struct vpdma_buf {
+	void			*addr;
+	dma_addr_t		dma_addr;
+	size_t			size;
+	bool			mapped;
+};
+
+struct vpdma_desc_list {
+	struct vpdma_buf buf;
+	void *next;
+	int type;
+};
+
+struct vpdma_data {
+	void __iomem		*base;
+
+	struct platform_device	*pdev;
+
+	/* tells whether vpdma firmware is loaded or not */
+	bool ready;
+};
+
+struct vpdma_data_format {
+	int data_type;
+	u8 depth;
+};
+
+#define VPDMA_DESC_ALIGN		16	/* 16-byte descriptor alignment */
+
+#define VPDMA_DTD_DESC_SIZE		32	/* 8 words */
+#define VPDMA_CFD_CTD_DESC_SIZE		16	/* 4 words */
+
+#define VPDMA_LIST_TYPE_NORMAL		0
+#define VPDMA_LIST_TYPE_SELF_MODIFYING	1
+#define VPDMA_LIST_TYPE_DOORBELL	2
+
+enum vpdma_yuv_formats {
+	VPDMA_DATA_FMT_Y444 = 0,
+	VPDMA_DATA_FMT_Y422,
+	VPDMA_DATA_FMT_Y420,
+	VPDMA_DATA_FMT_C444,
+	VPDMA_DATA_FMT_C422,
+	VPDMA_DATA_FMT_C420,
+	VPDMA_DATA_FMT_YC422,
+	VPDMA_DATA_FMT_YC444,
+	VPDMA_DATA_FMT_CY422,
+};
+
+enum vpdma_rgb_formats {
+	VPDMA_DATA_FMT_RGB565 = 0,
+	VPDMA_DATA_FMT_ARGB16_1555,
+	VPDMA_DATA_FMT_ARGB16,
+	VPDMA_DATA_FMT_RGBA16_5551,
+	VPDMA_DATA_FMT_RGBA16,
+	VPDMA_DATA_FMT_ARGB24,
+	VPDMA_DATA_FMT_RGB24,
+	VPDMA_DATA_FMT_ARGB32,
+	VPDMA_DATA_FMT_RGBA24,
+	VPDMA_DATA_FMT_RGBA32,
+	VPDMA_DATA_FMT_BGR565,
+	VPDMA_DATA_FMT_ABGR16_1555,
+	VPDMA_DATA_FMT_ABGR16,
+	VPDMA_DATA_FMT_BGRA16_5551,
+	VPDMA_DATA_FMT_BGRA16,
+	VPDMA_DATA_FMT_ABGR24,
+	VPDMA_DATA_FMT_BGR24,
+	VPDMA_DATA_FMT_ABGR32,
+	VPDMA_DATA_FMT_BGRA24,
+	VPDMA_DATA_FMT_BGRA32,
+};
+
+enum vpdma_misc_formats {
+	VPDMA_DATA_FMT_MV = 0,
+};
+
+extern const struct vpdma_data_format vpdma_yuv_fmts[];
+extern const struct vpdma_data_format vpdma_rgb_fmts[];
+extern const struct vpdma_data_format vpdma_misc_fmts[];
+
+enum vpdma_frame_start_event {
+	VPDMA_FSEVENT_HDMI_FID = 0,
+	VPDMA_FSEVENT_DVO2_FID,
+	VPDMA_FSEVENT_HDCOMP_FID,
+	VPDMA_FSEVENT_SD_FID,
+	VPDMA_FSEVENT_LM_FID0,
+	VPDMA_FSEVENT_LM_FID1,
+	VPDMA_FSEVENT_LM_FID2,
+	VPDMA_FSEVENT_CHANNEL_ACTIVE,
+};
+
+/*
+ * VPDMA channel numbers
+ */
+enum vpdma_channel {
+	VPE_CHAN_LUMA1_IN,
+	VPE_CHAN_CHROMA1_IN,
+	VPE_CHAN_LUMA2_IN,
+	VPE_CHAN_CHROMA2_IN,
+	VPE_CHAN_LUMA3_IN,
+	VPE_CHAN_CHROMA3_IN,
+	VPE_CHAN_MV_IN,
+	VPE_CHAN_MV_OUT,
+	VPE_CHAN_LUMA_OUT,
+	VPE_CHAN_CHROMA_OUT,
+	VPE_CHAN_RGB_OUT,
+};
+
+/* vpdma descriptor buffer allocation and management */
+int vpdma_alloc_desc_buf(struct vpdma_buf *buf, size_t size);
+void vpdma_free_desc_buf(struct vpdma_buf *buf);
+int vpdma_map_desc_buf(struct vpdma_data *vpdma, struct vpdma_buf *buf);
+void vpdma_unmap_desc_buf(struct vpdma_data *vpdma, struct vpdma_buf *buf);
+
+/* vpdma descriptor list funcs */
+int vpdma_create_desc_list(struct vpdma_desc_list *list, size_t size, int type);
+void vpdma_reset_desc_list(struct vpdma_desc_list *list);
+void vpdma_free_desc_list(struct vpdma_desc_list *list);
+int vpdma_submit_descs(struct vpdma_data *vpdma, struct vpdma_desc_list *list);
+
+/* vpdma list interrupt management */
+void vpdma_enable_list_complete_irq(struct vpdma_data *vpdma, int list_num,
+		bool enable);
+void vpdma_clear_list_stat(struct vpdma_data *vpdma);
+
+/* vpdma client configuration */
+void vpdma_set_line_mode(struct vpdma_data *vpdma, int line_mode,
+		enum vpdma_channel chan);
+void vpdma_set_frame_start_event(struct vpdma_data *vpdma,
+		enum vpdma_frame_start_event fs_event, enum vpdma_channel chan);
+
+void vpdma_dump_regs(struct vpdma_data *vpdma);
+
+/* initialize vpdma, passed with VPE's platform device pointer */
+struct vpdma_data *vpdma_create(struct platform_device *pdev);
+
+#endif
diff --git a/drivers/media/platform/ti-vpe/vpdma_priv.h b/drivers/media/platform/ti-vpe/vpdma_priv.h
new file mode 100644
index 0000000..8ff51a3
--- /dev/null
+++ b/drivers/media/platform/ti-vpe/vpdma_priv.h
@@ -0,0 +1,119 @@
+/*
+ * Copyright (c) 2013 Texas Instruments Inc.
+ *
+ * David Griego, <dagriego@biglakesoftware.com>
+ * Dale Farnsworth, <dale@farnsworth.org>
+ * Archit Taneja, <archit@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#ifndef _TI_VPDMA_PRIV_H_
+#define _TI_VPDMA_PRIV_H_
+
+/*
+ * VPDMA Register offsets
+ */
+
+/* Top level */
+#define VPDMA_PID		0x00
+#define VPDMA_LIST_ADDR		0x04
+#define VPDMA_LIST_ATTR		0x08
+#define VPDMA_LIST_STAT_SYNC	0x0c
+#define VPDMA_BG_RGB		0x18
+#define VPDMA_BG_YUV		0x1c
+#define VPDMA_SETUP		0x30
+#define VPDMA_MAX_SIZE1		0x34
+#define VPDMA_MAX_SIZE2		0x38
+#define VPDMA_MAX_SIZE3		0x3c
+
+/* Interrupts */
+#define VPDMA_INT_CHAN_STAT(grp)	(0x40 + grp * 8)
+#define VPDMA_INT_CHAN_MASK(grp)	(VPDMA_INT_CHAN_STAT(grp) + 4)
+#define VPDMA_INT_CLIENT0_STAT		0x78
+#define VPDMA_INT_CLIENT0_MASK		0x7c
+#define VPDMA_INT_CLIENT1_STAT		0x80
+#define VPDMA_INT_CLIENT1_MASK		0x84
+#define VPDMA_INT_LIST0_STAT		0x88
+#define VPDMA_INT_LIST0_MASK		0x8c
+
+#define VPDMA_PERFMON(i)		(0x200 + i * 4)
+
+/* VPE specific client registers */
+#define VPDMA_DEI_CHROMA1_CSTAT		0x0300
+#define VPDMA_DEI_LUMA1_CSTAT		0x0304
+#define VPDMA_DEI_LUMA2_CSTAT		0x0308
+#define VPDMA_DEI_CHROMA2_CSTAT		0x030c
+#define VPDMA_DEI_LUMA3_CSTAT		0x0310
+#define VPDMA_DEI_CHROMA3_CSTAT		0x0314
+#define VPDMA_DEI_MV_IN_CSTAT		0x0330
+#define VPDMA_DEI_MV_OUT_CSTAT		0x033c
+#define VPDMA_VIP_UP_Y_CSTAT		0x0390
+#define VPDMA_VIP_UP_UV_CSTAT		0x0394
+#define VPDMA_VPI_CTL_CSTAT		0x03d0
+
+/* Reg field info for VPDMA_CLIENT_CSTAT registers */
+#define VPDMA_CSTAT_LINE_MODE_MASK	0x03
+#define VPDMA_CSTAT_LINE_MODE_SHIFT	8
+#define VPDMA_CSTAT_FRAME_START_MASK	0xf
+#define VPDMA_CSTAT_FRAME_START_SHIFT	10
+
+#define VPDMA_LIST_NUM_MASK		0x07
+#define VPDMA_LIST_NUM_SHFT		24
+#define VPDMA_LIST_STOP_SHFT		20
+#define VPDMA_LIST_RDY_MASK		0x01
+#define VPDMA_LIST_RDY_SHFT		19
+#define VPDMA_LIST_TYPE_MASK		0x03
+#define VPDMA_LIST_TYPE_SHFT		16
+#define VPDMA_LIST_SIZE_MASK		0xffff
+
+/* VPDMA data type values for data formats */
+#define DATA_TYPE_Y444				0x0
+#define DATA_TYPE_Y422				0x1
+#define DATA_TYPE_Y420				0x2
+#define DATA_TYPE_C444				0x4
+#define DATA_TYPE_C422				0x5
+#define DATA_TYPE_C420				0x6
+#define DATA_TYPE_YC422				0x7
+#define DATA_TYPE_YC444				0x8
+#define DATA_TYPE_CY422				0x23
+
+#define DATA_TYPE_RGB16_565			0x0
+#define DATA_TYPE_ARGB_1555			0x1
+#define DATA_TYPE_ARGB_4444			0x2
+#define DATA_TYPE_RGBA_5551			0x3
+#define DATA_TYPE_RGBA_4444			0x4
+#define DATA_TYPE_ARGB24_6666			0x5
+#define DATA_TYPE_RGB24_888			0x6
+#define DATA_TYPE_ARGB32_8888			0x7
+#define DATA_TYPE_RGBA24_6666			0x8
+#define DATA_TYPE_RGBA32_8888			0x9
+#define DATA_TYPE_BGR16_565			0x10
+#define DATA_TYPE_ABGR_1555			0x11
+#define DATA_TYPE_ABGR_4444			0x12
+#define DATA_TYPE_BGRA_5551			0x13
+#define DATA_TYPE_BGRA_4444			0x14
+#define DATA_TYPE_ABGR24_6666			0x15
+#define DATA_TYPE_BGR24_888			0x16
+#define DATA_TYPE_ABGR32_8888			0x17
+#define DATA_TYPE_BGRA24_6666			0x18
+#define DATA_TYPE_BGRA32_8888			0x19
+
+#define DATA_TYPE_MV				0x3
+
+/* VPDMA channel numbers(only VPE channels for now) */
+#define	VPE_CHAN_NUM_LUMA1_IN		0
+#define	VPE_CHAN_NUM_CHROMA1_IN		1
+#define	VPE_CHAN_NUM_LUMA2_IN		2
+#define	VPE_CHAN_NUM_CHROMA2_IN		3
+#define	VPE_CHAN_NUM_LUMA3_IN		4
+#define	VPE_CHAN_NUM_CHROMA3_IN		5
+#define	VPE_CHAN_NUM_MV_IN		12
+#define	VPE_CHAN_NUM_MV_OUT		15
+#define	VPE_CHAN_NUM_LUMA_OUT		102
+#define	VPE_CHAN_NUM_CHROMA_OUT		103
+#define	VPE_CHAN_NUM_RGB_OUT		106
+
+#endif
-- 
1.8.1.2

