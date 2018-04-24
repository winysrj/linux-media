Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36596 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757875AbeDXMpe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 08:45:34 -0400
Received: by mail-wr0-f193.google.com with SMTP id u18-v6so22545274wrg.3
        for <linux-media@vger.kernel.org>; Tue, 24 Apr 2018 05:45:33 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 24/28] venus: vdec: new function for output configuration
Date: Tue, 24 Apr 2018 15:44:32 +0300
Message-Id: <20180424124436.26955-25-stanimir.varbanov@linaro.org>
In-Reply-To: <20180424124436.26955-1-stanimir.varbanov@linaro.org>
References: <20180424124436.26955-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make a new function vdec_output_conf() for decoder output
configuration. vdec_output_conf() will set properties via
HFI interface related to the output configuration, and
keep vdec_set_properties() which will set properties
related to decoding parameters.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 35 ++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 6ed9b7c4bd6e..ced3330c396a 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -545,6 +545,23 @@ static const struct v4l2_ioctl_ops vdec_ioctl_ops = {
 static int vdec_set_properties(struct venus_inst *inst)
 {
 	struct vdec_controls *ctr = &inst->controls.dec;
+	struct hfi_enable en = { .enable = 1 };
+	u32 ptype;
+	int ret;
+
+	if (ctr->post_loop_deb_mode) {
+		ptype = HFI_PROPERTY_CONFIG_VDEC_POST_LOOP_DEBLOCKER;
+		en.enable = 1;
+		ret = hfi_session_set_property(inst, ptype, &en);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int vdec_output_conf(struct venus_inst *inst)
+{
 	struct venus_core *core = inst->core;
 	struct hfi_enable en = { .enable = 1 };
 	u32 ptype;
@@ -569,14 +586,6 @@ static int vdec_set_properties(struct venus_inst *inst)
 	if (ret)
 		return ret;
 
-	if (ctr->post_loop_deb_mode) {
-		ptype = HFI_PROPERTY_CONFIG_VDEC_POST_LOOP_DEBLOCKER;
-		en.enable = 1;
-		ret = hfi_session_set_property(inst, ptype, &en);
-		if (ret)
-			return ret;
-	}
-
 	return 0;
 }
 
@@ -724,7 +733,6 @@ static int vdec_verify_conf(struct venus_inst *inst)
 static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct venus_inst *inst = vb2_get_drv_priv(q);
-	struct venus_core *core = inst->core;
 	int ret;
 
 	mutex_lock(&inst->lock);
@@ -753,12 +761,9 @@ static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
 	if (ret)
 		goto deinit_sess;
 
-	if (core->res->hfi_version == HFI_VERSION_3XX) {
-		ret = venus_helper_set_bufsize(inst, inst->output_buf_size,
-					       HFI_BUFFER_OUTPUT);
-		if (ret)
-			goto deinit_sess;
-	}
+	ret = vdec_output_conf(inst);
+	if (ret)
+		goto deinit_sess;
 
 	ret = vdec_verify_conf(inst);
 	if (ret)
-- 
2.14.1
