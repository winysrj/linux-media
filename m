Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:34419 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbZHaPy3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 11:54:29 -0400
Message-ID: <4A9BF22A.1000608@maxwell.research.nokia.com>
Date: Mon, 31 Aug 2009 18:54:18 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: Re: RFC: bus configuration setup for sub-devices
References: <200908291631.13696.hverkuil@xs4all.nl>
In-Reply-To: <200908291631.13696.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
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

How about the clock of the parallel interface?

I have to admit I haven't had time to read the thread about bus 
parameter negotiation.

The above parameters are probably valid for a number of possible 
parallel buses. Serial buses like CSI1 (CCP2) and CSI2 do have a 
different set of parameters, some of these are meaningless in CSI1 and 
CSI 2 context, like width. The bus specification already might define 
some, too.

I think there could be an union for different bus types, and a field 
that tells which type is the bus of.

CSI 1 is a subset of CCP 2 which include at least this:

- CRC enabled / disabled
- CSI 1 / CCP 2 mode
- channel
- data + clock or data + strobe signalling
- strobe clock inverted / not
- clock
- bits per pixel (bayer); 8, 10 or 12
- frame start / end and line start / end sync codes

There's more in the OMAP 3 ISP TRM here, as Laurent pointed out:

<URL:http://focus.ti.com/pdfs/wtbu/SWPU114U_FinalEPDF_08_17_2009.pdf>

The CSI 1 also defines image formats, line size and line start, see page 
1548.

I did try to define the bus parameters in the OMAP 2 camera and there's 
some of that in include/media/v4l2-int-device.h but the bus parameters 
are again different for OMAP 3 ISP so we then resorted to just have a 
configuration that is specific to the ISP (or the bridge, I guess).

The disadvantage is then that the sensor is not part of this 
configuration, so a generic way of expressing bus configuration really 
has an advantage.

> It's all bitfields, so it is a very compact representation.
> 
> In video_ops we add two new functions:
> 
>      int (*s_source_bus_config)(struct v4l2_subdev *sd, const struct v4l2_bus_config *bus);
>      int (*s_sink_bus_config)(struct v4l2_subdev *sd, const struct v4l2_bus_config *bus);
> 
> Actually, if there are no subdevs that can act as sinks then we should omit
> s_sink_bus_config for now.

I hope that could one day include the OMAP 3 ISP. :-)

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

The bus type should be definitely included. If a bridge has several 
different receivers, say parallel, CSI1 and CSI2, which of them should 
be configured to receive data unless that's part of the bus configuration?

> This particular API should just setup the physical bus. Nothing more, IMHO.

How would the image format be defined then...? The ISP in this case can 
mangle the image format the way it wants so what's coming from the 
sensor can be quite different from what's coming out of the ISP. Say, 
sensor produces raw bayer and ISP writes YUYV, for example. Usually the 
format the sensor outputs is not defined by the input format the user 
wants from the device.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
