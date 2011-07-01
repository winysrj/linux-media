Return-path: <mchehab@pedra>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:42457 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab1GAIPq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2011 04:15:46 -0400
From: =?utf-8?Q?S=C3=A9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Malcolm Priestley'" <tvboxspy@gmail.com>,
	"'Linux Media Mailing List'" <linux-media@vger.kernel.org>,
	<o.endriss@gmx.de>
References: <00a301cc365e$b6d415c0$247c4140$@coexsi.fr> <1309472493.11947.12.camel@localhost>
In-Reply-To: <1309472493.11947.12.camel@localhost>
Subject: RE: [PATCH] STV0288 Fast Channel Acquisition
Date: Fri, 1 Jul 2011 10:15:44 +0200
Message-ID: <004901cc37c7$147763d0$3d662b70$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Malcolm Priestley
> Sent: vendredi 1 juillet 2011 00:22
> To: Linux Media Mailing List
> Cc: Sébastien RAILLARD (COEXSI)
> Subject: [PATCH] STV0288 Fast Channel Acquisition
> 
> On Wed, 2011-06-29 at 15:16 +0200, Sébastien RAILLARD (COEXSI) wrote:
> 
> > On some other transponders, like ASTRA 19.2E 11567-V-22000, the card
> > nearly never manage to get the lock: it's looking like the signal
> > isn't good enough.
> > I turned on the debugging of the stb6000 and stv0288 modules, but I
> > can't see anything wrong.
> 
> I have had similar problems with the stv0288 on astra 19.2 and 28.2 with
> various frequencies.
> 
> I have been using this patch for some time which seems to improve
> things.
> 
> The STV0288 has a fast channel function which eliminates the need for
> software carrier search.
> 
> The patch removes the slow carrier search and replaces it with this
> faster and more reliable built-in chip function.
> 
> If carrier is lost while channel is running, fast channel attempts to
> recover it.
> 
> The patch also reguires registers 50-57 to be set correctly with
> inittab. All current combinations in the kernel media tree have been
> checked and tested.
> 

Thanks Macolm for this patch!

Regarding the TT-S-1500b, it's using a specific inittab, I hope Oliver can have a look and check if this patch is compatible with the ALPS BSBE1 tuner.

Sebastien

> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  drivers/media/dvb/frontends/stv0288.c |   75 +++++++++++++++++++++-----
> ------
>  1 files changed, 49 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/media/dvb/frontends/stv0288.c
> b/drivers/media/dvb/frontends/stv0288.c
> index 8e0cfad..fa5cba5 100644
> --- a/drivers/media/dvb/frontends/stv0288.c
> +++ b/drivers/media/dvb/frontends/stv0288.c
> @@ -142,6 +142,12 @@ static int stv0288_set_symbolrate(struct
> dvb_frontend *fe, u32 srate)
>  		stv0288_writeregI(state, 0x28, b[0]);
>  		stv0288_writeregI(state, 0x29, b[1]);
>  		stv0288_writeregI(state, 0x2a, b[2]);
> +
> +		stv0288_writeregI(state, 0x22, 0x0);
> +		stv0288_writeregI(state, 0x23, 0x0);
> +		stv0288_writeregI(state, 0x2b, 0x0);
> +		stv0288_writeregI(state, 0x2c, 0x0);
> +
>  		dprintk("stv0288: stv0288_set_symbolrate\n");
> 
>  	return 0;
> @@ -309,12 +315,13 @@ static u8 stv0288_inittab[] = {
>  	0xf1, 0x0,
>  	0xf2, 0xc0,
>  	0x51, 0x36,
> -	0x52, 0x09,
> -	0x53, 0x94,
> -	0x54, 0x62,
> -	0x55, 0x29,
> -	0x56, 0x64,
> -	0x57, 0x2b,
> +	0x52, 0x21,
> +	/* Fast Channel MIN/MAX Freqency Bounds MSB bit 7 sets stop */
> +	0x53, 0x94, /*Min MSB (0-6)*/
> +	0x54, 0x62, /*Min LSB*/
> +	0x55, 0x29, /*Max MSB (0-6)*/
> +	0x56, 0x64, /*Max LSB*/
> +	0x57, 0x2b, /* Increment (signed) */
>  	0xff, 0xff,
>  };
> 
> @@ -356,6 +363,35 @@ static int stv0288_init(struct dvb_frontend *fe)
>  	return 0;
>  }
> 
> +/* STV0288 Fast channel accquisition and blind search */ static int
> +stv0288_get_fast(struct dvb_frontend *fe) {
> +	struct stv0288_state *state = fe->demodulator_priv;
> +	int timeout = 0;
> +
> +	/* Coarse Tune */
> +	stv0288_writeregI(state, 0x50, 0x35);
> +	/* Wait 15ms */
> +	msleep(15);
> +	/* Fine Tune Control & Center Carrier */
> +	stv0288_writeregI(state, 0x50, 0x16);
> +	/* Check for Timing lock */
> +	while (!(stv0288_readreg(state, 0x1e) & 0x80)) {
> +		if (timeout++ > 5)
> +			return -EINVAL;
> +		msleep(15);
> +	}
> +
> +	/* Center Carrier for further length of time */
> +	stv0288_writeregI(state, 0x50, 0x14);
> +	udelay(500);
> +	/* Fast Search End*/
> +	stv0288_writeregI(state, 0x50, 0x10);
> +
> +	return 0;
> +}
> +
> +
>  static int stv0288_read_status(struct dvb_frontend *fe, fe_status_t
> *status)  {
>  	struct stv0288_state *state = fe->demodulator_priv; @@ -369,6
> +405,9 @@ static int stv0288_read_status(struct dvb_frontend *fe,
> fe_status_t *status)
>  	*status = 0;
>  	if (sync & 0x80)
>  		*status |= FE_HAS_CARRIER | FE_HAS_SIGNAL;
> +		else
> +		stv0288_get_fast(fe); /*try to recover*/
> +
>  	if (sync & 0x10)
>  		*status |= FE_HAS_VITERBI;
>  	if (sync & 0x08) {
> @@ -458,9 +497,7 @@ static int stv0288_set_frontend(struct dvb_frontend
> *fe,  {
>  	struct stv0288_state *state = fe->demodulator_priv;
>  	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> -
> -	char tm;
> -	unsigned char tda[3];
> +	int ret = 0;
> 
>  	dprintk("%s : FE_SET_FRONTEND\n", __func__);
> 
> @@ -487,28 +524,14 @@ static int stv0288_set_frontend(struct
> dvb_frontend *fe,
>  	stv0288_set_symbolrate(fe, c->symbol_rate);
>  	/* Carrier lock control register */
>  	stv0288_writeregI(state, 0x15, 0xc5);
> -
> -	tda[0] = 0x2b; /* CFRM */
> -	tda[2] = 0x0; /* CFRL */
> -	for (tm = -6; tm < 7;) {
> -		/* Viterbi status */
> -		if (stv0288_readreg(state, 0x24) & 0x8)
> -			break;
> -
> -		tda[2] += 40;
> -		if (tda[2] < 40)
> -			tm++;
> -		tda[1] = (unsigned char)tm;
> -		stv0288_writeregI(state, 0x2b, tda[1]);
> -		stv0288_writeregI(state, 0x2c, tda[2]);
> -		udelay(30);
> -	}
> +	/* Search for carrier */
> +	ret = stv0288_get_fast(fe);
> 
>  	state->tuner_frequency = c->frequency;
>  	state->fec_inner = FEC_AUTO;
>  	state->symbol_rate = c->symbol_rate;
> 
> -	return 0;
> +	return ret;
>  }
> 
>  static int stv0288_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
> --
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

