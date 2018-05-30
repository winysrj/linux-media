Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36490 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753836AbeE3PRo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 11:17:44 -0400
Subject: Re: [PATCH 3/8] xen/grant-table: Allow allocating buffers suitable
 for DMA
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180525153331.31188-1-andr2000@gmail.com>
 <20180525153331.31188-4-andr2000@gmail.com>
 <94de6bd7-405c-c43f-0468-be71efff7552@oracle.com>
 <c2f9f6b4-03bd-225b-a42d-b071958dd899@gmail.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <ab1b28b8-02b1-3501-801c-d4f523ab829f@oracle.com>
Date: Wed, 30 May 2018 11:20:41 -0400
MIME-Version: 1.0
In-Reply-To: <c2f9f6b4-03bd-225b-a42d-b071958dd899@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/30/2018 02:34 AM, Oleksandr Andrushchenko wrote:
> On 05/29/2018 10:10 PM, Boris Ostrovsky wrote:
>> On 05/25/2018 11:33 AM, Oleksandr Andrushchenko wrote:

>> +/**
>> + * gnttab_dma_free_pages - free DMAable pages
>> + * @args: arguments to the function
>> + */
>> +int gnttab_dma_free_pages(struct gnttab_dma_alloc_args *args)
>> +{
>> +    xen_pfn_t *frames;
>> +    size_t size;
>> +    int i, ret;
>> +
>> +    gnttab_pages_clear_private(args->nr_pages, args->pages);
>> +
>> +    frames = kcalloc(args->nr_pages, sizeof(*frames), GFP_KERNEL);
>>
>> Any way you can do it without allocating memory? One possibility is to
>> keep allocated frames from gnttab_dma_alloc_pages(). (Not sure I like
>> that either but it's the only thing I can think of).
> Yes, I was also thinking about storing the allocated frames array from
> gnttab_dma_alloc_pages(), but that seemed not to be clear enough as
> the caller of the gnttab_dma_alloc_pages will need to store those frames
> in some context, so we can pass them on free. But the caller doesn't
> really
> need the frames which might confuse, so I decided to make those
> allocations
> on the fly.
> But I can still rework that to store the frames if you insist: please
> let me know.


I would prefer not to allocate anything in the release path. Yes, I
realize that dragging frames array around is not necessary but IMO it's
better than potentially failing an allocation during a teardown. A
comment in the struct definition could explain the reason for having
this field.


>>
>>
>>> +    if (!frames)
>>> +        return -ENOMEM;
>>> +
>>> +    for (i = 0; i < args->nr_pages; i++)
>>> +        frames[i] = page_to_xen_pfn(args->pages[i]);
>>
>> Not xen_page_to_gfn()?
> Well, according to [1] it should be :
>     /* XENMEM_populate_physmap requires a PFN based on Xen
>      * granularity.
>      */
>     frame_list[i] = page_to_xen_pfn(page);


Ah, yes. I was looking at decrease_reservation and automatically assumed
the same parameter type.


-boris
