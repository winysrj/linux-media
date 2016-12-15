Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f178.google.com ([209.85.210.178]:33012 "EHLO
        mail-wj0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756554AbcLORY3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 12:24:29 -0500
Received: by mail-wj0-f178.google.com with SMTP id xy5so71272730wjc.0
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2016 09:23:59 -0800 (PST)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v5 8/9] media: venus: hfi: add Venus HFI files
Date: Thu, 15 Dec 2016 19:22:23 +0200
Message-Id: <1481822544-29900-9-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1481822544-29900-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1481822544-29900-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is the implementation of Venus video accelerator low-level
functionality. It contanins code which setup the registers and
startup uthe processor, allocate and manipulates with the shared
memory used for sending commands and receiving messages.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c    | 1508 ++++++++++++++++++++++
 drivers/media/platform/qcom/venus/hfi_venus.h    |   23 +
 drivers/media/platform/qcom/venus/hfi_venus_io.h |   98 ++
 3 files changed, 1629 insertions(+)
 create mode 100644 drivers/media/platform/qcom/venus/hfi_venus.c
 create mode 100644 drivers/media/platform/qcom/venus/hfi_venus.h
 create mode 100644 drivers/media/platform/qcom/venus/hfi_venus_io.h

diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c b/drivers/media/platform/qcom/venus/hfi_venus.c
new file mode 100644
index 000000000000..f004a9a80d85
--- /dev/null
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -0,0 +1,1508 @@
+/*
+ * Copyright (c) 2012-2015, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2016 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/iopoll.h>
+#include <linux/kernel.h>
+#include <linux/qcom_scm.h>
+#include <linux/slab.h>
+
+#include "core.h"
+#include "hfi_cmds.h"
+#include "hfi_msgs.h"
+#include "hfi_venus.h"
+#include "hfi_venus_io.h"
+
+#define HFI_MASK_QHDR_TX_TYPE		0xff000000
+#define HFI_MASK_QHDR_RX_TYPE		0x00ff0000
+#define HFI_MASK_QHDR_PRI_TYPE		0x0000ff00
+#define HFI_MASK_QHDR_ID_TYPE		0x000000ff
+
+#define HFI_HOST_TO_CTRL_CMD_Q		0
+#define HFI_CTRL_TO_HOST_MSG_Q		1
+#define HFI_CTRL_TO_HOST_DBG_Q		2
+#define HFI_MASK_QHDR_STATUS		0x000000ff
+
+#define IFACEQ_NUM			3
+#define IFACEQ_CMD_IDX			0
+#define IFACEQ_MSG_IDX			1
+#define IFACEQ_DBG_IDX			2
+#define IFACEQ_MAX_BUF_COUNT		50
+#define IFACEQ_MAX_PARALLEL_CLNTS	16
+#define IFACEQ_DFLT_QHDR		0x01010000
+
+#define POLL_INTERVAL_US		50
+
+#define IFACEQ_MAX_PKT_SIZE		1024
+#define IFACEQ_MED_PKT_SIZE		768
+#define IFACEQ_MIN_PKT_SIZE		8
+#define IFACEQ_VAR_SMALL_PKT_SIZE	100
+#define IFACEQ_VAR_LARGE_PKT_SIZE	512
+#define IFACEQ_VAR_HUGE_PKT_SIZE	(1024 * 12)
+
+enum tzbsp_video_state {
+	TZBSP_VIDEO_STATE_SUSPEND = 0,
+	TZBSP_VIDEO_STATE_RESUME
+};
+
+struct hfi_queue_table_header {
+	u32 version;
+	u32 size;
+	u32 qhdr0_offset;
+	u32 qhdr_size;
+	u32 num_q;
+	u32 num_active_q;
+};
+
+struct hfi_queue_header {
+	u32 status;
+	u32 start_addr;
+	u32 type;
+	u32 q_size;
+	u32 pkt_size;
+	u32 pkt_drop_cnt;
+	u32 rx_wm;
+	u32 tx_wm;
+	u32 rx_req;
+	u32 tx_req;
+	u32 rx_irq_status;
+	u32 tx_irq_status;
+	u32 read_idx;
+	u32 write_idx;
+};
+
+#define IFACEQ_TABLE_SIZE	\
+	(sizeof(struct hfi_queue_table_header) +	\
+	 sizeof(struct hfi_queue_header) * IFACEQ_NUM)
+
+#define IFACEQ_QUEUE_SIZE	(IFACEQ_MAX_PKT_SIZE *	\
+	IFACEQ_MAX_BUF_COUNT * IFACEQ_MAX_PARALLEL_CLNTS)
+
+#define IFACEQ_GET_QHDR_START_ADDR(ptr, i)	\
+	(void *)(((ptr) + sizeof(struct hfi_queue_table_header)) +	\
+		((i) * sizeof(struct hfi_queue_header)))
+
+#define QDSS_SIZE		SZ_4K
+#define SFR_SIZE		SZ_4K
+#define QUEUE_SIZE		\
+	(IFACEQ_TABLE_SIZE + (IFACEQ_QUEUE_SIZE * IFACEQ_NUM))
+
+#define ALIGNED_QDSS_SIZE	ALIGN(QDSS_SIZE, SZ_4K)
+#define ALIGNED_SFR_SIZE	ALIGN(SFR_SIZE, SZ_4K)
+#define ALIGNED_QUEUE_SIZE	ALIGN(QUEUE_SIZE, SZ_4K)
+#define SHARED_QSIZE		ALIGN(ALIGNED_SFR_SIZE + ALIGNED_QUEUE_SIZE + \
+				      ALIGNED_QDSS_SIZE, SZ_1M)
+
+struct mem_desc {
+	dma_addr_t da;	/* device address */
+	void *kva;	/* kernel virtual address */
+	u32 size;
+	unsigned long attrs;
+};
+
+struct iface_queue {
+	struct hfi_queue_header *qhdr;
+	struct mem_desc qmem;
+};
+
+enum venus_state {
+	VENUS_STATE_DEINIT = 1,
+	VENUS_STATE_INIT,
+};
+
+struct venus_hfi_device {
+	struct venus_core *core;
+	u32 irq_status;
+	u32 last_packet_type;
+	bool power_enabled;
+	bool suspended;
+	enum venus_state state;
+	struct mutex lock;
+	struct completion pwr_collapse_prep;
+	struct completion release_resource;
+	struct mem_desc ifaceq_table;
+	struct mem_desc sfr;
+	struct iface_queue queues[IFACEQ_NUM];
+	u8 pkt_buf[IFACEQ_VAR_HUGE_PKT_SIZE];
+	u8 dbg_buf[IFACEQ_VAR_HUGE_PKT_SIZE];
+};
+
+static bool venus_pkt_debug;
+static int venus_fw_debug = HFI_DEBUG_MSG_ERROR | HFI_DEBUG_MSG_FATAL;
+static bool venus_sys_idle_indicator;
+static bool venus_fw_low_power_mode = true;
+static int venus_hw_rsp_timeout = 1000;
+static bool venus_fw_coverage;
+
+static void venus_set_state(struct venus_hfi_device *hdev,
+			    enum venus_state state)
+{
+	mutex_lock(&hdev->lock);
+	hdev->state = state;
+	mutex_unlock(&hdev->lock);
+}
+
+static bool venus_is_valid_state(struct venus_hfi_device *hdev)
+{
+	return hdev->state != VENUS_STATE_DEINIT;
+}
+
+static void venus_dump_packet(struct venus_hfi_device *hdev, const void *packet)
+{
+	size_t pkt_size = *(u32 *)packet;
+
+	if (!venus_pkt_debug)
+		return;
+
+	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1, packet,
+		       pkt_size, true);
+}
+
+static int venus_write_queue(struct venus_hfi_device *hdev,
+			     struct iface_queue *queue,
+			     void *packet, u32 *rx_req)
+{
+	struct hfi_queue_header *qhdr;
+	u32 dwords, new_wr_idx;
+	u32 empty_space, rd_idx, wr_idx, qsize;
+	u32 *wr_ptr;
+
+	if (!queue->qmem.kva)
+		return -EINVAL;
+
+	qhdr = queue->qhdr;
+	if (!qhdr)
+		return -EINVAL;
+
+	venus_dump_packet(hdev, packet);
+
+	dwords = (*(u32 *)packet) >> 2;
+	if (!dwords)
+		return -EINVAL;
+
+	rd_idx = qhdr->read_idx;
+	wr_idx = qhdr->write_idx;
+	qsize = qhdr->q_size;
+	/* ensure rd/wr indices's are read from memory */
+	rmb();
+
+	if (wr_idx >= rd_idx)
+		empty_space = qsize - (wr_idx - rd_idx);
+	else
+		empty_space = rd_idx - wr_idx;
+
+	if (empty_space <= dwords) {
+		qhdr->tx_req = 1;
+		/* ensure tx_req is updated in memory */
+		wmb();
+		return -ENOSPC;
+	}
+
+	qhdr->tx_req = 0;
+	/* ensure tx_req is updated in memory */
+	wmb();
+
+	new_wr_idx = wr_idx + dwords;
+	wr_ptr = (u32 *)(queue->qmem.kva + (wr_idx << 2));
+	if (new_wr_idx < qsize) {
+		memcpy(wr_ptr, packet, dwords << 2);
+	} else {
+		size_t len;
+
+		new_wr_idx -= qsize;
+		len = (dwords - new_wr_idx) << 2;
+		memcpy(wr_ptr, packet, len);
+		memcpy(queue->qmem.kva, packet + len, new_wr_idx << 2);
+	}
+
+	/* make sure packet is written before updating the write index */
+	wmb();
+
+	qhdr->write_idx = new_wr_idx;
+	*rx_req = qhdr->rx_req ? 1 : 0;
+
+	/* make sure write index is updated before an interupt is raised */
+	mb();
+
+	return 0;
+}
+
+static int venus_read_queue(struct venus_hfi_device *hdev,
+			    struct iface_queue *queue, void *pkt, u32 *tx_req)
+{
+	struct hfi_queue_header *qhdr;
+	u32 dwords, new_rd_idx;
+	u32 rd_idx, wr_idx, type, qsize;
+	u32 *rd_ptr;
+	u32 recv_request = 0;
+	int ret = 0;
+
+	if (!queue->qmem.kva)
+		return -EINVAL;
+
+	qhdr = queue->qhdr;
+	if (!qhdr)
+		return -EINVAL;
+
+	type = qhdr->type;
+	rd_idx = qhdr->read_idx;
+	wr_idx = qhdr->write_idx;
+	qsize = qhdr->q_size;
+
+	/* make sure data is valid before using it */
+	rmb();
+
+	/*
+	 * Do not set receive request for debug queue, if set, Venus generates
+	 * interrupt for debug messages even when there is no response message
+	 * available. In general debug queue will not become full as it is being
+	 * emptied out for every interrupt from Venus. Venus will anyway
+	 * generates interrupt if it is full.
+	 */
+	if (type & HFI_CTRL_TO_HOST_MSG_Q)
+		recv_request = 1;
+
+	if (rd_idx == wr_idx) {
+		qhdr->rx_req = recv_request;
+		*tx_req = 0;
+		/* update rx_req field in memory */
+		wmb();
+		return -ENODATA;
+	}
+
+	rd_ptr = (u32 *)(queue->qmem.kva + (rd_idx << 2));
+	dwords = *rd_ptr >> 2;
+	if (!dwords)
+		return -EINVAL;
+
+	new_rd_idx = rd_idx + dwords;
+	if (((dwords << 2) <= IFACEQ_VAR_HUGE_PKT_SIZE) && rd_idx <= qsize) {
+		if (new_rd_idx < qsize) {
+			memcpy(pkt, rd_ptr, dwords << 2);
+		} else {
+			size_t len;
+
+			new_rd_idx -= qsize;
+			len = (dwords - new_rd_idx) << 2;
+			memcpy(pkt, rd_ptr, len);
+			memcpy(pkt + len, queue->qmem.kva, new_rd_idx << 2);
+		}
+	} else {
+		/* bad packet received, dropping */
+		new_rd_idx = qhdr->write_idx;
+		ret = -EBADMSG;
+	}
+
+	/* ensure the packet is read before updating read index */
+	rmb();
+
+	qhdr->read_idx = new_rd_idx;
+	/* ensure updating read index */
+	wmb();
+
+	rd_idx = qhdr->read_idx;
+	wr_idx = qhdr->write_idx;
+	/* ensure rd/wr indices are read from memory */
+	rmb();
+
+	if (rd_idx != wr_idx)
+		qhdr->rx_req = 0;
+	else
+		qhdr->rx_req = recv_request;
+
+	*tx_req = qhdr->tx_req ? 1 : 0;
+
+	/* ensure rx_req is stored to memory and tx_req is loaded from memory */
+	mb();
+
+	venus_dump_packet(hdev, pkt);
+
+	return ret;
+}
+
+static int venus_alloc(struct venus_hfi_device *hdev, struct mem_desc *desc,
+		       u32 size)
+{
+	struct device *dev = hdev->core->dev;
+
+	desc->attrs = DMA_ATTR_WRITE_COMBINE;
+	desc->size = ALIGN(size, SZ_4K);
+
+	desc->kva = dma_alloc_attrs(dev, size, &desc->da, GFP_KERNEL,
+				    desc->attrs);
+	if (!desc->kva)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void venus_free(struct venus_hfi_device *hdev, struct mem_desc *mem)
+{
+	struct device *dev = hdev->core->dev;
+
+	dma_free_attrs(dev, mem->size, mem->kva, mem->da, mem->attrs);
+}
+
+static void venus_writel(struct venus_hfi_device *hdev, u32 reg, u32 value)
+{
+	writel(value, hdev->core->base + reg);
+}
+
+static u32 venus_readl(struct venus_hfi_device *hdev, u32 reg)
+{
+	return readl(hdev->core->base + reg);
+}
+
+static void venus_set_registers(struct venus_hfi_device *hdev)
+{
+	const struct venus_resources *res = hdev->core->res;
+	const struct reg_val *tbl = res->reg_tbl;
+	unsigned int count = res->reg_tbl_size;
+	unsigned int i;
+
+	for (i = 0; i < count; i++)
+		venus_writel(hdev, tbl[i].reg, tbl[i].value);
+}
+
+static void venus_soft_int(struct venus_hfi_device *hdev)
+{
+	venus_writel(hdev, CPU_IC_SOFTINT, BIT(CPU_IC_SOFTINT_H2A_SHIFT));
+}
+
+static int venus_iface_cmdq_write_nolock(struct venus_hfi_device *hdev,
+					 void *pkt)
+{
+	struct device *dev = hdev->core->dev;
+	struct hfi_pkt_hdr *cmd_packet;
+	struct iface_queue *queue;
+	u32 rx_req;
+	int ret;
+
+	if (!venus_is_valid_state(hdev)) {
+		dev_err(dev, "%s: fw not in init state\n", __func__);
+		return -EINVAL;
+	}
+
+	cmd_packet = (struct hfi_pkt_hdr *)pkt;
+	hdev->last_packet_type = cmd_packet->pkt_type;
+
+	queue = &hdev->queues[IFACEQ_CMD_IDX];
+
+	ret = venus_write_queue(hdev, queue, pkt, &rx_req);
+	if (ret) {
+		dev_err(dev, "write to iface cmd queue failed (%d)\n", ret);
+		return ret;
+	}
+
+	if (rx_req)
+		venus_soft_int(hdev);
+
+	return 0;
+}
+
+static int venus_iface_cmdq_write(struct venus_hfi_device *hdev, void *pkt)
+{
+	int ret;
+
+	mutex_lock(&hdev->lock);
+	ret = venus_iface_cmdq_write_nolock(hdev, pkt);
+	mutex_unlock(&hdev->lock);
+
+	return ret;
+}
+
+static int venus_hfi_core_set_resource(struct venus_core *core, u32 id,
+				       u32 size, u32 addr, void *cookie)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(core);
+	struct hfi_sys_set_resource_pkt *pkt;
+	u8 packet[IFACEQ_VAR_SMALL_PKT_SIZE];
+	int ret;
+
+	if (id == VIDC_RESOURCE_NONE)
+		return 0;
+
+	pkt = (struct hfi_sys_set_resource_pkt *) packet;
+
+	ret = pkt_sys_set_resource(pkt, id, size, addr, cookie);
+	if (ret)
+		return ret;
+
+	ret = venus_iface_cmdq_write(hdev, pkt);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int venus_tzbsp_set_video_state(enum tzbsp_video_state state)
+{
+	return qcom_scm_video_set_state(state, 0);
+}
+
+static int venus_boot_core(struct venus_hfi_device *hdev)
+{
+	struct device *dev = hdev->core->dev;
+	static const unsigned int max_tries = 100;
+	u32 ctrl_status = 0;
+	unsigned int count = 0;
+	int ret = 0;
+
+	venus_writel(hdev, VIDC_CTRL_INIT, BIT(VIDC_CTRL_INIT_CTRL_SHIFT));
+	venus_writel(hdev, WRAPPER_INTR_MASK, WRAPPER_INTR_MASK_A2HVCODEC_MASK);
+	venus_writel(hdev, CPU_CS_SCIACMDARG3, 1);
+
+	while (!ctrl_status && count < max_tries) {
+		ctrl_status = venus_readl(hdev, CPU_CS_SCIACMDARG0);
+		if ((ctrl_status & CPU_CS_SCIACMDARG0_ERROR_STATUS_MASK) == 4) {
+			dev_err(dev, "invalid setting for UC_REGION\n");
+			ret = -EINVAL;
+			break;
+		}
+
+		usleep_range(500, 1000);
+		count++;
+	}
+
+	if (count >= max_tries)
+		ret = -ETIMEDOUT;
+
+	return ret;
+}
+
+static u32 venus_hwversion(struct venus_hfi_device *hdev)
+{
+	struct device *dev = hdev->core->dev;
+	u32 ver = venus_readl(hdev, WRAPPER_HW_VERSION);
+	u32 major, minor, step;
+
+	major = ver & WRAPPER_HW_VERSION_MAJOR_VERSION_MASK;
+	major = major >> WRAPPER_HW_VERSION_MAJOR_VERSION_SHIFT;
+	minor = ver & WRAPPER_HW_VERSION_MINOR_VERSION_MASK;
+	minor = minor >> WRAPPER_HW_VERSION_MINOR_VERSION_SHIFT;
+	step = ver & WRAPPER_HW_VERSION_STEP_VERSION_MASK;
+
+	dev_dbg(dev, "venus hw version %d.%d.%d\n", major, minor, step);
+
+	return major;
+}
+
+static int venus_run(struct venus_hfi_device *hdev)
+{
+	struct device *dev = hdev->core->dev;
+	int ret;
+
+	/*
+	 * Re-program all of the registers that get reset as a result of
+	 * regulator_disable() and _enable()
+	 */
+	venus_set_registers(hdev);
+
+	venus_writel(hdev, UC_REGION_ADDR, hdev->ifaceq_table.da);
+	venus_writel(hdev, UC_REGION_SIZE, SHARED_QSIZE);
+	venus_writel(hdev, CPU_CS_SCIACMDARG2, hdev->ifaceq_table.da);
+	venus_writel(hdev, CPU_CS_SCIACMDARG1, 0x01);
+	if (hdev->sfr.da)
+		venus_writel(hdev, SFR_ADDR, hdev->sfr.da);
+
+	ret = venus_boot_core(hdev);
+	if (ret) {
+		dev_err(dev, "failed to reset venus core\n");
+		return ret;
+	}
+
+	venus_hwversion(hdev);
+
+	return 0;
+}
+
+static int venus_halt_axi(struct venus_hfi_device *hdev)
+{
+	void __iomem *base = hdev->core->base;
+	struct device *dev = hdev->core->dev;
+	u32 val;
+	int ret;
+
+	/* Halt AXI and AXI IMEM VBIF Access */
+	val = venus_readl(hdev, VBIF_AXI_HALT_CTRL0);
+	val |= VBIF_AXI_HALT_CTRL0_HALT_REQ;
+	venus_writel(hdev, VBIF_AXI_HALT_CTRL0, val);
+
+	/* Request for AXI bus port halt */
+	ret = readl_poll_timeout(base + VBIF_AXI_HALT_CTRL1, val,
+				 val & VBIF_AXI_HALT_CTRL1_HALT_ACK,
+				 POLL_INTERVAL_US,
+				 VBIF_AXI_HALT_ACK_TIMEOUT_US);
+	if (ret) {
+		dev_err(dev, "AXI bus port halt timeout\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int venus_power_off(struct venus_hfi_device *hdev)
+{
+	int ret;
+
+	if (!hdev->power_enabled)
+		return 0;
+
+	ret = venus_halt_axi(hdev);
+	if (ret)
+		return ret;
+
+	ret = venus_tzbsp_set_video_state(TZBSP_VIDEO_STATE_SUSPEND);
+	if (ret)
+		return ret;
+
+	hdev->power_enabled = false;
+
+	return 0;
+}
+
+static int venus_power_on(struct venus_hfi_device *hdev)
+{
+	int ret;
+
+	if (hdev->power_enabled)
+		return 0;
+
+	ret = venus_tzbsp_set_video_state(TZBSP_VIDEO_STATE_RESUME);
+	if (ret)
+		goto err;
+
+	ret = venus_run(hdev);
+	if (ret)
+		goto err_suspend;
+
+	hdev->power_enabled = true;
+
+	return 0;
+
+err_suspend:
+	venus_tzbsp_set_video_state(TZBSP_VIDEO_STATE_SUSPEND);
+err:
+	hdev->power_enabled = false;
+	return ret;
+}
+
+static int venus_iface_msgq_read_nolock(struct venus_hfi_device *hdev,
+					void *pkt)
+{
+	struct iface_queue *queue;
+	u32 tx_req;
+	int ret;
+
+	if (!venus_is_valid_state(hdev))
+		return -EINVAL;
+
+	queue = &hdev->queues[IFACEQ_MSG_IDX];
+
+	ret = venus_read_queue(hdev, queue, pkt, &tx_req);
+	if (ret)
+		return ret;
+
+	if (tx_req)
+		venus_soft_int(hdev);
+
+	return 0;
+}
+
+static int venus_iface_msgq_read(struct venus_hfi_device *hdev, void *pkt)
+{
+	int ret;
+
+	mutex_lock(&hdev->lock);
+	ret = venus_iface_msgq_read_nolock(hdev, pkt);
+	mutex_unlock(&hdev->lock);
+
+	return ret;
+}
+
+static int venus_iface_dbgq_read_nolock(struct venus_hfi_device *hdev,
+					void *pkt)
+{
+	struct iface_queue *queue;
+	u32 tx_req;
+	int ret;
+
+	ret = venus_is_valid_state(hdev);
+	if (!ret)
+		return -EINVAL;
+
+	queue = &hdev->queues[IFACEQ_DBG_IDX];
+
+	ret = venus_read_queue(hdev, queue, pkt, &tx_req);
+	if (ret)
+		return ret;
+
+	if (tx_req)
+		venus_soft_int(hdev);
+
+	return 0;
+}
+
+static int venus_iface_dbgq_read(struct venus_hfi_device *hdev, void *pkt)
+{
+	int ret;
+
+	if (!pkt)
+		return -EINVAL;
+
+	mutex_lock(&hdev->lock);
+	ret = venus_iface_dbgq_read_nolock(hdev, pkt);
+	mutex_unlock(&hdev->lock);
+
+	return ret;
+}
+
+static void venus_set_qhdr_defaults(struct hfi_queue_header *qhdr)
+{
+	qhdr->status = 1;
+	qhdr->type = IFACEQ_DFLT_QHDR;
+	qhdr->q_size = IFACEQ_QUEUE_SIZE / 4;
+	qhdr->pkt_size = 0;
+	qhdr->rx_wm = 1;
+	qhdr->tx_wm = 1;
+	qhdr->rx_req = 1;
+	qhdr->tx_req = 0;
+	qhdr->rx_irq_status = 0;
+	qhdr->tx_irq_status = 0;
+	qhdr->read_idx = 0;
+	qhdr->write_idx = 0;
+}
+
+static void venus_interface_queues_release(struct venus_hfi_device *hdev)
+{
+	mutex_lock(&hdev->lock);
+
+	venus_free(hdev, &hdev->ifaceq_table);
+	venus_free(hdev, &hdev->sfr);
+
+	memset(hdev->queues, 0, sizeof(hdev->queues));
+	memset(&hdev->ifaceq_table, 0, sizeof(hdev->ifaceq_table));
+	memset(&hdev->sfr, 0, sizeof(hdev->sfr));
+
+	mutex_unlock(&hdev->lock);
+}
+
+static int venus_interface_queues_init(struct venus_hfi_device *hdev)
+{
+	struct hfi_queue_table_header *tbl_hdr;
+	struct iface_queue *queue;
+	struct hfi_sfr *sfr;
+	struct mem_desc desc = {0};
+	unsigned int offset;
+	unsigned int i;
+	int ret;
+
+	ret = venus_alloc(hdev, &desc, ALIGNED_QUEUE_SIZE);
+	if (ret)
+		return ret;
+
+	hdev->ifaceq_table.kva = desc.kva;
+	hdev->ifaceq_table.da = desc.da;
+	hdev->ifaceq_table.size = IFACEQ_TABLE_SIZE;
+	offset = hdev->ifaceq_table.size;
+
+	for (i = 0; i < IFACEQ_NUM; i++) {
+		queue = &hdev->queues[i];
+		queue->qmem.da = desc.da + offset;
+		queue->qmem.kva = desc.kva + offset;
+		queue->qmem.size = IFACEQ_QUEUE_SIZE;
+		offset += queue->qmem.size;
+		queue->qhdr =
+			IFACEQ_GET_QHDR_START_ADDR(hdev->ifaceq_table.kva, i);
+
+		venus_set_qhdr_defaults(queue->qhdr);
+
+		queue->qhdr->start_addr = queue->qmem.da;
+
+		if (i == IFACEQ_CMD_IDX)
+			queue->qhdr->type |= HFI_HOST_TO_CTRL_CMD_Q;
+		else if (i == IFACEQ_MSG_IDX)
+			queue->qhdr->type |= HFI_CTRL_TO_HOST_MSG_Q;
+		else if (i == IFACEQ_DBG_IDX)
+			queue->qhdr->type |= HFI_CTRL_TO_HOST_DBG_Q;
+	}
+
+	tbl_hdr = hdev->ifaceq_table.kva;
+	tbl_hdr->version = 0;
+	tbl_hdr->size = IFACEQ_TABLE_SIZE;
+	tbl_hdr->qhdr0_offset = sizeof(struct hfi_queue_table_header);
+	tbl_hdr->qhdr_size = sizeof(struct hfi_queue_header);
+	tbl_hdr->num_q = IFACEQ_NUM;
+	tbl_hdr->num_active_q = IFACEQ_NUM;
+
+	/*
+	 * Set receive request to zero on debug queue as there is no
+	 * need of interrupt from video hardware for debug messages
+	 */
+	queue = &hdev->queues[IFACEQ_DBG_IDX];
+	queue->qhdr->rx_req = 0;
+
+	ret = venus_alloc(hdev, &desc, ALIGNED_SFR_SIZE);
+	if (ret) {
+		hdev->sfr.da = 0;
+	} else {
+		hdev->sfr.da = desc.da;
+		hdev->sfr.kva = desc.kva;
+		hdev->sfr.size = ALIGNED_SFR_SIZE;
+		sfr = hdev->sfr.kva;
+		sfr->buf_size = ALIGNED_SFR_SIZE;
+	}
+
+	/* ensure table and queue header structs are settled in memory */
+	wmb();
+
+	return 0;
+}
+
+static int venus_sys_set_debug(struct venus_hfi_device *hdev, u32 debug)
+{
+	struct hfi_sys_set_property_pkt *pkt;
+	u8 packet[IFACEQ_VAR_SMALL_PKT_SIZE];
+	int ret;
+
+	pkt = (struct hfi_sys_set_property_pkt *) packet;
+
+	pkt_sys_debug_config(pkt, HFI_DEBUG_MODE_QUEUE, debug);
+
+	ret = venus_iface_cmdq_write(hdev, pkt);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int venus_sys_set_coverage(struct venus_hfi_device *hdev, u32 mode)
+{
+	struct hfi_sys_set_property_pkt *pkt;
+	u8 packet[IFACEQ_VAR_SMALL_PKT_SIZE];
+	int ret;
+
+	pkt = (struct hfi_sys_set_property_pkt *) packet;
+
+	pkt_sys_coverage_config(pkt, mode);
+
+	ret = venus_iface_cmdq_write(hdev, pkt);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int venus_sys_set_idle_message(struct venus_hfi_device *hdev,
+				      bool enable)
+{
+	struct hfi_sys_set_property_pkt *pkt;
+	u8 packet[IFACEQ_VAR_SMALL_PKT_SIZE];
+	int ret;
+
+	if (!enable)
+		return 0;
+
+	pkt = (struct hfi_sys_set_property_pkt *) packet;
+
+	pkt_sys_idle_indicator(pkt, enable);
+
+	ret = venus_iface_cmdq_write(hdev, pkt);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int venus_sys_set_power_control(struct venus_hfi_device *hdev,
+				       bool enable)
+{
+	struct hfi_sys_set_property_pkt *pkt;
+	u8 packet[IFACEQ_VAR_SMALL_PKT_SIZE];
+	int ret;
+
+	pkt = (struct hfi_sys_set_property_pkt *) packet;
+
+	pkt_sys_power_control(pkt, enable);
+
+	ret = venus_iface_cmdq_write(hdev, pkt);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int venus_get_queue_size(struct venus_hfi_device *hdev,
+				unsigned int index)
+{
+	struct hfi_queue_header *qhdr;
+
+	if (index >= IFACEQ_NUM)
+		return -EINVAL;
+
+	qhdr = hdev->queues[index].qhdr;
+	if (!qhdr)
+		return -EINVAL;
+
+	return abs(qhdr->read_idx - qhdr->write_idx);
+}
+
+static int venus_sys_set_default_properties(struct venus_hfi_device *hdev)
+{
+	struct device *dev = hdev->core->dev;
+	int ret;
+
+	ret = venus_sys_set_debug(hdev, venus_fw_debug);
+	if (ret)
+		dev_warn(dev, "setting fw debug msg ON failed (%d)\n", ret);
+
+	ret = venus_sys_set_idle_message(hdev, venus_sys_idle_indicator);
+	if (ret)
+		dev_warn(dev, "setting idle response ON failed (%d)\n", ret);
+
+	ret = venus_sys_set_power_control(hdev, venus_fw_low_power_mode);
+	if (ret)
+		dev_warn(dev, "setting hw power collapse ON failed (%d)\n",
+			 ret);
+
+	return ret;
+}
+
+static int venus_session_cmd(struct venus_inst *inst, u32 pkt_type)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(inst->core);
+	struct hfi_session_pkt pkt;
+	int ret;
+
+	pkt_session_cmd(&pkt, pkt_type, inst);
+
+	ret = venus_iface_cmdq_write(hdev, &pkt);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static void venus_flush_debug_queue(struct venus_hfi_device *hdev)
+{
+	struct device *dev = hdev->core->dev;
+	void *packet = hdev->dbg_buf;
+
+	while (!venus_iface_dbgq_read(hdev, packet)) {
+		struct hfi_msg_sys_coverage_pkt *pkt = packet;
+
+		if (pkt->hdr.pkt_type != HFI_MSG_SYS_COV) {
+			struct hfi_msg_sys_debug_pkt *pkt = packet;
+
+			dev_dbg(dev, "%s", pkt->msg_data);
+		}
+	}
+}
+
+static int venus_prepare_power_collapse(struct venus_hfi_device *hdev)
+{
+	unsigned long timeout = msecs_to_jiffies(venus_hw_rsp_timeout);
+	struct hfi_sys_pc_prep_pkt pkt;
+	int ret;
+
+	init_completion(&hdev->pwr_collapse_prep);
+
+	pkt_sys_pc_prep(&pkt);
+
+	ret = venus_iface_cmdq_write(hdev, &pkt);
+	if (ret)
+		return ret;
+
+	ret = wait_for_completion_timeout(&hdev->pwr_collapse_prep, timeout);
+	if (!ret) {
+		venus_flush_debug_queue(hdev);
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+static int venus_are_queues_empty(struct venus_hfi_device *hdev)
+{
+	int ret1, ret2;
+
+	ret1 = venus_get_queue_size(hdev, IFACEQ_MSG_IDX);
+	if (ret1 < 0)
+		return ret1;
+
+	ret2 = venus_get_queue_size(hdev, IFACEQ_CMD_IDX);
+	if (ret2 < 0)
+		return ret2;
+
+	if (!ret1 && !ret2)
+		return 1;
+
+	return 0;
+}
+
+static void venus_sfr_print(struct venus_hfi_device *hdev)
+{
+	struct device *dev = hdev->core->dev;
+	struct hfi_sfr *sfr = hdev->sfr.kva;
+	void *p;
+
+	if (!sfr)
+		return;
+
+	p = memchr(sfr->data, '\0', sfr->buf_size);
+	/*
+	 * SFR isn't guaranteed to be NULL terminated since SYS_ERROR indicates
+	 * that Venus is in the process of crashing.
+	 */
+	if (p == NULL)
+		sfr->data[sfr->buf_size - 1] = '\0';
+
+	dev_warn_ratelimited(dev, "SFR message from FW: %s\n", sfr->data);
+}
+
+static void venus_process_msg_sys_error(struct venus_hfi_device *hdev,
+					void *packet)
+{
+	struct hfi_msg_event_notify_pkt *event_pkt = packet;
+
+	if (event_pkt->event_id != HFI_EVENT_SYS_ERROR)
+		return;
+
+	venus_set_state(hdev, VENUS_STATE_DEINIT);
+
+	/*
+	 * Once SYS_ERROR received from HW, it is safe to halt the AXI.
+	 * With SYS_ERROR, Venus FW may have crashed and HW might be
+	 * active and causing unnecessary transactions. Hence it is
+	 * safe to stop all AXI transactions from venus subsystem.
+	 */
+	venus_halt_axi(hdev);
+	venus_sfr_print(hdev);
+}
+
+static irqreturn_t venus_isr_thread(struct venus_core *core)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(core);
+	const struct venus_resources *res = hdev->core->res;
+	void *pkt;
+	u32 msg_ret;
+
+	if (!hdev)
+		return IRQ_NONE;
+
+	pkt = hdev->pkt_buf;
+
+	if (hdev->irq_status & WRAPPER_INTR_STATUS_A2HWD_MASK) {
+		venus_sfr_print(hdev);
+		hfi_process_watchdog_timeout(core);
+	}
+
+	while (!venus_iface_msgq_read(hdev, pkt)) {
+		msg_ret = hfi_process_msg_packet(core, pkt);
+		switch (msg_ret) {
+		case HFI_MSG_EVENT_NOTIFY:
+			venus_process_msg_sys_error(hdev, pkt);
+			break;
+		case HFI_MSG_SYS_INIT:
+			venus_hfi_core_set_resource(core, res->vmem_id,
+						    res->vmem_size,
+						    res->vmem_addr,
+						    hdev);
+			break;
+		case HFI_MSG_SYS_RELEASE_RESOURCE:
+			complete(&hdev->release_resource);
+			break;
+		case HFI_MSG_SYS_PC_PREP:
+			complete(&hdev->pwr_collapse_prep);
+			break;
+		default:
+			break;
+		}
+	}
+
+	venus_flush_debug_queue(hdev);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t venus_isr(struct venus_core *core)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(core);
+	u32 status;
+
+	if (!hdev)
+		return IRQ_NONE;
+
+	status = venus_readl(hdev, WRAPPER_INTR_STATUS);
+
+	if (status & WRAPPER_INTR_STATUS_A2H_MASK ||
+	    status & WRAPPER_INTR_STATUS_A2HWD_MASK ||
+	    status & CPU_CS_SCIACMDARG0_INIT_IDLE_MSG_MASK)
+		hdev->irq_status = status;
+
+	venus_writel(hdev, CPU_CS_A2HSOFTINTCLR, 1);
+	venus_writel(hdev, WRAPPER_INTR_CLEAR, status);
+
+	return IRQ_WAKE_THREAD;
+}
+
+static int venus_hfi_core_init(struct venus_core *core)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(core);
+	struct device *dev = core->dev;
+	struct hfi_sys_get_property_pkt version_pkt;
+	struct hfi_sys_init_pkt pkt;
+	int ret;
+
+	pkt_sys_init(&pkt, HFI_VIDEO_ARCH_OX);
+
+	ret = venus_iface_cmdq_write(hdev, &pkt);
+	if (ret)
+		return ret;
+
+	pkt_sys_image_version(&version_pkt);
+
+	ret = venus_iface_cmdq_write(hdev, &version_pkt);
+	if (ret)
+		dev_warn(dev, "failed to send image version pkt to fw\n");
+
+	venus_set_state(hdev, VENUS_STATE_INIT);
+
+	return 0;
+}
+
+static int venus_hfi_core_deinit(struct venus_core *core)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(core);
+
+	venus_set_state(hdev, VENUS_STATE_DEINIT);
+	hdev->suspended = true;
+
+	return 0;
+}
+
+static int venus_hfi_core_ping(struct venus_core *core, u32 cookie)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(core);
+	struct hfi_sys_ping_pkt pkt;
+
+	pkt_sys_ping(&pkt, cookie);
+
+	return venus_iface_cmdq_write(hdev, &pkt);
+}
+
+static int venus_hfi_core_trigger_ssr(struct venus_core *core, u32 trigger_type)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(core);
+	struct hfi_sys_test_ssr_pkt pkt;
+	int ret;
+
+	ret = pkt_sys_ssr_cmd(&pkt, trigger_type);
+	if (ret)
+		return ret;
+
+	return venus_iface_cmdq_write(hdev, &pkt);
+}
+
+static int venus_hfi_session_init(struct venus_inst *inst,
+				  u32 session_type, u32 codec)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(inst->core);
+	struct hfi_session_init_pkt pkt;
+	int ret;
+
+	ret = venus_sys_set_default_properties(hdev);
+	if (ret)
+		return ret;
+
+	ret = pkt_session_init(&pkt, inst, session_type, codec);
+	if (ret)
+		goto err;
+
+	ret = venus_iface_cmdq_write(hdev, &pkt);
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	venus_flush_debug_queue(hdev);
+	return ret;
+}
+
+static int venus_hfi_session_end(struct venus_inst *inst)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(inst->core);
+	struct device *dev = hdev->core->dev;
+
+	if (venus_fw_coverage) {
+		if (venus_sys_set_coverage(hdev, venus_fw_coverage))
+			dev_warn(dev, "fw coverage msg ON failed\n");
+	}
+
+	return venus_session_cmd(inst, HFI_CMD_SYS_SESSION_END);
+}
+
+static int venus_hfi_session_abort(struct venus_inst *inst)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(inst->core);
+
+	venus_flush_debug_queue(hdev);
+
+	return venus_session_cmd(inst, HFI_CMD_SYS_SESSION_ABORT);
+}
+
+static int venus_hfi_session_flush(struct venus_inst *inst, u32 flush_mode)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(inst->core);
+	struct hfi_session_flush_pkt pkt;
+	int ret;
+
+	ret = pkt_session_flush(&pkt, inst, flush_mode);
+	if (ret)
+		return ret;
+
+	return venus_iface_cmdq_write(hdev, &pkt);
+}
+
+static int venus_hfi_session_start(struct venus_inst *inst)
+{
+	return venus_session_cmd(inst, HFI_CMD_SESSION_START);
+}
+
+static int venus_hfi_session_stop(struct venus_inst *inst)
+{
+	return venus_session_cmd(inst, HFI_CMD_SESSION_STOP);
+}
+
+static int venus_hfi_session_continue(struct venus_inst *inst)
+{
+	return venus_session_cmd(inst, HFI_CMD_SESSION_CONTINUE);
+}
+
+static int venus_hfi_session_etb(struct venus_inst *inst,
+				 struct hfi_frame_data *in_frame)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(inst->core);
+	u32 session_type = inst->session_type;
+	int ret;
+
+	if (session_type == VIDC_SESSION_TYPE_DEC) {
+		struct hfi_session_empty_buffer_compressed_pkt pkt;
+
+		ret = pkt_session_etb_decoder(&pkt, inst, in_frame);
+		if (ret)
+			return ret;
+
+		ret = venus_iface_cmdq_write(hdev, &pkt);
+	} else if (session_type == VIDC_SESSION_TYPE_ENC) {
+		struct hfi_session_empty_buffer_uncompressed_plane0_pkt pkt;
+
+		ret = pkt_session_etb_encoder(&pkt, inst, in_frame);
+		if (ret)
+			return ret;
+
+		ret = venus_iface_cmdq_write(hdev, &pkt);
+	} else {
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int venus_hfi_session_ftb(struct venus_inst *inst,
+				 struct hfi_frame_data *out_frame)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(inst->core);
+	struct hfi_session_fill_buffer_pkt pkt;
+	int ret;
+
+	ret = pkt_session_ftb(&pkt, inst, out_frame);
+	if (ret)
+		return ret;
+
+	return venus_iface_cmdq_write(hdev, &pkt);
+}
+
+static int venus_hfi_session_set_buffers(struct venus_inst *inst,
+					 struct hfi_buffer_desc *bd)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(inst->core);
+	struct hfi_session_set_buffers_pkt *pkt;
+	u8 packet[IFACEQ_VAR_LARGE_PKT_SIZE];
+	int ret;
+
+	if (bd->buffer_type == HFI_BUFFER_INPUT)
+		return 0;
+
+	pkt = (struct hfi_session_set_buffers_pkt *)packet;
+
+	ret = pkt_session_set_buffers(pkt, inst, bd);
+	if (ret)
+		return ret;
+
+	return venus_iface_cmdq_write(hdev, pkt);
+}
+
+static int venus_hfi_session_unset_buffers(struct venus_inst *inst,
+					   struct hfi_buffer_desc *bd)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(inst->core);
+	struct hfi_session_release_buffer_pkt *pkt;
+	u8 packet[IFACEQ_VAR_LARGE_PKT_SIZE];
+	int ret;
+
+	if (bd->buffer_type == HFI_BUFFER_INPUT)
+		return 0;
+
+	pkt = (struct hfi_session_release_buffer_pkt *) packet;
+
+	ret = pkt_session_unset_buffers(pkt, inst, bd);
+	if (ret)
+		return ret;
+
+	return venus_iface_cmdq_write(hdev, pkt);
+}
+
+static int venus_hfi_session_load_res(struct venus_inst *inst)
+{
+	return venus_session_cmd(inst, HFI_CMD_SESSION_LOAD_RESOURCES);
+}
+
+static int venus_hfi_session_release_res(struct venus_inst *inst)
+{
+	return venus_session_cmd(inst, HFI_CMD_SESSION_RELEASE_RESOURCES);
+}
+
+static int venus_hfi_session_parse_seq_hdr(struct venus_inst *inst,
+					   u32 seq_hdr, u32 seq_hdr_len)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(inst->core);
+	struct hfi_session_parse_sequence_header_pkt *pkt;
+	u8 packet[IFACEQ_VAR_SMALL_PKT_SIZE];
+	int ret;
+
+	pkt = (struct hfi_session_parse_sequence_header_pkt *) packet;
+
+	ret = pkt_session_parse_seq_header(pkt, inst, seq_hdr, seq_hdr_len);
+	if (ret)
+		return ret;
+
+	ret = venus_iface_cmdq_write(hdev, pkt);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int venus_hfi_session_get_seq_hdr(struct venus_inst *inst,
+					 u32 seq_hdr, u32 seq_hdr_len)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(inst->core);
+	struct hfi_session_get_sequence_header_pkt *pkt;
+	u8 packet[IFACEQ_VAR_SMALL_PKT_SIZE];
+	int ret;
+
+	pkt = (struct hfi_session_get_sequence_header_pkt *) packet;
+
+	ret = pkt_session_get_seq_hdr(pkt, inst, seq_hdr, seq_hdr_len);
+	if (ret)
+		return ret;
+
+	return venus_iface_cmdq_write(hdev, pkt);
+}
+
+static int venus_hfi_session_set_property(struct venus_inst *inst, u32 ptype,
+					  void *pdata)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(inst->core);
+	struct hfi_session_set_property_pkt *pkt;
+	u8 packet[IFACEQ_VAR_LARGE_PKT_SIZE];
+	int ret;
+
+	pkt = (struct hfi_session_set_property_pkt *) packet;
+
+	ret = pkt_session_set_property(pkt, inst, ptype, pdata);
+	if (ret)
+		return ret;
+
+	return venus_iface_cmdq_write(hdev, pkt);
+}
+
+static int venus_hfi_session_get_property(struct venus_inst *inst, u32 ptype)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(inst->core);
+	struct hfi_session_get_property_pkt pkt;
+	int ret;
+
+	ret = pkt_session_get_property(&pkt, inst, ptype);
+	if (ret)
+		return ret;
+
+	return venus_iface_cmdq_write(hdev, &pkt);
+}
+
+static int venus_hfi_resume(struct venus_core *core)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(core);
+	int ret = 0;
+
+	mutex_lock(&hdev->lock);
+
+	if (hdev->suspended == false)
+		goto unlock;
+
+	ret = venus_power_on(hdev);
+
+unlock:
+	if (!ret)
+		hdev->suspended = false;
+
+	mutex_unlock(&hdev->lock);
+
+	return ret;
+}
+
+static int venus_hfi_suspend(struct venus_core *core)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(core);
+	struct device *dev = core->dev;
+	u32 ctrl_status;
+	int ret;
+
+	if (!hdev->power_enabled || hdev->suspended)
+		return 0;
+
+	mutex_lock(&hdev->lock);
+	ret = venus_is_valid_state(hdev);
+	mutex_unlock(&hdev->lock);
+
+	if (!ret) {
+		dev_err(dev, "bad state, cannot suspend\n");
+		return -EINVAL;
+	}
+
+	ret = venus_prepare_power_collapse(hdev);
+	if (ret) {
+		dev_err(dev, "prepare for power collapse fail (%d)\n", ret);
+		return ret;
+	}
+
+	mutex_lock(&hdev->lock);
+
+	if (hdev->last_packet_type != HFI_CMD_SYS_PC_PREP) {
+		mutex_unlock(&hdev->lock);
+		return -EINVAL;
+	}
+
+	ret = venus_are_queues_empty(hdev);
+	if (ret < 0 || !ret) {
+		mutex_unlock(&hdev->lock);
+		return -EINVAL;
+	}
+
+	ctrl_status = venus_readl(hdev, CPU_CS_SCIACMDARG0);
+	if (!(ctrl_status & CPU_CS_SCIACMDARG0_PC_READY)) {
+		mutex_unlock(&hdev->lock);
+		return -EINVAL;
+	}
+
+	ret = venus_power_off(hdev);
+	if (ret) {
+		mutex_unlock(&hdev->lock);
+		return ret;
+	}
+
+	hdev->suspended = true;
+
+	mutex_unlock(&hdev->lock);
+
+	return 0;
+}
+
+static const struct hfi_ops venus_hfi_ops = {
+	.core_init			= venus_hfi_core_init,
+	.core_deinit			= venus_hfi_core_deinit,
+	.core_ping			= venus_hfi_core_ping,
+	.core_trigger_ssr		= venus_hfi_core_trigger_ssr,
+
+	.session_init			= venus_hfi_session_init,
+	.session_end			= venus_hfi_session_end,
+	.session_abort			= venus_hfi_session_abort,
+	.session_flush			= venus_hfi_session_flush,
+	.session_start			= venus_hfi_session_start,
+	.session_stop			= venus_hfi_session_stop,
+	.session_continue		= venus_hfi_session_continue,
+	.session_etb			= venus_hfi_session_etb,
+	.session_ftb			= venus_hfi_session_ftb,
+	.session_set_buffers		= venus_hfi_session_set_buffers,
+	.session_unset_buffers		= venus_hfi_session_unset_buffers,
+	.session_load_res		= venus_hfi_session_load_res,
+	.session_release_res		= venus_hfi_session_release_res,
+	.session_parse_seq_hdr		= venus_hfi_session_parse_seq_hdr,
+	.session_get_seq_hdr		= venus_hfi_session_get_seq_hdr,
+	.session_set_property		= venus_hfi_session_set_property,
+	.session_get_property		= venus_hfi_session_get_property,
+
+	.resume				= venus_hfi_resume,
+	.suspend			= venus_hfi_suspend,
+
+	.isr				= venus_isr,
+	.isr_thread			= venus_isr_thread,
+};
+
+void venus_hfi_destroy(struct venus_core *core)
+{
+	struct venus_hfi_device *hdev = to_hfi_priv(core);
+
+	venus_interface_queues_release(hdev);
+	mutex_destroy(&hdev->lock);
+	kfree(hdev);
+}
+
+int venus_hfi_create(struct venus_core *core)
+{
+	struct venus_hfi_device *hdev;
+	int ret;
+
+	hdev = kzalloc(sizeof(*hdev), GFP_KERNEL);
+	if (!hdev)
+		return -ENOMEM;
+
+	mutex_init(&hdev->lock);
+
+	hdev->core = core;
+	hdev->suspended = true;
+	core->priv = hdev;
+	core->ops = &venus_hfi_ops;
+	core->core_caps = ENC_ROTATION_CAPABILITY | ENC_SCALING_CAPABILITY |
+			  ENC_DEINTERLACE_CAPABILITY |
+			  DEC_MULTI_STREAM_CAPABILITY;
+
+	ret = venus_interface_queues_init(hdev);
+	if (ret)
+		goto err_kfree;
+
+	return 0;
+
+err_kfree:
+	kfree(hdev);
+	core->priv = NULL;
+	core->ops = NULL;
+	return ret;
+}
diff --git a/drivers/media/platform/qcom/venus/hfi_venus.h b/drivers/media/platform/qcom/venus/hfi_venus.h
new file mode 100644
index 000000000000..d6b7ed18d4e7
--- /dev/null
+++ b/drivers/media/platform/qcom/venus/hfi_venus.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright (c) 2012-2015, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2016 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#ifndef __VENUS_HFI_VENUS_H__
+#define __VENUS_HFI_VENUS_H__
+
+struct venus_core;
+
+void venus_hfi_destroy(struct venus_core *core);
+int venus_hfi_create(struct venus_core *core);
+
+#endif
diff --git a/drivers/media/platform/qcom/venus/hfi_venus_io.h b/drivers/media/platform/qcom/venus/hfi_venus_io.h
new file mode 100644
index 000000000000..6889251ddc28
--- /dev/null
+++ b/drivers/media/platform/qcom/venus/hfi_venus_io.h
@@ -0,0 +1,98 @@
+/*
+ * Copyright (c) 2012-2014, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2016 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#ifndef __VENUS_HFI_VENUS_IO_H__
+#define __VENUS_HFI_VENUS_IO_H__
+
+#define VBIF_BASE				0x80000
+
+#define VBIF_AXI_HALT_CTRL0			(VBIF_BASE + 0x208)
+#define VBIF_AXI_HALT_CTRL1			(VBIF_BASE + 0x20c)
+
+#define VBIF_AXI_HALT_CTRL0_HALT_REQ		BIT(0)
+#define VBIF_AXI_HALT_CTRL1_HALT_ACK		BIT(0)
+#define VBIF_AXI_HALT_ACK_TIMEOUT_US		500000
+
+#define CPU_BASE				0xc0000
+#define CPU_CS_BASE				(CPU_BASE + 0x12000)
+#define CPU_IC_BASE				(CPU_BASE + 0x1f000)
+
+#define CPU_CS_A2HSOFTINTCLR			(CPU_CS_BASE + 0x1c)
+
+#define VIDC_CTRL_INIT				(CPU_CS_BASE + 0x48)
+#define VIDC_CTRL_INIT_RESERVED_BITS31_1_MASK	0xfffffffe
+#define VIDC_CTRL_INIT_RESERVED_BITS31_1_SHIFT	1
+#define VIDC_CTRL_INIT_CTRL_MASK		0x1
+#define VIDC_CTRL_INIT_CTRL_SHIFT		0
+
+/* HFI control status */
+#define CPU_CS_SCIACMDARG0			(CPU_CS_BASE + 0x4c)
+#define CPU_CS_SCIACMDARG0_MASK			0xff
+#define CPU_CS_SCIACMDARG0_SHIFT		0x0
+#define CPU_CS_SCIACMDARG0_ERROR_STATUS_MASK	0xfe
+#define CPU_CS_SCIACMDARG0_ERROR_STATUS_SHIFT	0x1
+#define CPU_CS_SCIACMDARG0_INIT_STATUS_MASK	0x1
+#define CPU_CS_SCIACMDARG0_INIT_STATUS_SHIFT	0x0
+#define CPU_CS_SCIACMDARG0_PC_READY		0x100
+#define CPU_CS_SCIACMDARG0_INIT_IDLE_MSG_MASK	0x40000000
+
+/* HFI queue table info */
+#define CPU_CS_SCIACMDARG1			(CPU_CS_BASE + 0x50)
+
+/* HFI queue table address */
+#define CPU_CS_SCIACMDARG2			(CPU_CS_BASE + 0x54)
+
+/* Venus cpu */
+#define CPU_CS_SCIACMDARG3			(CPU_CS_BASE + 0x58)
+
+#define SFR_ADDR				(CPU_CS_BASE + 0x5c)
+#define MMAP_ADDR				(CPU_CS_BASE + 0x60)
+#define UC_REGION_ADDR				(CPU_CS_BASE + 0x64)
+#define UC_REGION_SIZE				(CPU_CS_BASE + 0x68)
+
+#define CPU_IC_SOFTINT				(CPU_IC_BASE + 0x18)
+#define CPU_IC_SOFTINT_H2A_MASK			0x8000
+#define CPU_IC_SOFTINT_H2A_SHIFT		0xf
+
+/* Venus wrapper */
+#define WRAPPER_BASE				0x000e0000
+
+#define WRAPPER_HW_VERSION			(WRAPPER_BASE + 0x00)
+#define WRAPPER_HW_VERSION_MAJOR_VERSION_MASK	0x78000000
+#define WRAPPER_HW_VERSION_MAJOR_VERSION_SHIFT	28
+#define WRAPPER_HW_VERSION_MINOR_VERSION_MASK	0xfff0000
+#define WRAPPER_HW_VERSION_MINOR_VERSION_SHIFT	16
+#define WRAPPER_HW_VERSION_STEP_VERSION_MASK	0xffff
+
+#define WRAPPER_INTR_STATUS			(WRAPPER_BASE + 0x0c)
+#define WRAPPER_INTR_STATUS_A2HWD_MASK		0x10
+#define WRAPPER_INTR_STATUS_A2HWD_SHIFT		0x4
+#define WRAPPER_INTR_STATUS_A2H_MASK		0x4
+#define WRAPPER_INTR_STATUS_A2H_SHIFT		0x2
+
+#define WRAPPER_INTR_MASK			(WRAPPER_BASE + 0x10)
+#define WRAPPER_INTR_MASK_A2HWD_BASK		0x10
+#define WRAPPER_INTR_MASK_A2HWD_SHIFT		0x4
+#define WRAPPER_INTR_MASK_A2HVCODEC_MASK	0x8
+#define WRAPPER_INTR_MASK_A2HVCODEC_SHIFT	0x3
+#define WRAPPER_INTR_MASK_A2HCPU_MASK		0x4
+#define WRAPPER_INTR_MASK_A2HCPU_SHIFT		0x2
+
+#define WRAPPER_INTR_CLEAR			(WRAPPER_BASE + 0x14)
+#define WRAPPER_INTR_CLEAR_A2HWD_MASK		0x10
+#define WRAPPER_INTR_CLEAR_A2HWD_SHIFT		0x4
+#define WRAPPER_INTR_CLEAR_A2H_MASK		0x4
+#define WRAPPER_INTR_CLEAR_A2H_SHIFT		0x2
+
+#endif
-- 
2.7.4

