Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43690 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbaADN7R (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jan 2014 08:59:17 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v4 13/22] [media] em28xx: initialize audio latter
Date: Sat,  4 Jan 2014 08:55:42 -0200
Message-Id: <1388832951-11195-14-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Better to first write the GPIOs of the input mux, before initializing
the audio.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 40 ++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index b767262c642b..328d724a13ea 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2291,26 +2291,6 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	em28xx_tuner_setup(dev);
 	em28xx_init_camera(dev);
 
-	/* Configure audio */
-	ret = em28xx_audio_setup(dev);
-	if (ret < 0) {
-		em28xx_errdev("%s: Error while setting audio - error [%d]!\n",
-			__func__, ret);
-		goto err;
-	}
-	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
-		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
-			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
-		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
-			V4L2_CID_AUDIO_VOLUME, 0, 0x1f, 1, 0x1f);
-	} else {
-		/* install the em28xx notify callback */
-		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_MUTE),
-				em28xx_ctrl_notify, dev);
-		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_VOLUME),
-				em28xx_ctrl_notify, dev);
-	}
-
 	/* wake i2c devices */
 	em28xx_wake_i2c(dev);
 
@@ -2356,6 +2336,26 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 
 	video_mux(dev, 0);
 
+	/* Configure audio */
+	ret = em28xx_audio_setup(dev);
+	if (ret < 0) {
+		em28xx_errdev("%s: Error while setting audio - error [%d]!\n",
+			__func__, ret);
+		goto err;
+	}
+	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
+		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
+		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
+			V4L2_CID_AUDIO_VOLUME, 0, 0x1f, 1, 0x1f);
+	} else {
+		/* install the em28xx notify callback */
+		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_MUTE),
+				em28xx_ctrl_notify, dev);
+		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_VOLUME),
+				em28xx_ctrl_notify, dev);
+	}
+
 	/* Audio defaults */
 	dev->mute = 1;
 	dev->volume = 0x1f;
-- 
1.8.3.1

