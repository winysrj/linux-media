Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9961 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750877AbeDIHUp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Apr 2018 03:20:45 -0400
Date: Mon, 9 Apr 2018 10:20:42 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Tomasz Figa <tfiga@google.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv9 PATCH 07/29] media-request: add media_request_object_find
Message-ID: <20180409072042.mf7lg4o7xg3h6wln@paasikivi.fi.intel.com>
References: <20180328135030.7116-1-hverkuil@xs4all.nl>
 <20180328135030.7116-8-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180328135030.7116-8-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Mar 28, 2018 at 03:50:08PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add media_request_object_find to find a request object inside a
> request based on ops and/or priv values.
> 
> Objects of the same type (vb2 buffer, control handler) will have
> the same ops value. And objects that refer to the same 'parent'
> object (e.g. the v4l2_ctrl_handler that has the current driver
> state) will have the same priv value.
> 
> The caller has to call media_request_object_put() for the returned
> object since this function increments the refcount.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/media-request.c | 26 ++++++++++++++++++++++++++
>  include/media/media-request.h | 25 +++++++++++++++++++++++++
>  2 files changed, 51 insertions(+)
> 
> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
> index d54fd353d8a6..10a05dd7b571 100644
> --- a/drivers/media/media-request.c
> +++ b/drivers/media/media-request.c
> @@ -309,6 +309,32 @@ static void media_request_object_release(struct kref *kref)
>  	obj->ops->release(obj);
>  }
>  
> +struct media_request_object *
> +media_request_object_find(struct media_request *req,
> +			  const struct media_request_object_ops *ops,
> +			  void *priv)
> +{
> +	struct media_request_object *obj;
> +	struct media_request_object *found = NULL;
> +	unsigned long flags;
> +
> +	if (!ops && !priv)
> +		return NULL;
> +
> +	spin_lock_irqsave(&req->lock, flags);
> +	list_for_each_entry(obj, &req->objects, list) {
> +		if ((!ops || obj->ops == ops) &&
> +		    (!priv || obj->priv == priv)) {

Do you have a use case for having matching priv but mismatching ops?

I think it'd be useful to require drivers to provide unique priv,
considering that it's risky to let them use the same while the VB2 request
object ops are always the same.

> +			media_request_object_get(obj);
> +			found = obj;
> +			break;
> +		}
> +	}
> +	spin_unlock_irqrestore(&req->lock, flags);
> +	return found;
> +}
> +EXPORT_SYMBOL_GPL(media_request_object_find);
> +
>  void media_request_object_put(struct media_request_object *obj)
>  {
>  	kref_put(&obj->kref, media_request_object_release);
> diff --git a/include/media/media-request.h b/include/media/media-request.h
> index c01b05570a31..570f3a205776 100644
> --- a/include/media/media-request.h
> +++ b/include/media/media-request.h
> @@ -122,6 +122,23 @@ static inline void media_request_object_get(struct media_request_object *obj)
>   */
>  void media_request_object_put(struct media_request_object *obj);
>  
> +/**
> + * media_request_object_find - Find an object in a request
> + *
> + * @ops: Find an object with this ops value, may be NULL.
> + * @priv: Find an object with this priv value, may be NULL.
> + *
> + * At least one of @ops and @priv must be non-NULL. If one of
> + * these is NULL, then skip checking for that field.
> + *
> + * Returns NULL if not found or the object (the refcount is increased
> + * in that case).
> + */
> +struct media_request_object *
> +media_request_object_find(struct media_request *req,
> +			  const struct media_request_object_ops *ops,
> +			  void *priv);
> +
>  /**
>   * media_request_object_init - Initialise a media request object
>   *
> @@ -154,6 +171,14 @@ static inline void media_request_object_put(struct media_request_object *obj)
>  {
>  }
>  
> +static inline struct media_request_object *
> +media_request_object_find(struct media_request *req,
> +			  const struct media_request_object_ops *ops,
> +			  void *priv)
> +{
> +	return NULL;
> +}
> +
>  static inline void media_request_object_init(struct media_request_object *obj)
>  {
>  	obj->ops = NULL;
> -- 
> 2.16.1
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
