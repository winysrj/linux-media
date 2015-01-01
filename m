Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36181 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbbAARoI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Jan 2015 12:44:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Josh Wu <josh.wu@atmel.com>, linux-media@vger.kernel.org,
	m.chehab@samsung.com, linux-arm-kernel@lists.infradead.org,
	s.nawrocki@samsung.com, festevam@gmail.com,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: Re: [PATCH v4 2/5] media: ov2640: add async probe function
Date: Thu, 01 Jan 2015 19:44:18 +0200
Message-ID: <59175204.C2PYysBhu5@avalon>
In-Reply-To: <alpine.DEB.2.00.1412301308070.9569@axis700.grange>
References: <1418869646-17071-1-git-send-email-josh.wu@atmel.com> <54A279A6.1060003@atmel.com> <alpine.DEB.2.00.1412301308070.9569@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tuesday 30 December 2014 13:12:27 Guennadi Liakhovetski wrote:
> On Tue, 30 Dec 2014, Josh Wu wrote:
> 
> [snip]
> 
> > > And until omap1 is in the mainline we cannot drop v4l2_clk.
> 
> s/until/as lonh as/
> 
> > So I think the better way right now for ov2640 driver is still request
> > both the v4l2_clock: mclk, and the clock: xvclk in probe().
> > In that way,  we can take our time to introduce other patches to merged
> > these two clocks. Does it make sense?
> 
> How about this sequence, that we cat still try to get in on time for the
> next merge window:
> 
> 1. stop using the clock name in v4l2_clk
> 2. add support for CCF to v4l2_clk, falling back to current behaviour if
> no clock is found
> 3. switch ov2640 to using "xvclk"

It looks good at first sight.

> Otherwise I would propose to add asynchronous probing support to ov2640
> _without_ changing the clock name. Whether or not we changee clock's name
> isn't related directly to async support, since the driver already is using
> v4l2_clk with the standarf "wrong" name. So, I would consider these two
> changes separately - one is a new feature, another is a fix. The only
> question is in which order to apply them. In general fix-first is
> preferred, but since in this case the fix requires framework changes, we
> could go with feature-first. This also makes sense since features need to
> catch a merge window, whereas a fix can go in later too. So, if we don't
> manage the above 3-step plan, I would priposw the most primitive patch ro
> ov2640 just adding async support in line wuth other drivers and without
> changing the clock name at first.

Async support can go in without the clock rename, but DT support can't.

-- 
Regards,

Laurent Pinchart

