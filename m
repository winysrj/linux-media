Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60971 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab1BBO6w (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Feb 2011 09:58:52 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Michal Nazarewicz" <m.nazarewicz@samsung.com>,
	"Ankita Garg" <ankita@in.ibm.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"Daniel Walker" <dwalker@codeaurora.org>,
	"Johan MOSSBERG" <johan.xx.mossberg@stericsson.com>,
	"KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
	"Marek Szyprowski" <m.szyprowski@samsung.com>,
	"Mel Gorman" <mel@csn.ul.ie>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCHv8 07/12] mm: cma: Contiguous Memory Allocator added
References: <cover.1292443200.git.m.nazarewicz@samsung.com> <eb8f43235c8ff2816ada7b56ffe371ea6140cae8.1292443200.git.m.nazarewicz@samsung.com> <20110202124333.GB26396@in.ibm.com>
Date: Wed, 02 Feb 2011 15:58:48 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vp96kaxy3l0zgt@mnazarewicz.zrh.corp.google.com>
In-Reply-To: <20110202124333.GB26396@in.ibm.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> On Wed, Dec 15, 2010 at 09:34:27PM +0100, Michal Nazarewicz wrote:
>> +unsigned long cma_reserve(unsigned long start, unsigned long size,
>> +			  unsigned long alignment)
>> +{
>> +	pr_debug("%s(%p+%p/%p)\n", __func__, (void *)start, (void *)size,
>> +		 (void *)alignment);
>> +
>> +	/* Sanity checks */
>> +	if (!size || (alignment & (alignment - 1)))
>> +		return (unsigned long)-EINVAL;
>> +
>> +	/* Sanitise input arguments */
>> +	start = PAGE_ALIGN(start);
>> +	size  = PAGE_ALIGN(size);
>> +	if (alignment < PAGE_SIZE)
>> +		alignment = PAGE_SIZE;
>> +
>> +	/* Reserve memory */
>> +	if (start) {
>> +		if (memblock_is_region_reserved(start, size) ||
>> +		    memblock_reserve(start, size) < 0)
>> +			return (unsigned long)-EBUSY;
>> +	} else {
>> +		/*
>> +		 * Use __memblock_alloc_base() since
>> +		 * memblock_alloc_base() panic()s.
>> +		 */
>> +		u64 addr = __memblock_alloc_base(size, alignment, 0);
>> +		if (!addr) {
>> +			return (unsigned long)-ENOMEM;
>> +		} else if (addr + size > ~(unsigned long)0) {
>> +			memblock_free(addr, size);
>> +			return (unsigned long)-EOVERFLOW;
>> +		} else {
>> +			start = addr;
>> +		}
>> +	}
>> +

On Wed, 02 Feb 2011 13:43:33 +0100, Ankita Garg <ankita@in.ibm.com> wrote:
> Reserving the areas of memory belonging to CMA using memblock_reserve,
> would preclude that range from the zones, due to which it would not be
> available for buddy allocations right ?

Correct.  CMA however, injects allocated pageblocks to buddy so they end
up in buddy with migratetype set to MIGRATE_CMA.

>> +	return start;
>> +}

-- 
Best regards,                                       _     _
.o. | Liege of Serenly Enlightened Majesty of     o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz  (o o)
ooo +-<email/jid: mnazarewicz@google.com>--------ooO--(_)--Ooo--
