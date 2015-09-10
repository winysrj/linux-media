Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35304 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbbIJLqW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2015 07:46:22 -0400
Date: Thu, 10 Sep 2015 08:46:16 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.3-rc1] media updates
Message-ID: <20150910084616.6fe26a80@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.3-2

For a series of patches that move part of the code used to allocate memory
from the media subsystem to the mm subsystem.

PS.: there are some conflicts with upstream. Two of them are really trivial
(just Kconfig/Makefile additions). The other one is more complex, and
involves some code that are been moved to mm. 

As you told in the past that you generally prefers to see the conflicts,
I'm keeping it. However, if you prefer, I can solve it locally and send you
another pull request with the conflict fixed. Whatever works best for you.

Thanks and regards,
Mauro

The following changes since commit 27c039750c8ff1297632e424a4674732cc4c3c70:

  [media] sr030pc30: don't read a new pointer (2015-08-16 12:58:31 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.3-2

for you to fetch changes up to 63540f01917c0d8b03b9813a0d6539469b163139:

  [media] drm/exynos: Convert g2d_userptr_get_dma_addr() to use get_vaddr_frames() (2015-08-16 13:15:58 -0300)

----------------------------------------------------------------
media updates for v4.3-rc1

----------------------------------------------------------------
Jan Kara (9):
      [media] vb2: Push mmap_sem down to memops
      [media] mm: Provide new get_vaddr_frames() helper
      [media] media: omap_vout: Convert omap_vout_uservirt_to_phys() to use get_vaddr_pfns()
      [media] vb2: Provide helpers for mapping virtual addresses
      [media] media: vb2: Convert vb2_dma_sg_get_userptr() to use frame vector
      [media] media: vb2: Convert vb2_vmalloc_get_userptr() to use frame vector
      [media] media: vb2: Convert vb2_dc_get_userptr() to use frame vector
      [media] media: vb2: Remove unused functions
      [media] drm/exynos: Convert g2d_userptr_get_dma_addr() to use get_vaddr_frames()

 drivers/gpu/drm/exynos/Kconfig                 |   1 +
 drivers/gpu/drm/exynos/exynos_drm_g2d.c        |  89 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.c        |  97 -
 drivers/media/platform/omap/Kconfig            |   1 +
 drivers/media/platform/omap/omap_vout.c        |  69 +-
 drivers/media/v4l2-core/Kconfig                |   1 +
 drivers/media/v4l2-core/videobuf2-core.c       |   2 -
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 207 +-
 drivers/media/v4l2-core/videobuf2-dma-sg.c     |  91 +-
 drivers/media/v4l2-core/videobuf2-memops.c     | 148 +-
 drivers/media/v4l2-core/videobuf2-vmalloc.c    |  90 +-
 include/linux/mm.h                             |  44 +
 include/media/videobuf2-memops.h               |  11 +-
 mm/Kconfig                                     |   3 +
 mm/Makefile                                    |   1 +
 mm/frame_vector.c                              | 230 ++
 16 files changed, 477 insertions(+), 608 deletions(-)
 create mode 100644 mm/frame_vector.c

