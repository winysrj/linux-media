Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:27403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757746Ab0LMN3b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 08:29:31 -0500
Message-ID: <4D061FB3.7010305@redhat.com>
Date: Mon, 13 Dec 2010 11:29:23 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/6] gspca - sonixj: Add a flag in the driver_info table
References: <20101213140326.569d150d@tele>
In-Reply-To: <20101213140326.569d150d@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 13-12-2010 11:03, Jean-Francois Moine escreveu:
> 
> Signed-off-by: Jean-François Moine <moinejf@free.fr>
> 
> diff --git a/drivers/media/video/gspca/sonixj.c b/drivers/media/video/gspca/sonixj.c
> index 5978676..bd5858e 100644
> --- a/drivers/media/video/gspca/sonixj.c
> +++ b/drivers/media/video/gspca/sonixj.c
> @@ -64,6 +64,7 @@ struct sd {
>  	u8 jpegqual;			/* webcam quality */
>  
>  	u8 reg18;
> +	u8 flags;
>  
>  	s8 ag_cnt;
>  #define AG_CNT_START 13
> @@ -96,6 +97,9 @@ enum sensors {
>  	SENSOR_SP80708,
>  };
>  
> +/* device flags */
> +#define PDN_INV	1		/* inverse pin S_PWR_DN / sn_xxx tables */
> +
>  /* V4L2 controls supported by the driver */
>  static void setbrightness(struct gspca_dev *gspca_dev);
>  static void setcontrast(struct gspca_dev *gspca_dev);
> @@ -1763,7 +1767,8 @@ static int sd_config(struct gspca_dev *gspca_dev,
>  	struct cam *cam;
>  
>  	sd->bridge = id->driver_info >> 16;
> -	sd->sensor = id->driver_info;
> +	sd->sensor = id->driver_info >> 8;
> +	sd->flags = id->driver_info;
>  
>  	cam = &gspca_dev->cam;
>  	if (sd->sensor == SENSOR_ADCM1700) {
> @@ -2947,7 +2952,11 @@ static const struct sd_desc sd_desc = {
>  /* -- module initialisation -- */
>  #define BS(bridge, sensor) \
>  	.driver_info = (BRIDGE_ ## bridge << 16) \
> -			| SENSOR_ ## sensor
> +			| (SENSOR_ ## sensor << 8)
> +#define BSF(bridge, sensor, flags) \
> +	.driver_info = (BRIDGE_ ## bridge << 16) \
> +			| (SENSOR_ ## sensor << 8) \
> +			| flags

As "flags" come from a macro, please use "(flags)" instead. This will avoid
the risk of having something bad happening here, if we add some more complex
flags logic.

>  static const __devinitdata struct usb_device_id device_table[] = {
>  #if !defined CONFIG_USB_SN9C102 && !defined CONFIG_USB_SN9C102_MODULE
>  	{USB_DEVICE(0x0458, 0x7025), BS(SN9C120, MI0360)},

