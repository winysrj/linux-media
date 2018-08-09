Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55348 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbeHIWpf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2018 18:45:35 -0400
Date: Thu, 9 Aug 2018 17:19:05 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv17 12/34] v4l2-ctrls: alloc memory for p_req
Message-ID: <20180809171905.14050d56@coco.lan>
In-Reply-To: <20180804124526.46206-13-hverkuil@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
        <20180804124526.46206-13-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat,  4 Aug 2018 14:45:04 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> To store request data the handler_new_ref() allocates memory
> for it if needed.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index b33a8bee82b0..171ab389afdd 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -2018,13 +2018,18 @@ EXPORT_SYMBOL(v4l2_ctrl_find);
>  /* Allocate a new v4l2_ctrl_ref and hook it into the handler. */
>  static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
>  			   struct v4l2_ctrl *ctrl,
> -			   bool from_other_dev)
> +			   struct v4l2_ctrl_ref **ctrl_ref,
> +			   bool from_other_dev, bool allocate_req)
>  {
>  	struct v4l2_ctrl_ref *ref;
>  	struct v4l2_ctrl_ref *new_ref;
>  	u32 id = ctrl->id;
>  	u32 class_ctrl = V4L2_CTRL_ID2WHICH(id) | 1;
>  	int bucket = id % hdl->nr_of_buckets;	/* which bucket to use */
> +	unsigned int sz_extra = 0;

Nitpick: I would name it size_extra_req, to make clear its usage.

Once renamed:

Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

> +
> +	if (ctrl_ref)
> +		*ctrl_ref = NULL;
>  
>  	/*
>  	 * Automatically add the control class if it is not yet present and
> @@ -2038,11 +2043,16 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
>  	if (hdl->error)
>  		return hdl->error;
>  
> -	new_ref = kzalloc(sizeof(*new_ref), GFP_KERNEL);
> +	if (allocate_req)
> +		sz_extra = ctrl->elems * ctrl->elem_size;
> +	new_ref = kzalloc(sizeof(*new_ref) + sz_extra, GFP_KERNEL);
>  	if (!new_ref)
>  		return handler_set_err(hdl, -ENOMEM);
>  	new_ref->ctrl = ctrl;
>  	new_ref->from_other_dev = from_other_dev;
> +	if (sz_extra)
> +		new_ref->p_req.p = &new_ref[1];
> +
>  	if (ctrl->handler == hdl) {
>  		/* By default each control starts in a cluster of its own.
>  		   new_ref->ctrl is basically a cluster array with one
> @@ -2082,6 +2092,8 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
>  	/* Insert the control node in the hash */
>  	new_ref->next = hdl->buckets[bucket];
>  	hdl->buckets[bucket] = new_ref;
> +	if (ctrl_ref)
> +		*ctrl_ref = new_ref;
>  
>  unlock:
>  	mutex_unlock(hdl->lock);
> @@ -2223,7 +2235,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>  		ctrl->type_ops->init(ctrl, idx, ctrl->p_new);
>  	}
>  
> -	if (handler_new_ref(hdl, ctrl, false)) {
> +	if (handler_new_ref(hdl, ctrl, NULL, false, false)) {
>  		kvfree(ctrl);
>  		return NULL;
>  	}
> @@ -2416,7 +2428,7 @@ int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
>  		/* Filter any unwanted controls */
>  		if (filter && !filter(ctrl))
>  			continue;
> -		ret = handler_new_ref(hdl, ctrl, from_other_dev);
> +		ret = handler_new_ref(hdl, ctrl, NULL, from_other_dev, false);
>  		if (ret)
>  			break;
>  	}



Thanks,
Mauro
