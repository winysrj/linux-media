Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:25048 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbbEDON6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 10:13:58 -0400
Received: from [10.47.76.63] ([10.47.76.63])
	by aer-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id t44EDvk7013751
	for <linux-media@vger.kernel.org>; Mon, 4 May 2015 14:13:57 GMT
Message-ID: <55477EA5.5070006@cisco.com>
Date: Mon, 04 May 2015 16:13:57 +0200
From: "Mats Randgaard (matrandg)" <matrandg@cisco.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [RFC 04/12] [media] tc358743: fix set_pll to enable PLL with
 default frequency
References: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de> <1427713856-10240-5-git-send-email-p.zabel@pengutronix.de> <55477DAE.5040408@cisco.com>
In-Reply-To: <55477DAE.5040408@cisco.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/30/2015 01:10 PM, Philipp Zabel wrote:
 > set_pll not only skips PLL changes but also doesn't enable it in
 > the first place if the rate is the same as the default values.
 >
 > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de> ---
 > drivers/media/i2c/tc358743.c | 5 +++-- 1 file changed, 3
 > insertions(+), 2 deletions(-)
 >
 > diff --git a/drivers/media/i2c/tc358743.c
 > b/drivers/media/i2c/tc358743.c index 85a0f7a..dd2ea16 100644 ---
 > a/drivers/media/i2c/tc358743.c +++ b/drivers/media/i2c/tc358743.c
 > @@ -606,6 +606,7 @@ static void tc358743_set_pll(struct v4l2_subdev
 > *sd) struct tc358743_state *state = to_state(sd); struct
 > tc358743_platform_data *pdata = &state->pdata; u16 pllctl0 =
 > i2c_rd16(sd, PLLCTL0); +    u16 pllctl1 = i2c_rd16(sd, PLLCTL1);
 > u16 pllctl0_new = SET_PLL_PRD(pdata->pll_prd) |
 > SET_PLL_FBD(pdata->pll_fbd);
 >
 > @@ -613,8 +614,8 @@ static void tc358743_set_pll(struct
 > v4l2_subdev *sd)
 >
 > /* Only rewrite when needed, since rewriting triggers another
 > format * change event. */ -    if (pllctl0 != pllctl0_new) { -
 > u32 hsck = (pdata->refclk_hz * pdata->pll_prd) / pdata->pll_fbd; +
 > if ((pllctl0 != pllctl0_new) || ((pllctl1 & MASK_PLL_EN) == 0)) { +
 > u32 hsck = (pdata->refclk_hz * pdata->pll_fbd) / pdata->pll_prd;

Yes, that is a bug that should be fixed!

The calculation of hsck is fixed in the latest version of the
driver.

Regards,

Mats Randgaard

