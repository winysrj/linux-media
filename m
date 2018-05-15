Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:39651 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752485AbeEOH7i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 03:59:38 -0400
Received: by mail-wm0-f68.google.com with SMTP id f8-v6so19700982wmc.4
        for <linux-media@vger.kernel.org>; Tue, 15 May 2018 00:59:38 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v2 10/29] venus: hfi_venus: add suspend functionality for Venus 4xx
Date: Tue, 15 May 2018 10:58:40 +0300
Message-Id: <20180515075859.17217-11-stanimir.varbanov@linaro.org>
In-Reply-To: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds suspend (power collapse) functionality by reusing
the suspend function for Venus 3xx and also enables idle indicator
property for Venus 4xx (where it is disabled by default).

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c b/drivers/media/platform/qcom/venus/hfi_venus.c
index 284da69eb81b..109116e1545d 100644
--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -878,6 +878,14 @@ static int venus_sys_set_default_properties(struct venus_hfi_device *hdev)
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
@@ -1525,7 +1533,8 @@ static int venus_suspend_3xx(struct venus_core *core)
 
 static int venus_suspend(struct venus_core *core)
 {
-	if (core->res->hfi_version == HFI_VERSION_3XX)
+	if (core->res->hfi_version == HFI_VERSION_3XX ||
+	    core->res->hfi_version == HFI_VERSION_4XX)
 		return venus_suspend_3xx(core);
 
 	return venus_suspend_1xx(core);
-- 
2.14.1
