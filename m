Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33982 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751577AbdCDPkU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Mar 2017 10:40:20 -0500
Date: Sat, 4 Mar 2017 17:39:46 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCHv2] omap3isp: add support for CSI1 bus
Message-ID: <20170304153946.GA3220@valkosipuli.retiisi.org.uk>
References: <20161228183036.GA13139@amd>
 <10545906.Gxg3yScdu4@avalon>
 <20170215094228.GA8586@amd>
 <2414221.XNA4JCFMRx@avalon>
 <20170302090143.GB27818@amd>
 <20170302101603.GE27818@amd>
 <20170302112401.GF3220@valkosipuli.retiisi.org.uk>
 <20170302123848.GA28230@amd>
 <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 04, 2017 at 03:03:18PM +0200, Sakari Ailus wrote:
> Hi Pavel,
> 
> On Thu, Mar 02, 2017 at 01:38:48PM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > > Ok, how about this one?
> > > > omap3isp: add rest of CSI1 support
> > > >     
> > > > CSI1 needs one more bit to be set up. Do just that.
> > > >     
> > > > It is not as straightforward as I'd like, see the comments in the code
> > > > for explanation.
> > ...
> > > > +	if (isp->phy_type == ISP_PHY_TYPE_3430) {
> > > > +		struct media_pad *pad;
> > > > +		struct v4l2_subdev *sensor;
> > > > +		const struct isp_ccp2_cfg *buscfg;
> > > > +
> > > > +		pad = media_entity_remote_pad(&ccp2->pads[CCP2_PAD_SINK]);
> > > > +		sensor = media_entity_to_v4l2_subdev(pad->entity);
> > > > +		/* Struct isp_bus_cfg has union inside */
> > > > +		buscfg = &((struct isp_bus_cfg *)sensor->host_priv)->bus.ccp2;
> > > > +
> > > > +		csiphy_routing_cfg_3430(&isp->isp_csiphy2,
> > > > +					ISP_INTERFACE_CCP2B_PHY1,
> > > > +					enable, !!buscfg->phy_layer,
> > > > +					buscfg->strobe_clk_pol);
> > > 
> > > You should do this through omap3isp_csiphy_acquire(), and not call
> > > csiphy_routing_cfg_3430() directly from here.
> > 
> > Well, unfortunately omap3isp_csiphy_acquire() does have csi2
> > assumptions hard-coded :-(.
> > 
> > This will probably fail.
> > 
> > 	        rval = omap3isp_csi2_reset(phy->csi2);
> > 	        if (rval < 0)
> > 		                goto done;
> 
> Could you try to two patches I've applied on the ccp2 branch (I'll remove
> them if there are issues).
> 
> That's compile tested for now only.

One more thing. What's needed for configuring the PHY for CCP2?

For instance, is the CSI-2 PHY regulator still needed in
omap3isp_csiphy_acquire()? One way to do this might go to see the original
driver for N900; I don't have the TRM at hand right now.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
