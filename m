Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:37952 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751649AbbEDKUL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 May 2015 06:20:11 -0400
Message-ID: <554747D0.50008@xs4all.nl>
Date: Mon, 04 May 2015 12:20:00 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 8/9] ov9740: avoid calling ov9740_res_roundup() twice
References: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl> <1430646876-19594-9-git-send-email-hverkuil@xs4all.nl> <Pine.LNX.4.64.1505032244370.6055@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1505032244370.6055@axis700.grange>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/03/2015 10:47 PM, Guennadi Liakhovetski wrote:
> Hi Hans,
> 
> On Sun, 3 May 2015, Hans Verkuil wrote:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Simplify ov9740_s_fmt.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> ---
>>  drivers/media/i2c/soc_camera/ov9740.c | 18 +-----------------
>>  1 file changed, 1 insertion(+), 17 deletions(-)
>>
>> diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
>> index 03a7fc7..61a8e18 100644
>> --- a/drivers/media/i2c/soc_camera/ov9740.c
>> +++ b/drivers/media/i2c/soc_camera/ov9740.c
>> @@ -673,20 +673,8 @@ static int ov9740_s_fmt(struct v4l2_subdev *sd,
>>  {
>>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>>  	struct ov9740_priv *priv = to_ov9740(sd);
>> -	enum v4l2_colorspace cspace;
>> -	u32 code = mf->code;
>>  	int ret;
>>  
>> -	ov9740_res_roundup(&mf->width, &mf->height);
>> -
>> -	switch (code) {
>> -	case MEDIA_BUS_FMT_YUYV8_2X8:
>> -		cspace = V4L2_COLORSPACE_SRGB;
>> -		break;
>> -	default:
>> -		return -EINVAL;
>> -	}
>> -
> 
> ov9740_s_fmt() is also called from ov9740_s_power(), so, don't we have to 
> do this simplification the other way round - remove redundant code from 
> ov9740_set_fmt() instead?

Yes, but s_power is also calling ov9740_res_roundup() and it sets mf->code and
mf->colorspace to the correct values. So this code in s_fmt is a duplicate
for both s_power and for set_fmt. It can't be removed from set_fmt either
since it is needed for the TRY_FORMAT case anyway.

So IMHO it makes sense to remove it from s_fmt.

Regards,

	Hans

> 
> Thanks
> Guennadi
> 
>>  	ret = ov9740_reg_write_array(client, ov9740_defaults,
>>  				     ARRAY_SIZE(ov9740_defaults));
>>  	if (ret < 0)
>> @@ -696,11 +684,7 @@ static int ov9740_s_fmt(struct v4l2_subdev *sd,
>>  	if (ret < 0)
>>  		return ret;
>>  
>> -	mf->code	= code;
>> -	mf->colorspace	= cspace;
>> -
>> -	memcpy(&priv->current_mf, mf, sizeof(struct v4l2_mbus_framefmt));
>> -
>> +	priv->current_mf = *mf;
>>  	return ret;
>>  }
>>  
>> -- 
>> 2.1.4
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

