Return-path: <linux-media-owner@vger.kernel.org>
Received: from alexa-out-blr-01.qualcomm.com ([103.229.18.197]:33323 "EHLO
        alexa-out-blr-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbeJIPP1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Oct 2018 11:15:27 -0400
From: Malathi Gottam <mgottam@codeaurora.org>
To: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org, mgottam@codeaurora.org
Subject: [PATCH] media: venus: add support for selection rectangles
Date: Tue,  9 Oct 2018 13:23:23 +0530
Message-Id: <1539071603-1588-1-git-send-email-mgottam@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Handles target type crop by setting the new active rectangle
to hardware. The new rectangle should be within YUV size.

Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
---
 drivers/media/platform/qcom/venus/venc.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 3f50cd0..754c19a 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -478,16 +478,31 @@ static int venc_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
 venc_s_selection(struct file *file, void *fh, struct v4l2_selection *s)
 {
 	struct venus_inst *inst = to_inst(file);
+	int ret;
+	u32 buftype;
 
 	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		return -EINVAL;
 
 	switch (s->target) {
 	case V4L2_SEL_TGT_CROP:
-		if (s->r.width != inst->out_width ||
-		    s->r.height != inst->out_height ||
+		if (s->r.width > inst->out_width ||
+		    s->r.height > inst->out_height ||
 		    s->r.top != 0 || s->r.left != 0)
 			return -EINVAL;
+		if (s->r.width != inst->width ||
+		    s->r.height != inst->height) {
+			buftype = HFI_BUFFER_OUTPUT;
+			ret = venus_helper_set_output_resolution(inst,
+								 s->r.width,
+								 s->r.height,
+								 buftype);
+			if (ret)
+				return ret;
+
+			inst->width = s->r.width;
+			inst->height = s->r.height;
+		}
 		break;
 	default:
 		return -EINVAL;
-- 
1.9.1
