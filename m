Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:41059 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966Ab3DVIkG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 04:40:06 -0400
Received: by mail-lb0-f177.google.com with SMTP id x10so676579lbi.8
        for <linux-media@vger.kernel.org>; Mon, 22 Apr 2013 01:40:05 -0700 (PDT)
Message-ID: <5174F74E.9030707@cogentembedded.com>
Date: Mon, 22 Apr 2013 12:39:42 +0400
From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	mchehab@redhat.com, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org, matsu@igel.co.jp
Subject: Re: [PATCH v2 1/5] V4L2: I2C: ML86V7667 video decoder driver
References: <201304212240.30949.sergei.shtylyov@cogentembedded.com> <201304220848.04870.hverkuil@xs4all.nl>
In-Reply-To: <201304220848.04870.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the review.

Hans Verkuil wrote:
>> +#include <media/v4l2-chip-ident.h>
>>     
>
> This include should be removed as well.
>   
ok
>   
>> +
>> +static int ml86v7667_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
>> +{
>> +	struct ml86v7667_priv *priv = to_ml86v7667(sd);
>> +
>> +	*std = priv->std;
>>     
>
> That's not right. querystd should attempt to detect the standard, that's
> what it is for. It should just return the detected standard, not actually
> change it.
>   
Ok.
I've mixed the things up with your review on removing the autoselection 
feature and detection.
Thx for pointing on this.
>   
>> +	 */
>> +	val = i2c_smbus_read_byte_data(client, STATUS_REG);
>> +	if (val < 0)
>> +		return val;
>> +
>> +	priv->std = val & STATUS_NTSCPAL ? V4L2_STD_PAL : V4L2_STD_NTSC;
>>     
>
> Shouldn't this be 50 Hz vs 60 Hz formats? There are 60 Hz PAL standards
> and usually these devices detect 50 Hz vs 60 Hz, not NTSC vs PAL.
>   
In the reference manual it is not mentioned about 50/60Hz input format 
selection/detection but it mentioned just PAL/NTSC.
The 50hz formats can be ether PAL and NTSC formats variants. The same is 
applied to 60Hz.

In the ML86V7667 datasheet the description for STATUS register detection 
bit is just PAL/NTSC:
" $2C/STATUS [2] NTSC/PAL identification 0: NTSC /1: PAL "

If you assure me that I must judge their description as 50 vs 60Hz 
formats and not PAL/NTSC then I will make the change.

Regards,
Vladimir
