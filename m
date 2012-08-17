Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58203 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab2HQOGQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 10:06:16 -0400
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
Date: Fri, 17 Aug 2012 16:06:31 +0200
Message-ID: <2279211.zL1tj9ffOr@avalon>
In-Reply-To: <1345208790.3158.133.camel@deskari>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com> <2019849.eCaIrHMssh@avalon> <1345208790.3158.133.camel@deskari>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomi,

On Friday 17 August 2012 16:06:30 Tomi Valkeinen wrote:
> On Fri, 2012-08-17 at 14:33 +0200, Laurent Pinchart wrote:
> > > But first, the data type should be byte, not unsigned long. How would
> > > you write 8 bits or 16 bits with your API?
> > 
> > u8 and u16 both fit in an unsigned long :-) Please see below.
> 
> Ah, I see, so the driver would just discard 24 bits or 16 bits from the
> ulong.

That's right.

> I somehow thought that if you have 8 bit bus, and you call the write with
> ulong, 4 bytes will be written.
> 
> > > Then again, I'd hope to have DCS somehow as a separate library, which
> > > would then use DBI/DSI/whatnot to actually send the data.
> > > 
> > > I'm not quite sure how easy that is because of the differences between
> > > the busses.
> > > 
> > > > Is DBI limited to 8-bit data transfers for commands ? Pixels can be
> > > > transferred 16-bit at a time, commands might as well. While DCS only
> > > > specifies 8-bit command/data, DBI panels that are not DCS compliant
> > > > can use 16-bit command/data (the R61505 panel, albeit a SYS-80 panel,
> > > > does so).
> > > 
> > > I have to say I don't remember much about DBI =). Looking at OMAP's
> > > driver, which was made for omap2 and hasn't been much updated since, I
> > > see that there are 4 modes, 8/9/12/16 bits. I think that defines how
> > > many of the parallel data lines are used.
> > 
> > SYS-80 also has an 18-bits mode, where bits 0 and 9 are always ignored
> > when transferring instructions and data other than pixels (for pixels the
> > 18-bits bus width can be used to transfer RGB666 in a single clock cycle).
> > 
> > See page 87 of
> > http://read.pudn.com/downloads91/sourcecode/others/348230/e61505_103a.pdf.
> > 
> > > However, I don't think that matters for the panel driver when it wants
> > > to send data. The panel driver should just call dbi_write(buf, buf_len),
> > > and the dbi driver would send the data in the buffer according to the
> > > bus width.
> > 
> > According to the DCS specification, commands and parameters are
> > transferred using 8-bit data. Non-DCS panels can however use wider
> > commands and parameters (all commands and parameters are 16-bits wide for
> > the R61505 for instance).
> > 
> > We can add an API to switch the DBI bus width on the fly. For Renesas
> > hardware this would "just" require shifting bits around to output the
> > 8-bit or 16-bit commands on the right data lines (the R61505 uses D17-D9
> > in 8-bit mode, while the DCS specification mentions D7-D0) based on how
> > the panel is connected and on which lines the panel expects data.
> > 
> > As commands can be expressed on either 8 or 16 bits I would use a 16 type
> > for them.
> 
> I won't put my head on the block, but I don't think DBI has any
> restriction on the size of the command. A "command" just means a data
> transfer while keeping the D/CX line low, and "data" when the line is
> high. Similar transfers for n bytes can be done in both modes.

Right. I'll see if the API could be simplified by having a single write 
callback function with a data/command parameter.

> > For parameters, we can either express everything as u8 * in the DBI bus
> > operations, or use a union similar to i2c_smbus_data
> > 
> > union i2c_smbus_data {
> > 
> >         __u8 byte;
> >         __u16 word;
> >         __u8 block[I2C_SMBUS_BLOCK_MAX + 2]; /* block[0] is used for
> >         length */
> >         
> >                                /* and one more for user-space
> >                                compatibility */
> > 
> > };
> 
> There's no DBI_BLOCK_MAX, so at least identical union won't work. I
> think it's simplest to have u8 * function as a base, and then a few
> helpers to write the most common datatypes.

OK, that sounds good to me.

> So we could have on the lowest level something like:
> 
> dbi_write_command(u8 *buf, size_t size);
> dbi_write_data(u8 *buf, size_t size);
> 
> And possible helpers:
> 
> dbi_write_data(u8 *cmd_buf, size_t cmd_size, u8 *data_buf, size_t
> data_size);
> 
> dbi_write_dcs(u8 cmd, u8 *data, size_t size);
> 
> And variations:
> 
> dbi_write_dcs_0(u8 cmd);
> dbi_write_dcs_1(u8 cmd, u8 data);
> 
> etc. So a simple helper to send 16 bits would be:
> 
> dbi_write_data(u16 data)
> {
> 	// or are the bytes the other way around...
> 	u8 buf[2] = { data & 0xff, (data >> 8) & 0xff };
> 	return dbi_write_data(buf, 2);
> }
> 
> > Helper functions would be available to perform 8-bit, 16-bit or n*8 bits
> > transfers.
> > 
> > Would that work for your use cases ?
> > 
> > > Also note that some chips need to change the bus width on the fly. The
> > > chip used on N800 wants configuration to be done with 8-bits, and pixel
> > > transfers with 16-bits. Who knows why...
> > 
> > On which data lines is configuration performed ? D7-D0 ?
> 
> I guess so, but does it matter? All the bus driver needs to know is how
> to send 8/16/.. bit data. On OMAP we just write the data to a 32 bit
> register, and the HW takes the lowest n bits. Do the bits represent the
> data lines directly on Renesans?

Yes they do. For a SYS-80 panel configured in 18-bits mode, I'll have to write

((data & 0xff00) << 2) | ((data & 0x00ff) << 1)

(d15:8 -> D17:10, d7:0 -> D8:1 where d is the word to be written, and D the 
physical lines)

to the hardware data register and trigger the write. In 8 bits mode, there 
would be two write operations with

(data & 0xff00) << 2
(data & 0x00ff) << 10

(d15:8 -> D17:10, d7:0 -> D17:10)

However, when writing a 8-bit command to a DBI panel in either 16- or 8-bits 
mode, there would be a single write with

d7:0 -> D7:0

How to shift the data thus depends both on the bus width and on which data 
lines the panel expects data to be present.

I wrote drivers for two DBI panels based on existing board code, the R61505 
and the R61517.

The R61505 datasheet is available online, the panel is a SYS-80 panel that 
supports 8-, 9-, 16- and 18-bits bus widths. It aligns data towards the MSB 
when using a bus width lower than 18.

The R61517 datasheet doesn't seem to be freely available. The panel seems to 
be DBI-compliant as it uses a subset of the DCS commands and a wide range of 
panel-specific commands. The panel is connected using a 16-bit bus, all 
commands and parameters are 8-bits wide and aligned towards the LSB.

To properly transfer commands and parameters, the DBI host will need to know 
on how many bits to perform transfers, and how to align data on the bus. For 
the former, your mipi_dbi_set_bus_width() function could be used, although 
probably not out of the box. The R61505 panel would call 
mipi_dbi_set_bus_width() to set the bus width to 16 (as commands and 
parameters are 16-bits wide), but if the panel is connected using only 8 or 9 
data lines, the host would need to split the 16-bits writes into two 8-bits 
writes. Should that be done transparently ? mipi_dbi_set_bus_width() could 
possibly act as a mipi_dbi_set_max_bus_width(), but that might be a bit too 
hackish.

I'd like to hide as much of the complexity as possible in mipi-dbi-bus.c but I 
don't know whether that's possible.

> The omap driver actually only implements 8 and 16 bit modes, not the 9 and
> 12 bit modes. I'm not sure what kind of shifting is needed for those.

There's no 12-bits mode in DBI-2 as far as I can tell.

We will need to support 8-, 9- and 16-bits modes for DBI-2, and additionally 
18-bits mode for SYS-80.

> > > > We might just need to provide fake timings. Video mode timings are at
> > > > the core of display support in all drivers so we can't just get rid of
> > > > them. The h/v front/back porch and sync won't be used by display
> > > > drivers for DBI/DSI panels anyway.
> > > 
> > > Right. But we should probably think if we can, at the panel level,
> > > easily separate conventional panels and smart panels. Then this
> > > framework wouldn't need to fake the timings, and it'd be up to the
> > > higher level to decide if and how to fake them. Then again, this is no
> > > biggie. Just thought that at the lowest level it'd be nice to be
> > > "correct" and leave faking to upper layers =).
> > 
> > But we would then have two different APIs at the lower level depending on
> > the panel type. I'm not sure that's a good thing.
> 
> Different API for what? Why anyway need panel type specific functions.
> In the panel struct we could just have an union of the different types
> of parameters for different types of panels.
> 
> But if this complicates things, it's not a biggie. Just something that
> has been in my mind when dealing with smart panels and assigning dummy
> video timings for them =).

Please feel free to make a proposal for this when I'll post v2. A patch would 
be nice :-)

-- 
Regards,

Laurent Pinchart

