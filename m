Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60212 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965725AbeE2SVs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 14:21:48 -0400
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
Message-ID: <44f62fb1-e013-2883-dfa1-386c7a96784b@oracle.com>
Date: Tue, 29 May 2018 14:24:49 -0400
MIME-Version: 1.0
In-Reply-To: <20180525153331.31188-3-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/25/2018 11:33 AM, Oleksandr Andrushchenko wrote:
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

One other thing I noticed --- both of these can be declared as NOPs in
the header file if !CONFIG_XEN_HAVE_PVMMU.

-boris
