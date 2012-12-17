Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38081 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab2LQWSh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 17:18:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	linux-fbdev@vger.kernel.org,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Tom Gall <tom.gall@linaro.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	dri-devel@lists.freedesktop.org, Rob Clark <rob.clark@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC v2 0/5] Common Display Framework
Date: Mon, 17 Dec 2012 23:19:53 +0100
Message-ID: <1671267.x0lxGrFjjV@avalon>
In-Reply-To: <87pq28hb72.fsf@intel.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <1608840.IleINgrx5J@avalon> <87pq28hb72.fsf@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jani,

On Monday 17 December 2012 18:53:37 Jani Nikula wrote:
> On Mon, 17 Dec 2012, Laurent Pinchart wrote:
> > On Friday 23 November 2012 16:51:37 Tomi Valkeinen wrote:
> >> On 2012-11-22 23:45, Laurent Pinchart wrote:
> >> > From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> >> > 
> >> > Hi everybody,
> >> > 
> >> > Here's the second RFC of what was previously known as the Generic Panel
> >> > Framework.
> >> 
> >> Nice work! Thanks for working on this.
> >> 
> >> I was doing some testing with the code, seeing how to use it in omapdss.
> >> Here are some thoughts:
> >> 
> >> In your model the DSS gets the panel devices connected to it from
> >> platform data. After the DSS and the panel drivers are loaded, DSS gets
> >> a notification and connects DSS and the panel.
> >> 
> >> I think it's a bit limited way. First of all, it'll make the DT data a
> >> bit more complex (although this is not a major problem). With your
> >> model, you'll need something like:
> >> 
> >> soc-base.dtsi:
> >> 
> >> dss {
> >> 	dpi0: dpi {
> >> 	};
> >> };
> >> 
> >> board.dts:
> >> 
> >> &dpi0 {
> >> 	panel = &dpi-panel;
> >> };
> >> 
> >> / {
> >> 	dpi-panel: dpi-panel {
> >> 		...panel data...;
> >> 	};
> >> };
> >> 
> >> Second, it'll prevent hotplug, and even if real hotplug would not be
> >> supported, it'll prevent cases where the connected panel must be found
> >> dynamically (like reading ID from eeprom).
> > 
> > Hotplug definitely needs to be supported, as the common display framework
> > also targets HDMI and DP. The notification mechanism was actually
> > designed to support hotplug.
> 
> I can see the need for a framework for DSI panels and such (in fact Tomi
> and I have talked about it like 2-3 years ago already!) but what is the
> story for HDMI and DP? In particular, what's the relationship between
> DRM and CDF here? Is there a world domination plan to switch the DRM
> drivers to use this framework too? ;) Do you have some rough plans how
> DRM and CDF should work together in general?

There's always a world domination plan, isn't there ? :-)

I certainly want CDF to be used by DRM (or more accurately KMS). That's what 
the C stands for, common refers to sharing panel and other display entity 
drivers between FBDEV, KMS and V4L2.

I currently have no plan to expose CDF internals to userspace through the KMS 
API. We might have to do so later if the hardware complexity grows in such a 
way that finer control than what KMS provides needs to be exposed to 
userspace, but I don't think we're there yet. The CDF API will thus only be 
used internally in the kernel by display controller drivers. The KMS core 
might get functions to handle common display entity operations, but the bulk 
of the work will be in the display controller drivers to start with. We will 
then see what can be abstracted in KMS helper functions.

Regarding HDMI and DP, I imagine HDMI and DP drivers that would use the CDF 
API. That's just a thought for now, I haven't tried to implement them, but it 
would be nice to handle HDMI screens and DPI/DBI/DSI panels in a generic way.

Do you have thoughts to share on this topic ?

-- 
Regards,

Laurent Pinchart

