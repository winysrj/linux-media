Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39334 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbbGNKKK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2015 06:10:10 -0400
Message-ID: <1436868605.3793.24.camel@pengutronix.de>
Subject: Re: [PATCH 3/5] [media] tc358743: support probe from device tree
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mats Randgaard <matrandg@cisco.com>, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kernel@pengutronix.de
Date: Tue, 14 Jul 2015 12:10:05 +0200
In-Reply-To: <55A39982.3030006@xs4all.nl>
References: <1436533897-3060-1-git-send-email-p.zabel@pengutronix.de>
	 <1436533897-3060-3-git-send-email-p.zabel@pengutronix.de>
	 <55A39982.3030006@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Am Montag, den 13.07.2015, 12:57 +0200 schrieb Hans Verkuil:
[...]
> > @@ -69,6 +72,7 @@ static const struct v4l2_dv_timings_cap tc358743_timings_cap = {
> >  
> >  struct tc358743_state {
> >  	struct tc358743_platform_data pdata;
> > +	struct v4l2_of_bus_mipi_csi2 bus;
> 
> Where is this bus struct set?

Uh-oh, I have accidentally dropped setting the bus struct when switching
to v4l2_of_alloc_parse_endpoint.

[...]
> > @@ -700,7 +706,8 @@ static void tc358743_set_csi(struct v4l2_subdev *sd)
> >  			((lanes > 2) ? MASK_D2M_HSTXVREGEN : 0x0) |
> >  			((lanes > 3) ? MASK_D3M_HSTXVREGEN : 0x0));
> >  
> > -	i2c_wr32(sd, TXOPTIONCNTRL, MASK_CONTCLKMODE);
> > +	i2c_wr32(sd, TXOPTIONCNTRL, (state->bus.flags &
> > +		 V4L2_MBUS_CSI2_CONTINUOUS_CLOCK) ? MASK_CONTCLKMODE : 0);
> 
> It's used here.
> 
> BTW, since I don't see state->bus being set, that means bus.flags == 0 and
> so this register is now set to 0 instead of MASK_CONTCLKMODE.
> 
> When using platform data I guess bus.flags should be set to
> V4L2_MBUS_CSI2_CONTINUOUS_CLOCK to prevent breakage.

Ok.

[..]
> > +	/*
> > +	 * The CSI bps per lane must be between 62.5 Mbps and 1 Gbps.
> > +	 * The default is 594 Mbps for 4-lane 1080p60 or 2-lane 720p60.
> > +	 */
> > +	bps_pr_lane = 2 * endpoint->link_frequencies[0];
> > +	if (bps_pr_lane < 62500000U || bps_pr_lane > 1000000000U) {
> > +		dev_err(dev, "unsupported bps per lane: %u bps\n", bps_pr_lane);
> > +		goto disable_clk;
> > +	}
> > +
> > +	/* The CSI speed per lane is refclk / pll_prd * pll_fbd */
> > +	state->pdata.pll_fbd = bps_pr_lane /
> > +			       state->pdata.refclk_hz * state->pdata.pll_prd;
> > +
> > +	/*
> > +	 * FIXME: These timings are from REF_02 for 594 Mbps per lane (297 MHz
> > +	 * link frequency). In principle it should be possible to calculate
> > +	 * them based on link frequency and resolution.
> > +	 */
> > +	if (bps_pr_lane != 594000000U)
> > +		dev_warn(dev, "untested bps per lane: %u bps\n", bps_pr_lane);
> > +	state->pdata.lineinitcnt = 0xe80;
> > +	state->pdata.lptxtimecnt = 0x003;
> > +	/* tclk-preparecnt: 3, tclk-zerocnt: 20 */
> > +	state->pdata.tclk_headercnt = 0x1403;
> > +	state->pdata.tclk_trailcnt = 0x00;
> > +	/* ths-preparecnt: 3, ths-zerocnt: 1 */
> > +	state->pdata.ths_headercnt = 0x0103;
> > +	state->pdata.twakeup = 0x4882;
> > +	state->pdata.tclk_postcnt = 0x008;
> > +	state->pdata.ths_trailcnt = 0x2;
> > +	state->pdata.hstxvregcnt = 0;

Do you have any suggestion how to handle this? AFAIK REF_02 is not
public, and I do not know the formulas it uses internally to calculate
these timings. I wouldn't want to add all the timing parameters to the
device tree just because of that.

[...]
> > @@ -1658,14 +1794,19 @@ static int tc358743_probe(struct i2c_client *client,
> >  	if (!state)
> >  		return -ENOMEM;
> >  
> > +	state->i2c_client = client;
> > +
> >  	/* platform data */
> > -	if (!pdata) {
> > -		v4l_err(client, "No platform data!\n");
> > -		return -ENODEV;
> > +	if (pdata) {
> > +		state->pdata = *pdata;
> > +	} else {
> > +		err = tc358743_probe_of(state);
> > +		if (err == -ENODEV)
> > +			v4l_err(client, "No platform data!\n");
> 
> I'd replace this with "No device tree data!" or something like that.

I'll do that, thank you.

regards
Philipp

