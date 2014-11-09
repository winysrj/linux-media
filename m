Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57946 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbaKIV5g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Nov 2014 16:57:36 -0500
Message-ID: <545FE34E.2040205@iki.fi>
Date: Sun, 09 Nov 2014 23:57:34 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Nibble Max <nibble.max@gmail.com>,
	Olli Salonen <olli.salonen@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/1] dvb-usb-dvbsky: fix i2c adapter for sp2 device
References: <201411081634137039659@gmail.com>
In-Reply-To: <201411081634137039659@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/08/2014 10:34 AM, Nibble Max wrote:
> It is wrong that sp2 device uses the i2c adapter from m88ds3103 return.
> sp2 device sits on the same i2c bus with m88ds3103, not behind m88ds3103.
>
> Signed-off-by: Nibble Max <nibble.max@gmail.com>

Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti

> ---
>   drivers/media/usb/dvb-usb-v2/dvbsky.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
> index c67a118..8be8447 100644
> --- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
> +++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
> @@ -479,7 +479,7 @@ static int dvbsky_s960c_attach(struct dvb_usb_adapter *adap)
>   	info.addr = 0x40;
>   	info.platform_data = &sp2_config;
>   	request_module("sp2");
> -	client_ci = i2c_new_device(i2c_adapter, &info);
> +	client_ci = i2c_new_device(&d->i2c_adap, &info);
>   	if (client_ci == NULL || client_ci->dev.driver == NULL) {
>   		ret = -ENODEV;
>   		goto fail_ci_device;
>
>

-- 
http://palosaari.fi/
