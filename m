Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:38064 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbZIRHWm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 03:22:42 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	=?iso-8859-1?Q?Koskip=E4=E4_Antti_Jussi_Petteri?=
	<antti.koskipaa@nokia.com>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	"stefan.kost@nokia.com" <stefan.kost@nokia.com>
Date: Fri, 18 Sep 2009 12:52:34 +0530
Subject: RE: [RFC] Global video buffers pool
Message-ID: <19F8576C6E063C45BE387C64729E73940436BA5EBB@dbde02.ent.ti.com>
References: <200909161746.39754.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200909161746.39754.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Wednesday, September 16, 2009 9:17 PM
> To: linux-media@vger.kernel.org; Hans Verkuil; Sakari Ailus; Cohen
> David Abraham; Koskipää Antti Jussi Petteri; Zutshi Vimarsh (Nokia-
> D-MSW/Helsinki); stefan.kost@nokia.com
> Subject: [RFC] Global video buffers pool
> 
> Hi everybody,
> 
> I didn't want to miss this year's pretty flourishing RFC season, so
> here's
> another one about a global video buffers pool.
> 
> All comments are welcome, but please don't trash this proposal too
> fast. It's
> a first shot at real problems encountered in real situations with
> real
> hardware (namely high resolution still image capture on OMAP3). It's
> far from
> perfect, and I'm open to completely different solutions if someone
> thinks of
> one.
> 
[Hiremath, Vaibhav] Thanks Laurent for putting this, I believe memory fragmentation is a critical issue for most of new the drivers. We need some sort of solution to address this.

Please find some observations/issues/Q below - 

> 
> Introduction
> ============
> 
> The V4L2 video buffers handling API makes use of a queue of video
> buffers to
> exchange data between video devices and userspace applications (the
> read
> method don't expose the buffers objects directly but uses them
> underneath).
> Although quite efficient for simple video capture and output use
> cases, the
> current implementation doesn't scale well when used with complex
> hardware and
> large video resolutions. This RFC will list the current limitations
> of the API
> and propose a possible solution.
> 
> The document is at this stage a work in progress. Its main purpose
> is to be
> used as support material for discussions at the Linux Plumbers
> Conference.
> 
> 
> Limitations
> ===========
> 
> Large buffers allocation
> ------------------------
> 
> Many video devices still require physically contiguous memory. The
> introduction of IOMMUs on high-end systems will probably make that a
> distant
> nightmare in the future, but we have to deal with this situation for
> the
> moment (I'm not sure if the most recent PCI devices support scatter-
> gather
> lists, but many embedded systems still require physically contiguous
> memory).
> 
> Allocating large amounts of physically contiguous memory needs to be
> done as
> soon as possible after (or even during) system bootup, otherwise
> memory
> fragmentation will cause the allocation to fail.
> 
> As the amount of required video memory depends on the frame size and
> the
> number of buffers, the driver can't pre-allocate the buffers
> beforehand. A few
> drivers allocate a large chunk of memory when they are loaded and
> then use it
> when a userspace application requests video buffers to be allocated.
> However,
> that method requires guessing how much memory will be needed, and
> can lead to
> waste of system memory (if the guess was too large) or allocation
> failures (if
> the guess was too low).
> 
[Hiremath, Vaibhav] Could it possible to fine tune this based on use-case. At-least on OMAP Display driver we have boot argument to control number of buffers and size of buffers which user can pass through boot time argument. The default setting is 3 buffers for max resolution (720P).
With this it won't be guessing any more, right?

> Buffer queuing latency
> -----------------------
> 
> VIDIOC_QBUF is becoming a performance bottleneck when capturing
> large images
> on some systems (especially in the embedded world). When capturing
> high
> resolution still pictures, the VIDIOC_QBUF delay adds to the shot
> latency,
> making the camera appear slow to the user.
> 
> The delay is caused by several operations required by DMA transfers
> that all
> happen when queuing buffers.
> 
> - Cache coherency management
> 
[Hiremath, Vaibhav] Agreed.

> When the processor has a non-coherent cache (which is the case with
> most
> embedded devices, especially ARM-based) the device driver needs to
> invalidate
> (for video capture) or flush (for video output) the cache (either a
> range, or
> the whole cache) every time a buffer is queued. This ensures that
> stale data
> in the cache will not be written back to memory during or after DMA
> and that
> all data written by the CPU is visible to the device.
> 
> Invalidating the cache for large resolutions take a considerable
> amount of
> time. Preliminary tests showed that cache invalidation for a 5MP
> buffer
> requires several hundreds of milliseconds on an OMAP3 platform for
> range
> invalidation, or several tens of milliseconds when invalidating the
> whole D
> cache.
> 
> When video buffers are passed between two devices (for instance when
> passing
> the same USERPTR buffer to a video capture device and a hardware
> codec)
> without any userspace access to the memory, CPU cache
> invalidation/flushing
> isn't required on either side (video capture and hardware codec) and
> could be
> skipped.
> 
> - Memory locking and IOMMU
> 
> Drivers need to lock the video buffer pages in memory to make sure
> that the
> physical pages will not be freed while DMA is in progress under low-
> memory
> conditions. This requires looping over all pages (typically 4kB
> long) that
> back the video buffer (10MB for a 5MP YUV image) and takes a
> considerable
> amount of time.
> 
> When using the MMAP streaming method, the buffers can be locked in
> memory when
> allocated (VIDIOC_REQBUFS). However, when using the USERPTR
> streaming method,
> the buffers can only be locked the first time they are queued,
> adding to the
> VIDIOC_QBUF latency.
> 
> A similar issue arises when using IOMMUs. The IOMMU needs to be
> programmed to
> translate physically scattered pages into a contiguous memory range
> on the
> bus. This operation is done the first time buffers are queued for
> USERPTR
> buffers.
> 
> Sharing buffers between devices
> -------------------------------
> 
> Video buffers memory can be shared between several devices when at
> most one of
> them uses the MMAP method, and the others the USERPTR method. This
> avoids
> memcpy() operations when transferring video data from one device to
> another
> through memory (video acquisition -> hardware codec is the most
> common use
> case).
> 
> However, the use of USERPTR buffers comes with restrictions compared
> to MMAP.
> Most architectures don't offer any API to DMA data to/from userspace
> buffers.
> Beside, kernel-allocated buffers could be fine-tuned by the driver
> (making
> them non-cacheable when it makes sense for instance), which is not
> possible
> when allocating the buffers in userspace.
> 
> For that reason it would be interesting to be able to share kernel-
> allocated
> video buffers between devices.
> 
[Hiremath, Vaibhav] This is really good description.

> 
> Video buffers pool
> ==================
> 
> Instead of having separate buffer queues at the video node level,
> this RFC
> proposes the creation of a video buffers pool at the media
> controller level
> that can be used to pre-allocate and pre-queue video buffers shared
> by all
> video devices created by the media controller.
> 
> Depending on the implementation complexity, the pool could even be
> made
> system-wide and shared by all video nodes.
[Hiremath, Vaibhav] I have some doubts here, will put at the end after understanding the proposal.

> 
> Allocating buffers
> ------------------
> 
> The video buffers pool will handle independent groups of video
> buffers.
> 
>         allocate               request
> (NULL)   ----->   (ALLOCATED)   ----->   (ACTIVE)
>          <----                  <-----
>           free                 release
> 
> Video buffers groups allocation is controlled by userspace. When
> allocating a
> buffers group, an application will specify
> 
> - the number of buffers
> - the buffer size (all buffers in a group have the same size)
> - what type of physical memory to allocate (virtual or physically
> contiguous)
[Hiremath, Vaibhav] Why do we need this? I think this is more or less driven by HW, whether your hardware supports scatter-gather or not. 
And do we have any example where virtually non-contiguous memory is being used by HW/Drivers?

I am bit confused here. In OMAP if I understand correctly we have IOMMU which supports scatter-gather but the virtual space is still contiguious, right?


> - whether to lock the pages in memory
> - whether to invalidate the cache
> 
[Hiremath, Vaibhav] I like this point, user should specify whether to invalidate or lock the pages, if user is not touching the buffers and queuing the buffers from another video node then this would really help to boost the performance.

> Once allocated, a group becomes ALLOCATED and is given an ID by the
> kernel.
> 
[Hiremath, Vaibhav] When you say application will control this and we are talking about same size buffer in pool, so for example, if I have one /dev/mc0 and /dev/video0 with 720P size resolution, then still you might fail to allocate this much memory. 

In my view, we have to have boot time allocation method for such a huge memory request, this way user can control/fine tune the buffer requirement as per the use-case.

I think same thing you have mentioned it below.

> When dealing with really large video buffers, embedded system
> designers might
> want to restrict the amount of RAM used by the Linux kernel to
> reserve memory
> for video buffers. This use case should be supported. One possible
> solution
> would be to set the reserved RAM address and size as module
> parameters, and
> let the video buffers pool manage that memory. A full-blown memory
> manager is
> not required, as buffers in that range will be allocated by
> applications that
> know what they're doing.
> 
> Queuing the buffers
> -------------------
> 
> Buffers can be used by any video node that belongs to the same media
> controller as the buffer pool.
> 
> To use buffers from the video buffers pool, a userspace application
> calls
> VIDIOC_REQBUFS on the video node and sets the memory field to
> V4L2_MEMORY_POOL. The video node driver creates a video buffers
> queue with the
> requested number of buffers (v4l2_requestbuffers::count) but does
> not allocate
> any buffer.
> 
> Later, the userspace application calls VIDIOC_QBUF to queue buffers
> from the
> pool to the video node queue. It sets v4l2_buffer::memory to
> V4L2_MEMORY_POOL
> and v4l2_buffer::m to the ID of the buffers group in the pool.
> 
> The driver must check if the buffer fulfills its needs. This
> includes, but is
> not limited to, verifying the buffer size. Some devices might
> require
> contiguous memory, in which case the driver must check if the buffer
> is
> contiguous.
> 
> Depending whether the pages have been locked in memory and the cache
> invalidated when allocating the buffers group in the pool, the
> driver might
> need to lock pages and invalidate the cache at this point, is it
> would do with
> MMAP or USERPTR buffers. The ability to perform those operations
> when
> allocating the group speeds up the VIDIOC_QBUF operation, decreasing
> the still
> picture shot latency.
> 
> Once a buffer from a group is queued, the group is market as active
> and can't
> be freed until all its buffers are released.
> 
> Dequeuing and using the buffers
> -------------------------------
> 
> V4L2_MEMORY_POOL buffers are dequeued similarly to MMAP or USERPTR
> buffers.
> Applications must set v4l2_buffer::memory to V4L2_MEMORY_POOL and
> the driver
> will set v4l2_buffer::m to the buffers group ID.
> 
> The buffer can then be used by the application and queued back to
> the same
> video node, or queued to another video node. If the application
> doesn't touch
> the buffer memory (neither reads from nor writes to memory) it can
> set
> v4l2_buffer::flags to the new V4L2_BUF_FLAG_NO_CACHE value to tell
> the driver
> to skip cache invalidation and cleaning.
> 
> Another option would be to base the decision whether to
> invalidate/flush the
> cache on whether to buffer is currently mmap'ed in userspace. A non-
> mmap'ed
> buffer can't be touched by userspace, and cache
> invalidation/flushing is thus
> not required. However, this wouldn't work for USERPTR-like buffer
> groups, but
> those are not supported at the moment.
> 
> Freeing the buffers
> -------------------
> 
> A buffer group can only be freed if all its buffers are not in use.
> This
> includes
> 
> - all buffers that have been mmap'ed must have been unmap'ed
> - no buffer can be queued to a video node
> 
> If both conditions are fulfilled, all buffers in the group are
> unused by both
> userspace and kernelspace. They can then be freed.
> 
[Hiremath, Vaibhav] Just would like to make one point here,

Are we really gaining anything by moving buffer pool to media controller? I do agree that we do need some kind of pool mechanism, but why are me putting this under media controller. 


- In my opinion we should enhance video-buf layer to handle/allocate pool of memory/buffers (most probably boot-time) and user will still make use of standard fields and interface. No change from user space interface.

- Or let driver decide on allocation part, as I mentioned before driver will allocate memory (mostly) during boot time and specify some flag to video-buf layer about it. 

At this point I should bring or point to similar kind of feature for buffer handling being made for OMAP3 frame buffer driver. 

http://arago-project.org/git/people/?p=vaibhav/ti-psp-omap-video.git;a=blob;f=drivers/video/omap2/vram.c;h=634ce23f9612d0d8b9d6674757b1bf1ca6e63b96;hb=44a1cb94f66f58cc9c6f6a0c975f5bdaba676dfc

Here we have vram allocator king of interface which takes and boot time argument for total vram required, then driver can call omap_vram_alloc for allocation. If this fails then driver fall down to dma_alloc_coherent.

I do agree that framebuffer driver has altogether different set of requirement from memory; it expects max buffer size to be allocated during boot time only. But I feel it is worth looking at implementation, we may get some pointers from it.


> --
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

