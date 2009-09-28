Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:37650 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZI1OFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2009 10:05:39 -0400
From: <Stefan.Kost@nokia.com>
To: <laurent.pinchart@ideasonboard.com>, <linux-media@vger.kernel.org>,
	<hverkuil@xs4all.nl>, <sakari.ailus@maxwell.research.nokia.com>,
	<david.cohen@nokia.com>, <antti.koskipaa@nokia.com>,
	<vimarsh.zutshi@nokia.com>
Date: Mon, 28 Sep 2009 16:04:58 +0200
Subject: RE: [RFC] Global video buffers pool
Message-ID: <D019E777779A4345963526A1797F28D409E78C5B57@NOK-EUMSG-02.mgdnok.nokia.com>
References: <200909161746.39754.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200909161746.39754.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi, 

>-----Original Message-----
>From: ext Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com] 
>Sent: 16 September, 2009 18:47
>To: linux-media@vger.kernel.org; Hans Verkuil; Sakari Ailus; 
>Cohen David.A (Nokia-D/Helsinki); Koskipaa Antti 
>(Nokia-D/Helsinki); Zutshi Vimarsh (Nokia-D/Helsinki); Kost 
>Stefan (Nokia-D/Helsinki)
>Subject: [RFC] Global video buffers pool
>
>Hi everybody,
>
>I didn't want to miss this year's pretty flourishing RFC 
>season, so here's another one about a global video buffers pool.
>

Sorry for ther very late reply. I have been thinking about the problem on a bit broader scale and see the need for something more kernel wide. E.g. there is some work done from intel for graphics:
http://keithp.com/blogs/gem_update/

and this is not so much embedded even. If there buffer pools are v4l2specific then we need to make all those other subsystems like xvideo, opengl, dsp-bridges become v4l2 media controllers. 

Stefan

>
>All comments are welcome, but please don't trash this proposal 
>too fast. It's a first shot at real problems encountered in 
>real situations with real hardware (namely high resolution 
>still image capture on OMAP3). It's far from perfect, and I'm 
>open to completely different solutions if someone thinks of one.
>
>
>Introduction
>============
>
>The V4L2 video buffers handling API makes use of a queue of 
>video buffers to exchange data between video devices and 
>userspace applications (the read method don't expose the 
>buffers objects directly but uses them underneath). 
>Although quite efficient for simple video capture and output 
>use cases, the current implementation doesn't scale well when 
>used with complex hardware and large video resolutions. This 
>RFC will list the current limitations of the API and propose a 
>possible solution.
>
>The document is at this stage a work in progress. Its main 
>purpose is to be used as support material for discussions at 
>the Linux Plumbers Conference.
>
>
>Limitations
>===========
>
>Large buffers allocation
>------------------------
>
>Many video devices still require physically contiguous memory. The 
>introduction of IOMMUs on high-end systems will probably make 
>that a distant 
>nightmare in the future, but we have to deal with this 
>situation for the 
>moment (I'm not sure if the most recent PCI devices support 
>scatter-gather 
>lists, but many embedded systems still require physically 
>contiguous memory).
>
>Allocating large amounts of physically contiguous memory needs 
>to be done as 
>soon as possible after (or even during) system bootup, 
>otherwise memory 
>fragmentation will cause the allocation to fail.
>
>As the amount of required video memory depends on the frame 
>size and the 
>number of buffers, the driver can't pre-allocate the buffers 
>beforehand. A few 
>drivers allocate a large chunk of memory when they are loaded 
>and then use it 
>when a userspace application requests video buffers to be 
>allocated. However, 
>that method requires guessing how much memory will be needed, 
>and can lead to 
>waste of system memory (if the guess was too large) or 
>allocation failures (if 
>the guess was too low).
>
>Buffer queuing latency
>-----------------------
>
>VIDIOC_QBUF is becoming a performance bottleneck when 
>capturing large images 
>on some systems (especially in the embedded world). When 
>capturing high 
>resolution still pictures, the VIDIOC_QBUF delay adds to the 
>shot latency, 
>making the camera appear slow to the user.
>
>The delay is caused by several operations required by DMA 
>transfers that all 
>happen when queuing buffers.
>
>- Cache coherency management
>
>When the processor has a non-coherent cache (which is the case 
>with most 
>embedded devices, especially ARM-based) the device driver 
>needs to invalidate 
>(for video capture) or flush (for video output) the cache 
>(either a range, or 
>the whole cache) every time a buffer is queued. This ensures 
>that stale data 
>in the cache will not be written back to memory during or 
>after DMA and that 
>all data written by the CPU is visible to the device.
>
>Invalidating the cache for large resolutions take a 
>considerable amount of 
>time. Preliminary tests showed that cache invalidation for a 
>5MP buffer 
>requires several hundreds of milliseconds on an OMAP3 platform 
>for range 
>invalidation, or several tens of milliseconds when 
>invalidating the whole D 
>cache.
>
>When video buffers are passed between two devices (for 
>instance when passing 
>the same USERPTR buffer to a video capture device and a 
>hardware codec) 
>without any userspace access to the memory, CPU cache 
>invalidation/flushing 
>isn't required on either side (video capture and hardware 
>codec) and could be 
>skipped.
>
>- Memory locking and IOMMU
>
>Drivers need to lock the video buffer pages in memory to make 
>sure that the 
>physical pages will not be freed while DMA is in progress 
>under low-memory 
>conditions. This requires looping over all pages (typically 
>4kB long) that 
>back the video buffer (10MB for a 5MP YUV image) and takes a 
>considerable 
>amount of time.
>
>When using the MMAP streaming method, the buffers can be 
>locked in memory when 
>allocated (VIDIOC_REQBUFS). However, when using the USERPTR 
>streaming method, 
>the buffers can only be locked the first time they are queued, 
>adding to the 
>VIDIOC_QBUF latency.
>
>A similar issue arises when using IOMMUs. The IOMMU needs to 
>be programmed to 
>translate physically scattered pages into a contiguous memory 
>range on the 
>bus. This operation is done the first time buffers are queued 
>for USERPTR 
>buffers.
>
>Sharing buffers between devices
>-------------------------------
>
>Video buffers memory can be shared between several devices 
>when at most one of 
>them uses the MMAP method, and the others the USERPTR method. 
>This avoids 
>memcpy() operations when transferring video data from one 
>device to another 
>through memory (video acquisition -> hardware codec is the 
>most common use 
>case).
>
>However, the use of USERPTR buffers comes with restrictions 
>compared to MMAP. 
>Most architectures don't offer any API to DMA data to/from 
>userspace buffers. 
>Beside, kernel-allocated buffers could be fine-tuned by the 
>driver (making 
>them non-cacheable when it makes sense for instance), which is 
>not possible 
>when allocating the buffers in userspace.
>
>For that reason it would be interesting to be able to share 
>kernel-allocated 
>video buffers between devices.
>
>
>Video buffers pool
>==================
>
>Instead of having separate buffer queues at the video node 
>level, this RFC 
>proposes the creation of a video buffers pool at the media 
>controller level 
>that can be used to pre-allocate and pre-queue video buffers 
>shared by all 
>video devices created by the media controller.
>
>Depending on the implementation complexity, the pool could 
>even be made 
>system-wide and shared by all video nodes.
>
>Allocating buffers
>------------------
>
>The video buffers pool will handle independent groups of video buffers.
>
>        allocate               request
>(NULL)   ----->   (ALLOCATED)   ----->   (ACTIVE)
>         <----                  <-----
>          free                 release
>
>Video buffers groups allocation is controlled by userspace. 
>When allocating a 
>buffers group, an application will specify
>
>- the number of buffers
>- the buffer size (all buffers in a group have the same size)
>- what type of physical memory to allocate (virtual or 
>physically contiguous)
>- whether to lock the pages in memory
>- whether to invalidate the cache
>
>Once allocated, a group becomes ALLOCATED and is given an ID 
>by the kernel.
>
>When dealing with really large video buffers, embedded system 
>designers might 
>want to restrict the amount of RAM used by the Linux kernel to 
>reserve memory 
>for video buffers. This use case should be supported. One 
>possible solution 
>would be to set the reserved RAM address and size as module 
>parameters, and 
>let the video buffers pool manage that memory. A full-blown 
>memory manager is 
>not required, as buffers in that range will be allocated by 
>applications that 
>know what they're doing.
>
>Queuing the buffers
>-------------------
>
>Buffers can be used by any video node that belongs to the same media 
>controller as the buffer pool.
>
>To use buffers from the video buffers pool, a userspace 
>application calls 
>VIDIOC_REQBUFS on the video node and sets the memory field to 
>V4L2_MEMORY_POOL. The video node driver creates a video 
>buffers queue with the 
>requested number of buffers (v4l2_requestbuffers::count) but 
>does not allocate 
>any buffer.
>
>Later, the userspace application calls VIDIOC_QBUF to queue 
>buffers from the 
>pool to the video node queue. It sets v4l2_buffer::memory to 
>V4L2_MEMORY_POOL 
>and v4l2_buffer::m to the ID of the buffers group in the pool.
>
>The driver must check if the buffer fulfills its needs. This 
>includes, but is 
>not limited to, verifying the buffer size. Some devices might require 
>contiguous memory, in which case the driver must check if the 
>buffer is 
>contiguous.
>
>Depending whether the pages have been locked in memory and the cache 
>invalidated when allocating the buffers group in the pool, the 
>driver might 
>need to lock pages and invalidate the cache at this point, is 
>it would do with 
>MMAP or USERPTR buffers. The ability to perform those operations when 
>allocating the group speeds up the VIDIOC_QBUF operation, 
>decreasing the still 
>picture shot latency.
>
>Once a buffer from a group is queued, the group is market as 
>active and can't 
>be freed until all its buffers are released.
>
>Dequeuing and using the buffers
>-------------------------------
>
>V4L2_MEMORY_POOL buffers are dequeued similarly to MMAP or 
>USERPTR buffers. 
>Applications must set v4l2_buffer::memory to V4L2_MEMORY_POOL 
>and the driver 
>will set v4l2_buffer::m to the buffers group ID.
>
>The buffer can then be used by the application and queued back 
>to the same 
>video node, or queued to another video node. If the 
>application doesn't touch 
>the buffer memory (neither reads from nor writes to memory) it can set 
>v4l2_buffer::flags to the new V4L2_BUF_FLAG_NO_CACHE value to 
>tell the driver 
>to skip cache invalidation and cleaning.
>
>Another option would be to base the decision whether to 
>invalidate/flush the 
>cache on whether to buffer is currently mmap'ed in userspace. 
>A non-mmap'ed 
>buffer can't be touched by userspace, and cache 
>invalidation/flushing is thus 
>not required. However, this wouldn't work for USERPTR-like 
>buffer groups, but 
>those are not supported at the moment.
>
>Freeing the buffers
>-------------------
>
>A buffer group can only be freed if all its buffers are not in 
>use. This 
>includes
>
>- all buffers that have been mmap'ed must have been unmap'ed
>- no buffer can be queued to a video node
>
>If both conditions are fulfilled, all buffers in the group are 
>unused by both 
>userspace and kernelspace. They can then be freed.
>
>-- 
>Laurent Pinchart
>