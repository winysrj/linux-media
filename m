Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48514 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751684AbdBTA73 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Feb 2017 19:59:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, mchehab@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] omap3isp: add support for CSI1 bus
Date: Mon, 20 Feb 2017 02:59:53 +0200
Message-ID: <2414221.XNA4JCFMRx@avalon>
In-Reply-To: <20170215094228.GA8586@amd>
References: <20161228183036.GA13139@amd> <10545906.Gxg3yScdu4@avalon> <20170215094228.GA8586@amd>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Wednesday 15 Feb 2017 10:42:29 Pavel Machek wrote:
> Hi!
> 
> >> diff --git a/drivers/media/platform/omap3isp/isp.c
> >> b/drivers/media/platform/omap3isp/isp.c index 0321d84..88bc7c6 100644
> >> --- a/drivers/media/platform/omap3isp/isp.c
> >> +++ b/drivers/media/platform/omap3isp/isp.c
> >> @@ -2024,21 +2024,92 @@ enum isp_of_phy {
> >>  	ISP_OF_PHY_CSIPHY2,
> >>  };
> >> 
> >> -static int isp_of_parse_node(struct device *dev, struct device_node
> >> *node,
> >> -			     struct isp_async_subdev *isd)
> >> +void __isp_of_parse_node_csi1(struct device *dev,
> >> +				   struct isp_ccp2_cfg *buscfg,
> >> +				   struct v4l2_of_endpoint *vep)
> > 
> > This function isn't use anywhere else, you can merge it with
> > isp_of_parse_node_csi1().
> 
> I'd prefer not to. First, it will be used separately in future, and
> second, expresions would be uglier.

Where will it be used ? As for the uglier part, I don't agree, otherwise I 
wouldn't have proposed it.

> >> +{
> >> +	buscfg->lanecfg.clk.pos = vep->bus.mipi_csi1.clock_lane;
> >> +	buscfg->lanecfg.clk.pol =
> >> +		vep->bus.mipi_csi1.lane_polarity[0];
> >> +	dev_dbg(dev, "clock lane polarity %u, pos %u\n",
> >> +		buscfg->lanecfg.clk.pol,
> >> +		buscfg->lanecfg.clk.pos);
> >> +
> >> +	buscfg->lanecfg.data[0].pos = vep->bus.mipi_csi2.data_lanes[0];
> >> +	buscfg->lanecfg.data[0].pol =
> >> +		vep->bus.mipi_csi2.lane_polarities[1];
> > 
> > bus.mipi_csi2 ?
> 
> Good catch. Fixed.
> 
> >> -	ret = v4l2_of_parse_endpoint(node, &vep);
> >> -	if (ret)
> >> -		return ret;
> >> +	if (vep->base.port == ISP_OF_PHY_CSIPHY1)
> >> +		buscfg->interface = ISP_INTERFACE_CSI2C_PHY1;
> >> +	else
> >> +		buscfg->interface = ISP_INTERFACE_CSI2A_PHY2;
> > 
> > I would keep this code in the caller to avoid code duplication with
> > isp_of_parse_node_csi1().
> 
> Take a closer look. Code in _csi1 is different.
>
> >>  		break;
> >>  	
> >>  	default:
> >> +		return -1;
> > 
> > Please use the appropriate error code.
> 
> Ok.
> 
> >> +	return 0;
> >> +}
> >> +
> >> +static int isp_of_parse_node_endpoint(struct device *dev,
> >> +				      struct device_node *node,
> >> +				      struct isp_async_subdev *isd)
> >> +{
> >> +	struct isp_bus_cfg *buscfg;
> >> +	struct v4l2_of_endpoint vep;
> >> +	int ret;
> >> +
> >> +	isd->bus = devm_kzalloc(dev, sizeof(*isd->bus), GFP_KERNEL);
> > 
> > Why do you now need to allocate this manually ?
> 
> bus is now a pointer.

I've seen that, but why have you changed it ?

> >> +	dev_dbg(dev, "parsing endpoint %s, interface %u\n", node->full_name,
> >> +		vep.base.port);
> >> +
> >> +	if (isp_endpoint_to_buscfg(dev, vep, buscfg))
> > 
> > I'm fine splitting the CSI1/CSI2 parsing code to separate functions, but I
> > don't think there's a need to split isp_endpoint_to_buscfg(). You can keep
> > that part inline.
> 
> I'd prefer smaller functions here. I tried to read the original and it
> was not too easy.

This function became a kzalloc (which I still don't see why you need it), a 
call to v4l2_of_parse_endpoint(), and then isp_endpoint_to_buscfg(). That's 
too small to be a function of its own. Please merge 
isp_of_parse_node_endpoint() and isp_endpoint_to_buscfg().

> >> diff --git a/drivers/media/platform/omap3isp/ispccp2.c
> >> b/drivers/media/platform/omap3isp/ispccp2.c index ca09523..4edb55a
> >> 100644
> >> --- a/drivers/media/platform/omap3isp/ispccp2.c
> >> +++ b/drivers/media/platform/omap3isp/ispccp2.c
> >> @@ -160,6 +163,33 @@ static int ccp2_if_enable(struct isp_ccp2_device
> >> *ccp2, u8 enable) return ret;
> >> 
> >>  	}
> >> 
> >> +	if (isp->revision == ISP_REVISION_2_0) {
> > 
> > The isp_csiphy.c code checks phy->isp->phy_type for the same purpose,
> > shouldn't you use that too ?
> 
> Do you want me to do phy->isp->phy_type == ISP_PHY_TYPE_3430 check
> here? Can do...

Yes that's what I meant.

> >> +		buscfg = &((struct isp_bus_cfg *)sensor->host_priv)->bus.ccp2;
> >> +
> >> +
> > 
> > One blank line is enough.
> 
> Ok.
> 
> >> +		if (enable) {
> >> +			csirxfe = OMAP343X_CONTROL_CSIRXFE_PWRDNZ |
> >> +				  OMAP343X_CONTROL_CSIRXFE_RESET;
> >> +
> >> +			if (buscfg->phy_layer)
> >> +				csirxfe |= OMAP343X_CONTROL_CSIRXFE_SELFORM;
> >> +
> >> +			if (buscfg->strobe_clk_pol)
> >> +				csirxfe |= OMAP343X_CONTROL_CSIRXFE_CSIB_INV;
> >> +		} else
> >> +			csirxfe = 0;
> > 
> > You need curly braces for the else statement too.
> 
> Easy enough.
> 
> >> +
> >> +		regmap_write(isp->syscon, isp->syscon_offset, csirxfe);
> > 
> > Isn't this already configured by csiphy_routing_cfg_3430(), called through
> > omap3isp_csiphy_acquire() ? You'll need to add support for the
> > strobe/clock polarity there, but the rest should already be handled.
> 
> Let me check...
> 
> >> @@ -69,11 +69,15 @@
> >>   * @V4L2_MBUS_PARALLEL:	parallel interface with hsync and vsync
> >>   * @V4L2_MBUS_BT656:	parallel interface with embedded
> >> synchronisation, can
> >>   *			also be used for BT.1120
> > > + * @V4L2_MBUS_CSI1:	MIPI CSI-1 serial interface
> > > + * @V4L2_MBUS_CCP2:	CCP2 (Compact Camera Port 2)
> > 
> > It would help if you could provide, in comments or in the commit message,
> > a few pointers to information about CSI-1 and CCP2.
> 
> There's not much good information :-(.
> 
> http://electronics.stackexchange.com/questions/134395/differences-between-mi
> pi-csi1-and-mipi-csi2

> >>  /**
> >> 
> >> + * struct v4l2_of_bus_csi1 - CSI-1/CCP2 data bus structure
> >> + * @clock_inv: polarity of clock/strobe signal
> >> + *	       false - not inverted, true - inverted
> >> + * @strobe: false - data/clock, true - data/strobe
> >> + * @data_lane: the number of the data lane
> >> + * @clock_lane: the number of the clock lane
> >> + */
> >> +struct v4l2_of_bus_mipi_csi1 {
> >> +	bool clock_inv;
> >> +	bool strobe;
> >> +	bool lane_polarity[2];
> > 
> > This field isn't documented.
> 
> Yep, automatic checker already told me. Plus, similar field elsewhere
> is called "lane_polarities" but I believe "polarity" is a better name.

-- 
Regards,

Laurent Pinchart
