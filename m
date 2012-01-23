Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab2AWOh3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 09:37:29 -0500
Message-ID: <4F1D7099.4080009@redhat.com>
Date: Mon, 23 Jan 2012 12:37:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	sumit.semwal@ti.com, jesse.barker@linaro.org, rob@ti.com,
	daniel@ffwll.ch, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, pawel@osciak.com
Subject: Re: [PATCH 00/10] Integration of videobuf2 with dmabuf
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz/Sumit,

Em 23-01-2012 11:51, Tomasz Stanislawski escreveu:
> Hello everyone,
> This patchset is an incremental patch to patchset created by Sumit
> Semwal [1].  The patches are dedicated to help find a better solution for
> support of buffer sharing by V4L2 API.  It is expected to start discussion on
> final installment for dma-buf in vb2-dma-contig allocator.  Current version of
> the patches contain little documentation. It is going to be fixed after
> achieving consensus about design for buffer exporting.  Moreover the API
> between vb2-core and the allocator should be revised.

I just raised a few points for the discussions for a few patches. Please don't
understand them as a full review. It isn't.

Btw, it would be nice to have vivi support for the dmabuf sharing, in order to
allow the patches to be tested by a wider audience, especially due to the new
userspace API proposal.

Regards,
Mauro
> 
> The amount of changes to vb2-dma-contig.c was significant making the difference
> patch very difficult to read.  Therefore the patch was split into two parts.
> One removes old file, the next patch creates the version of the file.
> 
> The patchset contains extension for DMA API and its implementation for ARM
> architecture. Therefore the patchset should be applied on the top of:
> 
> http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/3.2-dma-v5
> 
> After applying patches from [2] and [1].
> 
> v1: List of changes since [1].
> - support for DMA api extension dma_get_pages, the function is used to retrieve pages
>  used to create DMA mapping.
> - small fixes/code cleanup to videobuf2
> - added prepare and finish callbacks to vb2 allocators, it is used keep consistency between dma-cpu acess to the memory (by Marek Szyprowski)
> - support for exporting of DMABUF buffer in V4L2 and Videobuf2, originated from [3].
> - support for dma-buf exporting in vb2-dma-contig allocator
> - support for DMABUF for s5p-tv and s5p-fimc (capture interface) drivers, originated from [3]
> - changed handling for userptr buffers (by Marek Szyprowski, Andrzej Pietrasiewicz)
> - let mmap method to use dma_mmap_writecombine call (by Marek Szyprowski)
> 
> [1] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/42966/focus=42968
> [2] https://lkml.org/lkml/2011/12/26/29
> [3] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/36354/focus=36355
> 
> 
> Marek Szyprowski (2):
>   [media] media: vb2: remove plane argument from call_memop and cleanup
>     mempriv usage
>   media: vb2: add prepare/finish callbacks to allocators
> 
> Tomasz Stanislawski (8):
>   arm: dma: support for dma_get_pages
>   v4l: vb2: fixes for DMABUF support
>   v4l: add buffer exporting via dmabuf
>   v4l: vb2: add buffer exporting via dmabuf
>   v4l: vb2: remove dma-contig allocator
>   v4l: vb2-dma-contig: code refactoring, support for DMABUF exporting
>   v4l: fimc: integrate capture i-face with dmabuf
>   v4l: s5p-tv: mixer: integrate with dmabuf
> 
>  arch/arm/include/asm/dma-mapping.h          |    8 +
>  arch/arm/mm/dma-mapping.c                   |   44 ++
>  drivers/media/video/s5p-fimc/fimc-capture.c |   11 +-
>  drivers/media/video/s5p-tv/mixer_video.c    |   11 +-
>  drivers/media/video/v4l2-compat-ioctl32.c   |    1 +
>  drivers/media/video/v4l2-ioctl.c            |   11 +
>  drivers/media/video/videobuf2-core.c        |  114 ++++-
>  drivers/media/video/videobuf2-dma-contig.c  |  754 +++++++++++++++++++++------
>  include/linux/dma-mapping.h                 |    2 +
>  include/linux/videodev2.h                   |    1 +
>  include/media/v4l2-ioctl.h                  |    1 +
>  include/media/videobuf2-core.h              |   10 +-
>  12 files changed, 789 insertions(+), 179 deletions(-)
> 

