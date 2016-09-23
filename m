Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:52301 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754692AbcIWOCm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Sep 2016 10:02:42 -0400
Date: Fri, 23 Sep 2016 15:02:32 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        intel-gfx@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 10/11] dma-buf: Use seqlock to close RCU
 race in test_signaled_single
Message-ID: <20160923140232.GD28107@nuc-i3427.alporthouse.com>
References: <20160829070834.22296-1-chris@chris-wilson.co.uk>
 <20160829070834.22296-10-chris@chris-wilson.co.uk>
 <20160923134926.GL3988@dvetter-linux.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160923134926.GL3988@dvetter-linux.ger.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 23, 2016 at 03:49:26PM +0200, Daniel Vetter wrote:
> On Mon, Aug 29, 2016 at 08:08:33AM +0100, Chris Wilson wrote:
> > With the seqlock now extended to cover the lookup of the fence and its
> > testing, we can perform that testing solely under the seqlock guard and
> > avoid the effective locking and serialisation of acquiring a reference to
> > the request.  As the fence is RCU protected we know it cannot disappear
> > as we test it, the same guarantee that made it safe to acquire the
> > reference previously.  The seqlock tests whether the fence was replaced
> > as we are testing it telling us whether or not we can trust the result
> > (if not, we just repeat the test until stable).
> > 
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Sumit Semwal <sumit.semwal@linaro.org>
> > Cc: linux-media@vger.kernel.org
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: linaro-mm-sig@lists.linaro.org
> 
> Not entirely sure this is safe for non-i915 drivers. We might now call
> ->signalled on a zombie fence (i.e. refcount == 0, but not yet kfreed).
> i915 can do that, but other drivers might go boom.

All fences must be under RCU guard, or is that the sticking point? Given
that, the problem is fence reallocation within the RCU grace period. If
we can mandate that fence reallocation must be safe for concurrent
fence->ops->*(), we can use this technique to avoid the serialisation
barrier otherwise required. In the simple stress test, the difference is
an order of magnitude, and test_signaled_rcu is often on a path where
every memory barrier quickly adds up (at least for us).

So is it just that you worry that others using SLAB_DESTROY_BY_RCU won't
ensure their fence is safe during the reallocation?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
