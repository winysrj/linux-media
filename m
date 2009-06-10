Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54169 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751331AbZFJScK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 14:32:10 -0400
Date: Wed, 10 Jun 2009 20:32:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Muralidharan Karicheri <m-karicheri2@ti.com>
cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
Subject: Re: [PATCH] adding support for setting bus parameters in sub device
In-Reply-To: <1244580891-24153-1-git-send-email-m-karicheri2@ti.com>
Message-ID: <Pine.LNX.4.64.0906102022320.4817@axis700.grange>
References: <1244580891-24153-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 9 Jun 2009, m-karicheri2@ti.com wrote:

> From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>
> 
> This patch adds support for setting bus parameters such as bus type
> (BT.656, BT.1120 etc), width (example 10 bit raw image data bus)
> and polarities (vsync, hsync, field etc) in sub device. This allows
> bridge driver to configure the sub device for a specific set of bus
> parameters through s_bus() function call.

Yes, this is required, but this is not enough. Firstly, you're missing at 
least one more flag - master or slave. Secondly, it is not enough to 
provide a s_bus function. Many hosts and sensors can configure one of 
several alternate configurations - they can select signal polarities, data 
widths, master / slave role, etc. Whereas others have some or all of these 
parameters fixed. That's why we have a query method in soc-camera, which 
delivers all supported configurations, and then the host can select some 
mutually acceptable subset. No, just returning an error code is not 
enough.

So, you would need to request supported flags, the sensor would return a 
bitmask, and the host would then issue a s_bus call with a selected subset 
and configure itself. And then you realise, that one bit per parameter is 
not enough - you need a bit for both, e.g., vsync active low and active 
high.

Have a look at 
include/media/soc_camera.h::soc_camera_bus_param_compatible() and macros 
defined there, then you might want to have a look at 
drivers/media/video/pxa_camera.c::pxa_camera_set_bus_param() to see how 
the whole machinery works. And you also want inverter flags, see 
drivers/media/video/soc_camera.c::soc_camera_apply_sensor_flags().

So, this is a step in the right direction, but it doesn't seem final yet.

Thanks
Guennadi

> 
> Reviewed By "Hans Verkuil".
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> ---
> Applies to v4l-dvb repository
> 
>  include/media/v4l2-subdev.h |   36 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 36 insertions(+), 0 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 1785608..c1cfb3b 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -37,6 +37,41 @@ struct v4l2_decode_vbi_line {
>  	u32 type;		/* VBI service type (V4L2_SLICED_*). 0 if no service found */
>  };
>  
> +/*
> + * Some sub-devices are connected to the bridge device through a bus that
> + * carries * the clock, vsync, hsync and data. Some interfaces such as BT.656
> + * carries the sync embedded in the data where as others have separate line
> + * carrying the sync signals. The structure below is used by bridge driver to
> + * set the desired bus parameters in the sub device to work with it.
> + */
> +enum v4l2_subdev_bus_type {
> +	/* BT.656 interface. Embedded sync */
> +	V4L2_SUBDEV_BUS_BT_656,
> +	/* BT.1120 interface. Embedded sync */
> +	V4L2_SUBDEV_BUS_BT_1120,
> +	/* 8 bit muxed YCbCr bus, separate sync and field signals */
> +	V4L2_SUBDEV_BUS_YCBCR_8,
> +	/* 16 bit YCbCr bus, separate sync and field signals */
> +	V4L2_SUBDEV_BUS_YCBCR_16,
> +	/* Raw Bayer image data bus , 8 - 16 bit wide, sync signals */
> +	V4L2_SUBDEV_BUS_RAW_BAYER
> +};
> +
> +struct v4l2_subdev_bus	{
> +	enum v4l2_subdev_bus_type type;
> +	u8 width;
> +	/* 0 - active low, 1 - active high */
> +	unsigned pol_vsync:1;
> +	/* 0 - active low, 1 - active high */
> +	unsigned pol_hsync:1;
> +	/* 0 - low to high , 1 - high to low */
> +	unsigned pol_field:1;
> +	/* 0 - sample at falling edge , 1 - sample at rising edge */
> +	unsigned pol_pclock:1;
> +	/* 0 - active low , 1 - active high */
> +	unsigned pol_data:1;
> +};
> +
>  /* Sub-devices are devices that are connected somehow to the main bridge
>     device. These devices are usually audio/video muxers/encoders/decoders or
>     sensors and webcam controllers.
> @@ -109,6 +144,7 @@ struct v4l2_subdev_core_ops {
>  	int (*querymenu)(struct v4l2_subdev *sd, struct v4l2_querymenu *qm);
>  	int (*s_std)(struct v4l2_subdev *sd, v4l2_std_id norm);
>  	long (*ioctl)(struct v4l2_subdev *sd, unsigned int cmd, void *arg);
> +	int (*s_bus)(struct v4l2_subdev *sd, struct v4l2_subdev_bus *bus);
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>  	int (*g_register)(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg);
>  	int (*s_register)(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg);
> -- 
> 1.6.0.4
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
