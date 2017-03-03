Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53630 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752037AbdCCWSj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Mar 2017 17:18:39 -0500
Date: Sat, 4 Mar 2017 00:17:48 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCHv2] omap3isp: add support for CSI1 bus
Message-ID: <20170303221748.GR3220@valkosipuli.retiisi.org.uk>
References: <20161228183036.GA13139@amd>
 <10545906.Gxg3yScdu4@avalon>
 <20170215094228.GA8586@amd>
 <2414221.XNA4JCFMRx@avalon>
 <20170302090143.GB27818@amd>
 <20170302101603.GE27818@amd>
 <20170302112401.GF3220@valkosipuli.retiisi.org.uk>
 <20170302123848.GA28230@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170302123848.GA28230@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Thu, Mar 02, 2017 at 01:38:48PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > Ok, how about this one?
> > > omap3isp: add rest of CSI1 support
> > >     
> > > CSI1 needs one more bit to be set up. Do just that.
> > >     
> > > It is not as straightforward as I'd like, see the comments in the code
> > > for explanation.
> ...
> > > +	if (isp->phy_type == ISP_PHY_TYPE_3430) {
> > > +		struct media_pad *pad;
> > > +		struct v4l2_subdev *sensor;
> > > +		const struct isp_ccp2_cfg *buscfg;
> > > +
> > > +		pad = media_entity_remote_pad(&ccp2->pads[CCP2_PAD_SINK]);
> > > +		sensor = media_entity_to_v4l2_subdev(pad->entity);
> > > +		/* Struct isp_bus_cfg has union inside */
> > > +		buscfg = &((struct isp_bus_cfg *)sensor->host_priv)->bus.ccp2;
> > > +
> > > +		csiphy_routing_cfg_3430(&isp->isp_csiphy2,
> > > +					ISP_INTERFACE_CCP2B_PHY1,
> > > +					enable, !!buscfg->phy_layer,
> > > +					buscfg->strobe_clk_pol);
> > 
> > You should do this through omap3isp_csiphy_acquire(), and not call
> > csiphy_routing_cfg_3430() directly from here.
> 
> Well, unfortunately omap3isp_csiphy_acquire() does have csi2
> assumptions hard-coded :-(.
> 
> This will probably fail.
> 
> 	        rval = omap3isp_csi2_reset(phy->csi2);
> 	        if (rval < 0)
> 		                goto done;

Yes. It needs to be fixed. :-)

> 				
> And this will oops:
> 
> static int omap3isp_csiphy_config(struct isp_csiphy *phy)
> {
> 	struct isp_csi2_device *csi2 = phy->csi2;
>         struct isp_pipeline *pipe = to_isp_pipeline(&csi2->subdev.entity);
>  	struct isp_bus_cfg *buscfg = pipe->external->host_priv;

There seems to be some more work left, yes. :-I

> 
> > > @@ -1137,10 +1159,19 @@ int omap3isp_ccp2_init(struct isp_device *isp)
> > >  	if (isp->revision == ISP_REVISION_2_0) {
> > >  		ccp2->vdds_csib = devm_regulator_get(isp->dev, "vdds_csib");
> > >  		if (IS_ERR(ccp2->vdds_csib)) {
> > > +			if (PTR_ERR(ccp2->vdds_csib) == -EPROBE_DEFER)
> > > +				return -EPROBE_DEFER;
> > 
> > This should go to a separate patch.
> 
> Ok, easy enough.
> 
> > >  			dev_dbg(isp->dev,
> > >  				"Could not get regulator vdds_csib\n");
> > >  			ccp2->vdds_csib = NULL;
> > >  		}
> > > +		/*
> > > +		 * If we set up ccp2->phy here,
> > > +		 * omap3isp_csiphy_acquire() will go ahead and assume
> > > +		 * csi2, dereferencing some null pointers.
> > > +		 *
> > > +		 * ccp2->phy = &isp->isp_csiphy2;
> > 
> > That needs to be fixed separately.
> 
> See analysis above. Yes, it would be nice to fix it. Can you provide
> some hints how to do that? Maybe even patch to test? :-).

If I only will have the time. Let's see if I can find some time this
week-end.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
