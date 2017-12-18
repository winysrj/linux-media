Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:39982 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935208AbdLRW6F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 17:58:05 -0500
Received: by mail-lf0-f67.google.com with SMTP id g74so9629503lfk.7
        for <linux-media@vger.kernel.org>; Mon, 18 Dec 2017 14:58:04 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Mon, 18 Dec 2017 23:58:02 +0100
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH/RFC v2 14/15] adv748x: csi2: add get_routing support
Message-ID: <20171218225802.GD32148@bigcity.dyn.berto.se>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
 <20171214190835.7672-15-niklas.soderlund+renesas@ragnatech.se>
 <23bd28e2-5949-da25-b3e6-84f6d20dd8ef@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <23bd28e2-5949-da25-b3e6-84f6d20dd8ef@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thanks for your comments,

On 2017-12-14 23:27:57 +0000, Kieran Bingham wrote:
> Hi Niklas,
> 
> On 14/12/17 19:08, Niklas Söderlund wrote:
> > To support multiplexed streams the internal routing between the
> > adv748x sink pad and its source pad needs to be described.
> 
> The adv748x has quite a few sink and source pads... I presume here you mean the
> adv748x csi2 sink and source pad :D

Yes :-) Will fix for next version, thanks.

> 
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/i2c/adv748x/adv748x-csi2.c | 22 ++++++++++++++++++++++
> >  1 file changed, 22 insertions(+)
> > 
> > diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> > index 291b35bef49d41fb..dbefb53f5b8c414d 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> > @@ -262,10 +262,32 @@ static int adv748x_csi2_get_frame_desc(struct v4l2_subdev *sd, unsigned int pad,
> >  	return 0;
> >  }
> >  
> > +static int adv748x_csi2_get_routing(struct v4l2_subdev *subdev,
> > +				    struct v4l2_subdev_routing *routing)
> > +{
> > +	struct v4l2_subdev_route *r = routing->routes;
> > +
> > +	if (routing->num_routes < 1) {
> > +		routing->num_routes = 1;
> > +		return -ENOSPC;
> > +	}
> > +
> > +	routing->num_routes = 1;
> > +
> > +	r->sink_pad = ADV748X_CSI2_SINK;
> > +	r->sink_stream = 0;
> > +	r->source_pad = ADV748X_CSI2_SOURCE;
> > +	r->source_stream = 0;
> > +	r->flags = V4L2_SUBDEV_ROUTE_FL_ACTIVE | V4L2_SUBDEV_ROUTE_FL_IMMUTABLE;
> > +
> > +	return 0;
> > +}
> > +
> 
> So - I think this is fine - but it seems a lot of code to define a static
> default route which describes a single link between it's sink pad - and its
> source pad ...
> 
> I suspect this should/could be wrapped by some helpers in core for cases like
> this, as it's the simple case - but as we don't currently have that I guess we
> have to put this in here for now ?

Yes for now we need to fill in the information here.

> 
> Maybe we should have a helper to make this

I'm sure there could be v4l2 helpers for such a case. I don't even think 
you wound need to prime it with any information. If there is only one 
source and one sink I'm sure a helper function can figure it out :-)

> 
> return v4l2_subdev_single_route(subdev, routing,
>                                 ADV748X_CS2_SINK, 0,
>                                 ADV748X_CSI2_SOURCE, 0,
>                   V4L2_SUBDEV_ROUTE_FL_ACTIVE | V4L2_SUBDEV_ROUTE_FL_IMMUTABLE);
> 
> Or maybe even define these static routes in a struct somehow?

For more complex setups a struct could be used together with a helper 
function to decode it. But then again maybe it's easier to just define a 
const v4l2_subdev_route array and 'routing->routes = my_const_routes' ?

> 
> >  static const struct v4l2_subdev_pad_ops adv748x_csi2_pad_ops = {
> >  	.get_fmt = adv748x_csi2_get_format,
> >  	.set_fmt = adv748x_csi2_set_format,
> >  	.get_frame_desc = adv748x_csi2_get_frame_desc,
> > +	.get_routing = adv748x_csi2_get_routing,
> >  	.s_stream = adv748x_csi2_s_stream,
> >  };
> >  
> > 

-- 
Regards,
Niklas Söderlund
