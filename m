Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:39159 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754229AbbGXON4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 10:13:56 -0400
Message-ID: <55B247DC.4080606@xs4all.nl>
Date: Fri, 24 Jul 2015 16:12:44 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 05/13] v4l: subdev: Add pad config allocator and init
References: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk> <1437654103-26409-6-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1437654103-26409-6-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/23/2015 02:21 PM, William Towle wrote:
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
> ---
>  drivers/media/v4l2-core/v4l2-subdev.c |   19 ++++++++++++++++++-
>  include/media/v4l2-subdev.h           |   10 ++++++++++
>  2 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index 83615b8..951a9cf 100644
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
> index 370fc38..a03b600 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -486,6 +486,8 @@ struct v4l2_subdev_pad_config {
>   *                  may be adjusted by the subdev driver to device capabilities.
>   */
>  struct v4l2_subdev_pad_ops {
> +	void (*init_cfg)(struct v4l2_subdev *sd,
> +			 struct v4l2_subdev_pad_config *cfg);
>  	int (*enum_mbus_code)(struct v4l2_subdev *sd,
>  			      struct v4l2_subdev_pad_config *cfg,
>  			      struct v4l2_subdev_mbus_code_enum *code);
> @@ -680,7 +682,15 @@ int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
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

