Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:43459 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750986AbbLRKpo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 05:45:44 -0500
From: Yannick Fertre <yannick.fertre@st.com>
To: <linux-media@vger.kernel.org>
CC: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	<hugues.fruchet@st.com>, <kernel@stlinux.com>
Subject: [PATCH 2/3] [media] hva: STiH41x multi-format video encoder V4L2 driver
Date: Fri, 18 Dec 2015 11:45:32 +0100
Message-ID: <1450435533-15974-3-git-send-email-yannick.fertre@st.com>
In-Reply-To: <1450435533-15974-1-git-send-email-yannick.fertre@st.com>
References: <1450435533-15974-1-git-send-email-yannick.fertre@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds HVA (Hardware Video Accelerator) support for STI platform.

Signed-off-by: Yannick Fertre <yannick.fertre@st.com>
---
 drivers/media/platform/Kconfig            |   13 +
 drivers/media/platform/Makefile           |    1 +
 drivers/media/platform/sti/hva/Makefile   |    2 +
 drivers/media/platform/sti/hva/hva-hw.c   |  561 ++++++++++++
 drivers/media/platform/sti/hva/hva-hw.h   |   76 ++
 drivers/media/platform/sti/hva/hva-mem.c  |   63 ++
 drivers/media/platform/sti/hva/hva-mem.h  |   20 +
 drivers/media/platform/sti/hva/hva-v4l2.c | 1404 +++++++++++++++++++++++++++++
 drivers/media/platform/sti/hva/hva.h      |  499 ++++++++++
 9 files changed, 2639 insertions(+)
 create mode 100644 drivers/media/platform/sti/hva/Makefile
 create mode 100644 drivers/media/platform/sti/hva/hva-hw.c
 create mode 100644 drivers/media/platform/sti/hva/hva-hw.h
 create mode 100644 drivers/media/platform/sti/hva/hva-mem.c
 create mode 100644 drivers/media/platform/sti/hva/hva-mem.h
 create mode 100644 drivers/media/platform/sti/hva/hva-v4l2.c
 create mode 100644 drivers/media/platform/sti/hva/hva.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 5263594..50b5f83 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -221,6 +221,19 @@ config VIDEO_STI_BDISP
 	help
 	  This v4l2 mem2mem driver is a 2D blitter for STMicroelectronics SoC.
 
+config VIDEO_STI_HVA
+	tristate "STMicroelectronics STiH41x HVA multi-format video encoder V4L2 driver"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on ARCH_STI || COMPILE_TEST
+	select VIDEOBUF2_DMA_CONTIG
+	help
+	  This V4L2 driver enables HVA multi-format video encoder of
+	  STMicroelectronics SoC STiH41x series, allowing hardware encoding of raw
+	  uncompressed formats in various compressed video & jpeg bitstreams format.
+
+	  To compile this driver as a module, choose M here:
+	  the module will be called hva.
+
 config VIDEO_SH_VEU
 	tristate "SuperH VEU mem2mem video processing driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index efa0295..d7740d8 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+= s5p-g2d/
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
index 0000000..00b915b
--- /dev/null
+++ b/drivers/media/platform/sti/hva/hva-hw.c
@@ -0,0 +1,561 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2015
+ * Authors: Yannick Fertre <yannick.fertre@st.com>
+ *          Hugues Fruchet <hugues.fruchet@st.com>
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/clk.h>
+#include <linux/completion.h>
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/time.h>
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
+static irqreturn_t hva_hw_its_interrupt(int irq, void *data)
+{
+	struct hva_device *hva = data;
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
+	struct hva_device *hva = arg;
+	struct device *dev = hva_to_dev(hva);
+	u32 status = hva->sts_reg & 0xFF;
+	u8 client_id = (hva->sts_reg & 0xFF00) >> 8;
+	struct hva_ctx *ctx = NULL;
+
+	dev_dbg(dev, "%s     %s: status :0x%02x fifo level :0x%02x\n",
+		HVA_PREFIX, __func__, hva->sts_reg & 0xFF, hva->sfl_reg & 0xF);
+
+	/* check client ID */
+	if (client_id >= MAX_CONTEXT) {
+		dev_err(dev, "%s     %s: bad client identifier: %d\n",
+			ctx->name, __func__, client_id);
+		ctx->encode_errors++;
+		ctx->hw_err = true;
+		goto out;
+	}
+
+	ctx = hva->contexts_list[client_id];
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
+	case JPEG_BITSTREAM_OVERSIZE:
+		dev_err(dev, "%s     %s:jpeg bitstream oversize\n",
+			ctx->name, __func__);
+		ctx->encode_errors++;
+		ctx->hw_err = true;
+		break;
+	case H264_BITSTREAM_OVERSIZE:
+		dev_err(dev, "%s     %s:h264 bitstream oversize\n",
+			ctx->name, __func__);
+		ctx->encode_errors++;
+		ctx->hw_err = true;
+		break;
+	case H264_SLICE_LIMIT_SIZE:
+		dev_err(dev, "%s     %s: h264 slice limit size is reached\n",
+			ctx->name, __func__);
+		ctx->encode_errors++;
+		ctx->hw_err = true;
+		break;
+	case H264_MAX_SLICE_NUMBER:
+		dev_err(dev, "%s     %s: h264 max slice number is reached\n",
+			ctx->name, __func__);
+		ctx->encode_errors++;
+		ctx->hw_err = true;
+		break;
+	case TASK_LIST_FULL:
+		dev_err(dev, "%s     %s:task list full\n",
+			ctx->name, __func__);
+		ctx->encode_errors++;
+		ctx->hw_err = true;
+		break;
+	case UNKNOWN_COMMAND:
+		dev_err(dev, "%s     %s:command not known\n",
+			ctx->name, __func__);
+		ctx->encode_errors++;
+		ctx->hw_err = true;
+		break;
+	case WRONG_CODEC_OR_RESOLUTION:
+		dev_err(dev, "%s     %s:wrong codec or resolution\n",
+			ctx->name, __func__);
+		ctx->encode_errors++;
+		ctx->hw_err = true;
+		break;
+	default:
+		dev_err(dev, "%s     %s:status not recognized\n",
+			ctx->name, __func__);
+		ctx->encode_errors++;
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
+	struct hva_device *hva = data;
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
+	struct hva_device *hva = arg;
+	struct device *dev = hva_to_dev(hva);
+	u8 client_id = 0;
+	struct hva_ctx *ctx;
+
+	dev_dbg(dev, "%s     status :0x%02x fifo level :0x%02x\n",
+		HVA_PREFIX, hva->sts_reg & 0xFF, hva->sfl_reg & 0xF);
+
+	/* check client ID */
+	client_id = (hva->sts_reg & 0xFF00) >> 8;
+	if (client_id >= MAX_CONTEXT) {
+		dev_err(dev, "%s     bad client identifier: %d\n", HVA_PREFIX,
+			client_id);
+		goto out;
+	}
+
+	ctx = hva->contexts_list[client_id];
+
+	if (hva->lmi_err_reg) {
+		dev_err(dev, "%s     local memory interface error :0x%08x\n",
+			ctx->name, hva->lmi_err_reg);
+		ctx->encode_errors++;
+		ctx->hw_err = true;
+	}
+
+	if (hva->lmi_err_reg) {
+		dev_err(dev, "%s     external memory iterface error :0x%08x\n",
+			ctx->name, hva->emi_err_reg);
+		ctx->encode_errors++;
+		ctx->hw_err = true;
+	}
+
+	if (hva->hec_mif_err_reg) {
+		dev_err(dev, "%s     hec memory interface error :0x%08x\n",
+			ctx->name, hva->hec_mif_err_reg);
+		ctx->encode_errors++;
+		ctx->hw_err = true;
+	}
+out:
+	complete(&hva->interrupt);
+
+	return IRQ_HANDLED;
+}
+
+static unsigned long int hva_hw_get_chipset_id(struct hva_device *hva)
+{
+	struct device *dev = hva_to_dev(hva);
+	unsigned long int id;
+
+	mutex_lock(&hva->protect_mutex);
+
+	if (pm_runtime_get_sync(dev) < 0) {
+		dev_err(dev, "%s     get pm_runtime failed\n", HVA_PREFIX);
+		mutex_unlock(&hva->protect_mutex);
+		return -EFAULT;
+	}
+
+	id = readl_relaxed(hva->regs + HVA_HIF_REG_VERSION) &
+			   VERSION_ID_MASK;
+
+	pm_runtime_put_autosuspend(dev);
+
+	mutex_unlock(&hva->protect_mutex);
+
+	switch (id) {
+	case HVA_VERSION_V400:
+	case HVA_VERSION_V397:
+		dev_info(dev, "%s     chipset identifier 0x%lx\n",
+			 HVA_PREFIX, id);
+		break;
+	default:
+		dev_err(dev, "%s     unknown chipset identifier 0x%lx\n",
+			HVA_PREFIX, id);
+		id = HVA_VERSION_UNKNOWN;
+		break;
+	}
+
+	return id;
+}
+
+int hva_hw_probe(struct platform_device *pdev, struct hva_device *hva)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *regs;
+	struct resource *esram;
+	int irq = 0;
+	int ret = 0;
+
+	WARN_ON(!hva);
+	hva->pdev = pdev;
+	hva->dev = dev;
+
+	/* get a memory region for mmio */
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	hva->regs = devm_ioremap_resource(dev, regs);
+	if (IS_ERR_OR_NULL(hva->regs)) {
+		dev_err(dev, "%s     failed to get regs\n", HVA_PREFIX);
+		return PTR_ERR(hva->regs);
+	}
+
+	/* get a memory region for esram from device tree */
+	esram = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (IS_ERR_OR_NULL(esram)) {
+		dev_err(dev, "%s     failed to get esram region\n", HVA_PREFIX);
+		return PTR_ERR(esram);
+	}
+
+	hva->esram_addr = esram->start;
+	hva->esram_size = esram->end - esram->start + 1;
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
+	/* retrieve irq number from board resources */
+	hva->irq_its = platform_get_irq(pdev, 0);
+	if (!hva->irq_its) {
+		dev_err(dev, "%s     failed to get IRQ resource\n", HVA_PREFIX);
+		goto err_clk;
+	}
+
+	/* request irq */
+	ret = devm_request_threaded_irq(dev, hva->irq_its, hva_hw_its_interrupt,
+					hva_hw_its_irq_thread,
+					IRQF_ONESHOT,
+					"hva_its_irq", (void *)hva);
+	if (ret) {
+		dev_err(dev, "%s     failed to register its IRQ 0x%x\n",
+			HVA_PREFIX, irq);
+		goto err_clk;
+	}
+	disable_irq(hva->irq_its);
+
+	/* retrieve irq number from board resources */
+	hva->irq_err = platform_get_irq(pdev, 1);
+	if (!hva->irq_err) {
+		dev_err(dev, "%s     failed to get IRQ resource\n", HVA_PREFIX);
+		goto err_clk;
+	}
+
+	/* request irq */
+	ret = devm_request_threaded_irq(dev, hva->irq_err, hva_hw_err_interrupt,
+					hva_hw_err_irq_thread,
+					IRQF_ONESHOT,
+					"hva_err_irq", (void *)hva);
+	if (ret) {
+		dev_err(dev, "%s     failed to register err IRQ 0x%x\n",
+			HVA_PREFIX, irq);
+		goto err_clk;
+	}
+	disable_irq(hva->irq_err);
+
+	/* initialisation of the protection mutex */
+	mutex_init(&hva->protect_mutex);
+
+	/* initialisation of completion signal */
+	init_completion(&hva->interrupt);
+
+	/* init pm_runtime used for power management */
+	pm_runtime_set_autosuspend_delay(dev, AUTOSUSPEND_DELAY_MS);
+	pm_runtime_use_autosuspend(dev);
+	pm_runtime_set_suspended(dev);
+	pm_runtime_enable(dev);
+
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0) {
+		dev_err(dev, "%s     failed to set PM\n", HVA_PREFIX);
+		goto err_pm;
+	}
+
+	/* check hardware ID */
+	hva->chip_id = hva_hw_get_chipset_id(hva);
+
+	if (hva->chip_id == HVA_VERSION_UNKNOWN) {
+		ret = -EINVAL;
+		goto err_pm;
+	}
+
+	dev_info(dev, "%s     found hva device (id=%lx)\n", HVA_PREFIX,
+		 hva->chip_id);
+
+	return 0;
+err_pm:
+	pm_runtime_put(dev);
+err_clk:
+	if (hva->clk)
+		clk_unprepare(hva->clk);
+
+	return ret;
+}
+
+void hva_hw_remove(struct hva_device *hva)
+{
+	struct device *dev = hva_to_dev(hva);
+
+	/* disable interrupt */
+	disable_irq(hva->irq_its);
+	disable_irq(hva->irq_err);
+
+	pm_runtime_put_autosuspend(dev);
+	pm_runtime_disable(dev);
+}
+
+int hva_hw_runtime_suspend(struct device *dev)
+{
+	struct hva_device *hva = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(hva->clk);
+
+	return 0;
+}
+
+int hva_hw_runtime_resume(struct device *dev)
+{
+	struct hva_device *hva = dev_get_drvdata(dev);
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
+	struct hva_device *hva = ctx_to_hdev(ctx);
+	struct device *dev = hva_to_dev(hva);
+	unsigned long int version = 0;
+	u8 client_id = ctx->client_id;
+	u32 reg = 0;
+
+	mutex_lock(&hva->protect_mutex);
+
+	/* enable irqs */
+	enable_irq(hva->irq_its);
+	enable_irq(hva->irq_err);
+
+	if (pm_runtime_get_sync(dev) < 0) {
+		dev_err(dev, "%s     get pm_runtime failed\n", ctx->name);
+		ctx->sys_errors++;
+		goto out;
+	}
+
+	version = readl_relaxed(hva->regs + HVA_HIF_REG_VERSION) &
+		  VERSION_ID_MASK;
+
+	reg = readl_relaxed(hva->regs + HVA_HIF_REG_CLK_GATING);
+	switch (cmd) {
+	case JPEG_ENC:
+		reg |= CLK_GATING_HJE;
+		break;
+	case H264_ENC:
+	case VP8_ENC:
+		reg |= CLK_GATING_HVC;
+		break;
+	default:
+		dev_warn(dev, "%s     unknown command 0x%x\n", ctx->name, cmd);
+		goto out;
+	}
+	writel_relaxed(reg, hva->regs + HVA_HIF_REG_CLK_GATING);
+
+	dev_dbg(dev, "%s     %s: Write configuration registers\n", ctx->name,
+		__func__);
+
+	/* byte swap config */
+	switch (version) {
+	case HVA_VERSION_V397:
+	case HVA_VERSION_V400:
+		writel_relaxed(BSM_CFG_VAL1,
+			       hva->regs + HVA_HIF_REG_BSM);
+		break;
+	default:
+		dev_err(dev, "%s     unknown chipset identifier 0x%lx\n",
+			ctx->name, version);
+		ctx->sys_errors++;
+		goto out;
+	}
+
+	/*
+	 * define Max Opcode Size and Max Message Size
+	 * for LMI and EMI
+	 */
+	switch (version) {
+	case HVA_VERSION_V397:
+	case HVA_VERSION_V400:
+		writel_relaxed(MIF_CFG_VAL3,
+			       hva->regs + HVA_HIF_REG_MIF_CFG);
+		writel_relaxed(HEC_MIF_CFG_VAL,
+			       hva->regs + HVA_HIF_REG_HEC_MIF_CFG);
+		break;
+	default:
+		/* do nothing */
+		break;
+	}
+
+	/* command FIFO: task_id[31:16] client_id[15:8] command_type[7:0] */
+	dev_dbg(dev, "%s     %s: Send task ( cmd:%d, task_desc:0x%x)\n",
+		ctx->name, __func__, cmd + (client_id << 8), task->paddr);
+	writel_relaxed(cmd + (client_id << 8), hva->regs + HVA_HIF_FIFO_CMD);
+	writel_relaxed(task->paddr, hva->regs + HVA_HIF_FIFO_CMD);
+
+	if (!wait_for_completion_timeout(&hva->interrupt,
+					 msecs_to_jiffies(2000))) {
+		dev_err(dev, "%s     %s:Time out on completion\n", ctx->name,
+			__func__);
+		ctx->encode_errors++;
+		ctx->hw_err = true;
+	}
+out:
+	disable_irq(hva->irq_its);
+	disable_irq(hva->irq_err);
+
+	switch (cmd) {
+	case JPEG_ENC:
+		reg &= ~CLK_GATING_HJE;
+		writel_relaxed(reg, hva->regs + HVA_HIF_REG_CLK_GATING);
+		break;
+	case H264_ENC:
+	case VP8_ENC:
+		reg &= ~CLK_GATING_HVC;
+		writel_relaxed(reg, hva->regs + HVA_HIF_REG_CLK_GATING);
+
+		break;
+	default:
+		dev_warn(dev, "%s     unknown command 0x%x\n", ctx->name, cmd);
+	}
+
+	pm_runtime_put_autosuspend(dev);
+	mutex_unlock(&hva->protect_mutex);
+
+	if (ctx->hw_err)
+		return -EFAULT;
+
+	return 0;
+}
diff --git a/drivers/media/platform/sti/hva/hva-hw.h b/drivers/media/platform/sti/hva/hva-hw.h
new file mode 100644
index 0000000..b27465a
--- /dev/null
+++ b/drivers/media/platform/sti/hva/hva-hw.h
@@ -0,0 +1,76 @@
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
+/* HVA Versions */
+#define HVA_VERSION_UNKNOWN    0x000
+#define HVA_VERSION_V397       0x397
+#define HVA_VERSION_V400       0x400
+
+enum hva_hw_cmd_type {
+	/* RESERVED = 0x00 */
+	/* RESERVED = 0x01 */
+	H264_ENC = 0x02,
+	JPEG_ENC = 0x03,
+	/* SW synchro task (reserved in HW) */
+	/* RESERVED = 0x04 */
+	/* RESERVED = 0x05 */
+	VP8_ENC = 0x06,
+	/* RESERVED = 0x07 */
+	REMOVE_CLIENT = 0x08,
+	FREEZE_CLIENT = 0x09,
+	START_CLIENT = 0x0A,
+	FREEZE_ALL = 0x0B,
+	START_ALL = 0x0C,
+	REMOVE_ALL = 0x0D
+};
+
+/**
+ * hw encode error values
+ * NO_ERROR: Success, Task OK
+ * JPEG_BITSTREAM_OVERSIZE: VECJPEG Picture size > Max bitstream size
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
+	JPEG_BITSTREAM_OVERSIZE = 0x1,
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
+int hva_hw_probe(struct platform_device *pdev, struct hva_device *hva);
+void hva_hw_remove(struct hva_device *hva);
+int hva_hw_runtime_suspend(struct device *dev);
+int hva_hw_runtime_resume(struct device *dev);
+int hva_hw_execute_task(struct hva_ctx *ctx, enum hva_hw_cmd_type cmd,
+			struct hva_buffer *task);
+
+#endif /* HVA_HW_H */
diff --git a/drivers/media/platform/sti/hva/hva-mem.c b/drivers/media/platform/sti/hva/hva-mem.c
new file mode 100644
index 0000000..01da742
--- /dev/null
+++ b/drivers/media/platform/sti/hva/hva-mem.c
@@ -0,0 +1,63 @@
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
+	if (!b) {
+		ctx->sys_errors++;
+		return -ENOMEM;
+	}
+
+	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
+	base = dma_alloc_attrs(dev, size, &paddr, GFP_KERNEL | GFP_DMA, &attrs);
+	if (!base) {
+		dev_err(dev, "%s %s : dma_alloc_attrs failed for %s (size=%d)\n",
+			ctx->name, __func__, name, size);
+		ctx->sys_errors++;
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
+		"%s allocate %d bytes of HW memory @(virt=%p, phy=0x%x): %s\n",
+		ctx->name, size, b->vaddr, b->paddr, b->name);
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
+		"%s free %d bytes of HW memory @(virt=%p, phy=0x%x): %s\n",
+		ctx->name, buf->size, buf->vaddr, buf->paddr, buf->name);
+
+	dma_free_attrs(dev, buf->size, buf->vaddr, buf->paddr, &buf->attrs);
+
+	devm_kfree(dev, buf);
+}
diff --git a/drivers/media/platform/sti/hva/hva-mem.h b/drivers/media/platform/sti/hva/hva-mem.h
new file mode 100644
index 0000000..f181115
--- /dev/null
+++ b/drivers/media/platform/sti/hva/hva-mem.h
@@ -0,0 +1,20 @@
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
+int hva_mem_alloc(struct hva_ctx *ctx,
+		  __u32 size,
+		  const char *name,
+		  struct hva_buffer **buf);
+
+void hva_mem_free(struct hva_ctx *ctx,
+		  struct hva_buffer *buf);
+
+#endif /* HVA_MEM_H */
+
diff --git a/drivers/media/platform/sti/hva/hva-v4l2.c b/drivers/media/platform/sti/hva/hva-v4l2.c
new file mode 100644
index 0000000..051d2ea
--- /dev/null
+++ b/drivers/media/platform/sti/hva/hva-v4l2.c
@@ -0,0 +1,1404 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2015
+ * Authors: Yannick Fertre <yannick.fertre@st.com>
+ *          Hugues Fruchet <hugues.fruchet@st.com>
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/version.h>
+#include <linux/of.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
+#include "hva.h"
+#include "hva-hw.h"
+
+#define HVA_NAME "hva"
+
+/*
+ * 1 frame at least for user
+ * limit number of frames to 16
+ */
+#define MAX_FRAMES	16
+#define MIN_FRAMES	1
+
+#define HVA_MIN_WIDTH	32
+#define HVA_MAX_WIDTH	1920
+#define HVA_MIN_HEIGHT	32
+#define HVA_MAX_HEIGHT	1080
+
+#define DFT_CFG_WIDTH		HVA_MIN_WIDTH
+#define	DFT_CFG_HEIGHT		HVA_MIN_HEIGHT
+#define DFT_CFG_BITRATE_MODE	V4L2_MPEG_VIDEO_BITRATE_MODE_CBR
+#define DFT_CFG_GOP_SIZE	16
+#define DFT_CFG_INTRA_REFRESH	true
+#define DFT_CFG_FRAME_NUM	1
+#define DFT_CFG_FRAME_DEN	30
+#define DFT_CFG_QPMIN		5
+#define DFT_CFG_QPMAX		51
+#define DFT_CFG_DCT8X8		false
+#define DFT_CFG_COMP_QUALITY	85
+#define DFT_CFG_SAR_ENABLE	1
+#define DFT_CFG_BITRATE		(20000 * 1024)
+#define DFT_CFG_CPB_SIZE	(25000 * 1024)
+
+static const struct hva_frameinfo frame_dflt_fmt = {
+	.fmt		= {
+				.pixelformat	= V4L2_PIX_FMT_NV12,
+				.nb_planes	= 2,
+				.bpp		= 12,
+				.bpp_plane0	= 8,
+				.w_align	= 2,
+				.h_align	= 2
+			  },
+	.width		= DFT_CFG_WIDTH,
+	.height		= DFT_CFG_HEIGHT,
+	.crop		= {0, 0, DFT_CFG_WIDTH, DFT_CFG_HEIGHT},
+	.frame_width	= DFT_CFG_WIDTH,
+	.frame_height	= DFT_CFG_HEIGHT
+};
+
+static const struct hva_streaminfo stream_dflt_fmt = {
+	.width		= DFT_CFG_WIDTH,
+	.height		= DFT_CFG_HEIGHT
+};
+
+/* list of stream formats supported by hva hardware */
+const u32 stream_fmt[] = {
+};
+
+/* list of pixel formats supported by hva hardware */
+static const struct hva_frame_fmt frame_fmts[] = {
+	/* NV12. YUV420SP - 1 plane for Y + 1 plane for (CbCr) */
+	{
+		.pixelformat	= V4L2_PIX_FMT_NV12,
+		.nb_planes	= 2,
+		.bpp		= 12,
+		.bpp_plane0	= 8,
+		.w_align	= 2,
+		.h_align	= 2
+	},
+	/* NV21. YUV420SP - 1 plane for Y + 1 plane for (CbCr) */
+	{
+		.pixelformat	= V4L2_PIX_FMT_NV21,
+		.nb_planes	= 2,
+		.bpp		= 12,
+		.bpp_plane0	= 8,
+		.w_align	= 2,
+		.h_align	= 2
+	},
+};
+
+/* offset to differentiate OUTPUT/CAPTURE @mmap */
+#define MMAP_FRAME_OFFSET (UL(0x100000000) / 2)
+
+/* registry of available encoders */
+const struct hva_encoder *hva_encoders[] = {
+};
+
+static const struct hva_frame_fmt *hva_find_frame_fmt(u32 pixelformat)
+{
+	const struct hva_frame_fmt *fmt;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(frame_fmts); i++) {
+		fmt = &frame_fmts[i];
+		if (fmt->pixelformat == pixelformat)
+			return fmt;
+	}
+
+	return NULL;
+}
+
+static void register_encoder(struct hva_device *hva,
+			     const struct hva_encoder *enc)
+{
+	if (hva->nb_of_encoders >= HVA_MAX_ENCODERS) {
+		dev_warn(hva->dev,
+			 "%s can' t register encoder (max nb (%d) is reached!)\n",
+			 enc->name, HVA_MAX_ENCODERS);
+		return;
+	}
+
+	/* those encoder ops are mandatory */
+	WARN_ON(!enc->open);
+	WARN_ON(!enc->close);
+	WARN_ON(!enc->encode);
+
+	hva->encoders[hva->nb_of_encoders] = enc;
+	hva->nb_of_encoders++;
+	dev_info(hva->dev, "%s encoder registered\n", enc->name);
+}
+
+static void register_all(struct hva_device *hva)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(hva_encoders); i++)
+		register_encoder(hva, hva_encoders[i]);
+}
+
+static int hva_open_encoder(struct hva_ctx *ctx, u32 streamformat,
+			    u32 pixelformat, struct hva_encoder **penc)
+{
+	struct hva_device *hva = ctx_to_hdev(ctx);
+	struct device *dev = ctx_to_dev(ctx);
+	struct hva_encoder *enc;
+	unsigned int i;
+	int ret;
+
+	/* find an encoder which can deal with these formats */
+	for (i = 0; i < hva->nb_of_encoders; i++) {
+		enc = (struct hva_encoder *)hva->encoders[i];
+		if ((enc->streamformat == streamformat) &&
+		    (enc->pixelformat == pixelformat))
+			break;	/* found */
+	}
+
+	if (i == hva->nb_of_encoders) {
+		dev_err(dev, "%s no encoder found matching %4.4s => %4.4s\n",
+			ctx->name, (char *)pixelformat, (char *)streamformat);
+		return -EINVAL;
+	}
+
+	dev_dbg(dev, "%s one encoder matching %4.4s => %4.4s\n",
+		ctx->name, (char *)&pixelformat, (char *)&streamformat);
+
+	/* update name instance */
+	snprintf(ctx->name, sizeof(ctx->name), "[%3d:%4.4s]",
+		 hva->instance_id, (char *)&streamformat);
+
+	/* open encoder instance */
+	ret = enc->open(ctx);
+	if (ret) {
+		dev_err(hva->dev, "%s enc->open failed (%d)\n",
+			ctx->name, ret);
+		return ret;
+	}
+
+	*penc = enc;
+
+	return ret;
+}
+
+/* v4l2 ioctl operations */
+
+static int hva_querycap(struct file *file, void *priv,
+			struct v4l2_capability *cap)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct hva_device *hva = ctx_to_hdev(ctx);
+
+	strlcpy(cap->driver, hva->pdev->name, sizeof(cap->driver));
+	strlcpy(cap->card, hva->pdev->name, sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
+		 HVA_NAME);
+
+	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	return 0;
+}
+
+static int hva_enum_fmt_frame(struct file *file, void *priv,
+			      struct v4l2_fmtdesc *f)
+{
+	/* index don't have to exceed number of  format supported */
+	if (f->index >=  ARRAY_SIZE(frame_fmts))
+		return -EINVAL;
+
+	/* pixel format */
+	f->pixelformat = frame_fmts[f->index].pixelformat;
+
+	return 0;
+}
+
+static int hva_enum_fmt_stream(struct file *file, void *priv,
+			       struct v4l2_fmtdesc *f)
+{
+	/* index don't have to exceed number of stream format supported */
+	if (f->index >= ARRAY_SIZE(stream_fmt))
+		return -EINVAL;
+
+	/* pixel format */
+	f->pixelformat = stream_fmt[f->index];
+
+	/* compressed */
+	f->flags = V4L2_FMT_FLAG_COMPRESSED;
+
+	return 0;
+}
+
+static int hva_try_fmt_stream(struct file *file, void *priv,
+			      struct v4l2_format *f)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct hva_device *hva = ctx_to_hdev(ctx);
+	struct device *dev = ctx_to_dev(ctx);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	const struct hva_encoder *enc = NULL;
+	unsigned int i;
+
+	if ((f->fmt.pix.width == 0) || (f->fmt.pix.height == 0))
+		goto out;
+
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+	f->fmt.pix.priv = 0;
+
+	for (i = 0; i < hva->nb_of_encoders; i++) {
+		enc = hva->encoders[i];
+		if (enc->streamformat == pix->pixelformat)
+			if ((f->fmt.pix.height * f->fmt.pix.width) <=
+			    (enc->max_width * enc->max_height))
+				return 0;
+	}
+out:
+	dev_dbg(dev, "%s stream format or resolution %dx%d not supported\n",
+		ctx->name, f->fmt.pix.width, f->fmt.pix.height);
+	return -EINVAL;
+}
+
+static int hva_try_fmt_frame(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	const struct hva_frame_fmt *format;
+	u32 in_w, in_h;
+
+	format = hva_find_frame_fmt(pix->pixelformat);
+	if (!format) {
+		dev_dbg(dev, "%s Unknown format 0x%x\n", ctx->name,
+			pix->pixelformat);
+		return -EINVAL;
+	}
+
+	/* adjust width & height */
+	in_w = pix->width;
+	in_h = pix->height;
+	v4l_bound_align_image(&pix->width,
+			      HVA_MIN_WIDTH, HVA_MAX_WIDTH,
+			      ffs(format->w_align) - 1,
+			      &pix->height,
+			      HVA_MIN_HEIGHT, HVA_MAX_HEIGHT,
+			      ffs(format->h_align) - 1,
+			      0);
+
+	if ((pix->width != in_w) || (pix->height != in_h))
+		dev_dbg(dev, "%s size updated: %dx%d -> %dx%d\n", ctx->name,
+			in_w, in_h, pix->width, pix->height);
+
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+	f->fmt.pix.priv = 0;
+
+	return 0;
+}
+
+static int hva_s_fmt_stream(struct file *file, void *fh, struct v4l2_format *f)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+	int ret;
+
+	dev_dbg(dev, "%s %s %dx%d fmt:%.4s size:%d\n",
+		ctx->name, __func__, f->fmt.pix.width, f->fmt.pix.height,
+		(u8 *)&f->fmt.pix.pixelformat, f->fmt.pix.sizeimage);
+
+	ret = hva_try_fmt_stream(file, fh, f);
+	if (ret) {
+		dev_err(dev,
+			"%s %s %.4s format or %dx%d resolution not supported\n",
+			ctx->name, __func__, (char *)&f->fmt.pix.pixelformat,
+			f->fmt.pix.width, f->fmt.pix.height);
+		return ret;
+	}
+
+	/* update context */
+	ctx->streaminfo.width = f->fmt.pix.width;
+	ctx->streaminfo.height = f->fmt.pix.height;
+	ctx->streaminfo.streamformat = f->fmt.pix.pixelformat;
+	ctx->streaminfo.dpb = 1;
+	ctx->flags |= HVA_FLAG_STREAMINFO;
+
+	if ((!ctx->encoder) && (ctx->flags & HVA_FLAG_FRAMEINFO)) {
+		ret = hva_open_encoder(ctx,
+				       ctx->streaminfo.streamformat,
+				       ctx->frameinfo.fmt.pixelformat,
+				       &ctx->encoder);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int hva_s_fmt_frame(struct file *file, void *fh, struct v4l2_format *f)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	const struct hva_frame_fmt *fmt;
+	int ret = 0;
+
+	dev_dbg(dev, "%s %s %dx%d fmt:%.4s size:%d\n",
+		ctx->name, __func__, f->fmt.pix.width, f->fmt.pix.height,
+		(u8 *)&f->fmt.pix.pixelformat, f->fmt.pix.sizeimage);
+
+	ret = hva_try_fmt_frame(file, fh, f);
+	if (ret) {
+		dev_err(dev,
+			"%s %s %.4s format or %dx%d resolution not supported\n",
+			ctx->name, __func__, (char *)&f->fmt.pix.pixelformat,
+			f->fmt.pix.width, f->fmt.pix.height);
+		return ret;
+	}
+
+	fmt = hva_find_frame_fmt(pix->pixelformat);
+	if (!fmt) {
+		dev_dbg(dev, "%s %s unknown format 0x%x\n", ctx->name,
+			ctx->name, pix->pixelformat);
+		return -EINVAL;
+	}
+
+	memcpy(&ctx->frameinfo.fmt, fmt, sizeof(struct hva_frame_fmt));
+	ctx->frameinfo.frame_width = ALIGN(pix->width, 16);
+	ctx->frameinfo.frame_height = ALIGN(pix->height, 16);
+	ctx->frameinfo.width = pix->width;
+	ctx->frameinfo.height = pix->height;
+	ctx->frameinfo.crop.width = pix->width;
+	ctx->frameinfo.crop.height = pix->height;
+	ctx->frameinfo.crop.left = 0;
+	ctx->frameinfo.crop.top = 0;
+
+	ctx->flags |= HVA_FLAG_FRAMEINFO;
+
+	if ((!ctx->encoder) && (ctx->flags & HVA_FLAG_STREAMINFO))
+		ret = hva_open_encoder(ctx,
+				       ctx->streaminfo.streamformat,
+				       ctx->frameinfo.fmt.pixelformat,
+				       &ctx->encoder);
+
+	return ret;
+}
+
+static int hva_s_ext_ctrls(struct file *file, void *fh,
+			   struct v4l2_ext_controls *ctrls)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+	unsigned int i;
+
+	dev_dbg(dev, "%s %s count controls %d\n", ctx->name, __func__,
+		ctrls->count);
+
+	for (i = 0; i < ctrls->count; i++) {
+		switch (ctrls->controls[i].id) {
+		case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
+			ctx->ctrls.gop_size = ctrls->controls[i].value;
+			dev_dbg(dev, "%s V4L2_CID_MPEG_VIDEO_GOP_SIZE %d\n",
+				ctx->name, ctrls->controls[i].value);
+			break;
+		case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
+			ctx->ctrls.bitrate_mode = ctrls->controls[i].value;
+			dev_dbg(dev, "%s V4L2_CID_MPEG_VIDEO_BITRATE_MODE %d\n",
+				ctx->name, ctrls->controls[i].value);
+			break;
+		case V4L2_CID_MPEG_VIDEO_BITRATE:
+			ctx->ctrls.bitrate = ctrls->controls[i].value;
+			dev_dbg(dev, "%s V4L2_CID_MPEG_VIDEO_BITRATE %d\n",
+				ctx->name, ctrls->controls[i].value);
+			break;
+		case V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB:
+			ctx->ctrls.intra_refresh = ctrls->controls[i].value;
+			dev_dbg(dev,
+				"%s V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB %d\n",
+				ctx->name, ctrls->controls[i].value);
+			break;
+		case V4L2_CID_MPEG_VIDEO_ASPECT:
+			/* only one video aspect ratio supported (1/1) */
+			switch (ctrls->controls[i].value) {
+			case V4L2_MPEG_VIDEO_ASPECT_1x1:
+				dev_dbg(dev,
+					"%s V4L2_CID_MPEG_VIDEO_ASPECT 1x1\n",
+					ctx->name);
+				break;
+			case V4L2_MPEG_VIDEO_ASPECT_4x3:
+			case V4L2_MPEG_VIDEO_ASPECT_16x9:
+			case V4L2_MPEG_VIDEO_ASPECT_221x100:
+			default:
+				dev_err(dev,
+					"%s V4L2_CID_MPEG_VIDEO_ASPECT: Unsupported aspect ratio %d\n",
+					ctx->name, ctrls->controls[i].value);
+				return -EINVAL;
+			}
+			break;
+		default:
+			dev_err(dev,
+				"%s VIDIOC_S_EXT_CTRLS(): Unsupported control id %d\n",
+				ctx->name, ctrls->controls[i].id);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int hva_s_parm(struct file *file, void *fh, struct v4l2_streamparm *sp)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+
+	ctx->time_per_frame.numerator = sp->parm.capture.timeperframe.numerator;
+	ctx->time_per_frame.denominator =
+	    sp->parm.capture.timeperframe.denominator;
+
+	dev_dbg(dev, "%s set parameters %d/%d\n",
+		ctx->name, ctx->time_per_frame.numerator,
+		ctx->time_per_frame.denominator);
+
+	return 0;
+}
+
+static int hva_g_parm(struct file *file, void *fh, struct v4l2_streamparm *sp)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+
+	sp->parm.capture.timeperframe.numerator = ctx->time_per_frame.numerator;
+	sp->parm.capture.timeperframe.denominator =
+	    ctx->time_per_frame.denominator;
+
+	dev_dbg(dev, "%s get parameters %d/%d\n",
+		ctx->name, ctx->time_per_frame.numerator,
+		ctx->time_per_frame.denominator);
+
+	return 0;
+}
+
+static int hva_g_fmt_stream(struct file *file, void *fh, struct v4l2_format *f)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+
+	/* get stream format */
+	f->fmt.pix.width = ctx->streaminfo.width;
+	f->fmt.pix.height = ctx->streaminfo.height;
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+	/* 32 bytes alignment */
+	f->fmt.pix.bytesperline = ALIGN(f->fmt.pix.width, 32);
+	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * f->fmt.pix.height;
+	f->fmt.pix.pixelformat = ctx->streaminfo.streamformat;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+
+	dev_dbg(dev, "%s %s %dx%d fmt:%.4s size:%d\n",
+		ctx->name, __func__, f->fmt.pix.width, f->fmt.pix.height,
+		(u8 *)&f->fmt.pix.pixelformat, f->fmt.pix.sizeimage);
+	return 0;
+}
+
+static int hva_g_fmt_frame(struct file *file, void *fh, struct v4l2_format *f)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+	struct hva_frame_fmt *fmt = &ctx->frameinfo.fmt;
+	int width = ctx->frameinfo.frame_width;
+	int height = ctx->frameinfo.frame_height;
+
+	/* get source format */
+	f->fmt.pix.pixelformat = fmt->pixelformat;
+	f->fmt.pix.width = ctx->frameinfo.width;
+	f->fmt.pix.height = ctx->frameinfo.height;
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+	f->fmt.pix.bytesperline = (width * fmt->bpp_plane0) / 8;
+	f->fmt.pix.sizeimage = (width * height * fmt->bpp) / 8;
+
+	dev_dbg(dev, "%s %s %dx%d fmt:%.4s size:%d\n",
+		ctx->name, __func__, f->fmt.pix.width, f->fmt.pix.height,
+		(u8 *)&f->fmt.pix.pixelformat, f->fmt.pix.sizeimage);
+
+	return 0;
+}
+
+static int hva_reqbufs(struct file *file, void *priv,
+		       struct v4l2_requestbuffers *reqbufs)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+	int ret = 0;
+
+	dev_dbg(dev, "%s %s %s\n", ctx->name, __func__,
+		to_type_str(reqbufs->type));
+
+	ret = vb2_reqbufs(get_queue(ctx, reqbufs->type), reqbufs);
+	if (ret) {
+		dev_err(dev, "%s vb2_reqbufs failed (%d)\n", ctx->name, ret);
+		return ret;
+	}
+
+	if (reqbufs->count == 0) {
+		/*
+		 * buffers have been freed in vb2 __reqbufs()
+		 * now cleanup "allocation context" ...
+		 */
+		if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+			vb2_dma_contig_cleanup_ctx(ctx->q_frame.alloc_ctx[0]);
+			ctx->q_frame.alloc_ctx[0] = NULL;
+		} else if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+			vb2_dma_contig_cleanup_ctx(ctx->q_stream.alloc_ctx[0]);
+			ctx->q_stream.alloc_ctx[0] = NULL;
+		}
+	}
+
+	return 0;
+}
+
+static int hva_create_bufs(struct file *file, void *priv,
+			   struct v4l2_create_buffers *create)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct vb2_queue *q = get_queue(ctx, create->format.type);
+
+	return vb2_create_bufs(q, create);
+}
+
+static int hva_querybuf(struct file *file, void *priv, struct v4l2_buffer *b)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+	int ret = 0;
+
+	dev_dbg(dev, "%s %s %s[%d]\n", ctx->name, __func__,
+		to_type_str(b->type), b->index);
+
+	/* vb2 call */
+	ret = vb2_querybuf(get_queue(ctx, b->type), b);
+	if (ret) {
+		dev_err(dev, "%s vb2_querybuf failed (%d)\n", ctx->name, ret);
+		return ret;
+	}
+
+	/* add an offset to differentiate OUTPUT/CAPTURE @mmap time */
+	if ((b->memory == V4L2_MEMORY_MMAP) &&
+	    (b->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
+		b->m.offset += MMAP_FRAME_OFFSET;
+	}
+
+	return 0;
+}
+
+static int hva_expbuf(struct file *file, void *fh, struct v4l2_exportbuffer *b)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+	int ret = 0;
+
+	/* request validation */
+	if ((b->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) &&
+	    (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
+		dev_err(dev,
+			"%s V4L2 EXPBUF: only type output/cature are supported\n",
+			ctx->name);
+		return -EINVAL;
+	}
+
+	/* vb2 call */
+	ret = vb2_expbuf(get_queue(ctx, b->type), b);
+	if (ret) {
+		dev_err(dev, "%s vb2_expbuf failed (%d)\n", ctx->name, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int hva_qbuf(struct file *file, void *priv, struct v4l2_buffer *b)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+	struct vb2_queue *q = get_queue(ctx, b->type);
+	int ret = 0;
+
+	/* copy bytesused field from v4l2 buffer to vb2 buffer */
+	if ((b->index < MAX_FRAMES) &&
+	    (b->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
+		struct hva_stream *s = (struct hva_stream *)q->bufs[b->index];
+
+		s->payload = b->bytesused;
+	}
+
+	ret = vb2_qbuf(q, b);
+	if (ret) {
+		dev_err(dev, "%s vb2_qbuf failed (%d)\n", ctx->name, ret);
+		return ret;
+	}
+	return 0;
+}
+
+static int hva_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+	struct vb2_queue *q = get_queue(ctx, b->type);
+	int ret = 0;
+
+	/* vb2 call */
+	ret = vb2_dqbuf(q, b, file->f_flags & O_NONBLOCK);
+	if (ret) {
+		dev_err(dev, "%s vb2_dqbuf failed (%d)\n", ctx->name, ret);
+		return ret;
+	}
+
+	dev_dbg(dev, "%s %s %s[%d]\n", ctx->name, __func__,
+		to_type_str(b->type), b->index);
+
+	return 0;
+}
+
+static int hva_streamon(struct file *file, void *priv, enum v4l2_buf_type type)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+	int ret = 0;
+
+	/* reset frame number */
+	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		ctx->frame_num = 0;
+
+	/* vb2 call */
+	ret = vb2_streamon(get_queue(ctx, type), type);
+	if (ret) {
+		dev_err(dev, "%s vb2_streamon failed (%d)\n", ctx->name, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int hva_streamoff(struct file *file, void *priv, enum v4l2_buf_type type)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+	struct hva_stream *sr, *node;
+	int ret = 0;
+
+	/* release all active buffers */
+	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		list_for_each_entry_safe(sr, node, &ctx->list_stream, list) {
+			list_del_init(&sr->list);
+			vb2_buffer_done(&sr->v4l2.vb2_buf, VB2_BUF_STATE_ERROR);
+		}
+	}
+
+	/* vb2 call */
+	ret = vb2_streamoff(get_queue(ctx, type), type);
+	if (ret) {
+		dev_err(dev, "%s vb2_streamoff failed (%d)\n", ctx->name, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int is_rect_enclosed(struct v4l2_rect *a, struct v4l2_rect *b)
+{
+	/* return 1 if a is enclosed in b, or 0 otherwise. */
+	if (a->left < b->left || a->top < b->top)
+		return 0;
+
+	if (a->left + a->width > b->left + b->width)
+		return 0;
+
+	if (a->top + a->height > b->top + b->height)
+		return 0;
+
+	return 1;
+}
+
+static int hva_g_selection(struct file *file, void *fh,
+			   struct v4l2_selection *s)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+
+	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		dev_err(dev, "%s %s: G_SELECTION failed, invalid type (%d)\n",
+			ctx->name, __func__, s->type);
+		return -EINVAL;
+	}
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP:
+		/* cropped frame */
+		s->r = ctx->frameinfo.crop;
+		break;
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		/* complete frame */
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = ctx->frameinfo.width;
+		s->r.height = ctx->frameinfo.height;
+		break;
+	default:
+		dev_err(dev, "%s %s: G_SELECTION failed, invalid target (%d)\n",
+			ctx->name, __func__, s->target);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int hva_s_selection(struct file *file, void *fh,
+			   struct v4l2_selection *s)
+{
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+	struct v4l2_rect *in, out;
+
+	if ((s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) ||
+	    (s->target != V4L2_SEL_TGT_CROP)) {
+		dev_err(dev, "%s %s: S_SELECTION failed, invalid type (%d)\n",
+			ctx->name, __func__, s->type);
+		return -EINVAL;
+	}
+
+	in = &s->r;
+	out = *in;
+
+	/* align and check origin */
+	out.left = ALIGN(in->left, ctx->frameinfo.fmt.w_align);
+	out.top = ALIGN(in->top, ctx->frameinfo.fmt.h_align);
+
+	if (((out.left + out.width) >  ctx->frameinfo.width) ||
+	    ((out.top + out.height) >  ctx->frameinfo.height)) {
+		dev_err(dev,
+			"%s %s: S_SELECTION failed, invalid crop %dx%d@(%d,%d)\n",
+			ctx->name, __func__, out.width, out.height,
+			out.left, out.top);
+		return -EINVAL;
+	}
+
+	/* checks adjust constraints flags */
+	if (s->flags & V4L2_SEL_FLAG_LE && !is_rect_enclosed(&out, in))
+		return -ERANGE;
+
+	if (s->flags & V4L2_SEL_FLAG_GE && !is_rect_enclosed(in, &out))
+		return -ERANGE;
+
+	if ((out.left != in->left) || (out.top != in->top) ||
+	    (out.width != in->width) || (out.height != in->height))
+		*in = out;
+
+	ctx->frameinfo.crop = s->r;
+
+	return 0;
+}
+
+/* vb2 ioctls operations */
+
+static int hva_vb2_frame_queue_setup(struct vb2_queue *q,
+				     const void *parg,
+				     unsigned int *num_buffers,
+				     unsigned int *num_planes,
+				     unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct hva_ctx *ctx = fh_to_ctx(q->drv_priv);
+	struct device *dev = ctx_to_dev(ctx);
+	int width = ctx->frameinfo.frame_width;
+	int height = ctx->frameinfo.frame_height;
+
+	dev_dbg(dev, "%s %s *num_buffers=%d\n", ctx->name, __func__,
+		*num_buffers);
+
+	/* only one plane supported */
+	*num_planes = 1;
+
+	/* setup nb of input buffers needed =
+	 * user need (*num_buffer given, usually for grab pipeline) +
+	 * encoder internal need
+	 */
+	if (*num_buffers < MIN_FRAMES) {
+		dev_warn(dev,
+			 "%s num_buffers too low (%d), increasing to %d\n",
+			 ctx->name, *num_buffers, MIN_FRAMES);
+		*num_buffers = MIN_FRAMES;
+	}
+
+	if (*num_buffers > MAX_FRAMES) {
+		dev_warn(dev,
+			 "%s input frame count too high (%d), cut to %d\n",
+			 ctx->name, *num_buffers, MAX_FRAMES);
+		*num_buffers = MAX_FRAMES;
+	}
+
+	if (sizes[0])
+		dev_warn(dev, "%s psize[0] already set to %d\n", ctx->name,
+			 sizes[0]);
+
+	if (alloc_ctxs[0])
+		dev_warn(dev, "%s allocators[0] already set\n", ctx->name);
+
+	if (!(ctx->flags & HVA_FLAG_FRAMEINFO)) {
+		dev_err(dev, "%s %s frame format not set, using default format\n",
+			ctx->name, __func__);
+	}
+
+	sizes[0] = (width * height * ctx->frameinfo.fmt.bpp) / 8;
+	alloc_ctxs[0] = vb2_dma_contig_init_ctx(dev);
+	/* alloc_ctxs[0] will be freed @ reqbufs(0) or @ release */
+
+	return 0;
+}
+
+static int hva_vb2_frame_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	struct hva_ctx *ctx = fh_to_ctx(q->drv_priv);
+	struct device *dev = ctx_to_dev(ctx);
+	struct hva_frame *fm = (struct hva_frame *)vb;
+
+	if (!fm->prepared) {
+		/* get memory addresses */
+		fm->vaddr = vb2_plane_vaddr(&fm->v4l2.vb2_buf, 0);
+		fm->paddr =
+			vb2_dma_contig_plane_dma_addr(&fm->v4l2.vb2_buf, 0);
+		fm->prepared = true;
+
+		ctx->num_frames++;
+
+		dev_dbg(dev, "%s frame[%d] prepared; virt=%p, phy=0x%x\n",
+			ctx->name, vb->index, fm->vaddr,
+			fm->paddr);
+	}
+
+	return 0;
+}
+
+static void hva_vb2_frame_queue(struct vb2_buffer *vb)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	struct hva_ctx *ctx = fh_to_ctx(q->drv_priv);
+	struct device *dev = ctx_to_dev(ctx);
+	const struct hva_encoder *enc = ctx_to_enc(ctx);
+	struct hva_frame *fm = NULL;
+	struct hva_stream *sr = NULL;
+	int ret = 0;
+
+	fm = (struct hva_frame *)vb;
+
+	if (!vb2_is_streaming(q)) {
+		vb2_buffer_done(&fm->v4l2.vb2_buf, VB2_BUF_STATE_ERROR);
+		return;
+	}
+
+	/* get a free destination buffer */
+	if (list_empty(&ctx->list_stream)) {
+		dev_err(dev, "%s no free buffer for destination stream!\n",
+			ctx->name);
+		ctx->sys_errors++;
+		goto err;
+	}
+	sr = list_first_entry(&ctx->list_stream, struct hva_stream, list);
+
+	if (!sr)
+		goto err;
+
+	list_del(&sr->list);
+
+	/* encode the frame & get stream unit */
+	ret = enc->encode(ctx, fm, sr);
+	if (ret)
+		goto err;
+
+	/* propagate frame timestamp */
+	sr->v4l2.timestamp = fm->v4l2.timestamp;
+
+	ctx->encoded_frames++;
+
+	vb2_buffer_done(&sr->v4l2.vb2_buf, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&fm->v4l2.vb2_buf, VB2_BUF_STATE_DONE);
+
+	return;
+err:
+	if (sr)
+		vb2_buffer_done(&sr->v4l2.vb2_buf, VB2_BUF_STATE_ERROR);
+
+	vb2_buffer_done(&fm->v4l2.vb2_buf, VB2_BUF_STATE_ERROR);
+}
+
+static int hva_vb2_stream_queue_setup(struct vb2_queue *q,
+				      const void *parg,
+				      unsigned int *num_buffers,
+				      unsigned int *num_planes,
+				      unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct hva_ctx *ctx = fh_to_ctx(q->drv_priv);
+	struct device *dev = ctx_to_dev(ctx);
+	int max_buf_size = 0;
+	u32 pixelformat;
+	int width;
+	int height;
+
+	dev_dbg(dev, "%s %s *num_buffers=%d\n", ctx->name, __func__,
+		*num_buffers);
+
+	/* only one plane supported */
+	*num_planes = 1;
+
+	/* number of buffers must be at least 1 */
+	if (*num_buffers < 1)
+		*num_buffers = 1;
+
+	if (sizes[0])
+		dev_warn(dev, "%s psize[0] already set to %d\n", ctx->name,
+			 sizes[0]);
+
+	if (alloc_ctxs[0])
+		dev_warn(dev, "%s allocators[0] already set\n", ctx->name);
+
+	if (!(ctx->flags & HVA_FLAG_STREAMINFO)) {
+		dev_err(dev, "%s %s stream format not set, using dflt format\n",
+			ctx->name, __func__);
+	}
+
+	pixelformat = ctx->streaminfo.streamformat;
+	width = ctx->streaminfo.width;
+	height = ctx->streaminfo.height;
+
+	switch (pixelformat) {
+	default:
+		dev_err(dev, "%s %s Unknown stream format\n", ctx->name,
+			__func__);
+	}
+
+	sizes[0] = max_buf_size;
+	alloc_ctxs[0] = vb2_dma_contig_init_ctx(dev);	/* free @ release */
+
+	return 0;
+}
+
+static int hva_vb2_stream_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	struct hva_ctx *ctx = fh_to_ctx(q->drv_priv);
+	struct device *dev = ctx_to_dev(ctx);
+	struct hva_stream *sr = (struct hva_stream *)vb;
+
+	if (!sr->prepared) {
+		/* get memory addresses */
+		sr->vaddr = vb2_plane_vaddr(&sr->v4l2.vb2_buf, 0);
+		sr->paddr = vb2_dma_contig_plane_dma_addr(&sr->v4l2.vb2_buf, 0);
+		sr->prepared = true;
+
+		dev_dbg(dev, "%s stream[%d] prepared; virt=%p, phy=0x%x\n",
+			ctx->name, vb->index, sr->vaddr, sr->paddr);
+	}
+
+	return 0;
+}
+
+static void hva_vb2_stream_queue(struct vb2_buffer *vb)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	struct hva_ctx *ctx = fh_to_ctx(q->drv_priv);
+	struct hva_stream *sr = (struct hva_stream *)vb;
+
+	/* check validity of video stream */
+	if (vb) {
+		/* enqueue to a list destination stream */
+		list_add(&sr->list, &ctx->list_stream);
+	}
+}
+
+static struct vb2_ops hva_vb2_frame_ops = {
+	.queue_setup = hva_vb2_frame_queue_setup,
+	.buf_prepare = hva_vb2_frame_prepare,
+	.buf_queue = hva_vb2_frame_queue,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+};
+
+static struct vb2_ops hva_vb2_stream_ops = {
+	.queue_setup = hva_vb2_stream_queue_setup,
+	.buf_prepare = hva_vb2_stream_prepare,
+	.buf_queue = hva_vb2_stream_queue,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+};
+
+/* file basics operations */
+
+static int hva_open(struct file *file)
+{
+	struct hva_device *hva = video_drvdata(file);
+	struct vb2_queue *q;
+	struct device *dev;
+	struct hva_ctx *ctx;
+	int ret = 0;
+	unsigned int i;
+
+	WARN_ON(!hva);
+	dev = hva->dev;
+
+	mutex_lock(&hva->lock);
+
+	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		mutex_unlock(&hva->lock);
+		return -ENOMEM;
+	}
+
+	/* store the context address in the contexts list */
+	for (i = 0; i < MAX_CONTEXT; i++) {
+		if (!hva->contexts_list[i]) {
+			hva->contexts_list[i] = ctx;
+			/* save client id in context */
+			ctx->client_id = i;
+			break;
+		}
+	}
+
+	v4l2_fh_init(&ctx->fh, video_devdata(file));
+	file->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+
+	/* recopy device handlers */
+	ctx->dev = hva->dev;
+	ctx->hdev = hva;
+
+	/* setup vb2 queue for frame input */
+	q = &ctx->q_frame;
+	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT; /* to say input, weird! */
+	q->io_modes = VB2_MMAP | VB2_DMABUF;
+
+	/* save file handle to private data field of the queue */
+	q->drv_priv = &ctx->fh;
+
+	/* overload vb2 buffer size with private struct */
+	q->buf_struct_size = sizeof(struct hva_frame);
+
+	q->ops = &hva_vb2_frame_ops;
+	q->mem_ops = (struct vb2_mem_ops *)&vb2_dma_contig_memops;
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	q->lock = &hva->lock;
+
+	ret = vb2_queue_init(q);
+	if (ret) {
+		dev_err(dev, "%s [x:x] vb2_queue_init(frame) failed (%d)\n",
+			HVA_PREFIX,  ret);
+		ctx->sys_errors++;
+		goto err_fh_del;
+	}
+
+	/* setup vb2 queue of the destination */
+	q = &ctx->q_stream;
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_DMABUF;
+
+	/* save file handle to private data field of the queue */
+	q->drv_priv = &ctx->fh;
+
+	/* overload vb2 buffer size with private struct */
+	q->buf_struct_size = sizeof(struct hva_stream);
+
+	q->ops = &hva_vb2_stream_ops;
+	q->mem_ops = (struct vb2_mem_ops *)&vb2_dma_contig_memops;
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	q->lock = &hva->lock;
+
+	ret = vb2_queue_init(q);
+	if (ret) {
+		dev_err(dev, "%s [x:x] vb2_queue_init(stream) failed (%d)\n",
+			HVA_PREFIX, ret);
+		ctx->sys_errors++;
+		goto err_queue_del_frame;
+	}
+
+	/* initialize the list of stream buffers */
+	INIT_LIST_HEAD(&ctx->list_stream);
+
+	/* name this instance */
+	hva->instance_id++;	/* rolling id to identify this instance */
+	snprintf(ctx->name, sizeof(ctx->name), "[%3d:----]", hva->instance_id);
+
+	/* initialize controls */
+	ctx->ctrls.bitrate_mode = DFT_CFG_BITRATE_MODE;
+	ctx->ctrls.bitrate = DFT_CFG_BITRATE;
+	ctx->ctrls.cpb_size = DFT_CFG_CPB_SIZE;
+	ctx->ctrls.gop_size = DFT_CFG_GOP_SIZE;
+	ctx->ctrls.intra_refresh = DFT_CFG_INTRA_REFRESH;
+	ctx->ctrls.dct8x8 = DFT_CFG_DCT8X8;
+	ctx->ctrls.qpmin = DFT_CFG_QPMIN;
+	ctx->ctrls.qpmax = DFT_CFG_QPMAX;
+	ctx->ctrls.jpeg_comp_quality = DFT_CFG_COMP_QUALITY;
+	ctx->ctrls.vui_sar = DFT_CFG_SAR_ENABLE;
+
+	/* set by default time per frame */
+	ctx->time_per_frame.numerator = DFT_CFG_FRAME_NUM;
+	ctx->time_per_frame.denominator = DFT_CFG_FRAME_DEN;
+
+	/* default format */
+	ctx->streaminfo = stream_dflt_fmt;
+	ctx->frameinfo = frame_dflt_fmt;
+
+	hva->nb_of_instances++;
+
+	mutex_unlock(&hva->lock);
+
+	return 0;
+
+err_queue_del_frame:
+	vb2_queue_release(&ctx->q_frame);
+err_fh_del:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	hva->contexts_list[ctx->client_id] = NULL;
+	devm_kfree(dev, ctx);
+
+	mutex_unlock(&hva->lock);
+
+	return ret;
+}
+
+static int hva_release(struct file *file)
+{
+	struct hva_device *hva = video_drvdata(file);
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx_to_dev(ctx);
+	const struct hva_encoder *enc = ctx_to_enc(ctx);
+
+	mutex_lock(&hva->lock);
+
+	/* free queues: source & destination */
+	vb2_queue_release(&ctx->q_frame);
+	vb2_queue_release(&ctx->q_stream);
+
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+
+	/* will free dma memory of each frame in queue */
+	vb2_queue_release(&ctx->q_frame);
+	if (ctx->q_frame.alloc_ctx[0])
+		vb2_dma_contig_cleanup_ctx(ctx->q_frame.alloc_ctx[0]);
+
+	/* will free dma memory of each aus in queue */
+	vb2_queue_release(&ctx->q_stream);
+	if (ctx->q_stream.alloc_ctx[0])
+		vb2_dma_contig_cleanup_ctx(ctx->q_stream.alloc_ctx[0]);
+
+	/* clear context in contexts list */
+	if ((ctx->client_id >= MAX_CONTEXT) ||
+	    (hva->contexts_list[ctx->client_id] != ctx)) {
+		dev_err(dev, "%s can't clear context in contexts list!\n",
+			ctx->name);
+		ctx->sys_errors++;
+	}
+	hva->contexts_list[ctx->client_id] = NULL;
+
+	/* close encoder */
+	if (enc)
+		enc->close(ctx);
+
+	devm_kfree(dev, ctx);
+
+	hva->nb_of_instances--;
+
+	mutex_unlock(&hva->lock);
+
+	return 0;
+}
+
+static int hva_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct hva_device *hva = video_drvdata(file);
+	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
+	struct device *dev = ctx->dev;
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+	enum v4l2_buf_type type;
+	int ret;
+
+	mutex_lock(&hva->lock);
+
+	/* offset used to differentiate OUTPUT/CAPTURE */
+	if (offset < MMAP_FRAME_OFFSET) {
+		type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	} else {
+		type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		vma->vm_pgoff -= (MMAP_FRAME_OFFSET >> PAGE_SHIFT);
+	}
+
+	/* vb2 call */
+	ret = vb2_mmap(get_queue(ctx, type), vma);
+	if (ret) {
+		dev_err(dev, "%s vb2_mmap failed (%d)\n", ctx->name, ret);
+		ctx->sys_errors++;
+		mutex_unlock(&hva->lock);
+		return ret;
+	}
+
+	mutex_unlock(&hva->lock);
+
+	return 0;
+}
+
+/* v4l2 ops */
+static const struct v4l2_file_operations hva_fops = {
+	.owner = THIS_MODULE,
+	.open = hva_open,
+	.release = hva_release,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap = hva_mmap,
+};
+
+/* v4l2 ioctl ops */
+static const struct v4l2_ioctl_ops hva_ioctl_ops = {
+	.vidioc_querycap = hva_querycap,
+	/* formats ioctl */
+	.vidioc_enum_fmt_vid_cap	= hva_enum_fmt_stream,
+	.vidioc_enum_fmt_vid_out	= hva_enum_fmt_frame,
+	.vidioc_g_fmt_vid_cap		= hva_g_fmt_stream,
+	.vidioc_g_fmt_vid_out		= hva_g_fmt_frame,
+	.vidioc_try_fmt_vid_cap		= hva_try_fmt_stream,
+	.vidioc_try_fmt_vid_out		= hva_try_fmt_frame,
+	.vidioc_s_fmt_vid_cap		= hva_s_fmt_stream,
+	.vidioc_s_fmt_vid_out		= hva_s_fmt_frame,
+	.vidioc_s_ext_ctrls		= hva_s_ext_ctrls,
+	.vidioc_g_parm			= hva_g_parm,
+	.vidioc_s_parm			= hva_s_parm,
+	/* buffers ioctls */
+	.vidioc_reqbufs			= hva_reqbufs,
+	.vidioc_create_bufs             = hva_create_bufs,
+	.vidioc_querybuf		= hva_querybuf,
+	.vidioc_expbuf			= hva_expbuf,
+	.vidioc_qbuf			= hva_qbuf,
+	.vidioc_dqbuf			= hva_dqbuf,
+	/* stream ioctls */
+	.vidioc_streamon		= hva_streamon,
+	.vidioc_streamoff		= hva_streamoff,
+	.vidioc_g_selection		= hva_g_selection,
+	.vidioc_s_selection		= hva_s_selection,
+};
+
+static int hva_probe(struct platform_device *pdev)
+{
+	struct hva_device *hva;
+	struct device *dev = &pdev->dev;
+	struct video_device *vdev;
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
+	register_all(hva);
+
+	/* register on V4L2 */
+	ret = v4l2_device_register(dev, &hva->v4l2_dev);
+	if (ret) {
+		dev_err(dev, "%s %s could not register v4l2 device\n",
+			HVA_PREFIX, HVA_NAME);
+		goto err_hw_remove;
+	}
+
+	vdev = video_device_alloc();
+	vdev->fops = &hva_fops;
+	vdev->ioctl_ops = &hva_ioctl_ops;
+	vdev->release = video_device_release;
+	vdev->lock = &hva->lock;
+	vdev->v4l2_dev = &hva->v4l2_dev;
+	snprintf(vdev->name, sizeof(vdev->name), "%s", HVA_NAME);
+	vdev->vfl_dir = VFL_DIR_M2M;
+	ret = video_register_device(vdev, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		dev_err(dev, "%s %s failed to register video device\n",
+			HVA_PREFIX, HVA_NAME);
+		goto err_vdev_release;
+	}
+
+	hva->vdev = vdev;
+	video_set_drvdata(vdev, hva);
+
+	dev_info(dev, "%s %s registered as /dev/video%d\n", HVA_PREFIX,
+		 HVA_NAME, vdev->num);
+
+	dev_info(dev, "%s %s esram reserved for address: %p size:%d\n",
+		 HVA_PREFIX, HVA_NAME, (void *)hva->esram_addr,
+		 hva->esram_size);
+
+	return 0;
+
+err_vdev_release:
+	video_device_release(vdev);
+
+err_hw_remove:
+	hva_hw_remove(hva);
+
+err:
+	return ret;
+}
+
+static int hva_remove(struct platform_device *pdev)
+{
+	struct hva_device *hva = platform_get_drvdata(pdev);
+	struct device *dev = hva_to_dev(hva);
+
+	dev_info(dev, "%s removing %s\n", HVA_PREFIX, pdev->name);
+
+	hva_hw_remove(hva);
+
+	video_unregister_device(hva->vdev);
+	v4l2_device_unregister(&hva->v4l2_dev);
+
+	return 0;
+}
+
+static const struct dev_pm_ops hva_pm_ops = {
+	.runtime_suspend = hva_hw_runtime_suspend,
+	.runtime_resume = hva_hw_runtime_resume,
+};
+
+static const struct of_device_id hva_match_types[] = {
+	{
+	 .compatible = "st,stih407-hva",
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
+		.name           = HVA_NAME,
+		.owner          = THIS_MODULE,
+		.of_match_table = hva_match_types,
+		.pm             = &hva_pm_ops,
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
index 0000000..e646718
--- /dev/null
+++ b/drivers/media/platform/sti/hva/hva.h
@@ -0,0 +1,499 @@
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
+#include <media/v4l2-common.h>
+#include <media/v4l2-device.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
+
+#define get_queue(c, t) (t == V4L2_BUF_TYPE_VIDEO_OUTPUT ? \
+			 &c->q_frame : &c->q_stream)
+
+#define to_type_str(type) (type == V4L2_BUF_TYPE_VIDEO_OUTPUT ? \
+			   "frame" : "stream")
+
+#define fh_to_ctx(f)    (container_of(f, struct hva_ctx, fh))
+
+#define hva_to_dev(h)   (h->dev)
+
+#define ctx_to_dev(c)   (c->dev)
+
+#define ctx_to_hdev(c)  (c->hdev)
+
+#define ctx_to_enc(c)   (c->encoder)
+
+#define HVA_PREFIX "[---:----]"
+
+#define MAX_CONTEXT 16
+
+extern const struct hva_encoder nv12h264enc;
+extern const struct hva_encoder nv21h264enc;
+extern const struct hva_encoder uyvyh264enc;
+extern const struct hva_encoder vyuyh264enc;
+extern const struct hva_encoder xrgb32h264enc;
+extern const struct hva_encoder xbgr32h264enc;
+extern const struct hva_encoder rgbx32h264enc;
+extern const struct hva_encoder bgrx32h264enc;
+extern const struct hva_encoder rgb24h264enc;
+extern const struct hva_encoder bgr24h264enc;
+
+/**
+ * struct hva_frame_fmt - driver's internal color format data
+ * @pixelformat:fourcc code for this format
+ * @nb_planes:  number of planes  (ex: [0]=RGB/Y - [1]=Cb/Cr, ...)
+ * @bpp:        bits per pixel (general)
+ * @bpp_plane0: byte per pixel for the 1st plane
+ * @w_align:    width alignment in pixel (multiple of)
+ * @h_align:    height alignment in pixel (multiple of)
+ */
+struct hva_frame_fmt {
+	u32                     pixelformat;
+	u8                      nb_planes;
+	u8                      bpp;
+	u8                      bpp_plane0;
+	u8                      w_align;
+	u8                      h_align;
+};
+
+/**
+ * struct hva_frameinfo - information of frame
+ *
+ * @flags		flags of input frame
+ * @fmt:		format of input frame
+ * @width:		width of input frame
+ * @height:		height of input frame
+ * @crop:		cropping window due to encoder alignment constraints
+ *			(1920x1080@0,0 inside 1920x1088 encoded frame for ex.)
+ * @pixelaspect:	pixel aspect ratio of video (4/3, 5/4)
+ * @frame_width:	width of output frame (encoder alignment constraint)
+ * @frame_height:	height ""
+*/
+struct hva_frameinfo {
+	u32 flags;
+	struct hva_frame_fmt fmt;
+	u32 width;
+	u32 height;
+	struct v4l2_rect crop;
+	struct v4l2_fract pixelaspect;
+	u32 frame_width;
+	u32 frame_height;
+};
+
+/**
+ * struct hva_streaminfo - information of stream
+ *
+ * @flags		flags of video stream
+ * @width:		width of video stream
+ * @height:		height ""
+ * @streamformat:	fourcc compressed format of video (H264, JPEG, ...)
+ * @dpb:		number of frames needed to encode a single frame
+ *			(h264 dpb, up to 16 in standard)
+ * @profile:		profile string
+ * @level:		level string
+ * @other:		other string information from codec
+ */
+struct hva_streaminfo {
+	u32 flags;
+	u32 streamformat;
+	u32 width;
+	u32 height;
+	u32 dpb;
+	u8 profile[32];
+	u8 level[32];
+	u8 other[32];
+};
+
+#define HVA_FRAMEINFO_FLAG_CROP		0x0001
+#define HVA_FRAMEINFO_FLAG_PIXELASPECT	0x0002
+
+#define HVA_STREAMINFO_FLAG_OTHER	0x0001
+#define HVA_STREAMINFO_FLAG_JPEG	0x0002
+#define HVA_STREAMINFO_FLAG_H264	0x0004
+#define HVA_STREAMINFO_FLAG_VP8	0x0008
+
+/**
+ * struct hva_controls
+ *
+ * @level: level enumerate
+ * @profile: video profile
+ * @entropy_mode: entropy mode (CABAC or CVLC)
+ * @bitrate_mode: bitrate mode (constant bitrate or variable bitrate)
+ * @gop_size: groupe of picture size
+ * @bitrate: bitrate
+ * @cpb_size: coded picture buffer size
+ * @intra_refresh: activate intra refresh
+ * @dct8x8: enable transform mode 8x8
+ * @qpmin: defines the minimum quantizer
+ * @qpmax: defines the maximum quantizer
+ * @jpeg_comp_quality: jpeg compression quality
+ * @vui_sar: pixel aspect ratio enable
+ * @vui_sar_idc: pixel aspect ratio identifier
+ * @sei_fp: sei frame packing arrangement enable
+ * @sei_fp_type: sei frame packing arrangement type
+ */
+struct hva_controls {
+	enum v4l2_mpeg_video_h264_level level;
+	enum v4l2_mpeg_video_h264_profile profile;
+	enum v4l2_mpeg_video_h264_entropy_mode entropy_mode;
+	enum v4l2_mpeg_video_bitrate_mode bitrate_mode;
+	u32 gop_size;
+	u32 bitrate;
+	u32 cpb_size;
+	bool intra_refresh;
+	bool dct8x8;
+	u32 qpmin;
+	u32 qpmax;
+	u32 jpeg_comp_quality;
+	bool vui_sar;
+	enum v4l2_mpeg_video_h264_vui_sar_idc vui_sar_idc;
+	bool sei_fp;
+	enum v4l2_mpeg_video_h264_sei_fp_arrangement_type sei_fp_type;
+};
+
+/**
+ * struct hva_frame - structure.
+ *
+ * @v4l2:	video buffer information for v4l2.
+ *		To be kept first and not to be wrote by driver.
+ *		Allows to get the hva_frame fields by just casting a vb2_buffer
+ *		with hva_frame struct. This is allowed through the use of
+ *		vb2 custom buffer mechanism, cf @buf_struct_size of
+ *		struct vb2_queue in include/media/videobuf2-core.h
+ * @paddr:	physical address (for hardware)
+ * @vaddr:	virtual address (kernel can read/write)
+ * @prepared:	boolean, if set vaddr/paddr are resolved
+ */
+struct hva_frame {
+	struct vb2_v4l2_buffer	v4l2; /* !keep first! */
+	dma_addr_t		paddr;
+	void			*vaddr;
+	int			prepared;
+};
+
+/**
+ * struct hva_stream - structure.
+ *
+ * @v4l2:	video buffer information for v4l2.
+ *		To be kept first and not to be wrote by driver.
+ *		Allows to get the hva_stream fields by just casting a vb2_buffer
+ *		with hva_stream struct. This is allowed through the use of
+ *		vb2 custom buffer mechanism, cf @buf_struct_size of
+ *		struct vb2_queue in include/media/videobuf2-core.h
+ * @list:	list element
+ * @paddr:	physical address (for hardware)
+ * @vaddr:	virtual address (kernel can read/write)
+ * @prepared:	boolean, if set vaddr/paddr are resolved
+ * @payload:	number of bytes occupied by data in the buffer
+ */
+struct hva_stream {
+	struct vb2_v4l2_buffer	v4l2; /* !keep first! */
+	struct list_head	list;
+	dma_addr_t		paddr;
+	void			*vaddr;
+	int			prepared;
+	unsigned int		payload;
+};
+
+/**
+ * struct hva_buffer - structure.
+ *
+ * @name:	name of requester
+ * @attrs:	dma attributes
+ * @paddr:	physical address (for hardware)
+ * @vaddr:	virtual address (kernel can read/write)
+ * @size:	size of buffer
+ */
+struct hva_buffer {
+	const char		*name;
+	struct dma_attrs	attrs;
+	dma_addr_t		paddr;
+	void			*vaddr;
+	u32			size;
+};
+
+struct hva_device;
+struct hva_encoder;
+
+#define HVA_MAX_ENCODERS 30
+
+#define HVA_FLAG_STREAMINFO 0x0001
+#define HVA_FLAG_FRAMEINFO 0x0002
+
+/**
+ * struct hva_ctx - context structure.
+ *
+ * @flags:		validity of fields (streaminfo,frameinfo)
+ * @fh:			keep track of V4L2 file handle
+ * @dev:		keep track of device context
+ * @client_id:		Client Identifier
+ * @q_frame:		V4L2 vb2 queue for access units, allocated by driver
+ *			but managed by vb2 framework.
+ * @q_stream:		V4L2 vb2 queue for frames, allocated by driver
+ *			but managed by vb2 framework.
+ * @name:		string naming this instance (debug purpose)
+ * @list_stream:	list of stream queued for destination only
+ * @frame_num		frame number
+ * @frames:		set of src frames (input, reconstructed & reference)
+ * @priv:		private codec context for this instance, allocated
+ *			by encoder @open time.
+ * @sys_errors:		number of system errors ( memory, resource, pm, ..)
+ * @encode_errors:	number of encoding errors ( hw/driver errors)
+ * @frames_errors:	number of frames errors ( format, size, header ..)
+ * @hw_err:		hardware error detected
+ */
+struct hva_ctx {
+	u32 flags;
+
+	struct v4l2_fh fh;
+	struct hva_device *hdev;
+	struct device *dev;
+
+	u8 client_id;
+
+	/* vb2 queues */
+	struct vb2_queue q_frame;
+	struct vb2_queue q_stream;
+
+	char name[100];
+
+	struct list_head list_stream;
+
+	u32 frame_num;
+
+	struct hva_controls ctrls;
+	struct v4l2_fract time_per_frame;
+	u32 num_frames;
+
+	/* stream */
+	struct hva_streaminfo streaminfo;
+
+	/* frame */
+	struct hva_frameinfo frameinfo;
+
+	/* current encoder */
+	struct hva_encoder *encoder;
+
+	/* stats */
+	u32 encoded_frames;
+
+	/* private data */
+	void *priv;
+
+	/* errors */
+	u32 sys_errors;
+	u32 encode_errors;
+	u32 frame_skipped;
+	u32 frame_errors;
+	bool hw_err;
+
+	/* hardware task descriptor*/
+	struct hva_buffer *task;
+};
+
+/**
+ * struct hva_device - device struct, 1 per probe (so single one for
+ * all platform life)
+ *
+ * @v4l2_dev:		v4l2 device
+ * @vdev:		v4l2 video device
+ * @pdev:		platform device
+ * @dev:		device
+ * @lock:		device lock for critical section &
+ *			V4L2 ops serialization
+ * @instance_id:	instance identifier
+ * @contexts_list:	contexts list
+ * @regs:		register io memory access
+ * @reg_size:		register size
+ * @irq_its:		its interruption
+ * @irq_err:		error interruption
+ * @chip_id:		chipset identifier
+ * @protect_mutex:	mutex use to lock access of hardware
+ * @interrupt:		completion interrupt
+ * @clk:		hva clock
+ * @esram_addr:		esram address
+ * @esram_size:		esram size
+ * @sfl_reg:		Status fifo level register value
+ * @sts_reg:		Status register value
+ * @lmi_err_reg:	Local memory interface Error register value
+ * @emi_err_reg:	External memory interface Error register value
+ * @hec_mif_err_reg:HEC memory interface Error register value
+ * @encoders:		list of all encoders registered
+ * @nb_of_encoders:	number of encoders registered
+ * @nb_of_instances:	number of instance
+ */
+struct hva_device {
+	/* device */
+	struct v4l2_device v4l2_dev;
+	struct video_device *vdev;
+	struct platform_device *pdev;
+	struct device *dev;
+	struct mutex lock; /* device lock for critical section & V4L2 ops */
+	int instance_id;
+	struct hva_ctx *contexts_list[MAX_CONTEXT];
+
+	/* hardware */
+	void __iomem *regs;
+	int regs_size;
+	int irq_its;
+	int irq_err;
+	unsigned long int chip_id;
+	struct mutex protect_mutex; /* mutex use to lock access of hardware */
+	struct completion interrupt;
+	struct clk *clk;
+	u32 esram_addr;
+	u32 esram_size;
+
+	/* registers */
+	u32 sfl_reg;
+	u32 sts_reg;
+	u32 lmi_err_reg;
+	u32 emi_err_reg;
+	u32 hec_mif_err_reg;
+
+	/* encoders */
+	const struct hva_encoder *encoders[HVA_MAX_ENCODERS];
+	u32 nb_of_encoders;
+	u32 nb_of_instances;
+};
+
+struct hva_encoder {
+	struct list_head list;
+	const char *name;
+	u32 streamformat;
+	u32 pixelformat;
+	u32 max_width;
+	u32 max_height;
+
+	/**
+	 * Encoder ops
+	 */
+	int (*open)(struct hva_ctx *ctx);
+	int (*close)(struct hva_ctx *ctx);
+
+	/**
+	 * encode() - encode a single access unit
+	 * @ctx:	(in) instance
+	 * @frame:		(in/out) access unit
+	 *  @frame.size	(in) size of frame to encode
+	 *  @frame.vaddr	(in) virtual address (kernel can read/write)
+	 *  @frame.paddr	(in) physical address (for hardware)
+	 *  @frame.flags	(out) frame type (V4L2_BUF_FLAG_KEYFRAME/
+	 *			PFRAME/BFRAME)
+	 * @stream:	(out) frame with encoded data:
+	 *  @stream.index	(out) identifier of frame
+	 *  @stream.vaddr	(out) virtual address (kernel can read/write)
+	 *  @stream.paddr	(out) physical address (for hardware)
+	 *  @stream.pix		(out) width/height/format/stride/...
+	 *  @stream.flags	(out) stream type (V4L2_BUF_FLAG_KEYFRAME/
+	 *			PFRAME/BFRAME)
+	 *
+	 * Encode the access unit given. Encode is synchronous;
+	 * access unit memory is no more needed after this call.
+	 * After this call, none, one or several frames could
+	 * have been encoded, which can be retrieved using
+	 * get_stream().
+	*/
+	int (*encode)(struct hva_ctx *ctx, struct hva_frame *frame,
+		      struct hva_stream *stream);
+};
+
+static inline const char *profile_str(unsigned int p)
+{
+	switch (p) {
+	case V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE:
+		return "baseline profile";
+	case V4L2_MPEG_VIDEO_H264_PROFILE_MAIN:
+		return "main profile";
+	case V4L2_MPEG_VIDEO_H264_PROFILE_EXTENDED:
+		return "extended profile";
+	case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH:
+		return "high profile";
+	case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_10:
+		return "high 10 profile";
+	case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_422:
+		return "high 422 profile";
+	case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_444_PREDICTIVE:
+		return "high 444 predictive profile";
+	case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_10_INTRA:
+		return "high 10 intra profile";
+	case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_422_INTRA:
+		return "high 422 intra profile";
+	case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_444_INTRA:
+		return "high 444 intra profile";
+	case V4L2_MPEG_VIDEO_H264_PROFILE_CAVLC_444_INTRA:
+		return "calvc 444 intra profile";
+	case V4L2_MPEG_VIDEO_H264_PROFILE_SCALABLE_BASELINE:
+		return "scalable baseline profile";
+	case V4L2_MPEG_VIDEO_H264_PROFILE_SCALABLE_HIGH:
+		return "scalable high profile";
+	case V4L2_MPEG_VIDEO_H264_PROFILE_SCALABLE_HIGH_INTRA:
+		return "scalable high intra profile";
+	case V4L2_MPEG_VIDEO_H264_PROFILE_STEREO_HIGH:
+		return "stereo high profile";
+	case V4L2_MPEG_VIDEO_H264_PROFILE_MULTIVIEW_HIGH:
+		return "multiview high profile";
+	default:
+		return "unknown profile";
+	}
+}
+
+static inline const char *level_str(enum v4l2_mpeg_video_h264_level l)
+{
+	switch (l) {
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1_0:
+		return "level 1.0";
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1B:
+		return "level 1b";
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1_1:
+		return "level 1.1";
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1_2:
+		return "level 1.2";
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1_3:
+		return "level 1.3";
+	case V4L2_MPEG_VIDEO_H264_LEVEL_2_0:
+		return "level 2.0";
+	case V4L2_MPEG_VIDEO_H264_LEVEL_2_1:
+		return "level 2.1";
+	case V4L2_MPEG_VIDEO_H264_LEVEL_2_2:
+		return "level 2.2";
+	case V4L2_MPEG_VIDEO_H264_LEVEL_3_0:
+		return "level 3.0";
+	case V4L2_MPEG_VIDEO_H264_LEVEL_3_1:
+		return "level 3.1";
+	case V4L2_MPEG_VIDEO_H264_LEVEL_3_2:
+		return "level 3.2";
+	case V4L2_MPEG_VIDEO_H264_LEVEL_4_0:
+		return "level 4.0";
+	case V4L2_MPEG_VIDEO_H264_LEVEL_4_1:
+		return "level 4.1";
+	case V4L2_MPEG_VIDEO_H264_LEVEL_4_2:
+		return "level 4.2";
+	case V4L2_MPEG_VIDEO_H264_LEVEL_5_0:
+		return "level 5.0";
+	case V4L2_MPEG_VIDEO_H264_LEVEL_5_1:
+		return "level 5.1";
+	default:
+		return "unknown level";
+	}
+}
+
+static inline const char *bitrate_mode_str(enum v4l2_mpeg_video_bitrate_mode m)
+{
+	switch (m) {
+	case V4L2_MPEG_VIDEO_BITRATE_MODE_VBR:
+		return "variable bitrate";
+	case V4L2_MPEG_VIDEO_BITRATE_MODE_CBR:
+		return "constant bitrate";
+	default:
+		return "unknown bitrate mode";
+	}
+}
+
+#endif /* HVA_H */
-- 
1.9.1

