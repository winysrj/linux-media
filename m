Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44553 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab3BOW5T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 17:57:19 -0500
Message-ID: <511EBD28.9060108@iki.fi>
Date: Sat, 16 Feb 2013 00:56:40 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Fabrizio Gazzato <fabrizio.gazzato@gmail.com>
CC: gennarone@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] rtl28xxu: Add USB ID for MaxMedia HU394-T
References: <CAA=TYk8-a2NMSsZHjCygBxijGrfvd_KRDgsGWcKMFFAWMF6ubg@mail.gmail.com>
In-Reply-To: <CAA=TYk8-a2NMSsZHjCygBxijGrfvd_KRDgsGWcKMFFAWMF6ubg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/16/2013 12:54 AM, Fabrizio Gazzato wrote:
> Hi,
>
> please add USB ID for MaxMedia HU394-T USB DVB-T Multi (FM, DAB, DAB+)
> dongle (RTL2832U+FC0012)
>
> In Italy is branded: "DIKOM USB-DVBT HD"
>
> lsusb:
> ID 1b80:d394 Afatech
>
> Regards
>
>
> Signed-off-by: Fabrizio Gazzato <fabrizio.gazzato@gmail.com>

Acked-by: Antti Palosaari <crope@iki.fi>


> ---
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c |    2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index a4c302d..fc7b7a0 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1352,6 +1352,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
>   		&rtl2832u_props, "Dexatek DK mini DVB-T Dongle", NULL) },
>   	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00d7,
>   		&rtl2832u_props, "TerraTec Cinergy T Stick+", NULL) },
> +      { DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd394,
> +		&rtl2832u_props, "MaxMedia HU394-T", NULL) },
>   	{ }
>   };
>   MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
>



-- 
http://palosaari.fi/
