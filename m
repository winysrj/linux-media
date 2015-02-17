Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34233 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072AbbBQIub (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 03:50:31 -0500
Message-ID: <1424163029.3841.15.camel@pengutronix.de>
Subject: Re: [RFC v01] Driver for Toshiba TC358743 CSI-2 to HDMI bridge
From: Philipp Zabel <p.zabel@pengutronix.de>
To: matrandg@cisco.com
Cc: linux-media@vger.kernel.org, hansverk@cisco.com
Date: Tue, 17 Feb 2015 09:50:29 +0100
In-Reply-To: <1418667661-21078-1-git-send-email-matrandg@cisco.com>
References: <1418667661-21078-1-git-send-email-matrandg@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mats,

Am Montag, den 15.12.2014, 19:21 +0100 schrieb matrandg@cisco.com:
[...]
> +static void tc358743_set_pll(struct v4l2_subdev *sd)
> +{
> +	struct tc358743_state *state = to_state(sd);
> +	struct tc358743_platform_data *pdata = &state->pdata;
> +	u16 pllctl0 = i2c_rd16(sd, PLLCTL0);
> +	u16 pllctl0_new = SET_PLL_PRD(pdata->pll_prd) |
> +		SET_PLL_FBD(pdata->pll_fbd);
> +
> +	v4l2_dbg(2, debug, sd, "%s:\n", __func__);
> +
> +	/* Only rewrite when needed, since rewriting triggers another format
> +	 * change event. */
> +	if (pllctl0 != pllctl0_new) {
> +		u32 hsck = (pdata->refclk_hz * pdata->pll_prd) / pdata->pll_fbd;

This is the wrong way around. refclk_hz is divided by pll_prd to get the
PLL input clock. The PLL then multiplies by pll_fbd. Example:

refclk_hz = 27000000, pll_prd = 4, pll_fbd = 88
--> hsck = refclk_hz / pll_prd * pll_fbd = 594 MHz, pll_frs should be 0.

[...]
> +static unsigned tc358743_num_csi_lanes_needed(struct v4l2_subdev *sd)
> +{
> +	struct tc358743_state *state = to_state(sd);
> +	struct v4l2_bt_timings *bt = &state->timings.bt;
> +	u32 bits_pr_pixel =
> +		(state->mbus_fmt_code == MEDIA_BUS_FMT_UYVY8_1X16) ?  16 : 24;
> +	u32 bps = bt->width * bt->height * fps(bt) * bits_pr_pixel;

I think this calculation should include the blanking intervals.

> +static void tc358743_set_csi(struct v4l2_subdev *sd)
> +{
> +	struct tc358743_state *state = to_state(sd);
> +	struct tc358743_platform_data *pdata = &state->pdata;
> +	unsigned lanes = tc358743_num_csi_lanes_needed(sd);
> +
> +	v4l2_dbg(3, debug, sd, "%s:\n", __func__);
> +
> +	tc358743_reset(sd, MASK_CTXRST);
> +
> +	if (lanes < 1)
> +		i2c_wr32(sd, CLW_CNTRL, MASK_CLW_LANEDISABLE);
> +	if (lanes < 1)
> +		i2c_wr32(sd, D0W_CNTRL, MASK_D0W_LANEDISABLE);
> +	if (lanes < 2)
> +		i2c_wr32(sd, D1W_CNTRL, MASK_D1W_LANEDISABLE);
> +	if (lanes < 3)
> +		i2c_wr32(sd, D2W_CNTRL, MASK_D2W_LANEDISABLE);
> +	if (lanes < 4)
> +		i2c_wr32(sd, D3W_CNTRL, MASK_D3W_LANEDISABLE);
> +
> +	i2c_wr32(sd, LINEINITCNT, pdata->lineinitcnt);
> +	i2c_wr32(sd, LPTXTIMECNT, pdata->lptxtimecnt);
> +	i2c_wr32(sd, TCLK_HEADERCNT, pdata->tclk_headercnt);
> +	i2c_wr32(sd, THS_HEADERCNT, pdata->ths_headercnt);
> +	i2c_wr32(sd, TWAKEUP, pdata->twakeup);
> +	i2c_wr32(sd, THS_TRAILCNT, pdata->ths_trailcnt);
> +	i2c_wr32(sd, HSTXVREGCNT, pdata->hstxvregcnt);
> +
> +	i2c_wr32(sd, HSTXVREGEN,
> +			((lanes > 0) ? MASK_CLM_HSTXVREGEN : 0x0) |
> +			((lanes > 0) ? MASK_D0M_HSTXVREGEN : 0x0) |
> +			((lanes > 1) ? MASK_D1M_HSTXVREGEN : 0x0) |
> +			((lanes > 2) ? MASK_D2M_HSTXVREGEN : 0x0) |
> +			((lanes > 3) ? MASK_D3M_HSTXVREGEN : 0x0));
> +
> +	i2c_wr32(sd, TXOPTIONCNTRL, MASK_CONTCLKMODE);

Since anything below can't be undone without pulling CTXRST, I propose
to split tc358743_set_csi into tc358743_set_csi (above) and
tc358743_start_csi (below).

To make this driver work with the Synopsys DesignWare MIPI CSI-2 Host
Controller, there needs to be a time when the lanes are in stop state
first, so the host can synchronize. I'd then like to call start_csi in
s_stream only.

> +	i2c_wr32(sd, STARTCNTRL, MASK_START);
> +	i2c_wr32(sd, CSI_START, MASK_STRT);
> +
> +	i2c_wr32(sd, CSI_CONFW, MASK_MODE_SET |
> +			MASK_ADDRESS_CSI_CONTROL |
> +			MASK_CSI_MODE |
> +			MASK_TXHSMD |
> +			((lanes == 4) ? MASK_NOL_4 :
> +			 (lanes == 3) ? MASK_NOL_3 :
> +			 (lanes == 2) ? MASK_NOL_2 : MASK_NOL_1));
> +
> +	i2c_wr32(sd, CSI_CONFW, MASK_MODE_SET |
> +			MASK_ADDRESS_CSI_ERR_INTENA | MASK_TXBRK | MASK_QUNK |
> +			MASK_WCER | MASK_INER);
> +
> +	i2c_wr32(sd, CSI_CONFW, MASK_MODE_CLEAR |
> +			MASK_ADDRESS_CSI_ERR_HALT | MASK_TXBRK | MASK_QUNK);
> +
> +	i2c_wr32(sd, CSI_CONFW, MASK_MODE_SET |
> +			MASK_ADDRESS_CSI_INT_ENA | MASK_INTER);
> +}
[...]

regards
Philipp

