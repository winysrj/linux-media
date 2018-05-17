Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60614 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbeEQLdQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 07:33:16 -0400
From: Vikash Garodia <vgarodia@codeaurora.org>
To: hverkuil@xs4all.nl, mchehab@kernel.org, andy.gross@linaro.org,
        bjorn.andersson@linaro.org, stanimir.varbanov@linaro.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        acourbot@google.com, Vikash Garodia <vgarodia@codeaurora.org>
Subject: [PATCH 3/4] venus: add check to make scm calls
Date: Thu, 17 May 2018 17:02:19 +0530
Message-Id: <1526556740-25494-4-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1526556740-25494-1-git-send-email-vgarodia@codeaurora.org>
References: <1526556740-25494-1-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to invoke scm calls, ensure that the platform
has the required support to invoke the scm calls in
secure world. This code is in preparation to add PIL
functionality in venus driver.

Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c b/drivers/media/platform/qcom/venus/hfi_venus.c
index f61d34b..9bcce94 100644
--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -27,6 +27,7 @@
 #include "hfi_msgs.h"
 #include "hfi_venus.h"
 #include "hfi_venus_io.h"
+#include "firmware.h"
 
 #define HFI_MASK_QHDR_TX_TYPE		0xff000000
 #define HFI_MASK_QHDR_RX_TYPE		0x00ff0000
@@ -570,13 +571,19 @@ static int venus_halt_axi(struct venus_hfi_device *hdev)
 static int venus_power_off(struct venus_hfi_device *hdev)
 {
 	int ret;
+	void __iomem *reg_base;
 
 	if (!hdev->power_enabled)
 		return 0;
 
-	ret = qcom_scm_set_remote_state(TZBSP_VIDEO_STATE_SUSPEND, 0);
-	if (ret)
-		return ret;
+	if (qcom_scm_is_available()) {
+		ret = qcom_scm_set_remote_state(TZBSP_VIDEO_STATE_SUSPEND, 0);
+		if (ret)
+			return ret;
+	} else {
+		reg_base = hdev->core->base;
+		writel_relaxed(1, reg_base + WRAPPER_A9SS_SW_RESET);
+	}
 
 	ret = venus_halt_axi(hdev);
 	if (ret)
@@ -594,9 +601,13 @@ static int venus_power_on(struct venus_hfi_device *hdev)
 	if (hdev->power_enabled)
 		return 0;
 
-	ret = qcom_scm_set_remote_state(TZBSP_VIDEO_STATE_RESUME, 0);
-	if (ret)
-		goto err;
+	if (qcom_scm_is_available()) {
+		ret = qcom_scm_set_remote_state(TZBSP_VIDEO_STATE_RESUME, 0);
+		if (ret)
+			goto err;
+	} else {
+		venus_reset_hw(hdev->core);
+	}
 
 	ret = venus_run(hdev);
 	if (ret)
@@ -607,7 +618,8 @@ static int venus_power_on(struct venus_hfi_device *hdev)
 	return 0;
 
 err_suspend:
-	qcom_scm_set_remote_state(TZBSP_VIDEO_STATE_SUSPEND, 0);
+	if (qcom_scm_is_available())
+		qcom_scm_set_remote_state(TZBSP_VIDEO_STATE_SUSPEND, 0);
 err:
 	hdev->power_enabled = false;
 	return ret;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
