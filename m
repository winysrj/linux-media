Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44397 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143AbaICUdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH 33/46] [media] s5p-tv: Simplify the return logic
Date: Wed,  3 Sep 2014 17:33:05 -0300
Message-Id: <600cea39e9bd3c211ab8836ad6079f238c816499.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure pm_runtime_* calls does not use unnecessary
IS_ERR_VALUE().

Reported by scripts/coccinelle/api/pm_runtime.cocci script.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 754740f4b671..37c8bd694c5f 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -615,7 +615,7 @@ static int hdmi_s_power(struct v4l2_subdev *sd, int on)
 	else
 		ret = pm_runtime_put_sync(hdev->dev);
 	/* only values < 0 indicate errors */
-	return IS_ERR_VALUE(ret) ? ret : 0;
+	return ret < 0 ? ret : 0;
 }
 
 static int hdmi_s_dv_timings(struct v4l2_subdev *sd,
diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index 5a7c3796f22e..72cf892dd008 100644
--- a/drivers/media/platform/s5p-tv/sdo_drv.c
+++ b/drivers/media/platform/s5p-tv/sdo_drv.c
@@ -190,7 +190,7 @@ static int sdo_s_power(struct v4l2_subdev *sd, int on)
 		ret = pm_runtime_put_sync(dev);
 
 	/* only values < 0 indicate errors */
-	return IS_ERR_VALUE(ret) ? ret : 0;
+	return ret < 0 ? ret : 0;
 }
 
 static int sdo_streamon(struct sdo_device *sdev)
diff --git a/drivers/media/platform/s5p-tv/sii9234_drv.c b/drivers/media/platform/s5p-tv/sii9234_drv.c
index 3dd762e5b67e..db8c17bb4aaa 100644
--- a/drivers/media/platform/s5p-tv/sii9234_drv.c
+++ b/drivers/media/platform/s5p-tv/sii9234_drv.c
@@ -289,7 +289,7 @@ static int sii9234_s_power(struct v4l2_subdev *sd, int on)
 	else
 		ret = pm_runtime_put(&ctx->client->dev);
 	/* only values < 0 indicate errors */
-	return IS_ERR_VALUE(ret) ? ret : 0;
+	return ret < 0 ? ret : 0;
 }
 
 static int sii9234_s_stream(struct v4l2_subdev *sd, int enable)
-- 
1.9.3

