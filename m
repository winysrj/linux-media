Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58017 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbaCXTcv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 15:32:51 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so4761425eei.5
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 12:32:50 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 02/19] em28xx-video: simplify usage of the pointer to struct v4l2_ctrl_handler in em28xx_v4l2_init()
Date: Mon, 24 Mar 2014 20:33:08 +0100
Message-Id: <1395689605-2705-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 9df1826..45ad471 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2403,35 +2403,35 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	/* Add image controls */
 	/* NOTE: at this point, the subdevices are already registered, so bridge
 	 * controls are only added/enabled when no subdevice provides them */
-	if (NULL == v4l2_ctrl_find(&dev->ctrl_handler, V4L2_CID_CONTRAST))
-		v4l2_ctrl_new_std(&dev->ctrl_handler, &em28xx_ctrl_ops,
+	if (NULL == v4l2_ctrl_find(hdl, V4L2_CID_CONTRAST))
+		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
 				  V4L2_CID_CONTRAST,
 				  0, 0x1f, 1, CONTRAST_DEFAULT);
-	if (NULL == v4l2_ctrl_find(&dev->ctrl_handler, V4L2_CID_BRIGHTNESS))
-		v4l2_ctrl_new_std(&dev->ctrl_handler, &em28xx_ctrl_ops,
+	if (NULL == v4l2_ctrl_find(hdl, V4L2_CID_BRIGHTNESS))
+		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
 				  V4L2_CID_BRIGHTNESS,
 				  -0x80, 0x7f, 1, BRIGHTNESS_DEFAULT);
-	if (NULL == v4l2_ctrl_find(&dev->ctrl_handler, V4L2_CID_SATURATION))
-		v4l2_ctrl_new_std(&dev->ctrl_handler, &em28xx_ctrl_ops,
+	if (NULL == v4l2_ctrl_find(hdl, V4L2_CID_SATURATION))
+		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
 				  V4L2_CID_SATURATION,
 				  0, 0x1f, 1, SATURATION_DEFAULT);
-	if (NULL == v4l2_ctrl_find(&dev->ctrl_handler, V4L2_CID_BLUE_BALANCE))
-		v4l2_ctrl_new_std(&dev->ctrl_handler, &em28xx_ctrl_ops,
+	if (NULL == v4l2_ctrl_find(hdl, V4L2_CID_BLUE_BALANCE))
+		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
 				  V4L2_CID_BLUE_BALANCE,
 				  -0x30, 0x30, 1, BLUE_BALANCE_DEFAULT);
-	if (NULL == v4l2_ctrl_find(&dev->ctrl_handler, V4L2_CID_RED_BALANCE))
-		v4l2_ctrl_new_std(&dev->ctrl_handler, &em28xx_ctrl_ops,
+	if (NULL == v4l2_ctrl_find(hdl, V4L2_CID_RED_BALANCE))
+		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
 				  V4L2_CID_RED_BALANCE,
 				  -0x30, 0x30, 1, RED_BALANCE_DEFAULT);
-	if (NULL == v4l2_ctrl_find(&dev->ctrl_handler, V4L2_CID_SHARPNESS))
-		v4l2_ctrl_new_std(&dev->ctrl_handler, &em28xx_ctrl_ops,
+	if (NULL == v4l2_ctrl_find(hdl, V4L2_CID_SHARPNESS))
+		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
 				  V4L2_CID_SHARPNESS,
 				  0, 0x0f, 1, SHARPNESS_DEFAULT);
 
 	/* Reset image controls */
 	em28xx_colorlevels_set_default(dev);
-	v4l2_ctrl_handler_setup(&dev->ctrl_handler);
-	ret = dev->ctrl_handler.error;
+	v4l2_ctrl_handler_setup(hdl);
+	ret = hdl->error;
 	if (ret)
 		goto unregister_dev;
 
-- 
1.8.4.5

