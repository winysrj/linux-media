Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4184 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab1HZPaN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 11:30:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Embedded device and the  V4L2 API support - Was: [GIT PATCHES FOR 3.1] s5p-fimc and noon010pc30 driver updates
Date: Fri, 26 Aug 2011 17:29:50 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
References: <4E303E5B.9050701@samsung.com> <201108261616.02417.hverkuil@xs4all.nl> <4E57B70E.9010103@redhat.com>
In-Reply-To: <4E57B70E.9010103@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108261729.50483.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, August 26, 2011 17:09:02 Mauro Carvalho Chehab wrote:
> Em 26-08-2011 11:16, Hans Verkuil escreveu:
> > On Friday, August 26, 2011 15:45:30 Laurent Pinchart wrote:
> >> Hi Mauro,
> >>
> >> On Thursday 25 August 2011 14:43:56 Mauro Carvalho Chehab wrote:
> >>> Em 24-08-2011 19:29, Sakari Ailus escreveu:
> >>
> >> [snip]
> >>
> >>>> The question I still have on this is that how should the user know which
> >>>> video node to access on an embedded system with a camera: the OMAP 3 ISP,
> >>>> for example, contains some eight video nodes which have different ISP
> >>>> blocks connected to them. Likely two of these nodes are useful for a
> >>>> general purpose application based on which image format it requests. It
> >>>> would make sense to provide generic applications information only on
> >>>> those devices they may meaningfully use.
> >>>
> >>> IMO, we should create a namespace device mapping for video devices. What I
> >>> mean is that we should keep the "raw" V4L2 devices as:
> >>> 	/dev/video??
> >>> But also recommend the creation of a new userspace map, like:
> >>> 	/dev/webcam??
> >>> 	/dev/tv??
> >>> 	...
> >>> with is an alias for the actual device.
> >>>
> >>> Something similar to dvd/cdrom aliases that already happen on most distros:
> >>>
> >>> lrwxrwxrwx   1 root root           3 Ago 24 12:14 cdrom -> sr0
> >>> lrwxrwxrwx   1 root root           3 Ago 24 12:14 cdrw -> sr0
> >>> lrwxrwxrwx   1 root root           3 Ago 24 12:14 dvd -> sr0
> >>> lrwxrwxrwx   1 root root           3 Ago 24 12:14 dvdrw -> sr0
> >>
> >> I've been toying with a similar idea. libv4l currently wraps /dev/video* 
> >> device nodes and assumes a 1:1 relationship between a video device node and a 
> >> video device. Should this assumption be somehow removed, replaced by a video 
> >> device concept that wouldn't be tied to a single video device node ?
> > 
> > Just as background information: the original idea was always that all v4l
> > drivers would have a MC and that libv4l would use the information contained
> > there as a helper (such as deciding which nodes would be the 'default' nodes
> > for generic applications).
> 
> This is something that libv4l won't do: it is up to the userspace application
> to choose the device node to open. Ok, libv4l can have helper APIs for
> that, like the one I wrote, but even adding MC support on it may not solve
> the issues.
> 
> > Since there is only one MC device node for each piece of video hardware that
> > would make it much easier to discover what hardware there is and what video
> > nodes to use.
> > 
> > I always liked that idea, although I know Mauro is opposed to having a MC
> > for all v4l drivers.
> 
> It doesn't make sense to add MC for all V4L drivers. Not all devices are like
> ivtv with lots of device drivers. In a matter of fact, most supported devices
> create just one video node. Adding MC support for those devices will just 
> increase the drivers complexity without _any_ reason, as those devices are
> fully configurable using the existing ioctl's.

It's for consistency so applications know what to expect. For all the simple
drivers you'd just need some simple core support to add a MC. What I always
thought would be handy is for applications to just iterate over all MCs and
show which video/dvb/audio hardware the user has in its system.

> Also, as I said before, and implemented at xawtv and at a v4l-utils library, 
> the code may use sysfs for simpler devices. It shouldn't be hard to implement
> a mc aware code there, although I don't think that MC API is useful to discover
> what nodes are meant to be used for TV, encoder, decoder, webcams, etc.
> The only type information it currently provides is:
> 
> #define MEDIA_ENT_T_DEVNODE_V4L		(MEDIA_ENT_T_DEVNODE + 1)
> #define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
> #define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENT_T_DEVNODE + 3)
> #define MEDIA_ENT_T_DEVNODE_DVB		(MEDIA_ENT_T_DEVNODE + 4)

That's because we never added meta information like that. As long as the MC
is only used for SoC/complex drivers there is no point in adding such info.

It would be trivial to add precisely this type of information, though.

> So, a MC aware application also needs to be a hardware-dependent application,
> as it will need to use something else, like the media entity name, to discover
> for what purpose a media node is meant to be used.
> 
> > While I am not opposed to creating such userspace maps I also think it is
> > a bit of a poor-man's solution.
> 
> The creation of per-type devices is part of the current API: radio
> and vbi nodes are examples of that (except that they aren't aliases, but
> real devices, but the idea is the same: different names for different
> types of usage).

That's why I'm not opposed to it. I'm just not sure how detailed/extensive
that mapping should be.

> > In particular I am worried that we get a
> > lot of those mappings (just think of ivtv with its 8 or 9 devices).
> > 
> > I can think of: webcam, tv, compressed (mpeg), tv-out, compressed-out, mem2mem.
> > 
> > But a 'tv' node might also be able to handle compressed video (depending
> > on how the hardware is organized), so how do you handle that? 
> 
> Well, What you've called as "compressed" is, in IMO, "encoder". It probably makes
> sense to have, also "decoder".

I couldn't remember the name :-)

> I'm in doubt about "webcam", as there are some
> grabber devices with analog camera inputs for video surveillance. Maybe "camera"
> is a better name for it.

Hmm. 'webcam' or 'camera' implies settings like exposure, etc. Many video
surveillance devices are just frame grabbers to which you can attach a camera,
but you can just as easily attach any composite/S-video input.

> 
> > It can all
> > be solved, I'm sure, but I'm not sure if such userspace mappings will scale
> > that well with the increasing hardware complexity.
> 
> Not all video nodes would need an alias. Just the ones where it makes sense for
> an application to open it.

I'm not certain you will solve that much with this. Most people (i.e. the average
linux users) have only one or two video devices, most likely a webcam and perhaps
some DVB/V4L USB stick. Generic apps that needs to enumerate all devices will still
need to use sysfs or go through all video nodes.

It's why I like the MC: just one device node per hardware unit. Easy to enumerate,
easy to present to the user.

I'm tempted to see if I can make a proof-of-concept... Time is a problem for me,
though.

Regards,

	Hans
