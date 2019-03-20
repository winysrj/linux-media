Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7679C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75D7B2184D
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553092132;
	bh=e1u1Yd5obrYxT5L05jbg7Vqd+X49eKuwle3dKDHI8KQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=eL8NRT/tDjZlJbxs8ayBRCx4480BcXJwIPmVqyESU0WFE9E2CzpteQTpqTB9TOlXG
	 RIgsEHf8ZrnE7V8d1auze1KyH6wuYlj9ggD+v7wJw4dfkkYcxqK0LqJ/9HdEg+TeqB
	 bXC/qGTJo2bNdZYarirs+gY13ZGneVArPqUHhX3Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbfCTO2v (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:28:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:40518 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfCTO2v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 10:28:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gVAp22eDiptErTPwMhUh1ZE5YxpW2K0kfetnrd+TG+I=; b=sL1jmkXX3yOkydWwUuLlYLB4Pz
        EL+D4ER4H6usKIp1akwvWH8ReM41Pjm7ZtOrsDYlUwqzk8c1he+jakVguZ2NGgVe9afap0SMQdnFT
        oiFs30bBpcNSR9xfrwjwa8MGDeYJPfy0JA3AYszTG51Lfiq5Q86g+qWuke7A1SNQaiXe8//Yni0Oz
        Ndsbp7wNqEEI/wl3SNSQzSCSflWNP0FZarOpBO7Ge3g+t6Ooe8VuhYp2Vp36+0DAMKjQ80PcAdOpk
        TRAZwQbyYlUDCk/9dJ24qXwjBcMGB5Baj+OQCbp5y4SKpDJfZSjhwB6fAQaTOes4yDpTUNYUIldyt
        /pND28Zg==;
Received: from [179.95.24.146] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h6cD3-0001KH-84; Wed, 20 Mar 2019 14:28:49 +0000
Date:   Wed, 20 Mar 2019 11:28:45 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     linux-media@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Subject: Re: [PATCH v5.1 3/2] media requests: return EBADR instead of EACCES
Message-ID: <20190320112838.7867f0f2@coco.lan>
In-Reply-To: <b5a3175c-ae01-0251-9b57-f24b2bbb3355@xs4all.nl>
References: <20190320123305.5224-1-hverkuil-cisco@xs4all.nl>
        <20190320123305.5224-3-hverkuil-cisco@xs4all.nl>
        <b5a3175c-ae01-0251-9b57-f24b2bbb3355@xs4all.nl>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 20 Mar 2019 15:23:07 +0100
Hans Verkuil <hverkuil-cisco@xs4all.nl> escreveu:

> If requests are used when they shouldn't, or not used when they should, then
> return EBADR (Invalid request descriptor) instead of EACCES.
> 
> The reason for this change is that EACCES has more to do with permissions
> (not being the owner of the resource), but in this case the request file
> descriptor is just wrong for the current mode of the device.
> 
> Update the documentation accordingly.

Looks OK to me.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
> diff --git a/Documentation/media/uapi/mediactl/request-api.rst b/Documentation/media/uapi/mediactl/request-api.rst
> index 1ad631e549fe..a74c82d95609 100644
> --- a/Documentation/media/uapi/mediactl/request-api.rst
> +++ b/Documentation/media/uapi/mediactl/request-api.rst
> @@ -93,7 +93,7 @@ A queued request cannot be modified anymore.
>  .. caution::
>     For :ref:`memory-to-memory devices <mem2mem>` you can use requests only for
>     output buffers, not for capture buffers. Attempting to add a capture buffer
> -   to a request will result in an ``EACCES`` error.
> +   to a request will result in an ``EBADR`` error.
> 
>  If the request contains configurations for multiple entities, individual drivers
>  may synchronize so the requested pipeline's topology is applied before the
> diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
> index 81ffdcb89057..b9a2e9dc707c 100644
> --- a/Documentation/media/uapi/v4l/buffer.rst
> +++ b/Documentation/media/uapi/v4l/buffer.rst
> @@ -326,7 +326,7 @@ struct v4l2_buffer
>  	Applications should not set ``V4L2_BUF_FLAG_REQUEST_FD`` for any ioctls
>  	other than :ref:`VIDIOC_QBUF <VIDIOC_QBUF>`.
> 
> -	If the device does not support requests, then ``EACCES`` will be returned.
> +	If the device does not support requests, then ``EBADR`` will be returned.
>  	If requests are supported but an invalid request file descriptor is
>  	given, then ``EINVAL`` will be returned.
> 
> diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> index 5739c3676062..dbf7b445a27b 100644
> --- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> @@ -111,7 +111,7 @@ in use. Setting it means that the buffer will not be passed to the driver
>  until the request itself is queued. Also, the driver will apply any
>  settings associated with the request for this buffer. This field will
>  be ignored unless the ``V4L2_BUF_FLAG_REQUEST_FD`` flag is set.
> -If the device does not support requests, then ``EACCES`` will be returned.
> +If the device does not support requests, then ``EBADR`` will be returned.
>  If requests are supported but an invalid request file descriptor is given,
>  then ``EINVAL`` will be returned.
> 
> @@ -125,7 +125,7 @@ then ``EINVAL`` will be returned.
> 
>     For :ref:`memory-to-memory devices <mem2mem>` you can specify the
>     ``request_fd`` only for output buffers, not for capture buffers. Attempting
> -   to specify this for a capture buffer will result in an ``EACCES`` error.
> +   to specify this for a capture buffer will result in an ``EBADR`` error.
> 
>  Applications call the ``VIDIOC_DQBUF`` ioctl to dequeue a filled
>  (capturing) or displayed (output) buffer from the driver's outgoing
> @@ -185,12 +185,10 @@ EPIPE
>      codecs if a buffer with the ``V4L2_BUF_FLAG_LAST`` was already
>      dequeued and no new buffers are expected to become available.
> 
> -EACCES
> -    The ``V4L2_BUF_FLAG_REQUEST_FD`` flag was set but the device does not
> -    support requests for the given buffer type.
> -
>  EBADR
> -    The ``V4L2_BUF_FLAG_REQUEST_FD`` flag was not set but the device requires
> +    The ``V4L2_BUF_FLAG_REQUEST_FD`` flag was set but the device does not
> +    support requests for the given buffer type, or
> +    the ``V4L2_BUF_FLAG_REQUEST_FD`` flag was not set but the device requires
>      that the buffer is part of a request.
> 
>  EBUSY
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index 84de18b30a95..b11a779e97b0 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -392,7 +392,7 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct media_device *md
>  		return 0;
>  	} else if (!q->supports_requests) {
>  		dprintk(1, "%s: queue does not support requests\n", opname);
> -		return -EACCES;
> +		return -EBADR;
>  	} else if (q->uses_qbuf) {
>  		dprintk(1, "%s: queue does not use requests\n", opname);
>  		return -EBUSY;
> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
> index eec2e2b2f6ec..ed87305b29f9 100644
> --- a/drivers/media/media-request.c
> +++ b/drivers/media/media-request.c
> @@ -251,7 +251,7 @@ media_request_get_by_fd(struct media_device *mdev, int request_fd)
> 
>  	if (!mdev || !mdev->ops ||
>  	    !mdev->ops->req_validate || !mdev->ops->req_queue)
> -		return ERR_PTR(-EACCES);
> +		return ERR_PTR(-EBADR);
> 
>  	filp = fget(request_fd);
>  	if (!filp)
> @@ -407,7 +407,7 @@ int media_request_object_bind(struct media_request *req,
>  	int ret = -EBUSY;
> 
>  	if (WARN_ON(!ops->release))
> -		return -EACCES;
> +		return -EBADR;
> 
>  	spin_lock_irqsave(&req->lock, flags);
> 
> diff --git a/include/media/media-request.h b/include/media/media-request.h
> index bd36d7431698..3cd25a2717ce 100644
> --- a/include/media/media-request.h
> +++ b/include/media/media-request.h
> @@ -198,7 +198,7 @@ void media_request_put(struct media_request *req);
>   * Get the request represented by @request_fd that is owned
>   * by the media device.
>   *
> - * Return a -EACCES error pointer if requests are not supported
> + * Return a -EBADR error pointer if requests are not supported
>   * by this driver. Return -EINVAL if the request was not found.
>   * Return the pointer to the request if found: the caller will
>   * have to call @media_request_put when it finished using the
> @@ -231,7 +231,7 @@ static inline void media_request_put(struct media_request *req)
>  static inline struct media_request *
>  media_request_get_by_fd(struct media_device *mdev, int request_fd)
>  {
> -	return ERR_PTR(-EACCES);
> +	return ERR_PTR(-EBADR);
>  }
> 
>  #endif



Thanks,
Mauro
