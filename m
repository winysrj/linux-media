Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:42552 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751697AbbFKJJb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 05:09:31 -0400
Message-ID: <5579501F.6080000@xs4all.nl>
Date: Thu, 11 Jun 2015 11:08:47 +0200
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

Hi Andrew,

I discovered a regression on a prerequisite patch merged in the media
tree that until solved prevents parts of this patch series from going in.

See: http://www.mail-archive.com/linux-media@vger.kernel.org/msg89538.html

Jan is on vacation, and I don't know if I have time this weekend to dig
into this, so the patch that caused the regression may have to be reverted
for 4.2 and the vb2 patches in this series postponed until the regression
problem is fixed.

Note that this is all v4l/vb2 related, the get_vaddr_frames helper is actually
fine and could be merged, it's just the vb2 patches in this patch series that
cannot be merged for now due to deadlocks.

Regards,

	Hans

On 06/10/15 11:20, Mauro Carvalho Chehab wrote:
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
