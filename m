Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2971 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2GaGfK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 02:35:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCHv7 00/15] Integration of videobuf2 with dmabuf
Date: Tue, 31 Jul 2012 08:34:57 +0200
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, g.liakhovetski@gmx.de
References: <1339681069-8483-1-git-send-email-t.stanislaws@samsung.com> <201207310823.15072.hverkuil@xs4all.nl>
In-Reply-To: <201207310823.15072.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207310834.57907.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue July 31 2012 08:23:15 Hans Verkuil wrote:
> Hi Tomasz!
> 
> What is the status of this? If it is stable, then it might be a good idea to
> rebase to the latest for_v3.6 and make a pull request for 3.6.

BTW, while rebasing also fix two typos in patch 9 and 15:

s/usefull/useful/

Regards,

	Hans

> 
> Regards,
> 
> 	Hans
> 
> On Thu June 14 2012 15:37:34 Tomasz Stanislawski wrote:
> > Hello everyone,
> > This patchset adds support for DMABUF [2] importing to V4L2 stack.
> > The support for DMABUF exporting was moved to separate patchset
> > due to dependency on patches for DMA mapping redesign by
> > Marek Szyprowski [4]. This patchset depends on new scatterlist
> > constructor [5].
> > 
> > v7:
> > - support for V4L2_MEMORY_DMABUF in v4l2-compact-ioctl32.c
> > - cosmetic fixes to the documentation
> > - added importing for vmalloc because vmap support in dmabuf for 3.5
> >   was pull-requested
> > - support for dmabuf importing for VIVI
> > - resurrect allocation of dma-contig context
> > - remove reference of alloc_ctx in dma-contig buffer
> > - use sg_alloc_table_from_pages
> > - fix DMA scatterlist calls to use orig_nents instead of nents
> > - fix memleak in vb2_dc_sgt_foreach_page (use orig_nents instead of nents)
> > 
> > v6:
> > - fixed missing entry in v4l2_memory_names
> > - fixed a bug occuring after get_user_pages failure
> > - fixed a bug caused by using invalid vma for get_user_pages
> > - prepare/finish no longer call dma_sync for dmabuf buffers
> > 
> > v5:
> > - removed change of importer/exporter behaviour
> > - fixes vb2_dc_pages_to_sgt basing on Laurent's hints
> > - changed pin/unpin words to lock/unlock in Doc
> > 
> > v4:
> > - rebased on mainline 3.4-rc2
> > - included missing importing support for s5p-fimc and s5p-tv
> > - added patch for changing map/unmap for importers
> > - fixes to Documentation part
> > - coding style fixes
> > - pairing {map/unmap}_dmabuf in vb2-core
> > - fixing variable types and semantic of arguments in videobufb2-dma-contig.c
> > 
> > v3:
> > - rebased on mainline 3.4-rc1
> > - split 'code refactor' patch to multiple smaller patches
> > - squashed fixes to Sumit's patches
> > - patchset is no longer dependant on 'DMA mapping redesign'
> > - separated path for handling IO and non-IO mappings
> > - add documentation for DMABUF importing to V4L
> > - removed all DMABUF exporter related code
> > - removed usage of dma_get_pages extension
> > 
> > v2:
> > - extended VIDIOC_EXPBUF argument from integer memoffset to struct
> >   v4l2_exportbuffer
> > - added patch that breaks DMABUF spec on (un)map_atachment callcacks but allows
> >   to work with existing implementation of DMABUF prime in DRM
> > - all dma-contig code refactoring patches were squashed
> > - bugfixes
> > 
> > v1: List of changes since [1].
> > - support for DMA api extension dma_get_pages, the function is used to retrieve
> >   pages used to create DMA mapping.
> > - small fixes/code cleanup to videobuf2
> > - added prepare and finish callbacks to vb2 allocators, it is used keep
> >   consistency between dma-cpu acess to the memory (by Marek Szyprowski)
> > - support for exporting of DMABUF buffer in V4L2 and Videobuf2, originated from
> >   [3].
> > - support for dma-buf exporting in vb2-dma-contig allocator
> > - support for DMABUF for s5p-tv and s5p-fimc (capture interface) drivers,
> >   originated from [3]
> > - changed handling for userptr buffers (by Marek Szyprowski, Andrzej
> >   Pietrasiewicz)
> > - let mmap method to use dma_mmap_writecombine call (by Marek Szyprowski)
> > 
> > [1] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/42966/focus=42968
> > [2] https://lkml.org/lkml/2011/12/26/29
> > [3] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/36354/focus=36355
> > [4] http://thread.gmane.org/gmane.linux.kernel.cross-arch/12819
> > [5] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/47983
> > 
> > Laurent Pinchart (2):
> >   v4l: vb2-dma-contig: Shorten vb2_dma_contig prefix to vb2_dc
> >   v4l: vb2-dma-contig: Reorder functions
> > 
> > Marek Szyprowski (2):
> >   v4l: vb2: add prepare/finish callbacks to allocators
> >   v4l: vb2-dma-contig: add prepare/finish to dma-contig allocator
> > 
> > Sumit Semwal (4):
> >   v4l: Add DMABUF as a memory type
> >   v4l: vb2: add support for shared buffer (dma_buf)
> >   v4l: vb: remove warnings about MEMORY_DMABUF
> >   v4l: vb2-dma-contig: add support for dma_buf importing
> > 
> > Tomasz Stanislawski (7):
> >   Documentation: media: description of DMABUF importing in V4L2
> >   v4l: vb2-dma-contig: remove reference of alloc_ctx from a buffer
> >   v4l: vb2-dma-contig: add support for scatterlist in userptr mode
> >   v4l: vb2-vmalloc: add support for dmabuf importing
> >   v4l: vivi: support for dmabuf importing
> >   v4l: s5p-tv: mixer: support for dmabuf importing
> >   v4l: s5p-fimc: support for dmabuf importing
> > 
> >  Documentation/DocBook/media/v4l/compat.xml         |    4 +
> >  Documentation/DocBook/media/v4l/io.xml             |  179 ++++++++
> >  .../DocBook/media/v4l/vidioc-create-bufs.xml       |    3 +-
> >  Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |   15 +
> >  Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |   47 +-
> >  drivers/media/video/Kconfig                        |    1 +
> >  drivers/media/video/s5p-fimc/Kconfig               |    1 +
> >  drivers/media/video/s5p-fimc/fimc-capture.c        |    2 +-
> >  drivers/media/video/s5p-tv/Kconfig                 |    1 +
> >  drivers/media/video/s5p-tv/mixer_video.c           |    2 +-
> >  drivers/media/video/v4l2-compat-ioctl32.c          |   16 +
> >  drivers/media/video/v4l2-ioctl.c                   |    1 +
> >  drivers/media/video/videobuf-core.c                |    4 +
> >  drivers/media/video/videobuf2-core.c               |  207 ++++++++-
> >  drivers/media/video/videobuf2-dma-contig.c         |  470 +++++++++++++++++---
> >  drivers/media/video/videobuf2-vmalloc.c            |   56 +++
> >  drivers/media/video/vivi.c                         |    2 +-
> >  include/linux/videodev2.h                          |    7 +
> >  include/media/videobuf2-core.h                     |   34 ++
> >  19 files changed, 963 insertions(+), 89 deletions(-)
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
