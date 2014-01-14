Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56890 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaANUhy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jan 2014 15:37:54 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] em28xx-audio: provide an error code when URB submit fails
Date: Tue, 14 Jan 2014 15:34:13 -0200
Message-Id: <1389720853-20184-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of just saying:
	[ 1646.412419] em2882/3 #0: submit of audio urb failed
Print the reason why it failed, to help debugging and fixing it.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 73eeeaf6551f..1a01be604766 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -163,10 +163,9 @@ static void em28xx_audio_isocirq(struct urb *urb)
 	urb->status = 0;
 
 	status = usb_submit_urb(urb, GFP_ATOMIC);
-	if (status < 0) {
+	if (status < 0)
 		em28xx_errdev("resubmit of audio urb failed (error=%i)\n",
 			      status);
-	}
 	return;
 }
 
@@ -183,7 +182,8 @@ static int em28xx_init_audio_isoc(struct em28xx *dev)
 
 		errCode = usb_submit_urb(dev->adev.urb[i], GFP_ATOMIC);
 		if (errCode) {
-			em28xx_errdev("submit of audio urb failed\n");
+			em28xx_errdev("submit of audio urb failed (error=%i)\n",
+				      errCode);
 			em28xx_deinit_isoc_audio(dev);
 			atomic_set(&dev->stream_started, 0);
 			return errCode;
-- 
1.8.3.1

