Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43782 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab0KJOOf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 09:14:35 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sergio Aguirre <saaguirre@ti.com>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Philipp Wiesner <p.wiesner@phytec.de>,
	=?UTF-8?q?M=C3=A1rton=20N=C3=A9meth?= <nm127@freemail.hu>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: video: do not clear 'driver' from an i2c_client
Date: Wed, 10 Nov 2010 15:14:13 +0100
Message-Id: <1289398455-21949-1-git-send-email-w.sang@pengutronix.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The i2c-core does this already.

Reported-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---

Not sure if this should go via i2c or media?

 drivers/media/video/imx074.c     |    1 -
 drivers/media/video/mt9m001.c    |    1 -
 drivers/media/video/mt9m111.c    |    1 -
 drivers/media/video/mt9t031.c    |    1 -
 drivers/media/video/mt9v022.c    |    1 -
 drivers/media/video/rj54n1cb0c.c |    1 -
 6 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/imx074.c b/drivers/media/video/imx074.c
index 27b5dfd..1a11691 100644
--- a/drivers/media/video/imx074.c
+++ b/drivers/media/video/imx074.c
@@ -467,7 +467,6 @@ static int imx074_remove(struct i2c_client *client)
 	icd->ops = NULL;
 	if (icl->free_bus)
 		icl->free_bus(icl);
-	client->driver = NULL;
 	kfree(priv);
 
 	return 0;
diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index fcb4cd9..f7fc88d 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -798,7 +798,6 @@ static int mt9m001_remove(struct i2c_client *client)
 
 	icd->ops = NULL;
 	mt9m001_video_remove(icd);
-	client->driver = NULL;
 	kfree(mt9m001);
 
 	return 0;
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 525a16e..53fa2a7 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -1092,7 +1092,6 @@ static int mt9m111_remove(struct i2c_client *client)
 	struct soc_camera_device *icd = client->dev.platform_data;
 
 	icd->ops = NULL;
-	client->driver = NULL;
 	kfree(mt9m111);
 
 	return 0;
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index 9bd44a8..7ce279c 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -896,7 +896,6 @@ static int mt9t031_remove(struct i2c_client *client)
 
 	if (icd)
 		icd->ops = NULL;
-	client->driver = NULL;
 	kfree(mt9t031);
 
 	return 0;
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index b96171c..6a784c8 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -930,7 +930,6 @@ static int mt9v022_remove(struct i2c_client *client)
 
 	icd->ops = NULL;
 	mt9v022_video_remove(icd);
-	client->driver = NULL;
 	kfree(mt9v022);
 
 	return 0;
diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/video/rj54n1cb0c.c
index d2fa2d4..57e11b6 100644
--- a/drivers/media/video/rj54n1cb0c.c
+++ b/drivers/media/video/rj54n1cb0c.c
@@ -1460,7 +1460,6 @@ static int rj54n1_remove(struct i2c_client *client)
 	icd->ops = NULL;
 	if (icl->free_bus)
 		icl->free_bus(icl);
-	client->driver = NULL;
 	kfree(rj54n1);
 
 	return 0;
-- 
1.7.2.3

