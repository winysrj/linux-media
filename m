Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:52299 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab2GaM7s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 08:59:48 -0400
Date: Tue, 31 Jul 2012 14:59:45 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Subject: Re: [RFC/PATCH 09/13] media: s5k6aa: Add support for device tree
 based instantiation
In-Reply-To: <5017D3A5.5000503@samsung.com>
Message-ID: <Pine.LNX.4.64.1207311452180.27888@axis700.grange>
References: <4FBFE1EC.9060209@samsung.com> <3336686.TMIyoLDix4@avalon>
 <Pine.LNX.4.64.1207311326250.27888@axis700.grange> <7305269.IxTKyOjUBg@avalon>
 <Pine.LNX.4.64.1207311416160.27888@axis700.grange> <5017D3A5.5000503@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 31 Jul 2012, Sylwester Nawrocki wrote:

> On 07/31/2012 02:26 PM, Guennadi Liakhovetski wrote:
> >>>> But should we allow host probe() to succeed if the sensor isn't present ?
> >>>
> >>> I think we should, yes. The host hardware is there and functional -
> >>> whether or not all or some of the clients are failing. Theoretically
> >>> clients can also be hot-plugged. Whether and how many video device nodes
> >>> we create, that's a different question.
> >>
> >> I think I can agree with you on this (although I could change my mind if this 
> >> architecture turns out to result in unsolvable technical issues). That will 
> >> involve a lot of work though.
> > 
> > There's however at least one more gotcha that occurs to me with this 
> > approach: if clients fail to probe, how do we find out about that and turn 
> > clocks back off? One improvement to turning clocks on immediately in 
> 
> Hmm, wouldn't it be the client that turns a clock on/off when needed ?
> I'd like to preserve this functionality, so client drivers can have
> full control on the power up/down sequences. While we are trying to
> improve the current situation...

Eventually, when the clock API is available - yes, the client would just 
call clk_enable() / clk_disable(). But for now isn't it host's job to do 
that? Or you want to add new API for that?

Thanks
Guennadi

> > host's probe() is to only do it in a BUS_NOTIFY_BIND_DRIVER notifier. But 
> > how do we find out, that probing failed? No notifier is called in this 
> > case. We could use a time-out, but that's ugly. I think, we could ever 
> > request a new notifier for this case. We could also require client drivers 
> > to call a V4L2 function in this case, but that's not very pretty either.

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
