Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44507 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754397AbeGENFW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 09:05:22 -0400
Received: by mail-wr1-f65.google.com with SMTP id r16-v6so1138188wrt.11
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 06:05:21 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v5 13/27] venus: helpers: rename a helper function and use buffer mode from caps
Date: Thu,  5 Jul 2018 16:03:47 +0300
Message-Id: <20180705130401.24315-14-stanimir.varbanov@linaro.org>
In-Reply-To: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
References: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename is_reg_unreg_needed() to better name is_dynamic_bufmode() and
use buffer mode from enumerated per codec capabilities.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index c8c4a4be78e3..27c4a4060c4e 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -359,18 +359,16 @@ session_process_buf(struct venus_inst *inst, struct vb2_v4l2_buffer *vbuf)
 	return 0;
 }
 
-static inline int is_reg_unreg_needed(struct venus_inst *inst)
+static bool is_dynamic_bufmode(struct venus_inst *inst)
 {
-	if (inst->session_type == VIDC_SESSION_TYPE_DEC &&
-	    inst->core->res->hfi_version == HFI_VERSION_3XX)
-		return 0;
+	struct venus_core *core = inst->core;
+	struct venus_caps *caps;
 
-	if (inst->session_type == VIDC_SESSION_TYPE_DEC &&
-	    inst->cap_bufs_mode_dynamic &&
-	    inst->core->res->hfi_version == HFI_VERSION_1XX)
+	caps = venus_caps_by_codec(core, inst->hfi_codec, inst->session_type);
+	if (!caps)
 		return 0;
 
-	return 1;
+	return caps->cap_bufs_mode_dynamic;
 }
 
 static int session_unregister_bufs(struct venus_inst *inst)
@@ -379,7 +377,7 @@ static int session_unregister_bufs(struct venus_inst *inst)
 	struct hfi_buffer_desc bd;
 	int ret = 0;
 
-	if (!is_reg_unreg_needed(inst))
+	if (is_dynamic_bufmode(inst))
 		return 0;
 
 	list_for_each_entry_safe(buf, n, &inst->registeredbufs, reg_list) {
@@ -399,7 +397,7 @@ static int session_register_bufs(struct venus_inst *inst)
 	struct venus_buffer *buf;
 	int ret = 0;
 
-	if (!is_reg_unreg_needed(inst))
+	if (is_dynamic_bufmode(inst))
 		return 0;
 
 	list_for_each_entry(buf, &inst->registeredbufs, reg_list) {
-- 
2.14.1
