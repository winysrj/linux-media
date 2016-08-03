Return-path: <linux-media-owner@vger.kernel.org>
Received: from www381.your-server.de ([78.46.137.84]:40085 "EHLO
	www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213AbcHCOYR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2016 10:24:17 -0400
Subject: Re: [PATCHv2 7/7] [PATCHv5] media: adv7180: fix field type
To: Hans Verkuil <hverkuil@xs4all.nl>,
	=?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
	Steve Longerbeam <steve_longerbeam@mentor.com>
References: <20160802145107.24829-1-niklas.soderlund+renesas@ragnatech.se>
 <20160802145107.24829-8-niklas.soderlund+renesas@ragnatech.se>
 <3bb2b375-a4a9-00c4-1466-7b1ba8e3bfd8@metafoo.de>
 <20160803132147.GL3672@bigcity.dyn.berto.se>
 <927464df-14cb-aadb-c1d9-5a5f0d065828@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, slongerbeam@gmail.com,
	mchehab@kernel.org, hans.verkuil@cisco.com
From: Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <d7f16469-a4a4-b2cc-2af1-2c3efcd8aac6@metafoo.de>
Date: Wed, 3 Aug 2016 16:23:36 +0200
MIME-Version: 1.0
In-Reply-To: <927464df-14cb-aadb-c1d9-5a5f0d065828@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/03/2016 04:11 PM, Hans Verkuil wrote:
> 
> 
> On 08/03/2016 03:21 PM, Niklas Söderlund wrote:
>> On 2016-08-02 17:00:07 +0200, Lars-Peter Clausen wrote:
>>> [...]
>>>> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
>>>> index a8b434b..c6fed71 100644
>>>> --- a/drivers/media/i2c/adv7180.c
>>>> +++ b/drivers/media/i2c/adv7180.c
>>>> @@ -680,10 +680,13 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
>>>>  	switch (format->format.field) {
>>>>  	case V4L2_FIELD_NONE:
>>>>  		if (!(state->chip_info->flags & ADV7180_FLAG_I2P))
>>>> -			format->format.field = V4L2_FIELD_INTERLACED;
>>>> +			format->format.field = V4L2_FIELD_ALTERNATE;
>>>>  		break;
>>>>  	default:
>>>> -		format->format.field = V4L2_FIELD_INTERLACED;
>>>> +		if (state->chip_info->flags & ADV7180_FLAG_I2P)
>>>> +			format->format.field = V4L2_FIELD_INTERLACED;
>>>
>>> I'm not convinced this is correct. As far as I understand it when the I2P
>>> feature is enabled the core outputs full progressive frames at the full
>>> framerate. If it is bypassed it outputs half-frames. So we have the option
>>> of either V4L2_FIELD_NONE or V4L2_FIELD_ALTERNATE, but never interlaced. I
>>> think this branch should setup the field format to be ALTERNATE regardless
>>> of whether the I2P feature is available.
> 
> Actually, that's not true. If the progressive frame is obtained by combining
> two fields, then it should return FIELD_INTERLACED. This is how most SDTV
> receivers operate.

This is definitely not covered by the current definition of INTERLACED. It
says that the temporal order of the odd and even lines is the same for each
frame. Whereas for a deinterlaced frame the temporal order changes from
frame to frame.

E.g. lets say you have half frames A, B, C, D, E, F ...

The output of the I2P core are frames like (A,B) (C,B) (C,D) (E,D) (E, F) ...

The first frame is INTERLACED_TB, the second INTERLACED_BT, the third
INTERLACED_TB again and so on. Also you get the same amount of pixels as for
a progressive setup so the data-output-rate is higher. Maybe we need a
FIELD_DEINTERLACED to denote such a setup?

