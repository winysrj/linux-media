Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mANLEnNM010759
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 16:14:49 -0500
Received: from apfelkorn.psychaos.be (apfelkorn.psychaos.be [195.144.77.38])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mANLE0FI012938
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 16:14:01 -0500
Received: from p2 by apfelkorn.psychaos.be with local (Exim 4.63)
	(envelope-from <p2@psychaos.be>) id 1L4MHH-0007kL-2T
	for video4linux-list@redhat.com; Sun, 23 Nov 2008 23:13:59 +0200
Date: Sun, 23 Nov 2008 23:13:58 +0200
From: "Peter 'p2' De Schrijver" <p2@debian.org>
To: video4linux-list@redhat.com
Message-ID: <20081123211358.GG10591@apfelkorn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [PATCH] add support for TD3116 board
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

The following patch adds support for the Tongwei Video Technology TD-3116 board. This
is a Bt878 based capture card with 16 inputs meant for surveilance applications.
It also offers a way to check which inputs have a video signal while capturing another
input. In addition there are a number of alarm inputs and outputs available and there
is microcontroller which is presumably intended for use as a system watchdog. None of
these extra capabilities are supported by the patch.

---
 drivers/media/video/bt8xx/bttv-cards.c |   54 +++++++++++++++++++++++++++++++-
 drivers/media/video/bt8xx/bttv.h       |    1 +
 2 files changed, 54 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index 13742b0..25b1234 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -74,6 +74,8 @@ static void sigmaSQ_muxsel(struct bttv *btv, unsigned int input);
 
 static void geovision_muxsel(struct bttv *btv, unsigned int input);
 
+static void td3116_muxsel(struct bttv *btv, unsigned int input);
+
 static int terratec_active_radio_upgrade(struct bttv *btv);
 static int tea5757_read(struct bttv *btv);
 static int tea5757_write(struct bttv *btv, int value);
@@ -306,6 +308,7 @@ static struct CARD {
 	{ 0xd200dbc0, BTTV_BOARD_DVICO_FUSIONHDTV_2,	"DViCO FusionHDTV 2" },
 	{ 0x763c008a, BTTV_BOARD_GEOVISION_GV600,	"GeoVision GV-600" },
 	{ 0x18011000, BTTV_BOARD_ENLTV_FM_2,	"Encore ENL TV-FM-2" },
+	{ 0x3116f200, BTTV_BOARD_TVT_TD3116, "Tongwei Video Technology TD-3116" },
 	{ 0, -1, NULL }
 };
 
@@ -3061,7 +3064,20 @@ struct tvcard bttv_tvcards[] = {
 		.pll            = PLL_28,
 		.has_radio      = 1,
 		.has_remote     = 1,
-	}
+	},
+	[BTTV_BOARD_TVT_TD3116] = {
+		.name		= "Tongwei Video Technology TD-3116",
+		.video_inputs	= 16,
+		.audio_inputs	= 0,
+		.gpiomask	= 0xc00ff,
+		.muxsel		= { 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, },
+		.muxsel_hook	= td3116_muxsel,
+		.tuner		= UNSET,
+		.svhs		= UNSET,
+		.tuner_type	= UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+	},
 };
 
 static const unsigned int bttv_num_tvcards = ARRAY_SIZE(bttv_tvcards);
@@ -3418,6 +3434,42 @@ static void geovision_muxsel(struct bttv *btv, unsigned int input)
 	gpio_bits(0xf, inmux);
 }
 
+/* 
+ * The TD3116 has 2 74HC4051 muxes wired to the MUX0 input of a bt878.
+ * The first 74HC4051 has the lower 8 inputs, the second one the higher 8.
+ * The muxes are controlled via a 74HC373 latch which is connected to
+ * GPIOs 0-7. GPIO 18 is connected to the LE signal of the latch.
+ * Q0 of the latch is connected to the Enable (~E) input of the first
+ * 74HC4051. Q1 - Q3 are connected to S0 - S2 of the same 74HC4051.
+ * Q4 - Q7 are connected to the second 74HC4051 in the same way.
+ */
+
+static void td3116_latch_value(struct bttv *btv, u32 value)
+{
+	gpio_bits( (1<<18) | 0xff, value);
+	gpio_bits( (1<<18) | 0xff, (1<<18) | value);
+	udelay(1);
+	gpio_bits( (1<<18) | 0xff, value);
+}
+
+static void td3116_muxsel(struct bttv *btv, unsigned int input)
+{
+	u32 value;
+	u32 highbit;
+
+	highbit = (input & 0x8) >> 3 ;
+
+	/* Disable outputs and set value in the mux */
+	value = 0x11; /* Disable outputs */
+	value |= ((input & 0x7) << 1)  << (4 * highbit);
+	td3116_latch_value(btv, value);
+	
+	/* Enable the correct output */
+	value &= ~0x11;
+	value |= ((highbit ^ 0x1) << 4) | highbit;
+	td3116_latch_value(btv, value);
+}
+
 /* ----------------------------------------------------------------------- */
 
 static void bttv_reset_audio(struct bttv *btv)
diff --git a/drivers/media/video/bt8xx/bttv.h b/drivers/media/video/bt8xx/bttv.h
index 46cb90e..7884017 100644
--- a/drivers/media/video/bt8xx/bttv.h
+++ b/drivers/media/video/bt8xx/bttv.h
@@ -177,6 +177,7 @@
 #define BTTV_BOARD_GEOVISION_GV600	   0x96
 #define BTTV_BOARD_KOZUMI_KTV_01C          0x97
 #define BTTV_BOARD_ENLTV_FM_2		   0x98
+#define BTTV_BOARD_TVT_TD3116		   0x99
 
 /* more card-specific defines */
 #define PT2254_L_CHANNEL 0x10
-- 
1.5.6.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
