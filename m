Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:30143 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762181Ab2EQQaZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 12:30:25 -0400
Received: from maxwell.research.nokia.com (maxwell.research.nokia.com [172.21.199.25])
	by mgw-sa01.nokia.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q4HGUNnr029673
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 17 May 2012 19:30:24 +0300
Received: from lanttu (lanttu-o.localdomain [192.168.239.74])
	by maxwell.research.nokia.com (Postfix) with ESMTPS id 316F21F4D24
	for <linux-media@vger.kernel.org>; Thu, 17 May 2012 19:30:23 +0300 (EEST)
Received: from sakke by lanttu with local (Exim 4.72)
	(envelope-from <sakari.ailus@maxwell.research.nokia.com>)
	id 1SV3ak-00086d-13
	for linux-media@vger.kernel.org; Thu, 17 May 2012 19:30:18 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 04/10] smiapp: Use 8-bit reads only before identifying the sensor
Date: Thu, 17 May 2012 19:30:03 +0300
Message-Id: <1337272209-31061-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4FB52770.9000400@maxwell.research.nokia.com>
References: <4FB52770.9000400@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some sensors only allow 8-bit access, so use safe 8-bit access before the
sensor has been identified.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/smiapp/smiapp-core.c |   63 ++++++++++++++++--------------
 1 files changed, 34 insertions(+), 29 deletions(-)

diff --git a/drivers/media/video/smiapp/smiapp-core.c b/drivers/media/video/smiapp/smiapp-core.c
index de5c947..3bf086f 100644
--- a/drivers/media/video/smiapp/smiapp-core.c
+++ b/drivers/media/video/smiapp/smiapp-core.c
@@ -2197,51 +2197,56 @@ static int smiapp_identify_module(struct v4l2_subdev *subdev)
 	minfo->name = SMIAPP_NAME;
 
 	/* Module info */
-	rval = smiapp_read(sensor, SMIAPP_REG_U8_MANUFACTURER_ID,
-			   &minfo->manufacturer_id);
+	rval = smiapp_read_8only(sensor, SMIAPP_REG_U8_MANUFACTURER_ID,
+				 &minfo->manufacturer_id);
 	if (!rval)
-		rval = smiapp_read(sensor, SMIAPP_REG_U16_MODEL_ID,
-				   &minfo->model_id);
+		rval = smiapp_read_8only(sensor, SMIAPP_REG_U16_MODEL_ID,
+					 &minfo->model_id);
 	if (!rval)
-		rval = smiapp_read(sensor, SMIAPP_REG_U8_REVISION_NUMBER_MAJOR,
-				   &minfo->revision_number_major);
+		rval = smiapp_read_8only(sensor,
+					 SMIAPP_REG_U8_REVISION_NUMBER_MAJOR,
+					 &minfo->revision_number_major);
 	if (!rval)
-		rval = smiapp_read(sensor, SMIAPP_REG_U8_REVISION_NUMBER_MINOR,
-				   &minfo->revision_number_minor);
+		rval = smiapp_read_8only(sensor,
+					 SMIAPP_REG_U8_REVISION_NUMBER_MINOR,
+					 &minfo->revision_number_minor);
 	if (!rval)
-		rval = smiapp_read(sensor, SMIAPP_REG_U8_MODULE_DATE_YEAR,
-				   &minfo->module_year);
+		rval = smiapp_read_8only(sensor,
+					 SMIAPP_REG_U8_MODULE_DATE_YEAR,
+					 &minfo->module_year);
 	if (!rval)
-		rval = smiapp_read(sensor, SMIAPP_REG_U8_MODULE_DATE_MONTH,
-				   &minfo->module_month);
+		rval = smiapp_read_8only(sensor,
+					 SMIAPP_REG_U8_MODULE_DATE_MONTH,
+					 &minfo->module_month);
 	if (!rval)
-		rval = smiapp_read(sensor, SMIAPP_REG_U8_MODULE_DATE_DAY,
-				   &minfo->module_day);
+		rval = smiapp_read_8only(sensor, SMIAPP_REG_U8_MODULE_DATE_DAY,
+					 &minfo->module_day);
 
 	/* Sensor info */
 	if (!rval)
-		rval = smiapp_read(sensor,
-				   SMIAPP_REG_U8_SENSOR_MANUFACTURER_ID,
-				   &minfo->sensor_manufacturer_id);
+		rval = smiapp_read_8only(sensor,
+					 SMIAPP_REG_U8_SENSOR_MANUFACTURER_ID,
+					 &minfo->sensor_manufacturer_id);
 	if (!rval)
-		rval = smiapp_read(sensor, SMIAPP_REG_U16_SENSOR_MODEL_ID,
-				   &minfo->sensor_model_id);
+		rval = smiapp_read_8only(sensor,
+					 SMIAPP_REG_U16_SENSOR_MODEL_ID,
+					 &minfo->sensor_model_id);
 	if (!rval)
-		rval = smiapp_read(sensor,
-				   SMIAPP_REG_U8_SENSOR_REVISION_NUMBER,
-				   &minfo->sensor_revision_number);
+		rval = smiapp_read_8only(sensor,
+					 SMIAPP_REG_U8_SENSOR_REVISION_NUMBER,
+					 &minfo->sensor_revision_number);
 	if (!rval)
-		rval = smiapp_read(sensor,
-				   SMIAPP_REG_U8_SENSOR_FIRMWARE_VERSION,
-				   &minfo->sensor_firmware_version);
+		rval = smiapp_read_8only(sensor,
+					 SMIAPP_REG_U8_SENSOR_FIRMWARE_VERSION,
+					 &minfo->sensor_firmware_version);
 
 	/* SMIA */
 	if (!rval)
-		rval = smiapp_read(sensor, SMIAPP_REG_U8_SMIA_VERSION,
-				   &minfo->smia_version);
+		rval = smiapp_read_8only(sensor, SMIAPP_REG_U8_SMIA_VERSION,
+					 &minfo->smia_version);
 	if (!rval)
-		rval = smiapp_read(sensor, SMIAPP_REG_U8_SMIAPP_VERSION,
-				   &minfo->smiapp_version);
+		rval = smiapp_read_8only(sensor, SMIAPP_REG_U8_SMIAPP_VERSION,
+					 &minfo->smiapp_version);
 
 	if (rval) {
 		dev_err(&client->dev, "sensor detection failed\n");
-- 
1.7.2.5

