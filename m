Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35036 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752509AbeEOH7h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 03:59:37 -0400
Received: by mail-wm0-f68.google.com with SMTP id o78-v6so19723394wmg.0
        for <linux-media@vger.kernel.org>; Tue, 15 May 2018 00:59:36 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v2 08/29] venus: hfi_venus: fix suspend function for venus 3xx versions
Date: Tue, 15 May 2018 10:58:38 +0300
Message-Id: <20180515075859.17217-9-stanimir.varbanov@linaro.org>
In-Reply-To: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes the suspend function for Venus 3xx versions by
add a check for WFI (wait for interrupt) bit. This bit
is on when the ARM9 is idle and entered in low power mode.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c    | 59 ++++++++++++++++--------
 drivers/media/platform/qcom/venus/hfi_venus_io.h |  1 +
 2 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c b/drivers/media/platform/qcom/venus/hfi_venus.c
index 53546174aab8..aac351f699a0 100644
--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -1447,7 +1447,7 @@ static int venus_suspend_3xx(struct venus_core *core)
 {
 	struct venus_hfi_device *hdev = to_hfi_priv(core);
 	struct device *dev = core->dev;
-	u32 ctrl_status, wfi_status;
+	u32 ctrl_status, cpu_status;
 	int ret;
 	int cnt = 100;
 
@@ -1463,29 +1463,50 @@ static int venus_suspend_3xx(struct venus_core *core)
 		return -EINVAL;
 	}
 
-	ctrl_status = venus_readl(hdev, CPU_CS_SCIACMDARG0);
-	if (!(ctrl_status & CPU_CS_SCIACMDARG0_PC_READY)) {
-		wfi_status = venus_readl(hdev, WRAPPER_CPU_STATUS);
+	/*
+	 * Power collapse sequence for Venus 3xx and 4xx versions:
+	 * 1. Check for ARM9 and video core to be idle by checking WFI bit
+	 *    (bit 0) in CPU status register and by checking Idle (bit 30) in
+	 *    Control status register for video core.
+	 * 2. Send a command to prepare for power collapse.
+	 * 3. Check for WFI and PC_READY bits.
+	 */
+
+	while (--cnt) {
+		cpu_status = venus_readl(hdev, WRAPPER_CPU_STATUS);
 		ctrl_status = venus_readl(hdev, CPU_CS_SCIACMDARG0);
 
-		ret = venus_prepare_power_collapse(hdev, false);
-		if (ret) {
-			dev_err(dev, "prepare for power collapse fail (%d)\n",
-				ret);
-			return ret;
-		}
+		if (cpu_status & WRAPPER_CPU_STATUS_WFI &&
+		    ctrl_status & CPU_CS_SCIACMDARG0_INIT_IDLE_MSG_MASK)
+			break;
 
-		cnt = 100;
-		while (cnt--) {
-			wfi_status = venus_readl(hdev, WRAPPER_CPU_STATUS);
-			ctrl_status = venus_readl(hdev, CPU_CS_SCIACMDARG0);
-			if (ctrl_status & CPU_CS_SCIACMDARG0_PC_READY &&
-			    wfi_status & BIT(0))
-				break;
-			usleep_range(1000, 1500);
-		}
+		usleep_range(1000, 1500);
 	}
 
+	if (!cnt)
+		return -ETIMEDOUT;
+
+	ret = venus_prepare_power_collapse(hdev, false);
+	if (ret) {
+		dev_err(dev, "prepare for power collapse fail (%d)\n", ret);
+		return ret;
+	}
+
+	cnt = 100;
+	while (--cnt) {
+		cpu_status = venus_readl(hdev, WRAPPER_CPU_STATUS);
+		ctrl_status = venus_readl(hdev, CPU_CS_SCIACMDARG0);
+
+		if (cpu_status & WRAPPER_CPU_STATUS_WFI &&
+		    ctrl_status & CPU_CS_SCIACMDARG0_PC_READY)
+			break;
+
+		usleep_range(1000, 1500);
+	}
+
+	if (!cnt)
+		return -ETIMEDOUT;
+
 	mutex_lock(&hdev->lock);
 
 	ret = venus_power_off(hdev);
diff --git a/drivers/media/platform/qcom/venus/hfi_venus_io.h b/drivers/media/platform/qcom/venus/hfi_venus_io.h
index 76f47936d0fa..12e3d33a3d82 100644
--- a/drivers/media/platform/qcom/venus/hfi_venus_io.h
+++ b/drivers/media/platform/qcom/venus/hfi_venus_io.h
@@ -108,6 +108,7 @@
 
 #define WRAPPER_CPU_CGC_DIS			(WRAPPER_BASE + 0x2010)
 #define WRAPPER_CPU_STATUS			(WRAPPER_BASE + 0x2014)
+#define WRAPPER_CPU_STATUS_WFI			BIT(0)
 #define WRAPPER_SW_RESET			(WRAPPER_BASE + 0x3000)
 
 /* Venus 4xx */
-- 
2.14.1
