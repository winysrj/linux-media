Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:63485 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3HSOSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 10:18:48 -0400
Date: Mon, 19 Aug 2013 16:18:46 +0200 (CEST)
From: remi <remi@remis.cc>
Reply-To: remi <remi@remis.cc>
To: linux-media@vger.kernel.org
Message-ID: <641271032.80124.1376921926586.open-xchange@email.1and1.fr>
Subject: avermedia A306 / PCIe-minicard (laptop)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
 
I have this card since months,
 
http://www.avermedia.com/avertv/Product/ProductDetail.aspx?Id=376&SI=true
 
I have finally retested it with the cx23885 driver : card=39
 
 
 
If I could do anything to identify : [    2.414734] cx23885[0]: i2c scan: found
device @ 0x66  [???]
 
Or "hookup" the xc5000 etc
 
I'll be more than glad .
 
root@medeb:~# dmesg | grep -i  cx

[    2.140445] cx23885 driver version 0.0.3 loaded
[    2.140949] CORE cx23885[0]: subsystem: 1461:c139, board: AVerTV Hybrid
Express Slim HC81R [card=39,insmod option]
[    2.375411] cx23885[0]: scan bus 0:
[    2.387018] cx23885[0]: i2c scan: found device @ 0xa0  [eeprom]
[    2.393978] cx23885[0]: scan bus 1:
[    2.407961] cx23885[0]: i2c scan: found device @ 0xc2 
[tuner/mt2131/tda8275/xc5000/xc3028]
[    2.412550] cx23885[0]: scan bus 2:
[    2.414734] cx23885[0]: i2c scan: found device @ 0x66  [???]
[    2.415569] cx23885[0]: i2c scan: found device @ 0x88  [cx25837]
[    2.416062] cx23885[0]: i2c scan: found device @ 0x98  [flatiron]
[    2.450115] cx25840 3-0044: cx23885 A/V decoder found @ 0x88 (cx23885[0])
[    3.090011] cx25840 3-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382
bytes)
[    3.111328] cx23885[0]: registered device video1 [v4l2]
[    3.111597] cx23885[0]: registered device vbi0
[    3.111884] cx23885[0]: registered ALSA audio device
[    4.690855] cx23885_dev_checkrevision() Hardware revision = 0xb0
[    4.691054] cx23885[0]/0: found at 0000:05:00.0, rev: 2, irq: 18, latency: 0,
mmio: 0xd3000000
[  325.767037] usbcore: registered new interface driver cx231xx
[  325.767948] cx231xx: Cx231xx dvb Extension initialized
[  347.921336] cx231xx: Cx231xx dvb Extension removed
[  354.682367] cx231xx_dvb: `' invalid for parameter `debug'
[  358.874607] cx231xx: Cx231xx dvb Extension initialized
[  365.393339] cx231xx: Cx231xx dvb Extension removed
[  367.306463] cx231xx: Cx231xx dvb Extension initialized
root@medeb:~#

 
also tuner-xc2028 sees it
 
[    2.407961] cx23885[0]: i2c scan: found device @ 0xc2 
[tuner/mt2131/tda8275/xc5000/xc3028]
[    3.110806] xc2028: Xcv2028/3028 init called!
[    3.110809] xc2028 2-0061: creating new instance
[    3.111025] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
[    3.111218] xc2028 2-0061: xc2028_set_config called
[    3.112079] xc2028 2-0061: request_firmware_nowait(): OK
[    3.112080] xc2028 2-0061: load_all_firmwares called
[    3.112082] xc2028 2-0061: Loading 81 firmware images from xc3028L-v36.fw,
type: xc2028 firmware, ver 3.6
[    3.112088] xc2028 2-0061: Reading firmware type BASE F8MHZ (3), id 0,
size=9144.
[    3.112095] xc2028 2-0061: Reading firmware type BASE F8MHZ MTS (7), id 0,
size=9030.
[    3.112101] xc2028 2-0061: Reading firmware type BASE FM (401), id 0,
size=9054.
[    3.112109] xc2028 2-0061: Reading firmware type BASE FM INPUT1 (c01), id 0,
size=9068.
[    3.112114] xc2028 2-0061: Reading firmware type BASE (1), id 0, size=9132.
[    3.112120] xc2028 2-0061: Reading firmware type BASE MTS (5), id 0,
size=9006.
[    3.112123] xc2028 2-0061: Reading firmware type (0), id 7, size=161.
[    3.112124] xc2028 2-0061: Reading firmware type MTS (4), id 7, size=169.
[    3.112126] xc2028 2-0061: Reading firmware type (0), id 7, size=161.
[    3.112127] xc2028 2-0061: Reading firmware type MTS (4), id 7, size=169.
[    3.112128] xc2028 2-0061: Reading firmware type (0), id 7, size=161.
[    3.112130] xc2028 2-0061: Reading firmware type MTS (4), id 7, size=169.
[    3.112133] xc2028 2-0061: Reading firmware type (0), id 7, size=161.
[    3.112137] xc2028 2-0061: Reading firmware type MTS (4), id 7, size=169.
[    3.112138] xc2028 2-0061: Reading firmware type (0), id e0, size=161.
[    3.112140] xc2028 2-0061: Reading firmware type MTS (4), id e0, size=169.
[    3.112141] xc2028 2-0061: Reading firmware type (0), id e0, size=161.
[    3.112143] xc2028 2-0061: Reading firmware type MTS (4), id e0, size=169.
[    3.112144] xc2028 2-0061: Reading firmware type (0), id 200000, size=161.
[    3.112146] xc2028 2-0061: Reading firmware type MTS (4), id 200000,
size=169.
[    3.112147] xc2028 2-0061: Reading firmware type (0), id 4000000, size=161.
[    3.112149] xc2028 2-0061: Reading firmware type MTS (4), id 4000000,
size=169.
[    3.112151] xc2028 2-0061: Reading firmware type D2633 DTV6 ATSC (10030), id
0, size=149.
[    3.112153] xc2028 2-0061: Reading firmware type D2620 DTV6 QAM (68), id 0,
size=149.
[    3.112154] xc2028 2-0061: Reading firmware type D2633 DTV6 QAM (70), id 0,
size=149.
[    3.112156] xc2028 2-0061: Reading firmware type D2620 DTV7 (88), id 0,
size=149.
[    3.112158] xc2028 2-0061: Reading firmware type D2633 DTV7 (90), id 0,
size=149.
[    3.112159] xc2028 2-0061: Reading firmware type D2620 DTV78 (108), id 0,
size=149.
[    3.112161] xc2028 2-0061: Reading firmware type D2633 DTV78 (110), id 0,
size=149.
[    3.112163] xc2028 2-0061: Reading firmware type D2620 DTV8 (208), id 0,
size=149.
[    3.112164] xc2028 2-0061: Reading firmware type D2633 DTV8 (210), id 0,
size=149.
[    3.112166] xc2028 2-0061: Reading firmware type FM (400), id 0, size=135.
[    3.112168] xc2028 2-0061: Reading firmware type (0), id 10, size=161.
[    3.112169] xc2028 2-0061: Reading firmware type MTS (4), id 10, size=169.
[    3.112171] xc2028 2-0061: Reading firmware type (0), id 400000, size=161.
[    3.112172] xc2028 2-0061: Reading firmware type (0), id 800000, size=161.
[    3.112174] xc2028 2-0061: Reading firmware type (0), id 8000, size=161.
[    3.112175] xc2028 2-0061: Reading firmware type LCD (1000), id 8000,
size=161.
[    3.112177] xc2028 2-0061: Reading firmware type LCD NOGD (3000), id 8000,
size=161.
[    3.112178] xc2028 2-0061: Reading firmware type MTS (4), id 8000, size=169.
[    3.112180] xc2028 2-0061: Reading firmware type (0), id b700, size=161.
[    3.112181] xc2028 2-0061: Reading firmware type LCD (1000), id b700,
size=161.
[    3.112183] xc2028 2-0061: Reading firmware type LCD NOGD (3000), id b700,
size=161.
[    3.112184] xc2028 2-0061: Reading firmware type (0), id 2000, size=161.
[    3.112186] xc2028 2-0061: Reading firmware type MTS (4), id b700, size=169.
[    3.112187] xc2028 2-0061: Reading firmware type MTS LCD (1004), id b700,
size=169.
[    3.112189] xc2028 2-0061: Reading firmware type MTS LCD NOGD (3004), id
b700, size=169.
[    3.112191] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3280
(60000000), id 0, size=192.
[    3.112193] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3300
(60000000), id 0, size=192.
[    3.112195] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3440
(60000000), id 0, size=192.
[    3.112197] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3460
(60000000), id 0, size=192.
[    3.112199] xc2028 2-0061: Reading firmware type DTV6 ATSC OREN36 SCODE
HAS_IF_3800 (60210020), id 0, size=192.
[    3.112201] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4000
(60000000), id 0, size=192.
[    3.112213] xc2028 2-0061: Reading firmware type DTV6 ATSC TOYOTA388 SCODE
HAS_IF_4080 (60410020), id 0, size=192.
[    3.112215] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4200
(60000000), id 0, size=192.
[    3.112217] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_4320
(60008000), id 8000, size=192.
[    3.112218] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4450
(60000000), id 0, size=192.
[    3.112221] xc2028 2-0061: Reading firmware type MTS LCD NOGD MONO IF SCODE
HAS_IF_4500 (6002b004), id b700, size=192.
[    3.112223] xc2028 2-0061: Reading firmware type DTV78 DTV8 ZARLINK456 SCODE
HAS_IF_4560 (62000300), id 0, size=192.
[    3.112225] xc2028 2-0061: Reading firmware type LCD NOGD IF SCODE
HAS_IF_4600 (60023000), id 8000, size=192.
[    3.112227] xc2028 2-0061: Reading firmware type DTV6 QAM DTV7 ZARLINK456
SCODE HAS_IF_4760 (620000e0), id 0, size=192.
[    3.112229] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4940
(60000000), id 0, size=192.
[    3.112231] xc2028 2-0061: Reading firmware type DTV78 DTV8 DIBCOM52 SCODE
HAS_IF_5200 (61000300), id 0, size=192.
[    3.112232] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5260
(60000000), id 0, size=192.
[    3.112234] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_5320
(60008000), id 7, size=192.
[    3.112237] xc2028 2-0061: Reading firmware type DTV7 DTV8 DIBCOM52 CHINA
SCODE HAS_IF_5400 (65000280), id 0, size=192.
[    3.112239] xc2028 2-0061: Reading firmware type DTV6 ATSC OREN538 SCODE
HAS_IF_5580 (60110020), id 0, size=192.
[    3.112240] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5640
(60000000), id 7, size=192.
[    3.112242] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5740
(60000000), id 7, size=192.
[    3.112244] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5900
(60000000), id 0, size=192.
[    3.112245] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_6000
(60008000), id 4c000f0, size=192.
[    3.112248] xc2028 2-0061: Reading firmware type DTV6 QAM ATSC LG60 F6MHZ
SCODE HAS_IF_6200 (68050060), id 0, size=192.
[    3.112250] xc2028 2-0061: Reading firmware type SCODE HAS_IF_6240
(60000000), id 10, size=192.
[    3.112252] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_6320
(60008000), id 200000, size=192.
[    3.112253] xc2028 2-0061: Reading firmware type SCODE HAS_IF_6340
(60000000), id 200000, size=192.
[    3.112255] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_6500
(60008000), id 40000e0, size=192.
[    3.112257] xc2028 2-0061: Reading firmware type DTV6 ATSC ATI638 SCODE
HAS_IF_6580 (60090020), id 0, size=192.
[    3.112259] xc2028 2-0061: Reading firmware type SCODE HAS_IF_6600
(60000000), id e0, size=192.
[    3.112261] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_6680
(60008000), id e0, size=192.
[    3.112263] xc2028 2-0061: Reading firmware type DTV6 ATSC TOYOTA794 SCODE
HAS_IF_8140 (60810020), id 0, size=192.
[    3.112265] xc2028 2-0061: Reading firmware type SCODE HAS_IF_8200
(60000000), id 0, size=192.
[    3.112265] xc2028 2-0061: Firmware files loaded.
[    3.116533] xc2028 2-0061: xc2028_set_analog_freq called
[    3.116535] xc2028 2-0061: generic_set_freq called
[    3.116536] xc2028 2-0061: should set frequency 400000 kHz
[    3.116537] xc2028 2-0061: check_firmware called
[    3.116538] xc2028 2-0061: checking firmware, user requested type=(0), id
0000000c00001000, scode_tbl (0), scode_nr 0
[    3.316553] xc2028 2-0061: load_firmware called
[    3.316555] xc2028 2-0061: seek_firmware called, want type=BASE (1), id
0000000000000000.
[    3.316557] xc2028 2-0061: Found firmware for type=BASE (1), id
0000000000000000.
[    3.316559] xc2028 2-0061: Loading firmware for type=BASE (1), id
0000000000000000.
[    4.532625] xc2028 2-0061: Load init1 firmware, if exists
[    4.532629] xc2028 2-0061: load_firmware called
[    4.532631] xc2028 2-0061: seek_firmware called, want type=BASE INIT1 (4001),
id 0000000000000000.
[    4.532637] xc2028 2-0061: Can't find firmware for type=BASE INIT1 (4001), id
0000000000000000.
[    4.532641] xc2028 2-0061: load_firmware called
[    4.532644] xc2028 2-0061: seek_firmware called, want type=BASE INIT1 (4001),
id 0000000000000000.
[    4.532648] xc2028 2-0061: Can't find firmware for type=BASE INIT1 (4001), id
0000000000000000.
[    4.532652] xc2028 2-0061: load_firmware called
[    4.532654] xc2028 2-0061: seek_firmware called, want type=(0), id
0000000c00001000.
[    4.532658] xc2028 2-0061: Selecting best matching firmware (1 bits) for
type=(0), id 0000000c00001000:
[    4.532661] xc2028 2-0061: Found firmware for type=(0), id 000000000000b700.
[    4.532664] xc2028 2-0061: Loading firmware for type=(0), id
000000000000b700.
[    4.549622] xc2028 2-0061: Trying to load scode 0
[    4.549624] xc2028 2-0061: load_scode called
[    4.549625] xc2028 2-0061: seek_firmware called, want type=SCODE (20000000),
id 000000000000b700.
[    4.549628] xc2028 2-0061: Selecting best matching firmware (1 bits) for
type=SCODE (20000000), id 000000000000b700:
[    4.549630] xc2028 2-0061: Found firmware for type=SCODE (20000000), id
0000000000008000.
[    4.549631] xc2028 2-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320
(60008000), id 0000000000008000.
[    4.553026] xc2028 2-0061: xc2028_get_reg 0004 called
[    4.553586] xc2028 2-0061: xc2028_get_reg 0008 called
[    4.554151] xc2028 2-0061: Device is Xceive 0 version 0.0, firmware version
0.0
[    4.554153] xc2028 2-0061: Incorrect readback of firmware version.
[    4.554340] xc2028 2-0061: Read invalid device hardware information - tuner
hung?
[    4.554541] xc2028 2-0061: 0.d      0.d
[    4.667142] xc2028 2-0061: divisor= 00 00 64 00 (freq=400.000)
root@medeb:~#

05:00.0 0400: 14f1:8852 (rev 02)
    Subsystem: 1461:c139
    Flags: bus master, fast devsel, latency 0, IRQ 18
    Memory at d3000000 (64-bit, non-prefetchable) [size=2M]
    Capabilities: [40] Express Endpoint, MSI 00
    Capabilities: [80] Power Management version 2
    Capabilities: [90] Vital Product Data
    Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
    Capabilities: [100] Advanced Error Reporting
    Capabilities: [200] Virtual Channel
    Kernel driver in use: cx23885

05:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI Video
and Audio Decoder (rev 02)
    Subsystem: Avermedia Technologies Inc Device c139
    Flags: bus master, fast devsel, latency 0, IRQ 18
    Memory at d3000000 (64-bit, non-prefetchable) [size=2M]
    Capabilities: [40] Express Endpoint, MSI 00
    Capabilities: [80] Power Management version 2
    Capabilities: [90] Vital Product Data
    Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
    Capabilities: [100] Advanced Error Reporting
    Capabilities: [200] Virtual Channel
    Kernel driver in use: cx23885


ps: i opened it up a while ago,i saw an af9013 chip ? dvb-tuner looks like 
maybe the "device @ 0x66 i2c"

I will double check , and re-write-down all the chips , i think 3 .


Best regards

PUTHOMME-ESSAISSI Rémi
