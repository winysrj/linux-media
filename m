Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:33079 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751218AbeFCOOh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Jun 2018 10:14:37 -0400
Received: by mail-pl0-f67.google.com with SMTP id n10-v6so18034262plp.0
        for <linux-media@vger.kernel.org>; Sun, 03 Jun 2018 07:14:37 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH] media: pxa_camera: ignore -ENOIOCTLCMD from v4l2_subdev_call for s_power
Date: Sun,  3 Jun 2018 23:14:25 +0900
Message-Id: <1528035265-14404-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the subdevice doesn't provide s_power core ops callback, the
v4l2_subdev_call for s_power returns -ENOIOCTLCMD.  If the subdevice
doesn't have the special handling for its power saving mode, the s_power
isn't required.  So -ENOIOCTLCMD from the v4l2_subdev_call should be
ignored.

Actually the -ENOIOCTLCMD is ignored in this driver's suspend/resume,
but the others treat the -ENOIOCTLCMD as an error.

This prepares a wrapper function to ignore -ENOIOCTLCMD and replaces
all s_power calls with it.

This also adds warning message when s_power() is failed.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/platform/pxa_camera.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index c792cb1..4d5a26b 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -2030,6 +2030,22 @@ static int pxac_vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	return 0;
 }
 
+static int pxac_sensor_set_power(struct pxa_camera_dev *pcdev, int on)
+{
+	int ret;
+
+	ret = sensor_call(pcdev, core, s_power, on);
+	if (ret == -ENOIOCTLCMD)
+		ret = 0;
+	if (ret) {
+		dev_warn(pcdev_to_dev(pcdev),
+			 "Failed to put subdevice in %s mode: %d\n",
+			 on ? "normal operation" : "power saving", ret);
+	}
+
+	return ret;
+}
+
 static int pxac_fops_camera_open(struct file *filp)
 {
 	struct pxa_camera_dev *pcdev = video_drvdata(filp);
@@ -2043,7 +2059,7 @@ static int pxac_fops_camera_open(struct file *filp)
 	if (!v4l2_fh_is_singular_file(filp))
 		goto out;
 
-	ret = sensor_call(pcdev, core, s_power, 1);
+	ret = pxac_sensor_set_power(pcdev, 1);
 	if (ret)
 		v4l2_fh_release(filp);
 out:
@@ -2064,7 +2080,7 @@ static int pxac_fops_camera_release(struct file *filp)
 	ret = _vb2_fop_release(filp, NULL);
 
 	if (fh_singular)
-		ret = sensor_call(pcdev, core, s_power, 0);
+		ret = pxac_sensor_set_power(pcdev, 0);
 
 	mutex_unlock(&pcdev->mlock);
 
@@ -2167,7 +2183,7 @@ static int pxa_camera_sensor_bound(struct v4l2_async_notifier *notifier,
 	pix->pixelformat = pcdev->current_fmt->host_fmt->fourcc;
 	v4l2_fill_mbus_format(mf, pix, pcdev->current_fmt->code);
 
-	err = sensor_call(pcdev, core, s_power, 1);
+	err = pxac_sensor_set_power(pcdev, 1);
 	if (err)
 		goto out;
 
@@ -2194,7 +2210,7 @@ static int pxa_camera_sensor_bound(struct v4l2_async_notifier *notifier,
 	}
 
 out_sensor_poweroff:
-	err = sensor_call(pcdev, core, s_power, 0);
+	err = pxac_sensor_set_power(pcdev, 0);
 out:
 	mutex_unlock(&pcdev->mlock);
 	return err;
@@ -2249,11 +2265,8 @@ static int pxa_camera_suspend(struct device *dev)
 	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR3);
 	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR4);
 
-	if (pcdev->sensor) {
-		ret = sensor_call(pcdev, core, s_power, 0);
-		if (ret == -ENOIOCTLCMD)
-			ret = 0;
-	}
+	if (pcdev->sensor)
+		ret = pxac_sensor_set_power(pcdev, 0);
 
 	return ret;
 }
@@ -2270,9 +2283,7 @@ static int pxa_camera_resume(struct device *dev)
 	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR4);
 
 	if (pcdev->sensor) {
-		ret = sensor_call(pcdev, core, s_power, 1);
-		if (ret == -ENOIOCTLCMD)
-			ret = 0;
+		ret = pxac_sensor_set_power(pcdev, 1);
 	}
 
 	/* Restart frame capture if active buffer exists */
-- 
2.7.4
