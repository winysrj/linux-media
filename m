Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:25342 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3HEM1S (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 08:27:18 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	Tomasz Figa <t.figa@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Rob Herring <robherring2@gmail.com>,
	Olof Johansson <olof@lixom.net>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 0/2] Exynos: MFC: clean up device tree bindings
Date: Mon, 05 Aug 2013 14:26:48 +0200
Message-id: <1375705610-12724-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series are an attempt to cleanup the reserved memory device
tree bindings for MFC device. MFC device has two memory ports (AXI
masters), which are used to do DMA. Usually separate memory regions are
being defined for each of those memory ports to improve performance.
Some versions of MFC block have also significant limitation on the
possible address range available for each of those memory ports/banks.

In the board file era, there have been two additional platform devices
defined for each of memory ports (named "s5p-mfc-l" and "s5p-mfc-r") to
let the driver distinguish memory allocations done for each of them.
Each of those platform devices might have special DMA ops assigned to
fulfil specific memory requirements for a given memory port.

Later, when device tree binding was added for MFC device, those memory
ports were designed as two additional properties: "samsung,mfc-l" and
"samsung,mfc-r" for codec node. This approach however has some
significant limitation, so I propose to redesign it before the binding
become considered as stable.

The first problem with the proposed bindings is the fact that
"samsung,mfc-r"/"samsung,mfc-l" properties are tied only to "base
address + size" attributes of reserved memory and do not allow to assign
any other attributes to those memory ports. This limits using those
memory ports only to simple reserved memory.

The second issue with those attributes is the fact that they are very
specific to the MFC device, while reserved memory region is something
more generic, which can be used for other devices as well. For example
even on Exynos4 platform, similar reserved memory handling will be
needed for the FIMC ISP device.

For handling reserved memory regions and having a method to assign them
to particular device I have posted the patches [1], which add device
tree support to Contiguous Memory Allocator and simple reserved memory
allocator based on dma_declare_coherent() function.

This patch series is my proposal for replacing those custom bindings
with generic approach, proposed in [1]. To get it working we need
separate device node for each memory port, what has been achieved by
adding "simple-bus" compatibility entry to the main MFC device node and
adding two child nodes, which represent each memory port. Those child
nodes have compatible property set to "samsung,memport".

With such a structure "dma-memory-region" property with a phandle to
respective reserved region can be easily added to the child nodes of MFC
device. The advantage of such approach is the fact that those child
nodes can be also used for adding properties for IOMMU (SYSMMU)
controllers. This way also bindings for SYSMMU and the code, which
handles it can be simplified, because respective device tree part better
matches physical hardware design.

Best regards
Marek Szyprowski
Samsung R&D Institute Poland

[1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/257615/


Patch summary:

Marek Szyprowski (2):
  ARM: Exynos: replace custom MFC reserved memory handling with generic
    code
  media: s5p-mfc: remove DT hacks and simplify initialization code

 .../devicetree/bindings/media/s5p-mfc.txt          |   63 +++++++++++++---
 arch/arm/boot/dts/exynos4.dtsi                     |   10 ++-
 arch/arm/boot/dts/exynos4210-origen.dts            |   25 ++++++-
 arch/arm/boot/dts/exynos4210-smdkv310.dts          |   25 ++++++-
 arch/arm/boot/dts/exynos4412-origen.dts            |   25 ++++++-
 arch/arm/boot/dts/exynos4412-smdk4412.dts          |   25 ++++++-
 arch/arm/boot/dts/exynos5250-arndale.dts           |   26 ++++++-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |   26 ++++++-
 arch/arm/boot/dts/exynos5250.dtsi                  |   10 ++-
 arch/arm/mach-exynos/mach-exynos4-dt.c             |   16 -----
 arch/arm/mach-exynos/mach-exynos5-dt.c             |   17 -----
 arch/arm/plat-samsung/include/plat/mfc.h           |   11 ---
 arch/arm/plat-samsung/s5p-dev-mfc.c                |   32 ---------
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   75 ++++----------------
 14 files changed, 227 insertions(+), 159 deletions(-)

-- 
1.7.9.5

