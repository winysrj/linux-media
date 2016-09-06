Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:28263 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755384AbcIFJMD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 05:12:03 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jiri Kosina <trivial@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v6 06/14] media: platform: pxa_camera: introduce sensor_call
Date: Tue,  6 Sep 2016 11:04:16 +0200
Message-Id: <1473152664-5077-6-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1473152664-5077-1-git-send-email-robert.jarzmik@free.fr>
References: <1473152664-5077-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Introduce sensor_call(), which will be used for all sensor invocations.
This is a preparation move to v4l2 device conversion, ie. soc_camera
adherence removal.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/platform/soc_camera/pxa_camera.c | 27 ++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 62e3f69a17ec..3091ec708a46 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -168,6 +168,9 @@
 			CICR0_PERRM | CICR0_QDM | CICR0_CDM | CICR0_SOFM | \
 			CICR0_EOFM | CICR0_FOM)
 
+#define sensor_call(cam, o, f, args...) \
+	v4l2_subdev_call(sd, o, f, ##args)
+
 /*
  * Structures
  */
@@ -731,7 +734,7 @@ static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	unsigned long dw, bpp;
 	u32 cicr0, cicr1, cicr2, cicr3, cicr4 = 0, y_skip_top;
-	int ret = v4l2_subdev_call(sd, sensor, g_skip_top_lines, &y_skip_top);
+	int ret = sensor_call(pcdev, sensor, g_skip_top_lines, &y_skip_top);
 
 	if (ret < 0)
 		y_skip_top = 0;
@@ -1073,7 +1076,7 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd)
 	if (ret < 0)
 		return ret;
 
-	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
+	ret = sensor_call(pcdev, video, g_mbus_config, &cfg);
 	if (!ret) {
 		common_flags = soc_mbus_config_compatible(&cfg,
 							  bus_flags);
@@ -1117,7 +1120,7 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd)
 	}
 
 	cfg.flags = common_flags;
-	ret = v4l2_subdev_call(sd, video, s_mbus_config, &cfg);
+	ret = sensor_call(pcdev, video, s_mbus_config, &cfg);
 	if (ret < 0 && ret != -ENOIOCTLCMD) {
 		dev_dbg(icd->parent, "camera s_mbus_config(0x%lx) returned %d\n",
 			common_flags, ret);
@@ -1144,7 +1147,7 @@ static int pxa_camera_try_bus_param(struct soc_camera_device *icd,
 	if (ret < 0)
 		return ret;
 
-	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
+	ret = sensor_call(pcdev, video, g_mbus_config, &cfg);
 	if (!ret) {
 		common_flags = soc_mbus_config_compatible(&cfg,
 							  bus_flags);
@@ -1195,7 +1198,7 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 	};
 	const struct soc_mbus_pixelfmt *fmt;
 
-	ret = v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code);
+	ret = sensor_call(pcdev, pad, enum_mbus_code, NULL, &code);
 	if (ret < 0)
 		/* No more formats */
 		return 0;
@@ -1303,7 +1306,7 @@ static int pxa_camera_set_selection(struct soc_camera_device *icd,
 	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
 		icd->sense = &sense;
 
-	ret = v4l2_subdev_call(sd, pad, set_selection, NULL, &sdsel);
+	ret = sensor_call(pcdev, pad, set_selection, NULL, &sdsel);
 
 	icd->sense = NULL;
 
@@ -1314,7 +1317,7 @@ static int pxa_camera_set_selection(struct soc_camera_device *icd,
 	}
 	sel->r = sdsel.r;
 
-	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
+	ret = sensor_call(pcdev, pad, get_fmt, NULL, &fmt);
 	if (ret < 0)
 		return ret;
 
@@ -1326,7 +1329,7 @@ static int pxa_camera_set_selection(struct soc_camera_device *icd,
 		v4l_bound_align_image(&mf->width, 48, 2048, 1,
 			&mf->height, 32, 2048, 0,
 			fourcc == V4L2_PIX_FMT_YUV422P ? 4 : 0);
-		ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, &fmt);
+		ret = sensor_call(pcdev, pad, set_fmt, NULL, &fmt);
 		if (ret < 0)
 			return ret;
 
@@ -1391,7 +1394,7 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 	mf->colorspace	= pix->colorspace;
 	mf->code	= xlate->code;
 
-	ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, &format);
+	ret = sensor_call(pcdev, pad, set_fmt, NULL, &format);
 
 	if (mf->code != xlate->code)
 		return -EINVAL;
@@ -1466,7 +1469,7 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 	mf->colorspace	= pix->colorspace;
 	mf->code	= xlate->code;
 
-	ret = v4l2_subdev_call(sd, pad, set_fmt, &pad_cfg, &format);
+	ret = sensor_call(pcdev, pad, set_fmt, &pad_cfg, &format);
 	if (ret < 0)
 		return ret;
 
@@ -1524,7 +1527,7 @@ static int pxa_camera_suspend(struct device *dev)
 
 	if (pcdev->soc_host.icd) {
 		struct v4l2_subdev *sd = soc_camera_to_subdev(pcdev->soc_host.icd);
-		ret = v4l2_subdev_call(sd, core, s_power, 0);
+		ret = sensor_call(pcdev, core, s_power, 0);
 		if (ret == -ENOIOCTLCMD)
 			ret = 0;
 	}
@@ -1546,7 +1549,7 @@ static int pxa_camera_resume(struct device *dev)
 
 	if (pcdev->soc_host.icd) {
 		struct v4l2_subdev *sd = soc_camera_to_subdev(pcdev->soc_host.icd);
-		ret = v4l2_subdev_call(sd, core, s_power, 1);
+		ret = sensor_call(pcdev, core, s_power, 1);
 		if (ret == -ENOIOCTLCMD)
 			ret = 0;
 	}
-- 
2.1.4

