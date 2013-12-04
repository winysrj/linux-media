Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44098 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab3LDA4d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:33 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 0836436691
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:39 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 13/25] v4l: omap4iss: Create and use register access functions
Date: Wed,  4 Dec 2013 01:56:13 +0100
Message-Id: <1386118585-12449-14-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the direct readl/writel calls with helper functions that take an
ISS pointer and compute the register memory address. Also add bit clear,
set and update helpers.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c         |  96 ++++++++--------
 drivers/staging/media/omap4iss/iss.h         |  80 +++++++++++++
 drivers/staging/media/omap4iss/iss_ipipe.c   |  53 ++++-----
 drivers/staging/media/omap4iss/iss_ipipeif.c |  94 +++++++--------
 drivers/staging/media/omap4iss/iss_resizer.c | 166 ++++++++++++---------------
 5 files changed, 265 insertions(+), 224 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index e6528fa..ba8460d 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -32,7 +32,7 @@
 
 #define ISS_PRINT_REGISTER(iss, name)\
 	dev_dbg(iss->dev, "###ISS " #name "=0x%08x\n", \
-		readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_##name))
+		iss_reg_read(iss, OMAP4_ISS_MEM_TOP, ISS_##name))
 
 static void iss_print_status(struct iss_device *iss)
 {
@@ -62,8 +62,8 @@ static void iss_print_status(struct iss_device *iss)
  */
 void omap4iss_flush(struct iss_device *iss)
 {
-	writel(0, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_REVISION);
-	readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_REVISION);
+	iss_reg_write(iss, OMAP4_ISS_MEM_TOP, ISS_HL_REVISION, 0);
+	iss_reg_read(iss, OMAP4_ISS_MEM_TOP, ISS_HL_REVISION);
 }
 
 /*
@@ -75,8 +75,8 @@ static void iss_enable_interrupts(struct iss_device *iss)
 	static const u32 hl_irq = ISS_HL_IRQ_CSIA | ISS_HL_IRQ_CSIB | ISS_HL_IRQ_ISP(0);
 
 	/* Enable HL interrupts */
-	writel(hl_irq, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQSTATUS(5));
-	writel(hl_irq, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQENABLE_SET(5));
+	iss_reg_write(iss, OMAP4_ISS_MEM_TOP, ISS_HL_IRQSTATUS(5), hl_irq);
+	iss_reg_write(iss, OMAP4_ISS_MEM_TOP, ISS_HL_IRQENABLE_SET(5), hl_irq);
 
 }
 
@@ -86,7 +86,7 @@ static void iss_enable_interrupts(struct iss_device *iss)
  */
 static void iss_disable_interrupts(struct iss_device *iss)
 {
-	writel(-1, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQENABLE_CLR(5));
+	iss_reg_write(iss, OMAP4_ISS_MEM_TOP, ISS_HL_IRQENABLE_CLR(5), -1);
 }
 
 /*
@@ -102,8 +102,9 @@ void omap4iss_isp_enable_interrupts(struct iss_device *iss)
 				   ISP5_IRQ_ISIF_INT(0);
 
 	/* Enable ISP interrupts */
-	writel(isp_irq, iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_IRQSTATUS(0));
-	writel(isp_irq, iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_IRQENABLE_SET(0));
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_IRQSTATUS(0), isp_irq);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_IRQENABLE_SET(0),
+		      isp_irq);
 }
 
 /*
@@ -112,7 +113,7 @@ void omap4iss_isp_enable_interrupts(struct iss_device *iss)
  */
 void omap4iss_isp_disable_interrupts(struct iss_device *iss)
 {
-	writel(-1, iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_IRQENABLE_CLR(0));
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_IRQENABLE_CLR(0), -1);
 }
 
 int omap4iss_get_external_info(struct iss_pipeline *pipe,
@@ -169,11 +170,11 @@ void omap4iss_configure_bridge(struct iss_device *iss,
 	u32 issctrl_val;
 	u32 isp5ctrl_val;
 
-	issctrl_val  = readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_CTRL);
+	issctrl_val = iss_reg_read(iss, OMAP4_ISS_MEM_TOP, ISS_CTRL);
 	issctrl_val &= ~ISS_CTRL_INPUT_SEL_MASK;
 	issctrl_val &= ~ISS_CTRL_CLK_DIV_MASK;
 
-	isp5ctrl_val  = readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL);
+	isp5ctrl_val = iss_reg_read(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_CTRL);
 
 	switch (input) {
 	case IPIPEIF_INPUT_CSI2A:
@@ -193,8 +194,8 @@ void omap4iss_configure_bridge(struct iss_device *iss,
 	isp5ctrl_val |= ISP5_CTRL_VD_PULSE_EXT | ISP5_CTRL_PSYNC_CLK_SEL |
 			ISP5_CTRL_SYNC_ENABLE;
 
-	writel(issctrl_val, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_CTRL);
-	writel(isp5ctrl_val, iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL);
+	iss_reg_write(iss, OMAP4_ISS_MEM_TOP, ISS_CTRL, issctrl_val);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_CTRL, isp5ctrl_val);
 }
 
 #if defined(DEBUG) && defined(ISS_ISR_DEBUG)
@@ -313,8 +314,8 @@ static irqreturn_t iss_isr(int irq, void *_iss)
 	struct iss_device *iss = _iss;
 	u32 irqstatus;
 
-	irqstatus = readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQSTATUS(5));
-	writel(irqstatus, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQSTATUS(5));
+	irqstatus = iss_reg_read(iss, OMAP4_ISS_MEM_TOP, ISS_HL_IRQSTATUS(5));
+	iss_reg_write(iss, OMAP4_ISS_MEM_TOP, ISS_HL_IRQSTATUS(5), irqstatus);
 
 	if (irqstatus & ISS_HL_IRQ_CSIA)
 		omap4iss_csi2_isr(&iss->csi2a);
@@ -323,10 +324,10 @@ static irqreturn_t iss_isr(int irq, void *_iss)
 		omap4iss_csi2_isr(&iss->csi2b);
 
 	if (irqstatus & ISS_HL_IRQ_ISP(0)) {
-		u32 isp_irqstatus = readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] +
-					  ISP5_IRQSTATUS(0));
-		writel(isp_irqstatus, iss->regs[OMAP4_ISS_MEM_ISP_SYS1] +
-			ISP5_IRQSTATUS(0));
+		u32 isp_irqstatus = iss_reg_read(iss, OMAP4_ISS_MEM_ISP_SYS1,
+						 ISP5_IRQSTATUS(0));
+		iss_reg_write(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_IRQSTATUS(0),
+			      isp_irqstatus);
 
 		if (isp_irqstatus & ISP5_IRQ_OCP_ERR)
 			dev_dbg(iss->dev, "ISP5 OCP Error!\n");
@@ -689,12 +690,11 @@ static int iss_reset(struct iss_device *iss)
 {
 	unsigned long timeout = 0;
 
-	writel(readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_SYSCONFIG) |
-		ISS_HL_SYSCONFIG_SOFTRESET,
-		iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_SYSCONFIG);
+	iss_reg_set(iss, OMAP4_ISS_MEM_TOP, ISS_HL_SYSCONFIG,
+		    ISS_HL_SYSCONFIG_SOFTRESET);
 
-	while (readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_SYSCONFIG) &
-			ISS_HL_SYSCONFIG_SOFTRESET) {
+	while (iss_reg_read(iss, OMAP4_ISS_MEM_TOP, ISS_HL_SYSCONFIG) &
+	       ISS_HL_SYSCONFIG_SOFTRESET) {
 		if (timeout++ > 100) {
 			dev_alert(iss->dev, "cannot reset ISS\n");
 			return -ETIMEDOUT;
@@ -710,18 +710,15 @@ static int iss_isp_reset(struct iss_device *iss)
 	unsigned long timeout = 0;
 
 	/* Fist, ensure that the ISP is IDLE (no transactions happening) */
-	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_SYSCONFIG) &
-		~ISP5_SYSCONFIG_STANDBYMODE_MASK) |
-		ISP5_SYSCONFIG_STANDBYMODE_SMART,
-		iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_SYSCONFIG);
+	iss_reg_update(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_SYSCONFIG,
+		       ISP5_SYSCONFIG_STANDBYMODE_MASK,
+		       ISP5_SYSCONFIG_STANDBYMODE_SMART);
 
-	writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL) |
-		ISP5_CTRL_MSTANDBY,
-		iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL);
+	iss_reg_set(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_CTRL, ISP5_CTRL_MSTANDBY);
 
 	for (;;) {
-		if (readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL) &
-				ISP5_CTRL_MSTANDBY_WAIT)
+		if (iss_reg_read(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_CTRL) &
+		    ISP5_CTRL_MSTANDBY_WAIT)
 			break;
 		if (timeout++ > 1000) {
 			dev_alert(iss->dev, "cannot set ISP5 to standby\n");
@@ -731,13 +728,12 @@ static int iss_isp_reset(struct iss_device *iss)
 	}
 
 	/* Now finally, do the reset */
-	writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_SYSCONFIG) |
-		ISP5_SYSCONFIG_SOFTRESET,
-		iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_SYSCONFIG);
+	iss_reg_set(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_SYSCONFIG,
+		    ISP5_SYSCONFIG_SOFTRESET);
 
 	timeout = 0;
-	while (readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_SYSCONFIG) &
-			ISP5_SYSCONFIG_SOFTRESET) {
+	while (iss_reg_read(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_SYSCONFIG) &
+	       ISP5_SYSCONFIG_SOFTRESET) {
 		if (timeout++ > 1000) {
 			dev_alert(iss->dev, "cannot reset ISP5\n");
 			return -ETIMEDOUT;
@@ -848,15 +844,14 @@ static int __iss_subclk_update(struct iss_device *iss)
 	if (iss->subclk_resources & OMAP4_ISS_SUBCLK_ISP)
 		clk |= ISS_CLKCTRL_ISP;
 
-	writel((readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_CLKCTRL) &
-		~ISS_CLKCTRL_MASK) | clk,
-		iss->regs[OMAP4_ISS_MEM_TOP] + ISS_CLKCTRL);
+	iss_reg_update(iss, OMAP4_ISS_MEM_TOP, ISS_CLKCTRL,
+		       ISS_CLKCTRL_MASK, clk);
 
 	/* Wait for HW assertion */
 	while (--timeout > 0) {
 		udelay(1);
-		if ((readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_CLKSTAT) &
-		     ISS_CLKCTRL_MASK) == clk)
+		if ((iss_reg_read(iss, OMAP4_ISS_MEM_TOP, ISS_CLKSTAT) &
+		    ISS_CLKCTRL_MASK) == clk)
 			break;
 	}
 
@@ -911,9 +906,8 @@ static void __iss_isp_subclk_update(struct iss_device *iss)
 	if (clk)
 		clk |= ISP5_CTRL_BL_CLK_ENABLE;
 
-	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL) &
-		~ISS_ISP5_CLKCTRL_MASK) | clk,
-		iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL);
+	iss_reg_update(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_CTRL,
+		       ISS_ISP5_CLKCTRL_MASK, clk);
 }
 
 void omap4iss_isp_subclk_enable(struct iss_device *iss,
@@ -1380,7 +1374,7 @@ static int iss_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error_iss;
 
-	iss->revision = readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_REVISION);
+	iss->revision = iss_reg_read(iss, OMAP4_ISS_MEM_TOP, ISS_HL_REVISION);
 	dev_info(iss->dev, "Revision %08x found\n", iss->revision);
 
 	for (i = 1; i < OMAP4_ISS_MEM_LAST; i++) {
@@ -1390,9 +1384,9 @@ static int iss_probe(struct platform_device *pdev)
 	}
 
 	/* Configure BTE BW_LIMITER field to max recommended value (1 GB) */
-	writel((readl(iss->regs[OMAP4_ISS_MEM_BTE] + BTE_CTRL) & ~BTE_CTRL_BW_LIMITER_MASK) |
-		(18 << BTE_CTRL_BW_LIMITER_SHIFT),
-		iss->regs[OMAP4_ISS_MEM_BTE] + BTE_CTRL);
+	iss_reg_update(iss, OMAP4_ISS_MEM_BTE, BTE_CTRL,
+		       BTE_CTRL_BW_LIMITER_MASK,
+		       18 << BTE_CTRL_BW_LIMITER_SHIFT);
 
 	/* Perform ISP reset */
 	ret = omap4iss_subclk_enable(iss, OMAP4_ISS_SUBCLK_ISP);
@@ -1404,7 +1398,7 @@ static int iss_probe(struct platform_device *pdev)
 		goto error_iss;
 
 	dev_info(iss->dev, "ISP Revision %08x found\n",
-		 readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_REVISION));
+		 iss_reg_read(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_REVISION));
 
 	/* Interrupt */
 	iss->irq_num = platform_get_irq(pdev, 0);
diff --git a/drivers/staging/media/omap4iss/iss.h b/drivers/staging/media/omap4iss/iss.h
index f33664d..660809e 100644
--- a/drivers/staging/media/omap4iss/iss.h
+++ b/drivers/staging/media/omap4iss/iss.h
@@ -150,4 +150,84 @@ int omap4iss_register_entities(struct platform_device *pdev,
 			       struct v4l2_device *v4l2_dev);
 void omap4iss_unregister_entities(struct platform_device *pdev);
 
+/*
+ * iss_reg_read - Read the value of an OMAP4 ISS register
+ * @iss: the ISS device
+ * @res: memory resource in which the register is located
+ * @offset: register offset in the memory resource
+ *
+ * Return the register value.
+ */
+static inline
+u32 iss_reg_read(struct iss_device *iss, enum iss_mem_resources res,
+		 u32 offset)
+{
+	return readl(iss->regs[res] + offset);
+}
+
+/*
+ * iss_reg_write - Write a value to an OMAP4 ISS register
+ * @iss: the ISS device
+ * @res: memory resource in which the register is located
+ * @offset: register offset in the memory resource
+ * @value: value to be written
+ */
+static inline
+void iss_reg_write(struct iss_device *iss, enum iss_mem_resources res,
+		   u32 offset, u32 value)
+{
+	writel(value, iss->regs[res] + offset);
+}
+
+/*
+ * iss_reg_clr - Clear bits in an OMAP4 ISS register
+ * @iss: the ISS device
+ * @res: memory resource in which the register is located
+ * @offset: register offset in the memory resource
+ * @clr: bit mask to be cleared
+ */
+static inline
+void iss_reg_clr(struct iss_device *iss, enum iss_mem_resources res,
+		 u32 offset, u32 clr)
+{
+	u32 v = iss_reg_read(iss, res, offset);
+
+	iss_reg_write(iss, res, offset, v & ~clr);
+}
+
+/*
+ * iss_reg_set - Set bits in an OMAP4 ISS register
+ * @iss: the ISS device
+ * @res: memory resource in which the register is located
+ * @offset: register offset in the memory resource
+ * @set: bit mask to be set
+ */
+static inline
+void iss_reg_set(struct iss_device *iss, enum iss_mem_resources res,
+		 u32 offset, u32 set)
+{
+	u32 v = iss_reg_read(iss, res, offset);
+
+	iss_reg_write(iss, res, offset, v | set);
+}
+
+/*
+ * iss_reg_update - Clear and set bits in an OMAP4 ISS register
+ * @iss: the ISS device
+ * @res: memory resource in which the register is located
+ * @offset: register offset in the memory resource
+ * @clr: bit mask to be cleared
+ * @set: bit mask to be set
+ *
+ * Clear the clr mask first and then set the set mask.
+ */
+static inline
+void iss_reg_update(struct iss_device *iss, enum iss_mem_resources res,
+		    u32 offset, u32 clr, u32 set)
+{
+	u32 v = iss_reg_read(iss, res, offset);
+
+	iss_reg_write(iss, res, offset, (v & ~clr) | set);
+}
+
 #endif /* _OMAP4_ISS_H_ */
diff --git a/drivers/staging/media/omap4iss/iss_ipipe.c b/drivers/staging/media/omap4iss/iss_ipipe.c
index bdafd78..d0b9f8c 100644
--- a/drivers/staging/media/omap4iss/iss_ipipe.c
+++ b/drivers/staging/media/omap4iss/iss_ipipe.c
@@ -42,7 +42,7 @@ static const unsigned int ipipe_fmts[] = {
  */
 #define IPIPE_PRINT_REGISTER(iss, name)\
 	dev_dbg(iss->dev, "###IPIPE " #name "=0x%08x\n", \
-		readl(iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_##name))
+		iss_reg_read(iss, OMAP4_ISS_MEM_ISP_IPIPE, IPIPE_##name))
 
 static void ipipe_print_status(struct iss_ipipe_device *ipipe)
 {
@@ -73,10 +73,8 @@ static void ipipe_enable(struct iss_ipipe_device *ipipe, u8 enable)
 {
 	struct iss_device *iss = to_iss_device(ipipe);
 
-	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_SRC_EN) &
-		~IPIPE_SRC_EN_EN) |
-		(enable ? IPIPE_SRC_EN_EN : 0),
-		iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_SRC_EN);
+	iss_reg_update(iss, OMAP4_ISS_MEM_ISP_IPIPE, IPIPE_SRC_EN,
+		       IPIPE_SRC_EN_EN, enable ? IPIPE_SRC_EN_EN : 0);
 }
 
 /* -----------------------------------------------------------------------------
@@ -92,31 +90,28 @@ static void ipipe_configure(struct iss_ipipe_device *ipipe)
 	format = &ipipe->formats[IPIPE_PAD_SINK];
 
 	/* NOTE: Currently just supporting pipeline IN: RGB, OUT: YUV422 */
-	writel(IPIPE_SRC_FMT_RAW2YUV,
-		iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_SRC_FMT);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_IPIPE, IPIPE_SRC_FMT,
+		      IPIPE_SRC_FMT_RAW2YUV);
 
 	/* Enable YUV444 -> YUV422 conversion */
-	writel(IPIPE_YUV_PHS_LPF,
-		iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_YUV_PHS);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_IPIPE, IPIPE_YUV_PHS,
+		      IPIPE_YUV_PHS_LPF);
 
-	writel(0, iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_SRC_VPS);
-	writel(0, iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_SRC_HPS);
-	writel((format->height - 2) & IPIPE_SRC_VSZ_MASK,
-		iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_SRC_VSZ);
-	writel((format->width - 1) & IPIPE_SRC_HSZ_MASK,
-		iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_SRC_HSZ);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_IPIPE, IPIPE_SRC_VPS, 0);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_IPIPE, IPIPE_SRC_HPS, 0);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_IPIPE, IPIPE_SRC_VSZ,
+		      (format->height - 2) & IPIPE_SRC_VSZ_MASK);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_IPIPE, IPIPE_SRC_HSZ,
+		      (format->width - 1) & IPIPE_SRC_HSZ_MASK);
 
 	/* Ignore ipipeif_wrt signal, and operate on-the-fly.  */
-	writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_SRC_MODE) &
-		~(IPIPE_SRC_MODE_WRT | IPIPE_SRC_MODE_OST),
-		iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_SRC_MODE);
+	iss_reg_clr(iss, OMAP4_ISS_MEM_ISP_IPIPE, IPIPE_SRC_MODE,
+		    IPIPE_SRC_MODE_WRT | IPIPE_SRC_MODE_OST);
 
 	/* HACK: Values tuned for Ducati SW (OV) */
-	writel(IPIPE_SRC_COL_EE_B |
-		IPIPE_SRC_COL_EO_GB |
-		IPIPE_SRC_COL_OE_GR |
-		IPIPE_SRC_COL_OO_R,
-		iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_SRC_COL);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_IPIPE, IPIPE_SRC_COL,
+		      IPIPE_SRC_COL_EE_B | IPIPE_SRC_COL_EO_GB |
+		      IPIPE_SRC_COL_OE_GR | IPIPE_SRC_COL_OO_R);
 
 	/* IPIPE_PAD_SOURCE_VP */
 	format = &ipipe->formats[IPIPE_PAD_SOURCE_VP];
@@ -147,15 +142,13 @@ static int ipipe_set_stream(struct v4l2_subdev *sd, int enable)
 		omap4iss_isp_subclk_enable(iss, OMAP4_ISS_ISP_SUBCLK_IPIPE);
 
 		/* Enable clk_arm_g0 */
-		writel(IPIPE_GCK_MMR_REG,
-			iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_GCK_MMR);
+		iss_reg_write(iss, OMAP4_ISS_MEM_ISP_IPIPE, IPIPE_GCK_MMR,
+			      IPIPE_GCK_MMR_REG);
 
 		/* Enable clk_pix_g[3:0] */
-		writel(IPIPE_GCK_PIX_G3 |
-			IPIPE_GCK_PIX_G2 |
-			IPIPE_GCK_PIX_G1 |
-			IPIPE_GCK_PIX_G0,
-			iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_GCK_PIX);
+		iss_reg_write(iss, OMAP4_ISS_MEM_ISP_IPIPE, IPIPE_GCK_PIX,
+			      IPIPE_GCK_PIX_G3 | IPIPE_GCK_PIX_G2 |
+			      IPIPE_GCK_PIX_G1 | IPIPE_GCK_PIX_G0);
 	}
 
 	switch (enable) {
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index 2853851..2d11f62 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -40,15 +40,15 @@ static const unsigned int ipipeif_fmts[] = {
  */
 #define IPIPEIF_PRINT_REGISTER(iss, name)\
 	dev_dbg(iss->dev, "###IPIPEIF " #name "=0x%08x\n", \
-		readl(iss->regs[OMAP4_ISS_MEM_ISP_IPIPEIF] + IPIPEIF_##name))
+		iss_reg_read(iss, OMAP4_ISS_MEM_ISP_IPIPEIF, IPIPEIF_##name))
 
 #define ISIF_PRINT_REGISTER(iss, name)\
 	dev_dbg(iss->dev, "###ISIF " #name "=0x%08x\n", \
-		readl(iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_##name))
+		iss_reg_read(iss, OMAP4_ISS_MEM_ISP_ISIF, ISIF_##name))
 
 #define ISP5_PRINT_REGISTER(iss, name)\
 	dev_dbg(iss->dev, "###ISP5 " #name "=0x%08x\n", \
-		readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_##name))
+		iss_reg_read(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_##name))
 
 static void ipipeif_print_status(struct iss_ipipeif_device *ipipeif)
 {
@@ -83,10 +83,8 @@ static void ipipeif_write_enable(struct iss_ipipeif_device *ipipeif, u8 enable)
 {
 	struct iss_device *iss = to_iss_device(ipipeif);
 
-	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_SYNCEN) &
-		~ISIF_SYNCEN_DWEN) |
-		(enable ? ISIF_SYNCEN_DWEN : 0),
-		iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_SYNCEN);
+	iss_reg_update(iss, OMAP4_ISS_MEM_ISP_ISIF, ISIF_SYNCEN,
+		       ISIF_SYNCEN_DWEN, enable ? ISIF_SYNCEN_DWEN : 0);
 }
 
 /*
@@ -98,10 +96,8 @@ static void ipipeif_enable(struct iss_ipipeif_device *ipipeif, u8 enable)
 {
 	struct iss_device *iss = to_iss_device(ipipeif);
 
-	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_SYNCEN) &
-		~ISIF_SYNCEN_SYEN) |
-		(enable ? ISIF_SYNCEN_SYEN : 0),
-		iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_SYNCEN);
+	iss_reg_update(iss, OMAP4_ISS_MEM_ISP_ISIF, ISIF_SYNCEN,
+		       ISIF_SYNCEN_SYEN, enable ? ISIF_SYNCEN_SYEN : 0);
 }
 
 /* -----------------------------------------------------------------------------
@@ -120,10 +116,10 @@ static void ipipeif_set_outaddr(struct iss_ipipeif_device *ipipeif, u32 addr)
 	struct iss_device *iss = to_iss_device(ipipeif);
 
 	/* Save address splitted in Base Address H & L */
-	writel((addr >> (16 + 5)) & ISIF_CADU_MASK,
-		iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_CADU);
-	writel((addr >> 5) & ISIF_CADL_MASK,
-		iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_CADL);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_ISIF, ISIF_CADU,
+		      (addr >> (16 + 5)) & ISIF_CADU_MASK);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_ISIF, ISIF_CADL,
+		      (addr >> 5) & ISIF_CADL_MASK);
 }
 
 static void ipipeif_configure(struct iss_ipipeif_device *ipipeif)
@@ -139,25 +135,20 @@ static void ipipeif_configure(struct iss_ipipeif_device *ipipeif)
 	format = &ipipeif->formats[IPIPEIF_PAD_SINK];
 
 	/* IPIPEIF with YUV422 input from ISIF */
-	writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_IPIPEIF] + IPIPEIF_CFG1) &
-		~(IPIPEIF_CFG1_INPSRC1_MASK | IPIPEIF_CFG1_INPSRC2_MASK),
-		iss->regs[OMAP4_ISS_MEM_ISP_IPIPEIF] + IPIPEIF_CFG1);
+	iss_reg_clr(iss, OMAP4_ISS_MEM_ISP_IPIPEIF, IPIPEIF_CFG1,
+		    IPIPEIF_CFG1_INPSRC1_MASK | IPIPEIF_CFG1_INPSRC2_MASK);
 
 	/* Select ISIF/IPIPEIF input format */
 	switch (format->code) {
 	case V4L2_MBUS_FMT_UYVY8_1X16:
 	case V4L2_MBUS_FMT_YUYV8_1X16:
-		writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_MODESET) &
-			~(ISIF_MODESET_CCDMD |
-			  ISIF_MODESET_INPMOD_MASK |
-			  ISIF_MODESET_CCDW_MASK)) |
-			ISIF_MODESET_INPMOD_YCBCR16,
-			iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_MODESET);
-
-		writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_IPIPEIF] + IPIPEIF_CFG2) &
-			~IPIPEIF_CFG2_YUV8) |
-			IPIPEIF_CFG2_YUV16,
-			iss->regs[OMAP4_ISS_MEM_ISP_IPIPEIF] + IPIPEIF_CFG2);
+		iss_reg_update(iss, OMAP4_ISS_MEM_ISP_ISIF, ISIF_MODESET,
+			       ISIF_MODESET_CCDMD | ISIF_MODESET_INPMOD_MASK |
+			       ISIF_MODESET_CCDW_MASK,
+			       ISIF_MODESET_INPMOD_YCBCR16);
+
+		iss_reg_update(iss, OMAP4_ISS_MEM_ISP_IPIPEIF, IPIPEIF_CFG2,
+			       IPIPEIF_CFG2_YUV8, IPIPEIF_CFG2_YUV16);
 
 		break;
 	case V4L2_MBUS_FMT_SGRBG10_1X10:
@@ -184,44 +175,41 @@ static void ipipeif_configure(struct iss_ipipeif_device *ipipeif)
 			ISIF_CCOLP_CP2_F0_R |
 			ISIF_CCOLP_CP3_F0_GR;
 cont_raw:
-		writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_IPIPEIF] + IPIPEIF_CFG2) &
-			~IPIPEIF_CFG2_YUV16),
-			iss->regs[OMAP4_ISS_MEM_ISP_IPIPEIF] + IPIPEIF_CFG2);
+		iss_reg_clr(iss, OMAP4_ISS_MEM_ISP_IPIPEIF, IPIPEIF_CFG2,
+			    IPIPEIF_CFG2_YUV16);
 
-		writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_MODESET) &
-			~(ISIF_MODESET_CCDMD |
-			  ISIF_MODESET_INPMOD_MASK |
-			  ISIF_MODESET_CCDW_MASK)) |
-			ISIF_MODESET_INPMOD_RAW | ISIF_MODESET_CCDW_2BIT,
-			iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_MODESET);
+		iss_reg_update(iss, OMAP4_ISS_MEM_ISP_ISIF, ISIF_MODESET,
+			       ISIF_MODESET_CCDMD | ISIF_MODESET_INPMOD_MASK |
+			       ISIF_MODESET_CCDW_MASK, ISIF_MODESET_INPMOD_RAW |
+			       ISIF_MODESET_CCDW_2BIT);
 
 		info = omap4iss_video_format_info(format->code);
-		writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_CGAMMAWD) &
-			~ISIF_CGAMMAWD_GWDI_MASK) |
-			ISIF_CGAMMAWD_GWDI(info->bpp),
-			iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_CGAMMAWD);
+		iss_reg_update(iss, OMAP4_ISS_MEM_ISP_ISIF, ISIF_CGAMMAWD,
+			       ISIF_CGAMMAWD_GWDI_MASK,
+			       ISIF_CGAMMAWD_GWDI(info->bpp));
 
 		/* Set RAW Bayer pattern */
-		writel(isif_ccolp,
-			iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_CCOLP);
+		iss_reg_write(iss, OMAP4_ISS_MEM_ISP_ISIF, ISIF_CCOLP,
+			      isif_ccolp);
 		break;
 	}
 
-	writel(0 & ISIF_SPH_MASK, iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_SPH);
-	writel((format->width - 1) & ISIF_LNH_MASK,
-		iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_LNH);
-	writel((format->height - 1) & ISIF_LNV_MASK,
-		iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_LNV);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_ISIF, ISIF_SPH, 0 & ISIF_SPH_MASK);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_ISIF, ISIF_LNH,
+		      (format->width - 1) & ISIF_LNH_MASK);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_ISIF, ISIF_LNV,
+		      (format->height - 1) & ISIF_LNV_MASK);
 
 	/* Generate ISIF0 on the last line of the image */
-	writel(format->height - 1,
-		iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_VDINT(0));
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_ISIF, ISIF_VDINT(0),
+		      format->height - 1);
 
 	/* IPIPEIF_PAD_SOURCE_ISIF_SF */
 	format = &ipipeif->formats[IPIPEIF_PAD_SOURCE_ISIF_SF];
 
-	writel((ipipeif->video_out.bpl_value >> 5) & ISIF_HSIZE_HSIZE_MASK,
-		iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_HSIZE);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_ISIF, ISIF_HSIZE,
+		      (ipipeif->video_out.bpl_value >> 5) &
+		      ISIF_HSIZE_HSIZE_MASK);
 
 	/* IPIPEIF_PAD_SOURCE_VP */
 	/* Do nothing? */
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index 68eb2a7..793325c 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -36,11 +36,11 @@ static const unsigned int resizer_fmts[] = {
  */
 #define RSZ_PRINT_REGISTER(iss, name)\
 	dev_dbg(iss->dev, "###RSZ " #name "=0x%08x\n", \
-		readl(iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_##name))
+		iss_reg_read(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_##name))
 
 #define RZA_PRINT_REGISTER(iss, name)\
 	dev_dbg(iss->dev, "###RZA " #name "=0x%08x\n", \
-		readl(iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_##name))
+		iss_reg_read(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_##name))
 
 static void resizer_print_status(struct iss_resizer_device *resizer)
 {
@@ -116,16 +116,12 @@ static void resizer_enable(struct iss_resizer_device *resizer, u8 enable)
 {
 	struct iss_device *iss = to_iss_device(resizer);
 
-	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_SRC_EN) &
-		~RSZ_SRC_EN_SRC_EN) |
-		(enable ? RSZ_SRC_EN_SRC_EN : 0),
-		iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_SRC_EN);
+	iss_reg_update(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_SRC_EN,
+		       RSZ_SRC_EN_SRC_EN, enable ? RSZ_SRC_EN_SRC_EN : 0);
 
 	/* TODO: Enable RSZB */
-	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_EN) &
-		~RSZ_EN_EN) |
-		(enable ? RSZ_EN_EN : 0),
-		iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_EN);
+	iss_reg_update(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_EN, RSZ_EN_EN,
+		       enable ? RSZ_EN_EN : 0);
 }
 
 /* -----------------------------------------------------------------------------
@@ -148,16 +144,16 @@ static void resizer_set_outaddr(struct iss_resizer_device *resizer, u32 addr)
 	outformat = &resizer->formats[RESIZER_PAD_SOURCE_MEM];
 
 	/* Save address splitted in Base Address H & L */
-	writel((addr >> 16) & 0xffff,
-		iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_SDR_Y_BAD_H);
-	writel(addr & 0xffff,
-		iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_SDR_Y_BAD_L);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_SDR_Y_BAD_H,
+		      (addr >> 16) & 0xffff);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_SDR_Y_BAD_L,
+		      addr & 0xffff);
 
 	/* SAD = BAD */
-	writel((addr >> 16) & 0xffff,
-		iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_SDR_Y_SAD_H);
-	writel(addr & 0xffff,
-		iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_SDR_Y_SAD_L);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_SDR_Y_SAD_H,
+		      (addr >> 16) & 0xffff);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_SDR_Y_SAD_L,
+		      addr & 0xffff);
 
 	/* Program UV buffer address... Hardcoded to be contiguous! */
 	if ((informat->code == V4L2_MBUS_FMT_UYVY8_1X16) &&
@@ -173,16 +169,16 @@ static void resizer_set_outaddr(struct iss_resizer_device *resizer, u32 addr)
 		}
 
 		/* Save address splitted in Base Address H & L */
-		writel((c_addr >> 16) & 0xffff,
-			iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_SDR_C_BAD_H);
-		writel(c_addr & 0xffff,
-			iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_SDR_C_BAD_L);
+		iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_SDR_C_BAD_H,
+			      (c_addr >> 16) & 0xffff);
+		iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_SDR_C_BAD_L,
+			      c_addr & 0xffff);
 
 		/* SAD = BAD */
-		writel((c_addr >> 16) & 0xffff,
-			iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_SDR_C_SAD_H);
-		writel(c_addr & 0xffff,
-			iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_SDR_C_SAD_L);
+		iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_SDR_C_SAD_H,
+			      (c_addr >> 16) & 0xffff);
+		iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_SDR_C_SAD_L,
+			      c_addr & 0xffff);
 	}
 }
 
@@ -195,70 +191,70 @@ static void resizer_configure(struct iss_resizer_device *resizer)
 	outformat = &resizer->formats[RESIZER_PAD_SOURCE_MEM];
 
 	/* Make sure we don't bypass the resizer */
-	writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_SRC_FMT0) &
-		~RSZ_SRC_FMT0_BYPASS,
-		iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_SRC_FMT0);
+	iss_reg_clr(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_SRC_FMT0,
+		    RSZ_SRC_FMT0_BYPASS);
 
 	/* Select RSZ input */
-	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_SRC_FMT0) &
-		~RSZ_SRC_FMT0_SEL) |
-		(resizer->input == RESIZER_INPUT_IPIPEIF ? RSZ_SRC_FMT0_SEL : 0),
-		iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_SRC_FMT0);
+	iss_reg_update(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_SRC_FMT0,
+		       RSZ_SRC_FMT0_SEL,
+		       resizer->input == RESIZER_INPUT_IPIPEIF ?
+		       RSZ_SRC_FMT0_SEL : 0);
 
 	/* RSZ ignores WEN signal from IPIPE/IPIPEIF */
-	writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_SRC_MODE) &
-		~RSZ_SRC_MODE_WRT,
-		iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_SRC_MODE);
+	iss_reg_clr(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_SRC_MODE,
+		    RSZ_SRC_MODE_WRT);
 
 	/* Set Resizer in free-running mode */
-	writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_SRC_MODE) &
-		~RSZ_SRC_MODE_OST,
-		iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_SRC_MODE);
+	iss_reg_clr(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_SRC_MODE,
+		    RSZ_SRC_MODE_OST);
 
 	/* Init Resizer A */
-	writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_MODE) &
-		~RZA_MODE_ONE_SHOT,
-		iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_MODE);
+	iss_reg_clr(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_MODE,
+		    RZA_MODE_ONE_SHOT);
 
 	/* Set size related things now */
-	writel(0, iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_SRC_VPS);
-	writel(0, iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_SRC_HPS);
-	writel(informat->height - 2, iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_SRC_VSZ);
-	writel(informat->width - 1, iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_SRC_HSZ);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_SRC_VPS, 0);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_SRC_HPS, 0);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_SRC_VSZ,
+		      informat->height - 2);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_SRC_HSZ,
+		      informat->width - 1);
 
-	writel(0, iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_I_VPS);
-	writel(0, iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_I_HPS);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_I_VPS, 0);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_I_HPS, 0);
 
-	writel(outformat->height - 2, iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_O_VSZ);
-	writel(outformat->width - 1, iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_O_HSZ);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_O_VSZ,
+		      outformat->height - 2);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_O_HSZ,
+		      outformat->width - 1);
 
-	writel(0x100, iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_V_DIF);
-	writel(0x100, iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_H_DIF);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_V_DIF, 0x100);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_H_DIF, 0x100);
 
 	/* Buffer output settings */
-	writel(0, iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_SDR_Y_PTR_S);
-	writel(outformat->height - 1,
-		iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_SDR_Y_PTR_E);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_SDR_Y_PTR_S, 0);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_SDR_Y_PTR_E,
+		      outformat->height - 1);
 
-	writel(resizer->video_out.bpl_value,
-		iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_SDR_Y_OFT);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_SDR_Y_OFT,
+		      resizer->video_out.bpl_value);
 
 	/* UYVY -> NV12 conversion */
 	if ((informat->code == V4L2_MBUS_FMT_UYVY8_1X16) &&
 	    (outformat->code == V4L2_MBUS_FMT_YUYV8_1_5X8)) {
-		writel(RSZ_420_CEN | RSZ_420_YEN,
-			iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_420);
+		iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_420,
+			      RSZ_420_CEN | RSZ_420_YEN);
 
 		/* UV Buffer output settings */
-		writel(0, iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_SDR_C_PTR_S);
-		writel(outformat->height - 1,
-			iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_SDR_C_PTR_E);
+		iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_SDR_C_PTR_S,
+			      0);
+		iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_SDR_C_PTR_E,
+			      outformat->height - 1);
 
-		writel(resizer->video_out.bpl_value,
-			iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_SDR_C_OFT);
+		iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_SDR_C_OFT,
+			      resizer->video_out.bpl_value);
 	} else {
-		writel(0,
-			iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_420);
+		iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_420, 0);
 	}
 
 	omap4iss_isp_enable_interrupts(iss);
@@ -273,9 +269,7 @@ static void resizer_isr_buffer(struct iss_resizer_device *resizer)
 	struct iss_device *iss = to_iss_device(resizer);
 	struct iss_buffer *buffer;
 
-	writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_EN) &
-		~RSZ_EN_EN,
-		iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_EN);
+	iss_reg_clr(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_EN, RSZ_EN_EN);
 
 	buffer = omap4iss_video_buffer_next(&resizer->video_out);
 	if (buffer == NULL)
@@ -283,9 +277,7 @@ static void resizer_isr_buffer(struct iss_resizer_device *resizer)
 
 	resizer_set_outaddr(resizer, buffer->iss_addr);
 
-	writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_EN) |
-		RSZ_EN_EN,
-		iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_EN);
+	iss_reg_set(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_EN, RSZ_EN_EN);
 }
 
 /*
@@ -386,17 +378,14 @@ static int resizer_set_stream(struct v4l2_subdev *sd, int enable)
 
 		omap4iss_isp_subclk_enable(iss, OMAP4_ISS_ISP_SUBCLK_RSZ);
 
-		writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_GCK_MMR) |
-			RSZ_GCK_MMR_MMR,
-			iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_GCK_MMR);
-		writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_GCK_SDR) |
-			RSZ_GCK_SDR_CORE,
-			iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_GCK_SDR);
+		iss_reg_set(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_GCK_MMR,
+			    RSZ_GCK_MMR_MMR);
+		iss_reg_set(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_GCK_SDR,
+			    RSZ_GCK_SDR_CORE);
 
 		/* FIXME: Enable RSZB also */
-		writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_SYSCONFIG) |
-			RSZ_SYSCONFIG_RSZA_CLK_EN,
-			iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_SYSCONFIG);
+		iss_reg_set(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_SYSCONFIG,
+			    RSZ_SYSCONFIG_RSZA_CLK_EN);
 	}
 
 	switch (enable) {
@@ -430,15 +419,12 @@ static int resizer_set_stream(struct v4l2_subdev *sd, int enable)
 
 		resizer_enable(resizer, 0);
 		omap4iss_isp_disable_interrupts(iss);
-		writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_SYSCONFIG) &
-			~RSZ_SYSCONFIG_RSZA_CLK_EN,
-			iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_SYSCONFIG);
-		writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_GCK_SDR) &
-			~RSZ_GCK_SDR_CORE,
-			iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_GCK_SDR);
-		writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_GCK_MMR) &
-			~RSZ_GCK_MMR_MMR,
-			iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_GCK_MMR);
+		iss_reg_clr(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_SYSCONFIG,
+			    RSZ_SYSCONFIG_RSZA_CLK_EN);
+		iss_reg_clr(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_GCK_SDR,
+			    RSZ_GCK_SDR_CORE);
+		iss_reg_clr(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_GCK_MMR,
+			    RSZ_GCK_MMR_MMR);
 		omap4iss_isp_subclk_disable(iss, OMAP4_ISS_ISP_SUBCLK_RSZ);
 		iss_video_dmaqueue_flags_clr(video_out);
 		break;
-- 
1.8.3.2

