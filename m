Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:49314 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab3ABUt4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 15:49:56 -0500
Date: Wed, 2 Jan 2013 21:49:53 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] mt9p031: Add support for regulators
In-Reply-To: <1357127200-7672-1-git-send-email-laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1301022143580.13661@axis700.grange>
References: <1357127200-7672-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

On Wed, 2 Jan 2013, Laurent Pinchart wrote:

> Enable the regulators when powering the sensor up, and disable them when
> powering it down.
> 
> The regulators are mandatory. Boards that don't allow controlling the
> sensor power lines must provide dummy regulators.

I have been told several times, that (production) systems shouldn't use 
dummy regulators, they can only be used during development until proper 
regulators are implemented. Not that this should affect your patch, just 
maybe we should avoid wording like "must provide dummy regulators" in 
commit descriptions:-)

Thanks
Guennadi

> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/i2c/mt9p031.c |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index e0bad59..ecf4492 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -19,6 +19,7 @@
>  #include <linux/i2c.h>
>  #include <linux/log2.h>
>  #include <linux/pm.h>
> +#include <linux/regulator/consumer.h>
>  #include <linux/slab.h>
>  #include <linux/videodev2.h>
>  
> @@ -121,6 +122,10 @@ struct mt9p031 {
>  	struct mutex power_lock; /* lock to protect power_count */
>  	int power_count;
>  
> +	struct regulator *vaa;
> +	struct regulator *vdd;
> +	struct regulator *vdd_io;
> +
>  	enum mt9p031_model model;
>  	struct aptina_pll pll;
>  	int reset;
> @@ -264,6 +269,11 @@ static int mt9p031_power_on(struct mt9p031 *mt9p031)
>  		usleep_range(1000, 2000);
>  	}
>  
> +	/* Bring up the supplies */
> +	regulator_enable(mt9p031->vdd);
> +	regulator_enable(mt9p031->vdd_io);
> +	regulator_enable(mt9p031->vaa);
> +
>  	/* Emable clock */
>  	if (mt9p031->pdata->set_xclk)
>  		mt9p031->pdata->set_xclk(&mt9p031->subdev,
> @@ -285,6 +295,10 @@ static void mt9p031_power_off(struct mt9p031 *mt9p031)
>  		usleep_range(1000, 2000);
>  	}
>  
> +	regulator_disable(mt9p031->vaa);
> +	regulator_disable(mt9p031->vdd_io);
> +	regulator_disable(mt9p031->vdd);
> +
>  	if (mt9p031->pdata->set_xclk)
>  		mt9p031->pdata->set_xclk(&mt9p031->subdev, 0);
>  }
> @@ -937,6 +951,16 @@ static int mt9p031_probe(struct i2c_client *client,
>  	mt9p031->model = did->driver_data;
>  	mt9p031->reset = -1;
>  
> +	mt9p031->vaa = devm_regulator_get(&client->dev, "vaa");
> +	mt9p031->vdd = devm_regulator_get(&client->dev, "vdd");
> +	mt9p031->vdd_io = devm_regulator_get(&client->dev, "vdd_io");
> +
> +	if (IS_ERR(mt9p031->vaa) || IS_ERR(mt9p031->vdd) ||
> +	    IS_ERR(mt9p031->vdd_io)) {
> +		dev_err(&client->dev, "Unable to get regulators\n");
> +		return -ENODEV;
> +	}
> +
>  	v4l2_ctrl_handler_init(&mt9p031->ctrls, ARRAY_SIZE(mt9p031_ctrls) + 6);
>  
>  	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
> -- 
> 1.7.8.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
