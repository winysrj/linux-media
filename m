Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47836 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbeHIWXr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2018 18:23:47 -0400
Date: Thu, 9 Aug 2018 16:57:22 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv17 07/34] v4l2-device.h: add
 v4l2_device_supports_requests() helper
Message-ID: <20180809165722.3534d39d@coco.lan>
In-Reply-To: <20180804124526.46206-8-hverkuil@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
        <20180804124526.46206-8-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat,  4 Aug 2018 14:44:59 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add a simple helper function that tests if the driver supports
> the request API.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

> ---
>  include/media/v4l2-device.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
> index b330e4a08a6b..ac7677a183ff 100644
> --- a/include/media/v4l2-device.h
> +++ b/include/media/v4l2-device.h
> @@ -211,6 +211,17 @@ static inline void v4l2_subdev_notify(struct v4l2_subdev *sd,
>  		sd->v4l2_dev->notify(sd, notification, arg);
>  }
>  
> +/**
> + * v4l2_device_supports_requests - Test if requests are supported.
> + *
> + * @v4l2_dev: pointer to struct v4l2_device
> + */
> +static inline bool v4l2_device_supports_requests(struct v4l2_device *v4l2_dev)
> +{
> +	return v4l2_dev->mdev && v4l2_dev->mdev->ops &&
> +	       v4l2_dev->mdev->ops->req_queue;
> +}
> +
>  /* Helper macros to iterate over all subdevs. */
>  
>  /**



Thanks,
Mauro
