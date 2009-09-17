Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:4859 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbZIQVTY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2009 17:19:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC] Global video buffers pool
Date: Thu, 17 Sep 2009 23:19:24 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	=?iso-8859-1?q?Koskip=E4=E4_Antti_Jussi_Petteri?=
	<antti.koskipaa@nokia.com>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	stefan.kost@nokia.com
References: <200909161746.39754.laurent.pinchart@ideasonboard.com> <20090917154949.21b85c1b@pedra.chehab.org>
In-Reply-To: <20090917154949.21b85c1b@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909172319.24703.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 17 September 2009 20:49:49 Mauro Carvalho Chehab wrote:
> Em Wed, 16 Sep 2009 17:46:39 +0200
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> 
> > Hi everybody,
> > 
> > I didn't want to miss this year's pretty flourishing RFC season, so here's 
> > another one about a global video buffers pool.
> > 
> > All comments are welcome, but please don't trash this proposal too fast. It's 
> > a first shot at real problems encountered in real situations with real 
> > hardware (namely high resolution still image capture on OMAP3). It's far from 
> > perfect, and I'm open to completely different solutions if someone thinks of 
> > one.

First of all, thank you Laurent for working on this! Much appreciated.
 
> Some comments about your proposal:
> 
> 1) For embedded systems, probably the better is to create it at boot time, instead
> of controlling it via userspace, since as early it is done, the better.

I agree with Mauro here. The only way you can allocate the required memory is
in general to do it early in the boot sequence.

> 2) As I've posted at the media controller RFC, we should take care to not abuse
> about its usage. Media controller has two specific objetives: topology
> enumeration/change and subdev parameter send.

True, but perhaps it can also be used for other purposes. I'm not saying we
should, but neither should we stop thinking about it. Someone may come up with
a great idea for which a mc is ideally suited. We are still in the brainstorming
stage, so any idea is welcome.

> For the last, as I've explained 
> there, the proper solution is to create devices for each v4l subdev that requires
> control from userspace.

The proper solution *in your opinion*. I'm still on the fence on that one.

> In the case of a video buffers memory poll, it is none of the  
> usecases of media controller. So, it is needed to think better about where to
> implement it.

Why couldn't it be one of the use cases? Again, it is your opinion, not a fact.
Note that I share this opinion, but try to avoid presenting opinions as facts.
 
> 3) I don't think that having a buffer pool per media controller will be so useful.
> A media controller groups /dev/video with their audio, IR, I2C... resources. On
> systems with more than one different board (for example a cellular phone with a
> camera and an DVB-H receiver), you'll likely have more than one media controller.
> So, controlling video buffer pools at /dev/video or at media controller will give
> the same results on several environments;

I don't follow the logic here, sorry.

> 4) As you've mentioned, a global set of buffers seem to be the better alternative. This
> means that V4L2 core will take care of controlling the pool, instead of leaving
> this task to the drivers. This makes easier to have a boot-time parameter specifying
> the size of the memory pool and will optimize memory usage. We may even have a
> Kconfig var specifying the default size of the memory pool (although this is
> not really needed, since new kernels allow specifying default line command parameters).

Different devices may have quite different buffer requirements (size, number
of buffers). Would it be safe to have them all allocated from a global pool?
I do not feel confident myself that I understand all the implications of a
global pool or whether you actually always want that.
 
> 5) The step to have a a global-wide video buffers pool allocation, as you
> mentioned at the RFC, is to make sure that all drivers will use v4l2 framework
> to allocate memory. So, this means porting a few drivers (ivtv, uvcvideo, cx18
> and gspca) to use videobuf. As videobuf already supports all sorts of different
> memory types and configs (contig and Scatter/Gather DMA, vmalloced buffers,
> mmap, userptr, read, overlay modes), it should fits well on the needs.

Why would I want to change ivtv for this? In fact, I see no reason to modify
any of the existing drivers. A mc-wide or global memory pool is only of
interest for very complex devices where you want to pass buffers around
between various sub-devices (and possibly to other media devices or DSPs).
And yes, they probably will have to use the framework in order to be able to
coordinate these pools properly.
 
> 6) As videobuf uses a common method of allocating memory, and all memory
> requests passes via videobuf-core (videobuf_alloc function), the implementation of a
> global-wide set of videobuffer means to touch on just one function there, at the abstraction
> layer, and to double check at the videobuf-dma-sg/videobuf-vmalloc/videobuf-contig if they
> don't call directly their own allocation methods. If they do, a simple change
> would be needed.
> 
> 7) IMO, the better interface for it is to add some sysfs attributes to media
> class, providing there the means to control the video buffer pools. If the size
> of a video buffer pool is set to zero, it will use normal memory allocation.
> Otherwise, it will work at the "pool mode". 

Or you use the existing API to request either MEMORY_MMAP or MEMORY_POOL_MMAP.
So much cleaner than creating some random sysfs attribute.

> 8) By using videobuf, we can also export usage statistics via debugfs, providing
> runtime statistics about how many memory is being used by what drivers and /dev devices.

Wouldn't procfs be more appropriate? I don't think debugfs is very common.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
