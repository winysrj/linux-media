Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m52KfcmI023150
	for <video4linux-list@redhat.com>; Mon, 2 Jun 2008 16:43:59 -0400
Received: from mail9.dslextreme.com (mail9.dslextreme.com [66.51.199.94])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m52KBkiJ002527
	for <video4linux-list@redhat.com>; Mon, 2 Jun 2008 16:11:47 -0400
Message-ID: <484453F7.709@gimpelevich.san-francisco.ca.us>
Date: Mon, 02 Jun 2008 13:11:35 -0700
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
MIME-Version: 1.0
To: Vladimir Komendantsky <komendantsky@gmail.com>
References: <c5bea28d26aa1caa1e85da.20080531171359.qnavryt4@webmail.dslextreme.com>
	<20080531231049.725bf4d2@tux>
	<4fd977fd0806020149ne6221fai7384be4d7ffaa0fd@mail.gmail.com>
In-Reply-To: <4fd977fd0806020149ne6221fai7384be4d7ffaa0fd@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] PowerColor RA330 (Real Angel 330) fixes
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Vladimir Komendantsky wrote:
> Daniel,
> 
> As far as I can see this patch doesn't touch upon cx88-tvaudio.c,
> although this file seems to control audio norm setup and produces
> dmesg output like the one below:
> 
> cx88[0]/0: set_audio_standard_A2 AM-L (status: devel)
> cx88[0]/0: set_audio_standard_NICAM SECAM-L NICAM (status: devel)
> 
> For PAL, the status is "known-good". My signal is SECAM-L and the
> sound was very noisy. For some reason, with firmware v27 I experienced
> somewhat better sound than with v25 (with v25 there was just noise and
> nothing else).
> 
> I attach the dmesg output which I saved a couple of days before this
> patch when I returned the card to the retailer. I exchanged it for a
> bt878-based Hauppage WinTV which works much better under v4l.
> 
> Vladimir

WinTV cards with the bt878 typically have inferior ("tin-box") tuners, 
but v4l support of those tuners is relatively complete. The tuner-xc2028 
driver is something of a work in progress. However, much of the stuff in 
cx88-tvaudio.c is best-guess data, so it's difficult to separate 
problems with SECAM-L in cx88 from general problems in tuner-xc2028 
unless you try a SECAM-L signal on a cx88 card with a different tuner.

I have found that on this card (the one you returned), when the tuner is 
left active while a different vmux is used, the S-Video cable, if 
connected, draws in a ton of RFI from the tuner. This is a bug; the 
tuner should be software-deactivated when not needed.

> ----------------------------
> dmesg:
> 
> cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
> ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKD] -> GSI 10 (level,
> low) -> IRQ 10
> cx88[0]: quirk: PCIPCI_NATOMA -- set TBFX
> cx88[0]: subsystem: 14f1:ea3d, board: PowerColor Real Angel 330
> [card=62,autodetected]
> cx88[0]: TV tuner type 71, Radio tuner type 0
> cx88[0]: i2c register ok
> cx88[0]: i2c scan: found device @ 0x66  [???]
> cx88[0]: i2c scan: found device @ 0xa0  [eeprom]
> cx88[0]: i2c scan: found device @ 0xc2  [tuner (analog/dvb)]
> tuner' 1-0061: Setting mode_mask to 0x0e
> tuner' 1-0061: chip found @ 0xc2 (cx88[0])
> tuner' 1-0061: tuner 0x61: Tuner type absent
> cx88[0]: tuner' i2c attach [addr=0x61,client=(tuner unset)]
> tuner' 1-0061: Calling set_type_addr for type=0, addr=0x00, mode=0x02,
> config=0x00
> tuner' 1-0061: set addr discarded for type -1, mask e. Asked to change
> tuner at addr 0x00, with mask 2
> tuner' 1-0061: Calling set_type_addr for type=71, addr=0x61,
> mode=0x0c, config=0x00
> tuner' 1-0061: defining GPIO callback
> xc2028: Xcv2028/3028 init called!
> xc2028: video_dev =cfcef258
> xc2028: usage count is 1
> xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
> tuner' 1-0061: type set to Xceive XC3028
> tuner' 1-0061: cx88[0] tuner' I2C addr 0xc2 with type 71 used for 0x0e
> cx88[0]: Asking xc2028/3028 to load firmware xc3028-v25.fw
> xc2028 1-0061: xc2028_set_config called
> tuner' 1-0061: Cmd TUNER_SET_STANDBY accepted for analog TV
> input: cx88 IR (PowerColor Real Angel  as /class/input/input3
> cx88[0]/0: found at 0000:00:10.0, rev: 5, irq: 10, latency: 66, mmio: 0x43000000
> cx88[0]/0: registered device video0 [v4l2]
> cx88[0]/0: registered device vbi0
> cx88[0]/0: registered device radio0
> cx88[0]/0: set_audio_standard_BTSC (status: known-good)
> tuner' 1-0061: Cmd VIDIOC_S_STD accepted for analog TV
> tuner' 1-0061: switching to v4l2
> tuner' 1-0061: tv freq set to 400.00
> xc2028 1-0061: xc2028_set_analog_freq called
> xc2028 1-0061: generic_set_freq called
> xc2028 1-0061: should set frequency 400000 kHz
> xc2028 1-0061: check_firmware called
> xc2028 1-0061: load_all_firmwares called
> xc2028 1-0061: Reading firmware xc3028-v25.fw
> cx88 IR (PowerColor Real Angel : unknown key: key=0x3f raw=0x3f down=1
> cx88 IR (PowerColor Real Angel : unknown key: key=0x3f raw=0x3f down=0
> xc2028 1-0061: Loading 80 firmware images from xc3028-v25.fw, type:
> xc2028 firmware, ver 2.7
> xc2028 1-0061: Reading firmware type BASE F8MHZ (3), id 0, size=8718.
> xc2028 1-0061: Reading firmware type BASE F8MHZ MTS (7), id 0, size=8712.
> xc2028 1-0061: Reading firmware type BASE FM (401), id 0, size=8562.
> xc2028 1-0061: Reading firmware type BASE FM INPUT1 (c01), id 0, size=8576.
> xc2028 1-0061: Reading firmware type BASE (1), id 0, size=8706.
> xc2028 1-0061: Reading firmware type BASE MTS (5), id 0, size=8682.
> xc2028 1-0061: Reading firmware type (0), id 100000007, size=161.
> xc2028 1-0061: Reading firmware type MTS (4), id 100000007, size=169.
> xc2028 1-0061: Reading firmware type (0), id 200000007, size=161.
> xc2028 1-0061: Reading firmware type MTS (4), id 200000007, size=169.
> xc2028 1-0061: Reading firmware type (0), id 400000007, size=161.
> xc2028 1-0061: Reading firmware type MTS (4), id 400000007, size=169.
> xc2028 1-0061: Reading firmware type (0), id 800000007, size=161.
> xc2028 1-0061: Reading firmware type MTS (4), id 800000007, size=169.
> xc2028 1-0061: Reading firmware type (0), id 3000000e0, size=161.
> xc2028 1-0061: Reading firmware type MTS (4), id 3000000e0, size=169.
> xc2028 1-0061: Reading firmware type (0), id c000000e0, size=161.
> xc2028 1-0061: Reading firmware type MTS (4), id c000000e0, size=169.
> xc2028 1-0061: Reading firmware type (0), id 200000, size=161.
> xc2028 1-0061: Reading firmware type MTS (4), id 200000, size=169.
> xc2028 1-0061: Reading firmware type (0), id 4000000, size=161.
> xc2028 1-0061: Reading firmware type MTS (4), id 4000000, size=169.
> xc2028 1-0061: Reading firmware type D2633 DTV6 ATSC (10030), id 0, size=149.
> xc2028 1-0061: Reading firmware type D2620 DTV6 QAM (68), id 0, size=149.
> xc2028 1-0061: Reading firmware type D2633 DTV6 QAM (70), id 0, size=149.
> xc2028 1-0061: Reading firmware type D2620 DTV7 (88), id 0, size=149.
> xc2028 1-0061: Reading firmware type D2633 DTV7 (90), id 0, size=149.
> xc2028 1-0061: Reading firmware type D2620 DTV78 (108), id 0, size=149.
> xc2028 1-0061: Reading firmware type D2633 DTV78 (110), id 0, size=149.
> xc2028 1-0061: Reading firmware type D2620 DTV8 (208), id 0, size=149.
> xc2028 1-0061: Reading firmware type D2633 DTV8 (210), id 0, size=149.
> xc2028 1-0061: Reading firmware type FM (400), id 0, size=135.
> xc2028 1-0061: Reading firmware type (0), id 10, size=161.
> xc2028 1-0061: Reading firmware type MTS (4), id 10, size=169.
> xc2028 1-0061: Reading firmware type (0), id 1000400000, size=169.
> xc2028 1-0061: Reading firmware type (0), id c00400000, size=161.
> xc2028 1-0061: Reading firmware type (0), id 800000, size=161.
> xc2028 1-0061: Reading firmware type (0), id 8000, size=161.
> xc2028 1-0061: Reading firmware type LCD (1000), id 8000, size=161.
> xc2028 1-0061: Reading firmware type LCD NOGD (3000), id 8000, size=161.
> xc2028 1-0061: Reading firmware type MTS (4), id 8000, size=169.
> xc2028 1-0061: Reading firmware type (0), id b700, size=161.
> xc2028 1-0061: Reading firmware type LCD (1000), id b700, size=161.
> xc2028 1-0061: Reading firmware type LCD NOGD (3000), id b700, size=161.
> xc2028 1-0061: Reading firmware type (0), id 2000, size=161.
> xc2028 1-0061: Reading firmware type MTS (4), id b700, size=169.
> xc2028 1-0061: Reading firmware type MTS LCD (1004), id b700, size=169.
> xc2028 1-0061: Reading firmware type MTS LCD NOGD (3004), id b700, size=169.
> xc2028 1-0061: Reading firmware type SCODE HAS_IF_3280 (60000000), id
> 0, size=192.
> xc2028 1-0061: Reading firmware type SCODE HAS_IF_3300 (60000000), id
> 0, size=192.
> xc2028 1-0061: Reading firmware type SCODE HAS_IF_3440 (60000000), id
> 0, size=192.
> xc2028 1-0061: Reading firmware type SCODE HAS_IF_3460 (60000000), id
> 0, size=192.
> xc2028 1-0061: Reading firmware type DTV6 ATSC OREN36 SCODE
> HAS_IF_3800 (60210020), id 0, size=192.
> xc2028 1-0061: Reading firmware type SCODE HAS_IF_4000 (60000000), id
> 0, size=192.
> xc2028 1-0061: Reading firmware type DTV6 ATSC TOYOTA388 SCODE
> HAS_IF_4080 (60410020), id 0, size=192.
> xc2028 1-0061: Reading firmware type SCODE HAS_IF_4200 (60000000), id
> 0, size=192.
> xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_4320
> (60008000), id 8000, size=192.
> xc2028 1-0061: Reading firmware type SCODE HAS_IF_4450 (60000000), id
> 0, size=192.
> xc2028 1-0061: Reading firmware type MTS LCD NOGD MONO IF SCODE
> HAS_IF_4500 (6002b004), id b700, size=192.
> xc2028 1-0061: Reading firmware type LCD NOGD IF SCODE HAS_IF_4600
> (60023000), id 8000, size=192.
> xc2028 1-0061: Reading firmware type DTV6 QAM DTV7 DTV78 DTV8
> ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0, size=192.
> xc2028 1-0061: Reading firmware type SCODE HAS_IF_4940 (60000000), id
> 0, size=192.
> xc2028 1-0061: Reading firmware type SCODE HAS_IF_5260 (60000000), id
> 0, size=192.
> xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_5320
> (60008000), id f00000007, size=192.
> xc2028 1-0061: Reading firmware type DTV7 DTV78 DTV8 DIBCOM52 CHINA
> SCODE HAS_IF_5400 (65000380), id 0, size=192.
> xc2028 1-0061: Reading firmware type DTV6 ATSC OREN538 SCODE
> HAS_IF_5580 (60110020), id 0, size=192.
> xc2028 1-0061: Reading firmware type SCODE HAS_IF_5640 (60000000), id
> 300000007, size=192.
> xc2028 1-0061: Reading firmware type SCODE HAS_IF_5740 (60000000), id
> c00000007, size=192.
> xc2028 1-0061: Reading firmware type SCODE HAS_IF_5900 (60000000), id
> 0, size=192.
> xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_6000
> (60008000), id c04c000f0, size=192.
> xc2028 1-0061: Reading firmware type DTV6 QAM ATSC LG60 F6MHZ SCODE
> HAS_IF_6200 (68050060), id 0, size=192.
> xc2028 1-0061: Reading firmware type SCODE HAS_IF_6240 (60000000), id
> 10, size=192.
> xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_6320
> (60008000), id 200000, size=192.
> xc2028 1-0061: Reading firmware type SCODE HAS_IF_6340 (60000000), id
> 200000, size=192.
> xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_6500
> (60008000), id c044000e0, size=192.
> xc2028 1-0061: Reading firmware type DTV6 ATSC ATI638 SCODE
> HAS_IF_6580 (60090020), id 0, size=192.
> xc2028 1-0061: Reading firmware type SCODE HAS_IF_6600 (60000000), id
> 3000000e0, size=192.
> xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_6680
> (60008000), id 3000000e0, size=192.
> xc2028 1-0061: Reading firmware type DTV6 ATSC TOYOTA794 SCODE
> HAS_IF_8140 (60810020), id 0, size=192.
> xc2028 1-0061: Reading firmware type SCODE HAS_IF_8200 (60000000), id
> 0, size=192.
> xc2028 1-0061: Firmware files loaded.
> xc2028 1-0061: checking firmware, user requested type=(0), id
> 0000000000001000, scode_tbl (0), scode_nr 0
> cx88[0]: Calling XC2028/3028 callback
> xc2028 1-0061: load_firmware called
> xc2028 1-0061: seek_firmware called, want type=BASE (1), id 0000000000000000.
> xc2028 1-0061: Found firmware for type=BASE (1), id 0000000000000000.
> xc2028 1-0061: Loading firmware for type=BASE (1), id 0000000000000000.
> cx88[0]: Calling XC2028/3028 callback
> xc2028 1-0061: Load init1 firmware, if exists
> xc2028 1-0061: load_firmware called
> xc2028 1-0061: seek_firmware called, want type=BASE INIT1 (4001), id
> 0000000000000000.
> xc2028 1-0061: Can't find firmware for type=BASE INIT1 (4001), id
> 0000000000000000.
> xc2028 1-0061: load_firmware called
> xc2028 1-0061: seek_firmware called, want type=BASE INIT1 (4001), id
> 0000000000000000.
> xc2028 1-0061: Can't find firmware for type=BASE INIT1 (4001), id
> 0000000000000000.
> xc2028 1-0061: load_firmware called
> xc2028 1-0061: seek_firmware called, want type=(0), id 0000000000001000.
> xc2028 1-0061: Found firmware for type=(0), id 000000000000b700.
> xc2028 1-0061: Loading firmware for type=(0), id 000000000000b700.
> xc2028 1-0061: Trying to load scode 0
> xc2028 1-0061: load_scode called
> xc2028 1-0061: seek_firmware called, want type=SCODE (20000000), id
> 000000000000b700.
> xc2028 1-0061: Selecting best matching firmware (1 bits) for
> type=SCODE (20000000), id 000000000000b700:
> xc2028 1-0061: Found firmware for type=SCODE (20000000), id 0000000000008000.
> xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320
> (60008000), id 0000000000008000.
> xc2028 1-0061: xc2028_get_reg 0004 called
> xc2028 1-0061: xc2028_get_reg 0008 called
> xc2028 1-0061: Device is Xceive 35840 version 2.4, firmware version 0.0
> xc2028 1-0061: Incorrect readback of firmware version.
> xc2028 1-0061: Retrying firmware load
> xc2028 1-0061: checking firmware, user requested type=(0), id
> 0000000000001000, scode_tbl (0), scode_nr 0
> cx88[0]: Calling XC2028/3028 callback
> xc2028 1-0061: load_firmware called
> xc2028 1-0061: seek_firmware called, want type=BASE (1), id 0000000000000000.
> xc2028 1-0061: Found firmware for type=BASE (1), id 0000000000000000.
> xc2028 1-0061: Loading firmware for type=BASE (1), id 0000000000000000.
> cx88[0]: Calling XC2028/3028 callback
> xc2028 1-0061: Load init1 firmware, if exists
> xc2028 1-0061: load_firmware called
> xc2028 1-0061: seek_firmware called, want type=BASE INIT1 (4001), id
> 0000000000000000.
> xc2028 1-0061: Can't find firmware for type=BASE INIT1 (4001), id
> 0000000000000000.
> xc2028 1-0061: load_firmware called
> xc2028 1-0061: seek_firmware called, want type=BASE INIT1 (4001), id
> 0000000000000000.
> xc2028 1-0061: Can't find firmware for type=BASE INIT1 (4001), id
> 0000000000000000.
> xc2028 1-0061: load_firmware called
> xc2028 1-0061: seek_firmware called, want type=(0), id 0000000000001000.
> xc2028 1-0061: Found firmware for type=(0), id 000000000000b700.
> xc2028 1-0061: Loading firmware for type=(0), id 000000000000b700.
> xc2028 1-0061: Trying to load scode 0
> xc2028 1-0061: load_scode called
> xc2028 1-0061: seek_firmware called, want type=SCODE (20000000), id
> 000000000000b700.
> xc2028 1-0061: Selecting best matching firmware (1 bits) for
> type=SCODE (20000000), id 000000000000b700:
> xc2028 1-0061: Found firmware for type=SCODE (20000000), id 0000000000008000.
> xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320
> (60008000), id 0000000000008000.
> xc2028 1-0061: xc2028_get_reg 0004 called
> xc2028 1-0061: xc2028_get_reg 0008 called
> xc2028 1-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
> cx88[0]: Calling XC2028/3028 callback
> xc2028 1-0061: divisor= 00 00 64 00 (freq=400.000)
> cx88[0]/0: set_control id=0x980900(Brightness) ctrl=0x7f, reg=0x310110
> val=0xff (mask 0xff)
> cx88[0]/0: set_control id=0x980901(Contrast) ctrl=0x3f, reg=0x310110
> val=0x3f00 (mask 0xff00)
> cx88[0]/0: set_control id=0x980903(Hue) ctrl=0x7f, reg=0x310118
> val=0xff (mask 0xff)
> cx88[0]/0: set_control id=0x980902(Saturation) ctrl=0x7f, reg=0x310114
> val=0x5a7f (mask 0xffff)
> cx88[0]/0: set_control id=0x98091D(Chroma AGC) ctrl=0x01, reg=0x310104
> val=0x400 (mask 0x400)
> cx88[0]/0: set_control id=0x98091E(Color killer) ctrl=0x01,
> reg=0x310104 val=0x200 (mask 0x200)
> cx88[0]/0: set_control id=0x980909(Mute) ctrl=0x01, reg=0x320594
> val=0x40 (mask 0x40) [shadowed]
> cx88[0]/0: set_control id=0x980905(Volume) ctrl=0x3f, reg=0x320594
> val=0x00 (mask 0x3f) [shadowed]
> cx88[0]/0: set_control id=0x980906(Balance) ctrl=0x40, reg=0x320598
> val=0x00 (mask 0x7f) [shadowed]
> cx88[0]/0: video_mux: 0 [vmux=0,gpio=0xff,0xf35d,0x0,0x0]
> cx88[0]/0: cx88: tvaudio thread started
> ACPI: PCI Interrupt 0000:00:0f.0[A] -> Link [LNKC] -> GSI 11 (level,
> low) -> IRQ 11
> cx88[0]/0: AUD_STATUS: 0xf332 [mono/no pilot] ctl=BTSC_AUTO_STEREO
> cx88[0]/0: open minor=0 radio=0 type=video-cap
> cx88[0]/0: video_mux: 0 [vmux=0,gpio=0xff,0xf35d,0x0,0x0]
> cx88[0]/0: set_audio_standard_A2 AM-L (status: devel)
> cx88[0]/0: set_audio_standard_NICAM SECAM-L NICAM (status: devel)
> cx88[0]/0: start nicam autodetect.
> cx88[0]/0: nicam is not detected.
> cx88[0]/0: set_audio_standard_A2 AM-L (status: devel)
> tuner' 1-0061: tv freq set to 400.00
> xc2028 1-0061: xc2028_set_analog_freq called
> xc2028 1-0061: generic_set_freq called
> xc2028 1-0061: should set frequency 400000 kHz
> xc2028 1-0061: check_firmware called
> xc2028 1-0061: checking firmware, user requested type=F8MHZ (2), id
> 0000000000400000, scode_tbl (0), scode_nr 0
> cx88[0]: Calling XC2028/3028 callback
> xc2028 1-0061: load_firmware called
> xc2028 1-0061: seek_firmware called, want type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 1-0061: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
> xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
> cx88[0]: Calling XC2028/3028 callback
> cx88[0]/0: AUD_STATUS: 0x32 [mono/no pilot] ctl=A2_FORCE_MONO1
> xc2028 1-0061: Load init1 firmware, if exists
> xc2028 1-0061: load_firmware called
> xc2028 1-0061: seek_firmware called, want type=BASE INIT1 F8MHZ
> (4003), id 0000000000000000.
> xc2028 1-0061: Can't find firmware for type=BASE INIT1 F8MHZ (4003),
> id 0000000000000000.
> xc2028 1-0061: load_firmware called
> xc2028 1-0061: seek_firmware called, want type=BASE INIT1 (4001), id
> 0000000000000000.
> xc2028 1-0061: Can't find firmware for type=BASE INIT1 (4001), id
> 0000000000000000.
> xc2028 1-0061: load_firmware called
> xc2028 1-0061: seek_firmware called, want type=F8MHZ (2), id 0000000000400000.
> xc2028 1-0061: Found firmware for type=(0), id 0000001000400000.
> xc2028 1-0061: Loading firmware for type=(0), id 0000001000400000.
> xc2028 1-0061: Trying to load scode 0
> xc2028 1-0061: load_scode called
> xc2028 1-0061: seek_firmware called, want type=F8MHZ SCODE (20000002),
> id 0000001000400000.
> xc2028 1-0061: Selecting best matching firmware (1 bits) for
> type=SCODE (20000000), id 0000001000400000:
> xc2028 1-0061: Found firmware for type=SCODE (20000000), id 0000000c04c000f0.
> xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_6000
> (60008000), id 0000000c04c000f0.
> xc2028 1-0061: xc2028_get_reg 0004 called
> xc2028 1-0061: xc2028_get_reg 0008 called
> xc2028 1-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
> cx88[0]: Calling XC2028/3028 callback
> cx88[0]/0: AUD_STATUS: 0x3a [mono/pilot c2] ctl=A2_FORCE_MONO1
> xc2028 1-0061: divisor= 00 00 64 00 (freq=400.000)
> tuner' 1-0061: tv freq set to 479.25
> xc2028 1-0061: xc2028_set_analog_freq called
> xc2028 1-0061: generic_set_freq called
> xc2028 1-0061: should set frequency 479250 kHz
> xc2028 1-0061: check_firmware called
> xc2028 1-0061: checking firmware, user requested type=F8MHZ (2), id
> 0000000000400000, scode_tbl (0), scode_nr 0
> xc2028 1-0061: BASE firmware not changed.
> xc2028 1-0061: Std-specific firmware already loaded.
> xc2028 1-0061: SCODE firmware already loaded.
> xc2028 1-0061: xc2028_get_reg 0004 called
> xc2028 1-0061: xc2028_get_reg 0008 called
> xc2028 1-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
> cx88[0]: Calling XC2028/3028 callback
> xc2028 1-0061: divisor= 00 00 77 d0 (freq=479.250)
> cx88[0]/0: set_audio_standard_A2 AM-L (status: devel)
> cx88[0]/0: set_audio_standard_NICAM SECAM-L NICAM (status: devel)
> cx88[0]/0: start nicam autodetect.
> cx88[0]/0: nicam is not detected.
> cx88[0]/0: set_audio_standard_A2 AM-L (status: devel)
> tuner' 1-0061: Cmd VIDIOC_G_FREQUENCY accepted for analog TV
> xc2028 1-0061: xc2028_get_frequency called
> tuner' 1-0061: Cmd VIDIOC_G_FREQUENCY accepted for analog TV
> xc2028 1-0061: xc2028_get_frequency called
> cx88[0]/0: set_control id=0x980909(Mute) ctrl=0x00, reg=0x320594
> val=0x00 (mask 0x40) [shadowed]
> cx88[0]/0: set_control id=0x980900(Brightness) ctrl=0x7f, reg=0x310110
> val=0xff (mask 0xff)
> cx88[0]/0: set_control id=0x980903(Hue) ctrl=0x7f, reg=0x310118
> val=0xff (mask 0xff)
> cx88[0]/0: set_control id=0x980902(Saturation) ctrl=0x7f, reg=0x310114
> val=0x7f7f (mask 0xffff)
> cx88[0]/0: set_control id=0x980901(Contrast) ctrl=0x3f, reg=0x310110
> val=0x3f00 (mask 0xff00)
> cx88[0]/0: set_control id=0x980909(Mute) ctrl=0x01, reg=0x320594
> val=0x40 (mask 0x40) [shadowed]
> tuner' 1-0061: Cmd TUNER_SET_STANDBY accepted for analog TV
> cx88[0]/0: AUD_STATUS: 0x32 [mono/no pilot] ctl=A2_FORCE_MONO1
> cx88[0]/0: AUD_STATUS: 0x3a [mono/pilot c2] ctl=A2_FORCE_MONO1
> cx88[0]/0: AUD_STATUS: 0x32 [mono/no pilot] ctl=A2_FORCE_MONO1
> cx88[0]/0: AUD_STATUS: 0x3a [mono/pilot c2] ctl=A2_FORCE_MONO1
> cx88[0]/0: AUD_STATUS: 0x32 [mono/no pilot] ctl=A2_FORCE_MONO1

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
