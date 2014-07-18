Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56194 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761928AbaGRPZO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 11:25:14 -0400
Message-ID: <53C93C58.80000@iki.fi>
Date: Fri, 18 Jul 2014 18:25:12 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org,
	Luis Alves <ljalvs@gmail.com>
Subject: Re: [PATCH] si2157: Use name si2157_ops instead of si2157_tuner_ops
 (harmonize with si2168)
References: <1405662072-26808-1-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1405662072-26808-1-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I will apply that, thanks!

Could you and also Luis pay attention to commit message in future 
patches. I have had practically fixed almost every commit message from 
your patches. Long one liner just like this one is not correct. It 
should be short subject line and then explained more in the commit 
message body. I tend ask myself questions "why" and "how" and then write 
commit message based answers of those questions.

regards
Antti

On 07/18/2014 08:41 AM, Olli Salonen wrote:
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>   drivers/media/tuners/si2157.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
> index 329004f..4730f69 100644
> --- a/drivers/media/tuners/si2157.c
> +++ b/drivers/media/tuners/si2157.c
> @@ -277,7 +277,7 @@ err:
>   	return ret;
>   }
>
> -static const struct dvb_tuner_ops si2157_tuner_ops = {
> +static const struct dvb_tuner_ops si2157_ops = {
>   	.info = {
>   		.name           = "Silicon Labs Si2157/Si2158",
>   		.frequency_min  = 110000000,
> @@ -317,7 +317,7 @@ static int si2157_probe(struct i2c_client *client,
>   		goto err;
>
>   	fe->tuner_priv = s;
> -	memcpy(&fe->ops.tuner_ops, &si2157_tuner_ops,
> +	memcpy(&fe->ops.tuner_ops, &si2157_ops,
>   			sizeof(struct dvb_tuner_ops));
>
>   	i2c_set_clientdata(client, s);
>

-- 
http://palosaari.fi/
