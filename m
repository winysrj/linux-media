Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:33493 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbeAEAYl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 19:24:41 -0500
Received: by mail-qk0-f196.google.com with SMTP id x85so142828qkb.0
        for <linux-media@vger.kernel.org>; Thu, 04 Jan 2018 16:24:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1515110659-20145-7-git-send-email-brad@nextdimension.cc>
References: <1515110659-20145-1-git-send-email-brad@nextdimension.cc> <1515110659-20145-7-git-send-email-brad@nextdimension.cc>
From: Michael Ira Krufky <mkrufky@linuxtv.org>
Date: Thu, 4 Jan 2018 19:24:40 -0500
Message-ID: <CAOcJUbxpGS1p68kpTEv5O0CGipDZ3xtEcYuS9wFraGdy=ZFHDw@mail.gmail.com>
Subject: Re: [PATCH 6/9] em28xx: Enable Hauppauge SoloHD rebranded 292e SE
To: Brad Love <brad@nextdimension.cc>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 4, 2018 at 7:04 PM, Brad Love <brad@nextdimension.cc> wrote:
> Add a missing device to the driver table.
>
> Signed-off-by: Brad Love <brad@nextdimension.cc>

:+1

Reviewed-by: Michael Ira Krufky <mkrufky@linuxtv.org>

> ---
>  drivers/media/usb/em28xx/em28xx-cards.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index 34c693a..66d4c3a 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -2619,6 +2619,8 @@ struct usb_device_id em28xx_id_table[] = {
>                         .driver_info = EM28178_BOARD_PCTV_461E },
>         { USB_DEVICE(0x2013, 0x025f),
>                         .driver_info = EM28178_BOARD_PCTV_292E },
> +       { USB_DEVICE(0x2013, 0x0264), /* Hauppauge WinTV-soloHD 292e SE */
> +                       .driver_info = EM28178_BOARD_PCTV_292E },
>         { USB_DEVICE(0x2040, 0x0264), /* Hauppauge WinTV-soloHD Isoc */
>                         .driver_info = EM28178_BOARD_PCTV_292E },
>         { USB_DEVICE(0x2040, 0x8264), /* Hauppauge OEM Generic WinTV-soloHD Bulk */
> --
> 2.7.4
>
