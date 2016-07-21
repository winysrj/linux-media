Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:42070 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751657AbcGUHkl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 03:40:41 -0400
From: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Yannick Fertre <yannick.fertre@st.com>,
	Hugues Fruchet <hugues.fruchet@st.com>,
	Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v3 2/3] hva: multi-format video encoder V4L2 driver
Date: Thu, 21 Jul 2016 09:40:03 +0200
Message-ID: <1469086804-21652-3-git-send-email-jean-christophe.trotin@st.com>
In-Reply-To: <1469086804-21652-1-git-send-email-jean-christophe.trotin@st.com>
References: <1469086804-21652-1-git-send-email-jean-christophe.trotin@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds V4L2 HVA (Hardware Video Accelerator) video encoder
driver for STMicroelectronics SoC. It uses the V4L2 mem2mem framework.

This patch only contains the core parts of the driver:
- the V4L2 interface with the userland (hva-v4l2.c)
- the hardware services (hva-hw.c)
- the memory management utilities (hva-mem.c)

This patch doesn't include the support of specific codec (e.g. H.264)
video encoding: this support is part of subsequent patches.

Signed-off-by: Yannick Fertre <yannick.fertre@st.com>
Signed-off-by: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
---
 drivers/media/platform/Kconfig            |   14 +
 drivers/media/platform/Makefile           |    1 +
 drivers/media/platform/sti/hva/Makefile   |    2 +
 drivers/media/platform/sti/hva/hva-hw.c   |  538 ++++++++++++
 drivers/media/platform/sti/hva/hva-hw.h   |   42 +
 drivers/media/platform/sti/hva/hva-mem.c  |   60 ++
 drivers/media/platform/sti/hva/hva-mem.h  |   36 +
 drivers/media/platform/sti/hva/hva-v4l2.c | 1289 +++++++++++++++++++++++++++++
 drivers/media/platform/sti/hva/hva.h      |  290 +++++++
 9 files changed, 2272 insertions(+)
 create mode 100644 drivers/media/platform/sti/hva/Makefile
 create mode 100644 drivers/media/platform/sti/hva/hva-hw.c
 create mode 100644 drivers/media/platform/sti/hva/hva-hw.h
 create mode 100644 drivers/media/platform/sti/hva/hva-mem.c
 create mode 100644 drivers/media/platform/sti/hva/hva-mem.h
 create mode 100644 drivers/media/platform/sti/hva/hva-v4l2.c
 create mode 100644 drivers/media/platform/sti/hva/hva.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index f25344b..d872d7b 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -257,6 +257,20 @@ config VIDEO_STI_BDISP
 	help
 	  This v4l2 mem2mem driver is a 2D blitter for STMicroelectronics SoC.
 
+config VIDEO_STI_HVA
+	tristate "STMicroelectronics HVA multi-format video encoder V4L2 driver"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on ARCH_STI || COMPILE_TEST
+	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_MEM2MEM_DEV
+	help
+	  This V4L2 driver enables HVA (Hardware Video Accelerator) multi-format
+	  video encoder of STMicroelectronics SoC, allowing hardware encoding of
+	  raw uncompressed formats in various compressed video bitstreams format.
+
+	  To compile this driver as a module, choose M here:
+	  the module will be called hva.
+
 config VIDEO_SH_VEU
 	tristate "SuperH VEU mem2mem video processing driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 21771c1..fa31ec1 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+= s5p-g2d/
 obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+= exynos-gsc/
 
 obj-$(CONFIG_VIDEO_STI_BDISP)		+= sti/bdisp/
+obj-$(CONFIG_VIDEO_STI_HVA)		+= sti/hva/
 obj-$(CONFIG_DVB_C8SECTPFE)		+= sti/c8sectpfe/
 
 obj-$(CONFIG_BLACKFIN)                  += blackfin/
diff --git a/drivers/media/platform/sti/hva/Makefile b/drivers/media/platform/sti/hva/Makefile
new file mode 100644
index 0000000..7022a33
--- /dev/null
+++ b/drivers/media/platform/sti/hva/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_VIDEO_STI_HVA) := hva.o
+hva-y := hva-v4l2.o hva-hw.o hva-mem.o
diff --git a/drivers/media/platform/sti/hva/hva-hw.c b/drivers/media/platform/sti/hva/hva-hw.c
new file mode 100644
index 0000000..6919fa2
--- /dev/null
+++ b/drivers/media/platform/sti/hva/hva-hw.c
@@ -0,0 +1,538 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2015
+ * Authors: Yannick Fertre <yannick.fertre@st.com>
+ *          Hugues Fruchet <hugues.fruchet@st.com>
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/clk.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+
+#include "hva.h"
+#include "hva-hw.h"
+
+/* HVA register offsets */
+#define HVA_HIF_REG_RST                 0x0100U
+#define HVA_HIF_REG_RST_ACK             0x0104U
+#define HVA_HIF_REG_MIF_CFG             0x0108U
+#define HVA_HIF_REG_HEC_MIF_CFG         0x010CU
+#define HVA_HIF_REG_CFL                 0x0110U
+#define HVA_HIF_FIFO_CMD                0x0114U
+#define HVA_HIF_FIFO_STS                0x0118U
+#define HVA_HIF_REG_SFL                 0x011CU
+#define HVA_HIF_REG_IT_ACK              0x0120U
+#define HVA_HIF_REG_ERR_IT_ACK          0x0124U
+#define HVA_HIF_REG_LMI_ERR             0x0128U
+#define HVA_HIF_REG_EMI_ERR             0x012CU
+#define HVA_HIF_REG_HEC_MIF_ERR         0x0130U
+#define HVA_HIF_REG_HEC_STS             0x0134U
+#define HVA_HIF_REG_HVC_STS             0x0138U
+#define HVA_HIF_REG_HJE_STS             0x013CU
+#define HVA_HIF_REG_CNT                 0x0140U
+#define HVA_HIF_REG_HEC_CHKSYN_DIS      0x0144U
+#define HVA_HIF_REG_CLK_GATING          0x0148U
+#define HVA_HIF_REG_VERSION             0x014CU
+#define HVA_HIF_REG_BSM                 0x0150U
+
+/* define value for version id register (HVA_HIF_REG_VERSION) */
+#define VERSION_ID_MASK	0x0000FFFF
+
+/* define values for BSM register (HVA_HIF_REG_BSM) */
+#define BSM_CFG_VAL1	0x0003F000
+#define BSM_CFG_VAL2	0x003F0000
+
+/* define values for memory interface register (HVA_HIF_REG_MIF_CFG) */
+#define MIF_CFG_VAL1	0x04460446
+#define MIF_CFG_VAL2	0x04460806
+#define MIF_CFG_VAL3	0x00000000
+
+/* define value for HEC memory interface register (HVA_HIF_REG_MIF_CFG) */
+#define HEC_MIF_CFG_VAL	0x000000C4
+
+/*  Bits definition for clock gating register (HVA_HIF_REG_CLK_GATING) */
+#define CLK_GATING_HVC	BIT(0)
+#define CLK_GATING_HEC	BIT(1)
+#define CLK_GATING_HJE	BIT(2)
+
+/* fix hva clock rate */
+#define CLK_RATE		300000000
+
+/* fix delay for pmruntime */
+#define AUTOSUSPEND_DELAY_MS	3
+
+/**
+ * hw encode error values
+ * NO_ERROR: Success, Task OK
+ * H264_BITSTREAM_OVERSIZE: VECH264 Bitstream size > bitstream buffer
+ * H264_FRAME_SKIPPED: VECH264 Frame skipped (refers to CPB Buffer Size)
+ * H264_SLICE_LIMIT_SIZE: VECH264 MB > slice limit size
+ * H264_MAX_SLICE_NUMBER: VECH264 max slice number reached
+ * H264_SLICE_READY: VECH264 Slice ready
+ * TASK_LIST_FULL: HVA/FPC task list full
+		   (discard latest transform command)
+ * UNKNOWN_COMMAND: Transform command not known by HVA/FPC
+ * WRONG_CODEC_OR_RESOLUTION: Wrong Codec or Resolution Selection
+ * NO_INT_COMPLETION: Time-out on interrupt completion
+ * LMI_ERR: Local Memory Interface Error
+ * EMI_ERR: External Memory Interface Error
+ * HECMI_ERR: HEC Memory Interface Error
+ */
+enum hva_hw_error {
+	NO_ERROR = 0x0,
+	H264_BITSTREAM_OVERSIZE = 0x2,
+	H264_FRAME_SKIPPED = 0x4,
+	H264_SLICE_LIMIT_SIZE = 0x5,
+	H264_MAX_SLICE_NUMBER = 0x7,
+	H264_SLICE_READY = 0x8,
+	TASK_LIST_FULL = 0xF0,
+	UNKNOWN_COMMAND = 0xF1,
+	WRONG_CODEC_OR_RESOLUTION = 0xF4,
+	NO_INT_COMPLETION = 0x100,
+	LMI_ERR = 0x101,
+	EMI_ERR = 0x102,
+	HECMI_ERR = 0x103,
+};
+
+static irqreturn_t hva_hw_its_interrupt(int irq, void *data)
+{
+	struct hva_dev *hva = data;
+
+	/* read status registers */
+	hva->sts_reg = readl_relaxed(hva->regs + HVA_HIF_FIFO_STS);
+	hva->sfl_reg = readl_relaxed(hva->regs + HVA_HIF_REG_SFL);
+
+	/* acknowledge interruption */
+	writel_relaxed(0x1, hva->regs + HVA_HIF_REG_IT_ACK);
+
+	return IRQ_WAKE_THREAD;
+}
+
+static irqreturn_t hva_hw_its_irq_thread(int irq, void *arg)
+{
+	struct hva_dev *hva = arg;
+	struct device *dev = hva_to_dev(hva);
+	u32 status = hva->sts_reg & 0xFF;
+	u8 ctx_id = 0;
+	struct hva_ctx *ctx = NULL;
+
+	dev_dbg(dev, "%s     %s: status: 0x%02x fifo level: 0x%02x\n",
+		HVA_PREFIX, __func__, hva->sts_reg & 0xFF, hva->sfl_reg & 0xF);
+
+	/*
+	 * status: task_id[31:16] client_id[15:8] status[7:0]
+	 * the context identifier is retrieved from the client identifier
+	 */
+	ctx_id = (hva->sts_reg & 0xFF00) >> 8;
+	if (ctx_id >= HVA_MAX_INSTANCES) {
+		dev_err(dev, "%s     %s: bad context identifier: %d\n",
+			ctx->name, __func__, ctx_id);
+		ctx->hw_err = true;
+		goto out;
+	}
+
+	ctx = hva->instances[ctx_id];
+	if (!ctx)
+		goto out;
+
+	switch (status) {
+	case NO_ERROR:
+		dev_dbg(dev, "%s     %s: no error\n",
+			ctx->name, __func__);
+		ctx->hw_err = false;
+		break;
+	case H264_SLICE_READY:
+		dev_dbg(dev, "%s     %s: h264 slice ready\n",
+			ctx->name, __func__);
+		ctx->hw_err = false;
+		break;
+	case H264_FRAME_SKIPPED:
+		dev_dbg(dev, "%s     %s: h264 frame skipped\n",
+			ctx->name, __func__);
+		ctx->hw_err = false;
+		break;
+	case H264_BITSTREAM_OVERSIZE:
+		dev_err(dev, "%s     %s:h264 bitstream oversize\n",
+			ctx->name, __func__);
+		ctx->hw_err = true;
+		break;
+	case H264_SLICE_LIMIT_SIZE:
+		dev_err(dev, "%s     %s: h264 slice limit size is reached\n",
+			ctx->name, __func__);
+		ctx->hw_err = true;
+		break;
+	case H264_MAX_SLICE_NUMBER:
+		dev_err(dev, "%s     %s: h264 max slice number is reached\n",
+			ctx->name, __func__);
+		ctx->hw_err = true;
+		break;
+	case TASK_LIST_FULL:
+		dev_err(dev, "%s     %s:task list full\n",
+			ctx->name, __func__);
+		ctx->hw_err = true;
+		break;
+	case UNKNOWN_COMMAND:
+		dev_err(dev, "%s     %s: command not known\n",
+			ctx->name, __func__);
+		ctx->hw_err = true;
+		break;
+	case WRONG_CODEC_OR_RESOLUTION:
+		dev_err(dev, "%s     %s: wrong codec or resolution\n",
+			ctx->name, __func__);
+		ctx->hw_err = true;
+		break;
+	default:
+		dev_err(dev, "%s     %s: status not recognized\n",
+			ctx->name, __func__);
+		ctx->hw_err = true;
+		break;
+	}
+out:
+	complete(&hva->interrupt);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t hva_hw_err_interrupt(int irq, void *data)
+{
+	struct hva_dev *hva = data;
+
+	/* read status registers */
+	hva->sts_reg = readl_relaxed(hva->regs + HVA_HIF_FIFO_STS);
+	hva->sfl_reg = readl_relaxed(hva->regs + HVA_HIF_REG_SFL);
+
+	/* read error registers */
+	hva->lmi_err_reg = readl_relaxed(hva->regs + HVA_HIF_REG_LMI_ERR);
+	hva->emi_err_reg = readl_relaxed(hva->regs + HVA_HIF_REG_EMI_ERR);
+	hva->hec_mif_err_reg = readl_relaxed(hva->regs +
+					     HVA_HIF_REG_HEC_MIF_ERR);
+
+	/* acknowledge interruption */
+	writel_relaxed(0x1, hva->regs + HVA_HIF_REG_IT_ACK);
+
+	return IRQ_WAKE_THREAD;
+}
+
+static irqreturn_t hva_hw_err_irq_thread(int irq, void *arg)
+{
+	struct hva_dev *hva = arg;
+	struct device *dev = hva_to_dev(hva);
+	u8 ctx_id = 0;
+	struct hva_ctx *ctx;
+
+	dev_dbg(dev, "%s     status: 0x%02x fifo level: 0x%02x\n",
+		HVA_PREFIX, hva->sts_reg & 0xFF, hva->sfl_reg & 0xF);
+
+	/*
+	 * status: task_id[31:16] client_id[15:8] status[7:0]
+	 * the context identifier is retrieved from the client identifier
+	 */
+	ctx_id = (hva->sts_reg & 0xFF00) >> 8;
+	if (ctx_id >= HVA_MAX_INSTANCES) {
+		dev_err(dev, "%s     bad context identifier: %d\n", HVA_PREFIX,
+			ctx_id);
+		goto out;
+	}
+
+	ctx = hva->instances[ctx_id];
+	if (!ctx)
+		goto out;
+
+	if (hva->lmi_err_reg) {
+		dev_err(dev, "%s     local memory interface error: 0x%08x\n",
+			ctx->name, hva->lmi_err_reg);
+		ctx->hw_err = true;
+	}
+
+	if (hva->lmi_err_reg) {
+		dev_err(dev, "%s     external memory interface error: 0x%08x\n",
+			ctx->name, hva->emi_err_reg);
+		ctx->hw_err = true;
+	}
+
+	if (hva->hec_mif_err_reg) {
+		dev_err(dev, "%s     hec memory interface error: 0x%08x\n",
+			ctx->name, hva->hec_mif_err_reg);
+		ctx->hw_err = true;
+	}
+out:
+	complete(&hva->interrupt);
+
+	return IRQ_HANDLED;
+}
+
+static unsigned long int hva_hw_get_ip_version(struct hva_dev *hva)
+{
+	struct device *dev = hva_to_dev(hva);
+	unsigned long int version;
+
+	if (pm_runtime_get_sync(dev) < 0) {
+		dev_err(dev, "%s     failed to get pm_runtime\n", HVA_PREFIX);
+		mutex_unlock(&hva->protect_mutex);
+		return -EFAULT;
+	}
+
+	version = readl_relaxed(hva->regs + HVA_HIF_REG_VERSION) &
+				VERSION_ID_MASK;
+
+	pm_runtime_put_autosuspend(dev);
+
+	switch (version) {
+	case HVA_VERSION_V400:
+		dev_dbg(dev, "%s     IP hardware version 0x%lx\n",
+			HVA_PREFIX, version);
+		break;
+	default:
+		dev_err(dev, "%s     unknown IP hardware version 0x%lx\n",
+			HVA_PREFIX, version);
+		version = HVA_VERSION_UNKNOWN;
+		break;
+	}
+
+	return version;
+}
+
+int hva_hw_probe(struct platform_device *pdev, struct hva_dev *hva)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *regs;
+	struct resource *esram;
+	int ret;
+
+	WARN_ON(!hva);
+
+	/* get memory for registers */
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	hva->regs = devm_ioremap_resource(dev, regs);
+	if (IS_ERR_OR_NULL(hva->regs)) {
+		dev_err(dev, "%s     failed to get regs\n", HVA_PREFIX);
+		return PTR_ERR(hva->regs);
+	}
+
+	/* get memory for esram */
+	esram = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (IS_ERR_OR_NULL(esram)) {
+		dev_err(dev, "%s     failed to get esram\n", HVA_PREFIX);
+		return PTR_ERR(esram);
+	}
+	hva->esram_addr = esram->start;
+	hva->esram_size = esram->end - esram->start + 1;
+
+	dev_info(dev, "%s     esram reserved for address: 0x%x size:%d\n",
+		 HVA_PREFIX, hva->esram_addr, hva->esram_size);
+
+	/* get clock resource */
+	hva->clk = devm_clk_get(dev, "clk_hva");
+	if (IS_ERR(hva->clk)) {
+		dev_err(dev, "%s     failed to get clock\n", HVA_PREFIX);
+		return PTR_ERR(hva->clk);
+	}
+
+	ret = clk_prepare(hva->clk);
+	if (ret < 0) {
+		dev_err(dev, "%s     failed to prepare clock\n", HVA_PREFIX);
+		hva->clk = ERR_PTR(-EINVAL);
+		return ret;
+	}
+
+	/* get status interruption resource */
+	ret  = platform_get_irq(pdev, 0);
+	if (ret < 0) {
+		dev_err(dev, "%s     failed to get status IRQ\n", HVA_PREFIX);
+		goto err_clk;
+	}
+	hva->irq_its = ret;
+
+	ret = devm_request_threaded_irq(dev, hva->irq_its, hva_hw_its_interrupt,
+					hva_hw_its_irq_thread,
+					IRQF_ONESHOT,
+					"hva_its_irq", hva);
+	if (ret) {
+		dev_err(dev, "%s     failed to install status IRQ 0x%x\n",
+			HVA_PREFIX, hva->irq_its);
+		goto err_clk;
+	}
+	disable_irq(hva->irq_its);
+
+	/* get error interruption resource */
+	ret = platform_get_irq(pdev, 1);
+	if (ret < 0) {
+		dev_err(dev, "%s     failed to get error IRQ\n", HVA_PREFIX);
+		goto err_clk;
+	}
+	hva->irq_err = ret;
+
+	ret = devm_request_threaded_irq(dev, hva->irq_err, hva_hw_err_interrupt,
+					hva_hw_err_irq_thread,
+					IRQF_ONESHOT,
+					"hva_err_irq", hva);
+	if (ret) {
+		dev_err(dev, "%s     failed to install error IRQ 0x%x\n",
+			HVA_PREFIX, hva->irq_err);
+		goto err_clk;
+	}
+	disable_irq(hva->irq_err);
+
+	/* initialise protection mutex */
+	mutex_init(&hva->protect_mutex);
+
+	/* initialise completion signal */
+	init_completion(&hva->interrupt);
+
+	/* initialise runtime power management */
+	pm_runtime_set_autosuspend_delay(dev, AUTOSUSPEND_DELAY_MS);
+	pm_runtime_use_autosuspend(dev);
+	pm_runtime_set_suspended(dev);
+	pm_runtime_enable(dev);
+
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0) {
+		dev_err(dev, "%s     failed to set PM\n", HVA_PREFIX);
+		goto err_clk;
+	}
+
+	/* check IP hardware version */
+	hva->ip_version = hva_hw_get_ip_version(hva);
+
+	if (hva->ip_version == HVA_VERSION_UNKNOWN) {
+		ret = -EINVAL;
+		goto err_pm;
+	}
+
+	dev_info(dev, "%s     found hva device (version 0x%lx)\n", HVA_PREFIX,
+		 hva->ip_version);
+
+	return 0;
+
+err_pm:
+	pm_runtime_put(dev);
+err_clk:
+	if (hva->clk)
+		clk_unprepare(hva->clk);
+
+	return ret;
+}
+
+void hva_hw_remove(struct hva_dev *hva)
+{
+	struct device *dev = hva_to_dev(hva);
+
+	disable_irq(hva->irq_its);
+	disable_irq(hva->irq_err);
+
+	pm_runtime_put_autosuspend(dev);
+	pm_runtime_disable(dev);
+}
+
+int hva_hw_runtime_suspend(struct device *dev)
+{
+	struct hva_dev *hva = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(hva->clk);
+
+	return 0;
+}
+
+int hva_hw_runtime_resume(struct device *dev)
+{
+	struct hva_dev *hva = dev_get_drvdata(dev);
+
+	if (clk_prepare_enable(hva->clk)) {
+		dev_err(hva->dev, "%s     failed to prepare hva clk\n",
+			HVA_PREFIX);
+		return -EINVAL;
+	}
+
+	if (clk_set_rate(hva->clk, CLK_RATE)) {
+		dev_err(dev, "%s     failed to set clock frequency\n",
+			HVA_PREFIX);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int hva_hw_execute_task(struct hva_ctx *ctx, enum hva_hw_cmd_type cmd,
+			struct hva_buffer *task)
+{
+	struct hva_dev *hva = ctx_to_hdev(ctx);
+	struct device *dev = hva_to_dev(hva);
+	u8 client_id = ctx->id;
+	int ret;
+	u32 reg = 0;
+
+	mutex_lock(&hva->protect_mutex);
+
+	/* enable irqs */
+	enable_irq(hva->irq_its);
+	enable_irq(hva->irq_err);
+
+	if (pm_runtime_get_sync(dev) < 0) {
+		dev_err(dev, "%s     failed to get pm_runtime\n", ctx->name);
+		ret = -EFAULT;
+		goto out;
+	}
+
+	reg = readl_relaxed(hva->regs + HVA_HIF_REG_CLK_GATING);
+	switch (cmd) {
+	case H264_ENC:
+		reg |= CLK_GATING_HVC;
+		break;
+	default:
+		dev_dbg(dev, "%s     unknown command 0x%x\n", ctx->name, cmd);
+		ret = -EFAULT;
+		goto out;
+	}
+	writel_relaxed(reg, hva->regs + HVA_HIF_REG_CLK_GATING);
+
+	dev_dbg(dev, "%s     %s: write configuration registers\n", ctx->name,
+		__func__);
+
+	/* byte swap config */
+	writel_relaxed(BSM_CFG_VAL1, hva->regs + HVA_HIF_REG_BSM);
+
+	/* define Max Opcode Size and Max Message Size for LMI and EMI */
+	writel_relaxed(MIF_CFG_VAL3, hva->regs + HVA_HIF_REG_MIF_CFG);
+	writel_relaxed(HEC_MIF_CFG_VAL, hva->regs + HVA_HIF_REG_HEC_MIF_CFG);
+
+	/*
+	 * command FIFO: task_id[31:16] client_id[15:8] command_type[7:0]
+	 * the context identifier is provided as client identifier to the
+	 * hardware, and is retrieved in the interrupt functions from the
+	 * status register
+	 */
+	dev_dbg(dev, "%s     %s: send task (cmd: %d, task_desc: %pad)\n",
+		ctx->name, __func__, cmd + (client_id << 8), &task->paddr);
+	writel_relaxed(cmd + (client_id << 8), hva->regs + HVA_HIF_FIFO_CMD);
+	writel_relaxed(task->paddr, hva->regs + HVA_HIF_FIFO_CMD);
+
+	if (!wait_for_completion_timeout(&hva->interrupt,
+					 msecs_to_jiffies(2000))) {
+		dev_err(dev, "%s     %s: time out on completion\n", ctx->name,
+			__func__);
+		ret = -EFAULT;
+		goto out;
+	}
+
+	/* get encoding status */
+	ret = ctx->hw_err ? -EFAULT : 0;
+
+out:
+	disable_irq(hva->irq_its);
+	disable_irq(hva->irq_err);
+
+	switch (cmd) {
+	case H264_ENC:
+		reg &= ~CLK_GATING_HVC;
+		writel_relaxed(reg, hva->regs + HVA_HIF_REG_CLK_GATING);
+		break;
+	default:
+		dev_dbg(dev, "%s     unknown command 0x%x\n", ctx->name, cmd);
+	}
+
+	pm_runtime_put_autosuspend(dev);
+	mutex_unlock(&hva->protect_mutex);
+
+	return ret;
+}
diff --git a/drivers/media/platform/sti/hva/hva-hw.h b/drivers/media/platform/sti/hva/hva-hw.h
new file mode 100644
index 0000000..efb45b9
--- /dev/null
+++ b/drivers/media/platform/sti/hva/hva-hw.h
@@ -0,0 +1,42 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2015
+ * Authors: Yannick Fertre <yannick.fertre@st.com>
+ *          Hugues Fruchet <hugues.fruchet@st.com>
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef HVA_HW_H
+#define HVA_HW_H
+
+#include "hva-mem.h"
+
+/* HVA Versions */
+#define HVA_VERSION_UNKNOWN    0x000
+#define HVA_VERSION_V400       0x400
+
+/* HVA command types */
+enum hva_hw_cmd_type {
+	/* RESERVED = 0x00 */
+	/* RESERVED = 0x01 */
+	H264_ENC = 0x02,
+	/* RESERVED = 0x03 */
+	/* RESERVED = 0x04 */
+	/* RESERVED = 0x05 */
+	/* RESERVED = 0x06 */
+	/* RESERVED = 0x07 */
+	REMOVE_CLIENT = 0x08,
+	FREEZE_CLIENT = 0x09,
+	START_CLIENT = 0x0A,
+	FREEZE_ALL = 0x0B,
+	START_ALL = 0x0C,
+	REMOVE_ALL = 0x0D
+};
+
+int hva_hw_probe(struct platform_device *pdev, struct hva_dev *hva);
+void hva_hw_remove(struct hva_dev *hva);
+int hva_hw_runtime_suspend(struct device *dev);
+int hva_hw_runtime_resume(struct device *dev);
+int hva_hw_execute_task(struct hva_ctx *ctx, enum hva_hw_cmd_type cmd,
+			struct hva_buffer *task);
+
+#endif /* HVA_HW_H */
diff --git a/drivers/media/platform/sti/hva/hva-mem.c b/drivers/media/platform/sti/hva/hva-mem.c
new file mode 100644
index 0000000..759c873
--- /dev/null
+++ b/drivers/media/platform/sti/hva/hva-mem.c
@@ -0,0 +1,60 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2015
+ * Authors: Yannick Fertre <yannick.fertre@st.com>
+ *          Hugues Fruchet <hugues.fruchet@st.com>
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include "hva.h"
+#include "hva-mem.h"
+
+int hva_mem_alloc(struct hva_ctx *ctx, u32 size, const char *name,
+		  struct hva_buffer **buf)
+{
+	struct device *dev = ctx_to_dev(ctx);
+	struct hva_buffer *b;
+	dma_addr_t paddr;
+	void *base;
+	DEFINE_DMA_ATTRS(attrs);
+
+	b = devm_kzalloc(dev, sizeof(*b), GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
+
+	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
+	base = dma_alloc_attrs(dev, size, &paddr, GFP_KERNEL | GFP_DMA, &attrs);
+	if (!base) {
+		dev_err(dev, "%s %s : dma_alloc_attrs failed for %s (size=%d)\n",
+			ctx->name, __func__, name, size);
+		devm_kfree(dev, b);
+		return -ENOMEM;
+	}
+
+	b->size = size;
+	b->paddr = paddr;
+	b->vaddr = base;
+	b->attrs = attrs;
+	b->name = name;
+
+	dev_dbg(dev,
+		"%s allocate %d bytes of HW memory @(virt=%p, phy=%pad): %s\n",
+		ctx->name, size, b->vaddr, &b->paddr, b->name);
+
+	/* return  hva buffer to user */
+	*buf = b;
+
+	return 0;
+}
+
+void hva_mem_free(struct hva_ctx *ctx, struct hva_buffer *buf)
+{
+	struct device *dev = ctx_to_dev(ctx);
+
+	dev_dbg(dev,
+		"%s free %d bytes of HW memory @(virt=%p, phy=%pad): %s\n",
+		ctx->name, buf->size, buf->vaddr, &buf->paddr, buf->name);
+
+	dma_free_attrs(dev, buf->size, buf->vaddr, buf->paddr, &buf->attrs);
+
+	devm_kfree(dev, buf);
+}
diff --git a/drivers/media/platform/sti/hva/hva-mem.h b/drivers/media/platform/sti/hva/hva-mem.h
new file mode 100644
index 0000000..e8a3f7e
--- /dev/null
+++ b/drivers/media/platform/sti/hva/hva-mem.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2015
+ * Authors: Yannick Fertre <yannick.fertre@st.com>
+ *          Hugues Fruchet <hugues.fruchet@st.com>
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef HVA_MEM_H
+#define HVA_MEM_H
+
+/**
+ * struct hva_buffer - hva buffer
+ *
+ * @name:  name of requester
+ * @attrs: dma attributes
+ * @paddr: physical address (for hardware)
+ * @vaddr: virtual address (kernel can read/write)
+ * @size:  size of buffer
+ */
+struct hva_buffer {
+	const char		*name;
+	struct dma_attrs	attrs;
+	dma_addr_t		paddr;
+	void			*vaddr;
+	u32			size;
+};
+
+int hva_mem_alloc(struct hva_ctx *ctx,
+		  __u32 size,
+		  const char *name,
+		  struct hva_buffer **buf);
+
+void hva_mem_free(struct hva_ctx *ctx,
+		  struct hva_buffer *buf);
+
+#endif /* HVA_MEM_H */
diff --git a/drivers/media/platform/sti/hva/hva-v4l2.c b/drivers/media/platform/sti/hva/hva-v4l2.c
new file mode 100644
index 0000000..1e4de8d
--- /dev/null
+++ b/drivers/media/platform/sti/hva/hva-v4l2.c
@@ -0,0 +1,1289 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2015
+ * Authors: Yannick Fertre <yannick.fertre@st.com>
+ *          Hugues Fruchet <hugues.fruchet@st.com>
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "hva.h"
+#include "hva-hw.h"
+
+#define HVA_NAME "hva"
+
+#define MIN_FRAMES	1
+#define MIN_STREAMS	1
+
+#define HVA_MIN_WIDTH	32
+#define HVA_MAX_WIDTH	1920
+#define HVA_MIN_HEIGHT	32
+#define HVA_MAX_HEIGHT	1920
+
+/* HVA requires a 16x16 pixels alignment for frames */
+#define HVA_WIDTH_ALIGNMENT	16
+#define HVA_HEIGHT_ALIGNMENT	16
+
+#define DEFAULT_WIDTH		HVA_MIN_WIDTH
+#define	DEFAULT_HEIGHT		HVA_MIN_HEIGHT
+#define DEFAULT_FRAME_NUM	1
+#define DEFAULT_FRAME_DEN	30
+
+#define to_type_str(type) (type == V4L2_BUF_TYPE_VIDEO_OUTPUT ? \
+			   "frame" : "stream")
+
+#define fh_to_ctx(f)    (container_of(f, struct hva_ctx, fh))
+
+/* registry of available encoders */
+const struct hva_enc *hva_encoders[] = {
+};
+
+static inline int frame_size(u32 w, u32 h, u32 fmt)
+{
+	switch (fmt) {
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+		return (w * h * 3) / 2;
+	default:
+		return 0;
+	}
+}
+
+static inline int frame_stride(u32 w, u32 fmt)
+{
+	switch (fmt) {
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+		return w;
+	default:
+		return 0;
+	}
+}
+
+static inline int frame_alignment(u32 fmt)
+{
+	switch (fmt) {
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+		/* multiple of 2 */
+		return 2;
+	default:
+		return 1;
+	}
+}
+
+static inline int estimated_stream_size(u32 w, u32 h)
+{
+	/*
+	 * HVA only encodes in YUV420 format, whatever the frame format.
+	 * A compression ratio of 2 is assumed: thus, the maximum size
+	 * of a stream is estimated to ((width x height x 3 / 2) / 2)
+	 */
+	return (w * h * 3) / 4;
+}
+
+static void set_default_params(struct hva_ctx *ctx)
+{
+	struct hva_frameinfo *frameinfo = &ctx->frameinfo;
+	struct hva_streaminfo *streaminfo = &ctx->streaminfo;
+
+	frameinfo->pixelformat = V4L2_PIX_FMT_NV12;
+	frameinfo->width = DEFAULT_WIDTH;
+	frameinfo->height = DEFAULT_HEIGHT;
+	frameinfo->aligned_width = DEFAULT_WIDTH;
+	frameinfo->aligned_height = DEFAULT_HEIGHT;
+	frameinfo->size = frame_size(frameinfo->aligned_width,
+				     frameinfo->aligned_height,
+				     frameinfo->pixelformat);
+
+	streaminfo->streamformat = V4L2_PIX_FMT_H264;
+	streaminfo->width = DEFAULT_WIDTH;
+	streaminfo->height = DEFAULT_HEIGHT;
+
+	ctx->colorspace = V4L2_COLORSPACE_REC709;
+	ctx->xfer_func = V4L2_XFER_FUNC_DEFAULT;
+	ctx->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
+	ctx->quantization = V4L2_QUANTIZATION_DEFAULT;
+
+	ctx->max_stream_size = estimated_stream_size(streaminfo->width,
+						     streaminfo->height);
+}
+
+static const struct hva_enc *hva_find_encoder(struct hva_ctx *ctx,
+					      u32 pixelformat,
+					      u32 streamformat)
+{
+	struct hva_dev *hva = ctx_to_hdev(ctx);
+	const struct hva_enc *enc;
+	unsigned int i;
+
+	for (i = 0; i < hva->nb_of_encoders; i++) {
+		enc = hva->encoders[i];
+		if ((enc->pixelformat == pixelformat) &&
+		    (enc->streamformat == streamformat))
+			return enc;
+	}
+
+	return NULL;
+}
+
+static void register_format(u32 format, u32 formats[], u32 *nb_of_formats)
+{
+	u32 i;
+	bool found = false;
+
+	for (i = 0; i < *nb_of_formats; i++) {
+		if (format == formats[i]) {
+			found = true;
+			break;
+		}
+	}
+
+	if (!found)
+		formats[(*nb_of_formats)++] = format;
+}
+
+static void register_formats(struct hva_dev *hva)
+{
+	unsigned int i;
+
+	for (i = 0; i < hva->nb_of_encoders; i++) {
+		register_format(hva->encoders[i]->pixelformat,
+				hva->pixelformats,
+				&hva->nb_of_pixelformats);
+
+		register_format(hva->encoders[i]->streamformat,
+				hva->streamformats,
+				&hva->nb_of_streamformats);
+	}
+}
+
+static void register_encoders(struct hva_dev *hva)
+{
+	struct device *dev = hva_to_dev(hva);
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(hva_encoders); i++) {
+		if (hva->nb_of_encoders >= HVA_MAX_ENCODERS) {
+			dev_dbg(dev,
+				"%s failed to register encoder (%d maximum reached)\n",
+				hva_encoders[i]->name, HVA_MAX_ENCODERS);
+			return;
+		}
+
+		hva->encoders[hva->nb_of_encoders++] = hva_encoders[i];
+		dev_info(dev, "%s encoder registered\n", hva_encoders[i]->name);
+	}
+}
+
+static int hva_open_encoder(struct hva_ctx *ctx, u32 streamformat,
+			    u32 pixelformat, struct hva_enc **penc)
+{
+	struct hva_dev *hva = ctx_to_hdev(ctx);
+	struct device *dev = ctx_to_dev(ctx);
+	struct hva_enc *enc;
+	unsigned int i;
+	int ret;
+	bool found = false;
+
+	/* find an encoder which can deal with these formats */
+	for (i = 0; i < hva->nb_of_encoders; i++) {
+		enc = (struct hva_enc *)hva->encoders[i];
+		if ((enc->streamformat == streamformat) &&
+		    (enc->pixelformat == pixelformat)) {
+			found = true;
+			break;
+		}
+	}
+
+	if (!found) {
+		dev_err(dev, "%s no encoder found matching %4.4s => %4.4s\n",
+			ctx->name, (char *)&pixelformat, (char *)&streamformat);
+		return -EINVAL;
+	}
+
+	dev_dbg(dev, "%s one encoder matching %4.4s => %4.4s\n",
+		ctx->name, (char *)&pixelformat, (char *)&streamformat);
+
+	/* update instance name */
+	snprintf(ctx->name, sizeof(ctx->name), "[%3d:%4.4s]",
+		 hva->instance_id, (char *)&streamformat);
+
+	/* open encoder instance */
+	ret = enc->open(ctx);
+	if (ret) {
+		dev_err(dev, "%s failed to open encoder instance (%d)\n",
+			ctx->name, ret);
+		return ret;
+	}
+
+	dev_dbg(dev, "%s %s encoder opened\n", ctx->name, enc->name);
+
+	*penc = enc;
+
+	return ret;
+}
+
+/*
+ * V4L2 ioctl operations
+ */
+
+static int hva_querycap(struct file *file, void *priv,
+			struct v4l2_capability *cap)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct hva_dev *hva = ctx_to_hdev(ctx);
+
+	strlcpy(cap->driver, HVA_NAME, sizeof(cap->driver));
+	strlcpy(cap->card, hva->vdev->name, sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
+		 hva->pdev->name);
+
+	return 0;
+}
+
+static int hva_enum_fmt_stream(struct file *file, void *priv,
+			       struct v4l2_fmtdesc *f)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct hva_dev *hva = ctx_to_hdev(ctx);
+
+	if (unlikely(f->index >= hva->nb_of_streamformats))
+		return -EINVAL;
+
+	f->pixelformat = hva->streamformats[f->index];
+
+	return 0;
+}
+
+static int hva_enum_fmt_frame(struct file *file, void *priv,
+			      struct v4l2_fmtdesc *f)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct hva_dev *hva = ctx_to_hdev(ctx);
+
+	if (unlikely(f->index >= hva->nb_of_pixelformats))
+		return -EINVAL;
+
+	f->pixelformat = hva->pixelformats[f->index];
+
+	return 0;
+}
+
+static int hva_g_fmt_stream(struct file *file, void *fh, struct v4l2_format *f)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct hva_streaminfo *streaminfo = &ctx->streaminfo;
+
+	f->fmt.pix.width = streaminfo->width;
+	f->fmt.pix.height = streaminfo->height;
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+	f->fmt.pix.colorspace = ctx->colorspace;
+	f->fmt.pix.xfer_func = ctx->xfer_func;
+	f->fmt.pix.ycbcr_enc = ctx->ycbcr_enc;
+	f->fmt.pix.quantization = ctx->quantization;
+	f->fmt.pix.pixelformat = streaminfo->streamformat;
+	f->fmt.pix.bytesperline = 0;
+	f->fmt.pix.sizeimage = ctx->max_stream_size;
+
+	return 0;
+}
+
+static int hva_g_fmt_frame(struct file *file, void *fh, struct v4l2_format *f)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct hva_frameinfo *frameinfo = &ctx->frameinfo;
+
+	f->fmt.pix.width = frameinfo->width;
+	f->fmt.pix.height = frameinfo->height;
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+	f->fmt.pix.colorspace = ctx->colorspace;
+	f->fmt.pix.xfer_func = ctx->xfer_func;
+	f->fmt.pix.ycbcr_enc = ctx->ycbcr_enc;
+	f->fmt.pix.quantization = ctx->quantization;
+	f->fmt.pix.pixelformat = frameinfo->pixelformat;
+	f->fmt.pix.bytesperline = frame_stride(frameinfo->aligned_width,
+					       frameinfo->pixelformat);
+	f->fmt.pix.sizeimage = frameinfo->size;
+
+	return 0;
+}
+
+static int hva_try_fmt_stream(struct file *file, void *priv,
+			      struct v4l2_format *f)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	u32 streamformat = pix->pixelformat;
+	const struct hva_enc *enc;
+	u32 width, height;
+	u32 stream_size;
+
+	enc = hva_find_encoder(ctx, ctx->frameinfo.pixelformat, streamformat);
+	if (!enc) {
+		dev_dbg(dev,
+			"%s V4L2 TRY_FMT (CAPTURE): unsupported format %.4s\n",
+			ctx->name, (char *)&pix->pixelformat);
+		return -EINVAL;
+	}
+
+	width = pix->width;
+	height = pix->height;
+	if (ctx->flags & HVA_FLAG_FRAMEINFO) {
+		/*
+		 * if the frame resolution is already fixed, only allow the
+		 * same stream resolution
+		 */
+		pix->width = ctx->frameinfo.width;
+		pix->height = ctx->frameinfo.height;
+		if ((pix->width != width) || (pix->height != height))
+			dev_dbg(dev,
+				"%s V4L2 TRY_FMT (CAPTURE): resolution updated %dx%d -> %dx%d to fit frame resolution\n",
+				ctx->name, width, height,
+				pix->width, pix->height);
+	} else {
+		/* adjust width & height */
+		v4l_bound_align_image(&pix->width,
+				      HVA_MIN_WIDTH, enc->max_width,
+				      0,
+				      &pix->height,
+				      HVA_MIN_HEIGHT, enc->max_height,
+				      0,
+				      0);
+
+		if ((pix->width != width) || (pix->height != height))
+			dev_dbg(dev,
+				"%s V4L2 TRY_FMT (CAPTURE): resolution updated %dx%d -> %dx%d to fit min/max/alignment\n",
+				ctx->name, width, height,
+				pix->width, pix->height);
+	}
+
+	stream_size = estimated_stream_size(pix->width, pix->height);
+	if (pix->sizeimage < stream_size)
+		pix->sizeimage = stream_size;
+
+	pix->bytesperline = 0;
+	pix->colorspace = ctx->colorspace;
+	pix->xfer_func = ctx->xfer_func;
+	pix->ycbcr_enc = ctx->ycbcr_enc;
+	pix->quantization = ctx->quantization;
+	pix->field = V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static int hva_try_fmt_frame(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	u32 pixelformat = pix->pixelformat;
+	const struct hva_enc *enc;
+	u32 width, height;
+
+	enc = hva_find_encoder(ctx, pixelformat, ctx->streaminfo.streamformat);
+	if (!enc) {
+		dev_dbg(dev,
+			"%s V4L2 TRY_FMT (OUTPUT): unsupported format %.4s\n",
+			ctx->name, (char *)&pixelformat);
+		return -EINVAL;
+	}
+
+	/* adjust width & height */
+	width = pix->width;
+	height = pix->height;
+	v4l_bound_align_image(&pix->width,
+			      HVA_MIN_WIDTH, HVA_MAX_WIDTH,
+			      frame_alignment(pixelformat) - 1,
+			      &pix->height,
+			      HVA_MIN_HEIGHT, HVA_MAX_HEIGHT,
+			      frame_alignment(pixelformat) - 1,
+			      0);
+
+	if ((pix->width != width) || (pix->height != height))
+		dev_dbg(dev,
+			"%s V4L2 TRY_FMT (OUTPUT): resolution updated %dx%d -> %dx%d to fit min/max/alignment\n",
+			ctx->name, width, height, pix->width, pix->height);
+
+	width = ALIGN(pix->width, HVA_WIDTH_ALIGNMENT);
+	height = ALIGN(pix->height, HVA_HEIGHT_ALIGNMENT);
+
+	if (!pix->colorspace) {
+		pix->colorspace = V4L2_COLORSPACE_REC709;
+		pix->xfer_func = V4L2_XFER_FUNC_DEFAULT;
+		pix->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
+		pix->quantization = V4L2_QUANTIZATION_DEFAULT;
+	}
+
+	pix->bytesperline = frame_stride(width, pixelformat);
+	pix->sizeimage = frame_size(width, height, pixelformat);
+	pix->field = V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static int hva_s_fmt_stream(struct file *file, void *fh, struct v4l2_format *f)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+	struct vb2_queue *vq;
+	int ret;
+
+	ret = hva_try_fmt_stream(file, fh, f);
+	if (ret) {
+		dev_dbg(dev, "%s V4L2 S_FMT (CAPTURE): unsupported format %.4s\n",
+			ctx->name, (char *)&f->fmt.pix.pixelformat);
+		return ret;
+	}
+
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
+	if (vb2_is_streaming(vq)) {
+		dev_dbg(dev, "%s V4L2 S_FMT (CAPTURE): queue busy\n",
+			ctx->name);
+		return -EBUSY;
+	}
+
+	ctx->max_stream_size = f->fmt.pix.sizeimage;
+	ctx->streaminfo.width = f->fmt.pix.width;
+	ctx->streaminfo.height = f->fmt.pix.height;
+	ctx->streaminfo.streamformat = f->fmt.pix.pixelformat;
+	ctx->flags |= HVA_FLAG_STREAMINFO;
+
+	return 0;
+}
+
+static int hva_s_fmt_frame(struct file *file, void *fh, struct v4l2_format *f)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct vb2_queue *vq;
+	int ret;
+
+	ret = hva_try_fmt_frame(file, fh, f);
+	if (ret) {
+		dev_dbg(dev, "%s V4L2 S_FMT (OUTPUT): unsupported format %.4s\n",
+			ctx->name, (char *)&f->fmt.pix.pixelformat);
+		return ret;
+	}
+
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
+	if (vb2_is_streaming(vq)) {
+		dev_dbg(dev, "%s V4L2 S_FMT (OUTPUT): queue busy\n", ctx->name);
+		return -EBUSY;
+	}
+
+	ctx->colorspace = f->fmt.pix.colorspace;
+	ctx->xfer_func = f->fmt.pix.xfer_func;
+	ctx->ycbcr_enc = f->fmt.pix.ycbcr_enc;
+	ctx->quantization = f->fmt.pix.quantization;
+
+	ctx->frameinfo.aligned_width = ALIGN(pix->width, HVA_WIDTH_ALIGNMENT);
+	ctx->frameinfo.aligned_height = ALIGN(pix->height,
+					      HVA_HEIGHT_ALIGNMENT);
+	ctx->frameinfo.size = pix->sizeimage;
+	ctx->frameinfo.pixelformat = pix->pixelformat;
+	ctx->frameinfo.width = pix->width;
+	ctx->frameinfo.height = pix->height;
+	ctx->flags |= HVA_FLAG_FRAMEINFO;
+
+	return 0;
+}
+
+static int hva_s_parm(struct file *file, void *fh, struct v4l2_streamparm *sp)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct v4l2_fract *time_per_frame = &ctx->ctrls.time_per_frame;
+
+	time_per_frame->numerator = sp->parm.capture.timeperframe.numerator;
+	time_per_frame->denominator =
+		sp->parm.capture.timeperframe.denominator;
+
+	return 0;
+}
+
+static int hva_g_parm(struct file *file, void *fh, struct v4l2_streamparm *sp)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct v4l2_fract *time_per_frame = &ctx->ctrls.time_per_frame;
+
+	sp->parm.capture.timeperframe.numerator = time_per_frame->numerator;
+	sp->parm.capture.timeperframe.denominator =
+		time_per_frame->denominator;
+
+	return 0;
+}
+
+static int hva_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+
+	if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		/*
+		 * depending on the targeted compressed video format, the
+		 * capture buffer might contain headers (e.g. H.264 SPS/PPS)
+		 * filled in by the driver client; the size of these data is
+		 * copied from the bytesused field of the V4L2 buffer in the
+		 * payload field of the hva stream buffer
+		 */
+		struct vb2_queue *vq;
+		struct hva_stream *stream;
+
+		vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, buf->type);
+
+		if (buf->index >= vq->num_buffers) {
+			dev_dbg(dev, "%s buffer index %d out of range (%d)\n",
+				ctx->name, buf->index, vq->num_buffers);
+			return -EINVAL;
+		}
+
+		stream = (struct hva_stream *)vq->bufs[buf->index];
+		stream->bytesused = buf->bytesused;
+	}
+
+	return v4l2_m2m_qbuf(file, ctx->fh.m2m_ctx, buf);
+}
+
+/* V4L2 ioctl ops */
+static const struct v4l2_ioctl_ops hva_ioctl_ops = {
+	.vidioc_querycap		= hva_querycap,
+	.vidioc_enum_fmt_vid_cap	= hva_enum_fmt_stream,
+	.vidioc_enum_fmt_vid_out	= hva_enum_fmt_frame,
+	.vidioc_g_fmt_vid_cap		= hva_g_fmt_stream,
+	.vidioc_g_fmt_vid_out		= hva_g_fmt_frame,
+	.vidioc_try_fmt_vid_cap		= hva_try_fmt_stream,
+	.vidioc_try_fmt_vid_out		= hva_try_fmt_frame,
+	.vidioc_s_fmt_vid_cap		= hva_s_fmt_stream,
+	.vidioc_s_fmt_vid_out		= hva_s_fmt_frame,
+	.vidioc_g_parm			= hva_g_parm,
+	.vidioc_s_parm			= hva_s_parm,
+	.vidioc_reqbufs			= v4l2_m2m_ioctl_reqbufs,
+	.vidioc_create_bufs             = v4l2_m2m_ioctl_create_bufs,
+	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
+	.vidioc_expbuf			= v4l2_m2m_ioctl_expbuf,
+	.vidioc_qbuf			= hva_qbuf,
+	.vidioc_dqbuf			= v4l2_m2m_ioctl_dqbuf,
+	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
+	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
+	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
+};
+
+/*
+ * V4L2 control operations
+ */
+
+static int hva_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct hva_ctx *ctx = container_of(ctrl->handler, struct hva_ctx,
+					   ctrl_handler);
+	struct device *dev = ctx_to_dev(ctx);
+
+	dev_dbg(dev, "%s S_CTRL: id = %d, val = %d\n", ctx->name,
+		ctrl->id, ctrl->val);
+
+	switch (ctrl->id) {
+	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
+		ctx->ctrls.bitrate_mode = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
+		ctx->ctrls.gop_size = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_BITRATE:
+		ctx->ctrls.bitrate = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_ASPECT:
+		ctx->ctrls.aspect = ctrl->val;
+		break;
+	default:
+		dev_dbg(dev, "%s S_CTRL: invalid control (id = %d)\n",
+			ctx->name, ctrl->id);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* V4L2 control ops */
+static const struct v4l2_ctrl_ops hva_ctrl_ops = {
+	.s_ctrl = hva_s_ctrl,
+};
+
+static int hva_ctrls_setup(struct hva_ctx *ctx)
+{
+	struct device *dev = ctx_to_dev(ctx);
+	u64 mask;
+
+	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 4);
+
+	v4l2_ctrl_new_std_menu(&ctx->ctrl_handler, &hva_ctrl_ops,
+			       V4L2_CID_MPEG_VIDEO_BITRATE_MODE,
+			       V4L2_MPEG_VIDEO_BITRATE_MODE_CBR,
+			       0,
+			       V4L2_MPEG_VIDEO_BITRATE_MODE_CBR);
+
+	v4l2_ctrl_new_std(&ctx->ctrl_handler, &hva_ctrl_ops,
+			  V4L2_CID_MPEG_VIDEO_GOP_SIZE,
+			  1, 60, 1, 16);
+
+	v4l2_ctrl_new_std(&ctx->ctrl_handler, &hva_ctrl_ops,
+			  V4L2_CID_MPEG_VIDEO_BITRATE,
+			  1, 50000, 1, 20000);
+
+	mask = ~(1 << V4L2_MPEG_VIDEO_ASPECT_1x1);
+	v4l2_ctrl_new_std_menu(&ctx->ctrl_handler, &hva_ctrl_ops,
+			       V4L2_CID_MPEG_VIDEO_ASPECT,
+			       V4L2_MPEG_VIDEO_ASPECT_1x1,
+			       mask,
+			       V4L2_MPEG_VIDEO_ASPECT_1x1);
+
+	if (ctx->ctrl_handler.error) {
+		int err = ctx->ctrl_handler.error;
+
+		dev_dbg(dev, "%s controls setup failed (%d)\n",
+			ctx->name, err);
+		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+		return err;
+	}
+
+	v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
+
+	/* set default time per frame */
+	ctx->ctrls.time_per_frame.numerator = DEFAULT_FRAME_NUM;
+	ctx->ctrls.time_per_frame.denominator = DEFAULT_FRAME_DEN;
+
+	return 0;
+}
+
+/*
+ * mem-to-mem operations
+ */
+
+static void hva_run_work(struct work_struct *work)
+{
+	struct hva_ctx *ctx = container_of(work, struct hva_ctx, run_work);
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
+	const struct hva_enc *enc = ctx->enc;
+	struct hva_frame *frame;
+	struct hva_stream *stream;
+	int ret;
+
+	/* protect instance against reentrancy */
+	mutex_lock(&ctx->lock);
+
+	src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+
+	frame = to_hva_frame(src_buf);
+	stream = to_hva_stream(dst_buf);
+	frame->vbuf.sequence = ctx->frame_num++;
+
+	ret = enc->encode(ctx, frame, stream);
+
+	if (ret) {
+		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
+		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
+	} else {
+		/* propagate frame timestamp */
+		dst_buf->vb2_buf.timestamp = src_buf->vb2_buf.timestamp;
+		dst_buf->field = V4L2_FIELD_NONE;
+		dst_buf->sequence = ctx->stream_num - 1;
+
+		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
+		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
+	}
+
+	mutex_unlock(&ctx->lock);
+
+	v4l2_m2m_job_finish(ctx->hva_dev->m2m_dev, ctx->fh.m2m_ctx);
+}
+
+static void hva_device_run(void *priv)
+{
+	struct hva_ctx *ctx = priv;
+	struct hva_dev *hva = ctx_to_hdev(ctx);
+
+	queue_work(hva->work_queue, &ctx->run_work);
+}
+
+static void hva_job_abort(void *priv)
+{
+	struct hva_ctx *ctx = priv;
+	struct device *dev = ctx_to_dev(ctx);
+
+	dev_dbg(dev, "%s aborting job\n", ctx->name);
+
+	ctx->aborting = true;
+}
+
+static int hva_job_ready(void *priv)
+{
+	struct hva_ctx *ctx = priv;
+	struct device *dev = ctx_to_dev(ctx);
+
+	if (!v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx)) {
+		dev_dbg(dev, "%s job not ready: no frame buffers\n",
+			ctx->name);
+		return 0;
+	}
+
+	if (!v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx)) {
+		dev_dbg(dev, "%s job not ready: no stream buffers\n",
+			ctx->name);
+		return 0;
+	}
+
+	if (ctx->aborting) {
+		dev_dbg(dev, "%s job not ready: aborting\n", ctx->name);
+		return 0;
+	}
+
+	return 1;
+}
+
+/* mem-to-mem ops */
+static const struct v4l2_m2m_ops hva_m2m_ops = {
+	.device_run	= hva_device_run,
+	.job_abort	= hva_job_abort,
+	.job_ready	= hva_job_ready,
+};
+
+/*
+ * VB2 queue operations
+ */
+
+static int hva_queue_setup(struct vb2_queue *vq,
+			   unsigned int *num_buffers, unsigned int *num_planes,
+			   unsigned int sizes[], struct device *alloc_devs[])
+{
+	struct hva_ctx *ctx = vb2_get_drv_priv(vq);
+	struct device *dev = ctx_to_dev(ctx);
+	unsigned int size;
+
+	dev_dbg(dev, "%s %s queue setup: num_buffers %d\n", ctx->name,
+		to_type_str(vq->type), *num_buffers);
+
+	size = vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT ?
+		ctx->frameinfo.size : ctx->max_stream_size;
+
+	if (*num_planes)
+		return sizes[0] < size ? -EINVAL : 0;
+
+	/* only one plane supported */
+	*num_planes = 1;
+	sizes[0] = size;
+
+	return 0;
+}
+
+static int hva_buf_prepare(struct vb2_buffer *vb)
+{
+	struct hva_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct device *dev = ctx_to_dev(ctx);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+
+	if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		struct hva_frame *frame = to_hva_frame(vbuf);
+
+		if (vbuf->field == V4L2_FIELD_ANY)
+			vbuf->field = V4L2_FIELD_NONE;
+		if (vbuf->field != V4L2_FIELD_NONE) {
+			dev_dbg(dev,
+				"%s frame[%d] prepare: %d field not supported\n",
+				ctx->name, vb->index, vbuf->field);
+			return -EINVAL;
+		}
+
+		if (!frame->prepared) {
+			/* get memory addresses */
+			frame->vaddr = vb2_plane_vaddr(&vbuf->vb2_buf, 0);
+			frame->paddr = vb2_dma_contig_plane_dma_addr(
+					&vbuf->vb2_buf, 0);
+			frame->info = ctx->frameinfo;
+			frame->prepared = true;
+
+			dev_dbg(dev,
+				"%s frame[%d] prepared; virt=%p, phy=%pad\n",
+				ctx->name, vb->index,
+				frame->vaddr, &frame->paddr);
+		}
+	} else {
+		struct hva_stream *stream = to_hva_stream(vbuf);
+
+		if (!stream->prepared) {
+			/* get memory addresses */
+			stream->vaddr = vb2_plane_vaddr(&vbuf->vb2_buf, 0);
+			stream->paddr = vb2_dma_contig_plane_dma_addr(
+					&vbuf->vb2_buf, 0);
+			stream->size = vb2_plane_size(&vbuf->vb2_buf, 0);
+			stream->prepared = true;
+
+			dev_dbg(dev,
+				"%s stream[%d] prepared; virt=%p, phy=%pad\n",
+				ctx->name, vb->index,
+				stream->vaddr, &stream->paddr);
+		}
+	}
+
+	return 0;
+}
+
+static void hva_buf_queue(struct vb2_buffer *vb)
+{
+	struct hva_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+
+	if (ctx->fh.m2m_ctx)
+		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
+}
+
+static int hva_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct hva_ctx *ctx = vb2_get_drv_priv(vq);
+	struct hva_dev *hva = ctx_to_hdev(ctx);
+	struct device *dev = ctx_to_dev(ctx);
+	struct vb2_v4l2_buffer *vbuf;
+	int ret;
+	unsigned int i;
+	bool found = false;
+
+	dev_dbg(dev, "%s %s start streaming\n", ctx->name,
+		to_type_str(vq->type));
+
+	/* open encoder when both start_streaming have been called */
+	if (V4L2_TYPE_IS_OUTPUT(vq->type)) {
+		if (!vb2_start_streaming_called(&ctx->fh.m2m_ctx->cap_q_ctx.q))
+			return 0;
+	} else {
+		if (!vb2_start_streaming_called(&ctx->fh.m2m_ctx->out_q_ctx.q))
+			return 0;
+	}
+
+	/* store the instance context in the instances array */
+	for (i = 0; i < HVA_MAX_INSTANCES; i++) {
+		if (!hva->instances[i]) {
+			hva->instances[i] = ctx;
+			/* save the context identifier in the context */
+			ctx->id = i;
+			found = true;
+			break;
+		}
+	}
+
+	if (!found) {
+		dev_err(dev, "%s maximum instances reached\n", ctx->name);
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	hva->nb_of_instances++;
+
+	if (!ctx->enc) {
+		ret = hva_open_encoder(ctx,
+				       ctx->streaminfo.streamformat,
+				       ctx->frameinfo.pixelformat,
+				       &ctx->enc);
+		if (ret < 0)
+			goto err_ctx;
+	}
+
+	return 0;
+
+err_ctx:
+	hva->instances[ctx->id] = NULL;
+	hva->nb_of_instances--;
+err:
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		/* return of all pending buffers to vb2 (in queued state) */
+		while ((vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx)))
+			v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_QUEUED);
+	} else {
+		/* return of all pending buffers to vb2 (in queued state) */
+		while ((vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx)))
+			v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_QUEUED);
+	}
+
+	return ret;
+}
+
+static void hva_stop_streaming(struct vb2_queue *vq)
+{
+	struct hva_ctx *ctx = vb2_get_drv_priv(vq);
+	struct hva_dev *hva = ctx_to_hdev(ctx);
+	struct device *dev = ctx_to_dev(ctx);
+	const struct hva_enc *enc = ctx->enc;
+	struct vb2_v4l2_buffer *vbuf;
+
+	dev_dbg(dev, "%s %s stop streaming\n", ctx->name,
+		to_type_str(vq->type));
+
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		/* return of all pending buffers to vb2 (in error state) */
+		ctx->frame_num = 0;
+		while ((vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx)))
+			v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
+	} else {
+		/* return of all pending buffers to vb2 (in error state) */
+		ctx->stream_num = 0;
+		while ((vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx)))
+			v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
+	}
+
+	if ((V4L2_TYPE_IS_OUTPUT(vq->type) &&
+	     vb2_is_streaming(&ctx->fh.m2m_ctx->cap_q_ctx.q)) ||
+	    (!V4L2_TYPE_IS_OUTPUT(vq->type) &&
+	     vb2_is_streaming(&ctx->fh.m2m_ctx->out_q_ctx.q))) {
+		dev_dbg(dev, "%s %s out=%d cap=%d\n",
+			ctx->name, to_type_str(vq->type),
+			vb2_is_streaming(&ctx->fh.m2m_ctx->out_q_ctx.q),
+			vb2_is_streaming(&ctx->fh.m2m_ctx->cap_q_ctx.q));
+		return;
+	}
+
+	/* close encoder when both stop_streaming have been called */
+	if (enc) {
+		dev_dbg(dev, "%s %s encoder closed\n", ctx->name, enc->name);
+		enc->close(ctx);
+		ctx->enc = NULL;
+
+		/* clear instance context in instances array */
+		hva->instances[ctx->id] = NULL;
+		hva->nb_of_instances--;
+	}
+
+	ctx->aborting = false;
+}
+
+/* VB2 queue ops */
+static const struct vb2_ops hva_qops = {
+	.queue_setup		= hva_queue_setup,
+	.buf_prepare		= hva_buf_prepare,
+	.buf_queue		= hva_buf_queue,
+	.start_streaming	= hva_start_streaming,
+	.stop_streaming		= hva_stop_streaming,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
+};
+
+/*
+ * V4L2 file operations
+ */
+
+static int queue_init(struct hva_ctx *ctx, struct vb2_queue *vq)
+{
+	vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	vq->drv_priv = ctx;
+	vq->ops = &hva_qops;
+	vq->mem_ops = &vb2_dma_contig_memops;
+	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	vq->lock = &ctx->hva_dev->lock;
+
+	return vb2_queue_init(vq);
+}
+
+static int hva_queue_init(void *priv, struct vb2_queue *src_vq,
+			  struct vb2_queue *dst_vq)
+{
+	struct hva_ctx *ctx = priv;
+	int ret;
+
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	src_vq->buf_struct_size = sizeof(struct hva_frame);
+	src_vq->min_buffers_needed = MIN_FRAMES;
+	src_vq->dev = ctx->hva_dev->dev;
+
+	ret = queue_init(ctx, src_vq);
+	if (ret)
+		return ret;
+
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	dst_vq->buf_struct_size = sizeof(struct hva_stream);
+	dst_vq->min_buffers_needed = MIN_STREAMS;
+	dst_vq->dev = ctx->hva_dev->dev;
+
+	return queue_init(ctx, dst_vq);
+}
+
+static int hva_open(struct file *file)
+{
+	struct hva_dev *hva = video_drvdata(file);
+	struct device *dev = hva_to_dev(hva);
+	struct hva_ctx *ctx;
+	int ret;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	ctx->hva_dev = hva;
+
+	INIT_WORK(&ctx->run_work, hva_run_work);
+	v4l2_fh_init(&ctx->fh, video_devdata(file));
+	file->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+
+	ret = hva_ctrls_setup(ctx);
+	if (ret) {
+		dev_err(dev, "%s [x:x] failed to setup controls\n",
+			HVA_PREFIX);
+		goto err_fh;
+	}
+	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
+
+	mutex_init(&ctx->lock);
+
+	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(hva->m2m_dev, ctx,
+					    &hva_queue_init);
+	if (IS_ERR(ctx->fh.m2m_ctx)) {
+		ret = PTR_ERR(ctx->fh.m2m_ctx);
+		dev_err(dev, "%s [x:x] failed to initialize m2m context (%d)\n",
+			HVA_PREFIX, ret);
+		goto err_ctrls;
+	}
+
+	/* set the instance name */
+	mutex_lock(&hva->lock);
+	hva->instance_id++;
+	snprintf(ctx->name, sizeof(ctx->name), "[%3d:----]",
+		 hva->instance_id);
+	mutex_unlock(&hva->lock);
+
+	/* default parameters for frame and stream */
+	set_default_params(ctx);
+
+	dev_info(dev, "%s encoder instance created\n", ctx->name);
+
+	return 0;
+
+err_ctrls:
+	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+err_fh:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	kfree(ctx);
+out:
+	return ret;
+}
+
+static int hva_release(struct file *file)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+
+	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
+
+	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+
+	dev_info(dev, "%s encoder instance released\n", ctx->name);
+
+	kfree(ctx);
+
+	return 0;
+}
+
+/* V4L2 file ops */
+static const struct v4l2_file_operations hva_fops = {
+	.owner			= THIS_MODULE,
+	.open			= hva_open,
+	.release		= hva_release,
+	.unlocked_ioctl		= video_ioctl2,
+	.mmap			= v4l2_m2m_fop_mmap,
+	.poll			= v4l2_m2m_fop_poll,
+};
+
+/*
+ * Platform device operations
+ */
+
+static int hva_register_device(struct hva_dev *hva)
+{
+	int ret;
+	struct video_device *vdev;
+	struct device *dev;
+
+	if (!hva)
+		return -ENODEV;
+	dev = hva_to_dev(hva);
+
+	hva->m2m_dev = v4l2_m2m_init(&hva_m2m_ops);
+	if (IS_ERR(hva->m2m_dev)) {
+		dev_err(dev, "%s %s failed to initialize v4l2-m2m device\n",
+			HVA_PREFIX, HVA_NAME);
+		ret = PTR_ERR(hva->m2m_dev);
+		goto err;
+	}
+
+	vdev = video_device_alloc();
+	if (!vdev) {
+		dev_err(dev, "%s %s failed to allocate video device\n",
+			HVA_PREFIX, HVA_NAME);
+		ret = -ENOMEM;
+		goto err_m2m_release;
+	}
+
+	vdev->fops = &hva_fops;
+	vdev->ioctl_ops = &hva_ioctl_ops;
+	vdev->release = video_device_release;
+	vdev->lock = &hva->lock;
+	vdev->vfl_dir = VFL_DIR_M2M;
+	vdev->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M;
+	vdev->v4l2_dev = &hva->v4l2_dev;
+	snprintf(vdev->name, sizeof(vdev->name), "%s%lx", HVA_NAME,
+		 hva->ip_version);
+
+	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		dev_err(dev, "%s %s failed to register video device\n",
+			HVA_PREFIX, HVA_NAME);
+		goto err_vdev_release;
+	}
+
+	hva->vdev = vdev;
+	video_set_drvdata(vdev, hva);
+	return 0;
+
+err_vdev_release:
+	video_device_release(vdev);
+err_m2m_release:
+	v4l2_m2m_release(hva->m2m_dev);
+err:
+	return ret;
+}
+
+static void hva_unregister_device(struct hva_dev *hva)
+{
+	if (!hva)
+		return;
+
+	if (hva->m2m_dev)
+		v4l2_m2m_release(hva->m2m_dev);
+
+	video_unregister_device(hva->vdev);
+}
+
+static int hva_probe(struct platform_device *pdev)
+{
+	struct hva_dev *hva;
+	struct device *dev = &pdev->dev;
+	int ret;
+
+	hva = devm_kzalloc(dev, sizeof(*hva), GFP_KERNEL);
+	if (!hva) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	hva->dev = dev;
+	hva->pdev = pdev;
+	platform_set_drvdata(pdev, hva);
+
+	mutex_init(&hva->lock);
+
+	/* probe hardware */
+	ret = hva_hw_probe(pdev, hva);
+	if (ret)
+		goto err;
+
+	/* register all available encoders */
+	register_encoders(hva);
+
+	/* register all supported formats */
+	register_formats(hva);
+
+	/* register on V4L2 */
+	ret = v4l2_device_register(dev, &hva->v4l2_dev);
+	if (ret) {
+		dev_err(dev, "%s %s failed to register V4L2 device\n",
+			HVA_PREFIX, HVA_NAME);
+		goto err_hw;
+	}
+
+	hva->work_queue = create_workqueue(HVA_NAME);
+	if (!hva->work_queue) {
+		dev_err(dev, "%s %s failed to allocate work queue\n",
+			HVA_PREFIX, HVA_NAME);
+		ret = -ENOMEM;
+		goto err_v4l2;
+	}
+
+	/* register device */
+	ret = hva_register_device(hva);
+	if (ret)
+		goto err_work_queue;
+
+	dev_info(dev, "%s %s registered as /dev/video%d\n", HVA_PREFIX,
+		 HVA_NAME, hva->vdev->num);
+
+	return 0;
+
+err_work_queue:
+	destroy_workqueue(hva->work_queue);
+err_v4l2:
+	v4l2_device_unregister(&hva->v4l2_dev);
+err_hw:
+	hva_hw_remove(hva);
+err:
+	return ret;
+}
+
+static int hva_remove(struct platform_device *pdev)
+{
+	struct hva_dev *hva = platform_get_drvdata(pdev);
+	struct device *dev = hva_to_dev(hva);
+
+	hva_unregister_device(hva);
+
+	destroy_workqueue(hva->work_queue);
+
+	hva_hw_remove(hva);
+
+	v4l2_device_unregister(&hva->v4l2_dev);
+
+	dev_info(dev, "%s %s removed\n", HVA_PREFIX, pdev->name);
+
+	return 0;
+}
+
+/* PM ops */
+static const struct dev_pm_ops hva_pm_ops = {
+	.runtime_suspend	= hva_hw_runtime_suspend,
+	.runtime_resume		= hva_hw_runtime_resume,
+};
+
+static const struct of_device_id hva_match_types[] = {
+	{
+	 .compatible = "st,sti-hva",
+	},
+	{ /* end node */ }
+};
+
+MODULE_DEVICE_TABLE(of, hva_match_types);
+
+struct platform_driver hva_driver = {
+	.probe  = hva_probe,
+	.remove = hva_remove,
+	.driver = {
+		.name		= HVA_NAME,
+		.owner		= THIS_MODULE,
+		.of_match_table	= hva_match_types,
+		.pm		= &hva_pm_ops,
+		},
+};
+
+module_platform_driver(hva_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Yannick Fertre <yannick.fertre@st.com>");
+MODULE_DESCRIPTION("HVA video encoder V4L2 driver");
diff --git a/drivers/media/platform/sti/hva/hva.h b/drivers/media/platform/sti/hva/hva.h
new file mode 100644
index 0000000..9e9da9e
--- /dev/null
+++ b/drivers/media/platform/sti/hva/hva.h
@@ -0,0 +1,290 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2015
+ * Authors: Yannick Fertre <yannick.fertre@st.com>
+ *          Hugues Fruchet <hugues.fruchet@st.com>
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef HVA_H
+#define HVA_H
+
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/videobuf2-v4l2.h>
+#include <media/v4l2-mem2mem.h>
+
+#define fh_to_ctx(f)    (container_of(f, struct hva_ctx, fh))
+
+#define hva_to_dev(h)   (h->dev)
+
+#define ctx_to_dev(c)   (c->hva_dev->dev)
+
+#define ctx_to_hdev(c)  (c->hva_dev)
+
+#define HVA_PREFIX "[---:----]"
+
+/**
+ * struct hva_frameinfo - information about hva frame
+ *
+ * @pixelformat:    fourcc code for uncompressed video format
+ * @width:          width of frame
+ * @height:         height of frame
+ * @aligned_width:  width of frame (with encoder alignment constraint)
+ * @aligned_height: height of frame (with encoder alignment constraint)
+ * @size:           maximum size in bytes required for data
+*/
+struct hva_frameinfo {
+	u32	pixelformat;
+	u32	width;
+	u32	height;
+	u32	aligned_width;
+	u32	aligned_height;
+	u32	size;
+};
+
+/**
+ * struct hva_streaminfo - information about hva stream
+ *
+ * @streamformat: fourcc code of compressed video format (H.264...)
+ * @width:        width of stream
+ * @height:       height of stream
+ * @profile:      profile string
+ * @level:        level string
+ */
+struct hva_streaminfo {
+	u32	streamformat;
+	u32	width;
+	u32	height;
+	u8	profile[32];
+	u8	level[32];
+};
+
+/**
+ * struct hva_controls - hva controls set
+ *
+ * @time_per_frame: time per frame in seconds
+ * @bitrate_mode:   bitrate mode (constant bitrate or variable bitrate)
+ * @gop_size:       groupe of picture size
+ * @bitrate:        bitrate (in kbps)
+ * @aspect:         video aspect
+ */
+struct hva_controls {
+	struct v4l2_fract			time_per_frame;
+	enum v4l2_mpeg_video_bitrate_mode	bitrate_mode;
+	u32					gop_size;
+	u32					bitrate;
+	enum v4l2_mpeg_video_aspect		aspect;
+};
+
+/**
+ * struct hva_frame - hva frame buffer (output)
+ *
+ * @vbuf:     video buffer information for V4L2
+ * @list:     V4L2 m2m list that the frame belongs to
+ * @info:     frame information (width, height, format, alignment...)
+ * @paddr:    physical address (for hardware)
+ * @vaddr:    virtual address (kernel can read/write)
+ * @prepared: true if vaddr/paddr are resolved
+ */
+struct hva_frame {
+	struct vb2_v4l2_buffer	vbuf;
+	struct list_head	list;
+	struct hva_frameinfo	info;
+	dma_addr_t		paddr;
+	void			*vaddr;
+	bool			prepared;
+};
+
+/*
+ * to_hva_frame() - cast struct vb2_v4l2_buffer * to struct hva_frame *
+ */
+#define to_hva_frame(vb) \
+	container_of(vb, struct hva_frame, vbuf)
+
+/**
+ * struct hva_stream - hva stream buffer (capture)
+ *
+ * @v4l2:       video buffer information for V4L2
+ * @list:       V4L2 m2m list that the frame belongs to
+ * @paddr:      physical address (for hardware)
+ * @vaddr:      virtual address (kernel can read/write)
+ * @prepared:   true if vaddr/paddr are resolved
+ * @size:       size of the buffer in bytes
+ * @bytesused:  number of bytes occupied by data in the buffer
+ */
+struct hva_stream {
+	struct vb2_v4l2_buffer	vbuf;
+	struct list_head	list;
+	dma_addr_t		paddr;
+	void			*vaddr;
+	int			prepared;
+	unsigned int		size;
+	unsigned int		bytesused;
+};
+
+/*
+ * to_hva_stream() - cast struct vb2_v4l2_buffer * to struct hva_stream *
+ */
+#define to_hva_stream(vb) \
+	container_of(vb, struct hva_stream, vbuf)
+
+struct hva_dev;
+struct hva_enc;
+
+/**
+ * struct hva_ctx - context of hva instance
+ *
+ * @hva_dev:         the device that this instance is associated with
+ * @fh:              V4L2 file handle
+ * @ctrl_handler:    V4L2 controls handler
+ * @ctrls:           hva controls set
+ * @id:              instance identifier
+ * @aborting:        true if current job aborted
+ * @name:            instance name (debug purpose)
+ * @run_work:        encode work
+ * @lock:            mutex used to lock access of this context
+ * @flags:           validity of streaminfo and frameinfo fields
+ * @frame_num:       frame number
+ * @stream_num:      stream number
+ * @max_stream_size: maximum size in bytes required for stream data
+ * @colorspace:      colorspace identifier
+ * @xfer_func:       transfer function identifier
+ * @ycbcr_enc:       Y'CbCr encoding identifier
+ * @quantization:    quantization identifier
+ * @streaminfo:      stream properties
+ * @frameinfo:       frame properties
+ * @enc:             current encoder
+ * @priv:            private codec data for this instance, allocated
+ *                   by encoder @open time
+ * @hw_err:          true if hardware error detected
+ */
+struct hva_ctx {
+	struct hva_dev		        *hva_dev;
+	struct v4l2_fh			fh;
+	struct v4l2_ctrl_handler	ctrl_handler;
+	struct hva_controls		ctrls;
+	u8				id;
+	bool				aborting;
+	char				name[100];
+	struct work_struct		run_work;
+	/* mutex protecting this data structure */
+	struct mutex			lock;
+	u32				flags;
+	u32				frame_num;
+	u32				stream_num;
+	u32				max_stream_size;
+	enum v4l2_colorspace		colorspace;
+	enum v4l2_xfer_func		xfer_func;
+	enum v4l2_ycbcr_encoding	ycbcr_enc;
+	enum v4l2_quantization		quantization;
+	struct hva_streaminfo		streaminfo;
+	struct hva_frameinfo		frameinfo;
+	struct hva_enc			*enc;
+	void				*priv;
+	bool				hw_err;
+};
+
+#define HVA_FLAG_STREAMINFO	0x0001
+#define HVA_FLAG_FRAMEINFO	0x0002
+
+#define HVA_MAX_INSTANCES	16
+#define HVA_MAX_ENCODERS	10
+#define HVA_MAX_FORMATS		HVA_MAX_ENCODERS
+
+/**
+ * struct hva_dev - abstraction for hva entity
+ *
+ * @v4l2_dev:            V4L2 device
+ * @vdev:                video device
+ * @pdev:                platform device
+ * @dev:                 device
+ * @lock:                mutex used for critical sections & V4L2 ops
+ *                       serialization
+ * @m2m_dev:             memory-to-memory V4L2 device informatio
+ * @instances:           opened instances
+ * @nb_of_instances:     number of opened instances
+ * @instance_id:         rolling counter identifying an instance (debug purpose)
+ * @regs:                register io memory access
+ * @esram_addr:          esram address
+ * @esram_size:          esram size
+ * @clk:                 hva clock
+ * @irq_its:             status interruption
+ * @irq_err:             error interruption
+ * @work_queue:          work queue to handle the encode jobs
+ * @protect_mutex:       mutex used to lock access of hardware
+ * @interrupt:           completion interrupt
+ * @ip_version:          IP hardware version
+ * @encoders:            registered encoders
+ * @nb_of_encoders:      number of registered encoders
+ * @pixelformats:        supported uncompressed video formats
+ * @nb_of_pixelformats:  number of supported umcompressed video formats
+ * @streamformats:       supported compressed video formats
+ * @nb_of_streamformats: number of supported compressed video formats
+ * @sfl_reg:             status fifo level register value
+ * @sts_reg:             status register value
+ * @lmi_err_reg:         local memory interface error register value
+ * @emi_err_reg:         external memory interface error register value
+ * @hec_mif_err_reg:     HEC memory interface error register value
+ */
+struct hva_dev {
+	struct v4l2_device	v4l2_dev;
+	struct video_device	*vdev;
+	struct platform_device	*pdev;
+	struct device		*dev;
+	/* mutex protecting vb2_queue structure */
+	struct mutex		lock;
+	struct v4l2_m2m_dev	*m2m_dev;
+	struct hva_ctx		*instances[HVA_MAX_INSTANCES];
+	unsigned int		nb_of_instances;
+	unsigned int		instance_id;
+	void __iomem		*regs;
+	u32			esram_addr;
+	u32			esram_size;
+	struct clk		*clk;
+	int			irq_its;
+	int			irq_err;
+	struct workqueue_struct *work_queue;
+	/* mutex protecting hardware access */
+	struct mutex		protect_mutex;
+	struct completion	interrupt;
+	unsigned long int	ip_version;
+	const struct hva_enc	*encoders[HVA_MAX_ENCODERS];
+	u32			nb_of_encoders;
+	u32			pixelformats[HVA_MAX_FORMATS];
+	u32			nb_of_pixelformats;
+	u32			streamformats[HVA_MAX_FORMATS];
+	u32			nb_of_streamformats;
+	u32			sfl_reg;
+	u32			sts_reg;
+	u32			lmi_err_reg;
+	u32			emi_err_reg;
+	u32			hec_mif_err_reg;
+};
+
+/**
+ * struct hva_enc - hva encoder
+ *
+ * @name:         encoder name
+ * @streamformat: fourcc code for compressed video format (H.264...)
+ * @pixelformat:  fourcc code for uncompressed video format
+ * @max_width:    maximum width of frame for this encoder
+ * @max_height:   maximum height of frame for this encoder
+ * @open:         open encoder
+ * @close:        close encoder
+ * @encode:       encode a frame (struct hva_frame) in a stream
+ *                (struct hva_stream)
+ */
+
+struct hva_enc {
+	const char	*name;
+	u32		streamformat;
+	u32		pixelformat;
+	u32		max_width;
+	u32		max_height;
+	int		(*open)(struct hva_ctx *ctx);
+	int		(*close)(struct hva_ctx *ctx);
+	int		(*encode)(struct hva_ctx *ctx, struct hva_frame *frame,
+				  struct hva_stream *stream);
+};
+
+#endif /* HVA_H */
-- 
1.9.1

