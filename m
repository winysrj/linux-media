Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34726 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154AbbBPMb5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 07:31:57 -0500
Message-ID: <54E1E337.4060405@iki.fi>
Date: Mon, 16 Feb 2015 14:31:51 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Dimitris Lampridis <dlampridis@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Dimitris Lampridis <dlampridis@logikonlabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] rtl28xxu: add support for Turbo-X DTT2000
References: <1423923094-5289-1-git-send-email-dlampridis@logikonlabs.com>
In-Reply-To: <1423923094-5289-1-git-send-email-dlampridis@logikonlabs.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/14/2015 04:11 PM, Dimitris Lampridis wrote:
> ID 1b80:d3a4 Afatech
>
> Simply added the PID (0xd3a4) of this DVB-T USB device to the list of rtl2832u-supported devices. VID (0x1b80) is same as KWORLD2.
>
> Tested and verified to work in amd64 with kernels 3.13.0 and 3.16.0.
>
> Signed-off-by: Dimitris Lampridis <dlampridis@logikonlabs.com>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>


PS. Could someone correct that USB ID vendor name for database? It is 
not Afatech, but MaxMedia in my understanding...

http://www.maxmediatek.com/pd-page/DVB-T.htm


Antti

> ---
>   drivers/media/dvb-core/dvb-usb-ids.h    | 1 +
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
>   2 files changed, 3 insertions(+)
>
> diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
> index 80ab8d0..a9d601d 100644
> --- a/drivers/media/dvb-core/dvb-usb-ids.h
> +++ b/drivers/media/dvb-core/dvb-usb-ids.h
> @@ -385,4 +385,5 @@
>   #define USB_PID_PCTV_2002E                              0x025c
>   #define USB_PID_PCTV_2002E_SE                           0x025d
>   #define USB_PID_SVEON_STV27                             0xd3af
> +#define USB_PID_TURBOX_DTT_2000                         0xd3a4
>   #endif
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index 77dcfdf..b11380d 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1756,6 +1756,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
>   		&rtl28xxu_props, "Sveon STV21", NULL) },
>   	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV27,
>   		&rtl28xxu_props, "Sveon STV27", NULL) },
> +	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_TURBOX_DTT_2000,
> +		&rtl28xxu_props, "TURBO-X Pure TV Tuner DTT-2000", NULL) },
>
>   	/* RTL2832P devices: */
>   	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
>

-- 
http://palosaari.fi/
