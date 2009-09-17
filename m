Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46008 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758619AbZIQSu2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2009 14:50:28 -0400
Date: Thu, 17 Sep 2009 15:49:49 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	=?ISO-8859-1?B?S29za2lw5OQ=?= Antti Jussi Petteri
	<antti.koskipaa@nokia.com>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	stefan.kost@nokia.com
Subject: Re: [RFC] Global video buffers pool
Message-ID: <20090917154949.21b85c1b@pedra.chehab.org>
In-Reply-To: <200909161746.39754.laurent.pinchart@ideasonboard.com>
References: <200909161746.39754.laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 16 Sep 2009 17:46:39 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi everybody,
> 
> I didn't want to miss this year's pretty flourishing RFC season, so here's 
> another one about a global video buffers pool.
> 
> All comments are welcome, but please don't trash this proposal too fast. It's 
> a first shot at real problems encountered in real situations with real 
> hardware (namely high resolution still image capture on OMAP3). It's far from 
> perfect, and I'm open to completely different solutions if someone thinks of 
> one.

Some comments about your proposal:

1) For embedded systems, probably the better is to create it at boot time, instead
of controlling it via userspace, since as early it is done, the better.

2) As I've posted at the media controller RFC, we should take care to not abuse
about its usage. Media controller has two specific objetives: topology
enumeration/change and subdev parameter send. For the last, as I've explained
there, the proper solution is to create devices for each v4l subdev that requires
control from userspace. In the case of a video buffers memory poll, it is none of the 
usecases of media controller. So, it is needed to think better about where to
implement it.

3) I don't think that having a buffer pool per media controller will be so useful.
A media controller groups /dev/video with their audio, IR, I2C... resources. On
systems with more than one different board (for example a cellular phone with a
camera and an DVB-H receiver), you'll likely have more than one media controller.
So, controlling video buffer pools at /dev/video or at media controller will give
the same results on several environments;

4) As you've mentioned, a global set of buffers seem to be the better alternative. This
means that V4L2 core will take care of controlling the pool, instead of leaving
this task to the drivers. This makes easier to have a boot-time parameter specifying
the size of the memory pool and will optimize memory usage. We may even have a
Kconfig var specifying the default size of the memory pool (although this is
not really needed, since new kernels allow specifying default line command parameters).

5) The step to have a a global-wide video buffers pool allocation, as you
mentioned at the RFC, is to make sure that all drivers will use v4l2 framework
to allocate memory. So, this means porting a few drivers (ivtv, uvcvideo, cx18
and gspca) to use videobuf. As videobuf already supports all sorts of different
memory types and configs (contig and Scatter/Gather DMA, vmalloced buffers,
mmap, userptr, read, overlay modes), it should fits well on the needs.

6) As videobuf uses a common method of allocating memory, and all memory
requests passes via videobuf-core (videobuf_alloc function), the implementation of a
global-wide set of videobuffer means to touch on just one function there, at the abstraction
layer, and to double check at the videobuf-dma-sg/videobuf-vmalloc/videobuf-contig if they
don't call directly their own allocation methods. If they do, a simple change
would be needed.

7) IMO, the better interface for it is to add some sysfs attributes to media
class, providing there the means to control the video buffer pools. If the size
of a video buffer pool is set to zero, it will use normal memory allocation.
Otherwise, it will work at the "pool mode". 

8) By using videobuf, we can also export usage statistics via debugfs, providing
runtime statistics about how many memory is being used by what drivers and /dev devices.



Cheers,
Mauro
