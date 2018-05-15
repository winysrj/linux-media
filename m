Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35058 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752556AbeEOH7p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 03:59:45 -0400
Received: by mail-wm0-f68.google.com with SMTP id o78-v6so19724155wmg.0
        for <linux-media@vger.kernel.org>; Tue, 15 May 2018 00:59:44 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v2 15/29] venus: helpers: rename a helper function and use buffer mode from caps
Date: Tue, 15 May 2018 10:58:45 +0300
Message-Id: <20180515075859.17217-16-stanimir.varbanov@linaro.org>
In-Reply-To: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename is_reg_unreg_needed() to better name is_dynamic_bufmode() and
use buffer mode from enumerated per codec capabilities.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 2b21f6ed7502..1eda19adbf28 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -354,18 +354,19 @@ session_process_buf(struct venus_inst *inst, struct vb2_v4l2_buffer *vbuf)
 	return 0;
 }
 
-static inline int is_reg_unreg_needed(struct venus_inst *inst)
+static inline int is_dynamic_bufmode(struct venus_inst *inst)
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
+	if (caps->cap_bufs_mode_dynamic)
+		return 1;
+
+	return 0;
 }
 
 static int session_unregister_bufs(struct venus_inst *inst)
@@ -374,7 +375,7 @@ static int session_unregister_bufs(struct venus_inst *inst)
 	struct hfi_buffer_desc bd;
 	int ret = 0;
 
-	if (!is_reg_unreg_needed(inst))
+	if (is_dynamic_bufmode(inst))
 		return 0;
 
 	list_for_each_entry_safe(buf, n, &inst->registeredbufs, reg_list) {
@@ -394,7 +395,7 @@ static int session_register_bufs(struct venus_inst *inst)
 	struct venus_buffer *buf;
 	int ret = 0;
 
-	if (!is_reg_unreg_needed(inst))
+	if (is_dynamic_bufmode(inst))
 		return 0;
 
 	list_for_each_entry(buf, &inst->registeredbufs, reg_list) {
-- 
2.14.1
