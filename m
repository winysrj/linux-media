Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38953 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab3AWWhD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 17:37:03 -0500
Message-ID: <510065E9.7070702@iki.fi>
Date: Thu, 24 Jan 2013 00:36:25 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add lock to af9035 driver for dual mode
References: <45300900.lplt0zG7i2@jar7.dominio>
In-Reply-To: <45300900.lplt0zG7i2@jar7.dominio>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/24/2013 12:34 AM, Jose Alberto Reguero wrote:
> Add lock to af9035 driver for dual mode.

May I ask why you do that?

regards
Antti

>
> Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>
>
>
> diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.c
> linux.new/drivers/media/usb/dvb-usb-v2/af9035.c
> --- linux/drivers/media/usb/dvb-usb-v2/af9035.c	2013-01-07 05:45:57.000000000
> +0100
> +++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.c	2013-01-23
> 23:18:18.544788327 +0100
> @@ -824,6 +824,104 @@ static int af9035_get_adapter_count(stru
>   	return state->dual_mode + 1;
>   }
>
> +static int af9035_lock_set_frontend(struct dvb_frontend* fe)
> +{
> +       int result;
> +       struct dvb_usb_adapter *adap = fe_to_adap(fe);
> +       struct state *state = adap_to_priv(adap);
> +
> +       if (mutex_lock_interruptible(&state->fe_mutex))
> +               return -EAGAIN;
> +
> +       result = state->fe_ops[adap->id].set_frontend(fe);
> +       mutex_unlock(&state->fe_mutex);
> +       return result;
> +}
> +
> +static int af9035_lock_get_frontend(struct dvb_frontend* fe)
> +{
> +       int result;
> +       struct dvb_usb_adapter *adap = fe_to_adap(fe);
> +       struct state *state = adap_to_priv(adap);
> +
> +       if (mutex_lock_interruptible(&state->fe_mutex))
> +               return -EAGAIN;
> +
> +       result = state->fe_ops[adap->id].get_frontend(fe);
> +       mutex_unlock(&state->fe_mutex);
> +       return result;
> +}
> +
> +static int af9035_lock_read_status(struct dvb_frontend* fe, fe_status_t*
> status)
> +{
> +       int result;
> +       struct dvb_usb_adapter *adap = fe_to_adap(fe);
> +       struct state *state = adap_to_priv(adap);
> +
> +       if (mutex_lock_interruptible(&state->fe_mutex))
> +               return -EAGAIN;
> +
> +       result = state->fe_ops[adap->id].read_status(fe, status);
> +       mutex_unlock(&state->fe_mutex);
> +       return result;
> +}
> +
> +static int af9035_lock_read_ber(struct dvb_frontend* fe, u32* ber)
> +{
> +       int result;
> +       struct dvb_usb_adapter *adap = fe_to_adap(fe);
> +       struct state *state = adap_to_priv(adap);
> +
> +       if (mutex_lock_interruptible(&state->fe_mutex))
> +               return -EAGAIN;
> +
> +       result = state->fe_ops[adap->id].read_ber(fe, ber);
> +       mutex_unlock(&state->fe_mutex);
> +       return result;
> +}
> +
> +static int af9035_lock_read_signal_strength(struct dvb_frontend* fe, u16*
> strength)
> +{
> +       int result;
> +       struct dvb_usb_adapter *adap = fe_to_adap(fe);
> +       struct state *state = adap_to_priv(adap);
> +
> +       if (mutex_lock_interruptible(&state->fe_mutex))
> +               return -EAGAIN;
> +
> +       result = state->fe_ops[adap->id].read_signal_strength(fe, strength);
> +       mutex_unlock(&state->fe_mutex);
> +       return result;
> +}
> +
> +static int af9035_lock_read_snr(struct dvb_frontend* fe, u16* snr)
> +{
> +       int result;
> +       struct dvb_usb_adapter *adap = fe_to_adap(fe);
> +       struct state *state = adap_to_priv(adap);
> +
> +       if (mutex_lock_interruptible(&state->fe_mutex))
> +               return -EAGAIN;
> +
> +       result = state->fe_ops[adap->id].read_snr(fe, snr);
> +       mutex_unlock(&state->fe_mutex);
> +       return result;
> +}
> +
> +static int af9035_lock_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
> +{
> +       int result;
> +       struct dvb_usb_adapter *adap = fe_to_adap(fe);
> +       struct state *state = adap_to_priv(adap);
> +
> +       if (mutex_lock_interruptible(&state->fe_mutex))
> +               return -EAGAIN;
> +
> +       result = state->fe_ops[adap->id].read_ucblocks(fe, ucblocks);
> +       mutex_unlock(&state->fe_mutex);
> +       return result;
> +}
> +
>   static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
>   {
>   	struct state *state = adap_to_priv(adap);
> @@ -862,6 +960,22 @@ static int af9035_frontend_attach(struct
>   	adap->fe[0]->ops.i2c_gate_ctrl = NULL;
>   	adap->fe[0]->callback = af9035_frontend_callback;
>
> +       memcpy(&state->fe_ops[adap->id], &adap->fe[0]->ops, sizeof(struct
> dvb_frontend_ops));
> +       if (adap->fe[0]->ops.set_frontend)
> +               adap->fe[0]->ops.set_frontend = af9035_lock_set_frontend;
> +       if (adap->fe[0]->ops.get_frontend)
> +               adap->fe[0]->ops.get_frontend = af9035_lock_get_frontend;
> +       if (adap->fe[0]->ops.read_status)
> +               adap->fe[0]->ops.read_status = af9035_lock_read_status;
> +       if (adap->fe[0]->ops.read_ber)
> +               adap->fe[0]->ops.read_ber = af9035_lock_read_ber;
> +       if (adap->fe[0]->ops.read_signal_strength)
> +               adap->fe[0]->ops.read_signal_strength =
> af9035_lock_read_signal_strength;
> +       if (adap->fe[0]->ops.read_snr)
> +               adap->fe[0]->ops.read_snr = af9035_lock_read_snr;
> +       if (adap->fe[0]->ops.read_ucblocks)
> +               adap->fe[0]->ops.read_ucblocks = af9035_lock_read_ucblocks;
> +
>   	return 0;
>
>   err:
> @@ -1130,6 +1244,8 @@ static int af9035_init(struct dvb_usb_de
>   			"packet_size=%02x\n", __func__,
>   			d->udev->speed, frame_size, packet_size);
>
> +	mutex_init(&state->fe_mutex);
> +
>   	/* init endpoints */
>   	for (i = 0; i < ARRAY_SIZE(tab); i++) {
>   		ret = af9035_wr_reg_mask(d, tab[i].reg, tab[i].val,
> diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.h
> linux.new/drivers/media/usb/dvb-usb-v2/af9035.h
> --- linux/drivers/media/usb/dvb-usb-v2/af9035.h	2013-01-07 05:45:57.000000000
> +0100
> +++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.h	2013-01-23
> 23:12:59.389532516 +0100
> @@ -55,6 +55,10 @@ struct state {
>   	u8 seq; /* packet sequence number */
>   	bool dual_mode;
>   	struct af9033_config af9033_config[2];
> +
> +	struct dvb_frontend_ops fe_ops[2];
> +
> +	struct mutex fe_mutex;
>   };
>
>   u32 clock_lut[] = {
>


-- 
http://palosaari.fi/
