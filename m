Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44895 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751674Ab0BIJE7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 04:04:59 -0500
Date: Tue, 9 Feb 2010 10:05:32 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?ISO-8859-15?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc_camera: match signedness of soc_camera_limit_side()
In-Reply-To: <4B6201FD.2030708@freemail.hu>
Message-ID: <Pine.LNX.4.64.1002052114490.4506@axis700.grange>
References: <4B5AFD11.6000907@freemail.hu> <Pine.LNX.4.64.1001271645440.5073@axis700.grange>
 <4B6081D4.5070501@freemail.hu> <Pine.LNX.4.64.1001271915400.5073@axis700.grange>
 <4B609AD4.605@freemail.hu> <Pine.LNX.4.64.1001272109470.5073@axis700.grange>
 <4B60B32A.5090806@freemail.hu> <Pine.LNX.4.64.1001282105200.8946@axis700.grange>
 <4B6201FD.2030708@freemail.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 28 Jan 2010, Németh Márton wrote:

> Guennadi Liakhovetski wrote:
> > On Wed, 27 Jan 2010, Németh Márton wrote:
> > 
> >> Guennadi Liakhovetski wrote:
> >>> You didn't reply to my most important objection:
> >>>
> >>> On Wed, 27 Jan 2010, Németh Márton wrote:
> >>>
> >>>> diff -r 31eaa9423f98 linux/include/media/soc_camera.h
> >>>> --- a/linux/include/media/soc_camera.h	Mon Jan 25 15:04:15 2010 -0200
> >>>> +++ b/linux/include/media/soc_camera.h	Wed Jan 27 20:49:57 2010 +0100
> >>>> @@ -264,9 +264,8 @@
> >>>>  		common_flags;
> >>>>  }
> >>>>
> >>>> -static inline void soc_camera_limit_side(unsigned int *start,
> >>>> -		unsigned int *length, unsigned int start_min,
> >>>> -		unsigned int length_min, unsigned int length_max)
> >>>> +static inline void soc_camera_limit_side(int *start, int *length,
> >>>> +		int start_min, int length_min, int length_max)
> >>>>  {
> >>>>  	if (*length < length_min)
> >>>>  		*length = length_min;
> >>> I still do not believe this function will work equally well with signed 
> >>> parameters, as it works with unsigned ones.
> >> I implemented some test cases to find out whether the
> >> soc_camera_limit_side() works correctly or not. My biggest problem is that I'm
> >> not sure what is the expected working of the soc_camera_limit_side() function.
> > 
> > Well, the expected behaviour is simple: the function treats all its 
> > parameters as unsigned, and puts the former two input/output parameters 
> > within the limits, provided by the latter three parameters. Well, taking 
> 
> For the length parameter it is clear to put them between length_min and length_max.
> But for start there is only one limit given: start_min. Does this mean that
> any *start value bigger than start_min is acceptable?

Isn't this not clear enough?

	if (*start < start_min)
		*start = start_min;
	else if (*start > start_min + length_max - *length)
		*start = start_min + length_max - *length;


> (I would like to find out the meaning, not to read back what is written in
> the source code because it is no use to define test cases out of the source
> code.)
> 
> > into account, that when comparing a signed and an unsigned integers, the 
> > comparison is performed unsigned, I think, it should be ok to do what I 
> > suggested in the last email: change prototype to
> > 
> > +static inline void soc_camera_limit_side(int *start, int *length,
> > +		unsigned int start_min, unsigned int length_min, 
> > +		unsigned int length_max)
> > 
> > Maybe also provide a comment above the function explaining, why the first 
> > two parameters are signed. And cast explicitly in sh_mobile_ceu_camera.c:
> > 
> > 	soc_camera_limit_side(&rect->left, &rect->width,
> > 			      (unsigned int)cap.bounds.left, 2,
> > 			      (unsigned int)cap.bounds.width);
> > 	soc_camera_limit_side(&rect->top, &rect->height,
> > 			      (unsigned int)cap.bounds.top, 4,
> > 			      (unsigned int)cap.bounds.height);
> 
> I'm afraid that casting __s32 to unsigned int just cannot work. Let's take an
> example on a 32bit machine:
> 
>                -1 = 0xFFFFFFFF
>  (unsigned int)-1 = 0xFFFFFFFF = 4294967295
> 
> and
> 
>                -2147483648 = 0x80000000
>  (unsigned int)-2147483648 = 0x80000000 = 2147483648
> 
> This means that any negative number will be mapped to a large positive number
> when casting to (unsigned int) and I think this is not the wanted behaviour.

That's exactly the expected behaviour.

> > Could you check if this would make both sparse and the compiler happy?
> 
> There is no compiler warning nor sparse warning when applying the following
> version of the patch. I'm not sure, however, that the simple cast will do
> the right thing here.

Ok, I modified your patch a bit, how about the below version? If you 
agree, I'll commit it in that form (after converting to utf-8):

From: Márton Németh <nm127@freemail.hu>

The first two parameters of soc_camera_limit_side() are usually pointers 
to struct v4l2_rect elements. They are signed, so adjust the prototype 
accordingly.

This will remove the following sparse warning (see "make C=1"):

 * incorrect type in argument 1 (different signedness)
       expected unsigned int *start
       got signed int *<noident>

as well as a couple more signedness mismatches.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 1a34d29..e5bae4c 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -325,7 +325,7 @@ static int mt9v022_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	if (ret < 0)
 		return ret;
 
-	dev_dbg(&client->dev, "Frame %ux%u pixel\n", rect.width, rect.height);
+	dev_dbg(&client->dev, "Frame %dx%d pixel\n", rect.width, rect.height);
 
 	mt9v022->rect = rect;
 
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index bd297f5..d477e30 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -796,7 +796,7 @@ static int acquire_dma_channel(struct mx3_camera_dev *mx3_cam)
  * FIXME: learn to use stride != width, then we can keep stride properly aligned
  * and support arbitrary (even) widths.
  */
-static inline void stride_align(__s32 *width)
+static inline void stride_align(__u32 *width)
 {
 	if (((*width + 7) &  ~7) < 4096)
 		*width = (*width + 7) &  ~7;
@@ -844,7 +844,7 @@ static int mx3_camera_set_crop(struct soc_camera_device *icd,
 		 * So far only direct camera-to-memory is supported
 		 */
 		if (channel_change_requested(icd, rect)) {
-			int ret = acquire_dma_channel(mx3_cam);
+			ret = acquire_dma_channel(mx3_cam);
 			if (ret < 0)
 				return ret;
 		}
diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/video/rj54n1cb0c.c
index 9277194..bbd9c11 100644
--- a/drivers/media/video/rj54n1cb0c.c
+++ b/drivers/media/video/rj54n1cb0c.c
@@ -555,15 +555,15 @@ static int rj54n1_commit(struct i2c_client *client)
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
 
@@ -577,7 +577,7 @@ static int rj54n1_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	output_w = (input_w * 1024 + rj54n1->resize / 2) / rj54n1->resize;
 	output_h = (input_h * 1024 + rj54n1->resize / 2) / rj54n1->resize;
 
-	dev_dbg(&client->dev, "Scaling for %ux%u : %u = %ux%u\n",
+	dev_dbg(&client->dev, "Scaling for %dx%d : %u = %dx%d\n",
 		input_w, input_h, rj54n1->resize, output_w, output_h);
 
 	ret = rj54n1_sensor_scale(sd, &input_w, &input_h, &output_w, &output_h);
@@ -638,8 +638,8 @@ static int rj54n1_g_fmt(struct v4l2_subdev *sd,
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
@@ -749,7 +749,7 @@ static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
 	 * improve the image quality or stability for larger frames (see comment
 	 * above), but I didn't check the framerate.
 	 */
-	skip = min(resize / 1024, (unsigned)15);
+	skip = min(resize / 1024, 15U);
 
 	inc_sel = 1 << skip;
 
@@ -819,7 +819,7 @@ static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
 	*out_w = output_w;
 	*out_h = output_h;
 
-	dev_dbg(&client->dev, "Scaled for %ux%u : %u = %ux%u, skip %u\n",
+	dev_dbg(&client->dev, "Scaled for %dx%d : %u = %ux%u, skip %u\n",
 		*in_w, *in_h, resize, output_w, output_h, skip);
 
 	return resize;
@@ -1017,7 +1017,7 @@ static int rj54n1_s_fmt(struct v4l2_subdev *sd,
 	struct i2c_client *client = sd->priv;
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
 	const struct rj54n1_datafmt *fmt;
-	unsigned int output_w, output_h, max_w, max_h,
+	int output_w, output_h, max_w, max_h,
 		input_w = rj54n1->rect.width, input_h = rj54n1->rect.height;
 	int ret;
 
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index f09c714..af506bc 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -1040,13 +1040,13 @@ static int client_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *crop,
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
@@ -1102,7 +1102,7 @@ static int client_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *crop,
 
 		v4l2_subdev_call(sd, video, s_crop, cam_crop);
 		ret = client_g_rect(sd, cam_rect);
-		dev_geo(dev, "Camera S_CROP %d for %ux%u@%u:%u\n", ret,
+		dev_geo(dev, "Camera S_CROP %d for %dx%d@%d:%d\n", ret,
 			cam_rect->width, cam_rect->height,
 			cam_rect->left, cam_rect->top);
 	}
@@ -1116,7 +1116,7 @@ static int client_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *crop,
 		*cam_rect = cap.bounds;
 		v4l2_subdev_call(sd, video, s_crop, cam_crop);
 		ret = client_g_rect(sd, cam_rect);
-		dev_geo(dev, "Camera S_CROP %d for max %ux%u@%u:%u\n", ret,
+		dev_geo(dev, "Camera S_CROP %d for max %dx%d@%d:%d\n", ret,
 			cam_rect->width, cam_rect->height,
 			cam_rect->left, cam_rect->top);
 	}
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index dcc5b86..5a17365 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -264,8 +266,8 @@ static inline unsigned long soc_camera_bus_param_compatible(
 		common_flags;
 }
 
-static inline void soc_camera_limit_side(unsigned int *start,
-		unsigned int *length, unsigned int start_min,
+static inline void soc_camera_limit_side(int *start, int *length,
+		unsigned int start_min,
 		unsigned int length_min, unsigned int length_max)
 {
 	if (*length < length_min)
