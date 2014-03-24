Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:62916 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbaCXTcz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 15:32:55 -0400
Received: by mail-ee0-f47.google.com with SMTP id b15so4808094eek.6
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 12:32:54 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 04/19] em28xx: move struct v4l2_ctrl_handler ctrl_handler from struct em28xx to struct v4l2
Date: Mon, 24 Mar 2014 20:33:10 +0100
Message-Id: <1395689605-2705-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 13 +++++++++----
 drivers/media/usb/em28xx/em28xx.h       |  3 ++-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 89947db..22acb0f 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1138,7 +1138,9 @@ static void em28xx_ctrl_notify(struct v4l2_ctrl *ctrl, void *priv)
 
 static int em28xx_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct em28xx *dev = container_of(ctrl->handler, struct em28xx, ctrl_handler);
+	struct em28xx_v4l2 *v4l2 =
+		  container_of(ctrl->handler, struct em28xx_v4l2, ctrl_handler);
+	struct em28xx *dev = v4l2->dev;
 	int ret = -EINVAL;
 
 	switch (ctrl->id) {
@@ -1849,6 +1851,7 @@ void em28xx_free_v4l2(struct kref *ref)
 {
 	struct em28xx_v4l2 *v4l2 = container_of(ref, struct em28xx_v4l2, ref);
 
+	v4l2->dev->v4l2 = NULL;
 	kfree(v4l2);
 }
 
@@ -1968,7 +1971,7 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 		video_unregister_device(dev->vdev);
 	}
 
-	v4l2_ctrl_handler_free(&dev->ctrl_handler);
+	v4l2_ctrl_handler_free(&v4l2->ctrl_handler);
 	v4l2_device_unregister(&v4l2->v4l2_dev);
 
 	if (dev->clk) {
@@ -2276,7 +2279,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	u8 val;
 	int ret;
 	unsigned int maxw;
-	struct v4l2_ctrl_handler *hdl = &dev->ctrl_handler;
+	struct v4l2_ctrl_handler *hdl;
 	struct em28xx_v4l2 *v4l2;
 
 	if (dev->is_audio_only) {
@@ -2300,6 +2303,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		return -ENOMEM;
 	}
 	kref_init(&v4l2->ref);
+	v4l2->dev = dev;
 	dev->v4l2 = v4l2;
 
 	ret = v4l2_device_register(&dev->udev->dev, &v4l2->v4l2_dev);
@@ -2308,6 +2312,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		goto err;
 	}
 
+	hdl = &v4l2->ctrl_handler;
 	v4l2_ctrl_handler_init(hdl, 8);
 	v4l2->v4l2_dev.ctrl_handler = hdl;
 
@@ -2594,7 +2599,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	return 0;
 
 unregister_dev:
-	v4l2_ctrl_handler_free(&dev->ctrl_handler);
+	v4l2_ctrl_handler_free(&v4l2->ctrl_handler);
 	v4l2_device_unregister(&v4l2->v4l2_dev);
 err:
 	dev->v4l2 = NULL;
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index b18b968..910c2d8 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -499,8 +499,10 @@ struct em28xx_eeprom {
 
 struct em28xx_v4l2 {
 	struct kref ref;
+	struct em28xx *dev;
 
 	struct v4l2_device v4l2_dev;
+	struct v4l2_ctrl_handler ctrl_handler;
 };
 
 struct em28xx_audio {
@@ -566,7 +568,6 @@ struct em28xx {
 	unsigned int has_alsa_audio:1;
 	unsigned int is_audio_only:1;
 
-	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_clk *clk;
 	struct em28xx_board board;
 
-- 
1.8.4.5

