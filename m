Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51686 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab2KVX3i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 18:29:38 -0500
Message-ID: <50AEB542.4050200@iki.fi>
Date: Fri, 23 Nov 2012 01:29:06 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Juergen Lock <nox@jelal.kn-bremen.de>
CC: linux-media@vger.kernel.org, hselasky@c2i.net
Subject: Re: [PATCH] [media] rtl28xxu: add NOXON DAB/DAB+ USB dongle rev 2
References: <20121113180928.GA40337@triton8.kn-bremen.de>
In-Reply-To: <20121113180928.GA40337@triton8.kn-bremen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/13/2012 08:09 PM, Juergen Lock wrote:
> This just adds the usbid to the rtl28xxu driver, that's all that's
> needed to make the stick work for DVB.
>
> Signed-off-by: Juergen Lock <nox@jelal.kn-bremen.de>
>
> --- a/drivers/media/dvb-core/dvb-usb-ids.h
> +++ b/drivers/media/dvb-core/dvb-usb-ids.h
> @@ -250,6 +250,7 @@
>   #define USB_PID_TERRATEC_T3				0x10a0
>   #define USB_PID_TERRATEC_T5				0x10a1
>   #define USB_PID_NOXON_DAB_STICK				0x00b3
> +#define USB_PID_NOXON_DAB_STICK_REV2			0x00e0
>   #define USB_PID_PINNACLE_EXPRESSCARD_320CX		0x022e
>   #define USB_PID_PINNACLE_PCTV2000E			0x022c
>   #define USB_PID_PINNACLE_PCTV_DVB_T_FLASH		0x0228
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1338,6 +1338,8 @@ static const struct usb_device_id rtl28x
>   		&rtl2832u_props, "G-Tek Electronics Group Lifeview LV5TDLX DVB-T", NULL) },
>   	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK,
>   		&rtl2832u_props, "NOXON DAB/DAB+ USB dongle", NULL) },
> +	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK_REV2,
> +		&rtl2832u_props, "NOXON DAB/DAB+ USB dongle (rev 2)", NULL) },
>   	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_TREKSTOR_TERRES_2_0,
>   		&rtl2832u_props, "Trekstor DVB-T Stick Terres 2.0", NULL) },
>   	{ DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1101,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Applied thanks! I will pull-request that for Kernel 3.8

http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/for_v3.8-rtl28xxu

regards
Antti


-- 
http://palosaari.fi/
