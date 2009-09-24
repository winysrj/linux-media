Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:34234 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbZIXSzk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Sep 2009 14:55:40 -0400
Received: by ewy7 with SMTP id 7so1937709ewy.17
        for <linux-media@vger.kernel.org>; Thu, 24 Sep 2009 11:55:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090922210915.GD8661@systol-ng.god.lan>
References: <20090922210915.GD8661@systol-ng.god.lan>
Date: Thu, 24 Sep 2009 14:55:42 -0400
Message-ID: <37219a840909241155h1b809877mf7ae1807e34a2f87@mail.gmail.com>
Subject: Re: [PATCH 4/4] Zolid Hybrid PCI card add AGC control
From: Michael Krufky <mkrufky@kernellabs.com>
To: Henk.Vergonet@gmail.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 22, 2009 at 5:09 PM,  <spam@systol-ng.god.lan> wrote:
>
> Switches IF AGC control via GPIO 21 of the saa7134. Improves DTV reception and
> FM radio reception.
>
> Signed-off-by: Henk.Vergonet@gmail.com

Reviewed-by: Michael Krufky <mkrufky@kernellabs.com>

Henk,

This is *very* interesting...  Have you taken a scope to the board to
measure AGC interference?   This seems to be *very* similar to
Hauppauge's design for the HVR1120 and HVR1150 boards, which are
actually *not* based on any reference design.

I have no problems with this patch, but I would be interested to hear
that you can prove it is actually needed by using a scope.  If you
don't have a scope, I understand....  but this certainly peaks my
interest.

Do you have schematics of that board?

Regards,

Mike Krufky

>
> diff -r 29e4ba1a09bc linux/drivers/media/video/saa7134/saa7134-cards.c
> --- a/linux/drivers/media/video/saa7134/saa7134-cards.c Sat Sep 19 09:45:22 2009 -0300
> +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c Tue Sep 22 22:06:31 2009 +0200
> @@ -6651,6 +6651,22 @@
>        return 0;
>  }
>
> +static inline int saa7134_tda18271_zolid_toggle_agc(struct saa7134_dev *dev,
> +                                                     enum tda18271_mode mode)
> +{
> +       switch (mode) {
> +       case TDA18271_ANALOG:
> +               saa7134_set_gpio(dev, 21, 0);
> +               break;
> +       case TDA18271_DIGITAL:
> +               saa7134_set_gpio(dev, 21, 1);
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +       return 0;
> +}
> +
>  static int saa7134_tda8290_18271_callback(struct saa7134_dev *dev,
>                                          int command, int arg)
>  {
> @@ -6663,7 +6679,8 @@
>                case SAA7134_BOARD_HAUPPAUGE_HVR1120:
>                        ret = saa7134_tda18271_hvr11x0_toggle_agc(dev, arg);
>                        break;
> -               default:
> +               case SAA7134_BOARD_ZOLID_HYBRID_PCI:
> +                       ret = saa7134_tda18271_zolid_toggle_agc(dev, arg);
>                        break;
>                }
>                break;
> @@ -6682,6 +6699,7 @@
>        switch (dev->board) {
>        case SAA7134_BOARD_HAUPPAUGE_HVR1150:
>        case SAA7134_BOARD_HAUPPAUGE_HVR1120:
> +       case SAA7134_BOARD_ZOLID_HYBRID_PCI:
>                /* tda8290 + tda18271 */
>                ret = saa7134_tda8290_18271_callback(dev, command, arg);
>                break;
> @@ -6985,6 +7003,11 @@
>                saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00008000, 0x00008000);
>                saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
>                break;
> +       case SAA7134_BOARD_ZOLID_HYBRID_PCI:
> +               saa7134_set_gpio(dev, 21, 0);   /* s0 HC4052 */
> +               saa7134_set_gpio(dev, 22, 0);   /* vsync tda18271 - TODO implement saa713x driven sync in analog TV modes */
> +               saa7134_set_gpio(dev, 23, 0);   /* s1 HC4052 */
> +               break;
>        }
>        return 0;
>  }
> diff -r 29e4ba1a09bc linux/drivers/media/video/saa7134/saa7134-dvb.c
> --- a/linux/drivers/media/video/saa7134/saa7134-dvb.c   Sat Sep 19 09:45:22 2009 -0300
> +++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c   Tue Sep 22 22:06:31 2009 +0200
> @@ -1026,8 +1026,17 @@
>        .disable_gate_access = 1,
>  };
>
> +static struct tda18271_std_map zolid_tda18271_std_map = {
> +       /* FM reception via RF_IN */
> +       .fm_radio = { .if_freq = 1250, .fm_rfn = 0, .agc_mode = 3, .std = 0,
> +                     .if_lvl = 0, .rfagc_top = 0x2c, },
> +};
> +
>  static struct tda18271_config zolid_tda18271_config = {
> +       .std_map = &zolid_tda18271_std_map,
>        .gate    = TDA18271_GATE_ANALOG,
> +       .config  = 3,
> +       .output_opt = TDA18271_OUTPUT_LT_OFF,
>  };
>
>  /* ==================================================================
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
