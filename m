Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:43324 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZIRIiL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 04:38:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC] Global video buffers pool
Date: Fri, 18 Sep 2009 10:39:17 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	=?iso-8859-1?q?Koskip=E4=E4_Antti_Jussi_Petteri?=
	<antti.koskipaa@nokia.com>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	stefan.kost@nokia.com
References: <200909161746.39754.laurent.pinchart@ideasonboard.com> <200909172319.24703.hverkuil@xs4all.nl> <20090917194542.5df9c65b@pedra.chehab.org>
In-Reply-To: <20090917194542.5df9c65b@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909181039.18012.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

thanks for the review. A few comments.

On Friday 18 September 2009 00:45:42 Mauro Carvalho Chehab wrote:
> Em Thu, 17 Sep 2009 23:19:24 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:

[snip]

> > > 4) As you've mentioned, a global set of buffers seem to be the better
> > > alternative. This means that V4L2 core will take care of controlling
> > > the pool, instead of leaving this task to the drivers. This makes
> > > easier to have a boot-time parameter specifying the size of the memory
> > > pool and will optimize memory usage. We may even have a Kconfig var
> > > specifying the default size of the memory pool (although this is not
> > > really needed, since new kernels allow specifying default line command
> > > parameters).
> >
> > Different devices may have quite different buffer requirements (size,
> > number of buffers). Would it be safe to have them all allocated from a
> > global pool? I do not feel confident myself that I understand all the
> > implications of a global pool or whether you actually always want that.
> 
> This is a problem with the pool concept. Even having the same driver,
>  you'll still be needing different resolutions, frame rates, formats and
>  bits per pixel on each /dev/video interface.

That's right (the frame rate doesn't matter though), but not different memory 
type (low-mem, non-cacheable, contiguous, ...) requirements. The only thing 
that matters in the end is the number of buffers and their size. The pool 
doesn't care about the formats and resolutions separately.

>  I'm not sure how to deal.

My idea was to have several groups of video buffers. You could allocate on 
"large" group of low-resolution buffers for video preview, and a "small" group 
of high-resolution buffers for still image capture. Video devices could then 
pick buffers from one of those groups depending on their needs.

>  Maybe we'll need to allocate the buffers considering the worse case that
>  can be passed to the driver. For example, in the case of a kernel
>  parameter, it could be something like:
> 	videobuf=buffers=32,size=256K
> To allocate 32 buffers with 256K each. This way, even if application asks
>  for a smaller buffer, it will keep reserving 256K for each buffer. If bad
>  specified, memory will be wasted, but the memory will be there.
> Eventually, after allocating that memory, some API could be provided for
> example to rearrange the allocated space into 64 x 128K.

We still need separate groups, otherwise we will waste too much memory. 5MP 
sensors are common today, and the size will probably grow in the years to 
come. We can't allocate 32 5MP buffers on an embedded system.

> > > 5) The step to have a a global-wide video buffers pool allocation, as
> > > you mentioned at the RFC, is to make sure that all drivers will use
> > > v4l2 framework to allocate memory. So, this means porting a few drivers
> > > (ivtv, uvcvideo, cx18 and gspca) to use videobuf. As videobuf already
> > > supports all sorts of different memory types and configs (contig and
> > > Scatter/Gather DMA, vmalloced buffers, mmap, userptr, read, overlay
> > > modes), it should fits well on the needs.
> >
> > Why would I want to change ivtv for this? In fact, I see no reason to
> > modify any of the existing drivers. A mc-wide or global memory pool is
> > only of interest for very complex devices where you want to pass buffers
> > around between various sub-devices (and possibly to other media devices
> > or DSPs). And yes, they probably will have to use the framework in order
> > to be able to coordinate these pools properly.
> 
> The issue here is not necessarely related to device complexity. It can be
> motivated by other factors, for example:
> 
> 	- arch's with non-coherent cache;
> 	- devices that aren't capable of doing DMA scatter/gather;
> 	- high memory fragmentation.
> 
> Just as an example, I used an old laptop with "only" 256 Mb of ram, running
>  a new distro, when I started developing the tm6000 drivers. On that
>  hardware, I was needing buffers of about 600 KB each. It were very common
>  to not be able to allocate such buffers there, due to high memory
>  fragmentation, since the USB driver were trying to allocate a continuous
>  buffer on that hardware.
> 
> So, the same argument we used with the EMBEEDED Kconfig option also applies
>  here: it is not everything black or white. For example, surveillance
>  systems need to be very reliable. So, the possibility of allocating memory
>  during boot will help them.
> 
> Just to take a random real usecase, David Liontooth mentioned recently at
>  the ML his intention of maybe using ivtv hardware to capture TV signals at
>  remote locations, having the hardware minimally assisted. He mention the
>  needs of capturing data continuously for 15 hours. That means that the
>  machine will likely close devices and reopen once a day, during years. In
>  such application, a video buffer pool will for sure reduce the risk of
>  memory fragmentation on such systems, giving more reliability to the
>  system, especially if the hardware it will use requires continuous
>  buffers.
> 
> So, while I agree that it is not a mandatory requirement to port the
>  existing drivers to benefit with the memory pool, by not doing it, those
>  drivers will be less reliable than the other drivers on professional
>  usage.

Good point. No need to be too clever though. I think that the memory pool 
concept can be restricted to use cases where the user knows in advance what's 
going to happen with the hardware. A video monitoring system is one of them, a 
digital camera is another one. In those cases the system designer knows what 
resolutions will be streamed at, and how many buffers will be needed. This 
information can come from userspace or the kernel command line, and the memory 
pool won't need to become a complete memory management system. An application 
that wants to use buffers from the pool will the explicitly which set of 
buffers it wants to use.

> > > 6) As videobuf uses a common method of allocating memory, and all
> > > memory requests passes via videobuf-core (videobuf_alloc function), the
> > > implementation of a global-wide set of videobuffer means to touch on
> > > just one function there, at the abstraction layer, and to double check
> > > at the videobuf-dma-sg/videobuf-vmalloc/videobuf-contig if they don't
> > > call directly their own allocation methods. If they do, a simple change
> > > would be needed.
> > >
> > > 7) IMO, the better interface for it is to add some sysfs attributes to
> > > media class, providing there the means to control the video buffer
> > > pools. If the size of a video buffer pool is set to zero, it will use
> > > normal memory allocation. Otherwise, it will work at the "pool mode".
> >
> > Or you use the existing API to request either MEMORY_MMAP or
> > MEMORY_POOL_MMAP. So much cleaner than creating some random sysfs
> > attribute.
> 
> The existing V4L2 API applies over a /dev/video device, not at videobuf or
>  V4L2 core level. As we want this at a core level, we need to apply it on a
>  different place.

VIDIOC_REQBUFS/VIDIOC_QBUF/VIDIOC_DQBUF on the /dev/video device will need to 
tell the driver to use buffers from the pool, so a new memory type is needed.

> > > 8) By using videobuf, we can also export usage statistics via debugfs,
> > > providing runtime statistics about how many memory is being used by
> > > what drivers and /dev devices.
> >
> > Wouldn't procfs be more appropriate? I don't think debugfs is very
> > common.
> 
> perf counters, strace, and other advanced monitoring tools use debugfs.

-- 
Laurent Pinchart
