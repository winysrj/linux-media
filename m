Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44099 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab3LDA4d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:33 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 34BF3366A2
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:40 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 14/25] v4l: omap4iss: csi: Create and use register access functions
Date: Wed,  4 Dec 2013 01:56:14 +0100
Message-Id: <1386118585-12449-15-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the direct readl/writel calls with helper functions.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_csi2.c   | 122 +++++++++++++---------------
 drivers/staging/media/omap4iss/iss_csi2.h   |   6 +-
 drivers/staging/media/omap4iss/iss_csiphy.c |  27 +++---
 drivers/staging/media/omap4iss/iss_csiphy.h |   6 +-
 4 files changed, 76 insertions(+), 85 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index ac5868ac..f8d6472 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -29,9 +29,8 @@ static void csi2_if_enable(struct iss_csi2_device *csi2, u8 enable)
 {
 	struct iss_csi2_ctrl_cfg *currctrl = &csi2->ctrl;
 
-	writel((readl(csi2->regs1 + CSI2_CTRL) & ~CSI2_CTRL_IF_EN) |
-		(enable ? CSI2_CTRL_IF_EN : 0),
-		csi2->regs1 + CSI2_CTRL);
+	iss_reg_update(csi2->iss, csi2->regs1, CSI2_CTRL, CSI2_CTRL_IF_EN,
+		       enable ? CSI2_CTRL_IF_EN : 0);
 
 	currctrl->if_enable = enable;
 }
@@ -90,7 +89,7 @@ static void csi2_recv_config(struct iss_csi2_device *csi2,
 	 */
 	reg |= CSI2_CTRL_ENDIANNESS;
 
-	writel(reg, csi2->regs1 + CSI2_CTRL);
+	iss_reg_write(csi2->iss, csi2->regs1, CSI2_CTRL, reg);
 }
 
 static const unsigned int csi2_input_fmts[] = {
@@ -260,10 +259,10 @@ static void csi2_set_outaddr(struct iss_csi2_device *csi2, u32 addr)
 
 	ctx->ping_addr = addr;
 	ctx->pong_addr = addr;
-	writel(ctx->ping_addr,
-	       csi2->regs1 + CSI2_CTX_PING_ADDR(ctx->ctxnum));
-	writel(ctx->pong_addr,
-	       csi2->regs1 + CSI2_CTX_PONG_ADDR(ctx->ctxnum));
+	iss_reg_write(csi2->iss, csi2->regs1, CSI2_CTX_PING_ADDR(ctx->ctxnum),
+		      ctx->ping_addr);
+	iss_reg_write(csi2->iss, csi2->regs1, CSI2_CTX_PONG_ADDR(ctx->ctxnum),
+		      ctx->pong_addr);
 }
 
 /*
@@ -288,7 +287,7 @@ static void csi2_ctx_enable(struct iss_csi2_device *csi2, u8 ctxnum, u8 enable)
 	struct iss_csi2_ctx_cfg *ctx = &csi2->contexts[ctxnum];
 	u32 reg;
 
-	reg = readl(csi2->regs1 + CSI2_CTX_CTRL1(ctxnum));
+	reg = iss_reg_read(csi2->iss, csi2->regs1, CSI2_CTX_CTRL1(ctxnum));
 
 	if (enable) {
 		unsigned int skip = 0;
@@ -306,7 +305,7 @@ static void csi2_ctx_enable(struct iss_csi2_device *csi2, u8 ctxnum, u8 enable)
 		reg &= ~CSI2_CTX_CTRL1_CTX_EN;
 	}
 
-	writel(reg, csi2->regs1 + CSI2_CTX_CTRL1(ctxnum));
+	iss_reg_write(csi2->iss, csi2->regs1, CSI2_CTX_CTRL1(ctxnum), reg);
 	ctx->enabled = enable;
 }
 
@@ -330,7 +329,7 @@ static void csi2_ctx_config(struct iss_csi2_device *csi2,
 	if (ctx->checksum_enabled)
 		reg |= CSI2_CTX_CTRL1_CS_EN;
 
-	writel(reg, csi2->regs1 + CSI2_CTX_CTRL1(ctx->ctxnum));
+	iss_reg_write(csi2->iss, csi2->regs1, CSI2_CTX_CTRL1(ctx->ctxnum), reg);
 
 	/* Set up CSI2_CTx_CTRL2 */
 	reg = ctx->virtual_id << CSI2_CTX_CTRL2_VIRTUAL_ID_SHIFT;
@@ -342,23 +341,20 @@ static void csi2_ctx_config(struct iss_csi2_device *csi2,
 	if (is_usr_def_mapping(ctx->format_id))
 		reg |= 2 << CSI2_CTX_CTRL2_USER_DEF_MAP_SHIFT;
 
-	writel(reg, csi2->regs1 + CSI2_CTX_CTRL2(ctx->ctxnum));
+	iss_reg_write(csi2->iss, csi2->regs1, CSI2_CTX_CTRL2(ctx->ctxnum), reg);
 
 	/* Set up CSI2_CTx_CTRL3 */
-	writel(ctx->alpha << CSI2_CTX_CTRL3_ALPHA_SHIFT,
-		csi2->regs1 + CSI2_CTX_CTRL3(ctx->ctxnum));
+	iss_reg_write(csi2->iss, csi2->regs1, CSI2_CTX_CTRL3(ctx->ctxnum),
+		      ctx->alpha << CSI2_CTX_CTRL3_ALPHA_SHIFT);
 
 	/* Set up CSI2_CTx_DAT_OFST */
-	reg = readl(csi2->regs1 + CSI2_CTX_DAT_OFST(ctx->ctxnum));
-	reg &= ~CSI2_CTX_DAT_OFST_MASK;
-	reg |= ctx->data_offset;
-	writel(reg, csi2->regs1 + CSI2_CTX_DAT_OFST(ctx->ctxnum));
+	iss_reg_update(csi2->iss, csi2->regs1, CSI2_CTX_DAT_OFST(ctx->ctxnum),
+		       CSI2_CTX_DAT_OFST_MASK, ctx->data_offset);
 
-	writel(ctx->ping_addr,
-		       csi2->regs1 + CSI2_CTX_PING_ADDR(ctx->ctxnum));
-
-	writel(ctx->pong_addr,
-		       csi2->regs1 + CSI2_CTX_PONG_ADDR(ctx->ctxnum));
+	iss_reg_write(csi2->iss, csi2->regs1, CSI2_CTX_PING_ADDR(ctx->ctxnum),
+		      ctx->ping_addr);
+	iss_reg_write(csi2->iss, csi2->regs1, CSI2_CTX_PONG_ADDR(ctx->ctxnum),
+		      ctx->pong_addr);
 }
 
 /*
@@ -370,7 +366,7 @@ static void csi2_timing_config(struct iss_csi2_device *csi2,
 {
 	u32 reg;
 
-	reg = readl(csi2->regs1 + CSI2_TIMING);
+	reg = iss_reg_read(csi2->iss, csi2->regs1, CSI2_TIMING);
 
 	if (timing->force_rx_mode)
 		reg |= CSI2_TIMING_FORCE_RX_MODE_IO1;
@@ -391,7 +387,7 @@ static void csi2_timing_config(struct iss_csi2_device *csi2,
 	reg |= timing->stop_state_counter <<
 	       CSI2_TIMING_STOP_STATE_COUNTER_IO1_SHIFT;
 
-	writel(reg, csi2->regs1 + CSI2_TIMING);
+	iss_reg_write(csi2->iss, csi2->regs1, CSI2_TIMING, reg);
 }
 
 /*
@@ -407,14 +403,14 @@ static void csi2_irq_ctx_set(struct iss_csi2_device *csi2, int enable)
 		reg |= CSI2_CTX_IRQ_FS;
 
 	for (i = 0; i < 8; i++) {
-		writel(reg, csi2->regs1 + CSI2_CTX_IRQSTATUS(i));
+		iss_reg_write(csi2->iss, csi2->regs1, CSI2_CTX_IRQSTATUS(i),
+			      reg);
 		if (enable)
-			writel(readl(csi2->regs1 + CSI2_CTX_IRQENABLE(i)) | reg,
-				csi2->regs1 + CSI2_CTX_IRQENABLE(i));
+			iss_reg_set(csi2->iss, csi2->regs1,
+				    CSI2_CTX_IRQENABLE(i), reg);
 		else
-			writel(readl(csi2->regs1 + CSI2_CTX_IRQENABLE(i)) &
-				~reg,
-				csi2->regs1 + CSI2_CTX_IRQENABLE(i));
+			iss_reg_clr(csi2->iss, csi2->regs1,
+				    CSI2_CTX_IRQENABLE(i), reg);
 	}
 }
 
@@ -452,12 +448,13 @@ static void csi2_irq_complexio1_set(struct iss_csi2_device *csi2, int enable)
 		CSI2_COMPLEXIO_IRQ_ERRESC1 |
 		CSI2_COMPLEXIO_IRQ_ERRSOTSYNCHS1 |
 		CSI2_COMPLEXIO_IRQ_ERRSOTHS1;
-	writel(reg, csi2->regs1 + CSI2_COMPLEXIO_IRQSTATUS);
+	iss_reg_write(csi2->iss, csi2->regs1, CSI2_COMPLEXIO_IRQSTATUS, reg);
 	if (enable)
-		reg |= readl(csi2->regs1 + CSI2_COMPLEXIO_IRQENABLE);
+		iss_reg_set(csi2->iss, csi2->regs1, CSI2_COMPLEXIO_IRQENABLE,
+			    reg);
 	else
-		reg = 0;
-	writel(reg, csi2->regs1 + CSI2_COMPLEXIO_IRQENABLE);
+		iss_reg_write(csi2->iss, csi2->regs1, CSI2_COMPLEXIO_IRQENABLE,
+			      0);
 }
 
 /*
@@ -474,13 +471,11 @@ static void csi2_irq_status_set(struct iss_csi2_device *csi2, int enable)
 		CSI2_IRQ_COMPLEXIO_ERR |
 		CSI2_IRQ_FIFO_OVF |
 		CSI2_IRQ_CONTEXT0;
-	writel(reg, csi2->regs1 + CSI2_IRQSTATUS);
+	iss_reg_write(csi2->iss, csi2->regs1, CSI2_IRQSTATUS, reg);
 	if (enable)
-		reg |= readl(csi2->regs1 + CSI2_IRQENABLE);
+		iss_reg_set(csi2->iss, csi2->regs1, CSI2_IRQENABLE, reg);
 	else
-		reg = 0;
-
-	writel(reg, csi2->regs1 + CSI2_IRQENABLE);
+		iss_reg_write(csi2->iss, csi2->regs1, CSI2_IRQENABLE, 0);
 }
 
 /*
@@ -502,13 +497,12 @@ int omap4iss_csi2_reset(struct iss_csi2_device *csi2)
 	if (csi2->phy->phy_in_use)
 		return -EBUSY;
 
-	writel(readl(csi2->regs1 + CSI2_SYSCONFIG) |
-		CSI2_SYSCONFIG_SOFT_RESET,
-		csi2->regs1 + CSI2_SYSCONFIG);
+	iss_reg_set(csi2->iss, csi2->regs1, CSI2_SYSCONFIG,
+		    CSI2_SYSCONFIG_SOFT_RESET);
 
 	do {
-		reg = readl(csi2->regs1 + CSI2_SYSSTATUS) &
-				    CSI2_SYSSTATUS_RESET_DONE;
+		reg = iss_reg_read(csi2->iss, csi2->regs1, CSI2_SYSSTATUS)
+		    & CSI2_SYSSTATUS_RESET_DONE;
 		if (reg == CSI2_SYSSTATUS_RESET_DONE)
 			break;
 		soft_reset_retries++;
@@ -522,13 +516,12 @@ int omap4iss_csi2_reset(struct iss_csi2_device *csi2)
 		return -EBUSY;
 	}
 
-	writel(readl(csi2->regs1 + CSI2_COMPLEXIO_CFG) |
-		CSI2_COMPLEXIO_CFG_RESET_CTRL,
-		csi2->regs1 + CSI2_COMPLEXIO_CFG);
+	iss_reg_set(csi2->iss, csi2->regs1, CSI2_COMPLEXIO_CFG,
+		    CSI2_COMPLEXIO_CFG_RESET_CTRL);
 
 	i = 100;
 	do {
-		reg = readl(csi2->phy->phy_regs + REGISTER1)
+		reg = iss_reg_read(csi2->iss, csi2->phy->phy_regs, REGISTER1)
 		    & REGISTER1_RESET_DONE_CTRLCLK;
 		if (reg == REGISTER1_RESET_DONE_CTRLCLK)
 			break;
@@ -541,11 +534,10 @@ int omap4iss_csi2_reset(struct iss_csi2_device *csi2)
 		return -EBUSY;
 	}
 
-	writel((readl(csi2->regs1 + CSI2_SYSCONFIG) &
-		~(CSI2_SYSCONFIG_MSTANDBY_MODE_MASK |
-		  CSI2_SYSCONFIG_AUTO_IDLE)) |
-		CSI2_SYSCONFIG_MSTANDBY_MODE_NO,
-		csi2->regs1 + CSI2_SYSCONFIG);
+	iss_reg_update(csi2->iss, csi2->regs1, CSI2_SYSCONFIG,
+		       CSI2_SYSCONFIG_MSTANDBY_MODE_MASK |
+		       CSI2_SYSCONFIG_AUTO_IDLE,
+		       CSI2_SYSCONFIG_MSTANDBY_MODE_NO);
 
 	return 0;
 }
@@ -627,7 +619,7 @@ static int csi2_configure(struct iss_csi2_device *csi2)
  */
 #define CSI2_PRINT_REGISTER(iss, regs, name)\
 	dev_dbg(iss->dev, "###CSI2 " #name "=0x%08x\n", \
-		readl(regs + CSI2_##name))
+		iss_reg_read(iss, regs, CSI2_##name))
 
 static void csi2_print_status(struct iss_csi2_device *csi2)
 {
@@ -695,8 +687,8 @@ static void csi2_isr_ctx(struct iss_csi2_device *csi2,
 	unsigned int n = ctx->ctxnum;
 	u32 status;
 
-	status = readl(csi2->regs1 + CSI2_CTX_IRQSTATUS(n));
-	writel(status, csi2->regs1 + CSI2_CTX_IRQSTATUS(n));
+	status = iss_reg_read(csi2->iss, csi2->regs1, CSI2_CTX_IRQSTATUS(n));
+	iss_reg_write(csi2->iss, csi2->regs1, CSI2_CTX_IRQSTATUS(n), status);
 
 	/* Propagate frame number */
 	if (status & CSI2_CTX_IRQ_FS) {
@@ -745,15 +737,15 @@ void omap4iss_csi2_isr(struct iss_csi2_device *csi2)
 	if (!csi2->available)
 		return;
 
-	csi2_irqstatus = readl(csi2->regs1 + CSI2_IRQSTATUS);
-	writel(csi2_irqstatus, csi2->regs1 + CSI2_IRQSTATUS);
+	csi2_irqstatus = iss_reg_read(csi2->iss, csi2->regs1, CSI2_IRQSTATUS);
+	iss_reg_write(csi2->iss, csi2->regs1, CSI2_IRQSTATUS, csi2_irqstatus);
 
 	/* Failure Cases */
 	if (csi2_irqstatus & CSI2_IRQ_COMPLEXIO_ERR) {
-		cpxio1_irqstatus = readl(csi2->regs1 +
-					 CSI2_COMPLEXIO_IRQSTATUS);
-		writel(cpxio1_irqstatus,
-			csi2->regs1 + CSI2_COMPLEXIO_IRQSTATUS);
+		cpxio1_irqstatus = iss_reg_read(csi2->iss, csi2->regs1,
+						CSI2_COMPLEXIO_IRQSTATUS);
+		iss_reg_write(csi2->iss, csi2->regs1, CSI2_COMPLEXIO_IRQSTATUS,
+			      cpxio1_irqstatus);
 		dev_dbg(iss->dev, "CSI2: ComplexIO Error IRQ %x\n",
 			cpxio1_irqstatus);
 		pipe->error = true;
@@ -1319,7 +1311,7 @@ int omap4iss_csi2_init(struct iss_device *iss)
 
 	csi2a->iss = iss;
 	csi2a->available = 1;
-	csi2a->regs1 = iss->regs[OMAP4_ISS_MEM_CSI2_A_REGS1];
+	csi2a->regs1 = OMAP4_ISS_MEM_CSI2_A_REGS1;
 	csi2a->phy = &iss->csiphy1;
 	csi2a->state = ISS_PIPELINE_STREAM_STOPPED;
 	init_waitqueue_head(&csi2a->wait);
@@ -1330,7 +1322,7 @@ int omap4iss_csi2_init(struct iss_device *iss)
 
 	csi2b->iss = iss;
 	csi2b->available = 1;
-	csi2b->regs1 = iss->regs[OMAP4_ISS_MEM_CSI2_B_REGS1];
+	csi2b->regs1 = OMAP4_ISS_MEM_CSI2_B_REGS1;
 	csi2b->phy = &iss->csiphy2;
 	csi2b->state = ISS_PIPELINE_STREAM_STOPPED;
 	init_waitqueue_head(&csi2b->wait);
diff --git a/drivers/staging/media/omap4iss/iss_csi2.h b/drivers/staging/media/omap4iss/iss_csi2.h
index d1d077b..69a6263 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.h
+++ b/drivers/staging/media/omap4iss/iss_csi2.h
@@ -128,9 +128,9 @@ struct iss_csi2_device {
 
 	u8 available;		/* Is the IP present on the silicon? */
 
-	/* Pointer to register remaps into kernel space */
-	void __iomem *regs1;
-	void __iomem *regs2;
+	/* memory resources, as defined in enum iss_mem_resources */
+	unsigned int regs1;
+	unsigned int regs2;
 
 	u32 output; /* output to IPIPEIF, memory or both? */
 	bool dpcm_decompress;
diff --git a/drivers/staging/media/omap4iss/iss_csiphy.c b/drivers/staging/media/omap4iss/iss_csiphy.c
index d5c7cec..902391a 100644
--- a/drivers/staging/media/omap4iss/iss_csiphy.c
+++ b/drivers/staging/media/omap4iss/iss_csiphy.c
@@ -31,7 +31,7 @@ static void csiphy_lanes_config(struct iss_csiphy *phy)
 	unsigned int i;
 	u32 reg;
 
-	reg = readl(phy->cfg_regs + CSI2_COMPLEXIO_CFG);
+	reg = iss_reg_read(phy->iss, phy->cfg_regs, CSI2_COMPLEXIO_CFG);
 
 	for (i = 0; i < phy->max_data_lanes; i++) {
 		reg &= ~(CSI2_COMPLEXIO_CFG_DATA_POL(i + 1) |
@@ -47,7 +47,7 @@ static void csiphy_lanes_config(struct iss_csiphy *phy)
 	reg |= phy->lanes.clk.pol ? CSI2_COMPLEXIO_CFG_CLOCK_POL : 0;
 	reg |= phy->lanes.clk.pos << CSI2_COMPLEXIO_CFG_CLOCK_POSITION_SHIFT;
 
-	writel(reg, phy->cfg_regs + CSI2_COMPLEXIO_CFG);
+	iss_reg_write(phy->iss, phy->cfg_regs, CSI2_COMPLEXIO_CFG, reg);
 }
 
 /*
@@ -61,16 +61,15 @@ static int csiphy_set_power(struct iss_csiphy *phy, u32 power)
 	u32 reg;
 	u8 retry_count;
 
-	writel((readl(phy->cfg_regs + CSI2_COMPLEXIO_CFG) &
-		~CSI2_COMPLEXIO_CFG_PWD_CMD_MASK) |
-	       power | CSI2_COMPLEXIO_CFG_PWR_AUTO,
-	       phy->cfg_regs + CSI2_COMPLEXIO_CFG);
+	iss_reg_update(phy->iss, phy->cfg_regs, CSI2_COMPLEXIO_CFG,
+		       CSI2_COMPLEXIO_CFG_PWD_CMD_MASK,
+		       power | CSI2_COMPLEXIO_CFG_PWR_AUTO);
 
 	retry_count = 0;
 	do {
 		udelay(1);
-		reg = readl(phy->cfg_regs + CSI2_COMPLEXIO_CFG) &
-				CSI2_COMPLEXIO_CFG_PWD_STATUS_MASK;
+		reg = iss_reg_read(phy->iss, phy->cfg_regs, CSI2_COMPLEXIO_CFG)
+		    & CSI2_COMPLEXIO_CFG_PWD_STATUS_MASK;
 
 		if (reg != power >> 2)
 			retry_count++;
@@ -98,7 +97,7 @@ static void csiphy_dphy_config(struct iss_csiphy *phy)
 	reg = phy->dphy.ths_term << REGISTER0_THS_TERM_SHIFT;
 	reg |= phy->dphy.ths_settle << REGISTER0_THS_SETTLE_SHIFT;
 
-	writel(reg, phy->phy_regs + REGISTER0);
+	iss_reg_write(phy->iss, phy->phy_regs, REGISTER0, reg);
 
 	/* Set up REGISTER1 */
 	reg = phy->dphy.tclk_term << REGISTER1_TCLK_TERM_SHIFT;
@@ -106,7 +105,7 @@ static void csiphy_dphy_config(struct iss_csiphy *phy)
 	reg |= phy->dphy.tclk_settle << REGISTER1_TCLK_SETTLE_SHIFT;
 	reg |= 0xB8 << REGISTER1_DPHY_HS_SYNC_PATTERN_SHIFT;
 
-	writel(reg, phy->phy_regs + REGISTER1);
+	iss_reg_write(phy->iss, phy->phy_regs, REGISTER1, reg);
 }
 
 /*
@@ -264,16 +263,16 @@ int omap4iss_csiphy_init(struct iss_device *iss)
 	phy1->csi2 = &iss->csi2a;
 	phy1->max_data_lanes = ISS_CSIPHY1_NUM_DATA_LANES;
 	phy1->used_data_lanes = 0;
-	phy1->cfg_regs = iss->regs[OMAP4_ISS_MEM_CSI2_A_REGS1];
-	phy1->phy_regs = iss->regs[OMAP4_ISS_MEM_CAMERARX_CORE1];
+	phy1->cfg_regs = OMAP4_ISS_MEM_CSI2_A_REGS1;
+	phy1->phy_regs = OMAP4_ISS_MEM_CAMERARX_CORE1;
 	mutex_init(&phy1->mutex);
 
 	phy2->iss = iss;
 	phy2->csi2 = &iss->csi2b;
 	phy2->max_data_lanes = ISS_CSIPHY2_NUM_DATA_LANES;
 	phy2->used_data_lanes = 0;
-	phy2->cfg_regs = iss->regs[OMAP4_ISS_MEM_CSI2_B_REGS1];
-	phy2->phy_regs = iss->regs[OMAP4_ISS_MEM_CAMERARX_CORE2];
+	phy2->cfg_regs = OMAP4_ISS_MEM_CSI2_B_REGS1;
+	phy2->phy_regs = OMAP4_ISS_MEM_CAMERARX_CORE2;
 	mutex_init(&phy2->mutex);
 
 	return 0;
diff --git a/drivers/staging/media/omap4iss/iss_csiphy.h b/drivers/staging/media/omap4iss/iss_csiphy.h
index df63eda..e9ca439 100644
--- a/drivers/staging/media/omap4iss/iss_csiphy.h
+++ b/drivers/staging/media/omap4iss/iss_csiphy.h
@@ -32,9 +32,9 @@ struct iss_csiphy {
 	u8 phy_in_use;
 	struct iss_csi2_device *csi2;
 
-	/* Pointer to register remaps into kernel space */
-	void __iomem *cfg_regs;
-	void __iomem *phy_regs;
+	/* memory resources, as defined in enum iss_mem_resources */
+	unsigned int cfg_regs;
+	unsigned int phy_regs;
 
 	u8 max_data_lanes;	/* number of CSI2 Data Lanes supported */
 	u8 used_data_lanes;	/* number of CSI2 Data Lanes used */
-- 
1.8.3.2

