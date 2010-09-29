Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52337 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab0I2KYH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Sep 2010 06:24:07 -0400
Date: Wed, 29 Sep 2010 12:23:45 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 1/4] V4L/DVB: s5p-fimc: Register definition cleanup
In-reply-to: <1285755828-7815-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-arm-kernel@lists.infraded.org,
	linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1285755828-7815-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1285755828-7815-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add MIPI CSI format definitions, prepare DMA address
definitions for interlaced input frame mode.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-reg.c  |    6 +-
 drivers/media/video/s5p-fimc/regs-fimc.h |   61 ++++++++++++-----------------
 2 files changed, 28 insertions(+), 39 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 5570f1c..70f29c5 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -507,9 +507,9 @@ void fimc_hw_set_input_addr(struct fimc_dev *dev, struct fimc_addr *paddr)
 	cfg |= S5P_CIREAL_ISIZE_ADDR_CH_DIS;
 	writel(cfg, dev->regs + S5P_CIREAL_ISIZE);
 
-	writel(paddr->y, dev->regs + S5P_CIIYSA0);
-	writel(paddr->cb, dev->regs + S5P_CIICBSA0);
-	writel(paddr->cr, dev->regs + S5P_CIICRSA0);
+	writel(paddr->y, dev->regs + S5P_CIIYSA(0));
+	writel(paddr->cb, dev->regs + S5P_CIICBSA(0));
+	writel(paddr->cr, dev->regs + S5P_CIICRSA(0));
 
 	cfg &= ~S5P_CIREAL_ISIZE_ADDR_CH_DIS;
 	writel(cfg, dev->regs + S5P_CIREAL_ISIZE);
diff --git a/drivers/media/video/s5p-fimc/regs-fimc.h b/drivers/media/video/s5p-fimc/regs-fimc.h
index a3cfe82..9e83315 100644
--- a/drivers/media/video/s5p-fimc/regs-fimc.h
+++ b/drivers/media/video/s5p-fimc/regs-fimc.h
@@ -11,10 +11,6 @@
 #ifndef REGS_FIMC_H_
 #define REGS_FIMC_H_
 
-#define S5P_CIOYSA(__x)			(0x18 + (__x) * 4)
-#define S5P_CIOCBSA(__x)		(0x28 + (__x) * 4)
-#define S5P_CIOCRSA(__x)		(0x38 + (__x) * 4)
-
 /* Input source format */
 #define S5P_CISRCFMT			0x00
 #define S5P_CISRCFMT_ITU601_8BIT	(1 << 31)
@@ -28,22 +24,21 @@
 
 /* Window offset */
 #define S5P_CIWDOFST			0x04
-#define S5P_CIWDOFST_WINOFSEN		(1 << 31)
+#define S5P_CIWDOFST_OFF_EN		(1 << 31)
 #define S5P_CIWDOFST_CLROVFIY		(1 << 30)
 #define S5P_CIWDOFST_CLROVRLB		(1 << 29)
-#define S5P_CIWDOFST_WINHOROFST_MASK	(0x7ff << 16)
+#define S5P_CIWDOFST_HOROFF_MASK	(0x7ff << 16)
 #define S5P_CIWDOFST_CLROVFICB		(1 << 15)
 #define S5P_CIWDOFST_CLROVFICR		(1 << 14)
-#define S5P_CIWDOFST_WINHOROFST(x)	((x) << 16)
-#define S5P_CIWDOFST_WINVEROFST(x)	((x) << 0)
-#define S5P_CIWDOFST_WINVEROFST_MASK	(0xfff << 0)
+#define S5P_CIWDOFST_HOROFF(x)		((x) << 16)
+#define S5P_CIWDOFST_VEROFF(x)		((x) << 0)
+#define S5P_CIWDOFST_VEROFF_MASK	(0xfff << 0)
 
 /* Global control */
 #define S5P_CIGCTRL			0x08
 #define S5P_CIGCTRL_SWRST		(1 << 31)
 #define S5P_CIGCTRL_CAMRST_A		(1 << 30)
 #define S5P_CIGCTRL_SELCAM_ITU_A	(1 << 29)
-#define S5P_CIGCTRL_SELCAM_ITU_MASK	(1 << 29)
 #define S5P_CIGCTRL_TESTPAT_NORMAL	(0 << 27)
 #define S5P_CIGCTRL_TESTPAT_COLOR_BAR	(1 << 27)
 #define S5P_CIGCTRL_TESTPAT_HOR_INC	(2 << 27)
@@ -61,6 +56,8 @@
 #define S5P_CIGCTRL_SHDW_DISABLE	(1 << 12)
 #define S5P_CIGCTRL_SELCAM_MIPI_A	(1 << 7)
 #define S5P_CIGCTRL_CAMIF_SELWB		(1 << 6)
+/* 0 - ITU601; 1 - ITU709 */
+#define S5P_CIGCTRL_CSC_ITU601_709	(1 << 5)
 #define S5P_CIGCTRL_INVPOLHSYNC		(1 << 4)
 #define S5P_CIGCTRL_SELCAM_MIPI		(1 << 3)
 #define S5P_CIGCTRL_INTERLACE		(1 << 0)
@@ -72,23 +69,10 @@
 #define S5P_CIWDOFST2_HOROFF(x)		((x) << 16)
 #define S5P_CIWDOFST2_VEROFF(x)		((x) << 0)
 
-/* Output DMA Y plane start address */
-#define S5P_CIOYSA1			0x18
-#define S5P_CIOYSA2			0x1c
-#define S5P_CIOYSA3			0x20
-#define S5P_CIOYSA4			0x24
-
-/* Output DMA Cb plane start address */
-#define S5P_CIOCBSA1			0x28
-#define S5P_CIOCBSA2			0x2c
-#define S5P_CIOCBSA3			0x30
-#define S5P_CIOCBSA4			0x34
-
-/* Output DMA Cr plane start address */
-#define S5P_CIOCRSA1			0x38
-#define S5P_CIOCRSA2			0x3c
-#define S5P_CIOCRSA3			0x40
-#define S5P_CIOCRSA4			0x44
+/* Output DMA Y/Cb/Cr plane start addresses */
+#define S5P_CIOYSA(n)			(0x18 + (n) * 4)
+#define S5P_CIOCBSA(n)			(0x28 + (n) * 4)
+#define S5P_CIOCRSA(n)			(0x38 + (n) * 4)
 
 /* Target image format */
 #define S5P_CITRGFMT			0x48
@@ -168,6 +152,8 @@
 #define S5P_CISTATUS_OVFICB		(1 << 30)
 #define S5P_CISTATUS_OVFICR		(1 << 29)
 #define S5P_CISTATUS_VSYNC		(1 << 28)
+#define S5P_CISTATUS_FRAMECNT_MASK	(3 << 26)
+#define S5P_CISTATUS_FRAMECNT_SHIFT	26
 #define S5P_CISTATUS_WINOFF_EN		(1 << 25)
 #define S5P_CISTATUS_IMGCPT_EN		(1 << 22)
 #define S5P_CISTATUS_IMGCPT_SCEN	(1 << 21)
@@ -206,10 +192,10 @@
 #define S5P_CIIMGEFF_PAT_CB(x)		((x) << 13)
 #define S5P_CIIMGEFF_PAT_CR(x)		((x) << 0)
 
-/* Input DMA Y/Cb/Cr plane start address 0 */
-#define S5P_CIIYSA0			0xd4
-#define S5P_CIICBSA0			0xd8
-#define S5P_CIICRSA0			0xdc
+/* Input DMA Y/Cb/Cr plane start address 0/1 */
+#define S5P_CIIYSA(n)			(0xd4 + (n) * 0x70)
+#define S5P_CIICBSA(n)			(0xd8 + (n) * 0x70)
+#define S5P_CIICRSA(n)			(0xdc + (n) * 0x70)
 
 /* Real input DMA image size */
 #define S5P_CIREAL_ISIZE		0xf8
@@ -250,11 +236,6 @@
 #define S5P_MSCTRL_ENVID		(1 << 0)
 #define S5P_MSCTRL_FRAME_COUNT(x)	((x) << 24)
 
-/* Input DMA Y/Cb/Cr plane start address 1 */
-#define S5P_CIIYSA1			0x144
-#define S5P_CIICBSA1			0x148
-#define S5P_CIICRSA1			0x14c
-
 /* Output DMA Y/Cb/Cr offset */
 #define S5P_CIOYOFF			0x168
 #define S5P_CIOCBOFF			0x16c
@@ -289,5 +270,13 @@
 
 /* MIPI CSI image format */
 #define S5P_CSIIMGFMT			0x194
+#define S5P_CSIIMGFMT_YCBCR422_8BIT	0x1e
+#define S5P_CSIIMGFMT_RAW8		0x2a
+#define S5P_CSIIMGFMT_RAW10		0x2b
+#define S5P_CSIIMGFMT_RAW12		0x2c
+#define S5P_CSIIMGFMT_USER1		0x30
+#define S5P_CSIIMGFMT_USER2		0x31
+#define S5P_CSIIMGFMT_USER3		0x32
+#define S5P_CSIIMGFMT_USER4		0x33
 
 #endif /* REGS_FIMC_H_ */
-- 
1.7.3

