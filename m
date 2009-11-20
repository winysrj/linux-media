Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57896 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750907AbZKTLYp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 06:24:45 -0500
Date: Fri, 20 Nov 2009 12:24:58 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux-V4L2 <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc-camera: tw9910: Add sync polarity support
In-Reply-To: <ud43dq5dn.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0911201054110.4438@axis700.grange>
References: <ud43dq5dn.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 20 Nov 2009, Kuninori Morimoto wrote:

> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  drivers/media/video/tw9910.c |   22 +++++++++++++++++++---
>  1 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
> index a4ba720..243207d 100644
> --- a/drivers/media/video/tw9910.c
> +++ b/drivers/media/video/tw9910.c
> @@ -166,7 +166,7 @@
>  #define VSSL_FIELD  0x20 /*   2 : FIELD  */
>  #define VSSL_VVALID 0x30 /*   3 : VVALID */
>  #define VSSL_ZERO   0x70 /*   7 : 0      */
> -#define HSP_LOW     0x00 /* 0 : HS pin output polarity is active low */
> +#define HSP_LO      0x00 /* 0 : HS pin output polarity is active low */

I would remove field names with "0" values completely. Also see below

>  #define HSP_HI      0x08 /* 1 : HS pin output polarity is active high.*/
>  			 /* HS pin output control */
>  #define HSSL_HACT   0x00 /*   0 : HACT   */
> @@ -175,6 +175,11 @@
>  #define HSSL_HLOCK  0x03 /*   3 : HLOCK  */
>  #define HSSL_ASYNCW 0x04 /*   4 : ASYNCW */
>  #define HSSL_ZERO   0x07 /*   7 : 0      */
> +			 /* xSSL_xVALID polarity */
> +#define VSP_V_LO    VSP_HI /* xSSL_xVALID case, polarity will be inverted */
> +#define VSP_V_HI    VSP_LO
> +#define HSP_V_LO    HSP_HI
> +#define HSP_V_HI    HSP_LO

I wouldn't add these - just add a comment below and use reverted 
[HV]SP_{HI,LO} macros.

>  /* ACNTL1 */
>  #define SRESET      0x80 /* resets the device to its default state
> @@ -513,12 +518,22 @@ static int tw9910_set_bus_param(struct soc_camera_device *icd,
>  {
>  	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>  	struct i2c_client *client = sd->priv;
> +	u8 val = VSSL_VVALID | HSSL_DVALID;
>  
>  	/*
>  	 * set OUTCTR1
>  	 */
> -	return i2c_smbus_write_byte_data(client, OUTCTR1,
> -					 VSSL_VVALID | HSSL_DVALID);
> +	if (flags & SOCAM_HSYNC_ACTIVE_LOW)
> +		val |= HSP_V_LO;
> +	else
> +		val |= HSP_V_HI;

I think, for single-bit fields we usually only do

	if (must_set)
		val |= field;

and leave the case

	else
		val |= 0;

away. So, I would completely remove those macros with "0" value and only 
do the "1" case. Then you'd just have

+	/*
+	 * We use VVALID and DVALID signals to control VSYNC and HSYNC
+	 * outputs, in this mode their polarity is inverted.
+	 */
+	if (flags & SOCAM_HSYNC_ACTIVE_LOW)
+		val |= HSP_HI;

without any else, agree?

> +
> +	if (flags & SOCAM_VSYNC_ACTIVE_LOW)
> +		val |= VSP_V_LO;
> +	else
> +		val |= VSP_V_HI;

ditto.

> +
> +	return i2c_smbus_write_byte_data(client, OUTCTR1, val);
>  }

I think, I begin to understand what these *VALID signals are... Looks like 
VVALID and DVALID are internal signals, which are not routed outside, but 
you can select them as one of options to control HSYNC and VSYNC outputs.

>  
>  static unsigned long tw9910_query_bus_param(struct soc_camera_device *icd)
> @@ -528,6 +543,7 @@ static unsigned long tw9910_query_bus_param(struct soc_camera_device *icd)
>  	struct soc_camera_link *icl = to_soc_camera_link(icd);
>  	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_MASTER |
>  		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_HIGH |
> +		SOCAM_VSYNC_ACTIVE_LOW  | SOCAM_HSYNC_ACTIVE_LOW  |
>  		SOCAM_DATA_ACTIVE_HIGH | priv->info->buswidth;
>  
>  	return soc_camera_apply_sensor_flags(icl, flags);
> -- 
> 1.6.3.3
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
