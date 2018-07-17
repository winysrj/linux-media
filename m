Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56898 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbeGQLbK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 07:31:10 -0400
Date: Tue, 17 Jul 2018 19:58:53 +0900
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: "Katsuhiro Suzuki" <suzuki.katsuhiro@socionext.com>
Cc: <linux-media@vger.kernel.org>,
        "Masami Hiramatsu" <masami.hiramatsu@linaro.org>,
        "Jassi Brar" <jaswinder.singh@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, "Abylay Ospan" <aospan@netup.ru>
Subject: Re: [PATCH v3] media: dvb-frontends: add Socionext SC1501A ISDB-S/T
 demodulator driver
Message-ID: <20180717195853.07b2b42b@vela.lan>
In-Reply-To: <001201d41d94$7370e1d0$5a52a570$@socionext.com>
References: <20180621031748.21703-1-suzuki.katsuhiro@socionext.com>
        <20180704135657.3fd607cb@coco.lan>
        <000401d41403$b33db490$19b91db0$@socionext.com>
        <20180704234244.32d20f6b@coco.lan>
        <000501d41423$265013a0$72f03ae0$@socionext.com>
        <20180705212723.2856f064@coco.lan>
        <001f01d414ef$27145450$753cfcf0$@socionext.com>
        <20180706081603.2d8451c9@coco.lan>
        <002c01d41729$2ff6fa00$8fe4ee00$@socionext.com>
        <20180709105938.3d2f8391@coco.lan>
        <004501d417f8$c83a01c0$58ae0540$@socionext.com>
        <001201d41d94$7370e1d0$5a52a570$@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 17 Jul 2018 15:07:32 +0900
"Katsuhiro Suzuki" <suzuki.katsuhiro@socionext.com> escreveu:

> Hello Mauro,
>=20
> I want to send next version (v4) of this patch (just fix wrong max/min ra=
nge of=20
> frequency, fix symbol rate). But it depends your patches for DVB cores.
>=20
> Which way is better?
>=20
>   - Send next version now
>   - Send next version after your DVB cores patches applied
>=20
> I want to try to solve LNB problem after current codes applied. I think L=
NB IC=20
> will be defined as regulator device. Please tell me if you have comments =
about
> it.

I'm out of the town this week, but you can send it. No need to wait for
my patches. Just add a notice that the patch depends on them. I'll
handle after returning back from my trip.

>=20
>=20
> Regards,
> --
> Katsuhiro Suzuki
>=20
>=20
> > -----Original Message-----
> > From: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
> > Sent: Tuesday, July 10, 2018 11:51 AM
> > To: 'Mauro Carvalho Chehab' <mchehab+samsung@kernel.org>; Suzuki, Katsu=
hiro/=E9=88=B4=E6=9C=A8
> > =E5=8B=9D=E5=8D=9A <suzuki.katsuhiro@socionext.com>
> > Cc: linux-media@vger.kernel.org; Masami Hiramatsu <masami.hiramatsu@lin=
aro.org>;
> > Jassi Brar <jaswinder.singh@linaro.org>; linux-arm-kernel@lists.infrade=
ad.org;
> > linux-kernel@vger.kernel.org; Abylay Ospan <aospan@netup.ru>
> > Subject: Re: [PATCH v3] media: dvb-frontends: add Socionext SC1501A ISD=
B-S/T
> > demodulator driver
> >=20
> > Hello Mauro,
> >  =20
> > > -----Original Message-----
> > > From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > > Sent: Monday, July 9, 2018 11:00 PM
> > > To: Suzuki, Katsuhiro/=E9=88=B4=E6=9C=A8 =E5=8B=9D=E5=8D=9A <suzuki.k=
atsuhiro@socionext.com>
> > > Cc: linux-media@vger.kernel.org; Masami Hiramatsu =20
> > <masami.hiramatsu@linaro.org>; =20
> > > Jassi Brar <jaswinder.singh@linaro.org>; linux-arm-kernel@lists.infra=
dead.org;
> > > linux-kernel@vger.kernel.org; Abylay Ospan <aospan@netup.ru>
> > > Subject: Re: [PATCH v3] media: dvb-frontends: add Socionext SC1501A I=
SDB-S/T
> > > demodulator driver
> > >
> > > Em Mon, 9 Jul 2018 11:04:36 +0900
> > > "Katsuhiro Suzuki" <suzuki.katsuhiro@socionext.com> escreveu:
> > > =20
> > > > Hello Mauro,
> > > > =20
> > > > > -----Original Message-----
> > > > > From: linux-media-owner@vger.kernel.org <linux-media-owner@vger.k=
ernel.org> =20
> > > On =20
> > > > > Behalf Of Mauro Carvalho Chehab
> > > > > Sent: Friday, July 6, 2018 8:16 PM
> > > > > To: Suzuki, Katsuhiro/=E9=88=B4=E6=9C=A8 =E5=8B=9D=E5=8D=9A <suzu=
ki.katsuhiro@socionext.com>
> > > > > Cc: linux-media@vger.kernel.org; Masami Hiramatsu =20
> > > > <masami.hiramatsu@linaro.org>; =20
> > > > > Jassi Brar <jaswinder.singh@linaro.org>; =20
> > > linux-arm-kernel@lists.infradead.org; =20
> > > > > linux-kernel@vger.kernel.org; Abylay Ospan <aospan@netup.ru>
> > > > > Subject: Re: [PATCH v3] media: dvb-frontends: add Socionext SC150=
1A ISDB-S/T
> > > > > demodulator driver
> > > > >
> > > > > Em Fri, 6 Jul 2018 15:04:08 +0900
> > > > > "Katsuhiro Suzuki" <suzuki.katsuhiro@socionext.com> escreveu:
> > > > > =20
> > > > > > Here is the log of dvb-fe-tool on my environment.
> > > > > >
> > > > > > --------------------
> > > > > > # ./utils/dvb/.libs/dvb-fe-tool -d isdbs
> > > > > > Changing delivery system to: ISDBS
> > > > > > ERROR    FE_SET_VOLTAGE: Unknown error 524 =20
> > > > >
> > > > > Hmm... ENOTSUPP. Doesn't the device supposed to be able to power =
on the
> > > > > LNBf? =20
> > > >
> > > > Ah, maybe it's not implemented yet in Helene driver. =20
> > >
> > > That depends on how the hardware works. On some hardware, the
> > > LNBf power supply and control is at the demod; on others, it is
> > > supported by a separate chipset. See, for example, isl642.c for
> > > an example of such external hardware.
> > >
> > > I don't know much about ISDB-S, but, as far as what was
> > > implemented on v4l-utils dvb-sat.c for Japan 110BS/CS LNBf,
> > > the LNBf voltage is not used to switch the polarity.
> > >
> > > So, the control here is simpler than on DVB-S/S2, as the only
> > > control is either to send 18V to power on the LNBf/Dish, or
> > > zero in order to save power.
> > > =20
> >=20
> > Thank you, I misunderstood about LNB. I checked circuit of evaluation
> > board, the board has discrete LNB IC (ST micro LNBH29) for supplying
> > voltage to Helene. This IC is controlled by I2C.
> >=20
> > The standard (ARIB STD-B21) says DC 15V power is needed to drive the
> > converter (BS freq -> BS-IF freq) of BS dish antenna. This power
> > can be supplied via antenna line.
> >=20
> > It seems,
> >   LNBH29 --(LNB_PWR)--> Helene --> BS antenna
> >=20
> > I don't know enough about Helene, but it maybe supply 15V power to
> > converter of BS dish via antenna line if it receive 15V LNB_PWR...
> >=20
> >=20
> > I don't have idea about controlling this IC. Should I write some
> > driver for LNBH29, and pass the phandle to demodulator via device
> > tree??
> >=20
> >  =20
> > > >
> > > > =20
> > > > >
> > > > > Anyway, I changed the error print message to be clearer, displayi=
ng
> > > > > instead:
> > > > >
> > > > >   ERROR    FE_SET_VOLTAGE: driver doesn't support it!
> > > > > =20
> > > >
> > > > It's nice for users. Thanks!
> > > >
> > > > =20
> > > > > >
> > > > > > # ./utils/dvb/.libs/dvb-fe-tool
> > > > > > Device Socionext SC1501A (/dev/dvb/adapter0/frontend0) capabili=
ties:
> > > > > >      CAN_FEC_AUTO
> > > > > >      CAN_GUARD_INTERVAL_AUTO
> > > > > >      CAN_HIERARCHY_AUTO
> > > > > >      CAN_INVERSION_AUTO
> > > > > >      CAN_QAM_AUTO
> > > > > >      CAN_TRANSMISSION_MODE_AUTO
> > > > > > DVB API Version 5.11, Current v5 delivery system: ISDBS
> > > > > > Supported delivery systems:
> > > > > >     [ISDBS]
> > > > > >      ISDBT
> > > > > > Frequency range for the current standard:
> > > > > > From:             470 MHz
> > > > > > To:              2.07 GHz
> > > > > > Step:            25.0 kHz
> > > > > > Symbol rate ranges for the current standard:
> > > > > > From:                 0Bauds
> > > > > > To:                   0Bauds =20
> > > > >
> > > > > That seems a driver issue. The ISDB-S ops.info should be
> > > > > filling both symbol_rate_min and symbol_rate_max.
> > > > >
> > > > > I suspect that both should be filled with 28860000.
> > > > >
> > > > > The dvb_frontend.c core might hardcode it, but, IMHO,
> > > > > it is better to keep those information inside the
> > > > > tuner/frontend ops.info.
> > > > > =20
> > > >
> > > > Indeed, thank you for reviewing. I fixed my driver. It seems works =
fine.
> > > >
> > > > ----
> > > > # utils/dvb/.libs/dvb-fe-tool -a 0
> > > > Device Socionext SC1501A (/dev/dvb/adapter0/frontend0) capabilities:
> > > >      CAN_FEC_AUTO
> > > >      CAN_GUARD_INTERVAL_AUTO
> > > >      CAN_HIERARCHY_AUTO
> > > >      CAN_INVERSION_AUTO
> > > >      CAN_QAM_AUTO
> > > >      CAN_TRANSMISSION_MODE_AUTO
> > > > DVB API Version 5.11, Current v5 delivery system: ISDBS
> > > > Supported delivery systems:
> > > >     [ISDBS]
> > > >      ISDBT
> > > > Frequency range for the current standard:
> > > > From:             470 MHz
> > > > To:              2.07 GHz
> > > > Step:            25.0 kHz
> > > > Symbol rate ranges for the current standard:
> > > > From:            28.9 MBauds
> > > > To:              28.9 MBauds
> > > > SEC: set voltage to OFF
> > > > ERROR    FE_SET_VOLTAGE: Operation not permitted
> > > > ---- =20
> > >
> > > That sounds ok.
> > > =20
> > > >
> > > > =20
> > > > > > SEC: set voltage to OFF
> > > > > > ERROR    FE_SET_VOLTAGE: Operation not permitted
> > > > > >
> > > > > >
> > > > > > # ./utils/dvb/.libs/dvb-fe-tool -d isdbt
> > > > > > Changing delivery system to: ISDBT
> > > > > > ERROR    FE_SET_VOLTAGE: Unknown error 524
> > > > > >
> > > > > > # ./utils/dvb/.libs/dvb-fe-tool
> > > > > > Device Socionext SC1501A (/dev/dvb/adapter0/frontend0) capabili=
ties:
> > > > > >      CAN_FEC_AUTO
> > > > > >      CAN_GUARD_INTERVAL_AUTO
> > > > > >      CAN_HIERARCHY_AUTO
> > > > > >      CAN_INVERSION_AUTO
> > > > > >      CAN_QAM_AUTO
> > > > > >      CAN_TRANSMISSION_MODE_AUTO
> > > > > > DVB API Version 5.11, Current v5 delivery system: ISDBT
> > > > > > Supported delivery systems:
> > > > > >      ISDBS
> > > > > >     [ISDBT]
> > > > > > Frequency range for the current standard:
> > > > > > From:             470 MHz
> > > > > > To:              2.07 GHz
> > > > > > Step:            25.0 kHz =20
> > > > >
> > > > > The rest looks OK for me.
> > > > > =20
> > > > > > > > For example, Helene uses these info for only Ter or Sat fre=
q ranges:
> > > > > > > >
> > > > > > > > 		.name =3D "Sony HELENE Ter tuner",
> > > > > > > > 		.frequency_min_hz  =3D    1 * MHz,
> > > > > > > > 		.frequency_max_hz  =3D 1200 * MHz,
> > > > > > > > 		.frequency_step_hz =3D   25 * kHz,
> > > > > > > >
> > > > > > > > 		.name =3D "Sony HELENE Sat tuner",
> > > > > > > > 		.frequency_min_hz  =3D  500 * MHz,
> > > > > > > > 		.frequency_max_hz  =3D 2500 * MHz,
> > > > > > > > 		.frequency_step_hz =3D    1 * MHz,
> > > > > > > >
> > > > > > > > Is this better to add new info for both system?
> > > > > > > >
> > > > > > > > 		.name =3D "Sony HELENE Sat/Ter tuner",
> > > > > > > > 		.frequency_min_hz  =3D    1 * MHz,
> > > > > > > > 		.frequency_max_hz  =3D 2500 * MHz,
> > > > > > > > 		.frequency_step_hz =3D   25 * kHz, // Is this correct...?=
 =20
> > > > > > >
> > > > > > > That is indeed a very good question, and maybe a reason why we
> > > > > > > may need other approaches.
> > > > > > >
> > > > > > > See, if the tuner is capable of tuning from 1 MHz to 2500 MHz,
> > > > > > > the frequency range should be ok. It would aget_frontend_algo=
ctually be =20
> > > > pretty =20
> > > > > cool =20
> > > > > > > to use a tuner with such wide range for SDR, if the hardware =
supports
> > > > > > > raw I/Q collect :-D
> > > > > > >
> > > > > > > The frequency step is a different issue. If the tuner driver =
uses
> > > > > > > DVBFE_ALGO_SW (e. g. if ops.get_frontend_algo() returns it, o=
r if
> > > > > > > this function is not defined), then the step will be used to =
adjust
> > > > > > > the zigzag interactions. If it is too small, the tuning will =
lose
> > > > > > > channels if the signal is not strong.
> > > > > > > =20
> > > > > >
> > > > > > Thank you for describing. It's difficult problem... =20
> > > > >
> > > > > I double-checked the implementation. We don't need to worry about
> > > > > zigzag, provided that the ISDB-S implementation at the core is co=
rrect.
> > > > >
> > > > > For satellite/cable standards, the zigzag logic takes the symbol
> > > > > rate into account, and not the stepsize:
> > > > >
> > > > >                 case SYS_DVBS:
> > > > >                 case SYS_DVBS2:
> > > > >                 case SYS_ISDBS:
> > > > >                 case SYS_TURBO:
> > > > >                 case SYS_DVBC_ANNEX_A:
> > > > >                 case SYS_DVBC_ANNEX_C:
> > > > >                         fepriv->min_delay =3D HZ / 20;
> > > > >                         fepriv->step_size =3D c->symbol_rate / 16=
000;
> > > > >                         fepriv->max_drift =3D c->symbol_rate / 20=
00;
> > > > >                         break;
> > > > >
> > > > > For terrestrial standards, it uses the stepsize:
> > > > >
> > > > >                 case SYS_DVBT:
> > > > >                 case SYS_DVBT2:
> > > > >                 case SYS_ISDBT:
> > > > >                 case SYS_DTMB:
> > > > >                         fepriv->min_delay =3D HZ / 20;
> > > > >                         fepriv->step_size =3D dvb_frontend_get_st=
epsize(fe) * =20
> > > 2; =20
> > > > >                         fepriv->max_drift =3D (dvb_frontend_get_s=
tepsize(fe) =20
> > * =20
> > > 2) =20
> > > > + =20
> > > > > 1;
> > > > >                         break;
> > > > >
> > > > > So, having a value of 25 kHz there won't affect the zigzag algori=
thm
> > > > > for ISDB-S, as it will be used only for ISDB-T.
> > > > > =20
> > > >
> > > > Thank you for checking and describing. I checked it too.
> > > >
> > > > Default value is fine as you said, and we can use get_tune_settings=
()
> > > > callback if we face the problem or need different settings for each
> > > > delivery systems in the future.
> > > >
> > > >         /* get frontend-specific tuning settings */
> > > >         memset(&fetunesettings, 0, sizeof(struct =20
> > dvb_frontend_tune_settings)); =20
> > > >         if (fe->ops.get_tune_settings && (fe->ops.get_tune_settings=
(fe,
> > > > &fetunesettings) =3D=3D 0)) {
> > > >                 fepriv->min_delay =3D (fetunesettings.min_delay_ms =
* HZ) / 1000;
> > > >                 fepriv->max_drift =3D fetunesettings.max_drift;
> > > >                 fepriv->step_size =3D fetunesettings.step_size;
> > > >         } else {
> > > >                 /* default values */
> > > >                 ... =20
> > >
> > > Sure.
> > > =20
> > > >
> > > > =20
> > > > > > > In the specific case of helene, it doesn't have a get_fronten=
d_algo,
> > > > > > > so it will use the step frequency.
> > > > > > >
> > > > > > > I'm not sure how to solve this issue. Maybe Abylay may shed a=
 light
> > > > > > > here, if helene does sigzag in hardware or not.
> > > > > > > =20
> > > > > >
> > > > > > As far as I know, Helene does not have automatic scan mechanism=
 in
> > > > > > hardware. =20
> > > > >
> > > > > Ok, so the driver is doing the right thing here.
> > > > > =20
> > > > > > > If it does in hardware, you could add a get_frontend_algo() r=
outine
> > > > > > > at helene driver and return DVBFE_ALGO_HW. The tuning zigzag =
software
> > > > > > > algorithm in the Kernel will stop, as it will rely at the har=
dware.
> > > > > > >
> > > > > > > Please notice that, if the hardware doesn't do zigzag itself,=
 this
> > > > > > > will make it lose channels. On the other hand, if the hardwar=
e does
> > > > > > > have sigzag, changing to DVBFE_ALGO_HW will speedup tuning, a=
s the
> > > > > > > Kernel won't try to do sigzag itself.
> > > > > > > =20
> > > > > >
> > > > > > ISDB-T uses 6MHz bandwidth per channel (in Japan), ISDB-S for
> > > > > > BS/CS110 uses 38.36MHz bandwidth. Maybe 1MHz zigzag step is lar=
ge for
> > > > > > ISDB-T system and 25kHz is small for ISDB-S system. =20
> > > > >
> > > > > Yeah, but, after double-checking the logic, for ISDB-S, it will
> > > > > use:
> > > > >
> > > > > 	c->symbol_rate =3D 28860000;
> > > > > 	c->rolloff =3D ROLLOFF_35;
> > > > > 	c->bandwidth_hz =3D c->symbol_rate / 100 * 135;
> > > > >
> > > > > That would actually set the ISDB-S channel separation to 38.961 M=
Hz.
> > > > >
> > > > > By setting symbol_rate like that, the zigzag for ISDB-S will
> > > > > be defined by:
> > > > >
> > > > >        fepriv->step_size =3D c->symbol_rate / 16000; /* 38.961MHz=
 / 16000 =3D =20
> > > > .002435 =20
> > > > > - e. g. steps of ~25 kHz */
> > > > >        fepriv->max_drift =3D c->symbol_rate / 2000;  /* 38.961MHz=
 / 2000 =3D =20
> > > > .0194805 =20
> > > > > - e. g. max drift of ~195 kHz */
> > > > >
> > > > > Funny enough, it will be using about 25 kHz as step size for ISDB=
-S.
> > > > >
> > > > > I have no idea if the ISDB-S standard defines the zigzag logic,
> > > > > but I would be expecting a higher value for it. So, perhaps
> > > > > the ISDB-S zigzag could be optimized.
> > > > >
> > > > > Thanks,
> > > > > Mauro =20
> > > >
> > > > Hmm, interesting. I don't know zigzag for ISDB-S too, sorry...
> > > >
> > > > Anyway, I don't worry about that. I said in above, we can use
> > > > get_tune_settings() for fine tuning.
> > > >
> > > >
> > > > Regards,
> > > > --
> > > > Katsuhiro Suzuki
> > > >
> > > >
> > > > =20
> > >
> > >
> > >
> > > Thanks,
> > > Mauro =20
> >  =20
>=20
>=20
>=20




Cheers,
Mauro
