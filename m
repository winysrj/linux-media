Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:52416 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab0CEQWX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Mar 2010 11:22:23 -0500
Received: by bwz22 with SMTP id 22so761251bwz.28
        for <linux-media@vger.kernel.org>; Fri, 05 Mar 2010 08:22:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201003050219.48583.larrosa@kde.org>
References: <201003050219.48583.larrosa@kde.org>
Date: Fri, 5 Mar 2010 11:22:21 -0500
Message-ID: <829197381003050822y798da546ue11f109da5b77863@mail.gmail.com>
Subject: Re: [PATCH] em28xx: Support for Kworld VS-DVB-T 323UR
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antonio Larrosa <larrosa@kde.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 4, 2010 at 8:19 PM, Antonio Larrosa <larrosa@kde.org> wrote:
> em28xx: Support for Kworld VS-DVB-T 323UR
>
> From: Antonio Larrosa <larrosa@kde.org>
>
> This patch adapts the changes submitted by Dainius Ridzevicius to the
> linux-media mailing list on 8/14/09, to the current sources in order
> to make the Kworld VS-DVB-T 323UR usb device work.
>
> I also removed the "not validated" flag since I own the device and validated
> that it works fine after the patch is applied.
>
> Thanks to Devin Heitmueller for his guidance with the code.
>
> Priority: normal
>
> Signed-off-by: Antonio Larrosa <larrosa@kde.org>
>
> diff -r 41c5482f2dac linux/drivers/media/video/em28xx/em28xx-cards.c
> --- a/linux/drivers/media/video/em28xx/em28xx-cards.c   Thu Mar 04 02:49:46 2010 -0300
> +++ b/linux/drivers/media/video/em28xx/em28xx-cards.c   Fri Mar 05 01:41:46 2010 +0100
> @@ -1456,10 +1456,14 @@
>        },
>        [EM2882_BOARD_KWORLD_VS_DVBT] = {
>                .name         = "Kworld VS-DVB-T 323UR",
> -               .valid        = EM28XX_BOARD_NOT_VALIDATED,
>                .tuner_type   = TUNER_XC2028,
>                .tuner_gpio   = default_tuner_gpio,
>                .decoder      = EM28XX_TVP5150,
> +               .mts_firmware = 1,
> +               .has_dvb      = 1,
> +               .dvb_gpio     = kworld_330u_digital,
> +               .xclk         = EM28XX_XCLK_FREQUENCY_12MHZ, /* NEC IR */
> +               .ir_codes     = &ir_codes_kworld_315u_table,
>                .input        = { {
>                        .type     = EM28XX_VMUX_TELEVISION,
>                        .vmux     = TVP5150_COMPOSITE0,
> @@ -2198,6 +2202,7 @@
>                break;
>        case EM2883_BOARD_KWORLD_HYBRID_330U:
>        case EM2882_BOARD_DIKOM_DK300:
> +       case EM2882_BOARD_KWORLD_VS_DVBT:
>                ctl->demod = XC3028_FE_CHINA;
>                ctl->fname = XC2028_DEFAULT_FIRMWARE;
>                break;
> diff -r 41c5482f2dac linux/drivers/media/video/em28xx/em28xx-dvb.c
> --- a/linux/drivers/media/video/em28xx/em28xx-dvb.c     Thu Mar 04 02:49:46 2010 -0300
> +++ b/linux/drivers/media/video/em28xx/em28xx-dvb.c     Fri Mar 05 01:41:46 2010 +0100
> @@ -506,6 +506,7 @@
>        case EM2880_BOARD_TERRATEC_HYBRID_XS_FR:
>        case EM2881_BOARD_PINNACLE_HYBRID_PRO:
>        case EM2882_BOARD_DIKOM_DK300:
> +       case EM2882_BOARD_KWORLD_VS_DVBT:
>                dvb->frontend = dvb_attach(zl10353_attach,
>                                           &em28xx_zl10353_xc3028_no_i2c_gate,
>                                           &dev->i2c_adap);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Acked-by: Devin Heitmueller <dheitmueller@kernellabs.com>

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
