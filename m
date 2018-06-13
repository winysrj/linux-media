Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-he1eur01on0069.outbound.protection.outlook.com ([104.47.0.69]:29563
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935365AbeFMMDY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 08:03:24 -0400
Subject: Re: [PATCH v3 3/9] xen/balloon: Share common memory reservation
 routines
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com
References: <20180612134200.17456-1-andr2000@gmail.com>
 <20180612134200.17456-4-andr2000@gmail.com>
 <d63f0cf5-5154-f2a3-155e-fdb6dd0959e2@oracle.com>
 <cbaeec5c-0d69-881c-2b42-54855e53015a@epam.com>
 <b79713a9-3a2d-6465-3b22-622bfb7a4d3e@oracle.com>
From: Oleksandr Andrushchenko <Oleksandr_Andrushchenko@epam.com>
Message-ID: <cceefb52-d1bf-c6cd-1b73-489015602f57@epam.com>
Date: Wed, 13 Jun 2018 15:03:15 +0300
MIME-Version: 1.0
In-Reply-To: <b79713a9-3a2d-6465-3b22-622bfb7a4d3e@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/2018 03:02 PM, Boris Ostrovsky wrote:
>
>
> On 06/13/2018 02:26 AM, Oleksandr Andrushchenko wrote:
>> On 06/13/2018 03:47 AM, Boris Ostrovsky wrote:
>>>
>>>
>>> On 06/12/2018 09:41 AM, Oleksandr Andrushchenko wrote:
>>>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>>
>>>> diff --git a/include/xen/mem-reservation.h 
>>>> b/include/xen/mem-reservation.h
>>>> new file mode 100644
>>>> index 000000000000..e0939387278d
>>>> --- /dev/null
>>>> +++ b/include/xen/mem-reservation.h
>>>> @@ -0,0 +1,64 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>>> +
>>>> +/*
>>>> + * Xen memory reservation utilities.
>>>> + *
>>>> + * Copyright (c) 2003, B Dragovic
>>>> + * Copyright (c) 2003-2004, M Williamson, K Fraser
>>>> + * Copyright (c) 2005 Dan M. Smith, IBM Corporation
>>>> + * Copyright (c) 2010 Daniel Kiper
>>>> + * Copyright (c) 2018 Oleksandr Andrushchenko, EPAM Systems Inc.
>>>> + */
>>>> +
>>>> +#ifndef _XENMEM_RESERVATION_H
>>>> +#define _XENMEM_RESERVATION_H
>>>> +
>>>> +#include <linux/kernel.h>
>>>> +#include <linux/slab.h>
>>>> +
>>>> +#include <asm/xen/hypercall.h>
>>>> +#include <asm/tlb.h>
>>>> +
>>>> +#include <xen/interface/memory.h>
>>>> +#include <xen/page.h>
>>>
>>>
>>> I should have noticed this in the previous post but I suspect most 
>>> of these includes belong in the C file. For example, there is no 
>>> reason for hypercall.h here.
>>>
>> Yes, it seems that the header can only have
>> #include <xen/page.h>
>> Will move the rest into the .c file
>
>
> You may need something for clear_highpage() and maybe for Xen feature 
> flags. But you'll find out for sure when you try to build. ;-)
>
#include <asm/tlb.h>

;)
> -boris
>
>
>
>>> -boris
>>>
>>>
>>>> +
>>>> +static inline void xenmem_reservation_scrub_page(struct page *page)
>>>> +{
>>>> +#ifdef CONFIG_XEN_SCRUB_PAGES
>>>> +    clear_highpage(page);
>>>> +#endif
>>>> +}
>>>> +
>>>> +#ifdef CONFIG_XEN_HAVE_PVMMU
>>>> +void __xenmem_reservation_va_mapping_update(unsigned long count,
>>>> +                        struct page **pages,
>>>> +                        xen_pfn_t *frames);
>>>> +
>>>> +void __xenmem_reservation_va_mapping_reset(unsigned long count,
>>>> +                       struct page **pages);
>>>> +#endif
>>>> +
>>>> +static inline void xenmem_reservation_va_mapping_update(unsigned 
>>>> long count,
>>>> +                            struct page **pages,
>>>> +                            xen_pfn_t *frames)
>>>> +{
>>>> +#ifdef CONFIG_XEN_HAVE_PVMMU
>>>> +    if (!xen_feature(XENFEAT_auto_translated_physmap))
>>>> +        __xenmem_reservation_va_mapping_update(count, pages, frames);
>>>> +#endif
>>>> +}
>>>> +
>>>> +static inline void xenmem_reservation_va_mapping_reset(unsigned 
>>>> long count,
>>>> +                               struct page **pages)
>>>> +{
>>>> +#ifdef CONFIG_XEN_HAVE_PVMMU
>>>> +    if (!xen_feature(XENFEAT_auto_translated_physmap))
>>>> +        __xenmem_reservation_va_mapping_reset(count, pages);
>>>> +#endif
>>>> +}
>>>> +
>>>> +int xenmem_reservation_increase(int count, xen_pfn_t *frames);
>>>> +
>>>> +int xenmem_reservation_decrease(int count, xen_pfn_t *frames);
>>>> +
>>>> +#endif
>>>>
>>
