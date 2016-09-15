Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39274 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1763377AbcIOLWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 07:22:43 -0400
Received: from lanttu.localdomain (unknown [192.168.15.166])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id A0CEC600AD
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2016 14:22:36 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 15/17] smiapp: Obtain correct media bus code for try format
Date: Thu, 15 Sep 2016 14:22:29 +0300
Message-Id: <1473938551-14503-16-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media bus code obtained for try format may have been a code that the
sensor did not even support. Use a supported code with the current pixel
order.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 3548225..521afc0 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2602,8 +2602,6 @@ static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
 	struct smiapp_subdev *ssd = to_smiapp_subdev(sd);
 	struct smiapp_sensor *sensor = ssd->sensor;
-	u32 mbus_code =
-		smiapp_csi_data_formats[smiapp_pixel_order(sensor)].code;
 	unsigned int i;
 
 	mutex_lock(&sensor->mutex);
@@ -2619,7 +2617,7 @@ static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 
 		try_fmt->width = try_crop->width;
 		try_fmt->height = try_crop->height;
-		try_fmt->code = mbus_code;
+		try_fmt->code = sensor->internal_csi_format->code;
 		try_fmt->field = V4L2_FIELD_NONE;
 
 		if (ssd != sensor->pixel_array)
-- 
2.1.4

