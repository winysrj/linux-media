Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47622 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbeHIWV0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2018 18:21:26 -0400
Date: Thu, 9 Aug 2018 16:55:00 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv17 05/34] media-request: add media_request_get_by_fd
Message-ID: <20180809165500.2cc89f72@coco.lan>
In-Reply-To: <20180804124526.46206-6-hverkuil@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
        <20180804124526.46206-6-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat,  4 Aug 2018 14:44:57 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add media_request_get_by_fd() to find a request based on the file
> descriptor.
> 
> The caller has to call media_request_put() for the returned
> request since this function increments the refcount.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/media-request.c | 40 +++++++++++++++++++++++++++++++++++
>  include/media/media-request.h | 24 +++++++++++++++++++++
>  2 files changed, 64 insertions(+)
> 
> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
> index 253068f51a1f..4b523f3a03a3 100644
> --- a/drivers/media/media-request.c
> +++ b/drivers/media/media-request.c
> @@ -231,6 +231,46 @@ static const struct file_operations request_fops = {
>  	.release = media_request_close,
>  };
>  
> +struct media_request *
> +media_request_get_by_fd(struct media_device *mdev, int request_fd)
> +{
> +	struct file *filp;
> +	struct media_request *req;
> +
> +	if (!mdev || !mdev->ops ||
> +	    !mdev->ops->req_validate || !mdev->ops->req_queue)
> +		return ERR_PTR(-EPERM);

EPERM? I guess ENOTTY would be better.

Any reason why using EPERM?

> +
> +	filp = fget(request_fd);
> +	if (!filp)
> +		return ERR_PTR(-ENOENT);
> +
> +	if (filp->f_op != &request_fops)
> +		goto err_fput;
> +	req = filp->private_data;
> +	if (req->mdev != mdev)
> +		goto err_fput;
> +
> +	/*
> +	 * Note: as long as someone has an open filehandle of the request,
> +	 * the request can never be released. The fget() above ensures that
> +	 * even if userspace closes the request filehandle, the release()
> +	 * fop won't be called, so the media_request_get() always succeeds
> +	 * and there is no race condition where the request was released
> +	 * before media_request_get() is called.
> +	 */
> +	media_request_get(req);
> +	fput(filp);
> +
> +	return req;
> +
> +err_fput:
> +	fput(filp);
> +
> +	return ERR_PTR(-ENOENT);
> +}
> +EXPORT_SYMBOL_GPL(media_request_get_by_fd);
> +
>  int media_request_alloc(struct media_device *mdev,
>  			struct media_request_alloc *alloc)
>  {
> diff --git a/include/media/media-request.h b/include/media/media-request.h
> index fe5a04fb970c..66ec9d09fcd8 100644
> --- a/include/media/media-request.h
> +++ b/include/media/media-request.h
> @@ -143,6 +143,24 @@ static inline void media_request_get(struct media_request *req)
>   */
>  void media_request_put(struct media_request *req);
>  
> +/**
> + * media_request_get_by_fd - Get a media request by fd
> + *
> + * @mdev: Media device this request belongs to
> + * @request_fd: The file descriptor of the request
> + *
> + * Get the request represented by @request_fd that is owned
> + * by the media device.
> + *
> + * Return a -EPERM error pointer if requests are not supported
> + * by this driver. Return -ENOENT if the request was not found.
> + * Return the pointer to the request if found: the caller will
> + * have to call @media_request_put when it finished using the
> + * request.
> + */
> +struct media_request *
> +media_request_get_by_fd(struct media_device *mdev, int request_fd);
> +
>  /**
>   * media_request_alloc - Allocate the media request
>   *
> @@ -164,6 +182,12 @@ static inline void media_request_put(struct media_request *req)
>  {
>  }
>  
> +static inline struct media_request *
> +media_request_get_by_fd(struct media_device *mdev, int request_fd)
> +{
> +	return ERR_PTR(-EPERM);

Again -ENOTTY sounds better.

> +}
> +
>  #endif
>  
>  /**

Feel free to add my reviewed-by if you change the error code to
ENOTTY:

Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>


Thanks,
Mauro
