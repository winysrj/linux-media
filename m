Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42229 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaAJVtQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jan 2014 16:49:16 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/4] em28xx-audio: Fix error path
Date: Fri, 10 Jan 2014 16:45:37 -0200
Message-Id: <1389379539-31550-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389379539-31550-1-git-send-email-m.chehab@samsung.com>
References: <1389379539-31550-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

De-allocate memory and free sound if an error happens.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 8e6f04873422..4ee3488960e1 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -692,6 +692,7 @@ static int em28xx_audio_init(struct em28xx *dev)
 	if (intf->num_altsetting <= alt) {
 		em28xx_errdev("alt %d doesn't exist on interface %d\n",
 			      dev->audio_ifnum, alt);
+		snd_card_free(card);
 		return -ENODEV;
 	}
 
@@ -707,6 +708,7 @@ static int em28xx_audio_init(struct em28xx *dev)
 
 	if (!ep) {
 		em28xx_errdev("Couldn't find an audio endpoint");
+		snd_card_free(card);
 		return -ENODEV;
 	}
 
@@ -759,6 +761,7 @@ static int em28xx_audio_init(struct em28xx *dev)
 
 	err = snd_card_register(card);
 	if (err < 0) {
+		em28xx_audio_free_urb(dev);
 		snd_card_free(card);
 		return err;
 	}
-- 
1.8.3.1

