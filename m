Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:50315 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752762AbcHVMhA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 08:37:00 -0400
Subject: Re: [RFC v2 15/17] omap3isp: Allocate the media device dynamically
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <1471602228-30722-1-git-send-email-sakari.ailus@linux.intel.com>
 <1471602228-30722-16-git-send-email-sakari.ailus@linux.intel.com>
Cc: m.chehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <75a86d28-3c9d-9a2c-796f-64dc515bc1c8@xs4all.nl>
Date: Mon, 22 Aug 2016 14:36:55 +0200
MIME-Version: 1.0
In-Reply-To: <1471602228-30722-16-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No commit message?

On 08/19/2016 12:23 PM, Sakari Ailus wrote:
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/platform/omap3isp/isp.c      | 25 +++++++++++++------------
>  drivers/media/platform/omap3isp/isp.h      |  2 +-
>  drivers/media/platform/omap3isp/ispvideo.c |  2 +-
>  3 files changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index aa32537..1e42d37 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -1597,8 +1597,7 @@ static void isp_unregister_entities(struct isp_device *isp)
>  	omap3isp_stat_unregister_entities(&isp->isp_hist);
>  
>  	v4l2_device_unregister(&isp->v4l2_dev);
> -	media_device_unregister(&isp->media_dev);
> -	media_device_cleanup(&isp->media_dev);
> +	media_device_unregister(isp->media_dev);
>  }
>  
>  static int isp_link_entity(
> @@ -1676,14 +1675,16 @@ static int isp_register_entities(struct isp_device *isp)
>  {
>  	int ret;
>  
> -	isp->media_dev.dev = isp->dev;
> -	strlcpy(isp->media_dev.model, "TI OMAP3 ISP",
> -		sizeof(isp->media_dev.model));
> -	isp->media_dev.hw_revision = isp->revision;
> -	isp->media_dev.link_notify = v4l2_pipeline_link_notify;
> -	media_device_init(&isp->media_dev);
> +	isp->media_dev = media_device_alloc(isp->dev, isp, 0);
> +	if (!isp->media_dev)
> +		return -ENOMEM;
> +
> +	strlcpy(isp->media_dev->model, "TI OMAP3 ISP",
> +		sizeof(isp->media_dev->model));
> +	isp->media_dev->hw_revision = isp->revision;
> +	isp->media_dev->link_notify = v4l2_pipeline_link_notify;
>  
> -	isp->v4l2_dev.mdev = &isp->media_dev;
> +	isp->v4l2_dev.mdev = isp->media_dev;
>  	ret = v4l2_device_register(isp->dev, &isp->v4l2_dev);
>  	if (ret < 0) {
>  		dev_err(isp->dev, "%s: V4L2 device registration failed (%d)\n",
> @@ -1728,7 +1729,7 @@ static int isp_register_entities(struct isp_device *isp)
>  done:
>  	if (ret < 0) {
>  		isp_unregister_entities(isp);
> -		media_device_put(&isp->media_dev);
> +		media_device_put(isp->media_dev);

I am not sure if calling media_device_put is correct here, This only works if
the release callback is set for the media devnode, but that's done when the
media device is registered, which happens later.

I could be mistaken, though. It's hard to tell.

Regards,

	Hans

>  	}
>  
>  	return ret;
> @@ -2163,7 +2164,7 @@ static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
>  	struct isp_bus_cfg *bus;
>  	int ret;
>  
> -	ret = media_entity_enum_init(&isp->crashed, &isp->media_dev);
> +	ret = media_entity_enum_init(&isp->crashed, isp->media_dev);
>  	if (ret)
>  		return ret;
>  
> @@ -2181,7 +2182,7 @@ static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
>  	if (ret < 0)
>  		return ret;
>  
> -	return media_device_register(&isp->media_dev);
> +	return media_device_register(isp->media_dev);
>  }
>  
>  /*
> diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
> index 7e6f663..7378279 100644
> --- a/drivers/media/platform/omap3isp/isp.h
> +++ b/drivers/media/platform/omap3isp/isp.h
> @@ -176,7 +176,7 @@ struct isp_xclk {
>  struct isp_device {
>  	struct v4l2_device v4l2_dev;
>  	struct v4l2_async_notifier notifier;
> -	struct media_device media_dev;
> +	struct media_device *media_dev;
>  	struct device *dev;
>  	u32 revision;
>  
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
> index 7d9f359..45ef38c 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -1077,7 +1077,7 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
>  	pipe = video->video.entity.pipe
>  	     ? to_isp_pipeline(&video->video.entity) : &video->pipe;
>  
> -	ret = media_entity_enum_init(&pipe->ent_enum, &video->isp->media_dev);
> +	ret = media_entity_enum_init(&pipe->ent_enum, video->isp->media_dev);
>  	if (ret)
>  		goto err_enum_init;
>  
> 
