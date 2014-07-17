Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45755 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbaGQVcI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 17:32:08 -0400
Message-ID: <53C840D6.8040208@iki.fi>
Date: Fri, 18 Jul 2014 00:32:06 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Luis Alves <ljalvs@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] si2168: Set symbol_rate in set_frontend for DVB-C
 delivery system.
References: <1405618288-28317-1-git-send-email-ljalvs@gmail.com>
In-Reply-To: <1405618288-28317-1-git-send-email-ljalvs@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks sane, I will apply that.

regards
Antti

On 07/17/2014 08:31 PM, Luis Alves wrote:
> This patch adds symbol rate setting to the driver.
>
> Signed-off-by: Luis Alves <ljalvs@gmail.com>
> ---
>   drivers/media/dvb-frontends/si2168.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 0422925..7980741 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -278,6 +278,18 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
>   	if (ret)
>   		goto err;
>
> +	/* set DVB-C symbol rate */
> +	if (c->delivery_system == SYS_DVBC_ANNEX_A) {
> +		memcpy(cmd.args, "\x14\x00\x02\x11", 4);
> +		cmd.args[4] = (c->symbol_rate / 1000) & 0xff;
> +		cmd.args[5] = ((c->symbol_rate / 1000) >> 8) & 0xff;
> +		cmd.wlen = 6;
> +		cmd.rlen = 4;
> +		ret = si2168_cmd_execute(s, &cmd);
> +		if (ret)
> +			goto err;
> +	}
> +
>   	memcpy(cmd.args, "\x14\x00\x0f\x10\x10\x00", 6);
>   	cmd.wlen = 6;
>   	cmd.rlen = 4;
>

-- 
http://palosaari.fi/
