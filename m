Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:42619 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbeAEAYY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 19:24:24 -0500
Received: by mail-qk0-f193.google.com with SMTP id d202so4112819qkc.9
        for <linux-media@vger.kernel.org>; Thu, 04 Jan 2018 16:24:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1515110659-20145-6-git-send-email-brad@nextdimension.cc>
References: <1515110659-20145-1-git-send-email-brad@nextdimension.cc> <1515110659-20145-6-git-send-email-brad@nextdimension.cc>
From: Michael Ira Krufky <mkrufky@linuxtv.org>
Date: Thu, 4 Jan 2018 19:24:22 -0500
Message-ID: <CAOcJUbwsu7Nmr7=8KxMy8zFTgT+=fF3XH3v7Uy8cMPv4tweYaw@mail.gmail.com>
Subject: Re: [PATCH 5/9] em28xx: Add Hauppauge SoloHD/DualHD bulk models
To: Brad Love <brad@nextdimension.cc>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 4, 2018 at 7:04 PM, Brad Love <brad@nextdimension.cc> wrote:
> Add additional pids to driver list
>
> Signed-off-by: Brad Love <brad@nextdimension.cc>

:+1

Reviewed-by: Michael Ira Krufky <mkrufky@linuxtv.org>

> ---
>  drivers/media/usb/em28xx/em28xx-cards.c | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index 7f5d0b28..34c693a 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -507,8 +507,10 @@ static struct em28xx_reg_seq plex_px_bcud[] = {
>  };
>
>  /*
> - * 2040:0265 Hauppauge WinTV-dualHD DVB
> - * 2040:026d Hauppauge WinTV-dualHD ATSC/QAM
> + * 2040:0265 Hauppauge WinTV-dualHD DVB Isoc
> + * 2040:8265 Hauppauge WinTV-dualHD DVB Bulk
> + * 2040:026d Hauppauge WinTV-dualHD ATSC/QAM Isoc
> + * 2040:826d Hauppauge WinTV-dualHD ATSC/QAM Bulk
>   * reg 0x80/0x84:
>   * GPIO_0: Yellow LED tuner 1, 0=on, 1=off
>   * GPIO_1: Green LED tuner 1, 0=on, 1=off
> @@ -2391,7 +2393,8 @@ struct em28xx_board em28xx_boards[] = {
>                 .has_dvb       = 1,
>         },
>         /*
> -        * 2040:0265 Hauppauge WinTV-dualHD (DVB version).
> +        * 2040:0265 Hauppauge WinTV-dualHD (DVB version) Isoc.
> +        * 2040:8265 Hauppauge WinTV-dualHD (DVB version) Bulk.
>          * Empia EM28274, 2x Silicon Labs Si2168, 2x Silicon Labs Si2157
>          */
>         [EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_DVB] = {
> @@ -2407,7 +2410,8 @@ struct em28xx_board em28xx_boards[] = {
>                 .leds          = hauppauge_dualhd_leds,
>         },
>         /*
> -        * 2040:026d Hauppauge WinTV-dualHD (model 01595 - ATSC/QAM).
> +        * 2040:026d Hauppauge WinTV-dualHD (model 01595 - ATSC/QAM) Isoc.
> +        * 2040:826d Hauppauge WinTV-dualHD (model 01595 - ATSC/QAM) Bulk.
>          * Empia EM28274, 2x LG LGDT3306A, 2x Silicon Labs Si2157
>          */
>         [EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_01595] = {
> @@ -2549,8 +2553,12 @@ struct usb_device_id em28xx_id_table[] = {
>                         .driver_info = EM2883_BOARD_HAUPPAUGE_WINTV_HVR_850 },
>         { USB_DEVICE(0x2040, 0x0265),
>                         .driver_info = EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_DVB },
> +       { USB_DEVICE(0x2040, 0x8265),
> +                       .driver_info = EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_DVB },
>         { USB_DEVICE(0x2040, 0x026d),
>                         .driver_info = EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_01595 },
> +       { USB_DEVICE(0x2040, 0x826d),
> +                       .driver_info = EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_01595 },
>         { USB_DEVICE(0x0438, 0xb002),
>                         .driver_info = EM2880_BOARD_AMD_ATI_TV_WONDER_HD_600 },
>         { USB_DEVICE(0x2001, 0xf112),
> @@ -2611,7 +2619,11 @@ struct usb_device_id em28xx_id_table[] = {
>                         .driver_info = EM28178_BOARD_PCTV_461E },
>         { USB_DEVICE(0x2013, 0x025f),
>                         .driver_info = EM28178_BOARD_PCTV_292E },
> -       { USB_DEVICE(0x2040, 0x0264), /* Hauppauge WinTV-soloHD */
> +       { USB_DEVICE(0x2040, 0x0264), /* Hauppauge WinTV-soloHD Isoc */
> +                       .driver_info = EM28178_BOARD_PCTV_292E },
> +       { USB_DEVICE(0x2040, 0x8264), /* Hauppauge OEM Generic WinTV-soloHD Bulk */
> +                       .driver_info = EM28178_BOARD_PCTV_292E },
> +       { USB_DEVICE(0x2040, 0x8268), /* Hauppauge Retail WinTV-soloHD Bulk */
>                         .driver_info = EM28178_BOARD_PCTV_292E },
>         { USB_DEVICE(0x0413, 0x6f07),
>                         .driver_info = EM2861_BOARD_LEADTEK_VC100 },
> --
> 2.7.4
>
