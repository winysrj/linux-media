Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59042 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab2CDKOL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Mar 2012 05:14:11 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
	Martin Hostettler <martin@neutronstar.dyndns.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v3 09/10] v4l: Aptina-style sensor PLL support
Date: Sun, 04 Mar 2012 11:14:23 +0100
Message-ID: <2059444.5Gn7cyLNBL@avalon>
In-Reply-To: <20120303223707.GJ15695@valkosipuli.localdomain>
References: <1330788495-18762-1-git-send-email-laurent.pinchart@ideasonboard.com> <1330788495-18762-10-git-send-email-laurent.pinchart@ideasonboard.com> <20120303223707.GJ15695@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sunday 04 March 2012 00:37:07 Sakari Ailus wrote:
> On Sat, Mar 03, 2012 at 04:28:14PM +0100, Laurent Pinchart wrote:
> > Add a generic helper function to compute PLL parameters for PLL found in
> > several Aptina sensors.

[snip]

> > diff --git a/drivers/media/video/aptina-pll.c
> > b/drivers/media/video/aptina-pll.c new file mode 100644
> > index 0000000..55e4a40
> > --- /dev/null
> > +++ b/drivers/media/video/aptina-pll.c

[snip]

> > +int aptina_pll_configure(struct device *dev, struct aptina_pll *pll,
> > +			 const struct aptina_pll_limits *limits)
> 
> I've done the same to the SMIA++ PLL: it can be used separately from the
> driver now; it'll be part of the next patchset.
> 
> Do you think it could make sense to swap pll and limits parameters?

Why ? :-)

> I call the function smiapp_pll_calculate().

I've renamed the function to aptina_pll_calculate().

> > +{
> > +	unsigned int mf_min;
> > +	unsigned int mf_max;
> > +	unsigned int p1_min;
> > +	unsigned int p1_max;
> > +	unsigned int p1;
> > +	unsigned int div;
> > +
> > +	if (pll->ext_clock < limits->ext_clock_min ||
> > +	    pll->ext_clock > limits->ext_clock_max) {
> > +		dev_err(dev, "pll: invalid external clock frequency.\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (pll->pix_clock > limits->pix_clock_max) {
> > +		dev_err(dev, "pll: invalid pixel clock frequency.\n");
> > +		return -EINVAL;
> > +	}
> 
> You could check that pix_clock isn't zero.

OK.

[snip]

> > +	for (p1 = p1_max & ~1; p1 >= p1_min; p1 -= 2) {
> > +		unsigned int mf_inc = lcm(div, p1) / div;
> 
> I think you could avoid division by using p1 * gcd(div, p1) instead.

That's not the same. lcm(div, p1) / div == p1 / gcd(div, p1). There's still a 
division, but it's slightly better, so I'll use that.

> > +		unsigned int mf_high;
> > +		unsigned int mf_low;
> > +
> > +		mf_low = max(roundup(mf_min, mf_inc),
> > +			     DIV_ROUND_UP(pll->ext_clock * p1,
> > +			       limits->int_clock_max * div));
> > +		mf_high = min(mf_max, pll->ext_clock * p1 /
> > +			      (limits->int_clock_min * div));
> > +
> > +		if (mf_low <= mf_high) {
> > +			pll->n = div * mf_low / p1;
> > +			pll->m *= mf_low;
> > +			pll->p1 = p1;
> > +			break;
> 
> You could return already here.

OK.

> > +		}
> > +	}
> > +
> > +	if (p1 < p1_min) {
> > +		dev_err(dev, "pll: no valid N and P1 divisors found.\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	dev_dbg(dev, "PLL: ext clock %u N %u M %u P1 %u pix clock %u\n",
> > +		 pll->ext_clock, pll->n, pll->m, pll->p1, pll->pix_clock);
> > +
> > +	return 0;
> > +}

-- 
Regards,

Laurent Pinchart

