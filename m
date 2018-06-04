Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38270 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753057AbeFDNdJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 09:33:09 -0400
Date: Mon, 4 Jun 2018 10:33:03 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Javier Martinez Canillas <javier@dowhile0.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@google.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?=
        <niklas.soderlund@ragnatech.se>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Inki Dae <inki.dae@samsung.com>
Subject: [ANN v2] Complex Camera Workshop - Tokyo - Jun, 19
Message-ID: <20180604103303.6a6b792b@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I consolidated hopefully all comments I receive on the past announcement
with regards to the complex camera workshop we're planning to happen in
Tokyo, just before the Open Source Summit in Japan.

The main focus of the workshop is to allow supporting devices with MC-based
hardware connected to a camera.

I'm enclosing a detailed description of the problem, in order to
allow the interested parties to be at the same page.

We need to work towards an agenda for the meeting.

=46rom my side, I think we should have at least the following topics at
the agenda:

- a quick review about what's currently at libv4l2;
- a presentation about PipeWire solution;
- a discussion with the requirements for the new solution;
- a discussion about how we'll address - who will do what.

Comments? Suggestions?

Are there anyone else planning to either be there physically or via
Google Hangouts?

Tomaz,

Do you have any limit about the number of people that could join us
via Google Hangouts?


Regards,
Mauro

---

1. Introduction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

1.1 V4L2 Kernel aspects
-----------------------

The media subsystem supports two types of devices:

- "traditional" media hardware, supported via V4L2 API. On such hardware,=20
  opening a single device node (usually /dev/video0) is enough to control
  the entire device. We call it as devnode-based devices.
  An application sometimes may need to use multiple video nodes with=20
  devnode-based drivers to capture multiple streams in parallel
  (when the hardware allows it of course). That's quite common for
  Analog TV devices, where both /dev/video0 and /dev/vbi0 are opened
  at the same time.

- Media-controller based devices. On those devices, there are typically
  several /dev/video? nodes and several /dev/v4l2-subdev? nodes, plus
  a media controller device node (usually /dev/media0).
  We call it as mc-based devices. Controlling the hardware require
  opening the media device (/dev/media0), setup the pipeline and adjust
  the sub-devices via /dev/v4l2-subdev?. Only streaming is controlled
  by /dev/video?.

In other words, both configuration and streaming go through the video
device node on devnode-based drivers, while video device nodes are used
used for streaming on mc-based drivers.

With devnode-based drivers, "standard" media applications, including open=20
source ones (Camorama, Cheese, Xawtv, Firefox, Chromium, ...) and closed
source ones (Skype, Chrome, ...) support devnode-based devices[1]. Also,
when just one media device is connected, the streaming/control device
is typically /dev/video0.

[1] It should be noticed that closed-source applications tend to have=20
various bugs that prevent them from working properly on many devnode-based
devices. Due to that, some additional blocks were requred at libv4l to
support some of them. Skype is a good example, as we had to include a
software scaler in libv4l to make it happy. So in practice not everything
works smoothly with closed-source applications with devnode-based drivers.
A few such adjustments were also made on some drivers and/or libv4l, in
order to fulfill some open-source app requirements.

Support for mc-based devices currently require an specialized application=20
in order to prepare the device for its usage (setup pipelines, adjust
hardware controls, etc). Once pipeline is set, the streaming goes via
/dev/video?, although usually some /dev/v4l2-subdev? devnodes should also
be opened, in order to implement algorithms designed to make video quality
reasonable. On such devices, it is not uncommon that the device used by the
application to be a random number (on OMAP3 driver, typically, is either
/dev/video4 or /dev/video6).

One example of such hardware is at the OMAP3-based hardware:

	http://www.infradead.org/~mchehab/mc-next-gen/omap3-igepv2-with-tvp5150.png

On the picture, there's a graph with the hardware blocks in blue/dark/blue
and the corresponding devnode interfaces in yellow.

The mc-based approach was taken when support for Nokia N9/N900 cameras=20
was added (with has OMAP3 SoC). It is required because the camera hardware
on SoC comes with a media processor (ISP), with does a lot more than just
capturing, allowing complex algorithms to enhance image quality in runtime.
Those algorithms are known as 3A - an acronym for 3 other acronyms:

	- AE (Auto Exposure);
	- AF (Auto Focus);
	- AWB (Auto White Balance).

The main reason that drove the MC design is that the 3A algorithms (that is=
=20
the 3A control loop, and sometimes part of the image processing itself) oft=
en=20
need to run, at least partially, on the CPU. As a kernel-space implementati=
on
wasn't possible, we needed a lower-level UAPI.

Setting a camera with such ISPs are harder because the pipelines to be
set actually depends the requirements for those 3A algorithms to run.
Also, usually, the 3A algorithms use some chipset-specific userspace API,
that exports some image properties, calculated by the ISP, to speed up
the convergence of those algorithms.

Btw, usually, the 3A algorithms are IP-protected, provided by vendors
as binary only blobs, although there are a few OSS implementations.

Part of the problem is that, so far, there isn't a proper userspace API=20
to implement 3A libraries. Once we have an userspace camera stack, we
hope that we'll gradually increase the number and quality of open-source
3A stacks.


1.2 V4L2 userspace aspects
--------------------------

Back when USB cameras were introduced, the hardware were really simple:
they had a CMOS or CCD camera sensor and a chip that bridges the data=20
though USB. Camera sensors typically provide data using a bayer
format, but they usually have their own proprietary ways to pack the data
at the USB bridges, in order to reduce the bandwidth (the first
implementations were using USB version 1.1).

So, V4L2 has a myriad of different formats, in order to match each
camera sensor format. At the end of the day, applications were
able to use only a subset of the available hardware, since they need
to come with format converters for all formats the developer uses
(usually a very small subset of the available ones).

That's said, newer cameras are converged towards a small set of
standard formats - except for secondary data streams (like depth
maps). Yet, industrial cameras, and newer technologies, like
3D, light-field, etc may still bring newer formats.

To end with this mess, an userspace library was written, called libv4l.
It supports all those proprietary formats. So, applications can use
a RGB or YUV format, without needing to concern about conversions.

The way it works is by adding wrappers to system calls: open, close,
ioctl, mmap, mmunmap. So, a conversion to use it is really simple:
at the source code of the apps, all it was needed is to prepend the
existing calls with "v4l2_", e. g. v4l2_open, v4l2_close, etc.

All open source apps we know now supports libv4l. On a few (like
gstreamer), support for it is optional.

It should be noted that libv4l also handles scaling and rough auto-gain=20
and auto-white balance that are required by  some cameras to achieve
a usable image.

In order to support closed source, another wrapper was added, allowing
to call any closed source application to use it, by using LD_PRELOAD.
For example, using skype with it is as simple as calling it with:

	$ LD_PRELOAD=3D/usr/lib/libv4l/v4l1compat.so /usr/bin/skypeforlinux


2. Current problems
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

2.1 Libv4l can slow image handling
----------------------------------

Nowadays, almost all new "simple" cameras are connected via USB using
the UVC class (USB Video Class). UVC standardized the allowed formats,
and most apps just implement them. The UVC hardware is more complex,
having format converters inside it. So, for most usages, format
conversion isn't needed anymore.

The need of doing format conversion in software makes libv4l slow,
requiring lots of CPU usage in order to convert a 4K or 8K format,
being even worse with 3D cameras.

Also, due to the need of supporting LD_PRELOAD, zero-buffer copy via
DMA_BUFFER currently doesn't work with libv4l.

Right now, gstreamer defaults to not enable libv4l2, due to several
reasons:
  - Crash when CREATE_BUFS is being used;
  - Crash in the jpeg decoder (when frames are corrupted);
  - App exporting DMABuf need to be aware of emulation, otherwise the
    DMABuf exported are in the orignal format;
  - RW emulation only initialize the queue on first read (causing=20
    userspace poll() to fail);
  - Signature of v4l2_mmap does not match mmap() (minor);
  - The colorimetry does not seem emulated when conversion;
  - Sub-optimal locking (at least deadlocks were fixed).

Most of the above are due to new features added to Kernel uAPI, but
not added to libv4l2.

These issues are already worked around in GStreamer, but with the lost
of features of course. There is other cases were something worked=20
without libv4l2, but didn't work with libv4l2, but Gstreamer developers
haven't tracked down the cause yet. Since 1.14, libv4l2 can be enabled
at run-time using env GST_V4L2_USE_LIBV4L2=3D1.

2.2 Modern hardware is starting to come with "complex" camera ISP
-----------------------------------------------------------------

While mc-based devices were limited to SoC, it was easy to
"delegate" the task of talking with the hardware to the
embedded hardware designers.

However, this is changing. Dell Latitude 5285 laptop is a standard
PC with an i3-core, i5-core or i7-core CPU, with comes with the
Intel IMU3 ISP hardware[2].

[2] https://www.spinics.net/lists/linux-usb/msg167478.html

There, instead of an USB camera, the hardware is equipped with a
MC-based ISP, connected to its camera. Currently, despite having
a Kernel driver for it, the camera doesn't work with any
userspace application.

I'm also aware of other projects that are considering the usage of
mc-based devices for non-dedicated hardware.

3. How to solve it?
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

That's the main focus of the meeting :-)

=46rom a previous discussion I had with media sub-maintainers, there are
at least two actions that seem required. I'm listing them below as
an starting point for the discussions, but we can eventually come up
with some different approach after the meeting.

3.1 Library support for mc-based hardware
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

In order to support those hardware, we'll need to do some redesign,
mainly at userspace, via a library[3] that will replace/compliment
libv4l2.

The idea is to work on a library API that will allow to split the=20
format conversion on a separate part of it, add support
for DMA Buffer and come up with a way for the library to work
transparently with both devnode-based and mc-based hardware.

The library should be capable of doing dynamic pipeline setups,
including the functionality of allow tranfering buffers between
different media devices, as, on several cases, a a camera input
device node should be connected to a m2m device that would be
doing some image processing, and providing output data on a
standard video output format.

One possibility is to redesign libv4l2. It should be noticed that
Videolan people is working on a daemon that could also provide
another way to implement it[4].

Once we get a proper camera stack, we need to support traditional=20
applications that use libv4l2 and/or the new library directly. To=20
that end we  will need to expose the libv4l2 API on top of the=20
camera stack (through libv4l2 if it makes sense, or through a separate
implementation) and implement a transparent LD_PRELOAD-based library.

That envolves adding capacity to the library to setup hardware pipelines
and to propagate controls among their sub-devices. Eventually, part
of it will be done in Kernel.

That should give performance increase at the library and would allow
gstreamer to use it by default, without compromising performance.

[3] I don't discard that some Kernel changes could also be part of the
solution, like, for example, doing control propagation along the pipeline
on simple use case scenarios.

[4] With the venue of sandboxed application, there is a need to control
access to cameras through a daemon. The same daemon is also used to
control access to screen capture on Wayland (instead of letting any
random application capture your screen, like on X11). The effort is=20
lead by the desktop team at RedHat. PipeWire already have V4L2 native
support and is integrated in GStreamer already in a way that it can
totally replace the V4L2 capture component there. PipeWire is plugin based,
so more type of camera support can be added. Remote daemon can also provide=
=20
streams, as this is the case for compositors and screen casting. An extra=20
benefit is that you can have multiple application reading frames from the
same camera. It also allow sandboxed  application (the do not have access=20
to /dev) to use the cameras. In this context, proprietary or HW specific
algorithm could be implemented in userspace as PipeWire plugins, and then
application will automatically be enable to enumerate and use these.=20

3.2 libv4l2 support for 3A algorithms
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The 3A algorithm handing is highly dependent on the hardware. The
idea here is to allow libv4l to have a set of 3A algorithms that
will be specific to certain mc-based hardware.

One requirement, if we want vendor stacks to use our solution, is that=20
it should allow allow external closed-source algorithms to run as well.

The 3A library API must be standardized, to allow the closed-source=20
vendor implementation to be replaced by an open-source implementation
should someone have the time and energy (and qualifications) to write
one.

Sandboxed execution of the 3A library must be possible as closed-source=20
can't always be blindly trusted. This includes the ability to wrap the
library in a daemon should the platform's multimedia stack wishes
and to avoid any direct access to the kernel devices by the 3A library
itself (all accesses should be marshaled by the camera stack).

Please note that this daemon is *not* a camera daemon that would
communicates with the V4L2 driver through a custom back channel.

The decision to run the 3A library in a sandboxed process or to call
it directly from the camera stack should be left to the camera stack
and to the platform integrator, and should not be visible by the 3A
library.

The 3A library must be usable on major Linux-based camera stacks (the=20
Android and Chrome OS camera HALs are certainly important targets,=20
more can be added) unmodified, which will allow usage of the vendor
binary provided for Chrome OS or Android on regular Linux systems.

It would make sense to design a modular camera stack, and try to make=20
most components as platform-independent as possible. This should include:

- the kernel drivers (V4L2-compliant and usable without any closed-source=20
  userspace component);
- the 3A library
- any other component that could be shared (for instance a possible
  request API library).=20

The rest of the code will mostly be glue around those components to
integrate them in a particular camera stack, and should be as=20
platform-agnostic as possible.=20

In the case of the Android camera HAL, ideally it would be a glue that
could be used with different camera vendors (probably with some kind of
vendor-specific configuration, or possibly with a separate vendor-specific
component to handle pipeline configuration).

4 Complex camera workshop
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The workshop will be happening in Tokyo, Japan, at Jun, 19, at the
google offices. The location is:

=E3=80=92106-6126 Tokyo, Minato, Roppongi, 6 Chome=E2=88=9210=E2=88=921 Rop=
pongi Hills Mori Tower 44F

4.1 Physical Attendees
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Tomasz Figa <tfiga@google.com>
Mauro Carvalho Chehab <Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Kieran Bingham <kieran.bingham@ideasonboard.com>
Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Niklas S=C3=B6derlund <niklas.soderlund@ragnatech.se>
Zheng, Jian Xu Zheng <jian.xu.zheng@intel.com>

Anywone else?

4.2. Attendees Via Google Hangouts
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D

Hans Verkuil <hverkuil@xs4all.nl> - Via Google Hangouts - maybe only on aft=
ernoon
Javier Martinez Canillas <javier@dowhile0.org> - Via Google Hangouts - only=
 on reasonable TZ-compatible-hours
Ricky - Google camera team in Taipei - Via Google Hangouts

Anywone else?
