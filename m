Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42783 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab1KLQjk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 11:39:40 -0500
Message-ID: <4EBEA14B.6070504@iki.fi>
Date: Sat, 12 Nov 2011 18:39:39 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 6/7] af9013 Stop OFSM while channel changing.
References: <4ebe9717.5b6be30a.26ea.ffff9ad7@mx.google.com>
In-Reply-To: <4ebe9717.5b6be30a.26ea.ffff9ad7@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/2011 05:56 PM, Malcolm Priestley wrote:
> To minimise corruptions on channel change.
>
> Signed-off-by: Malcolm Priestley<tvboxspy@gmail.com>
> ---
>   drivers/media/dvb/frontends/af9013.c |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/dvb/frontends/af9013.c b/drivers/media/dvb/frontends/af9013.c
> index 38a6ea2..6a5b40c 100644
> --- a/drivers/media/dvb/frontends/af9013.c
> +++ b/drivers/media/dvb/frontends/af9013.c
> @@ -629,6 +629,10 @@ static int af9013_set_frontend(struct dvb_frontend *fe,
>   		params->u.ofdm.bandwidth);
>
>   	state->frequency = params->frequency;
> +	/* Stop OFSM */
> +	ret = af9013_write_reg(state, 0xffff, 1);
> +	if (ret)
> +		goto error;
>
>   	/* program tuner */
>   	if (mutex_lock_interruptible(state->fe_mutex)<  0)

That seems to be simple.

That means there is no corruptions for the other frontend after that? It 
sounds rather weird that setting one registers to other demod helps the 
other demod. Generally programming one demod should not be any effect to 
other demods having the same board.

Or do you mean it block corruptions on demod in question?
Corruptions in channel change sounds something like normal.

regards
Antti


-- 
http://palosaari.fi/
