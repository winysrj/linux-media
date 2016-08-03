Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:33320 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbcHCRsP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2016 13:48:15 -0400
Received: by mail-lf0-f52.google.com with SMTP id b199so166755066lfe.0
        for <linux-media@vger.kernel.org>; Wed, 03 Aug 2016 10:48:14 -0700 (PDT)
Date: Wed, 3 Aug 2016 19:19:48 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
	<niklas.soderlund@ragnatech.se>
To: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-media@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, slongerbeam@gmail.com,
	mchehab@kernel.org, hans.verkuil@cisco.com
Subject: Re: [PATCHv2 7/7] [PATCHv5] media: adv7180: fix field type
Message-ID: <20160803171947.GN3672@bigcity.dyn.berto.se>
References: <20160802145107.24829-1-niklas.soderlund+renesas@ragnatech.se>
 <20160802145107.24829-8-niklas.soderlund+renesas@ragnatech.se>
 <3bb2b375-a4a9-00c4-1466-7b1ba8e3bfd8@metafoo.de>
 <20160803132147.GL3672@bigcity.dyn.berto.se>
 <2a8ec840-301b-06c8-31ec-42d25b282437@mentor.com>
 <4301a49c-39e3-2b35-74a4-e079b528db9e@metafoo.de>
 <53ce2f9b-6f06-dad5-a55d-cb4abbe6db24@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53ce2f9b-6f06-dad5-a55d-cb4abbe6db24@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-08-03 10:14:45 -0700, Steve Longerbeam wrote:
> On 08/03/2016 09:58 AM, Lars-Peter Clausen wrote:
> > On 08/03/2016 06:55 PM, Steve Longerbeam wrote:
> >> On 08/03/2016 06:21 AM, Niklas Söderlund wrote:
> >>> On 2016-08-02 17:00:07 +0200, Lars-Peter Clausen wrote:
> >>>> [...]
> >>>>> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> >>>>> index a8b434b..c6fed71 100644
> >>>>> --- a/drivers/media/i2c/adv7180.c
> >>>>> +++ b/drivers/media/i2c/adv7180.c
> >>>>> @@ -680,10 +680,13 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
> >>>>>  	switch (format->format.field) {
> >>>>>  	case V4L2_FIELD_NONE:
> >>>>>  		if (!(state->chip_info->flags & ADV7180_FLAG_I2P))
> >>>>> -			format->format.field = V4L2_FIELD_INTERLACED;
> >>>>> +			format->format.field = V4L2_FIELD_ALTERNATE;
> >>>>>  		break;
> >>>>>  	default:
> >>>>> -		format->format.field = V4L2_FIELD_INTERLACED;
> >>>>> +		if (state->chip_info->flags & ADV7180_FLAG_I2P)
> >>>>> +			format->format.field = V4L2_FIELD_INTERLACED;
> >>>> I'm not convinced this is correct. As far as I understand it when the I2P
> >>>> feature is enabled the core outputs full progressive frames at the full
> >>>> framerate. If it is bypassed it outputs half-frames. So we have the option
> >>>> of either V4L2_FIELD_NONE or V4L2_FIELD_ALTERNATE, but never interlaced. I
> >>>> think this branch should setup the field format to be ALTERNATE regardless
> >>>> of whether the I2P feature is available.
> >>> I be happy to update the patch in such manner, but I feel this is more 
> >>> for Steven to handle. I have no deep understanding of the adv7180 driver 
> >>> and the only HW I have is the adv7180 and not adv7280, adv7280_m, 
> >>> adv7282 or adv7282_m which is the models which have the ADV7180_FLAG_I2P 
> >>> flag. So I can't really test such a change.
> >>>
> >>> Steven do you want to update this patch and resend it? 
> >> Hi Niklas, I can update this patch, but it sounds like the whole thing
> >> is "up in the air" at this point, and we may want to yank out the I2P
> >> support altogether. I'll leave it up to Lars and others to work that out
> >> first.
> > Yeah, we should remove the whole I2P stuff, I was misinformed about how it
> > works. But either way I think this patch should simply not touch the current
> > behavior, so don't add new if (FLAG_I2P) checks.
> 
> Hi Lars, Ok I can do that. I'll resubmit in next version of my patchset.

Thanks Steven, then I will drop this patch in my v3. Can you pleas CC me 
when you send out your patch?

-- 
Regards,
Niklas Söderlund
