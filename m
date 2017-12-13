Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:43287 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751121AbdLMKTF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 05:19:05 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Petr Cvek <petr.cvek@tul.cz>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] pxa_camera: rename the soc_camera_ prefix to pxa_camera_
Message-ID: <ef7aeca6-b963-f83c-84e6-8f90fb47f0c9@xs4all.nl>
Date: Wed, 13 Dec 2017 11:19:03 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename soc_camera to pxa_camera as this has no longer anything to do with the old
soc_camera driver/framework. It's confusing when grepping on soc_camera.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 295f34ad1080..7c765a00c504 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -647,16 +647,16 @@ static unsigned int pxa_mbus_config_compatible(const struct v4l2_mbus_config *cf
 }

 /**
- * struct soc_camera_format_xlate - match between host and sensor formats
+ * struct pxa_camera_format_xlate - match between host and sensor formats
  * @code: code of a sensor provided format
  * @host_fmt: host format after host translation from code
  *
  * Host and sensor translation structure. Used in table of host and sensor
- * formats matchings in soc_camera_device. A host can override the generic list
+ * formats matchings in pxa_camera_device. A host can override the generic list
  * generation by implementing get_formats(), and use it for format checks and
  * format setup.
  */
-struct soc_camera_format_xlate {
+struct pxa_camera_format_xlate {
 	u32 code;
 	const struct pxa_mbus_pixelfmt *host_fmt;
 };
@@ -693,8 +693,8 @@ struct pxa_camera_dev {
 	struct v4l2_async_notifier notifier;
 	struct vb2_queue	vb2_vq;
 	struct v4l2_subdev	*sensor;
-	struct soc_camera_format_xlate *user_formats;
-	const struct soc_camera_format_xlate *current_fmt;
+	struct pxa_camera_format_xlate *user_formats;
+	const struct pxa_camera_format_xlate *current_fmt;
 	struct v4l2_pix_format	current_pix;

 	struct v4l2_async_subdev asd;
@@ -743,8 +743,8 @@ static const char *pxa_cam_driver_description = "PXA_Camera";
 /*
  * Format translation functions
  */
-static const struct soc_camera_format_xlate
-*pxa_mbus_xlate_by_fourcc(struct soc_camera_format_xlate *user_formats,
+static const struct pxa_camera_format_xlate
+*pxa_mbus_xlate_by_fourcc(struct pxa_camera_format_xlate *user_formats,
 			  unsigned int fourcc)
 {
 	unsigned int i;
@@ -755,17 +755,17 @@ static const struct soc_camera_format_xlate
 	return NULL;
 }

-static struct soc_camera_format_xlate *pxa_mbus_build_fmts_xlate(
+static struct pxa_camera_format_xlate *pxa_mbus_build_fmts_xlate(
 	struct v4l2_device *v4l2_dev, struct v4l2_subdev *subdev,
 	int (*get_formats)(struct v4l2_device *, unsigned int,
-			   struct soc_camera_format_xlate *xlate))
+			   struct pxa_camera_format_xlate *xlate))
 {
 	unsigned int i, fmts = 0, raw_fmts = 0;
 	int ret;
 	struct v4l2_subdev_mbus_code_enum code = {
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
-	struct soc_camera_format_xlate *user_formats;
+	struct pxa_camera_format_xlate *user_formats;

 	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL, &code)) {
 		raw_fmts++;
@@ -1722,7 +1722,7 @@ static bool pxa_camera_packing_supported(const struct pxa_mbus_pixelfmt *fmt)

 static int pxa_camera_get_formats(struct v4l2_device *v4l2_dev,
 				  unsigned int idx,
-				  struct soc_camera_format_xlate *xlate)
+				  struct pxa_camera_format_xlate *xlate)
 {
 	struct pxa_camera_dev *pcdev = v4l2_dev_to_pcdev(v4l2_dev);
 	int formats = 0, ret;
@@ -1794,7 +1794,7 @@ static int pxa_camera_get_formats(struct v4l2_device *v4l2_dev,

 static int pxa_camera_build_formats(struct pxa_camera_dev *pcdev)
 {
-	struct soc_camera_format_xlate *xlate;
+	struct pxa_camera_format_xlate *xlate;

 	xlate = pxa_mbus_build_fmts_xlate(&pcdev->v4l2_dev, pcdev->sensor,
 					  pxa_camera_get_formats);
@@ -1883,7 +1883,7 @@ static int pxac_vidioc_try_fmt_vid_cap(struct file *filp, void *priv,
 				      struct v4l2_format *f)
 {
 	struct pxa_camera_dev *pcdev = video_drvdata(filp);
-	const struct soc_camera_format_xlate *xlate;
+	const struct pxa_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_subdev_pad_config pad_cfg;
 	struct v4l2_subdev_format format = {
@@ -1947,7 +1947,7 @@ static int pxac_vidioc_s_fmt_vid_cap(struct file *filp, void *priv,
 				    struct v4l2_format *f)
 {
 	struct pxa_camera_dev *pcdev = video_drvdata(filp);
-	const struct soc_camera_format_xlate *xlate;
+	const struct pxa_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_subdev_format format = {
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
