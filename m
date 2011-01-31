Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:32281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761Ab1AaPBb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Jan 2011 10:01:31 -0500
Message-ID: <4D46CEC2.8010107@redhat.com>
Date: Mon, 31 Jan 2011 13:01:22 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Holger Nelson <hnelson@hnelson.de>
CC: Stefan Ringel <stefan.ringel@arcor.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Add Terratec Grabster support to tm6000
References: <alpine.DEB.2.00.1101051849460.6749@nova.crius.de>
In-Reply-To: <alpine.DEB.2.00.1101051849460.6749@nova.crius.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 05-01-2011 15:58, Holger Nelson escreveu:
> On Tue, 4 Jan 2011, Stefan Ringel wrote:
> 
>> Am 04.01.2011 20:12, schrieb Holger Nelson:
>>> Hi,
>>> the following patch adds support for a Terratec Grabster AV MX150 (and maybe other devices in the Grabster series). This device is an analog frame grabber device using a tm5600. This device doesn't have a tuner, so I changed the code to skip the tuner reset if neither has_tuner nor has_dvb is set.
>> it skip, if you has no tuner gpio defined. You does'nt need more. Work the driver with input select (tv (conposite0), composite, s-vhs)?
> 
> Yes tuner reset is skipped, but in the else-branch, the code also complains that tuner reset is not configured and returns -1, which makes tm6000_init_dev exit before v4l2_device_register is called. Switching inputs does not work, but at least I can use the composite input, if I use the tv-input.
> 
> Below is a new version of the patch.
> 
> Holger

Please send your Signed-off-by: line. Btw, the patch doesn't apply
as-is over the latest development tree. Could you please rebase it
against it? you should use branch "staging/for_v2.6.39" of the git
tree at:
	http://git.linuxtv.org/media_tree.git

> 
> diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
> index 5a7946c..0f4154f 100644
> --- a/drivers/staging/tm6000/tm6000-cards.c
> +++ b/drivers/staging/tm6000/tm6000-cards.c
> @@ -50,6 +50,7 @@
>  #define TM6010_BOARD_BEHOLD_VOYAGER        11
>  #define TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE    12
>  #define TM6010_BOARD_TWINHAN_TU501        13
> +#define TM5600_BOARD_TERRATEC_GRABSTER        14
> 
>  #define TM6000_MAXBOARDS        16
>  static unsigned int card[]     = {[0 ... (TM6000_MAXBOARDS - 1)] = UNSET };
> @@ -303,6 +304,19 @@ struct tm6000_board tm6000_boards[] = {
>              .dvb_led    = TM6010_GPIO_5,
>              .ir        = TM6010_GPIO_0,
>          },
> +    },
> +    [TM5600_BOARD_TERRATEC_GRABSTER] = {
> +        .name         = "Terratec Grabster AV 150/250 MX",
> +        .type         = TM5600,
> +        .caps = {
> +            .has_tuner    = 0,
> +            .has_dvb    = 0,
> +            .has_zl10353    = 0,
> +            .has_eeprom    = 0,
> +            .has_remote    = 0,
> +        },
> +        .gpio = {
> +        },
>      }
>  };
> 
> @@ -325,6 +339,7 @@ struct usb_device_id tm6000_id_table[] = {
>      { USB_DEVICE(0x13d3, 0x3241), .driver_info = TM6010_BOARD_TWINHAN_TU501 },
>      { USB_DEVICE(0x13d3, 0x3243), .driver_info = TM6010_BOARD_TWINHAN_TU501 },
>      { USB_DEVICE(0x13d3, 0x3264), .driver_info = TM6010_BOARD_TWINHAN_TU501 },
> +    { USB_DEVICE(0x0ccd, 0x0079), .driver_info = TM5600_BOARD_TERRATEC_GRABSTER },
>      { },
>  };
> 
> @@ -447,6 +462,8 @@ int tm6000_cards_setup(struct tm6000_core *dev)
>       * the board-specific session.
>       */
>      switch (dev->model) {
> +    case TM5600_BOARD_TERRATEC_GRABSTER:
> +        return 0;
>      case TM6010_BOARD_HAUPPAUGE_900H:
>      case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
>      case TM6010_BOARD_TWINHAN_TU501:
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

