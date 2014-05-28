Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33676 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbaE1LQV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 May 2014 07:16:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] mt9v032: register v4l2 asynchronous subdevice
Date: Wed, 28 May 2014 13:16:40 +0200
Message-ID: <14598510.Vt3YXH2eJa@avalon>
In-Reply-To: <1401112645-14884-1-git-send-email-p.zabel@pengutronix.de>
References: <1401112645-14884-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thank you for the patch.

On Monday 26 May 2014 15:57:25 Philipp Zabel wrote:
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Now that Mauro starts to enforce commit message, I'll need to ask you to 
provide one :-)

> ---
>  drivers/media/i2c/mt9v032.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index 29d8d8f..ded97c2 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -985,6 +985,11 @@ static int mt9v032_probe(struct i2c_client *client,
> 
>  	mt9v032->pad.flags = MEDIA_PAD_FL_SOURCE;
>  	ret = media_entity_init(&mt9v032->subdev.entity, 1, &mt9v032->pad, 0);
> +	if (ret < 0)
> +		return ret;

That's not correct. You need to free the control handler here.

> +
> +	mt9v032->subdev.dev = &client->dev;
> +	ret = v4l2_async_register_subdev(&mt9v032->subdev);

Don't you also need to call v4l2_async_unregister_subdev() in the remove 
function ?

> 
>  	if (ret < 0)
>  		v4l2_ctrl_handler_free(&mt9v032->ctrls);

And you need to cleanup the media entity here. A dedicated error code block at 
the end of the function with appropriate goto statements seems to be needed.

-- 
Regards,

Laurent Pinchart

