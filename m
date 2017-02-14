Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58843 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752125AbdBNWNl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 17:13:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Pavel Machek <pavel@ucw.cz>, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: [RFC 08/13] smiapp-pll: Take existing divisor into account in minimum divisor check
Date: Wed, 15 Feb 2017 00:14:08 +0200
Message-ID: <2278259.j1SsZdfySc@avalon>
In-Reply-To: <20170214220503.GO16975@valkosipuli.retiisi.org.uk>
References: <20170214134004.GA8570@amd> <20170214220503.GO16975@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wednesday 15 Feb 2017 00:05:03 Sakari Ailus wrote:
> On Tue, Feb 14, 2017 at 02:40:04PM +0100, Pavel Machek wrote:
> > From: Sakari Ailus <sakari.ailus@iki.fi>
> > 
> > Required added multiplier (and divisor) calculation did not take into
> > account the existing divisor when checking the values against the
> > minimum divisor. Do just that.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> I need to understand again why did I write this patch. :-)

I was about to mention that a more detailed commit message (or possibly event 
comments in the source code) would be good :-)

> Could you send me the smiapp driver output with debug level messages
> enabled, please?
> 
> I think the problem was with the secondary sensor.
>
> > diff --git a/drivers/media/i2c/smiapp-pll.c
> > b/drivers/media/i2c/smiapp-pll.c
> > index 771db56..166bbaf 100644
> > --- a/drivers/media/i2c/smiapp-pll.c
> > +++ b/drivers/media/i2c/smiapp-pll.c
> > @@ -16,6 +16,8 @@
> >   * General Public License for more details.
> >   */
> > 
> > +#define DEBUG
> > +

This should be removed.

> >  #include <linux/device.h>
> >  #include <linux/gcd.h>
> >  #include <linux/lcm.h>
> > @@ -227,7 +229,8 @@ static int __smiapp_pll_calculate(
> >  	more_mul_factor = lcm(div, pll->pre_pll_clk_div) / div;
> >  	dev_dbg(dev, "more_mul_factor: %u\n", more_mul_factor);
> > 
> > -	more_mul_factor = lcm(more_mul_factor, op_limits->min_sys_clk_div);
> > +	more_mul_factor = lcm(more_mul_factor,
> > +			      DIV_ROUND_UP(op_limits->min_sys_clk_div, div));
> >  	dev_dbg(dev, "more_mul_factor: min_op_sys_clk_div: %d\n",
> >  		more_mul_factor);
> >  	i = roundup(more_mul_min, more_mul_factor);
> > @@ -456,6 +459,10 @@ int smiapp_pll_calculate(struct device *dev,
> >  	i = gcd(pll->pll_op_clk_freq_hz, pll->ext_clk_freq_hz);
> >  	mul = div_u64(pll->pll_op_clk_freq_hz, i);
> >  	div = pll->ext_clk_freq_hz / i;
> > +	if (!mul) {
> > +		dev_err(dev, "forcing mul to 1\n");
> > +		mul = 1;
> > +	}
> >  	dev_dbg(dev, "mul %u / div %u\n", mul, div);
> >  	
> >  	min_pre_pll_clk_div =
-- 
Regards,

Laurent Pinchart
