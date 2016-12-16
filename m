Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:50912 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752198AbcLPMHZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 07:07:25 -0500
Subject: Re: [RFC v2 00/11] vb2: Handle user cache hints, allow drivers to
 choose cache coherency
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
References: <20161216012425.11179-1-laurent.pinchart+renesas@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Laura Abbott <labbott@redhat.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e0d65f5b-f997-68da-085b-24c874f8fb35@xs4all.nl>
Date: Fri, 16 Dec 2016 13:06:48 +0100
MIME-Version: 1.0
In-Reply-To: <20161216012425.11179-1-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16/12/16 02:24, Laurent Pinchart wrote:
> Hello,
>
> This is a rebased version of the vb2 cache hints support patch series posted
> by Sakari more than a year ago. The patches have been modified as needed by
> the upstream changes and received the occasional small odd fix but are
> otherwise not modified. Please see the individual commit messages for more
> information.
>
> The videobuf2 memory managers use the DMA mapping API to handle cache
> synchronization on systems that require them transparently for drivers. As
> cache operations are expensive, system performances can be impacted. Cache
> synchronization can't be skipped altogether if we want to retain correct
> behaviour, but optimizations are possible in cases related to buffer sharing
> between multiple devices without CPU access to the memory.
>
> The first optimization covers cases where the memory never needs to be
> accessed by the CPU (neither in kernelspace nor in userspace). In those cases,
> as no CPU memory mappings exist, cache synchronization can be skipped. The
> situation could be detected in the kernel as we have enough information to
> determine whether CPU mappings for kernelspace or userspace exist (in the
> first case because drivers should request them explicitly, in the second case
> because the mmap() handler hasn't been invoked). This optimization is not
> implemented currently but should at least be prototyped as it could improve
> performances automatically in a large number of cases.
>
> The second class of optimizations cover cases where the memory sometimes needs
> to be accessed by the CPU. In those cases memory mapping must be created and
> cache handled, but cache synchronization could be skipped for buffer that are
> not touched by the CPU.
>
> By default the following cache synchronization operations need to be performed
> related to the buffer management ioctls. For simplicity means of QBUF below
> apply to buf VIDIOC_QBUF and VIDIOC_PREPARE_BUF.
>
> 		| QBUF		| DQBUF
> 	----------------------------------------
> 	CAPTURE	| Invalidate	| Invalidate (*)
> 	OUTPUT	| Clean		| -
>
> (*) for systems using speculative pre-fetching only
>
> The following cases can be optimized.
>
> 1. CAPTURE, the CPU has not written to the buffer before QBUF
>
>    Cache invalidation can be skipped at QBUF time, but becomes required at
>    DQBUF time on all systems, regardless of whether they use speculative
>    prefetching.
>
> 2. CAPTURE, the CPU will not read from the buffer after DQBUF
>
>    Cache invalidation can be skipped at DQBUF time.
>
> 3. CAPTURE, combination of (1) and (2)
>
>    Cache invalidation can be skipped at both QBUF and DQBUF time.
>
> 4. OUTPUT, the CPU has not written to the buffer before QBUF
>
>    Cache clean can be skipped at QBUF time.
>
>
> The kernel can't detect thoses situations automatically and thus requires
> hints from userspace to decide whether cache synchronization can be skipped.
> It should be noted that those hints might not be honoured. In particular, if
> userspace hints that it hasn't touched the buffer with the CPU, drivers might
> need to perform memory accesses themselves (adding JPEG or MPEG headers to
> buffers is a common case where CPU access could be needed in the kernel), in
> which case the userspace hints will be ignored.
>
> Getting the hints wrong will result in data corruption. Userspace applications
> are allowed to shoot themselves in the foot, but driver are responsible for
> deciding whether data corruption can pose a risk to the system in general. For
> instance if the device could be made to crash, or behave in a way that would
> jeopardize system security, reliability or performances, when fed with invalid
> data, cache synchronization shall not be skipped solely due to possibly
> incorrect userspace hints.
>
> The V4L2 API defines two flags, V4L2-BUF-FLAG-NO-CACHE-INVALIDATE and
> V4L2_BUF_FLAG_NO_CACHE_SYNC, that can be used to provide cache-related hints
> to the kernel. However, no kernel has ever implemented support for those flags
> that are thus most likely unused.
>
> A single flag is enough to cover all the optimization cases described above,
> provided we keep track of the flag being set at QBUF time to force cache
> invalidation at DQBUF time for case (1) if the  flag isn't set at DQBUF time.
> This patch series thus cleans up the userspace API and merges both flags into
> a single one.
>
> One potential issue with case (1) is that cache invalidation at DQBUF time for
> CAPTURE buffers isn't fully under the control of videobuf2. We can instruct
> the DMA mapping API to skip cache handling, but we can't force it to
> invalidate the cache in the sync_for_cpu operation for non speculative
> prefetching systems. Luckily, on ARM32 the current implementation always
> invalidates the cache in __dma_page_dev_to_cpu() for CAPTURE buffers so we are
> safe fot now. However, this is documented by a FIXME comment that might lead
> to someone fixing the implementation in the future. I believe we will have to
> the problem at the DMA mapping level, the userspace hint API shouldn't be
> affected.
>
> This RFC patch set achieves two main objectives:
>
> 1. Respect cache flags passed from the user space. As no driver nor videobuf2
> has (ever?) implemented them, the two flags are replaced by a single one
> (V4L2_BUF_FLAG_NO_CACHE_SYNC) and the two old flags are deprecated. This is
> done since a single flag provides the driver with enough information on what
> to do. (Patches 01/11 to 05/11, see patch 04/11 for more information.)
>
> 2. Allow a driver using videobuf2 dma-contig memory type to choose whether it
> prefers coherent or non-coherent CPU access to buffer memory for MMAP and
> USERPTR buffers. This could be later extended to be specified by the user, and
> per buffer if needed. (Patches 06/11 and 11/11).
>
> Only dma-contig memory type is changed but the same could be done to dma-sg as
> well. Sakari offered in v1 to add it to the set if people are happy with the
> changes to dma-contig.
>
> Note should be taken that the series performs cache optimization for MMAP
> buffers only. DMABUF imported buffers have their cache synchronization handled
> by the exported through the dma_buf_map_attachment() and
> dma_buf_unmap_attachment() functions, and dma-buf lacks an API to perform
> memory synchronization without unmapping and remapping the buffers. This is
> not a blocker as far as this patch series is concerned, but importing buffers
> (usually exported by the CPU) is such an important use case that we can't
> considered the cache optimization problem anywhere close to being solved if we
> don't address this case. I plan to start addressing the problem in January or
> February 2017, feedback on this point will thus be appreciated.

This series looks good to me, so:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

>
>
> Sakari Ailus (10):
>   vb2: Rename confusingly named internal buffer preparation functions
>   vb2: Move buffer cache synchronisation to prepare from queue
>   vb2: Move cache synchronisation from buffer done to dqbuf handler
>   v4l: Unify cache management hint buffer flags
>   vb2: Improve struct vb2_mem_ops documentation; alloc and put are for
>     MMAP
>   vb2: dma-contig: Remove redundant sgt_base field
>   vb2: dma-contig: Don't warn on failure in obtaining scatterlist
>   vb2: dma-contig: Move vb2_dc_get_base_sgt() up
>   vb2: dma-contig: Let drivers decide DMA attrs of MMAP and USERPTR bufs
>   vb2: dma-contig: Add WARN_ON_ONCE() to check for potential bugs
>
> Samu Onkalo (1):
>   v4l2-core: Don't sync cache for a buffer if so requested
>
>  Documentation/media/uapi/v4l/buffer.rst            |  24 ++--
>  .../media/uapi/v4l/vidioc-prepare-buf.rst          |   5 +-
>  drivers/media/v4l2-core/videobuf2-core.c           | 120 ++++++++++++------
>  drivers/media/v4l2-core/videobuf2-dma-contig.c     | 135 ++++++++++++++-------
>  drivers/media/v4l2-core/videobuf2-v4l2.c           |  14 ++-
>  include/media/videobuf2-core.h                     |  43 ++++---
>  include/trace/events/v4l2.h                        |   3 +-
>  include/uapi/linux/videodev2.h                     |   7 +-
>  8 files changed, 228 insertions(+), 123 deletions(-)
>

