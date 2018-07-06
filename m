Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47128 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753453AbeGFA1a (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 20:27:30 -0400
Date: Thu, 5 Jul 2018 21:27:23 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: "Katsuhiro Suzuki" <suzuki.katsuhiro@socionext.com>
Cc: <linux-media@vger.kernel.org>,
        "Masami Hiramatsu" <masami.hiramatsu@linaro.org>,
        "Jassi Brar" <jaswinder.singh@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Abylay Ospan <aospan@netup.ru>
Subject: Re: [PATCH v3] media: dvb-frontends: add Socionext SC1501A ISDB-S/T
 demodulator driver
Message-ID: <20180705212723.2856f064@coco.lan>
In-Reply-To: <000501d41423$265013a0$72f03ae0$@socionext.com>
References: <20180621031748.21703-1-suzuki.katsuhiro@socionext.com>
        <20180704135657.3fd607cb@coco.lan>
        <000401d41403$b33db490$19b91db0$@socionext.com>
        <20180704234244.32d20f6b@coco.lan>
        <000501d41423$265013a0$72f03ae0$@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 5 Jul 2018 14:43:49 +0900
"Katsuhiro Suzuki" <suzuki.katsuhiro@socionext.com> escreveu:

> Hi Mauro,
>=20
> Thank you very much! Great works.
> Your patches works fine with my driver (modified max/min frequencies).

Sent a new version of it to the Mailing List.

>=20
> Tested-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>

Thanks for testing. I did an update of the patchset at:

	https://git.linuxtv.org/mchehab/experimental.git/log/?h=3Ddvb_freq_hz_v2=20

and added a third patch to it.


Could you please test it again using the latest version of dvb-fe-tool
from its git tree:

	https://git.linuxtv.org/v4l-utils.git/

After compiling/installing, please call it like:

	$ dvb-fe-tool -d isdbt
	$ dvb-fe-tool=20
	$ dvb-fe-tool -d isdbs
	$ dvb-fe-tool=20

When called without arguments, it will show the frequency range as
reported by FE_GET_INFO (and used internally by the Kernel), e. g.
it will display something like:

    $ dvb-fe-tool
    Device DiBcom 8000 ISDB-T (/dev/dvb/adapter0/frontend0) capabilities:
         CAN_FEC_1_2
         CAN_FEC_2_3
         CAN_FEC_3_4
         CAN_FEC_5_6
         CAN_FEC_7_8
         CAN_FEC_AUTO
         CAN_GUARD_INTERVAL_AUTO
         CAN_HIERARCHY_AUTO
         CAN_INVERSION_AUTO
         CAN_QAM_16
         CAN_QAM_64
         CAN_QAM_AUTO
         CAN_QPSK
         CAN_RECOVER
         CAN_TRANSMISSION_MODE_AUTO
    DVB API Version 5.11, Current v5 delivery system: ISDBT
    Supported delivery system:=20
        [ISDBT]
    Frequency range for the current standard:=20
    From:            45.0 MHz
    To:               860 MHz
    Step:            62.5 kHz


>=20
>=20
> And I have one question in the below.
>=20
>=20
> > -----Original Message-----
> > From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > Sent: Thursday, July 5, 2018 11:43 AM
> > To: Suzuki, Katsuhiro/=E9=88=B4=E6=9C=A8 =E5=8B=9D=E5=8D=9A <suzuki.kat=
suhiro@socionext.com>
> > Cc: linux-media@vger.kernel.org; Masami Hiramatsu <masami.hiramatsu@lin=
aro.org>;
> > Jassi Brar <jaswinder.singh@linaro.org>; linux-arm-kernel@lists.infrade=
ad.org;
> > linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH v3] media: dvb-frontends: add Socionext SC1501A ISD=
B-S/T
> > demodulator driver
> >=20
> > Em Thu, 5 Jul 2018 10:58:42 +0900
> > "Katsuhiro Suzuki" <suzuki.katsuhiro@socionext.com> escreveu:
> >  =20
> > > Hi Mauro,
> > > =20
> > > > -----Original Message-----
> > > > From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > > > Sent: Thursday, July 5, 2018 1:58 AM
> > > > To: Suzuki, Katsuhiro/=E9=88=B4=E6=9C=A8 =E5=8B=9D=E5=8D=9A <suzuki=
.katsuhiro@socionext.com>
> > > > Cc: linux-media@vger.kernel.org; Masami Hiramatsu =20
> > > <masami.hiramatsu@linaro.org>; =20
> > > > Jassi Brar <jaswinder.singh@linaro.org>; =20
> > linux-arm-kernel@lists.infradead.org; =20
> > > > linux-kernel@vger.kernel.org
> > > > Subject: Re: [PATCH v3] media: dvb-frontends: add Socionext SC1501A=
 ISDB-S/T
> > > > demodulator driver
> > > >
> > > > Hi Katsuhiro-san,
> > > >
> > > > Em Thu, 21 Jun 2018 12:17:48 +0900
> > > > Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com> escreveu:
> > > > =20
> > > > > This patch adds a frontend driver for the Socionext SC1501A series
> > > > > and Socionext MN88443x ISDB-S/T demodulators. =20
> > > >
> > > > Sorry for taking so long to review it. We're missing a sub-maintain=
er
> > > > for DVB, with would otherwise speed up reviews of DVB patches. =20
> > >
> > > No problem, thank you for reviewing! I appreciate it.
> > >
> > > =20
> > > > >
> > > > > The maximum and minimum frequency of Socionext SC1501A comes from
> > > > > ISDB-S and ISDB-T so frequency range is the following:
> > > > >   - ISDB-S (BS/CS110 IF frequency in kHz, Local freq 10.678GHz)
> > > > >     - Min: BS-1: 1032000 =3D> 1032.23MHz
> > > > >     - Max: ND24: 2701000 =3D> 2070.25MHz
> > > > >   - ISDB-T (in Hz)
> > > > >     - Min: ch13: 470000000 =3D> 470.357857MHz
> > > > >     - Max: ch62: 770000000 =3D> 769.927857MHz =20
> > > >
> > > > There is actually an error on that part of the driver. Right now,
> > > > the DVB core expects Satellite frequencies (DVB-S, ISDB-S, ...)
> > > > in kHz. For all other delivery systems, it is in Hz.
> > > >
> > > > It is this way due to historic reasons. While it won't be hard to
> > > > change the core, that would require to touch all Satellite drivers.
> > > >
> > > > As there are very few frontend drivers that accept both Satellite
> > > > and Terrestrial standards, what we do, instead, is to setup
> > > > two frontends. See, for example, drivers/media/dvb-frontends/helene=
.c.
> > > > =20
> > >
> > > Thank you for describing it. I understand our device is rare case, and
> > > the reason why Helene has Terrestrial and Satellite structures.
> > >
> > > I'm using MN884434 device that has 2 cores. I want to setup DVB adapt=
er
> > > devices (/dev/dvb/adapter0/*) for our frontend system as the followin=
g:
> > >
> > >   - adapter0: for core 0, ISDB-T, ISDB-S
> > >   - adapter1: for core 1, ISDB-T, ISDB-S =20
> >=20
> > Yeah, that is what it was supposed to work, if the core was ready for i=
t.
> >  =20
> > > But it seems one DVB adapter device support only ISDB-T or only ISDB-S
> > > if I divide structures. So I define the adapters as the following:
> > >
> > >   - adapter0: for core 0, ISDB-T
> > >   - adapter1: for core 0, ISDB-S
> > >   - adapter2: for core 1, ISDB-T
> > >   - adapter3: for core 1, ISDB-S
> > >
> > > Is this correct? =20
> >=20
> > That's the way the current driver with uses helene does.
> >  =20
> > >
> > > =20
> > > > ... =20
> > > > > +static const struct dvb_frontend_ops sc1501a_ops =3D {
> > > > > +	.delsys =3D { SYS_ISDBS, SYS_ISDBT },
> > > > > +	.info =3D {
> > > > > +		.name          =3D "Socionext SC1501A",
> > > > > +		.frequency_min =3D 1032000,
> > > > > +		.frequency_max =3D 770000000,
> > > > > +		.caps =3D FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO |
> > > > > +			FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO |
> > > > > +			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
> > > > > +	},
> > > > > +
> > > > > +	.sleep                   =3D sc1501a_sleep,
> > > > > +	.set_frontend            =3D sc1501a_set_frontend,
> > > > > +	.get_tune_settings       =3D sc1501a_get_tune_settings,
> > > > > +	.read_status             =3D sc1501a_read_status,
> > > > > +}; =20
> > > >
> > > > In other words, you'll need to declare two structs here, one for IS=
DB-T
> > > > and another one for ISDB-S.
> > > > =20
> > >
> > > OK, I'm going to divide this structure for Terrestrial and Satellite.=
 And
> > > add attach functions same as Helene driver.
> > >
> > > I'll send v4 patch. =20
> >=20
> > I ended by writing two patches that should be solving the issues
> > inside the core. With them[1], it will work the way you want.
> >=20
> > There is a catch: you'll need to convert Helene to have a single
> > entry and be sure that the driver that currently uses it (netup_unidvb)
> > will keep working. I guess I have one such hardware here for testing.
> >=20
> > [1] after tested/reviewed - I didn't test them yet. Feel free to test.
> >  =20
>=20
> Thank you!!
>=20
> I try to fix '[PATCH v4] media: helene: add I2C device probe function'=20
> patch but I have a question...
>=20
> My idea is adding new dvb_tuner_ops structure and I2C probe function for=
=20
> supporting multiple systems. Current drivers (netup) continue to use=20
> helene_attach_t() and helene_attach_s(), so no need to change netup.
> It's conservative but prevent the degrade, I think.

Works for me.

>=20
> Newer added struct dvb_frontend_internal_info has one pair of max/min=20
> frequency. What is the best way to declare the frequency range for
> multiple systems?
>=20
> For example, Helene uses these info for only Ter or Sat freq ranges:
>=20
> 		.name =3D "Sony HELENE Ter tuner",
> 		.frequency_min_hz  =3D    1 * MHz,
> 		.frequency_max_hz  =3D 1200 * MHz,
> 		.frequency_step_hz =3D   25 * kHz,
>=20
> 		.name =3D "Sony HELENE Sat tuner",
> 		.frequency_min_hz  =3D  500 * MHz,
> 		.frequency_max_hz  =3D 2500 * MHz,
> 		.frequency_step_hz =3D    1 * MHz,
>=20
> Is this better to add new info for both system?
>=20
> 		.name =3D "Sony HELENE Sat/Ter tuner",
> 		.frequency_min_hz  =3D    1 * MHz,
> 		.frequency_max_hz  =3D 2500 * MHz,
> 		.frequency_step_hz =3D   25 * kHz, // Is this correct...?

That is indeed a very good question, and maybe a reason why we
may need other approaches.

See, if the tuner is capable of tuning from 1 MHz to 2500 MHz,
the frequency range should be ok. It would aget_frontend_algoctually be pre=
tty cool
to use a tuner with such wide range for SDR, if the hardware supports
raw I/Q collect :-D

The frequency step is a different issue. If the tuner driver uses
DVBFE_ALGO_SW (e. g. if ops.get_frontend_algo() returns it, or if
this function is not defined), then the step will be used to adjust
the zigzag interactions. If it is too small, the tuning will lose
channels if the signal is not strong.

In the specific case of helene, it doesn't have a get_frontend_algo,
so it will use the step frequency.

I'm not sure how to solve this issue. Maybe Abylay may shed a light
here, if helene does sigzag in hardware or not.

If it does in hardware, you could add a get_frontend_algo() routine
at helene driver and return DVBFE_ALGO_HW. The tuning zigzag software
algorithm in the Kernel will stop, as it will rely at the hardware.

Please notice that, if the hardware doesn't do zigzag itself, this
will make it lose channels. On the other hand, if the hardware does
have sigzag, changing to DVBFE_ALGO_HW will speedup tuning, as the
Kernel won't try to do sigzag itself.

>=20
>=20
> > So, please look at the two patches I sent today to the mailing list.
> >=20
> > (not sure why, they're taking a long time to arrive there - perhaps
> > vger has some issues).
> >=20
> > I added them on this tree:
> > 	https://git.linuxtv.org/mchehab/experimental.git/log/?h=3Ddvb_freq_hz
> >=20
> > it is the last two patches there:
> > 	-
> > https://git.linuxtv.org/mchehab/experimental.git/commit/?h=3Ddvb_freq_h=
z&id=3Db3d63
> > a8f038d136b26692bc3a14554960e767f4a
> > 	-
> > https://git.linuxtv.org/mchehab/experimental.git/commit/?h=3Ddvb_freq_h=
z&id=3D2a369
> > e8faf3b277baff4026371f298e95c84fbb2
> >=20
> > I'm not sure if all applications will do the right thing, though, as
> > it will depend  if they query the capabilities before or after switching
> > to a different delivery system. If it get caps before and store them
> > in Hz, apps will work, but tests are required.
> >  =20
>=20
> Ah, indeed. You mean,
>=20
>   - Application want to tune Terrestrial system
>   - Driver is in Satellite system
>   - Application query max/min frequency
>   - DVB API returns max/min frequency in 'kHz'
>   - Some application will get something wrong
>     (ex. app specific range check)

Yes. I guess, however, that most apps won't do range checks themselves,
but this has yet to be checked.

> Unfortunately, I don't know applications that do such scenario.
> My test application does not query max/min range...
>=20
>=20
> > >
> > > =20
> > > > Yeah, I know that this sucks. If you are in the mood of touching the
> > > > DVB core, I'm willing to consider a patch that would fix this, prov=
ided
> > > > that it won't break backward compatibility with other drivers (or w=
ould
> > > > convert the other satellite drivers to use the new way).
> > > >
> > > > Thanks,
> > > > Mauro =20
> > >
> > > Hmm, I don't know the details of DVB core, I try to investigate it.
> > >
> > >
> > > Regards,
> > > --
> > > Katsuhiro Suzuki
> > >
> > >
> > > =20
> >=20
> >=20
> >=20
> > Thanks,
> > Mauro =20
>=20
>=20
> Regards,
> --
> Katsuhiro Suzuki
>=20
>=20
>=20



Thanks,
Mauro
