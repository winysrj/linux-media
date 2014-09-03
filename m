Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44450 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbaICUdd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:33 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 17/46] [media] ov9740: use true/false for boolean vars
Date: Wed,  3 Sep 2014 17:32:49 -0300
Message-Id: <cfad8f3a0ea118432e3ed00ee5f1664641b661d5.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using 0 or 1 for boolean, use the true/false
defines.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
index ea76863dfdb4..ee9eb635d540 100644
--- a/drivers/media/i2c/soc_camera/ov9740.c
+++ b/drivers/media/i2c/soc_camera/ov9740.c
@@ -564,13 +564,13 @@ static int ov9740_set_res(struct i2c_client *client, u32 width, u32 height)
 	u32 y_start;
 	u32 x_end;
 	u32 y_end;
-	bool scaling = 0;
+	bool scaling = false;
 	u32 scale_input_x;
 	u32 scale_input_y;
 	int ret;
 
 	if ((width != OV9740_MAX_WIDTH) || (height != OV9740_MAX_HEIGHT))
-		scaling = 1;
+		scaling = true;
 
 	/*
 	 * Try to use as much of the sensor area as possible when supporting
-- 
1.9.3

