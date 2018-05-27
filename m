Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35508 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032634AbeE0PaV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 May 2018 11:30:21 -0400
Received: by mail-pf0-f193.google.com with SMTP id x9-v6so4692762pfm.2
        for <linux-media@vger.kernel.org>; Sun, 27 May 2018 08:30:21 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2] media: pxa_camera: avoid duplicate s_power calls
Date: Mon, 28 May 2018 00:30:11 +0900
Message-Id: <1527435011-9318-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The open() operation for the pxa_camera driver always calls s_power()
operation to put its subdevice sensor in normal operation mode, and the
release() operation always call s_power() operation to put the subdevice
in power saving mode.

This requires the subdevice sensor driver to keep track of its power
state in order to avoid putting the subdevice in power saving mode while
the device is still opened by some users.

Many subdevice drivers handle it by the boilerplate code that increments
and decrements an internal counter in s_power() like below:

	/*
	 * If the power count is modified from 0 to != 0 or from != 0 to 0,
	 * update the power state.
	 */
	if (sensor->power_count == !on) {
		ret = ov5640_set_power(sensor, !!on);
		if (ret)
			goto out;
	}

	/* Update the power count. */
	sensor->power_count += on ? 1 : -1;

However, some subdevice drivers don't handle it and may cause a problem
with the pxa_camera driver if the video device is opened by more than
two users at the same time.

Instead of propagating the boilerplate code for each subdevice driver
that implement s_power, this introduces an trick that many V4L2 drivers
are using with v4l2_fh_is_singular_file().

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v2
- Print warning message when s_power() is failed. (not printing warning
  when _vb2_fop_release() is failed as it always returns zero for now)

 drivers/media/platform/pxa_camera.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index c71a007..a35f461 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -2040,6 +2040,9 @@ static int pxac_fops_camera_open(struct file *filp)
 	if (ret < 0)
 		goto out;
 
+	if (!v4l2_fh_is_singular_file(filp))
+		goto out;
+
 	ret = sensor_call(pcdev, core, s_power, 1);
 	if (ret)
 		v4l2_fh_release(filp);
@@ -2052,13 +2055,23 @@ static int pxac_fops_camera_release(struct file *filp)
 {
 	struct pxa_camera_dev *pcdev = video_drvdata(filp);
 	int ret;
-
-	ret = vb2_fop_release(filp);
-	if (ret < 0)
-		return ret;
+	bool fh_singular;
 
 	mutex_lock(&pcdev->mlock);
-	ret = sensor_call(pcdev, core, s_power, 0);
+
+	fh_singular = v4l2_fh_is_singular_file(filp);
+
+	ret = _vb2_fop_release(filp, NULL);
+
+	if (fh_singular) {
+		ret = sensor_call(pcdev, core, s_power, 0);
+		if (ret) {
+			dev_warn(pcdev_to_dev(pcdev),
+				 "Failed to put subdevice in power saving mode: %d\n",
+				 ret);
+		}
+	}
+
 	mutex_unlock(&pcdev->mlock);
 
 	return ret;
-- 
2.7.4
