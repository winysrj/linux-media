Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:37043 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564AbaIRUyh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 16:54:37 -0400
Received: by mail-lb0-f171.google.com with SMTP id l4so1955581lbv.2
        for <linux-media@vger.kernel.org>; Thu, 18 Sep 2014 13:54:35 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH for 3.17] Revert "[media] em28xx-v4l: get rid of field "users" in struct em28xx_v4l2"
Date: Thu, 18 Sep 2014 22:55:45 +0200
Message-Id: <1411073745-17115-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit 747dba7de2a51a3db58b665ed3bc8c07921546ec.

It breaks concurrent vbi and video capturing:
While v4l2->users is the number of users of the whole device (all device nodes),
v4l2_fh_is_singular() only checks the number of users of a specific device node.
As a result. if one device node is open and a second device node is opened
(closed), the device is reinitialized (streaming is stopped).

Reported-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 23 ++++++++++-------------
 drivers/media/usb/em28xx/em28xx.h       |  1 +
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 90dec29..cef266c 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1883,8 +1883,9 @@ static int em28xx_v4l2_open(struct file *filp)
 		return -EINVAL;
 	}
 
-	em28xx_videodbg("open dev=%s type=%s\n",
-			video_device_node_name(vdev), v4l2_type_names[fh_type]);
+	em28xx_videodbg("open dev=%s type=%s users=%d\n",
+			video_device_node_name(vdev), v4l2_type_names[fh_type],
+			v4l2->users);
 
 	if (mutex_lock_interruptible(&dev->lock))
 		return -ERESTARTSYS;
@@ -1897,9 +1898,7 @@ static int em28xx_v4l2_open(struct file *filp)
 		return ret;
 	}
 
-	if (v4l2_fh_is_singular_file(filp)) {
-		em28xx_videodbg("first opened filehandle, initializing device\n");
-
+	if (v4l2->users == 0) {
 		em28xx_set_mode(dev, EM28XX_ANALOG_MODE);
 
 		if (vdev->vfl_type != VFL_TYPE_RADIO)
@@ -1910,8 +1909,6 @@ static int em28xx_v4l2_open(struct file *filp)
 		 * of some i2c devices
 		 */
 		em28xx_wake_i2c(dev);
-	} else {
-		em28xx_videodbg("further filehandles are already opened\n");
 	}
 
 	if (vdev->vfl_type == VFL_TYPE_RADIO) {
@@ -1921,6 +1918,7 @@ static int em28xx_v4l2_open(struct file *filp)
 
 	kref_get(&dev->ref);
 	kref_get(&v4l2->ref);
+	v4l2->users++;
 
 	mutex_unlock(&dev->lock);
 
@@ -2027,11 +2025,12 @@ static int em28xx_v4l2_close(struct file *filp)
 	struct em28xx_v4l2    *v4l2 = dev->v4l2;
 	int              errCode;
 
-	mutex_lock(&dev->lock);
+	em28xx_videodbg("users=%d\n", v4l2->users);
 
-	if (v4l2_fh_is_singular_file(filp)) {
-		em28xx_videodbg("last opened filehandle, shutting down device\n");
+	vb2_fop_release(filp);
+	mutex_lock(&dev->lock);
 
+	if (v4l2->users == 1) {
 		/* No sense to try to write to the device */
 		if (dev->disconnected)
 			goto exit;
@@ -2050,12 +2049,10 @@ static int em28xx_v4l2_close(struct file *filp)
 			em28xx_errdev("cannot change alternate number to "
 					"0 (error=%i)\n", errCode);
 		}
-	} else {
-		em28xx_videodbg("further opened filehandles left\n");
 	}
 
 exit:
-	vb2_fop_release(filp);
+	v4l2->users--;
 	kref_put(&v4l2->ref, em28xx_free_v4l2);
 	mutex_unlock(&dev->lock);
 	kref_put(&dev->ref, em28xx_free_device);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 84ef8ef..4360338 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -524,6 +524,7 @@ struct em28xx_v4l2 {
 	int sensor_yres;
 	int sensor_xtal;
 
+	int users;		/* user count for exclusive use */
 	int streaming_users;    /* number of actively streaming users */
 
 	u32 frequency;		/* selected tuner frequency */
-- 
1.8.4.5

