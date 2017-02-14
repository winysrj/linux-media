Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39761 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751490AbdBNHwT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 02:52:19 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCH 00/15] Exynos MFC v6+ - remove the need for the reserved memory
Date: Tue, 14 Feb 2017 08:51:53 +0100
Message-id: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
References: <CGME20170214075214eucas1p1574c18c0fa166cdda50838b9fb8cc23b@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear All,

This patchset is a result of my work on enabling full support for MFC device
(multimedia codec) on Exynos 5433 on ARM64 architecture. Initially I thought
that to let it working on ARM64 architecture with IOMMU, I would need to
solve the issue related to the fact that s5p-mfc driver was depending on the
first-fit allocation method in the DMA-mapping / IOMMU glue code (ARM64 use
different algorithm). It turned out, that there is a much simpler way.

During my research I found that some of the requirements for the memory
buffers for MFC v6+ devices were blindly copied from the previous
hardware (v5) version and simply turned out to be excessive. It turned out
that there is no strict requirement for ALL buffers to be allocated on
the higher addresses than the firmware base. This requirement is true only
for the device and per-context buffers. All video data buffers can be
allocated anywhere for all MFC v6+ versions. This heavily simplifies
memory management in the driver.

Such relaxed requirements for the memory buffers can be easily fulfilled
by allocating firmware, device and per-context buffers from the probe-time
preallocated larger buffer. There is no need to create special reserved
memory regions. The only case, when those memory regions are needed is an
oldest Exynos series - Exynos4210 or Exyno4412, which both have MFC v5
hardware, and only when IOMMU is disabled.

This patchset has been tested on Odroid U3 (Exynos4412 with MFC v5), Google
Snow (Exynos5250 with MFC v6), Odroid XU3 (Exynos5422 with MFC v8) and
TM2 (Exynos5433 with MFC v8, ARM64) boards.

To get it working on TM2/Exynos5433 with IOMMU enabled, the 'architectural
clock gating' in SYSMMU has to be disabled. Fixing this will be handled
separately. As a temporary solution, one need to clear CFG_ACGEN bit in
REG_MMU_CFG of the SYSMMU, see __sysmmu_init_config function in
drivers/iommu/exynos-iommu.c.

Patches are based on linux-next from 9th February 2017 with "media:
s5p-mfc: Fix initialization of internal structures" patch applied:
https://patchwork.linuxtv.org/patch/39198/

I've tried to split changes into small pieces to make it easier to review
the code. I've also did a bit of cleanup while touching the driver.

Best regards
Marek Szyprowski
Samsung R&D Institute Poland


Patch summary:

Marek Szyprowski (15):
  media: s5p-mfc: Remove unused structures and dead code
  media: s5p-mfc: Use generic of_device_get_match_data helper
  media: s5p-mfc: Replace mem_dev_* entries with an array
  media: s5p-mfc: Replace bank1/bank2 entries with an array
  media: s5p-mfc: Simplify alloc/release private buffer functions
  media: s5p-mfc: Move setting DMA max segmetn size to DMA configure
    function
  media: s5p-mfc: Put firmware to private buffer structure
  media: s5p-mfc: Move firmware allocation to DMA configure function
  media: s5p-mfc: Allocate firmware with internal private buffer alloc
    function
  media: s5p-mfc: Reduce firmware buffer size for MFC v6+ variants
  media: s5p-mfc: Split variant DMA memory configuration into separate
    functions
  media: s5p-mfc: Add support for probe-time preallocated block based
    allocator
  media: s5p-mfc: Remove special configuration of IOMMU domain
  media: s5p-mfc: Use preallocated block allocator always for MFC v6+
  ARM: dts: exynos: Remove MFC reserved buffers

 .../devicetree/bindings/media/s5p-mfc.txt          |   2 +-
 arch/arm/boot/dts/exynos5250-arndale.dts           |   1 -
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |   1 -
 arch/arm/boot/dts/exynos5250-spring.dts            |   1 -
 arch/arm/boot/dts/exynos5420-arndale-octa.dts      |   1 -
 arch/arm/boot/dts/exynos5420-peach-pit.dts         |   1 -
 arch/arm/boot/dts/exynos5420-smdk5420.dts          |   1 -
 arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi |   1 -
 arch/arm/boot/dts/exynos5800-peach-pi.dts          |   1 -
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h       |   2 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v7.h       |   2 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v8.h       |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           | 210 +++++++++++++--------
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c    |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |  43 ++---
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |  71 +++----
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h      |   1 -
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   8 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  10 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_iommu.h     |  51 +----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c       |  65 +++++--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h       |   8 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |  48 ++---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |  14 +-
 24 files changed, 264 insertions(+), 283 deletions(-)

-- 
1.9.1
