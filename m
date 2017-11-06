Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:50500 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750888AbdKFIpO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Nov 2017 03:45:14 -0500
Received: by mail-wm0-f67.google.com with SMTP id s66so11954979wmf.5
        for <linux-media@vger.kernel.org>; Mon, 06 Nov 2017 00:45:13 -0800 (PST)
Date: Mon, 6 Nov 2017 09:45:10 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Ville Syrjala <ville.syrjala@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        Jason Ekstrand <jason@jlekstrand.net>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 2/4] dma-buf/fence: Sparse wants __rcu on the object
 itself
Message-ID: <20171106084510.lffterxp3ibj6odq@phenom.ffwll.local>
References: <20171102200336.23347-1-ville.syrjala@linux.intel.com>
 <20171102200336.23347-3-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171102200336.23347-3-ville.syrjala@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 02, 2017 at 10:03:34PM +0200, Ville Syrjala wrote:
> From: Chris Wilson <chris@chris-wilson.co.uk>
> 
> In order to silent sparse in dma_fence_get_rcu_safe(), we need to mark

s/silent/silence/

On the series (assuming sparse is indeed happy now, I didn't check that):

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> the incoming fence object as being RCU protected and not the pointer to
> the object.
> 
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Jason Ekstrand <jason@jlekstrand.net>
> Cc: linaro-mm-sig@lists.linaro.org
> Cc: linux-media@vger.kernel.org
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Christian König <christian.koenig@amd.com>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> ---
>  include/linux/dma-fence.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
> index efdabbb64e3c..4c008170fe65 100644
> --- a/include/linux/dma-fence.h
> +++ b/include/linux/dma-fence.h
> @@ -242,7 +242,7 @@ static inline struct dma_fence *dma_fence_get_rcu(struct dma_fence *fence)
>   * The caller is required to hold the RCU read lock.
>   */
>  static inline struct dma_fence *
> -dma_fence_get_rcu_safe(struct dma_fence * __rcu *fencep)
> +dma_fence_get_rcu_safe(struct dma_fence __rcu **fencep)
>  {
>  	do {
>  		struct dma_fence *fence;
> -- 
> 2.13.6
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
