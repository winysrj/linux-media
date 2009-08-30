Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53684 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751421AbZH3WTf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 18:19:35 -0400
Date: Mon, 31 Aug 2009 00:19:38 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: Re: RFC: bus configuration setup for sub-devices
In-Reply-To: <200908291631.13696.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0908300109490.16132@axis700.grange>
References: <200908291631.13696.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 29 Aug 2009, Hans Verkuil wrote:

> Hi all,
> 
> This is an updated RFC on how to setup the bus for sub-devices.
> 
> It is based on work from Guennadi and Muralidharan.
> 
> The problem is that both sub-devices and bridge devices have to configure
> their bus correctly so that they can talk to one another. We need a
> standard way of configuring such busses.
> 
> The soc-camera driver did this by auto-negotiation. For several reasons (see
> the threads on bus parameters in the past) I thought that that was not a good
> idea. After talking this over last week with Guennadi we agreed that we would
> configure busses directly rather than negotiate the bus configuration. It was
> a very pleasant meeting (Hans de Goede, Laurent Pinchart, Guennadi Liakhovetski
> and myself) and something that we should repeat. Face-to-face meetings make
> it so much faster to come to a decision on difficult problems.
> 
> My last proposal merged subdev and bridge parameters into one struct, thus
> completely describing the bus setup. I realized that there is a problem with
> that if you have to define the bus for sub-devices that are in the middle of
> a chain: e.g. a sensor sends its video to a image processing subdev and from
> there it goes to the bridge. You have to be able to specify both the source and
> sink part of each bus for that image processing subdev.
> 
> It's much easier to do that by keeping the source and sink bus config
> separate.
> 
> Here is my new proposal:
> 
> /*
>  * Some sub-devices are connected to the host/bridge device through a bus that
>  * carries the clock, vsync, hsync and data. Some interfaces such as BT.656
>  * carries the sync embedded in the data whereas others have separate lines
>  * carrying the sync signals.
>  */
> struct v4l2_bus_config {
>         /* embedded sync, set this when sync is embedded in the data stream */
>         unsigned embedded_sync:1;
>         /* master or slave */
>         unsigned is_master:1;

Up to now I usually saw the master-slave relationship defined as per 
whether the protocol is "master" or "slave," which always was used from 
the PoV of the bridge. I.e., even in a camera datasheet a phrase like 
"supports master-parallel mode" means supports a mode in which the bridge 
is a master and the camera is a slave. So, maybe it is better instead of a 
.is_master flag to use a .master_mode flag?

Besides, aren't there any other bus synchronisation models apart from

data + master clock + pixel clock + hsync + vsync
and
data + master clock + pixel clock + embedded sync

? For example, we should be able to specify, that field is not connected?

> 
>         /* bus width */
>         unsigned width:8;
>         /* 0 - active low, 1 - active high */
>         unsigned pol_vsync:1;
>         /* 0 - active low, 1 - active high */
>         unsigned pol_hsync:1;
>         /* 0 - low to high, 1 - high to low */
>         unsigned pol_field:1;
>         /* 0 - sample at falling edge, 1 - sample at rising edge */
>         unsigned edge_pclock:1;
>         /* 0 - active low, 1 - active high */
>         unsigned pol_data:1;
> };
> 
> It's all bitfields, so it is a very compact representation.
> 
> In video_ops we add two new functions:
> 
>      int (*s_source_bus_config)(struct v4l2_subdev *sd, const struct v4l2_bus_config *bus);
>      int (*s_sink_bus_config)(struct v4l2_subdev *sd, const struct v4l2_bus_config *bus);
> 
> Actually, if there are no subdevs that can act as sinks then we should omit
> s_sink_bus_config for now.
> 
> In addition, I think we need to require that at the start of the s_*_bus_config
> implementation in the host or subdev there should be a standard comment
> block describing the possible combinations supported by the hardware:
> 
> /* This hardware supports the following bus settings:
> 
>    widths: 8/16
>    syncs: embedded or separate
>    bus master: slave
>    vsync polarity: 0/1
>    hsync polarity: 0/1
>    field polarity: not applicable
>    sampling edge pixelclock: 0/1
>    data polarity: 1
>  */
> 
> This should make it easy for implementers to pick a valid set of bus
> parameters.
> 
> Eagle-eyed observers will note that the bus type field has disappeared from
> this proposal. The problem with that is that I have no clue what it is supposed
> to do. Is there more than one bus that can be set up? In that case it is not a
> bus type but a bus ID. Or does it determine that type of data that is being
> transported over the bus? In that case it does not belong here, since that is
> something for a s_fmt type API.
> 
> This particular API should just setup the physical bus. Nothing more, IMHO.
> 
> Please let me know if I am missing something here.
> 
> Guennadi, from our meeting I understood that you also want a way provide
> an offset in case the data is actually only on some pins (e.g. the lower
> or upper X pins are always 0). I don't think it is hard to provide support
> for that in this API by adding an offset field or something like that.
> 
> Can you give me a pointer to the actual place where that is needed? Possibly
> also with references to datasheets? I'd like to understand this better.

I'll just describe to you the cases, where we need this:

1. PXA270 SoC Quick Capture Interface has 10 data lines (D9...D0) and can 
sample in raw (parallel) mode 8, 9, or 10 bits of data. However, when 
configured to capture fewer than 10 bits of data it sample not the most 
significant lines (D9...D1 or D9...D2), but the least significant ones.

2. i.MX31 SoC Camera Sensor Interface has 15 data lines (D14...D0) and can 
sample in raw (parallel) mode 8, 10, or 15 lines of data. Thereby it 
sample the most significant lines.

3. MT9M001 and MT9V022 sensors have 10 lines of data and always deliver 10 
bits of data. When directly connected D0-D0...D9-D9 to the PXA270 you can 
only sample 10 bits and not 8 bits. When similarly connected to i.MX31 
D0-D6...D9-D15 you can seamlessly configure the SoC to either capture 8 or 
10 bits of data - both will work.

4. Creative hardware engineers have supplied both these cameras with an 
i2c switch, that can switch the 8 most significant data lines of the 
sensor to the least significant lines of the interface to work with 
PXA270.

5. The current soc-camera solution for this situation seems pretty clean: 
we provide an optional callback into platform code to query bus 
parameters. On boards, using such a camera with an i2c switch this 
function returns to the sensor "you can support 8 and 10 bit modes." On 
PXA270 boards, using such a camera without a switch this function is 
either not implemented at all, or it returns the default "you can only 
provide 10 bits." Then there is another callback to actually switch 
between low and high lines by operating the I2C switch. And a third 
callback to release i2c switch resources. On i.MX31 you would implement 
the query callback as "yes, you can support 8 and 10 bits," and the switch 
callback as a dummy (or not implement at all) because you don't have to 
switch anything on i.MX31.

> Sakari, this proposal is specific to parallel busses. I understood that Nokia
> also has to deal with serial busses. Can you take a look at this proposal with
> a serial bus in mind?
> 
> This bus config stuff has been in limbo for too long, so I'd like to come
> to a conclusion and implementation in 1-2 weeks.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
