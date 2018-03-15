Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:39193 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbeCOJUV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Mar 2018 05:20:21 -0400
Received: by mail-wm0-f49.google.com with SMTP id u10so8855382wmu.4
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2018 02:20:20 -0700 (PDT)
Date: Thu, 15 Mar 2018 10:20:13 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: christian.koenig@amd.com
Cc: Daniel Vetter <daniel@ffwll.ch>, linaro-mm-sig@lists.linaro.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] dma-buf: add optional invalidate_mappings callback
Message-ID: <20180315092013.GC25297@phenom.ffwll.local>
References: <20180309191144.1817-1-christian.koenig@amd.com>
 <20180309191144.1817-2-christian.koenig@amd.com>
 <20180312170710.GL8589@phenom.ffwll.local>
 <f3986703-75de-4ce3-a828-1687291bb618@gmail.com>
 <20180313151721.GH4788@phenom.ffwll.local>
 <2866813a-f2ab-0589-ee40-30935e59d3d7@gmail.com>
 <20180313160052.GK4788@phenom.ffwll.local>
 <052a6595-9fc3-48a6-9366-67ca2f2da17e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <052a6595-9fc3-48a6-9366-67ca2f2da17e@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 13, 2018 at 06:20:07PM +0100, Christian König wrote:
> Am 13.03.2018 um 17:00 schrieb Daniel Vetter:
> > On Tue, Mar 13, 2018 at 04:52:02PM +0100, Christian König wrote:
> > > Am 13.03.2018 um 16:17 schrieb Daniel Vetter:
> > > [SNIP]
> > Ok, so plan is to support fully pipeline moves and everything, with the
> > old sg tables lazily cleaned up. I was thinking more about evicting stuff
> > and throwing it out, where there's not going to be any new sg list but the
> > object is going to be swapped out.
> 
> Yes, exactly. Well my example was the unlikely case when the object is
> swapped out and immediately swapped in again because somebody needs it.
> 
> > 
> > I think some state flow charts (we can do SVG or DOT) in the kerneldoc
> > would be sweet.Yeah, probably a good idea.
> 
> Sounds good and I find it great that you're volunteering for that :D
> 
> Ok seriously, my drawing capabilities are a bit underdeveloped. So I would
> prefer if somebody could at least help with that.

Take a look at the DOT graphs for atomic I've done a while ago. I think we
could make a formidable competition for who's doing the worst diagrams :-)

> > > > Re GPU might cause a deadlock: Isn't that already a problem if you hold
> > > > reservations of buffers used on other gpus, which want those reservations
> > > > to complete the gpu reset, but that gpu reset blocks some fence that the
> > > > reservation holder is waiting for?
> > > Correct, that's why amdgpu and TTM tries quite hard to never wait for a
> > > fence while a reservation object is locked.
> > We might have a fairly huge mismatch of expectations here :-/
> 
> What do you mean with that?

i915 expects that other drivers don't have this requirement. Our gpu reset
can proceed even if it's all locked down.

> > > The only use case I haven't fixed so far is reaping deleted object during
> > > eviction, but that is only a matter of my free time to fix it.
> > Yeah, this is the hard one.
> 
> Actually it isn't so hard, it's just that I didn't had time so far to clean
> it up and we never hit that issue so far during our reset testing.
> 
> The main point missing just a bit of functionality in the reservation object
> and Chris and I already had a good idea how to implement that.
> 
> > In general the assumption is that dma_fence will get signalled no matter
> > what you're doing, assuming the only thing you need is to not block
> > interrupts. The i915 gpu reset logic to make that work is a bit a work of
> > art ...
> 
> Correct, but I don't understand why that is so hard on i915? Our GPU
> scheduler makes all of that rather trivial, e.g. fences either signal
> correctly or are aborted and set as erroneous after a timeout.

Yes, i915 does the same. It's the locking requirement we disagree on, i915
can reset while holding locks. I think right now we don't reset while
holding reservation locks, but only while holding our own locks. I think
cross-release would help model us this and uncover all the funny
dependency loops we have.

The issue I'm seeing:

amdgpu: Expects that you never hold any of the heavywheight locks while
waiting for a fence (since gpu resets will need them).

i915: Happily blocks on fences while holding all kinds of locks, expects
gpu reset to be able to recover even in this case.

Both drivers either complete the fence (with or without setting the error
status to EIO or something like that), that's not the difference. The work
of art I referenced is how we managed to complete gpu reset (including
resubmitting) while holding plenty of locks.

> > If we expect amdgpu and i915 to cooperate with shared buffers I guess one
> > has to give in. No idea how to do that best.
> 
> Again at least from amdgpu side I don't see much of an issue with that. So
> what exactly do you have in mind here?
> 
> > > > We have tons of fun with deadlocks against GPU resets, and loooooots of
> > > > testcases, and I kinda get the impression amdgpu is throwing a lot of
> > > > issues under the rug through trylock tricks that shut up lockdep, but
> > > > don't fix much really.
> > > Hui? Why do you think that? The only trylock I'm aware of is during eviction
> > > and there it isn't a problem.
> > mmap fault handler had one too last time I looked, and it smelled fishy.
> 
> Good point, never wrapped my head fully around that one either.
> 
> > > > btw adding cross-release lockdep annotations for fences will probably turn
> > > > up _lots_ more bugs in this area.
> > > At least for amdgpu that should be handled by now.
> > You're sure? :-)
> 
> Yes, except for fallback paths and bootup self tests we simply never wait
> for fences while holding locks.

That's not what I meant with "are you sure". Did you enable the
cross-release stuff (after patching the bunch of leftover core kernel
issues still present), annotate dma_fence with the cross-release stuff,
run a bunch of multi-driver (amdgpu vs i915) dma-buf sharing tests and
weep?

I didn't do the full thing yet, but just within i915 we've found tons of
small little deadlocks we never really considered thanks to cross release,
and that wasn't even including the dma_fence annotation. Luckily nothing
that needed a full-on driver redesign.

I guess I need to ping core kernel maintainers about cross-release again.
I'd much prefer if we could validate ->invalidate_mapping and the
locking/fence dependency issues using that, instead of me having to read
and understand all the drivers.

> > Trouble is that cross-release wasn't even ever enabled, much less anyone
> > typed the dma_fence annotations. And just cross-release alone turned up
> > _lost_ of deadlocks in i915 between fences, async workers (userptr, gpu
> > reset) and core mm stuff.
> 
> Yeah, we had lots of fun with the mm locks as well but as far as I know
> Felix and I already fixed all of them.

Are you sure you mean cross-release fun, and not just normal lockdep fun?
The cross-release is orders of magnitude more nasty imo. And we had a few
discussions with core folks where they told us "no way we're going to
break this depency on our side", involving a chain of cpu hotplug
(suspend/resume does that to shut down non-boot cpus), worker threads,
userptr, gem locking and core mm. All components required to actually
close the loop.

I fear that with the ->invalidate_mapping callback (which inverts the
control flow between importer and exporter) and tying dma_fences into all
this it will be a _lot_ worse. And I'm definitely too stupid to understand
all the dependency chains without the aid of lockdep and a full test suite
(we have a bunch of amdgpu/i915 dma-buf tests in igt btw).
-Daniel

> 
> Christian.
> 
> > I'd be seriously surprised if it wouldn't find an entire rats nest of
> > issues around dma_fence once we enable it.
> > -Daniel
> > 
> > > > > > > +	 *
> > > > > > > +	 * New mappings can be created immediately, but can't be used before the
> > > > > > > +	 * exclusive fence in the dma_bufs reservation object is signaled.
> > > > > > > +	 */
> > > > > > > +	void (*invalidate_mappings)(struct dma_buf_attachment *attach);
> > > > > > Bunch of questions about exact semantics, but I very much like this. And I
> > > > > > think besides those technical details, the overall approach seems sound.
> > > > > Yeah this initial implementation was buggy like hell. Just wanted to confirm
> > > > > that the idea is going in the right direction.
> > > > I wanted this 7 years ago, idea very much acked :-)
> > > > 
> > > Ok, thanks. Good to know.
> > > 
> > > Christian.
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
