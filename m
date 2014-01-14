Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56778 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaANUAo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jan 2014 15:00:44 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] em28xx-alsa: Fix error patch for init/fini
Date: Tue, 14 Jan 2014 14:57:03 -0200
Message-Id: <1389718623-14558-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If something bad happens during init, we free the card data.
However, we still keep it initialized, causing some dependent
code to be called at .fini.

Fix it.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 1563f71a5ea2..45bea1adc11c 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -948,6 +948,7 @@ urb_free:
 
 card_free:
 	snd_card_free(card);
+	adev->sndcard = NULL;
 
 	return err;
 }
@@ -966,12 +967,12 @@ static int em28xx_audio_fini(struct em28xx *dev)
 
 	em28xx_info("Closing audio extension");
 
-	snd_card_disconnect(dev->adev.sndcard);
-	flush_work(&dev->wq_trigger);
+	if (dev->adev.sndcard) {
+		snd_card_disconnect(dev->adev.sndcard);
+		flush_work(&dev->wq_trigger);
 
-	em28xx_audio_free_urb(dev);
+		em28xx_audio_free_urb(dev);
 
-	if (dev->adev.sndcard) {
 		snd_card_free(dev->adev.sndcard);
 		dev->adev.sndcard = NULL;
 	}
-- 
1.8.3.1

