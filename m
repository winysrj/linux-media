Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:38863 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932205AbeFFHYK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 03:24:10 -0400
Subject: Re: [PATCH v2 3/9] xen/balloon: Share common memory reservation
 routines
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180601114132.22596-1-andr2000@gmail.com>
 <20180601114132.22596-4-andr2000@gmail.com>
 <4fd46fd8-f936-1514-06e4-34c5d3ed8960@oracle.com>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <05e361c2-c7f3-2f57-908c-e2c9b98b18e7@gmail.com>
Date: Wed, 6 Jun 2018 10:24:06 +0300
MIME-Version: 1.0
In-Reply-To: <4fd46fd8-f936-1514-06e4-34c5d3ed8960@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/04/2018 07:37 PM, Boris Ostrovsky wrote:
> On 06/01/2018 07:41 AM, Oleksandr Andrushchenko wrote:
>> diff --git a/include/xen/mem-reservation.h b/include/xen/mem-reservation.h
>> new file mode 100644
>> index 000000000000..a727d65a1e61
>> --- /dev/null
>> +++ b/include/xen/mem-reservation.h
>> @@ -0,0 +1,65 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +
>> +/*
>> + * Xen memory reservation utilities.
>> + *
>> + * Copyright (c) 2003, B Dragovic
>> + * Copyright (c) 2003-2004, M Williamson, K Fraser
>> + * Copyright (c) 2005 Dan M. Smith, IBM Corporation
>> + * Copyright (c) 2010 Daniel Kiper
>> + * Copyright (c) 2018 Oleksandr Andrushchenko, EPAM Systems Inc.
>> + */
>> +
>> +#ifndef _XENMEM_RESERVATION_H
>> +#define _XENMEM_RESERVATION_H
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/slab.h>
>> +
>> +#include <asm/xen/hypercall.h>
>> +#include <asm/tlb.h>
>> +
>> +#include <xen/interface/memory.h>
>> +#include <xen/page.h>
>> +
>> +#ifdef CONFIG_XEN_SCRUB_PAGES
>> +void xenmem_reservation_scrub_page(struct page *page);
>> +#else
>> +static inline void xenmem_reservation_scrub_page(struct page *page)
>> +{
>> +}
>> +#endif
>
> Given that this is a wrapper around a single call I'd prefer
>
> inline void xenmem_reservation_scrub_page(struct page *page)
> {
> #ifdef CONFIG_XEN_SCRUB_PAGES
>      clear_highpage(page);
> #endif
> }
Unfortunately this can't be done because of
EXPORT_SYMBOL_GPL(xenmem_reservation_scrub_page);
which is obviously cannot be used for static inline functions.
So, I'll keep it as is.
>
>
> -boris
>
>
Thank you,
Oleksandr
