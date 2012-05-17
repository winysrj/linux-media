Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:30305 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762194Ab2EQQae (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 12:30:34 -0400
Received: from maxwell.research.nokia.com (maxwell.research.nokia.com [172.21.199.25])
	by mgw-sa01.nokia.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q4HGUW8s029805
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 17 May 2012 19:30:33 +0300
Received: from lanttu (lanttu-o.localdomain [192.168.239.74])
	by maxwell.research.nokia.com (Postfix) with ESMTPS id 600021F4C5A
	for <linux-media@vger.kernel.org>; Thu, 17 May 2012 19:30:32 +0300 (EEST)
Received: from sakke by lanttu with local (Exim 4.72)
	(envelope-from <sakari.ailus@maxwell.research.nokia.com>)
	id 1SV3at-000871-7H
	for linux-media@vger.kernel.org; Thu, 17 May 2012 19:30:27 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 07/10] smiapp: Use non-binning limits if the binning limit is zero
Date: Thu, 17 May 2012 19:30:06 +0300
Message-Id: <1337272209-31061-7-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4FB52770.9000400@maxwell.research.nokia.com>
References: <4FB52770.9000400@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some sensors do use binning but do not have valid limits in binning
registers. Use non-binning limits in that case.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/smiapp/smiapp-core.c |   31 +++++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/smiapp/smiapp-core.c b/drivers/media/video/smiapp/smiapp-core.c
index 6524091..47d6901 100644
--- a/drivers/media/video/smiapp/smiapp-core.c
+++ b/drivers/media/video/smiapp/smiapp-core.c
@@ -653,6 +653,7 @@ static int smiapp_get_all_limits(struct smiapp_sensor *sensor)
 
 static int smiapp_get_limits_binning(struct smiapp_sensor *sensor)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	static u32 const limits[] = {
 		SMIAPP_LIMIT_MIN_FRAME_LENGTH_LINES_BIN,
 		SMIAPP_LIMIT_MAX_FRAME_LENGTH_LINES_BIN,
@@ -671,11 +672,11 @@ static int smiapp_get_limits_binning(struct smiapp_sensor *sensor)
 		SMIAPP_LIMIT_FINE_INTEGRATION_TIME_MIN,
 		SMIAPP_LIMIT_FINE_INTEGRATION_TIME_MAX_MARGIN,
 	};
+	unsigned int i;
+	int rval;
 
 	if (sensor->limits[SMIAPP_LIMIT_BINNING_CAPABILITY] ==
 	    SMIAPP_BINNING_CAPABILITY_NO) {
-		unsigned int i;
-
 		for (i = 0; i < ARRAY_SIZE(limits); i++)
 			sensor->limits[limits[i]] =
 				sensor->limits[limits_replace[i]];
@@ -683,7 +684,31 @@ static int smiapp_get_limits_binning(struct smiapp_sensor *sensor)
 		return 0;
 	}
 
-	return smiapp_get_limits(sensor, limits, ARRAY_SIZE(limits));
+	rval = smiapp_get_limits(sensor, limits, ARRAY_SIZE(limits));
+	if (rval < 0)
+		return rval;
+
+	/*
+	 * Sanity check whether the binning limits are valid. If not,
+	 * use the non-binning ones.
+	 */
+	if (sensor->limits[SMIAPP_LIMIT_MIN_FRAME_LENGTH_LINES_BIN]
+	    && sensor->limits[SMIAPP_LIMIT_MIN_LINE_LENGTH_PCK_BIN]
+	    && sensor->limits[SMIAPP_LIMIT_MIN_LINE_BLANKING_PCK_BIN])
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(limits); i++) {
+		dev_dbg(&client->dev,
+			"replace limit 0x%8.8x \"%s\" = %d, 0x%x\n",
+			smiapp_reg_limits[limits[i]].addr,
+			smiapp_reg_limits[limits[i]].what,
+			sensor->limits[limits_replace[i]],
+			sensor->limits[limits_replace[i]]);
+		sensor->limits[limits[i]] =
+			sensor->limits[limits_replace[i]];
+	}
+
+	return 0;
 }
 
 static int smiapp_get_mbus_formats(struct smiapp_sensor *sensor)
-- 
1.7.2.5

