Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:47906 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226AbcEXNbu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 09:31:50 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Uli Middelberg <uli@middelberg.de>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v4 0/7] Exynos: MFC driver: reserved memory cleanup and IOMMU
 support
Date: Tue, 24 May 2016 15:31:23 +0200
Message-id: <1464096690-23605-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This is another version of the patchset, which performs cleanup of
custom code for reserved memory handling in s5p-mfc codec driver. The
first part is removal of custom, driver specific code for intializing
and handling of reserved memory. Instead, a generic code for reserved
memory regions is used. Then, the driver is extended with IOMMU support.
The additional code is needed because of specific requirements of MFC
device firmware (see patch 3 for more details). When no IOMMU is
available, the code fallbacks to use generic reserved memory regions.

After applying this patchset, MFC device works correctly either when
IOMMU is either enabled or disabled (assuming that board provides
required reserved memory regions).

Patches have been tested on top of linux-next from 20160524 with some
additional patches:
- "[PATCH 0/3] [media] s5p-mfc: Fixes for issues when module is removed":
  https://lkml.org/lkml/2016/5/3/782
- "[PATCH v5 0/2] vb2-dma-contig: configure DMA max segment size properly":
  https://www.mail-archive.com/linux-media@vger.kernel.org/msg97625.html

I've prepared a git branch with all needed patches:
https://git.linaro.org/people/marek.szyprowski/linux-srpol.git v4.6-next20160524-mfc

I would prefer to merge patches 1-4 via media tree and patches 5-7 via
Samsung SoC tree (there are no compile-time dependencies between those
two sets). Patches have been tested on Odroid U3 (Exynos 4412 based) and
Odroid XU3 (Exynos 5422 based) boards.

Best regards
Marek Szyprowski
Samsung R&D Institute Poland


Changelog:
v4:
- moved videobuf2-dma-contig/dma max segment size patches to separate thread:
  https://www.mail-archive.com/linux-media@vger.kernel.org/msg97625.html
- removed 'named' support for reserved memory regions, now regions are selected
 by index (requested by Rob Herring in v3)
- splitted 'ARM: Exynos: convert MFC device to generic reserved memory bindings'
  patch into 3 separate changes (bindings, dts, code removal), rewrote commit
  messages to better describe the changes
- rebased onto latest linux-next kernel tree

v3: http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/97316
- fixed issues pointed by Laurent Pinchart:
  - added documentation to memory-region-names property,
  - changed devm_kzalloc to kzalloc in vb2_dma_contig_set_max_seg_size() to
    avoid access to freed memory after reloading driver module
- unified odroid mfc reserved memory configuration with other Exynos4 boards

v2: http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/97025
- reworked of_reserved_mem_init* functions on request from Rob Herring,
  added separate index and name based selection of reserved region
- adapted for of_reserved_mem_init* related changes

v1: https://www.mail-archive.com/linux-media@vger.kernel.org/msg94100.html
- initial version of another approach for this problem, rewrote driver code
  for new reserved memory bindings, which finally have been merged some
  time ago

v0: http://lists.infradead.org/pipermail/linux-arm-kernel/2013-August/189259.html
- old patchset solving the same problem, abandoned due to other tasks
  and long time of merging reserved memory bindings and support code for
  it

Patch summary:


Marek Szyprowski (7):
  of: reserved_mem: add support for using more than one region for given
    device
  media: s5p-mfc: use generic reserved memory bindings
  media: s5p-mfc: replace custom reserved memory handling code with
    generic one
  media: s5p-mfc: add iommu support
  ARM: Exynos: remove code for MFC custom reserved memory handling
  ARM: dts: exynos: convert MFC device to generic reserved memory
    bindings
  ARM: dts: exynos4412-odroid*: enable MFC device

 .../devicetree/bindings/media/s5p-mfc.txt          |  39 +++--
 arch/arm/boot/dts/exynos-mfc-reserved-memory.dtsi  |  27 ++++
 arch/arm/boot/dts/exynos4210-origen.dts            |   4 +-
 arch/arm/boot/dts/exynos4210-smdkv310.dts          |   4 +-
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi    |   6 +
 arch/arm/boot/dts/exynos4412-origen.dts            |   4 +-
 arch/arm/boot/dts/exynos4412-smdk4412.dts          |   4 +-
 arch/arm/boot/dts/exynos5250-arndale.dts           |   4 +-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |   4 +-
 arch/arm/boot/dts/exynos5250-spring.dts            |   4 +-
 arch/arm/boot/dts/exynos5420-arndale-octa.dts      |   4 +-
 arch/arm/boot/dts/exynos5420-peach-pit.dts         |   4 +-
 arch/arm/boot/dts/exynos5420-smdk5420.dts          |   4 +-
 arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi |   4 +-
 arch/arm/boot/dts/exynos5800-peach-pi.dts          |   4 +-
 arch/arm/mach-exynos/Makefile                      |   2 -
 arch/arm/mach-exynos/exynos.c                      |  19 ---
 arch/arm/mach-exynos/mfc.h                         |  16 ---
 arch/arm/mach-exynos/s5p-dev-mfc.c                 |  93 ------------
 drivers/media/platform/s5p-mfc/s5p_mfc.c           | 158 +++++++++++----------
 drivers/media/platform/s5p-mfc/s5p_mfc_iommu.h     |  79 +++++++++++
 drivers/of/of_reserved_mem.c                       |  85 ++++++++---
 include/linux/of_reserved_mem.h                    |  25 +++-
 23 files changed, 338 insertions(+), 259 deletions(-)
 create mode 100644 arch/arm/boot/dts/exynos-mfc-reserved-memory.dtsi
 delete mode 100644 arch/arm/mach-exynos/mfc.h
 delete mode 100644 arch/arm/mach-exynos/s5p-dev-mfc.c
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_iommu.h

-- 
1.9.2

