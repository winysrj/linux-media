Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:40684 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752203AbcJZLJH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Oct 2016 07:09:07 -0400
Received: by mail-wm0-f66.google.com with SMTP id b80so3306768wme.7
        for <linux-media@vger.kernel.org>; Wed, 26 Oct 2016 04:09:06 -0700 (PDT)
Date: Wed, 26 Oct 2016 13:09:02 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Brian Starkey <brian.starkey@arm.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v2 8/9] drm: writeback: Add out-fences for writeback
 connectors
Message-ID: <20161026110902.5mvtfbbtgjqbr7hj@phenom.ffwll.local>
References: <1477472108-27222-1-git-send-email-brian.starkey@arm.com>
 <1477472108-27222-9-git-send-email-brian.starkey@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1477472108-27222-9-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 26, 2016 at 09:55:07AM +0100, Brian Starkey wrote:
> Add the OUT_FENCE_PTR property to writeback connectors, to enable
> userspace to get a fence which will signal once the writeback is
> complete.
> 
> A timeline is added to drm_connector for use by the writeback
> out-fences. It is up to drivers to check for a fence in the
> connector_state and signal the it appropriately when their writeback has
> finished.
> 
> It is not allowed to request an out-fence without a framebuffer attached
> to the connector.
> 
> Signed-off-by: Brian Starkey <brian.starkey@arm.com>

Ah, here it is, so much for reading patches strictly in-order ;-) One
small comment below, otherwise I think this looks good. Again review from
Gustavo for the out fences stuff would be really good (so pls cc him). And
I think some igt testcases to exercise all the corner-cases in here.

> diff --git a/include/drm/drm_connector.h b/include/drm/drm_connector.h
> index a5e3778..7d40537 100644
> --- a/include/drm/drm_connector.h
> +++ b/include/drm/drm_connector.h
> @@ -199,6 +199,7 @@ int drm_display_info_set_bus_formats(struct drm_display_info *info,
>   * @best_encoder: can be used by helpers and drivers to select the encoder
>   * @state: backpointer to global drm_atomic_state
>   * @fb: Writeback framebuffer, for DRM_MODE_CONNECTOR_WRITEBACK
> + * @out_fence: Fence which will clear when the framebuffer write has finished
>   */
>  struct drm_connector_state {
>  	struct drm_connector *connector;
> @@ -216,6 +217,9 @@ struct drm_connector_state {
>  	struct drm_atomic_state *state;
>  
>  	struct drm_framebuffer *fb;  /* do not write directly, use drm_atomic_set_fb_for_connector() */

btw if you feel like adding a 2nd comment in-line like above, then that's
a clear signal that you should move your kerneldoc struct member comments
to the inline style. You can freely mix&match inline with top-level struct
member documentation, so no need to change them all. You also missed the
doc for out_fence_ptr, 0day won't like that.

> +
> +	struct fence *out_fence;
> +	u64 __user *out_fence_ptr;

writeback_ prefix for both imo, like in patch 1.

>  };
>  
>  /**
> @@ -546,6 +550,10 @@ struct drm_cmdline_mode {
>   * @tile_v_loc: vertical location of this tile
>   * @tile_h_size: horizontal size of this tile.
>   * @tile_v_size: vertical size of this tile.
> + * @fence_context: context for fence signalling
> + * @fence_lock: fence lock for the fence context
> + * @fence_seqno: seqno variable to create fences
> + * @timeline_name: fence timeline name
>   *
>   * Each connector may be connected to one or more CRTCs, or may be clonable by
>   * another connector if they can share a CRTC.  Each connector also has a specific
> @@ -694,6 +702,12 @@ struct drm_connector {
>  	uint8_t num_h_tile, num_v_tile;
>  	uint8_t tile_h_loc, tile_v_loc;
>  	uint16_t tile_h_size, tile_v_size;
> +
> +	/* fence timelines info for DRM out-fences */
> +	unsigned int fence_context;
> +	spinlock_t fence_lock;
> +	unsigned long fence_seqno;
> +	char timeline_name[32];

Should all have writeout_ prefix. And at that point I wonder a bit whether
we shouldn't just go ahead and create a struct drm_writeout_connector, to
keep this stuff nicely separate. Only change visible to drivers would be
the type of drm_writeback_connector_init, and they'd need to
allocate/embedd a different struct. Worth it imo.
-Daniel

>  };
>  
>  #define obj_to_connector(x) container_of(x, struct drm_connector, base)
> diff --git a/include/drm/drm_writeback.h b/include/drm/drm_writeback.h
> index afdc2742..01f33bc 100644
> --- a/include/drm/drm_writeback.h
> +++ b/include/drm/drm_writeback.h
> @@ -16,4 +16,6 @@ int drm_writeback_connector_init(struct drm_device *dev,
>  				 const struct drm_connector_funcs *funcs,
>  				 u32 *formats, int n_formats);
>  
> +struct fence *drm_writeback_get_out_fence(struct drm_connector *connector,
> +					  struct drm_connector_state *conn_state);
>  #endif
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
