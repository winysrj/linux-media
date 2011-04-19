Return-path: <mchehab@pedra>
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.184]:20043
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751869Ab1DSPAs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 11:00:48 -0400
Date: Tue, 19 Apr 2011 17:00:18 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: 'Arnd Bergmann' <arnd@arndb.de>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Kukjin Kim' <kgene.kim@samsung.com>,
	'Sylwester Nawrocki' <s.nawrocki@samsung.com>,
	'Andrzej Pietrasiewicz' <andrzej.p@samsung.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/7] ARM: Samsung: update/rewrite Samsung SYSMMU
 (IOMMU) driver
Message-ID: <20110419150018.GV2192@amd.com>
References: <1303118804-5575-1-git-send-email-m.szyprowski@samsung.com>
 <201104181612.35833.arnd@arndb.de>
 <005f01cbfe6b$148a8810$3d9f9830$%szyprowski@samsung.com>
 <201104191449.50824.arnd@arndb.de>
 <000001cbfe9a$8e64cae0$ab2e60a0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <000001cbfe9a$8e64cae0$ab2e60a0$%szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Apr 19, 2011 at 10:03:27AM -0400, Marek Szyprowski wrote:

> Ok. I understand. IOMMU API is quite nice abstraction of the IOMMU chip.
> dma-mapping API is something much more complex that creates the actual
> mapping for various sets of the devices. IMHO the right direction will
> be to create dma-mapping implementation that will be just a client of
> the IOMMU API. What's your opinion?

Definitly agreed. I plan this since some time but never found the
time to implement it. In the end we can have a generic dma-ops
implementation that works for all iommu-api implementations.

> Getting back to our video codec - it has 2 IOMMU controllers. The codec
> hardware is able to address only 256MiB of space. Do you have an idea how
> this can be handled with dma-mapping API? The only idea that comes to my
> mind is to provide a second, fake 'struct device' and use it for allocations
> for the second IOMMU controller.

The GPU IOMMUs can probably be handled in the GPU driver if they are
that different. Recent PCIe GPUs on x86 have their own IOMMUs too which
are very device specific and are handled in the device driver.

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

