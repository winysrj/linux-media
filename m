Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53626 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbcBKPt6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 10:49:58 -0500
Subject: Re: [PATCH] Add support for Avermedia AverTV Volar HD 2 (TD110)
To: Philippe Valembois <lephilousophe@users.sourceforge.net>
References: <1455005281-25407-1-git-send-email-lephilousophe@users.sourceforge.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <56BCADA4.4040407@iki.fi>
Date: Thu, 11 Feb 2016 17:49:56 +0200
MIME-Version: 1.0
In-Reply-To: <1455005281-25407-1-git-send-email-lephilousophe@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks good!

Reviewed-by: Antti Palosaari <crope@iki.fi>


On 02/09/2016 10:08 AM, Philippe Valembois wrote:
> Signed-off-by: Philippe Valembois <lephilousophe@users.sourceforge.net>
> ---
>   drivers/media/dvb-core/dvb-usb-ids.h  | 1 +
>   drivers/media/usb/dvb-usb-v2/af9035.c | 2 ++
>   2 files changed, 3 insertions(+)
>
> diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
> index dbdbb84..0afad39 100644
> --- a/drivers/media/dvb-core/dvb-usb-ids.h
> +++ b/drivers/media/dvb-core/dvb-usb-ids.h
> @@ -242,6 +242,7 @@
>   #define USB_PID_AVERMEDIA_1867				0x1867
>   #define USB_PID_AVERMEDIA_A867				0xa867
>   #define USB_PID_AVERMEDIA_H335				0x0335
> +#define USB_PID_AVERMEDIA_TD110				0xa110
>   #define USB_PID_AVERMEDIA_TWINSTAR			0x0825
>   #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
>   #define USB_PID_TECHNOTREND_CONNECT_S2400_8KEEPROM	0x3009
> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
> index b3c09fe..2638e32 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
> @@ -2053,6 +2053,8 @@ static const struct usb_device_id af9035_id_table[] = {
>   		&af9035_props, "Avermedia A835B(3835)", RC_MAP_IT913X_V2) },
>   	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A835B_4835,
>   		&af9035_props, "Avermedia A835B(4835)",	RC_MAP_IT913X_V2) },
> +	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_TD110,
> +		&af9035_props, "Avermedia AverTV Volar HD 2 (TD110)", RC_MAP_AVERMEDIA_RM_KS) },
>   	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_H335,
>   		&af9035_props, "Avermedia H335", RC_MAP_IT913X_V2) },
>   	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_UB499_2T_T09,
>

-- 
http://palosaari.fi/
