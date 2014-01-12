Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49543 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaAMCE1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 21:04:27 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 6/7] em28xx: print a message at disconnect
Date: Sun, 12 Jan 2014 21:00:48 -0200
Message-Id: <1389567649-26838-7-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389567649-26838-1-git-send-email-m.chehab@samsung.com>
References: <1389567649-26838-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That helps to identify if something fails and explain why em28xx
struct is not freed (if it ever happens).

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 2 ++
 drivers/media/usb/em28xx/em28xx-dvb.c   | 2 ++
 drivers/media/usb/em28xx/em28xx-input.c | 2 ++
 drivers/media/usb/em28xx/em28xx-video.c | 2 ++
 4 files changed, 8 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 5e16fcf18cac..0ec4742c3ab0 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -962,6 +962,8 @@ static int em28xx_audio_fini(struct em28xx *dev)
 		return 0;
 	}
 
+	em28xx_info("Disconnecting audio extension");
+
 	snd_card_disconnect(dev->adev.sndcard);
 	em28xx_audio_free_urb(dev);
 
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 8674ae5fce06..7ba209de57dd 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1473,6 +1473,8 @@ static int em28xx_dvb_fini(struct em28xx *dev)
 		return 0;
 	}
 
+	em28xx_info("Disconnecting DVB extension");
+
 	if (dev->dvb) {
 		struct em28xx_dvb *dvb = dev->dvb;
 
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 33388b5922a0..bf04c5e1bd2a 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -812,6 +812,8 @@ static int em28xx_ir_fini(struct em28xx *dev)
 		return 0;
 	}
 
+	em28xx_info("Disconnecting input extension");
+
 	em28xx_shutdown_buttons(dev);
 
 	/* skip detach on non attached boards */
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index dc10cec772ba..004fe12ceec7 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1894,6 +1894,8 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 		return 0;
 	}
 
+	em28xx_info("Disconnecting video extension");
+
 	v4l2_device_disconnect(&dev->v4l2_dev);
 
 	em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
-- 
1.8.3.1

