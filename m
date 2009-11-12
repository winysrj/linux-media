Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33334 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755145AbZKLXKR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 18:10:17 -0500
Date: Fri, 13 Nov 2009 00:10:22 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] soc-camera: tw9910: modify V/H outpit pin setting
 to use VALID
In-Reply-To: <uljifm5se.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0911130006160.15708@axis700.grange>
References: <uljifm5se.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Morimoto-san

On Tue, 10 Nov 2009, Kuninori Morimoto wrote:

> tw9910 driver assume that V/H data is active high.
> This is controlled by OUTCTR1 register.
> When we use VALID data with active high,
> the setting will be VSP_LO/HSP_LO.
> This setting is correct,
> because this register setting is based on SYNC.

Thanks for the patch. It is good to see magic values disappear and be 
replaced with proper algorithms, but please, let's do this properly. And 
this means let's advertise both supported HSYNC and VSYNC polarities in 
tw9910_query_bus_param() and configure the chip accordingly in 
tw9910_set_bus_param(). This will also guarantee, that when we switch to 
the new bus configuration API this information doesn't get lost.

Thanks
Guennadi

> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  drivers/media/video/tw9910.c |   41 +++++++++++++----------------------------
>  1 files changed, 13 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
> index 6d8dede..426f6fc 100644
> --- a/drivers/media/video/tw9910.c
> +++ b/drivers/media/video/tw9910.c
> @@ -166,7 +166,7 @@
>  #define VSSL_FIELD  0x20 /*   2 : FIELD  */
>  #define VSSL_VVALID 0x30 /*   3 : VVALID */
>  #define VSSL_ZERO   0x70 /*   7 : 0      */
> -#define HSP_LOW     0x00 /* 0 : HS pin output polarity is active low */
> +#define HSP_LO      0x00 /* 0 : HS pin output polarity is active low */
>  #define HSP_HI      0x08 /* 1 : HS pin output polarity is active high.*/
>  			 /* HS pin output control */
>  #define HSSL_HACT   0x00 /*   0 : HACT   */
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
> @@ -681,7 +655,18 @@ static int tw9910_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  	 * reset hardware
>  	 */
>  	tw9910_reset(client);
> -	ret = tw9910_write_array(client, tw9910_default_regs);
> +
> +	/*
> +	 * set OUTCTR1
> +	 *
> +	 * tw9910 use valid data on active high.
> +	 * Then, VSP/HSP low seems strange here. But this is correct.
> +	 * Because it is based on SYNC.
> +	 * So, VSP/HSP low mean active high for valid data
> +	 */
> +	ret = i2c_smbus_write_byte_data(client, OUTCTR1,
> +					VSP_LO | VSSL_VVALID |
> +					HSP_LO | HSSL_DVALID);
>  	if (ret < 0)
>  		goto tw9910_set_fmt_error;
>  
> -- 
> 1.6.3.3
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
