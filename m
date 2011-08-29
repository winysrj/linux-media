Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54427 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab1H2JLe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 05:11:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Embedded device and the  V4L2 API support - Was: [GIT PATCHES FOR 3.1] s5p-fimc and noon010pc30 driver updates
Date: Mon, 29 Aug 2011 11:12:00 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
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
Message-Id: <201108291112.00665.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Friday 26 August 2011 17:09:02 Mauro Carvalho Chehab wrote:
> Em 26-08-2011 11:16, Hans Verkuil escreveu:
> > On Friday, August 26, 2011 15:45:30 Laurent Pinchart wrote:
> >> On Thursday 25 August 2011 14:43:56 Mauro Carvalho Chehab wrote:
> >>> Em 24-08-2011 19:29, Sakari Ailus escreveu:
> >> [snip]
> >> 
> >>>> The question I still have on this is that how should the user know
> >>>> which video node to access on an embedded system with a camera: the
> >>>> OMAP 3 ISP, for example, contains some eight video nodes which have
> >>>> different ISP blocks connected to them. Likely two of these nodes are
> >>>> useful for a general purpose application based on which image format
> >>>> it requests. It would make sense to provide generic applications
> >>>> information only on those devices they may meaningfully use.
> >>> 
> >>> IMO, we should create a namespace device mapping for video devices.
> >>> What I
> >>> 
> >>> mean is that we should keep the "raw" V4L2 devices as:
> >>> 	/dev/video??
> >>> 
> >>> But also recommend the creation of a new userspace map, like:
> >>> 	/dev/webcam??
> >>> 	/dev/tv??
> >>> 	...
> >>> 
> >>> with is an alias for the actual device.
> >>> 
> >>> Something similar to dvd/cdrom aliases that already happen on most
> >>> distros:
> >>> 
> >>> lrwxrwxrwx   1 root root           3 Ago 24 12:14 cdrom -> sr0
> >>> lrwxrwxrwx   1 root root           3 Ago 24 12:14 cdrw -> sr0
> >>> lrwxrwxrwx   1 root root           3 Ago 24 12:14 dvd -> sr0
> >>> lrwxrwxrwx   1 root root           3 Ago 24 12:14 dvdrw -> sr0
> >> 
> >> I've been toying with a similar idea. libv4l currently wraps /dev/video*
> >> device nodes and assumes a 1:1 relationship between a video device node
> >> and a video device. Should this assumption be somehow removed, replaced
> >> by a video device concept that wouldn't be tied to a single video
> >> device node ?
> > 
> > Just as background information: the original idea was always that all v4l
> > drivers would have a MC and that libv4l would use the information
> > contained there as a helper (such as deciding which nodes would be the
> > 'default' nodes for generic applications).
> 
> This is something that libv4l won't do: it is up to the userspace
> application to choose the device node to open.

I think this is one of our fundamental issues. Most applications are actually 
not interested in video nodes at all. What they want is a video device. 
Shouldn't libv4l should allow applications to enumerate video devices (as 
opposed to video nodes) and open them without caring about video nodes ?

> Ok, libv4l can have helper APIs for that, like the one I wrote, but even
> adding MC support on it may not solve the issues.
> 
> > Since there is only one MC device node for each piece of video hardware
> > that would make it much easier to discover what hardware there is and
> > what video nodes to use.
> > 
> > I always liked that idea, although I know Mauro is opposed to having a MC
> > for all v4l drivers.
> 
> It doesn't make sense to add MC for all V4L drivers. Not all devices are
> like ivtv with lots of device drivers. In a matter of fact, most supported
> devices create just one video node. Adding MC support for those devices
> will just increase the drivers complexity without _any_ reason, as those
> devices are fully configurable using the existing ioctl's.

Hans' proposal is to handle this in the V4L2 core for most drivers, so those 
drivers won't become more complex as they won't be modified at all. The MC API 
for those devices will only offer read-only enumeration, not link 
configuration.

> Also, as I said before, and implemented at xawtv and at a v4l-utils library,
> the code may use sysfs for simpler devices. It shouldn't be hard to
> implement a mc aware code there, although I don't think that MC API is
> useful to discover what nodes are meant to be used for TV, encoder, decoder,
> webcams, etc. The only type information it currently provides is:
> 
> #define MEDIA_ENT_T_DEVNODE_V4L		(MEDIA_ENT_T_DEVNODE + 1)
> #define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
> #define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENT_T_DEVNODE + 3)
> #define MEDIA_ENT_T_DEVNODE_DVB		(MEDIA_ENT_T_DEVNODE + 4)
> 
> So, a MC aware application also needs to be a hardware-dependent
> application, as it will need to use something else, like the media entity
> name, to discover for what purpose a media node is meant to be used.

As Hans pointed out, this is because we haven't implemented more detailed 
information *yet*. It has always been a goal to provide more details through 
the MC API.

> > While I am not opposed to creating such userspace maps I also think it is
> > a bit of a poor-man's solution.
> 
> The creation of per-type devices is part of the current API: radio
> and vbi nodes are examples of that (except that they aren't aliases, but
> real devices, but the idea is the same: different names for different
> types of usage).

This would only work in a black-and-white world. Devices are often not just 
webcams or tv tuners.

> > In particular I am worried that we get a lot of those mappings (just think
> > of ivtv with its 8 or 9 devices).
> > 
> > I can think of: webcam, tv, compressed (mpeg), tv-out, compressed-out,
> > mem2mem.
> > 
> > But a 'tv' node might also be able to handle compressed video (depending
> > on how the hardware is organized), so how do you handle that?
> 
> Well, What you've called as "compressed" is, in IMO, "encoder". It probably
> makes sense to have, also "decoder". I'm in doubt about "webcam", as there
> are some grabber devices with analog camera inputs for video surveillance.
> Maybe "camera" is a better name for it.
> 
> > It can all be solved, I'm sure, but I'm not sure if such userspace
> > mappings will scale that well with the increasing hardware complexity.
> 
> Not all video nodes would need an alias. Just the ones where it makes sense
> for an application to open it.

If it doesn't make sense for an application to open a video node, you can 
remove it completely :-)

-- 
Regards,

Laurent Pinchart
