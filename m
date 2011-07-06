Return-path: <mchehab@localhost>
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:31980 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753585Ab1GFQLq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jul 2011 12:11:46 -0400
Date: Wed, 6 Jul 2011 11:05:00 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org,
	'Daniel Walker' <dwalker@codeaurora.org>,
	'Jonathan Corbet' <corbet@lwn.net>,
	'Mel Gorman' <mel@csn.ul.ie>,
	'Chunsang Jeong' <chunsang.jeong@linaro.org>,
	'Jesse Barker' <jesse.barker@linaro.org>,
	'KAMEZAWA Hiroyuki' <kamezawa.hiroyu@jp.fujitsu.com>,
	linux-kernel@vger.kernel.org,
	'Michal Nazarewicz' <mina86@mina86.com>,
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Ankita Garg' <ankita@in.ibm.com>,
	'Andrew Morton' <akpm@linux-foundation.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 6/8] drivers: add Contiguous Memory Allocator
In-Reply-To: <20110706154857.GG8286@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1107061100290.17624@router.home>
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com> <201107061609.29996.arnd@arndb.de> <20110706142345.GC8286@n2100.arm.linux.org.uk> <201107061651.49824.arnd@arndb.de> <20110706154857.GG8286@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Wed, 6 Jul 2011, Russell King - ARM Linux wrote:

> > > they typically don't fall into the highmem zone.  As the dmabounce
> > > code allocates from the DMA coherent allocator to provide it with
> > > guaranteed DMA-able memory, that would be rather inconvenient.
> >
> > True. The dmabounce code would consequently have to allocate
> > the memory through an internal function that avoids the
> > contiguous allocation area and goes straight to ZONE_DMA memory
> > as it does today.
>
> CMA's whole purpose for existing is to provide _dma-able_ contiguous
> memory for things like cameras and such like found on crippled non-
> scatter-gather hardware.  If that memory is not DMA-able what's the
> point?

ZONE_DMA is a zone for memory of legacy (crippled) devices that cannot DMA
into all of memory (and so is ZONE_DMA32). Memory from ZONE_NORMAL can be
used for DMA as well and a fully capable device would be expected to
handle any memory in the system for DMA transfers.

"guaranteed" dmaable memory? DMA abilities are device specific. Well maybe
you can call ZONE_DMA memory to be guaranteed if you guarantee that any
device must at mininum be able to perform DMA into ZONE_DMA memory. But
there may not be much of that memory around so you would want to limit
the use of that scarce resource.

