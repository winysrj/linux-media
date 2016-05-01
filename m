Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35300 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751083AbcEAKp6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 1 May 2016 06:45:58 -0400
Date: Sun, 1 May 2016 13:45:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 04/24] smiapp-pll: Take existing divisor into account
 in minimum divisor check
Message-ID: <20160501104524.GD26360@valkosipuli.retiisi.org.uk>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1461532104-24032-5-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1461532104-24032-5-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ivaylo,

On Mon, Apr 25, 2016 at 12:08:04AM +0300, Ivaylo Dimitrov wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> Required added multiplier (and divisor) calculation did not take into
> account the existing divisor when checking the values against the minimum
> divisor. Do just that.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/i2c/smiapp-pll.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
> index e3348db..5ad1edb 100644
> --- a/drivers/media/i2c/smiapp-pll.c
> +++ b/drivers/media/i2c/smiapp-pll.c
> @@ -227,7 +227,8 @@ static int __smiapp_pll_calculate(
>  
>  	more_mul_factor = lcm(div, pll->pre_pll_clk_div) / div;
>  	dev_dbg(dev, "more_mul_factor: %u\n", more_mul_factor);
> -	more_mul_factor = lcm(more_mul_factor, op_limits->min_sys_clk_div);
> +	more_mul_factor = lcm(more_mul_factor,
> +			      DIV_ROUND_UP(op_limits->min_sys_clk_div, div));
>  	dev_dbg(dev, "more_mul_factor: min_op_sys_clk_div: %d\n",
>  		more_mul_factor);
>  	i = roundup(more_mul_min, more_mul_factor);

I remember writing the patch, but I don't remember what for, or whether it
was really needed. Does the secondary sensor work without this one?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
