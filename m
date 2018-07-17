Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43308 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731573AbeGQOMr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 10:12:47 -0400
Received: by mail-lj1-f195.google.com with SMTP id r13-v6so1024264ljg.10
        for <linux-media@vger.kernel.org>; Tue, 17 Jul 2018 06:40:03 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Tue, 17 Jul 2018 15:40:01 +0200
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 1/2] adv7180: fix field type to V4L2_FIELD_ALTERNATE
Message-ID: <20180717134001.GK10087@bigcity.dyn.berto.se>
References: <20180717123041.2862-1-niklas.soderlund+renesas@ragnatech.se>
 <20180717123041.2862-2-niklas.soderlund+renesas@ragnatech.se>
 <9541cdb4-fb87-e0bb-85cb-667fd16d3804@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9541cdb4-fb87-e0bb-85cb-667fd16d3804@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your feedback.

On 2018-07-17 15:12:41 +0200, Hans Verkuil wrote:
> On 17/07/18 14:30, Niklas Söderlund wrote:
> > The ADV7180 and ADV7182 transmit whole fields, bottom field followed
> > by top (or vice-versa, depending on detected video standard). So
> > for chips that do not have support for explicitly setting the field
> > mode via I2P, set the field mode to V4L2_FIELD_ALTERNATE.
> 
> What does I2P do? I know it was explained before, but that's a long time
> ago :-)

The best explanation I have is that I2P is interlaced to progressive and 
in my research I stopped at commit 851a54effbd808da ("[media] adv7180: 
Add I2P support").

I also vaguely remember reading somewhere that I2P support is planed to 
be removed.

> 
> In any case, it should be explained in the commit log as well.
> 
> I faintly remember that it was just line-doubling of each field, in which
> case this code seems correct.

If you still think I2P needs to be explained in the commit message I 
will do so in the next version.

> 
> Have you checked other drivers that use this subdev? Are they affected by
> this change?

I did a quick check what other users there are and in tree dts indicates 
imx6 and the sun9i-a80-cubieboard4 in addition to the Renesas boards. As 
I can only test on the Renesas hardware I have access to I had to 
trusted the acks from the patch from Steve which I dug out of patchwork 
[1]. His work stopped with a few comments on the code but it was acked 
by Lars-Peter who maintains the driver.

1. https://patchwork.linuxtv.org/patch/36193/

> 
> Regards,
> 
> 	Hans
> 
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/i2c/adv7180.c | 13 ++++++++-----
> >  1 file changed, 8 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> > index 25d24a3f10a7cb4d..c2e24132e8c21d38 100644
> > --- a/drivers/media/i2c/adv7180.c
> > +++ b/drivers/media/i2c/adv7180.c
> > @@ -644,6 +644,9 @@ static int adv7180_mbus_fmt(struct v4l2_subdev *sd,
> >  	fmt->width = 720;
> >  	fmt->height = state->curr_norm & V4L2_STD_525_60 ? 480 : 576;
> >  
> > +	if (state->field == V4L2_FIELD_ALTERNATE)
> > +		fmt->height /= 2;
> > +
> >  	return 0;
> >  }
> >  
> > @@ -711,11 +714,11 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
> >  
> >  	switch (format->format.field) {
> >  	case V4L2_FIELD_NONE:
> > -		if (!(state->chip_info->flags & ADV7180_FLAG_I2P))
> > -			format->format.field = V4L2_FIELD_INTERLACED;
> > -		break;
> > +		if (state->chip_info->flags & ADV7180_FLAG_I2P)
> > +			break;
> > +		/* fall through */
> >  	default:
> > -		format->format.field = V4L2_FIELD_INTERLACED;
> > +		format->format.field = V4L2_FIELD_ALTERNATE;
> >  		break;
> >  	}
> >  
> > @@ -1291,7 +1294,7 @@ static int adv7180_probe(struct i2c_client *client,
> >  		return -ENOMEM;
> >  
> >  	state->client = client;
> > -	state->field = V4L2_FIELD_INTERLACED;
> > +	state->field = V4L2_FIELD_ALTERNATE;
> >  	state->chip_info = (struct adv7180_chip_info *)id->driver_data;
> >  
> >  	state->pwdn_gpio = devm_gpiod_get_optional(&client->dev, "powerdown",
> > 
> 

-- 
Regards,
Niklas Söderlund
