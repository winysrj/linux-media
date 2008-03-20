Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+58f8ad55774394d91ee7+1670+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JcMBQ-00072K-Nq
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 15:55:57 +0100
Date: Thu, 20 Mar 2008 11:55:31 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: timf <timf@iinet.net.au>
Message-ID: <20080320115531.7ab450ba@gaivota>
In-Reply-To: <1205904196.6510.3.camel@ubuntu>
References: <47A5D8AF.2090800@googlemail.com> <47A8CE7E.6020908@googlemail.com>
	<20080205222437.1397896d@gaivota> <47AA014F.2090608@googlemail.com>
	<20080207092607.0a1cacaa@gaivota> <47AAF0C4.8030804@googlemail.com>
	<47AB6A1B.5090100@googlemail.com> <20080207184221.1ea8e823@gaivota>
	<47ACA9AA.4090702@googlemail.com> <47AE20BD.7090503@googlemail.com>
	<20080212124734.62cd451d@gaivota> <47B1E22D.4090901@googlemail.com>
	<20080313114633.494bc7b1@gaivota> <1205457408.6358.5.camel@ubuntu>
	<20080314121423.670f31a0@gaivota> <1205518856.6094.14.camel@ubuntu>
	<20080314155851.52677f28@gaivota> <1205523274.6364.5.camel@ubuntu>
	<20080314172143.62390b1f@gaivota> <1205573636.5941.1.camel@ubuntu>
	<20080318103044.4363fefd@gaivota>
	<1205864312.11231.11.camel@ubuntu>
	<20080318161729.6da782ee@gaivota>
	<1205873332.11231.17.camel@ubuntu>
	<20080318180415.5dfc4319@gaivota>
	<1205875868.3385.133.camel@pc08.localdom.local>
	<1205904196.6510.3.camel@ubuntu>
Mime-Version: 1.0
Cc: Hackmann <hartmut.hackmann@t-online.de>, lucarasp <lucarasp@inwind.it>,
	"Richard \(MQ\)" <osl2008@googlemail.com>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Any chance of help with v4l-dvb-experimental /
 Avermedia A16D please?
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

On Wed, 19 Mar 2008 14:23:16 +0900
timf <timf@iinet.net.au> wrote:

> Hi all,
> 
> On Tue, 2008-03-18 at 22:31 +0100, hermann pitton wrote:
> > Hi,
> > 
> > Am Dienstag, den 18.03.2008, 18:04 -0300 schrieb Mauro Carvalho Chehab:
> > > On Wed, 19 Mar 2008 05:48:52 +0900
> > > timf <timf@iinet.net.au> wrote:
> > > 
> > > > 1) New install ubuntu, extract tip.tgz.
> > > 
> > > There's no need for you to reinstall Linux for each test. This is not MS**t ;)
> > > 
> > > You don't even need to reboot.
> > > 
> > > > [   40.753552] saa7133[0]: i2c scan: found device @ 0xc2  [???]
> > > > [   40.864616] tuner' 2-0061: Setting mode_mask to 0x0e
> > > > [   40.864621] tuner' 2-0061: chip found @ 0xc2 (saa7133[0])
> > > > [   40.864624] tuner' 2-0061: tuner 0x61: Tuner type absent
> > > > [   40.864658] tuner' 2-0061: Calling set_type_addr for type=0,
> > > > addr=0xff, mode=0x02, config=0xffff8100
> > 
> > any idea somebody when that was introduced?
> > 
> > [   40.753552] saa7133[0]: i2c scan: found device @ 0xc2  [???]
> > [   40.864616] tuner' 2-0061: Setting mode_mask to 0x0e
> > [   40.864621] tuner' 2-0061: chip found @ 0xc2 (saa7133[0])
> > [   40.864624] tuner' 2-0061: tuner 0x61: Tuner type absent
> > [   40.864658] tuner' 2-0061: Calling set_type_addr for type=0,
> > addr=0xff, mode=0x02, config=0xffff8100
> > [   40.864662] tuner' 2-0061: set addr for type -1
> > [   40.876586] tuner-simple 2-0061: creating new instance
> > [   40.876589] tuner-simple 2-0061: type set to 0 (Temic PAL (4002 FH5))
> > 
> > Out of historical cruft TUNER_ABSENT is tuner type 4.
> > 
> > > mode=0x02 is radio.
> > > 
> > > Try to add this to the struct:
> > > 
> > > .radio_type     = UNSET,
> > > 
> > > > 3) No DVB, installed tvtime - no signal.
> > > 
> > > DVB won't work yet. What the demod inside this board? There's no setup for it.
> > 
> > Cheers,
> > Hermann
> > 
> 
> Nope, could't get anything to work.
> - blacklisted tuner_xc3028 - no diff still locked up at boot
> - dbg - no module loaded
> 
> $%#!!! it - reinstalled; Gee it took ages for clone hg linuxtv to
> download - 3kbs at best???
> 
> 1) no updates, no nvidia-glx-new (prop) (thus no 1680 x 1050 - looks
> awful, nv can't do that res)
> 
> - looked in saa7134-cards.c
> only this patch:
> 	},
> 	[SAA7134_BOARD_AVERMEDIA_A16D] = {
> 		.name           = "AVerMedia Hybrid TV/Radio (A16D)",
> 		.audio_clock    = 0x187de7,
> 		.tuner_type     = TUNER_XC2028,
> 		.tuner_addr	= ADDR_UNSET,
> 		.inputs         = {{
> 			.name = name_tv,
> 			.vmux = 1,
> 			.amux = TV,
> 			.tv   = 1,
> 		}, {
> 			.name = name_svideo,
> 			.vmux = 8,
> 			.amux = LINE1,
> 		} },
> 		.radio = {
> 			.name = name_radio,
> 			.amux = LINE1,
> 		},
> 	},
> 	[SAA7134_BOARD_AVERMEDIA_M115] = {
> 
> - make, sudo make install v4l-dvb, reboot
> 
> - no /dev/video#
> - no soundcard detected??? -> no volume control
> dmesg
> <snip>
> [   40.108132] Linux video capture interface: v2.00
> [   40.146196] saa7130/34: v4l2 driver version 0.2.14 loaded
> [   40.147238] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
> [   40.147249] ACPI: PCI Interrupt 0000:04:09.0[A] -> Link [APC2] -> GSI
> 17 (level, low) -> IRQ 17
> [   40.147258] saa7133[0]: found at 0000:04:09.0, rev: 209, irq: 17,
> latency: 32, mmio: 0xfdbff000
> [   40.147265] saa7133[0]: subsystem: 1461:f936, board: AVerMedia Hybrid
> TV/Radio (A16D) [card=137,autodetected]
> [   40.147275] saa7133[0]: board init: gpio is 2fe00
> [   40.308263] saa7133[0]: i2c eeprom 00: 61 14 36 f9 00 00 00 00 00 00
> 00 00 00 00 00 00
> [   40.308273] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff
> ff ff ff ff ff ff
> [   40.308282] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 00 08 ff
> 00 0e ff ff ff ff
> [   40.308290] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.308298] saa7133[0]: i2c eeprom 40: ff 65 00 ff c2 1e ff ff ff ff
> ff ff ff ff ff ff
> [   40.308306] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.308314] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.308322] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.308330] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.308338] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.308347] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.308355] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.308363] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.308371] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.308379] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.308388] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.320255] saa7133[0]: i2c scan: found device @ 0x1e  [???]
> [   40.340220] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
> [   40.451576] saa7133[0]: registered device video0 [v4l2]
> [   40.451617] saa7133[0]: registered device vbi0
> [   40.451653] saa7133[0]: registered device radio0
> [   40.452183] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
> [   40.452187] ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [AAZA] -> GSI
> 22 (level, low) -> IRQ 22
> [   40.452421] PCI: Setting latency timer of device 0000:00:10.1 to 64
> [   40.464285] saa7134 ALSA driver for DMA sound loaded
> [   40.464316] saa7133[0]/alsa: saa7133[0] at 0xfdbff000 irq 17
> registered as card -2
> <snip>
> That's all!
> 
> 2) Put other patch in:
>  	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
>  	case SAA7134_BOARD_AVERMEDIA_M115:
>  	case SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM:
> +	case SAA7134_BOARD_AVERMEDIA_A16D:
>  		/* power-up tuner chip */
>  		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0xffffffff, 0xffffffff);
>  		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0xffffffff, 0xffffffff);
> 
> - make, sudo make install v4l-dvb, reboot
> - still no /dev/video#
> - still no soundcard detected??? -> no volume control
> dmesg
> <snip>
> [   37.052833] Linux video capture interface: v2.00
> [   37.088234] parport_pc 00:08: reported by Plug and Play ACPI
> [   37.088328] parport0: PC-style at 0x378 (0x778), irq 7, dma 3
> [PCSPP,TRISTATE,COMPAT,ECP,DMA]
> [   37.091985] hdc: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB
> Cache, UDMA(66)
> [   37.091993] Uniform CD-ROM driver Revision: 3.20
> [   37.127981] saa7130/34: v4l2 driver version 0.2.14 loaded
> [   37.129041] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
> [   37.129053] ACPI: PCI Interrupt 0000:04:09.0[A] -> Link [APC2] -> GSI
> 17 (level, low) -> IRQ 17
> [   37.129063] saa7133[0]: found at 0000:04:09.0, rev: 209, irq: 17,
> latency: 32, mmio: 0xfdbff000
> [   37.129069] saa7133[0]: subsystem: 1461:f936, board: AVerMedia Hybrid
> TV/Radio (A16D) [card=137,autodetected]
> [   37.129080] saa7133[0]: board init: gpio is 2fe00
> [   37.301262] saa7133[0]: i2c eeprom 00: 61 14 36 f9 00 00 00 00 00 00
> 00 00 00 00 00 00
> [   37.301272] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff
> ff ff ff ff ff ff
> [   37.301281] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 00 08 ff
> 00 0e ff ff ff ff
> [   37.301288] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   37.301297] saa7133[0]: i2c eeprom 40: ff 65 00 ff c2 1e ff ff ff ff
> ff ff ff ff ff ff
> [   37.301305] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   37.301312] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   37.301320] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   37.301328] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   37.301336] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   37.301344] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   37.301352] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   37.301360] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   37.301368] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   37.301376] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   37.301384] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   37.321227] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
> [   37.333208] saa7133[0]: i2c scan: found device @ 0xc2  [???]
> [   37.417690] tuner' 2-0061: Setting mode_mask to 0x0e
> [   37.417696] tuner' 2-0061: chip found @ 0xc2 (saa7133[0])
> [   37.417699] tuner' 2-0061: tuner 0x61: Tuner type absent
> [   37.417734] tuner' 2-0061: Calling set_type_addr for type=71,
> addr=0xff, mode=0x04, config=0x00
> [   37.417737] tuner' 2-0061: set addr for type -1
> [   37.417739] tuner' 2-0061: defining GPIO callback
> [   37.417742] xc2028: Xcv2028/3028 init called!
> [   37.417745] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
> [   37.417748] tuner' 2-0061: type set to Xceive XC3028
> [   37.417751] tuner' 2-0061: tv freq set to 400.00
> [   37.417753] xc2028 2-0061: xc2028_set_analog_freq called
> [   37.417756] xc2028 2-0061: generic_set_freq called
> [   37.417759] xc2028 2-0061: should set frequency 400000 kHz
> [   37.417761] xc2028 2-0061: check_firmware called
> [   37.417763] xc2028 2-0061: xc2028/3028 firmware name not set!
> [   37.417767] tuner' 2-0061: saa7133[0] tuner' I2C addr 0xc2 with type
> 71 used for 0x0e
> [   37.419545] xc2028 2-0061: xc2028_set_config called
> [   37.419553] tuner' 2-0061: switching to v4l2
> [   37.419557] tuner' 2-0061: tv freq set to 400.00
> [   37.419560] xc2028 2-0061: xc2028_set_analog_freq called
> [   37.419563] xc2028 2-0061: generic_set_freq called
> [   37.419565] xc2028 2-0061: should set frequency 400000 kHz
> [   37.419568] xc2028 2-0061: check_firmware called
> [   37.419570] xc2028 2-0061: load_all_firmwares called
> [   37.419572] xc2028 2-0061: Reading firmware xc3028-v27.fw
> [   37.456770] xc2028 2-0061: Loading 80 firmware images from
> xc3028-v27.fw, type: xc2028 firmware, ver 2.7
> [   37.456783] xc2028 2-0061: Reading firmware type BASE F8MHZ (3), id
> 0, size=8718.
> [   37.456798] xc2028 2-0061: Reading firmware type BASE F8MHZ MTS (7),
> id 0, size=8712.
> [   37.456812] xc2028 2-0061: Reading firmware type BASE FM (401), id 0,
> size=8562.
> [   37.456827] xc2028 2-0061: Reading firmware type BASE FM INPUT1
> (c01), id 0, size=8576.
> [   37.456841] xc2028 2-0061: Reading firmware type BASE (1), id 0,
> size=8706.
> [   37.456855] xc2028 2-0061: Reading firmware type BASE MTS (5), id 0,
> size=8682.
> [   37.456864] xc2028 2-0061: Reading firmware type (0), id 100000007,
> size=161.
> [   37.456867] xc2028 2-0061: Reading firmware type MTS (4), id
> 100000007, size=169.
> [   37.456872] xc2028 2-0061: Reading firmware type (0), id 200000007,
> size=161.
> [   37.456875] xc2028 2-0061: Reading firmware type MTS (4), id
> 200000007, size=169.
> [   37.456879] xc2028 2-0061: Reading firmware type (0), id 400000007,
> size=161.
> [   37.456882] xc2028 2-0061: Reading firmware type MTS (4), id
> 400000007, size=169.
> [   37.456887] xc2028 2-0061: Reading firmware type (0), id 800000007,
> size=161.
> [   37.456890] xc2028 2-0061: Reading firmware type MTS (4), id
> 800000007, size=169.
> [   37.456895] xc2028 2-0061: Reading firmware type (0), id 3000000e0,
> size=161.
> [   37.456898] xc2028 2-0061: Reading firmware type MTS (4), id
> 3000000e0, size=169.
> [   37.456902] xc2028 2-0061: Reading firmware type (0), id c000000e0,
> size=161.
> [   37.456905] xc2028 2-0061: Reading firmware type MTS (4), id
> c000000e0, size=169.
> [   37.456910] xc2028 2-0061: Reading firmware type (0), id 200000,
> size=161.
> [   37.456913] xc2028 2-0061: Reading firmware type MTS (4), id 200000,
> size=169.
> [   37.456917] xc2028 2-0061: Reading firmware type (0), id 4000000,
> size=161.
> [   37.456920] xc2028 2-0061: Reading firmware type MTS (4), id 4000000,
> size=169.
> [   37.456924] xc2028 2-0061: Reading firmware type D2633 DTV6 ATSC
> (10030), id 0, size=149.
> [   37.456928] xc2028 2-0061: Reading firmware type D2620 DTV6 QAM (68),
> id 0, size=149.
> [   37.456932] xc2028 2-0061: Reading firmware type D2633 DTV6 QAM (70),
> id 0, size=149.
> [   37.456938] xc2028 2-0061: Reading firmware type D2620 DTV7 (88), id
> 0, size=149.
> [   37.456942] xc2028 2-0061: Reading firmware type D2633 DTV7 (90), id
> 0, size=149.
> [   37.456946] xc2028 2-0061: Reading firmware type D2620 DTV78 (108),
> id 0, size=149.
> [   37.456951] xc2028 2-0061: Reading firmware type D2633 DTV78 (110),
> id 0, size=149.
> [   37.456954] xc2028 2-0061: Reading firmware type D2620 DTV8 (208), id
> 0, size=149.
> [   37.456958] xc2028 2-0061: Reading firmware type D2633 DTV8 (210), id
> 0, size=149.
> [   37.456963] xc2028 2-0061: Reading firmware type FM (400), id 0,
> size=135.
> [   37.456966] xc2028 2-0061: Reading firmware type (0), id 10,
> size=161.
> [   37.456969] xc2028 2-0061: Reading firmware type MTS (4), id 10,
> size=169.
> [   37.456973] xc2028 2-0061: Reading firmware type (0), id 1000400000,
> size=169.
> [   37.456977] xc2028 2-0061: Reading firmware type (0), id c00400000,
> size=161.
> [   37.456980] xc2028 2-0061: Reading firmware type (0), id 800000,
> size=161.
> [   37.456984] xc2028 2-0061: Reading firmware type (0), id 8000,
> size=161.
> [   37.456987] xc2028 2-0061: Reading firmware type LCD (1000), id 8000,
> size=161.
> [   37.456991] xc2028 2-0061: Reading firmware type LCD NOGD (3000), id
> 8000, size=161.
> [   37.456995] xc2028 2-0061: Reading firmware type MTS (4), id 8000,
> size=169.
> [   37.456999] xc2028 2-0061: Reading firmware type (0), id b700,
> size=161.
> [   37.457002] xc2028 2-0061: Reading firmware type LCD (1000), id b700,
> size=161.
> [   37.457006] xc2028 2-0061: Reading firmware type LCD NOGD (3000), id
> b700, size=161.
> [   37.457010] xc2028 2-0061: Reading firmware type (0), id 2000,
> size=161.
> [   37.457013] xc2028 2-0061: Reading firmware type MTS (4), id b700,
> size=169.
> [   37.457021] xc2028 2-0061: Reading firmware type MTS LCD (1004), id
> b700, size=169.
> [   37.457025] xc2028 2-0061: Reading firmware type MTS LCD NOGD (3004),
> id b700, size=169.
> [   37.457029] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3280
> (60000000), id 0, size=192.
> [   37.457034] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3300
> (60000000), id 0, size=192.
> [   37.457039] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3440
> (60000000), id 0, size=192.
> [   37.457043] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3460
> (60000000), id 0, size=192.
> [   37.457047] xc2028 2-0061: Reading firmware type DTV6 ATSC OREN36
> SCODE HAS_IF_3800 (60210020), id 0, size=192.
> [   37.457053] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4000
> (60000000), id 0, size=192.
> [   37.457057] xc2028 2-0061: Reading firmware type DTV6 ATSC TOYOTA388
> SCODE HAS_IF_4080 (60410020), id 0, size=192.
> [   37.457063] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4200
> (60000000), id 0, size=192.
> [   37.457067] xc2028 2-0061: Reading firmware type MONO SCODE
> HAS_IF_4320 (60008000), id 8000, size=192.
> [   37.457072] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4450
> (60000000), id 0, size=192.
> [   37.457077] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4500
> (60000000), id 2000, size=192.
> [   37.457081] xc2028 2-0061: Reading firmware type LCD NOGD IF SCODE
> HAS_IF_4600 (60023000), id 8000, size=192.
> [   37.457087] xc2028 2-0061: Reading firmware type DTV78 ZARLINK456
> SCODE HAS_IF_4760 (62000100), id 0, size=192.
> [   37.457092] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4940
> (60000000), id 0, size=192.
> [   37.457096] xc2028 2-0061: Reading firmware type DTV7 ZARLINK456
> SCODE HAS_IF_5260 (62000080), id 0, size=192.
> [   37.457101] xc2028 2-0061: Reading firmware type MONO SCODE
> HAS_IF_5320 (60008000), id 800000007, size=192.
> [   37.457107] xc2028 2-0061: Reading firmware type DTV8 CHINA SCODE
> HAS_IF_5400 (64000200), id 0, size=192.
> [   37.457111] xc2028 2-0061: Reading firmware type DTV6 ATSC OREN538
> SCODE HAS_IF_5580 (60110020), id 0, size=192.
> [   37.457117] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5640
> (60000000), id 200000007, size=192.
> [   37.457124] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5740
> (60000000), id 800000007, size=192.
> [   37.457129] xc2028 2-0061: Reading firmware type DTV7 DIBCOM52 SCODE
> HAS_IF_5900 (61000080), id 0, size=192.
> [   37.457134] xc2028 2-0061: Reading firmware type MONO SCODE
> HAS_IF_6000 (60008000), id 10, size=192.
> [   37.457139] xc2028 2-0061: Reading firmware type DTV6 QAM F6MHZ SCODE
> HAS_IF_6200 (68000060), id 0, size=192.
> [   37.457144] xc2028 2-0061: Reading firmware type SCODE HAS_IF_6240
> (60000000), id 10, size=192.
> [   37.457149] xc2028 2-0061: Reading firmware type MONO SCODE
> HAS_IF_6320 (60008000), id 200000, size=192.
> [   37.457154] xc2028 2-0061: Reading firmware type SCODE HAS_IF_6340
> (60000000), id 200000, size=192.
> [   37.457159] xc2028 2-0061: Reading firmware type MONO SCODE
> HAS_IF_6500 (60008000), id 4000000, size=192.
> [   37.457164] xc2028 2-0061: Reading firmware type DTV6 ATSC ATI638
> SCODE HAS_IF_6580 (60090020), id 0, size=192.
> [   37.457169] xc2028 2-0061: Reading firmware type SCODE HAS_IF_6600
> (60000000), id 3000000e0, size=192.
> [   37.457174] xc2028 2-0061: Reading firmware type MONO SCODE
> HAS_IF_6680 (60008000), id 3000000e0, size=192.
> [   37.457180] xc2028 2-0061: Reading firmware type DTV6 ATSC TOYOTA794
> SCODE HAS_IF_8140 (60810020), id 0, size=192.
> [   37.457185] xc2028 2-0061: Reading firmware type SCODE HAS_IF_8200
> (60000000), id 0, size=192.
> [   37.457201] xc2028 2-0061: Firmware files loaded.
> [   37.457203] xc2028 2-0061: checking firmware, user requested
> type=F8MHZ MTS (6), id 00000000000000ff, scode_tbl (0), scode_nr 0
> [   37.457229] Unable to handle kernel NULL pointer dereference at
> 00000000000001c4 RIP: 
> [   37.457232]  [<ffffffff88255839>] :saa7134:saa7134_tuner_callback
> +0x9/0x190
> [   37.457255] PGD 65f26067 PUD 66a9e067 PMD 0 
> [   37.457259] Oops: 0000 [1] SMP 
> [   37.457262] CPU 0 
> [   37.457264] Modules linked in: tuner tea5767 tda8290 tda18271 tda827x
> tuner_xc2028 xc5000 tda9887 tuner_simple tuner_types mt20xx tea5761
> snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy
> snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event saa7134 snd_seq
> parport_pc ide_cd cdrom snd_timer snd_seq_device compat_ioctl32 videodev
> v4l1_compat v4l2_common videobuf_dma_sg videobuf_core ir_kbd_i2c
> ir_common tveeprom xpad pcspkr psmouse parport snd soundcore
> snd_page_alloc i2c_nforce2 serio_raw k8temp i2c_core shpchp pci_hotplug
> evdev ext3 jbd mbcache sg sd_mod amd74xx ide_core usbhid hid forcedeth
> sata_nv ata_generic libata scsi_mod ohci_hcd ehci_hcd usbcore thermal
> processor fan fuse apparmor commoncap
> [   37.457305] Pid: 3942, comm: modprobe Not tainted 2.6.22-14-generic
> #1
> [   37.457308] RIP: 0010:[<ffffffff88255839>]
> [<ffffffff88255839>] :saa7134:saa7134_tuner_callback+0x9/0x190
> [   37.457321] RSP: 0018:ffff810065c65a38  EFLAGS: 00010292
> [   37.457323] RAX: 0000000000000007 RBX: 0000000000000001 RCX:
> 0000000000000000
> [   37.457326] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
> 0000000000000000
> [   37.457329] RBP: ffff81006c2e6600 R08: 000000000000904b R09:
> 0000000000000007
> [   37.457331] R10: 0000000000000000 R11: 0000000000000001 R12:
> 0000000000000000
> [   37.457334] R13: ffff81006c2e6678 R14: 0000000000000001 R15:
> 0000000000000001
> [   37.457338] FS:  00002ad17e0376e0(0000) GS:ffffffff80560000(0000)
> knlGS:0000000000000000
> [   37.457341] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   37.457344] CR2: 00000000000001c4 CR3: 0000000067900000 CR4:
> 00000000000006e0
> [   37.457348] Process modprobe (pid: 3942, threadinfo ffff810065c64000,
> task ffff810037e02dc0)
> [   37.457350] Stack:  ffff81006c2e6600 ffffffff8833c803
> ffff810065c65b08 ffff810000000002
> [   37.457358]  ffff810000000007 ffff81006d7db000 ffff81006d7db270
> 00000000000000ff
> [   37.457363]  000000066d7db170 17d7840000000004 ffff81006d7db000
> ffff81006c2e66a0
> [   37.457368] Call Trace:
> [   37.457375]  [<ffffffff8833c803>] :tuner_xc2028:generic_set_freq
> +0x593/0x1830
> [   37.457393]  [<ffffffff802361fe>] printk+0x4e/0x60
> [   37.457408]  [<ffffffff8835aa4e>] :tuner:set_tv_freq+0xae/0x1c0
> [   37.457417]  [<ffffffff8835abd1>] :tuner:set_freq+0x71/0x1a0
> [   37.457423]  [<ffffffff8835bfe8>] :tuner:tuner_command+0x198/0x12f0
> [   37.457439]  [<ffffffff8818c072>] :i2c_core:i2c_clients_command
> +0xa2/0xf0
> [   37.457452]  [<ffffffff8825dfc0>] :saa7134:saa7134_video_init2
> +0x10/0x40
> [   37.457462]  [<ffffffff882577bb>] :saa7134:saa7134_initdev
> +0x3fb/0x9a0
> [   37.457469]  [<ffffffff802e8530>] sysfs_make_dirent+0x30/0x50
> [   37.457478]  [<ffffffff803352d1>] pci_device_probe+0xf1/0x170
> [   37.457487]  [<ffffffff80391063>] driver_probe_device+0xa3/0x1b0
> [   37.457494]  [<ffffffff80391329>] __driver_attach+0xc9/0xd0
> [   37.457499]  [<ffffffff80391260>] __driver_attach+0x0/0xd0
> [   37.457503]  [<ffffffff8039023d>] bus_for_each_dev+0x4d/0x80
> [   37.457512]  [<ffffffff8039069f>] bus_add_driver+0xaf/0x1f0
> [   37.457518]  [<ffffffff80335556>] __pci_register_driver+0x66/0xb0
> [   37.457525]  [<ffffffff80256edb>] sys_init_module+0x19b/0x19b0
> [   37.457540]  [<ffffffff80326a21>] __up_write+0x21/0x130
> [   37.457551]  [<ffffffff80209e8e>] system_call+0x7e/0x83
> [   37.457560] 
> [   37.457561] 
> [   37.457562] Code: 8b 87 c4 01 00 00 83 f8 36 74 0f 83 f8 47 74 27 b8
> ea ff ff 
> [   37.457571] RIP  [<ffffffff88255839>] :saa7134:saa7134_tuner_callback
> +0x9/0x190
> [   37.457582]  RSP <ffff810065c65a38>
> [   37.457584] CR2: 00000000000001c4
> [  217.307903] loop: module loaded
> <snip>
> 
> 3) upgraded ubuntu 7.10
> 
> - now have /dev/video0 but tvtime no channel management
> - now have a soundcard and volume control
> dmesg
> <snip>
> [   40.858920] Linux video capture interface: v2.00
> [   40.885880] videobuf_core: exports duplicate symbol
> videobuf_mmap_mapper (owned by video_buf)
> [   40.898374] videobuf_dma_sg: disagrees about version of symbol
> videobuf_alloc
> [   40.898379] videobuf_dma_sg: Unknown symbol videobuf_alloc
> [   40.898442] videobuf_dma_sg: Unknown symbol videobuf_queue_core_init
> [   40.966241] input: PC Speaker as /class/input/input4
> [   40.996272] usbcore: registered new interface driver xpad
> [
> 40.996278] /build/buildd/linux-source-2.6.22-2.6.22/drivers/input/joystick/xpad.c: driver for Xbox controllers v0.1.6
> [   41.001747] videobuf_core: exports duplicate symbol
> videobuf_mmap_mapper (owned by video_buf)
> [   41.002059] videobuf_dma_sg: disagrees about version of symbol
> videobuf_alloc
> [   41.002062] videobuf_dma_sg: Unknown symbol videobuf_alloc
> [   41.002124] videobuf_dma_sg: Unknown symbol videobuf_queue_core_init
> [   41.023093] saa7130/34: v4l2 driver version 0.2.14 loaded
> [   41.024199] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
> [   41.024212] ACPI: PCI Interrupt 0000:04:09.0[A] -> Link [APC2] -> GSI
> 17 (level, low) -> IRQ 17
> [   41.024221] saa7133[0]: found at 0000:04:09.0, rev: 209, irq: 17,
> latency: 32, mmio: 0xfdbff000
> [   41.024228] saa7133[0]: subsystem: 1461:f936, board: UNKNOWN/GENERIC
> [card=0,autodetected]
> [   41.024238] saa7133[0]: board init: gpio is 2fa00
> [   41.169381] saa7133[0]: i2c eeprom 00: 61 14 36 f9 00 00 00 00 00 00
> 00 00 00 00 00 00
> [   41.169390] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff
> ff ff ff ff ff ff
> [   41.169398] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 00 08 ff
> 00 0e ff ff ff ff
> [   41.169405] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   41.169412] saa7133[0]: i2c eeprom 40: ff 65 00 ff c2 1e ff ff ff ff
> ff ff ff ff ff ff
> [   41.169419] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   41.169426] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   41.169433] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   41.181368] saa7133[0]: i2c scan: found device @ 0x1e  [???]
> [   41.201331] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
> [   41.207898] saa7133[0]: registered device video0 [v4l2]
> [   41.207916] saa7133[0]: registered device vbi0
> [   41.207634] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
> [   41.207640] ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [AAZA] -> GSI
> 22 (level, low) -> IRQ 22
> [   41.207843] PCI: Setting latency timer of device 0000:00:10.1 to 64
> [   41.216288] videobuf_core: exports duplicate symbol
> videobuf_mmap_mapper (owned by video_buf)
> [   41.216665] videobuf_dma_sg: disagrees about version of symbol
> videobuf_alloc
> [   41.216668] videobuf_dma_sg: Unknown symbol videobuf_alloc
> [   41.216730] videobuf_dma_sg: Unknown symbol videobuf_queue_core_init
> [   41.229655] saa7134 ALSA driver for DMA sound loaded
> [   41.229687] saa7133[0]/alsa: saa7133[0] at 0xfdbff000 irq 17
> registered as card -2
> [   42.568641] loop: module loaded
> <snip>
> 
> What is this?
> 
> [
> 40.996278] /build/buildd/linux-source-2.6.22-2.6.22/drivers/input/joystick/xpad.c: driver for Xbox controllers v0.1.6
> 
> I don't have a xbox, is it auto loaded module from kernel?
> 
> 4) still no nvidia-glx-new
> 
> - make, sudo make install v4l-dvb
> 
> after cd v4l-dvb, make, sudo make install:
> 
> timf@ubuntu:~/v4l-dvb$ sudo modprobe saa7134
> WARNING: Error inserting videobuf_core
> (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/videobuf-core.ko): Invalid module format
> WARNING: Error inserting videobuf_dma_sg
> (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/videobuf-dma-sg.ko): Unknown symbol in module, or unknown parameter (see dmesg)
> timf@ubuntu:~/v4l-dvb$ 
> 
> dmesg
> <snip>
> [   40.858920] Linux video capture interface: v2.00
> [   40.885880] videobuf_core: exports duplicate symbol
> videobuf_mmap_mapper (owned by video_buf)
> [   40.898374] videobuf_dma_sg: disagrees about version of symbol
> videobuf_alloc
> [   40.898379] videobuf_dma_sg: Unknown symbol videobuf_alloc
> [   40.898442] videobuf_dma_sg: Unknown symbol videobuf_queue_core_init
> [   40.966241] input: PC Speaker as /class/input/input4
> [   40.996272] usbcore: registered new interface driver xpad
> [
> 40.996278] /build/buildd/linux-source-2.6.22-2.6.22/drivers/input/joystick/xpad.c: driver for Xbox controllers v0.1.6
> [   41.001747] videobuf_core: exports duplicate symbol
> videobuf_mmap_mapper (owned by video_buf)
> [   41.002059] videobuf_dma_sg: disagrees about version of symbol
> videobuf_alloc
> [   41.002062] videobuf_dma_sg: Unknown symbol videobuf_alloc
> [   41.002124] videobuf_dma_sg: Unknown symbol videobuf_queue_core_init
> [   41.023093] saa7130/34: v4l2 driver version 0.2.14 loaded
> [   41.024199] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
> [   41.024212] ACPI: PCI Interrupt 0000:04:09.0[A] -> Link [APC2] -> GSI
> 17 (level, low) -> IRQ 17
> [   41.024221] saa7133[0]: found at 0000:04:09.0, rev: 209, irq: 17,
> latency: 32, mmio: 0xfdbff000
> [   41.024228] saa7133[0]: subsystem: 1461:f936, board: UNKNOWN/GENERIC
> [card=0,autodetected]
> [   41.024238] saa7133[0]: board init: gpio is 2fa00
> [   41.169381] saa7133[0]: i2c eeprom 00: 61 14 36 f9 00 00 00 00 00 00
> 00 00 00 00 00 00
> [   41.169390] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff
> ff ff ff ff ff ff
> [   41.169398] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 00 08 ff
> 00 0e ff ff ff ff
> [   41.169405] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   41.169412] saa7133[0]: i2c eeprom 40: ff 65 00 ff c2 1e ff ff ff ff
> ff ff ff ff ff ff
> [   41.169419] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   41.169426] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   41.169433] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   41.181368] saa7133[0]: i2c scan: found device @ 0x1e  [???]
> [   41.201331] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
> [   41.207898] saa7133[0]: registered device video0 [v4l2]
> [   41.207916] saa7133[0]: registered device vbi0
> [   41.207634] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
> [   41.207640] ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [AAZA] -> GSI
> 22 (level, low) -> IRQ 22
> [   41.207843] PCI: Setting latency timer of device 0000:00:10.1 to 64
> [   41.216288] videobuf_core: exports duplicate symbol
> videobuf_mmap_mapper (owned by video_buf)
> [   41.216665] videobuf_dma_sg: disagrees about version of symbol
> videobuf_alloc
> [   41.216668] videobuf_dma_sg: Unknown symbol videobuf_alloc
> [   41.216730] videobuf_dma_sg: Unknown symbol videobuf_queue_core_init
> [   41.229655] saa7134 ALSA driver for DMA sound loaded
> [   41.229687] saa7133[0]/alsa: saa7133[0] at 0xfdbff000 irq 17
> registered as card -2
> [   42.568641] loop: module loaded
> [   42.591463] lp0: using parport0 (interrupt-driven).
> [   42.683471] Adding 9767512k swap on /dev/sda3.  Priority:-1 extents:1
> across:9767512k
> [   43.018620] EXT3 FS on sda4, internal journal
> [   43.674379] kjournald starting.  Commit interval 5 seconds
> [   43.675429] EXT3 FS on sda2, internal journal
> [   43.675436] EXT3-fs: mounted filesystem with ordered data mode.
> [   44.385992] No dock devices found.
> [   44.463874] input: Power Button (FF) as /class/input/input5
> [   44.463900] ACPI: Power Button (FF) [PWRF]
> [   44.463943] input: Power Button (CM) as /class/input/input6
> [   44.463956] ACPI: Power Button (CM) [PWRB]
> [   44.726559] powernow-k8: Found 2 AMD Athlon(tm) 64 X2 Dual Core
> Processor 3600+ processors (version 2.00.00)
> [   44.725758] powernow-k8: MP systems not supported by PSB BIOS
> structure
> [   44.726603] powernow-k8: MP systems not supported by PSB BIOS
> structure
> [   45.730504] ppdev: user-space parallel port driver
> [   45.850955] audit(1205902078.360:3):  type=1503
> operation="inode_permission" requested_mask="a" denied_mask="a"
> name="/dev/tty" pid=5088 profile="/usr/sbin/cupsd"
> [   46.184234] Failure registering capabilities with primary security
> module.
> [   46.358319] Bluetooth: Core ver 2.11
> [   46.358438] NET: Registered protocol family 31
> [   46.358441] Bluetooth: HCI device and connection manager initialized
> [   46.358445] Bluetooth: HCI socket layer initialized
> [   46.368366] Bluetooth: L2CAP ver 2.8
> [   46.368373] Bluetooth: L2CAP socket layer initialized
> [   46.419940] Bluetooth: RFCOMM socket layer initialized
> [   46.420043] Bluetooth: RFCOMM TTY layer initialized
> [   46.420046] Bluetooth: RFCOMM ver 1.8
> [   50.527622] NET: Registered protocol family 17
> [   53.186922] NET: Registered protocol family 10
> [   53.187106] lo: Disabled Privacy Extensions
> [   63.602916] eth0: no IPv6 routers present
> [  112.219989] usb 2-2: new high speed USB device using ehci_hcd and
> address 4
> [  112.353831] usb 2-2: configuration #1 chosen from 1 choice
> [  112.427851] usbcore: registered new interface driver libusual
> [  112.448957] Initializing USB Mass Storage driver...
> [  112.449315] scsi4 : SCSI emulation for USB Mass Storage devices
> [  112.449028] usb-storage: device found at 4
> [  112.449035] usb-storage: waiting for device to settle before scanning
> [  112.449716] usbcore: registered new interface driver usb-storage
> [  112.449805] USB Mass Storage support registered.
> [  117.444090] usb-storage: device scan complete
> [  117.445168] scsi 4:0:0:0: Direct-Access     USBDisk  RunDisk
> 1.00 PQ: 0 ANSI: 2
> [  117.450144] sd 4:0:0:0: [sdb] 4005000 512-byte hardware sectors (2051
> MB)
> [  117.451766] sd 4:0:0:0: [sdb] Write Protect is off
> [  117.451771] sd 4:0:0:0: [sdb] Mode Sense: 0b 00 00 08
> [  117.451774] sd 4:0:0:0: [sdb] Assuming drive cache: write through
> [  117.457132] sd 4:0:0:0: [sdb] 4005000 512-byte hardware sectors (2051
> MB)
> [  117.458754] sd 4:0:0:0: [sdb] Write Protect is off
> [  117.458758] sd 4:0:0:0: [sdb] Mode Sense: 0b 00 00 08
> [  117.458762] sd 4:0:0:0: [sdb] Assuming drive cache: write through
> [  117.458766]  sdb: sdb1
> [  117.511250] sd 4:0:0:0: [sdb] Attached SCSI removable disk
> [  117.511293] sd 4:0:0:0: Attached scsi generic sg1 type 0
> [  142.382746] usb 2-2: USB disconnect, address 4
> [  831.554889] videobuf_core: exports duplicate symbol
> videobuf_mmap_mapper (owned by video_buf)
> [  831.555406] videobuf_dma_sg: disagrees about version of symbol
> videobuf_alloc
> [  831.555410] videobuf_dma_sg: Unknown symbol videobuf_alloc
> [  831.555473] videobuf_dma_sg: Unknown symbol videobuf_queue_core_init
> [  944.319189] usb 2-2: new high speed USB device using ehci_hcd and
> address 5
> [  944.465057] usb 2-2: configuration #1 chosen from 1 choice
> [  944.465398] scsi5 : SCSI emulation for USB Mass Storage devices
> [  944.465168] usb-storage: device found at 5
> [  944.465174] usb-storage: waiting for device to settle before scanning
> [  949.459464] usb-storage: device scan complete
> [  949.460517] scsi 5:0:0:0: Direct-Access     USBDisk  RunDisk
> 1.00 PQ: 0 ANSI: 2
> [  949.465494] sd 5:0:0:0: [sdb] 4005000 512-byte hardware sectors (2051
> MB)
> [  949.467115] sd 5:0:0:0: [sdb] Write Protect is off
> [  949.467119] sd 5:0:0:0: [sdb] Mode Sense: 0b 00 00 08
> [  949.467124] sd 5:0:0:0: [sdb] Assuming drive cache: write through
> [  949.472482] sd 5:0:0:0: [sdb] 4005000 512-byte hardware sectors (2051
> MB)
> [  949.474103] sd 5:0:0:0: [sdb] Write Protect is off
> [  949.474107] sd 5:0:0:0: [sdb] Mode Sense: 0b 00 00 08
> [  949.474109] sd 5:0:0:0: [sdb] Assuming drive cache: write through
> [  949.474113]  sdb: sdb1
> [  949.599354] sd 5:0:0:0: [sdb] Attached SCSI removable disk
> [  949.599397] sd 5:0:0:0: Attached scsi generic sg1 type 0
> 
> What's this?
> [   41.216288] videobuf_core: exports duplicate symbol
> videobuf_mmap_mapper (owned by video_buf)
> [   41.216665] videobuf_dma_sg: disagrees about version of symbol
> videobuf_alloc
> [   41.216668] videobuf_dma_sg: Unknown symbol videobuf_alloc
> [   41.216730] videobuf_dma_sg: Unknown symbol videobuf_queue_core_init
> 
> still no nvidia-glx-new
> 
> Reboot
> dmesg
> <snip>
> [   38.451668] Linux video capture interface: v2.00
> [   38.478278] usbcore: registered new interface driver xpad
> [
> 38.478284] /build/buildd/linux-source-2.6.22-2.6.22/drivers/input/joystick/xpad.c: driver for Xbox controllers v0.1.6
> [   38.536507] saa7130/34: v4l2 driver version 0.2.14 loaded
> [   38.537018] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
> [   38.537030] ACPI: PCI Interrupt 0000:04:09.0[A] -> Link [APC2] -> GSI
> 17 (level, low) -> IRQ 17
> [   38.537038] saa7133[0]: found at 0000:04:09.0, rev: 209, irq: 17,
> latency: 32, mmio: 0xfdbff000
> [   38.537045] saa7133[0]: subsystem: 1461:f936, board: AVerMedia Hybrid
> TV/Radio (A16D) [card=137,autodetected]
> [   38.537055] saa7133[0]: board init: gpio is 2fa00
> [   38.720192] saa7133[0]: i2c eeprom 00: 61 14 36 f9 00 00 00 00 00 00
> 00 00 00 00 00 00
> [   38.720201] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff
> ff ff ff ff ff ff
> [   38.720208] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 00 08 ff
> 00 0e ff ff ff ff
> [   38.720216] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   38.720223] saa7133[0]: i2c eeprom 40: ff 65 00 ff c2 1e ff ff ff ff
> ff ff ff ff ff ff
> [   38.720230] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   38.720237] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   38.720245] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   38.720252] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   38.720259] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   38.720267] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   38.720274] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   38.720281] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   38.720289] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   38.720297] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   38.720304] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   38.740158] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
> [   38.752139] saa7133[0]: i2c scan: found device @ 0xc2  [???]
> [   38.851995] tuner' 2-0061: Setting mode_mask to 0x0e
> [   38.852000] tuner' 2-0061: chip found @ 0xc2 (saa7133[0])
> [   38.852003] tuner' 2-0061: tuner 0x61: Tuner type absent
> [   38.852043] tuner' 2-0061: Calling set_type_addr for type=71,
> addr=0xff, mode=0x04, config=0x00
> [   38.852046] tuner' 2-0061: set addr for type -1
> [   38.852048] tuner' 2-0061: defining GPIO callback
> [   38.852051] xc2028: Xcv2028/3028 init called!
> [   38.852055] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
> [   38.852058] tuner' 2-0061: type set to Xceive XC3028
> [   38.852061] tuner' 2-0061: tv freq set to 400.00
> [   38.852063] xc2028 2-0061: xc2028_set_analog_freq called
> [   38.852066] xc2028 2-0061: generic_set_freq called
> [   38.852069] xc2028 2-0061: should set frequency 400000 kHz
> [   38.852071] xc2028 2-0061: check_firmware called
> [   38.852073] xc2028 2-0061: xc2028/3028 firmware name not set!
> [   38.852076] tuner' 2-0061: saa7133[0] tuner' I2C addr 0xc2 with type
> 71 used for 0x0e
> [   38.854098] xc2028 2-0061: xc2028_set_config called
> [   38.854103] tuner' 2-0061: switching to v4l2
> [   38.854106] tuner' 2-0061: tv freq set to 400.00
> [   38.854108] xc2028 2-0061: xc2028_set_analog_freq called
> [   38.854110] xc2028 2-0061: generic_set_freq called
> [   38.854113] xc2028 2-0061: should set frequency 400000 kHz
> [   38.854115] xc2028 2-0061: check_firmware called
> [   38.854117] xc2028 2-0061: load_all_firmwares called
> [   38.854119] xc2028 2-0061: Reading firmware xc3028-v27.fw
> [   38.887454] xc2028 2-0061: Loading 80 firmware images from
> xc3028-v27.fw, type: xc2028 firmware, ver 2.7
> [   38.887468] xc2028 2-0061: Reading firmware type BASE F8MHZ (3), id
> 0, size=8718.
> [   38.887481] xc2028 2-0061: Reading firmware type BASE F8MHZ MTS (7),
> id 0, size=8712.
> [   38.887492] xc2028 2-0061: Reading firmware type BASE FM (401), id 0,
> size=8562.
> [   38.887502] xc2028 2-0061: Reading firmware type BASE FM INPUT1
> (c01), id 0, size=8576.
> [   38.887514] xc2028 2-0061: Reading firmware type BASE (1), id 0,
> size=8706.
> [   38.887525] xc2028 2-0061: Reading firmware type BASE MTS (5), id 0,
> size=8682.
> [   38.887531] xc2028 2-0061: Reading firmware type (0), id 100000007,
> size=161.
> [   38.887534] xc2028 2-0061: Reading firmware type MTS (4), id
> 100000007, size=169.
> [   38.887539] xc2028 2-0061: Reading firmware type (0), id 200000007,
> size=161.
> [   38.887542] xc2028 2-0061: Reading firmware type MTS (4), id
> 200000007, size=169.
> [   38.887546] xc2028 2-0061: Reading firmware type (0), id 400000007,
> size=161.
> [   38.887550] xc2028 2-0061: Reading firmware type MTS (4), id
> 400000007, size=169.
> [   38.887554] xc2028 2-0061: Reading firmware type (0), id 800000007,
> size=161.
> [   38.887558] xc2028 2-0061: Reading firmware type MTS (4), id
> 800000007, size=169.
> [   38.887562] xc2028 2-0061: Reading firmware type (0), id 3000000e0,
> size=161.
> [   38.887565] xc2028 2-0061: Reading firmware type MTS (4), id
> 3000000e0, size=169.
> [   38.887569] xc2028 2-0061: Reading firmware type (0), id c000000e0,
> size=161.
> [   38.887572] xc2028 2-0061: Reading firmware type MTS (4), id
> c000000e0, size=169.
> [   38.887576] xc2028 2-0061: Reading firmware type (0), id 200000,
> size=161.
> [   38.887579] xc2028 2-0061: Reading firmware type MTS (4), id 200000,
> size=169.
> [   38.887583] xc2028 2-0061: Reading firmware type (0), id 4000000,
> size=161.
> [   38.887586] xc2028 2-0061: Reading firmware type MTS (4), id 4000000,
> size=169.
> [   38.887590] xc2028 2-0061: Reading firmware type D2633 DTV6 ATSC
> (10030), id 0, size=149.
> [   38.887594] xc2028 2-0061: Reading firmware type D2620 DTV6 QAM (68),
> id 0, size=149.
> [   38.887598] xc2028 2-0061: Reading firmware type D2633 DTV6 QAM (70),
> id 0, size=149.
> [   38.887604] xc2028 2-0061: Reading firmware type D2620 DTV7 (88), id
> 0, size=149.
> [   38.887607] xc2028 2-0061: Reading firmware type D2633 DTV7 (90), id
> 0, size=149.
> [   38.887611] xc2028 2-0061: Reading firmware type D2620 DTV78 (108),
> id 0, size=149.
> [   38.887615] xc2028 2-0061: Reading firmware type D2633 DTV78 (110),
> id 0, size=149.
> [   38.887619] xc2028 2-0061: Reading firmware type D2620 DTV8 (208), id
> 0, size=149.
> [   38.887622] xc2028 2-0061: Reading firmware type D2633 DTV8 (210), id
> 0, size=149.
> [   38.887626] xc2028 2-0061: Reading firmware type FM (400), id 0,
> size=135.
> [   38.887630] xc2028 2-0061: Reading firmware type (0), id 10,
> size=161.
> [   38.887633] xc2028 2-0061: Reading firmware type MTS (4), id 10,
> size=169.
> [   38.887636] xc2028 2-0061: Reading firmware type (0), id 1000400000,
> size=169.
> [   38.887640] xc2028 2-0061: Reading firmware type (0), id c00400000,
> size=161.
> [   38.887643] xc2028 2-0061: Reading firmware type (0), id 800000,
> size=161.
> [   38.887646] xc2028 2-0061: Reading firmware type (0), id 8000,
> size=161.
> [   38.887649] xc2028 2-0061: Reading firmware type LCD (1000), id 8000,
> size=161.
> [   38.887653] xc2028 2-0061: Reading firmware type LCD NOGD (3000), id
> 8000, size=161.
> [   38.887657] xc2028 2-0061: Reading firmware type MTS (4), id 8000,
> size=169.
> [   38.887661] xc2028 2-0061: Reading firmware type (0), id b700,
> size=161.
> [   38.887664] xc2028 2-0061: Reading firmware type LCD (1000), id b700,
> size=161.
> [   38.887667] xc2028 2-0061: Reading firmware type LCD NOGD (3000), id
> b700, size=161.
> [   38.887671] xc2028 2-0061: Reading firmware type (0), id 2000,
> size=161.
> [   38.887674] xc2028 2-0061: Reading firmware type MTS (4), id b700,
> size=169.
> [   38.887679] xc2028 2-0061: Reading firmware type MTS LCD (1004), id
> b700, size=169.
> [   38.887682] xc2028 2-0061: Reading firmware type MTS LCD NOGD (3004),
> id b700, size=169.
> [   38.887687] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3280
> (60000000), id 0, size=192.
> [   38.887691] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3300
> (60000000), id 0, size=192.
> [   38.887695] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3440
> (60000000), id 0, size=192.
> [   38.887700] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3460
> (60000000), id 0, size=192.
> [   38.887705] xc2028 2-0061: Reading firmware type DTV6 ATSC OREN36
> SCODE HAS_IF_3800 (60210020), id 0, size=192.
> [   38.887710] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4000
> (60000000), id 0, size=192.
> [   38.887715] xc2028 2-0061: Reading firmware type DTV6 ATSC TOYOTA388
> SCODE HAS_IF_4080 (60410020), id 0, size=192.
> [   38.887720] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4200
> (60000000), id 0, size=192.
> [   38.887725] xc2028 2-0061: Reading firmware type MONO SCODE
> HAS_IF_4320 (60008000), id 8000, size=192.
> [   38.887730] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4450
> (60000000), id 0, size=192.
> [   38.887734] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4500
> (60000000), id 2000, size=192.
> [   38.887739] xc2028 2-0061: Reading firmware type LCD NOGD IF SCODE
> HAS_IF_4600 (60023000), id 8000, size=192.
> [   38.887744] xc2028 2-0061: Reading firmware type DTV78 ZARLINK456
> SCODE HAS_IF_4760 (62000100), id 0, size=192.
> [   38.887749] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4940
> (60000000), id 0, size=192.
> [   38.887753] xc2028 2-0061: Reading firmware type DTV7 ZARLINK456
> SCODE HAS_IF_5260 (62000080), id 0, size=192.
> [   38.887758] xc2028 2-0061: Reading firmware type MONO SCODE
> HAS_IF_5320 (60008000), id 800000007, size=192.
> [   38.887763] xc2028 2-0061: Reading firmware type DTV8 CHINA SCODE
> HAS_IF_5400 (64000200), id 0, size=192.
> [   38.887768] xc2028 2-0061: Reading firmware type DTV6 ATSC OREN538
> SCODE HAS_IF_5580 (60110020), id 0, size=192.
> [   38.887774] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5640
> (60000000), id 200000007, size=192.
> [   38.887780] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5740
> (60000000), id 800000007, size=192.
> [   38.887785] xc2028 2-0061: Reading firmware type DTV7 DIBCOM52 SCODE
> HAS_IF_5900 (61000080), id 0, size=192.
> [   38.887790] xc2028 2-0061: Reading firmware type MONO SCODE
> HAS_IF_6000 (60008000), id 10, size=192.
> [   38.887795] xc2028 2-0061: Reading firmware type DTV6 QAM F6MHZ SCODE
> HAS_IF_6200 (68000060), id 0, size=192.
> [   38.887800] xc2028 2-0061: Reading firmware type SCODE HAS_IF_6240
> (60000000), id 10, size=192.
> [   38.887805] xc2028 2-0061: Reading firmware type MONO SCODE
> HAS_IF_6320 (60008000), id 200000, size=192.
> [   38.887810] xc2028 2-0061: Reading firmware type SCODE HAS_IF_6340
> (60000000), id 200000, size=192.
> [   38.887815] xc2028 2-0061: Reading firmware type MONO SCODE
> HAS_IF_6500 (60008000), id 4000000, size=192.
> [   38.887820] xc2028 2-0061: Reading firmware type DTV6 ATSC ATI638
> SCODE HAS_IF_6580 (60090020), id 0, size=192.
> [   38.887825] xc2028 2-0061: Reading firmware type SCODE HAS_IF_6600
> (60000000), id 3000000e0, size=192.
> [   38.887830] xc2028 2-0061: Reading firmware type MONO SCODE
> HAS_IF_6680 (60008000), id 3000000e0, size=192.
> [   38.887835] xc2028 2-0061: Reading firmware type DTV6 ATSC TOYOTA794
> SCODE HAS_IF_8140 (60810020), id 0, size=192.
> [   38.887841] xc2028 2-0061: Reading firmware type SCODE HAS_IF_8200
> (60000000), id 0, size=192.
> [   38.887851] xc2028 2-0061: Firmware files loaded.
> [   38.887854] xc2028 2-0061: checking firmware, user requested
> type=F8MHZ MTS (6), id 00000000000000ff, scode_tbl (0), scode_nr 0
> [   38.887878] Unable to handle kernel NULL pointer dereference at
> 00000000000001c4 RIP: 
> [   38.887881]  [<ffffffff8826e839>] :saa7134:saa7134_tuner_callback
> +0x9/0x190
> [   38.887903] PGD 67dc9067 PUD 67b92067 PMD 0 
> [   38.887906] Oops: 0000 [1] SMP 
> [   38.887909] CPU 1 
> [   38.887911] Modules linked in: tuner tea5767 tda8290 tda18271 tda827x
> tuner_xc2028 xc5000 tda9887 tuner_simple tuner_types mt20xx tea5761
> snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy saa7134
> snd_seq_oss xpad compat_ioctl32 videodev v4l1_compat v4l2_common
> videobuf_dma_sg videobuf_core ir_kbd_i2c ide_cd cdrom usbhid
> snd_seq_midi ir_common tveeprom hid parport_pc psmouse snd_rawmidi
> snd_seq_midi_event pcspkr parport snd_seq snd_timer snd_seq_device
> i2c_nforce2 k8temp serio_raw snd soundcore snd_page_alloc i2c_core
> shpchp pci_hotplug evdev ext3 jbd mbcache sg sd_mod amd74xx ide_core
> forcedeth ohci_hcd ata_generic ehci_hcd usbcore sata_nv libata scsi_mod
> thermal processor fan fuse apparmor commoncap
> [   38.887952] Pid: 3934, comm: modprobe Not tainted 2.6.22-14-generic
> #1
> [   38.887955] RIP: 0010:[<ffffffff8826e839>]
> [<ffffffff8826e839>] :saa7134:saa7134_tuner_callback+0x9/0x190
> [   38.887967] RSP: 0018:ffff810066f93a38  EFLAGS: 00010292
> [   38.887970] RAX: 0000000000000007 RBX: 0000000000000001 RCX:
> 0000000000000000
> [   38.887972] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
> 0000000000000000
> [   38.887975] RBP: ffff810066a00000 R08: 0000000000009048 R09:
> 0000000000000007
> [   38.887978] R10: 0000000000000000 R11: 0000000000000001 R12:
> 0000000000000000
> [   38.887981] R13: ffff810066a00078 R14: 0000000000000001 R15:
> 0000000000000001
> [   38.887984] FS:  00002ae9a3ee16e0(0000) GS:ffff8100378e6280(0000)
> knlGS:0000000000000000
> [   38.887988] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   38.887990] CR2: 00000000000001c4 CR3: 0000000068c71000 CR4:
> 00000000000006e0
> [   38.887994] Process modprobe (pid: 3934, threadinfo ffff810066f92000,
> task ffff810066a4c6e0)
> [   38.887996] Stack:  ffff810066a00000 ffffffff8833a803
> ffff810066f93b08 ffff810000000002
> [   38.888004]  ffff810000000007 ffff810065ce8c00 ffff810065ce8e70
> 00000000000000ff
> [   38.888009]  0000000665ce8d70 17d7840000000004 ffff810065ce8c00
> ffff810066a000a0
> [   38.888014] Call Trace:
> [   38.888021]  [<ffffffff8833a803>] :tuner_xc2028:generic_set_freq
> +0x593/0x1830
> [   38.888038]  [<ffffffff802361fe>] printk+0x4e/0x60
> [   38.888053]  [<ffffffff88358a4e>] :tuner:set_tv_freq+0xae/0x1c0
> [   38.888061]  [<ffffffff88358bd1>] :tuner:set_freq+0x71/0x1a0
> [   38.888067]  [<ffffffff88359fe8>] :tuner:tuner_command+0x198/0x12f0
> [   38.888081]  [<ffffffff88177072>] :i2c_core:i2c_clients_command
> +0xa2/0xf0
> [   38.888094]  [<ffffffff88276fc0>] :saa7134:saa7134_video_init2
> +0x10/0x40
> [   38.888104]  [<ffffffff882707bb>] :saa7134:saa7134_initdev
> +0x3fb/0x9a0
> [   38.888110]  [<ffffffff802e8600>] sysfs_make_dirent+0x30/0x50
> [   38.888119]  [<ffffffff803353a1>] pci_device_probe+0xf1/0x170
> [   38.888128]  [<ffffffff80391133>] driver_probe_device+0xa3/0x1b0
> [   38.888134]  [<ffffffff803913f9>] __driver_attach+0xc9/0xd0
> [   38.888139]  [<ffffffff80391330>] __driver_attach+0x0/0xd0
> [   38.888144]  [<ffffffff8039030d>] bus_for_each_dev+0x4d/0x80
> [   38.888152]  [<ffffffff8039076f>] bus_add_driver+0xaf/0x1f0
> [   38.888158]  [<ffffffff80335626>] __pci_register_driver+0x66/0xb0
> [   38.888164]  [<ffffffff80256f1b>] sys_init_module+0x19b/0x19b0
> [   38.888178]  [<ffffffff80326af1>] __up_write+0x21/0x130
> [   38.888189]  [<ffffffff80209e8e>] system_call+0x7e/0x83
> [   38.888197] 
> [   38.888198] 
> [   38.888199] Code: 8b 87 c4 01 00 00 83 f8 36 74 0f 83 f8 47 74 27 b8
> ea ff ff 
> [   38.888208] RIP  [<ffffffff8826e839>] :saa7134:saa7134_tuner_callback
> +0x9/0x190
> [   38.888219]  RSP <ffff810066f93a38>
> [   38.888221] CR2: 00000000000001c4
> [  218.562468] loop: module loaded
> <snip>
> 
> - still no nvidia-glx-new module installed yet
> - again no /dev/video#
> - again no soundcard detected??? -> no volume control
> 
> Now, I will wait, and not install nvidia-glx-new - it could be that
> which destroys GDM at boot, however I will need to install it to watch
> TV, nv is just not up to it.
> 
> I guess that's back to you experts!
> 
> Best Regards,
> Tim

Ok. People, could you please try the enclosed patch? There were some errors at
the callback codes for cx88 and saa7134. I've already tested this with two different
cx88-based xc2028 board (one analog only, and a hybrid board).

Unfortunately, I don't have any saa7134 device that requires a callback.

Hopefully, this patch will fix analog mode, on A16D and the LNA issue for
tda827x, pointed by Hartmut.

Could you please test and give us a feedback?

Cheers,
Mauro.

--

Fixes callback codes for tuners

This patch fixes several issues with callback tuners:
	- Remove the need of specifiying a video device for tuner-xc3028;
	- tda827x now uses the proper parameter for tuner callback (the private 
	  data address for i2c, at i2c_adap->algo_data);
	- xc3028 reusage is check via i2c parent device (i2c_adap->dev)
	- checks if callback first argument is NULL

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

diff -r f24051885fe9 linux/drivers/media/dvb/dvb-usb/cxusb.c
--- a/linux/drivers/media/dvb/dvb-usb/cxusb.c	Tue Mar 18 18:10:06 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/cxusb.c	Thu Mar 20 11:07:02 2008 -0300
@@ -509,7 +509,6 @@ static int cxusb_dvico_xc3028_tuner_atta
 	struct xc2028_config	  cfg = {
 		.i2c_adap  = &adap->dev->i2c_adap,
 		.i2c_addr  = 0x61,
-		.video_dev = adap->dev,
 		.callback  = dvico_bluebird_xc2028_callback,
 	};
 	static struct xc2028_ctrl ctl = {
diff -r f24051885fe9 linux/drivers/media/dvb/frontends/tda827x.c
--- a/linux/drivers/media/dvb/frontends/tda827x.c	Tue Mar 18 18:10:06 2008 -0300
+++ b/linux/drivers/media/dvb/frontends/tda827x.c	Thu Mar 20 11:07:02 2008 -0300
@@ -579,7 +579,8 @@ static void tda827xa_lna_gain(struct dvb
 		else
 			arg = 0;
 		if (priv->cfg->tuner_callback)
-			priv->cfg->tuner_callback(priv, 1, arg);
+			priv->cfg->tuner_callback(priv->i2c_adap->algo_data,
+						  1, arg);
 		buf[1] = high ? 0 : 1;
 		if (*priv->cfg->config == 2)
 			buf[1] = high ? 1 : 0;
@@ -587,7 +588,8 @@ static void tda827xa_lna_gain(struct dvb
 		break;
 	case 3: /* switch with GPIO of saa713x */
 		if (priv->cfg->tuner_callback)
-			priv->cfg->tuner_callback(priv, 0, high);
+			priv->cfg->tuner_callback(priv->i2c_adap->algo_data,
+						  0, high);
 		break;
 	}
 }
diff -r f24051885fe9 linux/drivers/media/video/cx23885/cx23885-dvb.c
--- a/linux/drivers/media/video/cx23885/cx23885-dvb.c	Tue Mar 18 18:10:06 2008 -0300
+++ b/linux/drivers/media/video/cx23885/cx23885-dvb.c	Thu Mar 20 11:07:02 2008 -0300
@@ -298,7 +298,6 @@ static int dvb_register(struct cx23885_t
 			struct xc2028_config cfg = {
 				.i2c_adap  = &i2c_bus->i2c_adap,
 				.i2c_addr  = 0x61,
-				.video_dev = port,
 				.callback  = cx23885_hvr1500_xc3028_callback,
 			};
 			static struct xc2028_ctrl ctl = {
diff -r f24051885fe9 linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c	Tue Mar 18 18:10:06 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Thu Mar 20 11:07:02 2008 -0300
@@ -2140,11 +2140,9 @@ static void gdi_eeprom(struct cx88_core 
 
 /* ------------------------------------------------------------------- */
 /* some Divco specific stuff                                           */
-static int cx88_dvico_xc2028_callback(void *priv, int command, int arg)
+static int cx88_dvico_xc2028_callback(struct cx88_core *core,
+				      int command, int arg)
 {
-	struct i2c_algo_bit_data *i2c_algo = priv;
-	struct cx88_core *core = i2c_algo->data;
-
 	switch (command) {
 	case XC2028_TUNER_RESET:
 		cx_write(MO_GP0_IO, 0x101000);
@@ -2162,11 +2160,9 @@ static int cx88_dvico_xc2028_callback(vo
 /* ----------------------------------------------------------------------- */
 /* some Geniatech specific stuff                                           */
 
-static int cx88_xc3028_geniatech_tuner_callback(void *priv, int command, int mode)
+static int cx88_xc3028_geniatech_tuner_callback(struct cx88_core *core,
+						int command, int mode)
 {
-	struct i2c_algo_bit_data *i2c_algo = priv;
-	struct cx88_core *core = i2c_algo->data;
-
 	switch (command) {
 	case XC2028_TUNER_RESET:
 		switch (INPUT(core->input).type) {
@@ -2193,11 +2189,9 @@ static int cx88_xc3028_geniatech_tuner_c
 
 /* ------------------------------------------------------------------- */
 /* some Divco specific stuff                                           */
-static int cx88_pv_8000gt_callback(void *priv, int command, int arg)
+static int cx88_pv_8000gt_callback(struct cx88_core *core,
+				   int command, int arg)
 {
-	struct i2c_algo_bit_data *i2c_algo = priv;
-	struct cx88_core *core = i2c_algo->data;
-
 	switch (command) {
 	case XC2028_TUNER_RESET:
 		cx_write(MO_GP2_IO, 0xcf7);
@@ -2248,21 +2242,18 @@ static void dvico_fusionhdtv_hybrid_init
 	}
 }
 
-static int cx88_xc2028_tuner_callback(void *priv, int command, int arg)
+static int cx88_xc2028_tuner_callback(struct cx88_core *core, int command, int arg)
 {
-	struct i2c_algo_bit_data *i2c_algo = priv;
-	struct cx88_core *core = i2c_algo->data;
-
 	/* Board-specific callbacks */
 	switch (core->boardnr) {
 	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
 	case CX88_BOARD_POWERCOLOR_REAL_ANGEL:
 	case CX88_BOARD_GENIATECH_X8000_MT:
-		return cx88_xc3028_geniatech_tuner_callback(priv, command, arg);
+		return cx88_xc3028_geniatech_tuner_callback(core, command, arg);
 	case CX88_BOARD_PROLINK_PV_8000GT:
-		return cx88_pv_8000gt_callback(priv, command, arg);
+		return cx88_pv_8000gt_callback(core, command, arg);
 	case CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_PRO:
-		return cx88_dvico_xc2028_callback(priv, command, arg);
+		return cx88_dvico_xc2028_callback(core, command, arg);
 	}
 
 	switch (command) {
@@ -2296,11 +2287,9 @@ static int cx88_xc2028_tuner_callback(vo
  * PCTV HD 800i with an xc5000 sillicon tuner. This is used for both	   *
  * analog tuner attach (tuner-core.c) and dvb tuner attach (cx88-dvb.c)    */
 
-static int cx88_xc5000_tuner_callback(void *priv, int command, int arg)
+static int cx88_xc5000_tuner_callback(struct cx88_core *core,
+				      int command, int arg)
 {
-	struct i2c_algo_bit_data *i2c_algo = priv;
-	struct cx88_core *core = i2c_algo->data;
-
 	switch (core->boardnr) {
 	case CX88_BOARD_PINNACLE_PCTV_HD_800i:
 		if (command == 0) { /* This is the reset command from xc5000 */
@@ -2334,15 +2323,27 @@ int cx88_tuner_callback(void *priv, int 
 int cx88_tuner_callback(void *priv, int command, int arg)
 {
 	struct i2c_algo_bit_data *i2c_algo = priv;
-	struct cx88_core *core = i2c_algo->data;
+	struct cx88_core *core;
+
+	if (!i2c_algo) {
+		printk(KERN_ERR "cx88: Error - i2c_algo not defined.\n");
+		return -EINVAL;
+	}
+
+	core = i2c_algo->data;
+
+	if (!core) {
+		printk(KERN_ERR "cx88: Error - device pointer is NULL!\n");
+		return -EINVAL;
+	}
 
 	switch (core->board.tuner_type) {
 		case TUNER_XC2028:
 			info_printk(core, "Calling XC2028/3028 callback\n");
-			return cx88_xc2028_tuner_callback(priv, command, arg);
+			return cx88_xc2028_tuner_callback(core, command, arg);
 		case TUNER_XC5000:
 			info_printk(core, "Calling XC5000 callback\n");
-			return cx88_xc5000_tuner_callback(priv, command, arg);
+			return cx88_xc5000_tuner_callback(core, command, arg);
 	}
 	err_printk(core, "Error: Calling callback for tuner %d\n",
 		   core->board.tuner_type);
diff -r f24051885fe9 linux/drivers/media/video/cx88/cx88-dvb.c
--- a/linux/drivers/media/video/cx88/cx88-dvb.c	Tue Mar 18 18:10:06 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c	Thu Mar 20 11:07:02 2008 -0300
@@ -465,7 +465,6 @@ static int attach_xc3028(u8 addr, struct
 	struct xc2028_config cfg = {
 		.i2c_adap  = &dev->core->i2c_adap,
 		.i2c_addr  = addr,
-		.video_dev = dev->core->i2c_adap.algo_data,
 	};
 
 	if (!dev->dvb.frontend) {
@@ -787,7 +786,6 @@ static int dvb_register(struct cx8802_de
 			struct xc2028_config cfg = {
 				.i2c_adap  = &dev->core->i2c_adap,
 				.i2c_addr  = 0x61,
-				.video_dev = dev->core,
 				.callback  = cx88_pci_nano_callback,
 			};
 			static struct xc2028_ctrl ctl = {
diff -r f24051885fe9 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Mar 18 18:10:06 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Mar 20 11:07:02 2008 -0300
@@ -5353,10 +5353,15 @@ static int saa7134_tda8290_callback(stru
 	return 0;
 }
 
+/* priv retuns algo_data - on saa7134, it is equal to dev */
 int saa7134_tuner_callback(void *priv, int command, int arg)
 {
-	struct i2c_algo_bit_data *i2c_algo = priv;
-	struct saa7134_dev *dev = i2c_algo->data;
+	struct saa7134_dev *dev = priv;
+
+	if (!dev) {
+		printk(KERN_ERR "saa7134: Error: device pointer is NULL!\n");
+		return -EINVAL;
+	}
 
 	switch (dev->tuner_type) {
 	case TUNER_PHILIPS_TDA8290:
diff -r f24051885fe9 linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Tue Mar 18 18:10:06 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Thu Mar 20 11:07:02 2008 -0300
@@ -1173,7 +1173,6 @@ static int dvb_init(struct saa7134_dev *
 		struct xc2028_config cfg = {
 			.i2c_adap  = &dev->i2c_adap,
 			.i2c_addr  = 0x61,
-			.video_dev = dev->i2c_adap.algo_data,
 		};
 		fe = dvb_attach(xc2028_attach, dev->dvb.frontend, &cfg);
 		if (!fe) {
diff -r f24051885fe9 linux/drivers/media/video/tuner-core.c
--- a/linux/drivers/media/video/tuner-core.c	Tue Mar 18 18:10:06 2008 -0300
+++ b/linux/drivers/media/video/tuner-core.c	Thu Mar 20 11:07:02 2008 -0300
@@ -448,7 +448,6 @@ static void set_type(struct i2c_client *
 		struct xc2028_config cfg = {
 			.i2c_adap  = t->i2c->adapter,
 			.i2c_addr  = t->i2c->addr,
-			.video_dev = c->adapter->algo_data,
 			.callback  = t->tuner_callback,
 		};
 		if (!xc2028_attach(&t->fe, &cfg)) {
diff -r f24051885fe9 linux/drivers/media/video/tuner-xc2028.c
--- a/linux/drivers/media/video/tuner-xc2028.c	Tue Mar 18 18:10:06 2008 -0300
+++ b/linux/drivers/media/video/tuner-xc2028.c	Thu Mar 20 11:07:02 2008 -0300
@@ -1174,7 +1174,7 @@ struct dvb_frontend *xc2028_attach(struc
 	if (debug)
 		printk(KERN_DEBUG "xc2028: Xcv2028/3028 init called!\n");
 
-	if (NULL == cfg || NULL == cfg->video_dev)
+	if (NULL == cfg)
 		return NULL;
 
 	if (!fe) {
@@ -1182,13 +1182,19 @@ struct dvb_frontend *xc2028_attach(struc
 		return NULL;
 	}
 
-	video_dev = cfg->video_dev;
+	video_dev = cfg->i2c_adap->algo_data;
+
+	if (debug)
+		printk(KERN_DEBUG "xc2028: video_dev =%p\n", video_dev);
 
 	mutex_lock(&xc2028_list_mutex);
 
 	list_for_each_entry(priv, &xc2028_list, xc2028_list) {
-		if (priv->video_dev == cfg->video_dev) {
+		if (&priv->i2c_props.adap->dev == &cfg->i2c_adap->dev) {
 			video_dev = NULL;
+			if (debug)
+				printk(KERN_DEBUG "xc2028: reusing device\n");
+
 			break;
 		}
 	}
@@ -1216,6 +1222,9 @@ struct dvb_frontend *xc2028_attach(struc
 	fe->tuner_priv = priv;
 	priv->count++;
 
+	if (debug)
+		printk(KERN_DEBUG "xc2028: usage count is %i\n", priv->count);
+
 	memcpy(&fe->ops.tuner_ops, &xc2028_dvb_tuner_ops,
 	       sizeof(xc2028_dvb_tuner_ops));
 





Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
