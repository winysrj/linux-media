Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:39494 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751690Ab2LUWAh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Dec 2012 17:00:37 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: AverMedia Satelllite Hybrid+FM A706
Date: Fri, 21 Dec 2012 23:00:08 +0100
Cc: linux-media@vger.kernel.org
References: <201212182245.50722.linux@rainbow-software.org> <201212202237.12376.linux@rainbow-software.org>
In-Reply-To: <201212202237.12376.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201212212300.09132.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update 2:
all I2C breakage is caused by i2c gates in CE6313 and TDA8290 so I just
commented-out the calls in tuner drivers for now.
Tuner detection in tda8290 breaks because it finds CE5039 at 0x60. Disabling
CE5039 using GPIO in board_init1() and enabling it in dvb_init() allows all
chips to initialize properly:

[  130.658813] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[  130.662715] saa7133[0]: found at 0000:02:01.0, rev: 209, irq: 9, latency: 32, mmio: 0xf4000000
[  130.665879] saa7133[0]: subsystem: 1461:2055, board: AverMedia AverTV Satellite Hybrid+FM A706 [card=191,autodetected]
[  130.669347] saa7133[0]: board init: gpio is 3500
[  130.822347] saa7133[0]: i2c eeprom 00: 61 14 55 20 00 00 00 00 00 00 00 00 00 00 00 00
[  130.825689] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff ff ff ff ff ff ff
[  130.829008] saa7133[0]: i2c eeprom 20: 02 40 01 02 02 01 01 04 06 ff 00 57 ff ff ff ff
[  130.832317] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  130.835627] saa7133[0]: i2c eeprom 40: 60 a0 00 c6 96 ff 05 30 8b 05 ff 40 ff ff ff ff
[  130.838932] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  130.842222] saa7133[0]: i2c eeprom 60: ff 89 00 c0 ff 1c 08 19 97 89 ff ff 80 15 0a ff
[  130.845525] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  130.848833] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  130.852109] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  130.855351] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  130.858565] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  130.861736] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  130.864894] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  130.868021] saa7133[0]: i2c eeprom e0: 00 01 81 b0 65 07 ff ff ff ff ff ff ff ff ff ff
[  130.871133] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  130.930349] tuner 2-004b: Tuner -1 found with type(s) Radio TV.
[  130.974345] tda829x 2-004b: setting tuner address to 63
[  131.019535] tda18271 2-0063: creating new instance
[  131.030345] TDA18271HD/C2 detected @ 2-0063
[  131.454335] tda18271: performing RF tracking filter calibration
[  135.778283] tda18271: RF tracking filter calibration complete
[  135.786296] tda829x 2-004b: type set to tda8290+18271
[  138.635047] saa7133[0]: registered device video0 [v4l2]
[  138.639407] saa7133[0]: registered device vbi0
[  138.643130] saa7133[0]: registered device radio0
[  138.676190] dvb_init() allocating 1 frontend
[  139.730238] DVB: registering new adapter (saa7133[0])
[  139.733196] saa7134 0000:02:01.0: DVB: registering adapter 0 frontend 0 (Zarlink ZL10313 DVB-S)...
[  140.321583] saa7134 ALSA driver for DMA sound loaded
[  140.325361] saa7133[0]/alsa: saa7133[0] at 0xf4000000 irq 9 registered as card -1

The card comes to life slowly: FM radio works for a couple of seconds!
With arecord | aplay, noise is played. When a radio station is tuned
(v4l2ctl -d /dev/radio0 -f something), I can hear it clearly for a 2-3 seconds,
then it fades to noise.

These errors appear in log:
[  521.281639] tda18271c2_rf_tracking_filters_correction: [2-0063|M] error -22 on line 277
[  521.289675] tda18271_calc_ir_measure: [2-0063|M] error -34 on line 686
[  521.289682] tda18271_calc_bp_filter: [2-0063|M] error -34 on line 618
[  521.289686] tda18271_calc_rf_band: [2-0063|M] error -34 on line 652
[  521.289690] tda18271_calc_gain_taper: [2-0063|M] error -34 on line 669


-- 
Ondrej Zary
