Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33552 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab3FDWq7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Jun 2013 18:46:59 -0400
Message-ID: <51AE6E3B.3010300@iki.fi>
Date: Wed, 05 Jun 2013 01:46:19 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Alessandro Miceli <angelofsky1980@gmail.com>
Subject: Re: [PATCH] [rtl28xxu] Add support for Crypto Redi PC50A device (rtl2832u
 + FC0012 tuner)
References: <1370376634-3033-1-git-send-email-angelofsky1980@gmail.com>
In-Reply-To: <1370376634-3033-1-git-send-email-angelofsky1980@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Applied!
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/rtl28xxu

t. Antti

On 06/04/2013 11:10 PM, Alessandro Miceli wrote:
> The device has been tested on a MIPSel box with kernel 3.1.1 and backported media_tree drivers
>
> The kernel detects the device with the following output:
>
> usbcore: registered new interface driver dvb_usb_rtl28xxu
> usb 1-2: dvb_usb_v2: found a 'Crypto Redi PC50A' in warm state
> usb 1-2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
> DVB: registering new adapter (Crypto Redi PC50A)
> usb 1-2: DVB: registering adapter 1 frontend 0 (Realtek RTL2832 (DVB-T))...
> i2c i2c-4: fc0012: Fitipower FC0012 successfully identified
> usb 1-2: dvb_usb_v2: 'Crypto Redi PC50A' successfully initialized and connected
>
> Signed-off-by: Alessandro Miceli <angelofsky1980@gmail.com>
> ---
>   drivers/media/dvb-core/dvb-usb-ids.h    |    1 +
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c |    2 ++
>   2 files changed, 3 insertions(+)
>
> diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
> index 2e0709a..87bf2eb 100644
> --- a/drivers/media/dvb-core/dvb-usb-ids.h
> +++ b/drivers/media/dvb-core/dvb-usb-ids.h
> @@ -368,4 +368,5 @@
>   #define USB_PID_TECHNISAT_AIRSTAR_TELESTICK_2		0x0004
>   #define USB_PID_TECHNISAT_USB2_DVB_S2			0x0500
>   #define USB_PID_CTVDIGDUAL_V2				0xe410
> +#define USB_PID_CPYTO_REDI_PC50A			0xa803
>   #endif
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index 22015fe..9a0ad1e 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1408,6 +1408,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
>   		&rtl2832u_props, "Compro VideoMate U620F", NULL) },
>   	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd394,
>   		&rtl2832u_props, "MaxMedia HU394-T", NULL) },
> +	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_CPYTO_REDI_PC50A,
> +		&rtl2832u_props, "Crypto Redi PC50A", NULL) },
>   	{ }
>   };
>   MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
>


-- 
http://palosaari.fi/
