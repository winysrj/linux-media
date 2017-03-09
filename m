Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46204 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750816AbdCIUi4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Mar 2017 15:38:56 -0500
Date: Thu, 9 Mar 2017 22:38:16 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        devicetree@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv3 04/15] ov7670: get xclk
Message-ID: <20170309203816.GQ3220@valkosipuli.retiisi.org.uk>
References: <20170306145616.38485-1-hverkuil@xs4all.nl>
 <20170306145616.38485-5-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170306145616.38485-5-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Mar 06, 2017 at 03:56:05PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Get the clock for this sensor.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/i2c/ov7670.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> index 50e4466a2b37..da0843617a49 100644
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
> @@ -227,6 +228,7 @@ struct ov7670_info {
>  		struct v4l2_ctrl *hue;
>  	};
>  	struct ov7670_format_struct *fmt;  /* Current format */
> +	struct clk *clk;
>  	int min_width;			/* Filter out smaller sizes */
>  	int min_height;			/* Filter out smaller sizes */
>  	int clock_speed;		/* External clock speed (MHz) */
> @@ -1587,6 +1589,15 @@ static int ov7670_probe(struct i2c_client *client,
>  			info->pclk_hb_disable = true;
>  	}
>  
> +	info->clk = devm_clk_get(&client->dev, "xclk");
> +	if (IS_ERR(info->clk))
> +		return -EPROBE_DEFER;
> +	clk_prepare_enable(info->clk);
> +
> +	info->clock_speed = clk_get_rate(info->clk) / 1000000;
> +	if (info->clock_speed < 10 || info->clock_speed > 48)
> +		return -EINVAL;

clk_disable_unprepare() before return?

> +
>  	/* Make sure it's an ov7670 */
>  	ret = ov7670_detect(sd);
>  	if (ret) {
> @@ -1667,6 +1678,7 @@ static int ov7670_remove(struct i2c_client *client)
>  
>  	v4l2_device_unregister_subdev(sd);
>  	v4l2_ctrl_handler_free(&info->hdl);
> +	clk_disable_unprepare(info->clk);
>  	return 0;
>  }
>  

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
