Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.socionext.com ([202.248.49.38]:14513 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932603AbeGFGEO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Jul 2018 02:04:14 -0400
From: "Katsuhiro Suzuki" <suzuki.katsuhiro@socionext.com>
To: "'Mauro Carvalho Chehab'" <mchehab+samsung@kernel.org>,
        =?utf-8?B?U3V6dWtpLCBLYXRzdWhpcm8v6Yi05pyoIOWLneWNmg==?=
        <suzuki.katsuhiro@socionext.com>
Cc: <linux-media@vger.kernel.org>,
        "Masami Hiramatsu" <masami.hiramatsu@linaro.org>,
        "Jassi Brar" <jaswinder.singh@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, "Abylay Ospan" <aospan@netup.ru>
References: <20180621031748.21703-1-suzuki.katsuhiro@socionext.com>     <20180704135657.3fd607cb@coco.lan>      <000401d41403$b33db490$19b91db0$@socionext.com> <20180704234244.32d20f6b@coco.lan>      <000501d41423$265013a0$72f03ae0$@socionext.com> <20180705212723.2856f064@coco.lan>
In-Reply-To: <20180705212723.2856f064@coco.lan>
Subject: Re: [PATCH v3] media: dvb-frontends: add Socionext SC1501A ISDB-S/T demodulator driver
Date: Fri, 6 Jul 2018 15:04:08 +0900
Message-ID: <001f01d414ef$27145450$753cfcf0$@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Language: ja
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

Thank you for new patches, it works fine.

Detail log is the below:


> -----Original Message-----
> From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> Sent: Friday, July 6, 2018 9:27 AM
> To: Suzuki, Katsuhiro/鈴木 勝博 <suzuki.katsuhiro@socionext.com>
> Cc: linux-media@vger.kernel.org; Masami Hiramatsu <masami.hiramatsu@linaro.org>;
> Jassi Brar <jaswinder.singh@linaro.org>; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org; Abylay Ospan <aospan@netup.ru>
> Subject: Re: [PATCH v3] media: dvb-frontends: add Socionext SC1501A ISDB-S/T
> demodulator driver
> 
> Em Thu, 5 Jul 2018 14:43:49 +0900
> "Katsuhiro Suzuki" <suzuki.katsuhiro@socionext.com> escreveu:
> 
> > Hi Mauro,
> >
> > Thank you very much! Great works.
> > Your patches works fine with my driver (modified max/min frequencies).
> 
> Sent a new version of it to the Mailing List.
> 
> >
> > Tested-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
> 
> Thanks for testing. I did an update of the patchset at:
> 
> 	https://git.linuxtv.org/mchehab/experimental.git/log/?h=dvb_freq_hz_v2
> 
> and added a third patch to it.
> 
> 
> Could you please test it again using the latest version of dvb-fe-tool
> from its git tree:
> 
> 	https://git.linuxtv.org/v4l-utils.git/
> 
> After compiling/installing, please call it like:
> 
> 	$ dvb-fe-tool -d isdbt
> 	$ dvb-fe-tool
> 	$ dvb-fe-tool -d isdbs
> 	$ dvb-fe-tool
> 
> When called without arguments, it will show the frequency range as
> reported by FE_GET_INFO (and used internally by the Kernel), e. g.
> it will display something like:
> 
>     $ dvb-fe-tool
>     Device DiBcom 8000 ISDB-T (/dev/dvb/adapter0/frontend0) capabilities:
>          CAN_FEC_1_2
>          CAN_FEC_2_3
>          CAN_FEC_3_4
>          CAN_FEC_5_6
>          CAN_FEC_7_8
>          CAN_FEC_AUTO
>          CAN_GUARD_INTERVAL_AUTO
>          CAN_HIERARCHY_AUTO
>          CAN_INVERSION_AUTO
>          CAN_QAM_16
>          CAN_QAM_64
>          CAN_QAM_AUTO
>          CAN_QPSK
>          CAN_RECOVER
>          CAN_TRANSMISSION_MODE_AUTO
>     DVB API Version 5.11, Current v5 delivery system: ISDBT
>     Supported delivery system:
>         [ISDBT]
>     Frequency range for the current standard:
>     From:            45.0 MHz
>     To:               860 MHz
>     Step:            62.5 kHz
> 

Here is the log of dvb-fe-tool on my environment.

--------------------
# ./utils/dvb/.libs/dvb-fe-tool -d isdbs
Changing delivery system to: ISDBS
ERROR    FE_SET_VOLTAGE: Unknown error 524

# ./utils/dvb/.libs/dvb-fe-tool
Device Socionext SC1501A (/dev/dvb/adapter0/frontend0) capabilities:
     CAN_FEC_AUTO
     CAN_GUARD_INTERVAL_AUTO
     CAN_HIERARCHY_AUTO
     CAN_INVERSION_AUTO
     CAN_QAM_AUTO
     CAN_TRANSMISSION_MODE_AUTO
DVB API Version 5.11, Current v5 delivery system: ISDBS
Supported delivery systems:
    [ISDBS]
     ISDBT
Frequency range for the current standard:
From:             470 MHz
To:              2.07 GHz
Step:            25.0 kHz
Symbol rate ranges for the current standard:
From:                 0Bauds
To:                   0Bauds
SEC: set voltage to OFF
ERROR    FE_SET_VOLTAGE: Operation not permitted


# ./utils/dvb/.libs/dvb-fe-tool -d isdbt
Changing delivery system to: ISDBT
ERROR    FE_SET_VOLTAGE: Unknown error 524

# ./utils/dvb/.libs/dvb-fe-tool
Device Socionext SC1501A (/dev/dvb/adapter0/frontend0) capabilities:
     CAN_FEC_AUTO
     CAN_GUARD_INTERVAL_AUTO
     CAN_HIERARCHY_AUTO
     CAN_INVERSION_AUTO
     CAN_QAM_AUTO
     CAN_TRANSMISSION_MODE_AUTO
DVB API Version 5.11, Current v5 delivery system: ISDBT
Supported delivery systems:
     ISDBS
    [ISDBT]
Frequency range for the current standard:
From:             470 MHz
To:              2.07 GHz
Step:            25.0 kHz
----------



> 
> >
> >
> > And I have one question in the below.
> >
> >
> > > -----Original Message-----
> > > From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > > Sent: Thursday, July 5, 2018 11:43 AM
> > > To: Suzuki, Katsuhiro/鈴木 勝博 <suzuki.katsuhiro@socionext.com>
> > > Cc: linux-media@vger.kernel.org; Masami Hiramatsu
> <masami.hiramatsu@linaro.org>;
> > > Jassi Brar <jaswinder.singh@linaro.org>;
> linux-arm-kernel@lists.infradead.org;
> > > linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH v3] media: dvb-frontends: add Socionext SC1501A ISDB-S/T
> > > demodulator driver
> > >
> > > Em Thu, 5 Jul 2018 10:58:42 +0900
> > > "Katsuhiro Suzuki" <suzuki.katsuhiro@socionext.com> escreveu:
> > >
> > > > Hi Mauro,
> > > >
> > > > > -----Original Message-----
> > > > > From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > > > > Sent: Thursday, July 5, 2018 1:58 AM
> > > > > To: Suzuki, Katsuhiro/鈴木 勝博 <suzuki.katsuhiro@socionext.com>
> > > > > Cc: linux-media@vger.kernel.org; Masami Hiramatsu
> > > > <masami.hiramatsu@linaro.org>;
> > > > > Jassi Brar <jaswinder.singh@linaro.org>;
> > > linux-arm-kernel@lists.infradead.org;
> > > > > linux-kernel@vger.kernel.org
> > > > > Subject: Re: [PATCH v3] media: dvb-frontends: add Socionext SC1501A ISDB-S/T
> > > > > demodulator driver
> > > > >
> > > > > Hi Katsuhiro-san,
> > > > >
> > > > > Em Thu, 21 Jun 2018 12:17:48 +0900
> > > > > Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com> escreveu:
> > > > >
> > > > > > This patch adds a frontend driver for the Socionext SC1501A series
> > > > > > and Socionext MN88443x ISDB-S/T demodulators.
> > > > >
> > > > > Sorry for taking so long to review it. We're missing a sub-maintainer
> > > > > for DVB, with would otherwise speed up reviews of DVB patches.
> > > >
> > > > No problem, thank you for reviewing! I appreciate it.
> > > >
> > > >
> > > > > >
> > > > > > The maximum and minimum frequency of Socionext SC1501A comes from
> > > > > > ISDB-S and ISDB-T so frequency range is the following:
> > > > > >   - ISDB-S (BS/CS110 IF frequency in kHz, Local freq 10.678GHz)
> > > > > >     - Min: BS-1: 1032000 => 1032.23MHz
> > > > > >     - Max: ND24: 2701000 => 2070.25MHz
> > > > > >   - ISDB-T (in Hz)
> > > > > >     - Min: ch13: 470000000 => 470.357857MHz
> > > > > >     - Max: ch62: 770000000 => 769.927857MHz
> > > > >
> > > > > There is actually an error on that part of the driver. Right now,
> > > > > the DVB core expects Satellite frequencies (DVB-S, ISDB-S, ...)
> > > > > in kHz. For all other delivery systems, it is in Hz.
> > > > >
> > > > > It is this way due to historic reasons. While it won't be hard to
> > > > > change the core, that would require to touch all Satellite drivers.
> > > > >
> > > > > As there are very few frontend drivers that accept both Satellite
> > > > > and Terrestrial standards, what we do, instead, is to setup
> > > > > two frontends. See, for example, drivers/media/dvb-frontends/helene.c.
> > > > >
> > > >
> > > > Thank you for describing it. I understand our device is rare case, and
> > > > the reason why Helene has Terrestrial and Satellite structures.
> > > >
> > > > I'm using MN884434 device that has 2 cores. I want to setup DVB adapter
> > > > devices (/dev/dvb/adapter0/*) for our frontend system as the following:
> > > >
> > > >   - adapter0: for core 0, ISDB-T, ISDB-S
> > > >   - adapter1: for core 1, ISDB-T, ISDB-S
> > >
> > > Yeah, that is what it was supposed to work, if the core was ready for it.
> > >
> > > > But it seems one DVB adapter device support only ISDB-T or only ISDB-S
> > > > if I divide structures. So I define the adapters as the following:
> > > >
> > > >   - adapter0: for core 0, ISDB-T
> > > >   - adapter1: for core 0, ISDB-S
> > > >   - adapter2: for core 1, ISDB-T
> > > >   - adapter3: for core 1, ISDB-S
> > > >
> > > > Is this correct?
> > >
> > > That's the way the current driver with uses helene does.
> > >
> > > >
> > > >
> > > > > ...
> > > > > > +static const struct dvb_frontend_ops sc1501a_ops = {
> > > > > > +	.delsys = { SYS_ISDBS, SYS_ISDBT },
> > > > > > +	.info = {
> > > > > > +		.name          = "Socionext SC1501A",
> > > > > > +		.frequency_min = 1032000,
> > > > > > +		.frequency_max = 770000000,
> > > > > > +		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO |
> > > > > > +			FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO |
> > > > > > +			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
> > > > > > +	},
> > > > > > +
> > > > > > +	.sleep                   = sc1501a_sleep,
> > > > > > +	.set_frontend            = sc1501a_set_frontend,
> > > > > > +	.get_tune_settings       = sc1501a_get_tune_settings,
> > > > > > +	.read_status             = sc1501a_read_status,
> > > > > > +};
> > > > >
> > > > > In other words, you'll need to declare two structs here, one for ISDB-T
> > > > > and another one for ISDB-S.
> > > > >
> > > >
> > > > OK, I'm going to divide this structure for Terrestrial and Satellite. And
> > > > add attach functions same as Helene driver.
> > > >
> > > > I'll send v4 patch.
> > >
> > > I ended by writing two patches that should be solving the issues
> > > inside the core. With them[1], it will work the way you want.
> > >
> > > There is a catch: you'll need to convert Helene to have a single
> > > entry and be sure that the driver that currently uses it (netup_unidvb)
> > > will keep working. I guess I have one such hardware here for testing.
> > >
> > > [1] after tested/reviewed - I didn't test them yet. Feel free to test.
> > >
> >
> > Thank you!!
> >
> > I try to fix '[PATCH v4] media: helene: add I2C device probe function'
> > patch but I have a question...
> >
> > My idea is adding new dvb_tuner_ops structure and I2C probe function for
> > supporting multiple systems. Current drivers (netup) continue to use
> > helene_attach_t() and helene_attach_s(), so no need to change netup.
> > It's conservative but prevent the degrade, I think.
> 
> Works for me.
> 
> >
> > Newer added struct dvb_frontend_internal_info has one pair of max/min
> > frequency. What is the best way to declare the frequency range for
> > multiple systems?
> >
> > For example, Helene uses these info for only Ter or Sat freq ranges:
> >
> > 		.name = "Sony HELENE Ter tuner",
> > 		.frequency_min_hz  =    1 * MHz,
> > 		.frequency_max_hz  = 1200 * MHz,
> > 		.frequency_step_hz =   25 * kHz,
> >
> > 		.name = "Sony HELENE Sat tuner",
> > 		.frequency_min_hz  =  500 * MHz,
> > 		.frequency_max_hz  = 2500 * MHz,
> > 		.frequency_step_hz =    1 * MHz,
> >
> > Is this better to add new info for both system?
> >
> > 		.name = "Sony HELENE Sat/Ter tuner",
> > 		.frequency_min_hz  =    1 * MHz,
> > 		.frequency_max_hz  = 2500 * MHz,
> > 		.frequency_step_hz =   25 * kHz, // Is this correct...?
> 
> That is indeed a very good question, and maybe a reason why we
> may need other approaches.
> 
> See, if the tuner is capable of tuning from 1 MHz to 2500 MHz,
> the frequency range should be ok. It would aget_frontend_algoctually be pretty cool
> to use a tuner with such wide range for SDR, if the hardware supports
> raw I/Q collect :-D
> 
> The frequency step is a different issue. If the tuner driver uses
> DVBFE_ALGO_SW (e. g. if ops.get_frontend_algo() returns it, or if
> this function is not defined), then the step will be used to adjust
> the zigzag interactions. If it is too small, the tuning will lose
> channels if the signal is not strong.
> 

Thank you for describing. It's difficult problem...


> In the specific case of helene, it doesn't have a get_frontend_algo,
> so it will use the step frequency.
> 
> I'm not sure how to solve this issue. Maybe Abylay may shed a light
> here, if helene does sigzag in hardware or not.
> 

As far as I know, Helene does not have automatic scan mechanism in 
hardware.


> If it does in hardware, you could add a get_frontend_algo() routine
> at helene driver and return DVBFE_ALGO_HW. The tuning zigzag software
> algorithm in the Kernel will stop, as it will rely at the hardware.
> 
> Please notice that, if the hardware doesn't do zigzag itself, this
> will make it lose channels. On the other hand, if the hardware does
> have sigzag, changing to DVBFE_ALGO_HW will speedup tuning, as the
> Kernel won't try to do sigzag itself.
> 

ISDB-T uses 6MHz bandwidth per channel (in Japan), ISDB-S for 
BS/CS110 uses 38.36MHz bandwidth. Maybe 1MHz zigzag step is large for 
ISDB-T system and 25kHz is small for ISDB-S system.

I cannot decide fixed step size for supporting multiple systems. So I 
think it's prefer to select the suitable step size at giving the 
delivery system (in set_frontend() callback or some others).


> >
> >
> > > So, please look at the two patches I sent today to the mailing list.
> > >
> > > (not sure why, they're taking a long time to arrive there - perhaps
> > > vger has some issues).
> > >
> > > I added them on this tree:
> > > 	https://git.linuxtv.org/mchehab/experimental.git/log/?h=dvb_freq_hz
> > >
> > > it is the last two patches there:
> > > 	-
> > >
> https://git.linuxtv.org/mchehab/experimental.git/commit/?h=dvb_freq_hz&id=b3d63
> > > a8f038d136b26692bc3a14554960e767f4a
> > > 	-
> > >
> https://git.linuxtv.org/mchehab/experimental.git/commit/?h=dvb_freq_hz&id=2a369
> > > e8faf3b277baff4026371f298e95c84fbb2
> > >
> > > I'm not sure if all applications will do the right thing, though, as
> > > it will depend  if they query the capabilities before or after switching
> > > to a different delivery system. If it get caps before and store them
> > > in Hz, apps will work, but tests are required.
> > >
> >
> > Ah, indeed. You mean,
> >
> >   - Application want to tune Terrestrial system
> >   - Driver is in Satellite system
> >   - Application query max/min frequency
> >   - DVB API returns max/min frequency in 'kHz'
> >   - Some application will get something wrong
> >     (ex. app specific range check)
> 
> Yes. I guess, however, that most apps won't do range checks themselves,
> but this has yet to be checked.
> 

I think & hope so too...


Regards,
--
Katsuhiro Suzuki


> > Unfortunately, I don't know applications that do such scenario.
> > My test application does not query max/min range...
> >
> >
> > > >
> > > >
> > > > > Yeah, I know that this sucks. If you are in the mood of touching the
> > > > > DVB core, I'm willing to consider a patch that would fix this, provided
> > > > > that it won't break backward compatibility with other drivers (or would
> > > > > convert the other satellite drivers to use the new way).
> > > > >
> > > > > Thanks,
> > > > > Mauro
> > > >
> > > > Hmm, I don't know the details of DVB core, I try to investigate it.
> > > >
> > > >
> > > > Regards,
> > > > --
> > > > Katsuhiro Suzuki
> > > >
> > > >
> > > >
> > >
> > >
> > >
> > > Thanks,
> > > Mauro
> >
> >
> > Regards,
> > --
> > Katsuhiro Suzuki
> >
> >
> >
> 
> 
> 
> Thanks,
> Mauro
