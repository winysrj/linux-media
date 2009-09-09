Return-path: <linux-media-owner@vger.kernel.org>
Received: from ip78-183-211-87.adsl2.static.versatel.nl ([87.211.183.78]:57701
	"EHLO god.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZIIGHR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2009 02:07:17 -0400
Date: Wed, 9 Sep 2009 08:06:58 +0200
From: spam@systol-ng.god.lan
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: Henk.Vergonet@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] Add support for Zolid Hybrid PCI card
Message-ID: <20090909060658.GA23473@systol-ng.god.lan>
References: <13c90c570909070123r2ba1f5f6w2b288703f5e98738@mail.gmail.com> <13c90c570909070127j11ae6ee2w2aa677529096f820@mail.gmail.com> <20090907124934.GA8339@systol-ng.god.lan> <37219a840909070718q47890f5bgbf76a00ea8826880@mail.gmail.com> <20090907151809.GA12556@systol-ng.god.lan> <37219a840909070912h3678fb2cm94102d7437bec5df@mail.gmail.com> <20090908212733.GA19438@systol-ng.god.lan> <37219a840909081457u610b9c65le6141e79567ab629@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <37219a840909081457u610b9c65le6141e79567ab629@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 08, 2009 at 05:57:12PM -0400, Michael Krufky wrote:
> >
> > Hi Mike,
> >
> 
> Henk,
> 
> Why do you expect a 8295?  If your board uses the SAA7131, then we
> would expect an 8290 IF demod.
> 
> Ah, I just checked the history of this email thread -- I must have
> read one of your previous emails too quickly.  :-)  Perhaps there is a
> typo in the document that you read -- tda8290 is correct.
> 
> About the analog noise and quality issues that you report, perhaps
> there is some tweaking that can be done to help the situation.  I dont
> have that Zolid board, myself, so I can't reallt help much in that
> respect, unfortunately.
> 
> At this point, I feel that your patch is fine to merge into the
> development repository, although I have some small cleanup requests:
> 
> #1)  You can omit this line from the tda18271_config struct:
> 
> .config  = 0,	/* no AGC config */
> 
> This is not necessary, as it is initialized at zero and this serves no
> purpose even for documentation's sake.
> 
> #2) The configuration inside saa7134-cards.c should be moved to the
> end of the boards array.
> 
> #3) The configuration case inside saa7134-dvb.c should be moved to the
> end of the switch..case block.
> 
> I'll wait for these cleanups, then I have no issue pushing up your
> patch.  Any quality improvements that we find along the way can
> certainly be added afterwards.
> 
> Good work.
> 
> Regards,
> 
> Mike

Hi Mike,

Did the last cleanups.
Good review! Thank you for your help.

- henk

----- patch comment -----

Adds support for Zolid Hybrid PCI card:
http://linuxtv.org/wiki/index.php/Zolid_Hybrid_TV_Tuner

test status analog (PAL-B):
- Sometimes picture is noisy, but it becomes crystal clear after
  switching between channels. (happens for example at 687.25 Mhz)
- On a lower frequency (511.25 Mhz) the picture is always sharp, but
  lacks colour.
- No sound problems.
- radio untested.

Digital:
- DVB-T/H stream reception works.
- Would expect to see some more channels in the higher frequency region.

Overall is the impression that sensitivity still needs improvement
both in analog and digital modes.

Signed-off-by: Henk.Vergonet@gmail.com


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="Zolid_Hybrid_PCI_take4.patch"

diff -r 2b49813f8482 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Sep 03 09:06:34 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Wed Sep 09 07:47:10 2009 +0200
@@ -5296,6 +5296,27 @@
 			.amux = TV,
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
+		}},
+		.radio = {	// untested
+			.name = name_radio,
+			.amux = TV,
+		},
+	},
 
 };
 
@@ -6429,6 +6450,12 @@
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
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Wed Sep 09 07:47:10 2009 +0200
@@ -1013,6 +1013,22 @@
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
+static struct tda18271_config zolid_tda18271_config = {
+	.gate    = TDA18271_GATE_ANALOG,
+};
+
 /* ==================================================================
  * Core code
  */
@@ -1492,6 +1508,19 @@
 					__func__);
 
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
+				   &zolid_tda18271_config);
+		}
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;
diff -r 2b49813f8482 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Thu Sep 03 09:06:34 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Wed Sep 09 07:47:10 2009 +0200
@@ -297,6 +297,7 @@
 #define SAA7134_BOARD_AVERMEDIA_STUDIO_505  170
 #define SAA7134_BOARD_BEHOLD_X7             171
 #define SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM 172
+#define SAA7134_BOARD_ZOLID_HYBRID_PCI		173
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8

--vkogqOf2sHV7VnPd--
