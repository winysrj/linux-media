Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55220 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbeHIWnR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2018 18:43:17 -0400
Date: Thu, 9 Aug 2018 17:16:47 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>
Subject: Re: [PATCHv17 11/34] v4l2-ctrls: prepare internal structs for
 request API
Message-ID: <20180809171647.1e4fc482@coco.lan>
In-Reply-To: <20180804124526.46206-12-hverkuil@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
        <20180804124526.46206-12-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat,  4 Aug 2018 14:45:03 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Embed and initialize a media_request_object in struct v4l2_ctrl_handler.
> 
> Add a p_req field to struct v4l2_ctrl_ref that will store the
> request value.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>

Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c |  1 +
>  include/media/v4l2-ctrls.h           | 10 ++++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 404291f00715..b33a8bee82b0 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1901,6 +1901,7 @@ int v4l2_ctrl_handler_init_class(struct v4l2_ctrl_handler *hdl,
>  				      sizeof(hdl->buckets[0]),
>  				      GFP_KERNEL | __GFP_ZERO);
>  	hdl->error = hdl->buckets ? 0 : -ENOMEM;
> +	media_request_object_init(&hdl->req_obj);

I don't like very much the idea of initializing it even when the
request API won't work, e. g. :

	if (!mdev->ops || !mdev->ops->req_validate || !mdev->ops->req_queue)

but I guess it would be too early to check it here, right?

>  	return hdl->error;
>  }
>  EXPORT_SYMBOL(v4l2_ctrl_handler_init_class);
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 192e31c21faf..3f4e062d4e3d 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -20,6 +20,7 @@
>  #include <linux/list.h>
>  #include <linux/mutex.h>
>  #include <linux/videodev2.h>
> +#include <media/media-request.h>
>  
>  /* forward references */
>  struct file;
> @@ -249,6 +250,11 @@ struct v4l2_ctrl {
>   *		``prepare_ext_ctrls`` function at ``v4l2-ctrl.c``.
>   * @from_other_dev: If true, then @ctrl was defined in another
>   *		device than the &struct v4l2_ctrl_handler.
> + * @p_req:	If the control handler containing this control reference
> + *		is bound to a media request, then this points to the
> + *		value of the control that should be applied when the request
> + *		is executed, or to the value of the control at the time
> + *		that the request was completed.
>   *
>   * Each control handler has a list of these refs. The list_head is used to
>   * keep a sorted-by-control-ID list of all controls, while the next pointer
> @@ -260,6 +266,7 @@ struct v4l2_ctrl_ref {
>  	struct v4l2_ctrl *ctrl;
>  	struct v4l2_ctrl_helper *helper;
>  	bool from_other_dev;
> +	union v4l2_ctrl_ptr p_req;
>  };
>  
>  /**
> @@ -283,6 +290,8 @@ struct v4l2_ctrl_ref {
>   * @notify_priv: Passed as argument to the v4l2_ctrl notify callback.
>   * @nr_of_buckets: Total number of buckets in the array.
>   * @error:	The error code of the first failed control addition.
> + * @req_obj:	The &struct media_request_object, used to link into a
> + *		&struct media_request. This request object has a refcount.
>   */
>  struct v4l2_ctrl_handler {
>  	struct mutex _lock;
> @@ -295,6 +304,7 @@ struct v4l2_ctrl_handler {
>  	void *notify_priv;
>  	u16 nr_of_buckets;
>  	int error;
> +	struct media_request_object req_obj;
>  };
>  
>  /**



Thanks,
Mauro
