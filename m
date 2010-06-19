Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2119 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab0FSOJO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jun 2010 10:09:14 -0400
Received: from tschai.localnet (18.80-203-20.nextgentel.com [80.203.20.18])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id o5JE9Bi2018600
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 19 Jun 2010 16:09:12 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Report of Helsinki mini-summit
Date: Sat, 19 Jun 2010 16:11:25 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006191611.25271.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the report of the video4linux mini-summit held June 14-16 in Helsinki,
Finland, and was hosted by Nokia.

About 24 developers attended, including the V4L maintainer, Mauro Carvalho Chehab,
V4L developers Hans de Goede, Guennadi Liakhovetski, Laurent Pinchart and
undersigned, and representatives from Nokia, Samsung, Qualcomm, Intel,
Texas Instruments, ST-Ericsson and Multimedia Solutions.

The main focus of the summit was how to proceed in the next several months
with regards to the SoC support in V4L. Video on SoCs is big business and
Google's Android platform plays a major role in pushing linux into the mobile
area. SoCs have unique requirements and for the past few years the foundation
has been laid in the V4L subsystem to start supporting the full functionality
of that hardware. Much of the summit was about what is still needed to achieve
this.

Part of the work is of course to introduce the new APIs and functionality that
are needed, but another part of the work is to figure out what to do with legacy
functionality that is actually blocking or hampering these new developments.
Sadly, throughout the V4L history not all decisions and designs where always
thought out carefully and so we have some hacks and inconsistencies that need
to be resolved.

Obviously not everything could be decided in just three days: some of the
items need more discussions.

I would like once again to thank all participants for their constructive input
and enthusiasm for this project. It is great to see so much interest in this.

I will go through the agenda points one-by-one. Any mistakes there may be are
mine and mine alone. Please reply to correct any errors!

Regarding presentations: we hope to host them on www.linuxtv.org soon.



1) Presentation on the Qualcomm video hw architecture.

Jeff Zhong gave the presentation. The main restriction that they have is that
they have a lot of proprietary video optimization and processing code and that
must somehow sit between the application and the driver.

A good solution was found in the form of a libv4l plug-in that uses IPC to talk
to a separate daemon process. Due to legal concerns it was not possible to
eliminate the daemon and just put everything in the plug-in code. See also
item 12.



2) Presentation on the ST-Ericsson video hardware.

Robert Fekete gave the presentation. This link gives an overview of their
hardware:

http://www.stericsson.com/platforms/U8500.jsp

They have several memory-to-memory devices, so they were very interested in
that recently merged functionality.

An open issue is how to create a blitter driver. The suggestion was to discuss
this further with Samsung and Andrew Morton.

For HDMI receivers and transmitters the foundations are already in place (high
resolution API and events API). For CEC support in HDMI more research and
discussions are needed: should this be an input driver? Or part of the IR
framework?

They also pointed to the openWF streaming API that is being developed. See
www.khronos.org. This will be of interest for future videobuf discussions.



3) Removal of V4L1: status of driver conversion in the kernel, status of
   moving v4l1->v4l2 conversion into libv4l1.

V4L1 driver status:

se401: Hans de Goede will convert this to V4L2 (gspca)
ibmcam + konicawc: Ditto.
stradis: Hans Verkuil will contact the company whether they have any interest.
	 Firmware is needed to test these cards, but seems to be unavailable.
	 No work has been done on this driver for a long time.
	 If there is no interest, then this driver will be removed.
pwc:	 Hans Verkuil removed the V4L1 support, but that broke the driver.
         It is now possible to test the hardware, so this will need a second
         attempt.
vicam: 	 No hardware. Remove the driver.
cpia_pp: Non-trivial parallel port webcam. Don't waste time on this, remove the
         driver.
cpia2:   Was converted, Alan Cox has the hardware, but has not yet tested the
         patch. If remains untested, then just merge anyway.

Those drivers that will be removed will be marked deprecated and put on the
feature removal list for 2.6.35. Actual removal will take place in 2.6.37.

libv4l1 status:

All V4L1 ioctls are now implemented by the library, but it needs testing
before it can be released.

This means that the V4L1 compat layer in the kernel can be marked deprecated
for 2.6.35 and put on the feature removal list so we can remove it in 2.6.37.
This will be a great improvement since the V4L1 compat support in
videobuf-dma-sg.c is really blocking videobuf development.

So V4L1 will finally disappear from the kernel in 2.6.37! There should be
an LWN article as well so everyone (we hope) will be informed of this in time.



4) Adopting old V4L1 programs

Hans de Goede suggested that we pull in the unmaintained camorama tool. No
other programs came up.



5) Media Controller Roadmap

Presentation by Laurent Pinchart.

It was suggested that there should be a MC ioctl that returns version information
of both hardware and the MC API. Everyone agreed on this, so this will be added.

There is an open issue on how to configure all the links in a complex video system.
In the current prototype implementation they become active when streaming starts
and cannot be changed while streaming is in progress. But in other systems
something like a commit ioctl might be needed or some other way to set multiple
links atomically.

Another idea was to have presets for common routing configurations and be able
to enumerate those presets. Whether that should be in user space or kernel space
was unclear, though.

Similar problems occur with configuring a large complex video subsystem. Perhaps
some configuration snapshot functionality might come in handy here.

These last three points will all need more thought.

The roadmap for the Media Controller is that the first patches should appear in
1-2 weeks. First adding subdev device nodes, then the MC itself.



6) TO DO list regarding V4L2 core framework including the new control framework.

- Control Framework: done, just needs a pull request. Some discussions on how
  to handle 'auto-foo' and 'foo' controls (e.g. autogain/gain). Can be fixed
  later.
- Replace all s/g/try_fmt subdev ops with s/g/try_busfmt. Mostly done, want to
  finish this for 2.6.36.
- Move priority handling into the core: need to post a new RFC.
- Simplify locking: need to post a new RFC.
- Convert existing drivers to v4l2_device, v4l2_fh, control framework.
  Ongoing job.
- Handling of dbg_g/s/_register and dbg_g_chip_ident can be moved into the core.
  Should simplify subdev drivers.

It was decided not to post the control framework yet, Laurent Pinchart will
attempt to use it in UVC first. If that succeeds, then Hans Verkuil can post a
pull request for this.

There was some discussion on how to reduce the amount of printk's in drivers.
Possibly by somehow using debugfs. No concrete results, though.

We should have some well-defined projects for Google Summer of Code (or similar
initiatives). Ideas are: an RDS test program, a dummy libv4l plugin.

One other useful thing to add to the TODO list is to move the pixel format
descriptions into the core framework to give consistent namings.



7) soc-camera status

Presentation by Guennadi Liakhovetski.

There are basically three outstanding issues when it comes to the remaining
soc-camera dependencies in sensor drivers:

- Bus parameter configuration. This should be done through a board info config.
  Needs new standard structs for basic parameters: one for parallel sensors,
  one for MIPI sensors. These can be embedded in the board info config.
- Control handling. Will be easy to fix once the control framework is merged.
- Mediabus pixel code defines: a discussion was started some time ago on the
  mailinglist regarding some ambiguities of the YUV pixel codes. This discussion
  needs to be finished so we can come to a conclusion. Since these defines will
  become public in the near future this issue needs to be resolved soon.



8) V4L2 video output vs. framebuffer.

Guennadi's idea was to provide a generic framebuffer driver that could sit
on top of a v4l output driver.

After some discussion it became clear that there was not enough interest in
this. Creating a fb driver is already very simple and the general opinion was
that there is no need for something like this at the moment.

That said, the framebuffer subsystem sees very little effort in improving the
APIs, in part because there is no central maintainer of that subsystem anymore.

Many SoCs support the fb API though, so the slow progress in the fb subsystem
can become a problem.

Samsung: will soon post subdev-based framebuffer driver to the list. (Already
done: see the patch series from Sylwester Nawrocki).

There are some common FB operations that most SoC vendors need. Samsung will
look at that and try to make a proposal for such common ioctls and post them
to the list, with a CC to Andrew Morton (due to the unmaintained status of the
FB API). See also item 15.



9) Remote Controllers.

Presentation by Mauro Carvalho Chehab.

One question that needed answering was whether RC keymaps should (optionally)
remain in kernel space, or whether all could be moved to userspace. Nobody
could see a good use case for keeping this in the kernel and the consensus
was to move this all to userspace.

As mentioned before, CEC was discussed in this context as well. More research
needs to be done to see whether the IR framework is a good match for this.

One currently missing bit in the IR framework are IR transmitters. Work is
being done on this. The implementation will use 'raw IR' format. Should CEC
use this framework as well, then CEC will need a non-raw format. This is
something that needs to be discussed further.



10) V4L2 driver compliance test framework.

Hans Verkuil made a start with this with the v4l2-compliance utility. This is
currently very basic and limited, though. Help is needed to extend this tool
so that it can cover the whole V4L2 API.

There is a sourceforge project called v4l-test. We have permission from the
author to reuse code from that project in v4l2-compliance. Some companies also
have in-house test tools. So there is a lot out there, we just need someone
to actually put in the work to turn v4l2-compliance into a really useful tool.

Some offers of help were made, so hopefully we can see more progress on this
in the near future.

Another idea was to test the other way around: verify user programs through
vivi and/or a libv4l plugin and/or a new driver. Not everyone liked to have
a new driver for this, though.

A general problem is what should be done with reserved fields that userspace
should zero. Currently there is no check whether apps really zeroed them.
So if you start to use them later, then apps might unexpectedly fail.

The eventual proposal was to have extra checks in the core, using printk to
warn that reserved fields are not zeroed by the app. Possibly only active if
the ADVANCED_DEBUG config option is enabled.

It was also suggested to get rid of the ADVANCED_DEBUG config option and use
debugfs instead.



10a) V4L2 specification changes/clarifications

The previous discussion led to a new discussion regarding ambiguities in the
V4L2 spec:

- Hans de Goede: should we allow STREAMON if no buffers are queued? This should
  be stated clearly in the spec. Discuss on mailinglist which option to use.
- Mixed read() and mmap() streaming. Allow or disallow? bttv allows it, which
  is against the spec since it only has one buffer queue so a read() will steal
  a frame. No conclusion was reached. Everyone thought it was very ugly but
  some apps apparently use this. Even though few drivers actually support this
  functionality.
- Hans de Goede: Clarify read/write call in spec. JPEG writing: write must
  always do full JPEG frames as partial JPEG frames make no sense (would require
  that the driver detects the end of the JPEG frame!).
  JPEG readining: libv4l emulates read by giving you whatever fits of the frame
  and throws away the rest of the frame, while many drivers allow you to read
  frames piecemeal, especially when it comes to raw or MPEG formats. But does
  that make sense for JPEG-like formats?
  To be discussed further on the mailinglist.
- Hans Verkuil: Remove this 'feature' from the spec: 'Regardless if /dev/video
  (81, 0) or /dev/vbi (81, 224) is opened the application can select any one of
  the video capturing, overlay or VBI capturing functions.' No drivers and apps
  do this and it is extremely complex to implement anyway. The consensus was
  that this could be removed.



11) Discuss list of 'reference' programs to test against.

We came up with the following list:

xawtv3, mplayer (for MPEG-like streams), tvtime, gnome-lirc, qv4l2, alevt,
gst -launch.

A discussion was started what to do with the 'overlay' support (PCI-to-PCI)
in V4L2. Currently only supported by xawtv3 and xdtv, but no longer works
out of the box: you need to manually setup the framebuffer address in the device
node.

Some where in favor of killing this, others thought it still had merits in
some cases. To be discussed on the mailinglist.



12) A processing plugin API for libv4l.

See: http://www.mail-archive.com/linux-media@vger.kernel.org/msg18993.html

The ability to create proprietary plug-ins is very important for SoC vendors.

The in-depth discussion of the proposal happened in a separate track. I was
not present, so I can only report the outcome:

The initial RFC was found to be too limited. Instead there should be a
generic plug-in API to capture all ioctls in both directions.

This makes it even possibly to create a completely emulated device (although
that won't show up in sysfs, obviously).

A new RFC will be prepared and posted by Hans de Goede.



13) Meego presentation

Sakari Ailus gave a presentation on the camera framework in Meego. They used
to have a daemon to handle proprietary software but will move to a libv4l
plug-in instead.

They have a 'v4l2camsrc' userspace module that contains support for custom
control IDs. Sakari Ailus will look into making a proposal to add those controls
to the standard V4L framework. Many of those controls seemed suitable as
standard controls. Having this in the core would make it possible to ditch this
module.



14) Status of intel drivers.

Presented by Xiaolin Zhang.

Mostly done. The comments from the last code review are being addressed.
Two open items:

- Duplicate videobuf support: this requires the new videobuf2 implementation
  (item 16).
- bus config setup: requires the proposed standard structs for parallel and
  mipi sensors (see item 7).



15) Status of the Texas Instruments drivers

Presented by Hiremath Vaibhav.

- the display subsystem (DSS) uses sysfs to address deficiencies in the FB API.
  TI will work with Samsung on trying to come up with new common FB API additions.
  (See also item 8).
- Full support for omap3x should be finished this year.
- Vaibhav's team is now also handling the DMxxx support.



16) videobuf/videobuf2.

Presentations by Laurent Pinchart and Pawel Osciak.

Everyone agreed that videobuf had too many fundamental flaws to be refactored
into a working framework. So there will be a videobuf2. Hopefully the current
videobuf drivers can be converted to videobuf2 eventually.

The recommendation was to clean up and fix the current videobuf as much as
possible before creating videobuf2.

Detailed discussions will have to wait until the videobuf2 patches are posted.
Everyone agreed with the basic concept, though. In particular having custom
memory allocators was seen as essential.

The 'waitqueue per buffer' method should be replaced with a single waitqueue
in the queue itself. This allows out-of-order dequeuing, something that is
needed by the Samsung hardware.

ST-Ericsson mentioned that the current enum v4l2_colorspace has no support
for full range vs limited range colorspaces. New colorspace entries should be
added to differentiate between the two.

The Samsung multi-planar proposal raised several issues:

- bytesperline in v4l2_pix_format is not sufficient in the multiplanar case:
  should we add a v4l2_pix_format_plane with an array of bytesperline?

- how do you know which plane contains what? The consensus was that fourcc codes
  should determine uniquely what goes to which plane.

- not clear how to specify that multiplanar is needed:
        - new v4l2_buf_type?
        - new pixel fourcc formats?
        - new memory type format?

- an alternative was also proposed: we need to be able to preregister memory
  to prepare the memory for use with video streaming (e.g. cache configurations,
  locking it in memory). One option is to preregister all planes. After that
  you can refer to the whole set of planes through a single ID as returned
  by the prereg ioctl. This might change the public API of the multiplanar
  proposal substantially (the internals will remain pretty much the same,
  though). Samsung and ST-Ericsson will make a joint proposal for this.

A next step will be to have a kernel-central way of creating large memory
buffers that can be used by v4l, fb, graphics (i.e. openGL textures) and
possibly others (pass on to DSPs for example).

This will need some cross-subsystem cooperation. ST-Ericsson has code and a
proposal. But this will definitely need a separate brainstorm session with
the relevant experts.



17) Ideas for LPC media track.

The Linux Plumbers Conference will be held November 3-5 in Cambridge, MA.
It will contain a media track and Mauro wanted to have some feedback which
topics should be discussed:

- alsa & HDMI
- alsa & v4l2 timestamping (ktime)
- query v4l2 output latency
- X memory handling
- Can parts of kms be shared with v4l? E.g. EDID parsing, others?
- Memory pool: how usable are gem, ttm?
- remote controller & X & apps



18) v4l2-int-device.h removal

Currently only used by one i2c driver and the omap2 driver. Should be converted
to subdev. Sakari Ailus and Hans Verkuil will discuss offline who can do what.



This concludes the report of this summit. As has become clear, there are many
ongoing developments taking place on many different levels. We are seeing steady
progress in all areas, every kernel release has one or more new building blocks
in place. It looks like we are getting close to finally offering the functionality
that SoC drivers need so that we can start to merge them. Perhaps not yet with a
full feature set, but good enough so we can build from there.

It is also clear that libv4l is developing into a much more important library
then was originally envisaged. It's likely to become an essential library for
SoCs. I'm very pleased to see how neatly it fits into the bigger picture.

A big 'Thank You!' to everyone who helped make this mini-summit a success!

Regards,

	Hans Verkuil

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
