Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:35989 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab2CHOtE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2012 09:49:04 -0500
Date: Thu, 8 Mar 2012 16:48:58 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5.1 34/35] smiapp: Generic SMIA++/SMIA PLL calculator
Message-ID: <20120308144858.GC1591@valkosipuli.localdomain>
References: <1960253.l1xo097dr7@avalon>
 <1331215050-20823-1-git-send-email-sakari.ailus@iki.fi>
 <2338182.m4p3vRkuCF@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2338182.m4p3vRkuCF@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, Mar 08, 2012 at 03:38:45PM +0100, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thanks for the patch.
> 
> On Thursday 08 March 2012 15:57:29 Sakari Ailus wrote:
> > From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> > 
> > Calculate PLL configuration based on input data: sensor configuration, board
> > properties and sensor-specific limits.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> 
> [snip]
> 
> > diff --git a/drivers/media/video/smiapp-pll.c
> > b/drivers/media/video/smiapp-pll.c new file mode 100644
> > index 0000000..c8ffdc9
> > --- /dev/null
> > +++ b/drivers/media/video/smiapp-pll.c
> 
> [snip]
> 
> > +	/*
> > +	 * Find pix_div such that a legal pix_div * sys_div results
> > +	 * into a value which is not smaller than div, the desired
> > +	 * divisor.
> > +	 */
> > +	for (vt_div = min_vt_div; vt_div <= max_vt_div;
> > +	     vt_div += 2 - (vt_div & 1)) {
> > +		for (sys_div = min_sys_div;
> > +		     sys_div <= max_sys_div;
> > +		     sys_div += 2 - (sys_div & 1)) {
> > +			int pix_div = DIV_ROUND_UP(vt_div, sys_div);
> > +
> > +			if (pix_div <
> > +			    limits->min_vt_pix_clk_div
> > +			    || pix_div
> > +			    > limits->max_vt_pix_clk_div) {
> 
> Maybe you should get some sleep, I've heard it helps memory ;-)

Oh. That's what it was. I didn't find it the first time. Sorry about that.

I'll send a new version where that has been fixed.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
