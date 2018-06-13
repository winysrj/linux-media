Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:38988 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935981AbeFMPJQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 11:09:16 -0400
Received: by mail-wr0-f196.google.com with SMTP id w7-v6so3140266wrn.6
        for <linux-media@vger.kernel.org>; Wed, 13 Jun 2018 08:09:15 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v3 07/27] venus: hfi_venus: add halt AXI support for Venus 4xx
Date: Wed, 13 Jun 2018 18:07:41 +0300
Message-Id: <20180613150801.11702-8-stanimir.varbanov@linaro.org>
In-Reply-To: <20180613150801.11702-1-stanimir.varbanov@linaro.org>
References: <20180613150801.11702-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add AXI halt support for version 4xx by using venus wrapper
registers.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c    | 18 ++++++++++++++++++
 drivers/media/platform/qcom/venus/hfi_venus_io.h |  2 ++
 2 files changed, 20 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c b/drivers/media/platform/qcom/venus/hfi_venus.c
index 734ce11b0ed0..784b3ad1a9f6 100644
--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -532,6 +532,24 @@ static int venus_halt_axi(struct venus_hfi_device *hdev)
 	u32 val;
 	int ret;
 
+	if (IS_V4(hdev->core)) {
+		val = venus_readl(hdev, WRAPPER_CPU_AXI_HALT);
+		val |= WRAPPER_CPU_AXI_HALT_HALT;
+		venus_writel(hdev, WRAPPER_CPU_AXI_HALT, val);
+
+		ret = readl_poll_timeout(base + WRAPPER_CPU_AXI_HALT_STATUS,
+					 val,
+					 val & WRAPPER_CPU_AXI_HALT_STATUS_IDLE,
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
diff --git a/drivers/media/platform/qcom/venus/hfi_venus_io.h b/drivers/media/platform/qcom/venus/hfi_venus_io.h
index d327b5cea334..c0b18de1e396 100644
--- a/drivers/media/platform/qcom/venus/hfi_venus_io.h
+++ b/drivers/media/platform/qcom/venus/hfi_venus_io.h
@@ -104,7 +104,9 @@
 
 #define WRAPPER_CPU_CLOCK_CONFIG		(WRAPPER_BASE + 0x2000)
 #define WRAPPER_CPU_AXI_HALT			(WRAPPER_BASE + 0x2008)
+#define WRAPPER_CPU_AXI_HALT_HALT		BIT(16)
 #define WRAPPER_CPU_AXI_HALT_STATUS		(WRAPPER_BASE + 0x200c)
+#define WRAPPER_CPU_AXI_HALT_STATUS_IDLE	BIT(24)
 
 #define WRAPPER_CPU_CGC_DIS			(WRAPPER_BASE + 0x2010)
 #define WRAPPER_CPU_STATUS			(WRAPPER_BASE + 0x2014)
-- 
2.14.1
