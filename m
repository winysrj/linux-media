Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3985 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab1HZOQ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 10:16:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Embedded device and the  V4L2 API support - Was: [GIT PATCHES FOR 3.1] s5p-fimc and noon010pc30 driver updates
Date: Fri, 26 Aug 2011 16:16:02 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
References: <4E303E5B.9050701@samsung.com> <4E56438C.1070102@redhat.com> <201108261545.30817.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201108261545.30817.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108261616.02417.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, August 26, 2011 15:45:30 Laurent Pinchart wrote:
> Hi Mauro,
> 
> On Thursday 25 August 2011 14:43:56 Mauro Carvalho Chehab wrote:
> > Em 24-08-2011 19:29, Sakari Ailus escreveu:
> 
> [snip]
> 
> > > The question I still have on this is that how should the user know which
> > > video node to access on an embedded system with a camera: the OMAP 3 ISP,
> > > for example, contains some eight video nodes which have different ISP
> > > blocks connected to them. Likely two of these nodes are useful for a
> > > general purpose application based on which image format it requests. It
> > > would make sense to provide generic applications information only on
> > > those devices they may meaningfully use.
> > 
> > IMO, we should create a namespace device mapping for video devices. What I
> > mean is that we should keep the "raw" V4L2 devices as:
> > 	/dev/video??
> > But also recommend the creation of a new userspace map, like:
> > 	/dev/webcam??
> > 	/dev/tv??
> > 	...
> > with is an alias for the actual device.
> > 
> > Something similar to dvd/cdrom aliases that already happen on most distros:
> > 
> > lrwxrwxrwx   1 root root           3 Ago 24 12:14 cdrom -> sr0
> > lrwxrwxrwx   1 root root           3 Ago 24 12:14 cdrw -> sr0
> > lrwxrwxrwx   1 root root           3 Ago 24 12:14 dvd -> sr0
> > lrwxrwxrwx   1 root root           3 Ago 24 12:14 dvdrw -> sr0
> 
> I've been toying with a similar idea. libv4l currently wraps /dev/video* 
> device nodes and assumes a 1:1 relationship between a video device node and a 
> video device. Should this assumption be somehow removed, replaced by a video 
> device concept that wouldn't be tied to a single video device node ?

Just as background information: the original idea was always that all v4l
drivers would have a MC and that libv4l would use the information contained
there as a helper (such as deciding which nodes would be the 'default' nodes
for generic applications).

Since there is only one MC device node for each piece of video hardware that
would make it much easier to discover what hardware there is and what video
nodes to use.

I always liked that idea, although I know Mauro is opposed to having a MC
for all v4l drivers.

While I am not opposed to creating such userspace maps I also think it is
a bit of a poor-man's solution. In particular I am worried that we get a
lot of those mappings (just think of ivtv with its 8 or 9 devices).

I can think of: webcam, tv, compressed (mpeg), tv-out, compressed-out, mem2mem.

But a 'tv' node might also be able to handle compressed video (depending
on how the hardware is organized), so how do you handle that? It can all
be solved, I'm sure, but I'm not sure if such userspace mappings will scale
that well with the increasing hardware complexity.

Regards,

	Hans
