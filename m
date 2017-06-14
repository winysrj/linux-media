Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:4599 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752595AbdFNWU0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 18:20:26 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com,
        Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v2 09/12] intel-ipu3: css hardware setup
Date: Wed, 14 Jun 2017 17:19:24 -0500
Message-Id: <1497478767-10270-10-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1497478767-10270-1-git-send-email-yong.zhi@intel.com>
References: <1497478767-10270-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
 drivers/media/pci/intel/ipu3/ipu3-css.c | 515 ++++++++++++++++++++++++++++++++
 drivers/media/pci/intel/ipu3/ipu3-css.h |   5 +
 2 files changed, 520 insertions(+)
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css.c

diff --git a/drivers/media/pci/intel/ipu3/ipu3-css.c b/drivers/media/pci/intel/ipu3/ipu3-css.c
new file mode 100644
index 0000000..675be91
--- /dev/null
+++ b/drivers/media/pci/intel/ipu3/ipu3-css.c
@@ -0,0 +1,515 @@
+/*
+ * Copyright (c) 2017 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include "ipu3-css.h"
+#include "ipu3-css-fw.h"
+#include "ipu3-tables.h"
+
+/* IRQ configuration */
+#define IMGU_IRQCTRL_IRQ_MASK	(IMGU_IRQCTRL_IRQ_SP1 | \
+				 IMGU_IRQCTRL_IRQ_SP2 | \
+				 IMGU_IRQCTRL_IRQ_SW_PIN(0) | \
+				 IMGU_IRQCTRL_IRQ_SW_PIN(1))
+
+static void writes(void *mem, ssize_t len, void __iomem *reg)
+{
+	while (len >= 4) {
+		writel(*(u32 *)mem, reg);
+		mem += 4;
+		reg += 4;
+		len -= 4;
+	}
+}
+
+/******************* css hw *******************/
+
+/* Wait until register `reg', masked with `mask', becomes `cmp' */
+static int ipu3_css_hw_wait(struct ipu3_css *css, int reg, u32 mask, u32 cmp)
+{
+	static const unsigned int delay = 1000;
+	unsigned int maxloops = 1000000 / 10 / delay;
+
+	do {
+		if ((readl(css->base + reg) & mask) == cmp)
+			return 0;
+		usleep_range(delay, 2 * delay);
+	} while (--maxloops);
+
+	return -EIO;
+}
+
+/* Initialize the IPU3 CSS hardware and associated h/w blocks */
+
+int ipu3_css_set_powerup(struct ipu3_css *css)
+{
+	struct device *dev = css->dev;
+	void __iomem *const base = css->base;
+	u32 pm_ctrl, state;
+
+	/* Clear the CSS busy signal */
+	readl(base + IMGU_REG_GP_BUSY);
+	writel(0, base + IMGU_REG_GP_BUSY);
+
+	/* Wait for idle signal */
+	if (ipu3_css_hw_wait(css, IMGU_REG_STATE, IMGU_STATE_IDLE_STS,
+						IMGU_STATE_IDLE_STS))
+		dev_warn(dev, "failed to set CSS idle\n");
+
+	/* Reset the css */
+	writel(readl(base + IMGU_REG_PM_CTRL) | IMGU_PM_CTRL_FORCE_RESET,
+		base + IMGU_REG_PM_CTRL);
+
+	usleep_range(200, 300);
+
+	/** Prepare CSS */
+
+	pm_ctrl = readl(base + IMGU_REG_PM_CTRL);
+	state = readl(base + IMGU_REG_STATE);
+
+	dev_dbg(dev, "CSS pm_ctrl 0x%x state 0x%x (power %s)\n",
+		pm_ctrl, state, state & IMGU_STATE_POWER_DOWN ? "down" : "up");
+
+	/* Power up CSS using wrapper */
+	if (state & IMGU_STATE_POWER_DOWN) {
+		writel(IMGU_PM_CTRL_RACE_TO_HALT | IMGU_PM_CTRL_START,
+			base + IMGU_REG_PM_CTRL);
+		if (ipu3_css_hw_wait(css, IMGU_REG_PM_CTRL,
+					IMGU_PM_CTRL_START, 0))
+			dev_warn(dev, "failed to power up CSS\n");
+		usleep_range(2000, 3000);
+	} else {
+		writel(IMGU_PM_CTRL_RACE_TO_HALT, base + IMGU_REG_PM_CTRL);
+	}
+
+	/* Set the busy bit */
+	writel(readl(base + IMGU_REG_GP_BUSY) | 1, base + IMGU_REG_GP_BUSY);
+
+	return 0;
+}
+
+int ipu3_css_set_powerdown(struct ipu3_css *css)
+{
+	struct device *dev = css->dev;
+	void __iomem *const base = css->base;
+
+	/* Clear the CSS busy signal */
+	readl(base + IMGU_REG_GP_BUSY);
+	writel(0, base + IMGU_REG_GP_BUSY);
+
+	/* Wait for idle signal */
+	if (ipu3_css_hw_wait(css, IMGU_REG_STATE, IMGU_STATE_IDLE_STS,
+						IMGU_STATE_IDLE_STS))
+		dev_warn(dev, "failed to set CSS idle\n");
+
+	/* Reset the css */
+	writel(readl(base + IMGU_REG_PM_CTRL) | IMGU_PM_CTRL_CSS_PWRDN,
+		base + IMGU_REG_PM_CTRL);
+
+	return 0;
+}
+
+static int ipu3_css_hw_init(struct ipu3_css *css)
+{
+	/* For checking that streaming monitor statuses are valid */
+	static const struct {
+		u32 reg;
+		u32 mask;
+		const char *name;
+	} stream_monitors[] = {
+		{
+			IMGU_REG_GP_SP1_STRMON_STAT,
+			IMGU_GP_STRMON_STAT_ISP_PORT_SP12ISP,
+			"ISP0 to SP0"
+		}, {
+			IMGU_REG_GP_ISP_STRMON_STAT,
+			IMGU_GP_STRMON_STAT_SP1_PORT_ISP2SP1,
+			"SP0 to ISP0"
+		}, {
+			IMGU_REG_GP_MOD_STRMON_STAT,
+			IMGU_GP_STRMON_STAT_MOD_PORT_ISP2DMA,
+			"ISP0 to DMA0"
+		}, {
+			IMGU_REG_GP_ISP_STRMON_STAT,
+			IMGU_GP_STRMON_STAT_ISP_PORT_DMA2ISP,
+			"DMA0 to ISP0"
+		}, {
+			IMGU_REG_GP_MOD_STRMON_STAT,
+			IMGU_GP_STRMON_STAT_MOD_PORT_CELLS2GDC,
+			"ISP0 to GDC0"
+		}, {
+			IMGU_REG_GP_MOD_STRMON_STAT,
+			IMGU_GP_STRMON_STAT_MOD_PORT_GDC2CELLS,
+			"GDC0 to ISP0"
+		}, {
+			IMGU_REG_GP_MOD_STRMON_STAT,
+			IMGU_GP_STRMON_STAT_MOD_PORT_SP12DMA,
+			"SP0 to DMA0"
+		}, {
+			IMGU_REG_GP_SP1_STRMON_STAT,
+			IMGU_GP_STRMON_STAT_SP1_PORT_DMA2SP1,
+			"DMA0 to SP0"
+		}, {
+			IMGU_REG_GP_MOD_STRMON_STAT,
+			IMGU_GP_STRMON_STAT_MOD_PORT_CELLS2GDC,
+			"SP0 to GDC0"
+		}, {
+			IMGU_REG_GP_MOD_STRMON_STAT,
+			IMGU_GP_STRMON_STAT_MOD_PORT_GDC2CELLS,
+			"GDC0 to SP0"
+		},
+	};
+
+	static const unsigned int freq = 320;
+	struct device *dev = css->dev;
+	void __iomem *const base = css->base;
+	u32 pm_ctrl, val, i;
+
+	/* Set CSS clock frequency */
+
+	pm_ctrl = readl(base + IMGU_REG_PM_CTRL);
+	val = pm_ctrl & ~(IMGU_PM_CTRL_CSS_PWRDN | IMGU_PM_CTRL_RST_AT_EOF);
+	writel(val, base + IMGU_REG_PM_CTRL);
+	writel(0, base + IMGU_REG_GP_BUSY);
+	if (ipu3_css_hw_wait(css, IMGU_REG_STATE,
+				IMGU_STATE_PWRDNM_FSM_MASK, 0))
+		dev_err(dev, "failed to pwrdn CSS\n");
+	val = (freq / IMGU_SYSTEM_REQ_FREQ_DIVIDER) & IMGU_SYSTEM_REQ_FREQ_MASK;
+	writel(val, base + IMGU_REG_SYSTEM_REQ);
+	writel(1, base + IMGU_REG_GP_BUSY);
+	writel(readl(base + IMGU_REG_PM_CTRL) | IMGU_PM_CTRL_FORCE_HALT,
+		base + IMGU_REG_PM_CTRL);
+	if (ipu3_css_hw_wait(css, IMGU_REG_STATE, IMGU_STATE_HALT_STS,
+				IMGU_STATE_HALT_STS))
+		dev_err(dev, "failed to halt CSS\n");
+
+	writel(readl(base + IMGU_REG_PM_CTRL) | IMGU_PM_CTRL_START,
+		base + IMGU_REG_PM_CTRL);
+	if (ipu3_css_hw_wait(css, IMGU_REG_PM_CTRL, IMGU_PM_CTRL_START, 0))
+		dev_err(dev, "failed to start CSS\n");
+	writel(readl(base + IMGU_REG_PM_CTRL) | IMGU_PM_CTRL_FORCE_UNHALT,
+		base + IMGU_REG_PM_CTRL);
+
+	val = readl(base + IMGU_REG_PM_CTRL);	/* get pm_ctrl */
+	val &= ~(IMGU_PM_CTRL_CSS_PWRDN | IMGU_PM_CTRL_RST_AT_EOF);
+	val |= pm_ctrl & (IMGU_PM_CTRL_CSS_PWRDN | IMGU_PM_CTRL_RST_AT_EOF);
+	writel(val, base + IMGU_REG_PM_CTRL);
+
+	/* Set MMU L1 table address and flush TLB */
+
+	writel(css->mmu_l1_addr >> IMGU_MMU_PADDR_SHIFT,
+		base + IMGU_REG_L1_PHYS);
+
+	/* Set up interrupts */
+
+	/*
+	 * Enable IRQ on the SP which signals that SP goes to idle
+	 * (aka ready state) and set trigger to pulse
+	 */
+	val = readl(base + IMGU_REG_SP_CTRL(0)) | IMGU_CTRL_IRQ_READY;
+	writel(val, base + IMGU_REG_SP_CTRL(0));
+	writel(val | IMGU_CTRL_IRQ_CLEAR, base + IMGU_REG_SP_CTRL(0));
+
+	/* Enable IRQs from the IMGU wrapper */
+	writel(IMGU_REG_INT_CSS_IRQ, base + IMGU_REG_INT_ENABLE);
+	/* Clear */
+	writel(IMGU_REG_INT_CSS_IRQ, base + IMGU_REG_INT_STATUS);
+
+	/* Enable IRQs from main IRQ controller */
+	writel(~0, base + IMGU_REG_IRQCTRL_EDGE_NOT_PULSE(IMGU_IRQCTRL_MAIN));
+	writel(0, base + IMGU_REG_IRQCTRL_MASK(IMGU_IRQCTRL_MAIN));
+	writel(IMGU_IRQCTRL_IRQ_MASK,
+		base + IMGU_REG_IRQCTRL_EDGE(IMGU_IRQCTRL_MAIN));
+	writel(IMGU_IRQCTRL_IRQ_MASK,
+		base + IMGU_REG_IRQCTRL_ENABLE(IMGU_IRQCTRL_MAIN));
+	writel(IMGU_IRQCTRL_IRQ_MASK,
+		base + IMGU_REG_IRQCTRL_CLEAR(IMGU_IRQCTRL_MAIN));
+	writel(IMGU_IRQCTRL_IRQ_MASK,
+		base + IMGU_REG_IRQCTRL_MASK(IMGU_IRQCTRL_MAIN));
+	/* Wait for write complete */
+	readl(base + IMGU_REG_IRQCTRL_ENABLE(IMGU_IRQCTRL_MAIN));
+
+	/* Enable IRQs from SP0 and SP1 controllers */
+	for (i = IMGU_IRQCTRL_SP0; i <= IMGU_IRQCTRL_SP1; i++) {
+		writel(~0, base + IMGU_REG_IRQCTRL_EDGE_NOT_PULSE(i));
+		writel(0, base + IMGU_REG_IRQCTRL_MASK(i));
+		writel(IMGU_IRQCTRL_IRQ_MASK, base + IMGU_REG_IRQCTRL_EDGE(i));
+		writel(IMGU_IRQCTRL_IRQ_MASK,
+			base + IMGU_REG_IRQCTRL_ENABLE(i));
+		writel(IMGU_IRQCTRL_IRQ_MASK, base + IMGU_REG_IRQCTRL_CLEAR(i));
+		writel(IMGU_IRQCTRL_IRQ_MASK, base + IMGU_REG_IRQCTRL_MASK(i));
+		/* Wait for write complete */
+		readl(base + IMGU_REG_IRQCTRL_ENABLE(i));
+	}
+
+	/* Set instruction cache address and inv bit for ISP, SP, and SP1 */
+	for (i = 0; i < IMGU_NUM_SP; i++) {
+		struct imgu_fw_info *bi =
+			&css->fwp->binary_header[css->fw_sp[i]];
+
+		writel(css->binary[css->fw_sp[i]].daddr,
+			base + IMGU_REG_SP_ICACHE_ADDR(bi->type));
+		writel(readl(base + IMGU_REG_SP_CTRL(bi->type)) |
+			IMGU_CTRL_ICACHE_INV,
+			base + IMGU_REG_SP_CTRL(bi->type));
+	}
+	writel(css->binary[css->fw_bl].daddr, base + IMGU_REG_ISP_ICACHE_ADDR);
+	writel(readl(base + IMGU_REG_ISP_CTRL) | IMGU_CTRL_ICACHE_INV,
+		base + IMGU_REG_ISP_CTRL);
+
+	/* Check that IMGU hardware is ready */
+
+	if (!(readl(base + IMGU_REG_SP_CTRL(0)) & IMGU_CTRL_IDLE)) {
+		dev_err(dev, "SP is not idle\n");
+		return -EIO;
+	}
+	if (!(readl(base + IMGU_REG_ISP_CTRL) & IMGU_CTRL_IDLE)) {
+		dev_err(dev, "ISP is not idle\n");
+		return -EIO;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(stream_monitors); i++) {
+		val = readl(base + stream_monitors[i].reg);
+		if (val & stream_monitors[i].mask) {
+			dev_err(dev, "error: Stream monitor %s is valid\n",
+				stream_monitors[i].name);
+			return -EIO;
+		}
+	}
+
+	/* Initialize GDC with default values */
+
+	for (i = 0; i < ARRAY_SIZE(ipu3_css_gdc_lut[0]); i++) {
+		u32 val0 = ipu3_css_gdc_lut[0][i] & IMGU_GDC_LUT_MASK;
+		u32 val1 = ipu3_css_gdc_lut[1][i] & IMGU_GDC_LUT_MASK;
+		u32 val2 = ipu3_css_gdc_lut[2][i] & IMGU_GDC_LUT_MASK;
+		u32 val3 = ipu3_css_gdc_lut[3][i] & IMGU_GDC_LUT_MASK;
+
+		writel(val0 | (val1 << 16),
+			base + IMGU_REG_GDC_LUT_BASE + i * 8);
+		writel(val2 | (val3 << 16),
+			base + IMGU_REG_GDC_LUT_BASE + i * 8 + 4);
+	};
+
+	return 0;
+}
+
+/* Boot the given IPU3 CSS SP */
+static int ipu3_css_hw_start_sp(struct ipu3_css *css, int sp)
+{
+	void __iomem *const base = css->base;
+	struct imgu_fw_info *bi = &css->fwp->binary_header[css->fw_sp[sp]];
+	struct imgu_abi_sp_init_dmem_cfg dmem_cfg = {
+		.ddr_data_addr = css->binary[css->fw_sp[sp]].daddr
+			+ bi->blob.data_source,
+		.dmem_data_addr = bi->blob.data_target,
+		.dmem_bss_addr = bi->blob.bss_target,
+		.data_size = bi->blob.data_size,
+		.bss_size = bi->blob.bss_size,
+		.sp_id = sp,
+	};
+
+	writes(&dmem_cfg, sizeof(dmem_cfg), base +
+		IMGU_REG_SP_DMEM_BASE(sp) + bi->info.sp.init_dmem_data);
+
+	writel(bi->info.sp.sp_entry, base + IMGU_REG_SP_START_ADDR(sp));
+
+	writel(readl(base + IMGU_REG_SP_CTRL(sp))
+		| IMGU_CTRL_START | IMGU_CTRL_RUN, base + IMGU_REG_SP_CTRL(sp));
+
+	if (ipu3_css_hw_wait(css, IMGU_REG_SP_DMEM_BASE(sp)
+				+ bi->info.sp.sw_state,
+				~0, IMGU_ABI_SP_SWSTATE_INITIALIZED))
+		return -EIO;
+
+	return 0;
+}
+
+/* Start the IPU3 CSS ImgU (Imaging Unit) and all the SPs */
+static int ipu3_css_hw_start(struct ipu3_css *css)
+{
+	static const u32 event_mask =
+		((1 << IMGU_ABI_EVTTYPE_OUT_FRAME_DONE) |
+		(1 << IMGU_ABI_EVTTYPE_2ND_OUT_FRAME_DONE) |
+		(1 << IMGU_ABI_EVTTYPE_VF_OUT_FRAME_DONE) |
+		(1 << IMGU_ABI_EVTTYPE_2ND_VF_OUT_FRAME_DONE) |
+		(1 << IMGU_ABI_EVTTYPE_3A_STATS_DONE) |
+		(1 << IMGU_ABI_EVTTYPE_DIS_STATS_DONE) |
+		(1 << IMGU_ABI_EVTTYPE_PIPELINE_DONE) |
+		(1 << IMGU_ABI_EVTTYPE_FRAME_TAGGED) |
+		(1 << IMGU_ABI_EVTTYPE_INPUT_FRAME_DONE) |
+		(1 << IMGU_ABI_EVTTYPE_METADATA_DONE) |
+		(1 << IMGU_ABI_EVTTYPE_LACE_STATS_DONE) |
+		(1 << IMGU_ABI_EVTTYPE_ACC_STAGE_COMPLETE))
+		<< IMGU_ABI_SP_COMM_EVENT_IRQ_MASK_OR_SHIFT;
+
+	void __iomem *const base = css->base;
+	struct imgu_fw_info *bi, *bl = &css->fwp->binary_header[css->fw_bl];
+	unsigned int i;
+
+	writel(IMGU_TLB_INVALIDATE, base + IMGU_REG_TLB_INVALIDATE);
+
+	/* Start bootloader */
+
+	writel(IMGU_ABI_BL_SWSTATE_BUSY,
+		base + IMGU_REG_ISP_DMEM_BASE + bl->info.bl.sw_state);
+	writel(IMGU_NUM_SP,
+		base + IMGU_REG_ISP_DMEM_BASE + bl->info.bl.num_dma_cmds);
+
+	for (i = 0; i < IMGU_NUM_SP; i++) {
+		int j = IMGU_NUM_SP - i - 1;	/* load sp1 first, then sp0 */
+		struct imgu_fw_info *sp =
+			&css->fwp->binary_header[css->fw_sp[j]];
+		struct imgu_abi_bl_dma_cmd_entry dma_cmd = {
+			.src_addr = css->binary[css->fw_sp[j]].daddr
+				+ sp->blob.text_source,
+			.size = sp->blob.text_size,
+			.dst_type = IMGU_ABI_BL_DMACMD_TYPE_SP_PMEM,
+			.dst_addr = IMGU_SP_PMEM_BASE(j),
+		};
+
+		writes(&dma_cmd, sizeof(dma_cmd),
+			base + IMGU_REG_ISP_DMEM_BASE + i * sizeof(dma_cmd) +
+			bl->info.bl.dma_cmd_list);
+	}
+
+	writel(bl->info.bl.bl_entry, base + IMGU_REG_ISP_START_ADDR);
+
+	writel(readl(base + IMGU_REG_ISP_CTRL)
+		| IMGU_CTRL_START | IMGU_CTRL_RUN, base + IMGU_REG_ISP_CTRL);
+	if (ipu3_css_hw_wait(css, IMGU_REG_ISP_DMEM_BASE + bl->info.bl.sw_state,
+				~0, IMGU_ABI_BL_SWSTATE_OK)) {
+		dev_err(css->dev, "failed to start bootloader\n");
+		return -EIO;
+	}
+
+	/* Start ISP */
+
+	memset(css->xmem_sp_group_ptrs.vaddr, 0,
+		sizeof(struct imgu_abi_sp_group));
+	dma_sync_single_for_device(css->dev,
+		css->xmem_sp_group_ptrs.daddr,
+		sizeof(struct imgu_abi_sp_group), DMA_TO_DEVICE);
+
+	bi = &css->fwp->binary_header[css->fw_sp[0]];
+
+	writel(css->xmem_sp_group_ptrs.daddr,
+		base + IMGU_REG_SP_DMEM_BASE(0) + bi->info.sp.per_frame_data);
+
+	writel(IMGU_ABI_SP_SWSTATE_TERMINATED,
+		base + IMGU_REG_SP_DMEM_BASE(0) + bi->info.sp.sw_state);
+	writel(1, base + IMGU_REG_SP_DMEM_BASE(0) + bi->info.sp.invalidate_tlb);
+
+	if (ipu3_css_hw_start_sp(css, 0))
+		return -EIO;
+
+	writel(0, base + IMGU_REG_SP_DMEM_BASE(0) + bi->info.sp.isp_started);
+	writel(0, base + IMGU_REG_SP_DMEM_BASE(0) +
+		bi->info.sp.host_sp_queues_initialized);
+	writel(0, base + IMGU_REG_SP_DMEM_BASE(0) + bi->info.sp.sleep_mode);
+	writel(0, base + IMGU_REG_SP_DMEM_BASE(0) + bi->info.sp.invalidate_tlb);
+	writel(IMGU_ABI_SP_COMM_COMMAND_READY, base + IMGU_REG_SP_DMEM_BASE(0)
+		+ bi->info.sp.host_sp_com + IMGU_ABI_SP_COMM_COMMAND);
+
+	/* Enable all events for all queues */
+
+	for (i = 0; i < IPU3_CSS_PIPE_ID_NUM; i++)
+		writel(event_mask, base + IMGU_REG_SP_DMEM_BASE(0)
+			+ bi->info.sp.host_sp_com
+			+ IMGU_ABI_SP_COMM_EVENT_IRQ_MASK(i));
+	writel(1, base + IMGU_REG_SP_DMEM_BASE(0) +
+		bi->info.sp.host_sp_queues_initialized);
+
+	/* Start SP1 */
+
+	bi = &css->fwp->binary_header[css->fw_sp[1]];
+
+	writel(IMGU_ABI_SP_SWSTATE_TERMINATED,
+		base + IMGU_REG_SP_DMEM_BASE(1) + bi->info.sp.sw_state);
+
+	if (ipu3_css_hw_start_sp(css, 1))
+		return -EIO;
+
+	writel(IMGU_ABI_SP_COMM_COMMAND_READY, base + IMGU_REG_SP_DMEM_BASE(1)
+		+ bi->info.sp.host_sp_com + IMGU_ABI_SP_COMM_COMMAND);
+
+	return 0;
+}
+
+static void ipu3_css_hw_cleanup(struct ipu3_css *css)
+{
+	void __iomem *const base = css->base;
+
+	/** Reset CSS **/
+
+	/* Clear the CSS busy signal */
+	readl(base + IMGU_REG_GP_BUSY);
+	writel(0, base + IMGU_REG_GP_BUSY);
+
+	/* Wait for idle signal */
+	if (ipu3_css_hw_wait(css, IMGU_REG_STATE, IMGU_STATE_IDLE_STS,
+				IMGU_STATE_IDLE_STS))
+		dev_err(css->dev, "failed to shut down hw cleanly\n");
+
+	/* Reset the css */
+	writel(readl(base + IMGU_REG_PM_CTRL) | IMGU_PM_CTRL_FORCE_RESET,
+		base + IMGU_REG_PM_CTRL);
+
+	usleep_range(200, 300);
+}
+
+int ipu3_css_irq_ack(struct ipu3_css *css)
+{
+	static const int NUM_SWIRQS = 3;
+	struct imgu_fw_info *bi = &css->fwp->binary_header[css->fw_sp[0]];
+	void __iomem *const base = css->base;
+	u32 irq_status[IMGU_IRQCTRL_NUM];
+	int i;
+
+	u32 imgu_status = readl(base + IMGU_REG_INT_STATUS);
+
+	for (i = 0; i < IMGU_IRQCTRL_NUM; i++)
+		irq_status[i] = readl(base + IMGU_REG_IRQCTRL_STATUS(i));
+
+	for (i = 0; i < NUM_SWIRQS; i++) {
+		if (irq_status[IMGU_IRQCTRL_SP0] & IMGU_IRQCTRL_IRQ_SW_PIN(i)) {
+			/* SP SW interrupt */
+			u32 cnt = readl(base + IMGU_REG_SP_DMEM_BASE(0) +
+					bi->info.sp.output);
+			u32 val = readl(base + IMGU_REG_SP_DMEM_BASE(0) +
+					bi->info.sp.output + 4 + 4 * i);
+
+			dev_dbg(css->dev, "%s: swirq %i cnt %i val 0x%x\n",
+				 __func__, i, cnt, val);
+		}
+	}
+
+	for (i = IMGU_IRQCTRL_NUM - 1; i >= 0; i--)
+		if (irq_status[i]) {
+			writel(irq_status[i], base + IMGU_REG_IRQCTRL_CLEAR(i));
+			/* Wait for write to complete */
+			readl(base + IMGU_REG_IRQCTRL_ENABLE(i));
+		}
+	writel(imgu_status, base + IMGU_REG_INT_STATUS);
+
+	dev_dbg(css->dev, "%s: imgu 0x%x main 0x%x sp0 0x%x sp1 0x%x\n",
+		__func__,
+		imgu_status, irq_status[IMGU_IRQCTRL_MAIN],
+		irq_status[IMGU_IRQCTRL_SP0], irq_status[IMGU_IRQCTRL_SP1]);
+
+	if (!imgu_status && !irq_status[IMGU_IRQCTRL_MAIN])
+		return -ENOMSG;
+
+	return 0;
+}
diff --git a/drivers/media/pci/intel/ipu3/ipu3-css.h b/drivers/media/pci/intel/ipu3/ipu3-css.h
index 6416750..364d490 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-css.h
+++ b/drivers/media/pci/intel/ipu3/ipu3-css.h
@@ -143,4 +143,9 @@ struct ipu3_css {
 	struct v4l2_rect rect[IPU3_CSS_RECTS];
 };
 
+/******************* css hw *******************/
+int ipu3_css_set_powerup(struct ipu3_css *css);
+int ipu3_css_set_powerdown(struct ipu3_css *css);
+int ipu3_css_irq_ack(struct ipu3_css *css);
+
 #endif
-- 
2.7.4
