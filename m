Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3989 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab2JGKEN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Oct 2012 06:04:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCHv9 00/25] Integration of videobuf2 with DMABUF
Date: Sun, 7 Oct 2012 12:03:52 +0200
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, zhangfei.gao@gmail.com,
	s.nawrocki@samsung.com, k.debski@samsung.com
References: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210071203.52732.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all!

On Tue October 2 2012 16:27:11 Tomasz Stanislawski wrote:
> Hello everyone,
> This patchset adds support for DMABUF [2] importing and exporting to V4L2
> stack.

I see that there is a lot of interest to getting this into 3.7. I understand
that, but IMHO this is a bit too soon. I would like to see the review comments
I made for v9 addressed, and more importantly, I would *really* like to see
mem2mem_testdev.c be dmabuf aware. One of the problems today is that it is
hard to test this, but if vivi and mem2mem_testdev can do dmabuf, then it is
easy to setup a pipeline that everyone can use for testing and application
development without requiring special hardware.

My suggestion would be to get a v10 out, and merge that as soon as the for_v3.8
branch opens. Then get mem2mem_testdev ready for dmabuf as well for 3.8.

Regards,

	Hans

> 
> v9:
> - rebase on 3.6
> - change type for fs to __s32
> - add support for vb2_ioctl_expbuf
> - remove patch 'v4l: vb2: add support for DMA_ATTR_NO_KERNEL_MAPPING',
>   it will be posted as a separate patch
> - fix typos and style in Documentation (from Hans Verkuil)
> - only vb2-core and vb2-dma-contig selects DMA_SHARED_BUFFER in Kconfig
> - use data_offset and length while queueing DMABUF
> - return the most recently used fd at VIDIOC_DQBUF
> - use (buffer-type, index, plane) tuple instead of mem_offset
>   to identify a for exporting (from Hans Verkuil)
> - support for DMABUF mmap in vb2-dma-contig (from Laurent Pinchart)
> - add testing alignment of vaddr and size while verifying userptr
>   against DMA capabilities (from Laurent Pinchart)
> - substitute VM_DONTDUMP with VM_RESERVED
> - simplify error handling in vb2_dc_get_dmabuf (from Laurent Pinchart)
> 
> v8:
> - rebased on 3.6-rc1
> - merged importer and exporter patchsets
> - fixed missing fields in v4l2_plane32 and v4l2_buffer32 structs
> - fixed typos/style in documentation
> - significant reduction of warnings from checkpatch.pl
> - fixed STREAMOFF issues reported by Dima Zavin [4] by adding
>   __vb2_dqbuf helper to vb2-core
> - DC fails if userptr is not correctly aligned
> - add support for DMA attributes in DC
> - add support for buffers with no kernel mapping
> - add reference counting on device from allocator context
> - dummy support for mmap
> - use dma_get_sgtable, drop vb2_dc_kaddr_to_pages hack and
>   vb2_dc_get_base_sgt helper
> 
> v7:
> - support for V4L2_MEMORY_DMABUF in v4l2-compact-ioctl32.c
> - cosmetic fixes to the documentation
> - added importing for vmalloc because vmap support in dmabuf for 3.5
>   was pull-requested
> - support for dmabuf importing for VIVI
> - resurrect allocation of dma-contig context
> - remove reference of alloc_ctx in dma-contig buffer
> - use sg_alloc_table_from_pages
> - fix DMA scatterlist calls to use orig_nents instead of nents
> - fix memleak in vb2_dc_sgt_foreach_page (use orig_nents instead of nents)
> 
> v6:
> - fixed missing entry in v4l2_memory_names
> - fixed a bug occuring after get_user_pages failure
> - fixed a bug caused by using invalid vma for get_user_pages
> - prepare/finish no longer call dma_sync for dmabuf buffers
> 
> v5:
> - removed change of importer/exporter behaviour
> - fixes vb2_dc_pages_to_sgt basing on Laurent's hints
> - changed pin/unpin words to lock/unlock in Doc
> 
> v4:
> - rebased on mainline 3.4-rc2
> - included missing importing support for s5p-fimc and s5p-tv
> - added patch for changing map/unmap for importers
> - fixes to Documentation part
> - coding style fixes
> - pairing {map/unmap}_dmabuf in vb2-core
> - fixing variable types and semantic of arguments in videobufb2-dma-contig.c
> 
> v3:
> - rebased on mainline 3.4-rc1
> - split 'code refactor' patch to multiple smaller patches
> - squashed fixes to Sumit's patches
> - patchset is no longer dependant on 'DMA mapping redesign'
> - separated path for handling IO and non-IO mappings
> - add documentation for DMABUF importing to V4L
> - removed all DMABUF exporter related code
> - removed usage of dma_get_pages extension
> 
> v2:
> - extended VIDIOC_EXPBUF argument from integer memoffset to struct
>   v4l2_exportbuffer
> - added patch that breaks DMABUF spec on (un)map_atachment callcacks but allows
>   to work with existing implementation of DMABUF prime in DRM
> - all dma-contig code refactoring patches were squashed
> - bugfixes
> 
> v1: List of changes since [1].
> - support for DMA api extension dma_get_pages, the function is used to retrieve
>   pages used to create DMA mapping.
> - small fixes/code cleanup to videobuf2
> - added prepare and finish callbacks to vb2 allocators, it is used keep
>   consistency between dma-cpu acess to the memory (by Marek Szyprowski)
> - support for exporting of DMABUF buffer in V4L2 and Videobuf2, originated from
>   [3].
> - support for dma-buf exporting in vb2-dma-contig allocator
> - support for DMABUF for s5p-tv and s5p-fimc (capture interface) drivers,
>   originated from [3]
> - changed handling for userptr buffers (by Marek Szyprowski, Andrzej
>   Pietrasiewicz)
> - let mmap method to use dma_mmap_writecombine call (by Marek Szyprowski)
> 
> [1] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/42966/focus=42968
> [2] https://lkml.org/lkml/2011/12/26/29
> [3] http://thread.gmane.org/gmane.linux.kernel.cross-arch/12819
> [4] http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/49700
> 
> Laurent Pinchart (2):
>   v4l: vb2-dma-contig: shorten vb2_dma_contig prefix to vb2_dc
>   v4l: vb2-dma-contig: reorder functions
> 
> Marek Szyprowski (4):
>   v4l: vb2: add prepare/finish callbacks to allocators
>   v4l: vb2-dma-contig: add prepare/finish to dma-contig allocator
>   v4l: vb2-dma-contig: let mmap method to use dma_mmap_coherent call
>   v4l: vb2-dma-contig: fail if user ptr buffer is not correctly aligned
> 
> Sumit Semwal (4):
>   v4l: Add DMABUF as a memory type
>   v4l: vb2: add support for shared buffer (dma_buf)
>   v4l: vb: remove warnings about MEMORY_DMABUF
>   v4l: vb2-dma-contig: add support for dma_buf importing
> 
> Tomasz Stanislawski (15):
>   Documentation: media: description of DMABUF importing in V4L2
>   v4l: vb2-dma-contig: remove reference of alloc_ctx from a buffer
>   v4l: vb2-dma-contig: add support for scatterlist in userptr mode
>   v4l: vb2-vmalloc: add support for dmabuf importing
>   v4l: vivi: support for dmabuf importing
>   v4l: s5p-tv: mixer: support for dmabuf importing
>   v4l: s5p-fimc: support for dmabuf importing
>   Documentation: media: description of DMABUF exporting in V4L2
>   v4l: add buffer exporting via dmabuf
>   v4l: vb2: add buffer exporting via dmabuf
>   v4l: vb2-dma-contig: add support for DMABUF exporting
>   v4l: vb2-dma-contig: add reference counting for a device from
>     allocator context
>   v4l: s5p-fimc: support for dmabuf exporting
>   v4l: s5p-tv: mixer: support for dmabuf exporting
>   v4l: s5p-mfc: support for dmabuf exporting
> 
>  Documentation/DocBook/media/v4l/compat.xml         |    7 +
>  Documentation/DocBook/media/v4l/io.xml             |  183 +++++-
>  Documentation/DocBook/media/v4l/v4l2.xml           |    1 +
>  .../DocBook/media/v4l/vidioc-create-bufs.xml       |   16 +-
>  Documentation/DocBook/media/v4l/vidioc-expbuf.xml  |  212 ++++++
>  Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |   17 +
>  Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |   47 +-
>  drivers/media/video/Kconfig                        |    2 +
>  drivers/media/video/s5p-fimc/fimc-capture.c        |   11 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_dec.c          |   14 +
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.c          |   14 +
>  drivers/media/video/s5p-tv/mixer_video.c           |   12 +-
>  drivers/media/video/v4l2-compat-ioctl32.c          |   19 +
>  drivers/media/video/v4l2-dev.c                     |    1 +
>  drivers/media/video/v4l2-ioctl.c                   |   11 +
>  drivers/media/video/videobuf-core.c                |    4 +
>  drivers/media/video/videobuf2-core.c               |  300 ++++++++-
>  drivers/media/video/videobuf2-dma-contig.c         |  695 ++++++++++++++++++--
>  drivers/media/video/videobuf2-memops.c             |   40 --
>  drivers/media/video/videobuf2-vmalloc.c            |   56 ++
>  drivers/media/video/vivi.c                         |    2 +-
>  include/linux/videodev2.h                          |   35 +
>  include/media/v4l2-ioctl.h                         |    2 +
>  include/media/videobuf2-core.h                     |   38 ++
>  include/media/videobuf2-memops.h                   |    5 -
>  25 files changed, 1608 insertions(+), 136 deletions(-)
>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-expbuf.xml
> 
> 
