Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:35789 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbcHOTCS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 15:02:18 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v4 06/13] media: platform: pxa_camera: introduce sensor_call
Date: Mon, 15 Aug 2016 21:01:56 +0200
Message-Id: <1471287723-25451-7-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1471287723-25451-1-git-send-email-robert.jarzmik@free.fr>
References: <1471287723-25451-1-git-send-email-robert.jarzmik@free.fr>
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
index 0a9e4bdccece..171e3c57615c 100644
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
@@ -1074,7 +1077,7 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd)
 	if (ret < 0)
 		return ret;
 
-	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
+	ret = sensor_call(pcdev, video, g_mbus_config, &cfg);
 	if (!ret) {
 		common_flags = soc_mbus_config_compatible(&cfg,
 							  bus_flags);
@@ -1118,7 +1121,7 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd)
 	}
 
 	cfg.flags = common_flags;
-	ret = v4l2_subdev_call(sd, video, s_mbus_config, &cfg);
+	ret = sensor_call(pcdev, video, s_mbus_config, &cfg);
 	if (ret < 0 && ret != -ENOIOCTLCMD) {
 		dev_dbg(icd->parent, "camera s_mbus_config(0x%lx) returned %d\n",
 			common_flags, ret);
@@ -1145,7 +1148,7 @@ static int pxa_camera_try_bus_param(struct soc_camera_device *icd,
 	if (ret < 0)
 		return ret;
 
-	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
+	ret = sensor_call(pcdev, video, g_mbus_config, &cfg);
 	if (!ret) {
 		common_flags = soc_mbus_config_compatible(&cfg,
 							  bus_flags);
@@ -1196,7 +1199,7 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 	};
 	const struct soc_mbus_pixelfmt *fmt;
 
-	ret = v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code);
+	ret = sensor_call(pcdev, pad, enum_mbus_code, NULL, &code);
 	if (ret < 0)
 		/* No more formats */
 		return 0;
@@ -1298,7 +1301,7 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
 		icd->sense = &sense;
 
-	ret = v4l2_subdev_call(sd, video, s_crop, a);
+	ret = sensor_call(pcdev, video, s_crop, a);
 
 	icd->sense = NULL;
 
@@ -1308,7 +1311,7 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 		return ret;
 	}
 
-	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
+	ret = sensor_call(pcdev, pad, get_fmt, NULL, &fmt);
 	if (ret < 0)
 		return ret;
 
@@ -1320,7 +1323,7 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 		v4l_bound_align_image(&mf->width, 48, 2048, 1,
 			&mf->height, 32, 2048, 0,
 			fourcc == V4L2_PIX_FMT_YUV422P ? 4 : 0);
-		ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, &fmt);
+		ret = sensor_call(pcdev, pad, set_fmt, NULL, &fmt);
 		if (ret < 0)
 			return ret;
 
@@ -1385,7 +1388,7 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 	mf->colorspace	= pix->colorspace;
 	mf->code	= xlate->code;
 
-	ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, &format);
+	ret = sensor_call(pcdev, pad, set_fmt, NULL, &format);
 
 	if (mf->code != xlate->code)
 		return -EINVAL;
@@ -1460,7 +1463,7 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 	mf->colorspace	= pix->colorspace;
 	mf->code	= xlate->code;
 
-	ret = v4l2_subdev_call(sd, pad, set_fmt, &pad_cfg, &format);
+	ret = sensor_call(pcdev, pad, set_fmt, &pad_cfg, &format);
 	if (ret < 0)
 		return ret;
 
@@ -1518,7 +1521,7 @@ static int pxa_camera_suspend(struct device *dev)
 
 	if (pcdev->soc_host.icd) {
 		struct v4l2_subdev *sd = soc_camera_to_subdev(pcdev->soc_host.icd);
-		ret = v4l2_subdev_call(sd, core, s_power, 0);
+		ret = sensor_call(pcdev, core, s_power, 0);
 		if (ret == -ENOIOCTLCMD)
 			ret = 0;
 	}
@@ -1540,7 +1543,7 @@ static int pxa_camera_resume(struct device *dev)
 
 	if (pcdev->soc_host.icd) {
 		struct v4l2_subdev *sd = soc_camera_to_subdev(pcdev->soc_host.icd);
-		ret = v4l2_subdev_call(sd, core, s_power, 1);
+		ret = sensor_call(pcdev, core, s_power, 1);
 		if (ret == -ENOIOCTLCMD)
 			ret = 0;
 	}
-- 
2.1.4

