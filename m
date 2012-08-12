Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47579 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab2HLAAZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Aug 2012 20:00:25 -0400
Received: by lbbgj3 with SMTP id gj3so791637lbb.19
        for <linux-media@vger.kernel.org>; Sat, 11 Aug 2012 17:00:24 -0700 (PDT)
Message-ID: <5026F209.4030604@iki.fi>
Date: Sun, 12 Aug 2012 03:00:09 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: CrazyCat <crazycat69@yandex.ru>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Manu Abraham <manu@linuxtv.org>
Subject: Re: [PATCH] DVB-S2 multistream support
References: <59951342221302@web18g.yandex.ru> <50258758.8050902@redhat.com> <1981451344725742@web18g.yandex.ru>
In-Reply-To: <1981451344725742@web18g.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/12/2012 01:55 AM, CrazyCat wrote:
> Fixed patch.

We asked you to merge isdbs_ts_id, dvbt2_plp_id and dvbs2_mis_id to one 
as those are logically same thing from the user-point of view. 
Technically those differs, but that is userspace API so underlying 
technique should not matter.

It is some more work for you, but it should not be such big issue you 
cannot do. So please use few hours and merge all those. I think correct 
name is DTV_STREAM_ID. So remove isdbs_ts_id, dvbt2_plp_id and 
dvbs2_mis_id. Add new variable stream_id. As DTV_ISDBS_TS_ID and 
DTV_DVBT2_PLP_ID already exists you should make some logic those could 
be still used.

regards
Antti


>
> Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index aebcdf2..7813165 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -948,6 +948,7 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
>
>   	c->isdbs_ts_id = 0;
>   	c->dvbt2_plp_id = 0;
> +	c->dvbs2_mis_id = -1;
>
>   	switch (c->delivery_system) {
>   	case SYS_DVBS:
> @@ -1049,6 +1050,8 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
>   	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_B, 0, 0),
>   	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_C, 0, 0),
>   	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_D, 0, 0),
> +
> +	_DTV_CMD(DTV_DVBS2_MIS_ID, 1, 0),
>   };
>
>   static void dtv_property_dump(struct dtv_property *tvp)
> @@ -1436,6 +1439,10 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
>   		tvp->u.data = fe->dtv_property_cache.atscmh_sccc_code_mode_d;
>   		break;
>
> +	case DTV_DVBS2_MIS_ID:
> +		tvp->u.data = c->dvbs2_mis_id;
> +		break;
> +
>   	default:
>   		return -EINVAL;
>   	}
> @@ -1786,6 +1793,10 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
>   		fe->dtv_property_cache.atscmh_rs_frame_ensemble = tvp->u.data;
>   		break;
>
> +	case DTV_DVBS2_MIS_ID:
> +		c->dvbs2_mis_id = tvp->u.data;
> +		break;
> +
>   	default:
>   		return -EINVAL;
>   	}
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
> index 7c64c09..cf10b05 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.h
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
> @@ -374,6 +374,9 @@ struct dtv_frontend_properties {
>   	/* DVB-T2 specifics */
>   	u32                     dvbt2_plp_id;
>
> +	/* DVB-S2 specifics */
> +	u32                     dvbs2_mis_id;
> +
>   	/* ATSC-MH specifics */
>   	u8			atscmh_fic_ver;
>   	u8			atscmh_parade_id;
> diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb/frontends/stv090x.c
> index ea86a56..a9c2bc5 100644
> --- a/drivers/media/dvb/frontends/stv090x.c
> +++ b/drivers/media/dvb/frontends/stv090x.c
> @@ -3425,6 +3425,33 @@ err:
>   	return -1;
>   }
>
> +static int stv090x_set_mis(struct stv090x_state *state, int mis)
> +{
> +	u32 reg;
> +
> +	if (mis < 0 || mis > 255) {
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
>   static enum dvbfe_search stv090x_search(struct dvb_frontend *fe)
>   {
>   	struct stv090x_state *state = fe->demodulator_priv;
> @@ -3447,6 +3474,8 @@ static enum dvbfe_search stv090x_search(struct dvb_frontend *fe)
>   		state->search_range = 5000000;
>   	}
>
> +	stv090x_set_mis(state, props->dvbs2_mis_id);
> +
>   	if (stv090x_algo(state) == STV090x_RANGEOK) {
>   		dprintk(FE_DEBUG, 1, "Search success!");
>   		return DVBFE_ALGO_SEARCH_SUCCESS;
> @@ -4798,6 +4827,9 @@ struct dvb_frontend *stv090x_attach(const struct stv090x_config *config,
>   		}
>   	}
>
> +	if (state->internal->dev_ver >= 0x30)
> +		state->frontend.ops.info.caps |= FE_CAN_MULTISTREAM;
> +
>   	/* workaround for stuck DiSEqC output */
>   	if (config->diseqc_envelope_mode)
>   		stv090x_send_diseqc_burst(&state->frontend, SEC_MINI_A);
> diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
> index f50d405..b37996e 100644
> --- a/include/linux/dvb/frontend.h
> +++ b/include/linux/dvb/frontend.h
> @@ -62,6 +62,7 @@ typedef enum fe_caps {
>   	FE_CAN_8VSB			= 0x200000,
>   	FE_CAN_16VSB			= 0x400000,
>   	FE_HAS_EXTENDED_CAPS		= 0x800000,   /* We need more bitspace for newer APIs, indicate this. */
> +	FE_CAN_MULTISTREAM		= 0x4000000,  /* frontend supports DVB-S2 multistream filtering */
>   	FE_CAN_TURBO_FEC		= 0x8000000,  /* frontend supports "turbo fec modulation" */
>   	FE_CAN_2G_MODULATION		= 0x10000000, /* frontend supports "2nd generation modulation" (DVB-S2) */
>   	FE_NEEDS_BENDING		= 0x20000000, /* not supported anymore, don't use (frontend requires frequency bending) */
> @@ -337,7 +338,9 @@ struct dvb_frontend_event {
>   #define DTV_ATSCMH_SCCC_CODE_MODE_C	58
>   #define DTV_ATSCMH_SCCC_CODE_MODE_D	59
>
> -#define DTV_MAX_COMMAND				DTV_ATSCMH_SCCC_CODE_MODE_D
> +#define DTV_DVBS2_MIS_ID	60
> +
> +#define DTV_MAX_COMMAND				DTV_DVBS2_MIS_ID
>
>   typedef enum fe_pilot {
>   	PILOT_ON,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
http://palosaari.fi/
