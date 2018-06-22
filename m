Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:56108 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754366AbeFVKJD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 06:09:03 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Gustavo Padovan <gustavo@padovan.org>,
        "Akhil P Oommen" <akhilpo@codeaurora.org>, sumit.semwal@linaro.org,
        jcrouse@codeaurora.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <1529661856.7034.404.camel@padovan.org>
Cc: linux-arm-msm@vger.kernel.org, smasetty@codeaurora.org
References: <1529660407-6266-1-git-send-email-akhilpo@codeaurora.org>
 <1529661856.7034.404.camel@padovan.org>
Message-ID: <152966212844.11773.6596589902326100250@mail.alporthouse.com>
Subject: Re: [PATCH v2] dma-buf/fence: Take refcount on the module that owns the fence
Date: Fri, 22 Jun 2018 11:08:48 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Gustavo Padovan (2018-06-22 11:04:16)
> Hi Akhil,
> 
> On Fri, 2018-06-22 at 15:10 +0530, Akhil P Oommen wrote:
> > Each fence object holds function pointers of the module that
> > initialized
> > it. Allowing the module to unload before this fence's release is
> > catastrophic. So, keep a refcount on the module until the fence is
> > released.
> > 
> > Signed-off-by: Akhil P Oommen <akhilpo@codeaurora.org>
> > ---
> > Changes in v2:
> > - added description for the new function parameter.
> > 
> >  drivers/dma-buf/dma-fence.c | 16 +++++++++++++---
> >  include/linux/dma-fence.h   | 10 ++++++++--
> >  2 files changed, 21 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-
> > fence.c
> > index 4edb9fd..2aaa44e 100644
> > --- a/drivers/dma-buf/dma-fence.c
> > +++ b/drivers/dma-buf/dma-fence.c
> > @@ -18,6 +18,7 @@
> >   * more details.
> >   */
> >  
> > +#include <linux/module.h>
> >  #include <linux/slab.h>
> >  #include <linux/export.h>
> >  #include <linux/atomic.h>
> > @@ -168,6 +169,7 @@ void dma_fence_release(struct kref *kref)
> >  {
> >       struct dma_fence *fence =
> >               container_of(kref, struct dma_fence, refcount);
> > +     struct module *module = fence->owner;
> >  
> >       trace_dma_fence_destroy(fence);
> >  
> > @@ -178,6 +180,8 @@ void dma_fence_release(struct kref *kref)
> >               fence->ops->release(fence);
> >       else
> >               dma_fence_free(fence);
> > +
> > +     module_put(module);
> >  }
> >  EXPORT_SYMBOL(dma_fence_release);
> >  
> > @@ -541,6 +545,7 @@ struct default_wait_cb {
> >  
> >  /**
> >   * dma_fence_init - Initialize a custom fence.
> > + * @module:  [in]    the module that calls this API
> >   * @fence:   [in]    the fence to initialize
> >   * @ops:     [in]    the dma_fence_ops for operations on this
> > fence
> >   * @lock:    [in]    the irqsafe spinlock to use for locking
> > this fence
> > @@ -556,8 +561,9 @@ struct default_wait_cb {
> >   * to check which fence is later by simply using dma_fence_later.
> >   */
> >  void
> > -dma_fence_init(struct dma_fence *fence, const struct dma_fence_ops
> > *ops,
> > -            spinlock_t *lock, u64 context, unsigned seqno)
> > +_dma_fence_init(struct module *module, struct dma_fence *fence,
> > +             const struct dma_fence_ops *ops, spinlock_t *lock,
> > +             u64 context, unsigned seqno)
> >  {
> >       BUG_ON(!lock);
> >       BUG_ON(!ops || !ops->wait || !ops->enable_signaling ||
> > @@ -571,7 +577,11 @@ struct default_wait_cb {
> >       fence->seqno = seqno;
> >       fence->flags = 0UL;
> >       fence->error = 0;
> > +     fence->owner = module;
> > +
> > +     if (!try_module_get(module))
> > +             fence->owner = NULL;
> >  
> >       trace_dma_fence_init(fence);
> >  }
> > -EXPORT_SYMBOL(dma_fence_init);
> > +EXPORT_SYMBOL(_dma_fence_init);
> 
> Do we still need to export the symbol, it won't be called from outside
> anymore? Other than that looks good to me:

There's a big drawback in that a module reference is often insufficient,
and that a reference on the driver (or whatever is required for the
lifetime of the fence) will already hold the module reference.

Considering that we want a few 100k fences in flight per second, is
there no other way to only export a fence with a module reference?
-Chris
