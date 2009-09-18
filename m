Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:38977 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbZIRI2h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 04:28:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC] Global video buffers pool
Date: Fri, 18 Sep 2009 10:29:42 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	=?iso-8859-1?q?Koskip=E4=E4_Antti_Jussi_Petteri?=
	<antti.koskipaa@nokia.com>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	stefan.kost@nokia.com
References: <200909161746.39754.laurent.pinchart@ideasonboard.com> <20090917154949.21b85c1b@pedra.chehab.org> <200909172319.24703.hverkuil@xs4all.nl>
In-Reply-To: <200909172319.24703.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909181029.42559.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 17 September 2009 23:19:24 Hans Verkuil wrote:
> On Thursday 17 September 2009 20:49:49 Mauro Carvalho Chehab wrote:
> > Em Wed, 16 Sep 2009 17:46:39 +0200
> > Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> > > Hi everybody,
> > >
> > > I didn't want to miss this year's pretty flourishing RFC season, so
> > > here's another one about a global video buffers pool.
> > >
> > > All comments are welcome, but please don't trash this proposal too
> > > fast. It's a first shot at real problems encountered in real situations
> > > with real hardware (namely high resolution still image capture on
> > > OMAP3). It's far from perfect, and I'm open to completely different
> > > solutions if someone thinks of one.
> 
> First of all, thank you Laurent for working on this! Much appreciated.
> 
> > Some comments about your proposal:
> >
> > 1) For embedded systems, probably the better is to create it at boot
> > time, instead of controlling it via userspace, since as early it is done,
> > the better.
> 
> I agree with Mauro here. The only way you can allocate the required memory
> is in general to do it early in the boot sequence.

I agree with you there as well, but there's one obvious problem with that 
approach: the Linux kernel doesn't know how much memory you will need.
Let me take the OMAP3 camera as an example. The sensor has a native 5MP 
resolution (2548x1938). When taking a still picture, we want to display live 
video on the device's screen in a lower resolution (840x400) and, when the 
user presses the camera button, switch to the 5MP resolution and capture 3 
images.

For this we need a few (let's say 5) 840x400 buffers (672000 bytes each in 
YUV) and 3 2548x1938 buffers (9876048 bytes each). Those requirements come 
from the product specifications, and the device driver has no way to know 
about them. Allocating several huge buffers at boot time big enough for all 
use cases will here use 75MB of memory instead of 31.5MB.

That's why I was thinking about allowing a userspace application to allocate 
those buffers very early after boot. One other possible solution would be to 
use a kernel command line parameter set to something like 
"5x672000,3x9876048".

Another reason to allow applications to allocate buffers in the pool was to be 
able to "pre-queue" buffers to avoid cache invalidation and memory pinning 
delays at VIDIOC_QBUF. This is a very important topic that I might not have 
stressed enough in the RFC. VIDIOC_QBUF currently hurts performances. For the 
camera use case I've explained above, we need a way to pre-queue the 3 5MP 
buffers while still streaming video in 840x400.

> > 2) As I've posted at the media controller RFC, we should take care to not
> > abuse about its usage. Media controller has two specific objetives:
> > topology enumeration/change and subdev parameter send.
> 
> True, but perhaps it can also be used for other purposes. I'm not saying we
> should, but neither should we stop thinking about it. Someone may come up
>  with a great idea for which a mc is ideally suited. We are still in the
>  brainstorming stage, so any idea is welcome.

Agreed. The media controller RFC described its intended purpose, but I don't 
see why it couldn't be extended if we find a use case for which the media 
controller is ideally suited.

> > For the last, as I've explained there, the proper solution is to create
> > devices for each v4l subdev that requires control from userspace.
> 
> The proper solution *in your opinion*. I'm still on the fence on that one.
> 
> > In the case of a video buffers memory poll, it is none of the usecases of
> > media controller. So, it is needed to think better about where to
> > implement it.
> 
> Why couldn't it be one of the use cases? Again, it is your opinion, not a
>  fact. Note that I share this opinion, but try to avoid presenting opinions
>  as facts.
> 
> > 3) I don't think that having a buffer pool per media controller will be
> > so useful. A media controller groups /dev/video with their audio, IR,
> > I2C... resources. On systems with more than one different board (for
> > example a cellular phone with a camera and an DVB-H receiver), you'll
> > likely have more than one media controller. So, controlling video buffer
> > pools at /dev/video or at media controller will give the same results on
> > several environments;
> 
> I don't follow the logic here, sorry.
> 
> > 4) As you've mentioned, a global set of buffers seem to be the better
> > alternative. This means that V4L2 core will take care of controlling the
> > pool, instead of leaving this task to the drivers. This makes easier to
> > have a boot-time parameter specifying the size of the memory pool and
> > will optimize memory usage. We may even have a Kconfig var specifying the
> > default size of the memory pool (although this is not really needed,
> > since new kernels allow specifying default line command parameters).
> 
> Different devices may have quite different buffer requirements (size,
>  number of buffers). Would it be safe to have them all allocated from a
>  global pool? I do not feel confident myself that I understand all the
>  implications of a global pool or whether you actually always want that.

This is why my proposal was restricted to one pool per media controller. 
Careful thought is required to extend that to a global pool. We would 
definitely need a way to allocate several groups of buffers with different 
resolutions and different "properties" (alignment, cacheable/non-cacheable, 
physically contiguous, ...). On some platforms the hardware can't DMA to all 
physical memory, so we need to be able to specify ranges of physical memory as 
well (it's a bad example as we probably don't really care about that kind of 
hardware, but ISA can only DMA to the first 16MB, and other PCI hardware or 
embedded hardware might have similar restrictions).

> > 5) The step to have a a global-wide video buffers pool allocation, as you
> > mentioned at the RFC, is to make sure that all drivers will use v4l2
> > framework to allocate memory. So, this means porting a few drivers (ivtv,
> > uvcvideo, cx18 and gspca) to use videobuf. As videobuf already supports
> > all sorts of different memory types and configs (contig and
> > Scatter/Gather DMA, vmalloced buffers, mmap, userptr, read, overlay
> > modes), it should fits well on the needs.
> 
> Why would I want to change ivtv for this? In fact, I see no reason to
>  modify any of the existing drivers. A mc-wide or global memory pool is
>  only of interest for very complex devices where you want to pass buffers
>  around between various sub-devices (and possibly to other media devices or
>  DSPs). And yes, they probably will have to use the framework in order to
>  be able to coordinate these pools properly.
> 
> > 6) As videobuf uses a common method of allocating memory, and all memory
> > requests passes via videobuf-core (videobuf_alloc function), the
> > implementation of a global-wide set of videobuffer means to touch on just
> > one function there, at the abstraction layer, and to double check at the
> > videobuf-dma-sg/videobuf-vmalloc/videobuf-contig if they don't call
> > directly their own allocation methods. If they do, a simple change would
> > be needed.
> >
> > 7) IMO, the better interface for it is to add some sysfs attributes to
> > media class, providing there the means to control the video buffer pools.
> > If the size of a video buffer pool is set to zero, it will use normal
> > memory allocation. Otherwise, it will work at the "pool mode".
> 
> Or you use the existing API to request either MEMORY_MMAP or
>  MEMORY_POOL_MMAP. So much cleaner than creating some random sysfs
>  attribute.

Agreed. Even if the pool was controlled through sysfs, we would still need a 
new memory type in the V4L2 API to tell drivers to request memory from the 
pool.
 
> > 8) By using videobuf, we can also export usage statistics via debugfs,
> > providing runtime statistics about how many memory is being used by what
> > drivers and /dev devices.
> 
> Wouldn't procfs be more appropriate? I don't think debugfs is very common.

-- 
Laurent Pinchart
