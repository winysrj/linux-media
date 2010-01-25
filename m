Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757Ab0AYMkU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 07:40:20 -0500
Message-ID: <4B5D912F.6000609@redhat.com>
Date: Mon, 25 Jan 2010 10:40:15 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Andrea.Amorosi76@gmail.com" <Andrea.Amorosi76@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: How can I add IR remote to this new device (DIKOM DK300)?
References: <4B51132A.1000606@gmail.com>
In-Reply-To: <4B51132A.1000606@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrea,

Andrea.Amorosi76@gmail.com wrote:
> Hi to all,
> I'm trying to use my Dikom DK300, my old notebook and an external
> monitor to create a media centre (I'm mostly interested in TV and TV
> recording).
> 
> The problem is that, even if I have managed to have the device working
> with the following patch, I can't still use the IR remote control
> shipped with it.

This basically depends on the chipset found on your device. Newer em28xx
devices have the IR decoding logic inside the chip. So, all you need is to
create a table with your IR codes and point to it at the board entry. You'll
need to discover what kind of IR protocol is used: NEC or RC5.

For example, adding this to the board description:
                .ir_codes       = &ir_codes_rc5_hauppauge_new_table,

Will program your chip to use RC5 protocol with the Hauppauge table.

Of course, your IR has a different table, so you'll need to load em28xx module
with ir_debug=1, and type every key of your keyboard, associating a keycode
with the scancode and writing a new table (or using an existing one, if equal).

Then, add the corresponding table at ir-keymaps.c.

> Can you give me some suggestion in order to have also the remote
> controller working? Otherwise is it easier to buy another remote with a
> dedicated receiver?
> 
> Moreover, since the digital demodulator remains activated when the tuner
> is switched from digital to analogue mode or when kaffeine (which
> actually I'm using to see digital tv) is closed, I wonder if someone can
> explain me how to verify the gpio settings using the usbsnoop (which
> I've done some times ago under win XP) to solve the issue.
> If it is not possible, is there any way to deactivate the usb port and
> reactivate it when the device is in needed?
> 
> Meantime this it the patch that fixes the Dikom DK300 hybrid USB card
> which is recognized as a Kworld VS-DVB-T 323UR (card=54).

Please, create a separate entry for your board, since your card is different.
Unfortunately, since both Kworld 323UR and Dikom dk300 share the same USB ID,
autodetection between the two is not possible, so a modprobe parameter will
be needed to differentiate between the two.

> The patch adds digital TV and solves analogue TV audio bad quality issue.
> Moreover it removes the composite and s-video analogue inputs which are
> not present on the board.
> 
> Not working: remote controller
> 
> Signed-off-by: Andrea Amorosi <Andrea.Amorosi76@gmail.com>
> 
> diff -r 59e746a1c5d1 linux/drivers/media/video/em28xx/em28xx-cards.c
> --- a/linux/drivers/media/video/em28xx/em28xx-cards.c    Wed Dec 30
> 09:10:33 2009 -0200
> +++ b/linux/drivers/media/video/em28xx/em28xx-cards.c    Tue Jan 12
> 21:58:30 2010 +0100
> @@ -1447,19 +1447,25 @@
>         .tuner_type   = TUNER_XC2028,
>         .tuner_gpio   = default_tuner_gpio,
>         .decoder      = EM28XX_TVP5150,
> +        .mts_firmware = 1,
> +        .has_dvb      = 1,
> +        .dvb_gpio     = kworld_330u_digital,
>         .input        = { {
>             .type     = EM28XX_VMUX_TELEVISION,
>             .vmux     = TVP5150_COMPOSITE0,
>             .amux     = EM28XX_AMUX_VIDEO,
> -        }, {
> +            .gpio     = default_analog,
> +        },/* {
>             .type     = EM28XX_VMUX_COMPOSITE1,
>             .vmux     = TVP5150_COMPOSITE1,
>             .amux     = EM28XX_AMUX_LINE_IN,
> +            .gpio     = kworld_330u_analog,
>         }, {
>             .type     = EM28XX_VMUX_SVIDEO,
>             .vmux     = TVP5150_SVIDEO,
>             .amux     = EM28XX_AMUX_LINE_IN,
> -        } },
> +            .gpio     = kworld_330u_analog,
> +        } */},
>     },
>     [EM2882_BOARD_TERRATEC_HYBRID_XS] = {
>         .name         = "Terratec Hybrid XS (em2882)",
> @@ -2168,6 +2174,7 @@
>         ctl->demod = XC3028_FE_DEFAULT;
>         break;
>     case EM2883_BOARD_KWORLD_HYBRID_330U:
> +    case EM2882_BOARD_KWORLD_VS_DVBT:
>         ctl->demod = XC3028_FE_CHINA;
>         ctl->fname = XC2028_DEFAULT_FIRMWARE;
>         break;
> diff -r 59e746a1c5d1 linux/drivers/media/video/em28xx/em28xx-dvb.c
> --- a/linux/drivers/media/video/em28xx/em28xx-dvb.c    Wed Dec 30
> 09:10:33 2009 -0200
> +++ b/linux/drivers/media/video/em28xx/em28xx-dvb.c    Tue Jan 12
> 21:58:30 2010 +0100
> @@ -504,6 +504,7 @@
>         break;
>     case EM2880_BOARD_TERRATEC_HYBRID_XS:
>     case EM2881_BOARD_PINNACLE_HYBRID_PRO:
> +    case EM2882_BOARD_KWORLD_VS_DVBT:
>         dvb->frontend = dvb_attach(zl10353_attach,
>                        &em28xx_zl10353_xc3028_no_i2c_gate,
>                        &dev->i2c_adap);
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

