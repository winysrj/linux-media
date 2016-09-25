Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33443 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933812AbcIYUnN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Sep 2016 16:43:13 -0400
Received: by mail-wm0-f68.google.com with SMTP id w84so11218057wmg.0
        for <linux-media@vger.kernel.org>; Sun, 25 Sep 2016 13:43:12 -0700 (PDT)
Date: Sun, 25 Sep 2016 22:43:08 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        intel-gfx@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 10/11] dma-buf: Use seqlock to close RCU
 race in test_signaled_single
Message-ID: <20160925204308.GP20761@phenom.ffwll.local>
References: <20160829070834.22296-1-chris@chris-wilson.co.uk>
 <20160829070834.22296-10-chris@chris-wilson.co.uk>
 <20160923134926.GL3988@dvetter-linux.ger.corp.intel.com>
 <20160923140232.GD28107@nuc-i3427.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20160923140232.GD28107@nuc-i3427.alporthouse.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 23, 2016 at 03:02:32PM +0100, Chris Wilson wrote:
> On Fri, Sep 23, 2016 at 03:49:26PM +0200, Daniel Vetter wrote:
> > On Mon, Aug 29, 2016 at 08:08:33AM +0100, Chris Wilson wrote:
> > > With the seqlock now extended to cover the lookup of the fence and its
> > > testing, we can perform that testing solely under the seqlock guard and
> > > avoid the effective locking and serialisation of acquiring a reference to
> > > the request.  As the fence is RCU protected we know it cannot disappear
> > > as we test it, the same guarantee that made it safe to acquire the
> > > reference previously.  The seqlock tests whether the fence was replaced
> > > as we are testing it telling us whether or not we can trust the result
> > > (if not, we just repeat the test until stable).
> > > 
> > > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > > Cc: Sumit Semwal <sumit.semwal@linaro.org>
> > > Cc: linux-media@vger.kernel.org
> > > Cc: dri-devel@lists.freedesktop.org
> > > Cc: linaro-mm-sig@lists.linaro.org
> > 
> > Not entirely sure this is safe for non-i915 drivers. We might now call
> > ->signalled on a zombie fence (i.e. refcount == 0, but not yet kfreed).
> > i915 can do that, but other drivers might go boom.
> 
> All fences must be under RCU guard, or is that the sticking point? Given
> that, the problem is fence reallocation within the RCU grace period. If
> we can mandate that fence reallocation must be safe for concurrent
> fence->ops->*(), we can use this technique to avoid the serialisation
> barrier otherwise required. In the simple stress test, the difference is
> an order of magnitude, and test_signaled_rcu is often on a path where
> every memory barrier quickly adds up (at least for us).
> 
> So is it just that you worry that others using SLAB_DESTROY_BY_RCU won't
> ensure their fence is safe during the reallocation?

Before your patch the rcu-protected part was just the
kref_get_unless_zero. This was done before calling down into and
fenc->ops->* functions. Which means the code of these functions was
guaranteed to run on a real fence object, and not a zombie fence in the
process of getting destructed.

Afaiui with your patch we might call into fence->ops->* on these zombie
fences. That would be a behaviour change with rather big implications
(since we'd need to audit all existing implementations, and also make sure
all future ones will be ok too). Or I missed something again.

I think we could still to this trick, at least partially, by making sure
we only inspect generic fence state and never call into fence->ops before
we're guaranteed to have a real fence.

But atm (at least per Christian König) a fence won't eventually get
signalled without calling into ->ops functions, so there's a catch 22.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
