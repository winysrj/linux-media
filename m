Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timf@iinet.net.au>) id 1JjzY9-0002H7-0D
	for linux-dvb@linuxtv.org; Thu, 10 Apr 2008 18:23:06 +0200
Message-ID: <47FE3ECC.8020209@iinet.net.au>
Date: Fri, 11 Apr 2008 00:22:36 +0800
From: timf <timf@iinet.net.au>
MIME-Version: 1.0
To: hartmut.hackmann@t-online.de, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Kworld DVB-T 210 - dvb tuning problem
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


Hi Hartmut,
OK, found some more spare time, but very, very frustrated!

1) Tried ubuntu 7.04, 7.10, 8.04
    Tried with just modules that exist in kernel (no v4l-dvb)
   Tried v4l-dvb from June 2007 and tried current v4l-dvb
   Tried with/without Hartmut patch - changeset 7376    49ba58715fe0
   Tried with .gpio_config   = TDA10046_GP11_I, or .gpio_config   = 
TDA10046_GP01_I,
   Tried using configs in saa7134-dvb.c matching tiger, tiger_s, 
pinnacle 310i, twinhan 3056

    # Australia / Perth (Roleystone transmitter)
    # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
    # SBS
    T 704500000 7MHz 2/3 NONE QAM64 8k 1/8 NONE
    # ABC
    T 725500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
    # Seven
    T 746500000 7MHz 2/3 NONE QAM64 8k 1/16 NONE
    # Nine
    T 767500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
    # Ten
    T 788500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE

2) I have these saa7134 cards:
    - pinnacle 310i
    - kworld 210

    This cx88 card:
    - dvico DVB-T Pro hybrid (analog tv not work)

-   problem only occurs with kworld 210 in linux (works fine in WinXP)

3) In WinXP, all channels, both analog tv and dvb-t found

4) In linux, if start dvb-t first, never scans SBS - dmesg1

5) In linux, if start analog tv first, stop, then start dvb-t, scan 
finds SBS - dmesg2

dmesg1:
[   44.841316] Linux video capture interface: v2.00

[   45.150800] saa7130/34: v4l2 driver version 0.2.14 loaded

[   45.150869] saa7133[0]: found at 0000:05:01.0, rev: 209, irq: 17, 
latency: 64, mmio: 0xfebff800
[   45.150875] saa7133[0]: subsystem: 17de:7250, board: KWorld DVB-T 210 
[card=114,autodetected]
[   45.150882] saa7133[0]: board init: gpio is 100
[   45.299946] saa7133[0]: i2c eeprom 00: de 17 50 72 ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.299956] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.299963] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.299970] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.299976] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.299983] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.299989] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.299996] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.300002] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.300009] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.300015] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.300022] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.300028] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.300035] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.300041] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.300048] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.308034] saa7133[0]: i2c scan: found device @ 0x10  [???]
[   45.328132] saa7133[0]: i2c scan: found device @ 0x96  [???]
[   45.336273] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]

[   45.489666] tda8290_probe: tda8290 detected @ 0-004b
[   45.489672] tuner' 0-004b: tda829x detected
[   45.489675] tuner' 0-004b: Setting mode_mask to 0x0e
[   45.489679] tuner' 0-004b: chip found @ 0x96 (saa7133[0])
[   45.489683] tuner' 0-004b: tuner 0x4b: Tuner type absent
[   45.489721] tuner' 0-004b: Calling set_type_addr for type=54, 
addr=0xff, mode=0x04, config=0x00
[   45.489724] tuner' 0-004b: set addr for type -1
[   45.489727] tuner' 0-004b: defining GPIO callback
[   45.505825] tda8290_probe: tda8290 detected @ 0-004b

[   45.570465] tda829x 0-004b: setting tuner address to 61
[   45.610865] tda827x: tda827x_attach:
[   45.610868] tda827x: type set to Philips TDA827X
[   45.618924] tda827x: tda827xa tuner found
[   45.618927] tda827x: tda827x_init:
[   45.618929] tda827x: tda827xa_sleep:
[   45.635024] tda829x 0-004b: type set to tda8290+75a
[   45.719438] tuner' 0-004b: type set to tda8290+75a
[   45.719443] tuner' 0-004b: tv freq set to 400.00
[   45.719447] tda829x 0-004b: setting tda829x to system xx
[   45.824191] tda827x: setting tda827x to system xx
[   45.880752] tda827x: AGC2 gain is: 8
[   46.219521] tda829x 0-004b: tda8290 not locked, no signal?
[   46.340456] tda829x 0-004b: tda8290 not locked, no signal?
[   46.461656] tda829x 0-004b: tda8290 not locked, no signal?
[   46.566695] tda829x 0-004b: adjust gain, step 1. Agc: 0, ADC stat: 0, 
lock: 0
[   46.707474] tda829x 0-004b: adjust gain, step 2. Agc: 204, lock: 0
[   46.852660] tda829x 0-004b: adjust gain, step 3. Agc: 108
[   46.990029] tuner' 0-004b: saa7133[0] tuner' I2C addr 0x96 with type 
54 used for 0x0e
[   47.002109] tuner' 0-004b: switching to v4l2
[   47.002114] tuner' 0-004b: tv freq set to 400.00
[   47.002118] tda829x 0-004b: setting tda829x to system B
[   47.106916] tda827x: setting tda827x to system B
[   47.175250] tda827x: AGC2 gain is: 8
[   47.506148] tda829x 0-004b: tda8290 not locked, no signal?
[   47.635056] tda829x 0-004b: tda8290 not locked, no signal?
[   47.751728] tda829x 0-004b: tda8290 not locked, no signal?
[   47.856768] tda829x 0-004b: adjust gain, step 1. Agc: 0, ADC stat: 0, 
lock: 0
[   48.002207] tda829x 0-004b: adjust gain, step 2. Agc: 225, lock: 0
[   48.151158] tda829x 0-004b: adjust gain, step 3. Agc: 133
[   48.288197] tuner' 0-004b: tv freq set to 400.00
[   48.288200] tda829x 0-004b: setting tda829x to system B
[   48.393231] tda827x: setting tda827x to system B
[   48.453810] tda827x: AGC2 gain is: 8
[   48.784236] tda829x 0-004b: tda8290 not locked, no signal?
[   48.905435] tda829x 0-004b: tda8290 not locked, no signal?
[   49.026553] tda829x 0-004b: tda8290 not locked, no signal?
[   49.127045] tda829x 0-004b: adjust gain, step 1. Agc: 0, ADC stat: 0, 
lock: 0
[   49.272200] tda829x 0-004b: adjust gain, step 2. Agc: 196, lock: 0
[   49.417642] tda829x 0-004b: adjust gain, step 3. Agc: 100
[   49.563001] saa7133[0]: registered device video0 [v4l2]
[   49.563022] saa7133[0]: registered device vbi0
[   49.563042] saa7133[0]: registered device radio0
[   49.563049] saa7133[0]: dsp access error
[   49.563051] saa7133[0]: dsp access error
[   49.563110] tuner' 0-004b: Cmd TUNER_SET_STANDBY accepted for analog TV
[   49.642566] saa7134 ALSA driver for DMA sound loaded
[   49.642600] saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 17 
registered as card -2
[   49.927240] tda827x: tda827x_attach:
[   49.927245] tda827x: type set to Philips TDA827X
[   49.927251] DVB: registering new adapter (saa7133[0])
[   49.927255] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
[   49.999195] tda1004x: setting up plls for 48MHz sampling clock
[   50.283154] tda1004x: found firmware revision 29 -- ok
[   50.571129] tda827x: tda827xa tuner found
[   50.571136] tda827x: tda827xa_sleep:

[   50.643361] saa7133[0]/dvb: setting GPIO21 to 1 (Radio antenna?)

-> ... here start scanning with dvb-utils/scan via me-tv

[   87.654762] tda1004x: setting up plls for 48MHz sampling clock
[   87.858921] tda1004x: found firmware revision 29 -- ok
[   88.050891] tda827x: tda827x_init:
[   88.050895] saa7133[0]/dvb: setting GPIO21 to 0 (TV antenna?)
[   91.888418] tda827x: tda827xa_set_params:
[   91.888425] tda827x: setting LNA to high gain
[   92.096383] tda827x: tda8275a AGC2 gain is: 8
[   93.856104] tda827x: tda827xa_set_params:
[   93.856113] tda827x: setting LNA to high gain
[   94.100059] tda827x: tda8275a AGC2 gain is: 8
[  100.854974] tda827x: tda827xa_set_params:
[  100.854981] tda827x: setting LNA to high gain
[  101.098933] tda827x: tda8275a AGC2 gain is: 8
[  105.510225] tda827x: tda827xa_set_params:
[  105.510232] tda827x: setting LNA to high gain
[  105.754184] tda827x: tda8275a AGC2 gain is: 8
[  109.393600] tda827x: tda827xa_set_params:
[  109.393606] tda827x: setting LNA to high gain
[  109.637559] tda827x: tda8275a AGC2 gain is: 8
[  111.825207] tda827x: tda827xa_set_params:
[  111.825214] tda827x: setting LNA to high gain
[  112.069167] tda827x: tda8275a AGC2 gain is: 8
[  113.852884] tda827x: tda827xa_set_params:
[  113.852891] tda827x: setting LNA to high gain
[  114.096840] tda827x: tda8275a AGC2 gain is: 8
[  116.828403] tda827x: tda827xa_set_params:
[  116.828410] tda827x: setting LNA to high gain
[  117.072362] tda827x: tda8275a AGC2 gain is: 8
[  124.419181] tda827x: tda827xa_set_params:
[  124.419187] tda827x: setting LNA to high gain
[  124.663139] tda827x: tda8275a AGC2 gain is: 8
[  129.802314] tda827x: tda827xa_set_params:
[  129.802320] tda827x: setting LNA to high gain
[  130.046273] tda827x: tda8275a AGC2 gain is: 8
[  133.029794] tda827x: tda827xa_set_params:
[  133.029800] tda827x: setting LNA to high gain
[  133.273756] tda827x: tda8275a AGC2 gain is: 8
[  139.768713] tda827x: tda827xa_set_params:
[  139.768719] tda827x: setting LNA to high gain
[  140.012692] tda827x: tda8275a AGC2 gain is: 8
[  150.782936] tda827x: tda827xa_set_params:
[  150.782942] tda827x: setting LNA to high gain
[  151.002900] tda827x: tda8275a AGC2 gain is: 8
[  153.166553] tda827x: tda827xa_set_params:
[  153.166560] tda827x: setting LNA to high gain
[  153.386517] tda827x: tda8275a AGC2 gain is: 8
[  160.021449] tda827x: tda827xa_set_params:
[  160.021456] tda827x: setting LNA to high gain
[  160.237414] tda827x: tda8275a AGC2 gain is: 8
[  171.027678] tda827x: tda827xa_set_params:
[  171.027684] tda827x: setting LNA to high gain
[  171.243642] tda827x: tda8275a AGC2 gain is: 8
[  179.591275] tda827x: tda827xa_set_params:
[  179.591282] tda827x: setting LNA to high gain
[  179.799322] tda827x: tda8275a AGC2 gain is: 8
[  188.045325] tda827x: tda827xa_sleep:
[  188.125616] saa7133[0]/dvb: setting GPIO21 to 1 (Radio antenna?)

---------------------------------------------------------------------

dmesg2:
[   45.042866] Linux video capture interface: v2.00
[   45.103665] saa7130/34: v4l2 driver version 0.2.14 loaded

[   45.103745] saa7133[0]: found at 0000:05:01.0, rev: 209, irq: 17, 
latency: 64, mmio: 0xfebff800
[   45.103752] saa7133[0]: subsystem: 17de:7250, board: KWorld DVB-T 210 
[card=114,autodetected]
[   45.103760] saa7133[0]: board init: gpio is 100
[   45.263665] saa7133[0]: i2c eeprom 00: de 17 50 72 ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.263679] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.263690] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.263701] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.263712] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.263722] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.263733] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.263744] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.263755] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.263766] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.263777] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.263787] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.263798] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.263809] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.263820] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.263831] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   45.275764] saa7133[0]: i2c scan: found device @ 0x10  [???]
[   45.295820] saa7133[0]: i2c scan: found device @ 0x96  [???]
[   45.308019] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]

[   45.449032] tda8290_probe: tda8290 detected @ 0-004b
[   45.449037] tuner' 0-004b: tda829x detected
[   45.449041] tuner' 0-004b: Setting mode_mask to 0x0e
[   45.449044] tuner' 0-004b: chip found @ 0x96 (saa7133[0])
[   45.449048] tuner' 0-004b: tuner 0x4b: Tuner type absent
[   45.449082] tuner' 0-004b: Calling set_type_addr for type=54, 
addr=0xff, mode=0x04, config=0x00
[   45.449086] tuner' 0-004b: set addr for type -1
[   45.449089] tuner' 0-004b: defining GPIO callback
[   45.465191] tda8290_probe: tda8290 detected @ 0-004b

[   45.529831] tda829x 0-004b: setting tuner address to 61
[   45.570255] tda827x: tda827x_attach:
[   45.570258] tda827x: type set to Philips TDA827X
[   45.578310] tda827x: tda827xa tuner found
[   45.578313] tda827x: tda827x_init:
[   45.578315] tda827x: tda827xa_sleep:
[   45.594481] tda829x 0-004b: type set to tda8290+75a
[   45.663128] tuner' 0-004b: type set to tda8290+75a
[   45.663132] tuner' 0-004b: tv freq set to 400.00
[   45.663137] tda829x 0-004b: setting tda829x to system xx
[   45.779921] tda827x: setting tda827x to system xx
[   45.836196] tda827x: AGC2 gain is: 9
[   46.167210] tda829x 0-004b: tda8290 not locked, no signal?
[   46.291982] tda829x 0-004b: tda8290 not locked, no signal?
[   46.412775] tda829x 0-004b: tda8290 not locked, no signal?
[   46.517815] tda829x 0-004b: adjust gain, step 1. Agc: 0, ADC stat: 0, 
lock: 0
[   46.663254] tda829x 0-004b: adjust gain, step 2. Agc: 225, lock: 0
[   46.804045] tda829x 0-004b: adjust gain, step 3. Agc: 119
[   46.941140] tuner' 0-004b: saa7133[0] tuner' I2C addr 0x96 with type 
54 used for 0x0e
[   46.953230] tuner' 0-004b: switching to v4l2
[   46.953236] tuner' 0-004b: tv freq set to 400.00
[   46.953240] tda829x 0-004b: setting tda829x to system B
[   47.058260] tda827x: setting tda827x to system B
[   47.118839] tda827x: AGC2 gain is: 9
[   47.449264] tda829x 0-004b: tda8290 not locked, no signal?
[   47.570463] tda829x 0-004b: tda8290 not locked, no signal?
[   47.695499] tda829x 0-004b: tda8290 not locked, no signal?
[   47.796012] tda829x 0-004b: adjust gain, step 1. Agc: 0, ADC stat: 0, 
lock: 0
[   47.941308] tda829x 0-004b: adjust gain, step 2. Agc: 204, lock: 0
[   48.086748] tda829x 0-004b: adjust gain, step 3. Agc: 108
[   48.227685] tuner' 0-004b: tv freq set to 400.00
[   48.227688] tda829x 0-004b: setting tda829x to system B
[   48.332434] tda827x: setting tda827x to system B
[   48.389003] tda827x: AGC2 gain is: 8
[   48.727743] tda829x 0-004b: tda8290 not locked, no signal?
[   48.848678] tda829x 0-004b: tda8290 not locked, no signal?
[   48.969877] tda829x 0-004b: tda8290 not locked, no signal?
[   49.074917] tda829x 0-004b: adjust gain, step 1. Agc: 0, ADC stat: 0, 
lock: 0
[   49.215687] tda829x 0-004b: adjust gain, step 2. Agc: 204, lock: 0
[   49.360883] tda829x 0-004b: adjust gain, step 3. Agc: 108
[   49.498617] saa7133[0]: registered device video0 [v4l2]
[   49.498763] saa7133[0]: registered device vbi0
[   49.498904] saa7133[0]: registered device radio0
[   49.498985] tuner' 0-004b: Cmd TUNER_SET_STANDBY accepted for analog TV
[   49.578852] saa7134 ALSA driver for DMA sound loaded
[   49.578881] saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 17 
registered as card -2
[   49.691172] tda827x: tda827x_attach:
[   49.691176] tda827x: type set to Philips TDA827X
[   49.691179] DVB: registering new adapter (saa7133[0])
[   49.691182] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
[   49.791118] tda1004x: setting up plls for 48MHz sampling clock
[   50.155058] tda1004x: found firmware revision 29 -- ok
[   50.575001] tda827x: tda827xa tuner found
[   50.575008] tda827x: tda827xa_sleep:
[   50.659073] saa7133[0]/dvb: setting GPIO21 to 1 (Radio antenna?)

-> ... here start viewing analog tv via tvtime

[   83.314648] tuner' 0-004b: Cmd VIDIOC_S_STD accepted for analog TV
[   83.314655] tuner' 0-004b: tv freq set to 400.00
[   83.314659] tda829x 0-004b: setting tda829x to system B
[   83.425824] tda827x: setting tda827x to system B
[   83.501861] tda827x: AGC2 gain is: 10
[   83.837806] tda829x 0-004b: tda8290 not locked, no signal?
[   83.957786] tda829x 0-004b: tda8290 not locked, no signal?
[   84.077767] tda829x 0-004b: tda8290 not locked, no signal?
[   84.181759] tda829x 0-004b: adjust gain, step 1. Agc: 0, ADC stat: 0, 
lock: 0
[   84.329729] tda829x 0-004b: adjust gain, step 2. Agc: 246, lock: 0
[   84.477703] tda829x 0-004b: adjust gain, step 3. Agc: 153
[   84.621780] tuner' 0-004b: tv freq set to 400.00
[   84.621786] tda829x 0-004b: setting tda829x to system B
[   84.733660] tda827x: setting tda827x to system B
[   84.801649] tda827x: AGC2 gain is: 9
[   85.129600] tda829x 0-004b: tda8290 not locked, no signal?
[   85.249595] tda829x 0-004b: tda8290 not locked, no signal?
[   85.369563] tda829x 0-004b: tda8290 not locked, no signal?
[   85.473542] tda829x 0-004b: adjust gain, step 1. Agc: 0, ADC stat: 0, 
lock: 0
[   85.617517] tda829x 0-004b: adjust gain, step 2. Agc: 212, lock: 0
[   85.761495] tda829x 0-004b: adjust gain, step 3. Agc: 113
[   85.897539] tuner' 0-004b: tv freq set to 400.00
[   85.897545] tda829x 0-004b: setting tda829x to system B
[   86.005458] tda827x: setting tda827x to system B
[   86.073445] tda827x: AGC2 gain is: 9
[   86.401398] tda829x 0-004b: tda8290 not locked, no signal?
[   86.521372] tda829x 0-004b: tda8290 not locked, no signal?
[   86.641353] tda829x 0-004b: tda8290 not locked, no signal?
[   86.745337] tda829x 0-004b: adjust gain, step 1. Agc: 0, ADC stat: 0, 
lock: 0
[   86.889316] tda829x 0-004b: adjust gain, step 2. Agc: 204, lock: 0
[   87.033290] tda829x 0-004b: adjust gain, step 3. Agc: 106
[   87.230182] tuner' 0-004b: tv freq set to 400.00
[   87.230191] tda829x 0-004b: setting tda829x to system B
[   87.341241] tda827x: setting tda827x to system B
[   87.409229] tda827x: AGC2 gain is: 9
[   87.737177] tda829x 0-004b: tda8290 not locked, no signal?
[   87.857157] tda829x 0-004b: tda8290 not locked, no signal?
[   87.977138] tda829x 0-004b: tda8290 not locked, no signal?
[   88.081122] tda829x 0-004b: adjust gain, step 1. Agc: 0, ADC stat: 0, 
lock: 0
[   88.225098] tda829x 0-004b: adjust gain, step 2. Agc: 212, lock: 0
[   88.369076] tda829x 0-004b: adjust gain, step 3. Agc: 113
[   88.505137] tuner' 0-004b: tv freq set to 400.00
[   88.505143] tda829x 0-004b: setting tda829x to system B
[   88.613036] tda827x: setting tda827x to system B
[   88.681025] tda827x: AGC2 gain is: 8
[   89.008972] tda829x 0-004b: tda8290 not locked, no signal?
[   89.128955] tda829x 0-004b: tda8290 not locked, no signal?
[   89.248951] tda829x 0-004b: tda8290 not locked, no signal?
[   89.352917] tda829x 0-004b: adjust gain, step 1. Agc: 0, ADC stat: 0, 
lock: 0
[   89.496894] tda829x 0-004b: adjust gain, step 2. Agc: 204, lock: 0
[   89.640871] tda829x 0-004b: adjust gain, step 3. Agc: 106
[   89.869324] tuner' 0-004b: tv freq set to 209.25
[   89.869332] tda829x 0-004b: setting tda829x to system B
[   89.976818] tda827x: setting tda827x to system B
[   90.044806] tda827x: AGC2 gain is: 9
[   90.408754] tda829x 0-004b: tda8290 is locked, AGC: 255
[   90.408761] tda829x 0-004b: adjust gain, step 1. Agc: 255, ADC stat: 
0, lock: 128
[   90.556725] tda829x 0-004b: adjust gain, step 2. Agc: 135, lock: 0
[   93.410080] tuner' 0-004b: Cmd TUNER_SET_STANDBY accepted for analog TV

-> ... here start scanning via me-tv dvb-utils/scan

[   95.744247] tda1004x: setting up plls for 48MHz sampling clock
[   96.108190] tda1004x: found firmware revision 29 -- ok
[   96.396146] tda827x: tda827x_init:
[   96.396153] saa7133[0]/dvb: setting GPIO21 to 0 (TV antenna?)
[   99.516901] tda827x: tda827xa_set_params:
[   99.516908] tda827x: setting LNA to high gain
[   99.724867] tda827x: tda8275a AGC2 gain is: 8
[  108.659429] tda827x: tda827xa_set_params:
[  108.659437] tda827x: setting LNA to high gain
[  108.867394] tda827x: tda8275a AGC2 gain is: 8
[  110.883074] tda827x: tda827xa_set_params:
[  110.883081] tda827x: setting LNA to high gain
[  111.091038] tda827x: tda8275a AGC2 gain is: 8
[  116.882107] tda827x: tda827xa_set_params:
[  116.882114] tda827x: setting LNA to high gain
[  117.090068] tda827x: tda8275a AGC2 gain is: 8
[  118.981766] tda827x: tda827xa_set_params:
[  118.981773] tda827x: setting LNA to high gain
[  119.189733] tda827x: tda8275a AGC2 gain is: 8
[  121.297396] tda827x: tda827xa_set_params:
[  121.297403] tda827x: setting LNA to high gain
[  121.505361] tda827x: tda8275a AGC2 gain is: 8
[  123.081110] tda827x: tda827xa_set_params:
[  123.081118] tda827x: setting LNA to high gain
[  123.289073] tda827x: tda8275a AGC2 gain is: 8
[  124.864821] tda827x: tda827xa_set_params:
[  124.864830] tda827x: setting LNA to high gain
[  125.072786] tda827x: tda8275a AGC2 gain is: 8
[  126.084630] tda827x: tda827xa_set_params:
[  126.084639] tda827x: setting LNA to high gain
[  126.292590] tda827x: tda8275a AGC2 gain is: 8
[  127.868335] tda827x: tda827xa_set_params:
[  127.868343] tda827x: setting LNA to high gain
[  128.076300] tda827x: tda8275a AGC2 gain is: 8
[  129.652048] tda827x: tda827xa_set_params:
[  129.652054] tda827x: setting LNA to high gain
[  129.860014] tda827x: tda8275a AGC2 gain is: 8
[  130.871851] tda827x: tda827xa_set_params:
[  130.871859] tda827x: setting LNA to high gain
[  131.079818] tda827x: tda8275a AGC2 gain is: 8
[  138.610606] tda827x: tda827xa_set_params:
[  138.610614] tda827x: setting LNA to high gain
[  138.818571] tda827x: tda8275a AGC2 gain is: 8
[  140.394320] tda827x: tda827xa_set_params:
[  140.394327] tda827x: setting LNA to high gain
[  140.602284] tda827x: tda8275a AGC2 gain is: 8
[  142.178031] tda827x: tda827xa_set_params:
[  142.178038] tda827x: setting LNA to high gain
[  142.386001] tda827x: tda8275a AGC2 gain is: 8
[  143.397837] tda827x: tda827xa_set_params:
[  143.397844] tda827x: setting LNA to high gain
[  143.605803] tda827x: tda8275a AGC2 gain is: 8
[  145.181549] tda827x: tda827xa_set_params:
[  145.181556] tda827x: setting LNA to high gain
[  145.389520] tda827x: tda8275a AGC2 gain is: 8
[  146.965261] tda827x: tda827xa_set_params:
[  146.965267] tda827x: setting LNA to high gain
[  147.173226] tda827x: tda8275a AGC2 gain is: 8
[  148.185065] tda827x: tda827xa_set_params:
[  148.185071] tda827x: setting LNA to high gain
[  148.393032] tda827x: tda8275a AGC2 gain is: 8
[  149.968779] tda827x: tda827xa_set_params:
[  149.968786] tda827x: setting LNA to high gain
[  150.176743] tda827x: tda8275a AGC2 gain is: 8
[  151.752490] tda827x: tda827xa_set_params:
[  151.752498] tda827x: setting LNA to high gain
[  151.960456] tda827x: tda8275a AGC2 gain is: 8
[  152.972294] tda827x: tda827xa_set_params:
[  152.972302] tda827x: setting LNA to high gain
[  153.180262] tda827x: tda8275a AGC2 gain is: 8
[  154.756008] tda827x: tda827xa_set_params:
[  154.756014] tda827x: setting LNA to high gain
[  154.963973] tda827x: tda8275a AGC2 gain is: 8
[  156.539720] tda827x: tda827xa_set_params:
[  156.539726] tda827x: setting LNA to high gain
[  156.747686] tda827x: tda8275a AGC2 gain is: 8
[  157.759524] tda827x: tda827xa_set_params:
[  157.759532] tda827x: setting LNA to high gain
[  157.967489] tda827x: tda8275a AGC2 gain is: 8
[  159.543237] tda827x: tda827xa_set_params:
[  159.543244] tda827x: setting LNA to high gain
[  159.751203] tda827x: tda8275a AGC2 gain is: 8
[  161.326950] tda827x: tda827xa_set_params:
[  161.326956] tda827x: setting LNA to high gain
[  161.534915] tda827x: tda8275a AGC2 gain is: 8
[  162.546754] tda827x: tda827xa_set_params:
[  162.546761] tda827x: setting LNA to high gain
[  162.754721] tda827x: tda8275a AGC2 gain is: 8
[  164.330466] tda827x: tda827xa_set_params:
[  164.330473] tda827x: setting LNA to high gain
[  164.538432] tda827x: tda8275a AGC2 gain is: 8
[  166.114178] tda827x: tda827xa_set_params:
[  166.114184] tda827x: setting LNA to high gain
[  166.322145] tda827x: tda8275a AGC2 gain is: 8
[  167.333983] tda827x: tda827xa_set_params:
[  167.333990] tda827x: setting LNA to high gain
[  167.541949] tda827x: tda8275a AGC2 gain is: 8
[  169.117696] tda827x: tda827xa_set_params:
[  169.117703] tda827x: setting LNA to high gain
[  169.325661] tda827x: tda8275a AGC2 gain is: 8
[  170.901411] tda827x: tda827xa_set_params:
[  170.901417] tda827x: setting LNA to high gain
[  171.109374] tda827x: tda8275a AGC2 gain is: 8
[  172.121213] tda827x: tda827xa_set_params:
[  172.121220] tda827x: setting LNA to high gain
[  172.329177] tda827x: tda8275a AGC2 gain is: 8
[  173.904926] tda827x: tda827xa_set_params:
[  173.904932] tda827x: setting LNA to high gain
[  174.112891] tda827x: tda8275a AGC2 gain is: 8
[  175.688638] tda827x: tda827xa_set_params:
[  175.688644] tda827x: setting LNA to high gain
[  175.896603] tda827x: tda8275a AGC2 gain is: 8
[  176.908442] tda827x: tda827xa_set_params:
[  176.908448] tda827x: setting LNA to high gain
[  177.116409] tda827x: tda8275a AGC2 gain is: 8
[  183.579369] tda827x: tda827xa_set_params:
[  183.579378] tda827x: setting LNA to high gain
[  183.787333] tda827x: tda8275a AGC2 gain is: 8
[  194.533604] tda827x: tda827xa_set_params:
[  194.533612] tda827x: setting LNA to high gain
[  194.741569] tda827x: tda8275a AGC2 gain is: 8
[  202.352347] tda827x: tda827xa_set_params:
[  202.352355] tda827x: setting LNA to high gain
[  202.560312] tda827x: tda8275a AGC2 gain is: 8
[  209.199244] tda827x: tda827xa_set_params:
[  209.199252] tda827x: setting LNA to high gain
[  209.407211] tda827x: tda8275a AGC2 gain is: 8
[  220.245465] tda827x: tda827xa_set_params:
[  220.245473] tda827x: setting LNA to high gain
[  220.489426] tda827x: tda8275a AGC2 gain is: 8
[  228.678486] tda827x: tda827xa_set_params:
[  228.678494] tda827x: setting LNA to high gain
[  228.890780] tda827x: tda8275a AGC2 gain is: 8
[  237.136138] tda827x: tda827xa_sleep:
[  237.208124] saa7133[0]/dvb: setting GPIO21 to 1 (Radio antenna?)

6) Herman mentioned something called a "mode-switch" in the archives, 
but not any description.
I tried to find some data sheets for tda8275 tda8290 but only found the 
publicity pdf file from Phillips,
so at least I can see they go together, so I presume this "mode-switch" 
is coded into those modules.
But those modules work for all other cards, so now I'm lost again.

What else should I try?

Regards,
Tim

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
