Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:50761 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755981AbbFCOAL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2015 10:00:11 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: guennadi liakhovetski <g.liakhovetski@gmx.de>,
	sergei shtylyov <sergei.shtylyov@cogentembedded.com>,
	hans verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 10/15] media: rcar_vin: Use correct pad number in try_fmt
Date: Wed,  3 Jun 2015 14:59:57 +0100
Message-Id: <1433340002-1691-11-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1433340002-1691-1-git-send-email-william.towle@codethink.co.uk>
References: <1433340002-1691-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix rcar_vin_try_fmt to use the correct pad number when calling the
subdev set_fmt. Previously pad number 0 was always used, resulting in
EINVAL if the subdev cares about the pad number (e.g. ADV7612).

Signed-off-by: William Towle <william.towle@codethink.co.uk>
Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>
---
 drivers/media/platform/soc_camera/rcar_vin.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 00c1034..cc993bc 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1697,7 +1697,7 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct v4l2_subdev_pad_config pad_cfg;
+	struct v4l2_subdev_pad_config *pad_cfg;
 	struct v4l2_subdev_format format = {
 		.which = V4L2_SUBDEV_FORMAT_TRY,
 	};
@@ -1706,6 +1706,8 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 	int width, height;
 	int ret;
 
+	pad_cfg = v4l2_subdev_alloc_pad_config(sd);
+
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
 		xlate = icd->current_fmt;
@@ -1734,10 +1736,15 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 	mf->code = xlate->code;
 	mf->colorspace = pix->colorspace;
 
-	ret = v4l2_device_call_until_err(sd->v4l2_dev, soc_camera_grp_id(icd),
-					 pad, set_fmt, &pad_cfg, &format);
-	if (ret < 0)
+	format.pad = icd->src_pad_idx;
+	ret = v4l2_device_call_until_err(sd->v4l2_dev,
+					soc_camera_grp_id(icd), pad,
+					set_fmt, pad_cfg,
+					&format);
+	if (ret < 0) {
+		v4l2_subdev_free_pad_config(pad_cfg);
 		return ret;
+	}
 
 	/* Adjust only if VIN cannot scale */
 	if (pix->width > mf->width * 2)
@@ -1759,13 +1766,15 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 			 */
 			mf->width = VIN_MAX_WIDTH;
 			mf->height = VIN_MAX_HEIGHT;
+			format.pad = icd->src_pad_idx;
 			ret = v4l2_device_call_until_err(sd->v4l2_dev,
 							 soc_camera_grp_id(icd),
-							 pad, set_fmt, &pad_cfg,
+							 pad, set_fmt, pad_cfg,
 							 &format);
 			if (ret < 0) {
 				dev_err(icd->parent,
 					"client try_fmt() = %d\n", ret);
+				v4l2_subdev_free_pad_config(pad_cfg);
 				return ret;
 			}
 		}
@@ -1776,6 +1785,7 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 			pix->height = height;
 	}
 
+	v4l2_subdev_free_pad_config(pad_cfg);
 	return ret;
 }
 
-- 
1.7.10.4

