Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:55516 "EHLO
	xk120" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753065AbbA2QTw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 11:19:52 -0500
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 7/8] WmT: rcar_vin new ADV7612 support
Date: Thu, 29 Jan 2015 16:19:47 +0000
Message-Id: <1422548388-28861-8-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk>
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add 'struct media_pad pad' member and suitable glue code, so that
soc_camera/rcar_vin can become agnostic to whether an old or new-
style driver (wrt pad API use) can sit underneath

This version has been reworked to include appropriate constant and
datatype names for kernel v3.18

---

** this version for kernel 3.18.x+ (v4l2 constant names) **
** now including: **
| WmT: assume max resolution at init
|
| Make rcar_vin agnostic to the driver beneath having a smaller
| resolution as its default size. Previously, the logic for calculating
| cropping region size -which depends on going from larger to smaller
| values- would have been confused by this.
---
 drivers/media/platform/soc_camera/rcar_vin.c |  112 +++++++++++++++++++++++---
 1 file changed, 101 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index e4f60d3..046fcc1 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -932,9 +932,27 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 	u32 code;
 	const struct soc_mbus_pixelfmt *fmt;
 
-	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
-	if (ret < 0)
-		return 0;
+	// subdev_has_op -> enum_mbus_code vs enum_mbus_fmt
+	if (v4l2_subdev_has_op(sd, pad, enum_mbus_code)) {
+		struct v4l2_subdev_mbus_code_enum c;
+
+		c.index = idx;
+
+		ret = v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &c);
+		if (ret < 0)
+			return 0;
+
+#if 1	/*  ideal  */
+		code = c.code;
+#else	/*  Ian HACK - required with full(er) formats table  */
+		code = MEDIA_BUS_FMT_RGB888_1X24; //HACK
+#endif
+	}
+	else {
+		ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
+		if (ret < 0)
+			return 0;
+	}
 
 	fmt = soc_mbus_get_fmtdesc(code);
 	if (!fmt) {
@@ -948,11 +966,28 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 
 	if (!icd->host_priv) {
 		struct v4l2_mbus_framefmt mf;
+		struct v4l2_subdev_format sd_format;
 		struct v4l2_rect rect;
 		struct device *dev = icd->parent;
 		int shift;
 
-		ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
+		// subdev_has_op -> get_fmt vs g_mbus_fmt
+		if (v4l2_subdev_has_op(sd, pad, get_fmt)) {
+			struct media_pad *remote_pad;
+
+			remote_pad= media_entity_remote_pad(&icd->vdev->entity.pads[0]);
+			sd_format.pad= remote_pad->index;
+			sd_format.which=V4L2_SUBDEV_FORMAT_ACTIVE;
+
+			ret = v4l2_subdev_call(sd, pad, get_fmt, NULL,
+						&sd_format);
+			mf= sd_format.format;
+			mf.width= VIN_MAX_WIDTH;
+			mf.height= VIN_MAX_HEIGHT;
+		}
+		else {
+			ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
+		}
 		if (ret < 0)
 			return ret;
 
@@ -979,10 +1014,18 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 
 			mf.width = 1280 >> shift;
 			mf.height = 960 >> shift;
-			ret = v4l2_device_call_until_err(sd->v4l2_dev,
-							 soc_camera_grp_id(icd),
-							 video, s_mbus_fmt,
-							 &mf);
+			// subdev_has_op -> set_fmt vs s_mbus_fmt
+			if (v4l2_subdev_has_op(sd, pad, set_fmt)) {
+				ret = v4l2_device_call_until_err(sd->v4l2_dev,
+						 soc_camera_grp_id(icd),
+						 pad, set_fmt, NULL,
+						 &sd_format);
+			} else {
+				ret = v4l2_device_call_until_err(sd->v4l2_dev,
+						 soc_camera_grp_id(icd),
+						 video, s_mbus_fmt,
+						 &mf);
+			}
 			if (ret < 0)
 				return ret;
 		}
@@ -1099,7 +1142,22 @@ static int rcar_vin_set_crop(struct soc_camera_device *icd,
 	/* On success cam_crop contains current camera crop */
 
 	/* Retrieve camera output window */
-	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
+	// subdev_has_op -> get_fmt vs g_mbus_fmt
+	if (v4l2_subdev_has_op(sd, pad, get_fmt))
+	{
+		struct v4l2_subdev_format sd_format;
+		struct media_pad *remote_pad;
+
+		remote_pad= media_entity_remote_pad(&icd->vdev->entity.pads[0]);
+		sd_format.pad= remote_pad->index;
+		sd_format.which= V4L2_SUBDEV_FORMAT_ACTIVE;
+		ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &sd_format);
+
+		mf.width= sd_format.format.width;
+		mf.height= sd_format.format.height;
+	} else {
+		ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
+	}
 	if (ret < 0)
 		return ret;
 
@@ -1314,8 +1372,22 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 	mf.code = xlate->code;
 	mf.colorspace = pix->colorspace;
 
-	ret = v4l2_device_call_until_err(sd->v4l2_dev, soc_camera_grp_id(icd),
+	// subdev_has_op -> get_fmt vs try_mbus_fmt
+	if (v4l2_subdev_has_op(sd, pad, get_fmt)) {
+		struct v4l2_subdev_format sd_format;
+		struct media_pad *remote_pad;
+
+		remote_pad= media_entity_remote_pad(
+					&icd->vdev->entity.pads[0]);
+		sd_format.pad= remote_pad->index;
+		sd_format.format= mf;
+		ret= v4l2_device_call_until_err(sd->v4l2_dev, soc_camera_grp_id(icd),
+                                        pad, get_fmt, NULL, &sd_format);
+		mf= sd_format.format;
+	} else {
+		ret = v4l2_device_call_until_err(sd->v4l2_dev, soc_camera_grp_id(icd),
 					 video, try_mbus_fmt, &mf);
+	}
 	if (ret < 0)
 		return ret;
 
@@ -1335,10 +1407,28 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 			 */
 			mf.width = VIN_MAX_WIDTH;
 			mf.height = VIN_MAX_HEIGHT;
-			ret = v4l2_device_call_until_err(sd->v4l2_dev,
+			// subdev_has_op -> get_fmt vs try_mbus_fmt
+			if (v4l2_subdev_has_op(sd, pad, get_fmt)) {
+				struct v4l2_subdev_format sd_format;
+				struct media_pad *remote_pad;
+
+				remote_pad= media_entity_remote_pad(
+					&icd->vdev->entity.pads[0]);
+				sd_format.pad = remote_pad->index;
+				sd_format.which= V4L2_SUBDEV_FORMAT_TRY;
+				sd_format.format= mf;
+				ret = v4l2_device_call_until_err(sd->v4l2_dev,
+							 soc_camera_grp_id(icd),
+							 pad, get_fmt,
+							 NULL, &sd_format);
+				mf= sd_format.format;
+			} else {
+				ret = v4l2_device_call_until_err(sd->v4l2_dev,
 							 soc_camera_grp_id(icd),
 							 video, try_mbus_fmt,
 							 &mf);
+			}
+
 			if (ret < 0) {
 				dev_err(icd->parent,
 					"client try_fmt() = %d\n", ret);
-- 
1.7.10.4

