Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6INPENE008590
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 19:25:14 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6INOv9Y005225
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 19:24:58 -0400
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200807181625.12619.hverkuil@xs4all.nl>
References: <200807181625.12619.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf8
Date: Fri, 18 Jul 2008 19:23:44 -0400
Message-Id: <1216423424.2708.116.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: v4l <video4linux-list@redhat.com>
Subject: Re: RFC: Add support to query and change connections inside a
	media device
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Fri, 2008-07-18 at 16:25 +0200, Hans Verkuil wrote:
> (It seems to be RFC day today. Here's another one!)
> 
> (This RFC is also available here: http://www.xs4all.nl/~hverkuil/RFC.txt)
> 
> RFC: Add support to query and change connections inside a media device
> 
> Version 1.0
> 
> Background
> ==========
> 
> This RFC is written in cooperation with and on behalve of Texas Instruments.
> Texas Instruments sells various SoCs for the embedded market of which DaVinci 
> and DaVinciHD have been recent additions. These chips contain capture and
> display ports for which TI wrote V4L2 drivers. However, the current V4L2 API
> cannot support the full functionality of these devices, so these drivers
> had to rely on non-standard ioctls.
> 
> TI wants to get these drivers into the mainline kernel, so for that to
> happen the V4L2 API has to be enhanced to enable the full functionality
> of these devices under Linux.
> 
> This RFC will not go into much implementation detail, it describes the
> framework and a rough implementation outline, but it is intended as a
> starting point for discussion.
> 
> Also, if you can think of better terminology/names then I have, by all
> means let me know. It's always hard to find good descriptive names.
> 
> Key TI developers:
> 
> Manjunath Hadli <mrh@ti.com>
> 
> Has been working on various Video display systems and Graphics devices
> for about a decade.
> 
> Brijesh Jadav <brijesh.j@ti.com>
> Sivaraj <sivaraj@ti.com>
> Vaibhav Hiremath <hvaibhav@ti.com>
> Hardik Shah <hardik.shah@ti.com>
> 
> All of the above have been working on V4L2 drivers for TI for the past
> 2-3 years. Implemented drivers for Davinci and DavinciHD.
> 
> I want to thank them all for their help in preparing this RFC.
> 
> I would also like to emphasize that I am working on this as an independent
> v4l-dvb developer and not as employee of Tandberg Telecom AS, although I
> did get into contact with TI through my work at Tandberg.
> 
> Davinci URLs:
> 
> http://focus.ti.com/docs/prod/folders/print/tms320dm6446.html
> http://www.ti.com/litv/pdf/sprue37c (VPBE or Display IP for Davinci)
> http://focus.ti.com/dsp/docs/dspsupporttechdocsc.tsp?sectionId=3&tabId=409&familyId=1302&abstractName=sprue38c
> (VPFE or Capture Device for Davinci)
> 
> DavinciHD URLs:
> 
> http://focus.ti.com/docs/prod/folders/print/tms320dm6467.html
> http://focus.ti.com/dsp/docs/dspsupporttechdocsc.tsp?sectionId=3&tabId=409&familyId=1506&abstractName=spruer9a
> (VPIF for capture and display)
> 
> OMAP URL: (OMAP = Open Multimedia Application Platform)
> 
> http://focus.ti.com/general/docs/wtbu/wtbuproductcontent.tsp?templateId=6123&navigationId=12643&contentId=14649
> 
> 
> Terminology
> ===========
> 
> Note that the point-of-view is that of the hardware. An input to a media
> processor might be an output from the point-of-view of the application.
> 
> Note that these are abstractions. The actual hardware implementation might
> combine e.g. a decoder and a media processor into one piece of silicon. As
> an example: the cx23418 contains audio and video decoders, a media processor
> and a DVB 'decoder', all on one chip.
> 
> Media board: the actual PCI card, USB device or SoC videoport, or anything
> else that needs a V4L2/DVB/Alsa/FB driver.

The PCI spec would call this the "Subsystem".  USB looks like it calls
this the "Product".  I wouldn't think of a USB dongle as a media "board"
per se. "Board" is better than "device" and probably better than
"product", but is "subsystem" better than "board"?



> Input A/V device: this is a framebuffer or a V4L2 or alsa output device.
> Several of these inputs can be blended, composited or mixed and the result
> is then sent on to one or more encoders.

An alternative term could be "A/V Source", avoiding the logical versus
physical "device" mess.  I prefer source/sink terminology when
performing transformations (maybe it's the EE education), and I think
this is the terminology gstreamer uses as well.


> Input A/V stream: an input A/V device generates an input A/V bit stream.
> 
> Encoder: a device that takes the digital media bit stream and
> encodes it to some output format. Usually something like an 
[digitized]
> analog PAL
> or NTSC signal or an HDMI/DVI digital signal. This output is usually
> sent to one or more output connectors. Example: the NXP SAA7129.

Does the encoder definition work on a digital input or analog.  I assume
your intent was digitized input.



> Output A/V device: this a V4L2, DVB or Alsa capture device.

Again, an alternative terminology would be "A/V Sink"


> Output A/V stream: an output A/V device generates an output A/V bit stream.
> 
> Decoder: a device that takes an analog (e.g. PAL/NTSC) or digital
> (e.g. HDMI/DVI) input and decodes it to a digital media bit stream.
> Example: the NXP SAA7115.

Being pedantic:

"﻿Decoder: a device that takes a *baseband* analog (e.g. PAL/NTSC) ..."



> Output/input connector: the actual physical connector. Can be an S-Video,
> composite or audio jack connector or just pins on a chip.

How about just "physical output/input connection"?  It looks like
gstreamer uses the word "pad".

And since I keep mentioning Gstreamer, here's an article by a TI
software architect, that mentions GStreamer and DaVinci, that may be
apropos:

http://www.eetimes.com/news/design/showArticle.jhtml?articleID=193401461


> Media processor: the part of the silicon that does the actual processing
> of the bit stream. This can be demultiplexing the bit stream from a
> decoder into video, VBI and audio streams, it can be blending and compositing
> framebuffer and video output streams and sending it on to an encoder.
> It might also do effects (fading from one stream to another), MPEG decoding
> or encoding, etc. In general, it processes X input media streams and
> outputs Y media streams.

A media processor can perform "transforms" on a stream.  It may be
helpful to introduce the notion of transforms in the RFC below, since
different media processors will have different capabilities when it
comes to transforms they are able to perform.

Transforms could include: MPEG encoding, MPEG decoding, baseband video
processing (hue, brightness, saturation), baseband audio processing
(volume, balance, bass, treble), VBI functions(?), encryption,
decryption, etc.


> 
> 
> Problem description
> ===================
> 
> The core problem is that for the DaVinci and for later video devices
> multiple input video streams can be combined (composited) into one or more
> video streams which in turn can be output to one or more encoders and
> from there to one or more output connectors:
> 
> 
>  Video0----|                  |---encoder0--|--output0
>  Video1----|-->Compositor1--->|
>  Graphics0-|-->compositor2--->|---encoder1--|--output1
>  Graphics1-|                                |--output2
> 
> or:
>  
>  Video0----|-->Compositor1--->|---encoder0--|--output0
>  Video1----|                  |
>  Graphics0-|-->compositor2--->|--->compositor3|-----encoder1--|--output1
>  Graphics1-|                                                  |--output2
> 
> 
> Currently there is no way of dynamically combining multiple sources, nor
> is there a good way of doing compositing and blending (some simple forms
> of blending exist in the v4l2_framebuffer struct). Implementing this is
> required if we want to support the TI SoC devices.
> 
> A secondary problem is the difficulty of discovering which video/radio/alsa/
> dvb/fb/vbi devices do what and which devices belong to the same media
> device. 
  ^^^^^^
Do you mean "media board"?

> Currently the end-user has to specify which devices an application
> like MythTV has to use for video capture, video output, vbi handling, DVB,
> alsa, etc. But what you really want is that MythTV can just discover the
> available media boards installed and just knows which devices it has to
> use.

Automatic discovery has it's problems.  Applications like MythTV can
benefit from automatic discovery of devices and capability, but there is
currently no way to divine what input carries what signal (OTA broadcast
or cable  RF) not what output goes to what receiver device (TV set or
VCR).  

Automatic discovery would need to guarantee consistent, and perhaps
configurable, ordering of A/V inputs and A/V outputs even in the
presence of errors; or some way to uniquely and consistently identify
A/V inputs and A/V outputs to an application (a UUID or serial number)
so that the proper signals can be routed and processed in the desired
way.


> This latter problem is not specific to the new TI devices. The ivtv driver
> suffers from the same problem: a PVR-350 MPEG encoder/decoder board has
> up to 9 devices and it can be hard for a user to figure out what is what.
> 
> The proposed solution for the core problem as described below can be used
> to solve both problems.
> 
> 
> Requirement
> ===========
> 
> Remain backwards compatible. It has to be an extension of the current
> V4L2 API, and not change the existing API.
> 
> 
> Solution
> ========
> 
> 1. Media Controller
> -------------------
> 
> Both problems can be solved by creating a new media controller device
> that can be used to:
> 
> - determine the current topology of inputs/outputs/media processors
> - change that topology for devices that support it
> 
> (I'll return to the concept of a 'media processor' later)
> 
> Each /dev/v4l/controllerX device is completely independent from others,
> so any changes made by the application will never interfere/modify
> other controllers. Internal to the driver that may be another story,
> but from the application point of view each controller is independent.
> 
> E.g. the PVR-350 has both an MPEG encoder and an MPEG decoder. While
> both are independent from the application PoV, that is not the case
> inside the driver (mostly with regards to the DMA handling).
> 
> But the DaVinciHD capture and display videoports are both independent
> internally and externally and so are implemented by two distinct drivers.
> 
> 
> 2. Media Processor
> ------------------
> 
> A media board can contain several media processors. A media processor
> is a unit that takes X media streams as input, processes them in some way,
> and produces Y media stream outputs. The output from a media processor can
> serve as input for another media processor, or it can go to a linux device
> (e.g. video0) or to an encoder chip and from there to a physical video
> connector.
> 
> On most media boards there is just one 'media processor' that gets input
> from a tuner or an S-Video/line-in combination and delivers video to a
> videoX device, VBI to a vbiX device and for example audio to an alsa device
> or audio jack output:
> 
> --tuner------|                         |--/dev/video0
> --S-Video----|--decoder--|--mediaproc--|--/dev/vbi0
> --composite--|                         |--line-out jack (looped back to audio input)
> --line-in----|
> 
> [A media controller would enumerate one media processor with two output devices
> (/dev/video0 and /dev/vbi0) and no input devices.]
> 
> As long as there is only one decoder or encoder, then changing TV standard
> settings, physical input and output enumeration, etc. can be done equally
> through all V4L2 input or output devices connected to it via a media
> processor. This is the way it is currently implemented. Note that this
> implies that each V4L2 driver already has its own internal 'media controller'
> that coordinates all the connectors and devices. It's just never made
> explicit.
> 
> However, when there are multiple decoders or encoders that can work
> simultaneously, then this approach will no longer work since the V4L2 API
> does not allow us to specify which decoder or encoder to set or query.
> 
> In that case each decoder/encoder gets its own V4L2 device that cannot do
> any streaming, but can be used to query and select hue, brightness, etc.,
> possible the capture format and which connector to use. For example:
> 
> --/dev/video0--+--mediaproc--+--encoder1 (/dev/video1)--|--S-Video out
>                |             |                          \--Composite out
> --/dev/fb0-----/             |
>                              \--encoder2 (/dev/video2)--|--HDMI out
>                                                         \--DVI-D out

﻿Are transforms like encryption (which CX23418 hardware can
theoretically perform according to publicly available product briefs)
lumped into media processor or decoder or would it show up as an
explicit transform downstream of the media processor (or decoder)?


> [A media controller would enumerate one media processor with two input
> devices (/dev/video0 and /dev/fb0) and two output devices (/dev/video1 and
> /dev/video2).]
> 
> If you enumerate the output connectors for /dev/video0, then there is only
> one output connector (towards the mediaprocessor). Enumerating the input
> connectors for /dev/video1 and /dev/video2 also shows only one connector
> (from the mediaprocessor). Enumerating the output connectors for video1
> and 2 shows S-Video & Composite for video1 and HDMI & DVI-D for video2.

Would you ever need to support the case of a device being able to drive
multiple physical outputs simultaneously?


BTW, it looks like you are converging on the concepts of sources, sinks,
buffers, pipelines, etc. that are used in gstreamer.


Would it desirable to enumerate the transforms the media processor is
capable of; how the transforms, sources, and sinks can be chained
together; and which can be done together or are mutually exclusive?




> 3. Video Timings
> ----------------
> 
> For setups like this:
> 
> --/dev/video0--+--mediaproc--+--encoder1 (/dev/video1)--|--S-Video out
>                |             |                          \--Composite out
> --/dev/fb0-----/             |
>                              \--encoder2 (/dev/video2)--|--HDMI out
>                                                         \--DVI-D out
> 
> it becomes much more difficult on how to set the video format. Until now
> you would just call VIDIOC_S_STD on video0. But for devices like this there
> are actually several places where you might need to define some transport
> standard. First of all in the input nodes, next in the media processor and
> finally in the output nodes (video1, video2).
> 
> In most cases you do not so much set a broadcast standard like PAL or NTSC,
> but instead you specify a set of timings for e.g. 1080p HDTV or 576i SDTV or
> even custom timings. This is used for the digital data transport, so for the
> path from video0 to the media processor you would set the timings through
> the video0 device.
> 
> In practice I would propose extending the v4l2_std_id with the common HDTV
> formats, that will take care for most use cases. In addition a new ioctl has
> to be introduced: VIDIOC_S_TIMINGS. This allows you to either specify a
> v4l2_std_id or a full set of timings (front porch, back porch, sync width,
> etc.). It should be extendable so that we can add additional timing formats
> in the future.
> 
> The digital format of the data from the media processor to the encoders can
> be set by calling S_STD or S_TIMINGS on the media processor device.
> 
> And finally the actual format output from the encoders can be set by calling
> S_STD or S_TIMINGS on the encoder devices. Note that this is currently a
> rather theoretical exercise since with the current hardware encoders cannot
> have different input and output timings. But we still have to cater for this
> possibility.
> 
> In order to make this easy on the user I propose the following strategy:
> 
> - Setting the format on an input A/V device will also set it for the media
>   processor and the encoders. It will also set it for all other A/V input
>   devices that are related (e.g. video0/vbi0). If you have multiple
>   independent inputs and each can have its own separate timings, then those
>   other inputs will remain unchanged.
> - Setting the format on the media processor will also set it for the
>   encoders.
> - Setting the format on an encoder will only change it for that encoder.

With there be a way to turn off these side effects if desired (and
supported in hardware)?

How will the relationship between special "related" A/V inputs be
discovered?


> Basically this pushes the standard 'up stream' but never 'down stream'.
> And it is also compatible with how it is working today.
> 
> You would have a similar strategy for capture devices.

You need to define "up stream" and "down stream".  Using a mental model
of input -> transform -> output, with data flowing down stream from
input to output (source to sink), your notion of stream direction seems
backwards to me.


> 
> 4. Ioctl()s
> -----------
> 
> After opening the media controller device you can enumerate over the
> media processors and for each media processor you can enumerate over
> the available input and output devices for that media processor.
> 
> You can also attach or detach input and/or output devices from that
> media processor (if supported, of course).
> 
> Multiple media processors can share some or all of the inputs and
> outputs. Whether you can attach the same input device to two or more
> media processors time depends on the hardware. You might get an -EBUSY
> error back if it is already in use.
> 
> A program trying to discover the topology would look like this:
> 
> struct v4l2_mediaproc mp;
> struct v4l2_mediainput mi;
> struct v4l2_mediaoutput mo;
> 
> fd_controller = open("/dev/v4l/controller0");
> mp.index = 0;
> while (!ioctl(fd_controller, VIDIOC_ENUM_MEDIAPROC, &mp)) {
> 	printf("mediaproc%d: %s\n", mp.index, mp.name);
> 	printf("  inputs:\n");
> 	mi.index = 0;
> 	mi.mp = mp.index;
> 	while (!ioctl(fd_controller, VIDIOC_ENUM_INPUTDEV, &mi)) {
> 		printf("    %d: %s (%s)\n", mi.index, mi.devpath, mi.name);
> 	}
> 	printf("  outputs:\n");
> 	mo.index = 0;
> 	mo.mp = mp.index;
> 	while (!ioctl(fd_controller, VIDIOC_ENUM_OUTPUTDEV, &mo)) {
> 		printf("    %d: %s (%s)\n", mo.index, mo.devpath, mo.name);
> 	}
> }
> 
> The filled-in structures would typically also include capabilities, whether
> the input or output device is attached to the media processor or not, some
> type field specifying the type of device (v4l, alsa, fb, dvb, etc.), and
> definitely lots of room for future additions.
> 
> Attaching/detaching would look something like this:
> 
> struct v4l2_media_connection mc;
> 
> mc.mp = mp.index;
> mc.input = mi.index;
> mc.action = V4L2_MC_ATTACH;
> ioctl(fd_controller, VIDIOC_S_MEDIACONNECTION, &mc);
> 
> mc.mp = mp.index;
> mc.output = mo.index;
> mc.action = V4L2_MC_DETACH;
> ioctl(fd_controller, VIDIOC_S_MEDIACONNECTION, &mc);
> 
> Note that only applications written specifically for e.g. a DaVinci SoC would
> ever attach or detach devices. You have to know the architecture of the
> media hardware and it is unlikely that an application like MythTV would ever
> need to do this. But the designer of an embedded system will probably need
> to do this in order to configure the media hardware according to his design.
> 
> 
> Examples
> ========
> 
> 1) Simple capture devices like bttv:
> 
> --tuner------|                         |--/dev/video0
> --S-Video----|--decoder--|--mediaproc--|--/dev/vbi0
> --composite--|                         |--line-out jack (looped back to audio input)
> --line-in----|
> 
> One media controller with one media processor and one decoder. The media
> processor has no input devices but has video0 and vbi0 capture devices.
> Calling S_STD or S_INPUT etc. ioctls on either output device will change
> it for the other as well (since both are connected to the same decoder via
> the media processor). The fact that there are no input devices implies that
> while there might be multiple physical inputs (e.g. tuner, composite in,
> S-Video in), only one is active at a time. The output devices are fixed
> (and pre-attached), so trying to detach them from the media processor will fail.
> 
> 2) Complicated devices like ivtv:
> 
> --tuner------|                         |--/dev/video0
> --S-Video----|--decoder--|--mediaproc--|--/dev/vbi0
> --composite--|                         |--/dev/video24
> --line-in----|                         |--/dev/video32
>                                        |--/dev/radio0
> 
> --/dev/video16--|                         |--S-Video out
> --/dev/fb0------|--mediaproc--|--encoder--|--line-out audio jack
> --/dev/vbi16----|             |           |--Composite out
> --/dev/video48--|             |
>                               \--/dev/vbi8
> 
> Two media controllers: one for capture, one for display.
> 
> The capture media controller has one media processor with no input devices
> (one physical audio or video input is active at a time). There are mpg, yuv,
> pcm (should become an alsa device) and vbi output devices (and a radio tuner
> device as well). The output devices are pre-attached and cannot be modified.
> 
> The display media controller has one media processor with mpg, yuv and vbi input
> devices and one vbi output device (this device outputs the embedded VBI data
> contained in the MPEG stream that's being decoded). The input/output devices
> are pre-attached.
> 
> 3) DavinciHD:
> 
> --decoder0--|--mediaproc0--|--/dev/video0
> 
> --decoder1--|--mediaproc1--|--/dev/video1
> 
> 
> /dev/video2--|--mediaproc0--|--encoder(s)--
> 
> /dev/video3--|--mediaproc1--|--encoder(s)--
> 
> 
> Two media controllers: one for capture, one for display.
> 
> The capture media controller has two media processors. The first has video0 as
> output device and no input device. The second has video1 as output device
> and no input device. The output devices are pre-attached.
> 
> If decoder0 is set to capture HD, then video1 is disabled and any access to it
> will return -EBUSY. So the two media processors are not independent from one
> another which is why they are enumerated in the same media controller.
> 
> The display media controller has two media processors. The first has video2 as
> input device and either no output devices (only possible if there is only one
> encoder) or one or more output devices, one for each encoder. These output
> devices cannot do any streaming, but they can be used to set hue, brightness,
> etc. for each encoder and to select the appropriate physical output connector.
> The input/output devices are pre-attached.
> 
> This is an embedded device, so which and how many decoders/encoders there are
> is up to the designer of the embedded system. As a consequence of this it
> would be very useful if there is a way to dynamically attach decoders and
> encoders to a media processor. Here too a media controller framework can be
> very useful by providing the driver internals to do this. However, this RFC
> is about the public API so this is not discussed here.
> 
> 4) Davinci:
> 
> I only discuss the display media controller as the capture media controller
> is pretty much standard.
> 
> /dev/video0--|             /--encoder0 (/dev/video2) --|--connector(s)
> /dev/video1--|--mediaproc--|
> /dev/fb0-----|             \--encoder1 (/dev/video3) --|--connector(s)
> /dev/fb1-----|
> 
> The display media controller has one media processor. There are multiple input
> devices (video0, video1, fb0 and fb1) and multiple output devices
> (one for each encoder). Input devices can be attached/detached from the media
> processor dynamically.
> 
> 5) OMAP DSS (DSS = Display SubSystem)
> 
> /dev/video0--|             /--encoder0--|--connector0
>              |--mediaproc--|
>              |             \--encoder1--|--connector1
> /dev/video1--|
>              |--mediaproc--|--encoder2--|--connector2
> /dev/fb0-----|             |
>                            \--connector3
> 
> The display media controller has two media processors. There are multiple input
> devices, the same list for each media processor. There are no output devices.
> You have to attach/detach input devices to each media processor since the
> routing is dynamic.
> 
> 
> Conclusion & open issues
> ========================
> 
> It is my opinion that the creation of a media controller device will solve
> various problems without sacrificing backwards compatibility. The addition
> of a central device that applications can use to discover all the inputs
> and outputs of a media board alone is very useful and has been sorely
> missing IMHO. And it allows us to implement the added flexibility that is
> required for advanced media boards like those of TI. The associated
> framework can also be used to setup sysfs nodes to help e.g. udev, or do
> other centralized administration.
> 
> All current V4L drivers actually implement a part of a media controller
> already, so I think that the opportunities for refactoring existing drivers
> are substantial.
> 
> Furthermore, it should be quite easy to add support for a media controller
> to all existing drivers. Most drivers just need to create a media controller
> and tell videodev to register the devices it creates with that controller.
> This should be fairly straightforward.
> 
> Media processors should also get their own device (where applicable). It
> can be used to do effects or compositing. For the current devices that are
> part of V4L there is no need to setup an explicit media processor since
> they do not need such functionality.

> Comments?

Again I think the notion of presenting the transforms that a media
controller is capable may be worthwhile.  You're so close to the
gstreamer framework concepts, that you could evaluate those concepts to
see if they can inform your proposal.

Overall you seem to have things well thought out.

> 	Hans Verkuil
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
