Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60600 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730269AbeGZUo0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jul 2018 16:44:26 -0400
Date: Thu, 26 Jul 2018 16:26:07 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Ivan Bornyakov <brnkv.i1@gmail.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: stv090x: fix if-else order
Message-ID: <20180726162607.2de43b84@coco.lan>
In-Reply-To: <20180601161221.24807-1-brnkv.i1@gmail.com>
References: <20180601161221.24807-1-brnkv.i1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri,  1 Jun 2018 19:12:21 +0300
Ivan Bornyakov <brnkv.i1@gmail.com> escreveu:

> There is this code:
> 
> 	if (v >= 0x20) {
> 		...
> 	} else if (v < 0x20) {
> 		...
> 	} else if (v > 0x30) {
> 		/* this branch is impossible */
> 	}
> 
> It would be sensibly for last branch to be on the top.

Have you tested it and check at the datasheets if dev_ver > 0x30 makes
sense?

If not, I would prefer, instead, to remove the dead code, as this
patch may cause regressions (adding a FIXME comment about this
special case).

> 
> Signed-off-by: Ivan Bornyakov <brnkv.i1@gmail.com>
> ---
>  drivers/media/dvb-frontends/stv090x.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
> index 9133f65d4623..d70eb311ebaf 100644
> --- a/drivers/media/dvb-frontends/stv090x.c
> +++ b/drivers/media/dvb-frontends/stv090x.c
> @@ -4841,7 +4841,11 @@ static int stv090x_setup(struct dvb_frontend *fe)
>  	}
>  
>  	state->internal->dev_ver = stv090x_read_reg(state, STV090x_MID);
> -	if (state->internal->dev_ver >= 0x20) {
> +	if (state->internal->dev_ver > 0x30) {
> +		/* we shouldn't bail out from here */
> +		dprintk(FE_ERROR, 1, "INFO: Cut: 0x%02x probably incomplete support!",
> +			state->internal->dev_ver);
> +	} else if (state->internal->dev_ver >= 0x20) {
>  		if (stv090x_write_reg(state, STV090x_TSGENERAL, 0x0c) < 0)
>  			goto err;
>  
> @@ -4857,10 +4861,6 @@ static int stv090x_setup(struct dvb_frontend *fe)
>  			state->internal->dev_ver);
>  
>  		goto err;
> -	} else if (state->internal->dev_ver > 0x30) {
> -		/* we shouldn't bail out from here */
> -		dprintk(FE_ERROR, 1, "INFO: Cut: 0x%02x probably incomplete support!",
> -			state->internal->dev_ver);
>  	}
>  
>  	/* ADC1 range */



Thanks,
Mauro
