Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56680 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2HQKCF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 06:02:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	Bryan Wu <bryan.wu@canonical.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	Sumit Semwal <sumit.semwal@ti.com>,
	Archit Taneja <archit@ti.com>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Inki Dae <inki.dae@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC 3/5] video: panel: Add MIPI DBI bus support
Date: Fri, 17 Aug 2012 12:02:21 +0200
Message-ID: <1682445.1yJVVY1ksn@avalon>
In-Reply-To: <1345194182.3158.66.camel@deskari>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com> <1345164583-18924-4-git-send-email-laurent.pinchart@ideasonboard.com> <1345194182.3158.66.camel@deskari>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomi,

Thank you for the review.

On Friday 17 August 2012 12:03:02 Tomi Valkeinen wrote:
> On Fri, 2012-08-17 at 02:49 +0200, Laurent Pinchart wrote:
> > +/*
> > -------------------------------------------------------------------------
> > ---- + * Bus operations
> > + */
> > +
> > +void panel_dbi_write_command(struct panel_dbi_device *dev, unsigned long
> > cmd) +{
> > +	dev->bus->ops->write_command(dev->bus, cmd);
> > +}
> > +EXPORT_SYMBOL_GPL(panel_dbi_write_command);
> > +
> > +void panel_dbi_write_data(struct panel_dbi_device *dev, unsigned long
> > data) +{
> > +	dev->bus->ops->write_data(dev->bus, data);
> > +}
> > +EXPORT_SYMBOL_GPL(panel_dbi_write_data);
> > +
> > +unsigned long panel_dbi_read_data(struct panel_dbi_device *dev)
> > +{
> > +	return dev->bus->ops->read_data(dev->bus);
> > +}
> > +EXPORT_SYMBOL_GPL(panel_dbi_read_data);
> 
> I'm not that familiar with how to implement bus drivers, can you
> describe in pseudo code how the SoC's DBI driver would register these?

Sure.

The DBI bus driver first needs to create a panel_dbi_bus_ops instance:

static const struct panel_dbi_bus_ops sh_mobile_lcdc_dbi_bus_ops = {
        .write_command = lcdc_dbi_write_command,
        .write_data = lcdc_dbi_write_data,
        .read_data = lcdc_dbi_read_data,
};

and a panel_dbi_bus instance, usually embedded in its private driver data 
structure, and initialize it by setting its dev and ops fields:

        ch->dbi_bus.dev = ch->lcdc->dev;
        ch->dbi_bus.ops = &sh_mobile_lcdc_dbi_bus_ops;

In my current implementation, the panel_dbi_device is created in board code:

static struct panel_dbi_device migor_panel_device = {
        .name           = "r61505",
        .id             = 0,
        .dev            = {
                .platform_data  = &migor_panel_info,
        },
};

A pointer to that structure is passed to the DBI master driver, which then 
registers the device:

        panel_dbi_device_register(dbi, &ch->dbi_bus);

With a DT-based solution the DBI core will expose a function to register DBI 
devices from OF nodes.

The bus itself is currently not registered with the DBI code because there was 
no need to.

> I think write/read data functions are a bit limited. Shouldn't they be
> something like write_data(const u8 *buf, int size) and read_data(u8
> *buf, int len)?

Good point. My hardware doesn't support multi-byte read/write operations 
directly so I haven't thought about adding those.

Can your hardware group command + data writes in a single operation ? If so we 
should expose that at the API level as well.

Is DBI limited to 8-bit data transfers for commands ? Pixels can be 
transferred 16-bit at a time, commands might as well. While DCS only specifies 
8-bit command/data, DBI panels that are not DCS compliant can use 16-bit 
command/data (the R61505 panel, albeit a SYS-80 panel, does so).

> Something that's totally missing is configuring the DBI bus. There are a
> bunch of timing related values that need to be configured. See
> include/video/omapdss.h struct rfbi_timings. While the struct is OMAP
> specific, if I recall right most of the values match to the MIPI DBI
> spec.

I've left that out currently, and thought about passing that information as 
platform data to the DBI bus driver. That's the easiest solution, but I agree 
that it's a hack. Panel should expose their timing requirements to the DBI 
host. API wise that wouldn't be difficult (we only need to add timing 
information to the panel platform data and add a function to the DBI API to 
retrieve it), one of challenges might be to express it in a way that's both 
universal enough and easy to use for DBI bus drivers.

> And this makes me wonder, you use DBI bus for SYS-80 panel. The busses
> may look similar in operation, but are they really so similar when you
> take into account the timings (and perhaps something else, it's been
> years since I read the MIPI DBI spec)?

I'll have to check all the details. SYS-80 is similar to DBI-B, but supports a 
wider bus width of 18 bits. I think the interfaces are similar enough to use a 
single bus implementation, possibly with quirks and/or options (see SCCB 
support in I2C for instance, with flags to ignore acks, force a stop bit 
generation, ...). We would duplicate lots of code if we had two different 
implementations, and would prevent a DBI panel to be attached to a SYS-80 host 
and vice-versa (the format is known to work).

> Then there's the start_transfer. This is something I'm not sure what is
> the best way to handle it, but the same problems that I mentioned in the
> previous post related to enable apply here also. For example, what if
> the panel needs to be update in two parts? This is done in Nokia N9.
> From panel's perspective, it'd be best to handle it somewhat like this
> (although asynchronously, probably):
> 
> write_update_area(0, 0, xres, yres / 2);
> write_memory_start()
> start_pixel_transfer();
> 
> wait_transfer_done();
> 
> write_update_area(0, yres / 2, xres, yres / 2);
> write_memory_start()
> start_pixel_transfer();
> 
> Why I said I'm not sure about this is that it does complicate things, as
> the actual pixel data often comes from the display subsystem hardware,
> which should probably be controlled by the display driver.

I have no solution for this at the moment. That's an advanced (but definitely 
required) feature, I've tried to concentrate on the basics first.

> I think there also needs to be some kind of transfer_done notifier, for
> both the display driver and the panel driver. Although if the display
> driver handles starting the actual pixel transfer, then it'll get the
> transfer_done via whatever interrupt the SoC has.
> 
> Also as food for thought, videomode timings does not really make sense
> for DBI panels, at least when you just consider the DBI side. There's
> really just the resolution of the display, and then the DBI timings. No
> pck, syncs, etc. Of course in the end there's the actual panel, which
> does have these video timings. But often they cannot be configured, and
> often you don't even know them as the specs don't tell them.

We might just need to provide fake timings. Video mode timings are at the core 
of display support in all drivers so we can't just get rid of them. The h/v 
front/back porch and sync won't be used by display drivers for DBI/DSI panels 
anyway.

-- 
Regards,

Laurent Pinchart

