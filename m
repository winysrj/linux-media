Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53410 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab2LXReV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Dec 2012 12:34:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Rob Clark <rob.clark@linaro.org>,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Tom Gall <tom.gall@linaro.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC v2 0/5] Common Display Framework
Date: Mon, 24 Dec 2012 18:35:45 +0100
Message-ID: <9229594.Uy6ivYUL5t@avalon>
In-Reply-To: <CAF6AEGuSt0CL2sFGK-PZnw6+r9zhGHO4CEjJEWaR8eGhks2=UQ@mail.gmail.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <87pq26ay2z.fsf@intel.com> <CAF6AEGuSt0CL2sFGK-PZnw6+r9zhGHO4CEjJEWaR8eGhks2=UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On Wednesday 19 December 2012 09:26:40 Rob Clark wrote:
> On Wed, Dec 19, 2012 at 8:57 AM, Jani Nikula wrote:
> > On Tue, 18 Dec 2012, Laurent Pinchart wrote:
> >> On Monday 17 December 2012 18:53:37 Jani Nikula wrote:
> >>> I can see the need for a framework for DSI panels and such (in fact Tomi
> >>> and I have talked about it like 2-3 years ago already!) but what is the
> >>> story for HDMI and DP? In particular, what's the relationship between
> >>> DRM and CDF here? Is there a world domination plan to switch the DRM
> >>> drivers to use this framework too? ;) Do you have some rough plans how
> >>> DRM and CDF should work together in general?
> >> 
> >> There's always a world domination plan, isn't there ? :-)
> >> 
> >> I certainly want CDF to be used by DRM (or more accurately KMS). That's
> >> what the C stands for, common refers to sharing panel and other display
> >> entity drivers between FBDEV, KMS and V4L2.
> >> 
> >> I currently have no plan to expose CDF internals to userspace through the
> >> KMS API. We might have to do so later if the hardware complexity grows
> >> in such a way that finer control than what KMS provides needs to be
> >> exposed to userspace, but I don't think we're there yet. The CDF API
> >> will thus only be used internally in the kernel by display controller
> >> drivers. The KMS core might get functions to handle common display
> >> entity operations, but the bulk of the work will be in the display
> >> controller drivers to start with. We will then see what can be
> >> abstracted in KMS helper functions.
> >> 
> >> Regarding HDMI and DP, I imagine HDMI and DP drivers that would use the
> >> CDF API. That's just a thought for now, I haven't tried to implement
> >> them, but it would be nice to handle HDMI screens and DPI/DBI/DSI panels
> >> in a generic way.
> >> 
> >> Do you have thoughts to share on this topic ?
> > 
> > It just seems to me that, at least from a DRM/KMS perspective, adding
> > another layer (=CDF) for HDMI or DP (or legacy outputs) would be
> > overengineering it. They are pretty well standardized, and I don't see
> > there would be a need to write multiple display drivers for them. Each
> > display controller has one, and can easily handle any chip specific
> > requirements right there. It's my gut feeling that an additional
> > framework would just get in the way. Perhaps there could be more common
> > HDMI/DP helper style code in DRM to reduce overlap across KMS drivers,
> > but that's another thing.
> > 
> > So is the HDMI/DP drivers using CDF a more interesting idea from a
> > non-DRM perspective? Or, put another way, is it more of an alternative
> > to using DRM? Please enlighten me if there's some real benefit here that
> > I fail to see!
> 
> fwiw, I think there are at least a couple cases where multiple SoC's
> have the same HDMI IP block.
> 
> And, there are also external HDMI encoders (for example connected over
> i2c) that can also be shared between boards.  So I think there will be
> a number of cases where CDF is appropriate for HDMI drivers.  Although
> trying to keep this all independent of DRM (as opposed to just
> something similar to what drivers/gpu/i2c is today) seems a bit
> overkill for me.  Being able to use the helpers in drm and avoiding an
> extra layer of translation seems like the better option to me.  So my
> vote would be drivers/gpu/cdf.

I don't think there will be any need for translation (except perhaps between 
the DRM mode structures and the common video mode structure that is being 
discussed). Add a drm_ prefix to the existing CDF functions and structures, 
and there you go :-)

The reason why I'd like to keep CDF separate from DRM (or at least not 
requiring a drm_device) is that HDMI/DP encoders can be used by pure V4L2 
drivers.

> > For DSI panels (or DSI-to-whatever bridges) it's of course another
> > story. You typically need a panel specific driver. And here I see the
> > main point of the whole CDF: decoupling display controllers and the
> > panel drivers, and sharing panel (and converter chip) specific drivers
> > across display controllers. Making it easy to write new drivers, as
> > there would be a model to follow. I'm definitely in favour of coming up
> > with some framework that would tackle that.

-- 
Regards,

Laurent Pinchart

