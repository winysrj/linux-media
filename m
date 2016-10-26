Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35313 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753753AbcJZLBc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Oct 2016 07:01:32 -0400
Received: by mail-wm0-f68.google.com with SMTP id o81so3320116wma.2
        for <linux-media@vger.kernel.org>; Wed, 26 Oct 2016 04:01:31 -0700 (PDT)
Date: Wed, 26 Oct 2016 13:01:28 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Brian Starkey <brian.starkey@arm.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v2 7/9] drm: atomic: factor out common out-fence
 operations
Message-ID: <20161026110128.yinp3uylfrkxb7bm@phenom.ffwll.local>
References: <1477472108-27222-1-git-send-email-brian.starkey@arm.com>
 <1477472108-27222-8-git-send-email-brian.starkey@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1477472108-27222-8-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 26, 2016 at 09:55:06AM +0100, Brian Starkey wrote:
> Some parts of setting up the CRTC out-fence can be re-used for
> writeback out-fences. Factor this out into a separate function.
> 
> Signed-off-by: Brian Starkey <brian.starkey@arm.com>

Cc: Gustavo here pls, probably best if he reviews this one.
-Daniel

> ---
>  drivers/gpu/drm/drm_atomic.c |   64 +++++++++++++++++++++++++++---------------
>  1 file changed, 42 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
> index f434f34..3f8fc97 100644
> --- a/drivers/gpu/drm/drm_atomic.c
> +++ b/drivers/gpu/drm/drm_atomic.c
> @@ -1693,37 +1693,46 @@ void drm_atomic_clean_old_fb(struct drm_device *dev,
>  }
>  EXPORT_SYMBOL(drm_atomic_clean_old_fb);
>  
> -static int crtc_setup_out_fence(struct drm_crtc *crtc,
> -				struct drm_crtc_state *crtc_state,
> -				struct drm_out_fence_state *fence_state)
> +static struct fence *get_crtc_fence(struct drm_crtc *crtc,
> +				    struct drm_crtc_state *crtc_state)
>  {
>  	struct fence *fence;
>  
> -	fence_state->fd = get_unused_fd_flags(O_CLOEXEC);
> -	if (fence_state->fd < 0) {
> -		return fence_state->fd;
> -	}
> -
> -	fence_state->out_fence_ptr = crtc_state->out_fence_ptr;
> -	crtc_state->out_fence_ptr = NULL;
> -
> -	if (put_user(fence_state->fd, fence_state->out_fence_ptr))
> -		return -EFAULT;
> -
>  	fence = kzalloc(sizeof(*fence), GFP_KERNEL);
>  	if (!fence)
> -		return -ENOMEM;
> +		return NULL;
>  
>  	fence_init(fence, &drm_crtc_fence_ops, &crtc->fence_lock,
>  		   crtc->fence_context, ++crtc->fence_seqno);
>  
> +	crtc_state->event->base.fence = fence_get(fence);
> +
> +	return fence;
> +}
> +
> +static int setup_out_fence(struct drm_out_fence_state *fence_state,
> +			   u64 __user *out_fence_ptr,
> +			   struct fence *fence)
> +{
> +	int ret;
> +
> +	DRM_DEBUG_ATOMIC("Putting out-fence %p into user ptr: %p\n",
> +			 fence, out_fence_ptr);
> +
> +	fence_state->fd = get_unused_fd_flags(O_CLOEXEC);
> +	if (fence_state->fd < 0)
> +		return fence_state->fd;
> +
> +	ret = put_user(fence_state->fd, out_fence_ptr);
> +	if (ret)
> +		return ret;
> +
> +	fence_state->out_fence_ptr = out_fence_ptr;
> +
>  	fence_state->sync_file = sync_file_create(fence);
> -	if(!fence_state->sync_file) {
> -		fence_put(fence);
> +	if (!fence_state->sync_file)
>  		return -ENOMEM;
> -	}
>  
> -	crtc_state->event->base.fence = fence_get(fence);
>  	return 0;
>  }
>  
> @@ -1896,10 +1905,21 @@ retry:
>  		}
>  
>  		if (crtc_state->out_fence_ptr) {
> -			ret = crtc_setup_out_fence(crtc, crtc_state,
> -						   &fence_state[fence_idx++]);
> -			if (ret)
> +			struct fence *fence = get_crtc_fence(crtc, crtc_state);
> +			if (!fence) {
> +				ret = -ENOMEM;
> +				goto out;
> +			}
> +
> +			ret = setup_out_fence(&fence_state[fence_idx++],
> +					      crtc_state->out_fence_ptr,
> +					      fence);
> +			if (ret) {
> +				fence_put(fence);
>  				goto out;
> +			}
> +
> +			crtc_state->out_fence_ptr = NULL;
>  		}
>  	}
>  
> -- 
> 1.7.9.5
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
