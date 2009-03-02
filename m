Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n22F2dcQ007204
	for <video4linux-list@redhat.com>; Mon, 2 Mar 2009 10:02:39 -0500
Received: from smtp103.biz.mail.re2.yahoo.com (smtp103.biz.mail.re2.yahoo.com
	[68.142.229.217])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n22F2MI5017946
	for <video4linux-list@redhat.com>; Mon, 2 Mar 2009 10:02:23 -0500
Message-ID: <49ABF405.9090005@embeddedalley.com>
Date: Mon, 02 Mar 2009 17:58:13 +0300
From: Vitaly Wool <vital@embeddedalley.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: [PATCH] em28xx: enable Compro VideoMate ForYou sound
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

Hello Mauro,

below is the final patch candidate for Compro VideoMate ForYou/Stereo USB TV box sound enablement.

The tvaudio changes are put aside, as it is a separate matter.

Thanks,
   Vitaly

 drivers/media/video/em28xx/em28xx-cards.c |   17 ++++++++++++++++-
 drivers/media/video/em28xx/em28xx-core.c  |   11 +++++++++++
 drivers/media/video/em28xx/em28xx-i2c.c   |    6 ++++++
 drivers/media/video/em28xx/em28xx-video.c |    7 +++++++
 drivers/media/video/em28xx/em28xx.h       |    2 ++
 5 files changed, 42 insertions(+), 1 deletion(-)

Signed-off-by: Vitaly Wool <vital@embeddedalley.com>

Index: linux-next/drivers/media/video/em28xx/em28xx-cards.c
===================================================================
--- linux-next.orig/drivers/media/video/em28xx/em28xx-cards.c	2009-03-02 17:50:40.000000000 +0300
+++ linux-next/drivers/media/video/em28xx/em28xx-cards.c	2009-03-02 17:51:16.000000000 +0300
@@ -122,6 +122,17 @@
 	{  -1,			-1,		-1,		-1},
 };
 
+/* Mute/unmute */
+static struct em28xx_reg_seq compro_unmute_gpio[] = {
+	{EM28XX_R08_GPIO,	EM_GPIO_0,	EM_GPIO_0 | EM_GPIO_1,	10},
+	{  -1,			-1,		-1,			-1},
+};
+
+static struct em28xx_reg_seq compro_mute_gpio[] = {
+	{EM28XX_R08_GPIO,	EM_GPIO_1,	EM_GPIO_0 | EM_GPIO_1,	10},
+	{  -1,			-1,		-1,			-1},
+};
+
 /*
  *  Board definitions
  */
@@ -1225,14 +1236,18 @@
 		.tda9887_conf = TDA9887_PRESENT,
 		.decoder      = EM28XX_TVP5150,
 		.adecoder     = EM28XX_TVAUDIO,
+		.mute_gpio    = compro_mute_gpio,
+		.unmute_gpio  = compro_unmute_gpio,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
-			.amux     = EM28XX_AMUX_LINE_IN,
+			.amux     = EM28XX_AMUX_VIDEO,
+			.gpio     = default_analog,
 		}, {
 			.type     = EM28XX_VMUX_SVIDEO,
 			.vmux     = TVP5150_SVIDEO,
 			.amux     = EM28XX_AMUX_LINE_IN,
+			.gpio     = default_analog,
 		} },
 	},
 	[EM2860_BOARD_KAIOMY_TVNPC_U2] = {
Index: linux-next/drivers/media/video/em28xx/em28xx-core.c
===================================================================
--- linux-next.orig/drivers/media/video/em28xx/em28xx-core.c	2009-03-02 17:50:40.000000000 +0300
+++ linux-next/drivers/media/video/em28xx/em28xx-core.c	2009-03-02 17:51:16.000000000 +0300
@@ -353,6 +353,7 @@
 {
 	int ret;
 	u8 input;
+	int do_mute = 0;
 
 	if (dev->board.is_em2800) {
 		if (dev->ctl_ainput == EM28XX_AMUX_VIDEO)
@@ -378,6 +379,16 @@
 		}
 	}
 
+	if (dev->mute || input != EM28XX_AUDIO_SRC_TUNER)
+		do_mute = 1;
+
+	if (dev->board.mute_gpio && do_mute)
+		em28xx_gpio_set(dev, dev->board.mute_gpio);
+
+	if (dev->board.unmute_gpio && !do_mute)
+		em28xx_gpio_set(dev, dev->board.unmute_gpio);
+
+
 	ret = em28xx_write_reg_bits(dev, EM28XX_R0E_AUDIOSRC, input, 0xc0);
 	if (ret < 0)
 		return ret;
Index: linux-next/drivers/media/video/em28xx/em28xx-i2c.c
===================================================================
--- linux-next.orig/drivers/media/video/em28xx/em28xx-i2c.c	2009-03-02 17:50:40.000000000 +0300
+++ linux-next/drivers/media/video/em28xx/em28xx-i2c.c	2009-03-02 17:51:16.000000000 +0300
@@ -510,12 +510,17 @@
 		dprintk1(1, "attach_inform: tvp5150 detected.\n");
 		break;
 
+	case 0xb0:
+		dprintk1(1, "attach_inform: tda9874 detected\n");
+		break;
+
 	default:
 		if (!dev->tuner_addr)
 			dev->tuner_addr = client->addr;
 
 		dprintk1(1, "attach inform: detected I2C address %x\n",
 				client->addr << 1);
+		dprintk1(1, "driver id %d\n", client->driver->id);
 
 	}
 
@@ -554,6 +559,7 @@
 	[0x80 >> 1] = "msp34xx",
 	[0x88 >> 1] = "msp34xx",
 	[0xa0 >> 1] = "eeprom",
+	[0xb0 >> 1] = "tda9874",
 	[0xb8 >> 1] = "tvp5150a",
 	[0xba >> 1] = "tvp5150a",
 	[0xc0 >> 1] = "tuner (analog)",
Index: linux-next/drivers/media/video/em28xx/em28xx-video.c
===================================================================
--- linux-next.orig/drivers/media/video/em28xx/em28xx-video.c	2009-03-02 17:50:40.000000000 +0300
+++ linux-next/drivers/media/video/em28xx/em28xx-video.c	2009-03-02 17:51:16.000000000 +0300
@@ -540,6 +540,13 @@
 			&route);
 	}
 
+	if (dev->board.adecoder != EM28XX_NOADECODER) {
+		route.input = dev->ctl_ainput;
+		route.output = dev->ctl_aoutput;
+		em28xx_i2c_call_clients(dev, VIDIOC_INT_S_AUDIO_ROUTING,
+			&route);
+	}
+
 	em28xx_audio_analog_set(dev);
 }
 
Index: linux-next/drivers/media/video/em28xx/em28xx.h
===================================================================
--- linux-next.orig/drivers/media/video/em28xx/em28xx.h	2009-03-02 17:50:40.000000000 +0300
+++ linux-next/drivers/media/video/em28xx/em28xx.h	2009-03-02 17:51:16.000000000 +0300
@@ -374,6 +374,8 @@
 	struct em28xx_reg_seq *dvb_gpio;
 	struct em28xx_reg_seq *suspend_gpio;
 	struct em28xx_reg_seq *tuner_gpio;
+	struct em28xx_reg_seq *mute_gpio;
+	struct em28xx_reg_seq *unmute_gpio;
 
 	unsigned int is_em2800:1;
 	unsigned int has_msp34xx:1;

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
