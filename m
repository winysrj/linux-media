Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:59157 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab3JJNmJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Oct 2013 09:42:09 -0400
Received: by mail-ee0-f54.google.com with SMTP id e53so1164365eek.41
        for <linux-media@vger.kernel.org>; Thu, 10 Oct 2013 06:42:07 -0700 (PDT)
Message-ID: <5256AEC2.4020501@googlemail.com>
Date: Thu, 10 Oct 2013 15:42:26 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Jean-Francois Thibert <jfthibert@google.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2] Add support for KWorld UB435-Q V2
References: <CACxGHmPH_hLd5OM+1em_m_o8AK3z9_zTcEs5UieQ13A2_cy-8Q@mail.gmail.com>
In-Reply-To: <CACxGHmPH_hLd5OM+1em_m_o8AK3z9_zTcEs5UieQ13A2_cy-8Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 09.10.2013 16:18, schrieb Jean-Francois Thibert:
> This patch adds support for the UB435-Q V2. You might need to
> use the device once with the Windows driver provided by KWorld
> in order to permanently reprogram the device descriptors. Thanks
> to Jarod Wilson for the initial attempt at adding support for this
> device.
>
> Signed-off-by: Jean-Francois Thibert <jfthibert@google.com>
> ---
>  drivers/media/usb/em28xx/em28xx-cards.c |   14 +++++++++++++-
>  drivers/media/usb/em28xx/em28xx-dvb.c   |   27 +++++++++++++++++++++++++++
>  drivers/media/usb/em28xx/em28xx.h       |    1 +
>  3 files changed, 41 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c
> b/drivers/media/usb/em28xx/em28xx-cards.c
> index dc65742..a512909 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -174,7 +174,7 @@ static struct em28xx_reg_seq evga_indtube_digital[] = {
>  };
>
>  /*
> - * KWorld PlusTV 340U and UB435-Q (ATSC) GPIOs map:
> + * KWorld PlusTV 340U, UB435-Q and UB435-Q V2 (ATSC) GPIOs map:
>   * EM_GPIO_0 - currently unknown
>   * EM_GPIO_1 - LED disable/enable (1 = off, 0 = on)
>   * EM_GPIO_2 - currently unknown
> @@ -2030,6 +2030,16 @@ struct em28xx_board em28xx_boards[] = {
>   .i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE |
>   EM28XX_I2C_FREQ_400_KHZ,
>   },
> + /* 1b80:e346 KWorld USB ATSC TV Stick UB435-Q V2
> + * Empia EM2874B + LG DT3305 + NXP TDA18271HDC2 */
> + [EM2874_BOARD_KWORLD_UB435Q_V2] = {
> + .name       = "KWorld USB ATSC TV Stick UB435-Q V2",
> + .tuner_type = TUNER_ABSENT,
> + .has_dvb    = 1,
> + .dvb_gpio   = kworld_a340_digital,
> + .tuner_gpio = default_tuner_gpio,
> + .def_i2c_bus  = 1,
> + },
>  };
>  const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
>
> @@ -2173,6 +2183,8 @@ struct usb_device_id em28xx_id_table[] = {
>   .driver_info = EM2860_BOARD_GADMEI_UTV330 },
>   { USB_DEVICE(0x1b80, 0xa340),
>   .driver_info = EM2870_BOARD_KWORLD_A340 },
> + { USB_DEVICE(0x1b80, 0xe346),
> + .driver_info = EM2874_BOARD_KWORLD_UB435Q_V2 },
>   { USB_DEVICE(0x2013, 0x024f),
>   .driver_info = EM28174_BOARD_PCTV_290E },
>   { USB_DEVICE(0x2013, 0x024c),
> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c
> b/drivers/media/usb/em28xx/em28xx-dvb.c
> index bb1e8dc..547eea6 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -298,6 +298,18 @@ static struct lgdt3305_config em2870_lgdt3304_dev = {
>   .qam_if_khz         = 4000,
>  };
>
> +static struct lgdt3305_config em2874_lgdt3305_dev = {
> + .i2c_addr           = 0x0e,
> + .demod_chip         = LGDT3305,
> + .spectral_inversion = 1,
> + .deny_i2c_rptr      = 0,
> + .mpeg_mode          = LGDT3305_MPEG_SERIAL,
> + .tpclk_edge         = LGDT3305_TPCLK_FALLING_EDGE,
> + .tpvalid_polarity   = LGDT3305_TP_VALID_HIGH,
> + .vsb_if_khz         = 3250,
> + .qam_if_khz         = 4000,
> +};
> +
>  static struct s921_config sharp_isdbt = {
>   .demod_address = 0x30 >> 1
>  };
> @@ -329,6 +341,12 @@ static struct tda18271_config kworld_a340_config = {
>   .std_map           = &kworld_a340_std_map,
>  };
>
> +static struct tda18271_config kworld_ub435q_v2_config = {
> + .std_map           = &kworld_a340_std_map,
> + .gate              = TDA18271_GATE_DIGITAL,

TDA18271_GATE_AUTO doesn't work ? Then you could use kworld_a340_config.
Or the other way around: wouldn't TDA18271_GATE_DIGITAL also work for
the A340 ?

Apart from that:

Reviewed-by: Frank Schäfer <fschaefer.oss@googlemail.com>

Regards,
Frank

> +};
> +
> +
>  static struct zl10353_config em28xx_zl10353_xc3028_no_i2c_gate = {
>   .demod_address = (0x1e >> 1),
>   .no_tuner = 1,
> @@ -1297,6 +1315,15 @@ static int em28xx_dvb_init(struct em28xx *dev)
>   goto out_free;
>   }
>   break;
> + case EM2874_BOARD_KWORLD_UB435Q_V2:
> + dvb->fe[0] = dvb_attach(lgdt3305_attach,
> +   &em2874_lgdt3305_dev,
> +   &dev->i2c_adap[dev->def_i2c_bus]);
> + if (dvb->fe[0] != NULL)
> + dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
> +   &dev->i2c_adap[dev->def_i2c_bus], &kworld_ub435q_v2_config);
> +
> + break;
>   default:
>   em28xx_errdev("/2: The frontend of your DVB/ATSC card"
>   " isn't supported yet\n");
> diff --git a/drivers/media/usb/em28xx/em28xx.h
> b/drivers/media/usb/em28xx/em28xx.h
> index 205e903..6d988ad 100644
> --- a/drivers/media/usb/em28xx/em28xx.h
> +++ b/drivers/media/usb/em28xx/em28xx.h
> @@ -131,6 +131,7 @@
>  #define EM2884_BOARD_TERRATEC_HTC_USB_XS  87
>  #define EM2884_BOARD_C3TECH_DIGITAL_DUO  88
>  #define EM2874_BOARD_DELOCK_61959  89
> +#define EM2874_BOARD_KWORLD_UB435Q_V2  90
>
>  /* Limits minimum and default number of buffers */
>  #define EM28XX_MIN_BUF 4

