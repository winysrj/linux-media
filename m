Return-path: <mchehab@pedra>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:50693 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab1FZTyU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jun 2011 15:54:20 -0400
Received: by fxd18 with SMTP id 18so1187597fxd.11
        for <linux-media@vger.kernel.org>; Sun, 26 Jun 2011 12:54:19 -0700 (PDT)
Message-ID: <4E078E67.8080600@gmail.com>
Date: Sun, 26 Jun 2011 21:54:15 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Subject: Re: [PATCH 2/3] noon010pc30: Convert to the pad level ops
References: <1308757470-24421-1-git-send-email-s.nawrocki@samsung.com> <1308757470-24421-3-git-send-email-s.nawrocki@samsung.com> <201106250208.52602.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201106250208.52602.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

thanks for your review.

On 06/25/2011 02:08 AM, Laurent Pinchart wrote:
> Hi Sylwester,
> 
> Thanks for the patch. It's nice to see sensor drivers picking up the pad-level
> API :-)

This is somehow a consequence of converting our camera host driver
to the pad-level API. Nevertheless for some of our devices the pad-level API
just scales better than regular V4L2 interface. So my goal is to gradually
introduce it in our BSP where relevant.

> 
> On Wednesday 22 June 2011 17:44:29 Sylwester Nawrocki wrote:
>> Replace g/s_mbus_fmt ops with the pad level get/set_fmt operations.
>> Add media entity initialization and set subdev flags so the host driver
>> creates a v4l-subdev device node for the driver. A mutex is added for
>> serializing operations on subdevice node. When setting format
>> is attempted during streaming EBUSY error code will be returned.
> 
> [snip]
> 
>> @@ -130,14 +130,19 @@ static const char * const noon010_supply_name[] = {
>>   #define NOON010_NUM_SUPPLIES ARRAY_SIZE(noon010_supply_name)
>>
>>   struct noon010_info {
>> +	/* Mutex protecting this data structure and subdev operations */
>> +	struct mutex lock;
> 
> Locks protect data, not operations. You should describe which data members are
> protected by the lock.

OK, thanks for pointing this out. I'll try to be more precise in the next
patch version.:)

> 
>>   	struct v4l2_subdev sd;
>> +	struct media_pad pad;
>>   	struct v4l2_ctrl_handler hdl;
>>   	const struct noon010pc30_platform_data *pdata;
>>   	const struct noon010_format *curr_fmt;
>>   	const struct noon010_frmsize *curr_win;
>> +	struct v4l2_mbus_framefmt format;
>>   	unsigned int hflip:1;
>>   	unsigned int vflip:1;
>>   	unsigned int power:1;
>> +	unsigned int streaming:1;
>>   	u8 i2c_reg_page;
>>   	struct regulator_bulk_data supply[NOON010_NUM_SUPPLIES];
>>   	u32 gpio_nreset;
> 
> [snip]
> 
>> @@ -374,6 +380,8 @@ static int noon010_try_frame_size(struct
>> v4l2_mbus_framefmt *mf) if (match) {
>>   		mf->width  = match->width;
>>   		mf->height = match->height;
>> +		if (size)
>> +			*size = match;
>>   		return 0;
>>   	}
>>   	return -EINVAL;
>> @@ -464,36 +472,45 @@ static int noon010_s_ctrl(struct v4l2_ctrl *ctrl)
> 
> [snip]
> 
>> -static int noon010_g_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt
>> *mf)
>> +static int noon010_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh
>> *fh,
>> +			   struct v4l2_subdev_format *fmt)
>>   {
>>   	struct noon010_info *info = to_noon010(sd);
>> -	int ret;
>> +	struct v4l2_mbus_framefmt *mf;
>>
>> -	if (!mf)
>> +	if (fmt->pad != 0)
>>   		return -EINVAL;
> 
> subdev_do_ioctl() already validates fmt->pad.

OK, I'll get rid of the check.

> 
>> -	if (!info->curr_win || !info->curr_fmt) {
>> -		ret = noon010_set_params(sd);
>> -		if (ret)
>> -			return ret;
>> +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
>> +		if (fh) {
>> +			mf = v4l2_subdev_get_try_format(fh, 0);
>> +			fmt->format = *mf;
>> +		}
>> +		return 0;
>>   	}
>> +	/* Active format */
>> +	mf =&fmt->format;
>>
>> +	mutex_lock(&info->lock);
>>   	mf->width	= info->curr_win->width;
>>   	mf->height	= info->curr_win->height;
>>   	mf->code	= info->curr_fmt->code;
>>   	mf->colorspace	= info->curr_fmt->colorspace;
>> -	mf->field	= V4L2_FIELD_NONE;
>> +	mutex_unlock(&info->lock);
>>
>> +	mf->field	= V4L2_FIELD_NONE;
>> +	mf->colorspace	= V4L2_COLORSPACE_JPEG;
>>   	return 0;
>>   }
>>
> 
> [snip]
> 
>> @@ -583,6 +609,17 @@ static int noon010_s_power(struct v4l2_subdev *sd, int
>> on) return ret;
>>   }
>>
>> +static int noon010_s_stream(struct v4l2_subdev *sd, int on)
>> +{
>> +	struct noon010_info *info = to_noon010(sd);
>> +
>> +	mutex_lock(&info->lock);
>> +	info->streaming = on;
>> +	mutex_unlock(&info->lock);
> 
> Does the sensor produce data continuously, without any way to stop it ?

Hmm, looks like not enough attention to that from my side. The sensor has
a software "power sleep" mode in which it is supposed to not generate 
an output signal and it tri-states its output pins. 
All registers' state is retained and the normal I2C register access should
be possible. I'll look into details in the datasheet. I think the driver
could be leaving the sensor chip in such 'suspended' state after s_power(1)
and be switching it into normal operation within s_stream(1).

> 
>> +
>> +	return 0;
>> +}
>> +
>>   static int noon010_g_chip_ident(struct v4l2_subdev *sd,
>>   				struct v4l2_dbg_chip_ident *chip)
> 
> You can get rid of g_chip_ident as well.

All right, when I was originally writing this driver I thought
it was mandatory to implement g_chip_indent. In fact it was never
really used so far, so I'm going to do away with it in next iteration.

> 
>>   {
> 
> [snip]
> 
>> @@ -666,9 +707,11 @@ static int noon010_probe(struct i2c_client *client,
>>   	if (!info)
>>   		return -ENOMEM;
>>
>> +	mutex_init(&info->lock);
>>   	sd =&info->sd;
>>   	strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
>>   	v4l2_i2c_subdev_init(sd, client,&noon010_ops);
>> +	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
> 
> You should |= V4L2_SUBDEV_FL_HAS_DEVNODE flag. v4l2_i2c_subdev_init() sets
> V4L2_SUBDEV_FL_IS_I2C.

Oops, my bad. Thanks, I'll fix this.

> 
>>   	v4l2_ctrl_handler_init(&info->hdl, 3);
> 

--
Regards,
Sylwester
