Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:49736 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3HTTbw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 15:31:52 -0400
Date: Tue, 20 Aug 2013 21:31:43 +0200 (CEST)
From: remi <remi@remis.cc>
Reply-To: remi <remi@remis.cc>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Message-ID: <945611328.103225.1377027103612.open-xchange@email.1and1.fr>
In-Reply-To: <1970131979.98476.1377009869066.open-xchange@email.1and1.fr>
References: <641271032.80124.1376921926586.open-xchange@email.1and1.fr> <52123758.4090007@iki.fi> <408826654.91086.1376994751713.open-xchange@email.1and1.fr> <1970131979.98476.1377009869066.open-xchange@email.1and1.fr>
Subject: Re: avermedia A306 / PCIe-minicard (laptop)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

Seeing that card=39 worked, and, that the A306 doesnt use the LowPower version
of the XC3028 , HC81 is an expressCard == lowpower

A306 is the PCIe minicard version == not LowPower ,


I decided to clone the HC81 entries in cx23885-video.c, cx23885.h ,
cx23885-cards.c

And intruct it to load then the xc3028-v27.fw instead,

Seems to me alot better , see below ,

And I added so, the card=40 in the definitions ...

I dont think submiting a patch for this woth it yet ...

as none of the tuners get "created" ,

For the analog video composite/s-video, i'll be able to test it when i find the
right cable .



root@medeb:~/v4l/media_build/v4l# grep A306 *
cx23885-cards.c:        [CX23885_BOARD_AVERMEDIA_A306] = {
cx23885-cards.c:                .name           = "AVerTV Hybrid Minicard PCIe
A306",
cx23885-cards.c:                .card      = CX23885_BOARD_AVERMEDIA_A306,
cx23885-cards.c:        case CX23885_BOARD_AVERMEDIA_A306:
cx23885-cards.c:        case CX23885_BOARD_AVERMEDIA_A306:
cx23885-cards.c:        case CX23885_BOARD_AVERMEDIA_A306:
cx23885-cards.c:        case CX23885_BOARD_AVERMEDIA_A306:
cx23885.h:#define CX23885_BOARD_AVERMEDIA_A306          40
cx23885-video.c:                (dev->board == CX23885_BOARD_AVERMEDIA_A306)) {
cx23885-video.c:                        if (dev->board ==
CX23885_BOARD_AVERMEDIA_A306) {




                        if (dev->board == CX23885_BOARD_AVERMEDIA_HC81R) {
                                struct xc2028_ctrl ctrl = {
                                        .fname = "xc3028L-v36.fw",
                                        .max_len = 64
                                };
                                struct v4l2_priv_tun_config cfg = {
                                        .tuner = dev->tuner_type,
                                        .priv = &ctrl
                                };
                                v4l2_subdev_call(sd, tuner, s_config, &cfg);
                        }
                        if (dev->board == CX23885_BOARD_AVERMEDIA_A306) {
                                struct xc2028_ctrl ctrl = {
                                     /* .fname = "xc3028L-v36.fw", */
                                        .fname = "xc3028-v27.fw",
                                        .max_len = 64
                                };
                                struct v4l2_priv_tun_config cfg = {
                                        .tuner = dev->tuner_type,
                                        .priv = &ctrl
                                };
                                v4l2_subdev_call(sd, tuner, s_config, &cfg);
                        }



[32653.087693] cx23885 driver version 0.0.3 loaded
[32653.088091] CORE cx23885[0]: subsystem: 1461:c139, board: AVerTV Hybrid
Minicard PCIe A306 [card=40,autodetected]
[32653.318339] cx23885[0]: scan bus 0:
[32653.329792] cx23885[0]: i2c scan: found device @ 0xa0  [eeprom]
[32653.336716] cx23885[0]: scan bus 1:
[32653.350543] cx23885[0]: i2c scan: found device @ 0xc2 
[tuner/mt2131/tda8275/xc5000/xc3028]
[32653.355042] cx23885[0]: scan bus 2:
[32653.357050] cx23885[0]: i2c scan: found device @ 0x66  [???]
[32653.357699] cx23885[0]: i2c scan: found device @ 0x88  [cx25837]
[32653.358011] cx23885[0]: i2c scan: found device @ 0x98  [flatiron]
[32653.391211] cx25840 3-0044: cx23885 A/V decoder found @ 0x88 (cx23885[0])
[32654.031992] cx25840 3-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382
bytes)
[32654.049675] tuner 2-0061: Tuner -1 found with type(s) Radio TV.
[32654.051827] xc2028: Xcv2028/3028 init called!
[32654.051830] xc2028 2-0061: creating new instance
[32654.051832] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
[32654.051834] xc2028 2-0061: xc2028_set_config called
[32654.051963] cx23885[0]: registered device video0 [v4l2]
[32654.052165] cx23885[0]: registered device vbi0
[32654.052329] cx23885[0]: registered ALSA audio device
[32654.052593] xc2028 2-0061: request_firmware_nowait(): OK
[32654.052596] xc2028 2-0061: load_all_firmwares called
[32654.052598] xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw,
type: xc2028 firmware, ver 2.7
[32654.052606] xc2028 2-0061: Reading firmware type BASE F8MHZ (3), id 0,
size=8718.
[32654.052614] xc2028 2-0061: Reading firmware type BASE F8MHZ MTS (7), id 0,
size=8712.
[32654.052623] xc2028 2-0061: Reading firmware type BASE FM (401), id 0,
size=8562.
[32654.052631] xc2028 2-0061: Reading firmware type BASE FM INPUT1 (c01), id 0,
size=8576.
[32654.052640] xc2028 2-0061: Reading firmware type BASE (1), id 0, size=8706.
[32654.052647] xc2028 2-0061: Reading firmware type BASE MTS (5), id 0,
size=8682.
[32654.052652] xc2028 2-0061: Reading firmware type (0), id 100000007, size=161.
[32654.052654] xc2028 2-0061: Reading firmware type MTS (4), id 100000007,
size=169.
[32654.052657] xc2028 2-0061: Reading firmware type (0), id 200000007, size=161.
[32654.052659] xc2028 2-0061: Reading firmware type MTS (4), id 200000007,
size=169.
[32654.052661] xc2028 2-0061: Reading firmware type (0), id 400000007, size=161.
[32654.052663] xc2028 2-0061: Reading firmware type MTS (4), id 400000007,
size=169.
[32654.052666] xc2028 2-0061: Reading firmware type (0), id 800000007, size=161.
[32654.052668] xc2028 2-0061: Reading firmware type MTS (4), id 800000007,
size=169.
[32654.052670] xc2028 2-0061: Reading firmware type (0), id 3000000e0, size=161.
[32654.052672] xc2028 2-0061: Reading firmware type MTS (4), id 3000000e0,
size=169.
[32654.052675] xc2028 2-0061: Reading firmware type (0), id c000000e0, size=161.
[32654.052677] xc2028 2-0061: Reading firmware type MTS (4), id c000000e0,
size=169.
[32654.052679] xc2028 2-0061: Reading firmware type (0), id 200000, size=161.
[32654.052681] xc2028 2-0061: Reading firmware type MTS (4), id 200000,
size=169.
[32654.052684] xc2028 2-0061: Reading firmware type (0), id 4000000, size=161.
[32654.052686] xc2028 2-0061: Reading firmware type MTS (4), id 4000000,
size=169.
[32654.052688] xc2028 2-0061: Reading firmware type D2633 DTV6 ATSC (10030), id
0, size=149.
[32654.052691] xc2028 2-0061: Reading firmware type D2620 DTV6 QAM (68), id 0,
size=149.
[32654.052694] xc2028 2-0061: Reading firmware type D2633 DTV6 QAM (70), id 0,
size=149.
[32654.052698] xc2028 2-0061: Reading firmware type D2620 DTV7 (88), id 0,
size=149.
[32654.052700] xc2028 2-0061: Reading firmware type D2633 DTV7 (90), id 0,
size=149.
[32654.052703] xc2028 2-0061: Reading firmware type D2620 DTV78 (108), id 0,
size=149.
[32654.052706] xc2028 2-0061: Reading firmware type D2633 DTV78 (110), id 0,
size=149.
[32654.052708] xc2028 2-0061: Reading firmware type D2620 DTV8 (208), id 0,
size=149.
[32654.052711] xc2028 2-0061: Reading firmware type D2633 DTV8 (210), id 0,
size=149.
[32654.052714] xc2028 2-0061: Reading firmware type FM (400), id 0, size=135.
[32654.052716] xc2028 2-0061: Reading firmware type (0), id 10, size=161.
[32654.052718] xc2028 2-0061: Reading firmware type MTS (4), id 10, size=169.
[32654.052721] xc2028 2-0061: Reading firmware type (0), id 1000400000,
size=169.
[32654.052723] xc2028 2-0061: Reading firmware type (0), id c00400000, size=161.
[32654.052725] xc2028 2-0061: Reading firmware type (0), id 800000, size=161.
[32654.052727] xc2028 2-0061: Reading firmware type (0), id 8000, size=161.
[32654.052729] xc2028 2-0061: Reading firmware type LCD (1000), id 8000,
size=161.
[32654.052732] xc2028 2-0061: Reading firmware type LCD NOGD (3000), id 8000,
size=161.
[32654.052734] xc2028 2-0061: Reading firmware type MTS (4), id 8000, size=169.
[32654.052737] xc2028 2-0061: Reading firmware type (0), id b700, size=161.
[32654.052739] xc2028 2-0061: Reading firmware type LCD (1000), id b700,
size=161.
[32654.052741] xc2028 2-0061: Reading firmware type LCD NOGD (3000), id b700,
size=161.
[32654.052744] xc2028 2-0061: Reading firmware type (0), id 2000, size=161.
[32654.052745] xc2028 2-0061: Reading firmware type MTS (4), id b700, size=169.
[32654.052748] xc2028 2-0061: Reading firmware type MTS LCD (1004), id b700,
size=169.
[32654.052750] xc2028 2-0061: Reading firmware type MTS LCD NOGD (3004), id
b700, size=169.
[32654.052753] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3280
(60000000), id 0, size=192.
[32654.052756] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3300
(60000000), id 0, size=192.
[32654.052759] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3440
(60000000), id 0, size=192.
[32654.052762] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3460
(60000000), id 0, size=192.
[32654.052765] xc2028 2-0061: Reading firmware type DTV6 ATSC OREN36 SCODE
HAS_IF_3800 (60210020), id 0, size=192.
[32654.052768] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4000
(60000000), id 0, size=192.
[32654.052771] xc2028 2-0061: Reading firmware type DTV6 ATSC TOYOTA388 SCODE
HAS_IF_4080 (60410020), id 0, size=192.
[32654.052775] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4200
(60000000), id 0, size=192.
[32654.052778] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_4320
(60008000), id 8000, size=192.
[32654.052781] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4450
(60000000), id 0, size=192.
[32654.052783] xc2028 2-0061: Reading firmware type MTS LCD NOGD MONO IF SCODE
HAS_IF_4500 (6002b004), id b700, size=192.
[32654.052788] xc2028 2-0061: Reading firmware type LCD NOGD IF SCODE
HAS_IF_4600 (60023000), id 8000, size=192.
[32654.052792] xc2028 2-0061: Reading firmware type DTV6 QAM DTV7 DTV78 DTV8
ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0, size=192.
[32654.052796] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4940
(60000000), id 0, size=192.
[32654.052799] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5260
(60000000), id 0, size=192.
[32654.052802] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_5320
(60008000), id f00000007, size=192.
[32654.052805] xc2028 2-0061: Reading firmware type DTV7 DTV78 DTV8 DIBCOM52
CHINA SCODE HAS_IF_5400 (65000380), id 0, size=192.
[32654.052809] xc2028 2-0061: Reading firmware type DTV6 ATSC OREN538 SCODE
HAS_IF_5580 (60110020), id 0, size=192.
[32654.052813] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5640
(60000000), id 300000007, size=192.
[32654.052816] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5740
(60000000), id c00000007, size=192.
[32654.052819] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5900
(60000000), id 0, size=192.
[32654.052822] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_6000
(60008000), id c04c000f0, size=192.
[32654.052825] xc2028 2-0061: Reading firmware type DTV6 QAM ATSC LG60 F6MHZ
SCODE HAS_IF_6200 (68050060), id 0, size=192.
[32654.052829] xc2028 2-0061: Reading firmware type SCODE HAS_IF_6240
(60000000), id 10, size=192.
[32654.052834] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_6320
(60008000), id 200000, size=192.
[32654.052837] xc2028 2-0061: Reading firmware type SCODE HAS_IF_6340
(60000000), id 200000, size=192.
[32654.052840] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_6500
(60008000), id c044000e0, size=192.
[32654.052843] xc2028 2-0061: Reading firmware type DTV6 ATSC ATI638 SCODE
HAS_IF_6580 (60090020), id 0, size=192.
[32654.052847] xc2028 2-0061: Reading firmware type SCODE HAS_IF_6600
(60000000), id 3000000e0, size=192.
[32654.052850] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_6680
(60008000), id 3000000e0, size=192.
[32654.052853] xc2028 2-0061: Reading firmware type DTV6 ATSC TOYOTA794 SCODE
HAS_IF_8140 (60810020), id 0, size=192.
[32654.052857] xc2028 2-0061: Reading firmware type SCODE HAS_IF_8200
(60000000), id 0, size=192.
[32654.052860] xc2028 2-0061: Firmware files loaded.
[32654.057869] xc2028 2-0061: xc2028_set_analog_freq called
[32654.057872] xc2028 2-0061: generic_set_freq called
[32654.057874] xc2028 2-0061: should set frequency 400000 kHz
[32654.057876] xc2028 2-0061: check_firmware called
[32654.057877] xc2028 2-0061: checking firmware, user requested type=(0), id
0000000c00001000, scode_tbl (0), scode_nr 0
[32654.257895] xc2028 2-0061: load_firmware called
[32654.257898] xc2028 2-0061: seek_firmware called, want type=BASE (1), id
0000000000000000.
[32654.257900] xc2028 2-0061: Found firmware for type=BASE (1), id
0000000000000000.
[32654.257902] xc2028 2-0061: Loading firmware for type=BASE (1), id
0000000000000000.
[32655.425394] xc2028 2-0061: Load init1 firmware, if exists
[32655.425399] xc2028 2-0061: load_firmware called
[32655.425402] xc2028 2-0061: seek_firmware called, want type=BASE INIT1 (4001),
id 0000000000000000.
[32655.425407] xc2028 2-0061: Can't find firmware for type=BASE INIT1 (4001), id
0000000000000000.
[32655.425412] xc2028 2-0061: load_firmware called
[32655.425414] xc2028 2-0061: seek_firmware called, want type=BASE INIT1 (4001),
id 0000000000000000.
[32655.425418] xc2028 2-0061: Can't find firmware for type=BASE INIT1 (4001), id
0000000000000000.
[32655.425423] xc2028 2-0061: load_firmware called
[32655.425425] xc2028 2-0061: seek_firmware called, want type=(0), id
0000000c00001000.
[32655.425429] xc2028 2-0061: Selecting best matching firmware (2 bits) for
type=(0), id 0000000c00001000:
[32655.425432] xc2028 2-0061: Found firmware for type=(0), id 0000000c000000e0.
[32655.425435] xc2028 2-0061: Loading firmware for type=(0), id
0000000c000000e0.
[32655.440874] xc2028 2-0061: Trying to load scode 0
[32655.440875] xc2028 2-0061: load_scode called
[32655.440877] xc2028 2-0061: seek_firmware called, want type=SCODE (20000000),
id 0000000c000000e0.
[32655.440879] xc2028 2-0061: Found firmware for type=SCODE (20000000), id
0000000c04c000f0.
[32655.440881] xc2028 2-0061: Loading SCODE for type=MONO SCODE HAS_IF_6000
(60008000), id 0000000c04c000f0.
[32655.443192] xc2028 2-0061: xc2028_get_reg 0004 called
[32655.443855] xc2028 2-0061: xc2028_get_reg 0008 called
[32655.444521] xc2028 2-0061: Device is Xceive 3028 version 1.0, firmware
version 2.7
[32655.557141] xc2028 2-0061: divisor= 00 00 64 00 (freq=400.000)
[32655.580856] cx23885_dev_checkrevision() Hardware revision = 0xb0
[32655.580862] cx23885[0]/0: found at 0000:05:00.0, rev: 2, irq: 18, latency: 0,
mmio: 0xd3000000
root@medeb:~/v4l/media_build#



Best regards

Rémi .


> Le 20 août 2013 à 16:44, remi <remi@remis.cc> a écrit :
>
>
> Hello
>
> FYI
>
> I digged into the firmware problem a little,
>
>
> xc3028L-v36.fw  gets loaded by default , and the errors are as you saw earlier
>
>
> forcing the /lib/firmware/xc3028-v27.fw : 
>
> [ 3569.941404] xc2028 2-0061: Could not load firmware
> /lib/firmware/xc3028-v27.fw
>
>
> So i searched the original dell/windows driver :
>
>
> I have these files in there :
>
> root@medeb:/home/gpunk/.wine/drive_c/dell/drivers/R169070# ls -lR
> .:
> total 5468
> drwxr-xr-x 2 gpunk gpunk    4096 août  20 13:24 Driver_X86
> -rwxr-xr-x 1 gpunk gpunk 5589827 sept. 12  2007 Setup.exe
> -rw-r--r-- 1 gpunk gpunk     197 oct.   9  2007 setup.iss
>
> ./Driver_X86:
> total 1448
> -rw-r--r-- 1 gpunk gpunk 114338 sept.  7  2007 A885VCap_ASUS_DELL_2.inf
> -rw-r--r-- 1 gpunk gpunk  15850 sept. 11  2007 a885vcap.cat
> -rw-r--r-- 1 gpunk gpunk 733824 sept.  7  2007 A885VCap.sys
> -rw-r--r-- 1 gpunk gpunk 147870 avril 20  2007 cpnotify.ax
> -rw-r--r-- 1 gpunk gpunk 376836 avril 20  2007 cx416enc.rom
> -rw-r--r-- 1 gpunk gpunk  65536 avril 20  2007 cxtvrate.dll
> -rw-r--r-- 1 gpunk gpunk  16382 avril 20  2007 merlinC.rom
> root@medeb:/home/gpunk/.wine/drive_c/dell/drivers/R169070#
>
> root@medeb:/home/gpunk/.wine/drive_c/dell/drivers/R169070/Driver_X86# grep
> firmware *
> Fichier binaire A885VCap.sys concordant
> root@medeb:/home/gpunk/.wine/drive_c/dell/drivers/R169070/Driver_X86#
>
>
>
> I'll try to find a way to extract "maybe" the right firmware for what this
> card
> ,
>
> I'd love some help :)
>
> Good news there are ALOT of infos on how to initialize the card in the .INF ,
> so
>
> many problems, i think, are partially solved (I need to implement them )
>
> I'll send a copy of theses to anyone who wishes,
>
> Or see
> http://www.dell.com/support/drivers/us/en/04/DriverDetails?driverId=R169070   
>  
>  :)
>
> Regards
>
> Rémi
>
>
>
>
>
> > Le 20 août 2013 à 12:32, remi <remi@remis.cc> a écrit :
> >
> >
> > Hello
> >
> > I have just putdown my screwdrivers :)
> >
> >
> > Yes it was three ICs
> >
> >
> > on the bottom-side , no heatsinks (digital reception, that's why i guess) ,
> > is
> > an AF9013-N1
> >
> > on the top-side, with a heatsink : CX23885-13Z , PCIe A/V controler
> >
> > on the top-side, with heat-sink + "radio-isolation" (aluminum box) XC3028ACQ
> > ,
> > so the analog reception .
> >
> >  
> > Its all on a PCIe bus, the reason why i baught it ... :)
> >
> >
> >
> > To resume :
> >
> >
> > AF9013-N1
> >
> > CX23885-13Z
> >
> > XC3028ACQ
> >
> >
> > the drivers while scanning
> >
> >
> > gpunk@medeb:~/Bureau$ dmesg |grep i2c
> > [    2.363784] cx23885[0]: i2c scan: found device @ 0xa0  [eeprom]
> > [    2.384721] cx23885[0]: i2c scan: found device @ 0xc2 
> > [tuner/mt2131/tda8275/xc5000/xc3028]
> > [    2.391502] cx23885[0]: i2c scan: found device @ 0x66  [???]
> > [    2.392339] cx23885[0]: i2c scan: found device @ 0x88  [cx25837]
> > [    2.392831] cx23885[0]: i2c scan: found device @ 0x98  [flatiron]
> > [    5.306751] i2c /dev entries driver
> > gpunk@medeb:~/Bureau$
> >
> >
> >  4.560428] xc2028 2-0061: xc2028_get_reg 0008 called
> > [    4.560989] xc2028 2-0061: Device is Xceive 0 version 0.0, firmware
> > version
> > 0.0
> > [    4.560990] xc2028 2-0061: Incorrect readback of firmware version.
> > [ *    4.561184] xc2028 2-0061: Read invalid device hardware information -
> > tuner
> > hung?
> > [ *    4.561386] xc2028 2-0061: 0.0      0.0
> > [ *    4.674072] xc2028 2-0061: divisor= 00 00 64 00 (freq=400.000)
> > [    4.697830] cx23885_dev_checkrevision() Hardware revision = 0xb0
> > [    4.698029] cx23885[0]/0: found at 0000:05:00.0, rev: 2, irq: 18,
> > latency:
> > 0,
> > mmio: 0xd3000000
> >
> > * --> I bypassed the "goto fail" to start debugging a little bit the
> > tuner-xc2028.c/ko ... lines 869
> > ...
> >
> >
> >
> > The firmware doesnt get all loaded .
> > gpunk@medeb:~/Bureau$  uname -a
> > Linux medeb 3.11.0-rc6remi #1 SMP PREEMPT Mon Aug 19 13:30:04 CEST 2013 i686
> > GNU/Linux
> > gpunk@medeb:~/Bureau$
> >
> >
> > With yesterday's tarball from linuxtv.org / media-build git .
> >
> >
> >
> > Best regards
> >
> > Rémi
> >
> >
> >
> >
> > > Le 19 août 2013 à 17:18, Antti Palosaari <crope@iki.fi> a écrit :
> > >
> > >
> > > On 08/19/2013 05:18 PM, remi wrote:
> > > > Hello
> > > >
> > > > I have this card since months,
> > > >
> > > > http://www.avermedia.com/avertv/Product/ProductDetail.aspx?Id=376&SI=true
> > > >
> > > > I have finally retested it with the cx23885 driver : card=39
> > > >
> > > >
> > > >
> > > > If I could do anything to identify : [    2.414734] cx23885[0]: i2c
> > > > scan:
> > > > found
> > > > device @ 0x66  [???]
> > > >
> > > > Or "hookup" the xc5000 etc
> > > >
> > > > I'll be more than glad .
> > > >
> > >
> > >
> > > >
> > > > ps: i opened it up a while ago,i saw an af9013 chip ? dvb-tuner looks
> > > > like
> > > > maybe the "device @ 0x66 i2c"
> > > >
> > > > I will double check , and re-write-down all the chips , i think 3 .
> > >
> > > You have to identify all the chips, for DVB-T there is tuner missing.
> > >
> > > USB-interface: cx23885
> > > DVB-T demodulator: AF9013
> > > RF-tuner: ?
> > >
> > > If there is existing driver for used RF-tuner it comes nice hacking
> > > project for some newcomer.
> > >
> > > It is just tweaking and hacking to find out all settings. AF9013 driver
> > > also needs likely some changes, currently it is used only for devices
> > > having AF9015 with integrated AF9013, or AF9015 dual devices having
> > > AF9015 + external AF9013 providing second tuner.
> > >
> > > I have bought quite similar AverMedia A301 ages back as I was looking
> > > for that AF9013 model, but maybe I have bought just wrong one... :)
> > >
> > >
> > > regards
> > > Antti
> > >
> > >
> > > --
> > > http://palosaari.fi/
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
