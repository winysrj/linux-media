Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54165 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab2ICKzb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Sep 2012 06:55:31 -0400
Message-ID: <50448C8F.8000603@iki.fi>
Date: Mon, 03 Sep 2012 13:55:11 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Philipp Dreimann <philipp@dreimann.net>
CC: linux-media@vger.kernel.org,
	Thomas Mair <thomas.mair86@googlemail.com>
Subject: Re: [PATCH] Add the usb id of the Trekstor DVB-T Stick Terres 2.0
References: <1346628654-3348-1-git-send-email-philipp@dreimann.net>
In-Reply-To: <1346628654-3348-1-git-send-email-philipp@dreimann.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/2012 02:30 AM, Philipp Dreimann wrote:
> It needs the e4000 tuner driver.
>
> Signed-off-by: Philipp Dreimann <philipp@dreimann.net>
> ---
>   drivers/media/dvb-core/dvb-usb-ids.h    |    1 +
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c |    2 ++
>   2 files changed, 3 insertions(+)
>
> diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
> index 26c4481..fed6dcd 100644
> --- a/drivers/media/dvb-core/dvb-usb-ids.h
> +++ b/drivers/media/dvb-core/dvb-usb-ids.h
> @@ -82,6 +82,7 @@
>   #define USB_PID_AFATECH_AF9035_1003			0x1003
>   #define USB_PID_AFATECH_AF9035_9035			0x9035
>   #define USB_PID_TREKSTOR_DVBT				0x901b
> +#define USB_PID_TREKSTOR_TERRES_2_0			0xC803
>   #define USB_VID_ALINK_DTU				0xf170
>   #define USB_PID_ANSONIC_DVBT_USB			0x6000
>   #define USB_PID_ANYSEE					0x861f
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index 88b5ea1..d0d23f2 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1236,6 +1236,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
>   		&rtl2832u_props, "NOXON DAB/DAB+ USB dongle", NULL) },
>   	{ DVB_USB_DEVICE(USB_VID_REALTEK, 0x2838,
>   		&rtl2832u_props, "Realtek RTL2832U reference design", NULL) },
> +	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_TREKSTOR_TERRES_2_0,
> +		&rtl2832u_props, "Trekstor DVB-T Stick Terres 2.0", NULL) },
>   	{ }
>   };
>   MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
>

Acked-by: Antti Palosaari <crope@iki.fi>


Antti
-- 
http://palosaari.fi/
