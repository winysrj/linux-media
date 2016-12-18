Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48538 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753998AbcLRWPZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Dec 2016 17:15:25 -0500
Date: Mon, 19 Dec 2016 00:15:21 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 04/15] ov7670: get xclk
Message-ID: <20161218221520.GX16630@valkosipuli.retiisi.org.uk>
References: <20161212155520.41375-1-hverkuil@xs4all.nl>
 <20161212155520.41375-5-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161212155520.41375-5-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Dec 12, 2016 at 04:55:09PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Get the clock for this sensor.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/i2c/ov7670.c | 35 ++++++++++++++++++++++++++++-------
>  1 file changed, 28 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> index 35b09d2..d2c0e23 100644
> --- a/drivers/media/i2c/ov7670.c
> +++ b/drivers/media/i2c/ov7670.c
> @@ -10,6 +10,7 @@
>   * This file may be distributed under the terms of the GNU General
>   * Public License, version 2.
>   */
> +#include <linux/clk.h>
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
> @@ -230,6 +231,7 @@ struct ov7670_info {
>  		struct v4l2_ctrl *hue;
>  	};
>  	struct ov7670_format_struct *fmt;  /* Current format */
> +	struct clk *clk;
>  	int min_width;			/* Filter out smaller sizes */
>  	int min_height;			/* Filter out smaller sizes */
>  	int clock_speed;		/* External clock speed (MHz) */
> @@ -1590,13 +1592,28 @@ static int ov7670_probe(struct i2c_client *client,
>  			info->pclk_hb_disable = true;
>  	}
>  
> +	info->clk = clk_get(&client->dev, "xclk");
> +	if (IS_ERR(info->clk))
> +		return -EPROBE_DEFER;

How about devm_clk_get() instead? I think there's nothing wrong in using
devm.*() here as it's not memory.

> +	clk_prepare_enable(info->clk);
> +
> +	ret = ov7670_probe_dt(client, info);
> +	if (ret)
> +		goto clk_put;
> +
> +	info->clock_speed = clk_get_rate(info->clk) / 1000000;
> +	if (info->clock_speed < 12 || info->clock_speed > 48) {

What's the clock expected to be? I don't know the sensor but all sensors
I've seen do derive their internal clocks from the one provided to the
sensor, meaning that any frequency would be directly related to this one. As
the sensor driver makes no effort in programming the PLL according to the
input clock, I bet the register lists used assume a certain frequency
instead. Shouldn't you check instead you're getting exactly that frequency?

> +		ret = -EINVAL;
> +		goto clk_put;
> +	}
> +
>  	/* Make sure it's an ov7670 */
>  	ret = ov7670_detect(sd);
>  	if (ret) {
>  		v4l_dbg(1, debug, client,
>  			"chip found @ 0x%x (%s) is not an ov7670 chip.\n",
>  			client->addr << 1, client->adapter->name);
> -		return ret;
> +		goto clk_put;
>  	}
>  	v4l_info(client, "chip found @ 0x%02x (%s)\n",
>  			client->addr << 1, client->adapter->name);
> @@ -1637,9 +1654,8 @@ static int ov7670_probe(struct i2c_client *client,
>  			V4L2_EXPOSURE_AUTO);
>  	sd->ctrl_handler = &info->hdl;
>  	if (info->hdl.error) {
> -		int err = info->hdl.error;
> -
> -		goto fail;
> +		ret = info->hdl.error;
> +		goto hdl_free;
>  	}
>  
>  #if defined(CONFIG_MEDIA_CONTROLLER)
> @@ -1647,7 +1663,7 @@ static int ov7670_probe(struct i2c_client *client,
>  	info->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
>  	ret = media_entity_pads_init(&info->sd.entity, 1, &info->pad);
>  	if (ret < 0)
> -		goto fail;
> +		goto hdl_free;
>  #endif
>  	/*
>  	 * We have checked empirically that hw allows to read back the gain
> @@ -1664,13 +1680,16 @@ static int ov7670_probe(struct i2c_client *client,
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  		media_entity_cleanup(&info->sd.entity);
>  #endif
> -		goto fail;
> +		goto hdl_free;
>  	}
>  
>  	return 0;
>  
> -fail:
> +hdl_free:
>  	v4l2_ctrl_handler_free(&info->hdl);
> +clk_put:
> +	clk_disable_unprepare(info->clk);
> +	clk_put(info->clk);
>  	return ret;
>  }
>  
> @@ -1685,6 +1704,8 @@ static int ov7670_remove(struct i2c_client *client)
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	media_entity_cleanup(&sd->entity);
>  #endif
> +	clk_disable_unprepare(info->clk);
> +	clk_put(info->clk);
>  	return 0;
>  }
>  

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
