Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:59517 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751952AbaLSOxI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 09:53:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	prabhakar.csengg@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 09/11] v4l2-subdev: add support for the new enum_frame_size which field.
Date: Fri, 19 Dec 2014 15:51:34 +0100
Message-Id: <1419000696-25202-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1419000696-25202-1-git-send-email-hverkuil@xs4all.nl>
References: <1419000696-25202-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           | 23 ++++++++++++++++++----
 drivers/media/platform/omap3isp/ispccdc.c          |  4 ++--
 drivers/media/platform/omap3isp/ispccp2.c          |  4 ++--
 drivers/media/platform/omap3isp/ispcsi2.c          |  4 ++--
 drivers/media/platform/omap3isp/isppreview.c       |  4 ++--
 drivers/media/platform/omap3isp/ispresizer.c       |  4 ++--
 drivers/media/platform/vsp1/vsp1_hsit.c            |  4 +++-
 drivers/media/platform/vsp1/vsp1_lif.c             |  4 +++-
 drivers/media/platform/vsp1/vsp1_lut.c             |  4 +++-
 drivers/media/platform/vsp1/vsp1_rwpf.c            |  3 ++-
 drivers/media/platform/vsp1/vsp1_sru.c             |  4 +++-
 drivers/media/platform/vsp1/vsp1_uds.c             |  4 +++-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |  6 ++----
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |  6 ++----
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |  4 ++--
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |  6 ++----
 drivers/staging/media/omap4iss/iss_csi2.c          |  4 ++--
 drivers/staging/media/omap4iss/iss_ipipe.c         |  4 ++--
 drivers/staging/media/omap4iss/iss_ipipeif.c       |  6 ++----
 drivers/staging/media/omap4iss/iss_resizer.c       |  6 ++----
 20 files changed, 62 insertions(+), 46 deletions(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index 257a335..08b234b 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1251,6 +1251,7 @@ static int s5c73m3_oif_enum_frame_size(struct v4l2_subdev *sd,
 				   struct v4l2_subdev_pad_config *cfg,
 				   struct v4l2_subdev_frame_size_enum *fse)
 {
+	struct s5c73m3 *state = oif_sd_to_s5c73m3(sd);
 	int idx;
 
 	if (fse->pad == OIF_SOURCE_PAD) {
@@ -1260,11 +1261,25 @@ static int s5c73m3_oif_enum_frame_size(struct v4l2_subdev *sd,
 		switch (fse->code) {
 		case S5C73M3_JPEG_FMT:
 		case S5C73M3_ISP_FMT: {
-			struct v4l2_mbus_framefmt *mf =
-				v4l2_subdev_get_try_format(sd, cfg, OIF_ISP_PAD);
+			unsigned w, h;
+
+			if (fse->which == V4L2_SUBDEV_FORMAT_TRY) {
+				struct v4l2_mbus_framefmt *mf;
+
+				mf = v4l2_subdev_get_try_format(sd, cfg,
+								OIF_ISP_PAD);
+
+				w = mf->width;
+				h = mf->height;
+			} else {
+				const struct s5c73m3_frame_size *fs;
 
-			fse->max_width = fse->min_width = mf->width;
-			fse->max_height = fse->min_height = mf->height;
+				fs = state->oif_pix_size[RES_ISP];
+				w = fs->width;
+				h = fs->height;
+			}
+			fse->max_width = fse->min_width = w;
+			fse->max_height = fse->min_height = h;
 			return 0;
 		}
 		default:
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 818aa52..6e0291b 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -2195,7 +2195,7 @@ static int ccdc_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	ccdc_try_format(ccdc, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	ccdc_try_format(ccdc, cfg, fse->pad, &format, fse->which);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
 
@@ -2205,7 +2205,7 @@ static int ccdc_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	ccdc_try_format(ccdc, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	ccdc_try_format(ccdc, cfg, fse->pad, &format, fse->which);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
 
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index 1d79368..44c20fa 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -723,7 +723,7 @@ static int ccp2_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	ccp2_try_format(ccp2, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	ccp2_try_format(ccp2, cfg, fse->pad, &format, fse->which);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
 
@@ -733,7 +733,7 @@ static int ccp2_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	ccp2_try_format(ccp2, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	ccp2_try_format(ccp2, cfg, fse->pad, &format, fse->which);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
 
diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index bde734c..bbadf66 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -944,7 +944,7 @@ static int csi2_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	csi2_try_format(csi2, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	csi2_try_format(csi2, cfg, fse->pad, &format, fse->which);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
 
@@ -954,7 +954,7 @@ static int csi2_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	csi2_try_format(csi2, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	csi2_try_format(csi2, cfg, fse->pad, &format, fse->which);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
 
diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index 0571c57..15cb254 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -1905,7 +1905,7 @@ static int preview_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	preview_try_format(prev, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	preview_try_format(prev, cfg, fse->pad, &format, fse->which);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
 
@@ -1915,7 +1915,7 @@ static int preview_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	preview_try_format(prev, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	preview_try_format(prev, cfg, fse->pad, &format, fse->which);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
 
diff --git a/drivers/media/platform/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
index 02549fa8..7cfb43d 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -1451,7 +1451,7 @@ static int resizer_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	resizer_try_format(res, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	resizer_try_format(res, cfg, fse->pad, &format, fse->which);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
 
@@ -1461,7 +1461,7 @@ static int resizer_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	resizer_try_format(res, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	resizer_try_format(res, cfg, fse->pad, &format, fse->which);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
 
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index 89c230d..2e15c73 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -81,9 +81,11 @@ static int hsit_enum_frame_size(struct v4l2_subdev *subdev,
 				struct v4l2_subdev_pad_config *cfg,
 				struct v4l2_subdev_frame_size_enum *fse)
 {
+	struct vsp1_hsit *hsit = to_hsit(subdev);
 	struct v4l2_mbus_framefmt *format;
 
-	format = v4l2_subdev_get_try_format(subdev, cfg, fse->pad);
+	format = vsp1_entity_get_pad_format(&hsit->entity, cfg, fse->pad,
+					    fse->which);
 
 	if (fse->index || fse->code != format->code)
 		return -EINVAL;
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index 60f1bd8..39fa5ef 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -109,9 +109,11 @@ static int lif_enum_frame_size(struct v4l2_subdev *subdev,
 			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_frame_size_enum *fse)
 {
+	struct vsp1_lif *lif = to_lif(subdev);
 	struct v4l2_mbus_framefmt *format;
 
-	format = v4l2_subdev_get_try_format(subdev, cfg, LIF_PAD_SINK);
+	format = vsp1_entity_get_pad_format(&lif->entity, cfg, LIF_PAD_SINK,
+					    fse->which);
 
 	if (fse->index || fse->code != format->code)
 		return -EINVAL;
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 8aa8c11..656ec27 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -117,9 +117,11 @@ static int lut_enum_frame_size(struct v4l2_subdev *subdev,
 			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_frame_size_enum *fse)
 {
+	struct vsp1_lut *lut = to_lut(subdev);
 	struct v4l2_mbus_framefmt *format;
 
-	format = v4l2_subdev_get_try_format(subdev, cfg, fse->pad);
+	format = vsp1_entity_get_pad_format(&lut->entity, cfg,
+					    fse->pad, fse->which);
 
 	if (fse->index || fse->code != format->code)
 		return -EINVAL;
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index a083d85..fa71f46 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -48,7 +48,8 @@ int vsp1_rwpf_enum_frame_size(struct v4l2_subdev *subdev,
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
 	struct v4l2_mbus_framefmt *format;
 
-	format = v4l2_subdev_get_try_format(subdev, cfg, fse->pad);
+	format = vsp1_entity_get_pad_format(&rwpf->entity, cfg, fse->pad,
+					    fse->which);
 
 	if (fse->index || fse->code != format->code)
 		return -EINVAL;
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index 554340d..6310aca 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -200,9 +200,11 @@ static int sru_enum_frame_size(struct v4l2_subdev *subdev,
 			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_frame_size_enum *fse)
 {
+	struct vsp1_sru *sru = to_sru(subdev);
 	struct v4l2_mbus_framefmt *format;
 
-	format = v4l2_subdev_get_try_format(subdev, cfg, SRU_PAD_SINK);
+	format = vsp1_entity_get_pad_format(&sru->entity, cfg,
+					    SRU_PAD_SINK, fse->which);
 
 	if (fse->index || fse->code != format->code)
 		return -EINVAL;
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index ef4d307..ccc8243 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -204,9 +204,11 @@ static int uds_enum_frame_size(struct v4l2_subdev *subdev,
 			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_frame_size_enum *fse)
 {
+	struct vsp1_uds *uds = to_uds(subdev);
 	struct v4l2_mbus_framefmt *format;
 
-	format = v4l2_subdev_get_try_format(subdev, cfg, UDS_PAD_SINK);
+	format = vsp1_entity_get_pad_format(&uds->entity, cfg,
+					    UDS_PAD_SINK, fse->which);
 
 	if (fse->index || fse->code != format->code)
 		return -EINVAL;
diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 75fae655..0c2985c 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -1548,8 +1548,7 @@ ipipe_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	ipipe_try_format(ipipe, cfg, fse->pad, &format,
-			   V4L2_SUBDEV_FORMAT_TRY);
+	ipipe_try_format(ipipe, cfg, fse->pad, &format, fse->which);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
 
@@ -1559,8 +1558,7 @@ ipipe_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	ipipe_try_format(ipipe, cfg, fse->pad, &format,
-			   V4L2_SUBDEV_FORMAT_TRY);
+	ipipe_try_format(ipipe, cfg, fse->pad, &format, fse->which);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
 
diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
index aa27fc7..35c68ae 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
@@ -653,8 +653,7 @@ ipipeif_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *c
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	ipipeif_try_format(ipipeif, cfg, fse->pad, &format,
-			   V4L2_SUBDEV_FORMAT_TRY);
+	ipipeif_try_format(ipipeif, cfg, fse->pad, &format, fse->which);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
 
@@ -664,8 +663,7 @@ ipipeif_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *c
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	ipipeif_try_format(ipipeif, cfg, fse->pad, &format,
-			   V4L2_SUBDEV_FORMAT_TRY);
+	ipipeif_try_format(ipipeif, cfg, fse->pad, &format, fse->which);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
 
diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
index 55ae242..de05260 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
@@ -1489,7 +1489,7 @@ isif_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 	format.format.code = fse->code;
 	format.format.width = 1;
 	format.format.height = 1;
-	format.which = V4L2_SUBDEV_FORMAT_TRY;
+	format.which = fse->which;
 	isif_try_format(isif, cfg, &format);
 	fse->min_width = format.format.width;
 	fse->min_height = format.format.height;
@@ -1501,7 +1501,7 @@ isif_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 	format.format.code = fse->code;
 	format.format.width = -1;
 	format.format.height = -1;
-	format.which = V4L2_SUBDEV_FORMAT_TRY;
+	format.which = fse->which;
 	isif_try_format(isif, cfg, &format);
 	fse->max_width = format.format.width;
 	fse->max_height = format.format.height;
diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 2c1c3ed..42b146f 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -1484,8 +1484,7 @@ static int resizer_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	resizer_try_format(sd, cfg, fse->pad, &format,
-			    V4L2_SUBDEV_FORMAT_TRY);
+	resizer_try_format(sd, cfg, fse->pad, &format, fse->which);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
 
@@ -1495,8 +1494,7 @@ static int resizer_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	resizer_try_format(sd, cfg, fse->pad, &format,
-			   V4L2_SUBDEV_FORMAT_TRY);
+	resizer_try_format(sd, cfg, fse->pad, &format, fse->which);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
 
diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index ea3476f..f3059b0 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -918,7 +918,7 @@ static int csi2_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	csi2_try_format(csi2, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	csi2_try_format(csi2, cfg, fse->pad, &format, fse->which);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
 
@@ -928,7 +928,7 @@ static int csi2_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	csi2_try_format(csi2, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	csi2_try_format(csi2, cfg, fse->pad, &format, fse->which);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
 
diff --git a/drivers/staging/media/omap4iss/iss_ipipe.c b/drivers/staging/media/omap4iss/iss_ipipe.c
index 4e49620..47a82b0 100644
--- a/drivers/staging/media/omap4iss/iss_ipipe.c
+++ b/drivers/staging/media/omap4iss/iss_ipipe.c
@@ -280,7 +280,7 @@ static int ipipe_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	ipipe_try_format(ipipe, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	ipipe_try_format(ipipe, cfg, fse->pad, &format, fse->which);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
 
@@ -290,7 +290,7 @@ static int ipipe_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	ipipe_try_format(ipipe, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	ipipe_try_format(ipipe, cfg, fse->pad, &format, fse->which);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
 
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index 319b96f..a21965c 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -508,8 +508,7 @@ static int ipipeif_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	ipipeif_try_format(ipipeif, cfg, fse->pad, &format,
-			   V4L2_SUBDEV_FORMAT_TRY);
+	ipipeif_try_format(ipipeif, cfg, fse->pad, &format, fse->which);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
 
@@ -519,8 +518,7 @@ static int ipipeif_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	ipipeif_try_format(ipipeif, cfg, fse->pad, &format,
-			   V4L2_SUBDEV_FORMAT_TRY);
+	ipipeif_try_format(ipipeif, cfg, fse->pad, &format, fse->which);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
 
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index 4967373..26ca4c6 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -570,8 +570,7 @@ static int resizer_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	resizer_try_format(resizer, cfg, fse->pad, &format,
-			   V4L2_SUBDEV_FORMAT_TRY);
+	resizer_try_format(resizer, cfg, fse->pad, &format, fse->which);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
 
@@ -581,8 +580,7 @@ static int resizer_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	resizer_try_format(resizer, cfg, fse->pad, &format,
-			   V4L2_SUBDEV_FORMAT_TRY);
+	resizer_try_format(resizer, cfg, fse->pad, &format, fse->which);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
 
-- 
2.1.3

