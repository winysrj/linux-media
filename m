Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49539 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaAMCE1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 21:04:27 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 7/7] em28xx: Fix usb diconnect logic
Date: Sun, 12 Jan 2014 21:00:49 -0200
Message-Id: <1389567649-26838-8-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389567649-26838-1-git-send-email-m.chehab@samsung.com>
References: <1389567649-26838-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that everything is extension, the usb disconnect logic should
be the same.

While here, fix the device name.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index df92f417634a..8fc0a437054e 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3384,12 +3384,7 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 
 	dev->disconnected = 1;
 
-	if (dev->is_audio_only) {
-		em28xx_close_extension(dev);
-		return;
-	}
-
-	em28xx_info("disconnecting %s\n", dev->vdev->name);
+	em28xx_info("Disconnecting %s\n", dev->name);
 
 	flush_request_modules(dev);
 
-- 
1.8.3.1

