Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56455 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984Ab1G2Myo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 08:54:44 -0400
Message-ID: <4E32AD92.8060500@iki.fi>
Date: Fri, 29 Jul 2011 15:54:42 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: HoP <jpetrous@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATH v2] cxd2820r: fix possible out-of-array lookup
References: <CAJbz7-0BNRvKb82fhcvZf63hXp-RXV+WT4uX0h9_zaDPfTPgiA@mail.gmail.com>
In-Reply-To: <CAJbz7-0BNRvKb82fhcvZf63hXp-RXV+WT4uX0h9_zaDPfTPgiA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/29/2011 09:57 AM, HoP wrote:
> When I2C_WRITE is used the msg[] array contains one element only.
> Don't access msg[1] in that case. Also moved rest of msg2[1]
> setting to be used only if needed.
> 
> Signed-off-by: Honza Petrous <jpetrous@smartimp.cz>
Acked-by: Antti Palosaari <crope@iki.fi>

> 
> ---
> 
> diff -r ae517614bf00 drivers/media/dvb/frontends/cxd2820r_core.c
> --- a/drivers/media/dvb/frontends/cxd2820r_core.c	Thu Jul 28 15:44:49 2011 +0200
> +++ b/drivers/media/dvb/frontends/cxd2820r_core.c	Thu Jul 28 16:20:17 2011 +0200
> @@ -747,12 +747,7 @@ static int cxd2820r_tuner_i2c_xfer(struc
>  			.flags = 0,
>  			.len = sizeof(obuf),
>  			.buf = obuf,
> -		}, {
> -			.addr = priv->cfg.i2c_address,
> -			.flags = I2C_M_RD,
> -			.len = msg[1].len,
> -			.buf = msg[1].buf,
> -		}
> +		},
>  	};
> 
>  	obuf[0] = 0x09;
> @@ -760,6 +755,11 @@ static int cxd2820r_tuner_i2c_xfer(struc
>  	if (num == 2) { /* I2C read */
>  		obuf[1] = (msg[0].addr << 1) | I2C_M_RD; /* I2C RD flag */
>  		msg2[0].len = sizeof(obuf) - 1; /* maybe HW bug ? */
> +
> +		msg2[1].addr = priv->cfg.i2c_address,
> +		msg2[1].flags = I2C_M_RD,
> +		msg2[1].len = msg[1].len,
> +		msg2[1].buf = msg[1].buf,
>  	}
>  	memcpy(&obuf[2], msg[0].buf, msg[0].len);


-- 
http://palosaari.fi/
