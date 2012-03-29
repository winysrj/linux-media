Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53452 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932690Ab2C2UeV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Mar 2012 16:34:21 -0400
Date: Thu, 29 Mar 2012 23:34:17 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 4/4] omap3isp: preview: Shorten shadow update delay
Message-ID: <20120329203417.GC922@valkosipuli.localdomain>
References: <1332936001-32603-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1332936001-32603-5-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332936001-32603-5-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch. I've got a few comments below.

On Wed, Mar 28, 2012 at 02:00:01PM +0200, Laurent Pinchart wrote:
> When applications modify preview engine parameters, the new values are
> applied to the hardware by the preview engine interrupt handler during
> vertical blanking. If the parameters are being changed when the
> interrupt handler is called, it just delays applying the parameters
> until the next frame.
> 
> If an application modifies the parameters for every frame, and the
> preview engine interrupt is triggerred synchronously, the parameters are
> never applied to the hardware.
> 
> Fix this by storing new parameters in a shadow copy, and switch the
> active parameters with the shadow values atomically.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/omap3isp/isppreview.c |  137 +++++++++++++++++++++--------
>  drivers/media/video/omap3isp/isppreview.h |   21 +++--
>  2 files changed, 112 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
> index 2b5c137..3267d83 100644
> --- a/drivers/media/video/omap3isp/isppreview.c
> +++ b/drivers/media/video/omap3isp/isppreview.c
> @@ -649,12 +649,17 @@ preview_config_rgb_to_ycbcr(struct isp_prev_device *prev, const void *prev_csc)
>  static void
>  preview_update_contrast(struct isp_prev_device *prev, u8 contrast)
>  {
> -	struct prev_params *params = &prev->params;
> +	struct prev_params *params;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&prev->params.lock, flags);
> +	params = prev->params.active;
>  
>  	if (params->contrast != (contrast * ISPPRV_CONTRAST_UNITS)) {
>  		params->contrast = contrast * ISPPRV_CONTRAST_UNITS;
> -		prev->update |= PREV_CONTRAST;
> +		params->update |= PREV_CONTRAST;
>  	}
> +	spin_unlock_irqrestore(&prev->params.lock, flags);
>  }
>  
>  /*
> @@ -681,12 +686,17 @@ preview_config_contrast(struct isp_prev_device *prev, const void *params)
>  static void
>  preview_update_brightness(struct isp_prev_device *prev, u8 brightness)
>  {
> -	struct prev_params *params = &prev->params;
> +	struct prev_params *params;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&prev->params.lock, flags);
> +	params = prev->params.active;
>  
>  	if (params->brightness != (brightness * ISPPRV_BRIGHT_UNITS)) {
>  		params->brightness = brightness * ISPPRV_BRIGHT_UNITS;
> -		prev->update |= PREV_BRIGHTNESS;
> +		params->update |= PREV_BRIGHTNESS;
>  	}
> +	spin_unlock_irqrestore(&prev->params.lock, flags);
>  }
>  
>  /*
> @@ -887,19 +897,19 @@ static int preview_config(struct isp_prev_device *prev,
>  {
>  	struct prev_params *params;
>  	struct preview_update *attr;
> +	unsigned long flags;
>  	int i, bit, rval = 0;
>  
> -	params = &prev->params;
>  	if (cfg->update == 0)
>  		return 0;
>  
> -	if (prev->state != ISP_PIPELINE_STREAM_STOPPED) {
> -		unsigned long flags;
> +	spin_lock_irqsave(&prev->params.lock, flags);
> +	params = prev->params.shadow;
> +	memcpy(params, prev->params.active, sizeof(*params));

Why memcpy()? Couldn't the same be achieved by swapping the pointers?

I also have a feeling that the implementation is still more complex than
would really be needed.

Calls to preview_config() should also be serialised. Otherwise it's possible
to call this simultaneously from user space. That likely wasn't an issue in
the old implementation.

> +	params->busy = true;
> +	spin_unlock_irqrestore(&prev->params.lock, flags);
>  
> -		spin_lock_irqsave(&prev->lock, flags);
> -		prev->shadow_update = 1;
> -		spin_unlock_irqrestore(&prev->lock, flags);
> -	}
> +	params->update = 0;
>  
>  	for (i = 0; i < ARRAY_SIZE(update_attrs); i++) {
>  		attr = &update_attrs[i];
> @@ -926,11 +936,34 @@ static int preview_config(struct isp_prev_device *prev,
>  			params->features &= ~attr->feature_bit;
>  		}
>  
> -		prev->update |= attr->feature_bit;
> +		params->update |= attr->feature_bit;
> +	}
> +
> +	if (rval < 0) {
> +		kfree(params);

I think this must be a remnant from the earlier version of the patch. :-)

> +		return rval;
>  	}
>  
> -	prev->shadow_update = 0;
> -	return rval;
> +	spin_lock_irqsave(&prev->params.lock, flags);
> +	params->busy = false;
> +
> +	/* If active parameters are not in use, switch the active and shadow
> +	 * parameters.
> +	 */
> +	if (!prev->params.active->busy) {
> +		/* Make sure to keep the active update flags as the hardware
> +		 * hasn't been updated yet. The values have been copied at the
> +		 * beginning of the function.
> +		 */
> +		params->update |= prev->params.active->update;
> +		prev->params.active->update = 0;
> +
> +		prev->params.shadow = prev->params.active;
> +		prev->params.active = params;
> +	}
> +	spin_unlock_irqrestore(&prev->params.lock, flags);
> +
> +	return 0;
>  }
>  
>  /*
> @@ -941,7 +974,7 @@ static int preview_config(struct isp_prev_device *prev,
>   */
>  static void preview_setup_hw(struct isp_prev_device *prev)
>  {
> -	struct prev_params *params = &prev->params;
> +	struct prev_params *params = prev->params.active;
>  	struct preview_update *attr;
>  	int i, bit;
>  	void *param_ptr;
> @@ -952,7 +985,7 @@ static void preview_setup_hw(struct isp_prev_device *prev)
>  	for (i = 0; i < ARRAY_SIZE(update_attrs); i++) {
>  		attr = &update_attrs[i];
>  
> -		if (!(prev->update & attr->feature_bit))
> +		if (!(params->update & attr->feature_bit))
>  			continue;
>  		bit = params->features & attr->feature_bit;
>  		if (bit) {
> @@ -967,7 +1000,7 @@ static void preview_setup_hw(struct isp_prev_device *prev)
>  			if (attr->enable)
>  				attr->enable(prev, 0);
>  
> -		prev->update &= ~attr->feature_bit;
> +		params->update &= ~attr->feature_bit;
>  	}
>  }
>  
> @@ -1004,14 +1037,15 @@ preview_config_ycpos(struct isp_prev_device *prev,
>   */
>  static void preview_config_averager(struct isp_prev_device *prev, u8 average)
>  {
> +	struct prev_params *params = prev->params.active;
>  	struct isp_device *isp = to_isp_device(prev);
>  	int reg = 0;
>  
> -	if (prev->params.cfa.format == OMAP3ISP_CFAFMT_BAYER)
> +	if (params->cfa.format == OMAP3ISP_CFAFMT_BAYER)
>  		reg = ISPPRV_AVE_EVENDIST_2 << ISPPRV_AVE_EVENDIST_SHIFT |
>  		      ISPPRV_AVE_ODDDIST_2 << ISPPRV_AVE_ODDDIST_SHIFT |
>  		      average;
> -	else if (prev->params.cfa.format == OMAP3ISP_CFAFMT_RGBFOVEON)
> +	else if (params->cfa.format == OMAP3ISP_CFAFMT_RGBFOVEON)
>  		reg = ISPPRV_AVE_EVENDIST_3 << ISPPRV_AVE_EVENDIST_SHIFT |
>  		      ISPPRV_AVE_ODDDIST_3 << ISPPRV_AVE_ODDDIST_SHIFT |
>  		      average;
> @@ -1032,7 +1066,7 @@ static void preview_config_averager(struct isp_prev_device *prev, u8 average)
>  static void preview_config_input_size(struct isp_prev_device *prev)
>  {
>  	struct isp_device *isp = to_isp_device(prev);
> -	struct prev_params *params = &prev->params;
> +	struct prev_params *params = prev->params.active;
>  	unsigned int sph = prev->crop.left;
>  	unsigned int eph = prev->crop.left + prev->crop.width - 1;
>  	unsigned int slv = prev->crop.top;
> @@ -1189,7 +1223,7 @@ int omap3isp_preview_busy(struct isp_prev_device *prev)
>   */
>  void omap3isp_preview_restore_context(struct isp_device *isp)
>  {
> -	isp->isp_prev.update = PREV_FEATURES_END - 1;
> +	isp->isp_prev.params.active->update = PREV_FEATURES_END - 1;
>  	preview_setup_hw(&isp->isp_prev);
>  }
>  
> @@ -1249,12 +1283,18 @@ static void preview_print_status(struct isp_prev_device *prev)
>  /*
>   * preview_init_params - init image processing parameters.
>   * @prev: pointer to previewer private structure
> - * return none
> + *
> + * Returns 0 on success or -ENOMEM if parameters memory can't be allocated.

This comment no longer needs to be changed.

>   */
> -static void preview_init_params(struct isp_prev_device *prev)
> +static int preview_init_params(struct isp_prev_device *prev)
>  {
> -	struct prev_params *params = &prev->params;
> -	int i = 0;
> +	struct prev_params *params;
> +	unsigned int i;
> +
> +	spin_lock_init(&prev->params.lock);
> +
> +	params = &prev->params.params[0];
> +	params->busy = false;
>  
>  	/* Init values */
>  	params->contrast = ISPPRV_CONTRAST_DEF * ISPPRV_CONTRAST_UNITS;
> @@ -1297,7 +1337,12 @@ static void preview_init_params(struct isp_prev_device *prev)
>  			 | PREV_RGB2RGB | PREV_COLOR_CONV | PREV_WB
>  			 | PREV_BRIGHTNESS | PREV_CONTRAST;
>  
> -	prev->update = PREV_FEATURES_END - 1;
> +	params->update = PREV_FEATURES_END - 1;
> +
> +	prev->params.active = &prev->params.params[0];
> +	prev->params.shadow = &prev->params.params[1];
> +
> +	return 0;
>  }
>  
>  /*
> @@ -1326,6 +1371,11 @@ static void preview_configure(struct isp_prev_device *prev)
>  {
>  	struct isp_device *isp = to_isp_device(prev);
>  	struct v4l2_mbus_framefmt *format;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&prev->params.lock, flags);
> +	prev->params.active->busy = true;
> +	spin_unlock_irqrestore(&prev->params.lock, flags);
>  
>  	preview_setup_hw(prev);
>  
> @@ -1365,6 +1415,10 @@ static void preview_configure(struct isp_prev_device *prev)
>  
>  	preview_config_averager(prev, 0);
>  	preview_config_ycpos(prev, format->code);
> +
> +	spin_lock_irqsave(&prev->params.lock, flags);
> +	prev->params.active->busy = false;
> +	spin_unlock_irqrestore(&prev->params.lock, flags);
>  }
>  
>  /* -----------------------------------------------------------------------------
> @@ -1452,26 +1506,33 @@ static void preview_isr_buffer(struct isp_prev_device *prev)
>   */
>  void omap3isp_preview_isr(struct isp_prev_device *prev)
>  {
> +	struct prev_params *params;
>  	unsigned long flags;
>  
>  	if (omap3isp_module_sync_is_stopping(&prev->wait, &prev->stopping))
>  		return;
>  
> -	spin_lock_irqsave(&prev->lock, flags);
> -	if (prev->shadow_update)
> -		goto done;
> +	spin_lock_irqsave(&prev->params.lock, flags);
> +	if (!prev->params.shadow->busy && prev->params.shadow->update) {
> +		params = prev->params.active;
> +		prev->params.active = prev->params.shadow;
> +		prev->params.shadow = params;
> +	}
> +	prev->params.active->busy = true;
> +	spin_unlock_irqrestore(&prev->params.lock, flags);
>  
>  	preview_setup_hw(prev);
>  	preview_config_input_size(prev);
>  
> -done:
> -	spin_unlock_irqrestore(&prev->lock, flags);
> -
>  	if (prev->input == PREVIEW_INPUT_MEMORY ||
>  	    prev->output & PREVIEW_OUTPUT_MEMORY)
>  		preview_isr_buffer(prev);
>  	else if (prev->state == ISP_PIPELINE_STREAM_CONTINUOUS)
>  		preview_enable_oneshot(prev);
> +
> +	spin_lock_irqsave(&prev->params.lock, flags);
> +	prev->params.active->busy = false;
> +	spin_unlock_irqrestore(&prev->params.lock, flags);
>  }
>  
>  /* -----------------------------------------------------------------------------
> @@ -1557,7 +1618,6 @@ static int preview_set_stream(struct v4l2_subdev *sd, int enable)
>  	struct isp_video *video_out = &prev->video_out;
>  	struct isp_device *isp = to_isp_device(prev);
>  	struct device *dev = to_device(prev);
> -	unsigned long flags;
>  
>  	if (prev->state == ISP_PIPELINE_STREAM_STOPPED) {
>  		if (enable == ISP_PIPELINE_STREAM_STOPPED)
> @@ -1594,11 +1654,9 @@ static int preview_set_stream(struct v4l2_subdev *sd, int enable)
>  		if (omap3isp_module_sync_idle(&sd->entity, &prev->wait,
>  					      &prev->stopping))
>  			dev_dbg(dev, "%s: stop timeout.\n", sd->name);
> -		spin_lock_irqsave(&prev->lock, flags);
>  		omap3isp_sbl_disable(isp, OMAP3_ISP_SBL_PREVIEW_READ);
>  		omap3isp_sbl_disable(isp, OMAP3_ISP_SBL_PREVIEW_WRITE);
>  		omap3isp_subclk_disable(isp, OMAP3_ISP_SUBCLK_PREVIEW);
> -		spin_unlock_irqrestore(&prev->lock, flags);
>  		isp_video_dmaqueue_flags_clr(video_out);
>  		break;
>  	}
> @@ -2206,17 +2264,20 @@ error_video_in:
>  }
>  
>  /*
> - * isp_preview_init - Previewer initialization.
> + * omap3isp_preview_init - Previewer initialization.
>   * @dev : Pointer to ISP device
>   * return -ENOMEM or zero on success
>   */
>  int omap3isp_preview_init(struct isp_device *isp)
>  {
>  	struct isp_prev_device *prev = &isp->isp_prev;
> +	int ret;
>  
> -	spin_lock_init(&prev->lock);
>  	init_waitqueue_head(&prev->wait);
> -	preview_init_params(prev);
> +
> +	ret = preview_init_params(prev);
> +	if (ret < 0)
> +		return ret;
>  
>  	return preview_init_entities(prev);
>  }
> diff --git a/drivers/media/video/omap3isp/isppreview.h b/drivers/media/video/omap3isp/isppreview.h
> index 67723c7..e756807 100644
> --- a/drivers/media/video/omap3isp/isppreview.h
> +++ b/drivers/media/video/omap3isp/isppreview.h
> @@ -88,6 +88,7 @@ enum preview_ycpos_mode {
>  /*
>   * struct prev_params - Structure for all configuration
>   * @features: Set of features enabled.
> + * @update: Bitmask of the parameters to be updated
>   * @cfa: CFA coefficients.
>   * @csup: Chroma suppression coefficients.
>   * @luma: Luma enhancement coefficients.
> @@ -104,7 +105,9 @@ enum preview_ycpos_mode {
>   * @brightness: Brightness.
>   */
>  struct prev_params {
> +	bool busy;
>  	u32 features;
> +	u32 update;
>  	struct omap3isp_prev_cfa cfa;
>  	struct omap3isp_prev_csup csup;
>  	struct omap3isp_prev_luma luma;
> @@ -156,12 +159,11 @@ struct isptables_update {
>   * @output: Bitmask of the active output
>   * @video_in: Input video entity
>   * @video_out: Output video entity
> - * @params: Module configuration data
> - * @shadow_update: If set, update the hardware configured in the next interrupt
> + * @params.active: Active module configuration data
> + * @params.shadow: Shadow module configuration data
> + * @params.lock: Parameters lock, protects params.active and params.shadow
>   * @underrun: Whether the preview entity has queued buffers on the output
>   * @state: Current preview pipeline state
> - * @lock: Shadow update lock
> - * @update: Bitmask of the parameters to be updated
>   *
>   * This structure is used to store the OMAP ISP Preview module Information.
>   */
> @@ -178,13 +180,16 @@ struct isp_prev_device {
>  	struct isp_video video_in;
>  	struct isp_video video_out;
>  
> -	struct prev_params params;
> -	unsigned int shadow_update:1;
> +	struct {
> +		struct prev_params params[2];
> +		struct prev_params *active;
> +		struct prev_params *shadow;
> +		spinlock_t lock;
> +	} params;
> +
>  	enum isp_pipeline_stream_state state;
>  	wait_queue_head_t wait;
>  	atomic_t stopping;
> -	spinlock_t lock;
> -	u32 update;
>  };
>  
>  struct isp_device;
> -- 
> 1.7.3.4
> 

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
