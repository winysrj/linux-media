Return-path: <linux-media-owner@vger.kernel.org>
Received: from vint.altlinux.org ([194.107.17.35]:41238 "EHLO
	vint.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab0ADLna (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jan 2010 06:43:30 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vint.altlinux.org (Postfix) with ESMTP id F1A0C3F80034
	for <linux-media@vger.kernel.org>; Mon,  4 Jan 2010 11:43:27 +0000 (UTC)
To: linux-media@vger.kernel.org
Subject: Re: cx18: Need information on SECAM-D/K problem with PVR-2100
References: <1262574635.5963.40.camel@localhost>
From: Sergey Bolshakov <sbolshakov@altlinux.ru>
Date: Mon, 04 Jan 2010 14:40:47 +0300
In-Reply-To: <1262574635.5963.40.camel@localhost> (Andy Walls's message of "Sun, 03 Jan 2010 22:10:35 -0500")
Message-ID: <m34on2ayio.fsf@hammer.lioka.obninsk.ru>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=

>>>>> "Andy" == Andy Walls <awalls@radix.net> writes:

 > Sergey,
 > On IRC you mentioned a problem of improper detection of SECAM-D/K with
 > the Leadtek PVR2100 (XC2028 and CX23418) from an RF source.

It was some misunderstanding, i suppose, i do not have problems with
secam, i had improper detection of sound standard (and silence as
result) on pal channels. Later i've found, that fully-specified std
(pal-d instead of just pal) helps, so i can live with that.

Anyway, logs you requested (first STATUS CARD chunk for pal, second
for pal-d):


--=-=-=
Content-Disposition: attachment; filename=dmesg-cx18-pvr2100.log

cx18:  Start initialization, version 1.2.0
cx18-0: Initializing card 0
cx18-0: Autodetected Leadtek WinFast PVR2100 card
cx18 0000:01:07.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
cx18-0: cx23418 revision 01010000 (B)
cx18-0: Experimenters and photos needed for device to work well.
	To help, mail the ivtv-devel list (www.ivtvdriver.org).
IRQ 17/cx18-0: IRQF_DISABLED is not guaranteed on shared IRQs
tuner 1-0061: Setting mode_mask to 0x0e
tuner 1-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)
tuner 1-0061: tuner 0x61: Tuner type absent
tuner 1-0061: Calling set_type_addr for type=71, addr=0xff, mode=0x04, config=0xffffffff
tuner 1-0061: defining GPIO callback
xc2028: Xcv2028/3028 init called!
xc2028 1-0061: creating new instance
xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
tuner 1-0061: type set to Xceive XC3028
tuner 1-0061: cx18 i2c driver #0-1 tuner I2C addr 0xc2 with type 71 used for 0x0e
xc2028 1-0061: xc2028_set_config called
cx18-0: Registered device video0 for encoder MPEG (64 x 32 kB)
cx18-0: Registered device video32 for encoder YUV (16 x 128 kB)
cx18-0: Registered device vbi0 for encoder VBI (20 x 51984 bytes)
cx18-0: Registered device video24 for encoder PCM audio (256 x 4 kB)
cx18-0: Registered device radio0 for encoder radio
cx18-0: Initialized card: Leadtek WinFast PVR2100
cx18:  End initialization
cx18 0000:01:07.0: firmware: requesting v4l-cx23418-cpu.fw
cx18-0: loaded v4l-cx23418-cpu.fw firmware (158332 bytes)
cx18 0000:01:07.0: firmware: requesting v4l-cx23418-apu.fw
cx18-0: loaded v4l-cx23418-apu.fw firmware V00120000 (141200 bytes)
cx18-0: FW version: 0.0.74.0 (Release 2007/03/12)
cx18 0000:01:07.0: firmware: requesting v4l-cx23418-cpu.fw
cx18 0000:01:07.0: firmware: requesting v4l-cx23418-apu.fw
cx18 0000:01:07.0: firmware: requesting v4l-cx23418-dig.fw
cx18-0 843: loaded v4l-cx23418-dig.fw firmware (16382 bytes)
cx18-0 843: verified load of v4l-cx23418-dig.fw firmware (16382 bytes)
tuner 1-0061: switching to v4l2
tuner 1-0061: tv freq set to 400.00
xc2028 1-0061: xc2028_set_analog_freq called
xc2028 1-0061: generic_set_freq called
xc2028 1-0061: should set frequency 400000 kHz
xc2028 1-0061: check_firmware called
xc2028 1-0061: load_all_firmwares called
xc2028 1-0061: Reading firmware xc3028-v27.fw
cx18 0000:01:07.0: firmware: requesting xc3028-v27.fw
xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
xc2028 1-0061: Reading firmware type BASE F8MHZ (3), id 0, size=8718.
xc2028 1-0061: Reading firmware type BASE F8MHZ MTS (7), id 0, size=8712.
xc2028 1-0061: Reading firmware type BASE FM (401), id 0, size=8562.
xc2028 1-0061: Reading firmware type BASE FM INPUT1 (c01), id 0, size=8576.
xc2028 1-0061: Reading firmware type BASE (1), id 0, size=8706.
xc2028 1-0061: Reading firmware type BASE MTS (5), id 0, size=8682.
xc2028 1-0061: Reading firmware type (0), id 100000007, size=161.
xc2028 1-0061: Reading firmware type MTS (4), id 100000007, size=169.
xc2028 1-0061: Reading firmware type (0), id 200000007, size=161.
xc2028 1-0061: Reading firmware type MTS (4), id 200000007, size=169.
xc2028 1-0061: Reading firmware type (0), id 400000007, size=161.
xc2028 1-0061: Reading firmware type MTS (4), id 400000007, size=169.
xc2028 1-0061: Reading firmware type (0), id 800000007, size=161.
xc2028 1-0061: Reading firmware type MTS (4), id 800000007, size=169.
xc2028 1-0061: Reading firmware type (0), id 3000000e0, size=161.
xc2028 1-0061: Reading firmware type MTS (4), id 3000000e0, size=169.
xc2028 1-0061: Reading firmware type (0), id c000000e0, size=161.
xc2028 1-0061: Reading firmware type MTS (4), id c000000e0, size=169.
xc2028 1-0061: Reading firmware type (0), id 200000, size=161.
xc2028 1-0061: Reading firmware type MTS (4), id 200000, size=169.
xc2028 1-0061: Reading firmware type (0), id 4000000, size=161.
xc2028 1-0061: Reading firmware type MTS (4), id 4000000, size=169.
xc2028 1-0061: Reading firmware type D2633 DTV6 ATSC (10030), id 0, size=149.
xc2028 1-0061: Reading firmware type D2620 DTV6 QAM (68), id 0, size=149.
xc2028 1-0061: Reading firmware type D2633 DTV6 QAM (70), id 0, size=149.
xc2028 1-0061: Reading firmware type D2620 DTV7 (88), id 0, size=149.
xc2028 1-0061: Reading firmware type D2633 DTV7 (90), id 0, size=149.
xc2028 1-0061: Reading firmware type D2620 DTV78 (108), id 0, size=149.
xc2028 1-0061: Reading firmware type D2633 DTV78 (110), id 0, size=149.
xc2028 1-0061: Reading firmware type D2620 DTV8 (208), id 0, size=149.
xc2028 1-0061: Reading firmware type D2633 DTV8 (210), id 0, size=149.
xc2028 1-0061: Reading firmware type FM (400), id 0, size=135.
xc2028 1-0061: Reading firmware type (0), id 10, size=161.
xc2028 1-0061: Reading firmware type MTS (4), id 10, size=169.
xc2028 1-0061: Reading firmware type (0), id 1000400000, size=169.
xc2028 1-0061: Reading firmware type (0), id c00400000, size=161.
xc2028 1-0061: Reading firmware type (0), id 800000, size=161.
xc2028 1-0061: Reading firmware type (0), id 8000, size=161.
xc2028 1-0061: Reading firmware type LCD (1000), id 8000, size=161.
xc2028 1-0061: Reading firmware type LCD NOGD (3000), id 8000, size=161.
xc2028 1-0061: Reading firmware type MTS (4), id 8000, size=169.
xc2028 1-0061: Reading firmware type (0), id b700, size=161.
xc2028 1-0061: Reading firmware type LCD (1000), id b700, size=161.
xc2028 1-0061: Reading firmware type LCD NOGD (3000), id b700, size=161.
xc2028 1-0061: Reading firmware type (0), id 2000, size=161.
xc2028 1-0061: Reading firmware type MTS (4), id b700, size=169.
xc2028 1-0061: Reading firmware type MTS LCD (1004), id b700, size=169.
xc2028 1-0061: Reading firmware type MTS LCD NOGD (3004), id b700, size=169.
xc2028 1-0061: Reading firmware type SCODE HAS_IF_3280 (60000000), id 0, size=192.
xc2028 1-0061: Reading firmware type SCODE HAS_IF_3300 (60000000), id 0, size=192.
xc2028 1-0061: Reading firmware type SCODE HAS_IF_3440 (60000000), id 0, size=192.
xc2028 1-0061: Reading firmware type SCODE HAS_IF_3460 (60000000), id 0, size=192.
xc2028 1-0061: Reading firmware type DTV6 ATSC OREN36 SCODE HAS_IF_3800 (60210020), id 0, size=192.
xc2028 1-0061: Reading firmware type SCODE HAS_IF_4000 (60000000), id 0, size=192.
xc2028 1-0061: Reading firmware type DTV6 ATSC TOYOTA388 SCODE HAS_IF_4080 (60410020), id 0, size=192.
xc2028 1-0061: Reading firmware type SCODE HAS_IF_4200 (60000000), id 0, size=192.
xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_4320 (60008000), id 8000, size=192.
xc2028 1-0061: Reading firmware type SCODE HAS_IF_4450 (60000000), id 0, size=192.
xc2028 1-0061: Reading firmware type MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id b700, size=192.
xc2028 1-0061: Reading firmware type LCD NOGD IF SCODE HAS_IF_4600 (60023000), id 8000, size=192.
xc2028 1-0061: Reading firmware type DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0, size=192.
xc2028 1-0061: Reading firmware type SCODE HAS_IF_4940 (60000000), id 0, size=192.
xc2028 1-0061: Reading firmware type SCODE HAS_IF_5260 (60000000), id 0, size=192.
xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_5320 (60008000), id f00000007, size=192.
xc2028 1-0061: Reading firmware type DTV7 DTV78 DTV8 DIBCOM52 CHINA SCODE HAS_IF_5400 (65000380), id 0, size=192.
xc2028 1-0061: Reading firmware type DTV6 ATSC OREN538 SCODE HAS_IF_5580 (60110020), id 0, size=192.
xc2028 1-0061: Reading firmware type SCODE HAS_IF_5640 (60000000), id 300000007, size=192.
xc2028 1-0061: Reading firmware type SCODE HAS_IF_5740 (60000000), id c00000007, size=192.
xc2028 1-0061: Reading firmware type SCODE HAS_IF_5900 (60000000), id 0, size=192.
xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_6000 (60008000), id c04c000f0, size=192.
xc2028 1-0061: Reading firmware type DTV6 QAM ATSC LG60 F6MHZ SCODE HAS_IF_6200 (68050060), id 0, size=192.
xc2028 1-0061: Reading firmware type SCODE HAS_IF_6240 (60000000), id 10, size=192.
xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_6320 (60008000), id 200000, size=192.
xc2028 1-0061: Reading firmware type SCODE HAS_IF_6340 (60000000), id 200000, size=192.
xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_6500 (60008000), id c044000e0, size=192.
xc2028 1-0061: Reading firmware type DTV6 ATSC ATI638 SCODE HAS_IF_6580 (60090020), id 0, size=192.
xc2028 1-0061: Reading firmware type SCODE HAS_IF_6600 (60000000), id 3000000e0, size=192.
xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_6680 (60008000), id 3000000e0, size=192.
xc2028 1-0061: Reading firmware type DTV6 ATSC TOYOTA794 SCODE HAS_IF_8140 (60810020), id 0, size=192.
xc2028 1-0061: Reading firmware type SCODE HAS_IF_8200 (60000000), id 0, size=192.
xc2028 1-0061: Firmware files loaded.
xc2028 1-0061: checking firmware, user requested type=(0), id 0000000000001000, scode_tbl (0), scode_nr 0
xc2028 1-0061: load_firmware called
xc2028 1-0061: seek_firmware called, want type=BASE (1), id 0000000000000000.
xc2028 1-0061: Found firmware for type=BASE (1), id 0000000000000000.
xc2028 1-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 1-0061: Load init1 firmware, if exists
xc2028 1-0061: load_firmware called
xc2028 1-0061: seek_firmware called, want type=BASE INIT1 (4001), id 0000000000000000.
xc2028 1-0061: Can't find firmware for type=BASE INIT1 (4001), id 0000000000000000.
xc2028 1-0061: load_firmware called
xc2028 1-0061: seek_firmware called, want type=BASE INIT1 (4001), id 0000000000000000.
xc2028 1-0061: Can't find firmware for type=BASE INIT1 (4001), id 0000000000000000.
xc2028 1-0061: load_firmware called
xc2028 1-0061: seek_firmware called, want type=(0), id 0000000000001000.
xc2028 1-0061: Found firmware for type=(0), id 000000000000b700.
xc2028 1-0061: Loading firmware for type=(0), id 000000000000b700.
xc2028 1-0061: Trying to load scode 0
xc2028 1-0061: load_scode called
xc2028 1-0061: seek_firmware called, want type=SCODE (20000000), id 000000000000b700.
xc2028 1-0061: Selecting best matching firmware (1 bits) for type=SCODE (20000000), id 000000000000b700:
xc2028 1-0061: Found firmware for type=SCODE (20000000), id 0000000000008000.
xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
xc2028 1-0061: xc2028_get_reg 0004 called
xc2028 1-0061: xc2028_get_reg 0008 called
xc2028 1-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
xc2028 1-0061: divisor= 00 00 64 00 (freq=400.000)
tuner 1-0061: tv freq set to 67.25
xc2028 1-0061: xc2028_set_analog_freq called
xc2028 1-0061: generic_set_freq called
xc2028 1-0061: should set frequency 67250 kHz
xc2028 1-0061: check_firmware called
xc2028 1-0061: checking firmware, user requested type=(0), id 0000000000001000, scode_tbl (0), scode_nr 0
xc2028 1-0061: BASE firmware not changed.
xc2028 1-0061: Std-specific firmware already loaded.
xc2028 1-0061: SCODE firmware already loaded.
xc2028 1-0061: xc2028_get_reg 0004 called
xc2028 1-0061: xc2028_get_reg 0008 called
xc2028 1-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
xc2028 1-0061: divisor= 00 00 10 d0 (freq=67.250)
cx18-0:  file: open encoder MPEG
cx18-0:  file: open encoder MPEG
tuner 1-0061: tv freq set to 67.25
xc2028 1-0061: xc2028_set_analog_freq called
xc2028 1-0061: generic_set_freq called
xc2028 1-0061: should set frequency 67250 kHz
xc2028 1-0061: check_firmware called
xc2028 1-0061: checking firmware, user requested type=F8MHZ (2), id 00000000000000ff, scode_tbl (0), scode_nr 0
xc2028 1-0061: load_firmware called
xc2028 1-0061: seek_firmware called, want type=BASE F8MHZ (3), id 0000000000000000.
xc2028 1-0061: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
xc2028 1-0061: Load init1 firmware, if exists
xc2028 1-0061: load_firmware called
xc2028 1-0061: seek_firmware called, want type=BASE INIT1 F8MHZ (4003), id 0000000000000000.
xc2028 1-0061: Can't find firmware for type=BASE INIT1 F8MHZ (4003), id 0000000000000000.
xc2028 1-0061: load_firmware called
xc2028 1-0061: seek_firmware called, want type=BASE INIT1 (4001), id 0000000000000000.
xc2028 1-0061: Can't find firmware for type=BASE INIT1 (4001), id 0000000000000000.
xc2028 1-0061: load_firmware called
xc2028 1-0061: seek_firmware called, want type=F8MHZ (2), id 00000000000000ff.
xc2028 1-0061: Selecting best matching firmware (3 bits) for type=(0), id 00000000000000ff:
xc2028 1-0061: Found firmware for type=(0), id 0000000100000007.
xc2028 1-0061: Loading firmware for type=(0), id 0000000100000007.
xc2028 1-0061: Trying to load scode 0
xc2028 1-0061: load_scode called
xc2028 1-0061: seek_firmware called, want type=F8MHZ SCODE (20000002), id 0000000100000007.
xc2028 1-0061: Found firmware for type=SCODE (20000000), id 0000000f00000007.
xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_5320 (60008000), id 0000000f00000007.
xc2028 1-0061: xc2028_get_reg 0004 called
xc2028 1-0061: xc2028_get_reg 0008 called
xc2028 1-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
xc2028 1-0061: divisor= 00 00 10 d0 (freq=67.250)
cx18-0:  file: open encoder MPEG
tuner 1-0061: Cmd g_tuner accepted for analog TV
tuner 1-0061: tv freq set to 111.25
xc2028 1-0061: xc2028_set_analog_freq called
xc2028 1-0061: generic_set_freq called
xc2028 1-0061: should set frequency 111250 kHz
xc2028 1-0061: check_firmware called
xc2028 1-0061: checking firmware, user requested type=F8MHZ (2), id 00000000000000ff, scode_tbl (0), scode_nr 0
xc2028 1-0061: BASE firmware not changed.
xc2028 1-0061: Std-specific firmware already loaded.
xc2028 1-0061: SCODE firmware already loaded.
xc2028 1-0061: xc2028_get_reg 0004 called
xc2028 1-0061: xc2028_get_reg 0008 called
xc2028 1-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
xc2028 1-0061: divisor= 00 00 1b d0 (freq=111.250)
cx18-0:  file: open encoder MPEG
tuner 1-0061: Cmd g_tuner accepted for analog TV
tuner 1-0061: Cmd g_tuner accepted for analog TV
tuner 1-0061: Cmd g_tuner accepted for analog TV
tuner 1-0061: Cmd g_tuner accepted for analog TV
tuner 1-0061: Cmd g_tuner accepted for analog TV
tuner 1-0061: Cmd g_tuner accepted for analog TV
tuner 1-0061: Cmd g_tuner accepted for analog TV
tuner 1-0061: Cmd g_tuner accepted for analog TV
tuner 1-0061: Cmd g_tuner accepted for analog TV
tuner 1-0061: Cmd g_tuner accepted for analog TV
tuner 1-0061: Cmd g_tuner accepted for analog TV
tuner 1-0061: Cmd g_tuner accepted for analog TV
tuner 1-0061: Cmd g_tuner accepted for analog TV
tuner 1-0061: Cmd g_tuner accepted for analog TV
tuner 1-0061: Cmd g_tuner accepted for analog TV
tuner 1-0061: Cmd g_tuner accepted for analog TV
tuner 1-0061: Cmd g_tuner accepted for analog TV
tuner 1-0061: Cmd g_tuner accepted for analog TV
cx18-0:  file: open encoder MPEG
cx18-0: =================  START STATUS CARD #0  =================
cx18-0: Version: 1.2.0  Card: Leadtek WinFast PVR2100
cx18-0 843: Video signal:              present
cx18-0 843: Detected format:           PAL-BDGHI
cx18-0 843: Specified standard:        PAL-BDGHI
cx18-0 843: Specified video input:     Composite 2
cx18-0 843: Specified audioclock freq: 48000 Hz
cx18-0 843: Detected audio mode:       mono
cx18-0 843: Detected audio standard:   no detected audio standard
cx18-0 843: Audio muted:               yes
cx18-0 843: Audio microcontroller:     running
cx18-0 843: Configured audio standard: automatic detection
cx18-0 843: Configured audio system:   automatic standard and mode detection
cx18-0 843: Specified audio input:     Tuner (In5)
cx18-0 843: Preferred audio mode:      stereo
cx18-0 843: Selected 65 MHz format:    system DK
cx18-0 843: Selected 45 MHz format:    A2-M
cx18-0 gpio-reset-ctrl: GPIO:  direction 0x00000007, value 0x00000006
tuner 1-0061: Tuner mode:      analog TV
tuner 1-0061: Frequency:       111.25 MHz
tuner 1-0061: Standard:        0x000000ff
cx18-0 gpio-mux: GPIO:  direction 0x00000007, value 0x00000006
cx18-0: Video Input: Tuner 1
cx18-0: Audio Input: Tuner 1
cx18-0: GPIO:  direction 0x00000007, value 0x00000006
cx18-0: Tuner: TV
cx18-0: Stream: MPEG-2 Program Stream
cx18-0: VBI Format: No VBI
cx18-0: Video:  720x576, 25 fps
cx18-0: Video:  MPEG-2, 4x3, Variable Bitrate, 6000000, Peak 8000000
cx18-0: Video:  GOP Size 15, 2 B-Frames, GOP Closure
cx18-0: Audio:  48 kHz, MPEG-1/2 Layer II, 224 kbps, Stereo, No Emphasis, No CRC
cx18-0: Spatial Filter:  Manual, Luma 1D Horizontal, Chroma 1D Horizontal, 0
cx18-0: Temporal Filter: Manual, 8
cx18-0: Median Filter:   Off, Luma [0, 255], Chroma [0, 255]
cx18-0: Status flags: 0x00200001
cx18-0: Stream encoder MPEG: status 0x0000, 0% of 2048 KiB (64 buffers) in use
cx18-0: Stream encoder YUV: status 0x0000, 0% of 2048 KiB (16 buffers) in use
cx18-0: Stream encoder VBI: status 0x0000, 0% of 1015 KiB (20 buffers) in use
cx18-0: Stream encoder PCM audio: status 0x0000, 0% of 1024 KiB (256 buffers) in use
cx18-0: Read MPEG/VBI: 15400960/0 bytes
cx18-0: ==================  END STATUS CARD #0  ==================
cx18-0:  file: open encoder MPEG
tuner 1-0061: tv freq set to 111.25
xc2028 1-0061: xc2028_set_analog_freq called
xc2028 1-0061: generic_set_freq called
xc2028 1-0061: should set frequency 111250 kHz
xc2028 1-0061: check_firmware called
xc2028 1-0061: checking firmware, user requested type=F8MHZ (2), id 00000000000000e0, scode_tbl (0), scode_nr 0
xc2028 1-0061: BASE firmware not changed.
xc2028 1-0061: load_firmware called
xc2028 1-0061: seek_firmware called, want type=F8MHZ (2), id 00000000000000e0.
xc2028 1-0061: Found firmware for type=(0), id 00000003000000e0.
xc2028 1-0061: Loading firmware for type=(0), id 00000003000000e0.
xc2028 1-0061: Trying to load scode 0
xc2028 1-0061: load_scode called
xc2028 1-0061: seek_firmware called, want type=F8MHZ SCODE (20000002), id 00000003000000e0.
xc2028 1-0061: Found firmware for type=SCODE (20000000), id 00000003000000e0.
xc2028 1-0061: Loading SCODE for type=SCODE HAS_IF_6600 (60000000), id 00000003000000e0.
xc2028 1-0061: xc2028_get_reg 0004 called
xc2028 1-0061: xc2028_get_reg 0008 called
xc2028 1-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
xc2028 1-0061: divisor= 00 00 1b d0 (freq=111.250)
cx18-0:  file: open encoder MPEG
tuner 1-0061: Cmd g_tuner accepted for analog TV
tuner 1-0061: Cmd g_tuner accepted for analog TV
tuner 1-0061: Cmd g_tuner accepted for analog TV
cx18-0:  file: open encoder MPEG
cx18-0: =================  START STATUS CARD #0  =================
cx18-0: Version: 1.2.0  Card: Leadtek WinFast PVR2100
cx18-0 843: Video signal:              present
cx18-0 843: Detected format:           PAL-BDGHI
cx18-0 843: Specified standard:        PAL-BDGHI
cx18-0 843: Specified video input:     Composite 2
cx18-0 843: Specified audioclock freq: 48000 Hz
cx18-0 843: Detected audio mode:       mono
cx18-0 843: Detected audio standard:   A2-DK1
cx18-0 843: Audio muted:               no
cx18-0 843: Audio microcontroller:     running
cx18-0 843: Configured audio standard: automatic detection
cx18-0 843: Configured audio system:   automatic standard and mode detection
cx18-0 843: Specified audio input:     Tuner (In5)
cx18-0 843: Preferred audio mode:      stereo
cx18-0 843: Selected 65 MHz format:    system DK
cx18-0 843: Selected 45 MHz format:    A2-M
cx18-0 gpio-reset-ctrl: GPIO:  direction 0x00000007, value 0x00000006
tuner 1-0061: Tuner mode:      analog TV
tuner 1-0061: Frequency:       111.25 MHz
tuner 1-0061: Standard:        0x000000e0
cx18-0 gpio-mux: GPIO:  direction 0x00000007, value 0x00000006
cx18-0: Video Input: Tuner 1
cx18-0: Audio Input: Tuner 1
cx18-0: GPIO:  direction 0x00000007, value 0x00000006
cx18-0: Tuner: TV
cx18-0: Stream: MPEG-2 Program Stream
cx18-0: VBI Format: No VBI
cx18-0: Video:  720x576, 25 fps
cx18-0: Video:  MPEG-2, 4x3, Variable Bitrate, 6000000, Peak 8000000
cx18-0: Video:  GOP Size 15, 2 B-Frames, GOP Closure
cx18-0: Audio:  48 kHz, MPEG-1/2 Layer II, 224 kbps, Stereo, No Emphasis, No CRC
cx18-0: Spatial Filter:  Manual, Luma 1D Horizontal, Chroma 1D Horizontal, 0
cx18-0: Temporal Filter: Manual, 8
cx18-0: Median Filter:   Off, Luma [0, 255], Chroma [0, 255]
cx18-0: Status flags: 0x00200001
cx18-0: Stream encoder MPEG: status 0x0000, 0% of 2048 KiB (64 buffers) in use
cx18-0: Stream encoder YUV: status 0x0000, 0% of 2048 KiB (16 buffers) in use
cx18-0: Stream encoder VBI: status 0x0000, 0% of 1015 KiB (20 buffers) in use
cx18-0: Stream encoder PCM audio: status 0x0000, 0% of 1024 KiB (256 buffers) in use
cx18-0: Read MPEG/VBI: 2424832/0 bytes
cx18-0: ==================  END STATUS CARD #0  ==================

--=-=-=


Thanks.

-- 

--=-=-=--
