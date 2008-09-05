Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 203.161.84.42.static.amnet.net.au ([203.161.84.42]
	helo=goeng.com.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tom@goeng.com.au>) id 1KbSl8-00058A-Kh
	for linux-dvb@linuxtv.org; Fri, 05 Sep 2008 06:17:26 +0200
From: "Thomas Goerke" <tom@goeng.com.au>
To: stev391@email.com, "'jackden'" <jackden@gmail.com>
References: <20080904232657.E73D747808F@ws1-5.us4.outblaze.com>
In-Reply-To: <20080904232657.E73D747808F@ws1-5.us4.outblaze.com>
Date: Fri, 5 Sep 2008 12:17:52 +0800
Message-ID: <007a01c90f0e$5fca1dd0$1f5e5970$@com.au>
MIME-Version: 1.0
Content-Language: en-au
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog
	TV/FM capture card
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

> ---Snip---
> 
> 
> Tom,
> 
> Attached is another patch,  this will break the support for your card,
> but proves that the cx25840 module is required for the DVB-T side of
> this card.  So before applying the patch make sure you have a copy of
> the working patch handy (or even two copies of the source tree).
> 
> Follow the same steps I had for the v0.1 patch, but use the attached
> (v0.2) patch.  The symptons will be the same as the original patch,
> i.e. no errors in dmesg, but unable to scam/tune.
> 
> Also can you please look at the other IC's on the board and see if you
> identify them for me.
> I'm looking for an eeprom or similiar IC, as I will need to distinguish
> between the various different boards.  Also if you can get a dump of
> what is on the eeprom and provide it (or put it on the wiki page, or
> both).  I'm not sure how to do this safely yet, so if you have time
> google is your friend (i2cdump might to the trick).
> 
> Thanks,
> Stephen
> 
> 
> --
> Be Yourself @ mail.com!
> Choose From 200+ Email Addresses
> Get a Free Account at www.mail.com
Stephen,

OK..some interesting feedback.  Your patch works, but only after a cold
reset.   I initially double checked I had applied the correct patch i.e.
	hg clone http://linuxtv.org/hg/v4l-dvb
	cd v4l-dvb
	make
	patch -p1 < ../patch/Compro_VideoMate_E650_V0.2.patch
	make
	sudo make install

and it seems that I did ;-).  

After a warm reboot the card does not work.  See below for outputs from both
dmesg.  You will notice that for the second one (fail condition) the kernel
ring buffer has been filled and seems to have wiped out the initial
messages.

In terms of the ic descriptions these are the chips on the board (I will
update the wiki):
	CX23885-132					- AV Decoder
	CX23417-11Z					- MPEG 2 Encoder
	ZL10353 0619T S				- Demodulator
	ETRONTECH EM638325ts-6G			- 2M x 32 bit Synchronous
DRAM (SDRAM)
	XCEIVE  XC3008ACQ AK50113.2		- Video Tuner
	ELAN EM78P156ELMH-G			- 8 bit microprocessor
	HT24LC02					- 2K 2-Wire CMOS
Serial EEPROM
	IDT QS3257					- High-Speed CMOS
QuickSwitch Quad 2:1 Mux/Demux
	1509						- PWM Buck DC/DC
Converter??

With regard to reading the eeprom, I don't have time at the moment to search
but will look into it if someone can provide somepointers.

Tom


Dmesg output - Cold start (working condition)
--
[   36.726340] Linux video capture interface: v2.00
[   36.744397] cx23885 driver version 0.0.1 loaded
[   36.744438] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) ->
IRQ 16
[   36.744441] cx23885[0]/0: cx23885_dev_setup() Memory configured for PCIe
bridge type 885
[   36.744443] cx23885[0]/0: cx23885_init_tsport(portno=2)
[   36.744450] CORE cx23885[0]: subsystem: 185b:e800, board: Compro
VideoMate E650 [card=13,autodetected]
[   36.744451] cx23885[0]/0: cx23885_pci_quirks()
[   36.744455] cx23885[0]/0: cx23885_dev_setup() tuner_type = 0x0 tuner_addr
= 0x0
[   36.744456] cx23885[0]/0: cx23885_dev_setup() radio_type = 0x0 radio_addr
= 0x0
[   36.744457] cx23885[0]/0: cx23885_reset()
[   36.843668] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
channel [VID A]
[   36.843679] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch2]
[   36.843680] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
channel [TS1 B]
[   36.843693] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch4]
[   36.843694] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch5]
[   36.843696] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
channel [TS2 C]
[   36.843709] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch7]
[   36.843710] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch8]
[   36.843712] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch9]
[   36.883470] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) ->
IRQ 22
[   36.883481] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   36.885478] cx23885[0]: i2c bus 0 registered
[   36.885497] cx23885[0]: i2c bus 1 registered
[   36.885508] cx23885[0]: i2c bus 2 registered
[   36.923040] hda_codec: Unknown model for ALC883, trying auto-probe from
BIOS...
[   36.935482] cx25840' 2-0044: cx25  0-21 found @ 0x88 (cx23885[0])
[   36.946678] cx23885[0]: cx23885 based dvb card
[   37.000004] xc2028: Xcv2028/3028 init called!
[   37.000007] xc2028 1-0061: creating new instance
[   37.000008] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   37.000009] xc2028 1-0061: xc2028_set_config called
[   37.000012] DVB: registering new adapter (cx23885[0])
[   37.000014] DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
[   37.000157] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   37.000163] cx23885[0]/0: found at 0000:04:00.0, rev: 2, irq: 16,
latency: 0, mmio: 0xfe800000
[   37.000169] PCI: Setting latency timer of device 0000:04:00.0 to 64
[   37.002975] dib0700: firmware started successfully.
[   37.503811] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm
state.
[   37.503844] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[   37.503990] DVB: registering new adapter (Hauppauge Nova-T 500 Dual
DVB-T)
[   37.617347] DVB: registering frontend 1 (DiBcom 3000MC/P)...
[   37.653325] MT2060: successfully identified (IF1 = 1258)
[   38.130408] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[   38.130598] DVB: registering new adapter (Hauppauge Nova-T 500 Dual
DVB-T)
[   38.136278] DVB: registering frontend 2 (DiBcom 3000MC/P)...
[   38.141025] MT2060: successfully identified (IF1 = 1255)
[   38.696060] dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully
initialized and connected.
[   38.696197] usbcore: registered new interface driver dvb_usb_dib0700
--
[   60.205989] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 =>
0x5ae9
[   60.206673] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600,
adc_clock 450560 => -6633 / 0xe617
[   60.208372] xc2028 1-0061: xc2028_set_params called
[   60.208374] xc2028 1-0061: generic_set_freq called
[   60.208375] xc2028 1-0061: should set frequency 226500 kHz
[   60.208377] xc2028 1-0061: check_firmware called
[   60.208378] xc2028 1-0061: load_all_firmwares called
[   60.208380] xc2028 1-0061: Reading firmware xc3028-v27.fw
[   60.245446] xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw,
type: xc2028 firmware, ver 2.7
[   60.245454] xc2028 1-0061: Reading firmware type BASE F8MHZ (3), id 0,
size=8718.
[   60.245462] xc2028 1-0061: Reading firmware type BASE F8MHZ MTS (7), id
0, size=8712.
[   60.245471] xc2028 1-0061: Reading firmware type BASE FM (401), id 0,
size=8562.
[   60.245480] xc2028 1-0061: Reading firmware type BASE FM INPUT1 (c01), id
0, size=8576.
[   60.245487] xc2028 1-0061: Reading firmware type BASE (1), id 0,
size=8706.
[   60.245495] xc2028 1-0061: Reading firmware type BASE MTS (5), id 0,
size=8682.
[   60.245500] xc2028 1-0061: Reading firmware type (0), id 100000007,
size=161.
[   60.245503] xc2028 1-0061: Reading firmware type MTS (4), id 100000007,
size=169.
[   60.245506] xc2028 1-0061: Reading firmware type (0), id 200000007,
size=161.
[   60.245509] xc2028 1-0061: Reading firmware type MTS (4), id 200000007,
size=169.
[   60.245511] xc2028 1-0061: Reading firmware type (0), id 400000007,
size=161.
[   60.245514] xc2028 1-0061: Reading firmware type MTS (4), id 400000007,
size=169.
[   60.245517] xc2028 1-0061: Reading firmware type (0), id 800000007,
size=161.
[   60.245519] xc2028 1-0061: Reading firmware type MTS (4), id 800000007,
size=169.
[   60.245522] xc2028 1-0061: Reading firmware type (0), id 3000000e0,
size=161.
[   60.245525] xc2028 1-0061: Reading firmware type MTS (4), id 3000000e0,
size=169.
[   60.245527] xc2028 1-0061: Reading firmware type (0), id c000000e0,
size=161.
[   60.245530] xc2028 1-0061: Reading firmware type MTS (4), id c000000e0,
size=169.
[   60.245533] xc2028 1-0061: Reading firmware type (0), id 200000,
size=161.
[   60.245536] xc2028 1-0061: Reading firmware type MTS (4), id 200000,
size=169.
[   60.245538] xc2028 1-0061: Reading firmware type (0), id 4000000,
size=161.
[   60.245541] xc2028 1-0061: Reading firmware type MTS (4), id 4000000,
size=169.
[   60.245544] xc2028 1-0061: Reading firmware type D2633 DTV6 ATSC (10030),
id 0, size=149.
[   60.245547] xc2028 1-0061: Reading firmware type D2620 DTV6 QAM (68), id
0, size=149.
[   60.245551] xc2028 1-0061: Reading firmware type D2633 DTV6 QAM (70), id
0, size=149.
[   60.245554] xc2028 1-0061: Reading firmware type D2620 DTV7 (88), id 0,
size=149.
[   60.245558] xc2028 1-0061: Reading firmware type D2633 DTV7 (90), id 0,
size=149.
[   60.245561] xc2028 1-0061: Reading firmware type D2620 DTV78 (108), id 0,
size=149.
[   60.245564] xc2028 1-0061: Reading firmware type D2633 DTV78 (110), id 0,
size=149.
[   60.245567] xc2028 1-0061: Reading firmware type D2620 DTV8 (208), id 0,
size=149.
[   60.245570] xc2028 1-0061: Reading firmware type D2633 DTV8 (210), id 0,
size=149.
[   60.245574] xc2028 1-0061: Reading firmware type FM (400), id 0,
size=135.
[   60.245576] xc2028 1-0061: Reading firmware type (0), id 10, size=161.
[   60.245579] xc2028 1-0061: Reading firmware type MTS (4), id 10,
size=169.
[   60.245582] xc2028 1-0061: Reading firmware type (0), id 1000400000,
size=169.
[   60.245584] xc2028 1-0061: Reading firmware type (0), id c00400000,
size=161.
[   60.245587] xc2028 1-0061: Reading firmware type (0), id 800000,
size=161.
[   60.245589] xc2028 1-0061: Reading firmware type (0), id 8000, size=161.
[   60.245592] xc2028 1-0061: Reading firmware type LCD (1000), id 8000,
size=161.
[   60.245595] xc2028 1-0061: Reading firmware type LCD NOGD (3000), id
8000, size=161.
[   60.245598] xc2028 1-0061: Reading firmware type MTS (4), id 8000,
size=169.
[   60.245601] xc2028 1-0061: Reading firmware type (0), id b700, size=161.
[   60.245604] xc2028 1-0061: Reading firmware type LCD (1000), id b700,
size=161.
[   60.245607] xc2028 1-0061: Reading firmware type LCD NOGD (3000), id
b700, size=161.
[   60.245610] xc2028 1-0061: Reading firmware type (0), id 2000, size=161.
[   60.245612] xc2028 1-0061: Reading firmware type MTS (4), id b700,
size=169.
[   60.245615] xc2028 1-0061: Reading firmware type MTS LCD (1004), id b700,
size=169.
[   60.245618] xc2028 1-0061: Reading firmware type MTS LCD NOGD (3004), id
b700, size=169.
[   60.245621] xc2028 1-0061: Reading firmware type SCODE HAS_IF_3280
(60000000), id 0, size=192.
[   60.245625] xc2028 1-0061: Reading firmware type SCODE HAS_IF_3300
(60000000), id 0, size=192.
[   60.245628] xc2028 1-0061: Reading firmware type SCODE HAS_IF_3440
(60000000), id 0, size=192.
[   60.245632] xc2028 1-0061: Reading firmware type SCODE HAS_IF_3460
(60000000), id 0, size=192.
[   60.245635] xc2028 1-0061: Reading firmware type DTV6 ATSC OREN36 SCODE
HAS_IF_3800 (60210020), id 0, size=192.
[   60.245640] xc2028 1-0061: Reading firmware type SCODE HAS_IF_4000
(60000000), id 0, size=192.
[   60.245643] xc2028 1-0061: Reading firmware type DTV6 ATSC TOYOTA388
SCODE HAS_IF_4080 (60410020), id 0, size=192.
[   60.245647] xc2028 1-0061: Reading firmware type SCODE HAS_IF_4200
(60000000), id 0, size=192.
[   60.245651] xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_4320
(60008000), id 8000, size=192.
[   60.245654] xc2028 1-0061: Reading firmware type SCODE HAS_IF_4450
(60000000), id 0, size=192.
[   60.245658] xc2028 1-0061: Reading firmware type MTS LCD NOGD MONO IF
SCODE HAS_IF_4500 (6002b004), id b700, size=192.
[   60.245663] xc2028 1-0061: Reading firmware type LCD NOGD IF SCODE
HAS_IF_4600 (60023000), id 8000, size=192.
[   60.245667] xc2028 1-0061: Reading firmware type DTV6 QAM DTV7 DTV78 DTV8
ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0, size=192.
[   60.245673] xc2028 1-0061: Reading firmware type SCODE HAS_IF_4940
(60000000), id 0, size=192.
[   60.245676] xc2028 1-0061: Reading firmware type SCODE HAS_IF_5260
(60000000), id 0, size=192.
[   60.245679] xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_5320
(60008000), id f00000007, size=192.
[   60.245683] xc2028 1-0061: Reading firmware type DTV7 DTV78 DTV8 DIBCOM52
CHINA SCODE HAS_IF_5400 (65000380), id 0, size=192.
[   60.245689] xc2028 1-0061: Reading firmware type DTV6 ATSC OREN538 SCODE
HAS_IF_5580 (60110020), id 0, size=192.
[   60.245693] xc2028 1-0061: Reading firmware type SCODE HAS_IF_5640
(60000000), id 300000007, size=192.
[   60.245697] xc2028 1-0061: Reading firmware type SCODE HAS_IF_5740
(60000000), id c00000007, size=192.
[   60.245700] xc2028 1-0061: Reading firmware type SCODE HAS_IF_5900
(60000000), id 0, size=192.
[   60.245704] xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_6000
(60008000), id c04c000f0, size=192.
[   60.245707] xc2028 1-0061: Reading firmware type DTV6 QAM ATSC LG60 F6MHZ
SCODE HAS_IF_6200 (68050060), id 0, size=192.
[   60.245712] xc2028 1-0061: Reading firmware type SCODE HAS_IF_6240
(60000000), id 10, size=192.
[   60.245716] xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_6320
(60008000), id 200000, size=192.
[   60.245720] xc2028 1-0061: Reading firmware type SCODE HAS_IF_6340
(60000000), id 200000, size=192.
[   60.245724] xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_6500
(60008000), id c044000e0, size=192.
[   60.245728] xc2028 1-0061: Reading firmware type DTV6 ATSC ATI638 SCODE
HAS_IF_6580 (60090020), id 0, size=192.
[   60.245733] xc2028 1-0061: Reading firmware type SCODE HAS_IF_6600
(60000000), id 3000000e0, size=192.
[   60.245737] xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_6680
(60008000), id 3000000e0, size=192.
[   60.245741] xc2028 1-0061: Reading firmware type DTV6 ATSC TOYOTA794
SCODE HAS_IF_8140 (60810020), id 0, size=192.
[   60.245747] xc2028 1-0061: Reading firmware type SCODE HAS_IF_8200
(60000000), id 0, size=192.
[   60.245756] xc2028 1-0061: Firmware files loaded.
[   60.245758] xc2028 1-0061: checking firmware, user requested type=F8MHZ
D2620 DTV7 (8a), id 0000000000000000, int_freq 4760, scode_nr 0
[   60.444033] xc2028 1-0061: load_firmware called
[   60.444036] xc2028 1-0061: seek_firmware called, want type=BASE F8MHZ
D2620 DTV7 (8b), id 0000000000000000.
[   60.444040] xc2028 1-0061: Found firmware for type=BASE F8MHZ (3), id
0000000000000000.
[   60.444042] xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), id
0000000000000000.
[   61.591362] xc2028 1-0061: Load init1 firmware, if exists
[   61.591366] xc2028 1-0061: load_firmware called
[   61.591367] xc2028 1-0061: seek_firmware called, want type=BASE INIT1
F8MHZ D2620 DTV7 (408b), id 0000000000000000.
[   61.591373] xc2028 1-0061: Can't find firmware for type=BASE INIT1 F8MHZ
(4003), id 0000000000000000.
[   61.591375] xc2028 1-0061: load_firmware called
[   61.591376] xc2028 1-0061: seek_firmware called, want type=BASE INIT1
D2620 DTV7 (4089), id 0000000000000000.
[   61.591380] xc2028 1-0061: Can't find firmware for type=BASE INIT1
(4001), id 0000000000000000.
[   61.591383] xc2028 1-0061: load_firmware called
[   61.591384] xc2028 1-0061: seek_firmware called, want type=F8MHZ D2620
DTV7 (8a), id 0000000000000000.
[   61.591387] xc2028 1-0061: Found firmware for type=D2620 DTV7 (88), id
0000000000000000.
[   61.591389] xc2028 1-0061: Loading firmware for type=D2620 DTV7 (88), id
0000000000000000.
[   61.605149] xc2028 1-0061: Trying to load scode 0
[   61.605151] xc2028 1-0061: load_scode called
[   61.605153] xc2028 1-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[   61.636427] xc2028 1-0061: xc2028_get_reg 0004 called
[   61.637139] xc2028 1-0061: xc2028_get_reg 0008 called
[   61.637849] xc2028 1-0061: Device is Xceive 3028 version 1.0, firmware
version 2.7
[   61.772300] xc2028 1-0061: divisor= 00 00 37 f0 (freq=226.500)
--
Dmesg output - Warm start (failure condition) 
[  119.515126] cx23885[0]/0: [f5f30e40/11] cx23885_buf_queue - append to
active
[  119.515128] cx23885[0]/0: queue is not empty - append to active
[  119.515130] cx23885[0]/0: [f6a18180/12] cx23885_buf_queue - append to
active
[  119.515132] cx23885[0]/0: queue is not empty - append to active
[  119.515133] cx23885[0]/0: [f69f3840/13] cx23885_buf_queue - append to
active
[  119.515135] cx23885[0]/0: queue is not empty - append to active
[  119.515137] cx23885[0]/0: [f69a9e40/14] cx23885_buf_queue - append to
active
[  119.515139] cx23885[0]/0: queue is not empty - append to active
[  119.515141] cx23885[0]/0: [f69a96c0/15] cx23885_buf_queue - append to
active
[  119.515143] cx23885[0]/0: queue is not empty - append to active
[  119.515144] cx23885[0]/0: [f69a9180/16] cx23885_buf_queue - append to
active
[  119.515146] cx23885[0]/0: queue is not empty - append to active
[  119.515148] cx23885[0]/0: [f69a93c0/17] cx23885_buf_queue - append to
active
[  119.515150] cx23885[0]/0: queue is not empty - append to active
[  119.515152] cx23885[0]/0: [f69a9600/18] cx23885_buf_queue - append to
active
[  119.515154] cx23885[0]/0: queue is not empty - append to active
[  119.515155] cx23885[0]/0: [f69b0f00/19] cx23885_buf_queue - append to
active
[  119.515157] cx23885[0]/0: queue is not empty - append to active
[  119.515159] cx23885[0]/0: [f6a03cc0/20] cx23885_buf_queue - append to
active
[  119.515161] cx23885[0]/0: queue is not empty - append to active
[  119.515162] cx23885[0]/0: [f6a03d80/21] cx23885_buf_queue - append to
active
[  119.515164] cx23885[0]/0: queue is not empty - append to active
[  119.515166] cx23885[0]/0: [f6a03300/22] cx23885_buf_queue - append to
active
[  119.515168] cx23885[0]/0: queue is not empty - append to active
[  119.515170] cx23885[0]/0: [f6a03e40/23] cx23885_buf_queue - append to
active
[  119.515171] cx23885[0]/0: queue is not empty - append to active
[  119.515173] cx23885[0]/0: [f6a030c0/24] cx23885_buf_queue - append to
active
[  119.515175] cx23885[0]/0: queue is not empty - append to active
[  119.515177] cx23885[0]/0: [f6a03f00/25] cx23885_buf_queue - append to
active
[  119.515179] cx23885[0]/0: queue is not empty - append to active
[  119.515180] cx23885[0]/0: [f6a036c0/26] cx23885_buf_queue - append to
active
[  119.515182] cx23885[0]/0: queue is not empty - append to active
[  119.515184] cx23885[0]/0: [f6a03780/27] cx23885_buf_queue - append to
active
[  119.515186] cx23885[0]/0: queue is not empty - append to active
[  119.515187] cx23885[0]/0: [f690f6c0/28] cx23885_buf_queue - append to
active
[  119.515189] cx23885[0]/0: queue is not empty - append to active
[  119.515191] cx23885[0]/0: [f690f000/29] cx23885_buf_queue - append to
active
[  119.515193] cx23885[0]/0: queue is not empty - append to active
[  119.515195] cx23885[0]/0: [f690f600/30] cx23885_buf_queue - append to
active
[  119.515196] cx23885[0]/0: queue is not empty - append to active
[  119.515198] cx23885[0]/0: [f690f480/31] cx23885_buf_queue - append to
active
[  120.511178] cx23885[0]/0: cx23885_timeout()
[  120.511182] cx23885[0]/0: cx23885_stop_dma()
[  120.511189] cx23885[0]/0: [f5f30a80/0] timeout - dma=0x35f21000
[  120.511191] cx23885[0]/0: [f5f306c0/1] timeout - dma=0x35f1a000
[  120.511193] cx23885[0]/0: [f5f30b40/2] timeout - dma=0x35f13000
[  120.511195] cx23885[0]/0: [f5f30f00/3] timeout - dma=0x35f0c000
[  120.511197] cx23885[0]/0: [f5f300c0/4] timeout - dma=0x35f05000
[  120.511199] cx23885[0]/0: [f5f309c0/5] timeout - dma=0x35efe000
[  120.511201] cx23885[0]/0: [f5f30780/6] timeout - dma=0x35ef7000
[  120.511203] cx23885[0]/0: [f5f30d80/7] timeout - dma=0x35ef0000
[  120.511205] cx23885[0]/0: [f5f30c00/8] timeout - dma=0x35ee9000
[  120.511207] cx23885[0]/0: [f5f30180/9] timeout - dma=0x35ee2000
[  120.511209] cx23885[0]/0: [f5f30cc0/10] timeout - dma=0x35edb000
[  120.511211] cx23885[0]/0: [f5f30e40/11] timeout - dma=0x35ed4000
[  120.511213] cx23885[0]/0: [f6a18180/12] timeout - dma=0x35ecd000
[  120.511215] cx23885[0]/0: [f69f3840/13] timeout - dma=0x35ec6000
[  120.511217] cx23885[0]/0: [f69a9e40/14] timeout - dma=0x35ebf000
[  120.511219] cx23885[0]/0: [f69a96c0/15] timeout - dma=0x35eb8000
[  120.511221] cx23885[0]/0: [f69a9180/16] timeout - dma=0x35eb1000
[  120.511223] cx23885[0]/0: [f69a93c0/17] timeout - dma=0x35eaa000
[  120.511225] cx23885[0]/0: [f69a9600/18] timeout - dma=0x35ea3000
[  120.511228] cx23885[0]/0: [f69b0f00/19] timeout - dma=0x35e9c000
[  120.511230] cx23885[0]/0: [f6a03cc0/20] timeout - dma=0x35e95000
[  120.511232] cx23885[0]/0: [f6a03d80/21] timeout - dma=0x35e8e000
[  120.511234] cx23885[0]/0: [f6a03300/22] timeout - dma=0x35dd1000
[  120.511236] cx23885[0]/0: [f6a03e40/23] timeout - dma=0x35e64000
[  120.511238] cx23885[0]/0: [f6a030c0/24] timeout - dma=0x3591f000
[  120.511240] cx23885[0]/0: [f6a03f00/25] timeout - dma=0x35e46000
[  120.511242] cx23885[0]/0: [f6a036c0/26] timeout - dma=0x35e69000
[  120.511244] cx23885[0]/0: [f6a03780/27] timeout - dma=0x35e50000
[  120.511246] cx23885[0]/0: [f690f6c0/28] timeout - dma=0x35e57000
[  120.511248] cx23885[0]/0: [f690f000/29] timeout - dma=0x35e4e000
[  120.511250] cx23885[0]/0: [f690f600/30] timeout - dma=0x35e75000
[  120.511252] cx23885[0]/0: [f690f480/31] timeout - dma=0x35e7c000
[  120.511253] cx23885[0]/0: restarting queue
[  120.514094] cx23885[0]/0: queue is empty - first active
[  120.514097] cx23885[0]/0: cx23885_start_dma() w: 752, h: 32, f: 2
[  120.514101] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
channel [TS2 C]
[  120.514315] cx23885[0]/0: cx23885_start_dma() enabling TS int's and DMA
[  120.514323] cx23885[0]/0: [f5f30a80/0] cx23885_buf_queue - first active
[  120.514325] cx23885[0]/0: queue is not empty - append to active
[  120.514327] cx23885[0]/0: [f5f306c0/1] cx23885_buf_queue - append to
active
[  120.514329] cx23885[0]/0: queue is not empty - append to active
[  120.514331] cx23885[0]/0: [f5f30b40/2] cx23885_buf_queue - append to
active
[  120.514332] cx23885[0]/0: queue is not empty - append to active
[  120.514334] cx23885[0]/0: [f5f30f00/3] cx23885_buf_queue - append to
active
[  120.514336] cx23885[0]/0: queue is not empty - append to active
[  120.514338] cx23885[0]/0: [f5f300c0/4] cx23885_buf_queue - append to
active
[  120.514340] cx23885[0]/0: queue is not empty - append to active
[  120.514341] cx23885[0]/0: [f5f309c0/5] cx23885_buf_queue - append to
active
[  120.514343] cx23885[0]/0: queue is not empty - append to active
[  120.514345] cx23885[0]/0: [f5f30780/6] cx23885_buf_queue - append to
active
[  120.514347] cx23885[0]/0: queue is not empty - append to active
[  120.514348] cx23885[0]/0: [f5f30d80/7] cx23885_buf_queue - append to
active
[  120.514350] cx23885[0]/0: queue is not empty - append to active
[  120.514352] cx23885[0]/0: [f5f30c00/8] cx23885_buf_queue - append to
active
[  120.514354] cx23885[0]/0: queue is not empty - append to active
[  120.514355] cx23885[0]/0: [f5f30180/9] cx23885_buf_queue - append to
active
[  120.514357] cx23885[0]/0: queue is not empty - append to active
[  120.514359] cx23885[0]/0: [f5f30cc0/10] cx23885_buf_queue - append to
active
[  120.514361] cx23885[0]/0: queue is not empty - append to active
[  120.514363] cx23885[0]/0: [f5f30e40/11] cx23885_buf_queue - append to
active
[  120.514364] cx23885[0]/0: queue is not empty - append to active
[  120.514366] cx23885[0]/0: [f6a18180/12] cx23885_buf_queue - append to
active
----  repeated for many screens...




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
