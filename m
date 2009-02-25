Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1PFrFE5016903
	for <video4linux-list@redhat.com>; Wed, 25 Feb 2009 10:53:15 -0500
Received: from smtp105.biz.mail.re2.yahoo.com (smtp105.biz.mail.re2.yahoo.com
	[206.190.52.174])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n1PFp5ME029753
	for <video4linux-list@redhat.com>; Wed, 25 Feb 2009 10:51:39 -0500
Message-ID: <49A567D9.80805@embeddedalley.com>
Date: Wed, 25 Feb 2009 18:46:33 +0300
From: Vitaly Wool <vital@embeddedalley.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <49A3A61F.30509@embeddedalley.com>	<20090224234205.7a5ca4ca@pedra.chehab.org>	<49A53CB9.1040109@embeddedalley.com>
	<20090225090728.7f2b0673@caramujo.chehab.org>
In-Reply-To: <20090225090728.7f2b0673@caramujo.chehab.org>
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

Mauro,

Mauro Carvalho Chehab wrote:

> Ok, so if everything else is properly configured on em28xx, you should have
> audio working. 
>
> I've just committed a patch that should automatically load tvaudio for your
> board. Could you please test it?
it looks like I've got the sound coming out of the board with the following piece of hackery:

diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index eee8d01..55bcf42 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -406,6 +406,24 @@ int em28xx_audio_analog_set(struct em28xx *dev)
 	int ret, i;
 	u8 xclk;
 
+	if (dev->i2c_tvaudio_client) {
+		char c;
+		switch (dev->ctl_ainput) {
+		case 0:
+			c = 0xfd;
+			break;
+		case 1:
+			c = 0xfc;
+			break;
+		default:
+			c = 0xfe;
+			break;
+		}
+		if (dev->mute)
+			c = 0xfe;
+		return em28xx_write_regs(dev, 0x08, &c, 1);
+	}
+
 	if (!dev->audio_mode.has_audio)
 		return 0;
 
diff --git a/drivers/media/video/em28xx/em28xx-i2c.c b/drivers/media/video/em28xx/em28xx-i2c.c
index 2dab43d..55e5a2e 100644
--- a/drivers/media/video/em28xx/em28xx-i2c.c
+++ b/drivers/media/video/em28xx/em28xx-i2c.c
@@ -510,12 +510,21 @@ static int attach_inform(struct i2c_client *client)
 		dprintk1(1, "attach_inform: tvp5150 detected.\n");
 		break;
 
+	case 0xb0:
+		dprintk1(1, "attach_inform: tda9874 detected\n");
+		dprintk1(1, "driver id %d\n", client->driver->id);
+		dev->i2c_tvaudio_client = client;
+		if (!dev->tuner_addr)
+			dev->tuner_addr = client->addr;
+		break;
+
 	default:
 		if (!dev->tuner_addr)
 			dev->tuner_addr = client->addr;
 
 		dprintk1(1, "attach inform: detected I2C address %x\n",
 				client->addr << 1);
+		dprintk1(1, "driver id %d\n", client->driver->id);
 
 	}
 
@@ -554,6 +563,7 @@ static char *i2c_devs[128] = {
 	[0x80 >> 1] = "msp34xx",
 	[0x88 >> 1] = "msp34xx",
 	[0xa0 >> 1] = "eeprom",
+	[0xb0 >> 1] = "tvaudio",
 	[0xb8 >> 1] = "tvp5150a",
 	[0xba >> 1] = "tvp5150a",
 	[0xc0 >> 1] = "tuner (analog)",
diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index efd6415..5f7f4da 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -540,6 +540,13 @@ static void video_mux(struct em28xx *dev, int index)
 			&route);
 	}
 
+	if (dev->i2c_tvaudio_client) {
+		route.input = dev->ctl_ainput;
+		route.output = 0;
+		em28xx_i2c_call_clients(dev, VIDIOC_INT_S_AUDIO_ROUTING,
+			&route);
+	}
+
 	em28xx_audio_analog_set(dev);
 }
 
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index 3e82d81..67c00af 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -479,6 +479,7 @@ struct em28xx {
 	/* i2c i/o */
 	struct i2c_adapter i2c_adap;
 	struct i2c_client i2c_client;
+	struct i2c_client *i2c_tvaudio_client;
 	/* video for linux */
 	int users;		/* user count for exclusive use */
 	struct video_device *vdev;	/* video for linux device struct */
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 100f90a..c263f5d 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -1248,7 +1248,7 @@ struct em28xx_board em28xx_boards[] = {
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
-			.amux     = EM28XX_AMUX_LINE_IN,
+			.amux     = EM28XX_AMUX_VIDEO,
 		}, {
 			.type     = EM28XX_VMUX_SVIDEO,
 			.vmux     = TVP5150_SVIDEO,



Please note the .amux change; my bad it wasn't right from the bery beginning. However, just changing it
doesn't make things work, either with your latest patch or without it. Changes in em28xx_audio_analog_set are 
apparently what matter. but I'm not sure.

The other thing is that even with this patch, I'm getting more noise than TV sound. That might be related to
some TDA9874 programming needed and not done, but I'm not sure here either.

Thanks,
   Vitaly

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
