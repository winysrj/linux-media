Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:55008 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750AbbEXIAw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2015 04:00:52 -0400
Message-ID: <5561852C.1020608@xs4all.nl>
Date: Sun, 24 May 2015 10:00:44 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: subdev: Add pad config allocator and init
References: <12906805.RcB5KU0kGN@avalon>
In-Reply-To: <12906805.RcB5KU0kGN@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Looks good, but I have one question. See below.

On 05/23/2015 08:24 PM, Laurent Pinchart wrote:
> Add a new subdev operation to initialize a subdev pad config array, and
> a helper function to allocate and initialize the array. This can be used
> by bridge drivers to implement try format based on subdev pad
> operations.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@linaro.org>
> Acked-by: Vaibhav Hiremath <vaibhav.hiremath@linaro.org>
> ---
>  drivers/media/v4l2-core/v4l2-subdev.c | 19 ++++++++++++++++++-
>  include/media/v4l2-subdev.h           |  3 +++
>  2 files changed, 21 insertions(+), 1 deletion(-)
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
> index 8f5da73dacff..7860d67574f5 100644
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
> @@ -675,6 +677,7 @@ int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
>  				      struct v4l2_subdev_format *source_fmt,
>  				      struct v4l2_subdev_format *sink_fmt);
>  int v4l2_subdev_link_validate(struct media_link *link);
> +struct v4l2_subdev_pad_config *v4l2_subdev_alloc_pad_config(struct v4l2_subdev *sd);

Would it make sense to add a simple static inline v4l2_subdev_free_pad_config here?
All it does is a kfree, but still it makes it symmetrical and if we ever need to
do more than a kfree, then we are able to do so.

At the very least this header needs a comment if we don't add a free_pad_config that
the caller needs to kfree the pointer.

Regards,

	Hans

>  #endif /* CONFIG_MEDIA_CONTROLLER */
>  void v4l2_subdev_init(struct v4l2_subdev *sd,
>  		      const struct v4l2_subdev_ops *ops);
> 

