Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:39824 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936077AbeFMPJo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 11:09:44 -0400
Received: by mail-wm0-f68.google.com with SMTP id p11-v6so6081104wmc.4
        for <linux-media@vger.kernel.org>; Wed, 13 Jun 2018 08:09:43 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v3 26/27] venus: core: add sdm845 DT compatible and resource data
Date: Wed, 13 Jun 2018 18:08:00 +0300
Message-Id: <20180613150801.11702-27-stanimir.varbanov@linaro.org>
In-Reply-To: <20180613150801.11702-1-stanimir.varbanov@linaro.org>
References: <20180613150801.11702-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds sdm845 DT compatible string with it's resource
data table.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/media/qcom,venus.txt       |  1 +
 drivers/media/platform/qcom/venus/core.c           | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/qcom,venus.txt b/Documentation/devicetree/bindings/media/qcom,venus.txt
index 2693449daf73..00d0d1bf7647 100644
--- a/Documentation/devicetree/bindings/media/qcom,venus.txt
+++ b/Documentation/devicetree/bindings/media/qcom,venus.txt
@@ -6,6 +6,7 @@
 	Definition: Value should contain one of:
 		- "qcom,msm8916-venus"
 		- "qcom,msm8996-venus"
+		- "qcom,sdm845-venus"
 - reg:
 	Usage: required
 	Value type: <prop-encoded-array>
diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 381bfdd688db..bb6add9d340e 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -450,9 +450,31 @@ static const struct venus_resources msm8996_res = {
 	.fwname = "qcom/venus-4.2/venus.mdt",
 };
 
+static const struct freq_tbl sdm845_freq_table[] = {
+	{ 1944000, 380000000 },	/* 4k UHD @ 60 */
+	{  972000, 320000000 },	/* 4k UHD @ 30 */
+	{  489600, 200000000 },	/* 1080p @ 60 */
+	{  244800, 100000000 },	/* 1080p @ 30 */
+};
+
+static const struct venus_resources sdm845_res = {
+	.freq_tbl = sdm845_freq_table,
+	.freq_tbl_size = ARRAY_SIZE(sdm845_freq_table),
+	.clks = {"core", "iface", "bus" },
+	.clks_num = 3,
+	.max_load = 2563200,
+	.hfi_version = HFI_VERSION_4XX,
+	.vmem_id = VIDC_RESOURCE_NONE,
+	.vmem_size = 0,
+	.vmem_addr = 0,
+	.dma_mask = 0xe0000000 - 1,
+	.fwname = "qcom/venus-5.2/venus.mdt",
+};
+
 static const struct of_device_id venus_dt_match[] = {
 	{ .compatible = "qcom,msm8916-venus", .data = &msm8916_res, },
 	{ .compatible = "qcom,msm8996-venus", .data = &msm8996_res, },
+	{ .compatible = "qcom,sdm845-venus", .data = &sdm845_res, },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, venus_dt_match);
-- 
2.14.1
