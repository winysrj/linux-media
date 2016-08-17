Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44844 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbcHQMbO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 08:31:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Songjun Wu <songjun.wu@microchip.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 4/7] ov7670: get xvclk
Date: Wed, 17 Aug 2016 15:30:40 +0300
Message-ID: <3609336.4L2FU6pBu3@avalon>
In-Reply-To: <1471415383-38531-5-git-send-email-hverkuil@xs4all.nl>
References: <1471415383-38531-1-git-send-email-hverkuil@xs4all.nl> <1471415383-38531-5-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Wednesday 17 Aug 2016 08:29:40 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Get the clock for this sensor.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/i2c/ov7670.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> index fe527b2..57adf3d 100644
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
> @@ -18,6 +19,7 @@
>  #include <linux/videodev2.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ctrls.h>
> +#include <media/v4l2-clk.h>
>  #include <media/v4l2-mediabus.h>
>  #include <media/v4l2-image-sizes.h>
>  #include <media/i2c/ov7670.h>
> @@ -228,6 +230,7 @@ struct ov7670_info {
>  		struct v4l2_ctrl *hue;
>  	};
>  	struct ov7670_format_struct *fmt;  /* Current format */
> +	struct v4l2_clk *clk;
>  	int min_width;			/* Filter out smaller sizes */
>  	int min_height;			/* Filter out smaller sizes */
>  	int clock_speed;		/* External clock speed (MHz) */
> @@ -1588,8 +1591,19 @@ static int ov7670_probe(struct i2c_client *client,
>  			info->pclk_hb_disable = true;
>  	}
> 
> +	info->clk = v4l2_clk_get(&client->dev, "xvclk");
> +	if (IS_ERR(info->clk))
> +		return -EPROBE_DEFER;
> +	v4l2_clk_enable(info->clk);

Do you really need the V4L2 clock API here, or could you use the CCF API 
directly ?

> +	info->clock_speed = v4l2_clk_get_rate(info->clk) / 1000000;
> +	if (info->clock_speed < 12 ||
> +	    info->clock_speed > 48)
> +		return -EINVAL;
> +

You need error handling here too. I recommend adding error handling code at 
the end of the function and using goto's.

>  	/* Make sure it's an ov7670 */
>  	ret = ov7670_detect(sd);
> +

No need for a blank line here.

>  	if (ret) {
>  		v4l_dbg(1, debug, client,
>  			"chip found @ 0x%x (%s) is not an ov7670 chip.\n",
> @@ -1682,6 +1696,7 @@ static int ov7670_remove(struct i2c_client *client)
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	media_entity_cleanup(&sd->entity);
>  #endif
> +	v4l2_clk_put(info->clk);

Don't you need to call v4l2_clk_disable() before ?

>  	return 0;
>  }

-- 
Regards,

Laurent Pinchart

