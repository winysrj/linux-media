Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:6171 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZCDKJE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 05:09:04 -0500
Received: by yw-out-2324.google.com with SMTP id 5so2109344ywh.1
        for <linux-media@vger.kernel.org>; Wed, 04 Mar 2009 02:09:02 -0800 (PST)
Subject: [Resubmit] [PATCH] v4l/bttv Add support to the GeoVision GV-800(S)
From: Bruno Christo <bchristo@inf.ufsm.br>
Reply-To: bchristo@inf.ufsm.br
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Mar 2009 07:08:53 -0300
Message-Id: <1236161333.861.9.camel@omega>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I have a GeoVision GV-800(S) card, it has 4 CONEXANT BT878A chips.
It has 16 video inputs and 4 audio inputs, and it is almost identical
to the GV-800, as seen on http://bttv-gallery.de .
The only difference appears to be the analog mux, it has a CD22M3494
in place of the MT8816AP. The card has a blue PCB, as seen in this
picture: http://www.gsbr.com.br/imagem/kits/GeoVision%20GV%20800.jpg .

This card wasn't originally supported, and it was detected as
UNKNOWN/GENERIC. The video inputs weren't working, so I tried
"forcing" a few cards like the GeoVision GV-600, but there was still
no video. So I made a patch to support this card, based on the Kodicom
4400r.

The GV-800(S) is identified as follows:

# lspci
...
02:00.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)
02:00.1 Multimedia controller: Brooktree Corporation Bt878 Audio
Capture (rev 11)
02:04.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)
02:04.1 Multimedia controller: Brooktree Corporation Bt878 Audio
Capture (rev 11)
02:08.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)
02:08.1 Multimedia controller: Brooktree Corporation Bt878 Audio
Capture (rev 11)
02:0c.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)
02:0c.1 Multimedia controller: Brooktree Corporation Bt878 Audio
Capture (rev 11)

# lspci -nv
...
02:00.0 0400: 109e:036e (rev 11)
       Subsystem: 800a:763d
       Flags: bus master, medium devsel, latency 32, IRQ 10
       Memory at cdfff000 (32-bit, prefetchable) [size=4K]
       Capabilities: [44] Vital Product Data <?>
       Capabilities: [4c] Power Management version 2
       Kernel modules: bttv

02:00.1 0480: 109e:0878 (rev 11)
       Subsystem: 800a:763d
       Flags: bus master, medium devsel, latency 32, IRQ 10
       Memory at cdffe000 (32-bit, prefetchable) [size=4K]
       Capabilities: [44] Vital Product Data <?>
       Capabilities: [4c] Power Management version 2

02:04.0 0400: 109e:036e (rev 11)
       Subsystem: 800b:763d
       Flags: bus master, medium devsel, latency 32, IRQ 10
       Memory at cdffd000 (32-bit, prefetchable) [size=4K]
       Capabilities: [44] Vital Product Data <?>
       Capabilities: [4c] Power Management version 2
       Kernel modules: bttv

02:04.1 0480: 109e:0878 (rev 11)
       Subsystem: 800b:763d
       Flags: bus master, medium devsel, latency 32, IRQ 10
       Memory at cdffc000 (32-bit, prefetchable) [size=4K]
       Capabilities: [44] Vital Product Data <?>
       Capabilities: [4c] Power Management version 2

02:08.0 0400: 109e:036e (rev 11)
       Subsystem: 800c:763d
       Flags: bus master, medium devsel, latency 32, IRQ 10
       Memory at cdffb000 (32-bit, prefetchable) [size=4K]
       Capabilities: [44] Vital Product Data <?>
       Capabilities: [4c] Power Management version 2
       Kernel modules: bttv

02:08.1 0480: 109e:0878 (rev 11)
       Subsystem: 800c:763d
       Flags: bus master, medium devsel, latency 32, IRQ 10
       Memory at cdffa000 (32-bit, prefetchable) [size=4K]
       Capabilities: [44] Vital Product Data <?>
       Capabilities: [4c] Power Management version 2

02:0c.0 0400: 109e:036e (rev 11)
       Subsystem: 800d:763d
       Flags: bus master, medium devsel, latency 32, IRQ 10
       Memory at cdff9000 (32-bit, prefetchable) [size=4K]
       Capabilities: [44] Vital Product Data <?>
       Capabilities: [4c] Power Management version 2
       Kernel modules: bttv

02:0c.1 0480: 109e:0878 (rev 11)
       Subsystem: 800d:763d
       Flags: bus master, medium devsel, latency 32, IRQ 10
       Memory at cdff8000 (32-bit, prefetchable) [size=4K]
       Capabilities: [44] Vital Product Data <?>
       Capabilities: [4c] Power Management version 2

As you can see, the GV-800(S) card is almost identical to the GV-800
on bttv-gallery, so this patch might also work for that card. If not,
only a few changes should be required on the gv800s_write() function.

After this patch, the video inputs work correctly on linux 2.6.24 and
2.6.27 using the software 'motion'. The input order may seem a little
odd, but it's the order the original software/driver uses, and I decided
to keep that order to get the most out of the card.

I tried to get the audio working with the snd-bt87x module, but I only
get noise from every audio input, even after selecting a different mux
with alsamixer. Also, after trying to play sound from those sources, I
randomly get a RISC error about an invalid RISC opcode, and then that
output stops working. I also can't change the sampling rate when
recording. Any pointers to adding audio support are welcome.

This mail was sent using Evolution as described in email-clients.txt, I 
hope the tabs/spaces are now ok.

Signed-off-by: Bruno Christo <bchristo@inf.ufsm.br>
---

diff --git a/linux/Documentation/video4linux/CARDLIST.bttv b/linux/Documentation/video4linux/CARDLIST.bttv
--- a/linux/Documentation/video4linux/CARDLIST.bttv
+++ b/linux/Documentation/video4linux/CARDLIST.bttv
@@ -155,3 +155,5 @@
 154 -> PHYTEC VD-012-X1 (bt878)
 155 -> PHYTEC VD-012-X2 (bt878)
 156 -> IVCE-8784                                           [0000:f050,0001:f050,0002:f050,0003:f050]
+157 -> Geovision GV-800(S) (master)                        [800a:763d]
+158 -> Geovision GV-800(S) (slave)                         [800b:763d,800c:763d,800d:763d]
diff --git a/linux/drivers/media/video/bt8xx/bttv-cards.c b/linux/drivers/media/video/bt8xx/bttv-cards.c
--- a/linux/drivers/media/video/bt8xx/bttv-cards.c
+++ b/linux/drivers/media/video/bt8xx/bttv-cards.c
@@ -75,6 +75,9 @@
 static void geovision_muxsel(struct bttv *btv, unsigned int input);
 
 static void phytec_muxsel(struct bttv *btv, unsigned int input);
+
+static void gv800s_muxsel(struct bttv *btv, unsigned int input);
+static void gv800s_init(struct bttv *btv);
 
 static int terratec_active_radio_upgrade(struct bttv *btv);
 static int tea5757_read(struct bttv *btv);
@@ -312,6 +315,10 @@
 	{ 0xd200dbc0, BTTV_BOARD_DVICO_FUSIONHDTV_2,	"DViCO FusionHDTV 2" },
 	{ 0x763c008a, BTTV_BOARD_GEOVISION_GV600,	"GeoVision GV-600" },
 	{ 0x18011000, BTTV_BOARD_ENLTV_FM_2,	"Encore ENL TV-FM-2" },
+	{ 0x763d800a, BTTV_BOARD_GEOVISION_GV800S, "GeoVision GV-800(S) (master)" },
+	{ 0x763d800b, BTTV_BOARD_GEOVISION_GV800S_SL,	"GeoVision GV-800(S) (slave)" },
+	{ 0x763d800c, BTTV_BOARD_GEOVISION_GV800S_SL,	"GeoVision GV-800(S) (slave)" },
+	{ 0x763d800d, BTTV_BOARD_GEOVISION_GV800S_SL,	"GeoVision GV-800(S) (slave)" },
 	{ 0, -1, NULL }
 };
 
@@ -2847,7 +2854,60 @@
 		.pll            = PLL_28,
 		.tuner_type     = TUNER_ABSENT,
 		.tuner_addr	= ADDR_UNSET,
-	}
+	},
+		[BTTV_BOARD_GEOVISION_GV800S] = {
+		/* Bruno Christo <bchristo@inf.ufsm.br>
+		 *
+		 * GeoVision GV-800(S) has 4 Conexant Fusion 878A:
+		 * 	1 audio input  per BT878A = 4 audio inputs
+		 * 	4 video inputs per BT878A = 16 video inputs
+		 * This is the first BT878A chip of the GV-800(S). It's the
+		 * "master" chip and it controls the video inputs through an
+		 * analog multiplexer (a CD22M3494) via some GPIO pins. The
+		 * slaves should use card type 0x9e (following this one).
+		 * There is a EEPROM on the card which is currently not handled.
+		 * The audio input is not working yet.
+		 */
+		.name           = "Geovision GV-800(S) (master)",
+		.video_inputs   = 4,
+		/* .audio_inputs= 1, */
+		.tuner_type	= TUNER_ABSENT,
+		.tuner_addr	= ADDR_UNSET,
+		.svhs           = NO_SVHS,
+		.gpiomask	= 0xf107f,
+		.no_gpioirq     = 1,
+		.muxsel		= MUXSEL(2, 2, 2, 2),
+		.pll		= PLL_28,
+		.no_msp34xx	= 1,
+		.no_tda7432	= 1,
+		.no_tda9875	= 1,
+		.muxsel_hook    = gv800s_muxsel,
+	},
+		[BTTV_BOARD_GEOVISION_GV800S_SL] = {
+		/* Bruno Christo <bchristo@inf.ufsm.br>
+		 *
+		 * GeoVision GV-800(S) has 4 Conexant Fusion 878A:
+		 * 	1 audio input  per BT878A = 4 audio inputs
+		 * 	4 video inputs per BT878A = 16 video inputs
+		 * The 3 other BT878A chips are "slave" chips of the GV-800(S)
+		 * and should use this card type.
+		 * The audio input is not working yet.
+		 */
+		.name           = "Geovision GV-800(S) (slave)",
+		.video_inputs   = 4,
+		/* .audio_inputs= 1, */
+		.tuner_type	= TUNER_ABSENT,
+		.tuner_addr	= ADDR_UNSET,
+		.svhs           = NO_SVHS,
+		.gpiomask	= 0x00,
+		.no_gpioirq     = 1,
+		.muxsel		= MUXSEL(2, 2, 2, 2),
+		.pll		= PLL_28,
+		.no_msp34xx	= 1,
+		.no_tda7432	= 1,
+		.no_tda9875	= 1,
+		.muxsel_hook    = gv800s_muxsel,
+	},
 };
 
 static const unsigned int bttv_num_tvcards = ARRAY_SIZE(bttv_tvcards);
@@ -3376,6 +3436,9 @@
 	case BTTV_BOARD_KODICOM_4400R:
 		kodicom4400r_init(btv);
 		break;
+	case BTTV_BOARD_GEOVISION_GV800S:
+		gv800s_init(btv);
+		break;
 	}
 
 	/* pll configuration */
@@ -4595,6 +4658,122 @@
 	gpio_bits(0x3, mux);
 }
 
+/*
+ * GeoVision GV-800(S) functions
+ * Bruno Christo <bchristo@inf.ufsm.br>
+*/
+
+/* This is a function to control the analog switch, which determines which
+ * camera is routed to which controller.  The switch comprises an X-address
+ * (gpio bits 0-3, representing the camera, ranging from 0-15), and a
+ * Y-address (gpio bits 4-6, representing the controller, ranging from 0-3).
+ * A data value (gpio bit 18) of '1' enables the switch, and '0' disables
+ * the switch.  A STROBE bit (gpio bit 17) latches the data value into the
+ * specified address. There is also a chip select (gpio bit 16).
+ * The idea is to set the address and chip select together, bring
+ * STROBE high, write the data, and finally bring STROBE back to low.
+ */
+static void gv800s_write(struct bttv *btv,
+			 unsigned char xaddr,
+			 unsigned char yaddr,
+			 unsigned char data) {
+	/* On the "master" 878A:
+	* GPIO bits 0-9 are used for the analog switch:
+	*   00 - 03:	camera selector
+	*   04 - 06:	878A (controller) selector
+	*   16: 	cselect
+	*   17:		strobe
+	*   18: 	data (1->on, 0->off)
+	*   19:		reset
+	*/
+	const u32 ADDRESS = ((xaddr&0xf) | (yaddr&3)<<4);
+	const u32 CSELECT = 1<<16;
+	const u32 STROBE = 1<<17;
+	const u32 DATA = data<<18;
+
+	gpio_bits(0x1007f, ADDRESS | CSELECT);	/* write ADDRESS and CSELECT */
+	gpio_bits(0x20000, STROBE);		/* STROBE high */
+	gpio_bits(0x40000, DATA);		/* write DATA */
+	gpio_bits(0x20000, ~STROBE);		/* STROBE low */
+}
+
+/*
+ * GeoVision GV-800(S) muxsel
+ *
+ * Each of the 4 cards (controllers) use this function.
+ * The controller using this function selects the input through the GPIO pins
+ * of the "master" card. A pointer to this card is stored in master[btv->c.nr].
+ *
+ * The parameter 'input' is the requested camera number (0-4) on the controller.
+ * The map array has the address of each input. Note that the addresses in the
+ * array are in the sequence the original GeoVision driver uses, that is, set
+ * every controller to input 0, then to input 1, 2, 3, repeat. This means that
+ * the physical "camera 1" connector corresponds to controller 0 input 0,
+ * "camera 2" corresponds to controller 1 input 0, and so on.
+ *
+ * After getting the input address, the function then writes the appropriate
+ * data to the analog switch, and housekeeps the local copy of the switch
+ * information.
+ */
+static void gv800s_muxsel(struct bttv *btv, unsigned int input)
+{
+	struct bttv *mctlr;
+	char *sw_status;
+	int xaddr, yaddr;
+	static unsigned int map[4][4] = { { 0x0, 0x4, 0xa, 0x6 },
+					  { 0x1, 0x5, 0xb, 0x7 },
+					  { 0x2, 0x8, 0xc, 0xe },
+					  { 0x3, 0x9, 0xd, 0xf } };
+	input = input%4;
+	mctlr = master[btv->c.nr];
+	if (mctlr == NULL) {
+		/* do nothing until the "master" is detected */
+		return;
+	}
+	yaddr = (btv->c.nr - mctlr->c.nr) & 3;
+	sw_status = (char *)(&mctlr->mbox_we);
+	xaddr = map[yaddr][input] & 0xf;
+
+	/* Check if the controller/camera pair has changed, ignore otherwise */
+	if (sw_status[yaddr] != xaddr) {
+		/* disable the old switch, enable the new one and save status */
+		gv800s_write(mctlr, sw_status[yaddr], yaddr, 0);
+		sw_status[yaddr] = xaddr;
+		gv800s_write(mctlr, xaddr, yaddr, 1);
+	}
+}
+
+/* GeoVision GV-800(S) "master" chip init */
+static void gv800s_init(struct bttv *btv)
+{
+	char *sw_status = (char *)(&btv->mbox_we);
+	int ix;
+
+	gpio_inout(0xf107f, 0xf107f);
+	gpio_write(1<<19); /* reset the analog MUX */
+	gpio_write(0);
+
+	/* Preset camera 0 to the 4 controllers */
+	for (ix = 0; ix < 4; ix++) {
+		sw_status[ix] = ix;
+		gv800s_write(btv, ix, ix, 1);
+	}
+
+	/* Inputs on the "master" controller need this brightness fix */
+	bttv_I2CWrite(btv, 0x18, 0x5, 0x90, 1);
+
+	if (btv->c.nr > BTTV_MAX-4)
+		return;
+	/*
+	 * Store the "master" controller pointer in the master
+	 * array for later use in the muxsel function.
+	 */
+	master[btv->c.nr]   = btv;
+	master[btv->c.nr+1] = btv;
+	master[btv->c.nr+2] = btv;
+	master[btv->c.nr+3] = btv;
+}
+
 /* ----------------------------------------------------------------------- */
 /* motherboard chipset specific stuff                                      */
 
diff --git a/linux/drivers/media/video/bt8xx/bttv.h b/linux/drivers/media/video/bt8xx/bttv.h
--- a/linux/drivers/media/video/bt8xx/bttv.h
+++ b/linux/drivers/media/video/bt8xx/bttv.h
@@ -182,6 +182,8 @@
 #define BTTV_BOARD_VD012_X1		   0x9a
 #define BTTV_BOARD_VD012_X2		   0x9b
 #define BTTV_BOARD_IVCE8784		   0x9c
+#define BTTV_BOARD_GEOVISION_GV800S	   0x9d
+#define BTTV_BOARD_GEOVISION_GV800S_SL	   0x9e
 
 
 /* more card-specific defines */


--
Bruno Christo
Bacharel em Ciência da Computação - UFSM

