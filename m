Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:35370 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbbFOHlg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 03:41:36 -0400
Message-ID: <557E819D.401@xs4all.nl>
Date: Mon, 15 Jun 2015 09:41:17 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/9] Helper to abstract vma handling in media layer
References: <cover.1433927458.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433927458.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/10/2015 11:20 AM, Mauro Carvalho Chehab wrote:
> Hi Andrew,
> 
> I received this patch series with a new set of helper functions for
> mm, together with changes for media and DRM drivers.
> 
> As this stuff is actually mm code, I prefer if this got merged via
> your tree.
> 
> Could you please handle it? Please notice that patch 8 actually changes
> the exynos DRM driver, but it misses ack from DRM people.

For the vb2 patches 3-7:

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

Since the prerequisite patch "vb2: Push mmap_sem down to memops" caused
two regressions I want to postpone these other vb2 patches until that problem
is fixed first.

Jan, I leave it to you whether you want the non-vb2 patches to go in or not.
I don't think they are affected by this vb2 problem.

Regards,

	Hans

> 
> Regards,
> Mauro
> 
> Jan Kara (9):
>   mm: Provide new get_vaddr_frames() helper
>   [media] media: omap_vout: Convert omap_vout_uservirt_to_phys() to use
>     get_vaddr_pfns()
>   [media] vb2: Provide helpers for mapping virtual addresses
>   [media] media: vb2: Convert vb2_dma_sg_get_userptr() to use frame
>     vector
>   [media] media: vb2: Convert vb2_vmalloc_get_userptr() to use frame
>     vector
>   [media] media: vb2: Convert vb2_dc_get_userptr() to use frame vector
>   [media] media: vb2: Remove unused functions
>   [media] drm/exynos: Convert g2d_userptr_get_dma_addr() to use
>     get_vaddr_frames()
>   [media] mm: Move get_vaddr_frames() behind a config option
> 
>  drivers/gpu/drm/exynos/Kconfig                 |   1 +
>  drivers/gpu/drm/exynos/exynos_drm_g2d.c        |  95 ++++------
>  drivers/gpu/drm/exynos/exynos_drm_gem.c        |  97 -----------
>  drivers/media/platform/omap/Kconfig            |   1 +
>  drivers/media/platform/omap/omap_vout.c        |  69 ++++----
>  drivers/media/v4l2-core/Kconfig                |   1 +
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 214 ++++-------------------
>  drivers/media/v4l2-core/videobuf2-dma-sg.c     |  99 ++---------
>  drivers/media/v4l2-core/videobuf2-memops.c     | 156 ++++++-----------
>  drivers/media/v4l2-core/videobuf2-vmalloc.c    |  92 ++++------
>  include/linux/mm.h                             |  44 +++++
>  include/media/videobuf2-memops.h               |  11 +-
>  mm/Kconfig                                     |   3 +
>  mm/Makefile                                    |   1 +
>  mm/frame_vector.c                              | 232 +++++++++++++++++++++++++
>  mm/gup.c                                       |   1 +
>  16 files changed, 486 insertions(+), 631 deletions(-)
>  create mode 100644 mm/frame_vector.c
> 

