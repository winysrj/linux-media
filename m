Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34461 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbbAPOW4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 09:22:56 -0500
Message-ID: <54B91EBE.1090206@iki.fi>
Date: Fri, 16 Jan 2015 16:22:54 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] si2168: return error if set_frontend is called with
 invalid parameters
References: <1421411720-2364-1-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1421411720-2364-1-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/16/2015 02:35 PM, Olli Salonen wrote:
> This patch should is based on Antti's silabs branch.
>
> According to dvb-frontend.h set_frontend may be called with bandwidth_hz set to 0 if automatic bandwidth is required. Si2168 does not support automatic bandwidth and does not declare FE_CAN_BANDWIDTH_AUTO in caps.
>
> This patch will change the behaviour in a way that EINVAL is returned if bandwidth_hz is 0.
>
> Cc-to: Antti Palosaari <crope@iki.fi>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>

Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti


> ---
>   drivers/media/dvb-frontends/si2168.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 7f966f3..7fef5ab 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -180,7 +180,12 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
>   		goto err;
>   	}
>
> -	if (c->bandwidth_hz <= 5000000)
> +	if (c->bandwidth_hz == 0) {
> +		ret = -EINVAL;
> +		dev_err(&client->dev, "automatic bandwidth not supported");
> +		goto err;
> +	}
> +	else if (c->bandwidth_hz <= 5000000)
>   		bandwidth = 0x05;
>   	else if (c->bandwidth_hz <= 6000000)
>   		bandwidth = 0x06;
>

-- 
http://palosaari.fi/
