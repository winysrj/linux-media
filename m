Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:64671 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab1DROPv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 10:15:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 4/7] v4l: videobuf2: add IOMMU based DMA memory allocator
Date: Mon, 18 Apr 2011 16:15:48 +0200
Cc: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Pietrasiwiecz <andrzej.p@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>
References: <1303118804-5575-1-git-send-email-m.szyprowski@samsung.com> <1303118804-5575-5-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1303118804-5575-5-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104181615.49009.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 18 April 2011, Marek Szyprowski wrote:
> From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> 
> This patch adds new videobuf2 memory allocator dedicated to devices that
> supports IOMMU DMA mappings. A device with IOMMU module and a driver
> with include/iommu.h compatible interface is required. This allocator
> aquires memory with standard alloc_page() call and doesn't suffer from
> memory fragmentation issues. The allocator support following page sizes:
> 4KiB, 64KiB, 1MiB and 16MiB to reduce iommu translation overhead.

My feeling is that this is not the right abstraction. Why can't you
just implement the regular dma-mapping.h interfaces for your IOMMU
so that the videobuf code can use the existing allocators?

	Arnd
