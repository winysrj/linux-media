Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38449 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbbEGUtq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 May 2015 16:49:46 -0400
Message-ID: <554BCFE8.6020200@iki.fi>
Date: Thu, 07 May 2015 23:49:44 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 5/6] si2168: add I2C error handling
References: <1430658023-17579-1-git-send-email-olli.salonen@iki.fi> <1430658023-17579-3-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1430658023-17579-3-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!
I didn't make any tests, but I could guess that error flag is set by 
firmware when some unsupported / invalid parameter is given as a 
firmware command request.

Anyhow, I am not sure which is proper error code to return. Could you 
please study, check from API docs and so, which are suitable error 
codes. EINVAL sounds proper code, but imho it is not good as generally 
it is returned by driver when invalid parameters are requested and I 
would like to see some other code to make difference (between driver and 
firmware error).

regards
Antti


On 05/03/2015 04:00 PM, Olli Salonen wrote:
> Return error from si2168_cmd_execute in case the demodulator returns an
> error.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>   drivers/media/dvb-frontends/si2168.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 29a5936..b68ab34 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -60,6 +60,12 @@ static int si2168_cmd_execute(struct i2c_client *client, struct si2168_cmd *cmd)
>   				jiffies_to_msecs(jiffies) -
>   				(jiffies_to_msecs(timeout) - TIMEOUT));
>
> +		/* error bit set? */
> +		if ((cmd->args[0] >> 6) & 0x01) {
> +			ret = -EREMOTEIO;
> +			goto err_mutex_unlock;
> +		}
> +
>   		if (!((cmd->args[0] >> 7) & 0x01)) {
>   			ret = -ETIMEDOUT;
>   			goto err_mutex_unlock;
>

-- 
http://palosaari.fi/
