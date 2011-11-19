Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53443 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1KSSuY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Nov 2011 13:50:24 -0500
Received: by ggnr5 with SMTP id r5so1169036ggn.19
        for <linux-media@vger.kernel.org>; Sat, 19 Nov 2011 10:50:23 -0800 (PST)
Date: Sat, 19 Nov 2011 15:50:15 -0300
From: Ezequiel <elezegarcia@gmail.com>
To: linux-media@vger.kernel.org
Cc: moinejf@free.fr, elezegarcia@gmail.com
Subject: [PATCH] [media] gspca: replaced static allocation by
 video_device_alloc/video_device_release
Message-ID: <20111119185015.GA3048@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pushed video_device initialization into a separate function.
Replaced static allocation of struct video_device by 
video_device_alloc/video_device_release usage.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 881e04c..1f27f05 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -1292,10 +1292,12 @@ static int vidioc_enum_frameintervals(struct file *filp, void *priv,
 
 static void gspca_release(struct video_device *vfd)
 {
-	struct gspca_dev *gspca_dev = container_of(vfd, struct gspca_dev, vdev);
+	struct gspca_dev *gspca_dev = video_get_drvdata(vfd);
 
 	PDEBUG(D_PROBE, "%s released",
-		video_device_node_name(&gspca_dev->vdev));
+		video_device_node_name(gspca_dev->vdev));
+
+	video_device_release(vfd);
 
 	kfree(gspca_dev->usb_buf);
 	kfree(gspca_dev);
@@ -1304,9 +1306,11 @@ static void gspca_release(struct video_device *vfd)
 static int dev_open(struct file *file)
 {
 	struct gspca_dev *gspca_dev;
+	struct video_device *vdev;
 
 	PDEBUG(D_STREAM, "[%s] open", current->comm);
-	gspca_dev = (struct gspca_dev *) video_devdata(file);
+	vdev = video_devdata(file);
+	gspca_dev = video_get_drvdata(vdev);
 	if (!gspca_dev->present)
 		return -ENODEV;
 
@@ -1318,10 +1322,10 @@ static int dev_open(struct file *file)
 #ifdef GSPCA_DEBUG
 	/* activate the v4l2 debug */
 	if (gspca_debug & D_V4L2)
-		gspca_dev->vdev.debug |= V4L2_DEBUG_IOCTL
+		gspca_dev->vdev->debug |= V4L2_DEBUG_IOCTL
 					| V4L2_DEBUG_IOCTL_ARG;
 	else
-		gspca_dev->vdev.debug &= ~(V4L2_DEBUG_IOCTL
+		gspca_dev->vdev->debug &= ~(V4L2_DEBUG_IOCTL
 					| V4L2_DEBUG_IOCTL_ARG);
