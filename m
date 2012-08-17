Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41375 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab2HQMct (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 08:32:49 -0400
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
Date: Fri, 17 Aug 2012 14:33:05 +0200
Message-ID: <2019849.eCaIrHMssh@avalon>
In-Reply-To: <1345200709.11073.27.camel@lappyti>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com> <1682445.1yJVVY1ksn@avalon> <1345200709.11073.27.camel@lappyti>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomi,

On Friday 17 August 2012 13:51:49 Tomi Valkeinen wrote:
> On Fri, 2012-08-17 at 12:02 +0200, Laurent Pinchart wrote:
> > On Friday 17 August 2012 12:03:02 Tomi Valkeinen wrote:
> > > On Fri, 2012-08-17 at 02:49 +0200, Laurent Pinchart wrote:
> > > > +/*
> > > > ----------------------------------------------------------------------
> > > > ---
> > > > ---- + * Bus operations
> > > > + */
> > > > +
> > > > +void panel_dbi_write_command(struct panel_dbi_device *dev, unsigned
> > > > long
> > > > cmd) +{
> > > > +	dev->bus->ops->write_command(dev->bus, cmd);
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(panel_dbi_write_command);
> > > > +
> > > > +void panel_dbi_write_data(struct panel_dbi_device *dev, unsigned long
> > > > data) +{
> > > > +	dev->bus->ops->write_data(dev->bus, data);
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(panel_dbi_write_data);
> > > > +
> > > > +unsigned long panel_dbi_read_data(struct panel_dbi_device *dev)
> > > > +{
> > > > +	return dev->bus->ops->read_data(dev->bus);
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(panel_dbi_read_data);
> > > 
> > > I'm not that familiar with how to implement bus drivers, can you
> > > describe in pseudo code how the SoC's DBI driver would register these?
> > 
> > Sure.
> > 
> > The DBI bus driver first needs to create a panel_dbi_bus_ops instance:
> > 
> > static const struct panel_dbi_bus_ops sh_mobile_lcdc_dbi_bus_ops = {
> > 
> >         .write_command = lcdc_dbi_write_command,
> >         .write_data = lcdc_dbi_write_data,
> >         .read_data = lcdc_dbi_read_data,
> > 
> > };
> 
> Thanks for the example, I think it cleared up things a bit.
> 
> As I mentioned earlier, I really think "panel" is not right here. While
> the whole framework may be called panel framework, the bus drivers are
> not panels, and we should support external chips also, which are not
> panels either.

I agree. I've renamed panel_dbi_* to mipi_dbi_*.

> > > I think write/read data functions are a bit limited. Shouldn't they be
> > > something like write_data(const u8 *buf, int size) and read_data(u8
> > > *buf, int len)?
> > 
> > Good point. My hardware doesn't support multi-byte read/write operations
> > directly so I haven't thought about adding those.
> 
> OMAP HW doesn't support it either. Well, not quite true, as OMAP's
> system DMA could be used to write a buffer to the DBI output. But that's
> really the same as doing the write with a a loop with CPU.
> 
> But first, the data type should be byte, not unsigned long. How would
> you write 8 bits or 16 bits with your API?

u8 and u16 both fit in an unsigned long :-) Please see below.

> And second, if the function takes just u8, you'd need lots of calls to do
> simple writes.

I agree, an array write function is a good idea.

> > Can your hardware group command + data writes in a single operation ? If
> > so we should expose that at the API level as well.
> 
> No it can't. But with DCS that is a common operation, so we could have
> some helpers to send command + data with one call.

Agreed.

> Then again, I'd hope to have DCS somehow as a separate library, which would
> then use DBI/DSI/whatnot to actually send the data.
> 
> I'm not quite sure how easy that is because of the differences between
> the busses.
> 
> > Is DBI limited to 8-bit data transfers for commands ? Pixels can be
> > transferred 16-bit at a time, commands might as well. While DCS only
> > specifies 8-bit command/data, DBI panels that are not DCS compliant can
> > use 16-bit command/data (the R61505 panel, albeit a SYS-80 panel, does
> > so).
> 
> I have to say I don't remember much about DBI =). Looking at OMAP's
> driver, which was made for omap2 and hasn't been much updated since, I
> see that there are 4 modes, 8/9/12/16 bits. I think that defines how
> many of the parallel data lines are used.

SYS-80 also has an 18-bits mode, where bits 0 and 9 are always ignored when 
transferring instructions and data other than pixels (for pixels the 18-bits 
bus width can be used to transfer RGB666 in a single clock cycle).

See page 87 of 
http://read.pudn.com/downloads91/sourcecode/others/348230/e61505_103a.pdf.

> However, I don't think that matters for the panel driver when it wants
> to send data. The panel driver should just call dbi_write(buf, buf_len),
> and the dbi driver would send the data in the buffer according to the
> bus width.

According to the DCS specification, commands and parameters are transferred 
using 8-bit data. Non-DCS panels can however use wider commands and parameters 
(all commands and parameters are 16-bits wide for the R61505 for instance).

We can add an API to switch the DBI bus width on the fly. For Renesas hardware 
this would "just" require shifting bits around to output the 8-bit or 16-bit 
commands on the right data lines (the R61505 uses D17-D9 in 8-bit mode, while 
the DCS specification mentions D7-D0) based on how the panel is connected and 
on which lines the panel expects data.

As commands can be expressed on either 8 or 16 bits I would use a 16 type for 
them.

For parameters, we can either express everything as u8 * in the DBI bus 
operations, or use a union similar to i2c_smbus_data

union i2c_smbus_data {
        __u8 byte;
        __u16 word;
        __u8 block[I2C_SMBUS_BLOCK_MAX + 2]; /* block[0] is used for length */
                               /* and one more for user-space compatibility */
};

Helper functions would be available to perform 8-bit, 16-bit or n*8 bits 
transfers.

Would that work for your use cases ?

> Also note that some chips need to change the bus width on the fly. The
> chip used on N800 wants configuration to be done with 8-bits, and pixel
> transfers with 16-bits. Who knows why...

On which data lines is configuration performed ? D7-D0 ?

> So I think this, and generally most of the configuration, should be
> somewhat dynamic, so that the panel driver can change them when it
> needs.
> 
> > > Something that's totally missing is configuring the DBI bus. There are a
> > > bunch of timing related values that need to be configured. See
> > > include/video/omapdss.h struct rfbi_timings. While the struct is OMAP
> > > specific, if I recall right most of the values match to the MIPI DBI
> > > spec.
> > 
> > I've left that out currently, and thought about passing that information
> > as platform data to the DBI bus driver. That's the easiest solution, but I
> > agree that it's a hack. Panel should expose their timing requirements to
> > the DBI host. API wise that wouldn't be difficult (we only need to add
> > timing information to the panel platform data and add a function to the
> > DBI API to retrieve it), one of challenges might be to express it in a
> > way that's both universal enough and easy to use for DBI bus drivers.
> 
> As I pointed above, I think the panel driver shouldn't expose it, but
> the panel driver should somehow set it. Or at least allowed to change it
> in some manner. This is actually again, the same problem as with enable
> and transfer: who controls what's going on.
> 
> How I think it should work is something like:
> 
> mipi_dbi_set_timings(dbi_dev, mytimings);
> mipi_dbi_set_bus_width(dbi_dev, 8);
> mipi_dbi_write(dbi_dev, ...);
> mipi_dbi_set_bus_width(dbi_dev, 16);
> start_frame_transfer(dbi_dev, ...);

I'll first implement bus width setting.

> > > And this makes me wonder, you use DBI bus for SYS-80 panel. The busses
> > > may look similar in operation, but are they really so similar when you
> > > take into account the timings (and perhaps something else, it's been
> > > years since I read the MIPI DBI spec)?
> > 
> > I'll have to check all the details. SYS-80 is similar to DBI-B, but
> > supports a wider bus width of 18 bits. I think the interfaces are similar
> > enough to use a single bus implementation, possibly with quirks and/or
> > options (see SCCB support in I2C for instance, with flags to ignore acks,
> > force a stop bit generation, ...). We would duplicate lots of code if we
> > had two different implementations, and would prevent a DBI panel to be
> > attached to a SYS-80 host and vice-versa (the format is known to work).
> 
> Ah ok, if a DBI panel can be connected to SYS-80 output and vice versa,
> then I agree they are similar enough.

Not all combination will work (a SYS panel that requires 16-bit transfers 
won't work with a DBI host that only supports 8-bit), but some do.
 
> > We might just need to provide fake timings. Video mode timings are at the
> > core of display support in all drivers so we can't just get rid of them.
> > The h/v front/back porch and sync won't be used by display drivers for
> > DBI/DSI panels anyway.
> 
> Right. But we should probably think if we can, at the panel level, easily
> separate conventional panels and smart panels. Then this framework wouldn't
> need to fake the timings, and it'd be up to the higher level to decide if
> and how to fake them. Then again, this is no biggie. Just thought that at
> the lowest level it'd be nice to be "correct" and leave faking to upper
> layers =).

But we would then have two different APIs at the lower level depending on the 
panel type. I'm not sure that's a good thing.

-- 
Regards,

Laurent Pinchart

