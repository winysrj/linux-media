Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:42934 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751384AbeERPhu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 11:37:50 -0400
Received: by mail-vk0-f44.google.com with SMTP id j7-v6so5065925vkc.9
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 08:37:49 -0700 (PDT)
Received: from mail-ua0-f178.google.com (mail-ua0-f178.google.com. [209.85.217.178])
        by smtp.gmail.com with ESMTPSA id i144-v6sm1928655vke.36.2018.05.18.08.37.47
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 May 2018 08:37:47 -0700 (PDT)
Received: by mail-ua0-f178.google.com with SMTP id v17-v6so5636064uak.6
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 08:37:47 -0700 (PDT)
MIME-Version: 1.0
References: <20180517160708.74811cfb@vento.lan>
In-Reply-To: <20180517160708.74811cfb@vento.lan>
From: Tomasz Figa <tfiga@chromium.org>
Date: Sat, 19 May 2018 00:37:34 +0900
Message-ID: <CAAFQd5Cca1E+LAWuGU9Q+j172XTE5Bevg0HABBdDMMU+gr_jxg@mail.gmail.com>
Subject: Re: [ANN] Meeting to discuss improvements to support MC-based cameras
 on generic apps
To: mchehab+samsung@kernel.org
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

+Hu, Jerry W +Mani, Rajmohan +Sakari Ailus

FYI
On Fri, May 18, 2018 at 4:07 AM Mauro Carvalho Chehab <
mchehab+samsung@kernel.org> wrote:

> Hi all,

> The goal of this e-mail is to schedule a meeting in order to discuss
> improvements at the media subsystem in order to support complex camera
> hardware by usual apps.

> The main focus here is to allow supporting devices with MC-based
> hardware connected to a camera.

> In short, my proposal is to meet with the interested parties on solving
> this issue during the Open Source Summit in Japan, e. g. between
> June, 19-22, in Tokyo.

> I'd like to know who is interested on joining us for such meeting,
> and to hear a proposal of themes for discussions.

> I'm enclosing a detailed description of the problem, in order to
> allow the interested parties to be at the same page.

> Regards,
> Mauro

> ---


> 1. Introduction
> ===============

> 1.1 V4L2 Kernel aspects
> -----------------------

> The media subsystem supports two types of devices:

> - "traditional" media hardware, supported via V4L2 API. On such hardware,
>    opening a single device node (usually /dev/video0) is enough to control
>    the entire device. We call it as devnode-based devices.

> - Media-controller based devices. On those devices, there are several
>    /dev/video? nodes and several /dev/v4l2-subdev? nodes, plus a media
>    controller device node (usually /dev/media0).
>    We call it as mc-based devices. Controlling the hardware require
>    opening the media device (/dev/media0), setup the pipeline and adjust
>    the sub-devices via /dev/v4l2-subdev?. Only streaming is controlled
>    by /dev/video?.

> All "standard" media applications, including open source ones (Camorama,
> Cheese, Xawtv, Firefox, Chromium, ...) and closed source ones (Skype,
> Chrome, ...) supports devnode-based devices.

> Support for mc-based devices currently require an specialized application
> in order to prepare the device for its usage (setup pipelines, adjust
> hardware controls, etc). Once pipeline is set, the streaming goes via
> /dev/video?, although usually some /dev/v4l2-subdev? devnodes should also
> be opened, in order to implement algorithms designed to make video quality
> reasonable. On such devices, it is not uncommon that the device used by
the
> application to be a random number (on OMAP3 driver, typically, is either
> /dev/video4 or /dev/video6).

> One example of such hardware is at the OMAP3-based hardware:


http://www.infradead.org/~mchehab/mc-next-gen/omap3-igepv2-with-tvp5150.png

> On the picture, there's a graph with the hardware blocks in blue/dark/blue
> and the corresponding devnode interfaces in yellow.

> The mc-based approach was taken when support for Nokia N9/N900 cameras
> was added (with has OMAP3 SoC). It is required because the camera hardware
> on SoC comes with a media processor (ISP), with does a lot more than just
> capturing, allowing complex algorithms to enhance image quality in
runtime.
> Those algorithms are known as 3A - an acronym for 3 other acronyms:

>          - AE (Auto Exposure);
>          - AF (Auto Focus);
>          - AWB (Auto White Balance).

> Setting a camera with such ISPs are harder because the pipelines to be
> set actually depends the requirements for those 3A algorithms to run.
> Also, usually, the 3A algorithms use some chipset-specific userspace API,
> that exports some image properties, calculated by the ISP, to speed up
> the convergence of those algorithms.

> Btw, usually, the 3A algorithms are IP-protected, provided by vendors
> as binary only blobs, although there are a few OSS implementations.

> 1.2 V4L2 userspace aspects
> --------------------------

> Back when USB cameras were introduced, the hardware were really simple:
> they had a CCD camera sensor and a chip that bridges the data though
> USB. CCD camera sensors typically provide data using a bayer format,
> but they usually have their own proprietary ways to pack the data,
> in order to reduce the USB bandwidth (original cameras were USB 1.1).

> So, V4L2 has a myriad of different formats, in order to match each
> CCD camera sensor format. At the end of the day, applications were
> able to use only a subset of the available hardware, since they need
> to come with format converters for all formats the developer uses
> (usually a very small subset of the available ones).

> To end with this mess, an userspace library was written, called libv4l.
> It supports all those proprietary formats. So, applications can use
> a RGB or YUV format, without needing to concern about conversions.

> The way it works is by adding wrappers to system calls: open, close,
> ioctl, mmap, mmunmap. So, a conversion to use it is really simple:
> at the source code of the apps, all it was needed is to prepend the
> existing calls with "v4l2_", e. g. v4l2_open, v4l2_close, etc.

> All open source apps we know now supports libv4l. On a few (like
> gstreamer), support for it is optional.

> In order to support closed source, another wrapper was added, allowing
> to call any closed source application to use it, by using LD_PRELOAD.
> For example, using skype with it is as simple as calling it with:

>          $ LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so /usr/bin/skypeforlinux

> 2. Current problems
> ===================

> 2.1 Libv4l can slow image handling
> ----------------------------------

> Nowadays, almost all new "simple" cameras are connected via USB using
> the UVC class (USB Video Class). UVC standardized the allowed formats,
> and most apps just implement them. The UVC hardware is more complex,
> having format converters inside it. So, for most usages, format
> conversion isn't needed anymore.

> The need of doing format conversion in software makes libv4l slow,
> requiring lots of CPU usage in order to convert a 4K or 8K format,
> being even worse with 3D cameras.

> Also, due to the need of supporting LD_PRELOAD, zero-buffer copy via
> DMA_BUFFER currently doesn't work with libv4l.

> Right now, gstreamer defaults to not enable libv4l2, mainly due to
> those performance issues.


> 2.2 Modern hardware is starting to come with "complex" camera ISP
> -----------------------------------------------------------------

> While mc-based devices were limited to SoC, it was easy to
> "delegate" the task of talking with the hardware to the
> embedded hardware designers.

> However, this is changing. Dell Latitude 5285 laptop is a standard
> PC with an i3-core, i5-core or i7-core CPU, with comes with the
> Intel IMU3 ISP hardware[1]

> [1] https://www.spinics.net/lists/linux-usb/msg167478.html

> There, instead of an USB camera, the hardware is equipped with a
> MC-based ISP, connected to its camera. Currently, despite having
> a Kernel driver for it, the camera doesn't work with any
> userspace application.

> I'm also aware of other projects that are considering the usage of
> mc-based devices for non-dedicated hardware.

> 3. How to solve it?
> ===================

> That's the main focus of the meeting :-)

>  From a previous discussion I had with media sub-maintainers, there are
> at least two actions that seem required. I'm listing them below as
> an starting point for the discussions, but we can eventually come up
> with some different approach after the meeting.

> 3.1 libv4l2 support for mc-based hardware
> =========================================

> In order to support those hardware, we'll need to do some redesign
> mainly at libv4l2[2].

> The idea is to work on a new API for libv4l2 that will allow to
> split the format conversion on a separate part of it, add support
> for DMA Buffer and come up with a way for the library to work
> transparently with both devnode-based and mc-based hardware.

> That envolves adding capacity at libv4l to setup hardware pipelines
> and to propagate controls among their sub-devices. Eventually, part
> of it will be done in Kernel.

> That should give performance increase at the library and would allow
> gstreamer to use it by default, without compromising performance.

> [2] I don't discard that some Kernel changes could also be part of the
> solution, like, for example, doing control propagation along the pipeline
> on simple use case scenarios.

> 3.2 libv4l2 support for 3A algorithms
> =====================================

> The 3A algorithm handing is highly dependent on the hardware. The
> idea here is to allow libv4l to have a set of 3A algorithms that
> will be specific to certain mc-based hardware. Ideally, this should
> be added in a way that it will allow external closed-source
> algorithms to run as well.

> Thanks,
> Mauro
