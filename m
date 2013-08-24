Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:62675 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab3HXQt4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Aug 2013 12:49:56 -0400
Received: by mail-pb0-f50.google.com with SMTP id uo5so1842902pbc.37
        for <linux-media@vger.kernel.org>; Sat, 24 Aug 2013 09:49:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHFNz9+wxS=fu_tDKYwAVhEuirdrNuenRW-A7ybmENgfj_g1SA@mail.gmail.com>
References: <1374682135-26259-1-git-send-email-updatelee@gmail.com>
	<CAHFNz9+wxS=fu_tDKYwAVhEuirdrNuenRW-A7ybmENgfj_g1SA@mail.gmail.com>
Date: Sat, 24 Aug 2013 10:49:55 -0600
Message-ID: <CAA9z4LZs8mHxwz=TRfcuckTGm+gFM2ES-Ht1KtxzYFzgTDgfPg@mail.gmail.com>
Subject: Re: [PATCH 2/2] stv090x: on tuning lock return correct tuned
 paramaters like freq/sr/fec/rolloff/etc
From: Chris Lee <updatelee@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- Bug number 6 on my datasheet is confirmed for cut 1.0 and fixed in
1.1. I dont think there are any cut 1.0 actually in circulation are
there? there is a work around for it, but I dont really see the need
if there arent any 1.0 cut's in pc cards.

- I have to resubmit the patch with better comments, just havent had
time. work is very busy right now. I think blind_search should be the
default, I dont really know a reason why you wouldnt want it.

- state->search_range is used for software zigzag where the demod does
it all in hardware anyways so setting state->search_range to 10mhz
only actually gets used if the demod cant find the signal, in which
case I have yet to see an example where the software zigzag was able
to find signal when the hardware demod could not. So lets not use it
with blindsearch.

Again Im learning, Im new to submitting patch's for public review, Ive
always just done my own thing. I'll resubmit the patch in the future
with more comments. Thanks for being patient.

Chris Lee

On Sat, Aug 24, 2013 at 7:34 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
> On Wed, Jul 24, 2013 at 9:38 PM, Chris Lee <updatelee@gmail.com> wrote:
>>
>> If you need it broken up more just let me know, I look forward to comments, thanks
>>
>
> Sorry about the late comments, have been a bit too busy ..
>
> I have a bit hard time, understanding the need for some of the changes.
> Comments, inline.
>
>
>> Chris
>>
>> ---
>>  drivers/media/dvb-frontends/stv090x.c     | 182 ++++++++++++++++++++++++++++--
>>  drivers/media/dvb-frontends/stv090x_reg.h |   2 +
>>  2 files changed, 172 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
>> index 56d470a..474584f 100644
>> --- a/drivers/media/dvb-frontends/stv090x.c
>> +++ b/drivers/media/dvb-frontends/stv090x.c
>> @@ -1678,6 +1678,7 @@ static u32 stv090x_get_srate(struct stv090x_state *state, u32 clk)
>>                 ((int_1 * tmp_2) >> 16) +
>>                 ((int_2 * tmp_1) >> 16);
>>
>> +       state->srate = srate;
>>         return srate;
>>  }
>>
>> @@ -2592,6 +2593,94 @@ static int stv090x_get_viterbi(struct stv090x_state *state)
>>  static enum stv090x_signal_state stv090x_get_sig_params(struct stv090x_state *state)
>>  {
>>         struct dvb_frontend *fe = &state->frontend;
>> +       struct dtv_frontend_properties *props = &fe->dtv_property_cache;
>> +
>> +       int fe_stv0900_tracking_standard_return[] = {
>> +               SYS_UNDEFINED,
>> +               SYS_DVBS,
>> +               SYS_DVBS2,
>> +               SYS_DSS
>> +       };
>> +
>> +       int fe_stv0900_rolloff_return[] = {
>> +               ROLLOFF_35,
>> +               ROLLOFF_25,
>> +               ROLLOFF_20,
>> +               ROLLOFF_AUTO
>> +       };
>> +
>> +       int fe_stv0900_modulation_return[] = {
>> +               QPSK,
>> +               PSK_8,
>> +               APSK_16,
>> +               APSK_32
>> +       };
>> +
>> +       int fe_stv0900_modcod_return_dvbs[] = {
>> +               FEC_NONE,
>> +               FEC_AUTO,
>> +               FEC_AUTO,
>> +               FEC_AUTO,
>> +               FEC_1_2,
>> +               FEC_3_5,
>> +               FEC_2_3,
>> +               FEC_3_4,
>> +               FEC_4_5,
>> +               FEC_5_6,
>> +               FEC_6_7,
>> +               FEC_7_8,
>> +               FEC_3_5,
>> +               FEC_2_3,
>> +               FEC_3_4,
>> +               FEC_5_6,
>> +               FEC_8_9,
>> +               FEC_9_10,
>> +               FEC_2_3,
>> +               FEC_3_4,
>> +               FEC_4_5,
>> +               FEC_5_6,
>> +               FEC_8_9,
>> +               FEC_9_10,
>> +               FEC_3_4,
>> +               FEC_4_5,
>> +               FEC_5_6,
>> +               FEC_8_9,
>> +               FEC_9_10,
>> +               FEC_AUTO
>> +       };
>> +
>> +       int fe_stv0900_modcod_return_dvbs2[] = {
>> +               FEC_NONE,
>> +               FEC_AUTO,
>> +               FEC_AUTO,
>> +               FEC_AUTO,
>> +               FEC_1_2,
>> +               FEC_3_5,
>> +               FEC_2_3,
>> +               FEC_3_4,
>> +               FEC_4_5,
>> +               FEC_5_6,
>> +               FEC_8_9,
>> +               FEC_9_10,
>> +               FEC_3_5,
>> +               FEC_2_3,
>> +               FEC_3_4,
>> +               FEC_5_6,
>> +               FEC_8_9,
>> +               FEC_9_10,
>> +               FEC_2_3,
>> +               FEC_3_4,
>> +               FEC_4_5,
>> +               FEC_5_6,
>> +               FEC_8_9,
>> +               FEC_9_10,
>> +               FEC_3_4,
>> +               FEC_4_5,
>> +               FEC_5_6,
>> +               FEC_8_9,
>> +               FEC_9_10,
>> +               FEC_AUTO
>> +       };
>>
>>         u8 tmg;
>>         u32 reg;
>> @@ -2631,10 +2720,71 @@ static enum stv090x_signal_state stv090x_get_sig_params(struct stv090x_state *st
>>         state->modcod = STV090x_GETFIELD_Px(reg, DEMOD_MODCOD_FIELD);
>>         state->pilots = STV090x_GETFIELD_Px(reg, DEMOD_TYPE_FIELD) & 0x01;
>>         state->frame_len = STV090x_GETFIELD_Px(reg, DEMOD_TYPE_FIELD) >> 1;
>> -       reg = STV090x_READ_DEMOD(state, TMGOBS);
>> -       state->rolloff = STV090x_GETFIELD_Px(reg, ROLLOFF_STATUS_FIELD);
>> -       reg = STV090x_READ_DEMOD(state, FECM);
>> -       state->inversion = STV090x_GETFIELD_Px(reg, IQINV_FIELD);
>> +       reg = STV090x_READ_DEMOD(state, MATSTR1);
>> +       state->rolloff = STV090x_GETFIELD_Px(reg, MATYPE_ROLLOFF_FIELD);
>> +
>> +       switch (state->delsys) {
>> +       case STV090x_DVBS2:
>> +               if (state->modcod <= STV090x_QPSK_910)
>> +                       state->modulation = STV090x_QPSK;
>> +               else if (state->modcod <= STV090x_8PSK_910)
>> +                       state->modulation = STV090x_8PSK;
>> +               else if (state->modcod <= STV090x_16APSK_910)
>> +                       state->modulation = STV090x_16APSK;
>> +               else if (state->modcod <= STV090x_32APSK_910)
>> +                       state->modulation = STV090x_32APSK;
>> +               else
>> +                       state->modulation = STV090x_UNKNOWN;
>> +               reg = STV090x_READ_DEMOD(state, PLHMODCOD);
>
>
> It is documented with Bug 6, that the demodulator may reject
> the MODCOD being read out. As a result, it is not a good idea to
> report the information, especially knowing that it is buggy.
>
>
>> +               state->inversion = STV090x_GETFIELD_Px(reg, SPECINV_DEMOD_FIELD);
>> +               break;
>> +       case STV090x_DVBS1:
>> +       case STV090x_DSS:
>> +               switch(state->fec) {
>> +               case STV090x_PR12:
>> +                       state->modcod = STV090x_QPSK_12;
>> +                       break;
>> +               case STV090x_PR23:
>> +                       state->modcod = STV090x_QPSK_23;
>> +                       break;
>> +               case STV090x_PR34:
>> +                       state->modcod = STV090x_QPSK_34;
>> +                       break;
>> +               case STV090x_PR45:
>> +                       state->modcod = STV090x_QPSK_45;
>> +                       break;
>> +               case STV090x_PR56:
>> +                       state->modcod = STV090x_QPSK_56;
>> +                       break;
>> +               case STV090x_PR67:
>> +                       state->modcod = STV090x_QPSK_89;
>> +                       break;
>> +               case STV090x_PR78:
>> +                       state->modcod = STV090x_QPSK_910;
>> +                       break;
>> +               default:
>> +                       state->modcod = STV090x_DUMMY_PLF;
>> +                       break;
>> +               }
>> +               state->modulation = STV090x_QPSK;
>> +               reg = STV090x_READ_DEMOD(state, FECM);
>> +               state->inversion = STV090x_GETFIELD_Px(reg, IQINV_FIELD);
>> +               break;
>> +       default:
>> +               break;
>> +       }
>> +
>> +       props->frequency                = state->frequency;
>> +       props->symbol_rate              = state->srate;
>> +       if (state->delsys == 2)
>> +               props->fec_inner        = fe_stv0900_modcod_return_dvbs2[state->modcod];
>> +       else
>> +               props->fec_inner        = fe_stv0900_modcod_return_dvbs[state->modcod];
>> +       props->pilot                    = state->pilots;
>> +       props->rolloff                  = fe_stv0900_rolloff_return[state->rolloff];
>> +       props->modulation               = fe_stv0900_modulation_return[state->modulation];
>> +       props->inversion                = state->inversion;
>> +       props->delivery_system          = fe_stv0900_tracking_standard_return[state->delsys];
>>
>>         if ((state->algo == STV090x_BLIND_SEARCH) || (state->srate < 10000000)) {
>>
>> @@ -2842,6 +2992,7 @@ static int stv090x_optimize_track(struct stv090x_state *state)
>>  {
>>         struct dvb_frontend *fe = &state->frontend;
>>
>> +       enum stv090x_rolloff rolloff;
>>         enum stv090x_modcod modcod;
>>
>>         s32 srate, pilots, aclc, f_1, f_0, i = 0, blind_tune = 0;
>> @@ -2965,6 +3116,7 @@ static int stv090x_optimize_track(struct stv090x_state *state)
>>         f_1 = STV090x_READ_DEMOD(state, CFR2);
>>         f_0 = STV090x_READ_DEMOD(state, CFR1);
>>         reg = STV090x_READ_DEMOD(state, TMGOBS);
>> +       rolloff = STV090x_GETFIELD_Px(reg, ROLLOFF_STATUS_FIELD);
>>
>>         if (state->algo == STV090x_BLIND_SEARCH) {
>>                 STV090x_WRITE_DEMOD(state, SFRSTEP, 0x00);
>> @@ -3464,20 +3616,24 @@ static enum dvbfe_search stv090x_search(struct dvb_frontend *fe)
>>         state->frequency = props->frequency;
>>         state->srate = props->symbol_rate;
>>         state->search_mode = STV090x_SEARCH_AUTO;
>> -       state->algo = STV090x_COLD_SEARCH;
>> +       state->algo = STV090x_BLIND_SEARCH;
>
>
> Why ?
>
>
>
>>         state->fec = STV090x_PRERR;
>> -       if (state->srate > 10000000) {
>> -               dprintk(FE_DEBUG, 1, "Search range: 10 MHz");
>> -               state->search_range = 10000000;
>> -       } else {
>> -               dprintk(FE_DEBUG, 1, "Search range: 5 MHz");
>> -               state->search_range = 5000000;
>> -       }
>> +       state->search_range = 0;
>>
>
>
> Again, why ?
>
>
>>         stv090x_set_mis(state, props->stream_id);
>>
>> +       dprintk(FE_DEBUG, 1, "Search started...");
>>         if (stv090x_algo(state) == STV090x_RANGEOK) {
>> +               stv090x_get_sig_params(state);
>>                 dprintk(FE_DEBUG, 1, "Search success!");
>> +               dprintk(FE_DEBUG, 1, "frequency       = %d", props->frequency);
>> +               dprintk(FE_DEBUG, 1, "symbol_rate     = %d", props->symbol_rate);
>> +               dprintk(FE_DEBUG, 1, "fec_inner       = %d, %d", props->fec_inner, state->modcod);
>> +               dprintk(FE_DEBUG, 1, "pilot           = %d", props->pilot);
>> +               dprintk(FE_DEBUG, 1, "rolloff         = %d", props->rolloff);
>> +               dprintk(FE_DEBUG, 1, "modulation      = %d, %d", props->modulation, state->modulation);
>> +               dprintk(FE_DEBUG, 1, "inversion       = %d", props->inversion);
>> +               dprintk(FE_DEBUG, 1, "delivery_system = %d, %d", props->delivery_system, state->delsys);
>>                 return DVBFE_ALGO_SEARCH_SUCCESS;
>>         } else {
>>                 dprintk(FE_DEBUG, 1, "Search failed!");
>> @@ -3520,6 +3676,7 @@ static int stv090x_read_status(struct dvb_frontend *fe, enum fe_status *status)
>>                                         *status |= FE_HAS_SYNC | FE_HAS_LOCK;
>>                         }
>>                 }
>> +               stv090x_get_sig_params(state);
>>                 break;
>>
>>         case 3: /* DVB-S1/legacy mode */
>> @@ -3533,6 +3690,7 @@ static int stv090x_read_status(struct dvb_frontend *fe, enum fe_status *status)
>>                                         *status |= FE_HAS_SYNC | FE_HAS_LOCK;
>>                         }
>>                 }
>> +               stv090x_get_sig_params(state);
>>                 break;
>>         }
>>
>> diff --git a/drivers/media/dvb-frontends/stv090x_reg.h b/drivers/media/dvb-frontends/stv090x_reg.h
>> index 93741ee..ac6bc30 100644
>> --- a/drivers/media/dvb-frontends/stv090x_reg.h
>> +++ b/drivers/media/dvb-frontends/stv090x_reg.h
>> @@ -1927,6 +1927,8 @@
>>  #define STV090x_P1_MATSTR1                     STV090x_Px_MATSTRy(1, 1)
>>  #define STV090x_P2_MATSTR0                     STV090x_Px_MATSTRy(2, 0)
>>  #define STV090x_P2_MATSTR1                     STV090x_Px_MATSTRy(2, 1)
>> +#define STV090x_OFFST_Px_MATYPE_ROLLOFF_FIELD  0
>> +#define STV090x_WIDTH_Px_MATYPE_ROLLOFF_FIELD  2
>>  #define STV090x_OFFST_Px_MATYPE_CURRENT_FIELD  0
>>  #define STV090x_WIDTH_Px_MATYPE_CURRENT_FIELD  8
>>
>> --
>> 1.8.1.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
