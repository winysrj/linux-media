Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n24BctY2007272
	for <video4linux-list@redhat.com>; Wed, 4 Mar 2009 06:38:55 -0500
Received: from smtp103.biz.mail.re2.yahoo.com (smtp103.biz.mail.re2.yahoo.com
	[68.142.229.217])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n24BccKJ013127
	for <video4linux-list@redhat.com>; Wed, 4 Mar 2009 06:38:38 -0500
Message-ID: <49AE65B8.1090609@embeddedalley.com>
Date: Wed, 04 Mar 2009 14:27:52 +0300
From: Vitaly Wool <vital@embeddedalley.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: [PATCH/upd] em28xx: enable Compro VideoMate ForYou sound
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

below is the new patch candidate for Compro VideoMate ForYou/Stereo USB TV box sound enablement.

Thanks,
  Vitaly


 em28xx-cards.c |   21 ++++++++++++++++++++-
 em28xx-core.c  |    5 +++++
 em28xx-i2c.c   |    6 ++++++
 em28xx-video.c |    7 +++++++
 em28xx.h       |    1 +
 5 files changed, 39 insertions(+), 1 deletion(-)

Signed-off-by: Vitaly Wool <vital@embeddedalley.com>

Index: linux-next/drivers/media/video/em28xx/em28xx-cards.c
===================================================================
--- linux-next.orig/drivers/media/video/em28xx/em28xx-cards.c	2009-03-03 10:34:48.000000000 +0300
+++ linux-next/drivers/media/video/em28xx/em28xx-cards.c	2009-03-03 10:35:16.000000000 +0300
@@ -122,6 +122,22 @@
 	{  -1,			-1,		-1,		-1},
 };
 
+/* Mute/unmute */
+static struct em28xx_reg_seq compro_unmute_tv_gpio[] = {
+	{EM28XX_R08_GPIO,	5,		7,		10},
+	{  -1,			-1,		-1,		-1},
+};
+
+static struct em28xx_reg_seq compro_unmute_svid_gpio[] = {
+	{EM28XX_R08_GPIO,	4,		7,		10},
+	{  -1,			-1,		-1,		-1},
+};
+
+static struct em28xx_reg_seq compro_mute_gpio[] = {
+	{EM28XX_R08_GPIO,	6,		7,		10},
+	{  -1,			-1,		-1,		-1},
+};
+
 /*
  *  Board definitions
  */
@@ -1225,14 +1241,17 @@
 		.tda9887_conf = TDA9887_PRESENT,
 		.decoder      = EM28XX_TVP5150,
 		.adecoder     = EM28XX_TVAUDIO,
+		.mute_gpio    = compro_mute_gpio,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
-			.amux     = EM28XX_AMUX_LINE_IN,
+			.amux     = EM28XX_AMUX_VIDEO,
+			.gpio     = compro_unmute_tv_gpio,
 		}, {
 			.type     = EM28XX_VMUX_SVIDEO,
 			.vmux     = TVP5150_SVIDEO,
 			.amux     = EM28XX_AMUX_LINE_IN,
+			.gpio     = compro_unmute_svid_gpio,
 		} },
 	},
 	[EM2860_BOARD_KAIOMY_TVNPC_U2] = {
Index: linux-next/drivers/media/video/em28xx/em28xx-core.c
===================================================================
--- linux-next.orig/drivers/media/video/em28xx/em28xx-core.c	2009-03-03 10:34:48.000000000 +0300
+++ linux-next/drivers/media/video/em28xx/em28xx-core.c	2009-03-03 17:41:34.000000000 +0300
@@ -378,6 +378,11 @@
 		}
 	}
 
+	if (dev->board.mute_gpio && dev->mute)
+		em28xx_gpio_set(dev, dev->board.mute_gpio);
+	else
+		em28xx_gpio_set(dev, INPUT(dev->ctl_input)->gpio);
+
 	ret = em28xx_write_reg_bits(dev, EM28XX_R0E_AUDIOSRC, input, 0xc0);
 	if (ret < 0)
 		return ret;
Index: linux-next/drivers/media/video/em28xx/em28xx-i2c.c
===================================================================
--- linux-next.orig/drivers/media/video/em28xx/em28xx-i2c.c	2009-03-03 10:34:48.000000000 +0300
+++ linux-next/drivers/media/video/em28xx/em28xx-i2c.c	2009-03-03 10:35:16.000000000 +0300
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
--- linux-next.orig/drivers/media/video/em28xx/em28xx-video.c	2009-03-03 10:34:48.000000000 +0300
+++ linux-next/drivers/media/video/em28xx/em28xx-video.c	2009-03-03 10:35:16.000000000 +0300
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
--- linux-next.orig/drivers/media/video/em28xx/em28xx.h	2009-03-03 10:34:48.000000000 +0300
+++ linux-next/drivers/media/video/em28xx/em28xx.h	2009-03-03 10:35:16.000000000 +0300
@@ -374,6 +374,7 @@
 	struct em28xx_reg_seq *dvb_gpio;
 	struct em28xx_reg_seq *suspend_gpio;
 	struct em28xx_reg_seq *tuner_gpio;
+	struct em28xx_reg_seq *mute_gpio;
 
 	unsigned int is_em2800:1;
 	unsigned int has_msp34xx:1;


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
