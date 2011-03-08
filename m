Return-path: <mchehab@pedra>
Received: from mailout3.samsung.com ([203.254.224.33]:55729 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab1CHHiZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2011 02:38:25 -0500
Date: Tue, 08 Mar 2011 16:28:34 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH/RFC 0/7] Samsung IOMMU videobuf2 allocator and s5p-fimc
 update
In-reply-to: <1299229274-9753-1-git-send-email-m.szyprowski@samsung.com>
To: 'Marek Szyprowski' <m.szyprowski@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, andrzej.p@samsung.com,
	t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	k.debski@samsung.com,
	=?ks_c_5601-1987?B?wMzAz8ijL1MvVyBTb2x1dGlvbrCzud/GwChTLkxTSSkvRQ==?=
	 =?ks_c_5601-1987?B?NSjDpcDTKS+777y6wPzA2g==?=
	<ilho215.lee@samsung.com>,
	=?ks_c_5601-1987?B?wbaw5sijL1MvVyBTb2x1dGlvbrCzud/GwChTLkxTSSkvRQ==?=
	 =?ks_c_5601-1987?B?NCi8scDTKS+777y6wPzA2g==?=
	<pullip.cho@samsung.com>
Message-id: <03ab01cbdd62$739550d0$5abff270$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-language: ko
Content-transfer-encoding: 7BIT
References: <1299229274-9753-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

There are comments for your System MMU driver below.

It's good that System MMU has functionality of mapping but System MMU have
to use other mapping of virtual memory allocator.

And would be better to change sysmmu_list to use array of defined in
s5p_sysmmu_ip enumeration, so that can get enhancement of memory space
usage, speed, and readability of codes.

TLB replacement policy does not need to use LRU. Of course, current System
MMU also needs it. I think, the round robin is enough, because to access
memory has no temporal locality and to make LRU need to access to System
MMU register one more. The reset value is round robin.

In the setting of SHARED page table in s5p_sysmmu_control_locked, get the
page table base address of ARM core from cp15 register now. But current->mm-
>pgd is better for more compatibility.

When it make page table with PRIVATE page table methods, the size of the
structure to manage the second page table is quite big. It is much better
rather that to make slab with cache size of 1KB.
Besides, the page mapping implementation is not safe in your System MMU
driver. Because only first one confirms primary page table entry, when it
assigns four second page tables consecutively at a time.

The System MMU driver cannot apply runtime pm by oneself with calling
pm_runtime_put_sync(). The reason is because a device with System MMU can
on/off power. I think just clock gating is enough. However, I can't find
clock enable/disable in your driver.

By PRIVATE page table method, each system MMU comes to have a page table
only for oneself. In this case, the problem is that each MFC System MMU L
and R having another page table.

In your System MMU driver, the page size is always 4KB crucially. This says
TLB thrashing and produces a result to lose a TLB hit rate. It is a big
problem with the device such as rotator which does not do sequential access
especially.

And the IRQ handler just outputs only a message. It should be implemented
in call back function to be able to handle from each device driver.

When it sets System MMU in SHARED page table, kernel virtual memory is
broken by a method such as s5p_sysmmu_map_area() :(

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.


Marek Szyprowski wrote:
> 
> Hello,
> 
> This patch series introduces new type of videbuf2 memory allocator -
> vb2-s5p-iommu. This allocator can be used only on Samsung SoCs that have
> IOMMU module. Currently only Samsung EXYNOS4 (former S5PV310) platform
> has SYSMMU modules. The allocator is then used by s5p-fimc driver. To
> make it possible some additional changes are required. Mainly platform
> support for s5p-fimc for EXYNOS4 machines need to be defined. The
> proposed solution has been tested on Universal C210 board (Samsung
> S5PC210/EXYNOS4 based).
> 
> We decided to use driver private address space mode of the iommu driver.
> This way each vb2-s5p-iommu client gets it's own address space for
> memory buffers. This reduces kernel virtual memory fragmentation as well
> as solves some non-trivial page table updates issues. The drawback is
> the fact that the interface for s5p-sysmmu has been changed.
> 
> This IOMMU allocator has no dependences on other subsystems besides
> Samsung platfrom core. We also ported s5p-mfc and s5p-tv drivers to this
> allocator, they will be posted in separate patch series. This will
> enable to get them working on EXYNOS4 (S5PV310) platform. Support for
> S5PV210/S5PC110 platform still depends on CMA allocator that needs more
> discussion on memory management mailing list and development. The
> patches with updated s5p-mfc and s5p-tv drivers will follow.
> 
> To get FIMC module working on EXYNOS4/UniversalC210 board we also added
> support for power domains and power gating.
> 
> This patch series contains a collection of patches for various platform
> subsystems. Here is a detailed list:
> 
> [PATCH 1/7] ARM: S5PV310: Add platform definitions for FIMC
> - adds basic platform resources for FIMC modules (for s5p-fimc driver)
> 
> [PATCH 2/7] ARM: S5PV310: power domains: fixes and code cleanup
> - adds support for block gating in Samsung power domain driver and
>   performs some cleanup
> 
> [PATCH 3/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU) driver
> - a complete rewrite of sysmmu driver for Samsung platform:
> - the new version introduces device private page tables (address space)
>   mode
> - simplified the resource management (no more horrible single platform
>   device with 32 resources is needed)
> - some other API chages required by upcoming videobuf2 allocator
> 
> [PATCH 4/7] v4l: videobuf2: add Samsung SYSMMU (IOMMU) based allocator
> - introduces new memory allocator for videobuf2, it uses s5p-sysmmu
>   iommu driver, memory for video buffers is acuired by alloc_page() kernel
>   function
> 
> [PATCH 5/7] s5p-fimc: add pm_runtime support
> - adds support for pm_runtime in s5p-fimc driver
> 
> [PATCH 6/7] s5p-fimc: Add support for vb2-s5p-iommu allocator
> - adds support for the newly introduces videbuf2-s5p-iommu allocator
>   on EXYNOS4 platform
> 
> [PATCH 7/7] ARM: S5PC210: enable FIMC on Universal_C210
> - adds all required machine definitions to get FIMC modules working
>   on Universal C210 boards
> 
> 
> The patch series is based on git://linuxtv.org/media_tree.git tree,
> staging/for_v2.6.39 branch with the following Samsung platform patches:
> 1. [PATCH] ARM: Samsung: change suspend/resume code to depend on
> CONFIG_SUSPEND
> http://www.mail-archive.com/linux-samsung-
soc@vger.kernel.org/msg04025.html
> 2. [PATCH v2] ARM: S5PC210: add support for i2c PMICs on Universal_C210
board
> http://www.mail-archive.com/linux-samsung-
soc@vger.kernel.org/msg04029.html
> 
> This series has not been rebased onto the latest changes (S5PV310
> renamed to EXYNOS4) in
> git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git,
> for-next branch. We will rebase them soon, but first we want to get
> feedback and comments on the s5p-iommu videobuf2 allocator idea.
> 
> Best regards
> --
> Marek Szyprowski
> Samsung Poland R&D Center
> 
> 
> Complete patch summary:
> 
> Andrzej Pietrasiewicz (2):
>   ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU) driver
>   v4l: videobuf2: add Samsung SYSMMU (IOMMU) based allocator
> 
> Marek Szyprowski (3):
>   s5p-fimc: add pm_runtime support
>   s5p-fimc: Add support for vb2-s5p-iommu allocator
>   ARM: S5PC210: enable FIMC on Universal_C210
> 
> Sylwester Nawrocki (1):
>   ARM: S5PV310: Add platform definitions for FIMC
> 
> Tomasz Stanislawski (1):
>   ARM: S5PV310: power domains: fixes and code cleanup
> 
>  arch/arm/mach-s5pv310/Kconfig                    |    6 +
>  arch/arm/mach-s5pv310/clock.c                    |   91 ++
>  arch/arm/mach-s5pv310/cpu.c                      |    7 +
>  arch/arm/mach-s5pv310/dev-pd.c                   |   93 ++-
>  arch/arm/mach-s5pv310/dev-sysmmu.c               |  582 +++++++++----
>  arch/arm/mach-s5pv310/include/mach/irqs.h        |   40 +-
>  arch/arm/mach-s5pv310/include/mach/map.h         |    8 +
>  arch/arm/mach-s5pv310/include/mach/regs-clock.h  |   12 +
>  arch/arm/mach-s5pv310/include/mach/regs-sysmmu.h |   23 +-
>  arch/arm/mach-s5pv310/include/mach/sysmmu.h      |  122 ---
>  arch/arm/mach-s5pv310/mach-universal_c210.c      |   20 +
>  arch/arm/plat-s5p/Kconfig                        |   22 +-
>  arch/arm/plat-s5p/Makefile                       |    1 +
>  arch/arm/plat-s5p/dev-fimc3.c                    |   43 +
>  arch/arm/plat-s5p/include/plat/sysmmu.h          |  127 +++
>  arch/arm/plat-s5p/sysmmu.c                       |  988 +++++++++++++++--
---
> --
>  arch/arm/plat-samsung/include/plat/devs.h        |    3 +-
>  arch/arm/plat-samsung/include/plat/fimc-core.h   |    5 +
>  arch/arm/plat-samsung/include/plat/pd.h          |    1 +
>  drivers/media/video/Kconfig                      |   11 +-
>  drivers/media/video/Makefile                     |    1 +
>  drivers/media/video/s5p-fimc/fimc-capture.c      |    9 +-
>  drivers/media/video/s5p-fimc/fimc-core.c         |   36 +-
>  drivers/media/video/s5p-fimc/fimc-mem.h          |   87 ++
>  drivers/media/video/videobuf2-s5p-iommu.c        |  444 ++++++++++
>  include/media/videobuf2-s5p-iommu.h              |   50 ++
>  26 files changed, 2129 insertions(+), 703 deletions(-)
>  rewrite arch/arm/mach-s5pv310/dev-sysmmu.c (86%)
>  delete mode 100644 arch/arm/mach-s5pv310/include/mach/sysmmu.h
>  create mode 100644 arch/arm/plat-s5p/dev-fimc3.c
>  create mode 100644 arch/arm/plat-s5p/include/plat/sysmmu.h
>  rewrite arch/arm/plat-s5p/sysmmu.c (85%)
>  create mode 100644 drivers/media/video/s5p-fimc/fimc-mem.h
>  create mode 100644 drivers/media/video/videobuf2-s5p-iommu.c
>  create mode 100644 include/media/videobuf2-s5p-iommu.h
> 
> --
> 1.7.1.569.g6f426

