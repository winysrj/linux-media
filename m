Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34486 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753973AbeD3PfG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Apr 2018 11:35:06 -0400
Received: by mail-wm0-f65.google.com with SMTP id a137so10498482wme.1
        for <linux-media@vger.kernel.org>; Mon, 30 Apr 2018 08:35:05 -0700 (PDT)
Date: Mon, 30 Apr 2018 17:35:02 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH 04/17] dma-fence: Allow wait_any_timeout for all fences
Message-ID: <20180430153502.GQ12521@phenom.ffwll.local>
References: <20180427061724.28497-1-daniel.vetter@ffwll.ch>
 <20180427061724.28497-5-daniel.vetter@ffwll.ch>
 <1df9beec-8ee4-5740-954a-a2a5dbc4fd03@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1df9beec-8ee4-5740-954a-a2a5dbc4fd03@amd.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Apr 29, 2018 at 09:11:31AM +0200, Christian König wrote:
> Am 27.04.2018 um 08:17 schrieb Daniel Vetter:
> > When this was introduced in
> > 
> > commit a519435a96597d8cd96123246fea4ae5a6c90b02
> > Author: Christian König <christian.koenig@amd.com>
> > Date:   Tue Oct 20 16:34:16 2015 +0200
> > 
> >      dma-buf/fence: add fence_wait_any_timeout function v2
> > 
> > there was a restriction added that this only works if the dma-fence
> > uses the dma_fence_default_wait hook. Which works for amdgpu, which is
> > the only caller. Well, until you share some buffers with e.g. i915,
> > then you get an -EINVAL.
> > 
> > But there's really no reason for this, because all drivers must
> > support callbacks. The special ->wait hook is only as an optimization;
> > if the driver needs to create a worker thread for an active callback,
> > then it can avoid to do that if it knows that there's a process
> > context available already. So ->wait is just an optimization, just
> > using the logic in dma_fence_default_wait() should work for all
> > drivers.
> > 
> > Let's remove this restriction.
> 
> Mhm, that was intentional introduced because for radeon that is not only an
> optimization, but mandatory for correct operation.
> 
> On the other hand radeon isn't using this function, so it should be fine as
> long as the Intel driver can live with it.

Well dma-buf already requires that dma_fence_add_callback works correctly.
And so do various users of it as soon as you engage in a bit of buffer
sharing. I guess whomever cares about buffer sharing with radeon gets to
fix this (you need to spawn a kthread or whatever in ->enable_signaling
which does the same work as your optimized ->wait callback).

But yeah, I'm definitely not making things work with this series, just a
bit more obvious that there's a problem already.
-Daniel

> 
> Christian.
> 
> > 
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > Cc: Sumit Semwal <sumit.semwal@linaro.org>
> > Cc: Gustavo Padovan <gustavo@padovan.org>
> > Cc: linux-media@vger.kernel.org
> > Cc: linaro-mm-sig@lists.linaro.org
> > Cc: Christian König <christian.koenig@amd.com>
> > Cc: Alex Deucher <alexander.deucher@amd.com>
> > ---
> >   drivers/dma-buf/dma-fence.c | 5 -----
> >   1 file changed, 5 deletions(-)
> > 
> > diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
> > index 7b5b40d6b70e..59049375bd19 100644
> > --- a/drivers/dma-buf/dma-fence.c
> > +++ b/drivers/dma-buf/dma-fence.c
> > @@ -503,11 +503,6 @@ dma_fence_wait_any_timeout(struct dma_fence **fences, uint32_t count,
> >   	for (i = 0; i < count; ++i) {
> >   		struct dma_fence *fence = fences[i];
> > -		if (fence->ops->wait != dma_fence_default_wait) {
> > -			ret = -EINVAL;
> > -			goto fence_rm_cb;
> > -		}
> > -
> >   		cb[i].task = current;
> >   		if (dma_fence_add_callback(fence, &cb[i].base,
> >   					   dma_fence_default_wait_cb)) {
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
