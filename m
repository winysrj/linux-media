Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:34734 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751995Ab1BOCAj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 21:00:39 -0500
From: Oliver Endriss <o.endriss@gmx.de>
To: Dan Carpenter <error27@gmail.com>
Subject: Re: [patch] [media] stv090x: handle allocation failures
Date: Tue, 15 Feb 2011 03:00:17 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Manu Abraham <manu@linuxtv.org>,
	Andreas Regel <andreas.regel@gmx.de>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20110207165650.GF4384@bicker>
In-Reply-To: <20110207165650.GF4384@bicker>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201102150300.19650@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 07 February 2011 17:56:50 Dan Carpenter wrote:
> kmalloc() can fail so check whether state->internal is NULL.
> append_internal() can return NULL on allocation failures so check that.
> Also if we hit the error condition later in the function then there is
> a memory leak and we need to call remove_dev() to fix it.
> ...

Thanks for the patch. See my comment below.

> --- a/drivers/media/dvb/frontends/stv090x.c
> +++ b/drivers/media/dvb/frontends/stv090x.c
> @@ -4783,7 +4783,13 @@ struct dvb_frontend *stv090x_attach(const struct stv090x_config *config,
>  	} else {
>  		state->internal = kmalloc(sizeof(struct stv090x_internal),
>  					  GFP_KERNEL);
> +		if (!state->internal)
> +			goto error;
>  		temp_int = append_internal(state->internal);
> +		if (!temp_int) {
> +			kfree(state->internal);
> +			goto error;
> +		}
>  		state->internal->num_used = 1;
>  		state->internal->mclk = 0;
>  		state->internal->dev_ver = 0;
> @@ -4796,7 +4802,7 @@ struct dvb_frontend *stv090x_attach(const struct stv090x_config *config,
>  
>  		if (stv090x_setup(&state->frontend) < 0) {
>  			dprintk(FE_ERROR, 1, "Error setting up device");
> -			goto error;
> +			goto err_remove;
>  		}
>  	}
>  
> @@ -4811,6 +4817,8 @@ struct dvb_frontend *stv090x_attach(const struct stv090x_config *config,
>  
>  	return &state->frontend;
>  
> +err_remove:
> +	remove_dev(state->internal);

AFAICS
        kfree(state->internal);
must be added here, as we allocated state->internal, state and temp_int.

>  error:
>  	kfree(state);
>  	return NULL;

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
