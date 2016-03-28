Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34180 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752562AbcC1XLb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2016 19:11:31 -0400
Date: Tue, 29 Mar 2016 02:11:27 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v3] v4l: subdev: Add pad config allocator and init
Message-ID: <20160328231127.GF32125@valkosipuli.retiisi.org.uk>
References: <1458902668-1141-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1458919665-32417-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1458919665-32417-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch. One comment below...

On Fri, Mar 25, 2016 at 05:27:45PM +0200, Laurent Pinchart wrote:
> From: Laurent Pinchart <laurent.pinchart@linaro.org>
> 
> Add a new subdev operation to initialize a subdev pad config array, and
> a helper function to allocate and initialize the array. This can be used
> by bridge drivers to implement try format based on subdev pad
> operations.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@linaro.org>
> Acked-by: Vaibhav Hiremath <vaibhav.hiremath@linaro.org>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-subdev.c | 37 ++++++++++++++++++++++++++++++++---
>  include/media/v4l2-subdev.h           |  8 ++++++++
>  2 files changed, 42 insertions(+), 3 deletions(-)
> 
> Changes since v2:
> 
> - Don't fail due to pad config allocation when the subdev has no pad.
> 
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index 0fa60801a428..8c6f016d1791 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -35,9 +35,11 @@
>  static int subdev_fh_init(struct v4l2_subdev_fh *fh, struct v4l2_subdev *sd)
>  {
>  #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
> -	fh->pad = kzalloc(sizeof(*fh->pad) * sd->entity.num_pads, GFP_KERNEL);
> -	if (fh->pad == NULL)
> -		return -ENOMEM;
> +	if (sd->entity.num_pads) {
> +		fh->pad = v4l2_subdev_alloc_pad_config(sd);
> +		if (fh->pad == NULL)
> +			return -ENOMEM;
> +	}
>  #endif
>  	return 0;
>  }
> @@ -569,6 +571,35 @@ int v4l2_subdev_link_validate(struct media_link *link)
>  		sink, link, &source_fmt, &sink_fmt);
>  }
>  EXPORT_SYMBOL_GPL(v4l2_subdev_link_validate);
> +
> +struct v4l2_subdev_pad_config *
> +v4l2_subdev_alloc_pad_config(struct v4l2_subdev *sd)

What's the use case for calling v4l2_subdev_alloc_pad_config() elsewhere
than from subdev_fh_init()?

> +{
> +	struct v4l2_subdev_pad_config *cfg;
> +	int ret;
> +
> +	if (!sd->entity.num_pads)
> +		return NULL;
> +
> +	cfg = kcalloc(sd->entity.num_pads, sizeof(*cfg), GFP_KERNEL);
> +	if (!cfg)
> +		return NULL;
> +
> +	ret = v4l2_subdev_call(sd, pad, init_cfg, cfg);
> +	if (ret < 0 && ret != -ENOIOCTLCMD) {
> +		kfree(cfg);
> +		return NULL;
> +	}
> +
> +	return cfg;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_subdev_alloc_pad_config);
> +
> +void v4l2_subdev_free_pad_config(struct v4l2_subdev_pad_config *cfg)
> +{
> +	kfree(cfg);

Not really a bug but --- I think it'd be cleaner to call this from
v4l2_fh_cleanup(), rather than freeing cfg directly using kfree().

> +}
> +EXPORT_SYMBOL_GPL(v4l2_subdev_free_pad_config);
>  #endif /* CONFIG_MEDIA_CONTROLLER */
>  
>  void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 11e2dfec0198..32fc7a4beb5e 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -572,6 +572,7 @@ struct v4l2_subdev_pad_config {
>  /**
>   * struct v4l2_subdev_pad_ops - v4l2-subdev pad level operations
>   *
> + * @init_cfg: initialize the pad config to default values
>   * @enum_mbus_code: callback for VIDIOC_SUBDEV_ENUM_MBUS_CODE ioctl handler
>   *		    code.
>   * @enum_frame_size: callback for VIDIOC_SUBDEV_ENUM_FRAME_SIZE ioctl handler
> @@ -607,6 +608,8 @@ struct v4l2_subdev_pad_config {
>   *                  may be adjusted by the subdev driver to device capabilities.
>   */
>  struct v4l2_subdev_pad_ops {
> +	int (*init_cfg)(struct v4l2_subdev *sd,
> +			struct v4l2_subdev_pad_config *cfg);
>  	int (*enum_mbus_code)(struct v4l2_subdev *sd,
>  			      struct v4l2_subdev_pad_config *cfg,
>  			      struct v4l2_subdev_mbus_code_enum *code);
> @@ -801,7 +804,12 @@ int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
>  				      struct v4l2_subdev_format *source_fmt,
>  				      struct v4l2_subdev_format *sink_fmt);
>  int v4l2_subdev_link_validate(struct media_link *link);
> +
> +struct v4l2_subdev_pad_config *
> +v4l2_subdev_alloc_pad_config(struct v4l2_subdev *sd);
> +void v4l2_subdev_free_pad_config(struct v4l2_subdev_pad_config *cfg);
>  #endif /* CONFIG_MEDIA_CONTROLLER */
> +
>  void v4l2_subdev_init(struct v4l2_subdev *sd,
>  		      const struct v4l2_subdev_ops *ops);
>  

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
