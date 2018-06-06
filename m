Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57124 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932514AbeFFQ0S (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 12:26:18 -0400
Date: Wed, 6 Jun 2018 13:26:10 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Tomasz Figa <tfiga@chromium.org>
Cc: linux-media@vger.kernel.org, javier@dowhile0.org,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        kieran.bingham@ideasonboard.com, niklas.soderlund@ragnatech.se,
        jian.xu.zheng@intel.com, dave.stevenson@raspberrypi.org,
        sw0312.kim@samsung.com, inki.dae@samsung.com, nicolas@ndufresne.ca
Subject: Re: [ANN v2] Complex Camera Workshop - Tokyo - Jun, 19
Message-ID: <20180606132610.5615f46f@coco.lan>
In-Reply-To: <CAAFQd5A13oivxg-m2vpPxBjBAsn8NLJx4_ups2p+j0uHaoiOng@mail.gmail.com>
References: <20180604103303.6a6b792b@vento.lan>
        <CAAFQd5A13oivxg-m2vpPxBjBAsn8NLJx4_ups2p+j0uHaoiOng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 6 Jun 2018 13:19:39 +0900
Tomasz Figa <tfiga@chromium.org> escreveu:

> On Mon, Jun 4, 2018 at 10:33 PM Mauro Carvalho Chehab
> <mchehab+samsung@kernel.org> wrote:
> >
> > Hi all,
> >
> > I consolidated hopefully all comments I receive on the past announcement
> > with regards to the complex camera workshop we're planning to happen in
> > Tokyo, just before the Open Source Summit in Japan.
> >
> > The main focus of the workshop is to allow supporting devices with MC-b=
ased
> > hardware connected to a camera.
> >
> > I'm enclosing a detailed description of the problem, in order to
> > allow the interested parties to be at the same page.
> >
> > We need to work towards an agenda for the meeting.
> >
> > From my side, I think we should have at least the following topics at
> > the agenda:
> >
> > - a quick review about what's currently at libv4l2;
> > - a presentation about PipeWire solution;
> > - a discussion with the requirements for the new solution;
> > - a discussion about how we'll address - who will do what. =20
>=20
> I believe Intel's Jian Xu would be able to give us some brief
> introduction to IPU3 hardware architecture and possibly also upcoming
> hardware generations as well.

That would be great!

> My experience with existing generations of ISPs from other vendors is
> that the main principles of operation are very similar to the model
> represented by IPU3 and very much different to the OMAP3 example
> mentioned by Mauro below. I further commented on it below.
>=20
> >
> > Comments? Suggestions?
> >
> > Are there anyone else planning to either be there physically or via
> > Google Hangouts?
> >
> > Tomaz,
> >
> > Do you have any limit about the number of people that could join us
> > via Google Hangouts?
> > =20
>=20
> Technically, Hangouts should be able to work with really huge
> multi-party conferences. There is obviously some limitation on client
> side, since thumbnails of participants need to be decoded at real
> time, so even if the resolution is low, if the client is very slow,
> there might be some really bad frame drop happening on client side.
>=20
> However, I often have meetings with around 8 parties and it tends to
> work fine. We can also disable video of all participants, who don't
> need to present anything at the moment and the problem would go away
> completely.

Ok, good!

> > Regards,
> > Mauro
> >
> > ---
> >
> > 1. Introduction
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > 1.1 V4L2 Kernel aspects
> > -----------------------
> >
> > The media subsystem supports two types of devices:
> >
> > - "traditional" media hardware, supported via V4L2 API. On such hardwar=
e,
> >   opening a single device node (usually /dev/video0) is enough to contr=
ol
> >   the entire device. We call it as devnode-based devices.
> >   An application sometimes may need to use multiple video nodes with
> >   devnode-based drivers to capture multiple streams in parallel
> >   (when the hardware allows it of course). That's quite common for
> >   Analog TV devices, where both /dev/video0 and /dev/vbi0 are opened
> >   at the same time.
> >
> > - Media-controller based devices. On those devices, there are typically
> >   several /dev/video? nodes and several /dev/v4l2-subdev? nodes, plus
> >   a media controller device node (usually /dev/media0).
> >   We call it as mc-based devices. Controlling the hardware require
> >   opening the media device (/dev/media0), setup the pipeline and adjust
> >   the sub-devices via /dev/v4l2-subdev?. Only streaming is controlled
> >   by /dev/video?.
> >
> > In other words, both configuration and streaming go through the video
> > device node on devnode-based drivers, while video device nodes are used
> > used for streaming on mc-based drivers.
> >
> > With devnode-based drivers, "standard" media applications, including op=
en
> > source ones (Camorama, Cheese, Xawtv, Firefox, Chromium, ...) and closed
> > source ones (Skype, Chrome, ...) support devnode-based devices[1]. Also,
> > when just one media device is connected, the streaming/control device
> > is typically /dev/video0.
> >
> > [1] It should be noticed that closed-source applications tend to have
> > various bugs that prevent them from working properly on many devnode-ba=
sed
> > devices. Due to that, some additional blocks were requred at libv4l to
> > support some of them. Skype is a good example, as we had to include a
> > software scaler in libv4l to make it happy. So in practice not everythi=
ng
> > works smoothly with closed-source applications with devnode-based drive=
rs.
> > A few such adjustments were also made on some drivers and/or libv4l, in
> > order to fulfill some open-source app requirements.
> >
> > Support for mc-based devices currently require an specialized applicati=
on
> > in order to prepare the device for its usage (setup pipelines, adjust
> > hardware controls, etc). Once pipeline is set, the streaming goes via
> > /dev/video?, although usually some /dev/v4l2-subdev? devnodes should al=
so
> > be opened, in order to implement algorithms designed to make video qual=
ity
> > reasonable. =20
>=20
> To further complicate the problem, on many modern imaging subsystems
> (Intel IPU3, Rockchip RKISP1), there is more than 1 video output
> (CAPTURE device), for example:
> 1) full resolution capture stream and
> 2) downscaled preview stream.

OMAP3 also has both full-res and downscaled for previews, on separate
/dev/video.

On a "simple" usecase (like PC apps and videoconference), just one
/dev/video is enough. For devices used to take static pictures,
both streams are important.

> Moreover, many ISPs also produce per-frame metadata (statistics) for
> 3A algorithms, which then produces per-frame metadata (parameters) for
> processing of next frame. These would be also exposed as /dev/video?
> nodes with respective V4L2_BUF_TYPE_META_* queues.

True, but the metadata frames don't need to go the the application,
as it will be consumed by the 3A logic.

>=20
> It is complicated even more on systems with separate input (e.g. CSI2)
> and processing (ISP) hardware, such as Intel IPU3. In such case, the
> raw frames captured from the CSI2 interface directly are not usable
> for end-user applications. This means that some component in userspace
> needs to forward the raw frames to the ISP and only the output of the
> ISP can be passed to the application.

Yes. Nowadays, several devices do the same.

> > On such devices, it is not uncommon that the device used by the
> > application to be a random number (on OMAP3 driver, typically, is either
> > /dev/video4 or /dev/video6).
> >
> > One example of such hardware is at the OMAP3-based hardware:
> >
> >         http://www.infradead.org/~mchehab/mc-next-gen/omap3-igepv2-with=
-tvp5150.png
> >
> > On the picture, there's a graph with the hardware blocks in blue/dark/b=
lue
> > and the corresponding devnode interfaces in yellow.
> >
> > The mc-based approach was taken when support for Nokia N9/N900 cameras
> > was added (with has OMAP3 SoC). It is required because the camera hardw=
are
> > on SoC comes with a media processor (ISP), with does a lot more than ju=
st
> > capturing, allowing complex algorithms to enhance image quality in runt=
ime.
> > Those algorithms are known as 3A - an acronym for 3 other acronyms:
> >
> >         - AE (Auto Exposure);
> >         - AF (Auto Focus);
> >         - AWB (Auto White Balance).
> >
> > The main reason that drove the MC design is that the 3A algorithms (tha=
t is
> > the 3A control loop, and sometimes part of the image processing itself)=
 often
> > need to run, at least partially, on the CPU. As a kernel-space implemen=
tation
> > wasn't possible, we needed a lower-level UAPI.
> >
> > Setting a camera with such ISPs are harder because the pipelines to be
> > set actually depends the requirements for those 3A algorithms to run.
> > Also, usually, the 3A algorithms use some chipset-specific userspace AP=
I,
> > that exports some image properties, calculated by the ISP, to speed up
> > the convergence of those algorithms.
> >
> > Btw, usually, the 3A algorithms are IP-protected, provided by vendors
> > as binary only blobs, although there are a few OSS implementations.
> >
> > Part of the problem is that, so far, there isn't a proper userspace API
> > to implement 3A libraries. Once we have an userspace camera stack, we
> > hope that we'll gradually increase the number and quality of open-source
> > 3A stacks.
> > =20
> [snip]
> >
> > 2.2 Modern hardware is starting to come with "complex" camera ISP
> > -----------------------------------------------------------------
> >
> > While mc-based devices were limited to SoC, it was easy to
> > "delegate" the task of talking with the hardware to the
> > embedded hardware designers.
> >
> > However, this is changing. Dell Latitude 5285 laptop is a standard
> > PC with an i3-core, i5-core or i7-core CPU, with comes with the
> > Intel IMU3 ISP hardware[2]. =20
>=20
> IPU3 :)

Yeah, I noticed the typo too late. I actually fixed it at the announcement
at linuxtv.org.

> >
> > [2] https://www.spinics.net/lists/linux-usb/msg167478.html
> >
> > There, instead of an USB camera, the hardware is equipped with a
> > MC-based ISP, connected to its camera. Currently, despite having
> > a Kernel driver for it, the camera doesn't work with any
> > userspace application.
> >
> > I'm also aware of other projects that are considering the usage of
> > mc-based devices for non-dedicated hardware.
> > =20
> [snip]
> >
> > 3.2 libv4l2 support for 3A algorithms
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > The 3A algorithm handing is highly dependent on the hardware. The
> > idea here is to allow libv4l to have a set of 3A algorithms that
> > will be specific to certain mc-based hardware.
> >
> > One requirement, if we want vendor stacks to use our solution, is that
> > it should allow allow external closed-source algorithms to run as well.
> >
> > The 3A library API must be standardized, to allow the closed-source
> > vendor implementation to be replaced by an open-source implementation
> > should someone have the time and energy (and qualifications) to write
> > one.
> >
> > Sandboxed execution of the 3A library must be possible as closed-source
> > can't always be blindly trusted. This includes the ability to wrap the
> > library in a daemon should the platform's multimedia stack wishes
> > and to avoid any direct access to the kernel devices by the 3A library
> > itself (all accesses should be marshaled by the camera stack).
> >
> > Please note that this daemon is *not* a camera daemon that would
> > communicates with the V4L2 driver through a custom back channel.
> >
> > The decision to run the 3A library in a sandboxed process or to call
> > it directly from the camera stack should be left to the camera stack
> > and to the platform integrator, and should not be visible by the 3A
> > library.
> >
> > The 3A library must be usable on major Linux-based camera stacks (the
> > Android and Chrome OS camera HALs are certainly important targets,
> > more can be added) unmodified, which will allow usage of the vendor
> > binary provided for Chrome OS or Android on regular Linux systems. =20
>=20
> This is quite an interesting idea and it would be really useful if it
> could be done. I'm kind of worried, though, about Android in
> particular, since the execution environment in Android differs
> significantly from a regular Linux distributions (including Chrome OS,
> which is not so far from such), namely:
> - different libc (bionic) and dynamic linker - I guess this could be
> solved by static linking?

Static link is one possible solution. IMHO, we should try to make it
use just a C library (if possible) and be sure that it will also compile
with bionic/ulibc in order to make it easier to be used by Android and
other embedded distros.

> - dedicated toolchains - perhaps not much of a problem if the per-arch
> ABI is the same?

Depending on library dependency, we could likely make it work with more
than one toolchain. I guess acconfig works with Android, right?
If so, it could auto-adjust to the different toolchains everywhere.

> > It would make sense to design a modular camera stack, and try to make
> > most components as platform-independent as possible. This should includ=
e:
> >
> > - the kernel drivers (V4L2-compliant and usable without any closed-sour=
ce
> >   userspace component);
> > - the 3A library
> > - any other component that could be shared (for instance a possible
> >   request API library).
> >
> > The rest of the code will mostly be glue around those components to
> > integrate them in a particular camera stack, and should be as
> > platform-agnostic as possible.
> >
> > In the case of the Android camera HAL, ideally it would be a glue that
> > could be used with different camera vendors (probably with some kind of
> > vendor-specific configuration, or possibly with a separate vendor-speci=
fic
> > component to handle pipeline configuration).
> >
> > 4 Complex camera workshop
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> >
> > The workshop will be happening in Tokyo, Japan, at Jun, 19, at the
> > google offices. The location is:
> >
> > =E3=80=92106-6126 Tokyo, Minato, Roppongi, 6 Chome=E2=88=9210=E2=88=921=
 Roppongi Hills Mori Tower 44F =20
>=20
> Nearest station exits:
> - Hibiya line Roppongi station exit 1c (recommended)
> - Oedo line Roppongi station exit 3 (and few minutes walk)
>=20
> >
> > 4.1 Physical Attendees
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Tomasz Figa <tfiga@google.com>
> > Mauro Carvalho Chehab <Mauro Carvalho Chehab <mchehab+samsung@kernel.or=
g>
> > Kieran Bingham <kieran.bingham@ideasonboard.com>
> > Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Niklas S=C3=B6derlund <niklas.soderlund@ragnatech.se>
> > Zheng, Jian Xu Zheng <jian.xu.zheng@intel.com>
> >
> > Anywone else? =20
>=20
> Looking at latest reply in this thread:
>=20
> jacopo mondi <jacopo@jmondi.org>
>=20
> Anyone else, please tell me beforehand (at least 1-2 days before), as
> I need to take care of building access, since it's a multi-tenant
> office building. I'll contact each attendee separately with further
> details by email.
>=20
> >
> > 4.2. Attendees Via Google Hangouts
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Hans Verkuil <hverkuil@xs4all.nl> - Via Google Hangouts - maybe only on=
 afternoon
> > Javier Martinez Canillas <javier@dowhile0.org> - Via Google Hangouts - =
only on reasonable TZ-compatible-hours =20
>=20
> What time zone would that be? I guess we could try to tweak the agenda
> to take this into account.

Thanks,
Mauro
