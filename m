Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755175Ab2HJWMs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 18:12:48 -0400
Message-ID: <50258758.8050902@redhat.com>
Date: Fri, 10 Aug 2012 19:12:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: CrazyCat <crazycat69@yandex.ru>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Manu Abraham <manu@linuxtv.org>
Subject: Re: [PATCH] DVB-S2 multistream support
References: <59951342221302@web18g.yandex.ru>
In-Reply-To: <59951342221302@web18g.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 13-07-2012 20:15, CrazyCat escreveu:
> Now present DTV_DVBT2_PLP_ID property for DVB-T2, so i add alias DTV_DVBS2_MIS_ID (same feature for advanced DVB-S2). Now DVB-S2 multistream filtration supported for current STV090x demod cut 3.0, so i implement support for stv090x demod driver. Additional fe-caps FE_CAN_MULTISTREAM also added.
> 
> 
> frontend-mis.patch

Please provide your Signed-off-by: (with your real name).

> 
> 
> diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
> index f50d405..f625f8d 100644
> --- a/include/linux/dvb/frontend.h
> +++ b/include/linux/dvb/frontend.h
> @@ -62,6 +62,7 @@ typedef enum fe_caps {
>  	FE_CAN_8VSB			= 0x200000,
>  	FE_CAN_16VSB			= 0x400000,
>  	FE_HAS_EXTENDED_CAPS		= 0x800000,   /* We need more bitspace for newer APIs, indicate this. */
> +	FE_CAN_MULTISTREAM		= 0x4000000,  /* frontend supports DVB-S2 multistream filtering */

Not sure if this is really needed. Are there any DVB-S2 frontends that
don't support MIS, or they don't implement it just because this weren't
defined yet? In the latter case, it would be better to not adding an
special flag for it.

>  	FE_CAN_TURBO_FEC		= 0x8000000,  /* frontend supports "turbo fec modulation" */
>  	FE_CAN_2G_MODULATION		= 0x10000000, /* frontend supports "2nd generation modulation" (DVB-S2) */
>  	FE_NEEDS_BENDING		= 0x20000000, /* not supported anymore, don't use (frontend requires frequency bending) */
> @@ -317,6 +318,7 @@ struct dvb_frontend_event {
>  #define DTV_ISDBS_TS_ID		42
>  
>  #define DTV_DVBT2_PLP_ID	43
> +#define DTV_DVBS2_MIS_ID	43

It would be better to define it as:

#define DTV_DVBS2_MIS_ID	DTV_DVBT2_PLP_ID

Even better, we should instead find a better name that would cover both
DVB-T2 and DVB-S2 program ID fields, like:

#define DTV_DVB_MULT		43
#define DTV_DVBT2_PLP_ID	DTV_DVB_MULT

And use the new symbol for both DVB-S2 and DVB-T2, deprecating the
legacy symbol.

Also, DocBook needs to be changed to reflect this change.

>  
>  #define DTV_ENUM_DELSYS		44
>  
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index aebcdf2..83e51f9 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -947,7 +947,7 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
>  	}
>  
>  	c->isdbs_ts_id = 0;
> -	c->dvbt2_plp_id = 0;
> +	c->dvbt2_plp_id = -1;
>  
>  	switch (c->delivery_system) {
>  	case SYS_DVBS:
> diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb/frontends/stv090x.c
> index ea86a56..eb6f1cf 100644
> --- a/drivers/media/dvb/frontends/stv090x.c
> +++ b/drivers/media/dvb/frontends/stv090x.c
> @@ -3425,6 +3425,33 @@ err:
>  	return -1;
>  }
>  
> +static int stv090x_set_mis(struct stv090x_state *state, int mis)
> +{
> +	u32 reg;
> +
> +	if (mis<0 || mis>255) {

You should be checking your patch using scripts/checkpatch.pl.
Due to Documentation/CodingStyle, the above should be written, instead, as:
	if (mis < 0 || mis > 255) {


> +		dprintk(FE_DEBUG, 1, "Disable MIS filtering");
> +		reg = STV090x_READ_DEMOD(state, PDELCTRL1);
> +		STV090x_SETFIELD_Px(reg, FILTER_EN_FIELD, 0x00);
> +		if (STV090x_WRITE_DEMOD(state, PDELCTRL1, reg) < 0)
> +			goto err;
> +	} else {
> +		dprintk(FE_DEBUG, 1, "Enable MIS filtering - %d", mis);
> +		reg = STV090x_READ_DEMOD(state, PDELCTRL1);
> +		STV090x_SETFIELD_Px(reg, FILTER_EN_FIELD, 0x01);
> +		if (STV090x_WRITE_DEMOD(state, PDELCTRL1, reg) < 0)
> +			goto err;
> +		if (STV090x_WRITE_DEMOD(state, ISIENTRY, mis) < 0)
> +			goto err;
> +		if (STV090x_WRITE_DEMOD(state, ISIBITENA, 0xff) < 0)
> +			goto err;
> +	}
> +	return 0;
> +err:
> +	dprintk(FE_ERROR, 1, "I/O error");
> +	return -1;
> +}
> +
>  static enum dvbfe_search stv090x_search(struct dvb_frontend *fe)
>  {
>  	struct stv090x_state *state = fe->demodulator_priv;
> @@ -3433,6 +3460,8 @@ static enum dvbfe_search stv090x_search(struct dvb_frontend *fe)
>  	if (props->frequency == 0)
>  		return DVBFE_ALGO_SEARCH_INVALID;
>  
> +	stv090x_set_mis(state,props->dvbt2_plp_id);
> +
>  	state->delsys = props->delivery_system;
>  	state->frequency = props->frequency;
>  	state->srate = props->symbol_rate;
> @@ -3447,6 +3476,8 @@ static enum dvbfe_search stv090x_search(struct dvb_frontend *fe)
>  		state->search_range = 5000000;
>  	}
>  
> +	stv090x_set_mis(state,props->dvbt2_plp_id);
> +
>  	if (stv090x_algo(state) == STV090x_RANGEOK) {
>  		dprintk(FE_DEBUG, 1, "Search success!");
>  		return DVBFE_ALGO_SEARCH_SUCCESS;
> @@ -4798,6 +4829,9 @@ struct dvb_frontend *stv090x_attach(const struct stv090x_config *config,
>  		}
>  	}
>  
> +	if (state->internal->dev_ver>=0x30)
> +	    state->frontend.ops.info.caps |= FE_CAN_MULTISTREAM;
> +
>  	/* workaround for stuck DiSEqC output */
>  	if (config->diseqc_envelope_mode)
>  		stv090x_send_diseqc_burst(&state->frontend, SEC_MINI_A);
> 

Regards,
Mauro
