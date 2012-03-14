Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37392 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759794Ab2CNVUv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 17:20:51 -0400
Received: by wejx9 with SMTP id x9so2180986wej.19
        for <linux-media@vger.kernel.org>; Wed, 14 Mar 2012 14:20:50 -0700 (PDT)
Message-ID: <1331759693.5713.12.camel@tvbox>
Subject: Re: [PATCH 2/2 FOR 3.4] af9015: fix i2c failures for dual-tuner
 devices - part 2
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Date: Wed, 14 Mar 2012 21:14:53 +0000
In-Reply-To: <1331735251-15393-2-git-send-email-crope@iki.fi>
References: <1331735251-15393-1-git-send-email-crope@iki.fi>
	 <1331735251-15393-2-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2012-03-14 at 16:27 +0200, Antti Palosaari wrote:
> Some changes for previous patch I liked to do.
> Just move tuner init and sleep to own functions from the demod
> init and sleep functions.  Functionality remains still almost the same.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/dvb/dvb-usb/af9015.c |   74 ++++++++++++++++++++++-------------
>  drivers/media/dvb/dvb-usb/af9015.h |    4 +-
>  2 files changed, 48 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
> index 9307b4ca..7e70ea5 100644
> --- a/drivers/media/dvb/dvb-usb/af9015.c
> +++ b/drivers/media/dvb/dvb-usb/af9015.c
> @@ -1141,18 +1141,7 @@ static int af9015_af9013_init(struct dvb_frontend *fe)
>  		return -EAGAIN;
>  
>  	ret = priv->init[adap->id](fe);
> -	if (ret)
> -		goto err_unlock;
> -
> -	if (priv->tuner_ops_init[adap->id]) {
> -		if (fe->ops.i2c_gate_ctrl)
> -			fe->ops.i2c_gate_ctrl(fe, 1);
> -		ret = priv->tuner_ops_init[adap->id](fe);
> -		if (fe->ops.i2c_gate_ctrl)
> -			fe->ops.i2c_gate_ctrl(fe, 0);
> -	}
>  
> -err_unlock:
>  	mutex_unlock(&adap->dev->usb_mutex);
>  
>  	return ret;
> @@ -1168,24 +1157,48 @@ static int af9015_af9013_sleep(struct dvb_frontend *fe)
>  	if (mutex_lock_interruptible(&adap->dev->usb_mutex))
>  		return -EAGAIN;
>  
> -	if (priv->tuner_ops_sleep[adap->id]) {
> -		if (fe->ops.i2c_gate_ctrl)
> -			fe->ops.i2c_gate_ctrl(fe, 1);
> -		ret = priv->tuner_ops_sleep[adap->id](fe);
> -		if (fe->ops.i2c_gate_ctrl)
> -			fe->ops.i2c_gate_ctrl(fe, 0);
> -		if (ret)
> -			goto err_unlock;
> -	}
> -
>  	ret = priv->sleep[adap->id](fe);
>  
> -err_unlock:
>  	mutex_unlock(&adap->dev->usb_mutex);
>  
>  	return ret;
>  }
>  
> +/* override tuner callbacks for resource locking */
> +static int af9015_tuner_init(struct dvb_frontend *fe)
> +{
> +	int ret;
> +	struct dvb_usb_adapter *adap = fe->dvb->priv;
> +	struct af9015_state *priv = adap->dev->priv;
> +
> +	if (mutex_lock_interruptible(&adap->dev->usb_mutex))
> +		return -EAGAIN;
Hi Antti

I think using mutex_lock_interruptible errors into dvb-usb causes false
errors and errors caused by missed registers.

I prefer to use mutex_lock only return genuine device errors.

Regards


Malcolm



 


> +
> +	ret = priv->tuner_init[adap->id](fe);
> +
> +	mutex_unlock(&adap->dev->usb_mutex);
> +
> +	return ret;
> +}
> +
> +/* override tuner callbacks for resource locking */
> +static int af9015_tuner_sleep(struct dvb_frontend *fe)
> +{
> +	int ret;
> +	struct dvb_usb_adapter *adap = fe->dvb->priv;
> +	struct af9015_state *priv = adap->dev->priv;
> +
> +	if (mutex_lock_interruptible(&adap->dev->usb_mutex))
> +		return -EAGAIN;
> +
> +	ret = priv->tuner_sleep[adap->id](fe);
> +
> +	mutex_unlock(&adap->dev->usb_mutex);
> +
> +	return ret;
> +}
> +
> +
>  static int af9015_af9013_frontend_attach(struct dvb_usb_adapter *adap)
>  {
>  	int ret;
> @@ -1364,13 +1377,18 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
>  			af9015_af9013_config[adap->id].tuner);
>  	}
>  
> -	state->tuner_ops_sleep[adap->id] =
> -				adap->fe_adap[0].fe->ops.tuner_ops.sleep;
> -	adap->fe_adap[0].fe->ops.tuner_ops.sleep = 0;
> +	if (adap->fe_adap[0].fe->ops.tuner_ops.init) {
> +		state->tuner_init[adap->id] =
> +			adap->fe_adap[0].fe->ops.tuner_ops.init;
> +		adap->fe_adap[0].fe->ops.tuner_ops.init = af9015_tuner_init;
> +	}
> +
> +	if (adap->fe_adap[0].fe->ops.tuner_ops.sleep) {
> +		state->tuner_sleep[adap->id] =
> +			adap->fe_adap[0].fe->ops.tuner_ops.sleep;
> +		adap->fe_adap[0].fe->ops.tuner_ops.sleep = af9015_tuner_sleep;
> +	}
>  
> -	state->tuner_ops_init[adap->id] =
> -				adap->fe_adap[0].fe->ops.tuner_ops.init;
> -	adap->fe_adap[0].fe->ops.tuner_ops.init = 0;
>  	return ret;
>  }
>  
> diff --git a/drivers/media/dvb/dvb-usb/af9015.h b/drivers/media/dvb/dvb-usb/af9015.h
> index ee2ec5b..2f68419 100644
> --- a/drivers/media/dvb/dvb-usb/af9015.h
> +++ b/drivers/media/dvb/dvb-usb/af9015.h
> @@ -108,8 +108,8 @@ struct af9015_state {
>  	int (*read_status[2]) (struct dvb_frontend *fe, fe_status_t *status);
>  	int (*init[2]) (struct dvb_frontend *fe);
>  	int (*sleep[2]) (struct dvb_frontend *fe);
> -	int (*tuner_ops_init[2]) (struct dvb_frontend *fe);
> -	int (*tuner_ops_sleep[2]) (struct dvb_frontend *fe);
> +	int (*tuner_init[2]) (struct dvb_frontend *fe);
> +	int (*tuner_sleep[2]) (struct dvb_frontend *fe);
>  };
>  
>  struct af9015_config {


