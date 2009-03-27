Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:55865 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbZC0NCT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 09:02:19 -0400
Received: by rv-out-0506.google.com with SMTP id f9so1241418rvb.1
        for <linux-media@vger.kernel.org>; Fri, 27 Mar 2009 06:02:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090327065726.5e4b4211@pedra.chehab.org>
References: <15ed362e0903170855k2ec1e5afm613de692c237e34d@mail.gmail.com>
	 <20090327065726.5e4b4211@pedra.chehab.org>
Date: Fri, 27 Mar 2009 21:02:17 +0800
Message-ID: <15ed362e0903270602q11a1034ewd16ff386b011d20c@mail.gmail.com>
Subject: Re: [PATCH] Support for Legend Silicon LGS8913/LGS8GL5/LGS8GXX China
	DMB-TH digital demodulator
From: David Wong <davidtlwong@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 27, 2009 at 5:57 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> On Tue, 17 Mar 2009 23:55:05 +0800
> David Wong <davidtlwong@gmail.com> wrote:
>
>> +#undef USE_FAKE_SIGNAL_STRENGTH
>
> Hmm... why do you need this upstream? Is the signal strength working? If so,
> just remove this test code.

I don't know if I should remove the that signal strength code.
LGS8913 codes already use a very slow loop get get signal strength.
It loops from 1 to 915 (for 915 guard intervals), set a register and then read.
Such loop is very slow, that's why I add a fake signal strength.

for LGS8GL5 and newer chips, it reads two register to roughly get the
AGC output value.

seems LGS8913 can use the new method too. Perhaps we can remove the
fake signal strength code.

>
>> +
>> +static void lgs8gxx_auto_lock(struct lgs8gxx_state *priv);
>
> I don't see why do you need to prototype this function.

No problem, to be removed.

>
>> +
>> +static int debug = 0;
>
> Don't initialize static vars to zero. Kernel already does this, and static
> initialization requires eats some space.

No problem.

>
>> +static int lgs8gxx_set_fe(struct dvb_frontend *fe,
>> +                       struct dvb_frontend_parameters *fe_params)
>> +{
>> +     struct lgs8gxx_state *priv = fe->demodulator_priv;
>> +
>> +     dprintk("%s\n", __func__);
>> +
>> +     /* set frequency */
>> +     if (fe->ops.tuner_ops.set_params) {
>> +             fe->ops.tuner_ops.set_params(fe, fe_params);
>> +             if (fe->ops.i2c_gate_ctrl)
>> +                     fe->ops.i2c_gate_ctrl(fe, 0);
>> +     }
>> +
>> +     /* Hardcoded to use auto as much as possible */
>> +     fe_params->u.ofdm.code_rate_HP = FEC_AUTO;
>> +     fe_params->u.ofdm.guard_interval = GUARD_INTERVAL_AUTO;
>> +     fe_params->u.ofdm.transmission_mode = TRANSMISSION_MODE_AUTO;
>
> Hmm... this is weird.
>
> That's said, maybe you may need some DVBS2 API additions for DMB. You should
> propose some API additions and provide a patch for it.

That's the code copied from another frontend when I start the work.
But currently I would like to make it AUTO only.
Yes, I think there is a need for DMB-TH API.
FYI, DMB-TH is union of two modes, single carrier and multi-carrier.
The multi carrier mode is very DVB-T 8MHz alike.
The single carrier mode, I guess, is ATSC like.
I am not very familiar with RF and DTV technology and there is no
single carrier mode broadcast in Hong Kong.
It is very welcome to open a new thread to discuss proposal for DMB-TH API

> +       fe_params->u.ofdm.code_rate_HP = translated_fec;
> +       fe_params->u.ofdm.code_rate_LP = translated_fec;
>
> The gcc optimizer will produce the same code, but this way would be cleaner for
> those who are reading the source code.

OK.

>
>> +static
>> +int lgs8gxx_get_tune_settings(struct dvb_frontend *fe,
>> +                           struct dvb_frontend_tune_settings *fesettings)
>> +{
>> +     /* FIXME: copy from tda1004x.c */
>
> It would be nice if you fix those FIXME's.
>
>> +     fesettings->min_delay_ms = 800;
>> +     /* Drift compensation makes no sense for DVB-T */
>
> DVB-T???

That's the code copy from tda1004x. What is that delay for?

>
>> +static int lgs8gxx_read_snr(struct dvb_frontend *fe, u16 *snr)
>> +{
>> +     struct lgs8gxx_state *priv = fe->demodulator_priv;
>> +     u8 t;
>> +     *snr = 0;
>> +
>> +     lgs8gxx_read_reg(priv, 0x95, &t);
>> +     dprintk("AVG Noise=0x%02X\n", t);
>> +     *snr = 256 - t;
>> +     *snr <<= 8;
>> +     dprintk("snr=0x%x\n", *snr);
>> +
>> +     return 0;
>> +}
>
> I dunno if you are following all those discussions about SNR. We're trying to
> standardize the meaning for all those status reads (SNR, signal strength, etc.
>
> Nothing were decided yet, but while we don't take a decision, the better is if
> you provide some comments at the source code specifying what's the unit for
> each of those status (dB? 0.1 dB steps? dB * 256 ?).

Yes, I read your SNR discussion.
The register read is called average noise magnitude, but I don't know the unit.
There is no description from vendor.

>
>> +static struct dvb_frontend_ops lgs8gxx_ops = {
>> +     .info = {
>> +             .name = "Legend Silicon LGS8913/LGS8GXX DMB-TH",
>> +             .type = FE_OFDM,
>> +             .frequency_min = 474000000,
>> +             .frequency_max = 858000000,
>> +             .frequency_stepsize = 10000,
>> +             .caps =
>> +                 FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
>> +                 FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
>> +                 FE_CAN_QPSK |
>> +                 FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QAM_AUTO |
>> +                 FE_CAN_TRANSMISSION_MODE_AUTO | FE_CAN_GUARD_INTERVAL_AUTO
>> +     },
>
> Also here we should reflect the proper DMB parameters, after the API additions.
>
> ---
>
> Before submitting patches, please check they with checkpatch.pl ( see
> http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches for the submission
> procedures).
>
> Please fix the CodingStyle errors detected by the tool:
>
>

No problem.

Regards,
David
