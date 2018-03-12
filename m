Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:34225 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750811AbeCLTPn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Mar 2018 15:15:43 -0400
Received: by mail-wm0-f47.google.com with SMTP id a20so14826075wmd.1
        for <linux-media@vger.kernel.org>; Mon, 12 Mar 2018 12:15:42 -0700 (PDT)
Reply-To: christian.koenig@amd.com
Subject: Re: RFC: unpinned DMA-buf exporting
To: Daniel Vetter <daniel@ffwll.ch>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
References: <20180309191144.1817-1-christian.koenig@amd.com>
 <20180312172401.GM8589@phenom.ffwll.local>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <e4b847f4-f6e7-6284-eaec-6bd3e1945c2d@gmail.com>
Date: Mon, 12 Mar 2018 20:15:40 +0100
MIME-Version: 1.0
In-Reply-To: <20180312172401.GM8589@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 12.03.2018 um 18:24 schrieb Daniel Vetter:
> On Fri, Mar 09, 2018 at 08:11:40PM +0100, Christian K??nig wrote:
>> This set of patches adds an option invalidate_mappings callback to each
>> DMA-buf attachment which can be filled in by the importer.
>>
>> This callback allows the exporter to provided the DMA-buf content
>> without pinning it. The reservation objects lock acts as synchronization
>> point for buffer moves and creating mappings.
>>
>> This set includes an implementation for amdgpu which should be rather
>> easily portable to other DRM drivers.
> Bunch of higher level comments, and one I've forgotten in reply to patch
> 1:
>
> - What happens when a dma-buf is pinned (e.g. i915 loves to pin buffers
>    for scanout)?

When you need to pin an imported DMA-buf you need to detach and reattach 
without the invalidate_mappings callback.

> - pulling the dma-buf implementations into amdgpu makes sense, that's
>    kinda how it was meant to be anyway. The gem prime helpers are a bit too
>    much midlayer for my taste (mostly because nvidia wanted to bypass the
>    EXPORT_SYMBOL_GPL of core dma-buf, hooray for legal bs). We can always
>    extract more helpers once there's more ttm based drivers doing this.

Yeah, I though to abstract that similar to the AGP backend.

Just moving some callbacks around in TTM should be sufficient to 
de-midlayer the whole thing.

Thanks,
Christian.

>
> Overall I like, there's some details to figure out first.
> -Daniel
