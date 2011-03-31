Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53935 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758298Ab1CaP3u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2011 11:29:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: v4l: Buffer pools
Date: Thu, 31 Mar 2011 17:30:09 +0200
Cc: "'Willy POISSON'" <willy.poisson@stericsson.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	"'Hans Verkuil'" <hverkuil@xs4all.nl>
References: <757395B8DE5A844B80F3F4BE9867DDB652374B2340@EXDCVYMBSTM006.EQ1STM.local> <001b01cbef8c$7da953a0$78fbfae0$%szyprowski@samsung.com>
In-Reply-To: <001b01cbef8c$7da953a0$78fbfae0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103311730.10282.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Marek,

On Thursday 31 March 2011 12:14:55 Marek Szyprowski wrote:
> On Tuesday, March 29, 2011 4:02 PM Willy POISSON wrote:
> > 	Following to the Warsaw mini-summit action point, I would like to open
> > 	the thread to gather
> > 
> > buffer pool & memory manager requirements.
> > The list of requirement for buffer pool may contain:
> > -	Support physically contiguous and virtual memory
> > -	Support IPC, import/export handles (between
> > processes/drivers/userland/etc) -	Security(access rights in order to
> > secure no one unauthorized is allowed to access buffers) -	Cache flush
> > management (by using setdomain and optimize when flushing is needed)
> > -	Pin/unpin in order to get the actual address to be able to do
> > defragmentation -	Support pinning in user land in order to allow
> > defragmentation while buffer is mmapped but not pined.
> > -	Both a user API and a Kernel API is needed for this module. (Kernel
> > drivers needs to be able to resolve buffer handles as well from the
> > memory manager module, and pin/unpin) -	be able to support any platform
> > specific allocator (Separate memory allocation from management as
> > allocator is platform dependant)
> > -	Support multiple region domain (Allow to allocate from several memory
> > domain ex: DDR1, DDR2, Embedded SRAM to make for ex bandwidth load
> > balancing ...)
> 
> The above list looks fine.
> 
> Memory/buffer pools are a large topic that covers at least 3 subsystems:
> 1. user space api
> 2. in-kernel buffer manager
> 3. in-kernel memory allocator
> 
> Most of the requirements above list can be assigned to one of these
> subsystems.
> 
> If would like to focus first on the user space API. This API should provide
> a generic way to allocate memory buffers. User space should not be aware
> of the allocator specific parameters of the buffer. User space should not
> decide whether a physically contiguous buffer is needed or not. The only
> information that user space should provide is a set or list of devices
> that the application want use with the allocated buffer. User space might
> also provide some additional hints about the buffers - like the preferred
> memory region.
> 
> Our chip S5PC110 and EXYNOS4 are very similar in terms of integrated
> multimedia modules, however there is one important difference. The latter
> has IOMMU module, so multimedia blocks doesn't require physically
> contiguous buffers. In userspace however we would like to support both
> with the same API.
> 
> We have also a very specific requirement for buffers for video codes
> (chroma buffers and luma buffers must be allocated from different memory
> banks). The memory bank should be specified at allocation time.
> 
> The only problem is to define a way the user space API will be able to
> provide a list of devices that must be able to operate with the allocated
> buffer. Without some kind of enumeration of all entities that work with
> buffer pool it might be a bit hard. I would like to avoid the need of
> hardcoding device names in the user space applications.

I've been thinking about that, and I'm not sure how feasible it would be. 
Beside the difficulty of passing a list of devices from applications to the 
kernel, drivers would need to transform that list into memory requirements 
compatible with all devices in the list. That will likely become very complex.

Wouldn't it be better to let applications specify memory requirements 
explicitly, and have individual drivers check if the buffers match their 
requirements when the buffer are used ?

> The in-kernel memory allocator is mainly targeted to systems that require
> physically contiguous buffers. Currently CMA framework perfectly fits
> here. A new version will be posted very soon.
> 
> > Another idea, but not so linked to memory management (more usage of
> > buffers), would be to have a common data container (structure to access
> > data) shared by several media (Imaging, video/still codecs, graphics,
> > Display...) to ease usage of the data. This container could  embed data
> > type (video frames, Access Unit) , frames format, pixel format, width,
> > height, pixel aspect ratio, region of interest, CTS (composition time
> > stamp),  ColorSpace, transparency (opaque, alpha, color key...), pointer
> > on buffer(s) handle)...
> 
> I'm not sure if such idea can be ever implemented in the mainline kernel...
> IHMO it is too complicated.

-- 
Regards,

Laurent Pinchart
