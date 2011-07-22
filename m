Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50018 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285Ab1GVWhU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 18:37:20 -0400
Message-ID: <4E29FB9E.4060507@iki.fi>
Date: Sat, 23 Jul 2011 01:37:18 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: HoP <jpetrous@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] cxd2820r: fix possible out-of-array lookup
References: <CAJbz7-29H=e=C2SyY-6Ru23Zzv6sH7wBbOm72ZWMxqOagakuKQ@mail.gmail.com>
In-Reply-To: <CAJbz7-29H=e=C2SyY-6Ru23Zzv6sH7wBbOm72ZWMxqOagakuKQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/23/2011 01:18 AM, HoP wrote:
> In case of i2c write operation there is only one element in msg[] array.
> Don't access msg[1] in that case.

NACK.
I suspect you confuse now local msg2 and msg that is passed as function 
parameter. Could you double check and explain?


regards
Antti

>
> Signed-off-by: Honza Petrous<jpetrous@smartimp.cz>
>
> --
>
> diff -uBbp cxd2820r_core.c.orig cxd2820r_core.c
> --- cxd2820r_core.c.orig	2011-07-22 23:31:56.319168405 +0200
> +++ cxd2820r_core.c	2011-07-22 23:35:02.508046078 +0200
> @@ -750,8 +750,6 @@ static int cxd2820r_tuner_i2c_xfer(struc
>   		}, {
>   			.addr = priv->cfg.i2c_address,
>   			.flags = I2C_M_RD,
> -			.len = msg[1].len,
> -			.buf = msg[1].buf,
>   		}
>   	};
>
> @@ -760,6 +758,8 @@ static int cxd2820r_tuner_i2c_xfer(struc
>   	if (num == 2) { /* I2C read */
>   		obuf[1] = (msg[0].addr<<  1) | I2C_M_RD; /* I2C RD flag */
>   		msg2[0].len = sizeof(obuf) - 1; /* maybe HW bug ? */
> +		msg2[1].len = msg[1].len;
> +		msg2[1].buf = msg[1].buf;
>   	}
>   	memcpy(&obuf[2], msg[0].buf, msg[0].len);


-- 
http://palosaari.fi/
