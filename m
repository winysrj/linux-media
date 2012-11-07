Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40376 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab2KGGY0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Nov 2012 01:24:26 -0500
Message-ID: <5099FE7D.7020801@iki.fi>
Date: Wed, 07 Nov 2012 08:23:57 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Andrew Karpow <andy@mailbox.tu-berlin.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] rtl28xxu: 0ccd:00d7 TerraTec Cinergy T Stick+
References: <509996BC.5060101@mailbox.tu-berlin.de>
In-Reply-To: <509996BC.5060101@mailbox.tu-berlin.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/07/2012 01:01 AM, Andrew Karpow wrote:
> added usb-id as driver supports the stick
>
> Signed-off-by: Andrew Karpow <andy@mailbox.tu-berlin.de>
> ---
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index 0149cdd..093f1ac 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1348,6 +1348,8 @@ static const struct usb_device_id
> rtl28xxu_id_table[] = {
>          &rtl2832u_props, "TerraTec Cinergy T Stick RC (Rev. 3)", NULL) },
>      { DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1102,
>          &rtl2832u_props, "Dexatek DK mini DVB-T Dongle", NULL) },
> +   { DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00d7,
> +       &rtl2832u_props, "TerraTec Cinergy T Stick+", NULL) },
>      { }
>   };
>   MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
>

Acked-by: Antti Palosaari <crope@iki.fi>

Thank you!

Could someone say if that simple USB ID addition could be added to the 
Kernel 3.7 which is already in release candidate phase?

regards
Antti

-- 
http://palosaari.fi/
