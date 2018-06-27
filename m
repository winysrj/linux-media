Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35858 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934728AbeF0P2J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 11:28:09 -0400
Received: by mail-wr0-f193.google.com with SMTP id f16-v6so2477100wrm.3
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2018 08:28:08 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v4 09/27] venus: hfi_venus: move set of default properties to core init
Date: Wed, 27 Jun 2018 18:27:07 +0300
Message-Id: <20180627152725.9783-10-stanimir.varbanov@linaro.org>
In-Reply-To: <20180627152725.9783-1-stanimir.varbanov@linaro.org>
References: <20180627152725.9783-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This moves setting of default properties (firmware debug, idle
indicator and low power mode) from session init to core init.
All of those properties are need to be enabled/disabled early
so that they could be used before the clients are even initialized.

The other reason is to set idle indicator property early before
we enter into venus_suspend function where we need to check for
ARM9 WFI.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c b/drivers/media/platform/qcom/venus/hfi_venus.c
index 72a8547eab39..7a83e967a8ea 100644
--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -1091,6 +1091,10 @@ static int venus_core_init(struct venus_core *core)
 	if (ret)
 		dev_warn(dev, "failed to send image version pkt to fw\n");
 
+	ret = venus_sys_set_default_properties(hdev);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
@@ -1135,10 +1139,6 @@ static int venus_session_init(struct venus_inst *inst, u32 session_type,
 	struct hfi_session_init_pkt pkt;
 	int ret;
 
-	ret = venus_sys_set_default_properties(hdev);
-	if (ret)
-		return ret;
-
 	ret = pkt_session_init(&pkt, inst, session_type, codec);
 	if (ret)
 		goto err;
-- 
2.14.1
