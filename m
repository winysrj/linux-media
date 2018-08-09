Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47750 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbeHIWXK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2018 18:23:10 -0400
Date: Thu, 9 Aug 2018 16:56:45 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv17 06/34] media-request: add media_request_object_find
Message-ID: <20180809165645.0bc83448@coco.lan>
In-Reply-To: <20180804124526.46206-7-hverkuil@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
        <20180804124526.46206-7-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat,  4 Aug 2018 14:44:58 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add media_request_object_find to find a request object inside a
> request based on ops and priv values.
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
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/media/media-request.c | 25 +++++++++++++++++++++++++
>  include/media/media-request.h | 28 ++++++++++++++++++++++++++++
>  2 files changed, 53 insertions(+)
> 
> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
> index 4b523f3a03a3..a5b70a4e613b 100644
> --- a/drivers/media/media-request.c
> +++ b/drivers/media/media-request.c
> @@ -344,6 +344,31 @@ static void media_request_object_release(struct kref *kref)
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
> +	if (WARN_ON(!ops || !priv))
> +		return NULL;
> +
> +	spin_lock_irqsave(&req->lock, flags);
> +	list_for_each_entry(obj, &req->objects, list) {
> +		if (obj->ops == ops && obj->priv == priv) {
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
> index 66ec9d09fcd8..fd08d7a431a1 100644
> --- a/include/media/media-request.h
> +++ b/include/media/media-request.h
> @@ -253,6 +253,26 @@ static inline void media_request_object_get(struct media_request_object *obj)
>   */
>  void media_request_object_put(struct media_request_object *obj);
>  
> +/**
> + * media_request_object_find - Find an object in a request
> + *
> + * @req: The media request
> + * @ops: Find an object with this ops value
> + * @priv: Find an object with this priv value
> + *
> + * Both @ops and @priv must be non-NULL.
> + *
> + * Returns the object pointer or NULL if not found. The caller must
> + * call media_request_object_put() once it finished using the object.
> + *
> + * Since this function needs to walk the list of objects it takes
> + * the @req->lock spin lock to make this safe.
> + */
> +struct media_request_object *
> +media_request_object_find(struct media_request *req,
> +			  const struct media_request_object_ops *ops,
> +			  void *priv);
> +
>  /**
>   * media_request_object_init - Initialise a media request object
>   *
> @@ -324,6 +344,14 @@ static inline void media_request_object_put(struct media_request_object *obj)
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



Thanks,
Mauro
