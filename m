Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:39640 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752500AbeEOH7g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 03:59:36 -0400
Received: by mail-wm0-f67.google.com with SMTP id f8-v6so19700678wmc.4
        for <linux-media@vger.kernel.org>; Tue, 15 May 2018 00:59:35 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v2 07/29] venus: hfi_venus: add halt AXI support for Venus 4xx
Date: Tue, 15 May 2018 10:58:37 +0300
Message-Id: <20180515075859.17217-8-stanimir.varbanov@linaro.org>
In-Reply-To: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add AXI halt support for version 4xx by using venus wrapper
registers.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c b/drivers/media/platform/qcom/venus/hfi_venus.c
index 734ce11b0ed0..53546174aab8 100644
--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -532,6 +532,23 @@ static int venus_halt_axi(struct venus_hfi_device *hdev)
 	u32 val;
 	int ret;
 
+	if (hdev->core->res->hfi_version == HFI_VERSION_4XX) {
+		val = venus_readl(hdev, WRAPPER_CPU_AXI_HALT);
+		val |= BIT(16);
+		venus_writel(hdev, WRAPPER_CPU_AXI_HALT, val);
+
+		ret = readl_poll_timeout(base + WRAPPER_CPU_AXI_HALT_STATUS,
+					 val, val & BIT(24),
+					 POLL_INTERVAL_US,
+					 VBIF_AXI_HALT_ACK_TIMEOUT_US);
+		if (ret) {
+			dev_err(dev, "AXI bus port halt timeout\n");
+			return ret;
+		}
+
+		return 0;
+	}
+
 	/* Halt AXI and AXI IMEM VBIF Access */
 	val = venus_readl(hdev, VBIF_AXI_HALT_CTRL0);
 	val |= VBIF_AXI_HALT_CTRL0_HALT_REQ;
-- 
2.14.1
