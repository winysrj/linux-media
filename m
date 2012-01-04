Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47541 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721Ab2ADTKF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 14:10:05 -0500
Received: by eekc4 with SMTP id c4so16914179eek.19
        for <linux-media@vger.kernel.org>; Wed, 04 Jan 2012 11:10:04 -0800 (PST)
Message-ID: <4F04A409.5040707@gmail.com>
Date: Wed, 04 Jan 2012 20:10:01 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v4 16/47] [media] tuner-xc2028: use DVBv5 parameters on
 set_params()
References: <1324741852-26138-1-git-send-email-mchehab@redhat.com> <1324741852-26138-3-git-send-email-mchehab@redhat.com> <1324741852-26138-4-git-send-email-mchehab@redhat.com> <1324741852-26138-5-git-send-email-mchehab@redhat.com> <1324741852-26138-6-git-send-email-mchehab@redhat.com> <1324741852-26138-7-git-send-email-mchehab@redhat.com> <1324741852-26138-8-git-send-email-mchehab@redhat.com> <1324741852-26138-9-git-send-email-mchehab@redhat.com> <1324741852-26138-10-git-send-email-mchehab@redhat.com> <1324741852-26138-11-git-send-email-mchehab@redhat.com> <1324741852-26138-12-git-send-email-mchehab@redhat.com> <1324741852-26138-13-git-send-email-mchehab@redhat.com> <1324741852-26138-14-git-send-email-mchehab@redhat.com> <1324741852-26138-15-git-send-email-mchehab@redhat.com> <1324741852-26138-16-git-send-email-mchehab@redhat.com> <1324741852-26138-17-git-send-email-mchehab@redhat.com> <4F02065E.4060406@gmail.com> <4F049F60.5040509@redhat.com>
In-Reply-To: <4F049F60.5040509@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 04/01/2012 19:50, Mauro Carvalho Chehab ha scritto:
> On 02-01-2012 17:32, Gianluca Gennari wrote:
>> Il 24/12/2011 16:50, Mauro Carvalho Chehab ha scritto:
>>> Instead of using DVBv3 parameters, rely on DVBv5 parameters to
>>> set the tuner.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>> ---
>>>  drivers/media/common/tuners/tuner-xc2028.c |   83 ++++++++++++----------------
>>>  1 files changed, 36 insertions(+), 47 deletions(-)
>>>
>>> diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
>>> index e531267..8c0dc6a1 100644
>>> --- a/drivers/media/common/tuners/tuner-xc2028.c
>>> +++ b/drivers/media/common/tuners/tuner-xc2028.c
>>> @@ -1087,65 +1087,26 @@ static int xc2028_set_analog_freq(struct dvb_frontend *fe,
>>>  static int xc2028_set_params(struct dvb_frontend *fe,
>>>  			     struct dvb_frontend_parameters *p)
>>>  {
>>> +	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>>> +	u32 delsys = c->delivery_system;
>>> +	u32 bw = c->bandwidth_hz;
>>>  	struct xc2028_data *priv = fe->tuner_priv;
>>>  	unsigned int       type=0;
>>> -	fe_bandwidth_t     bw = BANDWIDTH_8_MHZ;
>>>  	u16                demod = 0;
>>>  
>>>  	tuner_dbg("%s called\n", __func__);
>>>  
>>> -	switch(fe->ops.info.type) {
>>> -	case FE_OFDM:
>>> -		bw = p->u.ofdm.bandwidth;
>>> +	switch (delsys) {
>>> +	case SYS_DVBT:
>>> +	case SYS_DVBT2:
>>>  		/*
>>>  		 * The only countries with 6MHz seem to be Taiwan/Uruguay.
>>>  		 * Both seem to require QAM firmware for OFDM decoding
>>>  		 * Tested in Taiwan by Terry Wu <terrywu2009@gmail.com>
>>>  		 */
>>> -		if (bw == BANDWIDTH_6_MHZ)
>>> +		if (bw <= 6000000)
>>>  			type |= QAM;
>>> -		break;
>>> -	case FE_ATSC:
>>> -		bw = BANDWIDTH_6_MHZ;
>>> -		/* The only ATSC firmware (at least on v2.7) is D2633 */
>>> -		type |= ATSC | D2633;
>>> -		break;
>>> -	/* DVB-S and pure QAM (FE_QAM) are not supported */
>>> -	default:
>>> -		return -EINVAL;
>>> -	}
>>> -
>>> -	switch (bw) {
>>> -	case BANDWIDTH_8_MHZ:
>>> -		if (p->frequency < 470000000)
>>> -			priv->ctrl.vhfbw7 = 0;
>>> -		else
>>> -			priv->ctrl.uhfbw8 = 1;
>>> -		type |= (priv->ctrl.vhfbw7 && priv->ctrl.uhfbw8) ? DTV78 : DTV8;
>>> -		type |= F8MHZ;
>>> -		break;
>>> -	case BANDWIDTH_7_MHZ:
>>> -		if (p->frequency < 470000000)
>>> -			priv->ctrl.vhfbw7 = 1;
>>> -		else
>>> -			priv->ctrl.uhfbw8 = 0;
>>> -		type |= (priv->ctrl.vhfbw7 && priv->ctrl.uhfbw8) ? DTV78 : DTV7;
>>> -		type |= F8MHZ;
>>> -		break;
>>> -	case BANDWIDTH_6_MHZ:
>>> -		type |= DTV6;
>>> -		priv->ctrl.vhfbw7 = 0;
>>> -		priv->ctrl.uhfbw8 = 0;
>>> -		break;
>>> -	default:
>>> -		tuner_err("error: bandwidth not supported.\n");
>>> -	};
>>>  
>>> -	/*
>>> -	  Selects between D2633 or D2620 firmware.
>>> -	  It doesn't make sense for ATSC, since it should be D2633 on all cases
>>> -	 */
>>> -	if (fe->ops.info.type != FE_ATSC) {
>>>  		switch (priv->ctrl.type) {
>>>  		case XC2028_D2633:
>>>  			type |= D2633;
>>> @@ -1161,6 +1122,34 @@ static int xc2028_set_params(struct dvb_frontend *fe,
>>>  			else
>>>  				type |= D2620;
>>>  		}
>>> +		break;
>>> +	case SYS_ATSC:
>>> +		/* The only ATSC firmware (at least on v2.7) is D2633 */
>>> +		type |= ATSC | D2633;
>>> +		break;
>>> +	/* DVB-S and pure QAM (FE_QAM) are not supported */
>>> +	default:
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	if (bw <= 6000000) {
>>> +		type |= DTV6;
>>> +		priv->ctrl.vhfbw7 = 0;
>>> +		priv->ctrl.uhfbw8 = 0;
>>> +	} else if (bw <= 7000000) {
>>> +		if (c->frequency < 470000000)
>>> +			priv->ctrl.vhfbw7 = 1;
>>> +		else
>>> +			priv->ctrl.uhfbw8 = 0;
>>> +		type |= (priv->ctrl.vhfbw7 && priv->ctrl.uhfbw8) ? DTV78 : DTV7;
>>> +		type |= F8MHZ;
>>> +	} else {
>>> +		if (c->frequency < 470000000)
>>> +			priv->ctrl.vhfbw7 = 0;
>>> +		else
>>> +			priv->ctrl.uhfbw8 = 1;
>>> +		type |= (priv->ctrl.vhfbw7 && priv->ctrl.uhfbw8) ? DTV78 : DTV8;
>>> +		type |= F8MHZ;
>>>  	}
>>>  
>>>  	/* All S-code tables need a 200kHz shift */
>>> @@ -1185,7 +1174,7 @@ static int xc2028_set_params(struct dvb_frontend *fe,
>>>  		 */
>>>  	}
>>>  
>>> -	return generic_set_freq(fe, p->frequency,
>>> +	return generic_set_freq(fe, c->frequency,
>>>  				V4L2_TUNER_DIGITAL_TV, type, 0, demod);
>>>  }
>>>  
>>
>> Hi Mauro,
>> I've tested the new media_build tree with the DVBv5 modifications on my
>> Terratec Cinergy Hybrid T USB XS (0ccd:0042).
>>
>> The card works fine, but there is small issue: with the old code the
>> BASE firmware was loaded only 1 time, now it seems to be loaded each
>> time a new frequency is tuned (forcing reload of the other firmwares too).
>>
>> This is a log of the firmware loads after some channel surfing:
>>
>> OLD CODE:
>>
>> [ 8701.753768] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS
>> (7), id 0000000000000000.
>> [ 8702.804153] xc2028 0-0061: Loading firmware for type=D2633 DTV7 (90),
>> id 0000000000000000.
>> [ 8702.819274] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
>> DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
>> [ 8758.361730] xc2028 0-0061: Loading firmware for type=D2633 DTV78
>> (110), id 0000000000000000.
>> [ 8758.376951] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
>> DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
>>
>> (note that the first frequency was in VHF band, then I switched to a new
>> frequency in UHF band, so the DTV78 firmware was loaded)
>>
>> NEW CODE:
>>
>> [19398.450453] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS
>> (7), id 0000000000000000.
>> [19399.563210] xc2028 0-0061: Loading firmware for type=D2633 DTV8
>> (210), id 0000000000000000.
>> [19399.579467] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
>> DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
>> [19458.001144] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS
>> (7), id 0000000000000000.
>> [19459.084473] xc2028 0-0061: Loading firmware for type=D2633 DTV8
>> (210), id 0000000000000000.
>> [19459.100183] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
>> DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
>> [19471.695347] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS
>> (7), id 0000000000000000.
>> [19472.763449] xc2028 0-0061: Loading firmware for type=D2633 DTV8
>> (210), id 0000000000000000.
>> [19472.780660] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
>> DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
>> [19497.928003] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS
>> (7), id 0000000000000000.
>> [19498.999729] xc2028 0-0061: Loading firmware for type=D2633 DTV8
>> (210), id 0000000000000000.
>> [19499.015212] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
>> DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
>> [19510.258833] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS
>> (7), id 0000000000000000.
>> [19511.346135] xc2028 0-0061: Loading firmware for type=D2633 DTV78
>> (110), id 0000000000000000.
>> [19511.361506] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
>> DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
>> [19523.956877] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS
>> (7), id 0000000000000000.
>> [19525.028394] xc2028 0-0061: Loading firmware for type=D2633 DTV78
>> (110), id 0000000000000000.
>> [19525.044622] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
>> DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
>> [19538.526806] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS
>> (7), id 0000000000000000.
>> [19539.602083] xc2028 0-0061: Loading firmware for type=D2633 DTV78
>> (110), id 0000000000000000.
>> [19539.617613] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
>> DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
>>
>> (here I started with a UHF frequency, but each time a new frequency is
>> requested all firmwares are loaded anyway, starting from the BASE one).
> 
> Weird. This patch preserves the logic that decides what firmware should be
> used.
> 
> That's said, maybe the driver should just use DTV78 firmwwares on all cases.
> 
> On what Country do you live?
> 
> 
>>
>> Best regards,
>> Gianluca Gennari
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Hi Mauro,
I live in Italy, but this is not the cause of the problem.

In fact I've run further tests with debugging enabled and I found out
that the cause of the problem is the call of xc2028_sleep() when
xc2028_set_params() is called to tune a new channel:

[27103.741563] xc2028 0-0061: Putting xc2028/3028 into poweroff mode.
[27147.169281] xc2028 0-0061: xc2028_set_params called

this resets the firmware and forces a reload:

	priv->cur_fw.type = 0;	/* need firmware reload */

A workaround is to use the no_poweroff option:

modprobe tuner-xc2028 no_poweroff=1

this disables sleep mode for the xc2028 tuner and then the firmware is
loaded only when the first channel is tuned, just like the old code.

I have no idea where this call to xc2028_sleep() comes from.

I reproduced this bug with the latest media_build drivers on both Ubuntu
10.04 (kernel 2.6.32 - old Kaffeine) and Ubuntu 11.10 (kernel 3.0.0 -
new Kaffeine).

This is a log with debugging enabled:

[27103.741147] xc2028: Xcv2028/3028 init called!
[27103.741154] xc2028 0-0061: attaching existing instance
[27103.741158] xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
[27103.741161] em28xx #0: em28xx #0/2: xc3028 attached
[27103.741165] DVB: registering new adapter (em28xx #0)
[27103.741169] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353
DVB-T)...
[27103.741446] em28xx #0: Successfully loaded em28xx-dvb
[27103.741450] Em28xx: Initialized (Em28xx dvb Extension) extension
[27103.741563] xc2028 0-0061: Putting xc2028/3028 into poweroff mode.
[27147.169281] xc2028 0-0061: xc2028_set_params called
[27147.169287] xc2028 0-0061: generic_set_freq called
[27147.169290] xc2028 0-0061: should set frequency 198500 kHz
[27147.169293] xc2028 0-0061: check_firmware called
[27147.169297] xc2028 0-0061: checking firmware, user requested
type=F8MHZ MTS D2633 DTV7 (96), id 0000000000000000, int_freq 4760,
scode_nr 0
[27147.227134] xc2028 0-0061: load_firmware called
[27147.227139] xc2028 0-0061: seek_firmware called, want type=BASE F8MHZ
MTS D2633 DTV7 (97), id 0000000000000000.
[27147.227148] xc2028 0-0061: Found firmware for type=BASE F8MHZ MTS
(7), id 0000000000000000.
[27147.227154] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS
(7), id 0000000000000000.
[27148.326674] xc2028 0-0061: Load init1 firmware, if exists
[27148.326679] xc2028 0-0061: load_firmware called
[27148.326683] xc2028 0-0061: seek_firmware called, want type=BASE INIT1
F8MHZ MTS D2633 DTV7 (4097), id 0000000000000000.
[27148.326694] xc2028 0-0061: Can't find firmware for type=BASE INIT1
F8MHZ MTS (4007), id 0000000000000000.
[27148.326702] xc2028 0-0061: load_firmware called
[27148.326706] xc2028 0-0061: seek_firmware called, want type=BASE INIT1
MTS D2633 DTV7 (4095), id 0000000000000000.
[27148.326714] xc2028 0-0061: Can't find firmware for type=BASE INIT1
MTS (4005), id 0000000000000000.
[27148.326721] xc2028 0-0061: load_firmware called
[27148.326724] xc2028 0-0061: seek_firmware called, want type=F8MHZ MTS
D2633 DTV7 (96), id 0000000000000000.
[27148.326732] xc2028 0-0061: Found firmware for type=D2633 DTV7 (90),
id 0000000000000000.
[27148.326738] xc2028 0-0061: Loading firmware for type=D2633 DTV7 (90),
id 0000000000000000.
[27148.342787] xc2028 0-0061: Trying to load scode 0
[27148.342791] xc2028 0-0061: load_scode called
[27148.342795] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[27148.345282] xc2028 0-0061: xc2028_get_reg 0004 called
[27148.346404] xc2028 0-0061: xc2028_get_reg 0008 called
[27148.347433] xc2028 0-0061: Device is Xceive 3028 version 1.0,
firmware version 2.7
[27148.466633] xc2028 0-0061: divisor= 00 00 30 f0 (freq=198.500)
[27149.475929] xc2028 0-0061: xc2028_set_params called
[27149.475935] xc2028 0-0061: generic_set_freq called
[27149.475940] xc2028 0-0061: should set frequency 198500 kHz
[27149.475943] xc2028 0-0061: check_firmware called
[27149.475946] xc2028 0-0061: checking firmware, user requested
type=F8MHZ MTS D2633 DTV7 (96), id 0000000000000000, int_freq 4760,
scode_nr 0
[27149.475957] xc2028 0-0061: BASE firmware not changed.
[27149.475961] xc2028 0-0061: Std-specific firmware already loaded.
[27149.475964] xc2028 0-0061: SCODE firmware already loaded.
[27149.475968] xc2028 0-0061: xc2028_get_reg 0004 called
[27149.476932] xc2028 0-0061: xc2028_get_reg 0008 called
[27149.477929] xc2028 0-0061: Device is Xceive 3028 version 1.0,
firmware version 2.7
[27149.598130] xc2028 0-0061: divisor= 00 00 30 f0 (freq=198.500)
[27150.607986] xc2028 0-0061: xc2028_set_params called
[27150.607993] xc2028 0-0061: generic_set_freq called
[27150.607997] xc2028 0-0061: should set frequency 198500 kHz
[27150.608000] xc2028 0-0061: check_firmware called
[27150.608004] xc2028 0-0061: checking firmware, user requested
type=F8MHZ MTS D2633 DTV7 (96), id 0000000000000000, int_freq 4760,
scode_nr 0
[27150.608015] xc2028 0-0061: BASE firmware not changed.
[27150.608018] xc2028 0-0061: Std-specific firmware already loaded.
[27150.608022] xc2028 0-0061: SCODE firmware already loaded.
[27150.608025] xc2028 0-0061: xc2028_get_reg 0004 called
[27150.609082] xc2028 0-0061: xc2028_get_reg 0008 called
[27150.610100] xc2028 0-0061: Device is Xceive 3028 version 1.0,
firmware version 2.7
[27150.729780] xc2028 0-0061: divisor= 00 00 30 f0 (freq=198.500)
[27151.739507] xc2028 0-0061: xc2028_set_params called
[27151.739513] xc2028 0-0061: generic_set_freq called
[27151.739517] xc2028 0-0061: should set frequency 198500 kHz
[27151.739521] xc2028 0-0061: check_firmware called
[27151.739524] xc2028 0-0061: checking firmware, user requested
type=F8MHZ MTS D2633 DTV7 (96), id 0000000000000000, int_freq 4760,
scode_nr 0
[27151.739535] xc2028 0-0061: BASE firmware not changed.
[27151.739538] xc2028 0-0061: Std-specific firmware already loaded.
[27151.739542] xc2028 0-0061: SCODE firmware already loaded.
[27151.739546] xc2028 0-0061: xc2028_get_reg 0004 called
[27151.740601] xc2028 0-0061: xc2028_get_reg 0008 called
[27151.741758] xc2028 0-0061: Device is Xceive 3028 version 1.0,
firmware version 2.7
[27151.861124] xc2028 0-0061: divisor= 00 00 30 f0 (freq=198.500)
[27152.107733] xc2028 0-0061: Putting xc2028/3028 into poweroff mode.
[27152.181882] xc2028 0-0061: xc2028_set_params called
[27152.181890] xc2028 0-0061: generic_set_freq called
[27152.181896] xc2028 0-0061: should set frequency 658000 kHz
[27152.181901] xc2028 0-0061: check_firmware called
[27152.181905] xc2028 0-0061: checking firmware, user requested
type=F8MHZ MTS D2633 DTV78 (116), id 0000000000000000, int_freq 4760,
scode_nr 0
[27152.240972] xc2028 0-0061: load_firmware called
[27152.240977] xc2028 0-0061: seek_firmware called, want type=BASE F8MHZ
MTS D2633 DTV78 (117), id 0000000000000000.
[27152.240988] xc2028 0-0061: Found firmware for type=BASE F8MHZ MTS
(7), id 0000000000000000.
[27152.240994] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS
(7), id 0000000000000000.
[27153.317092] xc2028 0-0061: Load init1 firmware, if exists
[27153.317098] xc2028 0-0061: load_firmware called
[27153.317102] xc2028 0-0061: seek_firmware called, want type=BASE INIT1
F8MHZ MTS D2633 DTV78 (4117), id 0000000000000000.
[27153.317113] xc2028 0-0061: Can't find firmware for type=BASE INIT1
F8MHZ MTS (4007), id 0000000000000000.
[27153.317121] xc2028 0-0061: load_firmware called
[27153.317124] xc2028 0-0061: seek_firmware called, want type=BASE INIT1
MTS D2633 DTV78 (4115), id 0000000000000000.
[27153.317133] xc2028 0-0061: Can't find firmware for type=BASE INIT1
MTS (4005), id 0000000000000000.
[27153.317140] xc2028 0-0061: load_firmware called
[27153.317143] xc2028 0-0061: seek_firmware called, want type=F8MHZ MTS
D2633 DTV78 (116), id 0000000000000000.
[27153.317151] xc2028 0-0061: Found firmware for type=D2633 DTV78 (110),
id 0000000000000000.
[27153.317157] xc2028 0-0061: Loading firmware for type=D2633 DTV78
(110), id 0000000000000000.
[27153.332685] xc2028 0-0061: Trying to load scode 0
[27153.332692] xc2028 0-0061: load_scode called
[27153.332697] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[27153.335181] xc2028 0-0061: xc2028_get_reg 0004 called
[27153.336185] xc2028 0-0061: xc2028_get_reg 0008 called
[27153.337174] xc2028 0-0061: Device is Xceive 3028 version 1.0,
firmware version 2.7
[27153.456509] xc2028 0-0061: divisor= 00 00 a3 d0 (freq=658.000)


Best regards,
Gianluca Gennari

