Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:57614 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752209AbeEKHYF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 03:24:05 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Ezequiel Garcia <ezequiel@collabora.com>,
        "Gustavo Padovan" <gustavo@padovan.org>,
        "Sumit Semwal" <sumit.semwal@linaro.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <d4c75122e8e8ee89c7198e12445c67ef0ee11f04.camel@collabora.com>
Cc: kernel@collabora.com, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org
References: <20180509201449.27452-1-ezequiel@collabora.com>
 <1525905732.3381.6.camel@padovan.org>
 <d4c75122e8e8ee89c7198e12445c67ef0ee11f04.camel@collabora.com>
Message-ID: <152602343698.22269.13414355228515737873@mail.alporthouse.com>
Subject: Re: [PATCH] dma-fence: Make dma_fence_add_callback() fail if signaled with
 error
Date: Fri, 11 May 2018 08:23:56 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Ezequiel Garcia (2018-05-10 13:51:56)
> On Wed, 2018-05-09 at 19:42 -0300, Gustavo Padovan wrote:
> > Hi Ezequiel,
> > 
> > On Wed, 2018-05-09 at 17:14 -0300, Ezequiel Garcia wrote:
> > > Change how dma_fence_add_callback() behaves, when the fence
> > > has error-signaled by the time it is being add. After this commit,
> > > dma_fence_add_callback() returns the fence error, if it
> > > has error-signaled before dma_fence_add_callback() is called.
> > > 
> > > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > > ---
> > >  drivers/dma-buf/dma-fence.c | 10 ++++++----
> > >  1 file changed, 6 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-
> > > fence.c
> > > index 4edb9fd3cf47..298b440c5b68 100644
> > > --- a/drivers/dma-buf/dma-fence.c
> > > +++ b/drivers/dma-buf/dma-fence.c
> > > @@ -226,7 +226,8 @@ EXPORT_SYMBOL(dma_fence_enable_sw_signaling);
> > >   *
> > >   * Note that the callback can be called from an atomic context.  If
> > >   * fence is already signaled, this function will return -ENOENT (and
> > > - * *not* call the callback)
> > > + * *not* call the callback). If the fence is error-signaled, this
> > > + * function returns the fence error.
> > >   *
> > >   * Add a software callback to the fence. Same restrictions apply to
> > >   * refcount as it does to dma_fence_wait, however the caller doesn't
> > > need to
> > > @@ -235,8 +236,8 @@ EXPORT_SYMBOL(dma_fence_enable_sw_signaling);
> > >   * after it signals with dma_fence_signal. The callback itself can
> > > be called
> > >   * from irq context.
> > >   *
> > > - * Returns 0 in case of success, -ENOENT if the fence is already
> > > signaled
> > > - * and -EINVAL in case of error.
> > > + * Returns 0 in case of success, -ENOENT (or the error value) if the
> > > fence is
> > > + * already signaled and -EINVAL in case of error.
> > >   */
> > >  int dma_fence_add_callback(struct dma_fence *fence, struct
> > > dma_fence_cb *cb,
> > >                        dma_fence_func_t func)
> > > @@ -250,7 +251,8 @@ int dma_fence_add_callback(struct dma_fence
> > > *fence, struct dma_fence_cb *cb,
> > >  
> > >     if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
> > >             INIT_LIST_HEAD(&cb->node);
> > > -           return -ENOENT;
> > > +           ret = (fence->error < 0) ? fence->error : -ENOENT;
> > > +           return ret;
> > >     }
> > 
> > It looks good to me, but I'd first go check all place we call it in the
> > kernel because I have some memory of callers relying on the -ENOENT
> > return code for some decision. I might be wrong though.
> > 
> > 
> 
> I checked all users before submitting this patch.
> 
> git grep " = dma_fence_add_callback"
> drivers/gpu/drm/i915/i915_sw_fence.c:   ret = dma_fence_add_callback(dma, &cb->base, func);
> 
> And from what I could see, all of them handle the error
> properly.

Err, no. That error then is propagated back to userspace, and that is
not part of our ABI...
-Chris
