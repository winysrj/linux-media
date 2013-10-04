Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60943 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980Ab3JDOoI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Oct 2013 10:44:08 -0400
Message-ID: <524ED436.6030001@iki.fi>
Date: Fri, 04 Oct 2013 17:44:06 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
CC: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 06/14] drxd_hard: fix sparse warnings
References: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl> <1380895312-30863-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1380895312-30863-7-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04.10.2013 17:01, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> drivers/media/dvb-frontends/drxd_hard.c:1017:70: warning: Using plain integer as NULL pointer
> drivers/media/dvb-frontends/drxd_hard.c:1038:69: warning: Using plain integer as NULL pointer
> drivers/media/dvb-frontends/drxd_hard.c:2836:33: warning: Using plain integer as NULL pointer
> drivers/media/dvb-frontends/drxd_hard.c:2972:30: warning: Using plain integer as NULL pointer
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Antti Palosaari <crope@iki.fi>


> Cc: Antti Palosaari <crope@iki.fi>
> ---
>   drivers/media/dvb-frontends/drxd_hard.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
> index cbd7c92..959ae36 100644
> --- a/drivers/media/dvb-frontends/drxd_hard.c
> +++ b/drivers/media/dvb-frontends/drxd_hard.c
> @@ -1014,7 +1014,7 @@ static int HI_CfgCommand(struct drxd_state *state)
>   		status = Write16(state, HI_RA_RAM_SRV_CMD__A,
>   				 HI_RA_RAM_SRV_CMD_CONFIG, 0);
>   	else
> -		status = HI_Command(state, HI_RA_RAM_SRV_CMD_CONFIG, 0);
> +		status = HI_Command(state, HI_RA_RAM_SRV_CMD_CONFIG, NULL);
>   	mutex_unlock(&state->mutex);
>   	return status;
>   }
> @@ -1035,7 +1035,7 @@ static int HI_ResetCommand(struct drxd_state *state)
>   	status = Write16(state, HI_RA_RAM_SRV_RST_KEY__A,
>   			 HI_RA_RAM_SRV_RST_KEY_ACT, 0);
>   	if (status == 0)
> -		status = HI_Command(state, HI_RA_RAM_SRV_CMD_RESET, 0);
> +		status = HI_Command(state, HI_RA_RAM_SRV_CMD_RESET, NULL);
>   	mutex_unlock(&state->mutex);
>   	msleep(1);
>   	return status;
> @@ -2833,7 +2833,7 @@ static int drxd_init(struct dvb_frontend *fe)
>   	int err = 0;
>
>   /*	if (request_firmware(&state->fw, "drxd.fw", state->dev)<0) */
> -	return DRXD_init(state, 0, 0);
> +	return DRXD_init(state, NULL, 0);
>
>   	err = DRXD_init(state, state->fw->data, state->fw->size);
>   	release_firmware(state->fw);
> @@ -2969,7 +2969,7 @@ struct dvb_frontend *drxd_attach(const struct drxd_config *config,
>
>   	mutex_init(&state->mutex);
>
> -	if (Read16(state, 0, 0, 0) < 0)
> +	if (Read16(state, 0, NULL, 0) < 0)
>   		goto error;
>
>   	state->frontend.ops = drxd_ops;
>


-- 
http://palosaari.fi/
