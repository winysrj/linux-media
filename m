Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:63236 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaLRWAK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 17:00:10 -0500
Date: Thu, 18 Dec 2014 22:59:50 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Josh Wu <josh.wu@atmel.com>
cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	linux-arm-kernel@lists.infradead.org,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	festevam@gmail.com
Subject: Re: [PATCH v4 2/5] media: ov2640: add async probe function
In-Reply-To: <1418869646-17071-3-git-send-email-josh.wu@atmel.com>
Message-ID: <Pine.LNX.4.64.1412182237370.11953@axis700.grange>
References: <1418869646-17071-1-git-send-email-josh.wu@atmel.com>
 <1418869646-17071-3-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

Thanks for your patches!

On Thu, 18 Dec 2014, Josh Wu wrote:

> To support async probe for ov2640, we need remove the code to get 'mclk'
> in ov2640_probe() function. oterwise, if soc_camera host is not probed
> in the moment, then we will fail to get 'mclk' and quit the ov2640_probe()
> function.
> 
> So in this patch, we move such 'mclk' getting code to ov2640_s_power()
> function. That make ov2640 survive, as we can pass a NULL (priv-clk) to
> soc_camera_set_power() function.
> 
> And if soc_camera host is probed, the when ov2640_s_power() is called,
> then we can get the 'mclk' and that make us enable/disable soc_camera
> host's clock as well.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
> v3 -> v4:
> v2 -> v3:
> v1 -> v2:
>   no changes.
> 
>  drivers/media/i2c/soc_camera/ov2640.c | 31 +++++++++++++++++++++----------
>  1 file changed, 21 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
> index 1fdce2f..9ee910d 100644
> --- a/drivers/media/i2c/soc_camera/ov2640.c
> +++ b/drivers/media/i2c/soc_camera/ov2640.c
> @@ -739,6 +739,15 @@ static int ov2640_s_power(struct v4l2_subdev *sd, int on)
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
>  	struct ov2640_priv *priv = to_ov2640(client);
> +	struct v4l2_clk *clk;
> +
> +	if (!priv->clk) {
> +		clk = v4l2_clk_get(&client->dev, "mclk");
> +		if (IS_ERR(clk))
> +			dev_warn(&client->dev, "Cannot get the mclk. maybe soc-camera host is not probed yet.\n");
> +		else
> +			priv->clk = clk;
> +	}
>  
>  	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
>  }
> @@ -1078,21 +1087,21 @@ static int ov2640_probe(struct i2c_client *client,
>  	if (priv->hdl.error)
>  		return priv->hdl.error;
>  
> -	priv->clk = v4l2_clk_get(&client->dev, "mclk");
> -	if (IS_ERR(priv->clk)) {
> -		ret = PTR_ERR(priv->clk);
> -		goto eclkget;
> -	}
> -
>  	ret = ov2640_video_probe(client);

The first thing the above ov2640_video_probe() function will do is call 
ov2640_s_power(), which will request the clock. So, by moving requesting 
the clock from ov2640_probe() to ov2640_s_power() doesn't change how 
probing will be performed, am I right? Or are there any other patched, 
that change that, that I'm overseeing?

If I'm right, then I would propose an approach, already used in other 
drivers instead of this one: return -EPROBE_DEFER if the clock isn't 
available during probing. See ef6672ea35b5bb64ab42e18c1a1ffc717c31588a for 
an example. Or did I misunderstand anything?

Thanks
Guennadi

>  	if (ret) {
> -		v4l2_clk_put(priv->clk);
> -eclkget:
> -		v4l2_ctrl_handler_free(&priv->hdl);
> +		goto evideoprobe;
>  	} else {
>  		dev_info(&adapter->dev, "OV2640 Probed\n");
>  	}
>  
> +	ret = v4l2_async_register_subdev(&priv->subdev);
> +	if (ret < 0)
> +		goto evideoprobe;
> +
> +	return 0;
> +
> +evideoprobe:
> +	v4l2_ctrl_handler_free(&priv->hdl);
>  	return ret;
>  }
>  
> @@ -1100,7 +1109,9 @@ static int ov2640_remove(struct i2c_client *client)
>  {
>  	struct ov2640_priv       *priv = to_ov2640(client);
>  
> -	v4l2_clk_put(priv->clk);
> +	v4l2_async_unregister_subdev(&priv->subdev);
> +	if (priv->clk)
> +		v4l2_clk_put(priv->clk);
>  	v4l2_device_unregister_subdev(&priv->subdev);
>  	v4l2_ctrl_handler_free(&priv->hdl);
>  	return 0;
> -- 
> 1.9.1
> 
