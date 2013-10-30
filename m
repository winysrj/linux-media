Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:37759 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab3J3HLr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Oct 2013 03:11:47 -0400
Received: by mail-ob0-f176.google.com with SMTP id uy5so1030497obc.21
        for <linux-media@vger.kernel.org>; Wed, 30 Oct 2013 00:11:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1383111636-19743-4-git-send-email-crope@iki.fi>
References: <1383111636-19743-1-git-send-email-crope@iki.fi>
	<1383111636-19743-4-git-send-email-crope@iki.fi>
Date: Wed, 30 Oct 2013 08:11:46 +0100
Message-ID: <CAJbz7-27Jc7iCK2g2SQAwtpJzf_B4Phwko895=ZgoCNVC+3_cw@mail.gmail.com>
Subject: Re: [PATCH 4/4] rtl28xxu: add 15f4:0131 Astrometa DVB-T2
From: =?ISO-8859-2?Q?Honza_Petrou=B9?= <jpetrous@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti,
BTW


2013/10/30 Antti Palosaari <crope@iki.fi>:
> Components are RTL2832P + R828D + MN88472.
>
> Currently support only DVB-T as there is no driver for MN88472 demod.

I just (accidentally) found something:
http://code.google.com/p/tdt-amiko/source/browse/tdt/cvs/driver/frontends/spark7162/6158/MN88472_register.c?r=c90ff15db81b1635ce000d89115a31e21a3e5544

It is part of fork of Duckbox project, which is using Linux DVB API,
so it may be worth to try?

/Honza


>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index 8c600b7..ecca036 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1427,6 +1427,9 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
>                 &rtl2832u_props, "Leadtek WinFast DTV Dongle mini", NULL) },
>         { DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_CPYTO_REDI_PC50A,
>                 &rtl2832u_props, "Crypto ReDi PC 50 A", NULL) },
> +
> +       { DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
> +               &rtl2832u_props, "Astrometa DVB-T2", NULL) },
>         { }
>  };
>  MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
