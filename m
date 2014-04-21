Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39188 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaDUN71 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 09:59:27 -0400
Received: from avalon.ideasonboard.com (147.20-200-80.adsl-dyn.isp.belgacom.be [80.200.20.147])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 447FF359AC
	for <linux-media@vger.kernel.org>; Mon, 21 Apr 2014 15:57:15 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] omap4iss: Use a common macro for all sleep-based poll loops
Date: Mon, 21 Apr 2014 15:59:30 +0200
Message-Id: <1398088771-6375-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of implementing usleep_range-based poll loops manually (and
slightly differently), create a generic iss_poll_wait_timeout() macro
and use it through the driver.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c      | 46 ++++++++++++++-----------------
 drivers/staging/media/omap4iss/iss.h      | 14 ++++++++++
 drivers/staging/media/omap4iss/iss_csi2.c | 39 ++++++++------------------
 3 files changed, 45 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 219519d..217d719 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -734,18 +734,17 @@ static int iss_pipeline_is_last(struct media_entity *me)
 
 static int iss_reset(struct iss_device *iss)
 {
-	unsigned long timeout = 0;
+	unsigned int timeout;
 
 	iss_reg_set(iss, OMAP4_ISS_MEM_TOP, ISS_HL_SYSCONFIG,
 		    ISS_HL_SYSCONFIG_SOFTRESET);
 
-	while (iss_reg_read(iss, OMAP4_ISS_MEM_TOP, ISS_HL_SYSCONFIG) &
-	       ISS_HL_SYSCONFIG_SOFTRESET) {
-		if (timeout++ > 100) {
-			dev_alert(iss->dev, "cannot reset ISS\n");
-			return -ETIMEDOUT;
-		}
-		usleep_range(10, 10);
+	timeout = iss_poll_condition_timeout(
+		!(iss_reg_read(iss, OMAP4_ISS_MEM_TOP, ISS_HL_SYSCONFIG) &
+		ISS_HL_SYSCONFIG_SOFTRESET), 1000, 10, 10);
+	if (timeout) {
+		dev_err(iss->dev, "ISS reset timeout\n");
+		return -ETIMEDOUT;
 	}
 
 	iss->crashed = 0;
@@ -754,7 +753,7 @@ static int iss_reset(struct iss_device *iss)
 
 static int iss_isp_reset(struct iss_device *iss)
 {
-	unsigned long timeout = 0;
+	unsigned int timeout;
 
 	/* Fist, ensure that the ISP is IDLE (no transactions happening) */
 	iss_reg_update(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_SYSCONFIG,
@@ -763,29 +762,24 @@ static int iss_isp_reset(struct iss_device *iss)
 
 	iss_reg_set(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_CTRL, ISP5_CTRL_MSTANDBY);
 
-	for (;;) {
-		if (iss_reg_read(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_CTRL) &
-		    ISP5_CTRL_MSTANDBY_WAIT)
-			break;
-		if (timeout++ > 1000) {
-			dev_alert(iss->dev, "cannot set ISP5 to standby\n");
-			return -ETIMEDOUT;
-		}
-		usleep_range(1000, 1500);
+	timeout = iss_poll_condition_timeout(
+		iss_reg_read(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_CTRL) &
+		ISP5_CTRL_MSTANDBY_WAIT, 1000000, 1000, 1500);
+	if (timeout) {
+		dev_err(iss->dev, "ISP5 standby timeout\n");
+		return -ETIMEDOUT;
 	}
 
 	/* Now finally, do the reset */
 	iss_reg_set(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_SYSCONFIG,
 		    ISP5_SYSCONFIG_SOFTRESET);
 
-	timeout = 0;
-	while (iss_reg_read(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_SYSCONFIG) &
-	       ISP5_SYSCONFIG_SOFTRESET) {
-		if (timeout++ > 1000) {
-			dev_alert(iss->dev, "cannot reset ISP5\n");
-			return -ETIMEDOUT;
-		}
-		usleep_range(1000, 1500);
+	timeout = iss_poll_condition_timeout(
+		!(iss_reg_read(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_SYSCONFIG) &
+		ISP5_SYSCONFIG_SOFTRESET), 1000000, 1000, 1500);
+	if (timeout) {
+		dev_err(iss->dev, "ISP5 reset timeout\n");
+		return -ETIMEDOUT;
 	}
 
 	return 0;
diff --git a/drivers/staging/media/omap4iss/iss.h b/drivers/staging/media/omap4iss/iss.h
index 346db92..05cd9bf 100644
--- a/drivers/staging/media/omap4iss/iss.h
+++ b/drivers/staging/media/omap4iss/iss.h
@@ -233,4 +233,18 @@ void iss_reg_update(struct iss_device *iss, enum iss_mem_resources res,
 	iss_reg_write(iss, res, offset, (v & ~clr) | set);
 }
 
+#define iss_poll_condition_timeout(cond, timeout, min_ival, max_ival)	\
+({									\
+	unsigned long __timeout = jiffies + usecs_to_jiffies(timeout);	\
+	unsigned int __min_ival = (min_ival);				\
+	unsigned int __max_ival = (max_ival);				\
+	bool __cond;							\
+	while (!(__cond = (cond))) {					\
+		if (time_after(jiffies, __timeout))			\
+			break;						\
+		usleep_range(__min_ival, __max_ival);			\
+	}								\
+	!__cond;							\
+})
+
 #endif /* _OMAP4_ISS_H_ */
diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index 61fc350..3296115 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -487,9 +487,7 @@ static void csi2_irq_status_set(struct iss_csi2_device *csi2, int enable)
  */
 int omap4iss_csi2_reset(struct iss_csi2_device *csi2)
 {
-	u8 soft_reset_retries = 0;
-	u32 reg;
-	int i;
+	unsigned int timeout;
 
 	if (!csi2->available)
 		return -ENODEV;
@@ -500,37 +498,22 @@ int omap4iss_csi2_reset(struct iss_csi2_device *csi2)
 	iss_reg_set(csi2->iss, csi2->regs1, CSI2_SYSCONFIG,
 		    CSI2_SYSCONFIG_SOFT_RESET);
 
-	do {
-		reg = iss_reg_read(csi2->iss, csi2->regs1, CSI2_SYSSTATUS)
-		    & CSI2_SYSSTATUS_RESET_DONE;
-		if (reg == CSI2_SYSSTATUS_RESET_DONE)
-			break;
-		soft_reset_retries++;
-		if (soft_reset_retries < 5)
-			usleep_range(100, 100);
-	} while (soft_reset_retries < 5);
-
-	if (soft_reset_retries == 5) {
-		dev_err(csi2->iss->dev,
-			"CSI2: Soft reset try count exceeded!\n");
+	timeout = iss_poll_condition_timeout(
+		iss_reg_read(csi2->iss, csi2->regs1, CSI2_SYSSTATUS) &
+		CSI2_SYSSTATUS_RESET_DONE, 500, 100, 100);
+	if (timeout) {
+		dev_err(csi2->iss->dev, "CSI2: Soft reset timeout!\n");
 		return -EBUSY;
 	}
 
 	iss_reg_set(csi2->iss, csi2->regs1, CSI2_COMPLEXIO_CFG,
 		    CSI2_COMPLEXIO_CFG_RESET_CTRL);
 
-	i = 100;
-	do {
-		reg = iss_reg_read(csi2->iss, csi2->phy->phy_regs, REGISTER1)
-		    & REGISTER1_RESET_DONE_CTRLCLK;
-		if (reg == REGISTER1_RESET_DONE_CTRLCLK)
-			break;
-		usleep_range(100, 100);
-	} while (--i > 0);
-
-	if (i == 0) {
-		dev_err(csi2->iss->dev,
-			"CSI2: Reset for CSI2_96M_FCLK domain Failed!\n");
+	timeout = iss_poll_condition_timeout(
+		iss_reg_read(csi2->iss, csi2->phy->phy_regs, REGISTER1) &
+		REGISTER1_RESET_DONE_CTRLCLK, 10000, 100, 100);
+	if (timeout) {
+		dev_err(csi2->iss->dev, "CSI2: CSI2_96M_FCLK reset timeout!\n");
 		return -EBUSY;
 	}
 
-- 
1.8.3.2

