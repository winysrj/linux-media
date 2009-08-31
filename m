Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3606 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbZHaRmZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 13:42:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: RFC: bus configuration setup for sub-devices
Date: Mon, 31 Aug 2009 19:42:20 +0200
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Laurent Pinchart <laurent.pinchart@skynet.be>
References: <200908291631.13696.hverkuil@xs4all.nl> <4A9BF22A.1000608@maxwell.research.nokia.com>
In-Reply-To: <4A9BF22A.1000608@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908311942.20926.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 31 August 2009 17:54:18 Sakari Ailus wrote:
> Hans Verkuil wrote:
> > Hi all,
> > 
> > This is an updated RFC on how to setup the bus for sub-devices.
> > 
> > It is based on work from Guennadi and Muralidharan.
> > 
> > The problem is that both sub-devices and bridge devices have to configure
> > their bus correctly so that they can talk to one another. We need a
> > standard way of configuring such busses.
> > 
> > The soc-camera driver did this by auto-negotiation. For several reasons (see
> > the threads on bus parameters in the past) I thought that that was not a good
> > idea. After talking this over last week with Guennadi we agreed that we would
> > configure busses directly rather than negotiate the bus configuration. It was
> > a very pleasant meeting (Hans de Goede, Laurent Pinchart, Guennadi Liakhovetski
> > and myself) and something that we should repeat. Face-to-face meetings make
> > it so much faster to come to a decision on difficult problems.
> > 
> > My last proposal merged subdev and bridge parameters into one struct, thus
> > completely describing the bus setup. I realized that there is a problem with
> > that if you have to define the bus for sub-devices that are in the middle of
> > a chain: e.g. a sensor sends its video to a image processing subdev and from
> > there it goes to the bridge. You have to be able to specify both the source and
> > sink part of each bus for that image processing subdev.
> > 
> > It's much easier to do that by keeping the source and sink bus config
> > separate.
> > 
> > Here is my new proposal:
> > 
> > /*
> >  * Some sub-devices are connected to the host/bridge device through a bus that
> >  * carries the clock, vsync, hsync and data. Some interfaces such as BT.656
> >  * carries the sync embedded in the data whereas others have separate lines
> >  * carrying the sync signals.
> >  */
> > struct v4l2_bus_config {
> >         /* embedded sync, set this when sync is embedded in the data stream */
> >         unsigned embedded_sync:1;
> >         /* master or slave */
> >         unsigned is_master:1;
> > 
> >         /* bus width */
> >         unsigned width:8;
> >         /* 0 - active low, 1 - active high */
> >         unsigned pol_vsync:1;
> >         /* 0 - active low, 1 - active high */
> >         unsigned pol_hsync:1;
> >         /* 0 - low to high, 1 - high to low */
> >         unsigned pol_field:1;
> >         /* 0 - sample at falling edge, 1 - sample at rising edge */
> >         unsigned edge_pclock:1;
> >         /* 0 - active low, 1 - active high */
> >         unsigned pol_data:1;
> > };
> 
> How about the clock of the parallel interface?

I consider that part of the video format setup: e.g. if you want 720p, then
you can setup the timings (i.e. pixelclock, front/backporch, sync widths)
accordingly. This API just configures the bus.

> 
> I have to admit I haven't had time to read the thread about bus 
> parameter negotiation.
> 
> The above parameters are probably valid for a number of possible 
> parallel buses. Serial buses like CSI1 (CCP2) and CSI2 do have a 
> different set of parameters, some of these are meaningless in CSI1 and 
> CSI 2 context, like width. The bus specification already might define 
> some, too.
> 
> I think there could be an union for different bus types, and a field 
> that tells which type is the bus of.
> 
> CSI 1 is a subset of CCP 2 which include at least this:
> 
> - CRC enabled / disabled
> - CSI 1 / CCP 2 mode
> - channel
> - data + clock or data + strobe signalling
> - strobe clock inverted / not
> - clock
> - bits per pixel (bayer); 8, 10 or 12
> - frame start / end and line start / end sync codes

These last two items do not belong here: those are concerned with what is
going over the bus, not with the bus configuration itself. I'm not sure what
you mean with 'clock': the clock frequency? A pixel clock is usually part of
the video setup as it depends on the chosen video format.

> 
> There's more in the OMAP 3 ISP TRM here, as Laurent pointed out:
> 
> <URL:http://focus.ti.com/pdfs/wtbu/SWPU114U_FinalEPDF_08_17_2009.pdf>
> 
> The CSI 1 also defines image formats, line size and line start, see page 
> 1548.
> 
> I did try to define the bus parameters in the OMAP 2 camera and there's 
> some of that in include/media/v4l2-int-device.h but the bus parameters 
> are again different for OMAP 3 ISP so we then resorted to just have a 
> configuration that is specific to the ISP (or the bridge, I guess).
> 
> The disadvantage is then that the sensor is not part of this 
> configuration, so a generic way of expressing bus configuration really 
> has an advantage.
> 
> > It's all bitfields, so it is a very compact representation.
> > 
> > In video_ops we add two new functions:
> > 
> >      int (*s_source_bus_config)(struct v4l2_subdev *sd, const struct v4l2_bus_config *bus);
> >      int (*s_sink_bus_config)(struct v4l2_subdev *sd, const struct v4l2_bus_config *bus);
> > 
> > Actually, if there are no subdevs that can act as sinks then we should omit
> > s_sink_bus_config for now.
> 
> I hope that could one day include the OMAP 3 ISP. :-)
> 
> > In addition, I think we need to require that at the start of the s_*_bus_config
> > implementation in the host or subdev there should be a standard comment
> > block describing the possible combinations supported by the hardware:
> > 
> > /* This hardware supports the following bus settings:
> > 
> >    widths: 8/16
> >    syncs: embedded or separate
> >    bus master: slave
> >    vsync polarity: 0/1
> >    hsync polarity: 0/1
> >    field polarity: not applicable
> >    sampling edge pixelclock: 0/1
> >    data polarity: 1
> >  */
> > 
> > This should make it easy for implementers to pick a valid set of bus
> > parameters.
> > 
> > Eagle-eyed observers will note that the bus type field has disappeared from
> > this proposal. The problem with that is that I have no clue what it is supposed
> > to do. Is there more than one bus that can be set up? In that case it is not a
> > bus type but a bus ID. Or does it determine that type of data that is being
> > transported over the bus? In that case it does not belong here, since that is
> > something for a s_fmt type API.
> 
> The bus type should be definitely included. If a bridge has several 
> different receivers, say parallel, CSI1 and CSI2, which of them should 
> be configured to receive data unless that's part of the bus configuration?

Yeah, I see that omap supports one parallel and two serial busses, so we need
something for that.

> 
> > This particular API should just setup the physical bus. Nothing more, IMHO.
> 
> How would the image format be defined then...? The ISP in this case can 
> mangle the image format the way it wants so what's coming from the 
> sensor can be quite different from what's coming out of the ISP. Say, 
> sensor produces raw bayer and ISP writes YUYV, for example. Usually the 
> format the sensor outputs is not defined by the input format the user 
> wants from the device.

The image format is something that should be setup by a separate API. Guennadi
has a proposal for that which is being discussed. Although I wonder whether
these two APIs should perhaps be combined into one. Don't know yet.

In particular I wonder whether the bus width shouldn't become part of the image
format API rather than the bus configuration.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
