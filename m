Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47952 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746AbaLHUzp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Dec 2014 15:55:45 -0500
Message-ID: <5486104D.8090601@iki.fi>
Date: Mon, 08 Dec 2014 22:55:41 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] mn88472: fix firmware downloading
References: <1418070667-13349-1-git-send-email-benjamin@southpole.se>
In-Reply-To: <1418070667-13349-1-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!

But that patch is rather useless :] Only thing needed is to change 
existing value in file drivers/media/usb/dvb-usb-v2/rtl28xxu.c :
mn88472_config.i2c_wr_max = 22,
... and that leaves room for use even smaller values if there is an I2C 
adapter which cannot write even 17 bytes.

2nd thing is to add comment mn88472.h to specify that max limit and 
that's all.

regards
Antti


On 12/08/2014 10:31 PM, Benjamin Larsson wrote:
> The max amount of payload bytes in each i2c transfer when
> loading the demodulator firmware is 16 bytes.
>
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
> ---
>   drivers/staging/media/mn88472/mn88472.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
> index ffee187..df7dbe9 100644
> --- a/drivers/staging/media/mn88472/mn88472.c
> +++ b/drivers/staging/media/mn88472/mn88472.c
> @@ -15,6 +15,7 @@
>    */
>
>   #include "mn88472_priv.h"
> +#define FW_BUF_SIZE 16
>
>   static int mn88472_get_tune_settings(struct dvb_frontend *fe,
>   	struct dvb_frontend_tune_settings *s)
> @@ -331,10 +332,10 @@ static int mn88472_init(struct dvb_frontend *fe)
>   		goto err;
>
>   	for (remaining = fw->size; remaining > 0;
> -			remaining -= (dev->i2c_wr_max - 1)) {
> +			remaining -= FW_BUF_SIZE) {
>   		len = remaining;
> -		if (len > (dev->i2c_wr_max - 1))
> -			len = (dev->i2c_wr_max - 1);
> +		if (len > FW_BUF_SIZE)
> +			len = FW_BUF_SIZE;
>
>   		ret = regmap_bulk_write(dev->regmap[0], 0xf6,
>   				&fw->data[fw->size - remaining], len);
>

-- 
http://palosaari.fi/
