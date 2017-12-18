Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:46142 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936193AbdLRWZs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 17:25:48 -0500
Received: by mail-lf0-f66.google.com with SMTP id r143so19465504lfe.13
        for <linux-media@vger.kernel.org>; Mon, 18 Dec 2017 14:25:47 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Mon, 18 Dec 2017 23:25:45 +0100
To: kieran.bingham@ideasonboard.com
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH/RFC v2 13/15] adv748x: csi2: only allow formats on sink
 pads
Message-ID: <20171218222545.GB32148@bigcity.dyn.berto.se>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
 <20171214190835.7672-14-niklas.soderlund+renesas@ragnatech.se>
 <e365c00d-701d-4586-4013-e4f3ff58d85a@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e365c00d-701d-4586-4013-e4f3ff58d85a@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI Kieran,

Thanks for your comments.

On 2017-12-14 23:16:08 +0000, Kieran Bingham wrote:
> Hi Niklas,
> 
> On 14/12/17 19:08, Niklas Söderlund wrote:
> > The driver is now pad and stream aware, only allow to get/set format on
> > sink pads.
> 
> Ok - I can see the patch is doing this ...
> 
> > Also record a different format for each sink pad since it's
> > no longer true that they are all the same
> 
> But I can't see how the patch is doing this ^ ?
> 
> What have I missed?

I have missed moving this commit message to another patch when moving 
code around :-) Thanks for noticing. Will fix this for next version.

> 
> --
> Kieran
> 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/i2c/adv748x/adv748x-csi2.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> > index 39f993282dd3bb5c..291b35bef49d41fb 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> > @@ -176,6 +176,9 @@ static int adv748x_csi2_get_format(struct v4l2_subdev *sd,
> >  	struct adv748x_state *state = tx->state;
> >  	struct v4l2_mbus_framefmt *mbusformat;
> >  
> > +	if (sdformat->pad != ADV748X_CSI2_SINK)
> > +		return -EINVAL;
> > +
> >  	mbusformat = adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad,
> >  						 sdformat->which);
> >  	if (!mbusformat)
> > @@ -199,6 +202,9 @@ static int adv748x_csi2_set_format(struct v4l2_subdev *sd,
> >  	struct v4l2_mbus_framefmt *mbusformat;
> >  	int ret = 0;
> >  
> > +	if (sdformat->pad != ADV748X_CSI2_SINK)
> > +		return -EINVAL;
> > +
> >  	mbusformat = adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad,
> >  						 sdformat->which);
> >  	if (!mbusformat)
> > 

-- 
Regards,
Niklas Söderlund
