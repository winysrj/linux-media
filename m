Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56814 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab2CDKUS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Mar 2012 05:20:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org,
	Martin Hostettler <martin@neutronstar.dyndns.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v3 09/10] v4l: Aptina-style sensor PLL support
Date: Sun, 04 Mar 2012 11:20:36 +0100
Message-ID: <2542282.M9tkDiKfKT@avalon>
In-Reply-To: <1330796111.4195.10.camel@palomino.walls.org>
References: <1330788495-18762-1-git-send-email-laurent.pinchart@ideasonboard.com> <1330788495-18762-10-git-send-email-laurent.pinchart@ideasonboard.com> <1330796111.4195.10.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Thanks for the review.

On Saturday 03 March 2012 12:35:09 Andy Walls wrote:
> On Sat, 2012-03-03 at 16:28 +0100, Laurent Pinchart wrote:
> > Add a generic helper function to compute PLL parameters for PLL found in
> > several Aptina sensors.

[snip]

> > +int aptina_pll_configure(struct device *dev, struct aptina_pll *pll,
> > +			 const struct aptina_pll_limits *limits)
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
> > +
> > +	/* Compute the multiplier M and combined N*P1 divisor. */
> > +	div = gcd(pll->pix_clock, pll->ext_clock);
> > +	pll->m = pll->pix_clock / div;
> > +	div = pll->ext_clock / div;
> > +
> > +	/* We now have the smallest M and N*P1 values that will result in the
> > +	 * desired pixel clock frequency, but they might be out of the valid
> > +	 * range. Compute the factor by which we should multiply them given
> > +	 * the following constraints:
> > +	 *
> > +	 * - minimum/maximum multiplier
> > +	 * - minimum/maximum multiplier output clock frequency assuming the
> > +	 *   minimum/maximum N value
> > +	 * - minimum/maximum combined N*P1 divisor
> > +	 */
> > +	mf_min = DIV_ROUND_UP(limits->m_min, pll->m);
> > +	mf_min = max(mf_min, limits->out_clock_min /
> > +		     (pll->ext_clock / limits->n_min * pll->m));
> > +	mf_min = max(mf_min, limits->n_min * limits->p1_min / div);
> > +	mf_max = limits->m_max / pll->m;
> > +	mf_max = min(mf_max, limits->out_clock_max /
> > +		    (pll->ext_clock / limits->n_max * pll->m));
> > +	mf_max = min(mf_max, DIV_ROUND_UP(limits->n_max * limits->p1_max, 
div));
> > +
> > +	dev_dbg(dev, "pll: mf min %u max %u\n", mf_min, mf_max);
> > +	if (mf_min > mf_max) {
> > +		dev_err(dev, "pll: no valid combined N*P1 divisor.\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	/*
> > +	 * We're looking for the highest acceptable P1 value
> 
> Why the *highest* acceptable post-divide (P1) value?

According to the Aptina datasheets, "it is desirable to keep (fEXTCLK / n) as 
large as possible within the limits".

> > for which a
> > +	 * multiplier factor MF exists that fulfills the following 
conditions:
> > +	 *
> > +	 * 1. p1 is in the [p1_min, p1_max] range given by the limits and is
> > +	 *    even
> > +	 * 2. mf is in the [mf_min, mf_max] range computed above
> > +	 * 3. div * mf is a multiple of p1, in order to compute
> > +	 *	n = div * mf / p1
> > +	 *	m = pll->m * mf
> > +	 * 4. the internal clock frequency, given by ext_clock / n, is in the
> > +	 *    [int_clock_min, int_clock_max] range given by the limits
> > +	 * 5. the output clock frequency, given by ext_clock / n * m, is in 
the
> > +	 *    [out_clock_min, out_clock_max] range given by the limits
> > +	 *
> 
> So just to make your constrained optimzation problem even more complex:
> 
> I would imagine you would get faster PLL lock and less phase noise by
> having the VCO operate near its center frequency.
> 
> If you think that is a sensible constraint, then that translates to
> having the PLL output before post-divide (i.e. ext_clock / n * m), to be
> as close as possible to the center frequency of the VCO (i.e.
> (out_clock_max - out_clock_min) / 2 ).

Good point. But... *ouch* :-)

Do you think it's worth it ?

-- 
Regards,

Laurent Pinchart

