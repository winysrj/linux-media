Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:39550 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932418AbeCMRUL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 13:20:11 -0400
Received: by mail-wr0-f178.google.com with SMTP id k3so1047069wrg.6
        for <linux-media@vger.kernel.org>; Tue, 13 Mar 2018 10:20:11 -0700 (PDT)
Reply-To: christian.koenig@amd.com
Subject: Re: [PATCH 1/4] dma-buf: add optional invalidate_mappings callback
To: Daniel Vetter <daniel@ffwll.ch>, christian.koenig@amd.com
Cc: linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org, linux-media@vger.kernel.org
References: <20180309191144.1817-1-christian.koenig@amd.com>
 <20180309191144.1817-2-christian.koenig@amd.com>
 <20180312170710.GL8589@phenom.ffwll.local>
 <f3986703-75de-4ce3-a828-1687291bb618@gmail.com>
 <20180313151721.GH4788@phenom.ffwll.local>
 <2866813a-f2ab-0589-ee40-30935e59d3d7@gmail.com>
 <20180313160052.GK4788@phenom.ffwll.local>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <052a6595-9fc3-48a6-9366-67ca2f2da17e@gmail.com>
Date: Tue, 13 Mar 2018 18:20:07 +0100
MIME-Version: 1.0
In-Reply-To: <20180313160052.GK4788@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 13.03.2018 um 17:00 schrieb Daniel Vetter:
> On Tue, Mar 13, 2018 at 04:52:02PM +0100, Christian König wrote:
>> Am 13.03.2018 um 16:17 schrieb Daniel Vetter:
>> [SNIP]
> Ok, so plan is to support fully pipeline moves and everything, with the
> old sg tables lazily cleaned up. I was thinking more about evicting stuff
> and throwing it out, where there's not going to be any new sg list but the
> object is going to be swapped out.

Yes, exactly. Well my example was the unlikely case when the object is 
swapped out and immediately swapped in again because somebody needs it.

>
> I think some state flow charts (we can do SVG or DOT) in the kerneldoc
> would be sweet.Yeah, probably a good idea.

Sounds good and I find it great that you're volunteering for that :D

Ok seriously, my drawing capabilities are a bit underdeveloped. So I 
would prefer if somebody could at least help with that.

>>> Re GPU might cause a deadlock: Isn't that already a problem if you hold
>>> reservations of buffers used on other gpus, which want those reservations
>>> to complete the gpu reset, but that gpu reset blocks some fence that the
>>> reservation holder is waiting for?
>> Correct, that's why amdgpu and TTM tries quite hard to never wait for a
>> fence while a reservation object is locked.
> We might have a fairly huge mismatch of expectations here :-/

What do you mean with that?

>> The only use case I haven't fixed so far is reaping deleted object during
>> eviction, but that is only a matter of my free time to fix it.
> Yeah, this is the hard one.

Actually it isn't so hard, it's just that I didn't had time so far to 
clean it up and we never hit that issue so far during our reset testing.

The main point missing just a bit of functionality in the reservation 
object and Chris and I already had a good idea how to implement that.

> In general the assumption is that dma_fence will get signalled no matter
> what you're doing, assuming the only thing you need is to not block
> interrupts. The i915 gpu reset logic to make that work is a bit a work of
> art ...

Correct, but I don't understand why that is so hard on i915? Our GPU 
scheduler makes all of that rather trivial, e.g. fences either signal 
correctly or are aborted and set as erroneous after a timeout.

> If we expect amdgpu and i915 to cooperate with shared buffers I guess one
> has to give in. No idea how to do that best.

Again at least from amdgpu side I don't see much of an issue with that. 
So what exactly do you have in mind here?

>>> We have tons of fun with deadlocks against GPU resets, and loooooots of
>>> testcases, and I kinda get the impression amdgpu is throwing a lot of
>>> issues under the rug through trylock tricks that shut up lockdep, but
>>> don't fix much really.
>> Hui? Why do you think that? The only trylock I'm aware of is during eviction
>> and there it isn't a problem.
> mmap fault handler had one too last time I looked, and it smelled fishy.

Good point, never wrapped my head fully around that one either.

>>> btw adding cross-release lockdep annotations for fences will probably turn
>>> up _lots_ more bugs in this area.
>> At least for amdgpu that should be handled by now.
> You're sure? :-)

Yes, except for fallback paths and bootup self tests we simply never 
wait for fences while holding locks.

> Trouble is that cross-release wasn't even ever enabled, much less anyone
> typed the dma_fence annotations. And just cross-release alone turned up
> _lost_ of deadlocks in i915 between fences, async workers (userptr, gpu
> reset) and core mm stuff.

Yeah, we had lots of fun with the mm locks as well but as far as I know 
Felix and I already fixed all of them.

Christian.

> I'd be seriously surprised if it wouldn't find an entire rats nest of
> issues around dma_fence once we enable it.
> -Daniel
>
>>>>>> +	 *
>>>>>> +	 * New mappings can be created immediately, but can't be used before the
>>>>>> +	 * exclusive fence in the dma_bufs reservation object is signaled.
>>>>>> +	 */
>>>>>> +	void (*invalidate_mappings)(struct dma_buf_attachment *attach);
>>>>> Bunch of questions about exact semantics, but I very much like this. And I
>>>>> think besides those technical details, the overall approach seems sound.
>>>> Yeah this initial implementation was buggy like hell. Just wanted to confirm
>>>> that the idea is going in the right direction.
>>> I wanted this 7 years ago, idea very much acked :-)
>>>
>> Ok, thanks. Good to know.
>>
>> Christian.
