Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63779 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751221AbdBZT4l (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Feb 2017 14:56:41 -0500
Date: Sun, 26 Feb 2017 20:56:22 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Javier Martinez Canillas <javier@osg.samsung.com>
cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] [media] soc-camera: ov5642: Add OF device ID table
In-Reply-To: <20170222161129.28613-1-javier@osg.samsung.com>
Message-ID: <Pine.LNX.4.64.1702262054130.17018@axis700.grange>
References: <20170222161129.28613-1-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 22 Feb 2017, Javier Martinez Canillas wrote:

> The driver doesn't have a struct of_device_id table but supported devices
> are registered via Device Trees. This is working on the assumption that a
> I2C device registered via OF will always match a legacy I2C device ID and
> that the MODALIAS reported will always be of the form i2c:<device>.
> 
> But this could change in the future so the correct approach is to have an
> OF device ID table if the devices are registered via OF.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

> ---
> 
>  drivers/media/i2c/soc_camera/ov5642.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
> index 3d185bd622a3..1926f382dfce 100644
> --- a/drivers/media/i2c/soc_camera/ov5642.c
> +++ b/drivers/media/i2c/soc_camera/ov5642.c
> @@ -1063,9 +1063,18 @@ static const struct i2c_device_id ov5642_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, ov5642_id);
>  
> +#if IS_ENABLED(CONFIG_OF)
> +static const struct of_device_id ov5642_of_match[] = {
> +	{ .compatible = "ovti,ov5642" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, ov5642_of_match);
> +#endif
> +
>  static struct i2c_driver ov5642_i2c_driver = {
>  	.driver = {
>  		.name = "ov5642",
> +		.of_match_table = of_match_ptr(ov5642_of_match),
>  	},
>  	.probe		= ov5642_probe,
>  	.remove		= ov5642_remove,
> -- 
> 2.9.3
> 
