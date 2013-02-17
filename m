Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55165 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112Ab3BQW1a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Feb 2013 17:27:30 -0500
Message-ID: <5121592C.8050103@iki.fi>
Date: Mon, 18 Feb 2013 00:26:52 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Fabrizio Gazzato <fabrizio.gazzato@gmail.com>
CC: linux-media@vger.kernel.org, gennarone@gmail.com
Subject: Re: [PATCH] af9035: add ID [0ccd:00aa] TerraTec Cinergy T Stick (rev.
 2)
References: <CAA=TYk_Mc552Gx98aeaB6t9_t7pfK_w5Ka==g76hez2c0ufXMg@mail.gmail.com>
In-Reply-To: <CAA=TYk_Mc552Gx98aeaB6t9_t7pfK_w5Ka==g76hez2c0ufXMg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/18/2013 12:25 AM, Fabrizio Gazzato wrote:
> This patch adds USB ID for alternative "Terratec Cinergy T Stick".
> Tested by a friend: works similarly to 0ccd:0093 version (af9035+tua9001)
>
> Please delete the previous patch
>
> Regards
>
>
> Signed-off-by: Fabrizio Gazzato <fabrizio.gazzato@gmail.com>

Acked-by: Antti Palosaari <crope@iki.fi>


> ---
>   drivers/media/usb/dvb-usb-v2/af9035.c |    2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c
> b/drivers/media/usb/dvb-usb-v2/af9035.c
> index 61ae7f9..c3cd6be 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
> @@ -1133,6 +1133,8 @@ static const struct usb_device_id af9035_id_table[] = {
>   		&af9035_props, "AVerMedia Twinstar (A825)", NULL) },
>   	{ DVB_USB_DEVICE(USB_VID_ASUS, USB_PID_ASUS_U3100MINI_PLUS,
>   		&af9035_props, "Asus U3100Mini Plus", NULL) },
> +        { DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00aa,
> +		&af9035_props, "TerraTec Cinergy T Stick (rev. 2)", NULL) },
>   	{ }
>   };
>   MODULE_DEVICE_TABLE(usb, af9035_id_table);
>


-- 
http://palosaari.fi/
