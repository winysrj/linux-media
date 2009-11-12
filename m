Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:46198 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753096AbZKLUki (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 15:40:38 -0500
Subject: Re: Tuner drivers
From: hermann pitton <hermann-pitton@arcor.de>
To: Ruslan <rulet1@meta.ua>
Cc: linux-media@vger.kernel.org
In-Reply-To: <loom.20091112T190450-643@post.gmane.org>
References: <loom.20091112T190450-643@post.gmane.org>
Content-Type: text/plain
Date: Thu, 12 Nov 2009 21:37:53 +0100
Message-Id: <1258058273.8348.14.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Donnerstag, den 12.11.2009, 18:05 +0000 schrieb Ruslan:
> Who is making or was making driver for Analog Aver Super 007 tuner?
> I wanted to ask why there is no sound?
> 

http://linuxtv.org/hg/v4l-dvb/annotate/d480cd6efe5b/linux/drivers/media/video/saa7134/saa7134.h#249

"hg export 6072" delivers the patch.

# HG changeset patch
# User Michael Krufky <mkrufky@linuxtv.org>
# Date 1187630090 14400
# Node ID d480cd6efe5b50fb41c4e137f18ce4ae93ab096c
# Parent  db2a922a8498fdb5d759b1134566e19e7da30b68
saa7134: add DVB-T support for Avermedia Super 007

From: Edgar Simo <bobbens@gmail.com>

add DVB-T support for Avermedia Super 007

Analog television is untested.  The device lacks input adapters for radio,
svideo & composite -- seems to be a DVB-T ONLY device.

Signed-off-by: Edgar Simo <bobbens@gmail.com>
Acked-by: Hermann Pitton <hermann-pitton@arcor.de>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>

diff -r db2a922a8498 -r d480cd6efe5b linux/Documentation/video4linux/CARDLIST.saa7134
--- a/linux/Documentation/video4linux/CARDLIST.saa7134	Mon Aug 20 13:06:00 2007 -0400
+++ b/linux/Documentation/video4linux/CARDLIST.saa7134	Mon Aug 20 13:14:50 2007 -0400
@@ -115,3 +115,4 @@
 114 -> KWorld DVB-T 210                         [17de:7250]
 115 -> Sabrent PCMCIA TV-PCB05                  [0919:2003]
 116 -> 10MOONS TM300 TV Card                    [1131:2304]
+117 -> Avermedia Super 007                      [1461:f01d]
diff -r db2a922a8498 -r d480cd6efe5b linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon Aug 20 13:06:00 2007 -0400
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon Aug 20 13:14:50 2007 -0400
@@ -3573,6 +3573,22 @@
 			.gpio = 0x3000,
 		},
 	},
+	[SAA7134_BOARD_AVERMEDIA_SUPER_007] = {
+		.name           = "Avermedia Super 007",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tuner_config   = 0,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.inputs = {{
+			.name   = name_tv, /* FIXME: analog tv untested */
+			.vmux   = 1,
+			.amux   = TV,
+			.tv     = 1,
+		}},
+	},
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -4296,6 +4312,12 @@
 		.subdevice    = 0x2304,
 		.driver_data  = SAA7134_BOARD_10MOONSTVMASTER3,
 	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
+		.subdevice    = 0xf01d, /* AVerTV DVB-T Super 007 */
+		.driver_data  = SAA7134_BOARD_AVERMEDIA_SUPER_007,
+	},{
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -4640,6 +4662,7 @@
 		break;
 	case SAA7134_BOARD_PHILIPS_TIGER:
 	case SAA7134_BOARD_PHILIPS_TIGER_S:
+	case SAA7134_BOARD_AVERMEDIA_SUPER_007:
 		{
 		u8 data[] = { 0x3c, 0x33, 0x60};
 		struct i2c_msg msg = {.addr=0x08, .flags=0, .buf=data, .len = sizeof(data)};
diff -r db2a922a8498 -r d480cd6efe5b linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Mon Aug 20 13:06:00 2007 -0400
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Mon Aug 20 13:14:50 2007 -0400
@@ -763,6 +763,21 @@
 	.request_firmware = philips_tda1004x_request_firmware
 };
 
+static struct tda1004x_config avermedia_super_007_config = {
+	.demod_address = 0x08,
+	.invert        = 1,
+	.invert_oclk   = 0,
+	.xtal_freq     = TDA10046_XTAL_16M,
+	.agc_config    = TDA10046_AGC_TDA827X,
+	.gpio_config   = TDA10046_GP01_I,
+	.if_freq       = TDA10046_FREQ_045,
+	.i2c_gate      = 0x4b,
+	.tuner_address = 0x60,
+	.tuner_config  = 0,
+	.antenna_switch= 1,
+	.request_firmware = philips_tda1004x_request_firmware
+};
+
 /* ------------------------------------------------------------------
  * special case: this card uses saa713x GPIO22 for the mode switch
  */
@@ -1025,6 +1040,9 @@
 	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
 		configure_tda827x_fe(dev, &asus_p7131_hybrid_lna_config);
 		break;
+	case SAA7134_BOARD_AVERMEDIA_SUPER_007:
+		configure_tda827x_fe(dev, &avermedia_super_007_config);
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;
diff -r db2a922a8498 -r d480cd6efe5b linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Mon Aug 20 13:06:00 2007 -0400
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Mon Aug 20 13:14:50 2007 -0400
@@ -246,6 +246,7 @@
 #define SAA7134_BOARD_KWORLD_DVBT_210 114
 #define SAA7134_BOARD_SABRENT_TV_PCB05     115
 #define SAA7134_BOARD_10MOONSTVMASTER3     116
+#define SAA7134_BOARD_AVERMEDIA_SUPER_007  117
 
 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8

Mike worked with Edgar on IRC and I asked to test if there really is an
additional LNA on it, which was set initially. Turned out there is none.

This is a hybrid device, but there was no work on the analog part done.
Note the FIXME: "analog tv untested".

AverMedia almost always uses an external mux chip for the analog audio
routing. That might be the reason for the missing sound.

If it has no analog audio out for TV sound, you must try to use
saa7134-alsa at first too with "sox", "arecord/aplay" or
"mplayer/mencoder". Some instructions for saa7134-alsa are on the wiki.

Cheers,
Hermann






