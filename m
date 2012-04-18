Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43761 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab2DRKFI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 06:05:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L2: mt9m032: use the available subdev pointer, don't re-calculate it
Date: Wed, 18 Apr 2012 12:05:21 +0200
Message-ID: <14832954.2IxnYJWIfT@avalon>
In-Reply-To: <Pine.LNX.4.64.1204181000000.30514@axis700.grange>
References: <Pine.LNX.4.64.1204181000000.30514@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the patch.

On Wednesday 18 April 2012 10:00:52 Guennadi Liakhovetski wrote:
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

And applied to my tree.

> ---
>  drivers/media/video/mt9m032.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
> index 7636672..6f1ae54 100644
> --- a/drivers/media/video/mt9m032.c
> +++ b/drivers/media/video/mt9m032.c
> @@ -837,9 +837,9 @@ static int mt9m032_remove(struct i2c_client *client)
>  	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
>  	struct mt9m032 *sensor = to_mt9m032(subdev);
> 
> -	v4l2_device_unregister_subdev(&sensor->subdev);
> +	v4l2_device_unregister_subdev(subdev);
>  	v4l2_ctrl_handler_free(&sensor->ctrls);
> -	media_entity_cleanup(&sensor->subdev.entity);
> +	media_entity_cleanup(&subdev->entity);
>  	mutex_destroy(&sensor->lock);
>  	kfree(sensor);
>  	return 0;

-- 
Regards,

Laurent Pinchart

