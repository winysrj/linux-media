Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41756 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab3BMJWg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Feb 2013 04:22:36 -0500
Message-ID: <511B5B34.9060208@iki.fi>
Date: Wed, 13 Feb 2013 11:21:56 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Alistair Buxton <a.j.buxton@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] rtl28xxu: Add USB IDs for Compro VideoMate U620F.
References: <1360720727-22212-1-git-send-email-a.j.buxton@gmail.com>
In-Reply-To: <1360720727-22212-1-git-send-email-a.j.buxton@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/13/2013 03:58 AM, Alistair Buxton wrote:
> Signed-off-by: Alistair Buxton <a.j.buxton@gmail.com>

Acked-by: Antti Palosaari <crope@iki.fi>


> ---
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c |    2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index a4c302d..d8a8a88 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1352,6 +1352,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
>   		&rtl2832u_props, "Dexatek DK mini DVB-T Dongle", NULL) },
>   	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00d7,
>   		&rtl2832u_props, "TerraTec Cinergy T Stick+", NULL) },
> +	{ DVB_USB_DEVICE(USB_VID_COMPRO, 0x0620,
> +		&rtl2832u_props, "Compro VideoMate U620F", NULL) },
>   	{ }
>   };
>   MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
>


-- 
http://palosaari.fi/
