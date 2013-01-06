Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59670 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab3AFNht (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jan 2013 08:37:49 -0500
Message-ID: <50E97E05.1090607@iki.fi>
Date: Sun, 06 Jan 2013 15:37:09 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Subject: Re: [PATCH] ts2020: call get_rf_strength from frontend
References: <1357476042.16016.8.camel@canaries64>
In-Reply-To: <1357476042.16016.8.camel@canaries64>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/06/2013 02:40 PM, Malcolm Priestley wrote:
> Restore ds3000.c read_signal_strength.
>
> Call tuner get_rf_strength from frontend read_signal_strength.
>
> We are able to do a NULL check and doesn't limit the tuner
> attach to the frontend attach area.
>
> At the moment the lmedm04 tuner attach is stuck in frontend
> attach area.

I would like to nack that, as I see some problems:
1) it changes deviation against normal procedures
2) interface driver (usb/pci) should have full control to make decision
3) you shoot to our own leg easily in power management

* actually bug 3) already happened some drivers, like rtl28xxu. Tuner is 
behind demod and demod is put sleep => no access to tuner. FE callback 
is overridden (just like you are trying to do as default) which means 
user-space could still make queries => I/O errors.

Antti


>
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>   drivers/media/dvb-frontends/ds3000.c    | 10 ++++++++++
>   drivers/media/dvb-frontends/m88rs2000.c |  4 +++-
>   drivers/media/dvb-frontends/ts2020.c    |  1 -
>   3 files changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
> index d128f85..1e344b0 100644
> --- a/drivers/media/dvb-frontends/ds3000.c
> +++ b/drivers/media/dvb-frontends/ds3000.c
> @@ -533,6 +533,15 @@ static int ds3000_read_ber(struct dvb_frontend *fe, u32* ber)
>   	return 0;
>   }
>
> +static int ds3000_read_signal_strength(struct dvb_frontend *fe,
> +						u16 *signal_strength)
> +{
> +	if (fe->ops.tuner_ops.get_rf_strength)
> +		fe->ops.tuner_ops.get_rf_strength(fe, signal_strength);
> +
> +	return 0;
> +}
> +
>   /* calculate DS3000 snr value in dB */
>   static int ds3000_read_snr(struct dvb_frontend *fe, u16 *snr)
>   {
> @@ -1102,6 +1111,7 @@ static struct dvb_frontend_ops ds3000_ops = {
>   	.i2c_gate_ctrl = ds3000_i2c_gate_ctrl,
>   	.read_status = ds3000_read_status,
>   	.read_ber = ds3000_read_ber,
> +	.read_signal_strength = ds3000_read_signal_strength,
>   	.read_snr = ds3000_read_snr,
>   	.read_ucblocks = ds3000_read_ucblocks,
>   	.set_voltage = ds3000_set_voltage,
> diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
> index 283c90f..4da5272 100644
> --- a/drivers/media/dvb-frontends/m88rs2000.c
> +++ b/drivers/media/dvb-frontends/m88rs2000.c
> @@ -446,7 +446,9 @@ static int m88rs2000_read_ber(struct dvb_frontend *fe, u32 *ber)
>   static int m88rs2000_read_signal_strength(struct dvb_frontend *fe,
>   	u16 *strength)
>   {
> -	*strength = 0;
> +	if (fe->ops.tuner_ops.get_rf_strength)
> +		fe->ops.tuner_ops.get_rf_strength(fe, strength);
> +
>   	return 0;
>   }
>
> diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
> index f50e237..ad7ad85 100644
> --- a/drivers/media/dvb-frontends/ts2020.c
> +++ b/drivers/media/dvb-frontends/ts2020.c
> @@ -363,7 +363,6 @@ struct dvb_frontend *ts2020_attach(struct dvb_frontend *fe,
>
>   	memcpy(&fe->ops.tuner_ops, &ts2020_tuner_ops,
>   				sizeof(struct dvb_tuner_ops));
> -	fe->ops.read_signal_strength = fe->ops.tuner_ops.get_rf_strength;
>
>   	return fe;
>   }
>


-- 
http://palosaari.fi/
