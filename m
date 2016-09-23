Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:50794 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966379AbcIWSlu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Sep 2016 14:41:50 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 1/2] media: platform: pxa_camera: add missing sensor power on
Date: Fri, 23 Sep 2016 20:41:39 +0200
Message-Id: <1474656100-7415-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During sensors binding, there is a window where the sensor is switched
off, while there is a call it to set a new format, which can end up in
an access to the sensor, especially an I2C based sensor.

Remove this window by activating the sensor.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/platform/pxa_camera.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 2978cd6efa63..794c41d24d9f 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -2128,17 +2128,22 @@ static int pxa_camera_sensor_bound(struct v4l2_async_notifier *notifier,
 				    pix->bytesperline, pix->height);
 	pix->pixelformat = pcdev->current_fmt->host_fmt->fourcc;
 	v4l2_fill_mbus_format(mf, pix, pcdev->current_fmt->code);
-	err = sensor_call(pcdev, pad, set_fmt, NULL, &format);
+
+	err = sensor_call(pcdev, core, s_power, 1);
 	if (err)
 		goto out;
 
+	err = sensor_call(pcdev, pad, set_fmt, NULL, &format);
+	if (err)
+		goto out_sensor_poweroff;
+
 	v4l2_fill_pix_format(pix, mf);
 	pr_info("%s(): colorspace=0x%x pixfmt=0x%x\n",
 		__func__, pix->colorspace, pix->pixelformat);
 
 	err = pxa_camera_init_videobuf2(pcdev);
 	if (err)
-		goto out;
+		goto out_sensor_poweroff;
 
 	err = video_register_device(&pcdev->vdev, VFL_TYPE_GRABBER, -1);
 	if (err) {
@@ -2149,6 +2154,9 @@ static int pxa_camera_sensor_bound(struct v4l2_async_notifier *notifier,
 			 "PXA Camera driver attached to camera %s\n",
 			 subdev->name);
 	}
+
+out_sensor_poweroff:
+	err = sensor_call(pcdev, core, s_power, 0);
 out:
 	mutex_unlock(&pcdev->mlock);
 	return err;
-- 
2.1.4

