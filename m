Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64457 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab1KIWHF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2011 17:07:05 -0500
Received: by eye27 with SMTP id 27so1914354eye.19
        for <linux-media@vger.kernel.org>; Wed, 09 Nov 2011 14:07:04 -0800 (PST)
Message-ID: <4EBAF97F.4000105@test.com>
Date: Wed, 09 Nov 2011 22:06:55 +0000
From: tvboxspy <malcolmpriestley@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jean Delvare <khali@linux-fr.org>
Subject: Re: [RFC 2/2] tda18218: use generic dvb_wr_regs()
References: <4EB9C272.2010607@iki.fi>
In-Reply-To: <4EB9C272.2010607@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/11/11 23:59, Antti Palosaari wrote:
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
> drivers/media/common/tuners/tda18218.c | 69 +++++---------------------
> drivers/media/common/tuners/tda18218_priv.h | 3 +
> 2 files changed, 17 insertions(+), 55 deletions(-)
>
> diff --git a/drivers/media/common/tuners/tda18218.c
> b/drivers/media/common/tuners/tda18218.c
> index aacfe23..fef5560f 100644
> --- a/drivers/media/common/tuners/tda18218.c
> +++ b/drivers/media/common/tuners/tda18218.c
> @@ -25,46 +25,6 @@ static int debug;
> module_param(debug, int, 0644);
> MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
>
> -/* write multiple registers */
> -static int tda18218_wr_regs(struct tda18218_priv *priv, u8 reg, u8
> *val, u8 len)
> -{
> - int ret = 0;
> - u8 buf[1+len], quotient, remainder, i, msg_len, msg_len_max;
> - struct i2c_msg msg[1] = {
> - {
> - .addr = priv->cfg->i2c_address,
> - .flags = 0,
> - .buf = buf,
> - }
> - };
> -
> - msg_len_max = priv->cfg->i2c_wr_max - 1;
> - quotient = len / msg_len_max;
> - remainder = len % msg_len_max;
> - msg_len = msg_len_max;
> - for (i = 0; (i <= quotient && remainder); i++) {
> - if (i == quotient) /* set len of the last msg */
> - msg_len = remainder;
> -
> - msg[0].len = msg_len + 1;
> - buf[0] = reg + i * msg_len_max;
> - memcpy(&buf[1], &val[i * msg_len_max], msg_len);
> -
> - ret = i2c_transfer(priv->i2c, msg, 1);
> - if (ret != 1)
> - break;
> - }

The only thing I am not sure is whether devices such as af9013 are 
keeping their gate control continuously open through the write 
operations and not timing out.

This applies to tda18218, mxl5005s and other tuners, which have 
multipliable writes with no gate control between the writes, only at the 
start and end of the sequence.

Afatech seem to imply that full gate control is required on all I2C 
read/write operations.

With other devices such as stv0288 do close their gate after a stop 
condition.

Regards


Malcolm
