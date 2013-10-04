Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38838 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab3JDOwP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Oct 2013 10:52:15 -0400
Message-ID: <524ED61C.8040709@iki.fi>
Date: Fri, 04 Oct 2013 17:52:12 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Luis Alves <ljalvs@gmail.com>, linux-media@vger.kernel.org
CC: mkrufky@linuxtv.org, mchehab@infradead.org
Subject: Re: [PATCH] cx24117: Prevent mutex to be stuck on locked state if
 FE init fails.
References: <1380898115-30071-1-git-send-email-ljalvs@gmail.com>
In-Reply-To: <1380898115-30071-1-git-send-email-ljalvs@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04.10.2013 17:48, Luis Alves wrote:
> Hi,
> This patch will fix the situation where the mutex was left in a locked state if for some reason the FE init failed.
>
> Regards,
> Luis
>
>
> Signed-off-by: Luis Alves <ljalvs@gmail.com>

Reviewed-by: Antti Palosaari <crope@iki.fi>


> ---
>   drivers/media/dvb-frontends/cx24117.c |    9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/cx24117.c b/drivers/media/dvb-frontends/cx24117.c
> index 9087309..476b422 100644
> --- a/drivers/media/dvb-frontends/cx24117.c
> +++ b/drivers/media/dvb-frontends/cx24117.c
> @@ -1238,11 +1238,11 @@ static int cx24117_initfe(struct dvb_frontend *fe)
>   	cmd.len = 3;
>   	ret = cx24117_cmd_execute_nolock(fe, &cmd);
>   	if (ret != 0)
> -		return ret;
> +		goto exit;
>
>   	ret = cx24117_diseqc_init(fe);
>   	if (ret != 0)
> -		return ret;
> +		goto exit;
>
>   	/* CMD 3C */
>   	cmd.args[0] = 0x3c;
> @@ -1252,7 +1252,7 @@ static int cx24117_initfe(struct dvb_frontend *fe)
>   	cmd.len = 4;
>   	ret = cx24117_cmd_execute_nolock(fe, &cmd);
>   	if (ret != 0)
> -		return ret;
> +		goto exit;
>
>   	/* CMD 34 */
>   	cmd.args[0] = 0x34;
> @@ -1260,9 +1260,8 @@ static int cx24117_initfe(struct dvb_frontend *fe)
>   	cmd.args[2] = CX24117_OCC;
>   	cmd.len = 3;
>   	ret = cx24117_cmd_execute_nolock(fe, &cmd);
> -	if (ret != 0)
> -		return ret;
>
> +exit:
>   	mutex_unlock(&state->priv->fe_lock);
>
>   	return ret;
>


-- 
http://palosaari.fi/
