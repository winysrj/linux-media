Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:34953 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbaCXTc5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 15:32:57 -0400
Received: by mail-ee0-f52.google.com with SMTP id e49so4826711eek.11
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 12:32:56 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 05/19] em28xx: move struct v4l2_clk *clk from struct em28xx to struct v4l2
Date: Mon, 24 Mar 2014 20:33:11 +0100
Message-Id: <1395689605-2705-6-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-camera.c | 11 ++++++-----
 drivers/media/usb/em28xx/em28xx-video.c  |  6 +++---
 drivers/media/usb/em28xx/em28xx.h        |  2 +-
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index daebef3..c2672b4 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -330,13 +330,14 @@ int em28xx_init_camera(struct em28xx *dev)
 	char clk_name[V4L2_SUBDEV_NAME_SIZE];
 	struct i2c_client *client = &dev->i2c_client[dev->def_i2c_bus];
 	struct i2c_adapter *adap = &dev->i2c_adap[dev->def_i2c_bus];
+	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 	int ret = 0;
 
 	v4l2_clk_name_i2c(clk_name, sizeof(clk_name),
 			  i2c_adapter_id(adap), client->addr);
-	dev->clk = v4l2_clk_register_fixed(clk_name, "mclk", -EINVAL);
-	if (IS_ERR(dev->clk))
-		return PTR_ERR(dev->clk);
+	v4l2->clk = v4l2_clk_register_fixed(clk_name, "mclk", -EINVAL);
+	if (IS_ERR(v4l2->clk))
+		return PTR_ERR(v4l2->clk);
 
 	switch (dev->em28xx_sensor) {
 	case EM28XX_MT9V011:
@@ -448,8 +449,8 @@ int em28xx_init_camera(struct em28xx *dev)
 	}
 
 	if (ret < 0) {
-		v4l2_clk_unregister_fixed(dev->clk);
-		dev->clk = NULL;
+		v4l2_clk_unregister_fixed(v4l2->clk);
+		v4l2->clk = NULL;
 	}
 
 	return ret;
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 22acb0f..4fb0053 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1974,9 +1974,9 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 	v4l2_ctrl_handler_free(&v4l2->ctrl_handler);
 	v4l2_device_unregister(&v4l2->v4l2_dev);
 
-	if (dev->clk) {
-		v4l2_clk_unregister_fixed(dev->clk);
-		dev->clk = NULL;
+	if (v4l2->clk) {
+		v4l2_clk_unregister_fixed(v4l2->clk);
+		v4l2->clk = NULL;
 	}
 
 	kref_put(&v4l2->ref, em28xx_free_v4l2);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 910c2d8..a4d26bf 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -503,6 +503,7 @@ struct em28xx_v4l2 {
 
 	struct v4l2_device v4l2_dev;
 	struct v4l2_ctrl_handler ctrl_handler;
+	struct v4l2_clk *clk;
 };
 
 struct em28xx_audio {
@@ -568,7 +569,6 @@ struct em28xx {
 	unsigned int has_alsa_audio:1;
 	unsigned int is_audio_only:1;
 
-	struct v4l2_clk *clk;
 	struct em28xx_board board;
 
 	/* Webcam specific fields */
-- 
1.8.4.5

