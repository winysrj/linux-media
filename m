Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:61852 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab0AWNnu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jan 2010 08:43:50 -0500
Message-ID: <4B5AFD11.6000907@freemail.hu>
Date: Sat, 23 Jan 2010 14:43:45 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] soc_camera: match signedness of soc_camera_limit_side()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The parameters of soc_camera_limit_side() are either a pointer to
a structure element from v4l2_rect, or constants. The structure elements
of the v4l2_rect are signed (see <linux/videodev2.h>) so do the computations
also with signed values.

This will remove the following sparse warning (see "make C=1"):
 * incorrect type in argument 1 (different signedness)
       expected unsigned int *start
       got signed int *<noident>

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 2a50a0a1c951 linux/include/media/soc_camera.h
--- a/linux/include/media/soc_camera.h	Sat Jan 23 00:14:32 2010 -0200
+++ b/linux/include/media/soc_camera.h	Sat Jan 23 10:09:41 2010 +0100
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
diff -r 2a50a0a1c951 linux/drivers/media/video/rj54n1cb0c.c
--- a/linux/drivers/media/video/rj54n1cb0c.c	Sat Jan 23 00:14:32 2010 -0200
+++ b/linux/drivers/media/video/rj54n1cb0c.c	Sat Jan 23 10:09:41 2010 +0100
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

@@ -638,8 +638,8 @@
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
@@ -1017,7 +1017,7 @@
 	struct i2c_client *client = sd->priv;
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
 	const struct rj54n1_datafmt *fmt;
-	unsigned int output_w, output_h, max_w, max_h,
+	int output_w, output_h, max_w, max_h,
 		input_w = rj54n1->rect.width, input_h = rj54n1->rect.height;
 	int ret;


