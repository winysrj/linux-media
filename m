Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1KZtvz-00039t-89
	for linux-dvb@linuxtv.org; Sun, 31 Aug 2008 22:54:17 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: "Michael J. Curtis" <michael.curtis@glcweb.co.uk>
In-Reply-To: <3C276393607085468A28782D978BA5EE71D2BA8176@w2k8svr1.glcdomain8.local>
References: <3C276393607085468A28782D978BA5EE71D2BA8176@w2k8svr1.glcdomain8.local>
Date: Sun, 31 Aug 2008 22:52:13 +0200
Message-Id: <1220215933.2669.46.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Compro S350/S300 Tuner
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

Hi Michael,

Am Sonntag, den 31.08.2008, 14:17 +0100 schrieb Michael J. Curtis:
> Hi all
> 
> Has anyone discovered the tuner for the above?
> 
> Is there anyone that has got this card to work?
> 
> Seems like the card is correctly identified but the tuner is not?
> 
> ACPI: PCI Interrupt 0000:02:07.0[A] -> Link [APC2] -> GSI 17 (level, low) -> IRQ 17
> saa7134[0]: found at 0000:02:07.0, rev: 1, irq: 17, latency: 84, mmio: 0xfdffe000
> saa7134[0]: subsystem: 185b:c900, board: Compro Videomate DVB-T300 [card=70,autodetected]
> saa7134[0]: board init: gpio is 843f00
> input: saa7134 IR (Compro Videomate DV as /class/input/input6
> saa7134[0]: i2c eeprom 00: 5b 18 00 c9 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> saa7134[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 20: 01 40 01 02 02 01 03 01 08 ff 00 87 ff ff ff ff
> saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 40: ff d6 00 c0 86 1c 02 01 02 ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff cb
> saa7134[0]: i2c eeprom 60: 35 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 70: 00 00 00 00 4f e7 ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> tuner' 2-0068: chip found @ 0xd0 (saa7134[0])

The Compro cards all have a micro controller at 0xd0, but that is not
the tuner.

> tuner' 2-0068: tuner type not set
> tuner' 2-0068: tuner type not set
> saa7134[0]: registered device video0 [v4l2]
> saa7134[0]: registered device vbi0
> 

hardly have time to read all the mails currently, but one thing is
already discovered on your above post.

We have another case, where the PCI subsystem for Compro cards is not
reliable for autodetection and ambiguous stuff made it already in again.

		.vendor       = PCI_VENDOR_ID_PHILIPS,
		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
		.subvendor    = 0x185b,
		.subdevice    = 0xc900,
		.driver_data  = SAA7134_BOARD_VIDEOMATE_DVBT_300,
	},{

		.vendor       = PCI_VENDOR_ID_PHILIPS,
		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
		.subvendor    = 0x185b,
		.subdevice    = 0xc900,
		.driver_data  = SAA7134_BOARD_VIDEOMATE_T750,
	}, {

For some other Compro cards we have introduced eeprom detection to sort
them, but it is getting annoying.

The detected card is an hybrid DVB-T card and the analog tuner is hard
coded at 0x61, also has an analog tda9887 IF demod at 0x86/0x43.

	[SAA7134_BOARD_VIDEOMATE_DVBT_300] = {
		.name           = "Compro Videomate DVB-T300",
		.audio_clock    = 0x00187de7,
		.tuner_type     = TUNER_PHILIPS_TD1316,
		.radio_type     = UNSET,
		.tuner_addr	= 0x61,
		.radio_addr	= ADDR_UNSET,
		.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE,
		.mpeg           = SAA7134_MPEG_DVB,
		.inputs = {{
			.name   = name_tv,
			.vmux   = 3,
			.amux   = TV,
			.tv     = 1,
		},{
			.name   = name_comp1,
			.vmux   = 1,
			.amux   = LINE2,
		},{
			.name   = name_svideo,
			.vmux   = 8,
			.amux   = LINE2,
		}},
	},


The tuner also only becomes visible if the i2c bridge of the digital
demod (tda10046 at 0x10/0x08) is open.


	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
	case SAA7134_BOARD_ASUS_EUROPA2_HYBRID:
	{

		/* The Philips EUROPA based hybrid boards have the tuner connected through
		 * the channel decoder. We have to make it transparent to find it
		 */
		u8 data[] = { 0x07, 0x02};
		struct i2c_msg msg = {.addr=0x08, .flags=0, .buf=data, .len = sizeof(data)};
		i2c_transfer(&dev->i2c_adap, &msg, 1);

		break;
	}

You are talking about Compro S350/S300 and these are different cards For
DVB-S and not DVB-T.
http://www.comprousa.com/en/product/s300/s300.html

You seem to have the tuner at 0xc0/0x60 and the demod at 0x1c/0x0e.

That would be the same like on card=96, the dual triple CTX944 and the
single triple CTX948 in DVB-S mode.

To force DVB-S you need "options saa7134-dvb use_frontend=1" or modprobe
saa7134-dvb accordingly. ("modinfo saa7134-dvb")

You should of course at first load the saa7134 with i2c_scan=1 and see
if at least a tda10086 demod is visible on it.

Your card has the same PCI subsystem than the Compro DVBT_300, even gpio
init is the same, but eeprom differs for tuner and demod.

The S300 was already seen here, need to crawl through the archives.

Good Luck,

Hermann




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
