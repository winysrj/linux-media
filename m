Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:38334 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753245AbbDQIQH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2015 04:16:07 -0400
Message-ID: <5530C133.3070500@xs4all.nl>
Date: Fri, 17 Apr 2015 10:15:47 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH 1/7] v4l2: replace enum_mbus_fmt by enum_mbus_code
References: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl> <1428574888-46407-2-git-send-email-hverkuil@xs4all.nl> <Pine.LNX.4.64.1504152204330.32631@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1504152204330.32631@axis700.grange>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/15/2015 10:08 PM, Guennadi Liakhovetski wrote:
> On Thu, 9 Apr 2015, Hans Verkuil wrote:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Replace all calls to the enum_mbus_fmt video op by the pad
>> enum_mbus_code op and remove the duplicate video op.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> Cc: Scott Jiang <scott.jiang.linux@gmail.com>
>> Cc: Jonathan Corbet <corbet@lwn.net>
>> Cc: Kamil Debski <k.debski@samsung.com>
>> ---
> 
> [snip]
> 
>> diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
>> index 441e0fd..ef8682c 100644
>> --- a/drivers/media/i2c/soc_camera/mt9m111.c
>> +++ b/drivers/media/i2c/soc_camera/mt9m111.c
>> @@ -839,13 +839,14 @@ static struct v4l2_subdev_core_ops mt9m111_subdev_core_ops = {
>>  #endif
>>  };
>>  
>> -static int mt9m111_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
>> -			    u32 *code)
>> +static int mt9m111_enum_mbus_code(struct v4l2_subdev *sd,
>> +		struct v4l2_subdev_pad_config *cfg,
>> +		struct v4l2_subdev_mbus_code_enum *code)
>>  {
>> -	if (index >= ARRAY_SIZE(mt9m111_colour_fmts))
>> +	if (code->code || code->index >= ARRAY_SIZE(mt9m111_colour_fmts))
> 
> Didn't you mean 
> 
> +	if (code->pad || code->index >= ARRAY_SIZE(mt9m111_colour_fmts))
> 
> ?

Nice catch! Thanks, I've fixed this.

Regards,

	Hans
