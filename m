Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51096 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752007AbdCDSpF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Mar 2017 13:45:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Pavel Machek <pavel@ucw.cz>, mchehab@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCHv2] omap3isp: add support for CSI1 bus
Date: Sat, 04 Mar 2017 20:44:50 +0200
Message-ID: <2578197.Jc2St0chTa@avalon>
In-Reply-To: <20170304153946.GA3220@valkosipuli.retiisi.org.uk>
References: <20161228183036.GA13139@amd> <20170304130318.GU3220@valkosipuli.retiisi.org.uk> <20170304153946.GA3220@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Saturday 04 Mar 2017 17:39:46 Sakari Ailus wrote:
> On Sat, Mar 04, 2017 at 03:03:18PM +0200, Sakari Ailus wrote:
> > On Thu, Mar 02, 2017 at 01:38:48PM +0100, Pavel Machek wrote:
> >> 
> >>>> Ok, how about this one?
> >>>> omap3isp: add rest of CSI1 support
> >>>> 
> >>>> CSI1 needs one more bit to be set up. Do just that.
> >>>> 
> >>>> It is not as straightforward as I'd like, see the comments in the
> >>>> code for explanation.
> >>
> >> ...
> >> 
> >>>> +	if (isp->phy_type == ISP_PHY_TYPE_3430) {
> >>>> +		struct media_pad *pad;
> >>>> +		struct v4l2_subdev *sensor;
> >>>> +		const struct isp_ccp2_cfg *buscfg;
> >>>> +
> >>>> +		pad = media_entity_remote_pad(&ccp2
> >>>> ->pads[CCP2_PAD_SINK]);
> >>>> +		sensor = media_entity_to_v4l2_subdev(pad->entity);
> >>>> +		/* Struct isp_bus_cfg has union inside */
> >>>> +		buscfg = &((struct isp_bus_cfg *)sensor->host_priv)
> >>>> ->bus.ccp2;
> >>>> +
> >>>> +		csiphy_routing_cfg_3430(&isp->isp_csiphy2,
> >>>> +					ISP_INTERFACE_CCP2B_PHY1,
> >>> > +					enable, !!buscfg->phy_layer,
> >>> > +					buscfg->strobe_clk_pol);
> >>> 
> >>> You should do this through omap3isp_csiphy_acquire(), and not call
> >>> csiphy_routing_cfg_3430() directly from here.
> >> 
> >> Well, unfortunately omap3isp_csiphy_acquire() does have csi2
> >> assumptions hard-coded :-(.
> >> 
> >> This will probably fail.
> >> 
> >> 	        rval = omap3isp_csi2_reset(phy->csi2);
> >> 	        if (rval < 0)
> >> 		                goto done;
> > 
> > Could you try to two patches I've applied on the ccp2 branch (I'll remove
> > them if there are issues).
> > 
> > That's compile tested for now only.
> 
> One more thing. What's needed for configuring the PHY for CCP2?
> 
> For instance, is the CSI-2 PHY regulator still needed in
> omap3isp_csiphy_acquire()? One way to do this might go to see the original
> driver for N900; I don't have the TRM at hand right now.

The OMAP34xx TRM and data manual both mention separate VDDS power supplies for 
the CSIb and CSI2 I/O complexes.

vdds_csi2		CSI2 Complex I/O
vdds_csib		CSIb Complex I/O

On OMAP36xx, we instead have

vdda_csiphy1		Input power for camera PHY buffer
vdda_csiphy2		Input power for camera PHY buffer

We need to enable the vds_csib regulator to operate the CSI1/CCP2 PHY, but 
that regulator gets enabled in ispccp2.c as that module is powered by the 
vdds_csib supply on OMAP34xx. However, it won't hurt to do so, and the code 
could be simpler if we manage the regulators the same way on OMAP34xx and 
OMAP36xx.

-- 
Regards,

Laurent Pinchart
