Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38505 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaJAT6B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Oct 2014 15:58:01 -0400
Message-ID: <542C5CC7.9050000@iki.fi>
Date: Wed, 01 Oct 2014 22:57:59 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/5] sp2: improve debug logging
References: <1411976660-19329-1-git-send-email-olli.salonen@iki.fi> <1411976660-19329-3-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1411976660-19329-3-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti

On 09/29/2014 10:44 AM, Olli Salonen wrote:
> Improve debugging output.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>   drivers/media/dvb-frontends/sp2.c | 19 +++++++++++--------
>   1 file changed, 11 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/sp2.c b/drivers/media/dvb-frontends/sp2.c
> index 1f4f250..320cbe9 100644
> --- a/drivers/media/dvb-frontends/sp2.c
> +++ b/drivers/media/dvb-frontends/sp2.c
> @@ -92,6 +92,9 @@ static int sp2_write_i2c(struct sp2 *s, u8 reg, u8 *buf, int len)
>   			return -EIO;
>   	}
>
> +	dev_dbg(&s->client->dev, "addr=0x%04x, reg = 0x%02x, data = %*ph\n",
> +				client->addr, reg, len, buf);
> +
>   	return 0;
>   }
>
> @@ -103,9 +106,6 @@ static int sp2_ci_op_cam(struct dvb_ca_en50221 *en50221, int slot, u8 acs,
>   	int mem, ret;
>   	int (*ci_op_cam)(void*, u8, int, u8, int*) = s->ci_control;
>
> -	dev_dbg(&s->client->dev, "slot=%d, acs=0x%02x, addr=0x%04x, data = 0x%02x",
> -			slot, acs, addr, data);
> -
>   	if (slot != 0)
>   		return -EINVAL;
>
> @@ -140,13 +140,16 @@ static int sp2_ci_op_cam(struct dvb_ca_en50221 *en50221, int slot, u8 acs,
>   	if (ret)
>   		return ret;
>
> -	if (read) {
> -		dev_dbg(&s->client->dev, "cam read, addr=0x%04x, data = 0x%04x",
> -				addr, mem);
> +	dev_dbg(&s->client->dev, "%s: slot=%d, addr=0x%04x, %s, data=%x",
> +			(read) ? "read" : "write", slot, addr,
> +			(acs == SP2_CI_ATTR_ACS) ? "attr" : "io",
> +			(read) ? mem : data);
> +
> +	if (read)
>   		return mem;
> -	} else {
> +	else
>   		return 0;
> -	}
> +
>   }
>
>   int sp2_ci_read_attribute_mem(struct dvb_ca_en50221 *en50221,
>

-- 
http://palosaari.fi/
