Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve1eur01on0064.outbound.protection.outlook.com ([104.47.1.64]:25759
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932557AbeE3Fad (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 01:30:33 -0400
Subject: Re: [PATCH 2/8] xen/balloon: Move common memory reservation routines
 to a module
To: Juergen Gross <jgross@suse.com>,
        Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com
References: <20180525153331.31188-1-andr2000@gmail.com>
 <20180525153331.31188-3-andr2000@gmail.com>
 <b838fcb8-fa7f-5d75-d536-4dca47bd20aa@suse.com>
From: Oleksandr Andrushchenko <Oleksandr_Andrushchenko@epam.com>
Message-ID: <3d9360c5-5ee4-292b-3787-fc4d4cfc9cc9@epam.com>
Date: Wed, 30 May 2018 08:30:26 +0300
MIME-Version: 1.0
In-Reply-To: <b838fcb8-fa7f-5d75-d536-4dca47bd20aa@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/30/2018 07:32 AM, Juergen Gross wrote:
> On 25/05/18 17:33, Oleksandr Andrushchenko wrote:
>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>
>> Memory {increase|decrease}_reservation and VA mappings update/reset
>> code used in balloon driver can be made common, so other drivers can
>> also re-use the same functionality without open-coding.
>> Create a dedicated module for the shared code and export corresponding
>> symbols for other kernel modules.
>>
>> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>> ---
>>   drivers/xen/Makefile          |   1 +
>>   drivers/xen/balloon.c         |  71 ++----------------
>>   drivers/xen/mem-reservation.c | 134 ++++++++++++++++++++++++++++++++++
>>   include/xen/mem_reservation.h |  29 ++++++++
>>   4 files changed, 170 insertions(+), 65 deletions(-)
>>   create mode 100644 drivers/xen/mem-reservation.c
>>   create mode 100644 include/xen/mem_reservation.h
> Can you please name this include/xen/mem-reservation.h ?
>
Will rename
>> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
>> index 451e833f5931..3c87b0c3aca6 100644
>> --- a/drivers/xen/Makefile
>> +++ b/drivers/xen/Makefile
>> @@ -2,6 +2,7 @@
>>   obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
>>   obj-$(CONFIG_X86)			+= fallback.o
>>   obj-y	+= grant-table.o features.o balloon.o manage.o preempt.o time.o
>> +obj-y	+= mem-reservation.o
>>   obj-y	+= events/
>>   obj-y	+= xenbus/
>>   
>> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
>> index 065f0b607373..57b482d67a3a 100644
>> --- a/drivers/xen/balloon.c
>> +++ b/drivers/xen/balloon.c
>> @@ -71,6 +71,7 @@
>>   #include <xen/balloon.h>
>>   #include <xen/features.h>
>>   #include <xen/page.h>
>> +#include <xen/mem_reservation.h>
>>   
>>   static int xen_hotplug_unpopulated;
>>   
>> @@ -157,13 +158,6 @@ static DECLARE_DELAYED_WORK(balloon_worker, balloon_process);
>>   #define GFP_BALLOON \
>>   	(GFP_HIGHUSER | __GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC)
>>   
>> -static void scrub_page(struct page *page)
>> -{
>> -#ifdef CONFIG_XEN_SCRUB_PAGES
>> -	clear_highpage(page);
>> -#endif
>> -}
>> -
>>   /* balloon_append: add the given page to the balloon. */
>>   static void __balloon_append(struct page *page)
>>   {
>> @@ -463,11 +457,6 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
>>   	int rc;
>>   	unsigned long i;
>>   	struct page   *page;
>> -	struct xen_memory_reservation reservation = {
>> -		.address_bits = 0,
>> -		.extent_order = EXTENT_ORDER,
>> -		.domid        = DOMID_SELF
>> -	};
>>   
>>   	if (nr_pages > ARRAY_SIZE(frame_list))
>>   		nr_pages = ARRAY_SIZE(frame_list);
>> @@ -486,9 +475,7 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
>>   		page = balloon_next_page(page);
>>   	}
>>   
>> -	set_xen_guest_handle(reservation.extent_start, frame_list);
>> -	reservation.nr_extents = nr_pages;
>> -	rc = HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
>> +	rc = xenmem_reservation_increase(nr_pages, frame_list);
>>   	if (rc <= 0)
>>   		return BP_EAGAIN;
>>   
>> @@ -496,29 +483,7 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
>>   		page = balloon_retrieve(false);
>>   		BUG_ON(page == NULL);
>>   
>> -#ifdef CONFIG_XEN_HAVE_PVMMU
>> -		/*
>> -		 * We don't support PV MMU when Linux and Xen is using
>> -		 * different page granularity.
>> -		 */
>> -		BUILD_BUG_ON(XEN_PAGE_SIZE != PAGE_SIZE);
>> -
>> -		if (!xen_feature(XENFEAT_auto_translated_physmap)) {
>> -			unsigned long pfn = page_to_pfn(page);
>> -
>> -			set_phys_to_machine(pfn, frame_list[i]);
>> -
>> -			/* Link back into the page tables if not highmem. */
>> -			if (!PageHighMem(page)) {
>> -				int ret;
>> -				ret = HYPERVISOR_update_va_mapping(
>> -						(unsigned long)__va(pfn << PAGE_SHIFT),
>> -						mfn_pte(frame_list[i], PAGE_KERNEL),
>> -						0);
>> -				BUG_ON(ret);
>> -			}
>> -		}
>> -#endif
>> +		xenmem_reservation_va_mapping_update(1, &page, &frame_list[i]);
>>   
>>   		/* Relinquish the page back to the allocator. */
>>   		free_reserved_page(page);
>> @@ -535,11 +500,6 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
>>   	unsigned long i;
>>   	struct page *page, *tmp;
>>   	int ret;
>> -	struct xen_memory_reservation reservation = {
>> -		.address_bits = 0,
>> -		.extent_order = EXTENT_ORDER,
>> -		.domid        = DOMID_SELF
>> -	};
>>   	LIST_HEAD(pages);
>>   
>>   	if (nr_pages > ARRAY_SIZE(frame_list))
>> @@ -553,7 +513,7 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
>>   			break;
>>   		}
>>   		adjust_managed_page_count(page, -1);
>> -		scrub_page(page);
>> +		xenmem_reservation_scrub_page(page);
>>   		list_add(&page->lru, &pages);
>>   	}
>>   
>> @@ -575,25 +535,8 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
>>   		/* XENMEM_decrease_reservation requires a GFN */
>>   		frame_list[i++] = xen_page_to_gfn(page);
>>   
>> -#ifdef CONFIG_XEN_HAVE_PVMMU
>> -		/*
>> -		 * We don't support PV MMU when Linux and Xen is using
>> -		 * different page granularity.
>> -		 */
>> -		BUILD_BUG_ON(XEN_PAGE_SIZE != PAGE_SIZE);
>> -
>> -		if (!xen_feature(XENFEAT_auto_translated_physmap)) {
>> -			unsigned long pfn = page_to_pfn(page);
>> +		xenmem_reservation_va_mapping_reset(1, &page);
>>   
>> -			if (!PageHighMem(page)) {
>> -				ret = HYPERVISOR_update_va_mapping(
>> -						(unsigned long)__va(pfn << PAGE_SHIFT),
>> -						__pte_ma(0), 0);
>> -				BUG_ON(ret);
>> -			}
>> -			__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
>> -		}
>> -#endif
>>   		list_del(&page->lru);
>>   
>>   		balloon_append(page);
>> @@ -601,9 +544,7 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
>>   
>>   	flush_tlb_all();
>>   
>> -	set_xen_guest_handle(reservation.extent_start, frame_list);
>> -	reservation.nr_extents   = nr_pages;
>> -	ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation, &reservation);
>> +	ret = xenmem_reservation_decrease(nr_pages, frame_list);
>>   	BUG_ON(ret != nr_pages);
>>   
>>   	balloon_stats.current_pages -= nr_pages;
>> diff --git a/drivers/xen/mem-reservation.c b/drivers/xen/mem-reservation.c
>> new file mode 100644
>> index 000000000000..29882e4324f5
>> --- /dev/null
>> +++ b/drivers/xen/mem-reservation.c
>> @@ -0,0 +1,134 @@
>> +// SPDX-License-Identifier: GPL-2.0 OR MIT
>> +
>> +/******************************************************************************
>> + * Xen memory reservation utilities.
>> + *
>> + * Copyright (c) 2003, B Dragovic
>> + * Copyright (c) 2003-2004, M Williamson, K Fraser
>> + * Copyright (c) 2005 Dan M. Smith, IBM Corporation
>> + * Copyright (c) 2010 Daniel Kiper
>> + * Copyright (c) 2018, Oleksandr Andrushchenko, EPAM Systems Inc.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/slab.h>
>> +
>> +#include <asm/tlb.h>
>> +#include <asm/xen/hypercall.h>
>> +
>> +#include <xen/interface/memory.h>
>> +#include <xen/page.h>
>> +
>> +/*
>> + * Use one extent per PAGE_SIZE to avoid to break down the page into
>> + * multiple frame.
>> + */
>> +#define EXTENT_ORDER (fls(XEN_PFN_PER_PAGE) - 1)
>> +
>> +void xenmem_reservation_scrub_page(struct page *page)
>> +{
>> +#ifdef CONFIG_XEN_SCRUB_PAGES
>> +	clear_highpage(page);
>> +#endif
>> +}
>> +EXPORT_SYMBOL(xenmem_reservation_scrub_page);
> EXPORT_SYMBOL_GPL()
>
> Multiple times below, too.
Ok, will change to _GPL
> As a general rule of thumb: new exports should all be
> EXPORT_SYMBOL_GPL() if you can't give a reason why they shouldn't be.
>
>
> Juergen
Thank you,
Oleksandr
