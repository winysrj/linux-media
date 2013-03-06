Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:63254 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab3CFXFI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 18:05:08 -0500
Received: by mail-ie0-f173.google.com with SMTP id 9so10290444iec.32
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2013 15:05:08 -0800 (PST)
From: "Matt Gomboc" <gomboc0@gmail.com>
To: "'Hans Verkuil'" <hverkuil@xs4all.nl>
Cc: <linux-media@vger.kernel.org>
References: <4B487EF5847E47F0A8C1E96B9CA6B6D6@ucdenver.pvt> <201303010852.36574.hverkuil@xs4all.nl> <51313F7A.9080900@gmail.com> <201303062056.24462.hverkuil@xs4all.nl>
Subject: RE: cx231xx : Add support for OTG102 aka EZGrabber2
Date: Wed, 6 Mar 2013 16:05:03 -0700
Message-ID: <7B6EFBC44C0448D4962F730753A94DEA@ucdenver.pvt>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <201303062056.24462.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That is welcome by me, let me know if any action is needed on my end. 

I was also wondering about adding the definition for the device 0572:58a3
which is identically identified in the distributed Windows driver from
Geniatech, but as it is not verified and may not even be in production, I
suppose it is best to wait until someone with such a device cares to test
it.

Thanks,

Matt

-----Original Message-----
From: Hans Verkuil [mailto:hverkuil@xs4all.nl] 
Sent: Wednesday, March 06, 2013 12:56 PM
To: gomboc0@gmail.com
Cc: linux-media@vger.kernel.org
Subject: Re: cx231xx : Add support for OTG102 aka EZGrabber2

Hi Matt,

While I added this patch to my cx231xx patch series, Mauro didn't pick it
up for some reason. So for when he gets around to looking at your patch, I
want to
add my:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

On Sat March 2 2013 00:53:30 Matt Gomboc wrote:
> Thanks for the response, I have done as you suggested.
> 
> Below is an updated patch for the OTG102 device against
http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/cx231xx,
kernel version 3.8.
> 
> With further testing it appears the extra clauses in cx231xx-cards.c were
not necessary (in static in cx231xx_init_dev and static int
cx231xx_usb_probe), so those have been also been removed.
> 
> 
> Signed-off-by: Matt Gomboc <gomboc0@gmail.com>
> --
>  drivers/media/usb/cx231xx/cx231xx-avcore.c |  2 ++
>  drivers/media/usb/cx231xx/cx231xx-cards.c  | 35
++++++++++++++++++++++++++++++
>  drivers/media/usb/cx231xx/cx231xx.h        |  1 +
>  3 files changed, 38 insertions(+)
> 
> diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c
b/drivers/media/usb/cx231xx/cx231xx-avcore.c
> index 2e51fb9..235ba65 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
> @@ -357,6 +357,7 @@ int cx231xx_afe_update_power_control(struct cx231xx
*dev,
>  	case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
>  	case CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL:
>  	case CX231XX_BOARD_HAUPPAUGE_USB2_FM_NTSC:
> +	case CX231XX_BOARD_OTG102:
>  		if (avmode == POLARIS_AVMODE_ANALOGT_TV) {
>  			while (afe_power_status != (FLD_PWRDN_TUNING_BIAS |
>  						FLD_PWRDN_ENABLE_PLL)) {
> @@ -1720,6 +1721,7 @@ int cx231xx_dif_set_standard(struct cx231xx *dev,
u32 standard)
>  	case CX231XX_BOARD_CNXT_RDU_250:
>  	case CX231XX_BOARD_CNXT_VIDEO_GRABBER:
>  	case CX231XX_BOARD_HAUPPAUGE_EXETER:
> +	case CX231XX_BOARD_OTG102:
>  		func_mode = 0x03;
>  		break;
>  	case CX231XX_BOARD_CNXT_RDE_253S:
> diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c
b/drivers/media/usb/cx231xx/cx231xx-cards.c
> index b7b1acd..13249e5 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-cards.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
> @@ -634,6 +634,39 @@ struct cx231xx_board cx231xx_boards[] = {
>  			.gpio = NULL,
>  		} },
>  	},
> +	[CX231XX_BOARD_OTG102] = {
> +		.name = "Geniatech OTG102",
> +		.tuner_type = TUNER_ABSENT,
> +		.decoder = CX231XX_AVDECODER,
> +		.output_mode = OUT_MODE_VIP11,
> +		.ctl_pin_status_mask = 0xFFFFFFC4,
> +		.agc_analog_digital_select_gpio = 0x0c, 
> +			/* According with PV CxPlrCAP.inf file */
> +		.gpio_pin_status_mask = 0x4001000,
> +		.norm = V4L2_STD_NTSC,
> +		.no_alt_vanc = 1,
> +		.external_av = 1,
> +		.dont_use_port_3 = 1,
> +		/*.has_417 = 1, */
> +		/* This board is believed to have a hardware encoding chip
> +		 * supporting mpeg1/2/4, but as the 417 is apparently not
> +		 * working for the reference board it is not here either. */
> +
> +		.input = {{
> +				.type = CX231XX_VMUX_COMPOSITE1,
> +				.vmux = CX231XX_VIN_2_1,
> +				.amux = CX231XX_AMUX_LINE_IN,
> +				.gpio = NULL,
> +			}, {
> +				.type = CX231XX_VMUX_SVIDEO,
> +				.vmux = CX231XX_VIN_1_1 |
> +					(CX231XX_VIN_1_2 << 8) |
> +					CX25840_SVIDEO_ON,
> +				.amux = CX231XX_AMUX_LINE_IN,
> +				.gpio = NULL,
> +			}
> +		},
> +	},
>  };
>  const unsigned int cx231xx_bcount = ARRAY_SIZE(cx231xx_boards);
>  
> @@ -675,6 +708,8 @@ struct usb_device_id cx231xx_id_table[] = {
>  	 .driver_info = CX231XX_BOARD_ICONBIT_U100},
>  	{USB_DEVICE(0x0fd9, 0x0037),
>  	 .driver_info = CX231XX_BOARD_ELGATO_VIDEO_CAPTURE_V2},
> +	{USB_DEVICE(0x1f4d, 0x0102),
> +	 .driver_info = CX231XX_BOARD_OTG102},
>  	{},
>  };
>  
> diff --git a/drivers/media/usb/cx231xx/cx231xx.h
b/drivers/media/usb/cx231xx/cx231xx.h
> index a8e50d2..dff3f1d 100644
> --- a/drivers/media/usb/cx231xx/cx231xx.h
> +++ b/drivers/media/usb/cx231xx/cx231xx.h
> @@ -71,6 +71,7 @@
>  #define CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL 14
>  #define CX231XX_BOARD_HAUPPAUGE_USB2_FM_NTSC 15
>  #define CX231XX_BOARD_ELGATO_VIDEO_CAPTURE_V2 16
> +#define CX231XX_BOARD_OTG102 17
>  
>  /* Limits minimum and default number of buffers */
>  #define CX231XX_MIN_BUF                 4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

