Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33679 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934142AbdCLTFb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Mar 2017 15:05:31 -0400
Received: by mail-io0-f195.google.com with SMTP id f84so11567472ioj.0
        for <linux-media@vger.kernel.org>; Sun, 12 Mar 2017 12:05:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+M3ks6R=n4n54wofK7pYcWoQKUhzyWQytBO90+pRDRrAhi3ww@mail.gmail.com>
References: <1488491084-17252-1-git-send-email-labbott@redhat.com>
 <20170303132949.GC31582@dhcp22.suse.cz> <cf383b9b-3cbc-0092-a071-f120874c053c@redhat.com>
 <20170306074258.GA27953@dhcp22.suse.cz> <20170306104041.zghsicrnadoap7lp@phenom.ffwll.local>
 <20170306105805.jsq44kfxhsvazkm6@sirena.org.uk> <20170306160437.sf7bksorlnw7u372@phenom.ffwll.local>
 <CA+M3ks77Am3Fx-ZNmgeM5tCqdM7SzV7rby4Es-p2F2aOhUco9g@mail.gmail.com>
 <26bc57ae-d88f-4ea0-d666-2c1a02bf866f@redhat.com> <CA+M3ks6R=n4n54wofK7pYcWoQKUhzyWQytBO90+pRDRrAhi3ww@mail.gmail.com>
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Date: Sun, 12 Mar 2017 20:05:29 +0100
Message-ID: <CAKMK7uH9NemeM2z-tQvge_B=kABop6O7UQFK3PirpJminMCPqw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/12] Ion cleanup in preparation for moving out of staging
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: Laura Abbott <labbott@redhat.com>, Mark Brown <broonie@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Rom Lemarchand <romlem@google.com>, devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Brian Starkey <brian.starkey@arm.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 12, 2017 at 2:34 PM, Benjamin Gaignard
<benjamin.gaignard@linaro.org> wrote:
> 2017-03-09 18:38 GMT+01:00 Laura Abbott <labbott@redhat.com>:
>> On 03/09/2017 02:00 AM, Benjamin Gaignard wrote:
>>> 2017-03-06 17:04 GMT+01:00 Daniel Vetter <daniel@ffwll.ch>:
>>>> On Mon, Mar 06, 2017 at 11:58:05AM +0100, Mark Brown wrote:
>>>>> On Mon, Mar 06, 2017 at 11:40:41AM +0100, Daniel Vetter wrote:
>>>>>
>>>>>> No one gave a thing about android in upstream, so Greg KH just dumped it
>>>>>> all into staging/android/. We've discussed ION a bunch of times, recorded
>>>>>> anything we'd like to fix in staging/android/TODO, and Laura's patch
>>>>>> series here addresses a big chunk of that.
>>>>>
>>>>>> This is pretty much the same approach we (gpu folks) used to de-stage the
>>>>>> syncpt stuff.
>>>>>
>>>>> Well, there's also the fact that quite a few people have issues with the
>>>>> design (like Laurent).  It seems like a lot of them have either got more
>>>>> comfortable with it over time, or at least not managed to come up with
>>>>> any better ideas in the meantime.
>>>>
>>>> See the TODO, it has everything a really big group (look at the patch for
>>>> the full Cc: list) figured needs to be improved at LPC 2015. We don't just
>>>> merge stuff because merging stuff is fun :-)
>>>>
>>>> Laurent was even in that group ...
>>>> -Daniel
>>>
>>> For me those patches are going in the right direction.
>>>
>>> I still have few questions:
>>> - since alignment management has been remove from ion-core, should it
>>> be also removed from ioctl structure ?
>>
>> Yes, I think I'm going to go with the suggestion to fixup the ABI
>> so we don't need the compat layer and as part of that I'm also
>> dropping the align argument.
>>
>>> - can you we ride off ion_handle (at least in userland) and only
>>> export a dma-buf descriptor ?
>>
>> Yes, I think this is the right direction given we're breaking
>> everything anyway. I was debating trying to keep the two but
>> moving to only dma bufs is probably cleaner. The only reason
>> I could see for keeping the handles is running out of file
>> descriptors for dma-bufs but that seems unlikely.
>>>
>>> In the future how can we add new heaps ?
>>> Some platforms have very specific memory allocation
>>> requirements (just have a look in the number of gem custom allocator in drm)
>>> Do you plan to add heap type/mask for each ?
>>
>> Yes, that was my thinking.
>
> My concern is about the policy to adding heaps, will you accept
> "customs" heap per
> platforms ? per devices ? or only generic ones ?
> If you are too strict, we will have lot of out-of-tree heaps and if
> you accept of of them
> it will be a nightmare to maintain....

I think ion should expose any heap that's also directly accessible to
devices using dma_alloc(_coherent). That should leave very few things
left, like your SMA heap.

> Another point is how can we put secure rules (like selinux policy) on
> heaps since all the allocations
> go to the same device (/dev/ion) ? For example, until now, in Android
> we have to give the same
> access rights to all the process that use ION.
> It will become problem when we will add secure heaps because we won't
> be able to distinguish secure
> processes to standard ones or set specific policy per heaps.
> Maybe I'm wrong here but I have never see selinux policy checking an
> ioctl field but if that
> exist it could be a solution.

Hm, we might want to expose all the heaps as individual
/dev/ion_$heapname nodes? Should we do this from the start, since
we're massively revamping the uapi anyway (imo not needed, current
state seems to work too)?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
