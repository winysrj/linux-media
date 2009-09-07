Return-path: <linux-media-owner@vger.kernel.org>
Received: from ip78-183-211-87.adsl2.static.versatel.nl ([87.211.183.78]:59931
	"EHLO god.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbZIGPS3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 11:18:29 -0400
Date: Mon, 7 Sep 2009 17:18:09 +0200
From: spam@systol-ng.god.lan
To: Michael Krufky <mkrufky@gmail.com>
Cc: linux-dvd@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] Add support for Zolid Hybrid PCI card
Message-ID: <20090907151809.GA12556@systol-ng.god.lan>
References: <13c90c570909070123r2ba1f5f6w2b288703f5e98738@mail.gmail.com> <13c90c570909070127j11ae6ee2w2aa677529096f820@mail.gmail.com> <20090907124934.GA8339@systol-ng.god.lan> <37219a840909070718q47890f5bgbf76a00ea8826880@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <37219a840909070718q47890f5bgbf76a00ea8826880@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 07, 2009 at 10:18:46AM -0400, Michael Krufky wrote:
> >
> > This patch adds support for Zolid Hybrid TV card. The results are
> > pretty encouraging DVB reception and analog TV reception are confirmed
> > to work. Might still need to find the GPIO pin that switches AGC on
> > the TDA18271 for even better reception.
> >
> > see:
> > http://linuxtv.org/wiki/index.php/Zolid_Hybrid_TV_Tuner
> > for more information.
> >
> > Signed-off-by: Henk.Vergonet@gmail.com
> >
> >
> 
> Henk, thanks for your contribution, but this patch has problems.  This
> should NOT be merged as it is here.  Please see below:

Thanks for the review.

> 
> #1) It's just a copy of the HVR1120 configuration.  There tuner_config
> = 3 value is definitely wrong for your board.  To prove my point,
> notice that you added a case for your board to the switch..case block
> in saa7134_tda8290_callback.  This will cause
> saa7134_tda8290_18271_callback to get called, then the default case
> will do nothing and the entire thing was a no-op.
> 
> The correct value for your board for tuner_config is 0.  Always try
> the defaults before blindly copying somebody else's configuration.
 
You're right, changed tuner_config to zero.

> #2) Card description reads, "NXP Europa DVB-T hybrid reference design"
> but the card ID is SAA7134_BOARD_ZOLID_HYBRID_PCI.  I suggest to pick
> one name for the sake of clarity, specifically, the actual board name.
>  Feel free to indicate that it is based on a reference design in
> comments.
> 
Fair enough.

> #3) The change in saa7134-dvb will prevent an HVR1120 and your Zolid
> board from working together in the same PC.  Please create a new case
> block for the Zolid board, and create a new configuration structure
> for the tda10048 -- do not edit the value of static structures
> on-the-fly, and dont alter configuration of cards other than that of
> the board that you are adding today.

Ok I was assuming configuration parameters get copied in the tuner
state.

> 
> #4) Does your card have a saa7131 on it or some other saa713x variant?
> Is there actually a tda8290 present on the board?  Does the
> tda8290_attach function sucess or fail?  Please send in a dmesg
> snippit of the board functioning with your next patch.
> 
Well the chip is labeled as SAA7131E/03/G, according to the NXP docs its a
SAA7135 combined with a TDA8295 analog IF demod.

dmesg is attached below.

> #5)  Aren't there multiple versions of this board using different
> steppings of the tda18271 tuner?  This I am not sure of, but I do
> recall having issues bringing up the Zolid board months ago -- is this
> actually working for you?

Well all the references on the net refer to a tda18271/C2 version.

I have tested dvb reception just now, with a good antenna, and it works
get good audio and video. I still need to test analog reception. 

Also I assume selectivity can be better as I assume the V_AGC pin of
the TDA18271 is connected to some GPIO pin.

> 
> After you resubmit a cleaned up patch, we should see if anybody else
> out there can test this for you.  A dmesg snippit of the board's
> driver output would be nice.
> 
> Cheers,
> 
> Mike

Can you take a peek at the improved patch below?


dmesg:
[280156.190062] saa7130/34: v4l2 driver version 0.2.15 loaded
[280156.190234] saa7133[0]: found at 0000:04:00.0, rev: 209, irq: 16, latency: 64, mmio: 0xfebff800
[280156.190271] saa7133[0]: subsystem: 1131:2004, board: Zolid Hybrid TV Tuner PCI [card=173,autodetected]
[280156.190445] saa7133[0]: board init: gpio is 400100
[280156.190481] IRQ 16/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[280156.372530] saa7133[0]: i2c eeprom 00: 31 11 04 20 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[280156.372579] saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff
[280156.372622] saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 b2 ff ff ff ff
[280156.372664] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[280156.372715] saa7133[0]: i2c eeprom 40: ff 35 00 c0 96 10 03 32 21 05 ff ff ff ff ff ff
[280156.372758] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[280156.372800] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[280156.372842] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[280156.372885] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[280156.372927] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[280156.372969] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[280156.373012] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[280156.373054] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[280156.373097] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[280156.373139] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[280156.373181] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[280156.373229] i2c-adapter i2c-3: Invalid 7-bit address 0x7a
[280156.500405] tuner 3-004b: chip found @ 0x96 (saa7133[0])
[280156.660034] tda829x 3-004b: setting tuner address to 60
[280156.738826] tda18271 3-0060: creating new instance
[280156.820031] TDA18271HD/C2 detected @ 3-0060
[280159.210047] tda18271: performing RF tracking filter calibration
[280192.310026] tda18271: RF tracking filter calibration complete
[280192.420033] tda829x 3-004b: type set to tda8290+18271
[280200.470374] saa7133[0]: dsp access error
[280200.602731] saa7133[0]: registered device video0 [v4l2]
[280200.602842] saa7133[0]: registered device vbi0
[280200.602945] saa7133[0]: registered device radio0
[280200.659811] dvb_init() allocating 1 frontend
[280200.920034] tda829x 3-004b: type set to tda8290
[280200.960408] tda18271 3-0060: attaching existing instance
[280200.960426] DVB: registering new adapter (saa7133[0])
[280200.960440] DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
[280201.780031] tda10048_firmware_upload: waiting for firmware upload (dvb-fe-tda10048-1.0.fw)...
[280201.780054] saa7134 0000:04:00.0: firmware: requesting dvb-fe-tda10048-1.0.fw
[280201.794323] tda10048_firmware_upload: firmware read 24878 bytes.
[280201.794342] tda10048_firmware_upload: firmware uploading
[280207.010051] tda10048_firmware_upload: firmware uploaded
[280207.404727] saa7134 ALSA driver for DMA sound loaded
[280207.404763] IRQ 16/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[280207.404812] saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 16 registered as card -1

Here's a new patch:

--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="Zolid_Hybrid_PCI_take2.patch"

diff -r 2b49813f8482 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Sep 03 09:06:34 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon Sep 07 16:55:32 2009 +0200
@@ -3521,6 +3521,35 @@
 			.gpio = 0x0800100, /* GPIO 23 HI for FM */
 		},
 	},
+	[SAA7134_BOARD_ZOLID_HYBRID_PCI] = {
+		.name           = "Zolid Hybrid TV Tuner PCI",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tuner_config   = 0,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.ts_type	= SAA7134_MPEG_TS_PARALLEL,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.tv   = 1,
+		}, {
+			.name = name_comp1,
+			.vmux = 0,
+			.amux = LINE1,
+		}, {
+			.name = name_svideo,
+			.vmux = 6,
+			.amux = LINE1,
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+		},
+	},
 	[SAA7134_BOARD_CINERGY_HT_PCMCIA] = {
 		.name           = "Terratec Cinergy HT PCMCIA",
 		.audio_clock    = 0x00187de7,
@@ -6429,6 +6458,12 @@
 		.subdevice    = 0x0138, /* LifeView FlyTV Prime30 OEM */
 		.driver_data  = SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM,
 	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = PCI_VENDOR_ID_PHILIPS,
+		.subdevice    = 0x2004,
+		.driver_data  = SAA7134_BOARD_ZOLID_HYBRID_PCI,
+	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
diff -r 2b49813f8482 linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Thu Sep 03 09:06:34 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Mon Sep 07 16:55:32 2009 +0200
@@ -1013,6 +1013,18 @@
 	.probe_tuner = TDA829X_DONT_PROBE,
 };
 
+static struct tda10048_config zolid_tda10048_config = {
+	.demod_address    = 0x10 >> 1,
+	.output_mode      = TDA10048_PARALLEL_OUTPUT,
+	.fwbulkwritelen   = TDA10048_BULKWRITE_200,
+	.inversion        = TDA10048_INVERSION_ON,
+	.dtv6_if_freq_khz = TDA10048_IF_3300,
+	.dtv7_if_freq_khz = TDA10048_IF_3500,
+	.dtv8_if_freq_khz = TDA10048_IF_4000,
+	.clk_freq_khz     = TDA10048_CLK_16000,
+	.disable_gate_access = 1,
+};
+
 /* ==================================================================
  * Core code
  */
@@ -1124,6 +1136,19 @@
 					 &tda827x_cfg_2) < 0)
 			goto dettach_frontend;
 		break;
+	case SAA7134_BOARD_ZOLID_HYBRID_PCI:
+		fe0->dvb.frontend = dvb_attach(tda10048_attach,
+					       &zolid_tda10048_config,
+					       &dev->i2c_adap);
+		if (fe0->dvb.frontend != NULL) {
+			dvb_attach(tda829x_attach, fe0->dvb.frontend,
+				   &dev->i2c_adap, 0x4b,
+				   &tda829x_no_probe);
+			dvb_attach(tda18271_attach, fe0->dvb.frontend,
+				   0x60, &dev->i2c_adap,
+				   &hcw_tda18271_config);
+		}
+		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1120:
 		fe0->dvb.frontend = dvb_attach(tda10048_attach,
 					       &hcw_tda10048_config,
diff -r 2b49813f8482 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Thu Sep 03 09:06:34 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Mon Sep 07 16:55:32 2009 +0200
@@ -297,6 +297,7 @@
 #define SAA7134_BOARD_AVERMEDIA_STUDIO_505  170
 #define SAA7134_BOARD_BEHOLD_X7             171
 #define SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM 172
+#define SAA7134_BOARD_ZOLID_HYBRID_PCI		173
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8

--cNdxnHkX5QqsyA0e--
