Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:35946 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751914AbeEQVi5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 17:38:57 -0400
Received: by mail-qk0-f170.google.com with SMTP id l132-v6so4886901qke.3
        for <linux-media@vger.kernel.org>; Thu, 17 May 2018 14:38:57 -0700 (PDT)
Message-ID: <644920d91d1f69d659f233c6a52382d3f919babc.camel@ndufresne.ca>
Subject: Re: [ANN] Meeting to discuss improvements to support MC-based
 cameras on generic apps
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        LMML <linux-media@vger.kernel.org>
Cc: Wim Taymans <wtaymans@redhat.com>, schaller@redhat.com
Date: Thu, 17 May 2018 17:38:53 -0400
In-Reply-To: <20180517160708.74811cfb@vento.lan>
References: <20180517160708.74811cfb@vento.lan>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-nPVLClvqvHLUFaqQAfMw"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-nPVLClvqvHLUFaqQAfMw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 17 mai 2018 =C3=A0 16:07 -0300, Mauro Carvalho Chehab a =C3=A9crit=
 :
> Hi all,
>=20
> The goal of this e-mail is to schedule a meeting in order to discuss
> improvements at the media subsystem in order to support complex
> camera
> hardware by usual apps.
>=20
> The main focus here is to allow supporting devices with MC-based
> hardware connected to a camera.
>=20
> In short, my proposal is to meet with the interested parties on
> solving
> this issue during the Open Source Summit in Japan, e. g. between
> June, 19-22, in Tokyo.
>=20
> I'd like to know who is interested on joining us for such meeting,
> and to hear a proposal of themes for discussions.
>=20
> I'm enclosing a detailed description of the problem, in order to
> allow the interested parties to be at the same page.

It's unlikely I'll be able to attend this meeting, but I'd like to
provide some initial input on this. Find inline some clarification on
why libv4l2 is disabled by default in Gst, as it's not just
performance.

A major aspect that is totally absent of this mail is PipeWire. With
the venue of sandboxed application, there is a need to control access
to cameras through a daemon. The same daemon is also used to control
access to screen capture on Wayland (instead of letting any random
application capture your screen, like on X11). The effort is lead by
the desktop team at RedHat (folks CCed). PipeWire already have V4L2
native support and is integrated in GStreamer already in a way that it
can totally replace the V4L2 capture component there. PipeWire is
plugin base, so more type of camera support (including proprietary
ones) can be added. Remote daemon can also provide streams, as this is
the case for compositors and screen casting. An extra benefit is that
you can have multiple application reading frames from the same camera.
It also allow sandboxed application (the do not have access to /dev) to
use the cameras. PipeWire is much more then that, but let's focus on
that.

This is the direction we are heading on the "generic" / Desktop Linux.
Porting Firefox and Chrome is obviously planed, as these beast are
clear candidate for being sand-boxed and requires screen share feature
for WebRTC.

In this context, proprietary or HW specific algorithm could be
implemented in userspace as PipeWire plugins, and then application will
automatically be enable to enumerate and use these. I'm not saying the
libv4l2 stuff is not needed short term, but it's just a short term
thing in my opinion.

>=20
> Regards,
> Mauro
>=20
> ---
>=20
>=20
> 1. Introduction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> 1.1 V4L2 Kernel aspects
> -----------------------
>=20
> The media subsystem supports two types of devices:
>=20
> - "traditional" media hardware, supported via V4L2 API. On such
> hardware,=20
>   opening a single device node (usually /dev/video0) is enough to
> control
>   the entire device. We call it as devnode-based devices.
>=20
> - Media-controller based devices. On those devices, there are several
>   /dev/video? nodes and several /dev/v4l2-subdev? nodes, plus a media
>   controller device node (usually /dev/media0).
>   We call it as mc-based devices. Controlling the hardware require
>   opening the media device (/dev/media0), setup the pipeline and
> adjust
>   the sub-devices via /dev/v4l2-subdev?. Only streaming is controlled
>   by /dev/video?.
>=20
> All "standard" media applications, including open source ones
> (Camorama,
> Cheese, Xawtv, Firefox, Chromium, ...) and closed source ones
> (Skype,=20
> Chrome, ...) supports devnode-based devices.
>=20
> Support for mc-based devices currently require an specialized
> application=20
> in order to prepare the device for its usage (setup pipelines, adjust
> hardware controls, etc). Once pipeline is set, the streaming goes via
> /dev/video?, although usually some /dev/v4l2-subdev? devnodes should
> also
> be opened, in order to implement algorithms designed to make video
> quality
> reasonable. On such devices, it is not uncommon that the device used
> by the
> application to be a random number (on OMAP3 driver, typically, is
> either
> /dev/video4 or /dev/video6).
>=20
> One example of such hardware is at the OMAP3-based hardware:
>=20
> 	http://www.infradead.org/~mchehab/mc-next-gen/omap3-igepv2-with
> -tvp5150.png
>=20
> On the picture, there's a graph with the hardware blocks in
> blue/dark/blue
> and the corresponding devnode interfaces in yellow.
>=20
> The mc-based approach was taken when support for Nokia N9/N900
> cameras=20
> was added (with has OMAP3 SoC). It is required because the camera
> hardware
> on SoC comes with a media processor (ISP), with does a lot more than
> just
> capturing, allowing complex algorithms to enhance image quality in
> runtime.
> Those algorithms are known as 3A - an acronym for 3 other acronyms:
>=20
> 	- AE (Auto Exposure);
> 	- AF (Auto Focus);
> 	- AWB (Auto White Balance).
>=20
> Setting a camera with such ISPs are harder because the pipelines to
> be
> set actually depends the requirements for those 3A algorithms to run.
> Also, usually, the 3A algorithms use some chipset-specific userspace
> API,
> that exports some image properties, calculated by the ISP, to speed
> up
> the convergence of those algorithms.
>=20
> Btw, usually, the 3A algorithms are IP-protected, provided by vendors
> as binary only blobs, although there are a few OSS implementations.
>=20
> 1.2 V4L2 userspace aspects
> --------------------------
>=20
> Back when USB cameras were introduced, the hardware were really
> simple:
> they had a CCD camera sensor and a chip that bridges the data though
> USB. CCD camera sensors typically provide data using a bayer format,
> but they usually have their own proprietary ways to pack the data,
> in order to reduce the USB bandwidth (original cameras were USB 1.1).
>=20
> So, V4L2 has a myriad of different formats, in order to match each
> CCD camera sensor format. At the end of the day, applications were
> able to use only a subset of the available hardware, since they need
> to come with format converters for all formats the developer uses
> (usually a very small subset of the available ones).
>=20
> To end with this mess, an userspace library was written, called
> libv4l.
> It supports all those proprietary formats. So, applications can use
> a RGB or YUV format, without needing to concern about conversions.
>=20
> The way it works is by adding wrappers to system calls: open, close,
> ioctl, mmap, mmunmap. So, a conversion to use it is really simple:
> at the source code of the apps, all it was needed is to prepend the
> existing calls with "v4l2_", e. g. v4l2_open, v4l2_close, etc.
>=20
> All open source apps we know now supports libv4l. On a few (like
> gstreamer), support for it is optional.
>=20
> In order to support closed source, another wrapper was added,
> allowing
> to call any closed source application to use it, by using LD_PRELOAD.
> For example, using skype with it is as simple as calling it with:
>=20
> 	$ LD_PRELOAD=3D/usr/lib/libv4l/v4l1compat.so
> /usr/bin/skypeforlinux
>=20
> 2. Current problems
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> 2.1 Libv4l can slow image handling
> ----------------------------------
>=20
> Nowadays, almost all new "simple" cameras are connected via USB using
> the UVC class (USB Video Class). UVC standardized the allowed
> formats,
> and most apps just implement them. The UVC hardware is more complex,
> having format converters inside it. So, for most usages, format
> conversion isn't needed anymore.
>=20
> The need of doing format conversion in software makes libv4l slow,
> requiring lots of CPU usage in order to convert a 4K or 8K format,
> being even worse with 3D cameras.
>=20
> Also, due to the need of supporting LD_PRELOAD, zero-buffer copy via
> DMA_BUFFER currently doesn't work with libv4l.
>=20
> Right now, gstreamer defaults to not enable libv4l2, mainly due to=20
> those performance issues.

I need to clarify a little bit on why we disabled libv4l2 in GStreamer,
as it's not only for performance reason, there is couple of major
issues in the libv4l2 implementation that get's in way. Just a short
list:

  - Crash when CREATE_BUFS is being used
  - Crash in the jpeg decoder (when frames are corrupted)
  - App exporting DMABuf need to be aware of emulation, otherwise the
    DMABuf exported are in the orignal format
  - RW emulation only initialize the queue on first read (causing=20
    userspace poll() to fail)
  - Signature of v4l2_mmap does not match mmap() (minor)
  - The colorimetry does not seem emulated when conversion
  - Sub-optimal locking (at least deadlocks were fixed)

Except for the colorimetry (which causes negotiation failure, as it
causes invalid colorimetry / format matches), these issues are already
worked around in GStreamer, but with the lost of features of course.
There is other cases were something worked without libv4l2, but didn't
work with libv4l2, but we haven't tracked down the cause.

For people working on this venue, since 1.14, you can enable libv4l2 at
run-time using env GST_V4L2_USE_LIBV4L2=3D1.

>=20
>=20
> 2.2 Modern hardware is starting to come with "complex" camera ISP
> -----------------------------------------------------------------
>=20
> While mc-based devices were limited to SoC, it was easy to
> "delegate" the task of talking with the hardware to the
> embedded hardware designers.
>=20
> However, this is changing. Dell Latitude 5285 laptop is a standard
> PC with an i3-core, i5-core or i7-core CPU, with comes with the
> Intel IMU3 ISP hardware[1]
>=20
> [1] https://www.spinics.net/lists/linux-usb/msg167478.html
>=20
> There, instead of an USB camera, the hardware is equipped with a
> MC-based ISP, connected to its camera. Currently, despite having
> a Kernel driver for it, the camera doesn't work with any
> userspace application.
>=20
> I'm also aware of other projects that are considering the usage of
> mc-based devices for non-dedicated hardware.
>=20
> 3. How to solve it?
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> That's the main focus of the meeting :-)
>=20
> From a previous discussion I had with media sub-maintainers, there
> are
> at least two actions that seem required. I'm listing them below as
> an starting point for the discussions, but we can eventually come up
> with some different approach after the meeting.
>=20
> 3.1 libv4l2 support for mc-based hardware
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> In order to support those hardware, we'll need to do some redesign
> mainly at libv4l2[2].
>=20
> The idea is to work on a new API for libv4l2 that will allow to
> split the format conversion on a separate part of it, add support
> for DMA Buffer and come up with a way for the library to work
> transparently with both devnode-based and mc-based hardware.
>=20
> That envolves adding capacity at libv4l to setup hardware pipelines
> and to propagate controls among their sub-devices. Eventually, part
> of it will be done in Kernel.
>=20
> That should give performance increase at the library and would allow
> gstreamer to use it by default, without compromising performance.
>=20
> [2] I don't discard that some Kernel changes could also be part of
> the
> solution, like, for example, doing control propagation along the
> pipeline
> on simple use case scenarios.
>=20
> 3.2 libv4l2 support for 3A algorithms
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> The 3A algorithm handing is highly dependent on the hardware. The
> idea here is to allow libv4l to have a set of 3A algorithms that
> will be specific to certain mc-based hardware. Ideally, this should
> be added in a way that it will allow external closed-source
> algorithms to run as well.
>=20
> Thanks,
> Mauro
--=-nPVLClvqvHLUFaqQAfMw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWv32bQAKCRBxUwItrAao
HEEwAKCl3qDCqLPWmgEEGEaQzaCFXnc+QACeMXxybVXP+PkiSyeFaJ3GfUc2daM=
=KMQL
-----END PGP SIGNATURE-----

--=-nPVLClvqvHLUFaqQAfMw--
