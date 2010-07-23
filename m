Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31055 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757554Ab0GWQVt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jul 2010 12:21:49 -0400
Date: Fri, 23 Jul 2010 18:21:16 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 1/8] ARM: Samsung: Add register definitions for Samsung S5P
 SoC camera interface
In-reply-to: <1279902083-21250-1-git-send-email-s.nawrocki@samsung.com>
To: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, kgene.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org
Message-id: <1279902083-21250-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1279902083-21250-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add register definitions for the camera interface/video postprocessor
contained in Samsung's S5P SoC series.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Pawel Osciak <p.osciak@samsung.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/plat-samsung/include/plat/regs-fimc.h |  294 ++++++++++++++++++++++++
 1 files changed, 294 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-samsung/include/plat/regs-fimc.h

diff --git a/arch/arm/plat-samsung/include/plat/regs-fimc.h b/arch/arm/plat-samsung/include/plat/regs-fimc.h
new file mode 100644
index 0000000..7f3141c
--- /dev/null
+++ b/arch/arm/plat-samsung/include/plat/regs-fimc.h
@@ -0,0 +1,294 @@
+/* arch/arm/plat-s5p/include/plat/regs-fimc.h
+ *
+ * Register definition file for Samsung Camera Interface (FIMC) driver
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef REGS_FIMC_H_
+#define REGS_FIMC_H_
+
+#define S5P_CIOYSA(__x)			(0x18 + (__x) * 4)
+#define S5P_CIOCBSA(__x)		(0x28 + (__x) * 4)
+#define S5P_CIOCRSA(__x)		(0x38 + (__x) * 4)
+
+/* Input source format */
+#define S5P_CISRCFMT			0x00
+#define S5P_CISRCFMT_ITU601_8BIT	(1 << 31)
+#define S5P_CISRCFMT_ITU601_16BIT	(1 << 29)
+#define S5P_CISRCFMT_ORDER422_YCBYCR	(0 << 14)
+#define S5P_CISRCFMT_ORDER422_YCRYCB	(1 << 14)
+#define S5P_CISRCFMT_ORDER422_CBYCRY	(2 << 14)
+#define S5P_CISRCFMT_ORDER422_CRYCBY	(3 << 14)
+#define S5P_CISRCFMT_HSIZE(x)		((x) << 16)
+#define S5P_CISRCFMT_VSIZE(x)		((x) << 0)
+
+/* Window offset */
+#define S5P_CIWDOFST			0x04
+#define S5P_CIWDOFST_WINOFSEN		(1 << 31)
+#define S5P_CIWDOFST_CLROVFIY		(1 << 30)
+#define S5P_CIWDOFST_CLROVRLB		(1 << 29)
+#define S5P_CIWDOFST_WINHOROFST_MASK	(0x7ff << 16)
+#define S5P_CIWDOFST_CLROVFICB		(1 << 15)
+#define S5P_CIWDOFST_CLROVFICR		(1 << 14)
+#define S5P_CIWDOFST_WINHOROFST(x)	((x) << 16)
+#define S5P_CIWDOFST_WINVEROFST(x)	((x) << 0)
+#define S5P_CIWDOFST_WINVEROFST_MASK	(0xfff << 0)
+
+/* Global control */
+#define S5P_CIGCTRL			0x08
+#define S5P_CIGCTRL_SWRST		(1 << 31)
+#define S5P_CIGCTRL_CAMRST_A		(1 << 30)
+#define S5P_CIGCTRL_SELCAM_ITU_A	(1 << 29)
+#define S5P_CIGCTRL_SELCAM_ITU_MASK	(1 << 29)
+#define S5P_CIGCTRL_TESTPAT_NORMAL	(0 << 27)
+#define S5P_CIGCTRL_TESTPAT_COLOR_BAR	(1 << 27)
+#define S5P_CIGCTRL_TESTPAT_HOR_INC	(2 << 27)
+#define S5P_CIGCTRL_TESTPAT_VER_INC	(3 << 27)
+#define S5P_CIGCTRL_TESTPAT_MASK	(3 << 27)
+#define S5P_CIGCTRL_TESTPAT_SHIFT	(27)
+#define S5P_CIGCTRL_INVPOLPCLK		(1 << 26)
+#define S5P_CIGCTRL_INVPOLVSYNC		(1 << 25)
+#define S5P_CIGCTRL_INVPOLHREF		(1 << 24)
+#define S5P_CIGCTRL_IRQ_OVFEN		(1 << 22)
+#define S5P_CIGCTRL_HREF_MASK		(1 << 21)
+#define S5P_CIGCTRL_IRQ_LEVEL		(1 << 20)
+#define S5P_CIGCTRL_IRQ_CLR		(1 << 19)
+#define S5P_CIGCTRL_IRQ_ENABLE		(1 << 16)
+#define S5P_CIGCTRL_SHDW_DISABLE	(1 << 12)
+#define S5P_CIGCTRL_SELCAM_MIPI_A	(1 << 7)
+#define S5P_CIGCTRL_CAMIF_SELWB		(1 << 6)
+#define S5P_CIGCTRL_INVPOLHSYNC		(1 << 4)
+#define S5P_CIGCTRL_SELCAM_MIPI		(1 << 3)
+#define S5P_CIGCTRL_INTERLACE		(1 << 0)
+
+/* Window offset 2 */
+#define S5P_CIWDOFST2			0x14
+#define S5P_CIWDOFST2_HOROFF_MASK	(0xfff << 16)
+#define S5P_CIWDOFST2_VEROFF_MASK	(0xfff << 0)
+#define S5P_CIWDOFST2_HOROFF(x)		((x) << 16)
+#define S5P_CIWDOFST2_VEROFF(x)		((x) << 0)
+
+/* Output DMA Y plane start address */
+#define S5P_CIOYSA1			0x18
+#define S5P_CIOYSA2			0x1c
+#define S5P_CIOYSA3			0x20
+#define S5P_CIOYSA4			0x24
+
+/* Output DMA Cb plane start address */
+#define S5P_CIOCBSA1			0x28
+#define S5P_CIOCBSA2			0x2c
+#define S5P_CIOCBSA3			0x30
+#define S5P_CIOCBSA4			0x34
+
+/* Output DMA Cr plane start address */
+#define S5P_CIOCRSA1			0x38
+#define S5P_CIOCRSA2			0x3c
+#define S5P_CIOCRSA3			0x40
+#define S5P_CIOCRSA4			0x44
+
+/* Target image format */
+#define S5P_CITRGFMT			0x48
+#define S5P_CITRGFMT_INROT90		(1 << 31)
+#define S5P_CITRGFMT_YCBCR420		(0 << 29)
+#define S5P_CITRGFMT_YCBCR422		(1 << 29)
+#define S5P_CITRGFMT_YCBCR422_1P	(2 << 29)
+#define S5P_CITRGFMT_RGB		(3 << 29)
+#define S5P_CITRGFMT_FMT_MASK		(3 << 29)
+#define S5P_CITRGFMT_HSIZE_MASK		(0xfff << 16)
+#define S5P_CITRGFMT_FLIP_SHIFT		(14)
+#define S5P_CITRGFMT_FLIP_NORMAL	(0 << 14)
+#define S5P_CITRGFMT_FLIP_X_MIRROR	(1 << 14)
+#define S5P_CITRGFMT_FLIP_Y_MIRROR	(2 << 14)
+#define S5P_CITRGFMT_FLIP_180		(3 << 14)
+#define S5P_CITRGFMT_FLIP_MASK		(3 << 14)
+#define S5P_CITRGFMT_OUTROT90		(1 << 13)
+#define S5P_CITRGFMT_VSIZE_MASK		(0xfff << 0)
+#define S5P_CITRGFMT_HSIZE(x)		((x) << 16)
+#define S5P_CITRGFMT_VSIZE(x)		((x) << 0)
+
+/* Output DMA control */
+#define S5P_CIOCTRL			0x4c
+#define S5P_CIOCTRL_ORDER422_MASK	(3 << 0)
+#define S5P_CIOCTRL_ORDER422_CRYCBY	(0 << 0)
+#define S5P_CIOCTRL_ORDER422_YCRYCB	(1 << 0)
+#define S5P_CIOCTRL_ORDER422_CBYCRY	(2 << 0)
+#define S5P_CIOCTRL_ORDER422_YCBYCR	(3 << 0)
+#define S5P_CIOCTRL_LASTIRQ_ENABLE	(1 << 2)
+#define S5P_CIOCTRL_YCBCR_3PLANE	(0 << 3)
+#define S5P_CIOCTRL_YCBCR_2PLANE	(1 << 3)
+#define S5P_CIOCTRL_YCBCR_PLANE_MASK	(1 << 3)
+#define S5P_CIOCTRL_ORDER2P_SHIFT	(24)
+#define S5P_CIOCTRL_ORDER2P_MASK	(3 << 24)
+#define S5P_CIOCTRL_ORDER422_2P_LSB_CRCB (0 << 24)
+
+/* Pre-scaler control 1 */
+#define S5P_CISCPRERATIO		0x50
+#define S5P_CISCPRERATIO_SHFACTOR(x)	((x) << 28)
+#define S5P_CISCPRERATIO_HOR(x)		((x) << 16)
+#define S5P_CISCPRERATIO_VER(x)		((x) << 0)
+
+#define S5P_CISCPREDST			0x54
+#define S5P_CISCPREDST_WIDTH(x)		((x) << 16)
+#define S5P_CISCPREDST_HEIGHT(x)	((x) << 0)
+
+/* Main scaler control */
+#define S5P_CISCCTRL			0x58
+#define S5P_CISCCTRL_SCALERBYPASS	(1 << 31)
+#define S5P_CISCCTRL_SCALEUP_H		(1 << 30)
+#define S5P_CISCCTRL_SCALEUP_V		(1 << 29)
+#define S5P_CISCCTRL_CSCR2Y_WIDE	(1 << 28)
+#define S5P_CISCCTRL_CSCY2R_WIDE	(1 << 27)
+#define S5P_CISCCTRL_LCDPATHEN_FIFO	(1 << 26)
+#define S5P_CISCCTRL_INTERLACE		(1 << 25)
+#define S5P_CISCCTRL_SCALERSTART	(1 << 15)
+#define S5P_CISCCTRL_INRGB_FMT_RGB565	(0 << 13)
+#define S5P_CISCCTRL_INRGB_FMT_RGB666	(1 << 13)
+#define S5P_CISCCTRL_INRGB_FMT_RGB888	(2 << 13)
+#define S5P_CISCCTRL_INRGB_FMT_MASK	(3 << 13)
+#define S5P_CISCCTRL_OUTRGB_FMT_RGB565	(0 << 11)
+#define S5P_CISCCTRL_OUTRGB_FMT_RGB666	(1 << 11)
+#define S5P_CISCCTRL_OUTRGB_FMT_RGB888	(2 << 11)
+#define S5P_CISCCTRL_OUTRGB_FMT_MASK	(3 << 11)
+#define S5P_CISCCTRL_RGB_EXT		(1 << 10)
+#define S5P_CISCCTRL_ONE2ONE		(1 << 9)
+#define S5P_CISCCTRL_SC_HORRATIO(x)	((x) << 16)
+#define S5P_CISCCTRL_SC_VERRATIO(x)	((x) << 0)
+
+/* Target area */
+#define S5P_CITAREA			0x5c
+#define S5P_CITAREA_MASK		0x0fffffff
+
+/* General status */
+#define S5P_CISTATUS			0x64
+#define S5P_CISTATUS_OVFIY		(1 << 31)
+#define S5P_CISTATUS_OVFICB		(1 << 30)
+#define S5P_CISTATUS_OVFICR		(1 << 29)
+#define S5P_CISTATUS_VSYNC		(1 << 28)
+#define S5P_CISTATUS_WINOFF_EN		(1 << 25)
+#define S5P_CISTATUS_IMGCPT_EN		(1 << 22)
+#define S5P_CISTATUS_IMGCPT_SCEN	(1 << 21)
+#define S5P_CISTATUS_VSYNC_A		(1 << 20)
+#define S5P_CISTATUS_VSYNC_B		(1 << 19)
+#define S5P_CISTATUS_OVRLB		(1 << 18)
+#define S5P_CISTATUS_FRAME_END		(1 << 17)
+#define S5P_CISTATUS_LASTCAPT_END	(1 << 16)
+#define S5P_CISTATUS_VVALID_A		(1 << 15)
+#define S5P_CISTATUS_VVALID_B		(1 << 14)
+
+/* Image capture control */
+#define S5P_CIIMGCPT			0xc0
+#define S5P_CIIMGCPT_IMGCPTEN		(1 << 31)
+#define S5P_CIIMGCPT_IMGCPTEN_SC	(1 << 30)
+#define S5P_CIIMGCPT_CPT_FREN_ENABLE	(1 << 25)
+#define S5P_CIIMGCPT_CPT_FRMOD_CNT	(1 << 18)
+
+/* Frame capture sequence */
+#define S5P_CICPTSEQ			0xc4
+
+/* Image effect */
+#define S5P_CIIMGEFF			0xd0
+#define S5P_CIIMGEFF_IE_DISABLE		(0 << 30)
+#define S5P_CIIMGEFF_IE_ENABLE		(1 << 30)
+#define S5P_CIIMGEFF_IE_SC_BEFORE	(0 << 29)
+#define S5P_CIIMGEFF_IE_SC_AFTER	(1 << 29)
+#define S5P_CIIMGEFF_FIN_BYPASS		(0 << 26)
+#define S5P_CIIMGEFF_FIN_ARBITRARY	(1 << 26)
+#define S5P_CIIMGEFF_FIN_NEGATIVE	(2 << 26)
+#define S5P_CIIMGEFF_FIN_ARTFREEZE	(3 << 26)
+#define S5P_CIIMGEFF_FIN_EMBOSSING	(4 << 26)
+#define S5P_CIIMGEFF_FIN_SILHOUETTE	(5 << 26)
+#define S5P_CIIMGEFF_FIN_MASK		(7 << 26)
+#define S5P_CIIMGEFF_PAT_CBCR_MASK	((0xff < 13) | (0xff < 0))
+#define S5P_CIIMGEFF_PAT_CB(x)		((x) << 13)
+#define S5P_CIIMGEFF_PAT_CR(x)		((x) << 0)
+
+/* Input DMA Y/Cb/Cr plane start address 0 */
+#define S5P_CIIYSA0			0xd4
+#define S5P_CIICBSA0			0xd8
+#define S5P_CIICRSA0			0xdc
+
+/* Real input DMA image size */
+#define S5P_CIREAL_ISIZE		0xf8
+#define S5P_CIREAL_ISIZE_AUTOLOAD_EN	(1 << 31)
+#define S5P_CIREAL_ISIZE_ADDR_CH_DIS	(1 << 30)
+#define S5P_CIREAL_ISIZE_HEIGHT(x)	((x) << 16)
+#define S5P_CIREAL_ISIZE_WIDTH(x)	((x) << 0)
+
+
+/* Input DMA control */
+#define S5P_MSCTRL			0xfc
+#define S5P_MSCTRL_IN_BURST_COUNT_MASK	(3 << 24)
+#define S5P_MSCTRL_2P_IN_ORDER_MASK	(3 << 16)
+#define S5P_MSCTRL_2P_IN_ORDER_SHIFT	16
+#define S5P_MSCTRL_C_INT_IN_3PLANE	(0 << 15)
+#define S5P_MSCTRL_C_INT_IN_2PLANE	(1 << 15)
+#define S5P_MSCTRL_C_INT_IN_MASK	(1 << 15)
+#define S5P_MSCTRL_FLIP_SHIFT		13
+#define S5P_MSCTRL_FLIP_MASK		(3 << 13)
+#define S5P_MSCTRL_FLIP_NORMAL		(0 << 13)
+#define S5P_MSCTRL_FLIP_X_MIRROR	(1 << 13)
+#define S5P_MSCTRL_FLIP_Y_MIRROR	(2 << 13)
+#define S5P_MSCTRL_FLIP_180		(3 << 13)
+#define S5P_MSCTRL_ORDER422_SHIFT	4
+#define S5P_MSCTRL_ORDER422_CRYCBY	(0 << 4)
+#define S5P_MSCTRL_ORDER422_YCRYCB	(1 << 4)
+#define S5P_MSCTRL_ORDER422_CBYCRY	(2 << 4)
+#define S5P_MSCTRL_ORDER422_YCBYCR	(3 << 4)
+#define S5P_MSCTRL_ORDER422_MASK	(3 << 4)
+#define S5P_MSCTRL_INPUT_EXTCAM		(0 << 3)
+#define S5P_MSCTRL_INPUT_MEMORY		(1 << 3)
+#define S5P_MSCTRL_INPUT_MASK		(1 << 3)
+#define S5P_MSCTRL_INFORMAT_YCBCR420	(0 << 1)
+#define S5P_MSCTRL_INFORMAT_YCBCR422	(1 << 1)
+#define S5P_MSCTRL_INFORMAT_YCBCR422_1P	(2 << 1)
+#define S5P_MSCTRL_INFORMAT_RGB		(3 << 1)
+#define S5P_MSCTRL_INFORMAT_MASK	(3 << 1)
+#define S5P_MSCTRL_ENVID		(1 << 0)
+#define S5P_MSCTRL_FRAME_COUNT(x)	((x) << 24)
+
+/* Input DMA Y/Cb/Cr plane start address 1 */
+#define S5P_CIIYSA1			0x144
+#define S5P_CIICBSA1			0x148
+#define S5P_CIICRSA1			0x14c
+
+/* Output DMA Y/Cb/Cr offset */
+#define S5P_CIOYOFF			0x168
+#define S5P_CIOCBOFF			0x16c
+#define S5P_CIOCROFF			0x170
+
+/* Input DMA Y/Cb/Cr offset */
+#define S5P_CIIYOFF			0x174
+#define S5P_CIICBOFF			0x178
+#define S5P_CIICROFF			0x17c
+
+#define S5P_CIO_OFFS_VER(x)		((x) << 16)
+#define S5P_CIO_OFFS_HOR(x)		((x) << 0)
+
+/* Input DMA original image size */
+#define S5P_ORGISIZE			0x180
+
+/* Output DMA original image size */
+#define S5P_ORGOSIZE			0x184
+
+#define S5P_ORIG_SIZE_VER(x)		((x) << 16)
+#define S5P_ORIG_SIZE_HOR(x)		((x) << 0)
+
+/* Real output DMA image size (extension register) */
+#define S5P_CIEXTEN			0x188
+
+#define S5P_CIDMAPARAM			0x18c
+#define S5P_CIDMAPARAM_R_LINEAR		(0 << 29)
+#define S5P_CIDMAPARAM_R_64X32		(3 << 29)
+#define S5P_CIDMAPARAM_W_LINEAR		(0 << 13)
+#define S5P_CIDMAPARAM_W_64X32		(3 << 13)
+#define S5P_CIDMAPARAM_TILE_MASK	((3 << 29) | (3 << 13))
+
+/* MIPI CSI image format */
+#define S5P_CSIIMGFMT			0x194
+
+#endif /* REGS_FIMC_H_ */
-- 
1.7.2

