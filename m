Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:50701 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbZCCBjT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2009 20:39:19 -0500
Received: by qw-out-2122.google.com with SMTP id 5so3951233qwi.37
        for <linux-media@vger.kernel.org>; Mon, 02 Mar 2009 17:39:16 -0800 (PST)
Subject: Re: [PATCH] Add support for GeoVision GV-800(S)
From: Bruno Christo <brunochristo@gmail.com>
Reply-To: brunochristo@gmail.com
To: klimov.linux@gmail.com
Cc: Nicola Soranzo <nsoranzo@tiscali.it>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Mar 2009 22:38:59 -0300
Message-Id: <1236044339.28795.47.camel@omega>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Alexey,

> Well, i used gmail instructions to adjust evolution and it worked well
> (patches inlined okay).
> And i tried mutt - it also works as expected. I read email-clients.txt
> and used "preformatted" inline format in evolution as described. I
> think you can try again if have free time/wish.
>
> --
> Best regards, Klimov Alexey

I tried e-mailing myself the patch a few times using the method you
described, but I was getting whitespace instead of tabs on the message I
received (both in gmail and evolution). And that was preventing me from
applying the patch.

After many tries, I tried using the MIME attachment method, and it worked,
so I sent it to the list using this format because it appeared to be less
error-prone.

Based on this, my guess is you use a script to replace whitespace with
tabs, so all you need is an inlined patch? Or am I doing something wrong
and it should arrive with the tabs instead of the whitespace?

Anyway, I'm sending it now using the method you described:

Signed-off-by: Bruno Christo <bchristo@inf.ufsm.br>

diff -r c770b20d15c6 linux/Documentation/video4linux/CARDLIST.bttv
--- a/linux/Documentation/video4linux/CARDLIST.bttv	Fri Feb 27 21:29:59 2009 -0300
+++ b/linux/Documentation/video4linux/CARDLIST.bttv	Sun Mar 01 16:01:31 2009 +0000
@@ -155,3 +155,5 @@
 154 -> PHYTEC VD-012-X1 (bt878)
 155 -> PHYTEC VD-012-X2 (bt878)
 156 -> IVCE-8784                                           [0000:f050,0001:f050,0002:f050,0003:f050]
+157 -> Geovision GV-800(S) (master)                        [800a:763d]
+158 -> Geovision GV-800(S) (slave)                         [800b:763d,800c:763d,800d:763d]
diff -r c770b20d15c6 linux/drivers/media/video/bt8xx/bttv-cards.c
--- a/linux/drivers/media/video/bt8xx/bttv-cards.c	Fri Feb 27 21:29:59 2009 -0300
+++ b/linux/drivers/media/video/bt8xx/bttv-cards.c	Sun Mar 01 16:01:31 2009 +0000
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
 
diff -r c770b20d15c6 linux/drivers/media/video/bt8xx/bttv.h
--- a/linux/drivers/media/video/bt8xx/bttv.h	Fri Feb 27 21:29:59 2009 -0300
+++ b/linux/drivers/media/video/bt8xx/bttv.h	Sun Mar 01 16:01:31 2009 +0000
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

