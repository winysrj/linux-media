Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:43319 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932107AbeCKPe7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Mar 2018 11:34:59 -0400
Received: by mail-pf0-f196.google.com with SMTP id j2so3290719pff.10
        for <linux-media@vger.kernel.org>; Sun, 11 Mar 2018 08:34:58 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH] media: ov5640: add missing output pixel format setting
Date: Mon, 12 Mar 2018 00:34:41 +0900
Message-Id: <1520782481-13558-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The output pixel format changed by set_fmt() pad operation is not
correctly applied.  It is intended to be restored by calling
ov5640_set_framefmt() when the video stream is started.

However, when the device is powered on by s_power subdev operation before
the video stream is started, the current output mode setting is restored
by ov5640_restore_mode() that also clears pending_mode_change flag in
ov5640_set_mode().  So ov5640_set_framefmt() isn't called as intended and
the output pixel format is not restored.

This change adds the missing output pixel format setting in the
ov5640_restore_mode() that is called when the device is powered on.

Cc: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov5640.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index e2dd352..4eecc91 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1633,6 +1633,9 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 	return 0;
 }
 
+static int ov5640_set_framefmt(struct ov5640_dev *sensor,
+			       struct v4l2_mbus_framefmt *format);
+
 /* restore the last set video mode after chip power-on */
 static int ov5640_restore_mode(struct ov5640_dev *sensor)
 {
@@ -1644,7 +1647,11 @@ static int ov5640_restore_mode(struct ov5640_dev *sensor)
 		return ret;
 
 	/* now restore the last capture mode */
-	return ov5640_set_mode(sensor, &ov5640_mode_init_data);
+	ret = ov5640_set_mode(sensor, &ov5640_mode_init_data);
+	if (ret < 0)
+		return ret;
+
+	return ov5640_set_framefmt(sensor, &sensor->fmt);
 }
 
 static void ov5640_power(struct ov5640_dev *sensor, bool enable)
-- 
2.7.4
