Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:52408 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752344AbbE0QLA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2015 12:11:00 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 10/15] media: rcar_vin: Use correct pad number in try_fmt
Date: Wed, 27 May 2015 17:10:48 +0100
Message-Id: <1432743053-13479-11-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432743053-13479-1-git-send-email-william.towle@codethink.co.uk>
References: <1432743053-13479-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix rcar_vin_try_fmt to use the correct pad number when calling the
subdev set_fmt. Previously pad number 0 was always used, resulting in
EINVAL if the subdev cares about the pad number (e.g. ADV7612).

Signed-off-by: William Towle <william.towle@codethink.co.uk>
Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>
---
 drivers/media/platform/soc_camera/rcar_vin.c |   36 ++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 0df3212..5523d04 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1702,7 +1702,7 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct v4l2_subdev_pad_config pad_cfg;
+	struct v4l2_subdev_pad_config *pad_cfg = NULL;
 	struct v4l2_subdev_format format = {
 		.which = V4L2_SUBDEV_FORMAT_TRY,
 	};
@@ -1710,6 +1710,11 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 	__u32 pixfmt = pix->pixelformat;
 	int width, height;
 	int ret;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_pad *remote_pad;
+
+	pad_cfg = v4l2_subdev_alloc_pad_config(sd);
+#endif
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
@@ -1739,10 +1744,22 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 	mf->code = xlate->code;
 	mf->colorspace = pix->colorspace;
 
-	ret = v4l2_device_call_until_err(sd->v4l2_dev, soc_camera_grp_id(icd),
-					 pad, set_fmt, &pad_cfg, &format);
-	if (ret < 0)
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	remote_pad = media_entity_remote_pad(
+				&icd->vdev->entity.pads[0]);
+	format.pad = remote_pad->index;
+#endif
+
+	ret = v4l2_device_call_until_err(sd->v4l2_dev,
+					soc_camera_grp_id(icd), pad,
+					set_fmt, pad_cfg,
+					&format);
+	if (ret < 0) {
+#if defined(CONFIG_MEDIA_CONTROLLER)
+		v4l2_subdev_free_pad_config(pad_cfg);
+#endif
 		return ret;
+	}
 
 	/* Adjust only if VIN cannot scale */
 	if (pix->width > mf->width * 2)
@@ -1764,13 +1781,19 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 			 */
 			mf->width = VIN_MAX_WIDTH;
 			mf->height = VIN_MAX_HEIGHT;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+			format.pad = remote_pad->index;
+#endif
 			ret = v4l2_device_call_until_err(sd->v4l2_dev,
 							 soc_camera_grp_id(icd),
-							 pad, set_fmt, &pad_cfg,
+							 pad, set_fmt, pad_cfg,
 							 &format);
 			if (ret < 0) {
 				dev_err(icd->parent,
 					"client try_fmt() = %d\n", ret);
+#if defined(CONFIG_MEDIA_CONTROLLER)
+				v4l2_subdev_free_pad_config(pad_cfg);
+#endif
 				return ret;
 			}
 		}
@@ -1781,6 +1804,9 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 			pix->height = height;
 	}
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	v4l2_subdev_free_pad_config(pad_cfg);
+#endif
 	return ret;
 }
 
-- 
1.7.10.4

