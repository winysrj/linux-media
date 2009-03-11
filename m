Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:28751 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311AbZCKNtc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 09:49:32 -0400
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, hverkuil@xs4all.nl
Subject: [PATCH] omap24xxcam: Fix use count handling if sensor enable fails in open()
Date: Wed, 11 Mar 2009 15:49:14 +0200
Message-Id: <1236779354-862-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Decrease use count back if omap24xxcam_sensor_enable() fails in
omap24xxcam_open(). Thanks to Hans Verkuil for pointing this out.

Compile tested only.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/omap24xxcam.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/omap24xxcam.c b/drivers/media/video/omap24xxcam.c
index 73eb656..3002051 100644
--- a/drivers/media/video/omap24xxcam.c
+++ b/drivers/media/video/omap24xxcam.c
@@ -1476,10 +1476,8 @@ static int omap24xxcam_open(struct file *file)
 
 	if (atomic_inc_return(&cam->users) == 1) {
 		omap24xxcam_hwinit(cam);
-		if (omap24xxcam_sensor_enable(cam)) {
-			mutex_unlock(&cam->mutex);
+		if (omap24xxcam_sensor_enable(cam))
 			goto out_omap24xxcam_sensor_enable;
-		}
 	}
 	mutex_unlock(&cam->mutex);
 
@@ -1502,7 +1500,9 @@ static int omap24xxcam_open(struct file *file)
 	return 0;
 
 out_omap24xxcam_sensor_enable:
+	atomic_dec(&cam->users);
 	omap24xxcam_poweron_reset(cam);
+	mutex_unlock(&cam->mutex);
 	module_put(cam->sdev->module);
 
 out_try_module_get:
-- 
1.5.6.5

