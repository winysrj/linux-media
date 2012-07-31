Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46815 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab2GaVqk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 17:46:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Subject: Re: [RFC/PATCH 09/13] media: s5k6aa: Add support for device tree based instantiation
Date: Tue, 31 Jul 2012 23:46:46 +0200
Message-ID: <5948378.3Gs2pPiBLX@avalon>
In-Reply-To: <5017DD94.8040100@samsung.com>
References: <4FBFE1EC.9060209@samsung.com> <Pine.LNX.4.64.1207311452180.27888@axis700.grange> <5017DD94.8040100@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Tuesday 31 July 2012 15:28:52 Sylwester Nawrocki wrote:
> On 07/31/2012 02:59 PM, Guennadi Liakhovetski wrote:
> > On Tue, 31 Jul 2012, Sylwester Nawrocki wrote:
> >> On 07/31/2012 02:26 PM, Guennadi Liakhovetski wrote:
> >>>>>> But should we allow host probe() to succeed if the sensor isn't
> >>>>>> present ?
> >>>>> 
> >>>>> I think we should, yes. The host hardware is there and functional -
> >>>>> whether or not all or some of the clients are failing. Theoretically
> >>>>> clients can also be hot-plugged. Whether and how many video device
> >>>>> nodes
> >>>>> we create, that's a different question.
> >>>> 
> >>>> I think I can agree with you on this (although I could change my mind
> >>>> if this architecture turns out to result in unsolvable technical
> >>>> issues). That will involve a lot of work though.
> >>> 
> >>> There's however at least one more gotcha that occurs to me with this
> >>> approach: if clients fail to probe, how do we find out about that and
> >>> turn
> >>> clocks back off? One improvement to turning clocks on immediately in
> >> 
> >> Hmm, wouldn't it be the client that turns a clock on/off when needed ?
> >> I'd like to preserve this functionality, so client drivers can have
> >> full control on the power up/down sequences. While we are trying to
> >> improve the current situation...
> > 
> > Eventually, when the clock API is available - yes, the client would just
> > call clk_enable() / clk_disable(). But for now isn't it host's job to do
> > that? Or you want to add new API for that?
> 
> Indeed, looking at existing drivers, the clocks' handling is now mostly
> done in the host drivers. Only the omap3isp appears to do the right thing,
> i.e. delegating control over the clock to client drivers, but it does it
> with platform_data callbacks.
> 
> We've already discussed adding a new API for that,
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg35359.html
> 
> However using common clock API and binding a clock to client device
> (either DT based or not) sounds like a best approach to me.
> 
> Waiting for the common clock API to be generally available maybe we
> could add some clock ops at the v4l2_device ? Just a humble suggestion,
> I'm not sure whether it is really good and needed or not.

I'm fine with that (or something similar) as an interim solution.

-- 
Regards,

Laurent Pinchart

