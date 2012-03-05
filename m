Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:54376 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228Ab2CECjW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Mar 2012 21:39:22 -0500
Subject: Re: [PATCH v3 09/10] v4l: Aptina-style sensor PLL support
From: Andy Walls <awalls@md.metrocast.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Martin Hostettler <martin@neutronstar.dyndns.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>
Date: Sun, 04 Mar 2012 21:38:54 -0500
In-Reply-To: <2542282.M9tkDiKfKT@avalon>
References: <1330788495-18762-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <1330788495-18762-10-git-send-email-laurent.pinchart@ideasonboard.com>
	 <1330796111.4195.10.camel@palomino.walls.org> <2542282.M9tkDiKfKT@avalon>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1330915138.13686.102.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2012-03-04 at 11:20 +0100, Laurent Pinchart wrote:
> Hi Andy,
> 
> Thanks for the review.
> 
> On Saturday 03 March 2012 12:35:09 Andy Walls wrote:
> > On Sat, 2012-03-03 at 16:28 +0100, Laurent Pinchart wrote:
> > > Add a generic helper function to compute PLL parameters for PLL found in
> > > several Aptina sensors.
> 
> [snip]
> 
> > > +int aptina_pll_configure(struct device *dev, struct aptina_pll *pll,
> > > +			 const struct aptina_pll_limits *limits)
> > > +{
> > > +	unsigned int mf_min;
> > > +	unsigned int mf_max;
> > > +	unsigned int p1_min;
> > > +	unsigned int p1_max;
> > > +	unsigned int p1;
> > > +	unsigned int div;
> > > +
> > > +	if (pll->ext_clock < limits->ext_clock_min ||
> > > +	    pll->ext_clock > limits->ext_clock_max) {
> > > +		dev_err(dev, "pll: invalid external clock frequency.\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	if (pll->pix_clock > limits->pix_clock_max) {
> > > +		dev_err(dev, "pll: invalid pixel clock frequency.\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	/* Compute the multiplier M and combined N*P1 divisor. */
> > > +	div = gcd(pll->pix_clock, pll->ext_clock);
> > > +	pll->m = pll->pix_clock / div;
> > > +	div = pll->ext_clock / div;
> > > +
> > > +	/* We now have the smallest M and N*P1 values that will result in the
> > > +	 * desired pixel clock frequency, but they might be out of the valid
> > > +	 * range. Compute the factor by which we should multiply them given
> > > +	 * the following constraints:
> > > +	 *
> > > +	 * - minimum/maximum multiplier
> > > +	 * - minimum/maximum multiplier output clock frequency assuming the
> > > +	 *   minimum/maximum N value
> > > +	 * - minimum/maximum combined N*P1 divisor
> > > +	 */
> > > +	mf_min = DIV_ROUND_UP(limits->m_min, pll->m);
> > > +	mf_min = max(mf_min, limits->out_clock_min /
> > > +		     (pll->ext_clock / limits->n_min * pll->m));
> > > +	mf_min = max(mf_min, limits->n_min * limits->p1_min / div);
> > > +	mf_max = limits->m_max / pll->m;
> > > +	mf_max = min(mf_max, limits->out_clock_max /
> > > +		    (pll->ext_clock / limits->n_max * pll->m));
> > > +	mf_max = min(mf_max, DIV_ROUND_UP(limits->n_max * limits->p1_max, 
> div));
> > > +
> > > +	dev_dbg(dev, "pll: mf min %u max %u\n", mf_min, mf_max);
> > > +	if (mf_min > mf_max) {
> > > +		dev_err(dev, "pll: no valid combined N*P1 divisor.\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	/*
> > > +	 * We're looking for the highest acceptable P1 value
> > 
> > Why the *highest* acceptable post-divide (P1) value?
> 
> According to the Aptina datasheets, "it is desirable to keep (fEXTCLK / n) as 
> large as possible within the limits".

OK.  I'm looking ath the MT9P031 datasheet now.

The PLL implemented looks like a Classical Digital PLL (DPLL) with
- a Phase/Frequency Detector (PFD) phase detector
- a prescaler (divide by n) of the external reference (ext_clock) in
front of of the PFD
- a post-divider (divide by p1) for dividing the VCO's operating
frequency down (out_clock) for use as an output
- a divider in the feedback loop to multiply (by m) the locked operating
frequency of the VCO compared to the prescaled ext_clock (ext_clock/n)


Aptina's recommendation to keep ext_clock/n as large as possible for
best performance makes sense intuitively: more frequent phase error
measurements probably leads to better phase tracking.  


Since
	pix_clock = ext_clock / n * m / p1
 
I guess the objective is really to minimize m/p1 in order to meet the
recommendation.

> > for which a
> > > +	 * multiplier factor MF exists that fulfills the following 
> conditions:
> > > +	 *
> > > +	 * 1. p1 is in the [p1_min, p1_max] range given by the limits and is
> > > +	 *    even
> > > +	 * 2. mf is in the [mf_min, mf_max] range computed above
> > > +	 * 3. div * mf is a multiple of p1, in order to compute
> > > +	 *	n = div * mf / p1
> > > +	 *	m = pll->m * mf
> > > +	 * 4. the internal clock frequency, given by ext_clock / n, is in the
> > > +	 *    [int_clock_min, int_clock_max] range given by the limits
> > > +	 * 5. the output clock frequency, given by ext_clock / n * m, is in 
> the
> > > +	 *    [out_clock_min, out_clock_max] range given by the limits
> > > +	 *
> > 
> > So just to make your constrained optimzation problem even more complex:
> > 
> > I would imagine you would get faster PLL lock and less phase noise by
> > having the VCO operate near its center frequency.
> > 
> > If you think that is a sensible constraint, then that translates to
> > having the PLL output before post-divide (i.e. ext_clock / n * m), to be
> > as close as possible to the center frequency of the VCO (i.e.
> > (out_clock_max - out_clock_min) / 2 ).
> 
> Good point. But... *ouch* :-)

Sorry.  However, upon more research and reflection, I'll revise my
suggestion to be: set m as close as possible to m_mean =
sqrt(m_min*m_max), as that may be optimal for the PLL's operation.  (See
below).

> Do you think it's worth it ?

Well, that depends on the chip design details, but I'm guessing the
answer is "No". ;)

For frequency synthesis, one normally doesn't worry much about phase
noise, unless clock jitter will somehow adversely affect the results of
the processing downstream.

For frequency sythesis, one normally does care about DPLL response to
changes in the external frequency or the programmed frequency, in order
to quickly lock-in or pull-in to a change.  That may not matter for this
sensor, if the DPLL and external clock are only set up at startup, or
very infrequently.


Above I suggested you might try to pick m as close to m_mean =
sqrt(m_min * m_max) as practical.  In the absence of detailed design
information, I will guess that is where the DPLL's dynamic response is
"optimal".  

The damping factor, zeta, of the phase transfer function of the PLL, is
inversely proportional to 1/sqrt(m).  So zeta_min = k/sqrt(m_max) and
zeta_max = k/sqrt(m_min).  A DPLL with zeta == 1 is critically damped.
As zeta becomes < 1, the transient response of the PLL to a change
becomes increasingly oscillatory.  As zeta grows > 1, the response of
the PLL to a change becomes increasingly overdamped (sluggish).

A zeta = 1/sqrt(2) ~= 0.7071 provides an optimally flat, phase transfer
function response for the PLL.  (According to the textbook "Phase-Locked
Loops: Theory, Design, and Applications, Second Edition" by Roland E.
Best, 1993).  I will simply guess that the DPLLs in the Aptina devices
were designed with zeta_mean = k/sqrt(m_mean) = 0.7071.

For the MT9P031, m can range from [16, 256), so m_mean = 64. Assuming
zeta_mean = 0.7071, then zeta_min = 0.3536 and zeta_max = 1.414.

>From here, one could go on, making some assumptions about the data in
the Aptina datasheet and compute the lock-range of the PLL.  The
lock-range is the range of frequencies around the VCO center freq where
the PLL will lock to the reference freq within the time of 1 beat note
between ext_clock/n and out_clock (i.e. very fast).  Note that the
lock-range around the VCO center frequency increases proportionally to
1/m.

Anyway, I've rambled enough.

Regards,
Andy

