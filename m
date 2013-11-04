Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44553 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750789Ab3KDLUp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Nov 2013 06:20:45 -0500
Date: Mon, 4 Nov 2013 13:20:11 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	g@valkosipuli.retiisi.org.uk
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: omap3isp: Move code out of mutex-protected section
Message-ID: <20131104112010.GB21655@valkosipuli.retiisi.org.uk>
References: <1383559668-11003-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383559668-11003-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch.

On Mon, Nov 04, 2013 at 11:07:48AM +0100, Laurent Pinchart wrote:
> The pad::get_fmt call must be protected by a mutex, but preparing its
> arguments doesn't need to be. Move the non-critical code out of the
> mutex-protected section.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/platform/omap3isp/ispvideo.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
> index a908d00..f6304bb 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -339,14 +339,11 @@ __isp_video_get_format(struct isp_video *video, struct v4l2_format *format)
>  	if (subdev == NULL)
>  		return -EINVAL;
>  
> -	mutex_lock(&video->mutex);
> -
>  	fmt.pad = pad;
>  	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> -	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
> -	if (ret == -ENOIOCTLCMD)
> -		ret = -EINVAL;

By removing these lines, you're also returning -ENOIOCTLCMD to the caller.
Is this intentional?

That return value will end up to at least one place which seems to be
isp_video_streamon() and, unless I'm mistaken, will cause
ioctl(VIDIOC_STREAMON) also return ENOTTY.

> +	mutex_lock(&video->mutex);
> +	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
>  	mutex_unlock(&video->mutex);
>  
>  	if (ret)

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
