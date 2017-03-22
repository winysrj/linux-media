Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35528 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752184AbdCVEdF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Mar 2017 00:33:05 -0400
From: Arushi Singhal <arushisinghal19971997@gmail.com>
To: outreachy-kernel@googlegroups.com
Cc: linux-media@vger.kernel.org, gregkh@linuxfoundation.org,
        mchehab@kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 2/3] staging: media: davinci_vpfe: Replace a bit shift by a use of BIT.
Date: Wed, 22 Mar 2017 09:56:08 +0530
Message-Id: <20170322042609.23525-3-arushisinghal19971997@gmail.com>
In-Reply-To: <20170322042609.23525-1-arushisinghal19971997@gmail.com>
References: <20170322042609.23525-1-arushisinghal19971997@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch replaces bit shifting on 1 with the BIT(x) macro.
This was done with coccinelle:
@@
constant c;
@@

-1 << c
+BIT(c)

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |  2 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |  2 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    | 26 +++++++++++-----------
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |  6 ++---
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 6a3434cebd79..7eeb53217168 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -1815,7 +1815,7 @@ vpfe_ipipe_init(struct vpfe_ipipe_device *ipipe, struct platform_device *pdev)
 	v4l2_subdev_init(sd, &ipipe_v4l2_ops);
 	sd->internal_ops = &ipipe_v4l2_internal_ops;
 	strlcpy(sd->name, "DAVINCI IPIPE", sizeof(sd->name));
-	sd->grp_id = 1 << 16;	/* group ID for davinci subdevs */
+	sd->grp_id = BIT(16);	/* group ID for davinci subdevs */
 	v4l2_set_subdevdata(sd, ipipe);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
index 46fd2c7f69c3..c07f028dd6be 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
@@ -1021,7 +1021,7 @@ int vpfe_ipipeif_init(struct vpfe_ipipeif_device *ipipeif,
 
 	sd->internal_ops = &ipipeif_v4l2_internal_ops;
 	strlcpy(sd->name, "DAVINCI IPIPEIF", sizeof(sd->name));
-	sd->grp_id = 1 << 16;	/* group ID for davinci subdevs */
+	sd->grp_id = BIT(16);	/* group ID for davinci subdevs */
 
 	v4l2_set_subdevdata(sd, ipipeif);
 
diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
index 569bcdc9ce2f..0d160c1257d2 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
@@ -821,7 +821,7 @@ isif_config_dfc(struct vpfe_isif_device *isif, struct vpfe_isif_dfc *vdfc)
 
 	/* Correct whole line or partial */
 	if (vdfc->corr_whole_line)
-		val |= 1 << ISIF_VDFC_CORR_WHOLE_LN_SHIFT;
+		val |= BIT(ISIF_VDFC_CORR_WHOLE_LN_SHIFT);
 
 	/* level shift value */
 	val |= (vdfc->def_level_shift & ISIF_VDFC_LEVEL_SHFT_MASK) <<
@@ -849,7 +849,7 @@ isif_config_dfc(struct vpfe_isif_device *isif, struct vpfe_isif_dfc *vdfc)
 
 	val = isif_read(isif->isif_cfg.base_addr, DFCMEMCTL);
 	/* set DFCMARST and set DFCMWR */
-	val |= 1 << ISIF_DFCMEMCTL_DFCMARST_SHIFT;
+	val |= BIT(ISIF_DFCMEMCTL_DFCMARST_SHIFT);
 	val |= 1;
 	isif_write(isif->isif_cfg.base_addr, val, DFCMEMCTL);
 
@@ -880,7 +880,7 @@ isif_config_dfc(struct vpfe_isif_device *isif, struct vpfe_isif_dfc *vdfc)
 		}
 		val = isif_read(isif->isif_cfg.base_addr, DFCMEMCTL);
 		/* clear DFCMARST and set DFCMWR */
-		val &= ~(1 << ISIF_DFCMEMCTL_DFCMARST_SHIFT);
+		val &= ~(BIT(ISIF_DFCMEMCTL_DFCMARST_SHIFT));
 		val |= 1;
 		isif_write(isif->isif_cfg.base_addr, val, DFCMEMCTL);
 
@@ -904,10 +904,10 @@ isif_config_dfc(struct vpfe_isif_device *isif, struct vpfe_isif_dfc *vdfc)
 			   DM365_ISIF_DFCMWR_MEMORY_WRITE, DFCMEMCTL);
 	}
 	/* enable VDFC */
-	isif_merge(isif->isif_cfg.base_addr, (1 << ISIF_VDFC_EN_SHIFT),
-		   (1 << ISIF_VDFC_EN_SHIFT), DFCCTL);
+	isif_merge(isif->isif_cfg.base_addr, (BIT(ISIF_VDFC_EN_SHIFT)),
+		   (BIT(ISIF_VDFC_EN_SHIFT)), DFCCTL);
 
-	isif_merge(isif->isif_cfg.base_addr, (1 << ISIF_VDFC_EN_SHIFT),
+	isif_merge(isif->isif_cfg.base_addr, (BIT(ISIF_VDFC_EN_SHIFT)),
 		   (0 << ISIF_VDFC_EN_SHIFT), DFCCTL);
 
 	isif_write(isif->isif_cfg.base_addr, 0x6, DFCMEMCTL);
@@ -1140,7 +1140,7 @@ static int isif_config_raw(struct v4l2_subdev *sd, int mode)
 	isif_write(isif->isif_cfg.base_addr, val, CGAMMAWD);
 	/* Configure DPCM compression settings */
 	if (params->v4l2_pix_fmt == V4L2_PIX_FMT_SGRBG10DPCM8) {
-		val =  1 << ISIF_DPCM_EN_SHIFT;
+		val =  BIT(ISIF_DPCM_EN_SHIFT);
 		val |= (params->dpcm_predictor &
 			ISIF_DPCM_PREDICTOR_MASK) << ISIF_DPCM_PREDICTOR_SHIFT;
 	}
@@ -1893,7 +1893,7 @@ static const struct v4l2_ctrl_config vpfe_isif_crgain = {
 	.name = "CRGAIN",
 	.type = V4L2_CTRL_TYPE_INTEGER,
 	.min = 0,
-	.max = (1 << 12) - 1,
+	.max = (BIT(12)) - 1,
 	.step = 1,
 	.def = 0,
 };
@@ -1904,7 +1904,7 @@ static const struct v4l2_ctrl_config vpfe_isif_cgrgain = {
 	.name = "CGRGAIN",
 	.type = V4L2_CTRL_TYPE_INTEGER,
 	.min = 0,
-	.max = (1 << 12) - 1,
+	.max = (BIT(12)) - 1,
 	.step = 1,
 	.def = 0,
 };
@@ -1915,7 +1915,7 @@ static const struct v4l2_ctrl_config vpfe_isif_cgbgain = {
 	.name = "CGBGAIN",
 	.type = V4L2_CTRL_TYPE_INTEGER,
 	.min = 0,
-	.max = (1 << 12) - 1,
+	.max = (BIT(12)) - 1,
 	.step = 1,
 	.def = 0,
 };
@@ -1926,7 +1926,7 @@ static const struct v4l2_ctrl_config vpfe_isif_cbgain = {
 	.name = "CBGAIN",
 	.type = V4L2_CTRL_TYPE_INTEGER,
 	.min = 0,
-	.max = (1 << 12) - 1,
+	.max = (BIT(12)) - 1,
 	.step = 1,
 	.def = 0,
 };
@@ -1937,7 +1937,7 @@ static const struct v4l2_ctrl_config vpfe_isif_gain_offset = {
 	.name = "Gain Offset",
 	.type = V4L2_CTRL_TYPE_INTEGER,
 	.min = 0,
-	.max = (1 << 12) - 1,
+	.max = (BIT(12)) - 1,
 	.step = 1,
 	.def = 0,
 };
@@ -2044,7 +2044,7 @@ int vpfe_isif_init(struct vpfe_isif_device *isif, struct platform_device *pdev)
 	v4l2_subdev_init(sd, &isif_v4l2_ops);
 	sd->internal_ops = &isif_v4l2_internal_ops;
 	strlcpy(sd->name, "DAVINCI ISIF", sizeof(sd->name));
-	sd->grp_id = 1 << 16;	/* group ID for davinci subdevs */
+	sd->grp_id = BIT(16);	/* group ID for davinci subdevs */
 	v4l2_set_subdevdata(sd, isif);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS | V4L2_SUBDEV_FL_HAS_DEVNODE;
 	pads[ISIF_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 857b0e847c5e..3b3469adaf91 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -1903,7 +1903,7 @@ int vpfe_resizer_init(struct vpfe_resizer_device *vpfe_rsz,
 	v4l2_subdev_init(sd, &resizer_v4l2_ops);
 	sd->internal_ops = &resizer_v4l2_internal_ops;
 	strlcpy(sd->name, "DAVINCI RESIZER CROP", sizeof(sd->name));
-	sd->grp_id = 1 << 16;	/* group ID for davinci subdevs */
+	sd->grp_id = BIT(16);	/* group ID for davinci subdevs */
 	v4l2_set_subdevdata(sd, vpfe_rsz);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
@@ -1927,7 +1927,7 @@ int vpfe_resizer_init(struct vpfe_resizer_device *vpfe_rsz,
 	v4l2_subdev_init(sd, &resizer_v4l2_ops);
 	sd->internal_ops = &resizer_v4l2_internal_ops;
 	strlcpy(sd->name, "DAVINCI RESIZER A", sizeof(sd->name));
-	sd->grp_id = 1 << 16;	/* group ID for davinci subdevs */
+	sd->grp_id = BIT(16);	/* group ID for davinci subdevs */
 	v4l2_set_subdevdata(sd, vpfe_rsz);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
@@ -1949,7 +1949,7 @@ int vpfe_resizer_init(struct vpfe_resizer_device *vpfe_rsz,
 	v4l2_subdev_init(sd, &resizer_v4l2_ops);
 	sd->internal_ops = &resizer_v4l2_internal_ops;
 	strlcpy(sd->name, "DAVINCI RESIZER B", sizeof(sd->name));
-	sd->grp_id = 1 << 16;	/* group ID for davinci subdevs */
+	sd->grp_id = BIT(16);	/* group ID for davinci subdevs */
 	v4l2_set_subdevdata(sd, vpfe_rsz);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
-- 
2.11.0
