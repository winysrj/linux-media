Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3507 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab3EJMPM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 May 2013 08:15:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [PATCH RFC 2/3] media: added managed v4l2 control initialization
Date: Fri, 10 May 2013 14:14:56 +0200
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com
References: <1368103965-15232-1-git-send-email-a.hajda@samsung.com> <1368103965-15232-3-git-send-email-a.hajda@samsung.com>
In-Reply-To: <1368103965-15232-3-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305101414.56981.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu May 9 2013 14:52:43 Andrzej Hajda wrote:
> This patch adds managed versions of initialization
> and cleanup functions for v4l2 control handler.

Looks good, but please add the header changes needed for this to this
patch instead of patch 3/3.

With that change you can add my:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c |   48 ++++++++++++++++++++++++++++++++++
>  include/media/v4l2-ctrls.h           |   27 +++++++++++++++++++
>  2 files changed, 75 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 6b56d7b..1f16405 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1411,6 +1411,54 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
>  }
>  EXPORT_SYMBOL(v4l2_ctrl_handler_free);
>  
> +static void devm_v4l2_ctrl_handler_release(struct device *dev, void *res)
> +{
> +	struct v4l2_ctrl_handler **hdl = res;
> +
> +	v4l2_ctrl_handler_free(*hdl);
> +}
> +
> +int devm_v4l2_ctrl_handler_init(struct device *dev,
> +				struct v4l2_ctrl_handler *hdl,
> +				unsigned nr_of_controls_hint)
> +{
> +	struct v4l2_ctrl_handler **dr;
> +	int rc;
> +
> +	dr = devres_alloc(devm_v4l2_ctrl_handler_release, sizeof(*dr),
> +			  GFP_KERNEL);
> +	if (!dr)
> +		return -ENOMEM;
> +
> +	rc = v4l2_ctrl_handler_init(hdl, nr_of_controls_hint);
> +	if (rc) {
> +		devres_free(dr);
> +		return rc;
> +	}
> +
> +	*dr = hdl;
> +	devres_add(dev, dr);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(devm_v4l2_ctrl_handler_init);
> +
> +static int devm_v4l2_ctrl_handler_match(struct device *dev, void *res,
> +					void *data)
> +{
> +	struct v4l2_ctrl_handler **this = res, **hdl = data;
> +
> +	return *this == *hdl;
> +}
> +
> +void devm_v4l2_ctrl_handler_free(struct device *dev,
> +				 struct v4l2_ctrl_handler *hdl)
> +{
> +	WARN_ON(devres_release(dev, devm_v4l2_ctrl_handler_release,
> +			       devm_v4l2_ctrl_handler_match, &hdl));
> +}
> +EXPORT_SYMBOL_GPL(devm_v4l2_ctrl_handler_free);
> +
>  /* For backwards compatibility: V4L2_CID_PRIVATE_BASE should no longer
>     be used except in G_CTRL, S_CTRL, QUERYCTRL and QUERYMENU when dealing
>     with applications that do not use the NEXT_CTRL flag.
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index f00d42b..a1d06db 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -283,6 +283,33 @@ int v4l2_ctrl_handler_init(struct v4l2_ctrl_handler *hdl,
>    */
>  void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl);
>  
> +/*
> + * devm_v4l2_ctrl_handler_init - managed control handler initialization
> + *
> + * @dev: Device for which @hdl belongs to.
> + *
> + * This is a managed version of v4l2_ctrl_handler_init. Handler initialized with
> + * this function will be automatically cleaned up on driver detach.
> + *
> + * If an handler initialized with this function needs to be cleaned up
> + * separately, devm_v4l2_ctrl_handler_free() must be used.
> + */
> +int devm_v4l2_ctrl_handler_init(struct device *dev,
> +				struct v4l2_ctrl_handler *hdl,
> +				unsigned nr_of_controls_hint);
> +
> +/**
> + * devm_v4l2_ctrl_handler_free - managed control handler free
> + *
> + * @dev: Device for which @hdl belongs to.
> + * @hdl: Handler to be cleaned up.
> + *
> + * This function should be used to manual free of an control handler
> + * initialized with devm_v4l2_ctrl_handler_init().
> + */
> +void devm_v4l2_ctrl_handler_free(struct device *dev,
> +				 struct v4l2_ctrl_handler *hdl);
> +
>  /** v4l2_ctrl_handler_setup() - Call the s_ctrl op for all controls belonging
>    * to the handler to initialize the hardware to the current control values.
>    * @hdl:	The control handler.
> 
