Return-path: <linux-media-owner@vger.kernel.org>
Received: from ip78-183-211-87.adsl2.static.versatel.nl ([87.211.183.78]:51370
	"EHLO god.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbZIHV1x (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Sep 2009 17:27:53 -0400
Date: Tue, 8 Sep 2009 23:27:33 +0200
From: spam@systol-ng.god.lan
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: Henk <henk.vergonet@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Add support for Zolid Hybrid PCI card
Message-ID: <20090908212733.GA19438@systol-ng.god.lan>
Reply-To: Henk.Vergonet@gmail.com
References: <13c90c570909070123r2ba1f5f6w2b288703f5e98738@mail.gmail.com> <13c90c570909070127j11ae6ee2w2aa677529096f820@mail.gmail.com> <20090907124934.GA8339@systol-ng.god.lan> <37219a840909070718q47890f5bgbf76a00ea8826880@mail.gmail.com> <20090907151809.GA12556@systol-ng.god.lan> <37219a840909070912h3678fb2cm94102d7437bec5df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <37219a840909070912h3678fb2cm94102d7437bec5df@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 07, 2009 at 12:12:15PM -0400, Michael Krufky wrote:
> Henk,
> 
> Something is up with your mailer, making it difficult to reply to your
> emails.... going to some spam account instead of your email address...
> Please look into that, maybe set up a reply-to or something.
> 
> Anyway, thanks for your responses -- that clears a lot up.  I
> recommend to also create your own tda18271 config structure, as I have
> a pending pull request that will tweak the tda18271 configuration
> within that hcw_tda18271_config structure -- Id hate for your board to
> break as a result of using somebody else's config.
> 
> About the SAA7131 - correct -- it is a SAA713x combined with a TDA8295
> analog IF demod.  I was just checking to see that it was actually what
> your board uses.  Looks good to me.
> 
> As far as the analog input setup, have you verified that those work
> properly, or did you also copy those from the HVR1120 configuration?
> If you havent verified those yourself, I recommend removing them from
> your patch -- better to not check in untested configurations, as it
> may lead others to believe that it should work, causing support
> problems for the future.
> 
> After you re-submit with the above recommended changes, I'll be happy
> to push the patch for you.
> 
> Regards,
> 
> Mike

Hi Mike,

I tested the analog part (PAL-B), sound and picture work but with
some issues:

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

If you look at the dmesg, analog tuner is detected as 8290 instead of
the expected 8295 could this be a problem?
>> [280192.420033] tda829x 3-004b: type set to tda8290+18271


For information on the card see:
http://linuxtv.org/wiki/index.php/Zolid_Hybrid_TV_Tuner

Signed-off-by: Henk.Vergonet@gmail.com


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="Zolid_Hybrid_PCI_take3.patch"

diff -r 2b49813f8482 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Sep 03 09:06:34 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Sep 08 00:32:02 2009 +0200
@@ -3521,6 +3521,27 @@
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
+		}},
+		.radio = {	// untested
+			.name = name_radio,
+			.amux = TV,
+		},
+	},
 	[SAA7134_BOARD_CINERGY_HT_PCMCIA] = {
 		.name           = "Terratec Cinergy HT PCMCIA",
 		.audio_clock    = 0x00187de7,
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
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Tue Sep 08 00:32:02 2009 +0200
@@ -1013,6 +1013,23 @@
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
+	.config  = 0,	/* no AGC config */
+};
+
 /* ==================================================================
  * Core code
  */
@@ -1124,6 +1141,19 @@
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
+				   &zolid_tda18271_config);
+		}
+		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1120:
 		fe0->dvb.frontend = dvb_attach(tda10048_attach,
 					       &hcw_tda10048_config,
diff -r 2b49813f8482 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Thu Sep 03 09:06:34 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Tue Sep 08 00:32:02 2009 +0200
@@ -297,6 +297,7 @@
 #define SAA7134_BOARD_AVERMEDIA_STUDIO_505  170
 #define SAA7134_BOARD_BEHOLD_X7             171
 #define SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM 172
+#define SAA7134_BOARD_ZOLID_HYBRID_PCI		173
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8

--dDRMvlgZJXvWKvBx--
