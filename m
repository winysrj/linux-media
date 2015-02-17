Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:63802 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbbBQPw6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 10:52:58 -0500
Message-ID: <54E363F8.5050608@cisco.com>
Date: Tue, 17 Feb 2015 16:53:28 +0100
From: "Mats Randgaard (matrandg)" <matrandg@cisco.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: linux-media@vger.kernel.org, hansverk@cisco.com
Subject: Re: [RFC v01] Driver for Toshiba TC358743 CSI-2 to HDMI bridge
References: <1418667661-21078-1-git-send-email-matrandg@cisco.com> <1424163029.3841.15.camel@pengutronix.de>
In-Reply-To: <1424163029.3841.15.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you again for testing this driver!
I am sorry I haven't had time to prepare a second RFC for this driver, 
but I will try to do that as soon as possible.

On 02/17/2015 09:50 AM, Philipp Zabel wrote:
> Hi Mats,
>
> Am Montag, den 15.12.2014, 19:21 +0100 schrieb matrandg@cisco.com:
> [...]
>> +static void tc358743_set_pll(struct v4l2_subdev *sd)
>> +{
>> +	struct tc358743_state *state = to_state(sd);
>> +	struct tc358743_platform_data *pdata = &state->pdata;
>> +	u16 pllctl0 = i2c_rd16(sd, PLLCTL0);
>> +	u16 pllctl0_new = SET_PLL_PRD(pdata->pll_prd) |
>> +		SET_PLL_FBD(pdata->pll_fbd);
>> +
>> +	v4l2_dbg(2, debug, sd, "%s:\n", __func__);
>> +
>> +	/* Only rewrite when needed, since rewriting triggers another format
>> +	 * change event. */
>> +	if (pllctl0 != pllctl0_new) {
>> +		u32 hsck = (pdata->refclk_hz * pdata->pll_prd) / pdata->pll_fbd;
> This is the wrong way around. refclk_hz is divided by pll_prd to get the
> PLL input clock. The PLL then multiplies by pll_fbd. Example:
>
> refclk_hz = 27000000, pll_prd = 4, pll_fbd = 88
> --> hsck = refclk_hz / pll_prd * pll_fbd = 594 MHz, pll_frs should be 0.

Yes, you are right, and there was a bug in SET_PLL_FRS() as well, so the 
bits where always set to zero. I will fix that!

> [...]
>> +static unsigned tc358743_num_csi_lanes_needed(struct v4l2_subdev *sd)
>> +{
>> +	struct tc358743_state *state = to_state(sd);
>> +	struct v4l2_bt_timings *bt = &state->timings.bt;
>> +	u32 bits_pr_pixel =
>> +		(state->mbus_fmt_code == MEDIA_BUS_FMT_UYVY8_1X16) ?  16 : 24;
>> +	u32 bps = bt->width * bt->height * fps(bt) * bits_pr_pixel;
> I think this calculation should include the blanking intervals.

As far as I understand is only the active video from the HDMI interface 
transferred on the CSI interface, so I think this calculation is 
correct. We transfer 1080p60 video on four lanes with 823.5 Mbps/lane, 
which would not have been possible if the blanking should have been 
transferred as well ((2200 * 1125 * 60 * 24) bps / 823.5 Mbps/lane  = 
4.33 lanes.

>> +static void tc358743_set_csi(struct v4l2_subdev *sd)
>> +{
>> +	struct tc358743_state *state = to_state(sd);
>> +	struct tc358743_platform_data *pdata = &state->pdata;
>> +	unsigned lanes = tc358743_num_csi_lanes_needed(sd);
>> +
>> +	v4l2_dbg(3, debug, sd, "%s:\n", __func__);
>> +
>> +	tc358743_reset(sd, MASK_CTXRST);
>> +
>> +	if (lanes < 1)
>> +		i2c_wr32(sd, CLW_CNTRL, MASK_CLW_LANEDISABLE);
>> +	if (lanes < 1)
>> +		i2c_wr32(sd, D0W_CNTRL, MASK_D0W_LANEDISABLE);
>> +	if (lanes < 2)
>> +		i2c_wr32(sd, D1W_CNTRL, MASK_D1W_LANEDISABLE);
>> +	if (lanes < 3)
>> +		i2c_wr32(sd, D2W_CNTRL, MASK_D2W_LANEDISABLE);
>> +	if (lanes < 4)
>> +		i2c_wr32(sd, D3W_CNTRL, MASK_D3W_LANEDISABLE);
>> +
>> +	i2c_wr32(sd, LINEINITCNT, pdata->lineinitcnt);
>> +	i2c_wr32(sd, LPTXTIMECNT, pdata->lptxtimecnt);
>> +	i2c_wr32(sd, TCLK_HEADERCNT, pdata->tclk_headercnt);
>> +	i2c_wr32(sd, THS_HEADERCNT, pdata->ths_headercnt);
>> +	i2c_wr32(sd, TWAKEUP, pdata->twakeup);
>> +	i2c_wr32(sd, THS_TRAILCNT, pdata->ths_trailcnt);
>> +	i2c_wr32(sd, HSTXVREGCNT, pdata->hstxvregcnt);
>> +
>> +	i2c_wr32(sd, HSTXVREGEN,
>> +			((lanes > 0) ? MASK_CLM_HSTXVREGEN : 0x0) |
>> +			((lanes > 0) ? MASK_D0M_HSTXVREGEN : 0x0) |
>> +			((lanes > 1) ? MASK_D1M_HSTXVREGEN : 0x0) |
>> +			((lanes > 2) ? MASK_D2M_HSTXVREGEN : 0x0) |
>> +			((lanes > 3) ? MASK_D3M_HSTXVREGEN : 0x0));
>> +
>> +	i2c_wr32(sd, TXOPTIONCNTRL, MASK_CONTCLKMODE);
> Since anything below can't be undone without pulling CTXRST, I propose
> to split tc358743_set_csi into tc358743_set_csi (above) and
> tc358743_start_csi (below).
>
> To make this driver work with the Synopsys DesignWare MIPI CSI-2 Host
> Controller, there needs to be a time when the lanes are in stop state
> first, so the host can synchronize. I'd then like to call start_csi in
> s_stream only.

With help from Toshiba we have now implemented start and stop of the CSI 
interface without pulling CTXRST. You can see our solution in the next 
RFC, and I would appreciate if you could test if that works fine for you 
as well!

Regards,
Mats Randgaard
