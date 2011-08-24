Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:39950 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1HXW3e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 18:29:34 -0400
Date: Thu, 25 Aug 2011 01:29:25 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: Embedded device and the  V4L2 API support - Was: [GIT PATCHES
 FOR 3.1] s5p-fimc and noon010pc30 driver updates
Message-ID: <20110824222925.GR8872@valkosipuli.localdomain>
References: <4E303E5B.9050701@samsung.com>
 <201108151430.42722.laurent.pinchart@ideasonboard.com>
 <4E49B60C.4060506@redhat.com>
 <201108161057.57875.laurent.pinchart@ideasonboard.com>
 <4E4A8D27.1040602@redhat.com>
 <4E4AE583.6050308@gmail.com>
 <4E4B5C27.3000008@redhat.com>
 <4E4F9A0B.4050302@gmail.com>
 <4E4FA4C8.4050703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4FA4C8.4050703@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Sat, Aug 20, 2011 at 05:12:56AM -0700, Mauro Carvalho Chehab wrote:
> Em 20-08-2011 04:27, Sylwester Nawrocki escreveu:
> > Hi Mauro,
> > 
> > On 08/17/2011 08:13 AM, Mauro Carvalho Chehab wrote:
> >> It seems that there are too many miss understandings or maybe we're just
> >> talking the same thing on different ways.
> >>
> >> So, instead of answering again, let's re-start this discussion on a
> >> different way.
> >>
> >> One of the requirements that it was discussed a lot on both mailing
> >> lists and on the Media Controllers meetings that we had (or, at least
> >> in the ones where I've participated) is that:
> >>
> >> 	"A pure V4L2 userspace application, knowing about video device
> >> 	 nodes only, can still use the driver. Not all advanced features
> >> 	 will be available."
> > 
> > What does a term "a pure V4L2 userspace application" mean here ?
> 
> The above quotation are exactly the Laurent's words that I took from one 
> of his replies.

I would define this as an application which uses V4L2 but does not use Media
controller or the V4L2 subdev interfaces nor is aware of any particular
hardware device.

> > Does it also account an application which is linked to libv4l2 and uses
> > calls specific to a particular hardware which are included there?
> 
> That's a good question. We need to properly define what it means, to avoid
> having libv4l abuses.
> 
> In other words, it seems ok to use libv4l to set pipelines via the MC API
> at open(), but it isn't ok to have an open() binary only libv4l plugin that
> will hook open and do the complete device initialization on userspace
> (I remember that one vendor once proposed a driver like that).
> 
> Also, from my side, I'd like to see both libv4l and kernel drivers being
> submitted together, if the new driver depends on a special libv4l support
> for it to work.

I agree with the above.

I do favour using libv4l to do the pipeline setup using MC and V4L2 subdev
interfaces. This has the benefit that the driver provides just one interface
to access different aspects of it, be it pipeline setup (Media controller),
a control to change exposure time (V4L2 subdev) or queueing video buffer
(V4L2). This means more simple and more maintainable drivers and less bugs
in general.

Apart from what the drivers already provide on video nodea, to support a
general purpose V4L2 application, libv4l plugin can do is (not exhaustive
list):

- Perform pipeline setup using MC interface, possibly based on input
  selected using S_INPUT so that e.g. multiple sensors can be supported and
- implement {S,G,TRY}_EXT_CTRLS and QUERYCTRL using V4L2 subdev nodes as
  backend.

As the Media controller and V4L2 interfaces are standardised, I see no
reason why this plugin could not be fully generic: only the configuration is
device specific.

This configuration could be stored into a configuration file which is
selected based on the system type. On embedded systems (ARMs at least, but
anyway the vast majority is based on ARM) the board type is easily available
for the user space applications in /proc/cpuinfo --- this example is from
the Nokia N900:

---
Processor       : ARMv7 Processor rev 3 (v7l)
BogoMIPS        : 249.96
Features        : swp half fastmult vfp edsp neon vfpv3 
CPU implementer : 0x41
CPU architecture: 7
CPU variant     : 0x1
CPU part        : 0xc08
CPU revision    : 3

Hardware        : Nokia RX-51 board
Revision        : 2101
Serial          : 0000000000000000
---

I think this would be a first step to support general purpose application on
embedded systems.

The question I still have on this is that how should the user know which
video node to access on an embedded system with a camera: the OMAP 3 ISP,
for example, contains some eight video nodes which have different ISP blocks
connected to them. Likely two of these nodes are useful for a general
purpose application based on which image format it requests. It would make
sense to provide generic applications information only on those devices they
may meaningfully use.

Later on, more functionality could be added to better support hardware which
supports e.g. different pixel formats, image sizes, scaling and crop. I'm
not entirely certain if all of this is fully generic --- but I think the
vast majority of it is --- at least converting from v4l2_mbus_framefmt
pixelcode to v4l2_format.fmt is often quite hardware specific which must be
taken into account by the generic plugin.

At that point many policy decisions must be made on how to use the hardware
the best way, and that must be also present in the configuration file.

But perhaps I'm going too far with this now; we don't yet have a generic
plugin providing basic functionality. We have the OMAP 3 ISP libv4l plugin
which might be a good staring point for this work.

-- 
Sakari Ailus
sakari.ailus@iki.fi
