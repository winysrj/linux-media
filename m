Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:44688 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934968AbdLRWow (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 17:44:52 -0500
Received: by mail-lf0-f67.google.com with SMTP id x204so19516157lfa.11
        for <linux-media@vger.kernel.org>; Mon, 18 Dec 2017 14:44:51 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Mon, 18 Dec 2017 23:44:48 +0100
To: kieran.bingham@ideasonboard.com
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH/RFC v2 09/15] adv748x: csi2: add module param for virtual
 channel
Message-ID: <20171218224448.GC32148@bigcity.dyn.berto.se>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
 <20171214190835.7672-10-niklas.soderlund+renesas@ragnatech.se>
 <9eca77d9-641e-ed01-9f2a-0013aa6540d9@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9eca77d9-641e-ed01-9f2a-0013aa6540d9@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thanks for your comments.

On 2017-12-14 22:19:59 +0000, Kieran Bingham wrote:
> Hi Niklas,
> 
> On 14/12/17 19:08, Niklas Söderlund wrote:
> > The hardware can output on any of the 4 (0-3) Virtual Channels of the
> > CSI-2 bus. Add a module parameter each for TXA and TXB to allow the user
> > to specify which channel should be used.
> 
> This patch only configures the channel at initialisation time, (which is a valid
> thing to do here at the moment I think) - but will we expect to provide
> functionality to change the virtual channel later ?

I had no plan to add such functionality. But I would be open to 
suggesters on where to add such a control. I thought about this when 
working with this patch-set and I can think of three other places to 
control this.

1. A debugfs file
2. A configfs file
3. Define 4 streams in the frame descriptor for the source pad, one for 
   each CSI-2 VC. Then use the new G/S_ROUTE ioctls to control which 
   stream of the source the sink is connected to.

I thought option 1 and 2 was not the correct place for such a control.  
And option 3 would make the control of the VC output depending on this 
patch-set and all its dependencies. And since my use-case for this was 
patch is to test this patch-set it seemed silly at the time :-) But the 
more I think of this might be the best way forward for this type of 
things, what do you think?

> 
> Do we need to communicate the virtual channel in use across the media pad links
> somehow? (or does that already happen?)

Yes, this is part of this patch-set and its dependencies. The frame 
descriptor contains information about stream to CSI-2 virtual channel 
(and data type) mapping. While the G/S_ROUTE operations contains the 
controls and information on which stream of a multiplexed pad is routed 
to which 'normal' pad.

> 
> Perhaps the commit message could be clear on the fact that this only sets the
> channels initialisation value - and that modifying the module parameter after
> module load will have no effect?

Is this not true for all module parameters, they only have an effect at 
module load time? Can you even modify them after module load?

> 
> Regards
> 
> Kieran
> 
> 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> >
> > ---
> >  drivers/media/i2c/adv748x/adv748x-core.c | 10 ++++++++++
> >  drivers/media/i2c/adv748x/adv748x-csi2.c |  2 +-
> >  drivers/media/i2c/adv748x/adv748x.h      |  1 +
> >  3 files changed, 12 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> > index fd92c9e4b519d2c5..3cad52532ead2e34 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-core.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> > @@ -31,6 +31,9 @@
> >  
> >  #include "adv748x.h"
> >  
> > +static unsigned int txavc;
> > +static unsigned int txbvc;
> > +
> >  /* -----------------------------------------------------------------------------
> >   * Register manipulation
> >   */
> > @@ -747,6 +750,7 @@ static int adv748x_probe(struct i2c_client *client,
> >  	}
> >  
> >  	/* Initialise TXA */
> > +	state->txa.vc = txavc;
> >  	ret = adv748x_csi2_init(state, &state->txa);
> >  	if (ret) {
> >  		adv_err(state, "Failed to probe TXA");
> > @@ -754,6 +758,7 @@ static int adv748x_probe(struct i2c_client *client,
> >  	}
> >  
> >  	/* Initialise TXB */
> > +	state->txb.vc = txbvc;
> >  	ret = adv748x_csi2_init(state, &state->txb);
> >  	if (ret) {
> >  		adv_err(state, "Failed to probe TXB");
> > @@ -824,6 +829,11 @@ static struct i2c_driver adv748x_driver = {
> >  
> >  module_i2c_driver(adv748x_driver);
> >  
> > +module_param(txavc, uint, 0644);
> > +MODULE_PARM_DESC(txavc, "Virtual Channel for TXA");
> > +module_param(txbvc, uint, 0644);
> > +MODULE_PARM_DESC(txbvc, "Virtual Channel for TXB");
> > +
> >  MODULE_AUTHOR("Kieran Bingham <kieran.bingham@ideasonboard.com>");
> >  MODULE_DESCRIPTION("ADV748X video decoder");
> >  MODULE_LICENSE("GPL v2");
> > diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> > index 820b44ed56a8679f..2a5dff8c571013bf 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> > @@ -281,7 +281,7 @@ int adv748x_csi2_init(struct adv748x_state *state, struct adv748x_csi2 *tx)
> >  	}
> >  
> >  	/* Initialise the virtual channel */
> > -	adv748x_csi2_set_virtual_channel(tx, 0);
> > +	adv748x_csi2_set_virtual_channel(tx, tx->vc);
> >  
> >  	adv748x_subdev_init(&tx->sd, state, &adv748x_csi2_ops,
> >  			    MEDIA_ENT_F_UNKNOWN,
> > diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
> > index 6789e2f3bc8c2b49..f6e40ee3924e8f12 100644
> > --- a/drivers/media/i2c/adv748x/adv748x.h
> > +++ b/drivers/media/i2c/adv748x/adv748x.h
> > @@ -92,6 +92,7 @@ enum adv748x_csi2_pads {
> >  
> >  struct adv748x_csi2 {
> >  	struct adv748x_state *state;
> > +	unsigned int vc;
> >  	struct v4l2_mbus_framefmt format;
> >  	unsigned int page;
> >  
> > 

-- 
Regards,
Niklas Söderlund
