Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:51106 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754403AbeALLhx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 06:37:53 -0500
Subject: Re: [RFC PATCH 6/9] media: vb2: add support for requests in QBUF
 ioctl
To: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20171215075625.27028-1-acourbot@chromium.org>
 <20171215075625.27028-7-acourbot@chromium.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <39a23bdb-8493-d47f-7596-e4954743766b@xs4all.nl>
Date: Fri, 12 Jan 2018 12:37:48 +0100
MIME-Version: 1.0
In-Reply-To: <20171215075625.27028-7-acourbot@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/15/17 08:56, Alexandre Courbot wrote:
> Support the request argument of the QBUF ioctl.
> 
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 93 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 92 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 8d041247e97f..28f9c368563e 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -29,6 +29,7 @@
>  #include <media/v4l2-device.h>
>  #include <media/videobuf2-v4l2.h>
>  #include <media/v4l2-mc.h>
> +#include <media/media-request.h>
>  
>  #include <trace/events/v4l2.h>
>  
> @@ -965,6 +966,81 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
>  	return -EINVAL;
>  }
>  
> +/*
> + * Validate that a given request can be used during an ioctl.
> + *
> + * When using the request API, request file descriptors must be matched against
> + * the actual request object. User-space can pass any file descriptor, so we
> + * need to make sure the call is valid before going further.
> + *
> + * This function looks up the request and associated data and performs the
> + * following sanity checks:
> + *
> + * * Make sure that the entity supports requests,
> + * * Make sure that the entity belongs to the media_device managing the passed
> + *   request,
> + * * Make sure that the entity data (if any) is associated to the current file
> + *   handler.
> + *
> + * This function returns a pointer to the valid request, or and error code in
> + * case of failure. When successful, a reference to the request is acquired and
> + * must be properly released.
> + */
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +static struct media_request *
> +check_request(int request, struct file *file, void *fh)
> +{
> +	struct media_request *req = NULL;
> +	struct video_device *vfd = video_devdata(file);
> +	struct v4l2_fh *vfh =
> +		test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
> +	struct media_entity *entity = &vfd->entity;
> +	const struct media_entity *ent;
> +	struct media_request_entity_data *data;
> +	bool found = false;
> +
> +	if (!entity)
> +		return ERR_PTR(-EINVAL);
> +
> +	/* Check that the entity supports requests */
> +	if (!entity->req_ops)
> +		return ERR_PTR(-ENOTSUPP);
> +
> +	req = media_request_get_from_fd(request);

You can get the media_device from vfd->v4l2_dev->mdev. So it is much easier
to just pass the media_device as an argument to media_request_get_from_fd()...

> +	if (!req)
> +		return ERR_PTR(-EINVAL);
> +
> +	/* Validate that the entity belongs to the media_device managing
> +	 * the request queue */
> +	media_device_for_each_entity(ent, req->queue->mdev) {
> +		if (entity == ent) {
> +			found = true;
> +			break;
> +		}
> +	}
> +	if (!found) {
> +		media_request_put(req);
> +		return ERR_PTR(-EINVAL);
> +	}

...and then you don't need to do this ^^^ extra validation check.

> +
> +	/* Validate that the entity's data belongs to the correct fh */
> +	data = media_request_get_entity_data(req, entity, vfh);
> +	if (IS_ERR(data)) {
> +		media_request_put(req);
> +		return ERR_PTR(PTR_ERR(data));
> +	}

This assumes that each filehandle has its own state. That's true for codecs,
but not for most (all?) other devices. There the state is per device instance.

I'm not sure if we have a unique identifying mark for such drivers. The closest
is checking if fh->m2m_ctx is non-NULL, but I don't know if all drivers with
per-filehandle state use that field. An alternative might be to check if
fh->ctrl_handler is non-NULL. But again, I'm not sure if that's a 100% valid
check.

> +
> +	return req;
> +}
> +#else /* CONFIG_MEDIA_CONTROLLER */
> +static struct media_request *
> +check_request(int request, struct file *file, void *fh)
> +{
> +	return ERR_PTR(-ENOTSUPP);
> +}
> +
> +#endif /* CONFIG_MEDIA_CONTROLLER */
> +
>  static void v4l_sanitize_format(struct v4l2_format *fmt)
>  {
>  	unsigned int offset;
> @@ -1902,10 +1978,25 @@ static int v4l_querybuf(const struct v4l2_ioctl_ops *ops,
>  static int v4l_qbuf(const struct v4l2_ioctl_ops *ops,
>  				struct file *file, void *fh, void *arg)
>  {
> +	struct media_request *req = NULL;
>  	struct v4l2_buffer *p = arg;
>  	int ret = check_fmt(file, p->type);
>  
> -	return ret ? ret : ops->vidioc_qbuf(file, fh, p);
> +	if (ret)
> +		return ret;
> +
> +	if (p->request > 0) {
> +		req = check_request(p->request, file, fh);
> +		if (IS_ERR(req))
> +			return PTR_ERR(req);
> +	}
> +
> +	ret = ops->vidioc_qbuf(file, fh, p);
> +
> +	if (req)
> +		media_request_put(req);
> +
> +	return ret;
>  }
>  
>  static int v4l_dqbuf(const struct v4l2_ioctl_ops *ops,
> 

Regards,

	Hans
