Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:53257 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbZINOSg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 10:18:36 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@skynet.be>
Date: Mon, 14 Sep 2009 09:18:30 -0500
Subject: RE: RFC: bus and data format negotiation
Message-ID: <A69FA2915331DC488A831521EAE36FE401550D0FCE@dlee06.ent.ti.com>
References: <200909131559.41777.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.0909132241290.11038@axis700.grange>
 <200909132353.32050.hverkuil@xs4all.nl>
In-Reply-To: <200909132353.32050.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> >
>> > Video timings
>> > -------------
>> >
>> > Once the bus is configured and the data format is set it is finally
>possible
>> > to determine what resolutions and framerates are supported. Here we run
>into
>> > a problem, though. The current V4L2 API is not clear on how that should
>be
>> > done.
>> >
>> > We have three enumeration ioctls involved in this: either
>VIDIOC_ENUMSTD to
>> > enumerate the supported video standards for analog TV video encoders
>and
>> > decoders, and VIDIOC_ENUM_FRAMESIZES/FRAMEINTERVALS to enumerate native
>> > sensor resolutions and framerates. Unfortunately the spec is not clear
>whether
>> > ENUM_FRAMESIZES/INTERVALS really refers to the sensor (or more general,
>the
>> > component that is the initial source of the video stream) or to the
>sizes
>> > and framerates that you can capture on the video node.
>> >
>> > What makes this worse is that there is an essential ioctl missing: you
>need
>> > to have the equivalent of VIDIOC_S_STD to setup a sensor to a specific
>> > resolution/framerate. Right now VIDIOC_S_FMT is used for that, but that
>is
>> > really meant to take an input resolution and scale it up or down to the
>> > desired resolution. It is not meant to setup a sensor (or video source
>or sink
>> > in general) to a particular resolution.
>> >
>> > To fix this we need to 1) specify that the framesize/interval
>enumeration
>> > relates to the video source and not to the output of a possible scaler,
>and
>> > 2) add support for setting up a sensor to a specific size/framerate.
>Murali
>> > Karicheri from TI is working on something similar.
>> >
>> > Using S_FMT to select a particular resolution never felt right, and now
>I
>> > realize why. Luckily I don't think any of the webcam drivers we have
>currently
>> > do any scaling, so using S_FMT will still work for those and
>applications do
>> > not need to be modified.
>> >
>> > To do the sensor setup in the new-style we can either introduce a new
>ioctl
>> > to specify the size and use VIDIOC_S_PARM (yuck!) to setup the
>framerate, or
>> > we use the new video timings ioctl that Murali is working on.
>>
>> As yet one more example for your collection: I have an configuration with
>> a sensor, that has a DSP in it. The sensor itself can perform scaling,
>the
>> DSP has three (!) resizing algorithms, and the SoC can scale too...
>>
>> > Data format negotiation
>> > -----------------------
>> >
>> > Depending on the bus configuration a component supports a list of data
>formats.
>> > The next step is to somehow coordinate both sides of the bus to select
>> > compatible data formats. In many cases you can just go through the
>supported
>> > data formats and find matches. But this is not true in general. A
>generic
>> > camera framework like soc-camera either needs an optional mapping table
>that
>> > is supplied by the board configuration, or it should be given a
>callback
>> > function that can be implemented at the board level to do the matching
>for
>> > soc-camera (and if no function is supplied it can fallback to a default
>> > matching function).
>> >
>> > A simple example where matching would fail is if the sensor is sending
>on
>> > 8 pins and the SoC receives it on 12 pins (with the lowest 4 pins
>pulled
>> > down). So the data format from the sensor is some 8 bit Bayer format,
>while
>> > the SoC receives a 12 bit Bayer format. You can try all sorts of fancy
>> > heuristics to solve such problems, but in my opinion that will never be
>able
>> > to fully solve this data format negotiation. In the end the board
>designer
>> > knows exactly how to match it up, and so it is best to place the
>matching code
>> > at the level where that information is actually available: the platform
>code.
>>
>> A better example is the one, that I've already mentioned several times:
>> the sensor can only send 10 bits, they are connected directly to an SoC,
>> that can sample 8, 9, or 10 data lines, but it always samples least
>> significant ones. So, in this configuration only 10-bit data would be
>> functional. But there's also an i2c multiplexer in between, thatcan
>switch
>> D9..D2 sensor outputs to D7..D0 SoC inputs, thus letting it also support
>> 8-bit data.
>>
>> So, in this case:
>>
>> 1. the sensor shall honestly say "I can only send 10-bit data."
>>
>> 2. the platform callback shall make this to "you can get 8- or 10-bit
>data
>> from the sensor."
>>
>> 3. when actually configuring that 8-bit format, the platform code shall
>> operate the switch and further issue a call to the sensor to set up the
>> 10-bit data format.
>
>Exactly. Using a callback is probably the most flexible way of doing this.
>
>> > This type of data format matching works well in simple situations (e.g.
>a
>> > sensor connected to a SoC), but when you have a network of components
>all
>> > talking to one another it becomes impossible to manage that in a driver.
>> >
>> > Using the media controller it should be possible to setup the data
>format
>> > for a sub-device directly. Obviously, this only makes sense for SoCs.
>> > In theory one could also setup the bus configuration that way, but I
>feel
>> > uncomfortable doing that. This really belongs at the platform level.
>> >
>> > Note that when dealing with a SoC that e.g. connects a previewer
>component
>> > to a resizer component internally it is the responsibility of the SoC
>driver
>> > to select the data formats. This will not come from platform data,
>since this
>> > is a SoC-internal connection. Whether to allow an application to
>explicitly
>> > set the data format in this case is something that the SoC driver
>developer
>> > will have to decide.
>> >
>> >
>> > Pixel formats
>> > -------------
>> >
>> > Until now we have been talking about data formats. But the end-user
>only sees
>> > pixel formats. A pixel format defines uniquely how the video will be
>formatted
>> > in memory. The translation from a data format to memory is generally
>done by
>> > a DMA engine. A single data format can be DMAed into memory in
>potentially
>> > several ways, depending on the setup of the DMA engine.
>> >
>> > In many of our TV and webcam drivers there is only one data format
>(usually
>> > the default format, and often only format, available by the various
>components).
>> >
>> > So effectively the pixel enumeration maps that single data format to a
>set of
>> > pixel formats. And selecting a pixel format just changes the DMA engine
>and
>> > not the internal data format.
>> >
>> > For a complex device it may become very hard to generate a full list of
>all
>> > the possible pixel formats supported by all the possible data formats
>and DMA
>> > engine settings. This can easily explode into an unmanagable list, not
>to
>> > mention very difficult driver code. And does anyone really care about
>200
>> > possible pixel formats?
>> >
>> > I would suggest that every driver should enumerate the available pixel
>formats
>> > for the selected data format of the DMA engine.
>>
>> I use the term "packing algorithm" here, and, I think, it better
>describes
>> the process of transferring data from the bus to RAM than "data format of
>> the DMA engine." The DMA engine does not care what data is on the bus. It
>> can be a valid configuration to apply one specific packing algorithm to
>> different data formats.
>
>That's true, but I don't see the relevance to be honest.
>
>> > Some drivers might have
>> > additional information that allows them to extend that to more pixel
>formats
>> > and setup the data format based on the selected pixel format. For
>example,
>> > soc-camera might achieve that if the platform code will provide it with
>a
>> > table that maps pixel formats to data formats (a data format for the
>SoC and
>> > one for the sensor).
>>
>> What do you mean by the data format for the SoC? A packing algorithm?
>
>You typically have this component chain:
>
>sensor -> SoC -> memory
>
>So in order to get a certain pixel format you will have to select which
>data
>format the sensor is sending and which data format the SoC is expecting
>(i.e.
>a data format that can be packed into memory according to the specified
>pixel
>format). So with 'data format of the SoC' I mean the data format that the
>SoC
>sees from the sensor. Which will often, but not always, be identical to
>that
>used by the sensor.
>
>> > A full list of pixel formats will typically be more important for
>consumer
>> > market devices than for SoCs, so it is up to the driver to decide what
>is
>> > best here.
>> >
>> >
>> > Video nodes supporting input and output
>> > ---------------------------------------
>> >
>> > There is a special case that is currently not implemented, but it will
>be
>> > in the near future: stand-alone scalers and similar devices. These will
>have
>> > a single device node that a driver can send data to, then the data is
>> > transformed in some way and you get back the result.
>> >
>> > How to enumerate pixel formats in this case? If you set the input pixel
>format
>> > to X, then the set of possible pixel formats on the output might be
>different
>> > compared to input pixel format Y. Ditto if you enumerate input pixel
>formats
>> > based on a selected output pixel format.
>> >
>> > In both cases you still want to enumerate all supported formats, but
>you also
>> > want to know which match the chosen format 'on the other side'. I
>propose that
>> > we add a new flag to the struct v4l2_fmtdesc flags field:
>V4L2_FMT_FLAG_INVALID.
>> >
>> > This is only set if the enumerated pixel format is not currently valid
>compared
>> > to the chosen opposite pixel format. In principle this flag is only set
>for
>> > such input and output video nodes and not for others.
>> >
>> >
>> > Summary
>> > =======
>> >
>> > Based on this lengthy analysis I propose the following:
>> >
>> > 1) We add a v4l2-subdev API to setup bus configurations. This
>configuration
>> > comes from the board specification.
>> >
>> > 2) Each sub-device will support a list of data formats depending on the
>bus
>> > configuration. This is stored in the subdev driver.
>> >
>> > 3) A data format can either be setup explicitly through a media
>controller
>> > or it is negotiated. You may need to do the matching via a callback to
>> > platform code.
>> >
>> > 4) Restrict VIDIOC_ENUM_FRAMESIZES/INTERVALS to what is available on
>the
>> > sensor (or video source/sink in general). It should have similar
>semantics to
>> > VIDIOC_ENUMSTD.
>> >
>> > 5) We need a new API to setup a sensor directly and not rely on S_FMT
>to
>> > do that for us since that is ambiguous when there is also a scaler in
>the
>> > pipeline. A new API to setup digital video timings is being worked on
>and
>> > can probably be used for this.
>>
>> You mean a new user-space API (ioctl)? Don't think this is a good idea, I
>> would leave it to the drivers, in case only /dev/videoX is used, and to
>> the future media controller API.
>
>We have to. How else can a application tell the sensor what resolution to
>use?
>S_FMT tells what it should receive, but if there is a scaler in the
>pipeline,
>then what are you controlling? The sensor or the scaler?


For ip net cam applications, application would require the sensor 
to capture at a specific fps and resolution similar to S_STD. I think
we could use the ioctl I have proposed in my RFC (Posted today morning) for this. Using S_FMT for timing is a kludge way of doing the same thing.

>
>We need the new ioctls anyway to control digital video timings for HDTV
>support. It's being worked on by TI. That same API can hopefully also be
>used


I have posted this today morning to the linux-media mailing list.

>to setup sensors. It's really the missing piece in all this.
>
>Note that this will obviously not help you if you have multiple scalers in
>the pipeline. Then only a media controller will work where you can setup
>each
>scaler in turn.
>
>> > 6) All drivers will enumerate those pixel formats supported for the
>currently
>> > selected data format of the DMA engine. Optionally, some drivers may
>extend
>> > that to other data formats as well as long as they know how to setup
>the board
>> > to support the new pixel format.
>> >
>> > 7) For input/output video nodes the enumerated pixel formats will
>include a
>> > new flag that tells the application whether the pixel format is invalid
>if
>> > it does not match the pixel format on the other side. Obviously, the
>video
>> > node will only work if both pixel formats are valid.
>>
>> So, you will have to enumerate output formats after each S_FMT for an
>> input format and v.v.?
>
>Yes. I know, not the most efficient approach perhaps, but it's simple and
>it
>works and it does not require any new ioctls.
>
>Regards,
>
>	Hans
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

