Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56053 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbcDTQm2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 12:42:28 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	=?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	devel@driverdev.osuosl.org
Subject: [PATCH] [media] tw686x-kh: use the cached value
Date: Wed, 20 Apr 2016 13:41:04 -0300
Message-Id: <13431509a41889a70cc76b31180f63fd10d0a5b3.1461170447.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

the dma_requests field is cached, but cache is not used:

drivers/staging/media/tw686x-kh/tw686x-kh-video.c: In function 'tw686x_video_irq':
drivers/staging/media/tw686x-kh/tw686x-kh-video.c:622:6: warning: variable 'requests' set but not used [-Wunused-but-set-variable]
  u32 requests;
      ^

Use the cache instead, as it seems reading it needs to be done
with spin lock taken.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/staging/media/tw686x-kh/tw686x-kh-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/tw686x-kh/tw686x-kh-video.c b/drivers/staging/media/tw686x-kh/tw686x-kh-video.c
index 2fbc3cbd9eb0..0650c29f78eb 100644
--- a/drivers/staging/media/tw686x-kh/tw686x-kh-video.c
+++ b/drivers/staging/media/tw686x-kh/tw686x-kh-video.c
@@ -625,7 +625,7 @@ int tw686x_video_irq(struct tw686x_dev *dev)
 	requests = dev->dma_requests;
 	spin_unlock_irqrestore(&dev->irq_lock, flags);
 
-	if (dev->dma_requests & dev->video_active) {
+	if (requests & dev->video_active) {
 		wake_up_interruptible_all(&dev->video_thread_wait);
 		handled = 1;
 	}
-- 
2.5.5

