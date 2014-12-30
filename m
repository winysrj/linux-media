Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34159 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbaL3I6W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Dec 2014 03:58:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Josh Wu <josh.wu@atmel.com>, linux-media@vger.kernel.org,
	m.chehab@samsung.com, linux-arm-kernel@lists.infradead.org,
	s.nawrocki@samsung.com, festevam@gmail.com,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: Re: [PATCH v4 2/5] media: ov2640: add async probe function
Date: Tue, 30 Dec 2014 10:58:02 +0200
Message-ID: <4898423.Jl8IWzpt6k@avalon>
In-Reply-To: <alpine.DEB.2.00.1412300927380.8237@axis700.grange>
References: <1418869646-17071-1-git-send-email-josh.wu@atmel.com> <2421077.hZ7S0HT2At@avalon> <alpine.DEB.2.00.1412300927380.8237@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tuesday 30 December 2014 09:36:31 Guennadi Liakhovetski wrote:
> Hi Laurent,
> 
> First of all, sorry, I am currently on a holiday, so, replies are delayed,
> real work (reviewing or anything else) is impossible.

Sure, no worries. Enjoy your holidays without thinking too much about soc-
camera :-)

> On Tue, 30 Dec 2014, Laurent Pinchart wrote:
> > On Friday 26 December 2014 11:38:11 Guennadi Liakhovetski wrote:
> >> On Fri, 26 Dec 2014, Laurent Pinchart wrote:
> >>> On Friday 26 December 2014 10:14:26 Guennadi Liakhovetski wrote:
> >>>> On Fri, 26 Dec 2014, Laurent Pinchart wrote:
> >>>>> On Friday 26 December 2014 14:37:14 Josh Wu wrote:
> >
> > [snip]
> > 
> >>>>> Talking about mclk and xvclk is quite confusing. There's no mclk
> >>>>> from an ov2640 point of view. The ov2640 driver should call
> >>>>> v4l2_clk_get("xvclk").
> >>>> 
> >>>> Yes, I also was thinking about this, and yes, requesting a "xvclk"
> >>>> clock would be more logical. But then, as you write below, if we let
> >>>> the v4l2_clk wrapper first check for a CCF "xvclk" clock, say, none is
> >>>> found. How do we then find the exported "mclk" V4L2 clock? Maybe
> >>>> v4l2_clk_get() should use two names?..
> >>> 
> >>> Given that v4l2_clk_get() is only used by soc-camera drivers and that
> >>> they all call it with the clock name set to "mclk", I wonder whether we
> >>> couldn't just get rid of struct v4l2_clk.id and ignore the id argument
> >>> to v4l2_clk_get() when CCF isn't available. Maybe we've overdesigned
> >>> v4l2_clk :-)
> >> 
> >> Sure, that'd be fine with me, if everyone else agrees.
> > 
> > Can you submit a patch ? That's the best way to find out if anyone
> > objects.
> 
> Can do, sure, once I am back home and find time for this.
> 
> > [snip]
> > 
> >>>>> v4l2_clk_get() should try to get the clock from CCF with a call to
> >>>>> clk_get() first, and then look at the list of v4l2-specific clocks.
> >>>> 
> >>>> Yes, how will it find the "mclk" when "xvclk" (or any other name) is
> >>>> requested? We did discuss this in the beginning and agreed to use a
> >>>> fixed clock name for the time being...
> >>> 
> >>> Please see above.
> >>> 
> >>>>> That's at least how I had envisioned it when v4l2_clk_get() was
> >>>>> introduced. Let's remember that v4l2_clk was designed as a temporary
> >>>>> workaround for platforms not implementing CCF yet. Is that still
> >>>>> needed, or could be instead just get rid of it now ?
> >>>> 
> >>>> I didn't check, but I don't think all platforms, handled by
> >>>> soc-camera, support CCF yet.
> >>> 
> >>> After a quick check it looks like only OMAP1 and SH Mobile are
> >>> missing. Atmel, MX2, MX3 and R-Car all support CCF. PXA27x has CCF
> >>> support but doesn't enable it yet for an unknown (to me) reason.

On a side note, patches to enable CCF for PXA27x have been posted, they should 
be merged in v3.20.

> >>> The CEU driver is used on both arch/sh and arch/arm/mach-shmobile. The
> >>> former will most likely never receive CCF support, and the latter is
> >>> getting fixed. As arch/sh isn't maintained anymore I would be fine
> >>> with dropping CEU support for it.
> >>> 
> >>> OMAP1 is thus the only long-term show-stopper. What should we do with
> >>> it ?
> >> 
> >> Indeed, what should we? :)
> > 
> > You're listed as the soc-camera maintainer, so you should provide an
> > answer to that question :-)
> 
> Thanks for ar reminder;)
> 
> > I'll propose one, let's drop the omap1-camera driver (I've
> > CC'ed the original author of the driver to this e-mail).
> 
> Let's see what they reply, but I don't tgink Josh will want to wait that
> long. And until omap1 is in the mainline we cannot drop v4l2_clk.

Agreed, this was more of a question for the next step.

-- 
Regards,

Laurent Pinchart

