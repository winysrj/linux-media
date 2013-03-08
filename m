Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:59188 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757966Ab3CHOkc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 09:40:32 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org
Cc: s.nawrocki@samsung.com, kgene.kim@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: [RFC 05/12] exynos-fimc-is: Adds the register definition and context
 header
Date: Fri, 08 Mar 2013 09:59:18 -0500
Message-id: <1362754765-2651-6-git-send-email-arun.kk@samsung.com>
In-reply-to: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the register definition file for the fimc-is driver
and also the header file containing the main context for the driver.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
---
 drivers/media/platform/exynos5-is/fimc-is-regs.h |  352 ++++++++++++++++++++++
 drivers/media/platform/exynos5-is/fimc-is.h      |  151 ++++++++++
 2 files changed, 503 insertions(+)
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-regs.h
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is.h

diff --git a/drivers/media/platform/exynos5-is/fimc-is-regs.h b/drivers/media/platform/exynos5-is/fimc-is-regs.h
new file mode 100644
index 0000000..43ed011
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is-regs.h
@@ -0,0 +1,352 @@
+/*
+ * Samsung Exynos5 SoC series FIMC-IS driver
+ *
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef FIMC_IS_REGS_H
+#define FIMC_IS_REGS_H
+
+#include <mach/map.h>
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
+/* Interrupt Generation Register 0 from Host CPU to VIC */
+#define INTGR0				(MCUCTL+0x08)
+#define INTGR0_INTGC9			(1 << 25)
+#define INTGR0_INTGC8			(1 << 24)
+#define INTGR0_INTGC7			(1 << 23)
+#define INTGR0_INTGC6			(1 << 22)
+#define INTGR0_INTGC5			(1 << 21)
+#define INTGR0_INTGC4			(1 << 20)
+#define INTGR0_INTGC3			(1 << 19)
+#define INTGR0_INTGC2			(1 << 18)
+#define INTGR0_INTGC1			(1 << 17)
+#define INTGR0_INTGC0			(1 << 16)
+#define INTGR0_INTGD5			(1 << 5)
+#define INTGR0_INTGD4			(1 << 4)
+#define INTGR0_INTGD3			(1 << 3)
+#define INTGR0_INTGD2			(1 << 2)
+#define INTGR0_INTGD1			(1 << 1)
+#define INTGR0_INTGD0			(1 << 0)
+/* Interrupt Clear Register 0 from Host CPU to VIC */
+#define INTCR0				(MCUCTL+0x0c)
+#define INTCR0_INTCC9			(1 << 25)
+#define INTCR0_INTCC8			(1 << 24)
+#define INTCR0_INTCC7			(1 << 23)
+#define INTCR0_INTCC6			(1 << 22)
+#define INTCR0_INTCC5			(1 << 21)
+#define INTCR0_INTCC4			(1 << 20)
+#define INTCR0_INTCC3			(1 << 19)
+#define INTCR0_INTCC2			(1 << 18)
+#define INTCR0_INTCC1			(1 << 17)
+#define INTCR0_INTCC0			(1 << 16)
+#define INTCR0_INTCD5			(1 << 5)
+#define INTCR0_INTCD4			(1 << 4)
+#define INTCR0_INTCD3			(1 << 3)
+#define INTCR0_INTCD2			(1 << 2)
+#define INTCR0_INTCD1			(1 << 1)
+#define INTCR0_INTCD0			(1 << 0)
+/* Interrupt Mask Register 0 from Host CPU to VIC */
+#define INTMR0				(MCUCTL+0x10)
+#define INTMR0_INTMC9			(1 << 25)
+#define INTMR0_INTMC8			(1 << 24)
+#define INTMR0_INTMC7			(1 << 23)
+#define INTMR0_INTMC6			(1 << 22)
+#define INTMR0_INTMC5			(1 << 21)
+#define INTMR0_INTMC4			(1 << 20)
+#define INTMR0_INTMC3			(1 << 19)
+#define INTMR0_INTMC2			(1 << 18)
+#define INTMR0_INTMC1			(1 << 17)
+#define INTMR0_INTMC0			(1 << 16)
+#define INTMR0_INTMD5			(1 << 5)
+#define INTMR0_INTMD4			(1 << 4)
+#define INTMR0_INTMD3			(1 << 3)
+#define INTMR0_INTMD2			(1 << 2)
+#define INTMR0_INTMD1			(1 << 1)
+#define INTMR0_INTMD0			(1 << 0)
+/* Interrupt Status Register 0 from Host CPU to VIC */
+#define INTSR0				(MCUCTL+0x14)
+#define INTSR0_GET_INTSD0(x)		(((x) >> 0) & 0x1)
+#define INTSR0_GET_INTSD1(x)		(((x) >> 1) & 0x1)
+#define INTSR0_GET_INTSD2(x)		(((x) >> 2) & 0x1)
+#define INTSR0_GET_INTSD3(x)		(((x) >> 3) & 0x1)
+#define INTSR0_GET_INTSD4(x)		(((x) >> 4) & 0x1)
+#define INTSR0_GET_INTSC0(x)		(((x) >> 16) & 0x1)
+#define INTSR0_GET_INTSC1(x)		(((x) >> 17) & 0x1)
+#define INTSR0_GET_INTSC2(x)		(((x) >> 18) & 0x1)
+#define INTSR0_GET_INTSC3(x)		(((x) >> 19) & 0x1)
+#define INTSR0_GET_INTSC4(x)		(((x) >> 20) & 0x1)
+#define INTSR0_GET_INTSC5(x)		(((x) >> 21) & 0x1)
+#define INTSR0_GET_INTSC6(x)		(((x) >> 22) & 0x1)
+#define INTSR0_GET_INTSC7(x)		(((x) >> 23) & 0x1)
+#define INTSR0_GET_INTSC8(x)		(((x) >> 24) & 0x1)
+#define INTSR0_GET_INTSC9(x)		(((x) >> 25) & 0x1)
+/* Interrupt Mask Status Register 0 from Host CPU to VIC */
+#define INTMSR0				(MCUCTL+0x18)
+#define INTMSR0_GET_INTMSD0(x)		(((x) >> 0) & 0x1)
+#define INTMSR0_GET_INTMSD1(x)		(((x) >> 1) & 0x1)
+#define INTMSR0_GET_INTMSD2(x)		(((x) >> 2) & 0x1)
+#define INTMSR0_GET_INTMSD3(x)		(((x) >> 3) & 0x1)
+#define INTMSR0_GET_INTMSD4(x)		(((x) >> 4) & 0x1)
+#define INTMSR0_GET_INTMSC0(x)		(((x) >> 16) & 0x1)
+#define INTMSR0_GET_INTMSC1(x)		(((x) >> 17) & 0x1)
+#define INTMSR0_GET_INTMSC2(x)		(((x) >> 18) & 0x1)
+#define INTMSR0_GET_INTMSC3(x)		(((x) >> 19) & 0x1)
+#define INTMSR0_GET_INTMSC4(x)		(((x) >> 20) & 0x1)
+#define INTMSR0_GET_INTMSC5(x)		(((x) >> 21) & 0x1)
+#define INTMSR0_GET_INTMSC6(x)		(((x) >> 22) & 0x1)
+#define INTMSR0_GET_INTMSC7(x)		(((x) >> 23) & 0x1)
+#define INTMSR0_GET_INTMSC8(x)		(((x) >> 24) & 0x1)
+#define INTMSR0_GET_INTMSC9(x)		(((x) >> 25) & 0x1)
+/* Interrupt Generation Register 1 from ISP CPU to Host IC */
+#define INTGR1				(MCUCTL+0x1c)
+#define INTGR1_INTGC9			(1 << 9)
+#define INTGR1_INTGC8			(1 << 8)
+#define INTGR1_INTGC7			(1 << 7)
+#define INTGR1_INTGC6			(1 << 6)
+#define INTGR1_INTGC5			(1 << 5)
+#define INTGR1_INTGC4			(1 << 4)
+#define INTGR1_INTGC3			(1 << 3)
+#define INTGR1_INTGC2			(1 << 2)
+#define INTGR1_INTGC1			(1 << 1)
+#define INTGR1_INTGC0			(1 << 0)
+/* Interrupt Clear Register 1 from ISP CPU to Host IC */
+#define INTCR1				(MCUCTL+0x20)
+#define INTCR1_INTCC9			(1 << 9)
+#define INTCR1_INTCC8			(1 << 8)
+#define INTCR1_INTCC7			(1 << 7)
+#define INTCR1_INTCC6			(1 << 6)
+#define INTCR1_INTCC5			(1 << 5)
+#define INTCR1_INTCC4			(1 << 4)
+#define INTCR1_INTCC3			(1 << 3)
+#define INTCR1_INTCC2			(1 << 2)
+#define INTCR1_INTCC1			(1 << 1)
+#define INTCR1_INTCC0			(1 << 0)
+/* Interrupt Mask Register 1 from ISP CPU to Host IC */
+#define INTMR1				(MCUCTL+0x24)
+#define INTMR1_INTMC9			(1 << 9)
+#define INTMR1_INTMC8			(1 << 8)
+#define INTMR1_INTMC7			(1 << 7)
+#define INTMR1_INTMC6			(1 << 6)
+#define INTMR1_INTMC5			(1 << 5)
+#define INTMR1_INTMC4			(1 << 4)
+#define INTMR1_INTMC3			(1 << 3)
+#define INTMR1_INTMC2			(1 << 2)
+#define INTMR1_INTMC1			(1 << 1)
+#define INTMR1_INTMC0			(1 << 0)
+/* Interrupt Status Register 1 from ISP CPU to Host IC */
+#define INTSR1				(MCUCTL+0x28)
+/* Interrupt Mask Status Register 1 from ISP CPU to Host IC */
+#define INTMSR1				(MCUCTL+0x2c)
+/* Interrupt Clear Register 2 from ISP BLK's interrupts to Host IC */
+#define INTCR2				(MCUCTL+0x30)
+#define INTCR2_INTCC21			(1 << 21)
+#define INTCR2_INTCC20			(1 << 20)
+#define INTCR2_INTCC19			(1 << 19)
+#define INTCR2_INTCC18			(1 << 18)
+#define INTCR2_INTCC17			(1 << 17)
+#define INTCR2_INTCC16			(1 << 16)
+/* Interrupt Mask Register 2 from ISP BLK's interrupts to Host IC */
+#define INTMR2				(MCUCTL+0x34)
+#define INTMR2_INTMCIS25		(1 << 25)
+#define INTMR2_INTMCIS24		(1 << 24)
+#define INTMR2_INTMCIS23		(1 << 23)
+#define INTMR2_INTMCIS22		(1 << 22)
+#define INTMR2_INTMCIS21		(1 << 21)
+#define INTMR2_INTMCIS20		(1 << 20)
+#define INTMR2_INTMCIS19		(1 << 19)
+#define INTMR2_INTMCIS18		(1 << 18)
+#define INTMR2_INTMCIS17		(1 << 17)
+#define INTMR2_INTMCIS16		(1 << 16)
+#define INTMR2_INTMCIS15		(1 << 15)
+#define INTMR2_INTMCIS14		(1 << 14)
+#define INTMR2_INTMCIS13		(1 << 13)
+#define INTMR2_INTMCIS12		(1 << 12)
+#define INTMR2_INTMCIS11		(1 << 11)
+#define INTMR2_INTMCIS10		(1 << 10)
+#define INTMR2_INTMCIS9			(1 << 9)
+#define INTMR2_INTMCIS8			(1 << 8)
+#define INTMR2_INTMCIS7			(1 << 7)
+#define INTMR2_INTMCIS6			(1 << 6)
+#define INTMR2_INTMCIS5			(1 << 5)
+#define INTMR2_INTMCIS4			(1 << 4)
+#define INTMR2_INTMCIS3			(1 << 3)
+#define INTMR2_INTMCIS2			(1 << 2)
+#define INTMR2_INTMCIS1			(1 << 1)
+#define INTMR2_INTMCIS0			(1 << 0)
+/* Interrupt Status Register 2 from ISP BLK's interrupts to Host IC */
+#define INTSR2				(MCUCTL+0x38)
+/* Interrupt Mask Status Register 2 from ISP BLK's interrupts to Host IC */
+#define INTMSR2				(MCUCTL+0x3c)
+/* General Purpose Output Control Register (0~17) */
+#define GPOCTLR				(MCUCTL+0x40)
+#define GPOCTLR_GPOG17(x)		((x) << 17)
+#define GPOCTLR_GPOG16(x)		((x) << 16)
+#define GPOCTLR_GPOG15(x)		((x) << 15)
+#define GPOCTLR_GPOG14(x)		((x) << 14)
+#define GPOCTLR_GPOG13(x)		((x) << 13)
+#define GPOCTLR_GPOG12(x)		((x) << 12)
+#define GPOCTLR_GPOG11(x)		((x) << 11)
+#define GPOCTLR_GPOG10(x)		((x) << 10)
+#define GPOCTLR_GPOG9(x)		((x) << 9)
+#define GPOCTLR_GPOG8(x)		((x) << 8)
+#define GPOCTLR_GPOG7(x)		((x) << 7)
+#define GPOCTLR_GPOG6(x)		((x) << 6)
+#define GPOCTLR_GPOG5(x)		((x) << 5)
+#define GPOCTLR_GPOG4(x)		((x) << 4)
+#define GPOCTLR_GPOG3(x)		((x) << 3)
+#define GPOCTLR_GPOG2(x)		((x) << 2)
+#define GPOCTLR_GPOG1(x)		((x) << 1)
+#define GPOCTLR_GPOG0(x)		((x) << 0)
+/* General Purpose Pad Output Enable Register (0~17) */
+#define GPOENCTLR			(MCUCTL+0x44)
+#define GPOENCTLR_GPOEN17(x)		((x) << 17)
+#define GPOENCTLR_GPOEN16(x)		((x) << 16)
+#define GPOENCTLR_GPOEN15(x)		((x) << 15)
+#define GPOENCTLR_GPOEN14(x)		((x) << 14)
+#define GPOENCTLR_GPOEN13(x)		((x) << 13)
+#define GPOENCTLR_GPOEN12(x)		((x) << 12)
+#define GPOENCTLR_GPOEN11(x)		((x) << 11)
+#define GPOENCTLR_GPOEN10(x)		((x) << 10)
+#define GPOENCTLR_GPOEN9(x)		((x) << 9)
+#define GPOENCTLR_GPOEN8(x)		((x) << 8)
+#define GPOENCTLR_GPOEN7(x)		((x) << 7)
+#define GPOENCTLR_GPOEN6(x)		((x) << 6)
+#define GPOENCTLR_GPOEN5(x)		((x) << 5)
+#define GPOENCTLR_GPOEN4(x)		((x) << 4)
+#define GPOENCTLR_GPOEN3(x)		((x) << 3)
+#define GPOENCTLR_GPOEN2(x)		((x) << 2)
+#define GPOENCTLR_GPOEN1(x)		((x) << 1)
+#define GPOENCTLR_GPOEN0(x)		((x) << 0)
+/* General Purpose Input Control Register (0~17) */
+#define GPICTLR				(MCUCTL+0x48)
+/* IS Shared Register 0 between ISP CPU and HOST CPU */
+#define ISSR0			(MCUCTL+0x80)
+/* Command Host -> IS */
+/* IS Shared Register 1 between ISP CPU and HOST CPU */
+/* Sensor ID for Command */
+#define ISSR1			(MCUCTL+0x84)
+/* IS Shared Register 2 between ISP CPU and HOST CPU */
+/* Parameter 1 */
+#define ISSR2			(MCUCTL+0x88)
+/* IS Shared Register 3 between ISP CPU and HOST CPU */
+/* Parameter 2 */
+#define ISSR3			(MCUCTL+0x8c)
+/* IS Shared Register 4 between ISP CPU and HOST CPU */
+/* Parameter 3 */
+#define ISSR4			(MCUCTL+0x90)
+/* IS Shared Register 5 between ISP CPU and HOST CPU */
+/* Parameter 4 */
+#define ISSR5			(MCUCTL+0x94)
+#define ISSR6			(MCUCTL+0x98)
+#define ISSR7			(MCUCTL+0x9c)
+#define ISSR8			(MCUCTL+0xa0)
+#define ISSR9			(MCUCTL+0xa4)
+/* IS Shared Register 10 between ISP CPU and HOST CPU */
+/* Command IS -> Host */
+#define ISSR10			(MCUCTL+0xa8)
+/* IS Shared Register 11 between ISP CPU and HOST CPU */
+/* Sensor ID for Command */
+#define ISSR11			(MCUCTL+0xac)
+/* IS Shared Register 12 between ISP CPU and HOST CPU */
+/* Parameter 1 */
+#define ISSR12			(MCUCTL+0xb0)
+/* IS Shared Register 13 between ISP CPU and HOST CPU */
+/* Parameter 2 */
+#define ISSR13			(MCUCTL+0xb4)
+/* IS Shared Register 14 between ISP CPU and HOST CPU */
+/* Parameter 3 */
+#define ISSR14			(MCUCTL+0xb8)
+/* IS Shared Register 15 between ISP CPU and HOST CPU */
+/* Parameter 4 */
+#define ISSR15			(MCUCTL+0xbc)
+#define ISSR16			(MCUCTL+0xc0)
+#define ISSR17			(MCUCTL+0xc4)
+#define ISSR18			(MCUCTL+0xc8)
+#define ISSR19			(MCUCTL+0xcc)
+/* IS Shared Register 20 between ISP CPU and HOST CPU */
+/* ISP_FRAME_DONE : SENSOR ID */
+#define ISSR20			(MCUCTL+0xd0)
+/* IS Shared Register 21 between ISP CPU and HOST CPU */
+/* ISP_FRAME_DONE : PARAMETER 1 */
+#define ISSR21			(MCUCTL+0xd4)
+#define ISSR22			(MCUCTL+0xd8)
+#define ISSR23			(MCUCTL+0xdc)
+/* IS Shared Register 24 between ISP CPU and HOST CPU */
+/* SCALERC_FRAME_DONE : SENSOR ID */
+#define ISSR24			(MCUCTL+0xe0)
+/* IS Shared Register 25 between ISP CPU and HOST CPU */
+/* SCALERC_FRAME_DONE : PARAMETER 1 */
+#define ISSR25			(MCUCTL+0xe4)
+#define ISSR26			(MCUCTL+0xe8)
+#define ISSR27			(MCUCTL+0xec)
+/* IS Shared Register 28 between ISP CPU and HOST CPU */
+/* 3DNR_FRAME_DONE : SENSOR ID */
+#define ISSR28			(MCUCTL+0xf0)
+/* IS Shared Register 29 between ISP CPU and HOST CPU */
+/* 3DNR_FRAME_DONE : PARAMETER 1 */
+#define ISSR29			(MCUCTL+0xf4)
+#define ISSR30			(MCUCTL+0xf8)
+#define ISSR31			(MCUCTL+0xfc)
+/* IS Shared Register 32 between ISP CPU and HOST CPU */
+/* SCALERP_FRAME_DONE : SENSOR ID */
+#define ISSR32			(MCUCTL+0x100)
+/* IS Shared Register 33 between ISP CPU and HOST CPU */
+/* SCALERP_FRAME_DONE : PARAMETER 1 */
+#define ISSR33			(MCUCTL+0x104)
+#define ISSR34			(MCUCTL+0x108)
+#define ISSR35			(MCUCTL+0x10c)
+#define ISSR36			(MCUCTL+0x110)
+#define ISSR37			(MCUCTL+0x114)
+#define ISSR38			(MCUCTL+0x118)
+#define ISSR39			(MCUCTL+0x11c)
+#define ISSR40			(MCUCTL+0x120)
+#define ISSR41			(MCUCTL+0x124)
+#define ISSR42			(MCUCTL+0x128)
+#define ISSR43			(MCUCTL+0x12c)
+#define ISSR44			(MCUCTL+0x130)
+#define ISSR45			(MCUCTL+0x134)
+#define ISSR46			(MCUCTL+0x138)
+#define ISSR47			(MCUCTL+0x13c)
+#define ISSR48			(MCUCTL+0x140)
+#define ISSR49			(MCUCTL+0x144)
+#define ISSR50			(MCUCTL+0x148)
+#define ISSR51			(MCUCTL+0x14c)
+#define ISSR52			(MCUCTL+0x150)
+#define ISSR53			(MCUCTL+0x154)
+#define ISSR54			(MCUCTL+0x158)
+#define ISSR55			(MCUCTL+0x15c)
+#define ISSR56			(MCUCTL+0x160)
+#define ISSR57			(MCUCTL+0x164)
+#define ISSR58			(MCUCTL+0x168)
+#define ISSR59			(MCUCTL+0x16c)
+#define ISSR60			(MCUCTL+0x170)
+#define ISSR61			(MCUCTL+0x174)
+#define ISSR62			(MCUCTL+0x178)
+#define ISSR63			(MCUCTL+0x17c)
+
+/* PMU for FIMC-IS*/
+#define PMUREG_CMU_RESET_ISP_SYS_PWR_REG	(S5P_VA_PMU  + 0x1584)
+#define PMUREG_ISP_ARM_CONFIGURATION		(S5P_VA_PMU  + 0x2280)
+#define PMUREG_ISP_ARM_STATUS			(S5P_VA_PMU  + 0x2284)
+#define PMUREG_ISP_ARM_OPTION			(S5P_VA_PMU  + 0x2288)
+#define PMUREG_ISP_LOW_POWER_OFF		(S5P_VA_PMU  + 0x0004)
+#define PMUREG_ISP_CONFIGURATION		(S5P_VA_PMU  + 0x4020)
+#define PMUREG_ISP_STATUS				(S5P_VA_PMU  + 0x4024)
+
+#endif
diff --git a/drivers/media/platform/exynos5-is/fimc-is.h b/drivers/media/platform/exynos5-is/fimc-is.h
new file mode 100644
index 0000000..3558d19
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is.h
@@ -0,0 +1,151 @@
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
+extern int fimc_is_debug;
+
+#define is_dbg(level, fmt, args...)					\
+	do {								\
+		if (fimc_is_debug >= level)				\
+			pr_debug("%s:%d: " fmt,				\
+				__func__, __LINE__, ##args);		\
+	} while (0)
+#define is_err(fmt, args...)						\
+		pr_err("%s:%d: " fmt, __func__, __LINE__, ##args);	\
+
+#define fimc_pipeline_to_is(p) container_of(p, struct fimc_is, pipeline)
+#define fimc_interface_to_is(p) container_of(p, struct fimc_is, interface)
+#define fimc_sensor_to_is(p) container_of(p, struct fimc_is, sensor)
+#define fimc_isp_to_is(p) container_of(p, struct fimc_is, isp)
+#define fimc_scp_to_is(p) container_of(p, struct fimc_is, scp)
+
+/* Macros used by media dev to get the subdev and vfd */
+/* is --> driver data from pdev
+ * pid --> pipeline index */
+#define fimc_is_isp_get_sd(is, pid) (&is->pipeline.isp.subdev)
+#define fimc_is_isp_get_vfd(is, pid) (&is->pipeline.isp.vfd)
+#define fimc_is_scc_get_sd(is, pid) (&is->pipeline.scaler[SCALER_SCC].subdev)
+#define fimc_is_scc_get_vfd(is, pid) (&is->pipeline.scaler[SCALER_SCC].vfd)
+#define fimc_is_scp_get_sd(is, pid) (&is->pipeline.scaler[SCALER_SCP].subdev)
+#define fimc_is_scp_get_vfd(is, pid) (&is->pipeline.scaler[SCALER_SCP].vfd)
+/* is --> driver data from pdev
+ * sid --> sensor index */
+#define fimc_is_sensor_get_sd(is, sid) (&is->sensor[sid].subdev)
+
+
+/**
+ * struct fimc_is - fimc lite structure
+ * @pdev: pointer to FIMC-IS platform device
+ * @pdata: platform data for FIMC-IS
+ * @alloc_ctx: videobuf2 memory allocator context
+ * @clk: FIMC-IS clocks
+ * @minfo: internal memory organization info
+ * @sensor: FIMC-IS sensor context
+ * @pipeline: hardware pipeline context
+ * @interface: hardware interface context
+ */
+struct fimc_is {
+	struct platform_device		*pdev;
+
+	struct fimc_is_platdata		*pdata;
+	struct vb2_alloc_ctx		*alloc_ctx;
+	struct clk			*clock[IS_CLK_MAX_NUM];
+
+	struct fimc_is_meminfo		minfo;
+
+	struct fimc_is_sensor		sensor[FIMC_IS_NUM_SENSORS];
+	struct fimc_is_pipeline		pipeline;
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
+#endif
-- 
1.7.9.5

