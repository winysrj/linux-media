Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33159 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751744AbeDJLEP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 07:04:15 -0400
Date: Tue, 10 Apr 2018 08:04:09 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv11 PATCH 06/29] media-request: add media_request_find
Message-ID: <20180410080409.76a0c638@vento.lan>
In-Reply-To: <20180409142026.19369-7-hverkuil@xs4all.nl>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
        <20180409142026.19369-7-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon,  9 Apr 2018 16:20:03 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add media_request_find() to find a request based on the file
> descriptor.
> 
> The caller has to call media_request_put() for the returned
> request since this function increments the refcount.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/media-request.c | 47 +++++++++++++++++++++++++++++++++++++++++++
>  include/media/media-request.h | 10 +++++++++
>  2 files changed, 57 insertions(+)
> 
> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
> index 27739ff7cb09..02b620c81de5 100644
> --- a/drivers/media/media-request.c
> +++ b/drivers/media/media-request.c
> @@ -207,6 +207,53 @@ static const struct file_operations request_fops = {
>  	.release = media_request_close,
>  };
>  
> +/**
> + * media_request_find - Find a request based on the file descriptor
> + * @mdev: The media device
> + * @request: The request file handle

request_id.

> + *
> + * Find and return the request associated with the given file descriptor, or
> + * an error if no such request exists.
> + *
> + * When the function returns a request it increases its reference count. The
> + * caller is responsible for releasing the reference by calling
> + * media_request_put() on the request.

IMHO, this can only be called with mutex held. Please add such note
here.

> + */
> +struct media_request *
> +media_request_find(struct media_device *mdev, int request_fd)
> +{
> +	struct file *filp;
> +	struct media_request *req;
> +
> +	if (!mdev || !mdev->ops || !mdev->ops->req_queue)
> +		return ERR_PTR(-EPERM);
> +
> +	filp = fget(request_fd);
> +	if (!filp)
> +		return ERR_PTR(-ENOENT);
> +
> +	if (filp->f_op != &request_fops)
> +		goto err_fput;
> +	req = filp->private_data;
> +	media_request_get(req);
> +
> +	if (req->mdev != mdev)
> +		goto err_kref_put;
> +
> +	fput(filp);
> +
> +	return req;
> +
> +err_kref_put:
> +	media_request_put(req);
> +
> +err_fput:
> +	fput(filp);
> +
> +	return ERR_PTR(-ENOENT);
> +}
> +EXPORT_SYMBOL_GPL(media_request_find);
> +
>  int media_request_alloc(struct media_device *mdev,
>  			struct media_request_alloc *alloc)
>  {
> diff --git a/include/media/media-request.h b/include/media/media-request.h
> index 082c3cae04ac..033697d493cd 100644
> --- a/include/media/media-request.h
> +++ b/include/media/media-request.h
> @@ -59,6 +59,9 @@ static inline void media_request_get(struct media_request *req)
>  void media_request_put(struct media_request *req);
>  void media_request_cancel(struct media_request *req);
>  
> +struct media_request *
> +media_request_find(struct media_device *mdev, int request_fd);
> +
>  int media_request_alloc(struct media_device *mdev,
>  			struct media_request_alloc *alloc);
>  #else
> @@ -74,6 +77,12 @@ static inline void media_request_cancel(struct media_request *req)
>  {
>  }
>  
> +static inline struct media_request *
> +media_request_find(struct media_device *mdev, int request_fd)
> +{
> +	return ERR_PTR(-ENOENT);
> +}
> +
>  #endif
>  
>  struct media_request_object_ops {
> @@ -173,6 +182,7 @@ static inline void media_request_object_unbind(struct media_request_object *obj)
>  static inline void media_request_object_complete(struct media_request_object *obj)
>  {
>  }
> +
>  #endif
>  
>  #endif



Thanks,
Mauro
