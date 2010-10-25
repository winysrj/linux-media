Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:40896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759189Ab0JYR2a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Oct 2010 13:28:30 -0400
Message-ID: <4CC5BE39.70206@redhat.com>
Date: Mon, 25 Oct 2010 15:28:25 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Florian Klink <flokli@flokli.de>
CC: linux-media@vger.kernel.org
Subject: Re: em28xx: Terratec Grabby no sound
References: <f9fc4355b0c721744c6522a720ee2df7@flokli.de>
In-Reply-To: <f9fc4355b0c721744c6522a720ee2df7@flokli.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 25-10-2010 15:24, Florian Klink escreveu:
> Hi,
> 
> I recently bought a Terratec Grabby. The device has a S-Video and 3 Cinch
> cables (sound left, sound right, video). I want to record some video
> cassettes with it. (with a cinch-scart adapter).
> 
> I checked the signal, there is audio and video on it.
> 
> When I try to "play" the capture device with e.g. mplayer, I see "no
> sound", even with various options.
> 
> I can hear sound only by doing "arecord -D hw:2,0 -r 32000 -c 2 -f S16_LE |
> aplay -", but as soon as mplayer is starting, I can't hear anything
> anymore.
> 
> ...which means that using alsa as the sound device with mplayer doesn't
> work either.
> 
> Am I missing something?

Maybe the amux is wrong. The only way to know for sure is to check the used GPIO's,
via a USB snoop dump. Please take a look at linuxtv.org Wiki (search for usbsnoop).
After getting the dump, please parse it and send me.

> 
> I checked the source code, Terratec Grabby support was introduced with
> 4557af9c5338605c85fe54f5ebba3d4b14a60ab8:
> 
> -----------------------------------------
> diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
> index 7cb93fb..b4c78f2 100644
> --- a/drivers/media/video/em28xx/em28xx-cards.c
> +++ b/drivers/media/video/em28xx/em28xx-cards.c
> @@ -1347,6 +1347,22 @@ struct em28xx_board em28xx_boards[] = {
>              .amux     = EM28XX_AMUX_VIDEO,
>          } },
>      },
> +    [EM2860_BOARD_TERRATEC_GRABBY] = {
> +        .name            = "Terratec Grabby",
> +        .vchannels       = 2,
> +        .tuner_type      = TUNER_ABSENT,
> +        .decoder         = EM28XX_SAA711X,
> +        .xclk            = EM28XX_XCLK_FREQUENCY_12MHZ,
> +        .input           = { {
> +            .type     = EM28XX_VMUX_COMPOSITE1,
> +            .vmux     = SAA7115_COMPOSITE0,
> +            .amux     = EM28XX_AMUX_VIDEO2,
> +        }, {
> +            .type     = EM28XX_VMUX_SVIDEO,
> +            .vmux     = SAA7115_SVIDEO3,
> +            .amux     = EM28XX_AMUX_VIDEO2,
> +        } },
> +    },
>  };
>  const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
> 
> @@ -1410,6 +1426,8 @@ struct usb_device_id em28xx_id_table[] = {
>              .driver_info = EM2870_BOARD_TERRATEC_XS },
>      { USB_DEVICE(0x0ccd, 0x0047),
>              .driver_info = EM2880_BOARD_TERRATEC_PRODIGY_XS },
> +    { USB_DEVICE(0x0ccd, 0x0096),
> +            .driver_info = EM2860_BOARD_TERRATEC_GRABBY },
>      { USB_DEVICE(0x185b, 0x2870),
>              .driver_info = EM2870_BOARD_COMPRO_VIDEOMATE },
>      { USB_DEVICE(0x185b, 0x2041),
> diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
> index e801f78..fa2fb41 100644
> --- a/drivers/media/video/em28xx/em28xx.h
> +++ b/drivers/media/video/em28xx/em28xx.h
> @@ -103,6 +103,7 @@
>  #define EM2860_BOARD_EASYCAP                      64
>  #define EM2820_BOARD_IODATA_GVMVP_SZ          65
>  #define EM2880_BOARD_EMPIRE_DUAL_TV          66
> +#define EM2860_BOARD_TERRATEC_GRABBY          67
> 
>  /* Limits minimum and default number of buffers */
>  #define EM28XX_MIN_BUF 4
> -----------------------------------------
> 
> Is there maybe a wrong amux set? Which one could it be?
> Is sound-usb-audio somehow conflicting with em28xx module?
> 
> I hope you have an idea what is wrong here!
> 
> Florian Klink
> 

