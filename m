Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45904 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751680AbdHAOGY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Aug 2017 10:06:24 -0400
Subject: Re: [PATCH v2 13/14] drm: rcar-du: Restrict DPLL duty cycle
 workaround to H3 ES1.x
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
 <20170626181226.29575-14-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reply-To: kieran.bingham@ideasonboard.com
Message-ID: <8f72d427-4a7c-29ee-2492-d3a99449dfb8@ideasonboard.com>
Date: Tue, 1 Aug 2017 15:06:20 +0100
MIME-Version: 1.0
In-Reply-To: <20170626181226.29575-14-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 26/06/17 19:12, Laurent Pinchart wrote:
> The H3 ES1.x exhibits dot clock duty cycle stability issues. We can work
> around them by configuring the DPLL to twice the desired frequency,
> coupled with a /2 post-divider. This isn't needed on other SoCs and
> breaks HDMI output on M3-W for a currently unknown reason, so restrict
> the workaround to H3 ES1.x.
> 
> From an implementation point of view, move work around handling outside
> of the rcar_du_dpll_divider() function by requesting a x2 DPLL output
> frequency explicitly. The existing post-divider calculation mechanism
> will then take care of dividing the clock by two automatically.
> 
> While at it, print a more useful debugging message to ease debugging
> clock rate issues.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.c | 37 +++++++++++++++++++++++++---------
>  1 file changed, 27 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> index 8f942ebdd0c6..6c29981377c0 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> @@ -13,6 +13,7 @@
>  
>  #include <linux/clk.h>
>  #include <linux/mutex.h>
> +#include <linux/sys_soc.h>
>  
>  #include <drm/drmP.h>
>  #include <drm/drm_atomic.h>
> @@ -129,10 +130,8 @@ static void rcar_du_dpll_divider(struct rcar_du_crtc *rcrtc,
>  			for (fdpll = 1; fdpll < 32; fdpll++) {
>  				unsigned long output;
>  
> -				/* 1/2 (FRQSEL=1) for duty rate 50% */
>  				output = input * (n + 1) / (m + 1)
> -				       / (fdpll + 1) / 2;
> -
> +				       / (fdpll + 1);

I'm finding this hard to interpret vs the commit-message.

Here we remove the /2 (which affects all targets... is this a problem?)

>  				if (output >= 400000000)
>  					continue;
>  
> @@ -158,6 +157,11 @@ static void rcar_du_dpll_divider(struct rcar_du_crtc *rcrtc,
>  		 best_diff);
>  }
>  
> +static const struct soc_device_attribute rcar_du_r8a7795_es1[] = {
> +	{ .soc_id = "r8a7795", .revision = "ES1.*" },
> +	{ /* sentinel */ }
> +};
> +
>  static void rcar_du_crtc_set_display_timing(struct rcar_du_crtc *rcrtc)
>  {
>  	const struct drm_display_mode *mode = &rcrtc->crtc.state->adjusted_mode;
> @@ -185,7 +189,20 @@ static void rcar_du_crtc_set_display_timing(struct rcar_du_crtc *rcrtc)
>  
>  		extclk = clk_get_rate(rcrtc->extclock);
>  		if (rcdu->info->dpll_ch & (1 << rcrtc->index)) {
> -			rcar_du_dpll_divider(rcrtc, &dpll, extclk, mode_clock);
> +			unsigned long target = mode_clock;
> +
> +			/*
> +			 * The H3 ES1.x exhibits dot clock duty cycle stability
> +			 * issues. We can work around them by configuring the
> +			 * DPLL to twice the desired frequency, coupled with a
> +			 * /2 post-divider. This isn't needed on other SoCs and

But here we discuss 'coupling' it with a /2 post - divider.

My inference here then is that by setting a target that is 'twice' the value -
code later will provide the /2 post-divide?

> +			 * breaks HDMI output on M3-W for a currently unknown
> +			 * reason, so restrict the workaround to H3 ES1.x.
> +			 */
> +			if (soc_device_match(rcar_du_r8a7795_es1))
> +				target *= 2;
> +
> +			rcar_du_dpll_divider(rcrtc, &dpll, extclk, target);
>  			extclk = dpll.output;
>  		}
>  
> @@ -197,8 +214,6 @@ static void rcar_du_crtc_set_display_timing(struct rcar_du_crtc *rcrtc)
>  
>  		if (abs((long)extrate - (long)mode_clock) <
>  		    abs((long)rate - (long)mode_clock)) {
> -			dev_dbg(rcrtc->group->dev->dev,
> -				"crtc%u: using external clock\n", rcrtc->index);
>  
>  			if (rcdu->info->dpll_ch & (1 << rcrtc->index)) {
>  				u32 dpllcr = DPLLCR_CODE | DPLLCR_CLKE
> @@ -215,12 +230,14 @@ static void rcar_du_crtc_set_display_timing(struct rcar_du_crtc *rcrtc)
>  
>  				rcar_du_group_write(rcrtc->group, DPLLCR,
>  						    dpllcr);
> -
> -				escr = ESCR_DCLKSEL_DCLKIN | 1;
> -			} else {
> -				escr = ESCR_DCLKSEL_DCLKIN | extdiv;
>  			}
> +
> +			escr = ESCR_DCLKSEL_DCLKIN | extdiv;

Therefore - is this the post-divider?

If my inferences are correct - then OK:

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

--
KB

>  		}
> +
> +		dev_dbg(rcrtc->group->dev->dev,
> +			"mode clock %lu extrate %lu rate %lu ESCR 0x%08x\n",
> +			mode_clock, extrate, rate, escr);
>  	}
>  
>  	rcar_du_group_write(rcrtc->group, rcrtc->index % 2 ? ESCR2 : ESCR,
> 
