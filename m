Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2303 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab1IPItv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Sep 2011 04:49:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH/RFC] preserve video-device parent, set by the driver
Date: Fri, 16 Sep 2011 10:49:39 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <Pine.LNX.4.64.1109152119130.11565@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109152119130.11565@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109161049.39488.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, September 15, 2011 21:25:17 Guennadi Liakhovetski wrote:
> There doesn't seem to be any real requirement to override video-device 
> parent, set by the driver, even if a v4l2-device is linked to the 
> video-device, being registered. Let the driver control the parent pointer, 
> if it needs to.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> Marked as RFC, because I'm not sure, that there's no some hidden meaning 
> in this parent pointer manipulation. However, I haven't been able to find 
> any.

The idea is that the vdev->parent pointer will disappear once all drivers are
converted to struct v4l2_device. So any driver that already uses v4l2_device
shouldn't touch vdev->parent.

So this patch isn't correct. Adding a comment explaining this probably
wouldn't hurt, though :-)

Regards,

	Hans

> 
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> index 06f1400..728ebaf 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -576,7 +576,7 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
>  	vdev->vfl_type = type;
>  	vdev->cdev = NULL;
>  	if (vdev->v4l2_dev) {
> -		if (vdev->v4l2_dev->dev)
> +		if (vdev->v4l2_dev->dev && !vdev->parent)
>  			vdev->parent = vdev->v4l2_dev->dev;
>  		if (vdev->ctrl_handler == NULL)
>  			vdev->ctrl_handler = vdev->v4l2_dev->ctrl_handler;
> 
