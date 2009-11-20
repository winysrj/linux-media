Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:32895 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751887AbZKTMJh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 07:09:37 -0500
Date: Fri, 20 Nov 2009 13:09:51 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2] soc-camera: tw9910: modify V/H outpit pin setting to
 use VALID
In-Reply-To: <uzl6r6re1.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0911201303430.4438@axis700.grange>
References: <uzl6r6re1.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 13 Nov 2009, Kuninori Morimoto wrote:

> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
> v1 -> v2
> 
> o remove un-understandable explain.
>   -> tw9910_query_bus_param need not modify now
> o move OUTCTR1 setting to tw9910_set_bus_param
> 
>  drivers/media/video/tw9910.c |   38 ++++++++------------------------------
>  1 files changed, 8 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
> index 6d8dede..82135f2 100644
> --- a/drivers/media/video/tw9910.c
> +++ b/drivers/media/video/tw9910.c
> @@ -239,18 +239,6 @@ struct tw9910_priv {
>  	u32                             revision;
>  };
>  
> -/*
> - * register settings
> - */
> -
> -#define ENDMARKER { 0xff, 0xff }
> -
> -static const struct regval_list tw9910_default_regs[] =
> -{
> -	{ OUTCTR1, VSP_LO | VSSL_VVALID | HSP_HI | HSSL_HSYNC },
> -	ENDMARKER,
> -};
> -
>  static const enum v4l2_imgbus_pixelcode tw9910_color_codes[] = {
>  	V4L2_IMGBUS_FMT_VYUY,
>  };
> @@ -463,20 +451,6 @@ static int tw9910_set_hsync(struct i2c_client *client,
>  	return ret;
>  }
>  
> -static int tw9910_write_array(struct i2c_client *client,
> -			      const struct regval_list *vals)
> -{
> -	while (vals->reg_num != 0xff) {
> -		int ret = i2c_smbus_write_byte_data(client,
> -						    vals->reg_num,
> -						    vals->value);
> -		if (ret < 0)
> -			return ret;
> -		vals++;
> -	}
> -	return 0;
> -}
> -
>  static void tw9910_reset(struct i2c_client *client)
>  {
>  	tw9910_mask_set(client, ACNTL1, SRESET, SRESET);
> @@ -578,7 +552,14 @@ static int tw9910_s_stream(struct v4l2_subdev *sd, int enable)
>  static int tw9910_set_bus_param(struct soc_camera_device *icd,
>  				unsigned long flags)
>  {
> -	return 0;
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	struct i2c_client *client = sd->priv;
> +
> +	/*
> +	 * set OUTCTR1
> +	 */
> +	return i2c_smbus_write_byte_data(client, OUTCTR1,
> +					 VSSL_VVALID | HSSL_DVALID);

Hm, strange... This doesn't work at all for me. Getting only timeouts. 
Have you tested this on Migo-R?

Thanks
Guennadi

>  }
>  
>  static unsigned long tw9910_query_bus_param(struct soc_camera_device *icd)
> @@ -681,9 +662,6 @@ static int tw9910_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  	 * reset hardware
>  	 */
>  	tw9910_reset(client);
> -	ret = tw9910_write_array(client, tw9910_default_regs);
> -	if (ret < 0)
> -		goto tw9910_set_fmt_error;
>  
>  	/*
>  	 * set bus width
> -- 
> 1.6.3.3
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
