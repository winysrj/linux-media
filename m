Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38142 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbbAQM56 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2015 07:57:58 -0500
Message-ID: <54BA5C53.2000306@iki.fi>
Date: Sat, 17 Jan 2015 14:57:55 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCHv2] si2168: return error if set_frontend is called with
 invalid parameters
References: <1421433398-1541-1-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1421433398-1541-1-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/16/2015 08:36 PM, Olli Salonen wrote:
> This patch is based on Antti's silabs branch.
>
> According to dvb-frontend.h set_frontend may be called with bandwidth_hz set to
> 0 if automatic bandwidth is required. Si2168 does not support automatic
> bandwidth and does not declare FE_CAN_BANDWIDTH_AUTO in caps.
>
> This patch will change the behaviour in a way that EINVAL is returned if
> bandwidth_hz is 0.
>
> v2: remove error message, remove line break to comply with coding style.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>

Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti


> ---
>   drivers/media/dvb-frontends/si2168.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 7f966f3..85acc54 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -180,7 +180,10 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
>   		goto err;
>   	}
>
> -	if (c->bandwidth_hz <= 5000000)
> +	if (c->bandwidth_hz == 0) {
> +		ret = -EINVAL;
> +		goto err;
> +	} else if (c->bandwidth_hz <= 5000000)
>   		bandwidth = 0x05;
>   	else if (c->bandwidth_hz <= 6000000)
>   		bandwidth = 0x06;
>

-- 
http://palosaari.fi/
