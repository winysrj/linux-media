Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56643 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964795AbbLHIfd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2015 03:35:33 -0500
Subject: Re: [PATCH 0/7] Exynos: MFC driver: reserved memory cleanup and IOMMU
 support
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1449490142-27502-1-git-send-email-m.szyprowski@samsung.com>
Cc: devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <56669652.5000708@samsung.com>
Date: Tue, 08 Dec 2015 09:35:30 +0100
MIME-version: 1.0
In-reply-to: <1449490142-27502-1-git-send-email-m.szyprowski@samsung.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2015-12-07 13:08, Marek Szyprowski wrote:
> This patchset finally perform cleanup of custom code in s5p-mfc codec
> driver. The first part is removal of custom, driver specific code for
> intializing and handling of reserved memory. Instead, a generic code for
> reserved memory regions is used. Then, once it is done, the proper setup
> of DMA parameters (max segment size) is applied for all multimedia
> devices found on Exynos SoCs to let them properly handle shared buffers
> mapped into contiguous DMA address space. The last patch adds support
> for IOMMU to MFC driver. Some additional code is needed because of
> specific requirements of MFC device firmware (see patch 7 for more
> details). When no IOMMU is available, the code fallbacks to generic
> reserved memory regions.
>
> After applying this patchset, MFC device works correctly when IOMMU is
> either enabled or disabled.
>
> Patches have been tested on top of linux-next from 20151207. I would
> prefer to merge patches 1-2 via Samsung tree and patches 3-7 via media
> tree (there are no compile-time dependencies between patches 1-2 and
> 3-7). Patches have been tested on Odroid U3 (Exynos 4412 based) and
> Odroid XU3 (Exynos 5422 based) boards.

One more notice: this is an updated version of the old patch initially
posted here:
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-August/189259.html

The main change since that is adaptation for generic reserved memory
bindings, which have been merged a while ago and added support for IOMMU.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

