Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48568 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaALTsf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 14:48:35 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] em28xx-audio: fix return code on device disconnect
Date: Sun, 12 Jan 2014 14:44:52 -0200
Message-Id: <1389545092-19665-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alsa has an special non-negative return code to indicate device removal
at snd_em28xx_capture_pointer(). Use it, instead of an error code.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index f3e320098f79..47766b796acb 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -434,7 +434,7 @@ static snd_pcm_uframes_t snd_em28xx_capture_pointer(struct snd_pcm_substream
 
 	dev = snd_pcm_substream_chip(substream);
 	if (dev->disconnected)
-		return -ENODEV;
+		return SNDRV_PCM_POS_XRUN;
 
 	spin_lock_irqsave(&dev->adev.slock, flags);
 	hwptr_done = dev->adev.hwptr_done_capture;
-- 
1.8.3.1

