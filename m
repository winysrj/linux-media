Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:49645 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751862AbbFYJbO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 05:31:14 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 10/15] media: rcar_vin: Use correct pad number in try_fmt
Date: Thu, 25 Jun 2015 10:31:04 +0100
Message-Id: <1435224669-23672-11-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1435224669-23672-1-git-send-email-william.towle@codethink.co.uk>
References: <1435224669-23672-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix rcar_vin_try_fmt's use of an inappropriate pad number when calling
the subdev set_fmt function - for the ADV7612, IDs should be non-zero.

Signed-off-by: William Towle <william.towle@codethink.co.uk>
Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>
---
 drivers/media/platform/soc_camera/rcar_vin.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 00c1034..1023c5b 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1697,14 +1697,18 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct v4l2_subdev_pad_config pad_cfg;
+	struct v4l2_subdev_pad_config *pad_cfg;
 	struct v4l2_subdev_format format = {
 		.which = V4L2_SUBDEV_FORMAT_TRY,
 	};
 	struct v4l2_mbus_framefmt *mf = &format.format;
 	__u32 pixfmt = pix->pixelformat;
 	int width, height;
-	int ret;
+	int ret= -ENOMEM;
+
+	pad_cfg = v4l2_subdev_alloc_pad_config(sd);
+	if (pad_cfg == NULL)
+		goto out;
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
@@ -1734,10 +1738,11 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 	mf->code = xlate->code;
 	mf->colorspace = pix->colorspace;
 
+	format.pad = icd->src_pad_idx;
 	ret = v4l2_device_call_until_err(sd->v4l2_dev, soc_camera_grp_id(icd),
-					 pad, set_fmt, &pad_cfg, &format);
+					 pad, set_fmt, pad_cfg, &format);
 	if (ret < 0)
-		return ret;
+		goto cleanup;
 
 	/* Adjust only if VIN cannot scale */
 	if (pix->width > mf->width * 2)
@@ -1761,12 +1766,12 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 			mf->height = VIN_MAX_HEIGHT;
 			ret = v4l2_device_call_until_err(sd->v4l2_dev,
 							 soc_camera_grp_id(icd),
-							 pad, set_fmt, &pad_cfg,
+							 pad, set_fmt, pad_cfg,
 							 &format);
 			if (ret < 0) {
 				dev_err(icd->parent,
 					"client try_fmt() = %d\n", ret);
-				return ret;
+				goto cleanup;
 			}
 		}
 		/* We will scale exactly */
@@ -1776,6 +1781,9 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 			pix->height = height;
 	}
 
+cleanup:
+	v4l2_subdev_free_pad_config(pad_cfg);
+out:
 	return ret;
 }
 
-- 
1.7.10.4

