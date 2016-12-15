Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48066 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751520AbcLOMNG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 07:13:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, javier@osg.samsung.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH RFC] omap3isp: prevent releasing MC too early
Date: Thu, 15 Dec 2016 14:13:42 +0200
Message-ID: <3043978.ViByGAdkJL@avalon>
In-Reply-To: <20161214151406.20380-1-mchehab@s-opensource.com>
References: <20161214151406.20380-1-mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

(CC'ing Greg)

On Wednesday 14 Dec 2016 13:14:06 Mauro Carvalho Chehab wrote:
> Avoid calling streamoff without having the media structs allocated.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

The driver has a maintainer listed in MAINTAINERS, and you know that Sakari is 
also actively involved here. You could have CC'ed us.

> ---
> 
> Javier,
> 
> Could you please test this patch?
> 
> Thanks!
> Mauro
> 
>  drivers/media/platform/omap3isp/ispvideo.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c
> b/drivers/media/platform/omap3isp/ispvideo.c index
> 7354469670b7..f60995ed0a1f 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -1488,11 +1488,17 @@ int omap3isp_video_register(struct isp_video *video,
> struct v4l2_device *vdev) "%s: could not register video device (%d)\n",
>  			__func__, ret);
> 
> +	/* Prevent destroying MC before unregistering */
> +	kobject_get(vdev->v4l2_dev->mdev->devnode->dev.parent);

This doesn't even compile. Please make sure to at least compile-test patches 
you send for review, otherwise you end up wasting time for all reviewers and 
testers. I assume you meant

	kobject_get(&vdev->mdev->devnode->dev.parent->kobj);

and similarly below.

That's a long list of pointer dereferences, going deep down the device core. 
Greg, are drivers allowed to do this by the driver model ?

> +
>  	return ret;
>  }
> 
>  void omap3isp_video_unregister(struct isp_video *video)
>  {
> -	if (video_is_registered(&video->video))
> -		video_unregister_device(&video->video);
> +	if (!video_is_registered(&video->video))
> +		return;
> +
> +	video_unregister_device(&video->video);
> +	kobject_put(vdev->v4l2_dev->mdev->devnode->dev.parent);
>  }

-- 
Regards,

Laurent Pinchart

