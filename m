Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:55356 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3GXL01 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 07:26:27 -0400
Date: Wed, 24 Jul 2013 13:26:08 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: linux-media@vger.kernel.org, prabhakar.csengg@gmail.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com
Subject: Re: [PATCH RFC 4/5] V4L2: Rename subdev field of struct v4l2_async_notifier
In-Reply-To: <1374516287-7638-5-git-send-email-s.nawrocki@samsung.com>
Message-ID: <Pine.LNX.4.64.1307241322100.30777@axis700.grange>
References: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
 <1374516287-7638-5-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester

On Mon, 22 Jul 2013, Sylwester Nawrocki wrote:

> This is a purely cosmetic change. Since the 'subdev' member
> points to an array of subdevs it seems more intuitive to name
> it in plural form.

Well, I was aware of the fact, that "subdev" is an array and that the 
plural form of "subdev" would be "subdevs" :-) It was kind of a conscious 
choice. I think, both ways can be found in the kernel: using singulars and 
plurals for array names. Whether one of them is better than the other - no 
idea. My personal preference is somewhat with the singular form as in, say 
"subdev array" instead of "subdevs array," i.e. as an adjective, but I 
really don't care all that much :) Feel free to change if that's important 
for you or for others on V4L :)

Thanks
Guennadi

> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/platform/soc_camera/soc_camera.c |    2 +-
>  drivers/media/v4l2-core/v4l2-async.c           |    2 +-
>  include/media/v4l2-async.h                     |    4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index 8af572b..4b42572 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -1501,7 +1501,7 @@ static int scan_async_group(struct soc_camera_host *ici,
>  		return -ENOMEM;
>  	}
>  
> -	sasc->notifier.subdev = asd;
> +	sasc->notifier.subdevs = asd;
>  	sasc->notifier.num_subdevs = size;
>  	sasc->notifier.bound = soc_camera_async_bound;
>  	sasc->notifier.unbind = soc_camera_async_unbind;
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 9f91013..ed31a65 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -147,7 +147,7 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  	INIT_LIST_HEAD(&notifier->done);
>  
>  	for (i = 0; i < notifier->num_subdevs; i++) {
> -		asd = notifier->subdev[i];
> +		asd = notifier->subdevs[i];
>  
>  		switch (asd->match_type) {
>  		case V4L2_ASYNC_MATCH_CUSTOM:
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> index 295782e..4e7834a 100644
> --- a/include/media/v4l2-async.h
> +++ b/include/media/v4l2-async.h
> @@ -77,7 +77,7 @@ struct v4l2_async_subdev_list {
>  /**
>   * v4l2_async_notifier - v4l2_device notifier data
>   * @num_subdevs:number of subdevices
> - * @subdev:	array of pointers to subdevice descriptors
> + * @subdevs:	array of pointers to subdevice descriptors
>   * @v4l2_dev:	pointer to struct v4l2_device
>   * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
>   * @done:	list of struct v4l2_async_subdev_list, already probed
> @@ -88,7 +88,7 @@ struct v4l2_async_subdev_list {
>   */
>  struct v4l2_async_notifier {
>  	unsigned int num_subdevs;
> -	struct v4l2_async_subdev **subdev;
> +	struct v4l2_async_subdev **subdevs;
>  	struct v4l2_device *v4l2_dev;
>  	struct list_head waiting;
>  	struct list_head done;
> -- 
> 1.7.9.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
