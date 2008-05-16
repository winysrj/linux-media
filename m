Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web55608.mail.re4.yahoo.com ([206.190.58.232])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <trevor_boon@yahoo.com>) id 1Jx6P6-0000mH-Nm
	for linux-dvb@linuxtv.org; Fri, 16 May 2008 22:19:52 +0200
Date: Fri, 16 May 2008 13:19:14 -0700 (PDT)
From: Trevor Boon <trevor_boon@yahoo.com>
To: hermann pitton <hermann-pitton@arcor.de>
MIME-Version: 1.0
Message-ID: <830757.84071.qm@web55608.mail.re4.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] unknown i2c device on saa7130 card
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

As Amitay has said, the GPIO is an elusive thing. Steve posted
previously that the XC2028 sample code is similar to what should be
used to bring the tda10048 out of reset, but I can't seem to obtain any
useful data from the windows driver.

These are the only addresses I can see, but I've no idea how to obtain GPIO's from this.

HKR, "I2C Devices", "Device 0, Data1",0x00010001,0x03  ; Tuner ID 
HKR, "I2C Devices", "Device 0, Data2",0x00010001,0xC0  ; Tuner slave addr. 
HKR, "I2C Devices", "Device 0, Data3",0x00010001,0x86  ; Tuner IF PLL slave addr.

With
debug options i2c_scan=,1gpio_tracking=1, irq_debug=1, this is my
dmesg. Perhaps something in here may mean something to the more
experienced members of this list ...

[64502.117227] saa7130[0]/irq[42,16083975]: r=0x0 s=0x10
[64542.743415] Linux video capture interface: v2.00
[64542.766463] saa7130/34: v4l2 driver version 0.2.14 loaded
[64542.766519] saa7130[0]: found at 0000:02:01.0, rev: 1, irq: 16, latency: 32, mmio: 0xc0021000
[64542.766528] saa7130[0]: subsystem: 107d:6655, board: Leadtek Winfast DTV-1000s [card=143,autodetected]
[64542.766540] saa7130[0]: board init: gpio is 22000
[64543.509674] saa7130[0]: gpio: mode=0x00000000 in=0x00022000 out=0x00000000 [pre-init]
[64543.613365] ir-kbd-i2c: probe 0x7a @ saa7130[0]: no
[64543.614343] ir-kbd-i2c: probe 0x47 @ saa7130[0]: no
[64543.615246] ir-kbd-i2c: probe 0x71 @ saa7130[0]: no
[64543.616250] ir-kbd-i2c: probe 0x2d @ saa7130[0]: no
[64543.664977] saa7130[0]: i2c eeprom 00: 7d 10 55 66 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[64543.665002] saa7130[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
[64543.665024] saa7130[0]: i2c eeprom 20: 01 40 01 01 01 ff 01 03 08 ff 00 8a ff ff ff ff
[64543.665047] saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[64543.665074] saa7130[0]: i2c eeprom 40: ff 35 00 c0 00 10 03 02 ff 04 ff ff ff ff ff ff
[64543.665093] saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[64543.665112] saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[64543.665131] saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[64543.665149] saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[64543.665168] saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[64543.665187] saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[64543.665205] saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[64543.665247] saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[64543.665266] saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[64543.665284] saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[64543.665304] saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[64543.684922] saa7130[0]: i2c scan: found device @ 0xa0  [eeprom]
[64543.692906] saa7130[0]: i2c scan: found device @ 0xc0  [tuner (analog)]
[64543.720833] tuner' 3-0060: I2C RECV = 83 08 e0 de a5 8e 60 86 a8 63 b0 00 21 72 66 00 
[64543.744784] Chip ID is not zero. It is not a TEA5767
[64543.744859] tuner' 3-0060: Setting mode_mask to 0x0e
[64543.744865] tuner' 3-0060: chip found @ 0xc0 (saa7130[0])
[64543.744874] tuner' 3-0060: tuner 0x60: Tuner type absent
[64543.747667] tuner' 3-0060: TUNER_SET_TYPE_ADDR
[64543.747677] tuner' 3-0060: Calling set_type_addr for type=0, addr=0x00, mode=0x02, config=0x00
[64543.747683] tuner' 3-0060: set addr discarded for type -1, mask e. Asked to change tuner at addr 0x00, with mask 2
[64543.747688] tuner' 3-0060: TUNER_SET_TYPE_ADDR
[64543.747695] tuner' 3-0060: Calling set_type_addr for type=77, addr=0xff, mode=0x0c, config=0x00
[64543.747699] tuner' 3-0060: defining GPIO callback
[64543.766717] tda10048: tda10048_attach()
[64543.771241] tda10048_readreg: readreg error (ret == -5)
[64543.798059] tda18271 3-0060: creating new instance
[64543.808626] TDA18271HD/C1 detected @ 3-0060
[64543.808661] tda18271_init_regs: initializing registers for device @ 3-0060
[64544.211633] tuner' 3-0060: type set to NXP TDA18271HD
[64544.211641] tuner' 3-0060: tv freq set to 400.00
[64544.211646] tda18271_set_analog_params: setting tda18271 to system xx
[64544.211651] tda18271_tune: freq = 400000000, ifc = 7750, bw = 0, agc_mode = 1, std = 7
[64544.542921] tuner' 3-0060: saa7130[0] tuner' I2C addr 0xc0 with type 77 used for 0x0e
[64544.542935] tuner' 3-0060: VIDIOC_S_STD
[64544.542942] tuner' 3-0060: switching to v4l2
[64544.542947] tuner' 3-0060: tv freq set to 400.00
[64544.542951] tda18271_set_analog_params: setting tda18271 to system B
[64544.542955] tda18271_tune: freq = 400000000, ifc = 6750, bw = 0, agc_mode = 1, std = 6
[64544.874010] tuner' 3-0060: VIDIOC_S_STD
[64544.874020] tuner' 3-0060: tv freq set to 400.00
[64544.874024] tda18271_set_analog_params: setting tda18271 to system B
[64544.874029] tda18271_tune: freq = 400000000, ifc = 6750, bw = 0, agc_mode = 1, std = 6
[64545.205265] saa7130[0]: registered device video0 [v4l2]
[64545.206150] saa7130[0]: registered device vbi0
[64545.206821] tuner' 3-0060: TUNER_SET_STANDBY
[64545.206830] tuner' 3-0060: Cmd TUNER_SET_STANDBY accepted for analog TV
[64545.225637] tuner' 3-0060: VIDIOC_S_STD
[64545.225648] tuner' 3-0060: Cmd VIDIOC_S_STD accepted for analog TV
[64545.225653] tuner' 3-0060: tv freq set to 400.00
[64545.225657] tda18271_set_analog_params: setting tda18271 to system B
[64545.225661] tda18271_tune: freq = 400000000, ifc = 6750, bw = 0, agc_mode = 1, std = 6
[64545.242671] saa7130[0]/dvb: Huh? unknown DVB card?
[64545.242678] saa7130[0]/dvb: frontend initialization failed
[64545.557966] tuner' 3-0060: TUNER_SET_STANDBY
[64545.557976] tuner' 3-0060: Cmd TUNER_SET_STANDBY accepted for analog TV
[64545.583876] tuner' 3-0060: VIDIOC_S_STD
[64545.583887] tuner' 3-0060: Cmd VIDIOC_S_STD accepted for analog TV
[64545.583892] tuner' 3-0060: tv freq set to 400.00
[64545.583896] tda18271_set_analog_params: setting tda18271 to system B
[64545.583901] tda18271_tune: freq = 400000000, ifc = 6750, bw = 0, agc_mode = 1, std = 6
[64545.921092] tuner' 3-0060: TUNER_SET_STANDBY
[64545.921102] tuner' 3-0060: Cmd TUNER_SET_STANDBY accepted for analog TV

Thanks.

Trevor.


----- Original Message ----
From: hermann pitton <hermann-pitton@arcor.de>
To: Trevor Boon <trevor_boon@yahoo.com>
Cc: linux-dvb@linuxtv.org
Sent: Friday, 16 May, 2008 9:31:10 PM
Subject: Re: [linux-dvb] unknown i2c device on saa7130 card

Hi,

Am Donnerstag, den 15.05.2008, 22:25 -0700 schrieb Trevor Boon:
> Hi,
> 
> I've been plugging away blindly trying to get my Leadtek Winfast DTV1000S card working
> While trying to figure out how to find the gpio for the tda10048 to be recognised, I have come across an unknown device using the i2c tools. 
> Can anyone shed some light as to what this device is? 
> 
> ...noting that the tuner is at 0xC0 and the eeprom is at 0xA0 on the same bus
> 
> the i2cdump is as follows:
> 
> No size specified (using byte-data access)
> 
>      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
> 00: 7d 10 55 66 54 20 1c 00 43 43 a9 1c 55 d2 b2 92    }?UfT ?.CC??U???
> 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff    ..??. ..........
> 20: 01 40 01 01 01 ff 01 03 08 ff 00 8a ff ff ff ff    ?@???.???..?....
> 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> 40: ff 35 00 c0 00 10 03 02 ff 04 ff ff ff ff ff ff    .5.?.???.?......
> 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> 
> Basic i2cdetect info:
> 
>   Installed I2C busses:
>     i2c-3    smbus         saa7130[0]
>     i2c-0    i2c           NVIDIA i2c adapter 
>     i2c-1    i2c           NVIDIA i2c adapter 
>     i2c-2    i2c           NVIDIA i2c adapter 
> 
> sudo i2cdetect -y 3
>      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
> 00:          -- -- -- -- -- 08 -- -- -- -- -- -- -- 
> 10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 50: 50 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 60: 60 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 70: -- -- -- -- -- -- -- --                        
> 

0x10 >> 1 is the tda10048 then.

Cheers,
Hermann


      Get the name you always wanted with the new y7mail email address.
www.yahoo7.com.au/y7mail



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
