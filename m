Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58290 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab3JDOkx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Oct 2013 10:40:53 -0400
Message-ID: <524ED372.2080504@iki.fi>
Date: Fri, 04 Oct 2013 17:40:50 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
CC: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 07/14] drxk_hard: fix sparse warnings
References: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl> <1380895312-30863-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1380895312-30863-8-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04.10.2013 17:01, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> drivers/media/dvb-frontends/drxk_hard.c:1086:62: warning: Using plain integer as NULL pointer
> drivers/media/dvb-frontends/drxk_hard.c:2784:63: warning: Using plain integer as NULL pointer
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Antti Palosaari <crope@iki.fi>


> Cc: Antti Palosaari <crope@iki.fi>
> ---
>   drivers/media/dvb-frontends/drxk_hard.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
> index 082014d..d416c15 100644
> --- a/drivers/media/dvb-frontends/drxk_hard.c
> +++ b/drivers/media/dvb-frontends/drxk_hard.c
> @@ -1083,7 +1083,7 @@ static int hi_cfg_command(struct drxk_state *state)
>   			 SIO_HI_RA_RAM_PAR_1_PAR1_SEC_KEY);
>   	if (status < 0)
>   		goto error;
> -	status = hi_command(state, SIO_HI_RA_RAM_CMD_CONFIG, 0);
> +	status = hi_command(state, SIO_HI_RA_RAM_CMD_CONFIG, NULL);
>   	if (status < 0)
>   		goto error;
>
> @@ -2781,7 +2781,7 @@ static int ConfigureI2CBridge(struct drxk_state *state, bool b_enable_bridge)
>   			goto error;
>   	}
>
> -	status = hi_command(state, SIO_HI_RA_RAM_CMD_BRDCTRL, 0);
> +	status = hi_command(state, SIO_HI_RA_RAM_CMD_BRDCTRL, NULL);
>
>   error:
>   	if (status < 0)
>


-- 
http://palosaari.fi/
