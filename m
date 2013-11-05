Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:57362 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab3KEMNp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 07:13:45 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.ameer@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH v12 04/12] [media] exynos5-fimc-is: Add register definition and context header
Date: Tue,  5 Nov 2013 17:43:21 +0530
Message-Id: <1383653610-11835-5-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1383653610-11835-1-git-send-email-arun.kk@samsung.com>
References: <1383653610-11835-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the register definition file for the fimc-is driver
and also the header file containing the main context for the driver.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos5-is/fimc-is-regs.h |  105 ++++++++++++++
 drivers/media/platform/exynos5-is/fimc-is.h      |  160 ++++++++++++++++++++++
 2 files changed, 265 insertions(+)
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-regs.h
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is.h

diff --git a/drivers/media/platform/exynos5-is/fimc-is-regs.h b/drivers/media/platform/exynos5-is/fimc-is-regs.h
new file mode 100644
index 0000000..06aa466
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is-regs.h
@@ -0,0 +1,105 @@
+/*
+ * Samsung Exynos5 SoC series FIMC-IS driver
+ *
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd
+ * Arun Kumar K <arun.kk@samsung.com>
+ * Kil-yeon Lim <kilyeon.im@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef FIMC_IS_REGS_H
+#define FIMC_IS_REGS_H
+
+/* WDT_ISP register */
+#define WDT			0x00170000
+/* MCUCTL register */
+#define MCUCTL			0x00180000
+/* MCU Controller Register */
+#define MCUCTLR				(MCUCTL+0x00)
+#define MCUCTLR_AXI_ISPX_AWCACHE(x)	((x) << 16)
+#define MCUCTLR_AXI_ISPX_ARCACHE(x)	((x) << 12)
+#define MCUCTLR_MSWRST			(1 << 0)
+/* Boot Base OFfset Address Register */
+#define BBOAR				(MCUCTL+0x04)
+#define BBOAR_BBOA(x)			((x) << 0)
+
+/* Interrupt Generation Register 0 from Host CPU to VIC */
+#define INTGR0				(MCUCTL+0x08)
+#define INTGR0_INTGC(n)			(1 << ((n) + 16))
+#define INTGR0_INTGD(n)			(1 << (n))
+
+/* Interrupt Clear Register 0 from Host CPU to VIC */
+#define INTCR0				(MCUCTL+0x0c)
+#define INTCR0_INTCC(n)			(1 << ((n) + 16))
+#define INTCR0_INTCD(n)			(1 << (n))
+
+/* Interrupt Mask Register 0 from Host CPU to VIC */
+#define INTMR0				(MCUCTL+0x10)
+#define INTMR0_INTMC(n)			(1 << ((n) + 16))
+#define INTMR0_INTMD(n)			(1 << (n))
+
+/* Interrupt Status Register 0 from Host CPU to VIC */
+#define INTSR0				(MCUCTL+0x14)
+#define INTSR0_GET_INTSD(n, x)		(((x) >> (n)) & 0x1)
+#define INTSR0_GET_INTSC(n, x)		(((x) >> ((n) + 16)) & 0x1)
+
+/* Interrupt Mask Status Register 0 from Host CPU to VIC */
+#define INTMSR0				(MCUCTL+0x18)
+#define INTMSR0_GET_INTMSD(n, x)	(((x) >> (n)) & 0x1)
+#define INTMSR0_GET_INTMSC(n, x)	(((x) >> ((n) + 16)) & 0x1)
+
+/* Interrupt Generation Register 1 from ISP CPU to Host IC */
+#define INTGR1				(MCUCTL+0x1c)
+#define INTGR1_INTGC(n)			(1 << (n))
+
+/* Interrupt Clear Register 1 from ISP CPU to Host IC */
+#define INTCR1				(MCUCTL+0x20)
+#define INTCR1_INTCC(n)			(1 << (n))
+
+/* Interrupt Mask Register 1 from ISP CPU to Host IC */
+#define INTMR1				(MCUCTL+0x24)
+#define INTMR1_INTMC(n)			(1 << (n))
+
+/* Interrupt Status Register 1 from ISP CPU to Host IC */
+#define INTSR1				(MCUCTL+0x28)
+/* Interrupt Mask Status Register 1 from ISP CPU to Host IC */
+#define INTMSR1				(MCUCTL+0x2c)
+/* Interrupt Clear Register 2 from ISP BLK's interrupts to Host IC */
+#define INTCR2				(MCUCTL+0x30)
+#define INTCR2_INTCC(n)			(1 << (n))
+
+/* Interrupt Mask Register 2 from ISP BLK's interrupts to Host IC */
+#define INTMR2				(MCUCTL+0x34)
+#define INTMR2_INTMCIS(n)		(1 << (n))
+
+/* Interrupt Status Register 2 from ISP BLK's interrupts to Host IC */
+#define INTSR2				(MCUCTL+0x38)
+/* Interrupt Mask Status Register 2 from ISP BLK's interrupts to Host IC */
+#define INTMSR2				(MCUCTL+0x3c)
+/* General Purpose Output Control Register (0~17) */
+#define GPOCTLR				(MCUCTL+0x40)
+#define GPOCTLR_GPOG(n, x)		((x) << (n))
+
+/* General Purpose Pad Output Enable Register (0~17) */
+#define GPOENCTLR			(MCUCTL+0x44)
+#define GPOENCTLR_GPOEN0(n, x)		((x) << (n))
+
+/* General Purpose Input Control Register (0~17) */
+#define GPICTLR				(MCUCTL+0x48)
+
+/* IS Shared Registers between ISP CPU and HOST CPU */
+#define ISSR(n)			(MCUCTL + 0x80 + (n))
+
+/* PMU for FIMC-IS*/
+#define PMUREG_CMU_RESET_ISP_SYS_PWR_REG	0x1584
+#define PMUREG_ISP_ARM_CONFIGURATION		0x2280
+#define PMUREG_ISP_ARM_STATUS			0x2284
+#define PMUREG_ISP_ARM_OPTION			0x2288
+#define PMUREG_ISP_LOW_POWER_OFF		0x0004
+#define PMUREG_ISP_CONFIGURATION		0x4020
+#define PMUREG_ISP_STATUS			0x4024
+
+#endif
diff --git a/drivers/media/platform/exynos5-is/fimc-is.h b/drivers/media/platform/exynos5-is/fimc-is.h
new file mode 100644
index 0000000..136f367
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is.h
@@ -0,0 +1,160 @@
+/*
+ * Samsung EXYNOS5 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ *  Arun Kumar K <arun.kk@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef FIMC_IS_H_
+#define FIMC_IS_H_
+
+#include "fimc-is-err.h"
+#include "fimc-is-core.h"
+#include "fimc-is-param.h"
+#include "fimc-is-pipeline.h"
+#include "fimc-is-interface.h"
+
+#define fimc_interface_to_is(p) container_of(p, struct fimc_is, interface)
+#define fimc_sensor_to_is(p) container_of(p, struct fimc_is, sensor)
+
+/*
+ * Macros used by media dev to get the subdev and vfd
+ * is - driver data from pdev
+ * pid - pipeline index
+ */
+#define fimc_is_isp_get_sd(is, pid) (&is->pipeline[pid].isp.subdev)
+#define fimc_is_isp_get_vfd(is, pid) (&is->pipeline[pid].isp.vfd)
+#define fimc_is_scc_get_sd(is, pid) \
+	(&is->pipeline[pid].scaler[SCALER_SCC].subdev)
+#define fimc_is_scc_get_vfd(is, pid) \
+	(&is->pipeline[pid].scaler[SCALER_SCC].vfd)
+#define fimc_is_scp_get_sd(is, pid) \
+	(&is->pipeline[pid].scaler[SCALER_SCP].subdev)
+#define fimc_is_scp_get_vfd(is, pid) \
+	(&is->pipeline[pid].scaler[SCALER_SCP].vfd)
+/*
+ * is - driver data from pdev
+ * sid - sensor index
+ */
+#define fimc_is_sensor_get_sd(is, sid) (&is->sensor[sid].subdev)
+
+
+/**
+ * struct fimc_is - fimc-is driver private data
+ * @pdev: pointer to FIMC-IS platform device
+ * @pdata: platform data for FIMC-IS
+ * @alloc_ctx: videobuf2 memory allocator context
+ * @clock: FIMC-IS clocks
+ * @pmu_regs: PMU reg base address
+ * @num_pipelines: number of pipelines opened
+ * @minfo: internal memory organization info
+ * @drvdata: fimc-is driver data
+ * @sensor: FIMC-IS sensor context
+ * @pipeline: hardware pipeline context
+ * @interface: hardware interface context
+ */
+struct fimc_is {
+	struct platform_device		*pdev;
+
+	struct vb2_alloc_ctx		*alloc_ctx;
+	struct clk			*clock[IS_CLK_MAX_NUM];
+	void __iomem			*pmu_regs;
+	unsigned int			num_pipelines;
+
+	struct fimc_is_meminfo		minfo;
+
+	struct fimc_is_drvdata		*drvdata;
+	struct fimc_is_sensor		sensor[FIMC_IS_NUM_SENSORS];
+	struct fimc_is_pipeline		pipeline[FIMC_IS_NUM_PIPELINES];
+	struct fimc_is_interface	interface;
+};
+
+/* Queue operations for ISP */
+static inline void fimc_is_isp_wait_queue_add(struct fimc_is_isp *isp,
+		struct fimc_is_buf *buf)
+{
+	list_add_tail(&buf->list, &isp->wait_queue);
+	isp->wait_queue_cnt++;
+}
+
+static inline struct fimc_is_buf *fimc_is_isp_wait_queue_get(
+		struct fimc_is_isp *isp)
+{
+	struct fimc_is_buf *buf;
+	buf = list_entry(isp->wait_queue.next,
+			struct fimc_is_buf, list);
+	list_del(&buf->list);
+	isp->wait_queue_cnt--;
+	return buf;
+}
+
+static inline void fimc_is_isp_run_queue_add(struct fimc_is_isp *isp,
+		struct fimc_is_buf *buf)
+{
+	list_add_tail(&buf->list, &isp->run_queue);
+	isp->run_queue_cnt++;
+}
+
+static inline struct fimc_is_buf *fimc_is_isp_run_queue_get(
+		struct fimc_is_isp *isp)
+{
+	struct fimc_is_buf *buf;
+	buf = list_entry(isp->run_queue.next,
+			struct fimc_is_buf, list);
+	list_del(&buf->list);
+	isp->run_queue_cnt--;
+	return buf;
+}
+
+/* Queue operations for SCALER */
+static inline void fimc_is_scaler_wait_queue_add(struct fimc_is_scaler *scp,
+		struct fimc_is_buf *buf)
+{
+	list_add_tail(&buf->list, &scp->wait_queue);
+	scp->wait_queue_cnt++;
+}
+
+static inline struct fimc_is_buf *fimc_is_scaler_wait_queue_get(
+		struct fimc_is_scaler *scp)
+{
+	struct fimc_is_buf *buf;
+	buf = list_entry(scp->wait_queue.next,
+			struct fimc_is_buf, list);
+	list_del(&buf->list);
+	scp->wait_queue_cnt--;
+	return buf;
+}
+
+static inline void fimc_is_scaler_run_queue_add(struct fimc_is_scaler *scp,
+		struct fimc_is_buf *buf)
+{
+	list_add_tail(&buf->list, &scp->run_queue);
+	scp->run_queue_cnt++;
+}
+
+static inline struct fimc_is_buf *fimc_is_scaler_run_queue_get(
+		struct fimc_is_scaler *scp)
+{
+	struct fimc_is_buf *buf;
+	buf = list_entry(scp->run_queue.next,
+			struct fimc_is_buf, list);
+	list_del(&buf->list);
+	scp->run_queue_cnt--;
+	return buf;
+}
+
+static inline void pmu_is_write(u32 v, struct fimc_is *is, unsigned int offset)
+{
+	writel(v, is->pmu_regs + offset);
+}
+
+static inline u32 pmu_is_read(struct fimc_is *is, unsigned int offset)
+{
+	return readl(is->pmu_regs + offset);
+}
+
+#endif
-- 
1.7.9.5

