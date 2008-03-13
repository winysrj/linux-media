Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2DC3cG0031286
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 08:03:38 -0400
Received: from rs26s12.datacenter.cha.cantv.net
	(rs26s12.datacenter.cha.cantv.net [200.44.33.17])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2DC36XC017242
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 08:03:07 -0400
Received: from archammer.ius.cc
	(dC9D354DA.dslam-40-11-4-24-1-01.fsl.dsl.cantv.net [201.211.84.218])
	by rs26s12.datacenter.cha.cantv.net (8.13.8/8.13.0/3.0) with ESMTP id
	m2DC31W2004441
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 07:33:01 -0430
Received: from trillian.ius.cc (trillian.ius.cc [192.168.0.201])
	(authenticated bits=0)
	by archammer.ius.cc (8.13.8/8.13.8/Debian-3) with ESMTP id
	m2DC2wEQ024747
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 07:32:58 -0430
From: Ernesto =?ISO-8859-1?Q?Hern=E1ndez-Novich?= <emhn@usb.ve>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8
Date: Thu, 13 Mar 2008 07:32:56 -0430
Message-Id: <1205409776.20876.34.camel@trillian.ius.cc>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH] Support for a 16-channel bt878 card
Reply-To: emhn@usb.ve
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

Signed-off-by: Ernesto Hernández-Novich <emhn@usb.ve>

I have what looks like a Geovision GV-600 (or 650) card. It has a large
chip in the middle labeled

CONEXANT
FUSION 878A
25878-13
E345881.1
0312 TAIWAN

It has an audio connector coming out from a chip labeled

ATMEL
0242
AT89C2051-24PI

It is identified as follows on my Debian GNU/Linux Etch (kernel 2.6.18)
system:

# lspci
...
01:0a.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)
01:0a.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture
(rev 11)
# lspci -vn
...
01:0a.0 0400: 109e:036e (rev 11)
        Subsystem: 008a:763c
        Flags: bus master, medium devsel, latency 64, IRQ 58
        Memory at dfffe000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2

01:0a.1 0480: 109e:0878 (rev 11)
        Subsystem: 008a:763c
        Flags: bus master, medium devsel, latency 64, IRQ 58
        Memory at dffff000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2

It was being detected as a GENERIC UNKNOWN CARD both by the 2.6.18
kernel and the latest v4l-dvb drivers, but it did not work at all. The
card has sixteen (16) BNC video inputs, four of them on the board itself
and twelve on three daughter-cards. It has a single bt878 chip, no tuner
and what looks like and audio input. After doing some research I managed
to get only eight channels working by forcing card=125 and those DID NOT
match channels 0-7 on the card, and no audio.

Based on what was working for card=125, I added the card definition
block, added a specific muxsel routine and got the card working fully
with xawtv, where the sixteen channels show up as Composite0 to
Composite15, matching the channel labels in the card and daughter-cards.
I have made no efforts yet to get audio working, but would appreciate
any pointers.

diff -ur v4l-dvb/linux/drivers/media/video/bt8xx/bttv-cards.c
v4l-dvb-patched/linux/drivers/media/video/bt8xx/bttv-cards.c
--- v4l-dvb/linux/drivers/media/video/bt8xx/bttv-cards.c	2008-03-11
10:11:47.000000000 -0430
+++ v4l-dvb-patched/linux/drivers/media/video/bt8xx/bttv-cards.c
2008-03-11 10:15:25.000000000 -0430
@@ -75,6 +75,8 @@
 static void sigmaSLC_muxsel(struct bttv *btv, unsigned int input);
 static void sigmaSQ_muxsel(struct bttv *btv, unsigned int input);
 
+static void geovision_muxsel(struct bttv *btv, unsigned int input);
+
 static int terratec_active_radio_upgrade(struct bttv *btv);
 static int tea5757_read(struct bttv *btv);
 static int tea5757_write(struct bttv *btv, int value);
@@ -324,6 +326,7 @@
 	{ 0xd50018ac, BTTV_BOARD_DVICO_FUSIONHDTV_5_LITE,    "DViCO FusionHDTV
5 Lite" },
 	{ 0x00261822, BTTV_BOARD_TWINHAN_DST,	"DNTV Live! Mini "},
 	{ 0xd200dbc0, BTTV_BOARD_DVICO_FUSIONHDTV_2,	"DViCO FusionHDTV 2" },
+	{ 0x763c008a, BTTV_BOARD_GEOVISION_GV600,	"GeoVision GV-600" },
 
 	{ 0, -1, NULL }
 };
@@ -3039,6 +3042,24 @@
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
 	},
+	[BTTV_BOARD_GEOVISION_GV600] = {
+		/* emhn@usb.ve */
+		.name             = "Geovision GV-600",
+		.video_inputs     = 16,
+		.audio_inputs     = 0,
+		.tuner            = UNSET,
+		.svhs             = UNSET,
+		.gpiomask         = 0x0,
+		.muxsel           = { 2, 2, 2, 2, 2, 2, 2, 2,
+				      2, 2, 2, 2, 2, 2, 2, 2 },
+		.muxsel_hook      = geovision_muxsel,
+		.gpiomux          = { 0 },
+		.no_msp34xx       = 1,
+		.pll              = PLL_28,
+		.tuner_type       = UNSET,
+		.tuner_addr	  = ADDR_UNSET,
+		.radio_addr       = ADDR_UNSET,
+	},
 };
 
 static const unsigned int bttv_num_tvcards = ARRAY_SIZE(bttv_tvcards);
@@ -3387,6 +3408,13 @@
 	gpio_bits( 3<<9, inmux<<9 );
 }
 
+static void geovision_muxsel(struct bttv *btv, unsigned int input)
+{
+	unsigned int inmux = input % 16;
+	gpio_inout( 0xf, 0xf );
+	gpio_bits( 0xf, inmux );
+}
+
 /*
-----------------------------------------------------------------------
*/
 
 static void bttv_reset_audio(struct bttv *btv)
diff -ur v4l-dvb/linux/drivers/media/video/bt8xx/bttv.h
v4l-dvb-patched/linux/drivers/media/video/bt8xx/bttv.h
--- v4l-dvb/linux/drivers/media/video/bt8xx/bttv.h	2008-03-11
10:11:47.000000000 -0430
+++ v4l-dvb-patched/linux/drivers/media/video/bt8xx/bttv.h	2008-02-19
16:13:38.000000000 -0430
@@ -174,6 +174,7 @@
 #define BTTV_BOARD_VOODOOTV_200		   0x93
 #define BTTV_BOARD_DVICO_FUSIONHDTV_2	   0x94
 #define BTTV_BOARD_TYPHOON_TVTUNERPCI	   0x95
+#define BTTV_BOARD_GEOVISION_GV600	   0x96
 

 /* more card-specific defines */

-- 
Prof. Ernesto Hernández-Novich - MYS-220C
Geek by nature, Linux by choice, Debian of course.
If you can't aptitude it, it isn't useful or doesn't exist.
GPG Key Fingerprint = 438C 49A2 A8C7 E7D7 1500 C507 96D6 A3D6 2F4C 85E3

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
