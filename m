Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34665 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbeKUVeZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Nov 2018 16:34:25 -0500
Received: by mail-wr1-f67.google.com with SMTP id j2so5206921wrw.1
        for <linux-media@vger.kernel.org>; Wed, 21 Nov 2018 03:00:29 -0800 (PST)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: sakari.ailus@linux.intel.com
Cc: linux-media@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH] media: ov2680: fix null dereference at power on
Date: Wed, 21 Nov 2018 10:59:55 +0000
Message-Id: <20181121105955.9217-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Swapping the order between v4l2 subdevice registration and checking chip id in
b7a417628abf ("media: ov2680: don't register the v4l2 subdevice before checking chip ID")
makes the mode restore to use the sensor controls before they are set, so move
the mode restore call to s_power after the handler setup for controls is done.

This remove also the need for the error code path in power on function.

Fixes: b7a417628abf ("media: ov2680: don't register the v4l2 subdevice before checking chip ID")

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 drivers/media/i2c/ov2680.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/ov2680.c b/drivers/media/i2c/ov2680.c
index 0e34e15b67b3..b10bcfabaeeb 100644
--- a/drivers/media/i2c/ov2680.c
+++ b/drivers/media/i2c/ov2680.c
@@ -568,10 +568,6 @@ static int ov2680_power_on(struct ov2680_dev *sensor)
 	if (ret < 0)
 		return ret;
 
-	ret = ov2680_mode_restore(sensor);
-	if (ret < 0)
-		goto disable;
-
 	sensor->is_enabled = true;
 
 	/* Set clock lane into LP-11 state */
@@ -580,12 +576,6 @@ static int ov2680_power_on(struct ov2680_dev *sensor)
 	ov2680_stream_disable(sensor);
 
 	return 0;
-
-disable:
-	dev_err(dev, "failed to enable sensor: %d\n", ret);
-	ov2680_power_off(sensor);
-
-	return ret;
 }
 
 static int ov2680_s_power(struct v4l2_subdev *sd, int on)
@@ -606,6 +596,8 @@ static int ov2680_s_power(struct v4l2_subdev *sd, int on)
 		ret = v4l2_ctrl_handler_setup(&sensor->ctrls.handler);
 		if (ret < 0)
 			return ret;
+
+		ret = ov2680_mode_restore(sensor);
 	}
 
 	return ret;
-- 
2.19.1
