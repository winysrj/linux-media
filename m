Return-path: <mchehab@localhost>
Received: from moutng.kundenserver.de ([212.227.17.8]:59543 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab1GFOKY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 10:10:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 6/8] drivers: add Contiguous Memory Allocator
Date: Wed, 6 Jul 2011 16:09:29 +0200
Cc: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org,
	"'Daniel Walker'" <dwalker@codeaurora.org>,
	"'Jonathan Corbet'" <corbet@lwn.net>,
	"'Mel Gorman'" <mel@csn.ul.ie>,
	"'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
	"'Michal Nazarewicz'" <mina86@mina86.com>,
	"'Jesse Barker'" <jesse.barker@linaro.org>,
	"'Kyungmin Park'" <kyungmin.park@samsung.com>,
	"'Ankita Garg'" <ankita@in.ibm.com>,
	"'Andrew Morton'" <akpm@linux-foundation.org>,
	"'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com> <20110705113345.GA8286@n2100.arm.linux.org.uk> <006301cc3be4$daab1850$900148f0$%szyprowski@samsung.com>
In-Reply-To: <006301cc3be4$daab1850$900148f0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107061609.29996.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Wednesday 06 July 2011, Marek Szyprowski wrote:
> The only problem that might need to be resolved is GFP_ATOMIC allocation
> (updating page properties probably requires some locking), but it can be
> served from a special area which is created on boot without low-memory
> mapping at all. None sane driver will call dma_alloc_coherent(GFP_ATOMIC)
> for large buffers anyway.

Would it be easier to start with a version that only allocated from memory
without a low-memory mapping at first?

This would be similar to the approach that Russell's fix for the regular
dma_alloc_coherent has taken, except that you need to also allow the memory
to be used as highmem user pages.

Maybe you can simply adapt the default location of the contiguous memory
are like this:
- make CONFIG_CMA depend on CONFIG_HIGHMEM on ARM, at compile time
- if ZONE_HIGHMEM exist during boot, put the CMA area in there
- otherwise, put the CMA area at the top end of lowmem, and change
  the zone sizes so ZONE_HIGHMEM stretches over all of the CMA memory.

	Arnd
