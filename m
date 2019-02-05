Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B882DC282CC
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 20:25:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92E0820818
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 20:25:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbfBEUZY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 15:25:24 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:41840 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726978AbfBEUZY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 15:25:24 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 606A12802E4
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Karlman <jonas@kwiboo.se>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 09/10] rockchip/vpu: Add support for non-standard controls
Date:   Tue,  5 Feb 2019 17:24:16 -0300
Message-Id: <20190205202417.16555-10-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190205202417.16555-1-ezequiel@collabora.com>
References: <20190205202417.16555-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Rework the way controls are registered by the driver,
so it can support non-standard controls, such as those
used by stateless codecs.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 .../media/rockchip/vpu/rk3288_vpu_hw.c        |  2 +-
 .../media/rockchip/vpu/rk3399_vpu_hw.c        |  2 +-
 .../staging/media/rockchip/vpu/rockchip_vpu.h | 24 ++++++-
 .../media/rockchip/vpu/rockchip_vpu_common.h  |  1 +
 .../media/rockchip/vpu/rockchip_vpu_drv.c     | 65 +++++++++++++++++--
 5 files changed, 84 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c b/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c
index 056ee017c798..630eded99c68 100644
--- a/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c
+++ b/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c
@@ -112,7 +112,7 @@ const struct rockchip_vpu_variant rk3288_vpu_variant = {
 	.enc_fmts = rk3288_vpu_enc_fmts,
 	.num_enc_fmts = ARRAY_SIZE(rk3288_vpu_enc_fmts),
 	.codec_ops = rk3288_vpu_codec_ops,
-	.codec = RK_VPU_CODEC_JPEG,
+	.codec = RK_VPU_JPEG_ENCODER,
 	.vepu_irq = rk3288_vepu_irq,
 	.init = rk3288_vpu_hw_init,
 	.clk_names = {"aclk", "hclk"},
diff --git a/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c b/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c
index 0263584e616d..9eae1e6f1393 100644
--- a/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c
+++ b/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c
@@ -129,7 +129,7 @@ const struct rockchip_vpu_variant rk3399_vpu_variant = {
 	.enc_offset = 0x0,
 	.enc_fmts = rk3399_vpu_enc_fmts,
 	.num_enc_fmts = ARRAY_SIZE(rk3399_vpu_enc_fmts),
-	.codec = RK_VPU_CODEC_JPEG,
+	.codec = RK_VPU_JPEG_ENCODER,
 	.codec_ops = rk3399_vpu_codec_ops,
 	.vepu_irq = rk3399_vepu_irq,
 	.vdpu_irq = rk3399_vdpu_irq,
diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu.h b/drivers/staging/media/rockchip/vpu/rockchip_vpu.h
index b383c89ecc17..a90fc2dfae99 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu.h
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu.h
@@ -25,6 +25,7 @@
 
 #include "rockchip_vpu_hw.h"
 
+#define ROCKCHIP_VPU_MAX_CTRLS          32
 #define ROCKCHIP_VPU_MAX_CLOCKS		4
 
 #define JPEG_MB_DIM			16
@@ -34,7 +35,10 @@
 struct rockchip_vpu_ctx;
 struct rockchip_vpu_codec_ops;
 
-#define RK_VPU_CODEC_JPEG BIT(0)
+#define RK_VPU_JPEG_ENCODER	BIT(0)
+#define RK_VPU_ENCODERS		0x0000ffff
+
+#define RK_VPU_DECODERS		0xffff0000
 
 /**
  * struct rockchip_vpu_variant - information about VPU hardware variant
@@ -79,6 +83,20 @@ enum rockchip_vpu_codec_mode {
 	RK_VPU_MODE_JPEG_ENC,
 };
 
+/*
+ * struct rockchip_vpu_ctrl - helper type to declare supported controls
+ * @id:		V4L2 control ID (V4L2_CID_xxx)
+ * @is_std:	boolean to distinguish standard from customs control.
+ * @codec:	codec id this control belong to (RK_VPU_JPEG_ENCODER, etc.)
+ * @cfg:	control configuration
+ */
+struct rockchip_vpu_ctrl {
+	unsigned int id;
+	unsigned int is_std;
+	unsigned int codec;
+	struct v4l2_ctrl_config cfg;
+};
+
 /*
  * struct rockchip_vpu_mc - media controller data
  *
@@ -169,6 +187,8 @@ struct rockchip_vpu_dev {
  * @dst_fmt:		V4L2 pixel format of active destination format.
  *
  * @ctrl_handler:	Control handler used to register controls.
+ * @ctrls:		Array of supported controls.
+ * @num_ctrls:		Number of controls populated in the array.
  * @jpeg_quality:	User-specified JPEG compression quality.
  *
  * @codec_ops:		Set of operations related to codec mode.
@@ -188,6 +208,8 @@ struct rockchip_vpu_ctx {
 	struct v4l2_pix_format_mplane dst_fmt;
 
 	struct v4l2_ctrl_handler ctrl_handler;
+	struct v4l2_ctrl *ctrls[ROCKCHIP_VPU_MAX_CTRLS];
+	unsigned int num_ctrls;
 	int jpeg_quality;
 
 	const struct rockchip_vpu_codec_ops *codec_ops;
diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_common.h b/drivers/staging/media/rockchip/vpu/rockchip_vpu_common.h
index 7e5fce3bf215..70b8ac1c7503 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu_common.h
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_common.h
@@ -23,6 +23,7 @@ extern const struct v4l2_ioctl_ops rockchip_vpu_dec_ioctl_ops;
 extern const struct vb2_ops rockchip_vpu_enc_queue_ops;
 extern const struct vb2_ops rockchip_vpu_dec_queue_ops;
 
+void *rockchip_vpu_find_control_data(struct rockchip_vpu_ctx *ctx, unsigned int id);
 void rockchip_vpu_enc_reset_src_fmt(struct rockchip_vpu_dev *vpu,
 				    struct rockchip_vpu_ctx *ctx);
 void rockchip_vpu_enc_reset_dst_fmt(struct rockchip_vpu_dev *vpu,
diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c b/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
index 51792f70441d..df4c4e953742 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
@@ -272,26 +272,77 @@ static int rockchip_vpu_s_ctrl(struct v4l2_ctrl *ctrl)
 	return 0;
 }
 
+void *rockchip_vpu_find_control_data(struct rockchip_vpu_ctx *ctx, unsigned int id)
+{
+	unsigned int i;
+
+	for (i = 0; i < ctx->num_ctrls; i++) {
+		if (!ctx->ctrls[i])
+			continue;
+		if (ctx->ctrls[i]->id == id)
+			return ctx->ctrls[i]->p_cur.p;
+	}
+	return NULL;
+}
+
 static const struct v4l2_ctrl_ops rockchip_vpu_ctrl_ops = {
 	.s_ctrl = rockchip_vpu_s_ctrl,
 };
 
+static struct rockchip_vpu_ctrl controls[] = {
+	{
+		.id = V4L2_CID_JPEG_COMPRESSION_QUALITY,
+		.codec = RK_VPU_JPEG_ENCODER,
+		.is_std = 1,
+		.cfg = {
+			.min = 5,
+			.max = 100,
+			.step = 1,
+			.def = 50,
+		},
+	},
+};
+
 static int rockchip_vpu_ctrls_setup(struct rockchip_vpu_dev *vpu,
 				    struct rockchip_vpu_ctx *ctx)
 {
-	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 1);
-	if (vpu->variant->codec & RK_VPU_CODEC_JPEG) {
-		v4l2_ctrl_new_std(&ctx->ctrl_handler, &rockchip_vpu_ctrl_ops,
-				  V4L2_CID_JPEG_COMPRESSION_QUALITY,
-				  5, 100, 1, 50);
+	int j, i, num_ctrls = ARRAY_SIZE(controls);
+	int allowed_codecs;
+
+	if (ctx->is_enc)
+		allowed_codecs = vpu->variant->codec & RK_VPU_ENCODERS;
+	else
+		allowed_codecs = vpu->variant->codec & RK_VPU_DECODERS;
+
+	if (num_ctrls > ARRAY_SIZE(ctx->ctrls)) {
+		vpu_err("context control array not large enough\n");
+		return -EINVAL;
+	}
+
+	v4l2_ctrl_handler_init(&ctx->ctrl_handler, num_ctrls);
+
+	for (i = 0, j = 0; i < num_ctrls; i++) {
+		if (!(allowed_codecs & controls[i].codec))
+			continue;
+		if (controls[i].is_std) {
+			v4l2_ctrl_new_std(&ctx->ctrl_handler, &rockchip_vpu_ctrl_ops,
+					  controls[i].id, controls[i].cfg.min, controls[i].cfg.max,
+					  controls[i].cfg.step, controls[i].cfg.def);
+		} else {
+			controls[i].cfg.id = controls[i].id;
+			ctx->ctrls[j++] = v4l2_ctrl_new_custom(&ctx->ctrl_handler,
+							       &controls[i].cfg, NULL);
+		}
+
 		if (ctx->ctrl_handler.error) {
-			vpu_err("Adding JPEG control failed %d\n",
+			vpu_err("Adding control (%d) failed %d\n",
+				controls[i].id,
 				ctx->ctrl_handler.error);
 			v4l2_ctrl_handler_free(&ctx->ctrl_handler);
 			return ctx->ctrl_handler.error;
 		}
 	}
-
+	ctx->num_ctrls = j;
 	return v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
 }
 
-- 
2.20.1

