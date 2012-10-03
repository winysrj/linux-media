Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57011 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab2JCAhe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Oct 2012 20:37:34 -0400
Message-ID: <506B88B8.4060600@iki.fi>
Date: Wed, 03 Oct 2012 03:37:12 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgQ2FyZG9uYQ==?= <remi.cardona@smartjog.com>
CC: linux-media@vger.kernel.org, liplianin@me.by
Subject: Re: [PATCH 3/7] [media] ds3000: properly report register read errors
References: <1348837172-11784-1-git-send-email-remi.cardona@smartjog.com> <1348837172-11784-4-git-send-email-remi.cardona@smartjog.com>
In-Reply-To: <1348837172-11784-4-git-send-email-remi.cardona@smartjog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/28/2012 03:59 PM, Rémi Cardona wrote:
> This brings both ds3000_readreg() and ds3000_tuner_readreg() in line
> with ds3000_writereg() and ds3000_tuner_writereg() respectively.
>
> Signed-off-by: Rémi Cardona <remi.cardona@smartjog.com>

Reviewed-by: Antti Palosaari <crope@iki.fi>

> ---
>   drivers/media/dvb-frontends/ds3000.c |   11 +++++++----
>   1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
> index 474f26e..6752222 100644
> --- a/drivers/media/dvb-frontends/ds3000.c
> +++ b/drivers/media/dvb-frontends/ds3000.c
> @@ -340,7 +340,7 @@ static int ds3000_readreg(struct ds3000_state *state, u8 reg)
>
>   	if (ret != 2) {
>   		printk(KERN_ERR "%s: reg=0x%x(error=%d)\n", __func__, reg, ret);
> -		return ret;
> +		return -EREMOTEIO;
>   	}
>
>   	dprintk("%s: read reg 0x%02x, value 0x%02x\n", __func__, reg, b1[0]);
> @@ -367,12 +367,15 @@ static int ds3000_tuner_readreg(struct ds3000_state *state, u8 reg)
>   		}
>   	};
>
> -	ds3000_writereg(state, 0x03, 0x12);
> -	ret = i2c_transfer(state->i2c, msg, 2);
> +	ret = ds3000_writereg(state, 0x03, 0x12);
> +	if (ret < 0) {
> +		return -EREMOTEIO;
> +	}
>
> +	ret = i2c_transfer(state->i2c, msg, 2);
>   	if (ret != 2) {
>   		printk(KERN_ERR "%s: reg=0x%x(error=%d)\n", __func__, reg, ret);
> -		return ret;
> +		return -EREMOTEIO;
>   	}
>
>   	dprintk("%s: read reg 0x%02x, value 0x%02x\n", __func__, reg, b1[0]);
>


-- 
http://palosaari.fi/
