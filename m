Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3597 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbZIMN7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 09:59:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: RFC: bus and data format negotiation
Date: Sun, 13 Sep 2009 15:59:41 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@skynet.be>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909131559.41777.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(I promised that I would analyze this. Sorry that it took so long, but I
had a lot of other things going on and this was one topic that I needed to
really sit down for and think about carefully.)

RFC: bus and data format negotiation

Version 1.0


Background
==========

As media boards become more complex it is getting harder to enumerate and
setup the busses that connect the various components on the board and to
map that to actual pixelformats (i.e. how the data will end up in memory).

This is a particular problem for sensors that can often be connected in
many different ways.

Several attempts have been made to find a good internal API for this, but
none were satisfactory.

In this RFC I'll analyze how such connections are made, what the core problems
are and I'll present a solution that hopefully solves these problems in a
well-defined and not too complex way. This RFC is directly related to open
issue #3 in the media controller RFC.


Analysis
========

In general you have two components, A and B, and some sort of a bus between
them (i.e. the physical wires). This can be straightforward, e.g. 10 pins
on either side are directly connected, or there can be additional components
in between like level converters or perhaps even complex FPGAs that are not
under our control but that nevertheless can make changes in how the data is
presented. While information on such components may not be available at the
driver level, it is available at platform (board) level.

More complex boards have more than two components and multiple busses, but
many of the basics remain the same.


Bus configuration
-----------------

In order to setup a component you will need to supply a bus configuration
that sets up the physical properties of the bus: signal polarities, how the
data should be sampled, etc.

In many cases there is only one possible bus configuration. But especially
sensors have more configurations. This configuration should come from the
board specification and not be autonegotiated. Depending on the board layout
a wrong bus configuration can have quite unpredictable results. Even though
both sides of the bus may seemingly support a specific configuration additional
board-specific factors may prevent that configuration from working reliably.


Data formats
------------

For a given bus configuration a component can support one or more data
formats. A data format is similar, but not identical, to a pixel format. A
pixel format defines the format of the video in memory. A data format defines
the format of the video on a bus. The component's driver will know which data
formats it supports given the bus config.

Note that changing the bus config on the fly will also change the list of
supported data formats. Normally a bus config is setup once and not changed,
but this is not necessarily always the case.


Video timings
-------------

Once the bus is configured and the data format is set it is finally possible
to determine what resolutions and framerates are supported. Here we run into
a problem, though. The current V4L2 API is not clear on how that should be
done.

We have three enumeration ioctls involved in this: either VIDIOC_ENUMSTD to
enumerate the supported video standards for analog TV video encoders and
decoders, and VIDIOC_ENUM_FRAMESIZES/FRAMEINTERVALS to enumerate native
sensor resolutions and framerates. Unfortunately the spec is not clear whether
ENUM_FRAMESIZES/INTERVALS really refers to the sensor (or more general, the
component that is the initial source of the video stream) or to the sizes
and framerates that you can capture on the video node.

What makes this worse is that there is an essential ioctl missing: you need
to have the equivalent of VIDIOC_S_STD to setup a sensor to a specific
resolution/framerate. Right now VIDIOC_S_FMT is used for that, but that is
really meant to take an input resolution and scale it up or down to the
desired resolution. It is not meant to setup a sensor (or video source or sink
in general) to a particular resolution.

To fix this we need to 1) specify that the framesize/interval enumeration
relates to the video source and not to the output of a possible scaler, and
2) add support for setting up a sensor to a specific size/framerate. Murali 
Karicheri from TI is working on something similar.

Using S_FMT to select a particular resolution never felt right, and now I
realize why. Luckily I don't think any of the webcam drivers we have currently
do any scaling, so using S_FMT will still work for those and applications do
not need to be modified.

To do the sensor setup in the new-style we can either introduce a new ioctl
to specify the size and use VIDIOC_S_PARM (yuck!) to setup the framerate, or
we use the new video timings ioctl that Murali is working on.


Data format negotiation
-----------------------

Depending on the bus configuration a component supports a list of data formats.
The next step is to somehow coordinate both sides of the bus to select
compatible data formats. In many cases you can just go through the supported
data formats and find matches. But this is not true in general. A generic
camera framework like soc-camera either needs an optional mapping table that
is supplied by the board configuration, or it should be given a callback
function that can be implemented at the board level to do the matching for
soc-camera (and if no function is supplied it can fallback to a default
matching function).

A simple example where matching would fail is if the sensor is sending on
8 pins and the SoC receives it on 12 pins (with the lowest 4 pins pulled
down). So the data format from the sensor is some 8 bit Bayer format, while
the SoC receives a 12 bit Bayer format. You can try all sorts of fancy
heuristics to solve such problems, but in my opinion that will never be able
to fully solve this data format negotiation. In the end the board designer
knows exactly how to match it up, and so it is best to place the matching code
at the level where that information is actually available: the platform code.

This type of data format matching works well in simple situations (e.g. a
sensor connected to a SoC), but when you have a network of components all
talking to one another it becomes impossible to manage that in a driver.

Using the media controller it should be possible to setup the data format
for a sub-device directly. Obviously, this only makes sense for SoCs.
In theory one could also setup the bus configuration that way, but I feel
uncomfortable doing that. This really belongs at the platform level.

Note that when dealing with a SoC that e.g. connects a previewer component
to a resizer component internally it is the responsibility of the SoC driver
to select the data formats. This will not come from platform data, since this
is a SoC-internal connection. Whether to allow an application to explicitly
set the data format in this case is something that the SoC driver developer
will have to decide.


Pixel formats
-------------

Until now we have been talking about data formats. But the end-user only sees
pixel formats. A pixel format defines uniquely how the video will be formatted
in memory. The translation from a data format to memory is generally done by
a DMA engine. A single data format can be DMAed into memory in potentially
several ways, depending on the setup of the DMA engine.

In many of our TV and webcam drivers there is only one data format (usually
the default format, and often only format, available by the various components).

So effectively the pixel enumeration maps that single data format to a set of
pixel formats. And selecting a pixel format just changes the DMA engine and
not the internal data format.

For a complex device it may become very hard to generate a full list of all
the possible pixel formats supported by all the possible data formats and DMA
engine settings. This can easily explode into an unmanagable list, not to
mention very difficult driver code. And does anyone really care about 200
possible pixel formats?

I would suggest that every driver should enumerate the available pixel formats
for the selected data format of the DMA engine. Some drivers might have
additional information that allows them to extend that to more pixel formats
and setup the data format based on the selected pixel format. For example,
soc-camera might achieve that if the platform code will provide it with a
table that maps pixel formats to data formats (a data format for the SoC and
one for the sensor).

A full list of pixel formats will typically be more important for consumer
market devices than for SoCs, so it is up to the driver to decide what is
best here.


Video nodes supporting input and output
---------------------------------------

There is a special case that is currently not implemented, but it will be
in the near future: stand-alone scalers and similar devices. These will have
a single device node that a driver can send data to, then the data is
transformed in some way and you get back the result.

How to enumerate pixel formats in this case? If you set the input pixel format
to X, then the set of possible pixel formats on the output might be different
compared to input pixel format Y. Ditto if you enumerate input pixel formats
based on a selected output pixel format.

In both cases you still want to enumerate all supported formats, but you also
want to know which match the chosen format 'on the other side'. I propose that
we add a new flag to the struct v4l2_fmtdesc flags field: V4L2_FMT_FLAG_INVALID.

This is only set if the enumerated pixel format is not currently valid compared
to the chosen opposite pixel format. In principle this flag is only set for
such input and output video nodes and not for others.


Summary
=======

Based on this lengthy analysis I propose the following:

1) We add a v4l2-subdev API to setup bus configurations. This configuration
comes from the board specification.

2) Each sub-device will support a list of data formats depending on the bus
configuration. This is stored in the subdev driver.

3) A data format can either be setup explicitly through a media controller
or it is negotiated. You may need to do the matching via a callback to
platform code.

4) Restrict VIDIOC_ENUM_FRAMESIZES/INTERVALS to what is available on the
sensor (or video source/sink in general). It should have similar semantics to
VIDIOC_ENUMSTD.

5) We need a new API to setup a sensor directly and not rely on S_FMT to
do that for us since that is ambiguous when there is also a scaler in the
pipeline. A new API to setup digital video timings is being worked on and
can probably be used for this.

6) All drivers will enumerate those pixel formats supported for the currently
selected data format of the DMA engine. Optionally, some drivers may extend
that to other data formats as well as long as they know how to setup the board
to support the new pixel format.

7) For input/output video nodes the enumerated pixel formats will include a
new flag that tells the application whether the pixel format is invalid if
it does not match the pixel format on the other side. Obviously, the video
node will only work if both pixel formats are valid.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
