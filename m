Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:59881 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752043AbbEDH0C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 May 2015 03:26:02 -0400
Message-ID: <55471EFF.4040004@xs4all.nl>
Date: Mon, 04 May 2015 09:25:51 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 4/9] ov2640: avoid calling ov2640_select_win() twice
References: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl> <1430646876-19594-5-git-send-email-hverkuil@xs4all.nl> <Pine.LNX.4.64.1505032011550.4237@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1505032011550.4237@axis700.grange>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/03/2015 08:19 PM, Guennadi Liakhovetski wrote:
> Hi Hans,
> 
> On Sun, 3 May 2015, Hans Verkuil wrote:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Simplify ov2640_set_params and ov2640_set_fmt.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> ---
>>  drivers/media/i2c/soc_camera/ov2640.c | 21 ++++++++++-----------
>>  1 file changed, 10 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
>> index 9b4f5de..5dcaf24 100644
>> --- a/drivers/media/i2c/soc_camera/ov2640.c
>> +++ b/drivers/media/i2c/soc_camera/ov2640.c
>> @@ -769,15 +769,15 @@ static const struct ov2640_win_size *ov2640_select_win(u32 *width, u32 *height)
>>  	return &ov2640_supported_win_sizes[default_size];
>>  }
>>  
>> -static int ov2640_set_params(struct i2c_client *client, u32 *width, u32 *height,
>> -			     u32 code)
>> +static int ov2640_set_params(struct i2c_client *client,
>> +			     const struct ov2640_win_size *win, u32 code)
>>  {
>>  	struct ov2640_priv       *priv = to_ov2640(client);
>>  	const struct regval_list *selected_cfmt_regs;
>>  	int ret;
>>  
>>  	/* select win */
>> -	priv->win = ov2640_select_win(width, height);
>> +	priv->win = win;
>>  
>>  	/* select format */
>>  	priv->cfmt_code = 0;
>> @@ -798,6 +798,7 @@ static int ov2640_set_params(struct i2c_client *client, u32 *width, u32 *height,
>>  	case MEDIA_BUS_FMT_UYVY8_2X8:
>>  		dev_dbg(&client->dev, "%s: Selected cfmt UYVY", __func__);
>>  		selected_cfmt_regs = ov2640_uyvy_regs;
>> +		break;
> 
> Hm, IIRC, some versions of gcc complain like "break at the end of a switch 
> statement is deprecated." Why did you add this at two locations? Are you 
> seeing a warning? If not, maybe better not do that.

I have never seen such a warning in 20 odd years of using gcc. It is bad practice
not to add a break at the end in case someone adds a new case later or shuffles
cases around and misses that there was no break.

And since 99% of all switch statements in the kernel have a break at the end,
I would say that any gcc issues with that would have been spotted ages ago.

Regards,

	Hans

> 
> Otherwise
> 
> Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> Thanks
> Guennadi
> 
>>  	}
>>  
>>  	/* reset hardware */
>> @@ -832,8 +833,6 @@ static int ov2640_set_params(struct i2c_client *client, u32 *width, u32 *height,
>>  		goto err;
>>  
>>  	priv->cfmt_code = code;
>> -	*width = priv->win->width;
>> -	*height = priv->win->height;
>>  
>>  	return 0;
>>  
>> @@ -887,14 +886,13 @@ static int ov2640_set_fmt(struct v4l2_subdev *sd,
>>  {
>>  	struct v4l2_mbus_framefmt *mf = &format->format;
>>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +	const struct ov2640_win_size *win;
>>  
>>  	if (format->pad)
>>  		return -EINVAL;
>>  
>> -	/*
>> -	 * select suitable win, but don't store it
>> -	 */
>> -	ov2640_select_win(&mf->width, &mf->height);
>> +	/* select suitable win */
>> +	win = ov2640_select_win(&mf->width, &mf->height);
>>  
>>  	mf->field	= V4L2_FIELD_NONE;
>>  
>> @@ -905,14 +903,15 @@ static int ov2640_set_fmt(struct v4l2_subdev *sd,
>>  		break;
>>  	default:
>>  		mf->code = MEDIA_BUS_FMT_UYVY8_2X8;
>> +		/* fall through */
>>  	case MEDIA_BUS_FMT_YUYV8_2X8:
>>  	case MEDIA_BUS_FMT_UYVY8_2X8:
>>  		mf->colorspace = V4L2_COLORSPACE_JPEG;
>> +		break;
>>  	}
>>  
>>  	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
>> -		return ov2640_set_params(client, &mf->width,
>> -					 &mf->height, mf->code);
>> +		return ov2640_set_params(client, win, mf->code);
>>  	cfg->try_fmt = *mf;
>>  	return 0;
>>  }
>> -- 
>> 2.1.4
>>

