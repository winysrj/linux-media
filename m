Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41944 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750975AbeERPF3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 11:05:29 -0400
Date: Fri, 18 May 2018 12:05:22 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [ANN] Meeting to discuss improvements to support MC-based
 cameras on generic apps
Message-ID: <20180518120522.79b36f77@vento.lan>
In-Reply-To: <1731086.UqanYK9fHS@avalon>
References: <20180517160708.74811cfb@vento.lan>
        <1731086.UqanYK9fHS@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 18 May 2018 15:27:24 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Thursday, 17 May 2018 22:07:08 EEST Mauro Carvalho Chehab wrote:
> > Hi all,
> > 
> > The goal of this e-mail is to schedule a meeting in order to discuss
> > improvements at the media subsystem in order to support complex camera
> > hardware by usual apps.
> > 
> > The main focus here is to allow supporting devices with MC-based
> > hardware connected to a camera.
> > 
> > In short, my proposal is to meet with the interested parties on solving
> > this issue during the Open Source Summit in Japan, e. g. between
> > June, 19-22, in Tokyo.
> > 
> > I'd like to know who is interested on joining us for such meeting,
> > and to hear a proposal of themes for discussions.  
> 
> I want to attend the meeting, and will be in Tokyo during that period, so it 
> will be easy for me. Please note that I will give a talk at the Automotive 
> Linux Summit on Friday the 22nd at 15:15, so I won't be available during that 
> time and would prefer the meeting to happen earlier during the week (which 
> would also give us an opportunity for more discussions if one day turns out to 
> be too short).
> 
> > I'm enclosing a detailed description of the problem, in order to
> > allow the interested parties to be at the same page.
> > 
> > Regards,
> > Mauro
> > 
> > ---
> > 
> > 
> > 1. Introduction
> > ===============
> > 
> > 1.1 V4L2 Kernel aspects
> > -----------------------
> > 
> > The media subsystem supports two types of devices:
> > 
> > - "traditional" media hardware, supported via V4L2 API. On such hardware,
> >   opening a single device node (usually /dev/video0) is enough to control
> >   the entire device. We call it as devnode-based devices.  
> 
> To be precise, an application sometimes need to use multiple video nodes with 
> devnode-based drivers to capture multiple streams in parallel (when the 
> hardware allows it of course).
> 
> > - Media-controller based devices. On those devices, there are several
> >   /dev/video? nodes and several /dev/v4l2-subdev? nodes, plus a media
> >   controller device node (usually /dev/media0).  
> 
> To be precise again, there could be a single video node and a single subdev 
> node, although in practice there will likely be multiple subdevs.
> 
> >   We call it as mc-based devices. Controlling the hardware require
> >   opening the media device (/dev/media0), setup the pipeline and adjust
> >   the sub-devices via /dev/v4l2-subdev?. Only streaming is controlled
> >   by /dev/video?.  
> 
> That's the key difference, yes. Both configuration and streaming go through 
> the video device node on devnode-based drivers, while video device nodes are 
> only used for streaming on mc-based drivers.
> 
> > All "standard" media applications, including open source ones (Camorama,
> > Cheese, Xawtv, Firefox, Chromium, ...) and closed source ones (Skype,
> > Chrome, ...) supports devnode-based devices.  
> 
> To some extend at least. The closed-source applications tend to have various 
> bugs that prevent them from working properly on many devnode-based devices. 
> Skype is a good example, we had to include a software scaler in libv4l to make 
> it happy. So in practice not everything works smoothly with closed-source 
> applications (or even open-source ones) with devnode-based drivers. Where I 
> agree is that mc-based drivers are not supported at all by any of the 
> "regular" applications.
> 
> > Support for mc-based devices currently require an specialized application
> > in order to prepare the device for its usage (setup pipelines, adjust
> > hardware controls, etc). Once pipeline is set, the streaming goes via
> > /dev/video?, although usually some /dev/v4l2-subdev? devnodes should also
> > be opened, in order to implement algorithms designed to make video quality
> > reasonable. On such devices, it is not uncommon that the device used by the
> > application to be a random number (on OMAP3 driver, typically, is either
> > /dev/video4 or /dev/video6).  
> 
> The randomness is not unique to mc-based drivers, there's no guarantee that a 
> particular device will have a particular device node index even with devnode-
> based drivers.
> 
> > One example of such hardware is at the OMAP3-based hardware:
> > 
> > 	http://www.infradead.org/~mchehab/mc-next-gen/omap3-igepv2-with-tvp5150.png
> > 
> > On the picture, there's a graph with the hardware blocks in blue/dark/blue
> > and the corresponding devnode interfaces in yellow.
> > 
> > The mc-based approach was taken when support for Nokia N9/N900 cameras
> > was added (with has OMAP3 SoC). It is required because the camera hardware
> > on SoC comes with a media processor (ISP), with does a lot more than just
> > capturing, allowing complex algorithms to enhance image quality in runtime.
> > Those algorithms are known as 3A - an acronym for 3 other acronyms:
> > 
> > 	- AE (Auto Exposure);
> > 	- AF (Auto Focus);
> > 	- AWB (Auto White Balance).
> > 
> > Setting a camera with such ISPs are harder because the pipelines to be
> > set actually depends the requirements for those 3A algorithms to run.
> > Also, usually, the 3A algorithms use some chipset-specific userspace API,
> > that exports some image properties, calculated by the ISP, to speed up
> > the convergence of those algorithms.  
> 
> The main reason that drove the MC design is that the 3A algorithms (that is 
> the 3A control loop, and sometimes part of the image processing itself) often 
> need to run on the CPU. As a kernel-space implementation wasn't possible, we 
> needed a lower-level UAPI.
> 
> > Btw, usually, the 3A algorithms are IP-protected, provided by vendors
> > as binary only blobs, although there are a few OSS implementations.  
> 
> That's the very unfortunate current state. To the defense of vendors, we so 
> far have no proper userspace API to implement 3A libraries. The open-source 
> implementations suffer from the same problem. I hope for a positive evolution 
> in this domain once we provide a userspace camera stack.
> 
> > 1.2 V4L2 userspace aspects
> > --------------------------
> > 
> > Back when USB cameras were introduced, the hardware were really simple:
> > they had a CCD camera sensor and a chip that bridges the data though
> > USB. CCD camera sensors typically provide data using a bayer format,
> > but they usually have their own proprietary ways to pack the data,
> > in order to reduce the USB bandwidth (original cameras were USB 1.1).  
> 
> Do you mean CMOS instead of CCD ?
> 
> > So, V4L2 has a myriad of different formats, in order to match each
> > CCD camera sensor format.  
> 
> While several webcams use custom formats, those are often related to custom 
> compression performed by the USB bridge, so it's not really related to the 
> sensor itself.

Yes, on several cases, the custom format is at the bridge, and not at
the sensor itself. Anyway, the point is that format conversion used to
be a key feature in order for video apps to work with different cameras.

> > At the end of the day, applications were able to use only a subset of the
> > available hardware, since they need to come with format converters for all
> > formats the developer uses (usually a very small subset of the available
> > ones).  
> 
> Note that this was only transitory, as webcams then converged towards a small 
> set of standard formats (even if recent webcams also implement custom formats, 
> but that's usually related to secondary data streams such as depth maps, or to 
> non-consumer cameras such as industrial cameras).

We are still adding new fourcc formats nowadays. IMHO, there's now a 
certain stability/convergence on formats, although newer cameras with 
advanced features (like 3D and light-field) will very likely require new
formats.

> > To end with this mess, an userspace library was written, called libv4l.
> > It supports all those proprietary formats. So, applications can use
> > a RGB or YUV format, without needing to concern about conversions.
> > 
> > The way it works is by adding wrappers to system calls: open, close,
> > ioctl, mmap, mmunmap. So, a conversion to use it is really simple:
> > at the source code of the apps, all it was needed is to prepend the
> > existing calls with "v4l2_", e. g. v4l2_open, v4l2_close, etc.
> > 
> > All open source apps we know now supports libv4l. On a few (like
> > gstreamer), support for it is optional.
> > 
> > In order to support closed source, another wrapper was added, allowing
> > to call any closed source application to use it, by using LD_PRELOAD.
> > For example, using skype with it is as simple as calling it with:
> > 
> > 	$ LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so /usr/bin/skypeforlinux  
> 
> It should be noted that libv4l also handles scaling (Skype requires 640x480 if 
> I remember correctly, or at least used to, and would crash if given another 
> resolution) and rough auto-gain and auto-white balance that are required by 
> some cameras to achieve a usable image.
> 
> > 2. Current problems
> > ===================
> > 
> > 2.1 Libv4l can slow image handling
> > ----------------------------------
> > 
> > Nowadays, almost all new "simple" cameras are connected via USB using
> > the UVC class (USB Video Class). UVC standardized the allowed formats,
> > and most apps just implement them. The UVC hardware is more complex,
> > having format converters inside it. So, for most usages, format
> > conversion isn't needed anymore.
> > 
> > The need of doing format conversion in software makes libv4l slow,
> > requiring lots of CPU usage in order to convert a 4K or 8K format,
> > being even worse with 3D cameras.  
> 
> I would hope that libv4l doesn't perform conversion unnecessarily if not 
> needed. The main issue, as I understand it, is that application may fail to 
> notice that some formats require software conversion, and prefer them over 
> formats provided directly by the device even when such hardware formats are 
> supported by the application. We have introduced the V4L2_FMT_FLAG_EMULATED 
> flag in the kernel API in order for libv4l to flag emulated formats, but 
> applications may fail to see it.

I don't see how an application may fail to see it. If libv4l is used, the
flag will be there. This is not a new flag. Apps can easily look into it
and opt to use non-emulated formats. On non-emulated formats, there won't
be unnecessarily format conversions.

Granted, applications may opt to not use it, and just select an specific
format, but it is an application choice to either use it or not.

> (On a personal note, I think that extending the kernel API with features that 
> are not used by the kernel might not be the best API design decision we've 
> ever made, it questions whether the libv4l API design was right.)
> 
> > Also, due to the need of supporting LD_PRELOAD, zero-buffer copy via
> > DMA_BUFFER currently doesn't work with libv4l.
> > 
> > Right now, gstreamer defaults to not enable libv4l2, mainly due to
> > those performance issues.
> > 
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
> > Intel IMU3 ISP hardware[1]

Typo:
	IMU3 -> IPU3

> > 
> > [1] https://www.spinics.net/lists/linux-usb/msg167478.html  
> 
> Do you think it's changing, or could that be an exception rather than a future 
> rule ?

Well, on ARM, all SoC chipsets I'm aware have an ISP IP block. As Intel is 
now adding IPU3 on some of their chipsets, I think that we'll see more and
more hardware with it.

I don't have a crystal ball, but I guess that the trend would be to keep using
USB with UVC for external cameras, but some ISP-based hardware for the
internal ones.

> 
> > There, instead of an USB camera, the hardware is equipped with a
> > MC-based ISP, connected to its camera. Currently, despite having
> > a Kernel driver for it, the camera doesn't work with any
> > userspace application.
> > 
> > I'm also aware of other projects that are considering the usage of
> > mc-based devices for non-dedicated hardware.  
> 
> What are those projects ?

Well, cheap ARM-based hardware like RPi3 already has this issue: they
have an ISP (or some GPU firmware meant to emulate an ISP). While
those hardware could have multiple sensors, typically they have just
one.

> 
> > 3. How to solve it?
> > ===================
> > 
> > That's the main focus of the meeting :-)
> > 
> > From a previous discussion I had with media sub-maintainers, there are
> > at least two actions that seem required. I'm listing them below as
> > an starting point for the discussions, but we can eventually come up
> > with some different approach after the meeting.
> > 
> > 3.1 libv4l2 support for mc-based hardware
> > =========================================
> > 
> > In order to support those hardware, we'll need to do some redesign
> > mainly at libv4l2[2].  
> 
> I wouldn't necessarily focus on libv4l2.
> 
> What I believe we need is to design a userspace camera stack that will support 
> the features needed by more modern cameras. Let's keep the dogmas aside, if 
> libv4l2 turns out to be the right option we can certainly go for it, but if we 
> find out that another option is better (Nicolas mentioned Pipewire, I have no 
> personal opinion about that yet, and there could be other options too), then 
> so be it.
> Then, once we get a proper camera stack, we need to support traditional 
> applications that use libv4l2 and/or the V4L2 API directly. To that end we 
> will need to expose the libv4l2 API on top of the camera stack (through 
> libv4l2 if it makes sense, or through a separate implementation) and implement 
> a transparent LD_PRELOAD-based library (again either through libv4l2 or 
> through a separate implementation).
> 
> I'm certainly not calling for libv4l2 to be thrown away, but I think the 
> problem is complex enough without adding an artificial requirement of basing 
> the camera stack on a particular existing implementation. As long as we 
> achieve compatibility with the existing libv4l2 API and the V4L2 API I believe 
> we don't need to add any specific implementation restriction. What matters the 
> most to me is achieving a maintainable camera stack with a good API that 
> supports all our needs, and providing a compatibility layer on top of it.
> 
> (On that note, even if we end up using libv4l2 as the base, we will likely nd 
> up with a modified and incompatible main API anyway, with the need to provide 
> support for the existing API on top. That's why I think it doesn't matter much 
> if we decide to refactor libv4l2 or start from scratch and possibly reuse part 
> of the libv4l2 code.)
> 

Yeah, agreed. On this stage, we shouldn't be limited to libv4l2 or its
current implementation. The hole idea of the discussions is to understand
the alternatives and chose a clear path for us to fix the issue.

> > The idea is to work on a new API for libv4l2 that will allow to
> > split the format conversion on a separate part of it, add support
> > for DMA Buffer and come up with a way for the library to work
> > transparently with both devnode-based and mc-based hardware.
> > 
> > That envolves adding capacity at libv4l to setup hardware pipelines
> > and to propagate controls among their sub-devices. Eventually, part
> > of it will be done in Kernel.  
> 
> Which part do you mean exactly ?

I don't mean any specific part. Just saying that we shouldn't discard that
some Kernel support could be implemented in order to make easier to 
implement/maintain it.

> > That should give performance increase at the library and would allow
> > gstreamer to use it by default, without compromising performance.
> > 
> > [2] I don't discard that some Kernel changes could also be part of the
> > solution, like, for example, doing control propagation along the pipeline
> > on simple use case scenarios.  
> 
> We've tried that in the past and it was both cumbersome and not very useful. I 
> won't rule out kernel changes for the sake of it, but I'd rather focus on use 
> cases, and find for each of them the best possible implementation. In my 
> opinion we will find that most, if not all, of the new features and changes 
> would be better implemented in userspace.
> 
> > 3.2 libv4l2 support for 3A algorithms
> > =====================================
> > 
> > The 3A algorithm handing is highly dependent on the hardware. The
> > idea here is to allow libv4l to have a set of 3A algorithms that
> > will be specific to certain mc-based hardware. Ideally, this should
> > be added in a way that it will allow external closed-source
> > algorithms to run as well.  
> 
> As much as I dislike closed-source components, I don't think we "ideally" need 
> to support them, I believe they're mandatory if we want any vendor to use our 
> camera stack (unless someone can find enough resources to implement a product-
> quality 3A library that will work with all ISPs available out there, but I 
> don't think that's a reasonable assumption to start with).
> 
> My personal requirements for a 3A library are:
> 
> - The 3A library API must be standardized, to allow the closed-source vendor 
> implementation to be replaced by an open-source implementation should someone 
> have the time and energy (and qualifications) to write one.
> 
> - Sandboxed execution of the 3A library must be possible as closed-source 
> vendor code can't always be blindly trusted (that's an understatement). This 
> includes the ability to wrap the library in a daemon should the platform's 
> multimedia stack wishes, and to avoid any direct access to the kernel devices 
> by the 3A library itself (all accesses should be marshaled by the camera 
> stack).
> 
> Please note that this daemon is *not* a camera daemon as used by Qualcomm or 
> other vendors that communicates with the V4L2 driver through a custom back 
> channel. I want the kernel driver to implement the V4L2 API and to be usable 
> without any daemon. The decision to run the 3A library in a sandboxed process 
> or to call it directly from the camera stack should be left to the camera 
> stack and to the platform integrator, and should not be visible by the 3A 
> library.
> 
> - The 3A library must be usable on major Linux-based camera stacks (the 
> Android and Chrome OS camera HALs are certainly important targets, more can be 
> added) unmodified, which will allow usage of the vendor binary provided for 
> Chrome OS or Android on regular Linux systems.

One of the issues with closed-source components is that they usually
have dependencies that end being distro-dependent and arch-dependent [1].

[1] on a side note, I have here one example of a hardware that depends on
a closed-source plugin: a HP Laserjet USB printer/scanner. I would love
to use it connected to an Exynos hardware here, but the closed-source
plugin only works on x86, forcing me to connect to one desktop. The side
effect is that, every time I upgrade CUPS, the printer stops working, 
as it waits for me to download the newest plugin that is compatible with
such version. That's specially evil when I travel, as other people here
won't be able to print anything, until I remotely connect to it and
upgrade the plugin. Really nasty.

> On that note, I believe it would make sense to design a modular camera stack, 
> and try to make most components as platform-independent as possible. This 
> should include the kernel drivers (V4L2-compliant and usable without any 
> closed-source userspace component), the 3A library, and any other component 
> that could be shared (for instance a possible request API library). The rest 
> of the code will mostly be glue around those components to integrate them in a 
> particular camera stack, and should be as platform-agnostic as possible. 
> Ideally I would like to see one Android camera HAL glue that could be used 
> with different camera vendors (probably with some kind of vendor-specific 
> configuration, or possibly with a separate vendor-specific component to handle 
> pipeline configuration).

Makes sense.

Thanks,
Mauro
