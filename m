Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40810 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933377AbaLJVQk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Dec 2014 16:16:40 -0500
Received: from lanttu.localdomain (lanttu.localdomain [192.168.5.64])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 42172600A0
	for <linux-media@vger.kernel.org>; Wed, 10 Dec 2014 23:16:35 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH 5/7] smiapp: Move enumerating available media bus codes later
Date: Wed, 10 Dec 2014 23:16:18 +0200
Message-Id: <1418246180-667-6-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1418246180-667-1-git-send-email-sakari.ailus@iki.fi>
References: <1418246180-667-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the controls creation is separated in two sections, the available media
bus codes and link frequencies can be enumerated later on.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index e8e88bd..bacef3e 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2703,12 +2703,6 @@ static int smiapp_init(struct smiapp_sensor *sensor)
 	if (sensor->minfo.smiapp_profile == SMIAPP_PROFILE_0)
 		pll->flags |= SMIAPP_PLL_FLAG_NO_OP_CLOCKS;
 
-	rval = smiapp_get_mbus_formats(sensor);
-	if (rval) {
-		rval = -ENODEV;
-		goto out_cleanup;
-	}
-
 	for (i = 0; i < SMIAPP_SUBDEVS; i++) {
 		struct {
 			struct smiapp_subdev *ssd;
@@ -2778,6 +2772,12 @@ static int smiapp_init(struct smiapp_sensor *sensor)
 	if (rval < 0)
 		goto out_cleanup;
 
+	rval = smiapp_get_mbus_formats(sensor);
+	if (rval) {
+		rval = -ENODEV;
+		goto out_cleanup;
+	}
+
 	rval = smiapp_init_late_controls(sensor);
 	if (rval) {
 		rval = -ENODEV;
-- 
1.7.10.4

