Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:64293 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbaJULHZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 07:07:25 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	kiran@chromium.org, arunkk.samsung@gmail.com
Subject: [PATCH v3 01/13] [media] s5p-mfc: support MIN_BUFFERS query for encoder
Date: Tue, 21 Oct 2014 16:36:55 +0530
Message-Id: <1413889627-8431-2-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1413889627-8431-1-git-send-email-arun.kk@samsung.com>
References: <1413889627-8431-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kiran AVND <avnd.kiran@samsung.com>

Add V4L2_CID_MIN_BUFFERS_FOR_OUTPUT query for encoder.
Once mfc encoder state is HEAD_PARSED, which is sequence
header produced, dpb_count is avaialable. Let user space
query this value.

Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |   42 ++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index a904a1c..4816f31 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -690,6 +690,16 @@ static struct mfc_control controls[] = {
 		.step = 1,
 		.default_value = 0,
 	},
+	{
+		.id = V4L2_CID_MIN_BUFFERS_FOR_OUTPUT,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Minimum number of output bufs",
+		.minimum = 1,
+		.maximum = 32,
+		.step = 1,
+		.default_value = 1,
+		.is_volatile = 1,
+	},
 };
 
 #define NUM_CTRLS ARRAY_SIZE(controls)
@@ -1624,8 +1634,40 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
 	return ret;
 }
 
+static int s5p_mfc_enc_g_v_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct s5p_mfc_ctx *ctx = ctrl_to_ctx(ctrl);
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	switch (ctrl->id) {
+	case V4L2_CID_MIN_BUFFERS_FOR_OUTPUT:
+		if (ctx->state >= MFCINST_HEAD_PARSED &&
+		    ctx->state < MFCINST_ABORT) {
+			ctrl->val = ctx->pb_count;
+			break;
+		} else if (ctx->state != MFCINST_INIT) {
+			v4l2_err(&dev->v4l2_dev, "Encoding not initialised\n");
+			return -EINVAL;
+		}
+		/* Should wait for the header to be produced */
+		s5p_mfc_clean_ctx_int_flags(ctx);
+		s5p_mfc_wait_for_done_ctx(ctx,
+				S5P_MFC_R2H_CMD_SEQ_DONE_RET, 0);
+		if (ctx->state >= MFCINST_HEAD_PARSED &&
+		    ctx->state < MFCINST_ABORT) {
+			ctrl->val = ctx->pb_count;
+		} else {
+			v4l2_err(&dev->v4l2_dev, "Encoding not initialised\n");
+			return -EINVAL;
+		}
+		break;
+	}
+	return 0;
+}
+
 static const struct v4l2_ctrl_ops s5p_mfc_enc_ctrl_ops = {
 	.s_ctrl = s5p_mfc_enc_s_ctrl,
+	.g_volatile_ctrl = s5p_mfc_enc_g_v_ctrl,
 };
 
 static int vidioc_s_parm(struct file *file, void *priv,
-- 
1.7.9.5

