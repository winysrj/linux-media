Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37155 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbcDWJZ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2016 05:25:57 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH] [media] tvp686x: Don't go past array
Date: Sat, 23 Apr 2016 06:23:43 -0300
Message-Id: <d25dd8ca8edffc6cc8cee2dac9b907c333a0aa84.1461403421.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Depending on the compiler version, currently it produces the
following warnings:
	tw686x-video.c: In function 'tw686x_video_init':
	tw686x-video.c:65:543: warning: array subscript is above array bounds [-Warray-bounds]

This is actually bogus with the current code, as it currently
hardcodes the framerate to 30 frames/sec, however a potential
use after the array size could happen when the driver adds support
for setting the framerate. So, fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/pci/tw686x/tw686x-video.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index 118e9fac9f28..1ff59084ce08 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -61,8 +61,19 @@ static unsigned int tw686x_fields_map(v4l2_std_id std, unsigned int fps)
 		   8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 0, 0
 	};
 
-	unsigned int i =
-		(std & V4L2_STD_625_50) ? std_625_50[fps] : std_525_60[fps];
+	unsigned int i;
+
+	if (std & V4L2_STD_625_50) {
+		if (unlikely(i > ARRAY_SIZE(std_625_50)))
+			i = 14;		/* 25 fps */
+		else
+			i = std_625_50[fps];
+	} else {
+		if (unlikely(i > ARRAY_SIZE(std_525_60)))
+			i = 0;		/* 30 fps */
+		else
+			i = std_525_60[fps];
+	}
 
 	return map[i];
 }
-- 
2.5.5

