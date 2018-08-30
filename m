Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60170 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728138AbeH3OQ5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Aug 2018 10:16:57 -0400
Date: Thu, 30 Aug 2018 13:15:31 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 09/10] media-request: EPERM -> EACCES
Message-ID: <20180830101531.fbb2srjjl2y5ql5o@valkosipuli.retiisi.org.uk>
References: <20180828134911.44086-1-hverkuil@xs4all.nl>
 <20180828134911.44086-10-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180828134911.44086-10-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks a lot for working on this!

On Tue, Aug 28, 2018 at 03:49:10PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> If requests are not supported by the driver, then return EACCES, not
> EPERM. This is consistent with the error that an invalid request_fd will
> give, and if requests are not supported, then all request_fd values are
> invalid.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/media/uapi/v4l/buffer.rst           |  2 +-
>  .../media/uapi/v4l/vidioc-g-ext-ctrls.rst         |  9 ++++-----
>  Documentation/media/uapi/v4l/vidioc-qbuf.rst      | 15 +++++++++------
>  drivers/media/media-request.c                     |  4 ++--
>  4 files changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
> index 1865cd5b9d3c..58a6d7d336e6 100644
> --- a/Documentation/media/uapi/v4l/buffer.rst
> +++ b/Documentation/media/uapi/v4l/buffer.rst
> @@ -314,7 +314,7 @@ struct v4l2_buffer
>  	:ref:`ioctl VIDIOC_QBUF <VIDIOC_QBUF>` and ignored by other ioctls.
>  	Applications should not set ``V4L2_BUF_FLAG_REQUEST_FD`` for any ioctls
>  	other than :ref:`VIDIOC_QBUF <VIDIOC_QBUF>`.
> -	If the device does not support requests, then ``EPERM`` will be returned.
> +	If the device does not support requests, then ``EACCES`` will be returned.
>  	If requests are supported but an invalid request file descriptor is
>  	given, then ``EINVAL`` will be returned.
>  
> diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
> index ad8908ce3095..54a999df5aec 100644
> --- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
> @@ -100,7 +100,7 @@ file descriptor and ``which`` is set to ``V4L2_CTRL_WHICH_REQUEST_VAL``,
>  then the controls are not applied immediately when calling
>  :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`, but instead are applied by
>  the driver for the buffer associated with the same request.
> -If the device does not support requests, then ``EPERM`` will be returned.
> +If the device does not support requests, then ``EACCES`` will be returned.
>  If requests are supported but an invalid request file descriptor is given,
>  then ``EINVAL`` will be returned.
>  
> @@ -233,7 +233,7 @@ still cause this situation.
>  	these controls have to be retrieved from a request or tried/set for
>  	a request. In the latter case the ``request_fd`` field contains the
>  	file descriptor of the request that should be used. If the device
> -	does not support requests, then ``EPERM`` will be returned.
> +	does not support requests, then ``EACCES`` will be returned.
>  
>  	.. note::
>  
> @@ -299,7 +299,7 @@ still cause this situation.
>        - ``request_fd``
>        - File descriptor of the request to be used by this operation. Only
>  	valid if ``which`` is set to ``V4L2_CTRL_WHICH_REQUEST_VAL``.
> -	If the device does not support requests, then ``EPERM`` will be returned.
> +	If the device does not support requests, then ``EACCES`` will be returned.
>  	If requests are supported but an invalid request file descriptor is
>  	given, then ``EINVAL`` will be returned.
>      * - __u32
> @@ -408,6 +408,5 @@ EACCES
>      control, or to get a control from a request that has not yet been
>      completed.
>  
> -EPERM

-EACCES here, too?

> -    The ``which`` field was set to ``V4L2_CTRL_WHICH_REQUEST_VAL`` but the
> +    Or the ``which`` field was set to ``V4L2_CTRL_WHICH_REQUEST_VAL`` but the
>      device does not support requests.
> diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> index 7bff69c15452..a2f4ac0b0ba1 100644
> --- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> @@ -104,7 +104,7 @@ in use. Setting it means that the buffer will not be passed to the driver
>  until the request itself is queued. Also, the driver will apply any
>  settings associated with the request for this buffer. This field will
>  be ignored unless the ``V4L2_BUF_FLAG_REQUEST_FD`` flag is set.
> -If the device does not support requests, then ``EPERM`` will be returned.
> +If the device does not support requests, then ``EACCES`` will be returned.
>  If requests are supported but an invalid request file descriptor is given,
>  then ``EINVAL`` will be returned.
>  
> @@ -175,9 +175,12 @@ EPIPE
>      codecs if a buffer with the ``V4L2_BUF_FLAG_LAST`` was already
>      dequeued and no new buffers are expected to become available.
>  
> -EPERM
> +EACCES
>      The ``V4L2_BUF_FLAG_REQUEST_FD`` flag was set but the device does not
> -    support requests. Or the first buffer was queued via a request, but
> -    the application now tries to queue it directly, or vice versa (it is
> -    not permitted to mix the two APIs). Or an attempt is made to queue a
> -    CAPTURE buffer to a request for a :ref:`memory-to-memory device <codec>`.
> +    support requests.
> +
> +EPERM
> +    The first buffer was queued via a request, but the application now tries
> +    to queue it directly, or vice versa (it is not permitted to mix the two
> +    APIs). Or an attempt is made to queue a CAPTURE buffer to a request for a
> +    :ref:`memory-to-memory device <codec>`.

This is still apparently not quite the error code it should be --- EPERM is
about lacking permissions, not that the user did something that isn't
possible. We should not use an error code that has a well established
meaning everywhere else in uAPI already for a purpose that is very
different.

If you think this needs to be something else than EACCES (which I think is
perfectly fine), then how about EDOM or EBUSY?

> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
> index 414197645e09..4e9db1fed697 100644
> --- a/drivers/media/media-request.c
> +++ b/drivers/media/media-request.c
> @@ -249,7 +249,7 @@ media_request_get_by_fd(struct media_device *mdev, int request_fd)
>  
>  	if (!mdev || !mdev->ops ||
>  	    !mdev->ops->req_validate || !mdev->ops->req_queue)
> -		return ERR_PTR(-EPERM);
> +		return ERR_PTR(-EACCES);
>  
>  	filp = fget(request_fd);
>  	if (!filp)
> @@ -405,7 +405,7 @@ int media_request_object_bind(struct media_request *req,
>  	int ret = -EBUSY;
>  
>  	if (WARN_ON(!ops->release))
> -		return -EPERM;
> +		return -EACCES;
>  
>  	spin_lock_irqsave(&req->lock, flags);
>  

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
