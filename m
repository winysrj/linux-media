Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:33956 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751489AbeDOXQj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Apr 2018 19:16:39 -0400
Received: by mail-lf0-f41.google.com with SMTP id r7-v6so12343202lfr.1
        for <linux-media@vger.kernel.org>; Sun, 15 Apr 2018 16:16:38 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Mon, 16 Apr 2018 01:16:35 +0200
To: jacopo mondi <jacopo@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v13 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver
 driver
Message-ID: <20180415231635.GH20093@bigcity.dyn.berto.se>
References: <20180212230132.5402-1-niklas.soderlund+renesas@ragnatech.se>
 <20180212230132.5402-3-niklas.soderlund+renesas@ragnatech.se>
 <20180405091001.GI20945@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180405091001.GI20945@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your feedback.

Comments I have snipped out from this reply are addressed, thanks for 
bringing them to my attention!

On 2018-04-05 11:10:01 +0200, Jacopo Mondi wrote:

[snip]

> > +static int rcar_csi2_wait_phy_start(struct rcar_csi2 *priv)
> > +{
> > +	int timeout;
> > +
> > +	/* Wait for the clock and data lanes to enter LP-11 state. */
> > +	for (timeout = 100; timeout > 0; timeout--) {
> > +		const u32 lane_mask = (1 << priv->lanes) - 1;
> > +
> > +		if ((rcar_csi2_read(priv, PHCLM_REG) & 1) == 1 &&
> 
> Nitpicking:
> 		if ((rcar_csi2_read(priv, PHCLM_REG) & 0x01) &&
> 
> Don't you prefer to provide defines also for bit fields instead of
> using magic values? In this case something like
> PHCLM_REG_STOPSTATE_CLK would do.

Thanks addressed per your and Kieran's suggestion.

> 
> Also, from tables 25.[17-20] it seems to me that for H3 and V3 you
> have to set INSTATE to an hardcoded value after having validated PHDLM.
> Maybe it is not necessary, just pointing it out.

I assume you mean Figures 25.[17-20] and not Tables as the last table in 
chapter 25 is Table 25.15 and the register in question is INTSTATE :-) 
And to clarify this is documented for H3 which this driver supports and 
V3H and M3-N which this driver dose not yet support. And the constant 
you are to set it to is ULPS_START | UPLS_END.

This is a good catch as this was introduced in a later version of the 
datasheet and the current code where the ULPS_START | UPLS_END is set 
before confirming LP-11 have kept on working. Check the 
priv->info->clear_ulps usage in rcar_csi2_start(). I do think it's 
better to follow the flow-chart in the new datasheet so I will move this 
to the end of rcar_csi2_start() to reflect that (provided that the end 
result still works :-) Thanks for pointing this out!

[snip]

> > +static int rcar_csi2_start(struct rcar_csi2 *priv)
> > +{
> > +	const struct rcar_csi2_format *format;
> > +	u32 phycnt, phypll, vcdt = 0, vcdt2 = 0;
> > +	unsigned int i;
> > +	int ret;
> > +
> > +	dev_dbg(priv->dev, "Input size (%ux%u%c)\n",
> > +		priv->mf.width, priv->mf.height,
> > +		priv->mf.field == V4L2_FIELD_NONE ? 'p' : 'i');
> > +
> > +	/* Code is validated in set_fmt */
> > +	format = rcar_csi2_code_to_fmt(priv->mf.code);
> > +
> > +	/*
> > +	 * Enable all Virtual Channels
> > +	 *
> > +	 * NOTE: It's not possible to get individual datatype for each
> > +	 *       source virtual channel. Once this is possible in V4L2
> > +	 *       it should be used here.
> > +	 */
> > +	for (i = 0; i < 4; i++) {
> > +		u32 vcdt_part;
> > +
> > +		vcdt_part = VCDT_SEL_VC(i) | VCDT_VCDTN_EN | VCDT_SEL_DTN_ON |
> > +			VCDT_SEL_DT(format->datatype);
> > +
> > +		/* Store in correct reg and offset */
> > +		if (i < 2)
> > +			vcdt |= vcdt_part << ((i % 2) * 16);
> > +		else
> > +			vcdt2 |= vcdt_part << ((i % 2) * 16);
> > +	}
> > +
> > +	switch (priv->lanes) {
> > +	case 1:
> > +		phycnt = PHYCNT_ENABLECLK | PHYCNT_ENABLE_0;
> > +		break;
> > +	case 2:
> > +		phycnt = PHYCNT_ENABLECLK | PHYCNT_ENABLE_1 | PHYCNT_ENABLE_0;
> > +		break;
> > +	case 4:
> > +		phycnt = PHYCNT_ENABLECLK | PHYCNT_ENABLE_3 | PHYCNT_ENABLE_2 |
> > +			PHYCNT_ENABLE_1 | PHYCNT_ENABLE_0;
> > +		break;
> 
> Even simpler this could be written as
> 
>                 phycnt = PHYCNT_ENABLECLK | (1 << priv->lanes) - 1;

Fixed per your and Geert's suggestion.

> 
> > +	default:
> > +		return -EINVAL;
> 
> Can this happen? You have validated priv->lanes already when parsing
> DT

This can't happen but I like to have a catch all in any case, but since 
I took yours and Geert's suggestion above this issue goes away :-)

> 
> > +	}
> > +
> > +	ret = rcar_csi2_calc_phypll(priv, format->bpp, &phypll);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Clear Ultra Low Power interrupt */
> > +	if (priv->info->clear_ulps)
> > +		rcar_csi2_write(priv, INTSTATE_REG,
> > +				INTSTATE_INT_ULPS_START |
> > +				INTSTATE_INT_ULPS_END);
> > +
> > +	/* Init */
> > +	rcar_csi2_write(priv, TREF_REG, TREF_TREF);
> > +	rcar_csi2_reset(priv);
> > +	rcar_csi2_write(priv, PHTC_REG, 0);
> > +
> > +	/* Configure */
> > +	rcar_csi2_write(priv, FLD_REG, FLD_FLD_NUM(2) | FLD_FLD_EN4 |
> > +			FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN);
> 
> On the FLD_FLD_NUM(2) mask. Why 2?
> I read on the datasheet "the register must not be changed from default
> value" and I read defaul to be 0x0000

This is based on feedback from Renesas. The register is not properly 
documented. I'm working on improving it but for now I would like to keep 
it as FLD_FLD_NUM(2) and make a neater and documented fix in a follow up 
commit. In short it controls which field is captured first (ODD/EVEN).

> 
> Also, please consider a make as all other fields are enabled
> unconditionally.

No I don't like the idea of a mask here, I feel it better to be 
explicit.

> 
> > +	rcar_csi2_write(priv, VCDT_REG, vcdt);
> > +	rcar_csi2_write(priv, VCDT2_REG, vcdt2);
> > +	/* Lanes are zero indexed */
> > +	rcar_csi2_write(priv, LSWAP_REG,
> > +			LSWAP_L0SEL(priv->lane_swap[0] - 1) |
> > +			LSWAP_L1SEL(priv->lane_swap[1] - 1) |
> > +			LSWAP_L2SEL(priv->lane_swap[2] - 1) |
> > +			LSWAP_L3SEL(priv->lane_swap[3] - 1));
> 
> EDIT:
> (This comment is way too long for the real value it has, but since I
> already wrote it, and my initial doubt clarified while I was writing,
> resulting in a much less serious issues, I'm gonna keep it all anyway.
> Sorry about this :)
> 
> Why - 1 ?
> Is this because it is assumed clock lane is in position 0? Is this
> fixed by design?
> 
> What I read in datasheet for LSWAP_REG is:
> L[0-3]SEL       0 = Use PHY lane 0
>                 1 = Use PHY lane 1
>                 2 = Use PHY lane 2
>                 3 = Use PHY lane 3
> 
> priv->lane_swap[i] is collected parsing 'data_lanes' property and
> should reflect the actual physical lane value assigned to logical lane
> numbers. If 'data_lanes' is, say <1 2> I expect
> 
> priv->lane_swap[0] = 1;
> priv->lane_swap[1] = 2;
> priv->lane_swap[1] = 3; //assigned by your parsing routine
> priv->lane_swap[1] = 4; //assigned by your parsing routine
> 
> And I understand LSWAP counts instead from [0-3] so, ok, I get why you
> subtract one. But now I wonder what happens if instead, lane position
> is specified counting from 0 in DT. Ah, I see you refuse lane_swap
> values < 1! So It should be assumed clock is by HW design on lane 0,
> so wouldn't you need to mention in DT bindings that the HW has clock
> lanes fixed in position 0 and the accepted values for the 'data_lanes'
> property ranges in the [1-4] interval?

My understanding of video-interfaces.txt which is reference in the DT 
documentation is that the clock is always 0 and the data lanes are 
numbers 1-4 for CSI-2.

> 
> > +
> > +	if (priv->info->init_phtw) {
> > +		/*
> > +		 * This is for H3 ES2.0
> > +		 *
> > +		 * NOTE: Additional logic is needed here when
> > +		 * support for V3H and/or M3-N is added
> > +		 */
> > +		rcar_csi2_write(priv, PHTW_REG, 0x01cc01e2);
> > +		rcar_csi2_write(priv, PHTW_REG, 0x010101e3);
> > +		rcar_csi2_write(priv, PHTW_REG, 0x010101e4);
> > +		rcar_csi2_write(priv, PHTW_REG, 0x01100104);
> > +		rcar_csi2_write(priv, PHTW_REG, 0x01030100);
> > +		rcar_csi2_write(priv, PHTW_REG, 0x01800100);
> > +	}
> > +
> > +	/* Start */
> > +	rcar_csi2_write(priv, PHYPLL_REG, phypll);
> > +
> > +	/* Set frequency range if we have it */
> > +	if (priv->info->csi0clkfreqrange)
> > +		rcar_csi2_write(priv, CSI0CLKFCPR_REG,
> > +				CSI0CLKFREQRANGE(priv->info->csi0clkfreqrange));
> > +
> > +	rcar_csi2_write(priv, PHYCNT_REG, phycnt);
> > +	rcar_csi2_write(priv, LINKCNT_REG, LINKCNT_MONITOR_EN |
> > +			LINKCNT_REG_MONI_PACT_EN | LINKCNT_ICLK_NONSTOP);
> > +	rcar_csi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ);
> > +	rcar_csi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ |
> > +			PHYCNT_RSTZ);
> 
> Nit: from tables 25.[17-20] it seems to me you do not have to re-issue
> PHYCNT_SHUTDOWNZ when writing PHYCNT_RSTZ to PHYCNT_REG.

You are correct, I miss read '.... Here, the ENABLE_0 to ENABLE_3 and
ENABLECLK values set above should be retained' as all previous PHYCNT 
bits should be retained not just the ones explicitly listed. I will give 
this a test and if it still works I will remove it for the next version.

> 
> > +
> > +	return rcar_csi2_wait_phy_start(priv);
> > +}
> > +
> > +static void rcar_csi2_stop(struct rcar_csi2 *priv)
> > +{
> > +	rcar_csi2_write(priv, PHYCNT_REG, 0);
> > +
> > +	rcar_csi2_reset(priv);
> > +}
> > +
> > +static int rcar_csi2_s_stream(struct v4l2_subdev *sd, int enable)
> > +{
> > +	struct rcar_csi2 *priv = sd_to_csi2(sd);
> > +	struct v4l2_subdev *nextsd;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&priv->lock);
> > +
> > +	if (!priv->remote) {
> > +		ret = -ENODEV;
> > +		goto out;
> > +	}
> 
> Can this happen?

Sure, the video source is unbound and as you note bellow the unbind 
callback sets priv->remote = NULL. Or even simpler the driver for the 
video source is not loaded at all so the rcar-csi2 drivers bound 
callback is never called.

> 
> The 'bind' callback sets priv->remote and it gets assigned back to
> NULL only on 'unbind'. Wouldn't it be better to remove the link in the
> media graph and let the system return an EPIPE before calling this?

That would be very complex as some driver in the pipeline (VIN?) would 
have to parse the full graph in DT and somehow with subdevice support 
helpers to traverse the DT port to MC pad mapping using helpers that do 
not exist yet (and are hard to use if the remote subdevice driver is not 
loaded) to build a full view of the pipeline and return -EPIPE if not 
all entities are present in the media graph :-)

[snip]

> > +static int rcar_csi2_parse_v4l2(struct rcar_csi2 *priv,
> > +				struct v4l2_fwnode_endpoint *vep)
> > +{
> > +	unsigned int i;
> > +
> > +	/* Only port 0 endpoint 0 is valid */
> > +	if (vep->base.port || vep->base.id)
> > +		return -ENOTCONN;
> > +
> > +	if (vep->bus_type != V4L2_MBUS_CSI2) {
> > +		dev_err(priv->dev, "Unsupported bus: 0x%x\n", vep->bus_type);
> > +		return -EINVAL;
> > +	}
> > +
> > +	priv->lanes = vep->bus.mipi_csi2.num_data_lanes;
> > +	if (priv->lanes != 1 && priv->lanes != 2 && priv->lanes != 4) {
> 
> Is this an HW limitation? Like the 'data_lanes' comment, if it is,
> shouldn't you mention in bindings that the accepted lane numbers is
> limited to the [1,2,4] values.

Yes, see chapter 25.4.8 Lane Setting.

[snip]

> 
> No serious issues though. So when fixed/clarified feel free to append my
> Reviewed-by tag, if relevant at all.

Thanks! I feel I managed to address all of your review comments but 
would still like your confirmation for me to add your tag. Thanks again 
for the review!

-- 
Regards,
Niklas Söderlund
