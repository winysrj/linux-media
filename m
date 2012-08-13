Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab2HMS5h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 14:57:37 -0400
Message-ID: <50294E11.1030701@redhat.com>
Date: Mon, 13 Aug 2012 15:57:21 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: CrazyCat <crazycat69@yandex.ru>
CC: Antti Palosaari <crope@iki.fi>, Manu Abraham <manu@linuxtv.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] DVB-S2 multistream support
References: <59951342221302@web18g.yandex.ru> <50258758.8050902@redhat.com> <1981451344725742@web18g.yandex.ru> <5026F209.4030604@iki.fi> <2171791344796403@web4d.yandex.ru> <5027FAF5.7060106@iki.fi>
In-Reply-To: <5027FAF5.7060106@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 12-08-2012 15:50, Antti Palosaari escreveu:
> On 08/12/2012 09:33 PM, CrazyCat wrote:

>> diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
>> index f50d405..32d51bc 100644
>> --- a/include/linux/dvb/frontend.h
>> +++ b/include/linux/dvb/frontend.h
>> @@ -62,6 +62,7 @@ typedef enum fe_caps {
>>       FE_CAN_8VSB            = 0x200000,
>>       FE_CAN_16VSB            = 0x400000,
>>       FE_HAS_EXTENDED_CAPS        = 0x800000,   /* We need more bitspace for newer APIs, indicate this. */
>> +    FE_CAN_MULTISTREAM        = 0x4000000,  /* frontend supports DVB-S2 multistream filtering */
>>       FE_CAN_TURBO_FEC        = 0x8000000,  /* frontend supports "turbo fec modulation" */
>>       FE_CAN_2G_MODULATION        = 0x10000000, /* frontend supports "2nd generation modulation" (DVB-S2) */
>>       FE_NEEDS_BENDING        = 0x20000000, /* not supported anymore, don't use (frontend requires frequency bending) */
>> @@ -314,9 +315,10 @@ struct dvb_frontend_event {
>>
>>   #define DTV_ISDBT_LAYER_ENABLED    41
>>
>> -#define DTV_ISDBS_TS_ID        42
>> -
>> -#define DTV_DVBT2_PLP_ID    43
>> +#define DTV_STREAM_ID        42
>> +#define DTV_ISDBS_TS_ID        DTV_STREAM_ID
>> +#define DTV_DVBT2_PLP_ID    DTV_STREAM_ID
>> +#define DTV_DVBS2_MIS_ID    DTV_STREAM_ID
> 
> Do not define command DTV_DVBS2_MIS_ID at all. It is not never released thus no need to support.

I'd say we need compatibility bits only for the ID's that are already there (ISDBS_TS_ID and DTV_DVBT2_PLP_ID).

> 
> I suspect DTV_DVBT2_PLP_ID is never used by any application, but still it is not possible to change command number from 43 to 42 as this does.
> 
> I am not sure what kind of procedures are needed to remove existing API command number, but surely it is not possible like that. So you have to reserve command 43. Both commands 42 and 43 should continue working.

Rename the one that will be obsoleted with _LEGACY:
	#define DTV_DVBT2_PLP_ID_LEGACY    43

and keep accepting it inside the dvb_frontend, like: 

	switch (...) {
	case DTV_DVBT2_PLP_ID_LEGACY:
	case DTV_STREAM_ID:
		...
	}
	
This way, app developers will notice that this got removed and binary code will keep working.

> 
> DTV_DVBT2_PLP_ID should be marked as deprecated and after that it could be removed somewhere in future.
> 
>>
>>   #define DTV_ENUM_DELSYS        44
>>
>> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
>> index aebcdf2..8fb7eac 100644
>> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
>> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
>> @@ -946,8 +946,7 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
>>           c->layer[i].segment_count = 0;
>>       }
>>
>> -    c->isdbs_ts_id = 0;
>> -    c->dvbt2_plp_id = 0;
>> +    c->stream_id = -1;
> 
> You have defined it as a unsigned 32 thus -1 is not possible value. Maybe 0 is still good default choice.
> 
>>       switch (c->delivery_system) {
>>       case SYS_DVBS:
>> @@ -1017,8 +1016,7 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
>>       _DTV_CMD(DTV_ISDBT_LAYERC_SEGMENT_COUNT, 1, 0),
>>       _DTV_CMD(DTV_ISDBT_LAYERC_TIME_INTERLEAVING, 1, 0),
>>
>> -    _DTV_CMD(DTV_ISDBS_TS_ID, 1, 0),
>> -    _DTV_CMD(DTV_DVBT2_PLP_ID, 1, 0),
> 
> DTV_DVBT2_PLP_ID cannot be removed yet (but DTV_ISDBS_TS_ID can be as it is renamed, it is OK).
> 
>> +    _DTV_CMD(DTV_STREAM_ID, 1, 0),
>>
>>       /* Get */
>>       _DTV_CMD(DTV_DISEQC_SLAVE_REPLY, 0, 1),
>> @@ -1382,11 +1380,9 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
>>       case DTV_ISDBT_LAYERC_TIME_INTERLEAVING:
>>           tvp->u.data = c->layer[2].interleaving;
>>           break;
>> -    case DTV_ISDBS_TS_ID:
>> -        tvp->u.data = c->isdbs_ts_id;
>> -        break;
>> -    case DTV_DVBT2_PLP_ID:
>> -        tvp->u.data = c->dvbt2_plp_id;
> 
> DTV_DVBT2_PLP_ID cannot be removed yet (but DTV_ISDBS_TS_ID can be as it is renamed, it is OK).
> 
>> +
>> +    case DTV_STREAM_ID:
>> +        tvp->u.data = c->stream_id;
>>           break;
>>
>>       /* ATSC-MH */
>> @@ -1771,11 +1767,8 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
>>       case DTV_ISDBT_LAYERC_TIME_INTERLEAVING:
>>           c->layer[2].interleaving = tvp->u.data;
>>           break;
>> -    case DTV_ISDBS_TS_ID:
>> -        c->isdbs_ts_id = tvp->u.data;
>> -        break;
>> -    case DTV_DVBT2_PLP_ID:
>> -        c->dvbt2_plp_id = tvp->u.data;
> 
> DTV_DVBT2_PLP_ID cannot be removed yet (but DTV_ISDBS_TS_ID can be as it is renamed, it is OK).
> 
>> +    case DTV_STREAM_ID:
>> +        c->stream_id = tvp->u.data;
>>           break;
>>
>>       /* ATSC-MH */
>> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
>> index 7c64c09..bec0cda 100644
>> --- a/drivers/media/dvb/dvb-core/dvb_frontend.h
>> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
>> @@ -368,11 +368,8 @@ struct dtv_frontend_properties {
>>           u8            interleaving;
>>       } layer[3];
>>
>> -    /* ISDB-T specifics */
>> -    u32            isdbs_ts_id;
>> -
>> -    /* DVB-T2 specifics */
>> -    u32                     dvbt2_plp_id;
>> +    /* Multistream specifics */
>> +    u32            stream_id;
> 
> These are correct!
> 
>>
>>       /* ATSC-MH specifics */
>>       u8            atscmh_fic_ver;
>> diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb/frontends/stv090x.c
>> index ea86a56..13caec0 100644
>> --- a/drivers/media/dvb/frontends/stv090x.c
>> +++ b/drivers/media/dvb/frontends/stv090x.c

I prefer if you could split the DVB API changes from the driver changes.

Also, you'll need to patch Documentation/DocBook, in order to reflect those
API changes. 

Regards,
Mauro

>> @@ -3425,6 +3425,33 @@ err:
>>       return -1;
>>   }
>>
>> +static int stv090x_set_mis(struct stv090x_state *state, int mis)
>> +{
>> +    u32 reg;
>> +
>> +    if (mis < 0 || mis > 255) {
>> +        dprintk(FE_DEBUG, 1, "Disable MIS filtering");
>> +        reg = STV090x_READ_DEMOD(state, PDELCTRL1);
>> +        STV090x_SETFIELD_Px(reg, FILTER_EN_FIELD, 0x00);
>> +        if (STV090x_WRITE_DEMOD(state, PDELCTRL1, reg) < 0)
>> +            goto err;
>> +    } else {
>> +        dprintk(FE_DEBUG, 1, "Enable MIS filtering - %d", mis);
>> +        reg = STV090x_READ_DEMOD(state, PDELCTRL1);
>> +        STV090x_SETFIELD_Px(reg, FILTER_EN_FIELD, 0x01);
>> +        if (STV090x_WRITE_DEMOD(state, PDELCTRL1, reg) < 0)
>> +            goto err;
>> +        if (STV090x_WRITE_DEMOD(state, ISIENTRY, mis) < 0)
>> +            goto err;
>> +        if (STV090x_WRITE_DEMOD(state, ISIBITENA, 0xff) < 0)
>> +            goto err;
>> +    }
>> +    return 0;
>> +err:
>> +    dprintk(FE_ERROR, 1, "I/O error");
>> +    return -1;
>> +}
>> +
>>   static enum dvbfe_search stv090x_search(struct dvb_frontend *fe)
>>   {
>>       struct stv090x_state *state = fe->demodulator_priv;
>> @@ -3447,6 +3474,8 @@ static enum dvbfe_search stv090x_search(struct dvb_frontend *fe)
>>           state->search_range = 5000000;
>>       }
>>
>> +    stv090x_set_mis(state, props->stream_id);
>> +
>>       if (stv090x_algo(state) == STV090x_RANGEOK) {
>>           dprintk(FE_DEBUG, 1, "Search success!");
>>           return DVBFE_ALGO_SEARCH_SUCCESS;
>> @@ -4798,6 +4827,9 @@ struct dvb_frontend *stv090x_attach(const struct stv090x_config *config,
>>           }
>>       }
>>
>> +    if (state->internal->dev_ver >= 0x30)
>> +        state->frontend.ops.info.caps |= FE_CAN_MULTISTREAM;
>> +
>>       /* workaround for stuck DiSEqC output */
>>       if (config->diseqc_envelope_mode)
>>           stv090x_send_diseqc_burst(&state->frontend, SEC_MINI_A);
>>
> 
> Only functional problem is here that it removes DTV_DVBT2_PLP_ID command 43 from the API whilst there could be some applications using that. It should be deprecated (marked as do not use or like that) and then removed in future.
> 
> regards
> Antti
> 
> 

