Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46077 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbcD0LB0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2016 07:01:26 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH] tw686x: use a formula instead of two tables for div
Date: Wed, 27 Apr 2016 08:01:19 -0300
Message-Id: <8344040026ad0985c3c3981e8ec4251fd563258f.1461754812.git.mchehab@osg.samsung.com>
In-Reply-To: <20160427074055.091a90c8@recife.lan>
References: <20160427074055.091a90c8@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using two tables to estimate the temporal decimation
factor, use a formula. This allows to get the closest fps, with
sounds better than the current tables.

Compile-tested only.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/pci/tw686x/tw686x-video.c | 34 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index 253e10823ba3..0210fa304e4c 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -50,28 +50,18 @@ static unsigned int tw686x_fields_map(v4l2_std_id std, unsigned int fps)
 		0x01041041, 0x01104411, 0x01111111, 0x04444445, 0x04511445,
 		0x05145145, 0x05151515, 0x05515455, 0x05551555, 0x05555555
 	};
-
-	static const unsigned int std_625_50[26] = {
-		0, 1, 1, 2,  3,  3,  4,  4,  5,  5,  6,  7,  7,
-		   8, 8, 9, 10, 10, 11, 11, 12, 13, 13, 14, 14, 0
-	};
-
-	static const unsigned int std_525_60[31] = {
-		0, 1, 1, 1, 2,  2,  3,  3,  4,  4,  5,  5,  6,  6, 7, 7,
-		   8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 0, 0
-	};
-
-	unsigned int i;
-
-	if (std & V4L2_STD_525_60) {
-		if (fps >= ARRAY_SIZE(std_525_60))
-			fps = 30;
-		i = std_525_60[fps];
-	} else {
-		if (fps >= ARRAY_SIZE(std_625_50))
-			fps = 25;
-		i = std_625_50[fps];
-	}
+	unsigned int i, max_fps;
+
+	if (std & V4L2_STD_525_60)
+		max_fps = 30;
+	else
+		max_fps = 25;
+
+	i = DIV_ROUND_CLOSEST(15 * fps, max_fps);
+	if (!i)
+		i = 1;	/* Min possible fps */
+	else if (i > 14)
+		i = 0;	/* fps = max_fps */
 
 	return map[i];
 }
-- 
2.5.5

