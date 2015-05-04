Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:36888 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbbEDHWN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 May 2015 03:22:13 -0400
Message-ID: <55471E1B.50405@xs4all.nl>
Date: Mon, 04 May 2015 09:22:03 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/9] imx074: don't call imx074_find_datafmt() twice
References: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl> <1430646876-19594-2-git-send-email-hverkuil@xs4all.nl> <Pine.LNX.4.64.1505031948000.4237@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1505031948000.4237@axis700.grange>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/03/2015 07:54 PM, Guennadi Liakhovetski wrote:
> Hi Hans,
> 
> Thanks for fixing the drivers!
> 
> On Sun, 3 May 2015, Hans Verkuil wrote:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Simplify imx074_set_fmt().
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> ---
>>  drivers/media/i2c/soc_camera/imx074.c | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
>> index f68c235..4226f06 100644
>> --- a/drivers/media/i2c/soc_camera/imx074.c
>> +++ b/drivers/media/i2c/soc_camera/imx074.c
>> @@ -171,8 +171,9 @@ static int imx074_set_fmt(struct v4l2_subdev *sd,
>>  		/* MIPI CSI could have changed the format, double-check */
>>  		if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
>>  			return -EINVAL;
>> -		mf->code	= imx074_colour_fmts[0].code;
>> -		mf->colorspace	= imx074_colour_fmts[0].colorspace;
>> +		fmt = imx074_colour_fmts;
>> +		mf->code = fmt->code;
>> +		mf->colorspace = fmt->colorspace;
> 
> Uhm, why this change? I understand, that this is equivalent code, but (1) 
> is it at all related to the change? and (2) imx074_colour_fmts is an 
> array, so, I'd prefer to keep it as is. I do use pointer arithmetics for 
> array, but then I'd do something like

Ah, I missed the FORMAT_ACTIVE check just before these lines. You are right,
this change is not needed.

Regards,

	Hans

> 
> +		fmt = imx074_colour_fmts + 0;
> +		mf->code = fmt->code;
> +		mf->colorspace = fmt->colorspace;
> 
> which looks silly:) And then - even more importantly - you overwrite the 
> fmt variable, which is then used below instead of calling 
> imx074_find_datafmt() again. So, now you assign a (theoretically) 
> different value to priv->fmt. I know that array only has one element and 
> imx074_find_datafmt() will anyway just return it, but, I don't see why 
> this change is needed?
> 
> Thanks
> Guennadi
> 
>>  	}
>>  
>>  	mf->width	= IMX074_WIDTH;
>> @@ -180,7 +181,7 @@ static int imx074_set_fmt(struct v4l2_subdev *sd,
>>  	mf->field	= V4L2_FIELD_NONE;
>>  
>>  	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
>> -		priv->fmt = imx074_find_datafmt(mf->code);
>> +		priv->fmt = fmt;
>>  	else
>>  		cfg->try_fmt = *mf;
>>  
>> -- 
>> 2.1.4
>>

