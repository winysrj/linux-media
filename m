Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756745Ab2CTADh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 20:03:37 -0400
Message-ID: <4F67C953.3040109@redhat.com>
Date: Mon, 19 Mar 2012 21:03:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: linuxtv@stefanringel.de
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 03/22] mt2063: add hybrid
References: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de> <1329256066-8844-3-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1329256066-8844-3-git-send-email-linuxtv@stefanringel.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-02-2012 19:47, linuxtv@stefanringel.de escreveu:
> From: Stefan Ringel <linuxtv@stefanringel.de>
> 
> Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>

Patch is broken:

drivers/media/common/tuners/mt2063.c:365:1: error: expected identifier or ‘(’ before ‘{’ token
drivers/media/common/tuners/mt2063.c:367:4: error: expected identifier or ‘(’ before ‘else’
drivers/media/common/tuners/mt2063.c:369:1: error: expected identifier or ‘(’ before ‘}’ token
drivers/media/common/tuners/mt2063.c:371:1: error: expected identifier or ‘(’ before ‘{’ token
drivers/media/common/tuners/mt2063.c:287:12: warning: ‘mt2063_setreg’ defined but not used [-Wunused-function]
drivers/media/common/tuners/mt2063.c:308:12: warning: ‘mt2063_read’ defined but not used [-Wunused-function]
drivers/media/common/tuners/mt2063.c:355:12: warning: ‘MT2063_Sleep’ defined but not used [-Wunused-function]


> ---
>  drivers/media/common/tuners/mt2063.c |   57 +++++++++++++++++++++++-----------
>  1 files changed, 39 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
> index 9f3a546..d5a9dd9 100644
> --- a/drivers/media/common/tuners/mt2063.c
> +++ b/drivers/media/common/tuners/mt2063.c
> @@ -32,6 +32,8 @@ static unsigned int debug;
>  module_param(debug, int, 0644);
>  MODULE_PARM_DESC(debug, "Set debug level");
>  
> +static DEFINE_MUTEX(mt2063_list_mutex);
> +static LIST_HEAD(hybrid_tuner_instance_list);
>  
>  /* debug level
>   * 0 don't debug
> @@ -2247,29 +2249,48 @@ static struct dvb_tuner_ops mt2063_ops = {
>  };
>  
>  struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
> -				   struct mt2063_config *config,
> -				   struct i2c_adapter *i2c)
> +                   struct mt2063_config *config,
> +                   struct i2c_adapter *i2c)
>  {
>  	struct mt2063_state *state = NULL;
> +	int instance, ret;
> +
> +	dprintk(1, "\n");
> +
> +	mutex_lock(&mt2063_list_mutex);
> +
> +	instance = hybrid_tuner_request_state(struct mt2063_state, state,
> +                                          hybrid_tuner_instance_list,
> +                                          i2c, config->tuner_address,
> +                                          "mt2063");
> +
> +	switch(instance) {
> +	case 0:
> +		goto fail;
> +	case 1:
> +		/* new instance */
> +		state->i2c = i2c;
> +		state->i2c_addr = config->tuner_address;
> +		/* find chip */
> +		mutex_init(&state->lock);
> +		state->frontend = fe;
> +		if (ret < 0)
> +			goto fail;
> +		fe->tuner_priv = state;
> +		fe->ops.tuner_ops = mt2063_ops;
> +		break;
> +	default:
> +		fe->tuner_priv = state;
> +		fe->ops.tuner_ops = mt2063_ops;
> +		break;
> +	}
> +	mutex_unlock(&mt2063_list_mutex);
>  
> -	dprintk(2, "\n");
> -
> -	state = kzalloc(sizeof(struct mt2063_state), GFP_KERNEL);
> -	if (state == NULL)
> -		goto error;
> -
> -	state->config = config;
> -	state->i2c = i2c;
> -	state->frontend = fe;
> -	state->reference = config->refclock / 1000;	/* kHz */
> -	fe->tuner_priv = state;
> -	fe->ops.tuner_ops = mt2063_ops;
> -
> -	printk(KERN_INFO "%s: Attaching MT2063\n", __func__);
>  	return fe;
>  
> -error:
> -	kfree(state);
> +fail:
> +	hybrid_tuner_release_state(state);
> +	mutex_unlock(&mt2063_list_mutex);
>  	return NULL;
>  }
>  EXPORT_SYMBOL_GPL(mt2063_attach);

