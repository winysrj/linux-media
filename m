Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53164 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752572AbeFAU0r (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 16:26:47 -0400
From: Vikash Garodia <vgarodia@codeaurora.org>
To: hverkuil@xs4all.nl, mchehab@kernel.org, robh@kernel.org,
        mark.rutland@arm.com, andy.gross@linaro.org,
        bjorn.andersson@linaro.org, stanimir.varbanov@linaro.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, vgarodia@codeaurora.org,
        acourbot@chromium.org
Subject: [PATCH v2 1/5] media: venus: add a routine to reset ARM9
Date: Sat,  2 Jun 2018 01:56:04 +0530
Message-Id: <1527884768-22392-2-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
References: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new routine to reset the ARM9 and brings it
out of reset. This is in preparation to add PIL
functionality in venus driver.

Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
---
 drivers/media/platform/qcom/venus/firmware.c     | 26 ++++++++++++++++++++++++
 drivers/media/platform/qcom/venus/hfi_venus_io.h |  5 +++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
index 521d4b3..7d89b5a 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -14,6 +14,7 @@
 
 #include <linux/device.h>
 #include <linux/firmware.h>
+#include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/io.h>
 #include <linux/of.h>
@@ -22,11 +23,36 @@
 #include <linux/sizes.h>
 #include <linux/soc/qcom/mdt_loader.h>
 
+#include "core.h"
 #include "firmware.h"
+#include "hfi_venus_io.h"
 
 #define VENUS_PAS_ID			9
 #define VENUS_FW_MEM_SIZE		(6 * SZ_1M)
 
+static void venus_reset_hw(struct venus_core *core)
+{
+	void __iomem *reg_base = core->base;
+
+	writel(0, reg_base + WRAPPER_FW_START_ADDR);
+	writel(VENUS_FW_MEM_SIZE, reg_base + WRAPPER_FW_END_ADDR);
+	writel(0, reg_base + WRAPPER_CPA_START_ADDR);
+	writel(VENUS_FW_MEM_SIZE, reg_base + WRAPPER_CPA_END_ADDR);
+	writel(0x0, reg_base + WRAPPER_CPU_CGC_DIS);
+	writel(0x0, reg_base + WRAPPER_CPU_CLOCK_CONFIG);
+
+	/* Make sure all register writes are committed. */
+	mb();
+
+	/*
+	 * Need to wait 10 cycles of internal clocks before bringing ARM9
+	 * out of reset.
+	 */
+	udelay(1);
+
+	/* Bring Arm9 out of reset */
+	writel_relaxed(0, reg_base + WRAPPER_A9SS_SW_RESET);
+}
 int venus_boot(struct device *dev, const char *fwname)
 {
 	const struct firmware *mdt;
diff --git a/drivers/media/platform/qcom/venus/hfi_venus_io.h b/drivers/media/platform/qcom/venus/hfi_venus_io.h
index 76f4793..39afa5d 100644
--- a/drivers/media/platform/qcom/venus/hfi_venus_io.h
+++ b/drivers/media/platform/qcom/venus/hfi_venus_io.h
@@ -109,6 +109,11 @@
 #define WRAPPER_CPU_CGC_DIS			(WRAPPER_BASE + 0x2010)
 #define WRAPPER_CPU_STATUS			(WRAPPER_BASE + 0x2014)
 #define WRAPPER_SW_RESET			(WRAPPER_BASE + 0x3000)
+#define WRAPPER_CPA_START_ADDR		(WRAPPER_BASE + 0x1020)
+#define WRAPPER_CPA_END_ADDR		(WRAPPER_BASE + 0x1024)
+#define WRAPPER_FW_START_ADDR		(WRAPPER_BASE + 0x1028)
+#define WRAPPER_FW_END_ADDR			(WRAPPER_BASE + 0x102C)
+#define WRAPPER_A9SS_SW_RESET		(WRAPPER_BASE + 0x3000)
 
 /* Venus 4xx */
 #define WRAPPER_VCODEC0_MMCC_POWER_STATUS	(WRAPPER_BASE + 0x90)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
