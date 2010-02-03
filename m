Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757867Ab0BCUTJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 15:19:09 -0500
Message-ID: <4B69DA31.3010900@redhat.com>
Date: Wed, 03 Feb 2010 18:18:57 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH 2/15] -  tm6000 add Terratec Cinergy Hybrid XE
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de> <4B675B19.3080705@redhat.com> <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com> <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com> <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de> <4B69D8CC.2030008@arcor.de>
In-Reply-To: <4B69D8CC.2030008@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Ringel wrote:
> signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by:

(first letter is on upper case)

The patch looks ok to my eyes.
> 
> --- a/drivers/staging/tm6000/tm6000-cards.c
> +++ b/drivers/staging/tm6000/tm6000-cards.c
> @@ -44,6 +44,10 @@
>  #define TM6000_BOARD_FREECOM_AND_SIMILAR    7
>  #define TM6000_BOARD_ADSTECH_MINI_DUAL_TV    8
>  #define TM6010_BOARD_HAUPPAUGE_900H        9
> +#define TM6010_BOARD_BEHOLD_WANDER        10
> +#define TM6010_BOARD_BEHOLD_VOYAGER        11
> +#define TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE    12
> +
>  
>  #define TM6000_MAXBOARDS        16
>  static unsigned int card[]     = {[0 ... (TM6000_MAXBOARDS - 1)] = UNSET };
> @@ -208,7 +212,21 @@ struct tm6000_board tm6000_boards[] = {
>          },
>          .gpio_addr_tun_reset = TM6000_GPIO_2,
>      },
> -
> +    [TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE] = {
> +        .name         = "Terratec Cinergy Hybrid XE",
> +        .tuner_type   = TUNER_XC2028, /* has a XC3028 */
> +        .tuner_addr   = 0xc2 >> 1,
> +        .demod_addr   = 0x1e >> 1,
> +        .type         = TM6010,
> +        .caps = {
> +            .has_tuner    = 1,
> +            .has_dvb      = 1,
> +            .has_zl10353  = 1,
> +            .has_eeprom   = 1,
> +            .has_remote   = 1,
> +        },
> +        .gpio_addr_tun_reset = TM6010_GPIO_2,
> +    }
>  };
>  
>  /* table of devices that work with this driver */
> @@ -221,12 +239,13 @@ struct usb_device_id tm6000_id_table [] = {
>      { USB_DEVICE(0x2040, 0x6600), .driver_info =
> TM6010_BOARD_HAUPPAUGE_900H },
>      { USB_DEVICE(0x6000, 0xdec0), .driver_info =
> TM6010_BOARD_BEHOLD_WANDER },
>      { USB_DEVICE(0x6000, 0xdec1), .driver_info =
> TM6010_BOARD_BEHOLD_VOYAGER },
> +    { USB_DEVICE(0x0ccd, 0x0086), .driver_info =
> TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE },
>      { },
>  };
>  
> @@ -302,15 +344,19 @@ static void tm6000_config_tuner (struct
> tm6000_core *dev)
>          memset(&xc2028_cfg, 0, sizeof(xc2028_cfg));
>          memset (&ctl,0,sizeof(ctl));
>  
> -        ctl.mts   = 1;
> -        ctl.read_not_reliable = 1;
> +        ctl.input1 = 1;
> +        ctl.read_not_reliable = 0;
>          ctl.msleep = 10;
> -
> +        ctl.demod = XC3028_FE_ZARLINK456;
> +        ctl.vhfbw7 = 1;
> +        ctl.uhfbw8 = 1;
> +        ctl.switch_mode = 1;
>          xc2028_cfg.tuner = TUNER_XC2028;
>          xc2028_cfg.priv  = &ctl;
>  
>          switch(dev->model) {
>          case TM6010_BOARD_HAUPPAUGE_900H:
> +        case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
>              ctl.fname = "xc3028L-v36.fw";
>              break;
>          default:
> 


-- 

Cheers,
Mauro
