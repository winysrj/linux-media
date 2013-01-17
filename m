Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53455 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756558Ab3AQPbg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 10:31:36 -0500
Message-ID: <50F81933.40809@iki.fi>
Date: Thu, 17 Jan 2013 17:30:59 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Eddi De Pieri <eddi@depieri.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Support Digivox Mini HD (rtl2832)
References: <CAKdnbx7Qx7z1BVxaXsDAe8mDG9jhPQeAkPbZGof++B1xK31Wsw@mail.gmail.com>
In-Reply-To: <CAKdnbx7Qx7z1BVxaXsDAe8mDG9jhPQeAkPbZGof++B1xK31Wsw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/15/2013 12:21 AM, Eddi De Pieri wrote:
> Add support for Digivox Mini HD (rtl2832)
>
> The tuner works, but with worst performance then realtek linux driver,
> due to incomplete implementation of fc2580.c
>
> Signed-off-by: Eddi De Pieri <eddi@depieri.net>
> Tested-by: Lorenzo Dongarrà <lorenzo_64@katamail.com>
>
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index b6f4849..c05ea16 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1368,6 +1368,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
>                  &rtl2832u_props, "ASUS My Cinema-U3100Mini Plus V2", NULL) },
>          { DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd393,
>                  &rtl2832u_props, "GIGABYTE U7300", NULL) },
> +       { DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1104,
> +               &rtl2832u_props, "Digivox Micro Hd", NULL) },
>          { }
>   };
>   MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>


-- 
http://palosaari.fi/
