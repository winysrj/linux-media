Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:42335 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934853AbeF0P2I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 11:28:08 -0400
Received: by mail-wr0-f196.google.com with SMTP id p1-v6so2472948wrs.9
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2018 08:28:07 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v4 08/27] venus: hfi_venus: fix suspend function for venus 3xx versions
Date: Wed, 27 Jun 2018 18:27:06 +0300
Message-Id: <20180627152725.9783-9-stanimir.varbanov@linaro.org>
In-Reply-To: <20180627152725.9783-1-stanimir.varbanov@linaro.org>
References: <20180627152725.9783-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes the suspend function for Venus 3xx versions by
add a check for WFI (wait for interrupt) bit. This bit
is on when the ARM9 is idle and entered in low power mode.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c    | 72 ++++++++++++++++--------
 drivers/media/platform/qcom/venus/hfi_venus_io.h |  1 +
 2 files changed, 51 insertions(+), 22 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c b/drivers/media/platform/qcom/venus/hfi_venus.c
index 784b3ad1a9f6..72a8547eab39 100644
--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -1444,13 +1444,40 @@ static int venus_suspend_1xx(struct venus_core *core)
 	return 0;
 }
 
+static bool venus_cpu_and_video_core_idle(struct venus_hfi_device *hdev)
+{
+	u32 ctrl_status, cpu_status;
+
+	cpu_status = venus_readl(hdev, WRAPPER_CPU_STATUS);
+	ctrl_status = venus_readl(hdev, CPU_CS_SCIACMDARG0);
+
+	if (cpu_status & WRAPPER_CPU_STATUS_WFI &&
+	    ctrl_status & CPU_CS_SCIACMDARG0_INIT_IDLE_MSG_MASK)
+		return true;
+
+	return false;
+}
+
+static bool venus_cpu_idle_and_pc_ready(struct venus_hfi_device *hdev)
+{
+	u32 ctrl_status, cpu_status;
+
+	cpu_status = venus_readl(hdev, WRAPPER_CPU_STATUS);
+	ctrl_status = venus_readl(hdev, CPU_CS_SCIACMDARG0);
+
+	if (cpu_status & WRAPPER_CPU_STATUS_WFI &&
+	    ctrl_status & CPU_CS_SCIACMDARG0_PC_READY)
+		return true;
+
+	return false;
+}
+
 static int venus_suspend_3xx(struct venus_core *core)
 {
 	struct venus_hfi_device *hdev = to_hfi_priv(core);
 	struct device *dev = core->dev;
-	u32 ctrl_status, wfi_status;
+	bool val;
 	int ret;
-	int cnt = 100;
 
 	if (!hdev->power_enabled || hdev->suspended)
 		return 0;
@@ -1464,29 +1491,30 @@ static int venus_suspend_3xx(struct venus_core *core)
 		return -EINVAL;
 	}
 
-	ctrl_status = venus_readl(hdev, CPU_CS_SCIACMDARG0);
-	if (!(ctrl_status & CPU_CS_SCIACMDARG0_PC_READY)) {
-		wfi_status = venus_readl(hdev, WRAPPER_CPU_STATUS);
-		ctrl_status = venus_readl(hdev, CPU_CS_SCIACMDARG0);
-
-		ret = venus_prepare_power_collapse(hdev, false);
-		if (ret) {
-			dev_err(dev, "prepare for power collapse fail (%d)\n",
-				ret);
-			return ret;
-		}
+	/*
+	 * Power collapse sequence for Venus 3xx and 4xx versions:
+	 * 1. Check for ARM9 and video core to be idle by checking WFI bit
+	 *    (bit 0) in CPU status register and by checking Idle (bit 30) in
+	 *    Control status register for video core.
+	 * 2. Send a command to prepare for power collapse.
+	 * 3. Check for WFI and PC_READY bits.
+	 */
+	ret = readx_poll_timeout(venus_cpu_and_video_core_idle, hdev, val, val,
+				 1500, 100 * 1500);
+	if (ret)
+		return ret;
 
-		cnt = 100;
-		while (cnt--) {
-			wfi_status = venus_readl(hdev, WRAPPER_CPU_STATUS);
-			ctrl_status = venus_readl(hdev, CPU_CS_SCIACMDARG0);
-			if (ctrl_status & CPU_CS_SCIACMDARG0_PC_READY &&
-			    wfi_status & BIT(0))
-				break;
-			usleep_range(1000, 1500);
-		}
+	ret = venus_prepare_power_collapse(hdev, false);
+	if (ret) {
+		dev_err(dev, "prepare for power collapse fail (%d)\n", ret);
+		return ret;
 	}
 
+	ret = readx_poll_timeout(venus_cpu_idle_and_pc_ready, hdev, val, val,
+				 1500, 100 * 1500);
+	if (ret)
+		return ret;
+
 	mutex_lock(&hdev->lock);
 
 	ret = venus_power_off(hdev);
diff --git a/drivers/media/platform/qcom/venus/hfi_venus_io.h b/drivers/media/platform/qcom/venus/hfi_venus_io.h
index c0b18de1e396..def0926a6dee 100644
--- a/drivers/media/platform/qcom/venus/hfi_venus_io.h
+++ b/drivers/media/platform/qcom/venus/hfi_venus_io.h
@@ -110,6 +110,7 @@
 
 #define WRAPPER_CPU_CGC_DIS			(WRAPPER_BASE + 0x2010)
 #define WRAPPER_CPU_STATUS			(WRAPPER_BASE + 0x2014)
+#define WRAPPER_CPU_STATUS_WFI			BIT(0)
 #define WRAPPER_SW_RESET			(WRAPPER_BASE + 0x3000)
 
 /* Venus 4xx */
-- 
2.14.1
