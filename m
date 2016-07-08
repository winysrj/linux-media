Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:34998 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbcGHKw4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 06:52:56 -0400
Received: by mail-lf0-f42.google.com with SMTP id l188so26997194lfe.2
        for <linux-media@vger.kernel.org>; Fri, 08 Jul 2016 03:52:55 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Fri, 8 Jul 2016 12:52:53 +0200
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH 07/11] media: adv7180: change mbus format to UYVY
Message-ID: <20160708105252.GA8687@bigcity.dyn.berto.se>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846004-12731-8-git-send-email-steve_longerbeam@mentor.com>
 <577E72C1.3000902@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <577E72C1.3000902@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-07-07 17:18:25 +0200, Lars-Peter Clausen wrote:
> On 07/07/2016 01:00 AM, Steve Longerbeam wrote:
> > Change the media bus format from YUYV8_2X8 to UYVY8_2X8. Colors
> > now look correct when capturing with the i.mx6 backend. The other
> > option is to set the SWPC bit in register 0x27 to swap the Cr and Cb
> > output samples.
> > 
> > Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> 
> The patch is certainly correct from the technical point of view. But we need
> to be careful not to break any existing platforms which rely on this
> setting. So the alternative solution of changing the default output order is
> not an option.
> 
> Looking at things it seems like the Renesas vin driver, which is used in
> combination with the adv7180 on some boards, uses the return value from
> enum_mbus_code to setup the video pipeline. Adding Niklas to Cc, maybe he
> can help to test this.

Yes this change will make the rcar-vin driver fail to probe since it do 
not recognise the MEDIA_BUS_FMT_UYVY8_2X8 format.

There is a error in the Renesas VIN driver where it looks for the wrong 
media format YUVU but expects UYVY data. This error have masked the bug 
in adv7180 fixed in this commit.

I have have sent a patch '[media] rcar-vin: add legacy mode for wrong 
media bus formats' which tries to remedy this. I would like to see that 
patched (or similar solution) merged before this one as to not break the 
Renesas R-Car2 Koelsch board which uses the adv7180.

If that can be arranged

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> 
> But otherwise
> 
> Acked-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> > ---
> >  drivers/media/i2c/adv7180.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> > index fff887c..427695d 100644
> > --- a/drivers/media/i2c/adv7180.c
> > +++ b/drivers/media/i2c/adv7180.c
> > @@ -654,7 +654,7 @@ static int adv7180_enum_mbus_code(struct v4l2_subdev *sd,
> >  	if (code->index != 0)
> >  		return -EINVAL;
> >  
> > -	code->code = MEDIA_BUS_FMT_YUYV8_2X8;
> > +	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
> >  
> >  	return 0;
> >  }
> > @@ -664,7 +664,7 @@ static int adv7180_mbus_fmt(struct v4l2_subdev *sd,
> >  {
> >  	struct adv7180_state *state = to_state(sd);
> >  
> > -	fmt->code = MEDIA_BUS_FMT_YUYV8_2X8;
> > +	fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
> >  	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
> >  	fmt->width = 720;
> >  	fmt->height = state->curr_norm & V4L2_STD_525_60 ? 480 : 576;
> > 
> 

-- 
Regards,
Niklas Söderlund
