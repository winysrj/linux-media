Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60726 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab2KZQLH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Nov 2012 11:11:07 -0500
Date: Mon, 26 Nov 2012 17:10:55 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, kernel@pengutronix.de,
	David Airlie <airlied@linux.ie>,
	devicetree-discuss@lists.ozlabs.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCHv15 3/7] video: add of helper for display timings/videomode
Message-ID: <20121126161055.GB30791@pengutronix.de>
References: <1353920848-1705-1-git-send-email-s.trumtrar@pengutronix.de>
 <1353920848-1705-4-git-send-email-s.trumtrar@pengutronix.de>
 <50B37EEC.6090808@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B37EEC.6090808@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, Nov 26, 2012 at 04:38:36PM +0200, Tomi Valkeinen wrote:
> Hi,
> 
> On 2012-11-26 11:07, Steffen Trumtrar wrote:
> > This adds support for reading display timings from DT into a struct
> > display_timings. The of_display_timing implementation supports multiple
> > subnodes. All children are read into an array, that can be queried.
> > 
> > If no native mode is specified, the first subnode will be used.
> > 
> > For cases where the graphics driver knows there can be only one
> > mode description or where the driver only supports one mode, a helper
> > function of_get_videomode is added, that gets a struct videomode from DT.
> > 
> > Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > Acked-by: Stephen Warren <swarren@nvidia.com>
> > Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  .../devicetree/bindings/video/display-timing.txt   |  107 ++++++++++
> >  drivers/video/Kconfig                              |   15 ++
> >  drivers/video/Makefile                             |    2 +
> >  drivers/video/of_display_timing.c                  |  219 ++++++++++++++++++++
> >  drivers/video/of_videomode.c                       |   54 +++++
> >  include/linux/of_display_timing.h                  |   20 ++
> >  include/linux/of_videomode.h                       |   18 ++
> >  7 files changed, 435 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/video/display-timing.txt
> >  create mode 100644 drivers/video/of_display_timing.c
> >  create mode 100644 drivers/video/of_videomode.c
> >  create mode 100644 include/linux/of_display_timing.h
> >  create mode 100644 include/linux/of_videomode.h
> > 
> > diff --git a/Documentation/devicetree/bindings/video/display-timing.txt b/Documentation/devicetree/bindings/video/display-timing.txt
> > new file mode 100644
> > index 0000000..e238f27
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/video/display-timing.txt
> > @@ -0,0 +1,107 @@
> > +display-timing bindings
> > +=======================
> > +
> > +display-timings node
> > +--------------------
> > +
> > +required properties:
> > + - none
> > +
> > +optional properties:
> > + - native-mode: The native mode for the display, in case multiple modes are
> > +		provided. When omitted, assume the first node is the native.
> > +
> > +timing subnode
> > +--------------
> > +
> > +required properties:
> > + - hactive, vactive: display resolution
> > + - hfront-porch, hback-porch, hsync-len: horizontal display timing parameters
> > +   in pixels
> > +   vfront-porch, vback-porch, vsync-len: vertical display timing parameters in
> > +   lines
> > + - clock-frequency: display clock in Hz
> > +
> > +optional properties:
> > + - hsync-active: hsync pulse is active low/high/ignored
> > + - vsync-active: vsync pulse is active low/high/ignored
> > + - de-active: data-enable pulse is active low/high/ignored
> > + - pixelclk-inverted: pixelclock is inverted (active on falling edge)/
> > +				non-inverted (active on rising edge)/
> > +				     ignored (ignore property)
> 
> I think hsync-active and vsync-active are clear, and commonly used, and
> they are used for both drm and fb mode conversions in later patches.
> 
> de-active is not used in drm and fb mode conversions, but I think it's
> also clear.
> 
> pixelclk-inverted is not used in the mode conversions. It's also a bit
> unclear to me. What does it mean that pix clock is "active on rising
> edge"? The pixel data is driven on rising edge? How about the sync
> signals and DE, when are they driven? Does your HW have any settings
> related to those?
> 

Those are properties commonly found in display specs. That is why they are here.
If the GPU does not support the property it can be omitted.

> OMAP has the invert pclk setting, but it also has a setting to define
> when the sync signals are driven. The options are:
> - syncs are driven on rising edge of pclk
> - syncs are driven on falling edge of pclk
> - syncs are driven on the opposite edge of pclk compared to the pixel data
> 
> For DE there's no setting, except the active high/low.
> 
> And if I'm not mistaken, if the optional properties are not defined,
> they are not ignored, but left to the default 0. Which means active low,
> or active on rising edge(?). I think it would be good to have a
> "undefined" value for the properties.
> 

Yes. As mentioned in my other mail, the intention of the omitted properties do
not propagate properly. Omitted must be a value < 0, so it is clear in a later
stage, that this property shall not be used. And isn't unintentionally considered
to be active low.

> > + - interlaced (bool): boolean to enable interlaced mode
> > + - doublescan (bool): boolean to enable doublescan mode
> > + - doubleclk (bool)
> 
> As I mentioned in the other mail, doubleclk is not used nor documented here.
> 

Yes. Rebase mistake I overlooked.

> > +All the optional properties that are not bool follow the following logic:
> > +    <1>: high active
> > +    <0>: low active
> > +    omitted: not used on hardware
> > +
> > +There are different ways of describing the capabilities of a display. The devicetree
> > +representation corresponds to the one commonly found in datasheets for displays.
> > +If a display supports multiple signal timings, the native-mode can be specified.
> 
> I have some of the same concerns for this series than with the
> interpreted power sequences (on fbdev): when you publish the DT
> bindings, it's somewhat final version then, and fixing it later will be
> difficult. Of course, video modes are much clearer than the power
> sequences, so it's possible there won't be any problems with the DT
> bindings.
> 

The binding is pretty much at the bare minimum after a lot of discussion about
the properties. Even if the binding changes, I think it will rather grow than
shrink. Take the doubleclock property for example. It got here mistakingly,
because we had a display that has this feature.

> However, I'd still feel safer if the series would be split to non-DT and
> DT parts. The non-DT parts could be merged quite easily, and people
> could start using them in their kernels. This should expose
> bugs/problems related to the code.
> 
> The DT part could be merged later, when there's confidence that the
> timings are good for all platforms.
> 
> Or, alternatively, all the non-common bindings (de-active, pck
> invert,...) that are not used for fbdev or drm currently could be left
> out for now. But I'd stil prefer merging it in two parts.

I don't say that I'm against it, but the whole reason for the series was
getting the display timings from a DT into a graphics driver. And I think
I remember seeing some other attempts at achieving this, but all specific
to one special case. There is even already a mainline driver that uses an older
version of the DT bindings (vt8500-fb).

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
