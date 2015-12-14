Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9081 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbbLNJmO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 04:42:14 -0500
Subject: Re: [PATCH v2 0/7] Exynos: MFC driver: reserved memory cleanup and
 IOMMU support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1449669502-24601-1-git-send-email-m.szyprowski@samsung.com>
 <1849454.x4mBhJHn1l@avalon>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <566E8EF2.9020601@samsung.com>
Date: Mon, 14 Dec 2015 10:42:10 +0100
MIME-version: 1.0
In-reply-to: <1849454.x4mBhJHn1l@avalon>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2015-12-13 20:52, Laurent Pinchart wrote:
> Hi Marek,
>
> Thank you for the patches.
>
> On Wednesday 09 December 2015 14:58:15 Marek Szyprowski wrote:
>> Hello,
>>
>> This patchset finally perform cleanup of custom code in s5p-mfc codec
>> driver. The first part is removal of custom, driver specific code for
>> intializing and handling of reserved memory. Instead, a generic code for
>> reserved memory regions is used.
> Should you update the reserved memory bindings documentation
> (Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt) to
> document usage of the memory-region-names property ?

Okay, I will update documentation as well.

>> Then, once it is done, the proper setup
>> of DMA parameters (max segment size) is applied for all multimedia
>> devices found on Exynos SoCs to let them properly handle shared buffers
>> mapped into contiguous DMA address space. The last patch adds support
>> for IOMMU to MFC driver. Some additional code is needed because of
>> specific requirements of MFC device firmware (see patch 7 for more
>> details). When no IOMMU is available, the code fallbacks to generic
>> reserved memory regions.
>>
>> After applying this patchset, MFC device works correctly when IOMMU is
>> either enabled or disabled.
>>
>> Patches have been tested on top of linux-next from 20151207. I would
>> prefer to merge patches 1-2 via Samsung tree and patches 3-7 via media
>> tree (there are no compile-time dependencies between patches 1-2 and
>> 3-7). Patches have been tested on Odroid U3 (Exynos 4412 based) and
>> Odroid XU3 (Exynos 5422 based) boards.
>>
>> Best regards
>> Marek Szyprowski
>> Samsung R&D Institute Poland
>>
>>
>> Changelog:
>> v2:
>> - reworked of_reserved_mem_init* functions on request from Rob Herring,
>>    added separate index and name based selection of reserved region
>> - adapted for of_reserved_mem_init* related changes
>>
>> v1: https://www.mail-archive.com/linux-media@vger.kernel.org/msg94100.html
>> - initial version of another approach for this problem, rewrote driver code
>>    for new reserved memory bindings, which finally have been merged some
>>    time ago
>>
>> v0:
>> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-August/189259.ht
>> ml - old patchset solving the same problem, abandoned due to other tasks and
>> long time of merging reserved memory bindings and support code for it
>>
>> Patch summary:
>>
>> Marek Szyprowski (7):
>>    ARM: Exynos: convert MFC device to generic reserved memory bindings
>>    ARM: dts: exynos4412-odroid*: enable MFC device
>>    of: reserved_mem: add support for named reserved mem nodes
>>    media: vb2-dma-contig: add helper for setting dma max seg size
>>    media: set proper max seg size for devices on Exynos SoCs
>>    media: s5p-mfc: replace custom reserved memory init code with generic
>>      one
>>    media: s5p-mfc: add iommu support
>>
>>   .../devicetree/bindings/media/s5p-mfc.txt          |  16 +--
>>   arch/arm/boot/dts/exynos4210-origen.dts            |  22 ++-
>>   arch/arm/boot/dts/exynos4210-smdkv310.dts          |  22 ++-
>>   arch/arm/boot/dts/exynos4412-odroid-common.dtsi    |  24 ++++
>>   arch/arm/boot/dts/exynos4412-origen.dts            |  22 ++-
>>   arch/arm/boot/dts/exynos4412-smdk4412.dts          |  22 ++-
>>   arch/arm/boot/dts/exynos5250-arndale.dts           |  22 ++-
>>   arch/arm/boot/dts/exynos5250-smdk5250.dts          |  22 ++-
>>   arch/arm/boot/dts/exynos5250-spring.dts            |  22 ++-
>>   arch/arm/boot/dts/exynos5420-arndale-octa.dts      |  22 ++-
>>   arch/arm/boot/dts/exynos5420-smdk5420.dts          |  22 ++-
>>   arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi |  22 ++-
>>   arch/arm/mach-exynos/Makefile                      |   2 -
>>   arch/arm/mach-exynos/exynos.c                      |  19 ---
>>   arch/arm/mach-exynos/mfc.h                         |  16 ---
>>   arch/arm/mach-exynos/s5p-dev-mfc.c                 |  94 -------------
>>   drivers/media/platform/exynos-gsc/gsc-core.c       |   1 +
>>   drivers/media/platform/exynos4-is/fimc-core.c      |   1 +
>>   drivers/media/platform/exynos4-is/fimc-is.c        |   1 +
>>   drivers/media/platform/exynos4-is/fimc-lite.c      |   1 +
>>   drivers/media/platform/s5p-g2d/g2d.c               |   1 +
>>   drivers/media/platform/s5p-jpeg/jpeg-core.c        |   1 +
>>   drivers/media/platform/s5p-mfc/s5p_mfc.c           | 153 ++++++++++--------
>>   drivers/media/platform/s5p-mfc/s5p_mfc_iommu.h     |  79 +++++++++++
>>   drivers/media/platform/s5p-tv/mixer_video.c        |   1 +
>>   drivers/media/v4l2-core/videobuf2-dma-contig.c     |  15 ++
>>   drivers/of/of_reserved_mem.c                       | 104 +++++++++++---
>>   include/linux/of_reserved_mem.h                    |  31 ++++-
>>   include/media/videobuf2-dma-contig.h               |   1 +
>>   29 files changed, 533 insertions(+), 248 deletions(-)
>>   delete mode 100644 arch/arm/mach-exynos/mfc.h
>>   delete mode 100644 arch/arm/mach-exynos/s5p-dev-mfc.c
>>   create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_iommu.h

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

