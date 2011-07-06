Return-path: <mchehab@localhost>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45493 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab1GFRE2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 13:04:28 -0400
Date: Wed, 6 Jul 2011 18:02:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Christoph Lameter <cl@linux.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
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
Message-ID: <20110706170229.GI8286@n2100.arm.linux.org.uk>
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com> <201107061609.29996.arnd@arndb.de> <20110706142345.GC8286@n2100.arm.linux.org.uk> <201107061651.49824.arnd@arndb.de> <20110706154857.GG8286@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1107061100290.17624@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1107061100290.17624@router.home>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Wed, Jul 06, 2011 at 11:05:00AM -0500, Christoph Lameter wrote:
> On Wed, 6 Jul 2011, Russell King - ARM Linux wrote:
> 
> > > > they typically don't fall into the highmem zone.  As the dmabounce
> > > > code allocates from the DMA coherent allocator to provide it with
> > > > guaranteed DMA-able memory, that would be rather inconvenient.
> > >
> > > True. The dmabounce code would consequently have to allocate
> > > the memory through an internal function that avoids the
> > > contiguous allocation area and goes straight to ZONE_DMA memory
> > > as it does today.
> >
> > CMA's whole purpose for existing is to provide _dma-able_ contiguous
> > memory for things like cameras and such like found on crippled non-
> > scatter-gather hardware.  If that memory is not DMA-able what's the
> > point?
> 
> ZONE_DMA is a zone for memory of legacy (crippled) devices that cannot DMA
> into all of memory (and so is ZONE_DMA32). Memory from ZONE_NORMAL can be
> used for DMA as well and a fully capable device would be expected to
> handle any memory in the system for DMA transfers.
> 
> "guaranteed" dmaable memory? DMA abilities are device specific. Well maybe
> you can call ZONE_DMA memory to be guaranteed if you guarantee that any
> device must at mininum be able to perform DMA into ZONE_DMA memory. But
> there may not be much of that memory around so you would want to limit
> the use of that scarce resource.

Precisely, which is what ZONE_DMA is all about.  I *have* been a Linux
kernel hacker for the last 18 years and do know these things, especially
as ARM has had various issues with DMA memory limitations over those
years - and have successfully had platforms working reliably given that
and ZONE_DMA.
