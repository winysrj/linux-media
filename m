Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52322 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753667AbeE3TV1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 15:21:27 -0400
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
 <59ab73b0-967b-a82f-3b0d-95f1b0dc40a5@oracle.com>
 <89de7bdb-8759-419f-63bf-8ed0d57650f0@gmail.com>
 <edfa937b-3311-98db-2e6f-b4083598f796@oracle.com>
 <6ca7f428-eede-2c14-85fe-da4a20bcea0d@gmail.com>
 <5dd3378d-ac32-691e-1f80-7218a5d07fd6@oracle.com>
 <43c17501-8865-6e1f-1a92-d947755d8fa8@gmail.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <c08c380d-17af-b668-acf2-8d8a94333aca@oracle.com>
Date: Wed, 30 May 2018 15:24:13 -0400
MIME-Version: 1.0
In-Reply-To: <43c17501-8865-6e1f-1a92-d947755d8fa8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/30/2018 01:46 PM, Oleksandr Andrushchenko wrote:
> On 05/30/2018 06:54 PM, Boris Ostrovsky wrote:
>>
>>
>> BTW, I also think you can further simplify
>> xenmem_reservation_va_mapping_* routines by bailing out right away if
>> xen_feature(XENFEAT_auto_translated_physmap). In fact, you might even
>> make them inlines, along the lines of
>>
>> inline void xenmem_reservation_va_mapping_reset(unsigned long count,
>>                      struct page **pages)
>> {
>> #ifdef CONFIG_XEN_HAVE_PVMMU
>>     if (!xen_feature(XENFEAT_auto_translated_physmap))
>>         __xenmem_reservation_va_mapping_reset(...)
>> #endif
>> }
> How about:
>
> #ifdef CONFIG_XEN_HAVE_PVMMU
> static inline __xenmem_reservation_va_mapping_reset(struct page *page)
> {
> [...]
> }
> #endif
>
> and
>
> void xenmem_reservation_va_mapping_reset(unsigned long count,
>                      struct page **pages)
> {
> #ifdef CONFIG_XEN_HAVE_PVMMU
>     if (!xen_feature(XENFEAT_auto_translated_physmap)) {
>         int i;
>
>         for (i = 0; i < count; i++)
>             __xenmem_reservation_va_mapping_reset(pages[i]);
>     }
> #endif
> }
>
> This way I can use __xenmem_reservation_va_mapping_reset(page);
> instead of xenmem_reservation_va_mapping_reset(1, &page);


Sure, this also works.

-boris
