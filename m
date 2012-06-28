Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44298 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab2F1WB7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 18:01:59 -0400
Received: by yenl2 with SMTP id l2so2270869yen.19
        for <linux-media@vger.kernel.org>; Thu, 28 Jun 2012 15:01:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FECCCB4.9000402@gmail.com>
References: <4FECCCB4.9000402@gmail.com>
Date: Thu, 28 Jun 2012 18:01:58 -0400
Message-ID: <CAGoCfizFta5ZJOYKXP7_2Z+ygKku2gr1x1p9UnXqLLRC8wCEPA@mail.gmail.com>
Subject: Re: [PATCH 1/1] Add support for newer PCTV 800i cards with s5h1411 demodulators
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mack Stanley <mcs1937@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 28, 2012 at 5:29 PM, Mack Stanley <mcs1937@gmail.com> wrote:
> Testing is needed on older (aka Pinnacle) PCTV 800i cards with S5H1409
> demodulators
> to check that current support for them isn't broken by this patch.
>
> Signed-off-by: Mack Stanley <mcs1937@gmail.com>
> ---
>  drivers/media/video/cx88/cx88-dvb.c |   40
> ++++++++++++++++++++++++----------
>  1 files changed, 28 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/media/video/cx88/cx88-dvb.c
> b/drivers/media/video/cx88/cx88-dvb.c
> index 003937c..6d49672 100644
> --- a/drivers/media/video/cx88/cx88-dvb.c
> +++ b/drivers/media/video/cx88/cx88-dvb.c
> @@ -501,7 +501,7 @@ static const struct cx24123_config
> kworld_dvbs_100_config = {
>        .lnb_polarity  = 1,
>  };
>
> -static const struct s5h1409_config pinnacle_pctv_hd_800i_config = {
> +static const struct s5h1409_config pinnacle_pctv_hd_800i_s5h1409_config = {
>        .demod_address = 0x32 >> 1,
>        .output_mode   = S5H1409_PARALLEL_OUTPUT,
>        .gpio          = S5H1409_GPIO_ON,
> @@ -509,7 +509,7 @@ static const struct s5h1409_config
> pinnacle_pctv_hd_800i_config = {
>        .inversion     = S5H1409_INVERSION_OFF,
>        .status_mode   = S5H1409_DEMODLOCKING,
>        .mpeg_timing   = S5H1409_MPEGTIMING_NONCONTINOUS_NONINVERTING_CLOCK,
> -};
> +};
>
>  static const struct s5h1409_config dvico_hdtv5_pci_nano_config = {
>        .demod_address = 0x32 >> 1,
> @@ -556,6 +556,16 @@ static const struct s5h1411_config
> dvico_fusionhdtv7_config = {
>        .status_mode   = S5H1411_DEMODLOCKING
>  };
>
> +static const struct s5h1411_config pinnacle_pctv_hd_800i_s5h1411_config = {
> +       .output_mode   = S5H1411_PARALLEL_OUTPUT,
> +       .gpio          = S5H1411_GPIO_ON,
> +       .mpeg_timing   = S5H1411_MPEGTIMING_NONCONTINOUS_NONINVERTING_CLOCK,
> +       .qam_if        = S5H1411_IF_44000,
> +       .vsb_if        = S5H1411_IF_44000,
> +       .inversion     = S5H1411_INVERSION_OFF,
> +       .status_mode   = S5H1411_DEMODLOCKING
> +};
> +
>  static const struct xc5000_config dvico_fusionhdtv7_tuner_config = {
>        .i2c_address    = 0xc2 >> 1,
>        .if_khz         = 5380,
> @@ -1297,16 +1307,22 @@ static int dvb_register(struct cx8802_dev *dev)
>                }
>                break;
>        case CX88_BOARD_PINNACLE_PCTV_HD_800i:
> -               fe0->dvb.frontend = dvb_attach(s5h1409_attach,
> -
> &pinnacle_pctv_hd_800i_config,
> -                                              &core->i2c_adap);
> -               if (fe0->dvb.frontend != NULL) {
> -                       if (!dvb_attach(xc5000_attach, fe0->dvb.frontend,
> -                                       &core->i2c_adap,
> -
> &pinnacle_pctv_hd_800i_tuner_config))
> -                               goto frontend_detach;
> -               }
> -               break;
> +               /* Try s5h1409 chip first */
> +               fe0->dvb.frontend = dvb_attach(s5h1409_attach,
> +
> &pinnacle_pctv_hd_800i_s5h1409_config,
> +                                       &core->i2c_adap);
> +               /* Otherwise, try s5h1411 */
> +               if (fe0->dvb.frontend == NULL)
> +                       fe0->dvb.frontend = dvb_attach(s5h1411_attach,
> +
> &pinnacle_pctv_hd_800i_s5h1411_config,
> +                                       &core->i2c_adap);
> +               if (fe0->dvb.frontend != NULL) {
> +                       if (!dvb_attach(xc5000_attach, fe0->dvb.frontend,
> +                                       &core->i2c_adap,
> +
> &pinnacle_pctv_hd_800i_tuner_config))
> +                               goto frontend_detach;
> +               }
> +               break;
>        case CX88_BOARD_DVICO_FUSIONHDTV_5_PCI_NANO:
>                fe0->dvb.frontend = dvb_attach(s5h1409_attach,
>
> &dvico_hdtv5_pci_nano_config,
> --
> 1.7.7.6
>
>

Looks good.  Thanks for taking the time to put this together.

Reviewed-by: Devin Heitmueller <dheitmueller@kernellabs.com>

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
