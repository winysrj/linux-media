Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51692 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab3AAT5A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jan 2013 14:57:00 -0500
Message-ID: <50E33F61.4000000@iki.fi>
Date: Tue, 01 Jan 2013 21:56:17 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Eddi De Pieri <eddi@depieri.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Support Avermedia A835B
References: <CAKdnbx593exZgqOMYaJZD1h4pDZDDNM8pNo29zf3=etrtwQT4g@mail.gmail.com>
In-Reply-To: <CAKdnbx593exZgqOMYaJZD1h4pDZDDNM8pNo29zf3=etrtwQT4g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/22/2012 03:41 PM, Eddi De Pieri wrote:
> Add support for Avermedia A835B

Did you tested that all?

These are just same IDs I looked from Windows driver few weeks back as 
topic "avermedia, new version of avertv volar green hd" was talked and 
sent to nickname moebius. He has unable to make tests as he returned device.

regards
Antti


>
> Signed-off-by: Eddi De Pieri <eddi@depieri.net>
>
> diff --git a/drivers/media/dvb-core/dvb-usb-ids.h
> b/drivers/media/dvb-core/dvb-usb-ids.h
> index 26c4481..84d7759 100644
> --- a/drivers/media/dvb-core/dvb-usb-ids.h
> +++ b/drivers/media/dvb-core/dvb-usb-ids.h
> @@ -231,6 +231,10 @@
>   #define USB_PID_AVERMEDIA_A815M                                0x815a
>   #define USB_PID_AVERMEDIA_A835                         0xa835
>   #define USB_PID_AVERMEDIA_B835                         0xb835
> +#define USB_PID_AVERMEDIA_A835B_1835                   0x1835
> +#define USB_PID_AVERMEDIA_A835B_2835                   0x2835
> +#define USB_PID_AVERMEDIA_A835B_3835                   0x3835
> +#define USB_PID_AVERMEDIA_A835B_4835                   0x4835
>   #define USB_PID_AVERMEDIA_1867                         0x1867
>   #define USB_PID_AVERMEDIA_A867                         0xa867
>   #define USB_PID_AVERMEDIA_TWINSTAR                     0x0825
> diff --git a/drivers/media/usb/dvb-usb-v2/it913x.c
> b/drivers/media/usb/dvb-usb-v2/it913x.c
> index 1ca8fea..b2e9b87 100644
> --- a/drivers/media/usb/dvb-usb-v2/it913x.c
> +++ b/drivers/media/usb/dvb-usb-v2/it913x.c
> @@ -773,6 +773,18 @@ static const struct usb_device_id it913x_id_table[] = {
>          { DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135_9006,
>                  &it913x_properties, "ITE 9135(9006) Generic",
>                          RC_MAP_IT913X_V1) },
> +       { DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A835B_1835,
> +               &it913x_properties, "Avermedia A835B(1835)",
> +                       RC_MAP_IT913X_V2) },
> +       { DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A835B_2835,
> +               &it913x_properties, "Avermedia A835B(2835)",
> +                       RC_MAP_IT913X_V2) },
> +       { DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A835B_3835,
> +               &it913x_properties, "Avermedia A835B(3835)",
> +                       RC_MAP_IT913X_V2) },
> +       { DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A835B_4835,
> +               &it913x_properties, "Avermedia A835B(4835)",
> +                       RC_MAP_IT913X_V2) },
>          {}              /* Terminating entry */
>   };
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
http://palosaari.fi/
