Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:56650 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753370AbbEUJDZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 05:03:25 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com,
	hverkuil@xs4all.nl, rob.taylor@codethink.co.uk
Subject: [PATCH 09/20] media: rcar_vin: Use correct pad number in try_fmt
Date: Wed, 20 May 2015 17:39:29 +0100
Message-Id: <1432139980-12619-10-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Rob Taylor <rob.taylor@codethink.co.uk>

Fix rcar_vin_try_fmt to use the correct pad number when calling the
subdev set_fmt. Previously pad number 0 was always used, resulting in
EINVAL if the subdev cares about the pad number (e.g. ADV7612).

Signed-off-by: William Towle  Taylor <rob.taylor@codethink.co.uk>
Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>
---
 drivers/media/platform/soc_camera/rcar_vin.c |   29 +++++++++++++++++---------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index b4e9b43..571ab20 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1707,12 +1707,13 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct v4l2_subdev_pad_config pad_cfg;
+	struct v4l2_subdev_pad_config pad_cfg[sd->entity.num_pads];
 	struct v4l2_subdev_format format = {
 		.which = V4L2_SUBDEV_FORMAT_TRY,
 	};
 	struct v4l2_mbus_framefmt *mf = &format.format;
 	__u32 pixfmt = pix->pixelformat;
+	struct media_pad *remote_pad;
 	int width, height;
 	int ret;
 
@@ -1744,17 +1745,24 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 	mf->code = xlate->code;
 	mf->colorspace = pix->colorspace;
 
-	ret = v4l2_device_call_until_err(sd->v4l2_dev, soc_camera_grp_id(icd),
-					 pad, set_fmt, &pad_cfg, &format);
+	remote_pad = media_entity_remote_pad(
+				&icd->vdev->entity.pads[0]);
+	format.pad = remote_pad->index;
+
+	ret = v4l2_device_call_until_err(sd->v4l2_dev,
+					soc_camera_grp_id(icd), pad,
+					set_fmt, pad_cfg,
+					&format);
 	if (ret < 0)
 		return ret;
 
-	/* Adjust only if VIN cannot scale */
-	if (pix->width > mf->width * 2)
-		pix->width = mf->width * 2;
-	if (pix->height > mf->height * 3)
-		pix->height = mf->height * 3;
-
+	/*  In case the driver has adjusted 'fmt' to match the
+	 *  resolution of the live stream, 'pix' needs to pass this
+	 *  change out so that the buffer userland creates for the
+	 *  captured image/video has these dimensions
+	 */
+	pix->width = mf->width;
+	pix->height = mf->height;
 	pix->field = mf->field;
 	pix->colorspace = mf->colorspace;
 
@@ -1769,9 +1777,10 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 			 */
 			mf->width = VIN_MAX_WIDTH;
 			mf->height = VIN_MAX_HEIGHT;
+			format.pad = remote_pad->index;
 			ret = v4l2_device_call_until_err(sd->v4l2_dev,
 							 soc_camera_grp_id(icd),
-							 pad, set_fmt, &pad_cfg,
+							 pad, set_fmt, pad_cfg,
 							 &format);
 			if (ret < 0) {
 				dev_err(icd->parent,
-- 
1.7.10.4

