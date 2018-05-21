Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db5eur01on0068.outbound.protection.outlook.com ([104.47.2.68]:23488
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750773AbeEUTOA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 15:14:00 -0400
Subject: Re: [Xen-devel] [RFC 1/3] xen/balloon: Allow allocating DMA buffers
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, matthew.d.roper@intel.com,
        dongwon.kim@intel.com
References: <20180517082604.14828-1-andr2000@gmail.com>
 <20180517082604.14828-2-andr2000@gmail.com>
 <6a108876-19b7-49d0-3de2-9e10f984736c@oracle.com>
 <9541926e-001a-e41e-317c-dbff6d687761@gmail.com>
 <218e2bf7-490d-f89e-9866-27b7e3dbc835@oracle.com>
 <a08e7d0d-f7d5-6b7e-979b-8a17060482f0@gmail.com>
 <b177a327-6a73-bb77-c69b-bc0958a05532@oracle.com>
From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Message-ID: <f87478c7-3523-851c-5c3a-12a9e8753bb6@epam.com>
Date: Mon, 21 May 2018 22:13:14 +0300
MIME-Version: 1.0
In-Reply-To: <b177a327-6a73-bb77-c69b-bc0958a05532@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/21/2018 09:53 PM, Boris Ostrovsky wrote:
> On 05/21/2018 01:32 PM, Oleksandr Andrushchenko wrote:
>> On 05/21/2018 07:35 PM, Boris Ostrovsky wrote:
>>> On 05/21/2018 01:40 AM, Oleksandr Andrushchenko wrote:
>>>> On 05/19/2018 01:04 AM, Boris Ostrovsky wrote:
>>>>> On 05/17/2018 04:26 AM, Oleksandr Andrushchenko wrote:
>>>>>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>>>> A commit message would be useful.
>>>> Sure, v1 will have it
>>>>>> Signed-off-by: Oleksandr Andrushchenko
>>>>>> <oleksandr_andrushchenko@epam.com>
>>>>>>
>>>>>>         for (i = 0; i < nr_pages; i++) {
>>>>>> -        page = alloc_page(gfp);
>>>>>> -        if (page == NULL) {
>>>>>> -            nr_pages = i;
>>>>>> -            state = BP_EAGAIN;
>>>>>> -            break;
>>>>>> +        if (ext_pages) {
>>>>>> +            page = ext_pages[i];
>>>>>> +        } else {
>>>>>> +            page = alloc_page(gfp);
>>>>>> +            if (page == NULL) {
>>>>>> +                nr_pages = i;
>>>>>> +                state = BP_EAGAIN;
>>>>>> +                break;
>>>>>> +            }
>>>>>>             }
>>>>>>             scrub_page(page);
>>>>>>             list_add(&page->lru, &pages);
>>>>>> @@ -529,7 +565,7 @@ static enum bp_state
>>>>>> decrease_reservation(unsigned long nr_pages, gfp_t gfp)
>>>>>>         i = 0;
>>>>>>         list_for_each_entry_safe(page, tmp, &pages, lru) {
>>>>>>             /* XENMEM_decrease_reservation requires a GFN */
>>>>>> -        frame_list[i++] = xen_page_to_gfn(page);
>>>>>> +        frames[i++] = xen_page_to_gfn(page);
>>>>>>       #ifdef CONFIG_XEN_HAVE_PVMMU
>>>>>>             /*
>>>>>> @@ -552,18 +588,22 @@ static enum bp_state
>>>>>> decrease_reservation(unsigned long nr_pages, gfp_t gfp)
>>>>>>     #endif
>>>>>>             list_del(&page->lru);
>>>>>>     -        balloon_append(page);
>>>>>> +        if (!ext_pages)
>>>>>> +            balloon_append(page);
>>>>> So what you are proposing is not really ballooning. You are just
>>>>> piggybacking on existing interfaces, aren't you?
>>>> Sort of. Basically I need to {increase|decrease}_reservation, not
>>>> actually
>>>> allocating ballooned pages.
>>>> Do you think I can simply EXPORT_SYMBOL for
>>>> {increase|decrease}_reservation?
>>>> Any other suggestion?
>>> I am actually wondering how much of that code you end up reusing. You
>>> pretty much create new code paths in both routines and common code ends
>>> up being essentially the hypercall.
>> Well, I hoped that it would be easier to maintain if I modify existing
>> code
>> to support both use-cases, but I am also ok to create new routines if
>> this
>> seems to be reasonable - please let me know
>>>    So the question is --- would it make
>>> sense to do all of this separately from the balloon driver?
>> This can be done, but which driver will host this code then? If we
>> move from
>> the balloon driver, then this could go to either gntdev or grant-table.
>> What's your preference?
> A separate module?

> Is there any use for this feature outside of your zero-copy DRM driver?
Intel's hyper dma-buf (Dongwon/Matt CC'ed), V4L/GPU at least.

At the time I tried to upstream zcopy driver it was discussed and 
decided that
it would be better if I remove all DRM specific code and move it to Xen 
drivers.
Thus, this RFC.

But it can also be implemented as a dedicated Xen dma-buf driver which 
will have all the
code from this RFC + a bit more (char/misc device handling at least).
This will also require a dedicated user-space library, just like 
libxengnttab.so
for gntdev (now I have all new IOCTLs covered there).

If the idea of a dedicated Xen dma-buf driver seems to be more attractive we
can work toward this solution. BTW, I do support this idea, but was not
sure if Xen community accepts yet another driver which duplicates quite 
some code
of the existing gntdev/balloon/grant-table. And now after this RFC I 
hope that all cons
and pros of both dedicated driver and gntdev/balloon/grant-table 
extension are
clearly seen and we can make a decision.

>
> -boris
Thank you,
Oleksandr
[1] https://lists.freedesktop.org/archives/dri-devel/2018-April/173163.html
