Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58270 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934897AbeFMArz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 20:47:55 -0400
Subject: Re: [PATCH v3 3/9] xen/balloon: Share common memory reservation
 routines
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180612134200.17456-1-andr2000@gmail.com>
 <20180612134200.17456-4-andr2000@gmail.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <d63f0cf5-5154-f2a3-155e-fdb6dd0959e2@oracle.com>
Date: Tue, 12 Jun 2018 20:47:37 -0400
MIME-Version: 1.0
In-Reply-To: <20180612134200.17456-4-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/12/2018 09:41 AM, Oleksandr Andrushchenko wrote:
> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

> diff --git a/include/xen/mem-reservation.h b/include/xen/mem-reservation.h
> new file mode 100644
> index 000000000000..e0939387278d
> --- /dev/null
> +++ b/include/xen/mem-reservation.h
> @@ -0,0 +1,64 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +/*
> + * Xen memory reservation utilities.
> + *
> + * Copyright (c) 2003, B Dragovic
> + * Copyright (c) 2003-2004, M Williamson, K Fraser
> + * Copyright (c) 2005 Dan M. Smith, IBM Corporation
> + * Copyright (c) 2010 Daniel Kiper
> + * Copyright (c) 2018 Oleksandr Andrushchenko, EPAM Systems Inc.
> + */
> +
> +#ifndef _XENMEM_RESERVATION_H
> +#define _XENMEM_RESERVATION_H
> +
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +
> +#include <asm/xen/hypercall.h>
> +#include <asm/tlb.h>
> +
> +#include <xen/interface/memory.h>
> +#include <xen/page.h>


I should have noticed this in the previous post but I suspect most of 
these includes belong in the C file. For example, there is no reason for 
hypercall.h here.

-boris


> +
> +static inline void xenmem_reservation_scrub_page(struct page *page)
> +{
> +#ifdef CONFIG_XEN_SCRUB_PAGES
> +	clear_highpage(page);
> +#endif
> +}
> +
> +#ifdef CONFIG_XEN_HAVE_PVMMU
> +void __xenmem_reservation_va_mapping_update(unsigned long count,
> +					    struct page **pages,
> +					    xen_pfn_t *frames);
> +
> +void __xenmem_reservation_va_mapping_reset(unsigned long count,
> +					   struct page **pages);
> +#endif
> +
> +static inline void xenmem_reservation_va_mapping_update(unsigned long count,
> +							struct page **pages,
> +							xen_pfn_t *frames)
> +{
> +#ifdef CONFIG_XEN_HAVE_PVMMU
> +	if (!xen_feature(XENFEAT_auto_translated_physmap))
> +		__xenmem_reservation_va_mapping_update(count, pages, frames);
> +#endif
> +}
> +
> +static inline void xenmem_reservation_va_mapping_reset(unsigned long count,
> +						       struct page **pages)
> +{
> +#ifdef CONFIG_XEN_HAVE_PVMMU
> +	if (!xen_feature(XENFEAT_auto_translated_physmap))
> +		__xenmem_reservation_va_mapping_reset(count, pages);
> +#endif
> +}
> +
> +int xenmem_reservation_increase(int count, xen_pfn_t *frames);
> +
> +int xenmem_reservation_decrease(int count, xen_pfn_t *frames);
> +
> +#endif
> 
