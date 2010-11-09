Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35735 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab0KIPa2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Nov 2010 10:30:28 -0500
Received: from localhost.localdomain (unknown [91.178.204.79])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 8E64735CB5
	for <linux-media@vger.kernel.org>; Tue,  9 Nov 2010 15:30:27 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] v4l: Remove hardcoded module names passed to v4l2_i2c_new_subdev* (2)
Date: Tue,  9 Nov 2010 16:30:27 +0100
Message-Id: <1289316628-9394-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1289316628-9394-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1289316628-9394-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With the v4l2_i2c_new_subdev* functions now supporting loading modules
based on modaliases, replace the hardcoded module name passed to those
functions by NULL in the cafe-ccic, via-camera and s5p-fimc drivers.

All corresponding I2C modules have been checked, and all of them include
a module aliases table with names corresponding to what the drivers
modified here use.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/cafe_ccic.c             |    3 +--
 drivers/media/video/s5p-fimc/fimc-capture.c |    2 +-
 drivers/media/video/via-camera.c            |    2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
index 5ae2cec..68b6dce 100644
--- a/drivers/media/video/cafe_ccic.c
+++ b/drivers/media/video/cafe_ccic.c
@@ -2064,8 +2064,7 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 
 	cam->sensor_addr = 0x42;
 	cam->sensor = v4l2_i2c_new_subdev_cfg(&cam->v4l2_dev, &cam->i2c_adapter,
-			"ov7670", "ov7670", 0, &sensor_cfg, cam->sensor_addr,
-			NULL);
+			NULL, "ov7670", 0, &sensor_cfg, cam->sensor_addr, NULL);
 	if (cam->sensor == NULL) {
 		ret = -ENODEV;
 		goto out_smbus;
diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index e8f13d3..26f7ad2 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -44,7 +44,7 @@ static struct v4l2_subdev *fimc_subdev_register(struct fimc_dev *fimc,
 		return ERR_PTR(-ENOMEM);
 
 	sd = v4l2_i2c_new_subdev_board(&vid_cap->v4l2_dev, i2c_adap,
-				       MODULE_NAME, isp_info->board_info, NULL);
+				       NULL, isp_info->board_info, NULL);
 	if (!sd) {
 		v4l2_err(&vid_cap->v4l2_dev, "failed to acquire subdev\n");
 		return NULL;
diff --git a/drivers/media/video/via-camera.c b/drivers/media/video/via-camera.c
index 02a21bc..01bcdb4 100644
--- a/drivers/media/video/via-camera.c
+++ b/drivers/media/video/via-camera.c
@@ -1360,7 +1360,7 @@ static __devinit int viacam_probe(struct platform_device *pdev)
 	 */
 	sensor_adapter = viafb_find_i2c_adapter(VIA_PORT_31);
 	cam->sensor = v4l2_i2c_new_subdev(&cam->v4l2_dev, sensor_adapter,
-			"ov7670", "ov7670", 0x42 >> 1, NULL);
+			NULL, "ov7670", 0x42 >> 1, NULL);
 	if (cam->sensor == NULL) {
 		dev_err(&pdev->dev, "Unable to find the sensor!\n");
 		ret = -ENODEV;
-- 
1.7.2.2

