Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+0af2e7848fb42186027e+1672+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1Jd5Ch-0006Wq-Bb
	for linux-dvb@linuxtv.org; Sat, 22 Mar 2008 16:00:15 +0100
Date: Sat, 22 Mar 2008 11:59:25 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Richard (MQ)" <osl2008@googlemail.com>
Message-ID: <20080322115925.69cc5b38@gaivota>
In-Reply-To: <47E51CBD.1000906@googlemail.com>
References: <47A5D8AF.2090800@googlemail.com> <47AB6A1B.5090100@googlemail.com>
	<20080207184221.1ea8e823@gaivota> <47ACA9AA.4090702@googlemail.com>
	<47AE20BD.7090503@googlemail.com> <20080212124734.62cd451d@gaivota>
	<47B1E22D.4090901@googlemail.com> <20080313114633.494bc7b1@gaivota>
	<1205457408.6358.5.camel@ubuntu> <20080314121423.670f31a0@gaivota>
	<1205518856.6094.14.camel@ubuntu> <20080314155851.52677f28@gaivota>
	<1205523274.6364.5.camel@ubuntu> <20080314172143.62390b1f@gaivota>
	<1205573636.5941.1.camel@ubuntu> <20080318103044.4363fefd@gaivota>
	<1205864312.11231.11.camel@ubuntu>
	<20080318161729.6da782ee@gaivota>
	<1205873332.11231.17.camel@ubuntu>
	<20080318180415.5dfc4319@gaivota>
	<1205875868.3385.133.camel@pc08.localdom.local>
	<1205904196.6510.3.camel@ubuntu> <20080320115531.7ab450ba@gaivota>
	<1206030503.5997.2.camel@ubuntu> <20080320140715.4204ec78@gaivota>
	<20080322083435.2432256b@gaivota> <47E51CBD.1000906@googlemail.com>
Mime-Version: 1.0
Cc: Hackmann <hartmut.hackmann@t-online.de>,
	"Richard \(MQ\)" <osl2008@googlemail.com>, linux-dvb@linuxtv.org,
	lucarasp <lucarasp@inwind.it>
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

On Sat, 22 Mar 2008 14:50:37 +0000
"Richard (MQ)" <osl2008@googlemail.com> wrote:

> Hi again all,
> 
> Mauro Carvalho Chehab wrote:
> ...
> > Ok, the patch that fixed the callbacks were already applied.
> > 
> > For DVB to work, the demod needs to be initialized. From what I saw on
> > bttv-gallery, this board uses an mt352 demod. Hopefully, it will use the same
> > code as AV A16AR.
> > 
> > I'm enclosing an experimental patch that will enable DVB support for this
> > board. Please test. 
> 
> Finally I have the A16D card in a working box, running OpenSuSE 10.3
> FWIW (kernel 2.6.22.17). Sorry it took so long...
> 
> Starting from a virgin system (that is, current OpenSuSE rather than
> vanilla) I did an hg clone followed by make, no errors. Next I took the
> v27 firmware from your mail of 21st and then su -c "make install". Still
> no errors, but it didn't work.
> 
> Next I added the patches mentioned above, one line was already present
> ("+	case SAA7134_BOARD_AVERMEDIA_A16D:" after line 5512) but they went
> in with no other errors. Again, make was successful so installed and
> re-booted.
> 
> dmesg extract follows:
> 
> > saa7130/34: v4l2 driver version 0.2.14 loaded
> > ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
> > PCI: setting IRQ 10 as level-triggered
> > ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
> > saa7133[0]: found at 0000:00:0a.0, rev: 209, irq: 10, latency: 32, mmio: 0xea002000
> > saa7133[0]: subsystem: 1461:f936, board: AVerMedia Hybrid TV/Radio (A16D) [card=137,autodetected]
> > saa7133[0]: board init: gpio is 32fa00
> > saa7133[0]: i2c eeprom 00: 61 14 36 f9 00 00 00 00 00 00 00 00 00 00 00 00
> > saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff ff ff ff ff ff ff
> > saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 00 08 ff 00 0e ff ff ff ff
> > saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[0]: i2c eeprom 40: ff 65 00 ff c2 1e ff ff ff ff ff ff ff ff ff ff
> > saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > tuner' 0-0061: chip found @ 0xc2 (saa7133[0])
> > xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
> > xc2028 0-0061: xc2028/3028 firmware name not set!
> ...
> > xc2028 0-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
> > xc2028 0-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
> > (0), id 00000000000000ff:
> > xc2028 0-0061: Loading firmware for type=(0), id 0000000100000007.
> > SCODE (20000000), id 0000000100000007:
> > xc2028 0-0061: Loading SCODE for type=SCODE HAS_IF_5640 (60000000), id 0000000200000007.
> > xc2028 0-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
> > xc2028 0-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
> > saa7133[0]: registered device video0 [v4l2]
> > saa7133[0]: registered device vbi0
> > saa7133[0]: registered device radio0
> > ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
> > ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
> 
> 
> So far so good, but nothing in /dev/dvb.
> 
> I read the correspondence with timf, don't think I missed anything?
> 
> I'd be very interested in your comments

Hmm... I missed to add a small line at board description:
		.mpeg           = SAA7134_MPEG_DVB,

Ok, patch updated.

Richard,

Do you have analog channels on your area? If so, could you also test analog mode?

Cheers,
Mauro.

----

saa7134: Add DTV support for Avermedia A16D

From: Mauro Carvalho Chehab <mchehab@infradead.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

---
 linux/drivers/media/video/saa7134/saa7134-cards.c |   13 ++++++++++---
 linux/drivers/media/video/saa7134/saa7134-dvb.c   |    6 ++++++
 2 files changed, 16 insertions(+), 3 deletions(-)

--- master.orig/linux/drivers/media/video/saa7134/saa7134-cards.c
+++ master/linux/drivers/media/video/saa7134/saa7134-cards.c
@@ -4142,6 +4142,7 @@ struct saa7134_board saa7134_boards[] = 
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
+		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
 			.name = name_tv,
 			.vmux = 1,
@@ -5512,6 +5513,7 @@ int saa7134_board_init1(struct saa7134_d
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
 	case SAA7134_BOARD_AVERMEDIA_M115:
 	case SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM:
+	case SAA7134_BOARD_AVERMEDIA_A16D:
 		/* power-up tuner chip */
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0xffffffff, 0xffffffff);
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0xffffffff, 0xffffffff);
@@ -5808,9 +5810,14 @@ int saa7134_board_init2(struct saa7134_d
 		ctl.fname   = XC2028_DEFAULT_FIRMWARE;
 		ctl.max_len = 64;
 
-		/* FIXME: This should be device-dependent */
-		ctl.demod = XC3028_FE_OREN538;
-		ctl.mts = 1;
+		switch (dev->board) {
+		case SAA7134_BOARD_AVERMEDIA_A16D:
+			ctl.demod = XC3028_FE_ZARLINK456;
+			break;
+		default:
+			ctl.demod = XC3028_FE_OREN538;
+			ctl.mts = 1;
+		}
 
 		xc2028_cfg.tuner = TUNER_XC2028;
 		xc2028_cfg.priv  = &ctl;
--- master.orig/linux/drivers/media/video/saa7134/saa7134-dvb.c
+++ master/linux/drivers/media/video/saa7134/saa7134-dvb.c
@@ -936,6 +936,12 @@ static int dvb_init(struct saa7134_dev *
 				   NULL, DVB_PLL_PHILIPS_TD1316);
 		}
 		break;
+	case SAA7134_BOARD_AVERMEDIA_A16D:
+		dprintk("avertv A16D dvb setup\n");
+		dev->dvb.frontend = dvb_attach(mt352_attach, &avermedia_777,
+					       &dev->i2c_adap);
+		attach_xc3028 = 1;
+		break;
 	case SAA7134_BOARD_MD7134:
 		dev->dvb.frontend = dvb_attach(tda10046_attach,
 					       &medion_cardbus,


Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
