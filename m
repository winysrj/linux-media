Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64178 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab2KOWG3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 17:06:29 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so1258234eek.19
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2012 14:06:28 -0800 (PST)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: dron0gus@gmail.com, tomasz.figa@gmail.com,
	oselas@community.pengutronix.de, Andrey Gusakov <dron_gus@mail.ru>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH RFC v3 2/3] s3c-camif: Add image effect controls
Date: Thu, 15 Nov 2012 23:05:14 +0100
Message-Id: <1353017115-11492-3-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1353017115-11492-1-git-send-email-sylvester.nawrocki@gmail.com>
References: <1353017115-11492-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrey Gusakov <dron_gus@mail.ru>

Add v4l2 controls for the camif image effects. V4L2_CID_COLORFX
control selects an image effect and V4L2_CID_COLORFX_CBCR allows
to adjust CR/CR coefficients when V4L2_CID_COLORFX is set to
V4L2_COLORFX_SET_CBCR.
On s3c64xx the effects are enabled for both capture and preview
channels for compatibility with s3c2450.

The control values are cached to prevent races as they are accessed
in an interrupt context.

An additional .has_img_effect field in struct s3c_camif_variant
is used to tell if a given CAMIF revision supports image effects
or not.

Signed-off-by: Andrey Gusakov <dron0gus@gmail.com>
Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 drivers/media/platform/s3c-camif/camif-capture.c |   61 ++++++++++++++++++---
 drivers/media/platform/s3c-camif/camif-core.c    |    1 +
 drivers/media/platform/s3c-camif/camif-core.h    |   13 ++++-
 drivers/media/platform/s3c-camif/camif-regs.c    |   49 +++++++++++++----
 drivers/media/platform/s3c-camif/camif-regs.h    |    6 ++-
 5 files changed, 107 insertions(+), 23 deletions(-)

diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 8daf684..08d31dc 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -67,7 +67,7 @@ static void camif_prepare_dma_offset(struct camif_vp *vp)
 
 static int s3c_camif_hw_init(struct camif_dev *camif, struct camif_vp *vp)
 {
-	unsigned int ip_rev = camif->variant->ip_revision;
+	const struct s3c_camif_variant *variant = camif->variant;
 	unsigned long flags;
 
 	if (camif->sensor.sd == NULL || vp->out_fmt == NULL)
@@ -75,13 +75,16 @@ static int s3c_camif_hw_init(struct camif_dev *camif, struct camif_vp *vp)
 
 	spin_lock_irqsave(&camif->slock, flags);
 
-	if (ip_rev == S3C244X_CAMIF_IP_REV)
+	if (variant->ip_revision == S3C244X_CAMIF_IP_REV)
 		camif_hw_clear_fifo_overflow(vp);
 	camif_hw_set_camera_bus(camif);
 	camif_hw_set_source_format(camif);
 	camif_hw_set_camera_crop(camif);
-	camif_hw_set_test_pattern(camif, camif->test_pattern->val);
-	if (ip_rev == S3C6410_CAMIF_IP_REV)
+	camif_hw_set_test_pattern(camif, camif->test_pattern);
+	if (variant->has_img_effect)
+		camif_hw_set_effect(camif, camif->colorfx,
+				camif->colorfx_cb, camif->colorfx_cr);
+	if (variant->ip_revision == S3C6410_CAMIF_IP_REV)
 		camif_hw_set_input_path(vp);
 	camif_cfg_video_path(vp);
 	vp->state &= ~ST_VP_CONFIG;
@@ -108,8 +111,6 @@ static int s3c_camif_hw_vp_init(struct camif_dev *camif, struct camif_vp *vp)
 	if (ip_rev == S3C244X_CAMIF_IP_REV)
 		camif_hw_clear_fifo_overflow(vp);
 	camif_cfg_video_path(vp);
-	if (ip_rev == S3C6410_CAMIF_IP_REV)
-		camif_hw_set_effect(vp, false);
 	vp->state &= ~ST_VP_CONFIG;
 
 	spin_unlock_irqrestore(&camif->slock, flags);
@@ -373,7 +374,10 @@ irqreturn_t s3c_camif_irq_handler(int irq, void *priv)
 		camif_hw_set_camera_crop(camif);
 		camif_hw_set_scaler(vp);
 		camif_hw_set_flip(vp);
-		camif_hw_set_test_pattern(camif, camif->test_pattern->val);
+		camif_hw_set_test_pattern(camif, camif->test_pattern);
+		if (camif->variant->has_img_effect)
+			camif_hw_set_effect(camif, camif->colorfx,
+				    camif->colorfx_cb, camif->colorfx_cr);
 		vp->state &= ~ST_VP_CONFIG;
 	}
 unlock:
@@ -1521,6 +1525,33 @@ static int s3c_camif_subdev_s_ctrl(struct v4l2_ctrl *ctrl)
 	unsigned long flags;
 
 	spin_lock_irqsave(&camif->slock, flags);
+
+	switch (ctrl->id) {
+	case V4L2_CID_COLORFX:
+		if (camif->ctrl_colorfx_cbcr->is_new) {
+			camif->colorfx = camif->ctrl_colorfx->val;
+			/* Set Cb, Cr */
+			switch (ctrl->val) {
+			case V4L2_COLORFX_SEPIA:
+				camif->ctrl_colorfx_cbcr->val = 0x7391;
+				break;
+			case V4L2_COLORFX_SET_CBCR: /* noop */
+				break;
+			default:
+				/* for V4L2_COLORFX_BW and others */
+				camif->ctrl_colorfx_cbcr->val = 0x8080;
+			}
+		}
+		camif->colorfx_cb = camif->ctrl_colorfx_cbcr->val & 0xff;
+		camif->colorfx_cr = camif->ctrl_colorfx_cbcr->val >> 8;
+		break;
+	case V4L2_CID_TEST_PATTERN:
+		camif->test_pattern = camif->ctrl_test_pattern->val;
+		break;
+	default:
+		WARN_ON(1);
+	}
+
 	camif->vp[VP_CODEC].state |= ST_VP_CONFIG;
 	camif->vp[VP_PREVIEW].state |= ST_VP_CONFIG;
 	spin_unlock_irqrestore(&camif->slock, flags);
@@ -1558,16 +1589,28 @@ int s3c_camif_create_subdev(struct camif_dev *camif)
 	if (ret)
 		return ret;
 
-	v4l2_ctrl_handler_init(handler, 1);
-	camif->test_pattern = v4l2_ctrl_new_std_menu_items(handler,
+	v4l2_ctrl_handler_init(handler, 3);
+	camif->ctrl_test_pattern = v4l2_ctrl_new_std_menu_items(handler,
 			&s3c_camif_subdev_ctrl_ops, V4L2_CID_TEST_PATTERN,
 			ARRAY_SIZE(s3c_camif_test_pattern_menu) - 1, 0, 0,
 			s3c_camif_test_pattern_menu);
+
+	camif->ctrl_colorfx = v4l2_ctrl_new_std_menu(handler,
+				&s3c_camif_subdev_ctrl_ops,
+				V4L2_CID_COLORFX, V4L2_COLORFX_SET_CBCR,
+				~0x981f, V4L2_COLORFX_NONE);
+
+	camif->ctrl_colorfx_cbcr = v4l2_ctrl_new_std(handler,
+				&s3c_camif_subdev_ctrl_ops,
+				V4L2_CID_COLORFX_CBCR, 0, 0xffff, 1, 0);
 	if (handler->error) {
+		v4l2_ctrl_handler_free(handler);
 		media_entity_cleanup(&sd->entity);
 		return handler->error;
 	}
 
+	v4l2_ctrl_auto_cluster(2, &camif->ctrl_colorfx,
+			       V4L2_COLORFX_SET_CBCR, false);
 	sd->ctrl_handler = handler;
 	v4l2_set_subdevdata(sd, camif);
 
diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
index 26e2e67..0dd6537 100644
--- a/drivers/media/platform/s3c-camif/camif-core.c
+++ b/drivers/media/platform/s3c-camif/camif-core.c
@@ -617,6 +617,7 @@ static const struct s3c_camif_variant s3c6410_camif_variant = {
 		.win_hor_offset_align	= 8,
 	},
 	.ip_revision = S3C6410_CAMIF_IP_REV,
+	.has_img_effect = 1,
 	.vp_offset = 0x20,
 };
 
diff --git a/drivers/media/platform/s3c-camif/camif-core.h b/drivers/media/platform/s3c-camif/camif-core.h
index d64c0e2..261134b 100644
--- a/drivers/media/platform/s3c-camif/camif-core.h
+++ b/drivers/media/platform/s3c-camif/camif-core.h
@@ -39,6 +39,8 @@
 #define CAMIF_STOP_TIMEOUT	1500 /* ms */
 
 #define S3C244X_CAMIF_IP_REV	0x20 /* 2.0 */
+#define S3C2450_CAMIF_IP_REV	0x30 /* 3.0 - not implemented, not tested */
+#define S3C6400_CAMIF_IP_REV	0x31 /* 3.1 - not implemented, not tested */
 #define S3C6410_CAMIF_IP_REV	0x32 /* 3.2 */
 
 /* struct camif_vp::state */
@@ -153,6 +155,7 @@ struct s3c_camif_variant {
 	struct vp_pix_limits vp_pix_limits[2];
 	struct camif_pix_limits pix_limits;
 	u8 ip_revision;
+	u8 has_img_effect;
 	unsigned int vp_offset;
 };
 
@@ -277,7 +280,15 @@ struct camif_dev {
 	struct media_pipeline		*m_pipeline;
 
 	struct v4l2_ctrl_handler	ctrl_handler;
-	struct v4l2_ctrl		*test_pattern;
+	struct v4l2_ctrl		*ctrl_test_pattern;
+	struct {
+		struct v4l2_ctrl	*ctrl_colorfx;
+		struct v4l2_ctrl	*ctrl_colorfx_cbcr;
+	};
+	u8				test_pattern;
+	u8				colorfx;
+	u8				colorfx_cb;
+	u8				colorfx_cr;
 
 	struct camif_vp			vp[CAMIF_VP_NUM];
 	struct vb2_alloc_ctx		*alloc_ctx;
diff --git a/drivers/media/platform/s3c-camif/camif-regs.c b/drivers/media/platform/s3c-camif/camif-regs.c
index 07485a6..1a3b4fc 100644
--- a/drivers/media/platform/s3c-camif/camif-regs.c
+++ b/drivers/media/platform/s3c-camif/camif-regs.c
@@ -57,6 +57,44 @@ void camif_hw_set_test_pattern(struct camif_dev *camif, unsigned int pattern)
 	camif_write(camif, S3C_CAMIF_REG_CIGCTRL, cfg);
 }
 
+void camif_hw_set_effect(struct camif_dev *camif, unsigned int effect,
+			unsigned int cr, unsigned int cb)
+{
+	static const struct v4l2_control colorfx[] = {
+		{ V4L2_COLORFX_NONE,		CIIMGEFF_FIN_BYPASS },
+		{ V4L2_COLORFX_BW,		CIIMGEFF_FIN_ARBITRARY },
+		{ V4L2_COLORFX_SEPIA,		CIIMGEFF_FIN_ARBITRARY },
+		{ V4L2_COLORFX_NEGATIVE,	CIIMGEFF_FIN_NEGATIVE },
+		{ V4L2_COLORFX_ART_FREEZE,	CIIMGEFF_FIN_ARTFREEZE },
+		{ V4L2_COLORFX_EMBOSS,		CIIMGEFF_FIN_EMBOSSING },
+		{ V4L2_COLORFX_SILHOUETTE,	CIIMGEFF_FIN_SILHOUETTE },
+		{ V4L2_COLORFX_SET_CBCR,	CIIMGEFF_FIN_ARBITRARY },
+	};
+	unsigned int i, cfg;
+
+	for (i = 0; i < ARRAY_SIZE(colorfx); i++)
+		if (colorfx[i].id == effect)
+			break;
+
+	if (i == ARRAY_SIZE(colorfx))
+		return;
+
+	cfg = camif_read(camif, S3C_CAMIF_REG_CIIMGEFF(camif->vp->offset));
+	/* Set effect */
+	cfg &= ~CIIMGEFF_FIN_MASK;
+	cfg |= colorfx[i].value;
+	/* Set both paths */
+	if (camif->variant->ip_revision >= S3C6400_CAMIF_IP_REV) {
+		if (effect == V4L2_COLORFX_NONE)
+			cfg &= ~CIIMGEFF_IE_ENABLE_MASK;
+		else
+			cfg |= CIIMGEFF_IE_ENABLE_MASK;
+	}
+	cfg &= ~CIIMGEFF_PAT_CBCR_MASK;
+	cfg |= cr | (cb << 13);
+	camif_write(camif, S3C_CAMIF_REG_CIIMGEFF(camif->vp->offset), cfg);
+}
+
 static const u32 src_pixfmt_map[8][2] = {
 	{ V4L2_MBUS_FMT_YUYV8_2X8, CISRCFMT_ORDER422_YCBYCR },
 	{ V4L2_MBUS_FMT_YVYU8_2X8, CISRCFMT_ORDER422_YCRYCB },
@@ -473,17 +511,6 @@ void camif_hw_set_lastirq(struct camif_vp *vp, int enable)
 	camif_write(vp->camif, addr, cfg);
 }
 
-void camif_hw_set_effect(struct camif_vp *vp, bool active)
-{
-	u32 cfg = 0;
-
-	if (active) {
-		/* TODO: effects support on 64xx */
-	}
-
-	camif_write(vp->camif, S3C_CAMIF_REG_CIIMGEFF, cfg);
-}
-
 void camif_hw_enable_capture(struct camif_vp *vp)
 {
 	struct camif_dev *camif = vp->camif;
diff --git a/drivers/media/platform/s3c-camif/camif-regs.h b/drivers/media/platform/s3c-camif/camif-regs.h
index ced0152..af2d472 100644
--- a/drivers/media/platform/s3c-camif/camif-regs.h
+++ b/drivers/media/platform/s3c-camif/camif-regs.h
@@ -177,8 +177,9 @@
 #define S3C_CAMIF_REG_CICPTSEQ			0xc4
 
 /* Image effects */
-#define S3C_CAMIF_REG_CIIMGEFF			0xd0
+#define S3C_CAMIF_REG_CIIMGEFF(_offs)		(0xb0 + (_offs))
 #define  CIIMGEFF_IE_ENABLE(id)			(1 << (30 + (id)))
+#define  CIIMGEFF_IE_ENABLE_MASK		(3 << 30)
 /* Image effect: 1 - after scaler, 0 - before scaler */
 #define  CIIMGEFF_IE_AFTER_SC			(1 << 29)
 #define  CIIMGEFF_FIN_MASK			(7 << 26)
@@ -243,7 +244,6 @@ void camif_hw_clear_fifo_overflow(struct camif_vp *vp);
 void camif_hw_set_lastirq(struct camif_vp *vp, int enable);
 void camif_hw_set_input_path(struct camif_vp *vp);
 void camif_hw_enable_scaler(struct camif_vp *vp, bool on);
-void camif_hw_set_effect(struct camif_vp *vp, bool active);
 void camif_hw_enable_capture(struct camif_vp *vp);
 void camif_hw_disable_capture(struct camif_vp *vp);
 void camif_hw_set_camera_bus(struct camif_dev *camif);
@@ -254,6 +254,8 @@ void camif_hw_set_flip(struct camif_vp *vp);
 void camif_hw_set_output_dma(struct camif_vp *vp);
 void camif_hw_set_target_format(struct camif_vp *vp);
 void camif_hw_set_test_pattern(struct camif_dev *camif, unsigned int pattern);
+void camif_hw_set_effect(struct camif_dev *camif, unsigned int effect,
+			unsigned int cr, unsigned int cb);
 void camif_hw_set_output_addr(struct camif_vp *vp, struct camif_addr *paddr,
 			      int index);
 void camif_hw_dump_regs(struct camif_dev *camif, const char *label);
-- 
1.7.4.1

