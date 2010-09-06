Return-path: <mchehab@gaivota>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26102 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab0IFGx4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Sep 2010 02:53:56 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L8B0072HCHTIF20@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Sep 2010 07:53:53 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L8B00L4OCHSQN@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Sep 2010 07:53:52 +0100 (BST)
Date: Mon, 06 Sep 2010 08:53:45 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 3/8] v4l: s5p-fimc: Register definition cleanup
In-reply-to: <1283756030-28634-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	p.osciak@samsung.com, s.nawrocki@samsung.com
Message-id: <1283756030-28634-4-git-send-email-m.szyprowski@samsung.com>
References: <1283756030-28634-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

Prepare DMA address definitions for interlaced input frame mode.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-reg.c  |    6 ++--
 drivers/media/video/s5p-fimc/regs-fimc.h |   38 ++++++-----------------------
 2 files changed, 11 insertions(+), 33 deletions(-)

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
index a3cfe82..df8cdfb 100644
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
@@ -72,23 +68,10 @@
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
@@ -206,10 +189,10 @@
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
@@ -250,11 +233,6 @@
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
-- 
1.7.2.2

