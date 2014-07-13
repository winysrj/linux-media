Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35133 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbaGMROv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jul 2014 13:14:51 -0400
Message-ID: <53C2BE89.90207@iki.fi>
Date: Sun, 13 Jul 2014 20:14:49 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/6] si2157: Move chip initialization to si2157_init
References: <1405259542-32529-1-git-send-email-olli.salonen@iki.fi> <1405259542-32529-4-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1405259542-32529-4-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Applied!
http://git.linuxtv.org/cgit.cgi/anttip/media_tree.git/log/?h=silabs

Antti


On 07/13/2014 04:52 PM, Olli Salonen wrote:
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>   drivers/media/tuners/si2157.c | 71 ++++++++++++++++++-------------------------
>   1 file changed, 30 insertions(+), 41 deletions(-)
>
> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
> index a4908ee..a92570f9 100644
> --- a/drivers/media/tuners/si2157.c
> +++ b/drivers/media/tuners/si2157.c
> @@ -80,12 +80,41 @@ err:
>   static int si2157_init(struct dvb_frontend *fe)
>   {
>   	struct si2157 *s = fe->tuner_priv;
> +	int ret;
> +	struct si2157_cmd cmd;
>
>   	dev_dbg(&s->client->dev, "%s:\n", __func__);
>
> +	/* configure? */
> +	memcpy(cmd.args, "\xc0\x00\x0c\x00\x00\x01\x01\x01\x01\x01\x01\x02\x00\x00\x01", 15);
> +	cmd.wlen = 15;
> +	cmd.rlen = 1;
> +	ret = si2157_cmd_execute(s, &cmd);
> +	if (ret)
> +		goto err;
> +
> +	/* query chip revision */
> +	memcpy(cmd.args, "\x02", 1);
> +	cmd.wlen = 1;
> +	cmd.rlen = 13;
> +	ret = si2157_cmd_execute(s, &cmd);
> +	if (ret)
> +		goto err;
> +
> +	/* reboot the tuner with new firmware? */
> +	memcpy(cmd.args, "\x01\x01", 2);
> +	cmd.wlen = 2;
> +	cmd.rlen = 1;
> +	ret = si2157_cmd_execute(s, &cmd);
> +	if (ret)
> +		goto err;
> +
>   	s->active = true;
>
>   	return 0;
> +err:
> +	dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
> +	return ret;
>   }
>
>   static int si2157_sleep(struct dvb_frontend *fe)
> @@ -128,48 +157,8 @@ static int si2157_set_params(struct dvb_frontend *fe)
>   		goto err;
>   	}
>
> -	/* configure? */
> -	cmd.args[0] = 0xc0;
> -	cmd.args[1] = 0x00;
> -	cmd.args[2] = 0x0c;
> -	cmd.args[3] = 0x00;
> -	cmd.args[4] = 0x00;
> -	cmd.args[5] = 0x01;
> -	cmd.args[6] = 0x01;
> -	cmd.args[7] = 0x01;
> -	cmd.args[8] = 0x01;
> -	cmd.args[9] = 0x01;
> -	cmd.args[10] = 0x01;
> -	cmd.args[11] = 0x02;
> -	cmd.args[12] = 0x00;
> -	cmd.args[13] = 0x00;
> -	cmd.args[14] = 0x01;
> -	cmd.wlen = 15;
> -	cmd.rlen = 1;
> -	ret = si2157_cmd_execute(s, &cmd);
> -	if (ret)
> -		goto err;
> -
> -	cmd.args[0] = 0x02;
> -	cmd.wlen = 1;
> -	cmd.rlen = 13;
> -	ret = si2157_cmd_execute(s, &cmd);
> -	if (ret)
> -		goto err;
> -
> -	cmd.args[0] = 0x01;
> -	cmd.args[1] = 0x01;
> -	cmd.wlen = 2;
> -	cmd.rlen = 1;
> -	ret = si2157_cmd_execute(s, &cmd);
> -	if (ret)
> -		goto err;
> -
>   	/* set frequency */
> -	cmd.args[0] = 0x41;
> -	cmd.args[1] = 0x00;
> -	cmd.args[2] = 0x00;
> -	cmd.args[3] = 0x00;
> +	memcpy(cmd.args, "\x41\x00\x00\x00\x00\x00\x00\x00", 8);
>   	cmd.args[4] = (c->frequency >>  0) & 0xff;
>   	cmd.args[5] = (c->frequency >>  8) & 0xff;
>   	cmd.args[6] = (c->frequency >> 16) & 0xff;
>

-- 
http://palosaari.fi/
