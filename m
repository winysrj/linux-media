Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:60178 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671Ab3AYR1H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 12:27:07 -0500
Received: by mail-ea0-f179.google.com with SMTP id d12so260708eaa.10
        for <linux-media@vger.kernel.org>; Fri, 25 Jan 2013 09:27:06 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [REVIEW PATCH 10/12] em28xx: remove obsolete device state checks from the ioctl functions
Date: Fri, 25 Jan 2013 18:27:00 +0100
Message-Id: <1359134822-4585-11-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_device_disconnect() is called when the device is disconnected, so that the
v4l2-core rejects all ioctl calls.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   43 -------------------------------
 1 Datei geändert, 43 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 319d0ee..dd05cfb 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -799,15 +799,6 @@ const struct v4l2_ctrl_ops em28xx_ctrl_ops = {
 	.s_ctrl = em28xx_s_ctrl,
 };
 
-static int check_dev(struct em28xx *dev)
-{
-	if (dev->disconnected) {
-		em28xx_errdev("v4l2 ioctl: device not present\n");
-		return -ENODEV;
-	}
-	return 0;
-}
-
 static void get_scale(struct em28xx *dev,
 			unsigned int width, unsigned int height,
 			unsigned int *hscale, unsigned int *vscale)
@@ -957,11 +948,6 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *norm)
 {
 	struct em28xx_fh   *fh  = priv;
 	struct em28xx      *dev = fh->dev;
-	int                rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
 
 	*norm = dev->norm;
 
@@ -972,11 +958,6 @@ static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *norm)
 {
 	struct em28xx_fh   *fh  = priv;
 	struct em28xx      *dev = fh->dev;
-	int                rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, video, querystd, norm);
 
@@ -988,13 +969,9 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 	struct em28xx_fh   *fh  = priv;
 	struct em28xx      *dev = fh->dev;
 	struct v4l2_format f;
-	int                rc;
 
 	if (*norm == dev->norm)
 		return 0;
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
 
 	if (dev->streaming_users > 0)
 		return -EBUSY;
@@ -1101,11 +1078,6 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 {
 	struct em28xx_fh   *fh  = priv;
 	struct em28xx      *dev = fh->dev;
-	int                rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
 
 	if (i >= MAX_EM28XX_INPUT)
 		return -EINVAL;
@@ -1180,11 +1152,6 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 {
 	struct em28xx_fh      *fh  = priv;
 	struct em28xx         *dev = fh->dev;
-	int                   rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
 
 	if (0 != t->index)
 		return -EINVAL;
@@ -1200,11 +1167,6 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 {
 	struct em28xx_fh      *fh  = priv;
 	struct em28xx         *dev = fh->dev;
-	int                   rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
 
 	if (0 != t->index)
 		return -EINVAL;
@@ -1231,11 +1193,6 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 {
 	struct em28xx_fh      *fh  = priv;
 	struct em28xx         *dev = fh->dev;
-	int                   rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
 
 	if (0 != f->tuner)
 		return -EINVAL;
-- 
1.7.10.4

