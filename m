Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39223 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab1CDJB3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 04:01:29 -0500
Date: Fri, 04 Mar 2011 10:01:07 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH/RFC 0/7] Samsung IOMMU videobuf2 allocator and s5p-fimc update
To: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, andrzej.p@samsung.com,
	t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Message-id: <1299229274-9753-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

This patch series introduces new type of videbuf2 memory allocator -
vb2-s5p-iommu. This allocator can be used only on Samsung SoCs that have
IOMMU module. Currently only Samsung EXYNOS4 (former S5PV310) platform
has SYSMMU modules. The allocator is then used by s5p-fimc driver. To
make it possible some additional changes are required. Mainly platform
support for s5p-fimc for EXYNOS4 machines need to be defined. The
proposed solution has been tested on Universal C210 board (Samsung
S5PC210/EXYNOS4 based).

We decided to use driver private address space mode of the iommu driver.
This way each vb2-s5p-iommu client gets it's own address space for
memory buffers. This reduces kernel virtual memory fragmentation as well
as solves some non-trivial page table updates issues. The drawback is
the fact that the interface for s5p-sysmmu has been changed.

This IOMMU allocator has no dependences on other subsystems besides
Samsung platfrom core. We also ported s5p-mfc and s5p-tv drivers to this
allocator, they will be posted in separate patch series. This will
enable to get them working on EXYNOS4 (S5PV310) platform. Support for
S5PV210/S5PC110 platform still depends on CMA allocator that needs more
discussion on memory management mailing list and development. The
patches with updated s5p-mfc and s5p-tv drivers will follow.

To get FIMC module working on EXYNOS4/UniversalC210 board we also added
support for power domains and power gating.

This patch series contains a collection of patches for various platform
subsystems. Here is a detailed list:

[PATCH 1/7] ARM: S5PV310: Add platform definitions for FIMC
- adds basic platform resources for FIMC modules (for s5p-fimc driver)

[PATCH 2/7] ARM: S5PV310: power domains: fixes and code cleanup
- adds support for block gating in Samsung power domain driver and
  performs some cleanup

[PATCH 3/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU) driver
- a complete rewrite of sysmmu driver for Samsung platform:
- the new version introduces device private page tables (address space)
  mode
- simplified the resource management (no more horrible single platform
  device with 32 resources is needed)
- some other API chages required by upcoming videobuf2 allocator

[PATCH 4/7] v4l: videobuf2: add Samsung SYSMMU (IOMMU) based allocator
- introduces new memory allocator for videobuf2, it uses s5p-sysmmu
  iommu driver, memory for video buffers is acuired by alloc_page() kernel
  function

[PATCH 5/7] s5p-fimc: add pm_runtime support
- adds support for pm_runtime in s5p-fimc driver

[PATCH 6/7] s5p-fimc: Add support for vb2-s5p-iommu allocator
- adds support for the newly introduces videbuf2-s5p-iommu allocator
  on EXYNOS4 platform

[PATCH 7/7] ARM: S5PC210: enable FIMC on Universal_C210
- adds all required machine definitions to get FIMC modules working
  on Universal C210 boards


The patch series is based on git://linuxtv.org/media_tree.git tree,
staging/for_v2.6.39 branch with the following Samsung platform patches:
1. [PATCH] ARM: Samsung: change suspend/resume code to depend on CONFIG_SUSPEND
http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg04025.html
2. [PATCH v2] ARM: S5PC210: add support for i2c PMICs on Universal_C210 board
http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg04029.html

This series has not been rebased onto the latest changes (S5PV310
renamed to EXYNOS4) in
git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git,
for-next branch. We will rebase them soon, but first we want to get
feedback and comments on the s5p-iommu videobuf2 allocator idea.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


Complete patch summary:

Andrzej Pietrasiewicz (2):
  ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU) driver
  v4l: videobuf2: add Samsung SYSMMU (IOMMU) based allocator

Marek Szyprowski (3):
  s5p-fimc: add pm_runtime support
  s5p-fimc: Add support for vb2-s5p-iommu allocator
  ARM: S5PC210: enable FIMC on Universal_C210

Sylwester Nawrocki (1):
  ARM: S5PV310: Add platform definitions for FIMC

Tomasz Stanislawski (1):
  ARM: S5PV310: power domains: fixes and code cleanup

 arch/arm/mach-s5pv310/Kconfig                    |    6 +
 arch/arm/mach-s5pv310/clock.c                    |   91 ++
 arch/arm/mach-s5pv310/cpu.c                      |    7 +
 arch/arm/mach-s5pv310/dev-pd.c                   |   93 ++-
 arch/arm/mach-s5pv310/dev-sysmmu.c               |  582 +++++++++----
 arch/arm/mach-s5pv310/include/mach/irqs.h        |   40 +-
 arch/arm/mach-s5pv310/include/mach/map.h         |    8 +
 arch/arm/mach-s5pv310/include/mach/regs-clock.h  |   12 +
 arch/arm/mach-s5pv310/include/mach/regs-sysmmu.h |   23 +-
 arch/arm/mach-s5pv310/include/mach/sysmmu.h      |  122 ---
 arch/arm/mach-s5pv310/mach-universal_c210.c      |   20 +
 arch/arm/plat-s5p/Kconfig                        |   22 +-
 arch/arm/plat-s5p/Makefile                       |    1 +
 arch/arm/plat-s5p/dev-fimc3.c                    |   43 +
 arch/arm/plat-s5p/include/plat/sysmmu.h          |  127 +++
 arch/arm/plat-s5p/sysmmu.c                       |  988 +++++++++++++++-------
 arch/arm/plat-samsung/include/plat/devs.h        |    3 +-
 arch/arm/plat-samsung/include/plat/fimc-core.h   |    5 +
 arch/arm/plat-samsung/include/plat/pd.h          |    1 +
 drivers/media/video/Kconfig                      |   11 +-
 drivers/media/video/Makefile                     |    1 +
 drivers/media/video/s5p-fimc/fimc-capture.c      |    9 +-
 drivers/media/video/s5p-fimc/fimc-core.c         |   36 +-
 drivers/media/video/s5p-fimc/fimc-mem.h          |   87 ++
 drivers/media/video/videobuf2-s5p-iommu.c        |  444 ++++++++++
 include/media/videobuf2-s5p-iommu.h              |   50 ++
 26 files changed, 2129 insertions(+), 703 deletions(-)
 rewrite arch/arm/mach-s5pv310/dev-sysmmu.c (86%)
 delete mode 100644 arch/arm/mach-s5pv310/include/mach/sysmmu.h
 create mode 100644 arch/arm/plat-s5p/dev-fimc3.c
 create mode 100644 arch/arm/plat-s5p/include/plat/sysmmu.h
 rewrite arch/arm/plat-s5p/sysmmu.c (85%)
 create mode 100644 drivers/media/video/s5p-fimc/fimc-mem.h
 create mode 100644 drivers/media/video/videobuf2-s5p-iommu.c
 create mode 100644 include/media/videobuf2-s5p-iommu.h

-- 
1.7.1.569.g6f426
