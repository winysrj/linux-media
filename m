Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:44251 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab1CHJe5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2011 04:34:57 -0500
Date: Tue, 08 Mar 2011 10:34:40 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH/RFC 0/7] Samsung IOMMU videobuf2 allocator and s5p-fimc
 update
In-reply-to: <03ab01cbdd62$739550d0$5abff270$%kim@samsung.com>
To: 'Kukjin Kim' <kgene.kim@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	k.debski@samsung.com,
	=?ks_c_5601-1987?B?J8DMwM/Ioy9TL1cgU29sdXRpb26ws7nfxsAoUy5MU0kpL0U1KA==?=
	 =?ks_c_5601-1987?B?w6XA0ykvu++8usD8wNon?=
	<ilho215.lee@samsung.com>,
	=?ks_c_5601-1987?B?J8G2sObIoy9TL1cgU29sdXRpb26ws7nfxsAoUy5MU0kpL0U0KA==?=
	 =?ks_c_5601-1987?B?vLHA0ykvu++8usD8wNon?= <pullip.cho@samsung.com>,
	=?ks_c_5601-1987?B?J7TrwM6x4ic=?= <inki.dae@samsung.com>,
	=?ks_c_5601-1987?B?J7Ctuc6x1Cc=?= <mk7.kang@samsung.com>
Message-id: <001301cbdd74$1044a4b0$30cdee10$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1299229274-9753-1-git-send-email-m.szyprowski@samsung.com>
 <03ab01cbdd62$739550d0$5abff270$%kim@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Tuesday, March 08, 2011 8:29 AM Kukjin Kim wrote:

> Hello,
> 
> There are comments for your System MMU driver below.

Please take into account that this was an initial version of our SYSMMU
driver to start the discussion, so there were a few minor problems left.
Thanks for pointing them out btw. :)

 
> It's good that System MMU has functionality of mapping but System MMU have
> to use other mapping of virtual memory allocator.

Could you elaborate on this? I'm not sure I understand right your problem.

SYSMMU driver is a low-level driver for the SYSMMU module. The driver should
provide all the basic functionality that is (or might be) hardware dependent.
Creating a mapping is one of such elementary functionalities. Sysmmu client
(let it be videobuf2-s5p-iommu, vcmm, maybe even other driver directly)
should not need to know the format of page descriptors or the way they are
arranged in the memory. The sysmmu should provide low level functions to create
and remove a mapping. Managing a virtual space is something that MIGHT be client
dependent and should be left to the client. 

This design allows for different approaches to coexist. Videobuf2-s5p-iommu
client will manage the virtual space with gen_alloc framework, while vcmm will
use its own methods.

It would be great if one decide to unify iommu interfaces across the kernel,
but this will be a long road. We need to start from something simple (platform
private) and working first.
 
> And would be better to change sysmmu_list to use array of defined in
> s5p_sysmmu_ip enumeration, so that can get enhancement of memory space
> usage, speed, and readability of codes.

Yes, the list can be simplified to an array, but this is really a minor issue.

> TLB replacement policy does not need to use LRU. Of course, current System
> MMU also needs it. I think, the round robin is enough, because to access
> memory has no temporal locality and to make LRU need to access to System
> MMU register one more. The reset value is round robin.

Well, the best possibility is to allow sysmmu clients to decide which policy
should be used. For some devices (I'm thinking of MFC) LRU policy might give
a little speedup.

> In the setting of SHARED page table in s5p_sysmmu_control_locked, get the
> page table base address of ARM core from cp15 register now. But current->mm-
> >pgd is better for more compatibility.

Right, this way the pgd table pointer can be acquired in a more system friendly
way.

> When it make page table with PRIVATE page table methods, the size of the
> structure to manage the second page table is quite big. It is much better
> rather that to make slab with cache size of 1KB.

Yes, our initial driver uses directly 4KB pages to manage 4 consecutive second
page tables. However usually the allocations of client devices will be few but
quite large each. So most of pages used to hold second level page tables will
be effectively reused. 

You are right however that the approach with a slab with 1KB units will
result in code that is cleaner and easier to understand.

> Besides, the page mapping implementation is not safe in your System MMU
> driver. Because only first one confirms primary page table entry, when it
> assigns four second page tables consecutively at a time.

That's a direct result of the 4-second-level-at-once method of allocating
second level pages, but this can be cleaned by using 1KB with slab.

> The System MMU driver cannot apply runtime pm by oneself with calling
> pm_runtime_put_sync(). The reason is because a device with System MMU can
> on/off power. I think just clock gating is enough. However, I can't find
> clock enable/disable in your driver.

Clock is enabled in probe() and disabled in remove(). pm_runtime_get/put_sync()
only increases/decreases use count of a respective power domain, so the actual
device driver also has to call pm_runtime_get/put. Calling pm_runtime_put_sync()
will not shut down the power if the sysmmu client driver has called
pm_runtime_get() without pm_runtime_put(). I see no problems here. Could you 
elaborate your issue?

> 
> By PRIVATE page table method, each system MMU comes to have a page table
> only for oneself. In this case, the problem is that each MFC System MMU L
> and R having another page table.

Yes, true. This is consequence of the MFC hardware design and the fact that
it has 2 AXI master interfaces and 2 SYSMMU controllers. Each of them have to
be configured separately. Each of them has a separate virtual driver's address
space. Such configuration is used by the MFC driver posted in v7 patch series.

> In your System MMU driver, the page size is always 4KB crucially. This says
> TLB thrashing and produces a result to lose a TLB hit rate. It is a big
> problem with the device such as rotator which does not do sequential access
> especially.

The page size is set to 4KB, because Linux kernel uses 4KB pages by default.
Once support for other page size is available in the kernel, then sysmmu can be
extended also.

> And the IRQ handler just outputs only a message. It should be implemented
> in call back function to be able to handle from each device driver.

This was only for debugging purpose, but you are right that the sysmmu API in 
this area need to be extended.

> When it sets System MMU in SHARED page table, kernel virtual memory is
> broken by a method such as s5p_sysmmu_map_area()

Yes, there should be a check added to prevent messing with ARM pgd in SHARED 
mode.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center



