Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:32874 "EHLO
	mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237AbcHCN36 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2016 09:29:58 -0400
Received: by mail-lf0-f47.google.com with SMTP id b199so161418038lfe.0
        for <linux-media@vger.kernel.org>; Wed, 03 Aug 2016 06:29:57 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Wed, 3 Aug 2016 15:21:47 +0200
To: Lars-Peter Clausen <lars@metafoo.de>,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, slongerbeam@gmail.com,
	mchehab@kernel.org, hans.verkuil@cisco.com
Subject: Re: [PATCHv2 7/7] [PATCHv5] media: adv7180: fix field type
Message-ID: <20160803132147.GL3672@bigcity.dyn.berto.se>
References: <20160802145107.24829-1-niklas.soderlund+renesas@ragnatech.se>
 <20160802145107.24829-8-niklas.soderlund+renesas@ragnatech.se>
 <3bb2b375-a4a9-00c4-1466-7b1ba8e3bfd8@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3bb2b375-a4a9-00c4-1466-7b1ba8e3bfd8@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-08-02 17:00:07 +0200, Lars-Peter Clausen wrote:
> [...]
> > diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> > index a8b434b..c6fed71 100644
> > --- a/drivers/media/i2c/adv7180.c
> > +++ b/drivers/media/i2c/adv7180.c
> > @@ -680,10 +680,13 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
> >  	switch (format->format.field) {
> >  	case V4L2_FIELD_NONE:
> >  		if (!(state->chip_info->flags & ADV7180_FLAG_I2P))
> > -			format->format.field = V4L2_FIELD_INTERLACED;
> > +			format->format.field = V4L2_FIELD_ALTERNATE;
> >  		break;
> >  	default:
> > -		format->format.field = V4L2_FIELD_INTERLACED;
> > +		if (state->chip_info->flags & ADV7180_FLAG_I2P)
> > +			format->format.field = V4L2_FIELD_INTERLACED;
> 
> I'm not convinced this is correct. As far as I understand it when the I2P
> feature is enabled the core outputs full progressive frames at the full
> framerate. If it is bypassed it outputs half-frames. So we have the option
> of either V4L2_FIELD_NONE or V4L2_FIELD_ALTERNATE, but never interlaced. I
> think this branch should setup the field format to be ALTERNATE regardless
> of whether the I2P feature is available.

I be happy to update the patch in such manner, but I feel this is more 
for Steven to handle. I have no deep understanding of the adv7180 driver 
and the only HW I have is the adv7180 and not adv7280, adv7280_m, 
adv7282 or adv7282_m which is the models which have the ADV7180_FLAG_I2P 
flag. So I can't really test such a change.

Steven do you want to update this patch and resend it? I can drop it 
from this series altogether since the rcar-vin changes do not depend on 
it. I only kept it since I want the rcar-vin changes to be picked up 
before the adv7180 changes, otherwise the rcar-vin driver will stop to 
function on Koelsch. I can also ofc make the change suggested by Lars if 
you prefer, but then I want your blessing to do so. I have already 
changed so much of your original patch :-)

> 
> > +		else
> > +			format->format.field = V4L2_FIELD_ALTERNATE;
> >  		break;
> >  	}
> >  
> 

-- 
Regards,
Niklas Söderlund
