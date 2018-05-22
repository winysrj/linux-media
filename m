Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34972 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbeEVS1r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 14:27:47 -0400
Subject: Re: [Xen-devel] [RFC 1/3] xen/balloon: Allow allocating DMA buffers
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Oleksandr_Andrushchenko@epam.com" <Oleksandr_Andrushchenko@epam.com>,
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
 <f87478c7-3523-851c-5c3a-12a9e8753bb6@epam.com>
 <c2f0845b-ab2f-4b9b-6f46-6ddd236ad9ed@oracle.com>
 <77c20852-b9b8-c35a-26b0-b0317e6aba09@gmail.com>
 <f8775649-34eb-04ac-2264-609b33cdd504@oracle.com>
 <2a88de28-27ef-8fe4-ddc1-35eb9e698567@gmail.com>
 <afe3a9ba-ab50-5872-e044-9d8cf7034e70@oracle.com>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <533ca735-333b-8403-85f7-d17794ea97ca@gmail.com>
Date: Tue, 22 May 2018 21:27:42 +0300
MIME-Version: 1.0
In-Reply-To: <afe3a9ba-ab50-5872-e044-9d8cf7034e70@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/22/2018 09:02 PM, Boris Ostrovsky wrote:
> On 05/22/2018 11:00 AM, Oleksandr Andrushchenko wrote:
>> On 05/22/2018 05:33 PM, Boris Ostrovsky wrote:
>>> On 05/22/2018 01:55 AM, Oleksandr Andrushchenko wrote:
>>>> On 05/21/2018 11:36 PM, Boris Ostrovsky wrote:
>>>>> On 05/21/2018 03:13 PM, Oleksandr Andrushchenko wrote:
>>>>>> On 05/21/2018 09:53 PM, Boris Ostrovsky wrote:
>>>>>>> On 05/21/2018 01:32 PM, Oleksandr Andrushchenko wrote:
>>>>>>>> On 05/21/2018 07:35 PM, Boris Ostrovsky wrote:
>>>>>>>>> On 05/21/2018 01:40 AM, Oleksandr Andrushchenko wrote:
>>>>>>>>>> On 05/19/2018 01:04 AM, Boris Ostrovsky wrote:
>>>>>>>>>>> On 05/17/2018 04:26 AM, Oleksandr Andrushchenko wrote:
>>>>>>>>>>>> From: Oleksandr Andrushchenko
>>>>>>>>>>>> <oleksandr_andrushchenko@epam.com>
>>>>>>>>>>> A commit message would be useful.
>>>>>>>>>> Sure, v1 will have it
>>>>>>>>>>>> Signed-off-by: Oleksandr Andrushchenko
>>>>>>>>>>>> <oleksandr_andrushchenko@epam.com>
>>>>>>>>>>>>
>>>>>>>>>>>>            for (i = 0; i < nr_pages; i++) {
>>>>>>>>>>>> -        page = alloc_page(gfp);
>>>>>>>>>>>> -        if (page == NULL) {
>>>>>>>>>>>> -            nr_pages = i;
>>>>>>>>>>>> -            state = BP_EAGAIN;
>>>>>>>>>>>> -            break;
>>>>>>>>>>>> +        if (ext_pages) {
>>>>>>>>>>>> +            page = ext_pages[i];
>>>>>>>>>>>> +        } else {
>>>>>>>>>>>> +            page = alloc_page(gfp);
>>>>>>>>>>>> +            if (page == NULL) {
>>>>>>>>>>>> +                nr_pages = i;
>>>>>>>>>>>> +                state = BP_EAGAIN;
>>>>>>>>>>>> +                break;
>>>>>>>>>>>> +            }
>>>>>>>>>>>>                }
>>>>>>>>>>>>                scrub_page(page);
>>>>>>>>>>>>                list_add(&page->lru, &pages);
>>>>>>>>>>>> @@ -529,7 +565,7 @@ static enum bp_state
>>>>>>>>>>>> decrease_reservation(unsigned long nr_pages, gfp_t gfp)
>>>>>>>>>>>>            i = 0;
>>>>>>>>>>>>            list_for_each_entry_safe(page, tmp, &pages, lru) {
>>>>>>>>>>>>                /* XENMEM_decrease_reservation requires a GFN */
>>>>>>>>>>>> -        frame_list[i++] = xen_page_to_gfn(page);
>>>>>>>>>>>> +        frames[i++] = xen_page_to_gfn(page);
>>>>>>>>>>>>          #ifdef CONFIG_XEN_HAVE_PVMMU
>>>>>>>>>>>>                /*
>>>>>>>>>>>> @@ -552,18 +588,22 @@ static enum bp_state
>>>>>>>>>>>> decrease_reservation(unsigned long nr_pages, gfp_t gfp)
>>>>>>>>>>>>        #endif
>>>>>>>>>>>>                list_del(&page->lru);
>>>>>>>>>>>>        -        balloon_append(page);
>>>>>>>>>>>> +        if (!ext_pages)
>>>>>>>>>>>> +            balloon_append(page);
>>>>>>>>>>> So what you are proposing is not really ballooning. You are just
>>>>>>>>>>> piggybacking on existing interfaces, aren't you?
>>>>>>>>>> Sort of. Basically I need to {increase|decrease}_reservation, not
>>>>>>>>>> actually
>>>>>>>>>> allocating ballooned pages.
>>>>>>>>>> Do you think I can simply EXPORT_SYMBOL for
>>>>>>>>>> {increase|decrease}_reservation?
>>>>>>>>>> Any other suggestion?
>>>>>>>>> I am actually wondering how much of that code you end up reusing.
>>>>>>>>> You
>>>>>>>>> pretty much create new code paths in both routines and common code
>>>>>>>>> ends
>>>>>>>>> up being essentially the hypercall.
>>>>>>>> Well, I hoped that it would be easier to maintain if I modify
>>>>>>>> existing
>>>>>>>> code
>>>>>>>> to support both use-cases, but I am also ok to create new
>>>>>>>> routines if
>>>>>>>> this
>>>>>>>> seems to be reasonable - please let me know
>>>>>>>>>       So the question is --- would it make
>>>>>>>>> sense to do all of this separately from the balloon driver?
>>>>>>>> This can be done, but which driver will host this code then? If we
>>>>>>>> move from
>>>>>>>> the balloon driver, then this could go to either gntdev or
>>>>>>>> grant-table.
>>>>>>>> What's your preference?
>>>>>>> A separate module?
>>>>>>> Is there any use for this feature outside of your zero-copy DRM
>>>>>>> driver?
>>>>>> Intel's hyper dma-buf (Dongwon/Matt CC'ed), V4L/GPU at least.
>>>>>>
>>>>>> At the time I tried to upstream zcopy driver it was discussed and
>>>>>> decided that
>>>>>> it would be better if I remove all DRM specific code and move it to
>>>>>> Xen drivers.
>>>>>> Thus, this RFC.
>>>>>>
>>>>>> But it can also be implemented as a dedicated Xen dma-buf driver
>>>>>> which
>>>>>> will have all the
>>>>>> code from this RFC + a bit more (char/misc device handling at least).
>>>>>> This will also require a dedicated user-space library, just like
>>>>>> libxengnttab.so
>>>>>> for gntdev (now I have all new IOCTLs covered there).
>>>>>>
>>>>>> If the idea of a dedicated Xen dma-buf driver seems to be more
>>>>>> attractive we
>>>>>> can work toward this solution. BTW, I do support this idea, but
>>>>>> was not
>>>>>> sure if Xen community accepts yet another driver which duplicates
>>>>>> quite some code
>>>>>> of the existing gntdev/balloon/grant-table. And now after this RFC I
>>>>>> hope that all cons
>>>>>> and pros of both dedicated driver and gntdev/balloon/grant-table
>>>>>> extension are
>>>>>> clearly seen and we can make a decision.
>>>>> IIRC the objection for a separate module was in the context of gntdev
>>>>> was discussion, because (among other things) people didn't want to
>>>>> have
>>>>> yet another file in /dev/xen/
>>>>>
>>>>> Here we are talking about (a new) balloon-like module which doesn't
>>>>> create any new user-visible interfaces. And as for duplicating code
>>>>> ---
>>>>> as I said, I am not convinced there is much of duplication.
>>>>>
>>>>> I might even argue that we should add a new config option for this
>>>>> module.
>>>> I am not quite sure I am fully following you here: so, you suggest
>>>> that we have balloon.c unchanged, but instead create a new
>>>> module (namely a file under the same folder as balloon.c, e.g.
>>>> dma-buf-reservation.c) and move those {increase|decrease}_reservation
>>>> routines (specific to dma-buf) to that new file? And make it selectable
>>>> via Kconfig? If so, then how about the changes to grant-table and
>>>> gntdev?
>>>> Those will look inconsistent then.
>>> Inconsistent with what? The changes to grant code will also be under the
>>> new config option.
>> Ah, ok.
>>
>> Option 1. We will have Kconfig option which will cover dma-buf
>> changes in balloon,
> I really don't think your changes to balloon driver belong there. The
> have nothing to do with ballooning,
>
>> grant-table and gntdev. And for that we will
>> create dedicated routines in balloon and grant-table (copy of
>> the existing ones, but modified to fit dma-buf use-case) and
>> those under something like "#if CONFIG_XEN_DMABUF"?
>> This is relatively easy to do for balloon/grant-table, but not that
>> easy for gntdev: there still seems to be lots of code which can be
>> reused,
>> so I'll have to put lots of "#if CONFIG_XEN_DMABUF" there. Even more,
>> I change
>> interfaces of the existing gntdev routines which won't look cute with
>> #if's, IMO.
>>
>> Option 2. Try moving dma-buf related changes from balloon and
>> grant-table to a new file. Then gntdev's Kconfig concerns from above
>> will still
>> be there, but balloon/grant-table functionality will be localized in a
>> new module.
> I don't see a problem with leaving your code (from patch 2) where it is
> now, in grant table. It's a small change and it seems to me a single
> #ifdef/#endif would cover it, even if you factor out common code there
> as we've discussed. To my eye it logically belongs there. Just like your
> gntdev changes belong to gntdev file. (Presumably, because I haven't
> actually looked at them ;-))
>
> So my suggestion is
> - separate module for your changes in balloon.c
Ok, so, basically, the changes I need from the balloon driver is
{increase|decrease}_reservation and DMAable memory allocations, so
I'll move that into a separate file: what could be the name for such a file?

> - keep grant-table changes, with config option
Can we consider moving ex-balloon code into grant-table?

> - keep gntdev changes, with config option.
I'll try to see what happens to gntdev with Kconfig option wrt function 
prototype
changes. I also have to check if UAPI of gntdev can also support 
CONFIG_XXX ifdefs
w/o problems - do you by chance know if #if CONFIG_ is ok for UAPI files?
Or I can leave UAPI as is and ifdef in .ioctl callback.
>   (but when you get to post
> actual patches I would appreciate if you could split this into a series
> of logical changes and not post a one giant patch).
Of course, as this is at RFC stage the idea was to roll out all the 
changes at once, so
everyone has the full picture and don't need to collect changes from set 
of patches.
>
> -boris
>
Thank you,
Oleksandr
>> I am still missing your point here?
>>
>>>> If you suggest a new kernel driver module:
>>>> IMO, there is nothing bad if we create a dedicated kernel module
>>>> (driver) for Xen dma-buf handling selectable under Kconfig option.
>>>> Yes, this will create a yet another device under /dev/xen,
>>>> but most people will never see it if we set Kconfig to default to "n".
>>>> And then we'll need user-space support for that, so Xen tools will
>>>> be extended with libxendmabuf.so or so.
>>>> This way all Xen dma-buf support can be localized at one place which
>>>> might be easier to maintain. What is more it could be totally
>>>> transparent
>>>> to most of us as Kconfig option won't be set by default (both kernel
>>>> and Xen).
>>> The downside is that we will end up having another device for doing
>>> things that are not that different from what we are already doing with
>>> existing gnttab device. Or are they?
>> Agree, but Kconfig option, IMO, won't make it look nice because
>> of gntdev changes and code reuse.
>>> -boris
>> Thank you,
>> Oleksandr
>>
>> _______________________________________________
>> Xen-devel mailing list
>> Xen-devel@lists.xenproject.org
>> https://lists.xenproject.org/mailman/listinfo/xen-devel
