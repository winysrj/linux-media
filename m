Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:48778 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759216AbZFWPCM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 11:02:12 -0400
Received: by mail-bw0-f213.google.com with SMTP id 9so131252bwz.37
        for <linux-media@vger.kernel.org>; Tue, 23 Jun 2009 08:02:14 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: mo.ucina@gmail.com
Subject: Re: [linux-dvb] Support for Compro VideoMate S350
Date: Tue, 23 Jun 2009 18:04:28 +0300
Cc: linux-media@vger.kernel.org, "Jan D. Louw" <jd.louw@mweb.co.za>
References: <81c0b0550905250703o786a2a65ib757287da841dc11@mail.gmail.com> <200906201633.58431.liplianin@me.by> <4A40C81E.7070304@gmail.com>
In-Reply-To: <4A40C81E.7070304@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_87OQKKMWxkYEq5R"
Message-Id: <200906231804.28893.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_87OQKKMWxkYEq5R
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 23 June 2009 15:18:38 O&M Ugarcina wrote:
> Thanks for that Igor,
>
> I have just pulled the latest hg and tried to apply patches . Patches
> 12094 and 12095 went in with no problem . However patch 12096 failed
> with this output :
>
> [root@localhost v4l-dvb]# patch -p1 < 12096.patch
> patching file linux/drivers/media/common/ir-keymaps.c
> Hunk #1 FAILED at 2800.
> 1 out of 1 hunk FAILED -- saving rejects to file
> linux/drivers/media/common/ir-keymaps.c.rej
> patching file linux/drivers/media/video/saa7134/Kconfig
> patching file linux/drivers/media/video/saa7134/saa7134-cards.c
> patching file linux/drivers/media/video/saa7134/saa7134-dvb.c
> patching file linux/drivers/media/video/saa7134/saa7134-input.c
> patching file linux/drivers/media/video/saa7134/saa7134.h
> patching file linux/include/media/ir-common.h
> Hunk #1 FAILED at 162.
> 1 out of 1 hunk FAILED -- saving rejects to file
> linux/include/media/ir-common.h.rej
> [root@localhost v4l-dvb]#
>

I recreate last patch just now.

Igor

--Boundary-00=_87OQKKMWxkYEq5R
Content-Type: text/x-diff;
  charset="koi8-r";
  name="12135.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="12135.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1245768974 -10800
# Node ID 170087b85e38857ab2ce629777ce4adb548c42b6
# Parent  ae94525150167d61862a860b92a03dcb0f1c584b
Add support for Compro VideoMate S350 DVB-S PCI card.

From: Igor M. Liplianin <liplianin@me.by>

Add Compro VideoMate S350 DVB-S driver.
The card uses zl10313, zl10039, saa7130 integrated circuits.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r ae9452515016 -r 170087b85e38 linux/drivers/media/common/ir-keymaps.c
--- a/linux/drivers/media/common/ir-keymaps.c	Sat Jun 20 15:54:18 2009 +0300
+++ b/linux/drivers/media/common/ir-keymaps.c	Tue Jun 23 17:56:14 2009 +0300
@@ -2823,3 +2823,51 @@
 	[0x13] = KEY_CAMERA,
 };
 EXPORT_SYMBOL_GPL(ir_codes_evga_indtube);
+
+IR_KEYTAB_TYPE ir_codes_videomate_s350[IR_KEYTAB_SIZE] = {
+	[0x00] = KEY_TV,
+	[0x01] = KEY_DVD,
+	[0x04] = KEY_RECORD,
+	[0x05] = KEY_VIDEO, /* TV/Video */
+	[0x07] = KEY_STOP,
+	[0x08] = KEY_PLAYPAUSE,
+	[0x0a] = KEY_REWIND,
+	[0x0f] = KEY_FASTFORWARD,
+	[0x10] = KEY_CHANNELUP,
+	[0x12] = KEY_VOLUMEUP,
+	[0x13] = KEY_CHANNELDOWN,
+	[0x14] = KEY_MUTE,
+	[0x15] = KEY_VOLUMEDOWN,
+	[0x16] = KEY_1,
+	[0x17] = KEY_2,
+	[0x18] = KEY_3,
+	[0x19] = KEY_4,
+	[0x1a] = KEY_5,
+	[0x1b] = KEY_6,
+	[0x1c] = KEY_7,
+	[0x1d] = KEY_8,
+	[0x1e] = KEY_9,
+	[0x1f] = KEY_0,
+	[0x21] = KEY_SLEEP,
+	[0x24] = KEY_ZOOM,
+	[0x25] = KEY_LAST,    /* Recall */
+	[0x26] = KEY_SUBTITLE, /* CC */
+	[0x27] = KEY_LANGUAGE, /* MTS */
+	[0x29] = KEY_CHANNEL, /* SURF */
+	[0x2b] = KEY_A,
+	[0x2c] = KEY_B,
+	[0x2f] = KEY_SHUFFLE, /* Snapshot */
+	[0x23] = KEY_RADIO,
+	[0x02] = KEY_PREVIOUSSONG,
+	[0x06] = KEY_NEXTSONG,
+	[0x03] = KEY_EPG,
+	[0x09] = KEY_SETUP,
+	[0x22] = KEY_BACKSPACE,
+	[0x0c] = KEY_UP,
+	[0x0e] = KEY_DOWN,
+	[0x0b] = KEY_LEFT,
+	[0x0d] = KEY_RIGHT,
+	[0x11] = KEY_ENTER,
+	[0x20] = KEY_TEXT,
+};
+EXPORT_SYMBOL_GPL(ir_codes_videomate_s350);
diff -r ae9452515016 -r 170087b85e38 linux/drivers/media/video/saa7134/Kconfig
--- a/linux/drivers/media/video/saa7134/Kconfig	Sat Jun 20 15:54:18 2009 +0300
+++ b/linux/drivers/media/video/saa7134/Kconfig	Tue Jun 23 17:56:14 2009 +0300
@@ -47,6 +47,7 @@
 	select DVB_TDA10048 if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_TDA18271 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_TDA8290 if !MEDIA_TUNER_CUSTOMISE
+	select DVB_ZL10039 if !DVB_FE_CUSTOMISE
 	---help---
 	  This adds support for DVB cards based on the
 	  Philips saa7134 chip.
diff -r ae9452515016 -r 170087b85e38 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sat Jun 20 15:54:18 2009 +0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Jun 23 17:56:14 2009 +0300
@@ -5155,6 +5155,25 @@
 			.gpio = 0x00,
 		},
 	},
+	[SAA7134_BOARD_VIDEOMATE_S350] = {
+		/* Jan D. Louw <jd.louw@mweb.co.za */
+		.name		= "Compro VideoMate S350/S300",
+		.audio_clock	= 0x00187de7,
+		.tuner_type	= TUNER_ABSENT,
+		.radio_type	= UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.mpeg		= SAA7134_MPEG_DVB,
+		.inputs = { {
+			.name	= name_comp1,
+			.vmux	= 0,
+			.amux	= LINE1,
+		}, {
+			.name	= name_svideo,
+			.vmux	= 8, /* Not tested */
+			.amux	= LINE1
+		} },
+	},
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -6262,7 +6281,12 @@
 		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
 		.subdevice    = 0xf31d,
 		.driver_data  = SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS,
-
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
+		.subvendor    = 0x185b,
+		.subdevice    = 0xc900,
+		.driver_data  = SAA7134_BOARD_VIDEOMATE_S350,
 	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
@@ -6776,6 +6800,11 @@
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x80040100, 0x80040100);
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x80040100, 0x00040100);
 		break;
+	case SAA7134_BOARD_VIDEOMATE_S350:
+		dev->has_remote = SAA7134_REMOTE_GPIO;
+		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00008000, 0x00008000);
+		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
+		break;
 	}
 	return 0;
 }
diff -r ae9452515016 -r 170087b85e38 linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sat Jun 20 15:54:18 2009 +0300
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Tue Jun 23 17:56:14 2009 +0300
@@ -56,6 +56,7 @@
 #include "zl10353.h"
 
 #include "zl10036.h"
+#include "zl10039.h"
 #include "mt312.h"
 
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
@@ -968,6 +969,10 @@
 	.tuner_address = 0x60,
 };
 
+static struct mt312_config zl10313_compro_s350_config = {
+	.demod_address = 0x0e,
+};
+
 static struct lgdt3305_config hcw_lgdt3305_config = {
 	.i2c_addr           = 0x0e,
 	.mpeg_mode          = LGDT3305_MPEG_SERIAL,
@@ -1477,6 +1482,16 @@
 			}
 		}
 		break;
+	case SAA7134_BOARD_VIDEOMATE_S350:
+		fe0->dvb.frontend = dvb_attach(mt312_attach,
+				&zl10313_compro_s350_config, &dev->i2c_adap);
+		if (fe0->dvb.frontend)
+			if (dvb_attach(zl10039_attach, fe0->dvb.frontend,
+					0x60, &dev->i2c_adap) == NULL)
+				wprintk("%s: No zl10039 found!\n",
+					__func__);
+
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;
diff -r ae9452515016 -r 170087b85e38 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Sat Jun 20 15:54:18 2009 +0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Tue Jun 23 17:56:14 2009 +0300
@@ -646,6 +646,11 @@
 		mask_keycode = 0x7f;
 		polling = 40; /* ms */
 		break;
+	case SAA7134_BOARD_VIDEOMATE_S350:
+		ir_codes     = ir_codes_videomate_s350;
+		mask_keycode = 0x003f00;
+		mask_keydown = 0x040000;
+		break;
 	}
 	if (NULL == ir_codes) {
 		printk("%s: Oops: IR config error [card=%d]\n",
diff -r ae9452515016 -r 170087b85e38 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Sat Jun 20 15:54:18 2009 +0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Tue Jun 23 17:56:14 2009 +0300
@@ -293,6 +293,7 @@
 #define SAA7134_BOARD_BEHOLD_607RDS_MK5     166
 #define SAA7134_BOARD_BEHOLD_609RDS_MK3     167
 #define SAA7134_BOARD_BEHOLD_609RDS_MK5     168
+#define SAA7134_BOARD_VIDEOMATE_S350        169
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
diff -r ae9452515016 -r 170087b85e38 linux/include/media/ir-common.h
--- a/linux/include/media/ir-common.h	Sat Jun 20 15:54:18 2009 +0300
+++ b/linux/include/media/ir-common.h	Tue Jun 23 17:56:14 2009 +0300
@@ -163,6 +163,7 @@
 extern IR_KEYTAB_TYPE ir_codes_kaiomy[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_dm1105_nec[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_evga_indtube[IR_KEYTAB_SIZE];
+extern IR_KEYTAB_TYPE ir_codes_videomate_s350[IR_KEYTAB_SIZE];
 
 #endif
 

--Boundary-00=_87OQKKMWxkYEq5R--
