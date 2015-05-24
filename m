Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:45052 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980AbbEXWZn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2015 18:25:43 -0400
Message-ID: <55624FE0.1040307@xs4all.nl>
Date: Mon, 25 May 2015 00:25:36 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: Vaibhav Hiremath <vaibhav.hiremath@linaro.org>
Subject: Re: [PATCH v2] v4l: subdev: Add pad config allocator and init
References: <1432501800-3411-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1432501800-3411-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/24/2015 11:10 PM, Laurent Pinchart wrote:
> From: Laurent Pinchart <laurent.pinchart@linaro.org>
> 
> Add a new subdev operation to initialize a subdev pad config array, and
> a helper function to allocate and initialize the array. This can be used
> by bridge drivers to implement try format based on subdev pad
> operations.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@linaro.org>
> Acked-by: Vaibhav Hiremath <vaibhav.hiremath@linaro.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Note that before this goes in there should be at least one subdev driver that
implements init_cfg(). Perhaps adv7604?

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/v4l2-subdev.c | 19 ++++++++++++++++++-
>  include/media/v4l2-subdev.h           | 10 ++++++++++
>  2 files changed, 28 insertions(+), 1 deletion(-)
> 
> Changes since v1:
> 
> - Added v4l2_subdev_free_pad_config
> 
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index 63596063b213..d594fe566be2 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -35,7 +35,7 @@
>  static int subdev_fh_init(struct v4l2_subdev_fh *fh, struct v4l2_subdev *sd)
>  {
>  #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
> -	fh->pad = kzalloc(sizeof(*fh->pad) * sd->entity.num_pads, GFP_KERNEL);
> +	fh->pad = v4l2_subdev_alloc_pad_config(sd);
>  	if (fh->pad == NULL)
>  		return -ENOMEM;
>  #endif
> @@ -569,6 +569,23 @@ int v4l2_subdev_link_validate(struct media_link *link)
>  		sink, link, &source_fmt, &sink_fmt);
>  }
>  EXPORT_SYMBOL_GPL(v4l2_subdev_link_validate);
> +
> +struct v4l2_subdev_pad_config *v4l2_subdev_alloc_pad_config(struct v4l2_subdev *sd)
> +{
> +	struct v4l2_subdev_pad_config *cfg;
> +
> +	if (!sd->entity.num_pads)
> +		return NULL;
> +
> +	cfg = kcalloc(sd->entity.num_pads, sizeof(*cfg), GFP_KERNEL);
> +	if (!cfg)
> +		return NULL;
> +
> +	v4l2_subdev_call(sd, pad, init_cfg, cfg);
> +
> +	return cfg;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_subdev_alloc_pad_config);
>  #endif /* CONFIG_MEDIA_CONTROLLER */
>  
>  void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 8f5da73dacff..cf2ee07b0745 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -483,6 +483,8 @@ struct v4l2_subdev_pad_config {
>   *                  may be adjusted by the subdev driver to device capabilities.
>   */
>  struct v4l2_subdev_pad_ops {
> +	void (*init_cfg)(struct v4l2_subdev *sd,
> +			 struct v4l2_subdev_pad_config *cfg);
>  	int (*enum_mbus_code)(struct v4l2_subdev *sd,
>  			      struct v4l2_subdev_pad_config *cfg,
>  			      struct v4l2_subdev_mbus_code_enum *code);
> @@ -675,7 +677,15 @@ int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
>  				      struct v4l2_subdev_format *source_fmt,
>  				      struct v4l2_subdev_format *sink_fmt);
>  int v4l2_subdev_link_validate(struct media_link *link);
> +
> +struct v4l2_subdev_pad_config *v4l2_subdev_alloc_pad_config(struct v4l2_subdev *sd);
> +
> +static inline void v4l2_subdev_free_pad_config(struct v4l2_subdev_pad_config *cfg)
> +{
> +	kfree(cfg);
> +}
>  #endif /* CONFIG_MEDIA_CONTROLLER */
> +
>  void v4l2_subdev_init(struct v4l2_subdev *sd,
>  		      const struct v4l2_subdev_ops *ops);
>  
> 

