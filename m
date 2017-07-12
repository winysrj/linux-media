Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43366 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750766AbdGLXYu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 19:24:50 -0400
Subject: Re: [PATCH] Added support for the TerraTec T1 DVB-T USB tuner [IT9135
 chipset]
To: Nuno Henriques <nuno.amhenriques@gmail.com>,
        linux-media@vger.kernel.org
References: <20170629175554.19099-1-nuno.amhenriques@gmail.com>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <13ab44fb-cd6e-d7c6-4f2f-de03e7eb170d@iki.fi>
Date: Thu, 13 Jul 2017 02:24:47 +0300
MIME-Version: 1.0
In-Reply-To: <20170629175554.19099-1-nuno.amhenriques@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/29/2017 08:55 PM, Nuno Henriques wrote:
> Signed-off-by: Nuno Henriques <nuno.amhenriques@gmail.com>
> ---
>   drivers/media/dvb-core/dvb-usb-ids.h  | 1 +
>   drivers/media/usb/dvb-usb-v2/af9035.c | 2 ++
>   2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
> index e200aa6f2d2f..5b6041d462bc 100644
> --- a/drivers/media/dvb-core/dvb-usb-ids.h
> +++ b/drivers/media/dvb-core/dvb-usb-ids.h
> @@ -279,6 +279,7 @@
>   #define USB_PID_TERRATEC_H7				0x10b4
>   #define USB_PID_TERRATEC_H7_2				0x10a3
>   #define USB_PID_TERRATEC_H7_3				0x10a5
> +#define USB_PID_TERRATEC_T1				0x10ae
>   #define USB_PID_TERRATEC_T3				0x10a0
>   #define USB_PID_TERRATEC_T5				0x10a1
>   #define USB_PID_NOXON_DAB_STICK				0x00b3
> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
> index 4df9486e19b9..ccf4a5c68877 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
> @@ -2108,6 +2108,8 @@ static const struct usb_device_id af9035_id_table[] = {
>   	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_CTVDIGDUAL_V2,
>   		&af9035_props, "Digital Dual TV Receiver CTVDIGDUAL_V2",
>   							RC_MAP_IT913X_V1) },
> +	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_T1,
> +		&af9035_props, "TerraTec T1", RC_MAP_IT913X_V1) },
>   	/* XXX: that same ID [0ccd:0099] is used by af9015 driver too */
>   	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x0099,
>   		&af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 2)",
> 


Does this stick has a remote? I see always red when I see someone adds 
RC_MAP_IT913X_V1 remote controller as there is now too many simply 
totally wrongly defined remote controllers on that driver.

Commit message is missing, even it is very trivial patch there should be 
something like It is IT9135BX device having USB ID xxxx:yyyy and remote 
controller model is xxxxx.xxxx.

Use git log to see other commit messages where new usb id is added.

regards
Antti

-- 
http://palosaari.fi/
