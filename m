Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51088 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757378AbaGSCZK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 22:25:10 -0400
Message-ID: <53C9D704.8080404@iki.fi>
Date: Sat, 19 Jul 2014 05:25:08 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] si2157: Add support for spectral inversion
References: <53C58067.8000601@gentoo.org> <1405452876-8543-3-git-send-email-zzam@gentoo.org>
In-Reply-To: <1405452876-8543-3-git-send-email-zzam@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch applied.

http://git.linuxtv.org/cgit.cgi/anttip/media_tree.git/log/?h=silabs

However, it is usually demod which fixes inverted IF. There was only one 
other tuner driver having IF spectrum inversion, Mxl5007t.

Logically looking signal goes from tuner to demod and when it goes out 
from tuner it is correct, but when it arrives to demod input it is 
inverted (on case IF wiring is cross-connected). So it even logically 
belongs to demod, IMHO.

regards
Antti



On 07/15/2014 10:34 PM, Matthias Schwarzott wrote:
> This is needed for PCTV 522e support.
>
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> ---
>   drivers/media/tuners/si2157.c      | 3 +++
>   drivers/media/tuners/si2157.h      | 5 +++++
>   drivers/media/tuners/si2157_priv.h | 1 +
>   3 files changed, 9 insertions(+)
>
> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
> index 91808e8..06153fa 100644
> --- a/drivers/media/tuners/si2157.c
> +++ b/drivers/media/tuners/si2157.c
> @@ -253,6 +253,8 @@ static int si2157_set_params(struct dvb_frontend *fe)
>
>   	memcpy(cmd.args, "\x14\x00\x03\x07\x00\x00", 6);
>   	cmd.args[4] = delivery_system | bandwidth;
> +	if (s->inversion)
> +		cmd.args[5] = 0x01;
>   	cmd.wlen = 6;
>   	cmd.rlen = 1;
>   	ret = si2157_cmd_execute(s, &cmd);
> @@ -314,6 +316,7 @@ static int si2157_probe(struct i2c_client *client,
>
>   	s->client = client;
>   	s->fe = cfg->fe;
> +	s->inversion = cfg->inversion;
>   	mutex_init(&s->i2c_mutex);
>
>   	/* check if the tuner is there */
> diff --git a/drivers/media/tuners/si2157.h b/drivers/media/tuners/si2157.h
> index 4465c46..6da4d5d 100644
> --- a/drivers/media/tuners/si2157.h
> +++ b/drivers/media/tuners/si2157.h
> @@ -29,6 +29,11 @@ struct si2157_config {
>   	 * frontend
>   	 */
>   	struct dvb_frontend *fe;
> +
> +	/*
> +	 * Spectral Inversion
> +	 */
> +	bool inversion;
>   };
>
>   #endif
> diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
> index db79f3c..3ddab5e 100644
> --- a/drivers/media/tuners/si2157_priv.h
> +++ b/drivers/media/tuners/si2157_priv.h
> @@ -26,6 +26,7 @@ struct si2157 {
>   	struct i2c_client *client;
>   	struct dvb_frontend *fe;
>   	bool active;
> +	bool inversion;
>   };
>
>   /* firmare command struct */
>

-- 
http://palosaari.fi/
