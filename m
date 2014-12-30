Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:63577 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbaL3MNA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Dec 2014 07:13:00 -0500
Date: Tue, 30 Dec 2014 13:12:27 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Josh Wu <josh.wu@atmel.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, m.chehab@samsung.com,
	linux-arm-kernel@lists.infradead.org, s.nawrocki@samsung.com,
	festevam@gmail.com, Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: Re: [PATCH v4 2/5] media: ov2640: add async probe function
In-Reply-To: <54A279A6.1060003@atmel.com>
Message-ID: <alpine.DEB.2.00.1412301308070.9569@axis700.grange>
References: <1418869646-17071-1-git-send-email-josh.wu@atmel.com> <1492726.KPKGvtrvz4@avalon> <Pine.LNX.4.64.1412261136360.9254@axis700.grange> <2421077.hZ7S0HT2At@avalon> <alpine.DEB.2.00.1412300927380.8237@axis700.grange> <54A279A6.1060003@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 30 Dec 2014, Josh Wu wrote:

[snip]

> > And until omap1 is in the mainline we cannot drop v4l2_clk.

s/until/as lonh as/

> So I think the better way right now for ov2640 driver is still request both
> the v4l2_clock: mclk, and the clock: xvclk in probe().
> In that way,  we can take our time to introduce other patches to merged these
> two clocks.
> Does it make sense?

How about this sequence, that we cat still try to get in on time for the 
next merge window:

1. stop using the clock name in v4l2_clk
2. add support for CCF to v4l2_clk, falling back to current behaviour if 
no clock is found
3. switch ov2640 to using "xvclk"

Otherwise I would propose to add asynchronous probing support to ov2640 
_without_ changing the clock name. Whether or not we changee clock's name 
isn't related directly to async support, since the driver already is using 
v4l2_clk with the standarf "wrong" name. So, I would consider these two 
changes separately - one is a new feature, another is a fix. The only 
question is in which order to apply them. In general fix-first is 
preferred, but since in this case the fix requires framework changes, we 
could go with feature-first. This also makes sense since features need to 
catch a merge window, whereas a fix can go in later too. So, if we don't 
manage the above 3-step plan, I would priposw the most primitive patch ro 
ov2640 just adding async support in line wuth other drivers and without 
changing the clock name at first.

Thanks
Guennadi
