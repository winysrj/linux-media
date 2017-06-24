Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36538
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754667AbdFXVRs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 17:17:48 -0400
Date: Sat, 24 Jun 2017 18:17:40 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi
Subject: Re: [PATCH v2 3/4] [media] dvb-frontends/stv0367: SNR DVBv5
 statistics for DVB-C and T
Message-ID: <20170624181740.75d69c3b@vento.lan>
In-Reply-To: <20170621194544.16949-4-d.scheller.oss@gmail.com>
References: <20170621194544.16949-1-d.scheller.oss@gmail.com>
        <20170621194544.16949-4-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 21 Jun 2017 21:45:43 +0200
Daniel Scheller <d.scheller.oss@gmail.com> escreveu:

> From: Daniel Scheller <d.scheller@gmx.net>
> 
> Add signal-to-noise-ratio as provided by the demodulator in decibel scale.
> QAM/DVB-C needs some intlog calculation to have usable dB values, OFDM/
> DVB-T values from the demod look alright already and are provided as-is.
> 
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/stv0367.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
> index f8e9cceed04e..d3be25bc1002 100644
> --- a/drivers/media/dvb-frontends/stv0367.c
> +++ b/drivers/media/dvb-frontends/stv0367.c
> @@ -25,6 +25,8 @@
>  #include <linux/slab.h>
>  #include <linux/i2c.h>
>  
> +#include "dvb_math.h"
> +
>  #include "stv0367.h"
>  #include "stv0367_defs.h"
>  #include "stv0367_regs.h"
> @@ -2996,6 +2998,37 @@ static int stv0367ddb_set_frontend(struct dvb_frontend *fe)
>  	return -EINVAL;
>  }
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
> +		/* prevent division by zero */
> +		if (!regval)
> +			snrval = 0;
> +
> +		tmpval = (cab_pwr * 320) / regval;
> +		snrval = ((tmpval != 0) ? (intlog2(tmpval) / 5581) : 0);
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
>  static void stv0367ddb_read_ucblocks(struct dvb_frontend *fe)
>  {
>  	struct stv0367_state *state = fe->demodulator_priv;
> @@ -3042,10 +3075,12 @@ static int stv0367ddb_read_status(struct dvb_frontend *fe,
>  
>  	/* stop if demod isn't locked */
>  	if (!(*status & FE_HAS_LOCK)) {
> +		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;

It sounds weird that CNR is only available with full lock.

On a very quick look at the driver, for SYS_DVBC_ANNEX_A, I suspect that
you will get CNR earlier. Probably when 
cab_state->state == FE_CAB_CARRIEROK.

For SYS_DVBT, it seems that the algorithm doesn't have an intermediate
step. So, only after ter_state->state = FE_TER_LOCKOK you have full
lock.

So, you should likely apply something like the enclosed (untested) patch
to get more status from the frontend, at least for DVB-C.

Thanks,
Mauro

media: stv0367: Improve DVB-C frontend status

The stv0367 driver provide a lot of status on its state machine.
Change the logic to provide more information about frontend locking
status.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index f266c18c574c..9e5432b761b5 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -1507,7 +1507,8 @@ static int stv0367ter_read_status(struct dvb_frontend *fe,
 	*status = 0;
 
 	if (stv0367_readbits(state, F367TER_LK)) {
-		*status |= FE_HAS_LOCK;
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI
+			  | FE_HAS_SYNC | FE_HAS_LOCK;
 		dprintk("%s: stv0367 has locked\n", __func__);
 	}
 
@@ -2155,6 +2156,18 @@ static int stv0367cab_read_status(struct dvb_frontend *fe,
 
 	*status = 0;
 
+	if (state->cab_state->state > FE_CAB_NOSIGNAL)
+		*status |= FE_HAS_SIGNAL;
+
+	if (state->cab_state->state > FE_CAB_NOCARRIER)
+		*status |= FE_HAS_CARRIER;
+
+	if (state->cab_state->state >= FE_CAB_DEMODOK)
+		*status |= FE_HAS_VITERBI;
+
+	if (state->cab_state->state >= FE_CAB_DATAOK)
+		*status |= FE_HAS_SYNC;
+
 	if (stv0367_readbits(state, (state->cab_state->qamfec_status_reg ?
 		state->cab_state->qamfec_status_reg : F367CAB_QAMFEC_LOCK))) {
 		*status |= FE_HAS_LOCK;
