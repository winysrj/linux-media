Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:60865 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932234AbcKVKFw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 05:05:52 -0500
Subject: Re: [RFC v4 19/21] omap3isp: Allocate the media device dynamically
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk>
 <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
 <1478613330-24691-19-git-send-email-sakari.ailus@linux.intel.com>
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <99e22b20-12fd-1343-e682-c1fa0c79f074@xs4all.nl>
Date: Tue, 22 Nov 2016 11:05:49 +0100
MIME-Version: 1.0
In-Reply-To: <1478613330-24691-19-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/11/16 14:55, Sakari Ailus wrote:
> Use the new media_device_alloc() API to allocate and release the media
> device.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/platform/omap3isp/isp.c      | 24 +++++++++++++-----------
>  drivers/media/platform/omap3isp/isp.h      |  2 +-
>  drivers/media/platform/omap3isp/ispvideo.c |  2 +-
>  3 files changed, 15 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index 2e1b17e..8bc7a7c 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -1601,8 +1601,8 @@ static void isp_unregister_entities(struct isp_device *isp)
>  	omap3isp_stat_unregister_entities(&isp->isp_hist);
>
>  	v4l2_device_unregister(&isp->v4l2_dev);
> -	media_device_unregister(&isp->media_dev);
> -	media_device_cleanup(&isp->media_dev);
> +	media_device_unregister(isp->media_dev);
> +	media_device_put(isp->media_dev);
>  }
>
>  static int isp_link_entity(
> @@ -1680,14 +1680,16 @@ static int isp_register_entities(struct isp_device *isp)
>  {
>  	int ret;
>
> -	isp->media_dev.dev = isp->dev;
> -	strlcpy(isp->media_dev.model, "TI OMAP3 ISP",
> -		sizeof(isp->media_dev.model));
> -	isp->media_dev.hw_revision = isp->revision;
> -	isp->media_dev.ops = &isp_media_ops;
> -	media_device_init(&isp->media_dev);
> +	isp->media_dev = media_device_alloc(isp->dev, isp);
> +	if (!isp->media_dev)
> +		return -ENOMEM;
> +
> +	strlcpy(isp->media_dev->model, "TI OMAP3 ISP",
> +		sizeof(isp->media_dev->model));
> +	isp->media_dev->hw_revision = isp->revision;
> +	isp->media_dev->ops = &isp_media_ops;
>
> -	isp->v4l2_dev.mdev = &isp->media_dev;
> +	isp->v4l2_dev.mdev = isp->media_dev;
>  	ret = v4l2_device_register(isp->dev, &isp->v4l2_dev);
>  	if (ret < 0) {
>  		dev_err(isp->dev, "%s: V4L2 device registration failed (%d)\n",
> @@ -2165,7 +2167,7 @@ static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
>  	struct isp_bus_cfg *bus;
>  	int ret;
>
> -	ret = media_entity_enum_init(&isp->crashed, &isp->media_dev);
> +	ret = media_entity_enum_init(&isp->crashed, isp->media_dev);
>  	if (ret)
>  		return ret;
>
> @@ -2183,7 +2185,7 @@ static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
>  	if (ret < 0)
>  		return ret;
>
> -	return media_device_register(&isp->media_dev);
> +	return media_device_register(isp->media_dev);

I wonder if this is correct. Usually if the register fails, then the 
release/delete function
has to be called explicitly. That doesn't happen here.

E.g. from adv7604.c:

static int adv76xx_registered(struct v4l2_subdev *sd)
{
         struct adv76xx_state *state = to_state(sd);
         int err;

         err = cec_register_adapter(state->cec_adap);
         if (err)
                 cec_delete_adapter(state->cec_adap);
         return err;
}

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
> index 7354469..33e74b9 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -1104,7 +1104,7 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
>  	pipe = video->video.entity.pipe
>  	     ? to_isp_pipeline(&video->video.entity) : &video->pipe;
>
> -	ret = media_entity_enum_init(&pipe->ent_enum, &video->isp->media_dev);
> +	ret = media_entity_enum_init(&pipe->ent_enum, video->isp->media_dev);
>  	if (ret)
>  		goto err_enum_init;
>
>

Regards,

	Hans
