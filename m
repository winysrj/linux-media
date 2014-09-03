Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44427 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196AbaICUdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 16/46] [media] smiapp-core: use true/false for boolean vars
Date: Wed,  3 Sep 2014 17:32:48 -0300
Message-Id: <64a4483b3c2e3864dfdc0029497c9e4188a88887.1409775488.git.m.chehab@samsung.com>
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

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index c4cc5de3ae59..d312932bc56e 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1312,7 +1312,7 @@ static void smiapp_power_off(struct smiapp_sensor *sensor)
 		clk_disable_unprepare(sensor->ext_clk);
 	usleep_range(5000, 5000);
 	regulator_disable(sensor->vana);
-	sensor->streaming = 0;
+	sensor->streaming = false;
 }
 
 static int smiapp_set_power(struct v4l2_subdev *subdev, int on)
@@ -1509,13 +1509,13 @@ static int smiapp_set_stream(struct v4l2_subdev *subdev, int enable)
 		return 0;
 
 	if (enable) {
-		sensor->streaming = 1;
+		sensor->streaming = true;
 		rval = smiapp_start_streaming(sensor);
 		if (rval < 0)
-			sensor->streaming = 0;
+			sensor->streaming = false;
 	} else {
 		rval = smiapp_stop_streaming(sensor);
-		sensor->streaming = 0;
+		sensor->streaming = false;
 	}
 
 	return rval;
-- 
1.9.3

