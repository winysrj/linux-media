Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49542 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaAMCE1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 21:04:27 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/7] em28xx-audio: simplify error handling
Date: Sun, 12 Jan 2014 21:00:44 -0200
Message-Id: <1389567649-26838-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389567649-26838-1-git-send-email-m.chehab@samsung.com>
References: <1389567649-26838-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cleanup the error handling code at em28xx-audio init.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 47766b796acb..97d9105e6830 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -893,10 +893,8 @@ static int em28xx_audio_init(struct em28xx *dev)
 	adev->udev = dev->udev;
 
 	err = snd_pcm_new(card, "Em28xx Audio", 0, 0, 1, &pcm);
-	if (err < 0) {
-		snd_card_free(card);
-		return err;
-	}
+	if (err < 0)
+		goto card_free;
 
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_em28xx_pcm_capture);
 	pcm->info_flags = 0;
@@ -927,20 +925,23 @@ static int em28xx_audio_init(struct em28xx *dev)
 	}
 
 	err = em28xx_audio_urb_init(dev);
-	if (err) {
-		snd_card_free(card);
-		return -ENODEV;
-	}
+	if (err)
+		goto card_free;
 
 	err = snd_card_register(card);
-	if (err < 0) {
-		em28xx_audio_free_urb(dev);
-		snd_card_free(card);
-		return err;
-	}
+	if (err < 0)
+		goto urb_free;
 
 	em28xx_info("Audio extension successfully initialized\n");
 	return 0;
+
+urb_free:
+	em28xx_audio_free_urb(dev);
+
+card_free:
+	snd_card_free(card);
+
+	return err;
 }
 
 static int em28xx_audio_fini(struct em28xx *dev)
-- 
1.8.3.1

