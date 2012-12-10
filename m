Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab2LJRXF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 12:23:05 -0500
Message-ID: <50C61A60.8090603@redhat.com>
Date: Mon, 10 Dec 2012 15:22:40 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH RFC 06/11] az6007: make remote controller optional
References: <1355100335-2123-1-git-send-email-crope@iki.fi> <1355100335-2123-6-git-send-email-crope@iki.fi>
In-Reply-To: <1355100335-2123-6-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 09-12-2012 22:45, Antti Palosaari escreveu:
> Do not compile remote controller when RC-core is disabled by Kconfig.
>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Signed-off-by: Antti Palosaari <crope@iki.fi>

Seems OK for me.

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> ---
>   drivers/media/usb/dvb-usb-v2/az6007.c | 26 +++++++++++++++-----------
>   1 file changed, 15 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
> index d75dbf2..3b33f1e 100644
> --- a/drivers/media/usb/dvb-usb-v2/az6007.c
> +++ b/drivers/media/usb/dvb-usb-v2/az6007.c
> @@ -189,6 +189,7 @@ static int az6007_streaming_ctrl(struct dvb_frontend *fe, int onoff)
>   	return az6007_write(d, 0xbc, onoff, 0, NULL, 0);
>   }
>
> +#if defined(CONFIG_RC_CORE) || defined(CONFIG_RC_CORE_MODULE)
>   /* remote control stuff (does not work with my box) */
>   static int az6007_rc_query(struct dvb_usb_device *d)
>   {
> @@ -215,6 +216,20 @@ static int az6007_rc_query(struct dvb_usb_device *d)
>   	return 0;
>   }
>
> +static int az6007_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
> +{
> +	pr_debug("Getting az6007 Remote Control properties\n");
> +
> +	rc->allowed_protos = RC_BIT_NEC;
> +	rc->query          = az6007_rc_query;
> +	rc->interval       = 400;
> +
> +	return 0;
> +}
> +#else
> +	#define az6007_get_rc_config NULL
> +#endif
> +
>   static int az6007_ci_read_attribute_mem(struct dvb_ca_en50221 *ca,
>   					int slot,
>   					int address)
> @@ -822,17 +837,6 @@ static void az6007_usb_disconnect(struct usb_interface *intf)
>   	dvb_usbv2_disconnect(intf);
>   }
>
> -static int az6007_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
> -{
> -	pr_debug("Getting az6007 Remote Control properties\n");
> -
> -	rc->allowed_protos = RC_BIT_NEC;
> -	rc->query          = az6007_rc_query;
> -	rc->interval       = 400;
> -
> -	return 0;
> -}
> -
>   static int az6007_download_firmware(struct dvb_usb_device *d,
>   	const struct firmware *fw)
>   {
>

