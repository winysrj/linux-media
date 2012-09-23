Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34285 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095Ab2IWQU3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 12:20:29 -0400
Message-ID: <505F36B7.3010606@iki.fi>
Date: Sun, 23 Sep 2012 19:20:07 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org, Darryl Bond <darryl.bond@gmail.com>
Subject: Re: [PATCH] rtl28xxu: [0413:6680] DigitalNow Quad DVB-T Receiver
References: <1348177242-12494-1-git-send-email-crope@iki.fi>
In-Reply-To: <1348177242-12494-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/21/2012 12:40 AM, Antti Palosaari wrote:
> It is 4 x RTL2832U + 4 x FC0012 in one PCIe board.
> Of course there is a PCIe USB host controller too.
>
> Big thanks for Darryl Bond reporting and testing that!
>
> Cc: Darryl Bond <darryl.bond@gmail.com>
> Signed-off-by: Antti Palosaari <crope@iki.fi>

Maybe proper tags doesn't hurt here.

Tested-by: Darryl Bond <darryl.bond@gmail.com>
Reported-by: Darryl Bond <darryl.bond@gmail.com>

> ---
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index 70c2df1..f62cfba 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1342,6 +1342,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
>   		&rtl2832u_props, "Trekstor DVB-T Stick Terres 2.0", NULL) },
>   	{ DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1101,
>   		&rtl2832u_props, "Dexatek DK DVB-T Dongle", NULL) },
> +	{ DVB_USB_DEVICE(USB_VID_LEADTEK, 0x6680,
> +		&rtl2832u_props, "DigitalNow Quad DVB-T Receiver", NULL) },
>   	{ }
>   };
>   MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
>


-- 
http://palosaari.fi/
