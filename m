Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1PHGtkC022167
	for <video4linux-list@redhat.com>; Wed, 25 Feb 2009 12:16:55 -0500
Received: from smtp102.biz.mail.re2.yahoo.com (smtp102.biz.mail.re2.yahoo.com
	[68.142.229.216])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n1PHGTIl011979
	for <video4linux-list@redhat.com>; Wed, 25 Feb 2009 12:16:30 -0500
Message-ID: <49A57BD4.6040209@embeddedalley.com>
Date: Wed, 25 Feb 2009 20:11:48 +0300
From: Vitaly Wool <vital@embeddedalley.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <49A3A61F.30509@embeddedalley.com>	<20090224234205.7a5ca4ca@pedra.chehab.org>	<49A53CB9.1040109@embeddedalley.com>	<20090225090728.7f2b0673@caramujo.chehab.org>	<49A567D9.80805@embeddedalley.com>
	<20090225101812.212fabbe@caramujo.chehab.org>
In-Reply-To: <20090225101812.212fabbe@caramujo.chehab.org>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, em28xx@mcentral.de
Subject: Re: em28xx: Compro VideoMate For You sound problems
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

Mauro Carvalho Chehab wrote:

>
> IMO, it would be better if you could do a patch with the remaining changes. 
after doing the mods you'd suggested I found out that the noise started coming out after the em28xx module loading
stops when em28xx_set_audio_source() is executed. Don't I need to add some tweaks there as well?

The patch is now looking the following way:

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 100f90a..f300e74 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -1245,14 +1245,17 @@ struct em28xx_board em28xx_boards[] = {
 		.tda9887_conf = TDA9887_PRESENT,
 		.decoder      = EM28XX_TVP5150,
 		.adecoder     = EM28XX_TVAUDIO,
+		.tuner_gpio   = default_tuner_gpio,
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
diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index eee8d01..b5b2396 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -354,6 +354,7 @@ static int em28xx_set_audio_source(struct em28xx *dev)
 	int ret;
 	u8 input;
 
+	printk("%s: entered\n", __func__);
 	if (dev->board.is_em2800) {
 		if (dev->ctl_ainput == EM28XX_AMUX_VIDEO)
 			input = EM2800_AUDIO_SRC_TUNER;
diff --git a/drivers/media/video/em28xx/em28xx-i2c.c b/drivers/media/video/em28xx/em28xx-i2c.c
index 2dab43d..02c12fe 100644
--- a/drivers/media/video/em28xx/em28xx-i2c.c
+++ b/drivers/media/video/em28xx/em28xx-i2c.c
@@ -510,12 +510,17 @@ static int attach_inform(struct i2c_client *client)
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
 
@@ -554,6 +559,7 @@ static char *i2c_devs[128] = {
 	[0x80 >> 1] = "msp34xx",
 	[0x88 >> 1] = "msp34xx",
 	[0xa0 >> 1] = "eeprom",
+	[0xb0 >> 1] = "tda9874",
 	[0xb8 >> 1] = "tvp5150a",
 	[0xba >> 1] = "tvp5150a",
 	[0xc0 >> 1] = "tuner (analog)",
diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index efd6415..3ce8e95 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -540,6 +540,13 @@ static void video_mux(struct em28xx *dev, int index)
 			&route);
 	}
 
+	if (dev->board.adecoder != EM28XX_NOADECODER) {
+		route.input = dev->ctl_ainput;
+		route.output = 0;
+		em28xx_i2c_call_clients(dev, VIDIOC_INT_S_AUDIO_ROUTING,
+			&route);
+	}
+
 	em28xx_audio_analog_set(dev);
 }
 
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h


Thanks,
   Vitaly

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
