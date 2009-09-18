Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42042 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbZIRMr5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 08:47:57 -0400
Date: Fri, 18 Sep 2009 09:47:18 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	=?ISO-8859-1?B?S29za2lw5OQ=?= Antti Jussi Petteri
	<antti.koskipaa@nokia.com>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	stefan.kost@nokia.com
Subject: Re: [RFC] Global video buffers pool
Message-ID: <20090918094718.3d25ff20@pedra.chehab.org>
In-Reply-To: <200909181039.18012.laurent.pinchart@ideasonboard.com>
References: <200909161746.39754.laurent.pinchart@ideasonboard.com>
	<200909172319.24703.hverkuil@xs4all.nl>
	<20090917194542.5df9c65b@pedra.chehab.org>
	<200909181039.18012.laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm joining your comments to Vaibhav with your comments to me, in order to
avoid duplicating comments.

Em Fri, 18 Sep 2009 10:39:17 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> > > Different devices may have quite different buffer requirements (size,
> > > number of buffers). Would it be safe to have them all allocated from a
> > > global pool? I do not feel confident myself that I understand all the
> > > implications of a global pool or whether you actually always want that.
> > 
> > This is a problem with the pool concept. Even having the same driver,
> >  you'll still be needing different resolutions, frame rates, formats and
> >  bits per pixel on each /dev/video interface.
> 
> That's right (the frame rate doesn't matter though), but not different memory 
> type (low-mem, non-cacheable, contiguous, ...) requirements. The only thing 
> that matters in the end is the number of buffers and their size. The pool 
> doesn't care about the formats and resolutions separately.

For raw formats, that's right. However, with some compressed formats, there are
other parameters that affect the size of a framebuffer. For example, just
knowing the resolution is not enough for h.264/mpeg/jpeg formats. Even frame
rate can affect some of them, since they'll affect the temporal estimations. For
compressed formats, maybe the right approach would be to allocate buffers based
on the maximum allowed bandwidth.

> 
> >  I'm not sure how to deal.
> 
> My idea was to have several groups of video buffers. You could allocate on 
> "large" group of low-resolution buffers for video preview, and a "small" group 
> of high-resolution buffers for still image capture. Video devices could then 
> pick buffers from one of those groups depending on their needs.
> 
> >  Maybe we'll need to allocate the buffers considering the worse case that
> >  can be passed to the driver. For example, in the case of a kernel
> >  parameter, it could be something like:
> > 	videobuf=buffers=32,size=256K
> > To allocate 32 buffers with 256K each. This way, even if application asks
> >  for a smaller buffer, it will keep reserving 256K for each buffer. If bad
> >  specified, memory will be wasted, but the memory will be there.
> > Eventually, after allocating that memory, some API could be provided for
> > example to rearrange the allocated space into 64 x 128K.
> 
> We still need separate groups, otherwise we will waste too much memory. 5MP 
> sensors are common today, and the size will probably grow in the years to 
> come. We can't allocate 32 5MP buffers on an embedded system.

> > I agree with Mauro here. The only way you can allocate the required memory
> > is in general to do it early in the boot sequence.  
> 
> I agree with you there as well, but there's one obvious problem with that 
> approach: the Linux kernel doesn't know how much memory you will need.
> Let me take the OMAP3 camera as an example. The sensor has a native 5MP 
> resolution (2548x1938). When taking a still picture, we want to display live 
> video on the device's screen in a lower resolution (840x400) and, when the 
> user presses the camera button, switch to the 5MP resolution and capture 3 
> images.
>
> For this we need a few (let's say 5) 840x400 buffers (672000 bytes each in 
> YUV) and 3 2548x1938 buffers (9876048 bytes each). Those requirements come 
> from the product specifications, and the device driver has no way to know 
> about them. Allocating several huge buffers at boot time big enough for all 
> use cases will here use 75MB of memory instead of 31.5MB.
> 
> That's why I was thinking about allowing a userspace application to allocate 
> those buffers very early after boot. One other possible solution would be to 
> use a kernel command line parameter set to something like 
> "5x672000,3x9876048".

Interesting approach. Another alternative would be to allocate a flat memory
block
during boot time, and provide a set of controls to control how the memory will
be divided.

> > So, while I agree that it is not a mandatory requirement to port the
> >  existing drivers to benefit with the memory pool, by not doing it, those
> >  drivers will be less reliable than the other drivers on professional
> >  usage.
> 
> Good point. No need to be too clever though. I think that the memory pool 
> concept can be restricted to use cases where the user knows in advance what's 
> going to happen with the hardware. A video monitoring system is one of them, a 
> digital camera is another one.

Agreed.

> In those cases the system designer knows what 
> resolutions will be streamed at, and how many buffers will be needed. This 
> information can come from userspace or the kernel command line, and the memory 
> pool won't need to become a complete memory management system. An application 
> that wants to use buffers from the pool will the explicitly which set of 
> buffers it wants to use.

I'm not sure that reserving memory size on userspace would be good enough, even
if done too early. On the other hand, a complex command line won't be good
enough.

Maybe the solution could be something like:
	- command line: just the total size, like: videobuf.maxsize=16M

	- sysfs: call some application when the first video device is created.
or, alternatively, during rc scripts, before starting the first video
application.

> > > > 6) As videobuf uses a common method of allocating memory, and all
> > > > memory requests passes via videobuf-core (videobuf_alloc function), the
> > > > implementation of a global-wide set of videobuffer means to touch on
> > > > just one function there, at the abstraction layer, and to double check
> > > > at the videobuf-dma-sg/videobuf-vmalloc/videobuf-contig if they don't
> > > > call directly their own allocation methods. If they do, a simple change
> > > > would be needed.
> > > >
> > > > 7) IMO, the better interface for it is to add some sysfs attributes to
> > > > media class, providing there the means to control the video buffer
> > > > pools. If the size of a video buffer pool is set to zero, it will use
> > > > normal memory allocation. Otherwise, it will work at the "pool mode".
> > >
> > > Or you use the existing API to request either MEMORY_MMAP or
> > > MEMORY_POOL_MMAP. So much cleaner than creating some random sysfs
> > > attribute.
> > 
> > The existing V4L2 API applies over a /dev/video device, not at videobuf or
> >  V4L2 core level. As we want this at a core level, we need to apply it on a
> >  different place.
> 
> VIDIOC_REQBUFS/VIDIOC_QBUF/VIDIOC_DQBUF on the /dev/video device will need to 
> tell the driver to use buffers from the pool, so a new memory type is needed.

Why they need to tell? We don't need this even for read() method. If you look at
videobuf methods, no matter what kind of memory mode were selected (overlay,
mmap, userptr, read), it will be converted into 4 callbacks:
	buffer_setup, buffer_prepare, buffer_queue, buffer_release.

The first callback (buffer_setup) will return to videobuf the size of each
buffer.

So, videobuf just needs to check if there are memory pools allocated. If yes,
it will
use the closest buffers that are enough to satisfy the maximum size specified.
It can
even decide to reduce the number of buffers requested by the userspace
application.

For example, let's say that the pool has 5 x 672000 and 3 x  9876048 buffers,
all free, from your example above.

Userspace app may request 5 buffers for 840x400 res. Videobuf will call
buffer_setup, that will return a size of 672000 for each buffer.

Videobuf will check that it has 5 of such buffers, and will allocate his first
block to this application. Later, the snapshot button got pressed, and some
application got called, requesting 16 buffers (due to some bug there?) of
9876048. Videobuf will call buffer_setup, and check that there are only 3 buffers with
enough size. It will automatically reduce the number of buffers to 3, and this
information will be returned back to userspace.

So, there's no need to touch at the existing ioctls for it.

The only remaining question is what to do if all buffers were already spent,
but userspace is requesting more buffers. We may eventually have two modes of
operation: an "strict" mode, where trying to allocate more memory will result
in an error, and a "relaxed" mode, where it will fall back to the old behavior.
I would opt for using the "relaxed" mode, and to print some warning at dmesg
that the pool is not big enough. We may also have some API to allow userspace
to select between the two modes of operation.

> > Different devices may have quite different buffer requirements (size,
> >  number of buffers). Would it be safe to have them all allocated from a
> >  global pool? I do not feel confident myself that I understand all the
> >  implications of a global pool or whether you actually always want that.  
> 
> This is why my proposal was restricted to one pool per media controller. 
> Careful thought is required to extend that to a global pool. We would 
> definitely need a way to allocate several groups of buffers with different 
> resolutions and different "properties" (alignment, cacheable/non-cacheable, 
> physically contiguous, ...). On some platforms the hardware can't DMA to all 
> physical memory, so we need to be able to specify ranges of physical memory as 
> well (it's a bad example as we probably don't really care about that kind of 
> hardware, but ISA can only DMA to the first 16MB, and other PCI hardware or 
> embedded hardware might have similar restrictions).

Doing it per media controller could only make sense if the DMA restrictions
are different for the several boards at the same system. While this is
possible (so, this need to be addressed), I doubt that this will happen in
practice. The videobuf pools are for systems dedicated to an specific usage,
where memory restrictions deserve a serious analysis. If we have buffers per
memory controllers, on systems with several memory controllers, it is likely
that we'll waste memory.



Cheers,
Mauro
