Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:51098 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475AbcHCROs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2016 13:14:48 -0400
Subject: Re: [PATCHv2 7/7] [PATCHv5] media: adv7180: fix field type
To: Lars-Peter Clausen <lars@metafoo.de>,
	=?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
References: <20160802145107.24829-1-niklas.soderlund+renesas@ragnatech.se>
 <20160802145107.24829-8-niklas.soderlund+renesas@ragnatech.se>
 <3bb2b375-a4a9-00c4-1466-7b1ba8e3bfd8@metafoo.de>
 <20160803132147.GL3672@bigcity.dyn.berto.se>
 <2a8ec840-301b-06c8-31ec-42d25b282437@mentor.com>
 <4301a49c-39e3-2b35-74a4-e079b528db9e@metafoo.de>
CC: <linux-media@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
	<sergei.shtylyov@cogentembedded.com>, <slongerbeam@gmail.com>,
	<mchehab@kernel.org>, <hans.verkuil@cisco.com>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <53ce2f9b-6f06-dad5-a55d-cb4abbe6db24@mentor.com>
Date: Wed, 3 Aug 2016 10:14:45 -0700
MIME-Version: 1.0
In-Reply-To: <4301a49c-39e3-2b35-74a4-e079b528db9e@metafoo.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/03/2016 09:58 AM, Lars-Peter Clausen wrote:
> On 08/03/2016 06:55 PM, Steve Longerbeam wrote:
>> On 08/03/2016 06:21 AM, Niklas Söderlund wrote:
>>> On 2016-08-02 17:00:07 +0200, Lars-Peter Clausen wrote:
>>>> [...]
>>>>> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
>>>>> index a8b434b..c6fed71 100644
>>>>> --- a/drivers/media/i2c/adv7180.c
>>>>> +++ b/drivers/media/i2c/adv7180.c
>>>>> @@ -680,10 +680,13 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
>>>>>  	switch (format->format.field) {
>>>>>  	case V4L2_FIELD_NONE:
>>>>>  		if (!(state->chip_info->flags & ADV7180_FLAG_I2P))
>>>>> -			format->format.field = V4L2_FIELD_INTERLACED;
>>>>> +			format->format.field = V4L2_FIELD_ALTERNATE;
>>>>>  		break;
>>>>>  	default:
>>>>> -		format->format.field = V4L2_FIELD_INTERLACED;
>>>>> +		if (state->chip_info->flags & ADV7180_FLAG_I2P)
>>>>> +			format->format.field = V4L2_FIELD_INTERLACED;
>>>> I'm not convinced this is correct. As far as I understand it when the I2P
>>>> feature is enabled the core outputs full progressive frames at the full
>>>> framerate. If it is bypassed it outputs half-frames. So we have the option
>>>> of either V4L2_FIELD_NONE or V4L2_FIELD_ALTERNATE, but never interlaced. I
>>>> think this branch should setup the field format to be ALTERNATE regardless
>>>> of whether the I2P feature is available.
>>> I be happy to update the patch in such manner, but I feel this is more 
>>> for Steven to handle. I have no deep understanding of the adv7180 driver 
>>> and the only HW I have is the adv7180 and not adv7280, adv7280_m, 
>>> adv7282 or adv7282_m which is the models which have the ADV7180_FLAG_I2P 
>>> flag. So I can't really test such a change.
>>>
>>> Steven do you want to update this patch and resend it? 
>> Hi Niklas, I can update this patch, but it sounds like the whole thing
>> is "up in the air" at this point, and we may want to yank out the I2P
>> support altogether. I'll leave it up to Lars and others to work that out
>> first.
> Yeah, we should remove the whole I2P stuff, I was misinformed about how it
> works. But either way I think this patch should simply not touch the current
> behavior, so don't add new if (FLAG_I2P) checks.

Hi Lars, Ok I can do that. I'll resubmit in next version of my patchset.

Steve

