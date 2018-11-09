Return-path: <linux-media-owner@vger.kernel.org>
Received: from alexa-out-blr-01.qualcomm.com ([103.229.18.197]:27279 "EHLO
        alexa-out-blr-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727845AbeKIRSi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Nov 2018 12:18:38 -0500
From: Malathi Gottam <mgottam@codeaurora.org>
To: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org, mgottam@codeaurora.org
Subject: [PATCH v2] media: venus: add support for selection rectangles
Date: Fri,  9 Nov 2018 13:09:01 +0530
Message-Id: <1541749141-6989-1-git-send-email-mgottam@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Handles target type crop by setting the new active rectangle
to hardware. The new rectangle should be within YUV size.

Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
---
 drivers/media/platform/qcom/venus/venc.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index ce85962..d26c129 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -478,16 +478,34 @@ static int venc_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
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
-		    s->r.top != 0 || s->r.left != 0)
-			return -EINVAL;
+		if (s->r.left != 0) {
+			s->r.width += s->r.left;
+			s->r.left = 0;
+		}
+
+		if (s->r.top != 0) {
+			s->r.height += s->r.top;
+			s->r.top = 0;
+		}
+
+		if (s->r.width > inst->width)
+			s->r.width = inst->width;
+		else
+			inst->width = s->r.width;
+
+		if (s->r.height > inst->height)
+			s->r.height = inst->height;
+		else
+			inst->height = s->r.height;
+
 		break;
 	default:
 		return -EINVAL;
-- 
1.9.1
