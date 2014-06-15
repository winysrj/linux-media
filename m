Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37790 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbaFOJTZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jun 2014 05:19:25 -0400
Received: from 85-23-164-3.bb.dnainternet.fi ([85.23.164.3] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1Ww6ax-0005f2-LG
	for linux-media@vger.kernel.org; Sun, 15 Jun 2014 12:19:23 +0300
Message-ID: <539D651A.30505@iki.fi>
Date: Sun, 15 Jun 2014 12:19:22 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] rtl28xxu: add [1b80:d3b0] Sveon STV21
References: <20140612062245.GA1668@wolfgang>
In-Reply-To: <20140612062245.GA1668@wolfgang>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>

Mauro, please pick that from patchwork, I am not going to PULL request it.


regards
Antti


On 06/12/2014 09:22 AM, Sebastian Kemper wrote:
> Added Sveon STV21 device based on Realtek RTL2832U and FC0013 tuner
>
> Signed-off-by: Sebastian Kemper <sebastian_ml@gmx.net>
> ---
>
> diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
> index 11d2bea..b518ada 100644
> --- a/drivers/media/dvb-core/dvb-usb-ids.h
> +++ b/drivers/media/dvb-core/dvb-usb-ids.h
> @@ -363,6 +363,7 @@
>   #define USB_PID_TVWAY_PLUS				0x0002
>   #define USB_PID_SVEON_STV20				0xe39d
>   #define USB_PID_SVEON_STV20_RTL2832U			0xd39d
> +#define USB_PID_SVEON_STV21				0xd3b0
>   #define USB_PID_SVEON_STV22				0xe401
>   #define USB_PID_SVEON_STV22_IT9137			0xe411
>   #define USB_PID_AZUREWAVE_AZ6027			0x3275
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index a676e44..5f8ff0f 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1541,6 +1541,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
>   		&rtl2832u_props, "Peak DVB-T USB", NULL) },
>   	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV20_RTL2832U,
>   		&rtl2832u_props, "Sveon STV20", NULL) },
> +	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV21,
> +		&rtl2832u_props, "Sveon STV21", NULL) },
>   	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV27,
>   		&rtl2832u_props, "Sveon STV27", NULL) },
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
http://palosaari.fi/
