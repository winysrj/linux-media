Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:34018 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935589AbeEJMxU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 May 2018 08:53:20 -0400
Message-ID: <d4c75122e8e8ee89c7198e12445c67ef0ee11f04.camel@collabora.com>
Subject: Re: [PATCH] dma-fence: Make dma_fence_add_callback() fail if
 signaled with error
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Gustavo Padovan <gustavo@padovan.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        kernel@collabora.com
Date: Thu, 10 May 2018 09:51:56 -0300
In-Reply-To: <1525905732.3381.6.camel@padovan.org>
References: <20180509201449.27452-1-ezequiel@collabora.com>
         <1525905732.3381.6.camel@padovan.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-05-09 at 19:42 -0300, Gustavo Padovan wrote:
> Hi Ezequiel,
> 
> On Wed, 2018-05-09 at 17:14 -0300, Ezequiel Garcia wrote:
> > Change how dma_fence_add_callback() behaves, when the fence
> > has error-signaled by the time it is being add. After this commit,
> > dma_fence_add_callback() returns the fence error, if it
> > has error-signaled before dma_fence_add_callback() is called.
> > 
> > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > ---
> >  drivers/dma-buf/dma-fence.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-
> > fence.c
> > index 4edb9fd3cf47..298b440c5b68 100644
> > --- a/drivers/dma-buf/dma-fence.c
> > +++ b/drivers/dma-buf/dma-fence.c
> > @@ -226,7 +226,8 @@ EXPORT_SYMBOL(dma_fence_enable_sw_signaling);
> >   *
> >   * Note that the callback can be called from an atomic context.  If
> >   * fence is already signaled, this function will return -ENOENT (and
> > - * *not* call the callback)
> > + * *not* call the callback). If the fence is error-signaled, this
> > + * function returns the fence error.
> >   *
> >   * Add a software callback to the fence. Same restrictions apply to
> >   * refcount as it does to dma_fence_wait, however the caller doesn't
> > need to
> > @@ -235,8 +236,8 @@ EXPORT_SYMBOL(dma_fence_enable_sw_signaling);
> >   * after it signals with dma_fence_signal. The callback itself can
> > be called
> >   * from irq context.
> >   *
> > - * Returns 0 in case of success, -ENOENT if the fence is already
> > signaled
> > - * and -EINVAL in case of error.
> > + * Returns 0 in case of success, -ENOENT (or the error value) if the
> > fence is
> > + * already signaled and -EINVAL in case of error.
> >   */
> >  int dma_fence_add_callback(struct dma_fence *fence, struct
> > dma_fence_cb *cb,
> >  			   dma_fence_func_t func)
> > @@ -250,7 +251,8 @@ int dma_fence_add_callback(struct dma_fence
> > *fence, struct dma_fence_cb *cb,
> >  
> >  	if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
> >  		INIT_LIST_HEAD(&cb->node);
> > -		return -ENOENT;
> > +		ret = (fence->error < 0) ? fence->error : -ENOENT;
> > +		return ret;
> >  	}
> 
> It looks good to me, but I'd first go check all place we call it in the
> kernel because I have some memory of callers relying on the -ENOENT
> return code for some decision. I might be wrong though.
> 
> 

I checked all users before submitting this patch.

git grep " = dma_fence_add_callback"
drivers/gpu/drm/i915/i915_sw_fence.c:   ret = dma_fence_add_callback(dma, &cb->base, func);
drivers/gpu/drm/scheduler/gpu_scheduler.c:                      r = dma_fence_add_callback(fence, &s_fence->cb,
drivers/gpu/drm/scheduler/gpu_scheduler.c:                      r = dma_fence_add_callback(fence, &s_fence->cb,

And from what I could see, all of them handle the error
properly.

Thanks,
Eze
