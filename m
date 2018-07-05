Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:38010 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754298AbeGENFT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 09:05:19 -0400
Received: by mail-wm0-f65.google.com with SMTP id 69-v6so10664631wmf.3
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 06:05:18 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v5 10/27] venus: hfi_venus: add suspend functionality for Venus 4xx
Date: Thu,  5 Jul 2018 16:03:44 +0300
Message-Id: <20180705130401.24315-11-stanimir.varbanov@linaro.org>
In-Reply-To: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
References: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds suspend (power collapse) functionality by reusing
the suspend function for Venus 3xx and also enables idle indicator
property for Venus 4xx (where it is disabled by default).

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c b/drivers/media/platform/qcom/venus/hfi_venus.c
index 7a83e967a8ea..124085556b94 100644
--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -879,6 +879,14 @@ static int venus_sys_set_default_properties(struct venus_hfi_device *hdev)
 	if (ret)
 		dev_warn(dev, "setting fw debug msg ON failed (%d)\n", ret);
 
+	/*
+	 * Idle indicator is disabled by default on some 4xx firmware versions,
+	 * enable it explicitly in order to make suspend functional by checking
+	 * WFI (wait-for-interrupt) bit.
+	 */
+	if (IS_V4(hdev->core))
+		venus_sys_idle_indicator = true;
+
 	ret = venus_sys_set_idle_message(hdev, venus_sys_idle_indicator);
 	if (ret)
 		dev_warn(dev, "setting idle response ON failed (%d)\n", ret);
@@ -1533,7 +1541,7 @@ static int venus_suspend_3xx(struct venus_core *core)
 
 static int venus_suspend(struct venus_core *core)
 {
-	if (core->res->hfi_version == HFI_VERSION_3XX)
+	if (IS_V3(core) || IS_V4(core))
 		return venus_suspend_3xx(core);
 
 	return venus_suspend_1xx(core);
-- 
2.14.1
