Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:59386 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab1CaKPH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2011 06:15:07 -0400
Received: from epmmp1 (ep_mmp1 [203.254.227.16])
 by mailout2.samsung.com (Oracle Communications Messaging Exchange Server
 7u4-19.01 64bit (built Sep  7 2010))
 with ESMTP id <0LIX00DN7354IH60@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Mar 2011 19:15:04 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LIX00MAQ34WGN@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Mar 2011 19:15:04 +0900 (KST)
Date: Thu, 31 Mar 2011 12:14:55 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: v4l: Buffer pools
In-reply-to: <757395B8DE5A844B80F3F4BE9867DDB652374B2340@EXDCVYMBSTM006.EQ1STM.local>
To: 'Willy POISSON' <willy.poisson@stericsson.com>,
	linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, 'Hans Verkuil' <hverkuil@xs4all.nl>,
	kyungmin.park@samsung.com
Message-id: <001b01cbef8c$7da953a0$78fbfae0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <757395B8DE5A844B80F3F4BE9867DDB652374B2340@EXDCVYMBSTM006.EQ1STM.local>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Tuesday, March 29, 2011 4:02 PM Willy POISSON wrote:

> 	Following to the Warsaw mini-summit action point, I would like to open the thread to gather
> buffer pool & memory manager requirements.
> The list of requirement for buffer pool may contain:
> -	Support physically contiguous and virtual memory
> -	Support IPC, import/export handles (between processes/drivers/userland/etc)
> -	Security(access rights in order to secure no one unauthorized is allowed to access buffers)
> -	Cache flush management (by using setdomain and optimize when flushing is needed)
> -	Pin/unpin in order to get the actual address to be able to do defragmentation
> -	Support pinning in user land in order to allow defragmentation while buffer is mmapped but not
> pined.
> -	Both a user API and a Kernel API is needed for this module. (Kernel drivers needs to be able to
> resolve buffer handles as well from the memory manager module, and pin/unpin)
> -	be able to support any platform specific allocator (Separate memory allocation from management
> as allocator is platform dependant)
> -	Support multiple region domain (Allow to allocate from several memory domain ex: DDR1, DDR2,
> Embedded SRAM to make for ex bandwidth load balancing ...)

The above list looks fine.

Memory/buffer pools are a large topic that covers at least 3 subsystems:
1. user space api
2. in-kernel buffer manager
3. in-kernel memory allocator 

Most of the requirements above list can be assigned to one of these subsystems.

If would like to focus first on the user space API. This API should provide a generic way to allocate
memory buffers. User space should not be aware of the allocator specific parameters of the buffer.
User space should not decide whether a physically contiguous buffer is needed or not. The only
information that user space should provide is a set or list of devices that the application want use
with the allocated buffer. User space might also provide some additional hints about the buffers - like
the preferred memory region.

Our chip S5PC110 and EXYNOS4 are very similar in terms of integrated multimedia modules, however there
is one important difference. The latter has IOMMU module, so multimedia blocks doesn't require physically
contiguous buffers. In userspace however we would like to support both with the same API.

We have also a very specific requirement for buffers for video codes (chroma buffers and luma buffers
must be allocated from different memory banks). The memory bank should be specified at allocation time.

The only problem is to define a way the user space API will be able to provide a list of devices that 
must be able to operate with the allocated buffer. Without some kind of enumeration of all entities 
that work with buffer pool it might be a bit hard. I would like to avoid the need of hardcoding device 
names in the user space applications.

The in-kernel memory allocator is mainly targeted to systems that require physically contiguous buffers.
Currently CMA framework perfectly fits here. A new version will be posted very soon.

> Another idea, but not so linked to memory management (more usage of buffers), would be to have a
> common data container (structure to access data) shared by several media (Imaging, video/still codecs,
> graphics, Display...) to ease usage of the data. This container could  embed data type (video frames,
> Access Unit) , frames format, pixel format, width, height, pixel aspect ratio, region of interest, CTS
> (composition time stamp),  ColorSpace, transparency (opaque, alpha, color key...), pointer on buffer(s)
> handle)...

I'm not sure if such idea can be ever implemented in the mainline kernel... IHMO it is too complicated.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


