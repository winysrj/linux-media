Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62006 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab0JKPy1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 11:54:27 -0400
Received: by mail-iw0-f174.google.com with SMTP id 9so37477iwn.19
        for <linux-media@vger.kernel.org>; Mon, 11 Oct 2010 08:54:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=dRSDj5W4LsYkNmLEERkWYCHsFuwePeDuXruyU@mail.gmail.com>
References: <AANLkTi=dRSDj5W4LsYkNmLEERkWYCHsFuwePeDuXruyU@mail.gmail.com>
Date: Mon, 11 Oct 2010 08:54:27 -0700
Message-ID: <AANLkTikeaHeQ4cTCcbr1dBUUB5zmiUo9ux2ZhmYHvhpu@mail.gmail.com>
Subject: Re: [PATCH] gp8psk: Add support for the Genpix Skywalker-2
From: VDR User <user.vdr@gmail.com>
To: Alan Nisota <alannisota@gmail.com>,
	"mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

People are still waiting for this to be applied.  Any reason it hasn't been?

On Tue, Aug 17, 2010 at 10:56 AM, VDR User <user.vdr@gmail.com> wrote:
> gp8psk: Add support for the Genpix Skywalker-2 per user requests.
>
> Patched against v4l-dvb hg ab433502e041 tip.  Should patch fine
> against git as well.
>
> Signed-off-by: Derek Kelly <user.vdr@gmail.com>
> ----------
> diff -pruN v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> --- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> 2010-08-17 09:53:27.000000000 -0700
> +++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> 2010-08-17 10:38:48.000000000 -0700
> @@ -267,6 +267,7 @@
>  #define USB_PID_GENPIX_8PSK_REV_2                      0x0202
>  #define USB_PID_GENPIX_SKYWALKER_1                     0x0203
>  #define USB_PID_GENPIX_SKYWALKER_CW3K                  0x0204
> +#define USB_PID_GENPIX_SKYWALKER_2                     0x0206
>  #define USB_PID_SIGMATEK_DVB_110                       0x6610
>  #define USB_PID_MSI_DIGI_VOX_MINI_II                   0x1513
>  #define USB_PID_MSI_DIGIVOX_DUO                                0x8801
> diff -pruN v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/gp8psk.c
> v4l-dvb/linux/drivers/media/dvb/dvb-usb/gp8psk.c
> --- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/gp8psk.c
> 2010-08-17 09:53:27.000000000 -0700
> +++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/gp8psk.c    2010-08-17
> 10:42:33.000000000 -0700
> @@ -227,6 +227,7 @@ static struct usb_device_id gp8psk_usb_t
>            { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_1_WARM) },
>            { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_2) },
>            { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_SKYWALKER_1) },
> +           { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_SKYWALKER_2) },
>  /*         { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_SKYWALKER_CW3K) }, */
>            { 0 },
>  };
> @@ -258,7 +259,7 @@ static struct dvb_usb_device_properties
>
>        .generic_bulk_ctrl_endpoint = 0x01,
>
> -       .num_device_descs = 3,
> +       .num_device_descs = 4,
>        .devices = {
>                { .name = "Genpix 8PSK-to-USB2 Rev.1 DVB-S receiver",
>                  .cold_ids = { &gp8psk_usb_table[0], NULL },
> @@ -272,10 +273,14 @@ static struct dvb_usb_device_properties
>                  .cold_ids = { NULL },
>                  .warm_ids = { &gp8psk_usb_table[3], NULL },
>                },
> +               { .name = "Genpix SkyWalker-2 DVB-S receiver",
> +                 .cold_ids = { NULL },
> +                 .warm_ids = { &gp8psk_usb_table[4], NULL },
> +               },
>  #if 0
>                { .name = "Genpix SkyWalker-CW3K DVB-S receiver",
>                  .cold_ids = { NULL },
> -                 .warm_ids = { &gp8psk_usb_table[4], NULL },
> +                 .warm_ids = { &gp8psk_usb_table[5], NULL },
>                },
>  #endif
>                { NULL },
>
