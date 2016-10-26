Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:35986 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932684AbcJZVpT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Oct 2016 17:45:19 -0400
Date: Wed, 26 Oct 2016 19:45:14 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Brian Starkey <brian.starkey@arm.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v2 7/9] drm: atomic: factor out common out-fence
 operations
Message-ID: <20161026214514.GI12629@joana>
References: <1477472108-27222-1-git-send-email-brian.starkey@arm.com>
 <1477472108-27222-8-git-send-email-brian.starkey@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1477472108-27222-8-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-10-26 Brian Starkey <brian.starkey@arm.com>:

> Some parts of setting up the CRTC out-fence can be re-used for
> writeback out-fences. Factor this out into a separate function.
> 
> Signed-off-by: Brian Starkey <brian.starkey@arm.com>
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

%p should be kept for your internal debug only. Make sure to remove
anything that exposes kernel address when sending patches.

Gustavo

