Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44099 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab3LDA42 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:28 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id B3992363D3
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:38 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 05/25] v4l: omap4iss: Define more ISS and ISP IRQ register bits
Date: Wed,  4 Dec 2013 01:56:05 +0100
Message-Id: <1386118585-12449-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c         | 26 ++++++++++----------
 drivers/staging/media/omap4iss/iss_ipipeif.c |  2 +-
 drivers/staging/media/omap4iss/iss_regs.h    | 36 +++++++++++++++++++++-------
 drivers/staging/media/omap4iss/iss_resizer.c |  4 ++--
 4 files changed, 43 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 53dcb54..815b09b 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -40,9 +40,9 @@ static void iss_print_status(struct iss_device *iss)
 
 	ISS_PRINT_REGISTER(iss, HL_REVISION);
 	ISS_PRINT_REGISTER(iss, HL_SYSCONFIG);
-	ISS_PRINT_REGISTER(iss, HL_IRQSTATUS_5);
-	ISS_PRINT_REGISTER(iss, HL_IRQENABLE_5_SET);
-	ISS_PRINT_REGISTER(iss, HL_IRQENABLE_5_CLR);
+	ISS_PRINT_REGISTER(iss, HL_IRQSTATUS(5));
+	ISS_PRINT_REGISTER(iss, HL_IRQENABLE_SET(5));
+	ISS_PRINT_REGISTER(iss, HL_IRQENABLE_CLR(5));
 	ISS_PRINT_REGISTER(iss, CTRL);
 	ISS_PRINT_REGISTER(iss, CLKCTRL);
 	ISS_PRINT_REGISTER(iss, CLKSTAT);
@@ -75,8 +75,8 @@ static void iss_enable_interrupts(struct iss_device *iss)
 	static const u32 hl_irq = ISS_HL_IRQ_CSIA | ISS_HL_IRQ_CSIB | ISS_HL_IRQ_ISP(0);
 
 	/* Enable HL interrupts */
-	writel(hl_irq, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQSTATUS_5);
-	writel(hl_irq, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQENABLE_5_SET);
+	writel(hl_irq, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQSTATUS(5));
+	writel(hl_irq, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQENABLE_SET(5));
 
 }
 
@@ -86,7 +86,7 @@ static void iss_enable_interrupts(struct iss_device *iss)
  */
 static void iss_disable_interrupts(struct iss_device *iss)
 {
-	writel(-1, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQENABLE_5_CLR);
+	writel(-1, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQENABLE_CLR(5));
 }
 
 /*
@@ -96,10 +96,10 @@ static void iss_disable_interrupts(struct iss_device *iss)
 void omap4iss_isp_enable_interrupts(struct iss_device *iss)
 {
 	static const u32 isp_irq = ISP5_IRQ_OCP_ERR |
-				   ISP5_IRQ_RSZ_FIFO_IN_BLK |
+				   ISP5_IRQ_RSZ_FIFO_IN_BLK_ERR |
 				   ISP5_IRQ_RSZ_FIFO_OVF |
 				   ISP5_IRQ_RSZ_INT_DMA |
-				   ISP5_IRQ_ISIF0;
+				   ISP5_IRQ_ISIF_INT(0);
 
 	/* Enable ISP interrupts */
 	writel(isp_irq, iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_IRQSTATUS(0));
@@ -256,16 +256,16 @@ static inline void iss_isr_dbg(struct iss_device *iss, u32 irqstatus)
  */
 static irqreturn_t iss_isr(int irq, void *_iss)
 {
-	static const u32 ipipeif_events = ISP5_IRQ_IPIPEIF |
-					  ISP5_IRQ_ISIF0;
-	static const u32 resizer_events = ISP5_IRQ_RSZ_FIFO_IN_BLK |
+	static const u32 ipipeif_events = ISP5_IRQ_IPIPEIF_IRQ |
+					  ISP5_IRQ_ISIF_INT(0);
+	static const u32 resizer_events = ISP5_IRQ_RSZ_FIFO_IN_BLK_ERR |
 					  ISP5_IRQ_RSZ_FIFO_OVF |
 					  ISP5_IRQ_RSZ_INT_DMA;
 	struct iss_device *iss = _iss;
 	u32 irqstatus;
 
-	irqstatus = readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQSTATUS_5);
-	writel(irqstatus, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQSTATUS_5);
+	irqstatus = readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQSTATUS(5));
+	writel(irqstatus, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQSTATUS(5));
 
 	if (irqstatus & ISS_HL_IRQ_CSIA)
 		omap4iss_csi2_isr(&iss->csi2a);
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index eee6891..e96040f 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -274,7 +274,7 @@ void omap4iss_ipipeif_isr(struct iss_ipipeif_device *ipipeif, u32 events)
 					     &ipipeif->stopping))
 		return;
 
-	if (events & ISP5_IRQ_ISIF0)
+	if (events & ISP5_IRQ_ISIF_INT(0))
 		ipipeif_isif0_isr(ipipeif);
 }
 
diff --git a/drivers/staging/media/omap4iss/iss_regs.h b/drivers/staging/media/omap4iss/iss_regs.h
index 7327d0c..16975ca 100644
--- a/drivers/staging/media/omap4iss/iss_regs.h
+++ b/drivers/staging/media/omap4iss/iss_regs.h
@@ -24,12 +24,16 @@
 #define ISS_HL_SYSCONFIG_IDLEMODE_SMARTIDLE		0x2
 #define ISS_HL_SYSCONFIG_SOFTRESET			(1 << 0)
 
-#define ISS_HL_IRQSTATUS_5				(0x24 + (0x10 * 5))
-#define ISS_HL_IRQENABLE_5_SET				(0x28 + (0x10 * 5))
-#define ISS_HL_IRQENABLE_5_CLR				(0x2C + (0x10 * 5))
+#define ISS_HL_IRQSTATUS_RAW(i)				(0x20 + (0x10 * (i)))
+#define ISS_HL_IRQSTATUS(i)				(0x24 + (0x10 * (i)))
+#define ISS_HL_IRQENABLE_SET(i)				(0x28 + (0x10 * (i)))
+#define ISS_HL_IRQENABLE_CLR(i)				(0x2c + (0x10 * (i)))
 
+#define ISS_HL_IRQ_HS_VS				(1 << 17)
+#define ISS_HL_IRQ_SIMCOP(i)				(1 << (12 + (i)))
 #define ISS_HL_IRQ_BTE					(1 << 11)
 #define ISS_HL_IRQ_CBUFF				(1 << 10)
+#define ISS_HL_IRQ_CCP2(i)				(1 << ((i) > 3 ? 16 : 14 + (i)))
 #define ISS_HL_IRQ_CSIB					(1 << 5)
 #define ISS_HL_IRQ_CSIA					(1 << 4)
 #define ISS_HL_IRQ_ISP(i)				(1 << (i))
@@ -267,16 +271,30 @@
 
 /* Bits shared for ISP5_IRQ* registers */
 #define ISP5_IRQ_OCP_ERR				(1 << 31)
+#define ISP5_IRQ_IPIPE_INT_DPC_RNEW1			(1 << 29)
+#define ISP5_IRQ_IPIPE_INT_DPC_RNEW0			(1 << 28)
+#define ISP5_IRQ_IPIPE_INT_DPC_INIT			(1 << 27)
+#define ISP5_IRQ_IPIPE_INT_EOF				(1 << 25)
+#define ISP5_IRQ_H3A_INT_EOF				(1 << 24)
+#define ISP5_IRQ_RSZ_INT_EOF1				(1 << 23)
 #define ISP5_IRQ_RSZ_INT_EOF0				(1 << 22)
-#define ISP5_IRQ_RSZ_FIFO_IN_BLK			(1 << 19)
+#define ISP5_IRQ_RSZ_FIFO_IN_BLK_ERR			(1 << 19)
 #define ISP5_IRQ_RSZ_FIFO_OVF				(1 << 18)
+#define ISP5_IRQ_RSZ_INT_CYC_RSZB			(1 << 17)
 #define ISP5_IRQ_RSZ_INT_CYC_RSZA			(1 << 16)
 #define ISP5_IRQ_RSZ_INT_DMA				(1 << 15)
-#define ISP5_IRQ_IPIPEIF				(1 << 9)
-#define ISP5_IRQ_ISIF3					(1 << 3)
-#define ISP5_IRQ_ISIF2					(1 << 2)
-#define ISP5_IRQ_ISIF1					(1 << 1)
-#define ISP5_IRQ_ISIF0					(1 << 0)
+#define ISP5_IRQ_RSZ_INT_LAST_PIX			(1 << 14)
+#define ISP5_IRQ_RSZ_INT_REG				(1 << 13)
+#define ISP5_IRQ_H3A_INT				(1 << 12)
+#define ISP5_IRQ_AF_INT					(1 << 11)
+#define ISP5_IRQ_AEW_INT				(1 << 10)
+#define ISP5_IRQ_IPIPEIF_IRQ				(1 << 9)
+#define ISP5_IRQ_IPIPE_INT_HST				(1 << 8)
+#define ISP5_IRQ_IPIPE_INT_BSC				(1 << 7)
+#define ISP5_IRQ_IPIPE_INT_DMA				(1 << 6)
+#define ISP5_IRQ_IPIPE_INT_LAST_PIX			(1 << 5)
+#define ISP5_IRQ_IPIPE_INT_REG				(1 << 4)
+#define ISP5_IRQ_ISIF_INT(i)				(1 << (i))
 
 #define ISP5_CTRL					(0x006C)
 #define ISP5_CTRL_MSTANDBY				(1 << 24)
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index 08b2505..272b92a 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -315,11 +315,11 @@ void omap4iss_resizer_isr(struct iss_resizer_device *resizer, u32 events)
 	struct iss_pipeline *pipe =
 			     to_iss_pipeline(&resizer->subdev.entity);
 
-	if (events & (ISP5_IRQ_RSZ_FIFO_IN_BLK |
+	if (events & (ISP5_IRQ_RSZ_FIFO_IN_BLK_ERR |
 		      ISP5_IRQ_RSZ_FIFO_OVF)) {
 		dev_dbg(iss->dev, "RSZ Err: FIFO_IN_BLK:%d, FIFO_OVF:%d\n",
 			(events &
-			 ISP5_IRQ_RSZ_FIFO_IN_BLK) ? 1 : 0,
+			 ISP5_IRQ_RSZ_FIFO_IN_BLK_ERR) ? 1 : 0,
 			(events &
 			 ISP5_IRQ_RSZ_FIFO_OVF) ? 1 : 0);
 		pipe->error = true;
-- 
1.8.3.2

