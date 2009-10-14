Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34591 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbZJNJtZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 05:49:25 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KRI00FMA03GTT@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Oct 2009 10:38:04 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KRI00KTO03F1V@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Oct 2009 10:38:04 +0100 (BST)
Date: Wed, 14 Oct 2009 11:37:39 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: Global Video Buffers Pool - PMM and UPBuffer reference drivers
 [RFC]
In-reply-to: <000401ca4ca0$d668ef40$833acdc0$%szyprowski@samsung.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Fujak <t.fujak@samsung.com>,
	'Pawel Osciak' <p.osciak@samsung.com>
Message-id: <op.u1sac1ji7p4s8u@localhost>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
References: <000401ca4ca0$d668ef40$833acdc0$%szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

[Code modified a bit to shorten it; removed some error reporting;
  irrelevant parts of the code removed.]
>> diff --git a/drivers/s3cmm/pmm-init.c b/drivers/s3cmm/pmm-init.c
>> new file mode 100644
>> index 0000000..f1e31a5
>> --- /dev/null
>> +++ b/drivers/s3cmm/pmm-init.c
>> @@ -0,0 +1,75 @@
>> +static unsigned long pmm_memory_start, pmm_memory_size;
>> +
>> +static int __init pmm_early_param(char *param)
>> +{
>> +       unsigned long long size = memparse(param, 0);
>> +       void *ptr;
>> +
>> +       if (size <= 0 || size > (1ull << 30))
>> +               return -EINVAL;
>> +
>> +       pmm_memory_size = PAGE_ALIGN((unsigned long)size);
>> +       ptr = alloc_bootmem_pages_nopanic(pmm_memory_size);

From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
> How does this work?  When early params are parsed, the memory subsystem
> hasn't been initialized - not even bootmem.  So this will always fail.

 From my investigation into Linux kernel source code it seems as if
bootmem were initialised prior to parsing early params.  Lets look at
start_kernel():

#v+
init/main.c:
584        setup_arch(&command_line);
[...]
595        parse_early_param();
[...]
607        mm_init();
#v-

On ARM with MMU setup_arch() calls paging_init()
(arch/arm/kernel/setup.c:730) which calls bootmem_init()
(arch/arm/mm/mmu.c:989) which is the function that initialises
bootmem.

Early params are obviously handled by parse_early_param() function
which is invoked after the call to setup_arch().

What is also worth mentioning is that mm_init() initialises standard
allocators so after this function is called bootmem no longer works.


I've also tried to use various *_initcall()s (the ones defined in
include/linux/init.h) but neither of them seemed to work.


>> +       if (ptr)
>> +               pmm_memory_start = virt_to_phys(ptr);
>> +
>> +       return 0;
>> +}
>> +early_param("pmm", pmm_early_param);
>> +
>> +
>> +
>> +/** Called from pmm_module_init() when module is initialised. */
>> +void pmm_module_platform_init(pmm_add_region_func add_region)
>> +{
>> +       if (pmm_memory_start && pmm_memory_size)
>> +               add_region(pmm_memory_start, pmm_memory_size,
>> +                          PMM_MEM_GENERAL, 0);
>> +}
>> +EXPORT_SYMBOL(pmm_module_platform_init);


-- 
Best regards,                                           _     _
   .o. | Liege of Serenely Enlightened Majesty of       o' \,=./ `o
   ..o | Computer Science,  Michał "mina86" Nazarewicz     (o o)
   ooo +---<mina86@mina86.com>---<mina86@jabber.org>---ooO--(_)--Ooo--

