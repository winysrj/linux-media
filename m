Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2233 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbZH2ObW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2009 10:31:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: RFC: bus configuration setup for sub-devices
Date: Sat, 29 Aug 2009 16:31:13 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Laurent Pinchart <laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908291631.13696.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is an updated RFC on how to setup the bus for sub-devices.

It is based on work from Guennadi and Muralidharan.

The problem is that both sub-devices and bridge devices have to configure
their bus correctly so that they can talk to one another. We need a
standard way of configuring such busses.

The soc-camera driver did this by auto-negotiation. For several reasons (see
the threads on bus parameters in the past) I thought that that was not a good
idea. After talking this over last week with Guennadi we agreed that we would
configure busses directly rather than negotiate the bus configuration. It was
a very pleasant meeting (Hans de Goede, Laurent Pinchart, Guennadi Liakhovetski
and myself) and something that we should repeat. Face-to-face meetings make
it so much faster to come to a decision on difficult problems.

My last proposal merged subdev and bridge parameters into one struct, thus
completely describing the bus setup. I realized that there is a problem with
that if you have to define the bus for sub-devices that are in the middle of
a chain: e.g. a sensor sends its video to a image processing subdev and from
there it goes to the bridge. You have to be able to specify both the source and
sink part of each bus for that image processing subdev.

It's much easier to do that by keeping the source and sink bus config
separate.

Here is my new proposal:

/*
 * Some sub-devices are connected to the host/bridge device through a bus that
 * carries the clock, vsync, hsync and data. Some interfaces such as BT.656
 * carries the sync embedded in the data whereas others have separate lines
 * carrying the sync signals.
 */
struct v4l2_bus_config {
        /* embedded sync, set this when sync is embedded in the data stream */
        unsigned embedded_sync:1;
        /* master or slave */
        unsigned is_master:1;

        /* bus width */
        unsigned width:8;
        /* 0 - active low, 1 - active high */
        unsigned pol_vsync:1;
        /* 0 - active low, 1 - active high */
        unsigned pol_hsync:1;
        /* 0 - low to high, 1 - high to low */
        unsigned pol_field:1;
        /* 0 - sample at falling edge, 1 - sample at rising edge */
        unsigned edge_pclock:1;
        /* 0 - active low, 1 - active high */
        unsigned pol_data:1;
};

It's all bitfields, so it is a very compact representation.

In video_ops we add two new functions:

     int (*s_source_bus_config)(struct v4l2_subdev *sd, const struct v4l2_bus_config *bus);
     int (*s_sink_bus_config)(struct v4l2_subdev *sd, const struct v4l2_bus_config *bus);

Actually, if there are no subdevs that can act as sinks then we should omit
s_sink_bus_config for now.

In addition, I think we need to require that at the start of the s_*_bus_config
implementation in the host or subdev there should be a standard comment
block describing the possible combinations supported by the hardware:

/* This hardware supports the following bus settings:

   widths: 8/16
   syncs: embedded or separate
   bus master: slave
   vsync polarity: 0/1
   hsync polarity: 0/1
   field polarity: not applicable
   sampling edge pixelclock: 0/1
   data polarity: 1
 */

This should make it easy for implementers to pick a valid set of bus
parameters.

Eagle-eyed observers will note that the bus type field has disappeared from
this proposal. The problem with that is that I have no clue what it is supposed
to do. Is there more than one bus that can be set up? In that case it is not a
bus type but a bus ID. Or does it determine that type of data that is being
transported over the bus? In that case it does not belong here, since that is
something for a s_fmt type API.

This particular API should just setup the physical bus. Nothing more, IMHO.

Please let me know if I am missing something here.

Guennadi, from our meeting I understood that you also want a way provide
an offset in case the data is actually only on some pins (e.g. the lower
or upper X pins are always 0). I don't think it is hard to provide support
for that in this API by adding an offset field or something like that.

Can you give me a pointer to the actual place where that is needed? Possibly
also with references to datasheets? I'd like to understand this better.

Sakari, this proposal is specific to parallel busses. I understood that Nokia
also has to deal with serial busses. Can you take a look at this proposal with
a serial bus in mind?

This bus config stuff has been in limbo for too long, so I'd like to come
to a conclusion and implementation in 1-2 weeks.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
