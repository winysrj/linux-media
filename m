Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 203.161.84.42.static.amnet.net.au ([203.161.84.42]
	helo=goeng.com.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tom@goeng.com.au>) id 1KZl0Q-0001dZ-NF
	for linux-dvb@linuxtv.org; Sun, 31 Aug 2008 13:22:09 +0200
From: "Thomas Goerke" <tom@goeng.com.au>
To: stev391@email.com, "'jackden'" <jackden@gmail.com>
References: <20080830012407.BCB0247808F@ws1-5.us4.outblaze.com>
In-Reply-To: <20080830012407.BCB0247808F@ws1-5.us4.outblaze.com>
Date: Sun, 31 Aug 2008 19:22:31 +0800
Message-ID: <002d01c90b5b$dec12860$9c437920$@com.au>
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

> Tom,
> (Jackden please try first patch and provide feedback, if that doesn't
> work for your card, then try this and provide feedback)
> 
> The second dmesg (with debugging) didn't show me what I was looking
> for, but from past experience I will try something else.  I was looking
> for some dma errors from the cx23885 driver, these usually occured
> while streaming is being attempted.
> 
> Attached to this email is another patch.  The difference between the
> first one and the second one is that I load an extra module (cx25840),
> which normally is not required for DVB as it is part of the analog side
> of this card.  This does NOT mean analog will be supported.
> 
> As of today the main v4l-dvb can be used with this patch and this means
> that the cx23885-leadtek tree will soon disappear. So step 2 above has
> been modified to: "Check out the latest v4l-dvb source".
> 
> Other then that step 4 has a different file name for the patch.
> 
> Steps that need to be completed are: 2, 3, 4, 5, 7, 9, 10 & 11. (As you
> have completed the missing steps already).
> 
> If the patch works, please do not stop communicating, as I have to
> perform one more patch to prove that cx25840 is required and my
> assumptions are correct. Once this is completed I will send it to
> Steven Toth for inclusion in his test tree. This will need to be tested
> by you again, and if all is working well after a week or more it will
> be included into the main tree.
> 
> Regards,
> Stephen
> 
> 
> --

Stephen,

After following Steven Toth's advice re CPIA, applying your patch and then
make, make install, I can now report that the Compro E800F card is working!
This is very impressive and thanks for your help.

I have added the card to MythTV and all channels were successfully added.  I
am not sure about the comparable signal strength's compared to the Hauppauge
Nova card I also have installed - this is something I can provide feedback
on at a later stage.

I have tried from a soft and hard reset and all seems ok.

See below for the o/p from dmesg.  Please let  me know if there is anything
else you would like to try/test.

Tom

[   30.958220] Linux video capture interface: v2.00
--
[   31.029497] cx23885 driver version 0.0.1 loaded
[   31.048139] hda_codec: Unknown model for ALC883, trying auto-probe from
BIOS...
[   31.115006] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) ->
IRQ 16
[   31.115010] cx23885[0]/0: cx23885_dev_setup() Memory configured for PCIe
bridge type 885
[   31.115012] cx23885[0]/0: cx23885_init_tsport(portno=2)
[   31.115020] CORE cx23885[0]: subsystem: 185b:e800, board: Compro
VideoMate E650 [card=13,autodetected]
[   31.115021] cx23885[0]/0: cx23885_pci_quirks()
[   31.115024] cx23885[0]/0: cx23885_dev_setup() tuner_type = 0x0 tuner_addr
= 0x0
[   31.115025] cx23885[0]/0: cx23885_dev_setup() radio_type = 0x0 radio_addr
= 0x0
[   31.115027] cx23885[0]/0: cx23885_reset()
[   31.214235] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
channel [VID A]
[   31.214245] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch2]
[   31.214246] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
channel [TS1 B]
[   31.214260] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch4]
[   31.214262] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch5]
[   31.214263] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
channel [TS2 C]
[   31.214276] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch7]
[   31.214278] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch8]
[   31.214279] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch9]
[   31.253989] dib0700: loaded with support for 7 different device-types
[   31.254019] cx23885[0]: i2c bus 0 registered
[   31.254377] cx23885[0]: i2c bus 1 registered
[   31.254399] cx23885[0]: i2c bus 2 registered
[   31.254425] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in cold
state, will try to load a firmware
[   31.330077] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.10.fw'
[   31.372765] cx25840' 2-0044: cx25  0-21 found @ 0x88 (cx23885[0])
[   31.373208] cx23885[0]: cx23885 based dvb card
[   31.535949] dib0700: firmware started successfully.
[   31.709654] xc2028: Xcv2028/3028 init called!
[   31.709657] xc2028 1-0061: creating new instance
[   31.709658] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   31.709659] xc2028 1-0061: xc2028_set_config called
[   31.709662] DVB: registering new adapter (cx23885[0])
[   31.709664] DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
[   31.709808] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   31.709814] cx23885[0]/0: found at 0000:04:00.0, rev: 2, irq: 16,
latency: 0, mmio: 0xfe800000
[   31.709819] PCI: Setting latency timer of device 0000:04:00.0 to 64
[   32.036702] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm
state.
[   32.036730] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[   32.036837] DVB: registering new adapter (Hauppauge Nova-T 500 Dual
DVB-T)
[   32.150071] DVB: registering frontend 1 (DiBcom 3000MC/P)...
[   32.176555] MT2060: successfully identified (IF1 = 1258)
[   32.651264] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[   32.651456] DVB: registering new adapter (Hauppauge Nova-T 500 Dual
DVB-T)
[   32.657011] DVB: registering frontend 2 (DiBcom 3000MC/P)...
[   32.661756] MT2060: successfully identified (IF1 = 1255)
[   33.216916] dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully
initialized and connected.
[   33.217053] usbcore: registered new interface driver dvb_usb_dib0700
[   33.471632] lp: driver loaded but no devices found
[   33.516463] w83627ehf: Found W83627DHG chip at 0x290
[   33.539393] coretemp coretemp.0: Using undocumented features, absolute
temperature might be wrong!
[   33.539420] coretemp coretemp.1: Using undocumented features, absolute
temperature might be wrong!
--
[   47.747158] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 =>
0x5ae9
[   47.747838] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600,
adc_clock 450560 => -6633 / 0xe617
[   47.749533] xc2028 1-0061: xc2028_set_params called
[   47.749535] xc2028 1-0061: generic_set_freq called
[   47.749537] xc2028 1-0061: should set frequency 219500 kHz
[   47.749539] xc2028 1-0061: check_firmware called
[   47.749541] xc2028 1-0061: load_all_firmwares called
[   47.749543] xc2028 1-0061: Reading firmware xc3028-v27.fw
[   47.825029] xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw,
type: xc2028 firmware, ver 2.7
[   47.825040] xc2028 1-0061: Reading firmware type BASE F8MHZ (3), id 0,
size=8718.
[   47.825050] xc2028 1-0061: Reading firmware type BASE F8MHZ MTS (7), id
0, size=8712.
[   47.825060] xc2028 1-0061: Reading firmware type BASE FM (401), id 0,
size=8562.
[   47.825070] xc2028 1-0061: Reading firmware type BASE FM INPUT1 (c01), id
0, size=8576.
[   47.825080] xc2028 1-0061: Reading firmware type BASE (1), id 0,
size=8706.
[   47.825089] xc2028 1-0061: Reading firmware type BASE MTS (5), id 0,
size=8682.
[   47.825095] xc2028 1-0061: Reading firmware type (0), id 100000007,
size=161.
[   47.825098] xc2028 1-0061: Reading firmware type MTS (4), id 100000007,
size=169.
[   47.825101] xc2028 1-0061: Reading firmware type (0), id 200000007,
size=161.
[   47.825104] xc2028 1-0061: Reading firmware type MTS (4), id 200000007,
size=169.
[   47.825107] xc2028 1-0061: Reading firmware type (0), id 400000007,
size=161.
[   47.825110] xc2028 1-0061: Reading firmware type MTS (4), id 400000007,
size=169.
[   47.825113] xc2028 1-0061: Reading firmware type (0), id 800000007,
size=161.
[   47.825116] xc2028 1-0061: Reading firmware type MTS (4), id 800000007,
size=169.
[   47.825119] xc2028 1-0061: Reading firmware type (0), id 3000000e0,
size=161.
[   47.825122] xc2028 1-0061: Reading firmware type MTS (4), id 3000000e0,
size=169.
[   47.825126] xc2028 1-0061: Reading firmware type (0), id c000000e0,
size=161.
[   47.825128] xc2028 1-0061: Reading firmware type MTS (4), id c000000e0,
size=169.
[   47.825132] xc2028 1-0061: Reading firmware type (0), id 200000,
size=161.
[   47.825135] xc2028 1-0061: Reading firmware type MTS (4), id 200000,
size=169.
[   47.825138] xc2028 1-0061: Reading firmware type (0), id 4000000,
size=161.
[   47.825141] xc2028 1-0061: Reading firmware type MTS (4), id 4000000,
size=169.
[   47.825144] xc2028 1-0061: Reading firmware type D2633 DTV6 ATSC (10030),
id 0, size=149.
[   47.825148] xc2028 1-0061: Reading firmware type D2620 DTV6 QAM (68), id
0, size=149.
[   47.825152] xc2028 1-0061: Reading firmware type D2633 DTV6 QAM (70), id
0, size=149.
[   47.825156] xc2028 1-0061: Reading firmware type D2620 DTV7 (88), id 0,
size=149.
[   47.825159] xc2028 1-0061: Reading firmware type D2633 DTV7 (90), id 0,
size=149.
[   47.825163] xc2028 1-0061: Reading firmware type D2620 DTV78 (108), id 0,
size=149.
[   47.825166] xc2028 1-0061: Reading firmware type D2633 DTV78 (110), id 0,
size=149.
[   47.825170] xc2028 1-0061: Reading firmware type D2620 DTV8 (208), id 0,
size=149.
[   47.825173] xc2028 1-0061: Reading firmware type D2633 DTV8 (210), id 0,
size=149.
[   47.825177] xc2028 1-0061: Reading firmware type FM (400), id 0,
size=135.
[   47.825180] xc2028 1-0061: Reading firmware type (0), id 10, size=161.
[   47.825183] xc2028 1-0061: Reading firmware type MTS (4), id 10,
size=169.
[   47.825186] xc2028 1-0061: Reading firmware type (0), id 1000400000,
size=169.
[   47.825189] xc2028 1-0061: Reading firmware type (0), id c00400000,
size=161.
[   47.825191] xc2028 1-0061: Reading firmware type (0), id 800000,
size=161.
[   47.825194] xc2028 1-0061: Reading firmware type (0), id 8000, size=161.
[   47.825197] xc2028 1-0061: Reading firmware type LCD (1000), id 8000,
size=161.
[   47.825200] xc2028 1-0061: Reading firmware type LCD NOGD (3000), id
8000, size=161.
[   47.825204] xc2028 1-0061: Reading firmware type MTS (4), id 8000,
size=169.
[   47.825207] xc2028 1-0061: Reading firmware type (0), id b700, size=161.
[   47.825210] xc2028 1-0061: Reading firmware type LCD (1000), id b700,
size=161.
[   47.825214] xc2028 1-0061: Reading firmware type LCD NOGD (3000), id
b700, size=161.
[   47.825217] xc2028 1-0061: Reading firmware type (0), id 2000, size=161.
[   47.825219] xc2028 1-0061: Reading firmware type MTS (4), id b700,
size=169.
[   47.825222] xc2028 1-0061: Reading firmware type MTS LCD (1004), id b700,
size=169.
[   47.825226] xc2028 1-0061: Reading firmware type MTS LCD NOGD (3004), id
b700, size=169.
[   47.825230] xc2028 1-0061: Reading firmware type SCODE HAS_IF_3280
(60000000), id 0, size=192.
[   47.825234] xc2028 1-0061: Reading firmware type SCODE HAS_IF_3300
(60000000), id 0, size=192.
[   47.825238] xc2028 1-0061: Reading firmware type SCODE HAS_IF_3440
(60000000), id 0, size=192.
[   47.825242] xc2028 1-0061: Reading firmware type SCODE HAS_IF_3460
(60000000), id 0, size=192.
[   47.825246] xc2028 1-0061: Reading firmware type DTV6 ATSC OREN36 SCODE
HAS_IF_3800 (60210020), id 0, size=192.
[   47.825251] xc2028 1-0061: Reading firmware type SCODE HAS_IF_4000
(60000000), id 0, size=192.
[   47.825254] xc2028 1-0061: Reading firmware type DTV6 ATSC TOYOTA388
SCODE HAS_IF_4080 (60410020), id 0, size=192.
[   47.825259] xc2028 1-0061: Reading firmware type SCODE HAS_IF_4200
(60000000), id 0, size=192.
[   47.825263] xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_4320
(60008000), id 8000, size=192.
[   47.825267] xc2028 1-0061: Reading firmware type SCODE HAS_IF_4450
(60000000), id 0, size=192.
[   47.825271] xc2028 1-0061: Reading firmware type MTS LCD NOGD MONO IF
SCODE HAS_IF_4500 (6002b004), id b700, size=192.
[   47.825277] xc2028 1-0061: Reading firmware type LCD NOGD IF SCODE
HAS_IF_4600 (60023000), id 8000, size=192.
[   47.825282] xc2028 1-0061: Reading firmware type DTV6 QAM DTV7 DTV78 DTV8
ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0, size=192.
[   47.825288] xc2028 1-0061: Reading firmware type SCODE HAS_IF_4940
(60000000), id 0, size=192.
[   47.825292] xc2028 1-0061: Reading firmware type SCODE HAS_IF_5260
(60000000), id 0, size=192.
[   47.825295] xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_5320
(60008000), id f00000007, size=192.
[   47.825300] xc2028 1-0061: Reading firmware type DTV7 DTV78 DTV8 DIBCOM52
CHINA SCODE HAS_IF_5400 (65000380), id 0, size=192.
[   47.825306] xc2028 1-0061: Reading firmware type DTV6 ATSC OREN538 SCODE
HAS_IF_5580 (60110020), id 0, size=192.
[   47.825311] xc2028 1-0061: Reading firmware type SCODE HAS_IF_5640
(60000000), id 300000007, size=192.
[   47.825315] xc2028 1-0061: Reading firmware type SCODE HAS_IF_5740
(60000000), id c00000007, size=192.
[   47.825318] xc2028 1-0061: Reading firmware type SCODE HAS_IF_5900
(60000000), id 0, size=192.
[   47.825323] xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_6000
(60008000), id c04c000f0, size=192.
[   47.825327] xc2028 1-0061: Reading firmware type DTV6 QAM ATSC LG60 F6MHZ
SCODE HAS_IF_6200 (68050060), id 0, size=192.
[   47.825333] xc2028 1-0061: Reading firmware type SCODE HAS_IF_6240
(60000000), id 10, size=192.
[   47.825337] xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_6320
(60008000), id 200000, size=192.
[   47.825341] xc2028 1-0061: Reading firmware type SCODE HAS_IF_6340
(60000000), id 200000, size=192.
[   47.825345] xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_6500
(60008000), id c044000e0, size=192.
[   47.825349] xc2028 1-0061: Reading firmware type DTV6 ATSC ATI638 SCODE
HAS_IF_6580 (60090020), id 0, size=192.
[   47.825354] xc2028 1-0061: Reading firmware type SCODE HAS_IF_6600
(60000000), id 3000000e0, size=192.
[   47.825358] xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_6680
(60008000), id 3000000e0, size=192.
[   47.825363] xc2028 1-0061: Reading firmware type DTV6 ATSC TOYOTA794
SCODE HAS_IF_8140 (60810020), id 0, size=192.
[   47.825367] xc2028 1-0061: Reading firmware type SCODE HAS_IF_8200
(60000000), id 0, size=192.
[   47.825377] xc2028 1-0061: Firmware files loaded.
[   47.825378] xc2028 1-0061: checking firmware, user requested type=F8MHZ
D2620 DTV7 (8a), id 0000000000000000, int_freq 4760, scode_nr 0
[   48.023790] xc2028 1-0061: load_firmware called
[   48.023793] xc2028 1-0061: seek_firmware called, want type=BASE F8MHZ
D2620 DTV7 (8b), id 0000000000000000.
[   48.023798] xc2028 1-0061: Found firmware for type=BASE F8MHZ (3), id
0000000000000000.
[   48.023801] xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), id
0000000000000000.
[   49.173110] xc2028 1-0061: Load init1 firmware, if exists
[   49.173113] xc2028 1-0061: load_firmware called
[   49.173115] xc2028 1-0061: seek_firmware called, want type=BASE INIT1
F8MHZ D2620 DTV7 (408b), id 0000000000000000.
[   49.173120] xc2028 1-0061: Can't find firmware for type=BASE INIT1 F8MHZ
(4003), id 0000000000000000.
[   49.173122] xc2028 1-0061: load_firmware called
[   49.173124] xc2028 1-0061: seek_firmware called, want type=BASE INIT1
D2620 DTV7 (4089), id 0000000000000000.
[   49.173127] xc2028 1-0061: Can't find firmware for type=BASE INIT1
(4001), id 0000000000000000.
[   49.173130] xc2028 1-0061: load_firmware called
[   49.173131] xc2028 1-0061: seek_firmware called, want type=F8MHZ D2620
DTV7 (8a), id 0000000000000000.
[   49.173134] xc2028 1-0061: Found firmware for type=D2620 DTV7 (88), id
0000000000000000.
[   49.173137] xc2028 1-0061: Loading firmware for type=D2620 DTV7 (88), id
0000000000000000.
[   49.186909] xc2028 1-0061: Trying to load scode 0
[   49.186910] xc2028 1-0061: load_scode called
[   49.186912] xc2028 1-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[   49.219155] xc2028 1-0061: xc2028_get_reg 0004 called
[   49.219869] xc2028 1-0061: xc2028_get_reg 0008 called
[   49.220581] xc2028 1-0061: Device is Xceive 3028 version 1.0, firmware
version 2.7
[   49.327079] atl1 0000:02:00.0: eth0 link is up 100 Mbps full duplex
[   49.355032] xc2028 1-0061: divisor= 00 00 36 30 (freq=219.500)
--




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
