Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56041 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab2CGPwF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 10:52:05 -0500
Received: by bkcik5 with SMTP id ik5so5348021bkc.19
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2012 07:52:03 -0800 (PST)
Message-ID: <4F57841A.6060901@gmail.com>
Date: Wed, 07 Mar 2012 16:51:54 +0100
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] af9015: fix i2c failures for dual-tuner devices
References: <4F19EB13.7010502@iki.fi> <1327266792-8030-1-git-send-email-ghecker@gmx.de>
In-Reply-To: <1327266792-8030-1-git-send-email-ghecker@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22.01.2012 22:13, Gordon Hecker wrote:
> The i2c failures were caused by enabling both i2c gates
> at the same time while putting the tuners asleep.
> 
> This patch removes the init() and sleep() callbacks from the tuner,
> to prevent frontend.c from calling
>   i2c_gate_ctrl
>   tuner init / sleep
>   i2c_gate_ctrl
> without holding the lock.
> tuner init() and sleep() are instead called in frontend init() and
> sleep().
> 
> Signed-off-by: Gordon Hecker <ghecker@gmx.de>
> ---
>  drivers/media/dvb/dvb-usb/af9015.c |   31 +++++++++++++++++++++++++++++++
>  drivers/media/dvb/dvb-usb/af9015.h |    2 ++
>  2 files changed, 33 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
> index e755d76..b69b43b 100644
> --- a/drivers/media/dvb/dvb-usb/af9015.c
> +++ b/drivers/media/dvb/dvb-usb/af9015.c
> @@ -1141,7 +1141,18 @@ static int af9015_af9013_init(struct dvb_frontend *fe)
>  		return -EAGAIN;
>  
>  	ret = priv->init[adap->id](fe);
> +	if (ret)
> +		goto err_unlock;
> +
> +	if (priv->tuner_ops_init[adap->id]) {
> +		if (fe->ops.i2c_gate_ctrl)
> +			fe->ops.i2c_gate_ctrl(fe, 1);
> +		ret = priv->tuner_ops_init[adap->id](fe);
> +		if (fe->ops.i2c_gate_ctrl)
> +			fe->ops.i2c_gate_ctrl(fe, 0);
> +	}
>  
> +err_unlock:
>  	mutex_unlock(&adap->dev->usb_mutex);
>  
>  	return ret;
> @@ -1157,8 +1168,19 @@ static int af9015_af9013_sleep(struct dvb_frontend *fe)
>  	if (mutex_lock_interruptible(&adap->dev->usb_mutex))
>  		return -EAGAIN;
>  
> +	if (priv->tuner_ops_sleep[adap->id]) {
> +		if (fe->ops.i2c_gate_ctrl)
> +			fe->ops.i2c_gate_ctrl(fe, 1);
> +		ret = priv->tuner_ops_sleep[adap->id](fe);
> +		if (fe->ops.i2c_gate_ctrl)
> +			fe->ops.i2c_gate_ctrl(fe, 0);
> +		if (ret)
> +			goto err_unlock;
> +	}
> +
>  	ret = priv->sleep[adap->id](fe);
>  
> +err_unlock:
>  	mutex_unlock(&adap->dev->usb_mutex);
>  
>  	return ret;
> @@ -1283,6 +1305,7 @@ static struct mxl5007t_config af9015_mxl5007t_config = {
>  static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
>  {
>  	int ret;
> +	struct af9015_state *state = adap->dev->priv;
>  	deb_info("%s:\n", __func__);
>  
>  	switch (af9015_af9013_config[adap->id].tuner) {
> @@ -1340,6 +1363,14 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
>  		err("Unknown tuner id:%d",
>  			af9015_af9013_config[adap->id].tuner);
>  	}
> +
> +	state->tuner_ops_sleep[adap->id] =
> +				adap->fe_adap[0].fe->ops.tuner_ops.sleep;
> +	adap->fe_adap[0].fe->ops.tuner_ops.sleep = 0;
> +
> +	state->tuner_ops_init[adap->id] =
> +				adap->fe_adap[0].fe->ops.tuner_ops.init;
> +	adap->fe_adap[0].fe->ops.tuner_ops.init = 0;
>  	return ret;
>  }
>  
> diff --git a/drivers/media/dvb/dvb-usb/af9015.h b/drivers/media/dvb/dvb-usb/af9015.h
> index f619063..ee2ec5b 100644
> --- a/drivers/media/dvb/dvb-usb/af9015.h
> +++ b/drivers/media/dvb/dvb-usb/af9015.h
> @@ -108,6 +108,8 @@ struct af9015_state {
>  	int (*read_status[2]) (struct dvb_frontend *fe, fe_status_t *status);
>  	int (*init[2]) (struct dvb_frontend *fe);
>  	int (*sleep[2]) (struct dvb_frontend *fe);
> +	int (*tuner_ops_init[2]) (struct dvb_frontend *fe);
> +	int (*tuner_ops_sleep[2]) (struct dvb_frontend *fe);
>  };
>  
>  struct af9015_config {

Both tuners perform stable.
Tested on mythbackend multiple streams simultaneously.
+1

rgds,
poma
