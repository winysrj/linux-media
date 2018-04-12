Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56222 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751870AbeDLKaw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 06:30:52 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH v1.1 3/4] ov7740: Fix control handler error at the end of control init
Date: Thu, 12 Apr 2018 13:30:50 +0300
Message-Id: <20180412103050.8001-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20180412102150.29997-4-sakari.ailus@linux.intel.com>
References: <20180412102150.29997-4-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check that no error happened during adding controls to the driver's
control handler. Print an error message and bail out if there was one.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
since v1:

- Move error checking after clustering. While clustering won't cause an
  error now, it's better to check for errors only when everything has been
  done.

 drivers/media/i2c/ov7740.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/i2c/ov7740.c b/drivers/media/i2c/ov7740.c
index cbfa5a3327f6..3dad33c6180f 100644
--- a/drivers/media/i2c/ov7740.c
+++ b/drivers/media/i2c/ov7740.c
@@ -1006,6 +1006,13 @@ static int ov7740_init_controls(struct ov7740 *ov7740)
 			       V4L2_EXPOSURE_MANUAL, false);
 	v4l2_ctrl_cluster(2, &ov7740->hflip);
 
+	if (ctrl_hdlr->error) {
+		ret = ctrl_hdlr->error;
+		dev_err(&client->dev, "controls initialisation failed (%d)\n",
+			ret);
+		goto error;
+	}
+
 	ret = v4l2_ctrl_handler_setup(ctrl_hdlr);
 	if (ret) {
 		dev_err(&client->dev, "%s control init failed (%d)\n",
-- 
2.11.0
