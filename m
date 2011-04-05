Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:23213 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab1DEOJB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 10:09:01 -0400
Date: Tue, 05 Apr 2011 16:06:43 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [RFC/PATCH v2 0/7] Samsung IOMMU videobuf2 allocator and s5p-fimc
	update
To: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Pietrasiwiecz <andrzej.p@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Kukjin Kim <kgene.kim@samsung.com>
Message-id: <1302012410-17984-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

This is a second version of the Samsung IOMMU driver, videobuf2
allocator for IOMMU mapped memory and FIMC driver update. The main
change from the previous version is a complete rewrite of the IOMMU
driver API. As suggested by Arnd Bergmann we decided to drop the custom
interface and use the kernel wide, common iommu API defined in
linux/include/iommu.h. This way the videobuf2 iommu allocator become
much more generic framework, because it is no longer tied to any
particular iommu implementation.

This patch series introduces new type of videbuf2 memory allocator -
vb2-dma-iommu. This allocator can be used on the platforms that support
linux/include/iommu.h style IOMMU driver. An IOMMU driver for Samsung
EXYNOS4 (called SYSMMU) platform is also included. The allocator and
IOMMU driver is then used by s5p-fimc driver. To make it possible some
additional changes are required. Mainly the platform support for s5p-fimc
for EXYNOS4 machines need to be defined. The proposed solution has been
tested on Universal C210 board (Samsung S5PC210/EXYNOS4 based).
This IOMMU allocator has no dependences on any external subsystems.

We also ported s5p-mfc and s5p-tv drivers to this allocator, they will
be posted in separate patch series. This will enable to get them working
on mainline Linux kernel for EXYNOS4 platform. Support for
S5PV210/S5PC110 platform still depends on CMA allocator that needs more
discussion on memory management mailing list and further development.
The patches with updated s5p-mfc and s5p-tv drivers will follow.

To get FIMC module working on EXYNOS4 platform on UniversalC210 board we
also added support for power domains and power gating.

This patch series contains a collection of patches for various platform
subsystems. Here is a detailed list:

[PATCH 1/7] ARM: EXYNOS4: power domains: fixes and code cleanup
- adds support for block gating in Samsung power domain driver and
  performs some cleanup

[PATCH 2/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU) driver
- a complete rewrite of sysmmu driver for Samsung platform, now uses
  linux/include/iommu.h api

[PATCH 3/7] v4l: videobuf2: dma-sg: move some generic functions to memops
- a little cleanup and preparations for the dma-iommu allocator

[PATCH 4/7] v4l: videobuf2: add IOMMU based DMA memory allocator
- introduces new memory allocator for videobuf2 for drivers that support
  iommu dma memory mappings

[PATCH 5/7] v4l: s5p-fimc: add pm_runtime support
- adds support for pm_runtime in s5p-fimc driver

[PATCH 6/7] v4l: s5p-fimc: Add support for vb2-dma-iommu allocator
- adds support for the newly introduces videbuf2-s5p-iommu allocator
  on EXYNOS4 platform

[PATCH 7/7] ARM: EXYNOS4: enable FIMC on Universal_C210
- adds all required machine definitions to get FIMC modules working
  on Universal C210 boards


Changelog:

V2:
 - custom SYSMMU interface has been dropped in favour of linux/include/iommu.h
   and rewritten SYSMMU driver again
 - added support to SYSMMU for mapping pages larger than 4Kb
 - dropped ARM shared mode
 - videobuf2-s5p-iommu allocator has been renamed to videobuf2-dma-iommu,
   because it has no dependenco on any Samsung platform specific API,
   the allocator still uses only 4Kb pages, but this will be changed in the
   next version
 - dropped FIMC platform patch that have been merged mainline
 - rebased all patches onto Linux kernel v2.6.39-rc1

V1: http://www.spinics.net/lists/linux-media/msg29751.html

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



Complete patch summary:

Andrzej Pietrasiewicz (3):
  ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU) driver
  v4l: videobuf2: dma-sg: move some generic functions to memops
  v4l: videobuf2: add IOMMU based DMA memory allocator

Marek Szyprowski (3):
  v4l: s5p-fimc: add pm_runtime support
  v4l: s5p-fimc: Add support for vb2-dma-iommu allocator
  ARM: EXYNOS4: enable FIMC on Universal_C210

Tomasz Stanislawski (1):
  ARM: EXYNOS4: power domains: fixes and code cleanup

 arch/arm/mach-exynos4/Kconfig                   |    6 +
 arch/arm/mach-exynos4/clock.c                   |   68 +-
 arch/arm/mach-exynos4/dev-pd.c                  |   93 ++-
 arch/arm/mach-exynos4/dev-sysmmu.c              |  615 ++++++++-----
 arch/arm/mach-exynos4/include/mach/irqs.h       |   35 +-
 arch/arm/mach-exynos4/include/mach/regs-clock.h |    7 +
 arch/arm/mach-exynos4/include/mach/sysmmu.h     |   46 -
 arch/arm/mach-exynos4/mach-universal_c210.c     |   22 +
 arch/arm/plat-s5p/Kconfig                       |   20 +-
 arch/arm/plat-s5p/include/plat/sysmmu.h         |  165 ++--
 arch/arm/plat-s5p/sysmmu.c                      | 1103 ++++++++++++++++-------
 arch/arm/plat-samsung/include/plat/devs.h       |    2 +-
 arch/arm/plat-samsung/include/plat/pd.h         |    1 +
 drivers/media/video/Kconfig                     |   11 +-
 drivers/media/video/Makefile                    |    1 +
 drivers/media/video/s5p-fimc/fimc-capture.c     |    9 +-
 drivers/media/video/s5p-fimc/fimc-core.c        |   38 +-
 drivers/media/video/s5p-fimc/fimc-core.h        |    1 +
 drivers/media/video/s5p-fimc/fimc-mem.h         |  103 +++
 drivers/media/video/videobuf2-dma-iommu.c       |  469 ++++++++++
 drivers/media/video/videobuf2-dma-sg.c          |   37 +-
 drivers/media/video/videobuf2-memops.c          |   76 ++
 include/media/videobuf2-dma-iommu.h             |   48 +
 include/media/videobuf2-memops.h                |    5 +
 24 files changed, 2180 insertions(+), 801 deletions(-)
 rewrite arch/arm/mach-exynos4/dev-sysmmu.c (88%)
 delete mode 100644 arch/arm/mach-exynos4/include/mach/sysmmu.h
 rewrite arch/arm/plat-s5p/include/plat/sysmmu.h (83%)
 rewrite arch/arm/plat-s5p/sysmmu.c (87%)
 create mode 100644 drivers/media/video/s5p-fimc/fimc-mem.h
 create mode 100644 drivers/media/video/videobuf2-dma-iommu.c
 create mode 100644 include/media/videobuf2-dma-iommu.h

-- 
1.7.1.569.g6f426
