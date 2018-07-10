Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.socionext.com ([202.248.49.38]:57571 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932824AbeGJCun (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Jul 2018 22:50:43 -0400
From: "Katsuhiro Suzuki" <suzuki.katsuhiro@socionext.com>
To: "'Mauro Carvalho Chehab'" <mchehab+samsung@kernel.org>,
        =?utf-8?B?U3V6dWtpLCBLYXRzdWhpcm8v6Yi05pyoIOWLneWNmg==?=
        <suzuki.katsuhiro@socionext.com>
Cc: <linux-media@vger.kernel.org>,
        "Masami Hiramatsu" <masami.hiramatsu@linaro.org>,
        "Jassi Brar" <jaswinder.singh@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, "Abylay Ospan" <aospan@netup.ru>
References: <20180621031748.21703-1-suzuki.katsuhiro@socionext.com>     <20180704135657.3fd607cb@coco.lan>      <000401d41403$b33db490$19b91db0$@socionext.com> <20180704234244.32d20f6b@coco.lan>      <000501d41423$265013a0$72f03ae0$@socionext.com> <20180705212723.2856f064@coco.lan>      <001f01d414ef$27145450$753cfcf0$@socionext.com> <20180706081603.2d8451c9@coco.lan>      <002c01d41729$2ff6fa00$8fe4ee00$@socionext.com> <20180709105938.3d2f8391@coco.lan>
In-Reply-To: <20180709105938.3d2f8391@coco.lan>
Subject: Re: [PATCH v3] media: dvb-frontends: add Socionext SC1501A ISDB-S/T demodulator driver
Date: Tue, 10 Jul 2018 11:50:37 +0900
Message-ID: <004501d417f8$c83a01c0$58ae0540$@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Language: ja
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

> -----Original Message-----
> From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> Sent: Monday, July 9, 2018 11:00 PM
> To: Suzuki, Katsuhiro/鈴木 勝博 <suzuki.katsuhiro@socionext.com>
> Cc: linux-media@vger.kernel.org; Masami Hiramatsu <masami.hiramatsu@linaro.org>;
> Jassi Brar <jaswinder.singh@linaro.org>; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org; Abylay Ospan <aospan@netup.ru>
> Subject: Re: [PATCH v3] media: dvb-frontends: add Socionext SC1501A ISDB-S/T
> demodulator driver
> 
> Em Mon, 9 Jul 2018 11:04:36 +0900
> "Katsuhiro Suzuki" <suzuki.katsuhiro@socionext.com> escreveu:
> 
> > Hello Mauro,
> >
> > > -----Original Message-----
> > > From: linux-media-owner@vger.kernel.org <linux-media-owner@vger.kernel.org>
> On
> > > Behalf Of Mauro Carvalho Chehab
> > > Sent: Friday, July 6, 2018 8:16 PM
> > > To: Suzuki, Katsuhiro/鈴木 勝博 <suzuki.katsuhiro@socionext.com>
> > > Cc: linux-media@vger.kernel.org; Masami Hiramatsu
> > <masami.hiramatsu@linaro.org>;
> > > Jassi Brar <jaswinder.singh@linaro.org>;
> linux-arm-kernel@lists.infradead.org;
> > > linux-kernel@vger.kernel.org; Abylay Ospan <aospan@netup.ru>
> > > Subject: Re: [PATCH v3] media: dvb-frontends: add Socionext SC1501A ISDB-S/T
> > > demodulator driver
> > >
> > > Em Fri, 6 Jul 2018 15:04:08 +0900
> > > "Katsuhiro Suzuki" <suzuki.katsuhiro@socionext.com> escreveu:
> > >
> > > > Here is the log of dvb-fe-tool on my environment.
> > > >
> > > > --------------------
> > > > # ./utils/dvb/.libs/dvb-fe-tool -d isdbs
> > > > Changing delivery system to: ISDBS
> > > > ERROR    FE_SET_VOLTAGE: Unknown error 524
> > >
> > > Hmm... ENOTSUPP. Doesn't the device supposed to be able to power on the
> > > LNBf?
> >
> > Ah, maybe it's not implemented yet in Helene driver.
> 
> That depends on how the hardware works. On some hardware, the
> LNBf power supply and control is at the demod; on others, it is
> supported by a separate chipset. See, for example, isl642.c for
> an example of such external hardware.
> 
> I don't know much about ISDB-S, but, as far as what was
> implemented on v4l-utils dvb-sat.c for Japan 110BS/CS LNBf,
> the LNBf voltage is not used to switch the polarity.
> 
> So, the control here is simpler than on DVB-S/S2, as the only
> control is either to send 18V to power on the LNBf/Dish, or
> zero in order to save power.
> 

Thank you, I misunderstood about LNB. I checked circuit of evaluation 
board, the board has discrete LNB IC (ST micro LNBH29) for supplying 
voltage to Helene. This IC is controlled by I2C.

The standard (ARIB STD-B21) says DC 15V power is needed to drive the 
converter (BS freq -> BS-IF freq) of BS dish antenna. This power 
can be supplied via antenna line.

It seems,
  LNBH29 --(LNB_PWR)--> Helene --> BS antenna

I don't know enough about Helene, but it maybe supply 15V power to 
converter of BS dish via antenna line if it receive 15V LNB_PWR...


I don't have idea about controlling this IC. Should I write some 
driver for LNBH29, and pass the phandle to demodulator via device 
tree??


> >
> >
> > >
> > > Anyway, I changed the error print message to be clearer, displaying
> > > instead:
> > >
> > >   ERROR    FE_SET_VOLTAGE: driver doesn't support it!
> > >
> >
> > It's nice for users. Thanks!
> >
> >
> > > >
> > > > # ./utils/dvb/.libs/dvb-fe-tool
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
> > > > From:                 0Bauds
> > > > To:                   0Bauds
> > >
> > > That seems a driver issue. The ISDB-S ops.info should be
> > > filling both symbol_rate_min and symbol_rate_max.
> > >
> > > I suspect that both should be filled with 28860000.
> > >
> > > The dvb_frontend.c core might hardcode it, but, IMHO,
> > > it is better to keep those information inside the
> > > tuner/frontend ops.info.
> > >
> >
> > Indeed, thank you for reviewing. I fixed my driver. It seems works fine.
> >
> > ----
> > # utils/dvb/.libs/dvb-fe-tool -a 0
> > Device Socionext SC1501A (/dev/dvb/adapter0/frontend0) capabilities:
> >      CAN_FEC_AUTO
> >      CAN_GUARD_INTERVAL_AUTO
> >      CAN_HIERARCHY_AUTO
> >      CAN_INVERSION_AUTO
> >      CAN_QAM_AUTO
> >      CAN_TRANSMISSION_MODE_AUTO
> > DVB API Version 5.11, Current v5 delivery system: ISDBS
> > Supported delivery systems:
> >     [ISDBS]
> >      ISDBT
> > Frequency range for the current standard:
> > From:             470 MHz
> > To:              2.07 GHz
> > Step:            25.0 kHz
> > Symbol rate ranges for the current standard:
> > From:            28.9 MBauds
> > To:              28.9 MBauds
> > SEC: set voltage to OFF
> > ERROR    FE_SET_VOLTAGE: Operation not permitted
> > ----
> 
> That sounds ok.
> 
> >
> >
> > > > SEC: set voltage to OFF
> > > > ERROR    FE_SET_VOLTAGE: Operation not permitted
> > > >
> > > >
> > > > # ./utils/dvb/.libs/dvb-fe-tool -d isdbt
> > > > Changing delivery system to: ISDBT
> > > > ERROR    FE_SET_VOLTAGE: Unknown error 524
> > > >
> > > > # ./utils/dvb/.libs/dvb-fe-tool
> > > > Device Socionext SC1501A (/dev/dvb/adapter0/frontend0) capabilities:
> > > >      CAN_FEC_AUTO
> > > >      CAN_GUARD_INTERVAL_AUTO
> > > >      CAN_HIERARCHY_AUTO
> > > >      CAN_INVERSION_AUTO
> > > >      CAN_QAM_AUTO
> > > >      CAN_TRANSMISSION_MODE_AUTO
> > > > DVB API Version 5.11, Current v5 delivery system: ISDBT
> > > > Supported delivery systems:
> > > >      ISDBS
> > > >     [ISDBT]
> > > > Frequency range for the current standard:
> > > > From:             470 MHz
> > > > To:              2.07 GHz
> > > > Step:            25.0 kHz
> > >
> > > The rest looks OK for me.
> > >
> > > > > > For example, Helene uses these info for only Ter or Sat freq ranges:
> > > > > >
> > > > > > 		.name = "Sony HELENE Ter tuner",
> > > > > > 		.frequency_min_hz  =    1 * MHz,
> > > > > > 		.frequency_max_hz  = 1200 * MHz,
> > > > > > 		.frequency_step_hz =   25 * kHz,
> > > > > >
> > > > > > 		.name = "Sony HELENE Sat tuner",
> > > > > > 		.frequency_min_hz  =  500 * MHz,
> > > > > > 		.frequency_max_hz  = 2500 * MHz,
> > > > > > 		.frequency_step_hz =    1 * MHz,
> > > > > >
> > > > > > Is this better to add new info for both system?
> > > > > >
> > > > > > 		.name = "Sony HELENE Sat/Ter tuner",
> > > > > > 		.frequency_min_hz  =    1 * MHz,
> > > > > > 		.frequency_max_hz  = 2500 * MHz,
> > > > > > 		.frequency_step_hz =   25 * kHz, // Is this correct...?
> > > > >
> > > > > That is indeed a very good question, and maybe a reason why we
> > > > > may need other approaches.
> > > > >
> > > > > See, if the tuner is capable of tuning from 1 MHz to 2500 MHz,
> > > > > the frequency range should be ok. It would aget_frontend_algoctually be
> > pretty
> > > cool
> > > > > to use a tuner with such wide range for SDR, if the hardware supports
> > > > > raw I/Q collect :-D
> > > > >
> > > > > The frequency step is a different issue. If the tuner driver uses
> > > > > DVBFE_ALGO_SW (e. g. if ops.get_frontend_algo() returns it, or if
> > > > > this function is not defined), then the step will be used to adjust
> > > > > the zigzag interactions. If it is too small, the tuning will lose
> > > > > channels if the signal is not strong.
> > > > >
> > > >
> > > > Thank you for describing. It's difficult problem...
> > >
> > > I double-checked the implementation. We don't need to worry about
> > > zigzag, provided that the ISDB-S implementation at the core is correct.
> > >
> > > For satellite/cable standards, the zigzag logic takes the symbol
> > > rate into account, and not the stepsize:
> > >
> > >                 case SYS_DVBS:
> > >                 case SYS_DVBS2:
> > >                 case SYS_ISDBS:
> > >                 case SYS_TURBO:
> > >                 case SYS_DVBC_ANNEX_A:
> > >                 case SYS_DVBC_ANNEX_C:
> > >                         fepriv->min_delay = HZ / 20;
> > >                         fepriv->step_size = c->symbol_rate / 16000;
> > >                         fepriv->max_drift = c->symbol_rate / 2000;
> > >                         break;
> > >
> > > For terrestrial standards, it uses the stepsize:
> > >
> > >                 case SYS_DVBT:
> > >                 case SYS_DVBT2:
> > >                 case SYS_ISDBT:
> > >                 case SYS_DTMB:
> > >                         fepriv->min_delay = HZ / 20;
> > >                         fepriv->step_size = dvb_frontend_get_stepsize(fe) *
> 2;
> > >                         fepriv->max_drift = (dvb_frontend_get_stepsize(fe) *
> 2)
> > +
> > > 1;
> > >                         break;
> > >
> > > So, having a value of 25 kHz there won't affect the zigzag algorithm
> > > for ISDB-S, as it will be used only for ISDB-T.
> > >
> >
> > Thank you for checking and describing. I checked it too.
> >
> > Default value is fine as you said, and we can use get_tune_settings()
> > callback if we face the problem or need different settings for each
> > delivery systems in the future.
> >
> >         /* get frontend-specific tuning settings */
> >         memset(&fetunesettings, 0, sizeof(struct dvb_frontend_tune_settings));
> >         if (fe->ops.get_tune_settings && (fe->ops.get_tune_settings(fe,
> > &fetunesettings) == 0)) {
> >                 fepriv->min_delay = (fetunesettings.min_delay_ms * HZ) / 1000;
> >                 fepriv->max_drift = fetunesettings.max_drift;
> >                 fepriv->step_size = fetunesettings.step_size;
> >         } else {
> >                 /* default values */
> >                 ...
> 
> Sure.
> 
> >
> >
> > > > > In the specific case of helene, it doesn't have a get_frontend_algo,
> > > > > so it will use the step frequency.
> > > > >
> > > > > I'm not sure how to solve this issue. Maybe Abylay may shed a light
> > > > > here, if helene does sigzag in hardware or not.
> > > > >
> > > >
> > > > As far as I know, Helene does not have automatic scan mechanism in
> > > > hardware.
> > >
> > > Ok, so the driver is doing the right thing here.
> > >
> > > > > If it does in hardware, you could add a get_frontend_algo() routine
> > > > > at helene driver and return DVBFE_ALGO_HW. The tuning zigzag software
> > > > > algorithm in the Kernel will stop, as it will rely at the hardware.
> > > > >
> > > > > Please notice that, if the hardware doesn't do zigzag itself, this
> > > > > will make it lose channels. On the other hand, if the hardware does
> > > > > have sigzag, changing to DVBFE_ALGO_HW will speedup tuning, as the
> > > > > Kernel won't try to do sigzag itself.
> > > > >
> > > >
> > > > ISDB-T uses 6MHz bandwidth per channel (in Japan), ISDB-S for
> > > > BS/CS110 uses 38.36MHz bandwidth. Maybe 1MHz zigzag step is large for
> > > > ISDB-T system and 25kHz is small for ISDB-S system.
> > >
> > > Yeah, but, after double-checking the logic, for ISDB-S, it will
> > > use:
> > >
> > > 	c->symbol_rate = 28860000;
> > > 	c->rolloff = ROLLOFF_35;
> > > 	c->bandwidth_hz = c->symbol_rate / 100 * 135;
> > >
> > > That would actually set the ISDB-S channel separation to 38.961 MHz.
> > >
> > > By setting symbol_rate like that, the zigzag for ISDB-S will
> > > be defined by:
> > >
> > >        fepriv->step_size = c->symbol_rate / 16000; /* 38.961MHz / 16000 =
> > .002435
> > > - e. g. steps of ~25 kHz */
> > >        fepriv->max_drift = c->symbol_rate / 2000;  /* 38.961MHz / 2000 =
> > .0194805
> > > - e. g. max drift of ~195 kHz */
> > >
> > > Funny enough, it will be using about 25 kHz as step size for ISDB-S.
> > >
> > > I have no idea if the ISDB-S standard defines the zigzag logic,
> > > but I would be expecting a higher value for it. So, perhaps
> > > the ISDB-S zigzag could be optimized.
> > >
> > > Thanks,
> > > Mauro
> >
> > Hmm, interesting. I don't know zigzag for ISDB-S too, sorry...
> >
> > Anyway, I don't worry about that. I said in above, we can use
> > get_tune_settings() for fine tuning.
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
