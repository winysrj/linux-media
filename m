Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40371 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab3EOLce (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 May 2013 07:32:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com
Subject: Re: [PATCH RFC v2 2/3] media: added managed v4l2 control initialization
Date: Wed, 15 May 2013 13:32:54 +0200
Message-ID: <1820945.rcN45v55i8@avalon>
In-Reply-To: <1368434086-9027-3-git-send-email-a.hajda@samsung.com>
References: <1368434086-9027-1-git-send-email-a.hajda@samsung.com> <1368434086-9027-3-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

Thank you for the patch.

On Monday 13 May 2013 10:34:45 Andrzej Hajda wrote:
> This patch adds managed versions of initialization
> and cleanup functions for v4l2 control handler.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> v2:
> 	- added missing struct device forward declaration,
> 	- corrected few comments
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c |   48 +++++++++++++++++++++++++++++++
>  include/media/v4l2-ctrls.h           |   31 ++++++++++++++++++++++
>  2 files changed, 79 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
> b/drivers/media/v4l2-core/v4l2-ctrls.c index ebb8e48..69c9b95 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1421,6 +1421,54 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler
> *hdl) }
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

I expect very few drivers to actually need devm_v4l2_ctrl_handler_free(), if 
any at all. Do you have a use case for that function at the moment ? If not, 
what about removing it for now and adding it later when (if) needed ?

> +
>  /* For backwards compatibility: V4L2_CID_PRIVATE_BASE should no longer
>     be used except in G_CTRL, S_CTRL, QUERYCTRL and QUERYMENU when dealing
>     with applications that do not use the NEXT_CTRL flag.
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 7343a27..1986b90 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -25,6 +25,7 @@
>  #include <linux/videodev2.h>
> 
>  /* forward references */
> +struct device;
>  struct file;
>  struct v4l2_ctrl_handler;
>  struct v4l2_ctrl_helper;
> @@ -306,6 +307,36 @@ int v4l2_ctrl_handler_init_class(struct
> v4l2_ctrl_handler *hdl, */
>  void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl);
> 
> +/*
> + * devm_v4l2_ctrl_handler_init - managed control handler initialization
> + *
> + * @dev: Device the @hdl belongs to.
> + * @hdl:	The control handler.
> + * @nr_of_controls_hint: A hint of how many controls this handler is
> + *		expected to refer to.
> + *
> + * This is a managed version of v4l2_ctrl_handler_init. Handler initialized
> with + * this function will be automatically cleaned up on driver detach. +
> *
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
> + * @dev: Device the @hdl belongs to.
> + * @hdl: Handler to be cleaned up.
> + *
> + * This function should be used to manual free of an control handler
> + * initialized with devm_v4l2_ctrl_handler_init().
> + */
> +void devm_v4l2_ctrl_handler_free(struct device *dev,
> +				 struct v4l2_ctrl_handler *hdl);
> +
>  /** v4l2_ctrl_handler_setup() - Call the s_ctrl op for all controls
> belonging * to the handler to initialize the hardware to the current
> control values. * @hdl:	The control handler.
-- 
Regards,

Laurent Pinchart

