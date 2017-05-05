Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:36247 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbdEEAGY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 May 2017 20:06:24 -0400
Received: by mail-qk0-f194.google.com with SMTP id y128so2637060qka.3
        for <linux-media@vger.kernel.org>; Thu, 04 May 2017 17:06:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170504222115.GA26659@googlemail.com>
References: <20170504222115.GA26659@googlemail.com>
From: Markus Rechberger <mrechberger@gmail.com>
Date: Fri, 5 May 2017 08:06:23 +0800
Message-ID: <CA+O4pCJqqSqE_YFDM6unU8pvuVoRJijkNOv64AWD6CPdbxD5qA@mail.gmail.com>
Subject: Re: [PATCH] [media] em28xx: support for Sundtek MediaTV Digital Home
To: Thomas Hollstegge <thomas.hollstegge@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 5, 2017 at 6:21 AM, Thomas Hollstegge
<thomas.hollstegge@gmail.com> wrote:
> Sundtek MediaTV Digital Home is a rebranded MaxMedia UB425-TC with the
> following components:
>
> USB bridge: Empia EM2874B
> Demodulator: Micronas DRX 3913KA2
> Tuner: NXP TDA18271HDC2
>

Not that it matters a lot anymore for those units however the USB ID
is allocated for multiple different units, this patch will break some
of them.
If you want to use that use the unit with this driver you're on your
own and have to assign it via sysfs and usb/bind.

It was a joint project many years ago before we also started to design
and manufacture our own units.

Best Regards,
Markus Rechberger

> Signed-off-by: Thomas Hollstegge <thomas.hollstegge@gmail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-cards.c | 15 +++++++++++++++
>  drivers/media/usb/em28xx/em28xx-dvb.c   |  1 +
>  drivers/media/usb/em28xx/em28xx.h       |  1 +
>  3 files changed, 17 insertions(+)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index 5f90d08..4effbda 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -415,6 +415,7 @@ static struct em28xx_reg_seq hauppauge_930c_digital[] = {
>
>  /* 1b80:e425 MaxMedia UB425-TC
>   * 1b80:e1cc Delock 61959
> + * eb1a:51b2 Sundtek MediaTV Digital Home
>   * GPIO_6 - demod reset, 0=active
>   * GPIO_7 - LED, 0=active
>   */
> @@ -2405,6 +2406,18 @@ struct em28xx_board em28xx_boards[] = {
>                 .ir_codes      = RC_MAP_HAUPPAUGE,
>                 .leds          = hauppauge_dualhd_leds,
>         },
> +       /* eb1a:51b2 Sundtek MediaTV Digital Home
> +        * Empia EM2874B + Micronas DRX 3913KA2 + NXP TDA18271HDC2 */
> +       [EM2874_BOARD_SUNDTEK_MEDIATV_DIGITAL_HOME] = {
> +               .name          = "Sundtek MediaTV Digital Home",
> +               .tuner_type    = TUNER_ABSENT,
> +               .tuner_gpio    = maxmedia_ub425_tc,
> +               .has_dvb       = 1,
> +               .ir_codes      = RC_MAP_REDDO,
> +               .def_i2c_bus   = 1,
> +               .i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE |
> +                               EM28XX_I2C_FREQ_400_KHZ,
> +       },
>  };
>  EXPORT_SYMBOL_GPL(em28xx_boards);
>
> @@ -2600,6 +2613,8 @@ struct usb_device_id em28xx_id_table[] = {
>                         .driver_info = EM28178_BOARD_TERRATEC_T2_STICK_HD },
>         { USB_DEVICE(0x3275, 0x0085),
>                         .driver_info = EM28178_BOARD_PLEX_PX_BCUD },
> +       { USB_DEVICE(0xeb1a, 0x51b2),
> +                       .driver_info = EM2874_BOARD_SUNDTEK_MEDIATV_DIGITAL_HOME },
>         { },
>  };
>  MODULE_DEVICE_TABLE(usb, em28xx_id_table);
> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> index 82edd37..e7fa25d 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -1482,6 +1482,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
>                 break;
>         }
>         case EM2874_BOARD_DELOCK_61959:
> +       case EM2874_BOARD_SUNDTEK_MEDIATV_DIGITAL_HOME:
>         case EM2874_BOARD_MAXMEDIA_UB425_TC:
>                 /* attach demodulator */
>                 dvb->fe[0] = dvb_attach(drxk_attach, &maxmedia_ub425_tc_drxk,
> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> index e9f3799..72f1468 100644
> --- a/drivers/media/usb/em28xx/em28xx.h
> +++ b/drivers/media/usb/em28xx/em28xx.h
> @@ -148,6 +148,7 @@
>  #define EM28178_BOARD_PLEX_PX_BCUD                98
>  #define EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_DVB  99
>  #define EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_01595 100
> +#define EM2874_BOARD_SUNDTEK_MEDIATV_DIGITAL_HOME 101
>
>  /* Limits minimum and default number of buffers */
>  #define EM28XX_MIN_BUF 4
> --
> 2.7.4
>
