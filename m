Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:46864 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab1BXTIi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 14:08:38 -0500
Message-ID: <4D66ACB1.5030108@infradead.org>
Date: Thu, 24 Feb 2011 16:08:33 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 6/9 v2] ds3000: yet clean up in tune procedure
References: <201102020040.57353.liplianin@me.by>
In-Reply-To: <201102020040.57353.liplianin@me.by>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Igor,

Em 01-02-2011 20:40, Igor M. Liplianin escreveu:
> Remove a lot of debug messages and delays.

This patch didn't apply, probably because of the removal of the first one. 
Please fix and resend. The better is to join patches 5/9 and 6/9.

Thanks!
Mauro.
> 
> Signed-off-by: Igor M. Liplianin <liplianin@me.by>
> ---
>  drivers/media/dvb/frontends/ds3000.c |   50 +++++-----------------------------
>  1 files changed, 7 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
> index 7c61936..11f1aa2 100644
> --- a/drivers/media/dvb/frontends/ds3000.c
> +++ b/drivers/media/dvb/frontends/ds3000.c
> @@ -536,25 +536,6 @@ static int ds3000_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t 
> voltage)
>  	return 0;
>  }
>  
> -static void ds3000_dump_registers(struct dvb_frontend *fe)
> -{
> -	struct ds3000_state *state = fe->demodulator_priv;
> -	int x, y, reg = 0, val;
> -
> -	for (y = 0; y < 16; y++) {
> -		dprintk("%s: %02x: ", __func__, y);
> -		for (x = 0; x < 16; x++) {
> -			reg = (y << 4) + x;
> -			val = ds3000_readreg(state, reg);
> -			if (x != 15)
> -				dprintk("%02x ",  val);
> -			else
> -				dprintk("%02x\n", val);
> -		}
> -	}
> -	dprintk("%s: -- DS3000 DUMP DONE --\n", __func__);
> -}
> -
>  static int ds3000_read_status(struct dvb_frontend *fe, fe_status_t* status)
>  {
>  	struct ds3000_state *state = fe->demodulator_priv;
> @@ -589,16 +570,6 @@ static int ds3000_read_status(struct dvb_frontend *fe, fe_status_t* status)
>  	return 0;
>  }
>  
> -#define FE_IS_TUNED (FE_HAS_SIGNAL + FE_HAS_LOCK)
> -static int ds3000_is_tuned(struct dvb_frontend *fe)
> -{
> -	fe_status_t tunerstat;
> -
> -	ds3000_read_status(fe, &tunerstat);
> -
> -	return ((tunerstat & FE_IS_TUNED) == FE_IS_TUNED);
> -}
> -
>  /* read DS3000 BER value */
>  static int ds3000_read_ber(struct dvb_frontend *fe, u32* ber)
>  {
> @@ -1049,7 +1020,7 @@ static int ds3000_tune(struct dvb_frontend *fe,
>  	struct ds3000_state *state = fe->demodulator_priv;
>  	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>  
> -	int ret = 0, i;
> +	int i;
>  	u8 status, mlpf, mlpf_new, mlpf_max, mlpf_min, nlpf;
>  	u16 value, ndiv;
>  	u32 f3db;
> @@ -1292,22 +1263,15 @@ static int ds3000_tune(struct dvb_frontend *fe,
>  
>  	/* TODO: calculate and set carrier offset */
>  
> -	/* wait before retrying */
>  	for (i = 0; i < 30 ; i++) {
> -		if (ds3000_is_tuned(fe)) {
> -			dprintk("%s: Tuned\n", __func__);
> -			ds3000_dump_registers(fe);
> -			goto tuned;
> -		}
> -		msleep(1);
> -	}
> -
> -	dprintk("%s: Not tuned\n", __func__);
> -	ds3000_dump_registers(fe);
> +		ds3000_read_status(fe, &status);
> +		if (status && FE_HAS_LOCK)
> +			return 0;
>  
> +		msleep(10);
> +	}
>  
> -tuned:
> -	return ret;
> +	return 1;
>  }
>  
>  static enum dvbfe_algo ds3000_get_algo(struct dvb_frontend *fe)

