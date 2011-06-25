Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42899 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab1FYAIt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2011 20:08:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 2/3] noon010pc30: Convert to the pad level ops
Date: Sat, 25 Jun 2011 02:08:52 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
References: <1308757470-24421-1-git-send-email-s.nawrocki@samsung.com> <1308757470-24421-3-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1308757470-24421-3-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106250208.52602.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sylwester,

Thanks for the patch. It's nice to see sensor drivers picking up the pad-level 
API :-)

On Wednesday 22 June 2011 17:44:29 Sylwester Nawrocki wrote:
> Replace g/s_mbus_fmt ops with the pad level get/set_fmt operations.
> Add media entity initalization and set subdev flags so the host driver
> creates a v4l-subdev device node for the driver. A mutex is added for
> serializing operations on subdevice node. When setting format
> is attempted during streaming EBUSY error code will be returned.

[snip]

> @@ -130,14 +130,19 @@ static const char * const noon010_supply_name[] = {
>  #define NOON010_NUM_SUPPLIES ARRAY_SIZE(noon010_supply_name)
> 
>  struct noon010_info {
> +	/* Mutex protecting this data structure and subdev operations */
> +	struct mutex lock;

Locks protect data, not operations. You should describe which data members are 
protected by the lock.

>  	struct v4l2_subdev sd;
> +	struct media_pad pad;
>  	struct v4l2_ctrl_handler hdl;
>  	const struct noon010pc30_platform_data *pdata;
>  	const struct noon010_format *curr_fmt;
>  	const struct noon010_frmsize *curr_win;
> +	struct v4l2_mbus_framefmt format;
>  	unsigned int hflip:1;
>  	unsigned int vflip:1;
>  	unsigned int power:1;
> +	unsigned int streaming:1;
>  	u8 i2c_reg_page;
>  	struct regulator_bulk_data supply[NOON010_NUM_SUPPLIES];
>  	u32 gpio_nreset;

[snip]

> @@ -374,6 +380,8 @@ static int noon010_try_frame_size(struct
> v4l2_mbus_framefmt *mf) if (match) {
>  		mf->width  = match->width;
>  		mf->height = match->height;
> +		if (size)
> +			*size = match;
>  		return 0;
>  	}
>  	return -EINVAL;
> @@ -464,36 +472,45 @@ static int noon010_s_ctrl(struct v4l2_ctrl *ctrl)

[snip]

> -static int noon010_g_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt
> *mf)
> +static int noon010_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh
> *fh,
> +			   struct v4l2_subdev_format *fmt)
>  {
>  	struct noon010_info *info = to_noon010(sd);
> -	int ret;
> +	struct v4l2_mbus_framefmt *mf;
> 
> -	if (!mf)
> +	if (fmt->pad != 0)
>  		return -EINVAL;

subdev_do_ioctl() already validates fmt->pad.

> -	if (!info->curr_win || !info->curr_fmt) {
> -		ret = noon010_set_params(sd);
> -		if (ret)
> -			return ret;
> +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		if (fh) {
> +			mf = v4l2_subdev_get_try_format(fh, 0);
> +			fmt->format = *mf;
> +		}
> +		return 0;
>  	}
> +	/* Active format */
> +	mf = &fmt->format;
> 
> +	mutex_lock(&info->lock);
>  	mf->width	= info->curr_win->width;
>  	mf->height	= info->curr_win->height;
>  	mf->code	= info->curr_fmt->code;
>  	mf->colorspace	= info->curr_fmt->colorspace;
> -	mf->field	= V4L2_FIELD_NONE;
> +	mutex_unlock(&info->lock);
> 
> +	mf->field	= V4L2_FIELD_NONE;
> +	mf->colorspace	= V4L2_COLORSPACE_JPEG;
>  	return 0;
>  }
> 

[snip]

> @@ -583,6 +609,17 @@ static int noon010_s_power(struct v4l2_subdev *sd, int
> on) return ret;
>  }
> 
> +static int noon010_s_stream(struct v4l2_subdev *sd, int on)
> +{
> +	struct noon010_info *info = to_noon010(sd);
> +
> +	mutex_lock(&info->lock);
> +	info->streaming = on;
> +	mutex_unlock(&info->lock);

Does the sensor produce data continuously, without any way to stop it ?

> +
> +	return 0;
> +}
> +
>  static int noon010_g_chip_ident(struct v4l2_subdev *sd,
>  				struct v4l2_dbg_chip_ident *chip)

You can get rid of g_chip_ident as well.

>  {

[snip]

> @@ -666,9 +707,11 @@ static int noon010_probe(struct i2c_client *client,
>  	if (!info)
>  		return -ENOMEM;
> 
> +	mutex_init(&info->lock);
>  	sd = &info->sd;
>  	strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
>  	v4l2_i2c_subdev_init(sd, client, &noon010_ops);
> +	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;

You should |= V4L2_SUBDEV_FL_HAS_DEVNODE flag. v4l2_i2c_subdev_init() sets 
V4L2_SUBDEV_FL_IS_I2C.

>  	v4l2_ctrl_handler_init(&info->hdl, 3);

-- 
Regards,

Laurent Pinchart
