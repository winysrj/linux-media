Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43008 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753020Ab0A0QFK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 11:05:10 -0500
Date: Wed, 27 Jan 2010 17:05:18 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc_camera: match signedness of soc_camera_limit_side()
In-Reply-To: <4B5AFD11.6000907@freemail.hu>
Message-ID: <Pine.LNX.4.64.1001271645440.5073@axis700.grange>
References: <4B5AFD11.6000907@freemail.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 23 Jan 2010, Németh Márton wrote:

> From: Márton Németh <nm127@freemail.hu>
> 
> The parameters of soc_camera_limit_side() are either a pointer to
> a structure element from v4l2_rect, or constants. The structure elements
> of the v4l2_rect are signed (see <linux/videodev2.h>) so do the computations
> also with signed values.
> 
> This will remove the following sparse warning (see "make C=1"):
>  * incorrect type in argument 1 (different signedness)
>        expected unsigned int *start
>        got signed int *<noident>

Well, it is interesting, but insufficient. And, unfortunately, I don't 
have a good (and easy) recipe for how to fix this properly.

The problem is, that in soc_camera_limit_side all tests and arithmetics 
are performed with unsigned in mind, now, if you change them to signed, 
think what happens, if some of them are negative. No, I don't know when 
negative members of struct v4l2_rect make sense, having them signed 
doesn't seem a very good idea to me. But they cannot be changed - that's a 
part of the user-space API...

Casting all parameters inside that inline to unsigned would be way too 
ugly. Maybe we could at least keep start_min, length_min, and length_max 
unsigned, and only change start and length to signed, and only cast those 
two inside the function. Then, if you grep through all the drivers, 
there's only one location, where soc_camera_limit_side() is called with 
the latter 3 parameters not constant - two calls in 
sh_mobile_ceu_camera.c. So, to keep sparse happy, you'd have to cast 
there. Ideally, you would also add checks there for negative values...

> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> diff -r 2a50a0a1c951 linux/include/media/soc_camera.h
> --- a/linux/include/media/soc_camera.h	Sat Jan 23 00:14:32 2010 -0200
> +++ b/linux/include/media/soc_camera.h	Sat Jan 23 10:09:41 2010 +0100
> @@ -264,9 +264,8 @@
>  		common_flags;
>  }
> 
> -static inline void soc_camera_limit_side(unsigned int *start,
> -		unsigned int *length, unsigned int start_min,
> -		unsigned int length_min, unsigned int length_max)
> +static inline void soc_camera_limit_side(int *start, int *length,
> +		int start_min, int length_min, int length_max)
>  {
>  	if (*length < length_min)
>  		*length = length_min;
> diff -r 2a50a0a1c951 linux/drivers/media/video/rj54n1cb0c.c
> --- a/linux/drivers/media/video/rj54n1cb0c.c	Sat Jan 23 00:14:32 2010 -0200
> +++ b/linux/drivers/media/video/rj54n1cb0c.c	Sat Jan 23 10:09:41 2010 +0100
> @@ -555,15 +555,15 @@
>  	return ret;
>  }
> 
> -static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
> -			       u32 *out_w, u32 *out_h);
> +static int rj54n1_sensor_scale(struct v4l2_subdev *sd, s32 *in_w, s32 *in_h,
> +			       s32 *out_w, s32 *out_h);
> 
>  static int rj54n1_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  {
>  	struct i2c_client *client = sd->priv;
>  	struct rj54n1 *rj54n1 = to_rj54n1(client);
>  	struct v4l2_rect *rect = &a->c;
> -	unsigned int dummy = 0, output_w, output_h,
> +	int dummy = 0, output_w, output_h,
>  		input_w = rect->width, input_h = rect->height;
>  	int ret;

And these:

	if (output_w > max(512U, input_w / 2)) {
	if (output_h > max(384U, input_h / 2)) {

would now produce compiler warnings... Have you actually tried to compile 
your patch? You'll also have to change formats in dev_dbg() calls here...

> 
> @@ -638,8 +638,8 @@
>   * the output one, updates the window sizes and returns an error or the resize
>   * coefficient on success. Note: we only use the "Fixed Scaling" on this camera.
>   */
> -static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
> -			       u32 *out_w, u32 *out_h)
> +static int rj54n1_sensor_scale(struct v4l2_subdev *sd, s32 *in_w, s32 *in_h,
> +			       s32 *out_w, s32 *out_h)
>  {
>  	struct i2c_client *client = sd->priv;
>  	struct rj54n1 *rj54n1 = to_rj54n1(client);
> @@ -1017,7 +1017,7 @@
>  	struct i2c_client *client = sd->priv;
>  	struct rj54n1 *rj54n1 = to_rj54n1(client);
>  	const struct rj54n1_datafmt *fmt;
> -	unsigned int output_w, output_h, max_w, max_h,
> +	int output_w, output_h, max_w, max_h,
>  		input_w = rj54n1->rect.width, input_h = rj54n1->rect.height;
>  	int ret;

and here.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
