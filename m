Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43777 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762Ab3LMOc7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 09:32:59 -0500
Message-ID: <52AB1A98.6080803@iki.fi>
Date: Fri, 13 Dec 2013 16:32:56 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Robert Backhaus <robbak@robbak.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Add USB IDs for Winfast DTV Dongle Mini-D
References: <201312131401.rBDE1qoF039531@boffin.lan>
In-Reply-To: <201312131401.rBDE1qoF039531@boffin.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>

regards
Antti

On 13.12.2013 16:01, Robert Backhaus wrote:
> From: Robert Backhaus <robbak@robbak.com>
> Date:   Fri Dec 13 22:59:10 2013 +1000
>
>      Add USB IDs for the WinFast DTV Dongle Mini.
>      Device is tested and works fine under MythTV
>
>      Signed-off-by: Robert Backhaus <robbak@robbak.com>
>
> diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
> index 4a53454..6947621 100644
> --- a/drivers/media/dvb-core/dvb-usb-ids.h
> +++ b/drivers/media/dvb-core/dvb-usb-ids.h
> @@ -317,6 +317,7 @@
>   #define USB_PID_WINFAST_DTV_DONGLE_H			0x60f6
>   #define USB_PID_WINFAST_DTV_DONGLE_STK7700P_2		0x6f01
>   #define USB_PID_WINFAST_DTV_DONGLE_GOLD			0x6029
> +#define USB_PID_WINFAST_DTV_DONGLE_MINID		0x6f0f
>   #define USB_PID_GENPIX_8PSK_REV_1_COLD			0x0200
>   #define USB_PID_GENPIX_8PSK_REV_1_WARM			0x0201
>   #define USB_PID_GENPIX_8PSK_REV_2			0x0202
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index ecca036..fda5c64 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1407,6 +1407,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
>   		&rtl2832u_props, "Dexatek DK DVB-T Dongle", NULL) },
>   	{ DVB_USB_DEVICE(USB_VID_LEADTEK, 0x6680,
>   		&rtl2832u_props, "DigitalNow Quad DVB-T Receiver", NULL) },
> +	{ DVB_USB_DEVICE(USB_VID_LEADTEK, USB_PID_WINFAST_DTV_DONGLE_MINID,
> +		&rtl2832u_props, "Leadtek Winfast DTV Dongle Mini D", NULL) },
>   	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00d3,
>   		&rtl2832u_props, "TerraTec Cinergy T Stick RC (Rev. 3)", NULL) },
>   	{ DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1102,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
http://palosaari.fi/
