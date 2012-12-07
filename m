Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50095 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030606Ab2LGOM6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2012 09:12:58 -0500
Subject: Re: [PATCHv15 3/7] video: add of helper for display
 timings/videomode
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	linux-fbdev@vger.kernel.org, kernel@pengutronix.de,
	David Airlie <airlied@linux.ie>,
	devicetree-discuss@lists.ozlabs.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
In-Reply-To: <50B39F46.7050808@ti.com>
References: <1353920848-1705-1-git-send-email-s.trumtrar@pengutronix.de>
	 <1353920848-1705-4-git-send-email-s.trumtrar@pengutronix.de>
	 <50B37EEC.6090808@ti.com> <20121126161055.GB30791@pengutronix.de>
	 <50B39F46.7050808@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Dec 2012 15:12:48 +0100
Message-ID: <1354889568.2533.118.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Montag, den 26.11.2012, 18:56 +0200 schrieb Tomi Valkeinen:
> On 2012-11-26 18:10, Steffen Trumtrar wrote:
> > Hi,
> > 
> > On Mon, Nov 26, 2012 at 04:38:36PM +0200, Tomi Valkeinen wrote:
> 
> >>> +optional properties:
> >>> + - hsync-active: hsync pulse is active low/high/ignored
> >>> + - vsync-active: vsync pulse is active low/high/ignored
> >>> + - de-active: data-enable pulse is active low/high/ignored
> >>> + - pixelclk-inverted: pixelclock is inverted (active on falling edge)/
> >>> +				non-inverted (active on rising edge)/
> >>> +				     ignored (ignore property)
> >>
> >> I think hsync-active and vsync-active are clear, and commonly used, and
> >> they are used for both drm and fb mode conversions in later patches.
> >>
> >> de-active is not used in drm and fb mode conversions, but I think it's
> >> also clear.
> >>
> >> pixelclk-inverted is not used in the mode conversions. It's also a bit
> >> unclear to me. What does it mean that pix clock is "active on rising
> >> edge"? The pixel data is driven on rising edge? How about the sync
> >> signals and DE, when are they driven? Does your HW have any settings
> >> related to those?
> >>
> > 
> > Those are properties commonly found in display specs. That is why they are here.
> > If the GPU does not support the property it can be omitted.
> 
> So what does the pixelclk-inverted mean? Normally the SoC drives pixel
> data on rising edge, and the panel samples it at falling edge? And
> vice-versa for inverted? Or the other way around?
>
> When is hsync/vsync set? On rising or falling edge of pclk?
>
> My point here is that the pixelclk-inverted is not crystal clear thing,
> like the hsync/vsync/de-active values are.
>
> And while thinking about this, I realized that the meaning of
> pixelclk-inverted depends on what component is it applied to. Presuming
> normal pixclk means "pixel data on rising edge", the meaning of that
> depends on do we consider the SoC or the panel. The panel needs to
> sample the data on the other edge from the one the SoC uses to drive the
> data.
> 
> Does the videomode describe the panel, or does it describe the settings
> programmed to the SoC?

How about calling this property pixelclk-active, active high meaning
driving pixel data on rising edges and sampling on falling edges (the
pixel clock is high between driving and sampling the data), and active
low meaning driving on falling edges and sampling on rising edges?
It is the same from the SoC perspective and from the panel perspective,
and it mirrors the usage of the other *-active properties.

[...]

regards
Philipp

