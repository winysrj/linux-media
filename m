Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38573 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbZIQWqU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2009 18:46:20 -0400
Date: Thu, 17 Sep 2009 19:45:42 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	=?ISO-8859-1?B?S29za2lw5OQ=?= Antti Jussi Petteri
	<antti.koskipaa@nokia.com>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	stefan.kost@nokia.com
Subject: Re: [RFC] Global video buffers pool
Message-ID: <20090917194542.5df9c65b@pedra.chehab.org>
In-Reply-To: <200909172319.24703.hverkuil@xs4all.nl>
References: <200909161746.39754.laurent.pinchart@ideasonboard.com>
	<20090917154949.21b85c1b@pedra.chehab.org>
	<200909172319.24703.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 Sep 2009 23:19:24 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> > 3) I don't think that having a buffer pool per media controller will be so useful.
> > A media controller groups /dev/video with their audio, IR, I2C... resources. On
> > systems with more than one different board (for example a cellular phone with a
> > camera and an DVB-H receiver), you'll likely have more than one media controller.
> > So, controlling video buffer pools at /dev/video or at media controller will give
> > the same results on several environments;
> 
> I don't follow the logic here, sorry.

I mean that if you have a device with, for example, a dibcom driver for dvb-h, and an
uvc driver for the camera, you'll end by having two memory controllers.

Anyway, this is a bad example, since dvb-h is out of the current scope, but we can imagine
for example a surveillance solution with several PCI boards there. This means that we'll
have several memory controllers.

> > 4) As you've mentioned, a global set of buffers seem to be the better alternative. This
> > means that V4L2 core will take care of controlling the pool, instead of leaving
> > this task to the drivers. This makes easier to have a boot-time parameter specifying
> > the size of the memory pool and will optimize memory usage. We may even have a
> > Kconfig var specifying the default size of the memory pool (although this is
> > not really needed, since new kernels allow specifying default line command parameters).
> 
> Different devices may have quite different buffer requirements (size, number
> of buffers). Would it be safe to have them all allocated from a global pool?
> I do not feel confident myself that I understand all the implications of a
> global pool or whether you actually always want that.

This is a problem with the pool concept. Even having the same driver, you'll still be
needing different resolutions, frame rates, formats and bits per pixel on
each /dev/video interface. I'm not sure how to deal. Maybe we'll need to allocate the
buffers considering the worse case that can be passed to the driver. For example,
in the case of a kernel parameter, it could be something like:
	videobuf=buffers=32,size=256K
To allocate 32 buffers with 256K each. This way, even if application asks for a smaller buffer,
it will keep reserving 256K for each buffer. If bad specified, memory will be wasted, but
the memory will be there.

Eventually, after allocating that memory, some API could be provided for example to rearrange
the allocated space into 64 x 128K.

> > 5) The step to have a a global-wide video buffers pool allocation, as you
> > mentioned at the RFC, is to make sure that all drivers will use v4l2 framework
> > to allocate memory. So, this means porting a few drivers (ivtv, uvcvideo, cx18
> > and gspca) to use videobuf. As videobuf already supports all sorts of different
> > memory types and configs (contig and Scatter/Gather DMA, vmalloced buffers,
> > mmap, userptr, read, overlay modes), it should fits well on the needs.
> 
> Why would I want to change ivtv for this? In fact, I see no reason to modify
> any of the existing drivers. A mc-wide or global memory pool is only of
> interest for very complex devices where you want to pass buffers around
> between various sub-devices (and possibly to other media devices or DSPs).
> And yes, they probably will have to use the framework in order to be able to
> coordinate these pools properly.

The issue here is not necessarely related to device complexity. It can be
motivated by other factors, for example:

	- arch's with non-coherent cache;
	- devices that aren't capable of doing DMA scatter/gather;
	- high memory fragmentation.

Just as an example, I used an old laptop with "only" 256 Mb of ram, running a new distro,
when I started developing the tm6000 drivers. On that hardware, I was needing
buffers of about 600 KB each. It were very common to not be able to allocate such buffers
there, due to high memory fragmentation, since the USB driver were trying to allocate a
continuous buffer on that hardware.

So, the same argument we used with the EMBEEDED Kconfig option also applies here: it is not
everything black or white. For example, surveillance systems need to be very reliable.
So, the possibility of allocating memory during boot will help them.

Just to take a random real usecase, David Liontooth mentioned recently at the ML his
intention of maybe using ivtv hardware to capture TV signals at remote
locations, having the hardware minimally assisted. He mention the needs of capturing data
continuously for 15 hours. That means that the machine will likely close devices and reopen
once a day, during years. In such application, a video buffer pool will for
sure reduce the risk of memory fragmentation on such systems, giving more
reliability to the system, especially if the hardware it will use requires continuous buffers.

So, while I agree that it is not a mandatory requirement to port the existing drivers to
benefit with the memory pool, by not doing it, those drivers will be less reliable than
the other drivers on professional usage.

>  
> > 6) As videobuf uses a common method of allocating memory, and all memory
> > requests passes via videobuf-core (videobuf_alloc function), the implementation of a
> > global-wide set of videobuffer means to touch on just one function there, at the abstraction
> > layer, and to double check at the videobuf-dma-sg/videobuf-vmalloc/videobuf-contig if they
> > don't call directly their own allocation methods. If they do, a simple change
> > would be needed.
> > 
> > 7) IMO, the better interface for it is to add some sysfs attributes to media
> > class, providing there the means to control the video buffer pools. If the size
> > of a video buffer pool is set to zero, it will use normal memory allocation.
> > Otherwise, it will work at the "pool mode". 
> 
> Or you use the existing API to request either MEMORY_MMAP or MEMORY_POOL_MMAP.
> So much cleaner than creating some random sysfs attribute.

The existing V4L2 API applies over a /dev/video device, not at videobuf or V4L2
core level. As we want this at a core level, we need to apply it on a different place.

> > 8) By using videobuf, we can also export usage statistics via debugfs, providing
> > runtime statistics about how many memory is being used by what drivers and /dev devices.
> 
> Wouldn't procfs be more appropriate? I don't think debugfs is very common.

perf counters, strace, and other advanced monitoring tools use debugfs.



Cheers,
Mauro
