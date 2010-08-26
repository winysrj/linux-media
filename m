Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52278 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab0HZBXG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Aug 2010 21:23:06 -0400
Date: Thu, 26 Aug 2010 03:22:37 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH/RFCv4 2/6] mm: cma: Contiguous Memory Allocator added
In-reply-to: <20100825203237.GA5318@phenom.dumpdata.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Daniel Walker <dwalker@codeaurora.org>,
	Russell King <linux@arm.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Pawel Osciak <p.osciak@samsung.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	linux-kernel@vger.kernel.org,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
	Zach Pfeffer <zpfeffer@codeaurora.org>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <op.vh0t3z2m7p4s8u@localhost>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
References: <cover.1282286941.git.m.nazarewicz@samsung.com>
 <0b02e05fc21e70a3af39e65e628d117cd89d70a1.1282286941.git.m.nazarewicz@samsung.com>
 <343f4b0edf9b5eef598831700cb459cd428d3f2e.1282286941.git.m.nazarewicz@samsung.com>
 <20100825203237.GA5318@phenom.dumpdata.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, 25 Aug 2010 22:32:37 +0200, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Fri, Aug 20, 2010 at 11:50:42AM +0200, Michal Nazarewicz wrote:
>> The Contiguous Memory Allocator framework is a set of APIs for
>> allocating physically contiguous chunks of memory.
>>
>> Various chips require contiguous blocks of memory to operate.  Those
>> chips include devices such as cameras, hardware video decoders and
>> encoders, etc.
>
> I am not that familiar with how StrongARM works, and I took a bit look
> at the arch/arm/mach-s* and then some of the
> drivers/video/media/video/cx88 to get an idea how the hardware video
> decoders would work this.
>
> What I got from this patch review is that you are writting an IOMMU

No.  CMA's designed for systems without IOMMU.  If system has IOMMU then
there is no need for contiguous memory blocks since all discontiguousnesses
can be hidden by the IOMMU.

> that is on steroids. It essentially knows that this device and that
> device can both share the same region, and it has fancy plugin system
> to deal with fragmentation and offers an simple API for other to
> write their own "allocators".

Dunno if the plugin system is "fancy" but essentially the above is true. ;)

> Even better, during init, the sub-platform can use
> cma_early_regions_reserve(<func>) to register their own function
> for reserving large regions of memory. Which from my experience (with
> Xen) means that there is a mechanism in place to have it setup
> contingous regions using sub-platform code.

Essentially that's the idea.  Platform init code adds early regions and later
on reserves memory for all of the early regions.  For the former some
additional helper functions are provided which can be used.

> This is how I think it works, but I am not sure if I got it right. From
> looking at 'cma_alloc' and 'cma_alloc_from_region' - both return
> an dma_addr_t, which is what is usually feed in the DMA API. And looking
> at the cx88 driver I see it using that API..
>
> I do understand that under ARM platform you might not have a need for
> DMA at all, and you use the 'dma_addr_t' just as handles, but for
> other platforms this would be used.

In the first version I've used unsigned long as return type but then it
was suggested that maybe dma_addr_t would be better.  This is easily
changed at this stage so I'd be more then happy to hear any comments.

> So here is the bit where I am confused. Why not have this
> as Software IOMMU that would utilize the IOMMU API? There would be some
> technical questions to be answered (such as, what to do when you have
> another IOMMU and can you stack them on top of each other).

If I understood you correctly this is something I'm thinking about.  I'm
actually thinking of ways to integrate CMA with Zach's IOMMU proposal posted
some time ago.  The idea would be to define a subset of functionalities
of the IOMMU API that would work on systems with and without hardware IOMMU.
If platform had no IOMMU CMA would be used.

I'm currently trying to fully understand Zach's proposal to see how such an
approach could be pursued.

> A light review below:

Thanks!  Greatly appreciated.

>> + * cma_alloc_from - allocates contiguous chunk of memory from named regions.
>> + * @regions:	Comma separated list of region names.  Terminated by NUL
>
> I think you mean 'NULL'

No, a NUL byte, ie. '\0'.

>> + *		byte or a semicolon.
>
> Uh, really? Why? Why not just simplify your life and make it \0?

This is a consequence of how map is stored.  It's stored as a single string
with entries separated by semicolons.

>> + * The cma_allocator::alloc() operation need to set only the @start
>                       ^^- C++, eh?

Well, I'm unaware of a C way to reference "methods" so I just borrowed C++ style.

>> +int __init cma_early_region_reserve(struct cma_region *reg)
>> +{
[...]
>> +#ifndef CONFIG_NO_BOOTMEM
[...]
>> +#endif
>> +
>> +#ifdef CONFIG_HAVE_MEMBLOCK
[...]
>> +#endif

> Those two #ifdefs are pretty ugly. What if you defined in a header
> something along this:
>
> #ifdef CONFIG_HAVE_MEMBLOCK
> int __init default_early_region_reserve(struct cma_region *reg) {
>    .. do it using memblock
> }
> #endif
> #ifdef CONFIG_NO_BOOTMEM
> int __init default_early_region_reserve(struct cma_region *reg) {
>    .. do it using bootmem
> }
> #endif

I wanted the function to try all possible allocators.  As a matter of fact,
both APIs (memblock and bootmem) can be supported at the same time.

> and you would cut the API by one function, the
> cma_early_regions_reserve(struct cma_region *reg)

Actually, I would prefer to leave it.  It may be useful for platform
initialisation code.  Especially if platform has some special regions
which are allocated in a different but for the rest wants to use the
default CMA's reserve call.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

