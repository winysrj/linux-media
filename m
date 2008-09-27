Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8R1gvu1028767
	for <video4linux-list@redhat.com>; Fri, 26 Sep 2008 21:42:58 -0400
Received: from ws5-1.us4.outblaze.com (ws5-1.us4.outblaze.com [205.158.62.131])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8R1g5gP022759
	for <video4linux-list@redhat.com>; Fri, 26 Sep 2008 21:42:05 -0400
Message-ID: <48DD8F6B.8030408@linuxmail.org>
Date: Fri, 26 Sep 2008 20:42:03 -0500
From: Perry Gilfillan <perrye@linuxmail.org>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <48961FED.4040909@linuxmail.org>
In-Reply-To: <48961FED.4040909@linuxmail.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [PATCH] bttv: Re: Howto select one of 16 inputs on Digi-Flower
	boards?
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

Perry Gilfillan wrote:
> I've recently laid hands on a few Digi-Flower capture cards and found no 
> indication that anyone has ever taken the time to poke at these cards 
> with a digital multi-meter to discover how they are laid out.
> 

I've succeeded in getting the basic capture functionality to work
with this card and have a couple of ZoneMinder systems running, so
I'd like to submit this patch.

I've copied my earlier description of the board layout and function
to the ZoneMinder Wiki for those that are interested.

http://www.zoneminder.com/wiki/index.php/Digiflower



--- drivers/media/video/bt8xx/bttv.h.orig	2008-08-19 12:20:13.000000000 -0500
+++ drivers/media/video/bt8xx/bttv.h	2008-08-19 12:15:32.000000000 -0500
@@ -173,6 +173,7 @@
  #define BTTV_BOARD_VOODOOTV_200		   0x93
  #define BTTV_BOARD_DVICO_FUSIONHDTV_2	   0x94
  #define BTTV_BOARD_TYPHOON_TVTUNERPCI	   0x95
+#define BTTV_BOARD_DIGIFLOWER_DVR2000B     0x96

  /* more card-specific defines */
  #define PT2254_L_CHANNEL 0x10
--- drivers/media/video/bt8xx/bttv-cards.c.orig	2008-08-19 12:02:31.000000000 -0500
+++ drivers/media/video/bt8xx/bttv-cards.c	2008-08-19 12:52:58.000000000 -0500
@@ -81,6 +81,8 @@ static void tibetCS16_init(struct bttv *
  static void kodicom4400r_muxsel(struct bttv *btv, unsigned int input);
  static void kodicom4400r_init(struct bttv *btv);

+static void digiflower_dvr2000b_muxsel(struct bttv *btv, unsigned int input);
+
  static void sigmaSLC_muxsel(struct bttv *btv, unsigned int input);
  static void sigmaSQ_muxsel(struct bttv *btv, unsigned int input);

@@ -314,6 +316,7 @@ static struct CARD {
  	{ 0xd50018ac, BTTV_BOARD_DVICO_FUSIONHDTV_5_LITE,    "DViCO FusionHDTV 5 Lite" },
  	{ 0x00261822, BTTV_BOARD_TWINHAN_DST,	"DNTV Live! Mini "},
  	{ 0xd200dbc0, BTTV_BOARD_DVICO_FUSIONHDTV_2,	"DViCO FusionHDTV 2" },
+	{ 0x00000000, BTTV_BOARD_DIGIFLOWER_DVR2000B,	"Digi-Flower DVR2000B" },

  	{ 0, -1, NULL }
  };
@@ -3005,6 +3008,25 @@ struct tvcard bttv_tvcards[] = {
  		.tuner_addr     = ADDR_UNSET,
  		.radio_addr     = ADDR_UNSET,
  	},
+	[BTTV_BOARD_DIGIFLOWER_DVR2000B] = {
+		.name           = "Digi-Flower DVR2000B (master?)",
+		.video_inputs   = 16,
+		.audio_inputs   = 0,
+		.tuner          = UNSET,
+		.svhs           = UNSET,
+		.tuner_type     = TUNER_ABSENT,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.no_gpioirq     = 1,
+		.gpiomask2      = 0x140007,
+		.muxsel         = { 2,6,10,14, 2,6,10,14, 2,6,10,14, 2,6,10,14 },
+		.muxsel_hook	= digiflower_dvr2000b_muxsel,
+                .gpiomux        = { 0, 0, 0, 0 }, /* card has no audio */
+		.no_msp34xx     = 1,
+		.no_tda9875     = 1,
+		.no_tda7432     = 1,
+		.pll            = PLL_28,
+	},
  };

  static const unsigned int bttv_num_tvcards = ARRAY_SIZE(bttv_tvcards);
@@ -4887,6 +4909,21 @@ static void kodicom4400r_init(struct btt
  	master[btv->c.nr+2] = btv;
  }

+/* DB1 = Top connector fan-out.  DB2 = Bottom connector fan-out. */
+#define DB1    0x100000
+#define DB2    0x040000
+
+static void digiflower_dvr2000b_muxsel(struct bttv *btv, unsigned int input)
+{
+	static const int masks[] = {
+		DB1,   DB1|1, DB1|2, DB1|3,
+		DB1|4, DB1|5, DB1|6, DB1|7,
+		DB2,   DB2|1, DB2|2, DB2|3,
+		DB2|4, DB2|5, DB2|6, DB2|7,
+	};
+	gpio_write(masks[input%16]);
+}
+
  /* The Grandtec X-Guard framegrabber card uses two Dual 4-channel
   * video multiplexers to provide up to 16 video inputs. These
   * multiplexers are controlled by the lower 8 GPIO pins of the

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
