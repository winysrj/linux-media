Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:60856 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab2JJOr0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 10:47:26 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBO00ERGMEWRZA0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Oct 2012 23:47:24 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBO002YDME0EC70@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Oct 2012 23:47:24 +0900 (KST)
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, zhangfei.gao@gmail.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: [PATCHv10 00/26] Integration of videobuf2 with DMABUF
Date: Wed, 10 Oct 2012 16:46:19 +0200
Message-id: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,
This patchset adds support for DMABUF [2] importing and exporting to V4L2
stack.

v10:
- rebase on media-next 3.7
- typos and style fixes in Documentation (from Hans Verkuil)
- fix compilation error with __fill_vb2_buffer
- fix uninitialized data_offset for single-planar queue
- support for DMABUF importing in S5P-FIMC mem-to-mem interface
- update layout of v4l2_exportbuffer structure
- update ioctl flags in v4l2_ioctls for VIDIOC_EXPBUF
- support for DMABUF exporting in m2m framework
- allow exporting for file handles that calle REQBUBS/CREATE_BUF
- simplify handling of get_device in vb2_dc_alloc
- reduce pr_err to pr_debug while checking alignment of userptr
- check size of userptr buffer against zero
- align size to PAGE_SIZE at allocation of dma-contig buffer

v9:
- rebase on 3.6
- change type for fs to __s32
- add support for vb2_ioctl_expbuf
- remove patch 'v4l: vb2: add support for DMA_ATTR_NO_KERNEL_MAPPING',
  it will be posted as a separate patch
- fix typos and style in Documentation (from Hans Verkuil)
- only vb2-core and vb2-dma-contig selects DMA_SHARED_BUFFER in Kconfig
- use data_offset and length while queueing DMABUF
- return the most recently used fd at VIDIOC_DQBUF
- use (buffer-type, index, plane) tuple instead of mem_offset
  to identify a for exporting (from Hans Verkuil)
- support for DMABUF mmap in vb2-dma-contig (from Laurent Pinchart)
- add testing alignment of vaddr and size while verifying userptr
  against DMA capabilities (from Laurent Pinchart)
- substitute VM_DONTDUMP with VM_RESERVED
- simplify error handling in vb2_dc_get_dmabuf (from Laurent Pinchart)

v8:
- rebased on 3.6-rc1
- merged importer and exporter patchsets
- fixed missing fields in v4l2_plane32 and v4l2_buffer32 structs
- fixed typos/style in documentation
- significant reduction of warnings from checkpatch.pl
- fixed STREAMOFF issues reported by Dima Zavin [4] by adding
  __vb2_dqbuf helper to vb2-core
- DC fails if userptr is not correctly aligned
- add support for DMA attributes in DC
- add support for buffers with no kernel mapping
- add reference counting on device from allocator context
- dummy support for mmap
- use dma_get_sgtable, drop vb2_dc_kaddr_to_pages hack and
  vb2_dc_get_base_sgt helper

v7:
- support for V4L2_MEMORY_DMABUF in v4l2-compact-ioctl32.c
- cosmetic fixes to the documentation
- added importing for vmalloc because vmap support in dmabuf for 3.5
  was pull-requested
- support for dmabuf importing for VIVI
- resurrect allocation of dma-contig context
- remove reference of alloc_ctx in dma-contig buffer
- use sg_alloc_table_from_pages
- fix DMA scatterlist calls to use orig_nents instead of nents
- fix memleak in vb2_dc_sgt_foreach_page (use orig_nents instead of nents)

v6:
- fixed missing entry in v4l2_memory_names
- fixed a bug occuring after get_user_pages failure
- fixed a bug caused by using invalid vma for get_user_pages
- prepare/finish no longer call dma_sync for dmabuf buffers

v5:
- removed change of importer/exporter behaviour
- fixes vb2_dc_pages_to_sgt basing on Laurent's hints
- changed pin/unpin words to lock/unlock in Doc

v4:
- rebased on mainline 3.4-rc2
- included missing importing support for s5p-fimc and s5p-tv
- added patch for changing map/unmap for importers
- fixes to Documentation part
- coding style fixes
- pairing {map/unmap}_dmabuf in vb2-core
- fixing variable types and semantic of arguments in videobufb2-dma-contig.c

v3:
- rebased on mainline 3.4-rc1
- split 'code refactor' patch to multiple smaller patches
- squashed fixes to Sumit's patches
- patchset is no longer dependant on 'DMA mapping redesign'
- separated path for handling IO and non-IO mappings
- add documentation for DMABUF importing to V4L
- removed all DMABUF exporter related code
- removed usage of dma_get_pages extension

v2:
- extended VIDIOC_EXPBUF argument from integer memoffset to struct
  v4l2_exportbuffer
- added patch that breaks DMABUF spec on (un)map_atachment callcacks but allows
  to work with existing implementation of DMABUF prime in DRM
- all dma-contig code refactoring patches were squashed
- bugfixes

v1: List of changes since [1].
- support for DMA api extension dma_get_pages, the function is used to retrieve
  pages used to create DMA mapping.
- small fixes/code cleanup to videobuf2
- added prepare and finish callbacks to vb2 allocators, it is used keep
  consistency between dma-cpu acess to the memory (by Marek Szyprowski)
- support for exporting of DMABUF buffer in V4L2 and Videobuf2, originated from
  [3].
- support for dma-buf exporting in vb2-dma-contig allocator
- support for DMABUF for s5p-tv and s5p-fimc (capture interface) drivers,
  originated from [3]
- changed handling for userptr buffers (by Marek Szyprowski, Andrzej
  Pietrasiewicz)
- let mmap method to use dma_mmap_writecombine call (by Marek Szyprowski)

[1] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/42966/focus=42968
[2] https://lkml.org/lkml/2011/12/26/29
[3] http://thread.gmane.org/gmane.linux.kernel.cross-arch/12819
[4] http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/49700

Laurent Pinchart (2):
  v4l: vb2-dma-contig: shorten vb2_dma_contig prefix to vb2_dc
  v4l: vb2-dma-contig: reorder functions

Marek Szyprowski (4):
  v4l: vb2: add prepare/finish callbacks to allocators
  v4l: vb2-dma-contig: add prepare/finish to dma-contig allocator
  v4l: vb2-dma-contig: let mmap method to use dma_mmap_coherent call
  v4l: vb2-dma-contig: fail if user ptr buffer is not correctly aligned

Sumit Semwal (4):
  v4l: Add DMABUF as a memory type
  v4l: vb2: add support for shared buffer (dma_buf)
  v4l: vb: remove warnings about MEMORY_DMABUF
  v4l: vb2-dma-contig: add support for dma_buf importing

Tomasz Stanislawski (16):
  Documentation: media: description of DMABUF importing in V4L2
  v4l: vb2-dma-contig: remove reference of alloc_ctx from a buffer
  v4l: vb2-dma-contig: add support for scatterlist in userptr mode
  v4l: vb2-vmalloc: add support for dmabuf importing
  v4l: vivi: support for dmabuf importing
  v4l: s5p-tv: mixer: support for dmabuf importing
  v4l: s5p-fimc: support for dmabuf importing
  Documentation: media: description of DMABUF exporting in V4L2
  v4l: add buffer exporting via dmabuf
  v4l: vb2: add buffer exporting via dmabuf
  v4l: vb2-dma-contig: add support for DMABUF exporting
  v4l: vb2-dma-contig: add reference counting for a device from
    allocator context
  v4l: vb2-dma-contig: align buffer size to PAGE_SIZE
  v4l: s5p-fimc: support for dmabuf exporting
  v4l: s5p-tv: mixer: support for dmabuf exporting
  v4l: s5p-mfc: support for dmabuf exporting

 Documentation/DocBook/media/v4l/compat.xml         |    7 +
 Documentation/DocBook/media/v4l/io.xml             |  184 ++++-
 Documentation/DocBook/media/v4l/v4l2.xml           |    1 +
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |   16 +-
 Documentation/DocBook/media/v4l/vidioc-expbuf.xml  |  212 ++++++
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |   17 +
 Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |   47 +-
 drivers/media/platform/s5p-fimc/fimc-capture.c     |   11 +-
 drivers/media/platform/s5p-fimc/fimc-m2m.c         |   14 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   14 +
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   14 +
 drivers/media/platform/s5p-tv/mixer_video.c        |   12 +-
 drivers/media/platform/vivi.c                      |    2 +-
 drivers/media/v4l2-core/Kconfig                    |    3 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   19 +
 drivers/media/v4l2-core/v4l2-dev.c                 |    1 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |   11 +
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   13 +
 drivers/media/v4l2-core/videobuf-core.c            |    4 +
 drivers/media/v4l2-core/videobuf2-core.c           |  300 ++++++++-
 drivers/media/v4l2-core/videobuf2-dma-contig.c     |  702 ++++++++++++++++++--
 drivers/media/v4l2-core/videobuf2-memops.c         |   40 --
 drivers/media/v4l2-core/videobuf2-vmalloc.c        |   56 ++
 include/linux/videodev2.h                          |   35 +
 include/media/v4l2-ioctl.h                         |    2 +
 include/media/v4l2-mem2mem.h                       |    3 +
 include/media/videobuf2-core.h                     |   38 ++
 include/media/videobuf2-memops.h                   |    5 -
 28 files changed, 1645 insertions(+), 138 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-expbuf.xml

-- 
1.7.9.5

