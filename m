Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m17IAICO021390
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 13:10:18 -0500
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.249])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m17I9sKX005562
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 13:09:54 -0500
Received: by an-out-0708.google.com with SMTP id c31so1545068ana.124
	for <video4linux-list@redhat.com>; Thu, 07 Feb 2008 10:09:48 -0800 (PST)
Message-ID: <9c4b1d600802071009q7fc69d4cj88c3ec2586e484a0@mail.gmail.com>
Date: Thu, 7 Feb 2008 16:09:48 -0200
From: "Adrian Pardini" <pardo.bsso@gmail.com>
To: "Linux and Kernel Video" <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: [PATCH] New card entry (saa7134) and FM support for TNF9835
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello,
This patch brings complete functionality to the "Genius TVGo A11MCE" (saa7130,
tuner is TNF9835) proper audio/video routing, fm tunning and remote control.

Things I've done:
  * New entry for the card.
  * New entry for the tuner. It's a TNF9835, as the wiki says it works
fine for tv using
     tuner=37 but the datasheet specifies different frequency bands and the i2c
     command used to tune fm is other.
  * Key mappings for the remote control.

Files changed:
  ir-common.h
  ir-keymaps.c
  saa7134.h
  saa7134-cards.c
  saa7134-input.c
  tuner.h
  tuner-simple.c
  tuner-types.c

Testing:
  I successfully built and tested it ( with the sources from
mercurial) using Ubuntu Gutsy(linux 2.6.22, custom) and Musix
1.0r3-test5 (2.6.23-rt1)

Notes:
  I get this message from time to time and I don't know what to do:
  "saa7130[0]/irq: looping -- clearing PE (parity error!) enable bit"

  I didn't want to mess with the pci ids table.
  Without using the card= parameter it is detected as being an
"Philips TOUGH DVB-T reference design [card=61,autodetected]".
  lspci output:
00:0c.0 Multimedia controller: Philips Semiconductors SAA7130 Video
Broadcast Decoder (rev 01)
        Subsystem: Philips Semiconductors Unknown device 2004
        Flags: bus master, medium devsel, latency 64, IRQ 11
        Memory at dffffc00 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [40] Power Management version 1

I'm wide open to accept suggestions and corrections.
Thanks a lot for your time,
Adrian.

Signed-off-by: Adrian Pardini <pardo.bsso AT gmail.com>

---
diff -uprN -X dontdiff v4l-dvb/linux/drivers/media/common/ir-keymaps.c
v4l-dvb-modified/linux/drivers/media/common/ir-keymaps.c
--- v4l-dvb/linux/drivers/media/common/ir-keymaps.c	2008-02-06
22:54:07.000000000 -0200
+++ v4l-dvb-modified/linux/drivers/media/common/ir-keymaps.c	2008-02-07
12:10:06.000000000 -0200
@@ -2037,3 +2037,52 @@ IR_KEYTAB_TYPE ir_codes_behold[IR_KEYTAB
 };

 EXPORT_SYMBOL_GPL(ir_codes_behold);
+
+/*
+ * Remote control for the Genius TVGO A11MCE
+ * Adrian Pardini <pardo.bsso@gmail.com>
+ */
+IR_KEYTAB_TYPE ir_codes_genius_tvgo_a11mce[IR_KEYTAB_SIZE] = {
+	/* Keys 0 to 9 */
+	[ 0x48 ] = KEY_0,
+	[ 0x09 ] = KEY_1,
+	[ 0x1d ] = KEY_2,
+	[ 0x1f ] = KEY_3,
+	[ 0x19 ] = KEY_4,
+	[ 0x1b ] = KEY_5,
+	[ 0x11 ] = KEY_6,
+	[ 0x17 ] = KEY_7,
+	[ 0x12 ] = KEY_8,
+	[ 0x16 ] = KEY_9,
+
+	[ 0x54 ] = KEY_RECORD,		/* recording */
+	[ 0x06 ] = KEY_MUTE,		/* mute */
+	[ 0x10 ] = KEY_POWER,		
+	[ 0x40 ] = KEY_LAST,		/* recall */
+	[ 0x4c ] = KEY_CHANNELUP,	/* channel / program + */
+	[ 0x00 ] = KEY_CHANNELDOWN,	/* channel / program - */
+	[ 0x0d ] = KEY_VOLUMEUP,
+	[ 0x15 ] = KEY_VOLUMEDOWN,
+	[ 0x4d ] = KEY_OK,		/* also labeled as Pause */
+	[ 0x1c ] = KEY_ZOOM,		/* full screen and Stop*/
+	[ 0x02 ] = KEY_MODE,		/* AV Source or Rewind*/
+	[ 0x04 ] = KEY_LIST,		/* -/-- */
+	/* small arrows above numbers */
+	[ 0x1a ] = KEY_NEXT,		/* also Fast Forward */
+	[ 0x0e ] = KEY_PREVIOUS,	/* also Rewind */
+	/* these are in a rather non standard layout and have
+	an alternate name written */
+	[ 0x1e ] = KEY_UP,		/* Video Setting */
+	[ 0x0a ] = KEY_DOWN,		/* Video Default */
+	[ 0x05 ] = KEY_LEFT,		/* Snapshot */
+	[ 0x0c ] = KEY_RIGHT,		/* Hide Panel */
+	/* Four buttons without label */
+	[ 0x49 ] = KEY_RED,
+	[ 0x0b ] = KEY_GREEN,
+	[ 0x13 ] = KEY_YELLOW,
+	[ 0x50 ] = KEY_BLUE,
+
+};
+EXPORT_SYMBOL_GPL(ir_codes_genius_tvgo_a11mce);
+
diff -uprN -X dontdiff
v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c
v4l-dvb-modified/linux/drivers/media/video/saa7134/saa7134-cards.c
--- v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c	2008-02-06
22:54:10.000000000 -0200
+++ v4l-dvb-modified/linux/drivers/media/video/saa7134/saa7134-cards.c	2008-02-07
14:07:45.000000000 -0200
@@ -3992,6 +3992,51 @@ struct saa7134_board saa7134_boards[] =
 			.gpio   = 0x0200000,
 		},
 	},
+	[SAA7134_BOARD_GENIUS_TVGO_A11MCE] = {
+		/* Adrian Pardini <pardo.bsso@gmail.com> */
+		.name		= "Genius TVGO AM11MCE",
+		.audio_clock	= 0x00200000,
+		.tuner_type	= TUNER_TNF9835,
+		.radio_type     = UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+
+		.gpiomask       = 0xf000,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.gpio = 0x8000,
+			.tv   = 1,
+		},{
+			.name = name_tv_mono,
+			.vmux = 1,
+			.amux = LINE2,
+			.gpio = 0x0000,
+			.tv   = 1,
+		},{
+			.name = name_comp1,
+			.vmux = 3,
+			.amux = LINE1,
+			.gpio = 0x2000,
+			.tv=1
+		},{
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+			.gpio = 0x2000,
+	}},
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+			.gpio = 0x1000,
+		},
+		.mute = {
+			.name = name_mute,
+			.amux = LINE2,
+			.gpio = 0x6000,
+		},
+	},
 };

 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -5130,6 +5175,7 @@ int saa7134_board_init1(struct saa7134_d
 	case SAA7134_BOARD_BEHOLD_409:
 	case SAA7134_BOARD_BEHOLD_505FM:
 	case SAA7134_BOARD_BEHOLD_507_9FM:
+	case SAA7134_BOARD_GENIUS_TVGO_A11MCE:
 		dev->has_remote = SAA7134_REMOTE_GPIO;
 		break;
 	case SAA7134_BOARD_FLYDVBS_LR300:
diff -uprN -X dontdiff
v4l-dvb/linux/drivers/media/video/saa7134/saa7134.h
v4l-dvb-modified/linux/drivers/media/video/saa7134/saa7134.h
--- v4l-dvb/linux/drivers/media/video/saa7134/saa7134.h	2008-02-06
22:54:10.000000000 -0200
+++ v4l-dvb-modified/linux/drivers/media/video/saa7134/saa7134.h	2008-02-07
11:10:37.000000000 -0200
@@ -260,6 +260,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_BEHOLD_607_9FM	129
 #define SAA7134_BOARD_BEHOLD_M6		130
 #define SAA7134_BOARD_TWINHAN_DTV_DVB_3056 131
+#define SAA7134_BOARD_GENIUS_TVGO_A11MCE 132

 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8
diff -uprN -X dontdiff
v4l-dvb/linux/drivers/media/video/saa7134/saa7134-input.c
v4l-dvb-modified/linux/drivers/media/video/saa7134/saa7134-input.c
--- v4l-dvb/linux/drivers/media/video/saa7134/saa7134-input.c	2008-02-06
22:54:10.000000000 -0200
+++ v4l-dvb-modified/linux/drivers/media/video/saa7134/saa7134-input.c	2008-02-07
12:11:55.000000000 -0200
@@ -406,6 +406,12 @@ int saa7134_input_init1(struct saa7134_d
 		mask_keyup   = 0x8000000;
 		polling      = 50; //ms
 		break;
+	case SAA7134_BOARD_GENIUS_TVGO_A11MCE:
+		ir_codes     = ir_codes_genius_tvgo_a11mce;
+		mask_keycode = 0xff;
+		mask_keydown = 0xf00000;
+		polling = 50; //ms
+		break;
 	}
 	if (NULL == ir_codes) {
 		printk("%s: Oops: IR config error [card=%d]\n",
diff -uprN -X dontdiff
v4l-dvb/linux/drivers/media/video/tuner-simple.c
v4l-dvb-modified/linux/drivers/media/video/tuner-simple.c
--- v4l-dvb/linux/drivers/media/video/tuner-simple.c	2008-02-06
22:54:11.000000000 -0200
+++ v4l-dvb-modified/linux/drivers/media/video/tuner-simple.c	2008-02-07
14:10:59.000000000 -0200
@@ -462,6 +462,7 @@ static int simple_radio_bandswitch(struc
 		buffer[3] = 0x19;
 		break;
 	case TUNER_TNF_5335MF:
+	case TUNER_TNF9835:
 		buffer[3] = 0x11;
 		break;
 	case TUNER_LG_PAL_FM:
diff -uprN -X dontdiff v4l-dvb/linux/drivers/media/video/tuner-types.c
v4l-dvb-modified/linux/drivers/media/video/tuner-types.c
--- v4l-dvb/linux/drivers/media/video/tuner-types.c	2008-02-06
22:54:11.000000000 -0200
+++ v4l-dvb-modified/linux/drivers/media/video/tuner-types.c	2008-02-07
14:06:28.000000000 -0200
@@ -1133,6 +1133,22 @@ static struct tuner_params tuner_samsung
 	},
 };

+/* -------------------------- TUNER_TNF9835 -------------------------- */
+
+static struct tuner_range tuner_tnf9835_ranges[] = {
+	{ 16 * 161.25 /*MHz*/, 0x8e, 0x01, },
+	{ 16 * 463.25 /*MHz*/, 0x8e, 0x02, },
+	{ 16 * 999.99        , 0x8e, 0x08, },
+};
+
+static struct tuner_params tuner_tnf9835_params[] = {
+	{
+		.type   = TUNER_PARAM_TYPE_PAL,
+		.ranges = tuner_tnf9835_ranges,
+		.count  = ARRAY_SIZE(tuner_tnf9835_ranges),
+	},
+};
+
 /* --------------------------------------------------------------------- */

 struct tunertype tuners[] = {
@@ -1527,6 +1543,11 @@ struct tunertype tuners[] = {
 		.name   = "Xceive 5000 tuner",
 		/* see xc5000.c for details */
 	},
+	[TUNER_TNF9835] = {
+		.name   = "TNF9835 FM / PAL B-BG / NTSC",
+		.params = tuner_tnf9835_params,
+		.count = ARRAY_SIZE(tuner_tnf9835_params),
+	},
 };
 EXPORT_SYMBOL(tuners);

diff -uprN -X dontdiff v4l-dvb/linux/include/media/ir-common.h
v4l-dvb-modified/linux/include/media/ir-common.h
--- v4l-dvb/linux/include/media/ir-common.h	2008-02-06 22:54:11.000000000 -0200
+++ v4l-dvb-modified/linux/include/media/ir-common.h	2008-02-07
11:08:02.000000000 -0200
@@ -142,6 +142,7 @@ extern IR_KEYTAB_TYPE ir_codes_tt_1500[I
 extern IR_KEYTAB_TYPE ir_codes_fusionhdtv_mce[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_behold[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_pinnacle_pctv_hd[IR_KEYTAB_SIZE];
+extern IR_KEYTAB_TYPE ir_codes_genius_tvgo_a11mce[IR_KEYTAB_SIZE];

 #endif

diff -uprN -X dontdiff v4l-dvb/linux/include/media/tuner.h
v4l-dvb-modified/linux/include/media/tuner.h
--- v4l-dvb/linux/include/media/tuner.h	2008-02-06 22:54:11.000000000 -0200
+++ v4l-dvb-modified/linux/include/media/tuner.h	2008-02-07
12:57:57.000000000 -0200
@@ -122,6 +122,7 @@
 #define TUNER_TDA9887                   74      /* This tuner should
be used only internally */
 #define TUNER_TEA5761			75	/* Only FM Radio Tuner */
 #define TUNER_XC5000			76	/* Xceive Silicon Tuner */
+#define TUNER_TNF9835			77	/* FM / PAL B-BG / NTSC */

 /* tv card specific */
 #define TDA9887_PRESENT 		(1<<0)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
