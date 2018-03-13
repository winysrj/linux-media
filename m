Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:45908 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934309AbeCMPwF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 11:52:05 -0400
Received: by mail-wr0-f181.google.com with SMTP id h2so149495wre.12
        for <linux-media@vger.kernel.org>; Tue, 13 Mar 2018 08:52:05 -0700 (PDT)
Reply-To: christian.koenig@amd.com
Subject: Re: [PATCH 1/4] dma-buf: add optional invalidate_mappings callback
To: Daniel Vetter <daniel@ffwll.ch>, christian.koenig@amd.com
Cc: linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
References: <20180309191144.1817-1-christian.koenig@amd.com>
 <20180309191144.1817-2-christian.koenig@amd.com>
 <20180312170710.GL8589@phenom.ffwll.local>
 <f3986703-75de-4ce3-a828-1687291bb618@gmail.com>
 <20180313151721.GH4788@phenom.ffwll.local>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <2866813a-f2ab-0589-ee40-30935e59d3d7@gmail.com>
Date: Tue, 13 Mar 2018 16:52:02 +0100
MIME-Version: 1.0
In-Reply-To: <20180313151721.GH4788@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 13.03.2018 um 16:17 schrieb Daniel Vetter:
> [SNIP]
>>> I think a helper which both unmaps _and_ waits for all the fences to clear
>>> would be best, with some guarantees that it'll either fail or all the
>>> mappings _will_ be gone. The locking for that one will be hilarious, since
>>> we need to figure out dmabuf->lock vs. the reservation. I kinda prefer we
>>> throw away the dmabuf->lock and superseed it entirely by the reservation
>>> lock.
>> Big NAK on that. The whole API is asynchronously, e.g. we never block for
>> any operation to finish.
>>
>> Otherwise you run into big trouble with cross device GPU resets and stuff
>> like that.
> But how will the unmapping work then? You can't throw the sg list away
> before the dma stopped. The dma only stops once the fence is signalled.
> The importer can't call dma_buf_detach because the reservation lock is
> hogged already by the exporter trying to unmap everything.
>
> How is this supposed to work?

Even after invalidation the sg list stays alive until it is explicitly 
destroyed by the importer using dma_buf_unmap_attachment() which in turn 
is only allowed after all fences have signaled.

The implementation is in ttm_bo_pipeline_gutting(), basically we use the 
same functionality as for pipelined moves/evictions which hangs the old 
backing store on a dummy object and destroys it after all fences signaled.

While the old sg list is still about to be destroyed the importer can 
request a new sg list for the new location of the DMA-buf using 
dma_buf_map_attachment(). This new location becomes valid after the move 
fence in the reservation object is signaled.

So from the CPU point of view multiple sg list could exists at the same 
time which allows us to have a seamless transition from the old to the 
new location from the GPU point of view.

> Re GPU might cause a deadlock: Isn't that already a problem if you hold
> reservations of buffers used on other gpus, which want those reservations
> to complete the gpu reset, but that gpu reset blocks some fence that the
> reservation holder is waiting for?

Correct, that's why amdgpu and TTM tries quite hard to never wait for a 
fence while a reservation object is locked.

The only use case I haven't fixed so far is reaping deleted object 
during eviction, but that is only a matter of my free time to fix it.

> We have tons of fun with deadlocks against GPU resets, and loooooots of
> testcases, and I kinda get the impression amdgpu is throwing a lot of
> issues under the rug through trylock tricks that shut up lockdep, but
> don't fix much really.

Hui? Why do you think that? The only trylock I'm aware of is during 
eviction and there it isn't a problem.

> btw adding cross-release lockdep annotations for fences will probably turn
> up _lots_ more bugs in this area.

At least for amdgpu that should be handled by now.

>>>> +	 *
>>>> +	 * New mappings can be created immediately, but can't be used before the
>>>> +	 * exclusive fence in the dma_bufs reservation object is signaled.
>>>> +	 */
>>>> +	void (*invalidate_mappings)(struct dma_buf_attachment *attach);
>>> Bunch of questions about exact semantics, but I very much like this. And I
>>> think besides those technical details, the overall approach seems sound.
>> Yeah this initial implementation was buggy like hell. Just wanted to confirm
>> that the idea is going in the right direction.
> I wanted this 7 years ago, idea very much acked :-)
>
Ok, thanks. Good to know.

Christian.
