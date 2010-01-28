Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:60330 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab0A1Van (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2010 16:30:43 -0500
Message-ID: <4B6201FD.2030708@freemail.hu>
Date: Thu, 28 Jan 2010 22:30:37 +0100
From: =?ISO-8859-15?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc_camera: match signedness of soc_camera_limit_side()
References: <4B5AFD11.6000907@freemail.hu> <Pine.LNX.4.64.1001271645440.5073@axis700.grange> <4B6081D4.5070501@freemail.hu> <Pine.LNX.4.64.1001271915400.5073@axis700.grange> <4B609AD4.605@freemail.hu> <Pine.LNX.4.64.1001272109470.5073@axis700.grange> <4B60B32A.5090806@freemail.hu> <Pine.LNX.4.64.1001282105200.8946@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1001282105200.8946@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> On Wed, 27 Jan 2010, Németh Márton wrote:
> 
>> Guennadi Liakhovetski wrote:
>>> You didn't reply to my most important objection:
>>>
>>> On Wed, 27 Jan 2010, Németh Márton wrote:
>>>
>>>> diff -r 31eaa9423f98 linux/include/media/soc_camera.h
>>>> --- a/linux/include/media/soc_camera.h	Mon Jan 25 15:04:15 2010 -0200
>>>> +++ b/linux/include/media/soc_camera.h	Wed Jan 27 20:49:57 2010 +0100
>>>> @@ -264,9 +264,8 @@
>>>>  		common_flags;
>>>>  }
>>>>
>>>> -static inline void soc_camera_limit_side(unsigned int *start,
>>>> -		unsigned int *length, unsigned int start_min,
>>>> -		unsigned int length_min, unsigned int length_max)
>>>> +static inline void soc_camera_limit_side(int *start, int *length,
>>>> +		int start_min, int length_min, int length_max)
>>>>  {
>>>>  	if (*length < length_min)
>>>>  		*length = length_min;
>>> I still do not believe this function will work equally well with signed 
>>> parameters, as it works with unsigned ones.
>> I implemented some test cases to find out whether the
>> soc_camera_limit_side() works correctly or not. My biggest problem is that I'm
>> not sure what is the expected working of the soc_camera_limit_side() function.
> 
> Well, the expected behaviour is simple: the function treats all its 
> parameters as unsigned, and puts the former two input/output parameters 
> within the limits, provided by the latter three parameters. Well, taking 

For the length parameter it is clear to put them between length_min and length_max.
But for start there is only one limit given: start_min. Does this mean that
any *start value bigger than start_min is acceptable?

(I would like to find out the meaning, not to read back what is written in
the source code because it is no use to define test cases out of the source
code.)

> into account, that when comparing a signed and an unsigned integers, the 
> comparison is performed unsigned, I think, it should be ok to do what I 
> suggested in the last email: change prototype to
> 
> +static inline void soc_camera_limit_side(int *start, int *length,
> +		unsigned int start_min, unsigned int length_min, 
> +		unsigned int length_max)
> 
> Maybe also provide a comment above the function explaining, why the first 
> two parameters are signed. And cast explicitly in sh_mobile_ceu_camera.c:
> 
> 	soc_camera_limit_side(&rect->left, &rect->width,
> 			      (unsigned int)cap.bounds.left, 2,
> 			      (unsigned int)cap.bounds.width);
> 	soc_camera_limit_side(&rect->top, &rect->height,
> 			      (unsigned int)cap.bounds.top, 4,
> 			      (unsigned int)cap.bounds.height);

I'm afraid that casting __s32 to unsigned int just cannot work. Let's take an
example on a 32bit machine:

               -1 = 0xFFFFFFFF
 (unsigned int)-1 = 0xFFFFFFFF = 4294967295

and

               -2147483648 = 0x80000000
 (unsigned int)-2147483648 = 0x80000000 = 2147483648

This means that any negative number will be mapped to a large positive number
when casting to (unsigned int) and I think this is not the wanted behaviour.

> Could you check if this would make both sparse and the compiler happy?

There is no compiler warning nor sparse warning when applying the following
version of the patch. I'm not sure, however, that the simple cast will do
the right thing here.

Regards,

	Márton Németh

---
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
+++ b/linux/drivers/media/video/mt9v022.c	Thu Jan 28 22:24:35 2010 +0100
@@ -326,7 +326,7 @@
 	if (ret < 0)
 		return ret;

-	dev_dbg(&client->dev, "Frame %ux%u pixel\n", rect.width, rect.height);
+	dev_dbg(&client->dev, "Frame %dx%d pixel\n", rect.width, rect.height);

 	mt9v022->rect = rect;

diff -r 31eaa9423f98 linux/drivers/media/video/rj54n1cb0c.c
--- a/linux/drivers/media/video/rj54n1cb0c.c	Mon Jan 25 15:04:15 2010 -0200
+++ b/linux/drivers/media/video/rj54n1cb0c.c	Thu Jan 28 22:24:35 2010 +0100
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
+++ b/linux/drivers/media/video/sh_mobile_ceu_camera.c	Thu Jan 28 22:24:35 2010 +0100
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
@@ -1057,10 +1057,12 @@
 	if (ret < 0)
 		return ret;

-	soc_camera_limit_side(&rect->left, &rect->width, cap.bounds.left, 2,
-			      cap.bounds.width);
-	soc_camera_limit_side(&rect->top, &rect->height, cap.bounds.top, 4,
-			      cap.bounds.height);
+	soc_camera_limit_side(&rect->left, &rect->width,
+			      (unsigned int)cap.bounds.left, 2,
+			      (unsigned int)cap.bounds.width);
+	soc_camera_limit_side(&rect->top, &rect->height,
+			      (unsigned int)cap.bounds.top, 4,
+			      (unsigned int)cap.bounds.height);

 	/*
 	 * Popular special case - some cameras can only handle fixed sizes like
@@ -1103,7 +1105,7 @@

 		v4l2_subdev_call(sd, video, s_crop, cam_crop);
 		ret = client_g_rect(sd, cam_rect);
-		dev_geo(dev, "Camera S_CROP %d for %ux%u@%u:%u\n", ret,
+		dev_geo(dev, "Camera S_CROP %d for %dx%d@%d:%d\n", ret,
 			cam_rect->width, cam_rect->height,
 			cam_rect->left, cam_rect->top);
 	}
@@ -1117,7 +1119,7 @@
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
+++ b/linux/include/media/soc_camera.h	Thu Jan 28 22:24:35 2010 +0100
@@ -264,8 +264,8 @@
 		common_flags;
 }

-static inline void soc_camera_limit_side(unsigned int *start,
-		unsigned int *length, unsigned int start_min,
+static inline void soc_camera_limit_side(int *start, int *length,
+		unsigned int start_min,
 		unsigned int length_min, unsigned int length_max)
 {
 	if (*length < length_min)

