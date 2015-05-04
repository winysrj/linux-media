Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:59881 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049AbbEDH0e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 May 2015 03:26:34 -0400
Message-ID: <55471F20.5090005@xs4all.nl>
Date: Mon, 04 May 2015 09:26:24 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 5/9] ov5642: avoid calling ov5642_find_datafmt() twice
References: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl> <1430646876-19594-6-git-send-email-hverkuil@xs4all.nl> <Pine.LNX.4.64.1505032223340.6055@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1505032223340.6055@axis700.grange>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/03/2015 10:24 PM, Guennadi Liakhovetski wrote:
> Hi Hans,
> 
> On Sun, 3 May 2015, Hans Verkuil wrote:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Simplify ov5642_set_fmt().
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> ---
>>  drivers/media/i2c/soc_camera/ov5642.c | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
>> index bab9ac0..061fca3 100644
>> --- a/drivers/media/i2c/soc_camera/ov5642.c
>> +++ b/drivers/media/i2c/soc_camera/ov5642.c
>> @@ -804,14 +804,15 @@ static int ov5642_set_fmt(struct v4l2_subdev *sd,
>>  	if (!fmt) {
>>  		if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
>>  			return -EINVAL;
>> -		mf->code	= ov5642_colour_fmts[0].code;
>> -		mf->colorspace	= ov5642_colour_fmts[0].colorspace;
>> +		fmt = ov5642_colour_fmts;
>> +		mf->code = fmt->code;
>> +		mf->colorspace = fmt->colorspace;
> 
> Again - I still don't see why this is needed.

Same thing, missed the if statement just before these lines.

Will fix.

	Hans

> 
> Thanks
> Guennadi
> 
>>  	}
>>  
>>  	mf->field	= V4L2_FIELD_NONE;
>>  
>>  	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
>> -		priv->fmt = ov5642_find_datafmt(mf->code);
>> +		priv->fmt = fmt;
>>  	else
>>  		cfg->try_fmt = *mf;
>>  	return 0;
>> -- 
>> 2.1.4
>>

