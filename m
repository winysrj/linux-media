Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44098 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab3LDA4a (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:30 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 07DAE363EF
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:39 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 07/25] v4l: omap4iss: Enhance IRQ debugging
Date: Wed,  4 Dec 2013 01:56:07 +0100
Message-Id: <1386118585-12449-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a pretty print function for ISP IRQs and remove the _INT suffix from
interrupt names to enhance readability.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c | 121 +++++++++++++++++++++++++----------
 1 file changed, 87 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 815b09b..65a1680 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -197,43 +197,44 @@ void omap4iss_configure_bridge(struct iss_device *iss,
 	writel(isp5ctrl_val, iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL);
 }
 
+#if defined(DEBUG) && defined(ISS_ISR_DEBUG)
 static inline void iss_isr_dbg(struct iss_device *iss, u32 irqstatus)
 {
-	static const char *name[] = {
-		"ISP_IRQ0",
-		"ISP_IRQ1",
-		"ISP_IRQ2",
-		"ISP_IRQ3",
-		"CSIA_IRQ",
-		"CSIB_IRQ",
-		"CCP2_IRQ0",
-		"CCP2_IRQ1",
-		"CCP2_IRQ2",
-		"CCP2_IRQ3",
-		"CBUFF_IRQ",
-		"BTE_IRQ",
-		"SIMCOP_IRQ0",
-		"SIMCOP_IRQ1",
-		"SIMCOP_IRQ2",
-		"SIMCOP_IRQ3",
-		"CCP2_IRQ8",
-		"HS_VS_IRQ",
-		"res18",
-		"res19",
-		"res20",
-		"res21",
-		"res22",
-		"res23",
-		"res24",
-		"res25",
-		"res26",
-		"res27",
-		"res28",
-		"res29",
-		"res30",
-		"res31",
+	static const char * const name[] = {
+		"ISP_0",
+		"ISP_1",
+		"ISP_2",
+		"ISP_3",
+		"CSIA",
+		"CSIB",
+		"CCP2_0",
+		"CCP2_1",
+		"CCP2_2",
+		"CCP2_3",
+		"CBUFF",
+		"BTE",
+		"SIMCOP_0",
+		"SIMCOP_1",
+		"SIMCOP_2",
+		"SIMCOP_3",
+		"CCP2_8",
+		"HS_VS",
+		"18",
+		"19",
+		"20",
+		"21",
+		"22",
+		"23",
+		"24",
+		"25",
+		"26",
+		"27",
+		"28",
+		"29",
+		"30",
+		"31",
 	};
-	int i;
+	unsigned int i;
 
 	dev_dbg(iss->dev, "ISS IRQ: ");
 
@@ -244,6 +245,54 @@ static inline void iss_isr_dbg(struct iss_device *iss, u32 irqstatus)
 	pr_cont("\n");
 }
 
+static inline void iss_isp_isr_dbg(struct iss_device *iss, u32 irqstatus)
+{
+	static const char * const name[] = {
+		"ISIF_0",
+		"ISIF_1",
+		"ISIF_2",
+		"ISIF_3",
+		"IPIPEREQ",
+		"IPIPELAST_PIX",
+		"IPIPEDMA",
+		"IPIPEBSC",
+		"IPIPEHST",
+		"IPIPEIF",
+		"AEW",
+		"AF",
+		"H3A",
+		"RSZ_REG",
+		"RSZ_LAST_PIX",
+		"RSZ_DMA",
+		"RSZ_CYC_RZA",
+		"RSZ_CYC_RZB",
+		"RSZ_FIFO_OVF",
+		"RSZ_FIFO_IN_BLK_ERR",
+		"20",
+		"21",
+		"RSZ_EOF0",
+		"RSZ_EOF1",
+		"H3A_EOF",
+		"IPIPE_EOF",
+		"26",
+		"IPIPE_DPC_INI",
+		"IPIPE_DPC_RNEW0",
+		"IPIPE_DPC_RNEW1",
+		"30",
+		"OCP_ERR",
+	};
+	unsigned int i;
+
+	dev_dbg(iss->dev, "ISP IRQ: ");
+
+	for (i = 0; i < ARRAY_SIZE(name); i++) {
+		if ((1 << i) & irqstatus)
+			pr_cont("%s ", name[i]);
+	}
+	pr_cont("\n");
+}
+#endif
+
 /*
  * iss_isr - Interrupt Service Routine for ISS module.
  * @irq: Not used currently.
@@ -290,6 +339,10 @@ static irqreturn_t iss_isr(int irq, void *_iss)
 		if (isp_irqstatus & resizer_events)
 			omap4iss_resizer_isr(&iss->resizer,
 					     isp_irqstatus & resizer_events);
+
+#if defined(DEBUG) && defined(ISS_ISR_DEBUG)
+		iss_isp_isr_dbg(iss, isp_irqstatus);
+#endif
 	}
 
 	omap4iss_flush(iss);
-- 
1.8.3.2

