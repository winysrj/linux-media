Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46004 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965391AbeE2SBg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 14:01:36 -0400
Subject: Re: [PATCH 2/8] xen/balloon: Move common memory reservation routines
 to a module
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180525153331.31188-1-andr2000@gmail.com>
 <20180525153331.31188-3-andr2000@gmail.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <59ab73b0-967b-a82f-3b0d-95f1b0dc40a5@oracle.com>
Date: Tue, 29 May 2018 14:04:38 -0400
MIME-Version: 1.0
In-Reply-To: <20180525153331.31188-3-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/25/2018 11:33 AM, Oleksandr Andrushchenko wrote:
> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>
> Memory {increase|decrease}_reservation and VA mappings update/reset
> code used in balloon driver can be made common, so other drivers can
> also re-use the same functionality without open-coding.
> Create a dedicated module 

IIUIC this is not really a module, it's a common file.


> for the shared code and export corresponding
> symbols for other kernel modules.
>
> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
> ---
>  drivers/xen/Makefile          |   1 +
>  drivers/xen/balloon.c         |  71 ++----------------
>  drivers/xen/mem-reservation.c | 134 ++++++++++++++++++++++++++++++++++
>  include/xen/mem_reservation.h |  29 ++++++++
>  4 files changed, 170 insertions(+), 65 deletions(-)
>  create mode 100644 drivers/xen/mem-reservation.c
>  create mode 100644 include/xen/mem_reservation.h
>
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index 451e833f5931..3c87b0c3aca6 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -2,6 +2,7 @@
>  obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
>  obj-$(CONFIG_X86)			+= fallback.o
>  obj-y	+= grant-table.o features.o balloon.o manage.o preempt.o time.o
> +obj-y	+= mem-reservation.o
>  obj-y	+= events/
>  obj-y	+= xenbus/
>  
> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> index 065f0b607373..57b482d67a3a 100644
> --- a/drivers/xen/balloon.c
> +++ b/drivers/xen/balloon.c
> @@ -71,6 +71,7 @@
>  #include <xen/balloon.h>
>  #include <xen/features.h>
>  #include <xen/page.h>
> +#include <xen/mem_reservation.h>
>  
>  static int xen_hotplug_unpopulated;
>  
> @@ -157,13 +158,6 @@ static DECLARE_DELAYED_WORK(balloon_worker, balloon_process);
>  #define GFP_BALLOON \
>  	(GFP_HIGHUSER | __GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC)
>  
> -static void scrub_page(struct page *page)
> -{
> -#ifdef CONFIG_XEN_SCRUB_PAGES
> -	clear_highpage(page);
> -#endif
> -}
> -
>  /* balloon_append: add the given page to the balloon. */
>  static void __balloon_append(struct page *page)
>  {
> @@ -463,11 +457,6 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
>  	int rc;
>  	unsigned long i;
>  	struct page   *page;
> -	struct xen_memory_reservation reservation = {
> -		.address_bits = 0,
> -		.extent_order = EXTENT_ORDER,
> -		.domid        = DOMID_SELF
> -	};
>  
>  	if (nr_pages > ARRAY_SIZE(frame_list))
>  		nr_pages = ARRAY_SIZE(frame_list);
> @@ -486,9 +475,7 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
>  		page = balloon_next_page(page);
>  	}
>  
> -	set_xen_guest_handle(reservation.extent_start, frame_list);
> -	reservation.nr_extents = nr_pages;
> -	rc = HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
> +	rc = xenmem_reservation_increase(nr_pages, frame_list);
>  	if (rc <= 0)
>  		return BP_EAGAIN;
>  
> @@ -496,29 +483,7 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
>  		page = balloon_retrieve(false);
>  		BUG_ON(page == NULL);
>  
> -#ifdef CONFIG_XEN_HAVE_PVMMU
> -		/*
> -		 * We don't support PV MMU when Linux and Xen is using
> -		 * different page granularity.
> -		 */
> -		BUILD_BUG_ON(XEN_PAGE_SIZE != PAGE_SIZE);
> -
> -		if (!xen_feature(XENFEAT_auto_translated_physmap)) {
> -			unsigned long pfn = page_to_pfn(page);
> -
> -			set_phys_to_machine(pfn, frame_list[i]);
> -
> -			/* Link back into the page tables if not highmem. */
> -			if (!PageHighMem(page)) {
> -				int ret;
> -				ret = HYPERVISOR_update_va_mapping(
> -						(unsigned long)__va(pfn << PAGE_SHIFT),
> -						mfn_pte(frame_list[i], PAGE_KERNEL),
> -						0);
> -				BUG_ON(ret);
> -			}
> -		}
> -#endif
> +		xenmem_reservation_va_mapping_update(1, &page, &frame_list[i]);


Can you make a single call to xenmem_reservation_va_mapping_update(rc,
...)? You need to keep track of pages but presumable they can be put
into an array (or a list). In fact, perhaps we can have
balloon_retrieve() return a set of pages.




>  
>  		/* Relinquish the page back to the allocator. */
>  		free_reserved_page(page);
> @@ -535,11 +500,6 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
>  	unsigned long i;
>  	struct page *page, *tmp;
>  	int ret;
> -	struct xen_memory_reservation reservation = {
> -		.address_bits = 0,
> -		.extent_order = EXTENT_ORDER,
> -		.domid        = DOMID_SELF
> -	};
>  	LIST_HEAD(pages);
>  
>  	if (nr_pages > ARRAY_SIZE(frame_list))
> @@ -553,7 +513,7 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
>  			break;
>  		}
>  		adjust_managed_page_count(page, -1);
> -		scrub_page(page);
> +		xenmem_reservation_scrub_page(page);
>  		list_add(&page->lru, &pages);
>  	}
>  
> @@ -575,25 +535,8 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
>  		/* XENMEM_decrease_reservation requires a GFN */
>  		frame_list[i++] = xen_page_to_gfn(page);
>  
> -#ifdef CONFIG_XEN_HAVE_PVMMU
> -		/*
> -		 * We don't support PV MMU when Linux and Xen is using
> -		 * different page granularity.
> -		 */
> -		BUILD_BUG_ON(XEN_PAGE_SIZE != PAGE_SIZE);
> -
> -		if (!xen_feature(XENFEAT_auto_translated_physmap)) {
> -			unsigned long pfn = page_to_pfn(page);
> +		xenmem_reservation_va_mapping_reset(1, &page);


and here too.


>  
> -			if (!PageHighMem(page)) {
> -				ret = HYPERVISOR_update_va_mapping(
> -						(unsigned long)__va(pfn << PAGE_SHIFT),
> -						__pte_ma(0), 0);
> -				BUG_ON(ret);
> -			}
> -			__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
> -		}
> -#endif
>  		list_del(&page->lru);
>  
>  		balloon_append(page);
> @@ -601,9 +544,7 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
>  
>  	flush_tlb_all();
>  
> -	set_xen_guest_handle(reservation.extent_start, frame_list);
> -	reservation.nr_extents   = nr_pages;
> -	ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation, &reservation);
> +	ret = xenmem_reservation_decrease(nr_pages, frame_list);
>  	BUG_ON(ret != nr_pages);
>  
>  	balloon_stats.current_pages -= nr_pages;
> diff --git a/drivers/xen/mem-reservation.c b/drivers/xen/mem-reservation.c
> new file mode 100644
> index 000000000000..29882e4324f5
> --- /dev/null
> +++ b/drivers/xen/mem-reservation.c
> @@ -0,0 +1,134 @@
> +// SPDX-License-Identifier: GPL-2.0 OR MIT


Why is this "OR MIT"? The original file was licensed GPLv2 only.


> +
> +/******************************************************************************
> + * Xen memory reservation utilities.
> + *
> + * Copyright (c) 2003, B Dragovic
> + * Copyright (c) 2003-2004, M Williamson, K Fraser
> + * Copyright (c) 2005 Dan M. Smith, IBM Corporation
> + * Copyright (c) 2010 Daniel Kiper
> + * Copyright (c) 2018, Oleksandr Andrushchenko, EPAM Systems Inc.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +
> +#include <asm/tlb.h>
> +#include <asm/xen/hypercall.h>
> +
> +#include <xen/interface/memory.h>
> +#include <xen/page.h>
> +
> +/*
> + * Use one extent per PAGE_SIZE to avoid to break down the page into
> + * multiple frame.
> + */
> +#define EXTENT_ORDER (fls(XEN_PFN_PER_PAGE) - 1)
> +
> +void xenmem_reservation_scrub_page(struct page *page)
> +{
> +#ifdef CONFIG_XEN_SCRUB_PAGES
> +	clear_highpage(page);
> +#endif
> +}
> +EXPORT_SYMBOL(xenmem_reservation_scrub_page);
> +
> +void xenmem_reservation_va_mapping_update(unsigned long count,
> +					  struct page **pages,
> +					  xen_pfn_t *frames)
> +{
> +#ifdef CONFIG_XEN_HAVE_PVMMU
> +	int i;
> +
> +	for (i = 0; i < count; i++) {
> +		struct page *page;
> +
> +		page = pages[i];
> +		BUG_ON(page == NULL);
> +
> +		/*
> +		 * We don't support PV MMU when Linux and Xen is using
> +		 * different page granularity.
> +		 */
> +		BUILD_BUG_ON(XEN_PAGE_SIZE != PAGE_SIZE);
> +
> +		if (!xen_feature(XENFEAT_auto_translated_physmap)) {
> +			unsigned long pfn = page_to_pfn(page);
> +
> +			set_phys_to_machine(pfn, frames[i]);
> +
> +			/* Link back into the page tables if not highmem. */
> +			if (!PageHighMem(page)) {
> +				int ret;
> +
> +				ret = HYPERVISOR_update_va_mapping(
> +						(unsigned long)__va(pfn << PAGE_SHIFT),
> +						mfn_pte(frames[i], PAGE_KERNEL),
> +						0);
> +				BUG_ON(ret);
> +			}
> +		}
> +	}
> +#endif
> +}
> +EXPORT_SYMBOL(xenmem_reservation_va_mapping_update);
> +
> +void xenmem_reservation_va_mapping_reset(unsigned long count,
> +					 struct page **pages)
> +{
> +#ifdef CONFIG_XEN_HAVE_PVMMU
> +	int i;
> +
> +	for (i = 0; i < count; i++) {
> +		/*
> +		 * We don't support PV MMU when Linux and Xen is using
> +		 * different page granularity.
> +		 */
> +		BUILD_BUG_ON(XEN_PAGE_SIZE != PAGE_SIZE);
> +
> +		if (!xen_feature(XENFEAT_auto_translated_physmap)) {
> +			struct page *page = pages[i];
> +			unsigned long pfn = page_to_pfn(page);
> +
> +			if (!PageHighMem(page)) {
> +				int ret;
> +
> +				ret = HYPERVISOR_update_va_mapping(
> +						(unsigned long)__va(pfn << PAGE_SHIFT),
> +						__pte_ma(0), 0);
> +				BUG_ON(ret);
> +			}
> +			__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
> +		}
> +	}
> +#endif
> +}
> +EXPORT_SYMBOL(xenmem_reservation_va_mapping_reset);
> +
> +int xenmem_reservation_increase(int count, xen_pfn_t *frames)
> +{
> +	struct xen_memory_reservation reservation = {
> +		.address_bits = 0,
> +		.extent_order = EXTENT_ORDER,
> +		.domid        = DOMID_SELF
> +	};
> +
> +	set_xen_guest_handle(reservation.extent_start, frames);
> +	reservation.nr_extents = count;
> +	return HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
> +}
> +EXPORT_SYMBOL(xenmem_reservation_increase);
> +
> +int xenmem_reservation_decrease(int count, xen_pfn_t *frames)
> +{
> +	struct xen_memory_reservation reservation = {
> +		.address_bits = 0,
> +		.extent_order = EXTENT_ORDER,
> +		.domid        = DOMID_SELF
> +	};
> +
> +	set_xen_guest_handle(reservation.extent_start, frames);
> +	reservation.nr_extents = count;
> +	return HYPERVISOR_memory_op(XENMEM_decrease_reservation, &reservation);
> +}
> +EXPORT_SYMBOL(xenmem_reservation_decrease);
> diff --git a/include/xen/mem_reservation.h b/include/xen/mem_reservation.h
> new file mode 100644
> index 000000000000..9306d9b8743c
> --- /dev/null
> +++ b/include/xen/mem_reservation.h
> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR MIT */

and here too.


-boris


> +
> +/*
> + * Xen memory reservation utilities.
> + *
> + * Copyright (c) 2003, B Dragovic
> + * Copyright (c) 2003-2004, M Williamson, K Fraser
> + * Copyright (c) 2005 Dan M. Smith, IBM Corporation
> + * Copyright (c) 2010 Daniel Kiper
> + * Copyright (c) 2018, Oleksandr Andrushchenko, EPAM Systems Inc.
> + */
> +
> +#ifndef _XENMEM_RESERVATION_H
> +#define _XENMEM_RESERVATION_H
> +
> +void xenmem_reservation_scrub_page(struct page *page);
> +
> +void xenmem_reservation_va_mapping_update(unsigned long count,
> +					  struct page **pages,
> +					  xen_pfn_t *frames);
> +
> +void xenmem_reservation_va_mapping_reset(unsigned long count,
> +					 struct page **pages);
> +
> +int xenmem_reservation_increase(int count, xen_pfn_t *frames);
> +
> +int xenmem_reservation_decrease(int count, xen_pfn_t *frames);
> +
> +#endif
