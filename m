Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58713 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab3BCWr7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Feb 2013 17:47:59 -0500
Message-ID: <510EE8F7.1070801@iki.fi>
Date: Mon, 04 Feb 2013 00:47:19 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: Michael Krufky <mkrufky@linuxtv.org>,
	Gianluca Gennari <gennarone@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATH 1/2] mxl5007 move reset to attach
References: <2289340.7RydykYGjZ@jar7.dominio>
In-Reply-To: <2289340.7RydykYGjZ@jar7.dominio>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/04/2013 12:30 AM, Jose Alberto Reguero wrote:
> This patch move the soft reset to the attach function because with dual
> tuners, when one tuner do reset, the other one is perturbed, and the
> stream has errors.
>
> Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

Looks good for my eyes!

Reviewed-by: Antti Palosaari <crope@iki.fi>

>
> diff -upr linux/drivers/media/tuners/mxl5007t.c linux.new/drivers/media/tuners/mxl5007t.c
> --- linux/drivers/media/tuners/mxl5007t.c	2012-08-14 05:45:22.000000000 +0200
> +++ linux.new/drivers/media/tuners/mxl5007t.c	2013-02-03 23:03:03.784525410 +0100
> @@ -531,10 +531,6 @@ static int mxl5007t_tuner_init(struct mx
>   	struct reg_pair_t *init_regs;
>   	int ret;
>
> -	ret = mxl5007t_soft_reset(state);
> -	if (mxl_fail(ret))
> -		goto fail;
> -
>   	/* calculate initialization reg array */
>   	init_regs = mxl5007t_calc_init_regs(state, mode);
>
> @@ -900,7 +896,20 @@ struct dvb_frontend *mxl5007t_attach(str
>   		/* existing tuner instance */
>   		break;
>   	}
> +
> +	if (fe->ops.i2c_gate_ctrl)
> +		fe->ops.i2c_gate_ctrl(fe, 1);
> +
> +	ret = mxl5007t_soft_reset(state);
> +
> +	if (fe->ops.i2c_gate_ctrl)
> +		fe->ops.i2c_gate_ctrl(fe, 0);
> +
> +	if (mxl_fail(ret))
> +		goto fail;
> +
>   	fe->tuner_priv = state;
> +
>   	mutex_unlock(&mxl5007t_list_mutex);
>
>   	memcpy(&fe->ops.tuner_ops, &mxl5007t_tuner_ops,
>


-- 
http://palosaari.fi/
