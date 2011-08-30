Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:34195 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568Ab1H3Uef (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 16:34:35 -0400
Date: Tue, 30 Aug 2011 23:34:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: Embedded device and the  V4L2 API support - Was: [GIT PATCHES
 FOR 3.1] s5p-fimc and noon010pc30 driver updates
Message-ID: <20110830203428.GH12368@valkosipuli.localdomain>
References: <201108151430.42722.laurent.pinchart@ideasonboard.com>
 <4E49B60C.4060506@redhat.com>
 <201108161057.57875.laurent.pinchart@ideasonboard.com>
 <4E4A8D27.1040602@redhat.com>
 <4E4AE583.6050308@gmail.com>
 <4E4B5C27.3000008@redhat.com>
 <4E4F9A0B.4050302@gmail.com>
 <4E4FA4C8.4050703@redhat.com>
 <20110824222925.GR8872@valkosipuli.localdomain>
 <4E56438C.1070102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E56438C.1070102@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thu, Aug 25, 2011 at 09:43:56AM -0300, Mauro Carvalho Chehab wrote:
> Em 24-08-2011 19:29, Sakari Ailus escreveu:
> > Hi Mauro,
> > 
> > On Sat, Aug 20, 2011 at 05:12:56AM -0700, Mauro Carvalho Chehab wrote:
> >> Em 20-08-2011 04:27, Sylwester Nawrocki escreveu:
> >>> Hi Mauro,
> >>>
> >>> On 08/17/2011 08:13 AM, Mauro Carvalho Chehab wrote:
> >>>> It seems that there are too many miss understandings or maybe we're just
> >>>> talking the same thing on different ways.
> >>>>
> >>>> So, instead of answering again, let's re-start this discussion on a
> >>>> different way.
> >>>>
> >>>> One of the requirements that it was discussed a lot on both mailing
> >>>> lists and on the Media Controllers meetings that we had (or, at least
> >>>> in the ones where I've participated) is that:
> >>>>
> >>>> 	"A pure V4L2 userspace application, knowing about video device
> >>>> 	 nodes only, can still use the driver. Not all advanced features
> >>>> 	 will be available."
> >>>
> >>> What does a term "a pure V4L2 userspace application" mean here ?
> >>
> >> The above quotation are exactly the Laurent's words that I took from one 
> >> of his replies.
> > 
> > I would define this as an application which uses V4L2 but does not use Media
> > controller or the V4L2 subdev interfaces nor is aware of any particular
> > hardware device.
> 
> As a general rule, applications should not be aware of any particular hardware.
> That's why we provide standard ways of doing things. Experience shows that hardware
> aware applications become obsolete very fast. If you seek at the net, you'll see
> application-aware tools for bttv, zoran, etc. I doubt that they would still
> work today, as they were dependent on some particular special case driver
> behavior that has changed among the time. Also, if you look of the updates 
> timeline for those, you'll see that they were kept maintained for a short
> period of time.

I agree.

> So, I think that all hardware aware dependency should be at the driver and
> at the libv4l only. As the proper usage of the MC API requires a hardware
> aware knowledge, I don't think that a generic application should bother
> to implement the MC API at all.

At least for link configuration, no. But for device discovery, I'd say
"perhaps", as this was one of the MC API's original goals. But that's a
separate discussion from this one. I think the question is how the user
should discover devices, e.g. that which audio source is connected to a
video source.

> It should be noticed, however, that having a hardware/driver aware libv4l 
> also implies that libv4l should be dependent on an specific kernel version, 
> at the distributions.

I think a difference needs to be made between libv4l and libv4l plugins.

The plugin interface was added with plugins performing MC link setup etc. in
mind, but whether the libv4l proper should do something specific in embedded
system other than loading a plugin hasn't been discussed yet.

I could imagine this might be part of the libv4l core eventually.

> This already happens somehow there, but, currently, a new version of libv4l
> can work with an older kernel (as all we currently have there is support for
> new FOURCC formats and quirk lists of sensors mounted upside down).
> 
> So, a version made to work with kernel 3.0 will for sure support all webcams
> found at kernel 2.39.

As features are standardised this is easy. However, often standardising
something requires creating a few implementations privately. If one writes a
libv4l plugin using such private interfaces, it will break once the feature
is standardised.

A good, simple example of this could be the FRAME_SYNC event:

<URL:http://git.linuxtv.org/sailus/media_tree.git/shortlog/refs/heads/media-for-3.2-frame-sync-event-1>

I don't think this is an actual problem right now since there haven't been
many generic users of these interfaces but I think this is worth keeping in
mind.

> >>> Does it also account an application which is linked to libv4l2 and uses
> >>> calls specific to a particular hardware which are included there?
> >>
> >> That's a good question. We need to properly define what it means, to avoid
> >> having libv4l abuses.
> >>
> >> In other words, it seems ok to use libv4l to set pipelines via the MC API
> >> at open(), but it isn't ok to have an open() binary only libv4l plugin that
> >> will hook open and do the complete device initialization on userspace
> >> (I remember that one vendor once proposed a driver like that).
> >>
> >> Also, from my side, I'd like to see both libv4l and kernel drivers being
> >> submitted together, if the new driver depends on a special libv4l support
> >> for it to work.
> > 
> > I agree with the above.
> > 
> > I do favour using libv4l to do the pipeline setup using MC and V4L2 subdev
> > interfaces. This has the benefit that the driver provides just one interface
> > to access different aspects of it, be it pipeline setup (Media controller),
> > a control to change exposure time (V4L2 subdev) or queueing video buffer
> > (V4L2). This means more simple and more maintainable drivers and less bugs
> > in general.
> 
> I agree.
> 
> > Apart from what the drivers already provide on video nodea, to support a
> > general purpose V4L2 application, libv4l plugin can do is (not exhaustive
> > list):
> 
> IMO, we need to write a full list of what should be done at libv4l, as it seems
> that there are different opinions about what should be at the driver, and what
> should be outside it.

In general we can describe this related to the capabilities of the hardware
as the capabilities of the hardware varies. I think a general rule should be
that the drivers should provide access to the capabilities of the hardware,
no more.

For example, some sensors run their own software automatic white balance
algorithms. A Fujitsu image sensor (M5-MOLS, if I remember correctly) does
this. But on hardware doesn't do it, it often depends on the user space what
kind of white balance algorithm is wanted. One example of this which I often
mention is Fcam, which is also open source. It requires quite low level
access to hardware features such as those offered by the V4L2 subdevice
nodes.

> > - Perform pipeline setup using MC interface, possibly based on input
> >   selected using S_INPUT so that e.g. multiple sensors can be supported and
> > - implement {S,G,TRY}_EXT_CTRLS and QUERYCTRL using V4L2 subdev nodes as
> >   backend.
> > 
> > As the Media controller and V4L2 interfaces are standardised, I see no
> > reason why this plugin could not be fully generic: only the configuration is
> > device specific.
> 
> I don't think you can do everything that is needed on a fully generic plugin.
> 3A algorithm implementations, for example, seems to be device specific.

I hadn't gotten that far yet. :)

It depends how you want to do it. Libv4l contains algorithms which use image
data and not statistics. Using the image data is only dependent on the
format of the data, so it can be considered hardware independent. It's less
efficient than using the statistics: doing the same computations using the
CPU takes CPU time and requires extra memory accesses.

> Of course, the maximum we can do to have a generic implementation that fits
> on most cases, the better. 
> 
> > This configuration could be stored into a configuration file which is
> > selected based on the system type. On embedded systems (ARMs at least, but
> > anyway the vast majority is based on ARM) the board type is easily available
> > for the user space applications in /proc/cpuinfo --- this example is from
> > the Nokia N900:
> > 
> > ---
> > Processor       : ARMv7 Processor rev 3 (v7l)
> > BogoMIPS        : 249.96
> > Features        : swp half fastmult vfp edsp neon vfpv3 
> > CPU implementer : 0x41
> > CPU architecture: 7
> > CPU variant     : 0x1
> > CPU part        : 0xc08
> > CPU revision    : 3
> > 
> > Hardware        : Nokia RX-51 board
> > Revision        : 2101
> > Serial          : 0000000000000000
> > ---
> > 
> > I think this would be a first step to support general purpose application on
> > embedded systems.
> 
> Agreed.
> 
> > The question I still have on this is that how should the user know which
> > video node to access on an embedded system with a camera: the OMAP 3 ISP,
> > for example, contains some eight video nodes which have different ISP blocks
> > connected to them. Likely two of these nodes are useful for a general
> > purpose application based on which image format it requests. It would make
> > sense to provide generic applications information only on those devices they
> > may meaningfully use.
> 
> IMO, we should create a namespace device mapping for video devices. What I mean
> is that we should keep the "raw" V4L2 devices as:
> 	/dev/video??
> But also recommend the creation of a new userspace map, like:
> 	/dev/webcam??
> 	/dev/tv??
> 	...
> with is an alias for the actual device.
> 
> Something similar to dvd/cdrom aliases that already happen on most distros:
> 
> lrwxrwxrwx   1 root root           3 Ago 24 12:14 cdrom -> sr0
> lrwxrwxrwx   1 root root           3 Ago 24 12:14 cdrw -> sr0
> lrwxrwxrwx   1 root root           3 Ago 24 12:14 dvd -> sr0
> lrwxrwxrwx   1 root root           3 Ago 24 12:14 dvdrw -> sr0
>  
> > Later on, more functionality could be added to better support hardware which
> > supports e.g. different pixel formats, image sizes, scaling and crop. I'm
> > not entirely certain if all of this is fully generic --- but I think the
> > vast majority of it is --- at least converting from v4l2_mbus_framefmt
> > pixelcode to v4l2_format.fmt is often quite hardware specific which must be
> > taken into account by the generic plugin.
> > 
> > At that point many policy decisions must be made on how to use the hardware
> > the best way, and that must be also present in the configuration file.
> > 
> > But perhaps I'm going too far with this now; we don't yet have a generic
> > plugin providing basic functionality. We have the OMAP 3 ISP libv4l plugin
> > which might be a good staring point for this work.
> > 
> 
> We can start with that plugin making it more generic or forking it into two
> plugins: a generic one, and an OMAP3 specific implementation for the things
> that are hardware-specific.

I think at this point I would like to focus all the efforts towards a
generic plugin. We can later see what really cannot be done in that one at
all, and decide if we need that, wharever it turns out to be.

-- 
Sakari Ailus
sakari.ailus@iki.fi
