Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56012 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbaFDOQD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jun 2014 10:16:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH v2 2/5] [media] mt9v032: register v4l2 asynchronous subdevice
Date: Wed, 04 Jun 2014 16:16:30 +0200
Message-ID: <2505444.YzkDIeOsnF@avalon>
In-Reply-To: <1401788155-3690-3-git-send-email-p.zabel@pengutronix.de>
References: <1401788155-3690-1-git-send-email-p.zabel@pengutronix.de> <1401788155-3690-3-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thank you for the patch.

On Tuesday 03 June 2014 11:35:52 Philipp Zabel wrote:
> Add support for registering the sensor subdevice using the v4l2-async API.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v1:
>  - Fixed cleanup and error handling
> ---
>  drivers/media/i2c/mt9v032.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index 29d8d8f..83ae8ca6d 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -985,10 +985,20 @@ static int mt9v032_probe(struct i2c_client *client,
> 
>  	mt9v032->pad.flags = MEDIA_PAD_FL_SOURCE;
>  	ret = media_entity_init(&mt9v032->subdev.entity, 1, &mt9v032->pad, 0);
> +	if (ret < 0)
> +		goto err_entity;
> 
> +	mt9v032->subdev.dev = &client->dev;
> +	ret = v4l2_async_register_subdev(&mt9v032->subdev);
>  	if (ret < 0)
> -		v4l2_ctrl_handler_free(&mt9v032->ctrls);
> +		goto err_async;
> +
> +	return 0;
> 
> +err_async:
> +	media_entity_cleanup(&mt9v032->subdev.entity);

media_entity_cleanup() can safely be called on an unintialized entity, 
provided the memory has been zeroed. You could thus merge the err_async and 
err_entity labels into a single error label.

> +err_entity:
> +	v4l2_ctrl_handler_free(&mt9v032->ctrls);
>  	return ret;
>  }
> 
> @@ -997,6 +1007,7 @@ static int mt9v032_remove(struct i2c_client *client)
>  	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
>  	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
> 
> +	v4l2_async_unregister_subdev(subdev);
>  	v4l2_ctrl_handler_free(&mt9v032->ctrls);
>  	v4l2_device_unregister_subdev(subdev);
>  	media_entity_cleanup(&subdev->entity);

-- 
Regards,

Laurent Pinchart

