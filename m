Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39096 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab2KFW6a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Nov 2012 17:58:30 -0500
Message-ID: <509995F9.20509@iki.fi>
Date: Wed, 07 Nov 2012 00:58:01 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org, Hubert Lin <hubertwslin@gmail.com>
Subject: Re: [PATCH] rtl28xxu: 1d19:1102 Dexatek DK mini DVB-T Dongle
References: <1352229407-30411-1-git-send-email-crope@iki.fi>
In-Reply-To: <1352229407-30411-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Short question,
is simple ID addition for device driver like that allowed to push during 
RC phase (for Kernel 3.7 as now is RC4 released)?

I tried to look documentation but didn't found answer.

regards
Antti


On 11/06/2012 09:16 PM, Antti Palosaari wrote:
> Add new USB ID as driver supports it.
>
> Reported-by: Hubert Lin <hubertwslin@gmail.com>
> Tested-by: Hubert Lin <hubertwslin@gmail.com>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index adabba8..0149cdd 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1346,6 +1346,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
>   		&rtl2832u_props, "DigitalNow Quad DVB-T Receiver", NULL) },
>   	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00d3,
>   		&rtl2832u_props, "TerraTec Cinergy T Stick RC (Rev. 3)", NULL) },
> +	{ DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1102,
> +		&rtl2832u_props, "Dexatek DK mini DVB-T Dongle", NULL) },
>   	{ }
>   };
>   MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
>


-- 
http://palosaari.fi/
