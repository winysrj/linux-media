Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46525 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbcDZJjo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2016 05:39:44 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH] [media] tw686x: avoid going past array
Date: Tue, 26 Apr 2016 06:38:17 -0300
Message-Id: <45c175c4ae9695d6d2f30a45ab7f3866cfac184b.1461663494.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix those two warnings:
	drivers/media/pci/tw686x/tw686x-video.c:69 tw686x_fields_map() error: buffer overflow 'std_525_60' 31 <= 31
	drivers/media/pci/tw686x/tw686x-video.c:73 tw686x_fields_map() error: buffer overflow 'std_625_50' 26 <= 26

I had those changes at the last version of my patch, but I ended
by merging the previous version by mistake.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/pci/tw686x/tw686x-video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index d2a0147e6492..253e10823ba3 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -64,11 +64,11 @@ static unsigned int tw686x_fields_map(v4l2_std_id std, unsigned int fps)
 	unsigned int i;
 
 	if (std & V4L2_STD_525_60) {
-		if (fps > ARRAY_SIZE(std_525_60))
+		if (fps >= ARRAY_SIZE(std_525_60))
 			fps = 30;
 		i = std_525_60[fps];
 	} else {
-		if (fps > ARRAY_SIZE(std_625_50))
+		if (fps >= ARRAY_SIZE(std_625_50))
 			fps = 25;
 		i = std_625_50[fps];
 	}
-- 
2.5.5

