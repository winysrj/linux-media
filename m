Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:60718 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab0A0T6T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 14:58:19 -0500
Message-ID: <4B609AD4.605@freemail.hu>
Date: Wed, 27 Jan 2010 20:58:12 +0100
From: =?ISO-8859-15?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc_camera: match signedness of soc_camera_limit_side()
References: <4B5AFD11.6000907@freemail.hu> <Pine.LNX.4.64.1001271645440.5073@axis700.grange> <4B6081D4.5070501@freemail.hu> <Pine.LNX.4.64.1001271915400.5073@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1001271915400.5073@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The parameters of soc_camera_limit_side() are either a pointer to
a structure element from v4l2_rect, or constants. The structure elements
of the v4l2_rect are signed (see <linux/videodev2.h>) so do the computations
also with signed values.

The *s_crop() functions may receive negative numbers through the c field of
struct v4l2_crop. These negative values then limited by the start_min and
length_min parameters of soc_camera_limit_side().

This will remove the following sparse warning (see "make C=1"):
 * incorrect type in argument 1 (different signedness)
       expected unsigned int *start
       got signed int *<noident>

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 31eaa9423f98 linux/drivers/media/video/mt9v022.c
--- a/linux/drivers/media/video/mt9v022.c	Mon Jan 25 15:04:15 2010 -0200
+++ b/linux/drivers/media/video/mt9v022.c	Wed Jan 27 20:49:57 2010 +0100
@@ -326,7 +326,7 @@
 	if (ret < 0)
 		return ret;

-	dev_dbg(&client->dev, "Frame %ux%u pixel\n", rect.width, rect.height);
+	dev_dbg(&client->dev, "Frame %dx%d pixel\n", rect.width, rect.height);

 	mt9v022->rect = rect;

diff -r 31eaa9423f98 linux/drivers/media/video/rj54n1cb0c.c
--- a/linux/drivers/media/video/rj54n1cb0c.c	Mon Jan 25 15:04:15 2010 -0200
+++ b/linux/drivers/media/video/rj54n1cb0c.c	Wed Jan 27 20:49:57 2010 +0100
@@ -555,15 +555,15 @@
 	return ret;
 }

-static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
-			       u32 *out_w, u32 *out_h);
+static int rj54n1_sensor_scale(struct v4l2_subdev *sd, s32 *in_w, s32 *in_h,
+			       s32 *out_w, s32 *out_h);

 static int rj54n1_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
 	struct i2c_client *client = sd->priv;
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
 	struct v4l2_rect *rect = &a->c;
-	unsigned int dummy = 0, output_w, output_h,
+	int dummy = 0, output_w, output_h,
 		input_w = rect->width, input_h = rect->height;
 	int ret;

@@ -577,7 +577,7 @@
 	output_w = (input_w * 1024 + rj54n1->resize / 2) / rj54n1->resize;
 	output_h = (input_h * 1024 + rj54n1->resize / 2) / rj54n1->resize;

-	dev_dbg(&client->dev, "Scaling for %ux%u : %u = %ux%u\n",
+	dev_dbg(&client->dev, "Scaling for %dx%d : %d = %dx%d\n",
 		input_w, input_h, rj54n1->resize, output_w, output_h);

 	ret = rj54n1_sensor_scale(sd, &input_w, &input_h, &output_w, &output_h);
@@ -638,12 +638,12 @@
  * the output one, updates the window sizes and returns an error or the resize
  * coefficient on success. Note: we only use the "Fixed Scaling" on this camera.
  */
-static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
-			       u32 *out_w, u32 *out_h)
+static int rj54n1_sensor_scale(struct v4l2_subdev *sd, s32 *in_w, s32 *in_h,
+			       s32 *out_w, s32 *out_h)
 {
 	struct i2c_client *client = sd->priv;
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
-	unsigned int skip, resize, input_w = *in_w, input_h = *in_h,
+	int skip, resize, input_w = *in_w, input_h = *in_h,
 		output_w = *out_w, output_h = *out_h;
 	u16 inc_sel, wb_bit8, wb_left, wb_right, wb_top, wb_bottom;
 	unsigned int peak, peak_50, peak_60;
@@ -655,7 +655,7 @@
 	 * case we have to either reduce the input window to equal or below
 	 * 512x384 or the output window to equal or below 1/2 of the input.
 	 */
-	if (output_w > max(512U, input_w / 2)) {
+	if (output_w > max(512, input_w / 2)) {
 		if (2 * output_w > RJ54N1_MAX_WIDTH) {
 			input_w = RJ54N1_MAX_WIDTH;
 			output_w = RJ54N1_MAX_WIDTH / 2;
@@ -663,11 +663,11 @@
 			input_w = output_w * 2;
 		}

-		dev_dbg(&client->dev, "Adjusted output width: in %u, out %u\n",
+		dev_dbg(&client->dev, "Adjusted output width: in %d, out %d\n",
 			input_w, output_w);
 	}

-	if (output_h > max(384U, input_h / 2)) {
+	if (output_h > max(384, input_h / 2)) {
 		if (2 * output_h > RJ54N1_MAX_HEIGHT) {
 			input_h = RJ54N1_MAX_HEIGHT;
 			output_h = RJ54N1_MAX_HEIGHT / 2;
@@ -675,7 +675,7 @@
 			input_h = output_h * 2;
 		}

-		dev_dbg(&client->dev, "Adjusted output height: in %u, out %u\n",
+		dev_dbg(&client->dev, "Adjusted output height: in %d, out %d\n",
 			input_h, output_h);
 	}

@@ -749,7 +749,7 @@
 	 * improve the image quality or stability for larger frames (see comment
 	 * above), but I didn't check the framerate.
 	 */
-	skip = min(resize / 1024, (unsigned)15);
+	skip = min(resize / 1024, 15);

 	inc_sel = 1 << skip;

@@ -819,7 +819,7 @@
 	*out_w = output_w;
 	*out_h = output_h;

-	dev_dbg(&client->dev, "Scaled for %ux%u : %u = %ux%u, skip %u\n",
+	dev_dbg(&client->dev, "Scaled for %dx%d : %d = %dx%d, skip %d\n",
 		*in_w, *in_h, resize, output_w, output_h, skip);

 	return resize;
@@ -1017,7 +1017,7 @@
 	struct i2c_client *client = sd->priv;
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
 	const struct rj54n1_datafmt *fmt;
-	unsigned int output_w, output_h, max_w, max_h,
+	int output_w, output_h, max_w, max_h,
 		input_w = rj54n1->rect.width, input_h = rj54n1->rect.height;
 	int ret;

diff -r 31eaa9423f98 linux/drivers/media/video/sh_mobile_ceu_camera.c
--- a/linux/drivers/media/video/sh_mobile_ceu_camera.c	Mon Jan 25 15:04:15 2010 -0200
+++ b/linux/drivers/media/video/sh_mobile_ceu_camera.c	Wed Jan 27 20:49:57 2010 +0100
@@ -1041,13 +1041,13 @@
 	 */
 	if (!memcmp(rect, cam_rect, sizeof(*rect))) {
 		/* Even if camera S_CROP failed, but camera rectangle matches */
-		dev_dbg(dev, "Camera S_CROP successful for %ux%u@%u:%u\n",
+		dev_dbg(dev, "Camera S_CROP successful for %dx%d@%d:%d\n",
 			rect->width, rect->height, rect->left, rect->top);
 		return 0;
 	}

 	/* Try to fix cropping, that camera hasn't managed to set */
-	dev_geo(dev, "Fix camera S_CROP for %ux%u@%u:%u to %ux%u@%u:%u\n",
+	dev_geo(dev, "Fix camera S_CROP for %dx%d@%d:%d to %dx%d@%d:%d\n",
 		cam_rect->width, cam_rect->height,
 		cam_rect->left, cam_rect->top,
 		rect->width, rect->height, rect->left, rect->top);
@@ -1103,7 +1103,7 @@

 		v4l2_subdev_call(sd, video, s_crop, cam_crop);
 		ret = client_g_rect(sd, cam_rect);
-		dev_geo(dev, "Camera S_CROP %d for %ux%u@%u:%u\n", ret,
+		dev_geo(dev, "Camera S_CROP %d for %dx%d@%d:%d\n", ret,
 			cam_rect->width, cam_rect->height,
 			cam_rect->left, cam_rect->top);
 	}
@@ -1117,7 +1117,7 @@
 		*cam_rect = cap.bounds;
 		v4l2_subdev_call(sd, video, s_crop, cam_crop);
 		ret = client_g_rect(sd, cam_rect);
-		dev_geo(dev, "Camera S_CROP %d for max %ux%u@%u:%u\n", ret,
+		dev_geo(dev, "Camera S_CROP %d for max %dx%d@%d:%d\n", ret,
 			cam_rect->width, cam_rect->height,
 			cam_rect->left, cam_rect->top);
 	}
diff -r 31eaa9423f98 linux/include/media/soc_camera.h
--- a/linux/include/media/soc_camera.h	Mon Jan 25 15:04:15 2010 -0200
+++ b/linux/include/media/soc_camera.h	Wed Jan 27 20:49:57 2010 +0100
@@ -264,9 +264,8 @@
 		common_flags;
 }

-static inline void soc_camera_limit_side(unsigned int *start,
-		unsigned int *length, unsigned int start_min,
-		unsigned int length_min, unsigned int length_max)
+static inline void soc_camera_limit_side(int *start, int *length,
+		int start_min, int length_min, int length_max)
 {
 	if (*length < length_min)
 		*length = length_min;
