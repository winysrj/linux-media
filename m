Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59442 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751963AbcJWOJV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Oct 2016 10:09:21 -0400
Date: Sun, 23 Oct 2016 17:09:11 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, sre@kernel.org,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: v4.9-rc1: smiapp divides by zero
Message-ID: <20161023140911.GF9460@valkosipuli.retiisi.org.uk>
References: <1465659593-16858-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20161023073322.GA3523@amd>
 <20161023102213.GA13705@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161023102213.GA13705@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Sun, Oct 23, 2016 at 12:22:13PM +0200, Pavel Machek wrote:
> Hi!
> 
> I tried to update camera code on n900 to v4.9-rc1, and I'm getting
> some divide by zero, that eventually cascades into fcam-dev not
> working.
> 
> mul is zero in my testing, resulting in divide by zero.
> 
> (Note that this is going from my patched camera-v4.8 tree to
> camera-v4.9 tree.)
> 
> Best regards,
> 								Pavel
> 
> diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
> index 5ad1edb..e0a6edd 100644
> --- a/drivers/media/i2c/smiapp-pll.c
> +++ b/drivers/media/i2c/smiapp-pll.c
> @@ -16,6 +16,8 @@
>   * General Public License for more details.
>   */
>  
> +#define DEBUG
> +
>  #include <linux/device.h>
>  #include <linux/gcd.h>
>  #include <linux/lcm.h>
> @@ -457,6 +459,10 @@ int smiapp_pll_calculate(struct device *dev,
>  	i = gcd(pll->pll_op_clk_freq_hz, pll->ext_clk_freq_hz);
>  	mul = div_u64(pll->pll_op_clk_freq_hz, i);
>  	div = pll->ext_clk_freq_hz / i;
> +	if (!mul) {

Something must be very wrong if you get here.

What are the values of pll->pll_op_clk_freq_hz and pll->ext_clk_freq_hz?
Or... what does dmesg say?

> +		dev_err(dev, "forcing mul to 1\n");
> +		mul = 1;
> +	}
>  	dev_dbg(dev, "mul %u / div %u\n", mul, div);
>  
>  	min_pre_pll_clk_div =
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
