Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:41583 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759985AbZDAHfM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Apr 2009 03:35:12 -0400
Received: by rv-out-0506.google.com with SMTP id f9so3478902rvb.1
        for <linux-media@vger.kernel.org>; Wed, 01 Apr 2009 00:35:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090327065726.5e4b4211@pedra.chehab.org>
References: <15ed362e0903170855k2ec1e5afm613de692c237e34d@mail.gmail.com>
	 <20090327065726.5e4b4211@pedra.chehab.org>
Date: Wed, 1 Apr 2009 15:35:10 +0800
Message-ID: <15ed362e0904010035w7428c9b1saea12978d4ccc218@mail.gmail.com>
Subject: Re: [PATCH] Support for Legend Silicon LGS8913/LGS8GL5/LGS8GXX China
	DMB-TH digital demodulator
From: David Wong <davidtlwong@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0cd14dee017dee0466795bf6
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--000e0cd14dee017dee0466795bf6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Resubmit after code clean up.
This patch contains the unified driver for Legend Silicon LGS8913 and
LGS8GL5. It should replace lgs8gl5.c in media/dvb/frontends in the future.

Signed-off-by: David T.L. Wong <davidtlwong@gmail.com>

On Fri, Mar 27, 2009 at 5:57 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> On Tue, 17 Mar 2009 23:55:05 +0800
> David Wong <davidtlwong@gmail.com> wrote:
>
>> +#undef USE_FAKE_SIGNAL_STRENGTH
>
> Hmm... why do you need this upstream? Is the signal strength working? If =
so,
> just remove this test code.
>
>> +
>> +static void lgs8gxx_auto_lock(struct lgs8gxx_state *priv);
>
> I don't see why do you need to prototype this function.
>
>> +
>> +static int debug =3D 0;
>
> Don't initialize static vars to zero. Kernel already does this, and stati=
c
> initialization requires eats some space.
>
>> +static int lgs8gxx_set_fe(struct dvb_frontend *fe,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 struct dvb_frontend_parameters *fe_params)
>> +{
>> + =C2=A0 =C2=A0 struct lgs8gxx_state *priv =3D fe->demodulator_priv;
>> +
>> + =C2=A0 =C2=A0 dprintk("%s\n", __func__);
>> +
>> + =C2=A0 =C2=A0 /* set frequency */
>> + =C2=A0 =C2=A0 if (fe->ops.tuner_ops.set_params) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fe->ops.tuner_ops.set_params=
(fe, fe_params);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (fe->ops.i2c_gate_ctrl)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
fe->ops.i2c_gate_ctrl(fe, 0);
>> + =C2=A0 =C2=A0 }
>> +
>> + =C2=A0 =C2=A0 /* Hardcoded to use auto as much as possible */
>> + =C2=A0 =C2=A0 fe_params->u.ofdm.code_rate_HP =3D FEC_AUTO;
>> + =C2=A0 =C2=A0 fe_params->u.ofdm.guard_interval =3D GUARD_INTERVAL_AUTO=
;
>> + =C2=A0 =C2=A0 fe_params->u.ofdm.transmission_mode =3D TRANSMISSION_MOD=
E_AUTO;
>
> Hmm... this is weird.
>
> That's said, maybe you may need some DVBS2 API additions for DMB. You sho=
uld
> propose some API additions and provide a patch for it.
>
>> + =C2=A0 =C2=A0 /* FEC. No exact match for DMB-TH, pick approx. value */
>> + =C2=A0 =C2=A0 switch(t & LGS_FEC_MASK) {
>> + =C2=A0 =C2=A0 case =C2=A0LGS_FEC_0_4: /* FEC 0.4 */
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 translated_fec =3D FEC_1_2;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
>> + =C2=A0 =C2=A0 case =C2=A0LGS_FEC_0_6: /* FEC 0.6 */
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 translated_fec =3D FEC_2_3;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
>> + =C2=A0 =C2=A0 case =C2=A0LGS_FEC_0_8: /* FEC 0.8 */
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 translated_fec =3D FEC_5_6;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
>> + =C2=A0 =C2=A0 default:
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 translated_fec =3D FEC_1_2;
>> + =C2=A0 =C2=A0 }
>
> Same here: if there's no exact match, we should first patch the core file=
s to
> improve the API, and then use the correct values.
>
>> + =C2=A0 =C2=A0 fe_params->u.ofdm.code_rate_HP =3D
>> + =C2=A0 =C2=A0 fe_params->u.ofdm.code_rate_LP =3D translated_fec;
>
> The above seems weird. It would be better to do:
>
> + =C2=A0 =C2=A0 =C2=A0 fe_params->u.ofdm.code_rate_HP =3D translated_fec;
> + =C2=A0 =C2=A0 =C2=A0 fe_params->u.ofdm.code_rate_LP =3D translated_fec;
>
> The gcc optimizer will produce the same code, but this way would be clean=
er for
> those who are reading the source code.
>
>> +static
>> +int lgs8gxx_get_tune_settings(struct dvb_frontend *fe,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 struct dvb_frontend_tune_settings *fesettings)
>> +{
>> + =C2=A0 =C2=A0 /* FIXME: copy from tda1004x.c */
>
> It would be nice if you fix those FIXME's.
>
>> + =C2=A0 =C2=A0 fesettings->min_delay_ms =3D 800;
>> + =C2=A0 =C2=A0 /* Drift compensation makes no sense for DVB-T */
>
> DVB-T???
>
>> +static int lgs8gxx_read_snr(struct dvb_frontend *fe, u16 *snr)
>> +{
>> + =C2=A0 =C2=A0 struct lgs8gxx_state *priv =3D fe->demodulator_priv;
>> + =C2=A0 =C2=A0 u8 t;
>> + =C2=A0 =C2=A0 *snr =3D 0;
>> +
>> + =C2=A0 =C2=A0 lgs8gxx_read_reg(priv, 0x95, &t);
>> + =C2=A0 =C2=A0 dprintk("AVG Noise=3D0x%02X\n", t);
>> + =C2=A0 =C2=A0 *snr =3D 256 - t;
>> + =C2=A0 =C2=A0 *snr <<=3D 8;
>> + =C2=A0 =C2=A0 dprintk("snr=3D0x%x\n", *snr);
>> +
>> + =C2=A0 =C2=A0 return 0;
>> +}
>
> I dunno if you are following all those discussions about SNR. We're tryin=
g to
> standardize the meaning for all those status reads (SNR, signal strength,=
 etc.
>
> Nothing were decided yet, but while we don't take a decision, the better =
is if
> you provide some comments at the source code specifying what's the unit f=
or
> each of those status (dB? 0.1 dB steps? dB * 256 ?).
>
>> +static struct dvb_frontend_ops lgs8gxx_ops =3D {
>> + =C2=A0 =C2=A0 .info =3D {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .name =3D "Legend Silicon LG=
S8913/LGS8GXX DMB-TH",
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .type =3D FE_OFDM,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .frequency_min =3D 474000000=
,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .frequency_max =3D 858000000=
,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .frequency_stepsize =3D 1000=
0,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .caps =3D
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FE_CAN_FEC_1_2=
 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FE_CAN_FEC_5_6=
 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FE_CAN_QPSK |
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FE_CAN_QAM_16 =
| FE_CAN_QAM_64 | FE_CAN_QAM_AUTO |
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FE_CAN_TRANSMI=
SSION_MODE_AUTO | FE_CAN_GUARD_INTERVAL_AUTO
>> + =C2=A0 =C2=A0 },
>
> Also here we should reflect the proper DMB parameters, after the API addi=
tions.
>
> ---
>
> Before submitting patches, please check they with checkpatch.pl ( see
> http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches for the submiss=
ion
> procedures).
>
> Please fix the CodingStyle errors detected by the tool:
>
>
> ERROR: do not initialise statics to 0 or NULL
> #91: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:43:
> +static int debug =3D 0;
>
> WARNING: printk() should include KERN_ facility level
> #145: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:97:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk("%s: reg=3D0x%0=
2X, data=3D0x%02X\n", __func__, reg, b1[0]);
>
> ERROR: do not use C99 // comments
> #164: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:116:
> + =C2=A0 =C2=A0 =C2=A0 if_conf =3D 0x10; // AGC output on;
>
> ERROR: spaces required around that ':' (ctx:VxV)
> #167: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:119:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ((config->ext_adc) ? 0=
x80:0x00) |
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^
>
> ERROR: spaces required around that ':' (ctx:VxV)
> #168: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:120:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ((config->if_neg_cente=
r) ? 0x04:0x00) |
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 ^
>
> ERROR: spaces required around that ':' (ctx:VxV)
> #169: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:121:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ((config->if_freq =3D=
=3D 0) ? 0x08:0x00) | /* Baseband */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0^
>
> ERROR: spaces required around that ':' (ctx:VxV)
> #170: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:122:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ((config->ext_adc && c=
onfig->adc_signed) ? 0x02:0x00) |
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^
>
> ERROR: spaces required around that ':' (ctx:VxV)
> #171: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:123:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ((config->ext_adc && c=
onfig->if_neg_edge) ? 0x01:0x00);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0^
>
> WARNING: braces {} are not necessary for single statement blocks
> #216: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:168:
> + =C2=A0 =C2=A0 =C2=A0 if (priv->config->prod =3D=3D LGS8GXX_PROD_LGS8913=
) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lgs8gxx_write_reg(priv=
, 0xC6, 0x01);
> + =C2=A0 =C2=A0 =C2=A0 }
>
> ERROR: do not use C99 // comments
> #223: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:175:
> + =C2=A0 =C2=A0 =C2=A0 // clear FEC self reset
>
> WARNING: braces {} are not necessary for single statement blocks
> #244: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:196:
> + =C2=A0 =C2=A0 =C2=A0 if (priv->config->prod =3D=3D LGS8GXX_PROD_LGS8G52=
) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lgs8gxx_write_reg(priv=
, 0xD9, 0x40);
> + =C2=A0 =C2=A0 =C2=A0 }
>
> ERROR: trailing whitespace
> #300: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:252:
> +^Iint err; $
>
> ERROR: space required after that ',' (ctx:VxV)
> #327: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:279:
> + =C2=A0 =C2=A0 =C2=A0 int i,j;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^
>
> ERROR: spaces required around that '=3D' (ctx:WxV)
> #338: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:290:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (j =3D0 ; j < 2; j=
++) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 ^
>
> ERROR: trailing statements should be on next line
> #341: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:293:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 if (err) goto out;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 if (err) goto out;
> ERROR: trailing statements should be on next line
> #342: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:294:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 if (locked) goto locked;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 if (locked) goto locked;
> ERROR: spaces required around that '=3D' (ctx:WxV)
> #344: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:296:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (j =3D0 ; j < 2; j=
++) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 ^
>
> ERROR: trailing statements should be on next line
> #347: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:299:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 if (err) goto out;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 if (err) goto out;
> ERROR: trailing statements should be on next line
> #348: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:300:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 if (locked) goto locked;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 if (locked) goto locked;
> ERROR: trailing statements should be on next line
> #352: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:304:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (err) goto out;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (err) goto out;
> ERROR: trailing statements should be on next line
> #353: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:305:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (locked) goto locke=
d;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (locked) goto locke=
d;
> ERROR: do not use C99 // comments
> #381: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:333:
> + =C2=A0 =C2=A0 =C2=A0 //u8 ctrl_frame =3D 0, mode =3D 0, rate =3D 0;
>
> ERROR: trailing whitespace
> #395: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:347:
> +^I$
>
> WARNING: braces {} are not necessary for single statement blocks
> #404: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:356:
> + =C2=A0 =C2=A0 =C2=A0 if (priv->config->prod =3D=3D LGS8GXX_PROD_LGS8913=
) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lgs8gxx_write_reg(priv=
, 0xC0, detected_param);
> + =C2=A0 =C2=A0 =C2=A0 }
>
> ERROR: do not use C99 // comments
> #407: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:359:
> + =C2=A0 =C2=A0 =C2=A0 //lgs8gxx_soft_reset(priv);
>
> WARNING: suspect code indent for conditional statements (8, 8)
> #412: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:364:
> + =C2=A0 =C2=A0 =C2=A0 if (gi =3D=3D 0x2)
> + =C2=A0 =C2=A0 =C2=A0 switch(gi) {
>
> ERROR: space required before the open parenthesis '('
> #413: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:365:
> + =C2=A0 =C2=A0 =C2=A0 switch(gi) {
>
> ERROR: trailing whitespace
> #467: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:419:
> +^Ilgs8gxx_write_reg(priv, 0x2C, 0); $
>
> WARNING: line over 80 characters
> #477: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:429:
> + =C2=A0 =C2=A0 =C2=A0 struct lgs8gxx_state *priv =3D (struct lgs8gxx_sta=
te *)fe->demodulator_priv;
>
> WARNING: braces {} are not necessary for single statement blocks
> #493: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:445:
> + =C2=A0 =C2=A0 =C2=A0 if (config->prod =3D=3D LGS8GXX_PROD_LGS8913) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lgs8913_init(priv);
> + =C2=A0 =C2=A0 =C2=A0 }
>
> WARNING: suspect code indent for conditional statements (8, 8)
> #550: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:502:
> + =C2=A0 =C2=A0 =C2=A0 if ((fe_params->u.ofdm.code_rate_HP =3D=3D FEC_AUT=
O) ||
> [...]
> + =C2=A0 =C2=A0 =C2=A0 } else {
>
> ERROR: space required before the open parenthesis '('
> #629: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:581:
> + =C2=A0 =C2=A0 =C2=A0 switch(t & LGS_FEC_MASK) {
>
> ERROR: space required before the open parenthesis '('
> #646: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:598:
> + =C2=A0 =C2=A0 =C2=A0 switch(t & SC_MASK) {
>
> WARNING: line over 80 characters
> #707: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:659:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 *fe_status |=3D FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
>
> ERROR: trailing whitespace
> #724: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:676:
> +^Idprintk("%s()\n", __func__);^I$
>
> ERROR: space prohibited before that close parenthesis ')'
> #734: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:686:
> + =C2=A0 =C2=A0 =C2=A0 if (v < 0x100 )
>
> ERROR: trailing whitespace
> #748: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:700:
> +^I^I$
>
> ERROR: trailing whitespace
> #818: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:770:
> +^I$
>
> ERROR: "foo* bar" should be "foo *bar"
> #865: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:817:
> +static int lgs8gxx_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)
>
> WARNING: braces {} are not necessary for any arm of this statement
> #871: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:823:
> + =C2=A0 =C2=A0 =C2=A0 if (enable) {
> [...]
> + =C2=A0 =C2=A0 =C2=A0 } else {
> [...]
>
> WARNING: line over 80 characters
> #872: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:824:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return lgs8gxx_write_r=
eg(priv, 0x01, 0x80 | priv->config->tuner_address);
>
> ERROR: do not use C99 // comments
> #896: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:848:
> + =C2=A0 =C2=A0 =C2=A0 //.sleep =3D lgs8gxx_sleep,
>
> ERROR: space required after that ',' (ctx:VxV)
> #917: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:869:
> + =C2=A0 =C2=A0 =C2=A0 dprintk("%s()\n",__func__);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0^
>
> ERROR: trailing whitespace
> #1111: FILE: linux/drivers/media/dvb/frontends/lgs8gxx_priv.h:58:
> +#define GI_595^I0x01^I$
>
>
>
> Cheers,
> Mauro
>

--000e0cd14dee017dee0466795bf6
Content-Type: text/x-patch; charset=US-ASCII; name="lgs8gxx.patch"
Content-Disposition: attachment; filename="lgs8gxx.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fszp9qhy0

ZGlmZiAtciA2ZjA4ODlmZGEzMTcgbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZnJvbnRlbmRzL0tj
b25maWcKLS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZnJvbnRlbmRzL0tjb25maWcJTW9u
IE1hciAwMiAxMDo0MDo1MiAyMDA5ICswMTAwCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZi
L2Zyb250ZW5kcy9LY29uZmlnCVdlZCBBcHIgMDEgMTU6Mjg6MDQgMjAwOSArMDgwMApAQCAtNTEz
LDYgKzUxMywxMyBAQAogCWhlbHAKIAkgIEEgRE1CLVRIIHR1bmVyIG1vZHVsZS4gU2F5IFkgd2hl
biB5b3Ugd2FudCB0byBzdXBwb3J0IHRoaXMgZnJvbnRlbmQuCiAKK2NvbmZpZyBEVkJfTEdTOEdY
WAorCXRyaXN0YXRlICJMZWdlbmQgU2lsaWNvbiBMR1M4OTEzL0xHUzhHTDUvTEdTOEdYWCBETUIt
VEggZGVtb2R1bGF0b3IiCisJZGVwZW5kcyBvbiBEVkJfQ09SRSAmJiBJMkMKKwlkZWZhdWx0IG0g
aWYgRFZCX0ZFX0NVU1RPTUlTRQorCWhlbHAKKwkgIEEgRE1CLVRIIHR1bmVyIG1vZHVsZS4gU2F5
IFkgd2hlbiB5b3Ugd2FudCB0byBzdXBwb3J0IHRoaXMgZnJvbnRlbmQuCisKIGNvbW1lbnQgIlRv
b2xzIHRvIGRldmVsb3AgbmV3IGZyb250ZW5kcyIKIAogY29uZmlnIERWQl9EVU1NWV9GRQpkaWZm
IC1yIDZmMDg4OWZkYTMxNyBsaW51eC9kcml2ZXJzL21lZGlhL2R2Yi9mcm9udGVuZHMvTWFrZWZp
bGUKLS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZnJvbnRlbmRzL01ha2VmaWxlCU1vbiBN
YXIgMDIgMTA6NDA6NTIgMjAwOSArMDEwMAorKysgYi9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9m
cm9udGVuZHMvTWFrZWZpbGUJV2VkIEFwciAwMSAxNToyODowNCAyMDA5ICswODAwCkBAIC02MCw2
ICs2MCw3IEBACiBvYmotJChDT05GSUdfRFZCX1RVTkVSX0NYMjQxMTMpICs9IGN4MjQxMTMubwog
b2JqLSQoQ09ORklHX0RWQl9TNUgxNDExKSArPSBzNWgxNDExLm8KIG9iai0kKENPTkZJR19EVkJf
TEdTOEdMNSkgKz0gbGdzOGdsNS5vCitvYmotJChDT05GSUdfRFZCX0xHUzhHWFgpICs9IGxnczhn
eHgubwogb2JqLSQoQ09ORklHX0RWQl9EVU1NWV9GRSkgKz0gZHZiX2R1bW15X2ZlLm8KIG9iai0k
KENPTkZJR19EVkJfQUY5MDEzKSArPSBhZjkwMTMubwogb2JqLSQoQ09ORklHX0RWQl9DWDI0MTE2
KSArPSBjeDI0MTE2Lm8KZGlmZiAtciA2ZjA4ODlmZGEzMTcgbGludXgvZHJpdmVycy9tZWRpYS9k
dmIvZnJvbnRlbmRzL2xnczhneHguYwotLS0gL2Rldi9udWxsCVRodSBKYW4gMDEgMDA6MDA6MDAg
MTk3MCArMDAwMAorKysgYi9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9mcm9udGVuZHMvbGdzOGd4
eC5jCVdlZCBBcHIgMDEgMTU6Mjg6MDQgMjAwOSArMDgwMApAQCAtMCwwICsxLDg1OSBAQAorLyoK
KyAqICAgIFN1cHBvcnQgZm9yIExlZ2VuZCBTaWxpY29uIERNQi1USCBkZW1vZHVsYXRvcgorICog
ICAgTEdTODkxMywgTEdTOEdMNQorICogICAgZXhwZXJpbWVudGFsIHN1cHBvcnQgTEdTOEc0Miwg
TEdTOEc1MgorICoKKyAqICAgIENvcHlyaWdodCAoQykgMjAwNywyMDA4IERhdmlkIFQuTC4gV29u
ZyA8ZGF2aWR0bHdvbmdAZ21haWwuY29tPgorICogICAgQ29weXJpZ2h0IChDKSAyMDA4IFNpcml1
cyBJbnRlcm5hdGlvbmFsIChIb25nIEtvbmcpIExpbWl0ZWQKKyAqICAgIFRpbW90aHkgTGVlIDx0
aW1vdGh5LmxlZUBzaXJpdXNoay5jb20+IChmb3IgaW5pdGlhbCB3b3JrIG9uIExHUzhHTDUpCisg
KgorICogICAgVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmli
dXRlIGl0IGFuZC9vciBtb2RpZnkKKyAqICAgIGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05V
IEdlbmVyYWwgUHVibGljIExpY2Vuc2UgYXMgcHVibGlzaGVkIGJ5CisgKiAgICB0aGUgRnJlZSBT
b2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbiAyIG9mIHRoZSBMaWNlbnNlLCBvcgor
ICogICAgKGF0IHlvdXIgb3B0aW9uKSBhbnkgbGF0ZXIgdmVyc2lvbi4KKyAqCisgKiAgICBUaGlz
IHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgaW4gdGhlIGhvcGUgdGhhdCBpdCB3aWxsIGJlIHVzZWZ1
bCwKKyAqICAgIGJ1dCBXSVRIT1VUIEFOWSBXQVJSQU5UWTsgd2l0aG91dCBldmVuIHRoZSBpbXBs
aWVkIHdhcnJhbnR5IG9mCisgKiAgICBNRVJDSEFOVEFCSUxJVFkgb3IgRklUTkVTUyBGT1IgQSBQ
QVJUSUNVTEFSIFBVUlBPU0UuICBTZWUgdGhlCisgKiAgICBHTlUgR2VuZXJhbCBQdWJsaWMgTGlj
ZW5zZSBmb3IgbW9yZSBkZXRhaWxzLgorICoKKyAqICAgIFlvdSBzaG91bGQgaGF2ZSByZWNlaXZl
ZCBhIGNvcHkgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlCisgKiAgICBhbG9uZyB3
aXRoIHRoaXMgcHJvZ3JhbTsgaWYgbm90LCB3cml0ZSB0byB0aGUgRnJlZSBTb2Z0d2FyZQorICog
ICAgRm91bmRhdGlvbiwgSW5jLiwgNjc1IE1hc3MgQXZlLCBDYW1icmlkZ2UsIE1BIDAyMTM5LCBV
U0EuCisgKgorICovCisKKyNpbmNsdWRlIDxhc20vZGl2NjQuaD4KKworI2luY2x1ZGUgImR2Yl9m
cm9udGVuZC5oIgorCisjaW5jbHVkZSAibGdzOGd4eC5oIgorI2luY2x1ZGUgImxnczhneHhfcHJp
di5oIgorCisjZGVmaW5lIGRwcmludGsoYXJncy4uLikgXAorCWRvIHsgXAorCQlpZiAoZGVidWcp
IFwKKwkJCXByaW50ayhLRVJOX0RFQlVHICJsZ3M4Z3h4OiAiIGFyZ3MpOyBcCisJfSB3aGlsZSAo
MCkKKworc3RhdGljIGludCBkZWJ1ZzsKK3N0YXRpYyBpbnQgZmFrZV9zaWduYWxfc3RyOworCitt
b2R1bGVfcGFyYW0oZGVidWcsIGludCwgMDY0NCk7CitNT0RVTEVfUEFSTV9ERVNDKGRlYnVnLCAi
VHVybiBvbi9vZmYgZnJvbnRlbmQgZGVidWdnaW5nIChkZWZhdWx0Om9mZikuIik7CisKK21vZHVs
ZV9wYXJhbShmYWtlX3NpZ25hbF9zdHIsIGludCwgMDY0NCk7CitNT0RVTEVfUEFSTV9ERVNDKGZh
a2Vfc2lnbmFsX3N0ciwgImZha2Ugc2lnbmFsIHN0cmVuZ3RoIGZvciBMR1M4OTEzLiIKKyJTaWdu
YWwgc3RyZW5ndGggY2FsY3VsYXRpb24gaXMgc2xvdy4oZGVmYXVsdDpvZmYpLiIpOworCisvKiBM
R1M4R1hYIGludGVybmFsIGhlbHBlciBmdW5jdGlvbnMgKi8KKworc3RhdGljIGludCBsZ3M4Z3h4
X3dyaXRlX3JlZyhzdHJ1Y3QgbGdzOGd4eF9zdGF0ZSAqcHJpdiwgdTggcmVnLCB1OCBkYXRhKQor
eworCWludCByZXQ7CisJdTggYnVmW10gPSB7IHJlZywgZGF0YSB9OworCXN0cnVjdCBpMmNfbXNn
IG1zZyA9IHsgLmZsYWdzID0gMCwgLmJ1ZiA9IGJ1ZiwgLmxlbiA9IDIgfTsKKworCW1zZy5hZGRy
ID0gcHJpdi0+Y29uZmlnLT5kZW1vZF9hZGRyZXNzOworCWlmIChyZWcgPj0gMHhDMCkKKwkJbXNn
LmFkZHIgKz0gMHgwMjsKKworCWlmIChkZWJ1ZyA+PSAyKQorCQlwcmludGsoS0VSTl9ERUJVRyAi
JXM6IHJlZz0weCUwMlgsIGRhdGE9MHglMDJYXG4iLAorCQkJX19mdW5jX18sIHJlZywgZGF0YSk7
CisKKwlyZXQgPSBpMmNfdHJhbnNmZXIocHJpdi0+aTJjLCAmbXNnLCAxKTsKKworCWlmIChyZXQg
IT0gMSkKKwkJZHByaW50ayhLRVJOX0RFQlVHICIlczogZXJyb3IgcmVnPTB4JXgsIGRhdGE9MHgl
eCwgcmV0PSVpXG4iLAorCQkJX19mdW5jX18sIHJlZywgZGF0YSwgcmV0KTsKKworCXJldHVybiAo
cmV0ICE9IDEpID8gLTEgOiAwOworfQorCitzdGF0aWMgaW50IGxnczhneHhfcmVhZF9yZWcoc3Ry
dWN0IGxnczhneHhfc3RhdGUgKnByaXYsIHU4IHJlZywgdTggKnBfZGF0YSkKK3sKKwlpbnQgcmV0
OworCXU4IGRldl9hZGRyOworCisJdTggYjBbXSA9IHsgcmVnIH07CisJdTggYjFbXSA9IHsgMCB9
OworCXN0cnVjdCBpMmNfbXNnIG1zZ1tdID0geworCQl7IC5mbGFncyA9IDAsIC5idWYgPSBiMCwg
LmxlbiA9IDEgfSwKKwkJeyAuZmxhZ3MgPSBJMkNfTV9SRCwgLmJ1ZiA9IGIxLCAubGVuID0gMSB9
LAorCX07CisKKwlkZXZfYWRkciA9IHByaXYtPmNvbmZpZy0+ZGVtb2RfYWRkcmVzczsKKwlpZiAo
cmVnID49IDB4QzApCisJCWRldl9hZGRyICs9IDB4MDI7CisJbXNnWzFdLmFkZHIgPSAgbXNnWzBd
LmFkZHIgPSBkZXZfYWRkcjsKKworCXJldCA9IGkyY190cmFuc2Zlcihwcml2LT5pMmMsIG1zZywg
Mik7CisJaWYgKHJldCAhPSAyKSB7CisJCWRwcmludGsoS0VSTl9ERUJVRyAiJXM6IGVycm9yIHJl
Zz0weCV4LCByZXQ9JWlcbiIsCisJCQlfX2Z1bmNfXywgcmVnLCByZXQpOworCQlyZXR1cm4gLTE7
CisJfQorCisJKnBfZGF0YSA9IGIxWzBdOworCWlmIChkZWJ1ZyA+PSAyKQorCQlwcmludGsoS0VS
Tl9ERUJVRyAiJXM6IHJlZz0weCUwMlgsIGRhdGE9MHglMDJYXG4iLAorCQkJX19mdW5jX18sIHJl
ZywgYjFbMF0pOworCXJldHVybiAwOworfQorCitzdGF0aWMgaW50IGxnczhneHhfc29mdF9yZXNl
dChzdHJ1Y3QgbGdzOGd4eF9zdGF0ZSAqcHJpdikKK3sKKwlsZ3M4Z3h4X3dyaXRlX3JlZyhwcml2
LCAweDAyLCAweDAwKTsKKwltc2xlZXAoMSk7CisJbGdzOGd4eF93cml0ZV9yZWcocHJpdiwgMHgw
MiwgMHgwMSk7CisJbXNsZWVwKDEwMCk7CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGludCBs
Z3M4Z3h4X3NldF9hZF9tb2RlKHN0cnVjdCBsZ3M4Z3h4X3N0YXRlICpwcml2KQoreworCWNvbnN0
IHN0cnVjdCBsZ3M4Z3h4X2NvbmZpZyAqY29uZmlnID0gcHJpdi0+Y29uZmlnOworCXU4IGlmX2Nv
bmY7CisKKwlpZl9jb25mID0gMHgxMDsgLyogQUdDIG91dHB1dCBvbjsgKi8KKworCWlmX2NvbmYg
fD0KKwkJKChjb25maWctPmV4dF9hZGMpID8gMHg4MCA6IDB4MDApIHwKKwkJKChjb25maWctPmlm
X25lZ19jZW50ZXIpID8gMHgwNCA6IDB4MDApIHwKKwkJKChjb25maWctPmlmX2ZyZXEgPT0gMCkg
PyAweDA4IDogMHgwMCkgfCAvKiBCYXNlYmFuZCAqLworCQkoKGNvbmZpZy0+ZXh0X2FkYyAmJiBj
b25maWctPmFkY19zaWduZWQpID8gMHgwMiA6IDB4MDApIHwKKwkJKChjb25maWctPmV4dF9hZGMg
JiYgY29uZmlnLT5pZl9uZWdfZWRnZSkgPyAweDAxIDogMHgwMCk7CisKKwlpZiAoY29uZmlnLT5l
eHRfYWRjICYmCisJCShjb25maWctPnByb2QgPT0gTEdTOEdYWF9QUk9EX0xHUzhHNTIpKSB7CisJ
CWxnczhneHhfd3JpdGVfcmVnKHByaXYsIDB4QkEsIDB4NDApOworCX0KKworCWxnczhneHhfd3Jp
dGVfcmVnKHByaXYsIDB4MDcsIGlmX2NvbmYpOworCisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYyBp
bnQgbGdzOGd4eF9zZXRfaWZfZnJlcShzdHJ1Y3QgbGdzOGd4eF9zdGF0ZSAqcHJpdiwgdTMyIGZy
ZXEgLyppbiBrSHoqLykKK3sKKwl1NjQgdmFsOworCXUzMiB2MzI7CisJdTMyIGlmX2NsazsKKwor
CWlmX2NsayA9IHByaXYtPmNvbmZpZy0+aWZfY2xrX2ZyZXE7CisKKwl2YWwgPSBmcmVxOworCWlm
IChmcmVxICE9IDApIHsKKwkJdmFsICo9ICh1NjQpMSA8PCAzMjsKKwkJaWYgKGlmX2NsayAhPSAw
KQorCQkJZG9fZGl2KHZhbCwgaWZfY2xrKTsKKwkJdjMyID0gdmFsICYgMHhGRkZGRkZGRjsKKwkJ
ZHByaW50aygiU2V0IElGIEZyZXEgdG8gJWRrSHpcbiIsIGZyZXEpOworCX0gZWxzZSB7CisJCXYz
MiA9IDA7CisJCWRwcmludGsoIlNldCBJRiBGcmVxIHRvIGJhc2ViYW5kXG4iKTsKKwl9CisJZHBy
aW50aygiQUZDX0lOSVRfRlJFUSA9IDB4JTA4WFxuIiwgdjMyKTsKKworCWxnczhneHhfd3JpdGVf
cmVnKHByaXYsIDB4MDksIDB4RkYgJiAodjMyKSk7CisJbGdzOGd4eF93cml0ZV9yZWcocHJpdiwg
MHgwQSwgMHhGRiAmICh2MzIgPj4gOCkpOworCWxnczhneHhfd3JpdGVfcmVnKHByaXYsIDB4MEIs
IDB4RkYgJiAodjMyID4+IDE2KSk7CisJbGdzOGd4eF93cml0ZV9yZWcocHJpdiwgMHgwQywgMHhG
RiAmICh2MzIgPj4gMjQpKTsKKworCXJldHVybiAwOworfQorCitzdGF0aWMgaW50IGxnczhneHhf
c2V0X21vZGVfYXV0byhzdHJ1Y3QgbGdzOGd4eF9zdGF0ZSAqcHJpdikKK3sKKwl1OCB0OworCisJ
aWYgKHByaXYtPmNvbmZpZy0+cHJvZCA9PSBMR1M4R1hYX1BST0RfTEdTODkxMykKKwkJbGdzOGd4
eF93cml0ZV9yZWcocHJpdiwgMHhDNiwgMHgwMSk7CisKKwlsZ3M4Z3h4X3JlYWRfcmVnKHByaXYs
IDB4N0UsICZ0KTsKKwlsZ3M4Z3h4X3dyaXRlX3JlZyhwcml2LCAweDdFLCB0IHwgMHgwMSk7CisK
KwkvKiBjbGVhciBGRUMgc2VsZiByZXNldCAqLworCWxnczhneHhfcmVhZF9yZWcocHJpdiwgMHhD
NSwgJnQpOworCWxnczhneHhfd3JpdGVfcmVnKHByaXYsIDB4QzUsIHQgJiAweEUwKTsKKworCWlm
IChwcml2LT5jb25maWctPnByb2QgPT0gTEdTOEdYWF9QUk9EX0xHUzg5MTMpIHsKKwkJLyogRkVD
IGF1dG8gZGV0ZWN0ICovCisJCWxnczhneHhfd3JpdGVfcmVnKHByaXYsIDB4QzEsIDB4MDMpOwor
CisJCWxnczhneHhfcmVhZF9yZWcocHJpdiwgMHg3QywgJnQpOworCQl0ID0gKHQgJiAweDhDKSB8
IDB4MDM7CisJCWxnczhneHhfd3JpdGVfcmVnKHByaXYsIDB4N0MsIHQpOworCX0KKworCisJaWYg
KHByaXYtPmNvbmZpZy0+cHJvZCA9PSBMR1M4R1hYX1BST0RfTEdTODkxMykgeworCQkvKiBCRVIg
dGVzdCBtb2RlICovCisJCWxnczhneHhfcmVhZF9yZWcocHJpdiwgMHhDMywgJnQpOworCQl0ID0g
KHQgJiAweEVGKSB8ICAweDEwOworCQlsZ3M4Z3h4X3dyaXRlX3JlZyhwcml2LCAweEMzLCB0KTsK
Kwl9CisKKwlpZiAocHJpdi0+Y29uZmlnLT5wcm9kID09IExHUzhHWFhfUFJPRF9MR1M4RzUyKQor
CQlsZ3M4Z3h4X3dyaXRlX3JlZyhwcml2LCAweEQ5LCAweDQwKTsKKworCXJldHVybiAwOworfQor
CitzdGF0aWMgaW50IGxnczhneHhfc2V0X21vZGVfbWFudWFsKHN0cnVjdCBsZ3M4Z3h4X3N0YXRl
ICpwcml2KQoreworCWludCByZXQgPSAwOworCXU4IHQ7CisKKwkvKiB0dXJuIG9mZiBhdXRvLWRl
dGVjdDsgbWFudWFsIHNldHRpbmdzICovCisJbGdzOGd4eF93cml0ZV9yZWcocHJpdiwgMHg3RSwg
MCk7CisJaWYgKHByaXYtPmNvbmZpZy0+cHJvZCA9PSBMR1M4R1hYX1BST0RfTEdTODkxMykKKwkJ
bGdzOGd4eF93cml0ZV9yZWcocHJpdiwgMHhDMSwgMCk7CisKKwlyZXQgPSBsZ3M4Z3h4X3JlYWRf
cmVnKHByaXYsIDB4QzUsICZ0KTsKKwl0ID0gKHQgJiAweEUwKSB8IDB4MDY7CisJbGdzOGd4eF93
cml0ZV9yZWcocHJpdiwgMHhDNSwgdCk7CisKKwlsZ3M4Z3h4X3NvZnRfcmVzZXQocHJpdik7CisK
KwlyZXR1cm4gMDsKK30KKworc3RhdGljIGludCBsZ3M4Z3h4X2lzX2xvY2tlZChzdHJ1Y3QgbGdz
OGd4eF9zdGF0ZSAqcHJpdiwgdTggKmxvY2tlZCkKK3sKKwlpbnQgcmV0ID0gMDsKKwl1OCB0Owor
CisJcmV0ID0gbGdzOGd4eF9yZWFkX3JlZyhwcml2LCAweDRCLCAmdCk7CisJaWYgKHJldCAhPSAw
KQorCQlyZXR1cm4gcmV0OworCisJKmxvY2tlZCA9ICgodCAmIDB4QzApID09IDB4QzApID8gMSA6
IDA7CisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYyBpbnQgbGdzOGd4eF9pc19hdXRvZGV0ZWN0X2Zp
bmlzaGVkKHN0cnVjdCBsZ3M4Z3h4X3N0YXRlICpwcml2LAorCQkJCQkgIHU4ICpmaW5pc2hlZCkK
K3sKKwlpbnQgcmV0ID0gMDsKKwl1OCB0OworCisJcmV0ID0gbGdzOGd4eF9yZWFkX3JlZyhwcml2
LCAweEE0LCAmdCk7CisJaWYgKHJldCAhPSAwKQorCQlyZXR1cm4gcmV0OworCisJKmZpbmlzaGVk
ID0gKCh0ICYgMHgzKSA9PSAweDEpID8gMSA6IDA7CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGlj
IGludCBsZ3M4Z3h4X2F1dG9sb2NrX2dpKHN0cnVjdCBsZ3M4Z3h4X3N0YXRlICpwcml2LCB1OCBn
aSwgdTggKmxvY2tlZCkKK3sKKwlpbnQgZXJyOworCXU4IGFkX2ZpbmkgPSAwOworCisJaWYgKGdp
ID09IEdJXzk0NSkKKwkJZHByaW50aygidHJ5IEdJIDk0NVxuIik7CisJZWxzZSBpZiAoZ2kgPT0g
R0lfNTk1KQorCQlkcHJpbnRrKCJ0cnkgR0kgNTk1XG4iKTsKKwllbHNlIGlmIChnaSA9PSBHSV80
MjApCisJCWRwcmludGsoInRyeSBHSSA0MjBcbiIpOworCWxnczhneHhfd3JpdGVfcmVnKHByaXYs
IDB4MDQsIGdpKTsKKwlsZ3M4Z3h4X3NvZnRfcmVzZXQocHJpdik7CisJbXNsZWVwKDUwKTsKKwll
cnIgPSBsZ3M4Z3h4X2lzX2F1dG9kZXRlY3RfZmluaXNoZWQocHJpdiwgJmFkX2ZpbmkpOworCWlm
IChlcnIgIT0gMCkKKwkJcmV0dXJuIGVycjsKKwlpZiAoYWRfZmluaSkgeworCQllcnIgPSBsZ3M4
Z3h4X2lzX2xvY2tlZChwcml2LCBsb2NrZWQpOworCQlpZiAoZXJyICE9IDApCisJCQlyZXR1cm4g
ZXJyOworCX0KKworCXJldHVybiAwOworfQorCitzdGF0aWMgaW50IGxnczhneHhfYXV0b19kZXRl
Y3Qoc3RydWN0IGxnczhneHhfc3RhdGUgKnByaXYsCisJCQkgICAgICAgdTggKmRldGVjdGVkX3Bh
cmFtLCB1OCAqZ2kpCit7CisJaW50IGksIGo7CisJaW50IGVyciA9IDA7CisJdTggbG9ja2VkID0g
MCwgdG1wX2dpOworCisJZHByaW50aygiJXNcbiIsIF9fZnVuY19fKTsKKworCWxnczhneHhfc2V0
X21vZGVfYXV0byhwcml2KTsKKwkvKiBHdWFyZCBJbnRlcnZhbCAqLworCWxnczhneHhfd3JpdGVf
cmVnKHByaXYsIDB4MDMsIDAwKTsKKworCWZvciAoaSA9IDA7IGkgPCAyOyBpKyspIHsKKwkJZm9y
IChqID0gMDsgaiA8IDI7IGorKykgeworCQkJdG1wX2dpID0gR0lfOTQ1OworCQkJZXJyID0gbGdz
OGd4eF9hdXRvbG9ja19naShwcml2LCBHSV85NDUsICZsb2NrZWQpOworCQkJaWYgKGVycikKKwkJ
CQlnb3RvIG91dDsKKwkJCWlmIChsb2NrZWQpCisJCQkJZ290byBsb2NrZWQ7CisJCX0KKwkJZm9y
IChqID0gMDsgaiA8IDI7IGorKykgeworCQkJdG1wX2dpID0gR0lfNDIwOworCQkJZXJyID0gbGdz
OGd4eF9hdXRvbG9ja19naShwcml2LCBHSV80MjAsICZsb2NrZWQpOworCQkJaWYgKGVycikKKwkJ
CQlnb3RvIG91dDsKKwkJCWlmIChsb2NrZWQpCisJCQkJZ290byBsb2NrZWQ7CisJCX0KKwkJdG1w
X2dpID0gR0lfNTk1OworCQllcnIgPSBsZ3M4Z3h4X2F1dG9sb2NrX2dpKHByaXYsIEdJXzU5NSwg
JmxvY2tlZCk7CisJCWlmIChlcnIpCisJCQlnb3RvIG91dDsKKwkJaWYgKGxvY2tlZCkKKwkJCWdv
dG8gbG9ja2VkOworCX0KKworbG9ja2VkOgorCWlmICgoZXJyID09IDApICYmIChsb2NrZWQgPT0g
MSkpIHsKKwkJdTggdDsKKworCQlsZ3M4Z3h4X3JlYWRfcmVnKHByaXYsIDB4QTIsICZ0KTsKKwkJ
KmRldGVjdGVkX3BhcmFtID0gdDsKKworCQlpZiAodG1wX2dpID09IEdJXzk0NSkKKwkJCWRwcmlu
dGsoIkdJIDk0NSBsb2NrZWRcbiIpOworCQllbHNlIGlmICh0bXBfZ2kgPT0gR0lfNTk1KQorCQkJ
ZHByaW50aygiR0kgNTk1IGxvY2tlZFxuIik7CisJCWVsc2UgaWYgKHRtcF9naSA9PSBHSV80MjAp
CisJCQlkcHJpbnRrKCJHSSA0MjAgbG9ja2VkXG4iKTsKKwkJKmdpID0gdG1wX2dpOworCX0KKwlp
ZiAoIWxvY2tlZCkKKwkJZXJyID0gLTE7CisKK291dDoKKwlyZXR1cm4gZXJyOworfQorCitzdGF0
aWMgdm9pZCBsZ3M4Z3h4X2F1dG9fbG9jayhzdHJ1Y3QgbGdzOGd4eF9zdGF0ZSAqcHJpdikKK3sK
KwlzOCBlcnI7CisJdTggZ2kgPSAweDI7CisJdTggZGV0ZWN0ZWRfcGFyYW0gPSAwOworCisJZXJy
ID0gbGdzOGd4eF9hdXRvX2RldGVjdChwcml2LCAmZGV0ZWN0ZWRfcGFyYW0sICZnaSk7CisKKwlp
ZiAoZXJyICE9IDApIHsKKyNpZiAwCisJCS8qIFNldCBhdXRvIGd1YXJkaW50ZXJ2YWwgZGV0ZWN0
aW9uICovCisJCWxnczhneHhfd3JpdGVfcmVnKHByaXYsIDB4MDMsIDB4MDEpOworI2VuZGlmCisJ
CWRwcmludGsoImxnczhneHhfYXV0b19kZXRlY3QgZmFpbGVkXG4iKTsKKwl9CisKKwkvKiBBcHBs
eSBkZXRlY3RlZCBwYXJhbWV0ZXJzICovCisJaWYgKHByaXYtPmNvbmZpZy0+cHJvZCA9PSBMR1M4
R1hYX1BST0RfTEdTODkxMykgeworCQl1OCBpbnRlcl9sZWF2ZV9sZW4gPSBkZXRlY3RlZF9wYXJh
bSAmIFRJTV9NQVNLIDsKKwkJaW50ZXJfbGVhdmVfbGVuID0gKGludGVyX2xlYXZlX2xlbiA9PSBU
SU1fTE9ORykgPyAweDYwIDogMHg0MDsKKwkJZGV0ZWN0ZWRfcGFyYW0gJj0gQ0ZfTUFTSyB8IFND
X01BU0sgIHwgTEdTX0ZFQ19NQVNLOworCQlkZXRlY3RlZF9wYXJhbSB8PSBpbnRlcl9sZWF2ZV9s
ZW47CisJfQorCWxnczhneHhfd3JpdGVfcmVnKHByaXYsIDB4N0QsIGRldGVjdGVkX3BhcmFtKTsK
KwlpZiAocHJpdi0+Y29uZmlnLT5wcm9kID09IExHUzhHWFhfUFJPRF9MR1M4OTEzKQorCQlsZ3M4
Z3h4X3dyaXRlX3JlZyhwcml2LCAweEMwLCBkZXRlY3RlZF9wYXJhbSk7CisJLyogbGdzOGd4eF9z
b2Z0X3Jlc2V0KHByaXYpOyAqLworCisJLyogRW50ZXIgbWFudWFsIG1vZGUgKi8KKwlsZ3M4Z3h4
X3NldF9tb2RlX21hbnVhbChwcml2KTsKKworCXN3aXRjaCAoZ2kpIHsKKwljYXNlIEdJXzk0NToK
KwkJcHJpdi0+Y3Vycl9naSA9IDk0NTsgYnJlYWs7CisJY2FzZSBHSV81OTU6CisJCXByaXYtPmN1
cnJfZ2kgPSA1OTU7IGJyZWFrOworCWNhc2UgR0lfNDIwOgorCQlwcml2LT5jdXJyX2dpID0gNDIw
OyBicmVhazsKKwlkZWZhdWx0OgorCQlwcml2LT5jdXJyX2dpID0gOTQ1OyBicmVhazsKKwl9Cit9
CisKK3N0YXRpYyBpbnQgbGdzOGd4eF9zZXRfbXBlZ19tb2RlKHN0cnVjdCBsZ3M4Z3h4X3N0YXRl
ICpwcml2LAorCXU4IHNlcmlhbCwgdTggY2xrX3BvbCwgdTggY2xrX2dhdGVkKQoreworCWludCBy
ZXQgPSAwOworCXU4IHQ7CisKKwlyZXQgPSBsZ3M4Z3h4X3JlYWRfcmVnKHByaXYsIDB4QzIsICZ0
KTsKKwlpZiAocmV0ICE9IDApCisJCXJldHVybiByZXQ7CisKKwl0ICY9IDB4Rjg7CisJdCB8PSBz
ZXJpYWwgPyBUU19TRVJJQUwgOiBUU19QQVJBTExFTDsKKwl0IHw9IGNsa19wb2wgPyBUU19DTEtf
SU5WRVJURUQgOiBUU19DTEtfTk9STUFMOworCXQgfD0gY2xrX2dhdGVkID8gVFNfQ0xLX0dBVEVE
IDogVFNfQ0xLX0ZSRUVSVU47CisKKwlyZXQgPSBsZ3M4Z3h4X3dyaXRlX3JlZyhwcml2LCAweEMy
LCB0KTsKKwlpZiAocmV0ICE9IDApCisJCXJldHVybiByZXQ7CisKKwlyZXR1cm4gMDsKK30KKwor
CisvKiBMR1M4OTEzIGRlbW9kIGZyb250ZW5kIGZ1bmN0aW9ucyAqLworCitzdGF0aWMgaW50IGxn
czg5MTNfaW5pdChzdHJ1Y3QgbGdzOGd4eF9zdGF0ZSAqcHJpdikKK3sKKwl1OCB0OworCisJLyog
TEdTODkxMyBzcGVjaWZpYyAqLworCWxnczhneHhfd3JpdGVfcmVnKHByaXYsIDB4YzEsIDB4Myk7
CisKKwlsZ3M4Z3h4X3JlYWRfcmVnKHByaXYsIDB4N2MsICZ0KTsKKwlsZ3M4Z3h4X3dyaXRlX3Jl
Zyhwcml2LCAweDdjLCAodCYweDhjKSB8IDB4Myk7CisKKwkvKiBMR1M4OTEzIHNwZWNpZmljICov
CisJbGdzOGd4eF9yZWFkX3JlZyhwcml2LCAweGMzLCAmdCk7CisJbGdzOGd4eF93cml0ZV9yZWco
cHJpdiwgMHhjMywgdCYweDEwKTsKKworI2lmIDAKKwkvKiBzZXQgQUdDIHJlZiAqLworCS8qIFRP
RE8gYmV0dGVyIHNldCBmcm9tIGNvbmZpZ3VyYXRpb24gcGVyIGhhcmR3YXJlICovCisJbGdzOGd4
eF93cml0ZV9yZWcocHJpdiwgMHgyQywgMCk7CisJbGdzOGd4eF93cml0ZV9yZWcocHJpdiwgMHgy
RCwgMHgxOCk7CisJbGdzOGd4eF93cml0ZV9yZWcocHJpdiwgMHgyRSwgMHhBMik7CisjZW5kaWYK
KworCXJldHVybiAwOworfQorCitzdGF0aWMgaW50IGxnczhneHhfaW5pdChzdHJ1Y3QgZHZiX2Zy
b250ZW5kICpmZSkKK3sKKwlzdHJ1Y3QgbGdzOGd4eF9zdGF0ZSAqcHJpdiA9CisJCShzdHJ1Y3Qg
bGdzOGd4eF9zdGF0ZSAqKWZlLT5kZW1vZHVsYXRvcl9wcml2OworCWNvbnN0IHN0cnVjdCBsZ3M4
Z3h4X2NvbmZpZyAqY29uZmlnID0gcHJpdi0+Y29uZmlnOworCXU4IGRhdGEgPSAwOworCXM4IGVy
cjsKKwlkcHJpbnRrKCIlc1xuIiwgX19mdW5jX18pOworCisJbGdzOGd4eF9yZWFkX3JlZyhwcml2
LCAwLCAmZGF0YSk7CisJZHByaW50aygicmVnIDAgPSAweCUwMlhcbiIsIGRhdGEpOworCisJLyog
U2V0dXAgTVBFRyBvdXRwdXQgZm9ybWF0ICovCisJZXJyID0gbGdzOGd4eF9zZXRfbXBlZ19tb2Rl
KHByaXYsIGNvbmZpZy0+c2VyaWFsX3RzLAorCQkJCSAgICBjb25maWctPnRzX2Nsa19wb2wsCisJ
CQkJICAgIGNvbmZpZy0+dHNfY2xrX2dhdGVkKTsKKwlpZiAoZXJyICE9IDApCisJCXJldHVybiAt
RUlPOworCisJaWYgKGNvbmZpZy0+cHJvZCA9PSBMR1M4R1hYX1BST0RfTEdTODkxMykKKwkJbGdz
ODkxM19pbml0KHByaXYpOworCWxnczhneHhfc2V0X2lmX2ZyZXEocHJpdiwgcHJpdi0+Y29uZmln
LT5pZl9mcmVxKTsKKwlpZiAoY29uZmlnLT5wcm9kICE9IExHUzhHWFhfUFJPRF9MR1M4OTEzKQor
CQlsZ3M4Z3h4X3NldF9hZF9tb2RlKHByaXYpOworCisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYyB2
b2lkIGxnczhneHhfcmVsZWFzZShzdHJ1Y3QgZHZiX2Zyb250ZW5kICpmZSkKK3sKKwlzdHJ1Y3Qg
bGdzOGd4eF9zdGF0ZSAqc3RhdGUgPSBmZS0+ZGVtb2R1bGF0b3JfcHJpdjsKKwlkcHJpbnRrKCIl
c1xuIiwgX19mdW5jX18pOworCisJa2ZyZWUoc3RhdGUpOworfQorCisjaWYgMAorc3RhdGljIGlu
dCBsZ3M4Z3h4X3NsZWVwKHN0cnVjdCBkdmJfZnJvbnRlbmQgKmZlKQoreworCWRwcmludGsoIiVz
XG4iLCBfX2Z1bmNfXyk7CisKKwlyZXR1cm4gMDsKK30KKyNlbmRpZgorCitzdGF0aWMgaW50IGxn
czhneHhfd3JpdGUoc3RydWN0IGR2Yl9mcm9udGVuZCAqZmUsIHU4ICpidWYsIGludCBsZW4pCit7
CisJc3RydWN0IGxnczhneHhfc3RhdGUgKnByaXYgPSBmZS0+ZGVtb2R1bGF0b3JfcHJpdjsKKwor
CWlmIChsZW4gIT0gMikKKwkJcmV0dXJuIC1FSU5WQUw7CisKKwlyZXR1cm4gbGdzOGd4eF93cml0
ZV9yZWcocHJpdiwgYnVmWzBdLCBidWZbMV0pOworfQorCitzdGF0aWMgaW50IGxnczhneHhfc2V0
X2ZlKHN0cnVjdCBkdmJfZnJvbnRlbmQgKmZlLAorCQkJICBzdHJ1Y3QgZHZiX2Zyb250ZW5kX3Bh
cmFtZXRlcnMgKmZlX3BhcmFtcykKK3sKKwlzdHJ1Y3QgbGdzOGd4eF9zdGF0ZSAqcHJpdiA9IGZl
LT5kZW1vZHVsYXRvcl9wcml2OworCisJZHByaW50aygiJXNcbiIsIF9fZnVuY19fKTsKKworCS8q
IHNldCBmcmVxdWVuY3kgKi8KKwlpZiAoZmUtPm9wcy50dW5lcl9vcHMuc2V0X3BhcmFtcykgewor
CQlmZS0+b3BzLnR1bmVyX29wcy5zZXRfcGFyYW1zKGZlLCBmZV9wYXJhbXMpOworCQlpZiAoZmUt
Pm9wcy5pMmNfZ2F0ZV9jdHJsKQorCQkJZmUtPm9wcy5pMmNfZ2F0ZV9jdHJsKGZlLCAwKTsKKwl9
CisKKwkvKiBzdGFydCBhdXRvIGxvY2sgKi8KKwlsZ3M4Z3h4X2F1dG9fbG9jayhwcml2KTsKKwor
CW1zbGVlcCgxMCk7CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGludCBsZ3M4Z3h4X2dldF9m
ZShzdHJ1Y3QgZHZiX2Zyb250ZW5kICpmZSwKKwkJCSAgc3RydWN0IGR2Yl9mcm9udGVuZF9wYXJh
bWV0ZXJzICpmZV9wYXJhbXMpCit7CisJc3RydWN0IGxnczhneHhfc3RhdGUgKnByaXYgPSBmZS0+
ZGVtb2R1bGF0b3JfcHJpdjsKKwl1OCB0OworI2lmIDAKKwlpbnQgdHJhbnNsYXRlZF9mZWMgPSBG
RUNfMV8yOworI2VuZGlmCisKKwlkcHJpbnRrKCIlc1xuIiwgX19mdW5jX18pOworCisJLyogVE9E
TzogZ2V0IHJlYWwgcmVhZGluZ3MgZnJvbSBkZXZpY2UgKi8KKwkvKiBpbnZlcnNpb24gc3RhdHVz
ICovCisJZmVfcGFyYW1zLT5pbnZlcnNpb24gPSBJTlZFUlNJT05fT0ZGOworCisJLyogYmFuZHdp
ZHRoICovCisJZmVfcGFyYW1zLT51Lm9mZG0uYmFuZHdpZHRoID0gQkFORFdJRFRIXzhfTUhaOwor
CisKKwlsZ3M4Z3h4X3JlYWRfcmVnKHByaXYsIDB4N0QsICZ0KTsKKyNpZiAwCisJLyogRkVDLiBO
byBleGFjdCBtYXRjaCBmb3IgRE1CLVRILCBwaWNrIGFwcHJveC4gdmFsdWUgKi8KKwlzd2l0Y2gg
KHQgJiBMR1NfRkVDX01BU0spIHsKKwljYXNlICBMR1NfRkVDXzBfNDogLyogRkVDIDAuNCAqLwor
CQl0cmFuc2xhdGVkX2ZlYyA9IEZFQ18xXzI7CisJCWJyZWFrOworCWNhc2UgIExHU19GRUNfMF82
OiAvKiBGRUMgMC42ICovCisJCXRyYW5zbGF0ZWRfZmVjID0gRkVDXzJfMzsKKwkJYnJlYWs7CisJ
Y2FzZSAgTEdTX0ZFQ18wXzg6IC8qIEZFQyAwLjggKi8KKwkJdHJhbnNsYXRlZF9mZWMgPSBGRUNf
NV82OworCQlicmVhazsKKwlkZWZhdWx0OgorCQl0cmFuc2xhdGVkX2ZlYyA9IEZFQ18xXzI7CisJ
fQorCWZlX3BhcmFtcy0+dS5vZmRtLmNvZGVfcmF0ZV9IUCA9IHRyYW5zbGF0ZWRfZmVjOworCWZl
X3BhcmFtcy0+dS5vZmRtLmNvZGVfcmF0ZV9MUCA9IHRyYW5zbGF0ZWRfZmVjOworI2VuZGlmCisJ
ZmVfcGFyYW1zLT51Lm9mZG0uY29kZV9yYXRlX0hQID0gRkVDX0FVVE87CisJZmVfcGFyYW1zLT51
Lm9mZG0uY29kZV9yYXRlX0xQID0gRkVDX0FVVE87CisKKwkvKiBjb25zdGVsbGF0aW9uICovCisJ
c3dpdGNoICh0ICYgU0NfTUFTSykgeworCWNhc2UgU0NfUUFNNjQ6CisJCWZlX3BhcmFtcy0+dS5v
ZmRtLmNvbnN0ZWxsYXRpb24gPSBRQU1fNjQ7CisJCWJyZWFrOworCWNhc2UgU0NfUUFNMzI6CisJ
CWZlX3BhcmFtcy0+dS5vZmRtLmNvbnN0ZWxsYXRpb24gPSBRQU1fMzI7CisJCWJyZWFrOworCWNh
c2UgU0NfUUFNMTY6CisJCWZlX3BhcmFtcy0+dS5vZmRtLmNvbnN0ZWxsYXRpb24gPSBRQU1fMTY7
CisJCWJyZWFrOworCWNhc2UgU0NfUUFNNDoKKwljYXNlIFNDX1FBTTROUjoKKwkJZmVfcGFyYW1z
LT51Lm9mZG0uY29uc3RlbGxhdGlvbiA9IFFQU0s7CisJCWJyZWFrOworCWRlZmF1bHQ6CisJCWZl
X3BhcmFtcy0+dS5vZmRtLmNvbnN0ZWxsYXRpb24gPSBRQU1fNjQ7CisJfQorCisJLyogdHJhbnNt
aXNzaW9uIG1vZGUgKi8KKwlmZV9wYXJhbXMtPnUub2ZkbS50cmFuc21pc3Npb25fbW9kZSA9IFRS
QU5TTUlTU0lPTl9NT0RFX0FVVE87CisKKwkvKiBndWFyZCBpbnRlcnZhbCAqLworCWZlX3BhcmFt
cy0+dS5vZmRtLmd1YXJkX2ludGVydmFsID0gR1VBUkRfSU5URVJWQUxfQVVUTzsKKworCS8qIGhp
ZXJhcmNoeSAqLworCWZlX3BhcmFtcy0+dS5vZmRtLmhpZXJhcmNoeV9pbmZvcm1hdGlvbiA9IEhJ
RVJBUkNIWV9OT05FOworCisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYworaW50IGxnczhneHhfZ2V0
X3R1bmVfc2V0dGluZ3Moc3RydWN0IGR2Yl9mcm9udGVuZCAqZmUsCisJCQkgICAgICBzdHJ1Y3Qg
ZHZiX2Zyb250ZW5kX3R1bmVfc2V0dGluZ3MgKmZlc2V0dGluZ3MpCit7CisJLyogRklYTUU6IGNv
cHkgZnJvbSB0ZGExMDA0eC5jICovCisJZmVzZXR0aW5ncy0+bWluX2RlbGF5X21zID0gODAwOwor
CWZlc2V0dGluZ3MtPnN0ZXBfc2l6ZSA9IDA7CisJZmVzZXR0aW5ncy0+bWF4X2RyaWZ0ID0gMDsK
KwlyZXR1cm4gMDsKK30KKworc3RhdGljIGludCBsZ3M4Z3h4X3JlYWRfc3RhdHVzKHN0cnVjdCBk
dmJfZnJvbnRlbmQgKmZlLCBmZV9zdGF0dXNfdCAqZmVfc3RhdHVzKQoreworCXN0cnVjdCBsZ3M4
Z3h4X3N0YXRlICpwcml2ID0gZmUtPmRlbW9kdWxhdG9yX3ByaXY7CisJczggcmV0OworCXU4IHQ7
CisKKwlkcHJpbnRrKCIlc1xuIiwgX19mdW5jX18pOworCisJcmV0ID0gbGdzOGd4eF9yZWFkX3Jl
Zyhwcml2LCAweDRCLCAmdCk7CisJaWYgKHJldCAhPSAwKQorCQlyZXR1cm4gLUVJTzsKKworCWRw
cmludGsoIlJlZyAweDRCOiAweCUwMlhcbiIsIHQpOworCisJKmZlX3N0YXR1cyA9IDA7CisJaWYg
KHByaXYtPmNvbmZpZy0+cHJvZCA9PSBMR1M4R1hYX1BST0RfTEdTODkxMykgeworCQlpZiAoKHQg
JiAweDQwKSA9PSAweDQwKQorCQkJKmZlX3N0YXR1cyB8PSBGRV9IQVNfU0lHTkFMIHwgRkVfSEFT
X0NBUlJJRVI7CisJCWlmICgodCAmIDB4ODApID09IDB4ODApCisJCQkqZmVfc3RhdHVzIHw9IEZF
X0hBU19WSVRFUkJJIHwgRkVfSEFTX1NZTkMgfAorCQkJCUZFX0hBU19MT0NLOworCX0gZWxzZSB7
CisJCWlmICgodCAmIDB4ODApID09IDB4ODApCisJCQkqZmVfc3RhdHVzIHw9IEZFX0hBU19TSUdO
QUwgfCBGRV9IQVNfQ0FSUklFUiB8CisJCQkJRkVfSEFTX1ZJVEVSQkkgfCBGRV9IQVNfU1lOQyB8
IEZFX0hBU19MT0NLOworCX0KKworCS8qIHN1Y2Nlc3MgKi8KKwlkcHJpbnRrKCIlczogZmVfc3Rh
dHVzPTB4JXhcbiIsIF9fZnVuY19fLCAqZmVfc3RhdHVzKTsKKwlyZXR1cm4gMDsKK30KKworc3Rh
dGljIGludCBsZ3M4Z3h4X3JlYWRfc2lnbmFsX2FnYyhzdHJ1Y3QgbGdzOGd4eF9zdGF0ZSAqcHJp
diwgdTE2ICpzaWduYWwpCit7CisJdTE2IHY7CisJdTggYWdjX2x2bFsyXSwgY2F0OworCisJZHBy
aW50aygiJXMoKVxuIiwgX19mdW5jX18pOworCWxnczhneHhfcmVhZF9yZWcocHJpdiwgMHgzRiwg
JmFnY19sdmxbMF0pOworCWxnczhneHhfcmVhZF9yZWcocHJpdiwgMHgzRSwgJmFnY19sdmxbMV0p
OworCisJdiA9IGFnY19sdmxbMF07CisJdiA8PD0gODsKKwl2IHw9IGFnY19sdmxbMV07CisKKwlk
cHJpbnRrKCJhZ2NfbHZsOiAweCUwNFhcbiIsIHYpOworCisJaWYgKHYgPCAweDEwMCkKKwkJY2F0
ID0gMDsKKwllbHNlIGlmICh2IDwgMHgxOTApCisJCWNhdCA9IDU7CisJZWxzZSBpZiAodiA8IDB4
MkE4KQorCQljYXQgPSA0OworCWVsc2UgaWYgKHYgPCAweDM4MSkKKwkJY2F0ID0gMzsKKwllbHNl
IGlmICh2IDwgMHg0MDApCisJCWNhdCA9IDI7CisJZWxzZSBpZiAodiA9PSAweDQwMCkKKwkJY2F0
ID0gMTsKKwllbHNlCisJCWNhdCA9IDA7CisKKwkqc2lnbmFsID0gY2F0OworCisJcmV0dXJuIDA7
Cit9CisKK3N0YXRpYyBpbnQgbGdzODkxM19yZWFkX3NpZ25hbF9zdHJlbmd0aChzdHJ1Y3QgbGdz
OGd4eF9zdGF0ZSAqcHJpdiwgdTE2ICpzaWduYWwpCit7CisJdTggdDsgczggcmV0OworCXMxNiBt
YXhfc3RyZW5ndGggPSAwOworCXU4IHN0cjsKKwl1MTYgaSwgZ2kgPSBwcml2LT5jdXJyX2dpOwor
CisJZHByaW50aygiJXNcbiIsIF9fZnVuY19fKTsKKworCXJldCA9IGxnczhneHhfcmVhZF9yZWco
cHJpdiwgMHg0QiwgJnQpOworCWlmIChyZXQgIT0gMCkKKwkJcmV0dXJuIC1FSU87CisKKwlpZiAo
ZmFrZV9zaWduYWxfc3RyKSB7CisJCWlmICgodCAmIDB4QzApID09IDB4QzApIHsKKwkJCWRwcmlu
dGsoIkZha2Ugc2lnbmFsIHN0cmVuZ3RoIGFzIDUwXG4iKTsKKwkJCSpzaWduYWwgPSAweDMyOwor
CQl9IGVsc2UKKwkJCSpzaWduYWwgPSAwOworCQlyZXR1cm4gMDsKKwl9CisKKwlkcHJpbnRrKCJn
aSA9ICVkXG4iLCBnaSk7CisJZm9yIChpID0gMDsgaSA8IGdpOyBpKyspIHsKKworCQlpZiAoKGkg
JiAweEZGKSA9PSAwKQorCQkJbGdzOGd4eF93cml0ZV9yZWcocHJpdiwgMHg4NCwgMHgwMyAmIChp
ID4+IDgpKTsKKwkJbGdzOGd4eF93cml0ZV9yZWcocHJpdiwgMHg4MywgaSAmIDB4RkYpOworCisJ
CWxnczhneHhfcmVhZF9yZWcocHJpdiwgMHg5NCwgJnN0cik7CisJCWlmIChtYXhfc3RyZW5ndGgg
PCBzdHIpCisJCQltYXhfc3RyZW5ndGggPSBzdHI7CisJfQorCisJKnNpZ25hbCA9IG1heF9zdHJl
bmd0aDsKKwlkcHJpbnRrKCIlczogc2lnbmFsPTB4JTAyWFxuIiwgX19mdW5jX18sICpzaWduYWwp
OworCisJbGdzOGd4eF9yZWFkX3JlZyhwcml2LCAweDk1LCAmdCk7CisJZHByaW50aygiJXM6IEFW
RyBOb2lzZT0weCUwMlhcbiIsIF9fZnVuY19fLCB0KTsKKworCXJldHVybiAwOworfQorCitzdGF0
aWMgaW50IGxnczhneHhfcmVhZF9zaWduYWxfc3RyZW5ndGgoc3RydWN0IGR2Yl9mcm9udGVuZCAq
ZmUsIHUxNiAqc2lnbmFsKQoreworCXN0cnVjdCBsZ3M4Z3h4X3N0YXRlICpwcml2ID0gZmUtPmRl
bW9kdWxhdG9yX3ByaXY7CisKKwlpZiAocHJpdi0+Y29uZmlnLT5wcm9kID09IExHUzhHWFhfUFJP
RF9MR1M4OTEzKQorCQlyZXR1cm4gbGdzODkxM19yZWFkX3NpZ25hbF9zdHJlbmd0aChwcml2LCBz
aWduYWwpOworCWVsc2UKKwkJcmV0dXJuIGxnczhneHhfcmVhZF9zaWduYWxfYWdjKHByaXYsIHNp
Z25hbCk7Cit9CisKK3N0YXRpYyBpbnQgbGdzOGd4eF9yZWFkX3NucihzdHJ1Y3QgZHZiX2Zyb250
ZW5kICpmZSwgdTE2ICpzbnIpCit7CisJc3RydWN0IGxnczhneHhfc3RhdGUgKnByaXYgPSBmZS0+
ZGVtb2R1bGF0b3JfcHJpdjsKKwl1OCB0OworCSpzbnIgPSAwOworCisJbGdzOGd4eF9yZWFkX3Jl
Zyhwcml2LCAweDk1LCAmdCk7CisJZHByaW50aygiQVZHIE5vaXNlPTB4JTAyWFxuIiwgdCk7CisJ
KnNuciA9IDI1NiAtIHQ7CisJKnNuciA8PD0gODsKKwlkcHJpbnRrKCJzbnI9MHgleFxuIiwgKnNu
cik7CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGludCBsZ3M4Z3h4X3JlYWRfdWNibG9ja3Mo
c3RydWN0IGR2Yl9mcm9udGVuZCAqZmUsIHUzMiAqdWNibG9ja3MpCit7CisJKnVjYmxvY2tzID0g
MDsKKwlkcHJpbnRrKCIlczogdWNibG9ja3M9MHgleFxuIiwgX19mdW5jX18sICp1Y2Jsb2Nrcyk7
CisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYyBpbnQgbGdzOGd4eF9yZWFkX2JlcihzdHJ1Y3QgZHZi
X2Zyb250ZW5kICpmZSwgdTMyICpiZXIpCit7CisJc3RydWN0IGxnczhneHhfc3RhdGUgKnByaXYg
PSBmZS0+ZGVtb2R1bGF0b3JfcHJpdjsKKwl1OCByMCwgcjEsIHIyLCByMzsKKwl1MzIgdG90YWxf
Y250LCBlcnJfY250OworCisJZHByaW50aygiJXNcbiIsIF9fZnVuY19fKTsKKworCWxnczhneHhf
d3JpdGVfcmVnKHByaXYsIDB4YzYsIDB4MDEpOworCWxnczhneHhfd3JpdGVfcmVnKHByaXYsIDB4
YzYsIDB4NDEpOworCWxnczhneHhfd3JpdGVfcmVnKHByaXYsIDB4YzYsIDB4MDEpOworCisJbXNs
ZWVwKDIwMCk7CisKKwlsZ3M4Z3h4X3dyaXRlX3JlZyhwcml2LCAweGM2LCAweDgxKTsKKwlsZ3M4
Z3h4X3JlYWRfcmVnKHByaXYsIDB4ZDAsICZyMCk7CisJbGdzOGd4eF9yZWFkX3JlZyhwcml2LCAw
eGQxLCAmcjEpOworCWxnczhneHhfcmVhZF9yZWcocHJpdiwgMHhkMiwgJnIyKTsKKwlsZ3M4Z3h4
X3JlYWRfcmVnKHByaXYsIDB4ZDMsICZyMyk7CisJdG90YWxfY250ID0gKHIzIDw8IDI0KSB8IChy
MiA8PCAxNikgfCAocjEgPDwgOCkgfCAocjApOworCWxnczhneHhfcmVhZF9yZWcocHJpdiwgMHhk
NCwgJnIwKTsKKwlsZ3M4Z3h4X3JlYWRfcmVnKHByaXYsIDB4ZDUsICZyMSk7CisJbGdzOGd4eF9y
ZWFkX3JlZyhwcml2LCAweGQ2LCAmcjIpOworCWxnczhneHhfcmVhZF9yZWcocHJpdiwgMHhkNywg
JnIzKTsKKwllcnJfY250ID0gKHIzIDw8IDI0KSB8IChyMiA8PCAxNikgfCAocjEgPDwgOCkgfCAo
cjApOworCWRwcmludGsoImVycm9yPSVkIHRvdGFsPSVkXG4iLCBlcnJfY250LCB0b3RhbF9jbnQp
OworCisJaWYgKHRvdGFsX2NudCA9PSAwKQorCQkqYmVyID0gMDsKKwllbHNlCisJCSpiZXIgPSBl
cnJfY250ICogMTAwIC8gdG90YWxfY250OworCisJZHByaW50aygiJXM6IGJlcj0weCV4XG4iLCBf
X2Z1bmNfXywgKmJlcik7CisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYyBpbnQgbGdzOGd4eF9pMmNf
Z2F0ZV9jdHJsKHN0cnVjdCBkdmJfZnJvbnRlbmQgKmZlLCBpbnQgZW5hYmxlKQoreworCXN0cnVj
dCBsZ3M4Z3h4X3N0YXRlICpwcml2ID0gZmUtPmRlbW9kdWxhdG9yX3ByaXY7CisKKwlpZiAocHJp
di0+Y29uZmlnLT50dW5lcl9hZGRyZXNzID09IDApCisJCXJldHVybiAwOworCWlmIChlbmFibGUp
IHsKKwkJdTggdiA9IDB4ODAgfCBwcml2LT5jb25maWctPnR1bmVyX2FkZHJlc3M7CisJCXJldHVy
biBsZ3M4Z3h4X3dyaXRlX3JlZyhwcml2LCAweDAxLCB2KTsKKwl9CisJcmV0dXJuIGxnczhneHhf
d3JpdGVfcmVnKHByaXYsIDB4MDEsIDApOworfQorCitzdGF0aWMgc3RydWN0IGR2Yl9mcm9udGVu
ZF9vcHMgbGdzOGd4eF9vcHMgPSB7CisJLmluZm8gPSB7CisJCS5uYW1lID0gIkxlZ2VuZCBTaWxp
Y29uIExHUzg5MTMvTEdTOEdYWCBETUItVEgiLAorCQkudHlwZSA9IEZFX09GRE0sCisJCS5mcmVx
dWVuY3lfbWluID0gNDc0MDAwMDAwLAorCQkuZnJlcXVlbmN5X21heCA9IDg1ODAwMDAwMCwKKwkJ
LmZyZXF1ZW5jeV9zdGVwc2l6ZSA9IDEwMDAwLAorCQkuY2FwcyA9CisJCQlGRV9DQU5fRkVDX0FV
VE8gfAorCQkJRkVfQ0FOX1FBTV9BVVRPIHwKKwkJCUZFX0NBTl9UUkFOU01JU1NJT05fTU9ERV9B
VVRPIHwKKwkJCUZFX0NBTl9HVUFSRF9JTlRFUlZBTF9BVVRPCisJfSwKKworCS5yZWxlYXNlID0g
bGdzOGd4eF9yZWxlYXNlLAorCisJLmluaXQgPSBsZ3M4Z3h4X2luaXQsCisjaWYgMAorCS5zbGVl
cCA9IGxnczhneHhfc2xlZXAsCisjZW5kaWYKKwkud3JpdGUgPSBsZ3M4Z3h4X3dyaXRlLAorCS5p
MmNfZ2F0ZV9jdHJsID0gbGdzOGd4eF9pMmNfZ2F0ZV9jdHJsLAorCisJLnNldF9mcm9udGVuZCA9
IGxnczhneHhfc2V0X2ZlLAorCS5nZXRfZnJvbnRlbmQgPSBsZ3M4Z3h4X2dldF9mZSwKKwkuZ2V0
X3R1bmVfc2V0dGluZ3MgPSBsZ3M4Z3h4X2dldF90dW5lX3NldHRpbmdzLAorCisJLnJlYWRfc3Rh
dHVzID0gbGdzOGd4eF9yZWFkX3N0YXR1cywKKwkucmVhZF9iZXIgPSBsZ3M4Z3h4X3JlYWRfYmVy
LAorCS5yZWFkX3NpZ25hbF9zdHJlbmd0aCA9IGxnczhneHhfcmVhZF9zaWduYWxfc3RyZW5ndGgs
CisJLnJlYWRfc25yID0gbGdzOGd4eF9yZWFkX3NuciwKKwkucmVhZF91Y2Jsb2NrcyA9IGxnczhn
eHhfcmVhZF91Y2Jsb2NrcywKK307CisKK3N0cnVjdCBkdmJfZnJvbnRlbmQgKmxnczhneHhfYXR0
YWNoKGNvbnN0IHN0cnVjdCBsZ3M4Z3h4X2NvbmZpZyAqY29uZmlnLAorCXN0cnVjdCBpMmNfYWRh
cHRlciAqaTJjKQoreworCXN0cnVjdCBsZ3M4Z3h4X3N0YXRlICpwcml2ID0gTlVMTDsKKwl1OCBk
YXRhID0gMDsKKworCWRwcmludGsoIiVzKClcbiIsIF9fZnVuY19fKTsKKworCWlmIChjb25maWcg
PT0gTlVMTCB8fCBpMmMgPT0gTlVMTCkKKwkJcmV0dXJuIE5VTEw7CisKKwlwcml2ID0ga3phbGxv
YyhzaXplb2Yoc3RydWN0IGxnczhneHhfc3RhdGUpLCBHRlBfS0VSTkVMKTsKKwlpZiAocHJpdiA9
PSBOVUxMKQorCQlnb3RvIGVycm9yX291dDsKKworCXByaXYtPmNvbmZpZyA9IGNvbmZpZzsKKwlw
cml2LT5pMmMgPSBpMmM7CisKKwkvKiBjaGVjayBpZiB0aGUgZGVtb2QgaXMgdGhlcmUgKi8KKwlp
ZiAobGdzOGd4eF9yZWFkX3JlZyhwcml2LCAwLCAmZGF0YSkgIT0gMCkgeworCQlkcHJpbnRrKCIl
cyBsZ3M4Z3h4IG5vdCBmb3VuZCBhdCBpMmMgYWRkciAweCUwMlhcbiIsCisJCQlfX2Z1bmNfXywg
cHJpdi0+Y29uZmlnLT5kZW1vZF9hZGRyZXNzKTsKKwkJZ290byBlcnJvcl9vdXQ7CisJfQorCisJ
bGdzOGd4eF9yZWFkX3JlZyhwcml2LCAxLCAmZGF0YSk7CisKKwltZW1jcHkoJnByaXYtPmZyb250
ZW5kLm9wcywgJmxnczhneHhfb3BzLAorCSAgICAgICBzaXplb2Yoc3RydWN0IGR2Yl9mcm9udGVu
ZF9vcHMpKTsKKwlwcml2LT5mcm9udGVuZC5kZW1vZHVsYXRvcl9wcml2ID0gcHJpdjsKKworCXJl
dHVybiAmcHJpdi0+ZnJvbnRlbmQ7CisKK2Vycm9yX291dDoKKwlkcHJpbnRrKCIlcygpIGVycm9y
X291dFxuIiwgX19mdW5jX18pOworCWtmcmVlKHByaXYpOworCXJldHVybiBOVUxMOworCit9CitF
WFBPUlRfU1lNQk9MKGxnczhneHhfYXR0YWNoKTsKKworTU9EVUxFX0RFU0NSSVBUSU9OKCJMZWdl
bmQgU2lsaWNvbiBMR1M4OTEzL0xHUzhHWFggRE1CLVRIIGRlbW9kdWxhdG9yIGRyaXZlciIpOwor
TU9EVUxFX0FVVEhPUigiRGF2aWQgVC4gTC4gV29uZyA8ZGF2aWR0bHdvbmdAZ21haWwuY29tPiIp
OworTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOwpkaWZmIC1yIDZmMDg4OWZkYTMxNyBsaW51eC9kcml2
ZXJzL21lZGlhL2R2Yi9mcm9udGVuZHMvbGdzOGd4eC5oCi0tLSAvZGV2L251bGwJVGh1IEphbiAw
MSAwMDowMDowMCAxOTcwICswMDAwCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250
ZW5kcy9sZ3M4Z3h4LmgJV2VkIEFwciAwMSAxNToyODowNCAyMDA5ICswODAwCkBAIC0wLDAgKzEs
OTAgQEAKKy8qCisgKiAgICBTdXBwb3J0IGZvciBMZWdlbmQgU2lsaWNvbiBETUItVEggZGVtb2R1
bGF0b3IKKyAqICAgIExHUzg5MTMsIExHUzhHTDUKKyAqICAgIGV4cGVyaW1lbnRhbCBzdXBwb3J0
IExHUzhHNDIsIExHUzhHNTIKKyAqCisgKiAgICBDb3B5cmlnaHQgKEMpIDIwMDcsMjAwOCBEYXZp
ZCBULkwuIFdvbmcgPGRhdmlkdGx3b25nQGdtYWlsLmNvbT4KKyAqICAgIENvcHlyaWdodCAoQykg
MjAwOCBTaXJpdXMgSW50ZXJuYXRpb25hbCAoSG9uZyBLb25nKSBMaW1pdGVkCisgKiAgICBUaW1v
dGh5IExlZSA8dGltb3RoeS5sZWVAc2lyaXVzaGsuY29tPiAoZm9yIGluaXRpYWwgd29yayBvbiBM
R1M4R0w1KQorICoKKyAqICAgIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2Fu
IHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5CisgKiAgICBpdCB1bmRlciB0aGUgdGVybXMg
b2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGFzIHB1Ymxpc2hlZCBieQorICogICAg
dGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbjsgZWl0aGVyIHZlcnNpb24gMiBvZiB0aGUgTGlj
ZW5zZSwgb3IKKyAqICAgIChhdCB5b3VyIG9wdGlvbikgYW55IGxhdGVyIHZlcnNpb24uCisgKgor
ICogICAgVGhpcyBwcm9ncmFtIGlzIGRpc3RyaWJ1dGVkIGluIHRoZSBob3BlIHRoYXQgaXQgd2ls
bCBiZSB1c2VmdWwsCisgKiAgICBidXQgV0lUSE9VVCBBTlkgV0FSUkFOVFk7IHdpdGhvdXQgZXZl
biB0aGUgaW1wbGllZCB3YXJyYW50eSBvZgorICogICAgTUVSQ0hBTlRBQklMSVRZIG9yIEZJVE5F
U1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFLiAgU2VlIHRoZQorICogICAgR05VIEdlbmVyYWwg
UHVibGljIExpY2Vuc2UgZm9yIG1vcmUgZGV0YWlscy4KKyAqCisgKiAgICBZb3Ugc2hvdWxkIGhh
dmUgcmVjZWl2ZWQgYSBjb3B5IG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZQorICog
ICAgYWxvbmcgd2l0aCB0aGlzIHByb2dyYW07IGlmIG5vdCwgd3JpdGUgdG8gdGhlIEZyZWUgU29m
dHdhcmUKKyAqICAgIEZvdW5kYXRpb24sIEluYy4sIDY3NSBNYXNzIEF2ZSwgQ2FtYnJpZGdlLCBN
QSAwMjEzOSwgVVNBLgorICoKKyAqLworCisjaWZuZGVmIF9fTEdTOEdYWF9IX18KKyNkZWZpbmUg
X19MR1M4R1hYX0hfXworCisjaW5jbHVkZSA8bGludXgvZHZiL2Zyb250ZW5kLmg+CisjaW5jbHVk
ZSA8bGludXgvaTJjLmg+CisKKyNkZWZpbmUgTEdTOEdYWF9QUk9EX0xHUzg5MTMgMAorI2RlZmlu
ZSBMR1M4R1hYX1BST0RfTEdTOEdMNSAxCisjZGVmaW5lIExHUzhHWFhfUFJPRF9MR1M4RzQyIDMK
KyNkZWZpbmUgTEdTOEdYWF9QUk9EX0xHUzhHNTIgNAorI2RlZmluZSBMR1M4R1hYX1BST0RfTEdT
OEc1NCA1CisKK3N0cnVjdCBsZ3M4Z3h4X2NvbmZpZyB7CisKKwkvKiBwcm9kdWN0IHR5cGUgKi8K
Kwl1OCBwcm9kOworCisJLyogdGhlIGRlbW9kdWxhdG9yJ3MgaTJjIGFkZHJlc3MgKi8KKwl1OCBk
ZW1vZF9hZGRyZXNzOworCisJLyogcGFyYWxsZWwgb3Igc2VyaWFsIHRyYW5zcG9ydCBzdHJlYW0g
Ki8KKwl1OCBzZXJpYWxfdHM7CisKKwkvKiB0cmFuc3BvcnQgc3RyZWFtIHBvbGFyaXR5Ki8KKwl1
OCB0c19jbGtfcG9sOworCisJLyogdHJhbnNwb3J0IHN0cmVhbSBjbG9jayBnYXRlZCBieSB0c192
YWxpZCAqLworCXU4IHRzX2Nsa19nYXRlZDsKKworCS8qIEEvRCBDbG9jayBmcmVxdWVuY3kgKi8K
Kwl1MzIgaWZfY2xrX2ZyZXE7IC8qIGluIGtIeiAqLworCisJLyogSUYgZnJlcXVlbmN5ICovCisJ
dTMyIGlmX2ZyZXE7IC8qIGluIGtIeiAqLworCisJLypVc2UgRXh0ZXJuYWwgQURDKi8KKwl1OCBl
eHRfYWRjOworCisJLypFeHRlcm5hbCBBREMgb3V0cHV0IHR3bydzIGNvbXBsZW1lbnQqLworCXU4
IGFkY19zaWduZWQ7CisKKwkvKlNhbXBsZSBJRiBkYXRhIGF0IGZhbGxpbmcgZWRnZSBvZiBJRl9D
TEsqLworCXU4IGlmX25lZ19lZGdlOworCisJLypJRiB1c2UgTmVnYXRpdmUgY2VudGVyIGZyZXF1
ZW5jeSovCisJdTggaWZfbmVnX2NlbnRlcjsKKworCS8qIHNsYXZlIGFkZHJlc3MgYW5kIGNvbmZp
Z3VyYXRpb24gb2YgdGhlIHR1bmVyICovCisJdTggdHVuZXJfYWRkcmVzczsKK307CisKKyNpZiBk
ZWZpbmVkKENPTkZJR19EVkJfTEdTOEdYWCkgfHwgXAorCShkZWZpbmVkKENPTkZJR19EVkJfTEdT
OEdYWF9NT0RVTEUpICYmIGRlZmluZWQoTU9EVUxFKSkKK2V4dGVybiBzdHJ1Y3QgZHZiX2Zyb250
ZW5kICpsZ3M4Z3h4X2F0dGFjaChjb25zdCBzdHJ1Y3QgbGdzOGd4eF9jb25maWcgKmNvbmZpZywK
KwkJCQkJICAgc3RydWN0IGkyY19hZGFwdGVyICppMmMpOworI2Vsc2UKK3N0YXRpYyBpbmxpbmUK
K3N0cnVjdCBkdmJfZnJvbnRlbmQgKmxnczhneHhfYXR0YWNoKGNvbnN0IHN0cnVjdCBsZ3M4Z3h4
X2NvbmZpZyAqY29uZmlnLAorCQkJCSAgICBzdHJ1Y3QgaTJjX2FkYXB0ZXIgKmkyYykgeworCXBy
aW50ayhLRVJOX1dBUk5JTkcgIiVzOiBkcml2ZXIgZGlzYWJsZWQgYnkgS2NvbmZpZ1xuIiwgX19m
dW5jX18pOworCXJldHVybiBOVUxMOworfQorI2VuZGlmIC8qIENPTkZJR19EVkJfTEdTOEdYWCAq
LworCisjZW5kaWYgLyogX19MR1M4R1hYX0hfXyAqLwpkaWZmIC1yIDZmMDg4OWZkYTMxNyBsaW51
eC9kcml2ZXJzL21lZGlhL2R2Yi9mcm9udGVuZHMvbGdzOGd4eF9wcml2LmgKLS0tIC9kZXYvbnVs
bAlUaHUgSmFuIDAxIDAwOjAwOjAwIDE5NzAgKzAwMDAKKysrIGIvbGludXgvZHJpdmVycy9tZWRp
YS9kdmIvZnJvbnRlbmRzL2xnczhneHhfcHJpdi5oCVdlZCBBcHIgMDEgMTU6Mjg6MDQgMjAwOSAr
MDgwMApAQCAtMCwwICsxLDcwIEBACisvKgorICogICAgU3VwcG9ydCBmb3IgTGVnZW5kIFNpbGlj
b24gRE1CLVRIIGRlbW9kdWxhdG9yCisgKiAgICBMR1M4OTEzLCBMR1M4R0w1CisgKiAgICBleHBl
cmltZW50YWwgc3VwcG9ydCBMR1M4RzQyLCBMR1M4RzUyCisgKgorICogICAgQ29weXJpZ2h0IChD
KSAyMDA3LDIwMDggRGF2aWQgVC5MLiBXb25nIDxkYXZpZHRsd29uZ0BnbWFpbC5jb20+CisgKiAg
ICBDb3B5cmlnaHQgKEMpIDIwMDggU2lyaXVzIEludGVybmF0aW9uYWwgKEhvbmcgS29uZykgTGlt
aXRlZAorICogICAgVGltb3RoeSBMZWUgPHRpbW90aHkubGVlQHNpcml1c2hrLmNvbT4gKGZvciBp
bml0aWFsIHdvcmsgb24gTEdTOEdMNSkKKyAqCisgKiAgICBUaGlzIHByb2dyYW0gaXMgZnJlZSBz
b2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeQorICogICAgaXQg
dW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJs
aXNoZWQgYnkKKyAqICAgIHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb247IGVpdGhlciB2ZXJz
aW9uIDIgb2YgdGhlIExpY2Vuc2UsIG9yCisgKiAgICAoYXQgeW91ciBvcHRpb24pIGFueSBsYXRl
ciB2ZXJzaW9uLgorICoKKyAqICAgIFRoaXMgcHJvZ3JhbSBpcyBkaXN0cmlidXRlZCBpbiB0aGUg
aG9wZSB0aGF0IGl0IHdpbGwgYmUgdXNlZnVsLAorICogICAgYnV0IFdJVEhPVVQgQU5ZIFdBUlJB
TlRZOyB3aXRob3V0IGV2ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YKKyAqICAgIE1FUkNIQU5U
QUJJTElUWSBvciBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRS4gIFNlZSB0aGUKKyAq
ICAgIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGZvciBtb3JlIGRldGFpbHMuCisgKgorICog
ICAgWW91IHNob3VsZCBoYXZlIHJlY2VpdmVkIGEgY29weSBvZiB0aGUgR05VIEdlbmVyYWwgUHVi
bGljIExpY2Vuc2UKKyAqICAgIGFsb25nIHdpdGggdGhpcyBwcm9ncmFtOyBpZiBub3QsIHdyaXRl
IHRvIHRoZSBGcmVlIFNvZnR3YXJlCisgKiAgICBGb3VuZGF0aW9uLCBJbmMuLCA2NzUgTWFzcyBB
dmUsIENhbWJyaWRnZSwgTUEgMDIxMzksIFVTQS4KKyAqCisgKi8KKworI2lmbmRlZiBMR1M4OTEz
X1BSSVZfSAorI2RlZmluZSBMR1M4OTEzX1BSSVZfSAorCitzdHJ1Y3QgbGdzOGd4eF9zdGF0ZSB7
CisJc3RydWN0IGkyY19hZGFwdGVyICppMmM7CisJLyogY29uZmlndXJhdGlvbiBzZXR0aW5ncyAq
LworCWNvbnN0IHN0cnVjdCBsZ3M4Z3h4X2NvbmZpZyAqY29uZmlnOworCXN0cnVjdCBkdmJfZnJv
bnRlbmQgZnJvbnRlbmQ7CisJdTE2IGN1cnJfZ2k7IC8qIGN1cnJlbnQgZ3VhcmQgaW50ZXJ2YWwg
Ki8KK307CisKKyNkZWZpbmUgU0NfTUFTSwkJMHgxQwkvKiBTdWItQ2FycmllciBNb2R1bGF0aW9u
IE1hc2sgKi8KKyNkZWZpbmUgU0NfUUFNNjQJMHgxMAkvKiA2NFFBTSBtb2R1bGF0aW9uICovCisj
ZGVmaW5lIFNDX1FBTTMyCTB4MEMJLyogMzJRQU0gbW9kdWxhdGlvbiAqLworI2RlZmluZSBTQ19R
QU0xNgkweDA4CS8qIDE2UUFNIG1vZHVsYXRpb24gKi8KKyNkZWZpbmUgU0NfUUFNNE5SCTB4MDQJ
LyogNFFBTSBtb2R1bGF0aW9uICovCisjZGVmaW5lIFNDX1FBTTQJCTB4MDAJLyogNFFBTSBtb2R1
bGF0aW9uICovCisKKyNkZWZpbmUgTEdTX0ZFQ19NQVNLCTB4MDMJLyogRkVDIFJhdGUgTWFzayAq
LworI2RlZmluZSBMR1NfRkVDXzBfNAkweDAwCS8qIEZFQyBSYXRlIDAuNCAqLworI2RlZmluZSBM
R1NfRkVDXzBfNgkweDAxCS8qIEZFQyBSYXRlIDAuNiAqLworI2RlZmluZSBMR1NfRkVDXzBfOAkw
eDAyCS8qIEZFQyBSYXRlIDAuOCAqLworCisjZGVmaW5lIFRJTV9NQVNLCSAgMHgyMAkvKiBUaW1l
IEludGVybGVhdmUgTGVuZ3RoIE1hc2sgKi8KKyNkZWZpbmUgVElNX0xPTkcJICAweDAwCS8qIFRp
bWUgSW50ZXJsZWF2ZSBMZW5ndGggPSA3MjAgKi8KKyNkZWZpbmUgVElNX01JRERMRSAgICAgMHgy
MCAgIC8qIFRpbWUgSW50ZXJsZWF2ZSBMZW5ndGggPSAyNDAgKi8KKworI2RlZmluZSBDRl9NQVNL
CTB4ODAJLyogQ29udHJvbCBGcmFtZSBNYXNrICovCisjZGVmaW5lIENGX0VOCTB4ODAJLyogQ29u
dHJvbCBGcmFtZSBPbiAqLworCisjZGVmaW5lIEdJX01BU0sJMHgwMwkvKiBHdWFyZCBJbnRlcnZh
bCBNYXNrICovCisjZGVmaW5lIEdJXzQyMAkweDAwCS8qIDEvOSBHdWFyZCBJbnRlcnZhbCAqLwor
I2RlZmluZSBHSV81OTUJMHgwMQkvKiAqLworI2RlZmluZSBHSV85NDUJMHgwMgkvKiAxLzQgR3Vh
cmQgSW50ZXJ2YWwgKi8KKworCisjZGVmaW5lIFRTX1BBUkFMTEVMCTB4MDAJLyogUGFyYWxsZWwg
VFMgT3V0cHV0IGEuay5hLiBTUEkgKi8KKyNkZWZpbmUgVFNfU0VSSUFMCTB4MDEJLyogU2VyaWFs
IFRTIE91dHB1dCBhLmsuYS4gU1NJICovCisjZGVmaW5lIFRTX0NMS19OT1JNQUwJCTB4MDAJLyog
TVBFRyBDbG9jayBOb3JtYWwgKi8KKyNkZWZpbmUgVFNfQ0xLX0lOVkVSVEVECQkweDAyCS8qIE1Q
RUcgQ2xvY2sgSW52ZXJ0ZWQgKi8KKyNkZWZpbmUgVFNfQ0xLX0dBVEVECQkweDAwCS8qIE1QRUcg
Y2xvY2sgZ2F0ZWQgKi8KKyNkZWZpbmUgVFNfQ0xLX0ZSRUVSVU4JCTB4MDQJLyogTVBFRyBjbG9j
ayBmcmVlIHJ1bm5pbmcqLworCisKKyNlbmRpZgo=
--000e0cd14dee017dee0466795bf6--
