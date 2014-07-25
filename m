Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43741 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935085AbaGYRsL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 13:48:11 -0400
Received: by mail-wi0-f180.google.com with SMTP id n3so1408841wiv.1
        for <linux-media@vger.kernel.org>; Fri, 25 Jul 2014 10:48:10 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 4/4] em28xx-v4l: get rid of field "users" in struct em28xx_v4l2
Date: Fri, 25 Jul 2014 19:48:58 +0200
Message-Id: <1406310538-5001-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1406310538-5001-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1406310538-5001-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of counting the number of opened file handles, use function
v4l2_fh_is_singular_file() in em28xx_v4l2_open() and em28xx_v4l2_close() to
determine if the file handle is the first/last opened one.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 23 +++++++++++++----------
 drivers/media/usb/em28xx/em28xx.h       |  1 -
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 3a7ec3b..087ccf9 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1883,9 +1883,8 @@ static int em28xx_v4l2_open(struct file *filp)
 		return -EINVAL;
 	}
 
-	em28xx_videodbg("open dev=%s type=%s users=%d\n",
-			video_device_node_name(vdev), v4l2_type_names[fh_type],
-			v4l2->users);
+	em28xx_videodbg("open dev=%s type=%s\n",
+			video_device_node_name(vdev), v4l2_type_names[fh_type]);
 
 	if (mutex_lock_interruptible(&dev->lock))
 		return -ERESTARTSYS;
@@ -1898,7 +1897,9 @@ static int em28xx_v4l2_open(struct file *filp)
 		return ret;
 	}
 
-	if (v4l2->users == 0) {
+	if (v4l2_fh_is_singular_file(filp)) {
+		em28xx_videodbg("first opened filehandle, initializing device\n");
+
 		em28xx_set_mode(dev, EM28XX_ANALOG_MODE);
 
 		if (vdev->vfl_type != VFL_TYPE_RADIO)
@@ -1909,6 +1910,8 @@ static int em28xx_v4l2_open(struct file *filp)
 		 * of some i2c devices
 		 */
 		em28xx_wake_i2c(dev);
+	} else {
+		em28xx_videodbg("further filehandles are already opened\n");
 	}
 
 	if (vdev->vfl_type == VFL_TYPE_RADIO) {
@@ -1918,7 +1921,6 @@ static int em28xx_v4l2_open(struct file *filp)
 
 	kref_get(&dev->ref);
 	kref_get(&v4l2->ref);
-	v4l2->users++;
 
 	mutex_unlock(&dev->lock);
 
@@ -2025,12 +2027,11 @@ static int em28xx_v4l2_close(struct file *filp)
 	struct em28xx_v4l2    *v4l2 = dev->v4l2;
 	int              errCode;
 
-	em28xx_videodbg("users=%d\n", v4l2->users);
-
-	vb2_fop_release(filp);
 	mutex_lock(&dev->lock);
 
-	if (v4l2->users == 1) {
+	if (v4l2_fh_is_singular_file(filp)) {
+		em28xx_videodbg("last opened filehandle, shutting down device\n");
+
 		/* No sense to try to write to the device */
 		if (dev->disconnected)
 			goto exit;
@@ -2049,10 +2050,12 @@ static int em28xx_v4l2_close(struct file *filp)
 			em28xx_errdev("cannot change alternate number to "
 					"0 (error=%i)\n", errCode);
 		}
+	} else {
+		em28xx_videodbg("further opened filehandles left\n");
 	}
 
 exit:
-	v4l2->users--;
+	vb2_fop_release(filp);
 	kref_put(&v4l2->ref, em28xx_free_v4l2);
 	mutex_unlock(&dev->lock);
 	kref_put(&dev->ref, em28xx_free_device);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 4360338..84ef8ef 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -524,7 +524,6 @@ struct em28xx_v4l2 {
 	int sensor_yres;
 	int sensor_xtal;
 
-	int users;		/* user count for exclusive use */
 	int streaming_users;    /* number of actively streaming users */
 
 	u32 frequency;		/* selected tuner frequency */
-- 
1.8.4.5

