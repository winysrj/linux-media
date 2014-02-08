Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39769 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbaBHJsK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Feb 2014 04:48:10 -0500
Message-ID: <52F5FD58.2050506@iki.fi>
Date: Sat, 08 Feb 2014 11:48:08 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Luis Alves <ljalvs@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/8] rtl2832: Fix deadlock on i2c mux select function.
References: <1391852281-18291-1-git-send-email-crope@iki.fi> <1391852281-18291-4-git-send-email-crope@iki.fi>
In-Reply-To: <1391852281-18291-4-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Luis,
Could you send your SOB?

Antti

On 08.02.2014 11:37, Antti Palosaari wrote:
> From: Luis Alves <ljalvs@gmail.com>
>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>   drivers/media/dvb-frontends/rtl2832.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
> index c0366a8..cfc5438 100644
> --- a/drivers/media/dvb-frontends/rtl2832.c
> +++ b/drivers/media/dvb-frontends/rtl2832.c
> @@ -917,7 +917,7 @@ static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
>   	buf[0] = 0x00;
>   	buf[1] = 0x01;
>
> -	ret = i2c_transfer(adap, msg, 1);
> +	ret = __i2c_transfer(adap, msg, 1);
>   	if (ret != 1)
>   		goto err;
>
> @@ -930,7 +930,7 @@ static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
>   	else
>   		buf[1] = 0x10; /* close */
>
> -	ret = i2c_transfer(adap, msg, 1);
> +	ret = __i2c_transfer(adap, msg, 1);
>   	if (ret != 1)
>   		goto err;
>
>


-- 
http://palosaari.fi/
