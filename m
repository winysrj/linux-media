Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:39464 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752246AbeC0IGI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 04:06:08 -0400
Received: by mail-wm0-f65.google.com with SMTP id f125so19863717wme.4
        for <linux-media@vger.kernel.org>; Tue, 27 Mar 2018 01:06:07 -0700 (PDT)
Reply-To: christian.koenig@amd.com
Subject: Re: [Linaro-mm-sig] [PATCH 1/5] dma-buf: add optional
 invalidate_mappings callback v2
To: Daniel Vetter <daniel@ffwll.ch>, christian.koenig@amd.com
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Jerome Glisse <j.glisse@gmail.com>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
References: <19ed21a5-805d-271f-9120-49e0c00f510f@amd.com>
 <20180320140810.GU14155@phenom.ffwll.local>
 <37ba7394-2a5c-a0bc-cc51-c8a0edc2991d@gmail.com>
 <20180321082839.GA14155@phenom.ffwll.local>
 <327c4bc1-5813-16e8-62fc-4301b19a1a22@gmail.com>
 <20180322071804.GH14155@phenom.ffwll.local>
 <ef9fa9a2-c368-1fca-a8ac-8ee8d522b6ab@gmail.com>
 <20180326080121.GO14155@phenom.ffwll.local>
 <20180326154224.GA11930@gmail.com>
 <f8ff3993-6605-4f8e-5ac2-c40f0450c1c6@gmail.com>
 <20180327075334.GK14155@phenom.ffwll.local>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <71f3f0cc-263d-bf60-aff8-6f2277884aaf@gmail.com>
Date: Tue, 27 Mar 2018 10:06:04 +0200
MIME-Version: 1.0
In-Reply-To: <20180327075334.GK14155@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 27.03.2018 um 09:53 schrieb Daniel Vetter:
> [SNIP]
>>> [SNIP]
>>> A slightly better solution is using atomic counter:
>>>     driver_range_start() {
>>>       atomic_inc(&mydev->notifier_count);
>> ...
>>
>> Yeah, that is exactly what amdgpu is doing now. Sorry if my description
>> didn't made that clear.
>>
>>> I would like to see driver using same code, as it means one place to fix
>>> issues. I had for a long time on my TODO list doing the above conversion
>>> to amd or radeon kernel driver. I am pushing up my todo list hopefully in
>>> next few weeks i can send an rfc so people can have a real sense of how
>>> it can look.
>> Certainly a good idea, but I think we might have that separate to HMM.
>>
>> TTM suffered really from feature overload, e.g. trying to do everything in a
>> single subsystem. And it would be rather nice to have coherent userptr
>> handling for GPUs as separate feature.
> TTM suffered from being a midlayer imo, not from doing too much.

Yeah, completely agree.

midlayers work as long as you concentrate on doing exactly one things in 
your midlayer. E.g. in the case of TTM the callback for BO move handling 
is well justified.

Only all the stuff around it like address space handling etc... is 
really wrong designed and should be separated (which is exactly what DRM 
MM did, but TTM still uses this in the wrong way).

> HMM is apparently structured like a toolbox (despite its documentation claiming
> otherwise), so you can pick&choose freely.

That sounds good, but I would still have a better feeling if userptr 
handling would be separated. That avoids mangling things together again.

Christian.

> -Daniel
