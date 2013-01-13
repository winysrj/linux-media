Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:62732 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab3AMMuo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 07:50:44 -0500
Received: by mail-ea0-f175.google.com with SMTP id d1so164433eab.6
        for <linux-media@vger.kernel.org>; Sun, 13 Jan 2013 04:50:43 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx: return -ENOTTY for tuner + frequency ioctls if the device has no tuner
Date: Sun, 13 Jan 2013 13:50:50 +0100
Message-Id: <1358081450-5705-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    8 ++++++++
 1 Datei geändert, 8 Zeilen hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 2eabf2a..4a7f73c 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1204,6 +1204,8 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	struct em28xx         *dev = fh->dev;
 	int                   rc;
 
+	if (dev->tuner_type == TUNER_ABSENT)
+		return -ENOTTY;
 	rc = check_dev(dev);
 	if (rc < 0)
 		return rc;
@@ -1224,6 +1226,8 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 	struct em28xx         *dev = fh->dev;
 	int                   rc;
 
+	if (dev->tuner_type == TUNER_ABSENT)
+		return -ENOTTY;
 	rc = check_dev(dev);
 	if (rc < 0)
 		return rc;
@@ -1241,6 +1245,8 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 	struct em28xx_fh      *fh  = priv;
 	struct em28xx         *dev = fh->dev;
 
+	if (dev->tuner_type == TUNER_ABSENT)
+		return -ENOTTY;
 	if (0 != f->tuner)
 		return -EINVAL;
 
@@ -1255,6 +1261,8 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	struct em28xx         *dev = fh->dev;
 	int                   rc;
 
+	if (dev->tuner_type == TUNER_ABSENT)
+		return -ENOTTY;
 	rc = check_dev(dev);
 	if (rc < 0)
 		return rc;
-- 
1.7.10.4

