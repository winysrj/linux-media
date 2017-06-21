Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48946 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751895AbdFUGai (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 02:30:38 -0400
Subject: Re: [PATCH 3/4] [media] dvb-frontends/stv0367: SNR DVBv5 statistics
 for DVB-C and T
To: Daniel Scheller <d.scheller.oss@gmail.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: liplianin@netup.ru, rjkm@metzlerbros.de
References: <20170620174506.7593-1-d.scheller.oss@gmail.com>
 <20170620174506.7593-4-d.scheller.oss@gmail.com>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <ee554f8e-b533-4b8b-5710-83e7ff40a3c2@iki.fi>
Date: Wed, 21 Jun 2017 09:30:27 +0300
MIME-Version: 1.0
In-Reply-To: <20170620174506.7593-4-d.scheller.oss@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/20/2017 08:45 PM, Daniel Scheller wrote:
> From: Daniel Scheller <d.scheller@gmx.net>
> 
> Add signal-to-noise-ratio as provided by the demodulator in decibel scale.
> QAM/DVB-C needs some intlog calculation to have usable dB values, OFDM/
> DVB-T values from the demod look alright already and are provided as-is.
> 
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>   drivers/media/dvb-frontends/stv0367.c | 33 +++++++++++++++++++++++++++++++++
>   1 file changed, 33 insertions(+)
> 
> diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
> index bb498f942ebd..0b13a407df23 100644
> --- a/drivers/media/dvb-frontends/stv0367.c
> +++ b/drivers/media/dvb-frontends/stv0367.c
> @@ -25,6 +25,8 @@
>   #include <linux/slab.h>
>   #include <linux/i2c.h>
>   
> +#include "dvb_math.h"
> +
>   #include "stv0367.h"
>   #include "stv0367_defs.h"
>   #include "stv0367_regs.h"
> @@ -33,6 +35,9 @@
>   /* Max transfer size done by I2C transfer functions */
>   #define MAX_XFER_SIZE  64
>   
> +/* snr logarithmic calc */
> +#define INTLOG10X100(x) ((u32) (((u64) intlog10(x) * 100) >> 24))
> +
>   static int stvdebug;
>   module_param_named(debug, stvdebug, int, 0644);
>   
> @@ -3013,6 +3018,33 @@ static int stv0367ddb_read_status(struct dvb_frontend *fe,
>   	return -EINVAL;
>   }
>   
> +static void stv0367ddb_read_snr(struct dvb_frontend *fe)
> +{
> +	struct stv0367_state *state = fe->demodulator_priv;
> +	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
> +	int cab_pwr;
> +	u32 regval, tmpval, snrval = 0;
> +
> +	switch (state->activedemod) {
> +	case demod_ter:
> +		snrval = stv0367ter_snr_readreg(fe);
> +		break;
> +	case demod_cab:
> +		cab_pwr = stv0367cab_snr_power(fe);
> +		regval = stv0367cab_snr_readreg(fe, 0);
> +
> +		tmpval = (cab_pwr * 320) / regval;
> +		snrval = ((tmpval != 0) ? INTLOG10X100(tmpval) : 0) * 100;

How much there will be rounding errors due to that signal/noise 
division? I would convert it to calculation of sums (tip logarithm 
calculation rules).

Also, that INTLOG10X100 is pretty much useless. Use just what 
intlog10/intlog2 offers without yet again another conversion.



> +		break;
> +	default:
> +		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> +		return;
> +	}
> +
> +	p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
> +	p->cnr.stat[0].uvalue = snrval;
> +}
> +
>   static void stv0367ddb_read_ucblocks(struct dvb_frontend *fe)
>   {
>   	struct stv0367_state *state = fe->demodulator_priv;
> @@ -3069,6 +3101,7 @@ static int stv0367ddb_get_frontend(struct dvb_frontend *fe,
>   	}
>   
>   	stv0367ddb_read_ucblocks(fe);
> +	stv0367ddb_read_snr(fe);
>   
>   	return 0;
>   }
> 

regards
Antti

-- 
http://palosaari.fi/
