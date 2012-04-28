Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4225 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab2D1PKI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 11:10:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 5/7] gscpa: use v4l2_fh and add G/S_PRIORITY support.
Date: Sat, 28 Apr 2012 17:09:54 +0200
Message-Id: <9d6d63bf8daefb1272273077dbdfb1389b17718c.1335625085.git.hans.verkuil@cisco.com>
In-Reply-To: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl>
References: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea7e986dc0fa18da12c22048e9187e9933191d3d.1335625085.git.hans.verkuil@cisco.com>
References: <ea7e986dc0fa18da12c22048e9187e9933191d3d.1335625085.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In order to support control event gspca has to use struct v4l2_fh.
As a bonus feature this also gives priority handling for free.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/gspca/gspca.c |   13 ++++++++++---
 drivers/media/video/gspca/gspca.h |    2 ++
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 5c1b53e..3d3b780 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -39,6 +39,7 @@
 #include <linux/ktime.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
 
 #include "gspca.h"
 
@@ -1327,6 +1328,7 @@ static void gspca_release(struct video_device *vfd)
 		video_device_node_name(&gspca_dev->vdev));
 
 	v4l2_ctrl_handler_free(gspca_dev->vdev.ctrl_handler);
+	v4l2_device_unregister(&gspca_dev->v4l2_dev);
 	kfree(gspca_dev->usb_buf);
 	kfree(gspca_dev);
 }
@@ -1352,7 +1354,7 @@ static int dev_open(struct file *file)
 		gspca_dev->vdev.debug &= ~(V4L2_DEBUG_IOCTL
 					| V4L2_DEBUG_IOCTL_ARG);
 #endif
-	return 0;
+	return v4l2_fh_open(file);
 }
 
 static int dev_close(struct file *file)
@@ -1378,7 +1380,7 @@ static int dev_close(struct file *file)
 
 	PDEBUG(D_STREAM, "close done");
 
-	return 0;
+	return v4l2_fh_release(file);
 }
 
 static int vidioc_querycap(struct file *file, void  *priv,
@@ -2345,12 +2347,16 @@ int gspca_dev_probe2(struct usb_interface *intf,
 		}
 	}
 
+	ret = v4l2_device_register(&intf->dev, &gspca_dev->v4l2_dev);
+	if (ret)
+		goto out;
 	gspca_dev->sd_desc = sd_desc;
 	gspca_dev->nbufread = 2;
 	gspca_dev->empty_packet = -1;	/* don't check the empty packets */
 	gspca_dev->vdev = gspca_template;
-	gspca_dev->vdev.parent = &intf->dev;
+	gspca_dev->vdev.v4l2_dev = &gspca_dev->v4l2_dev;
 	video_set_drvdata(&gspca_dev->vdev, gspca_dev);
+	set_bit(V4L2_FL_USE_FH_PRIO, &gspca_dev->vdev.flags);
 	gspca_dev->module = module;
 	gspca_dev->present = 1;
 
@@ -2458,6 +2464,7 @@ void gspca_disconnect(struct usb_interface *intf)
 
 	/* the device is freed at exit of this function */
 	gspca_dev->dev = NULL;
+	v4l2_device_disconnect(&gspca_dev->v4l2_dev);
 	mutex_unlock(&gspca_dev->usb_lock);
 
 	usb_set_intfdata(intf, NULL);
diff --git a/drivers/media/video/gspca/gspca.h b/drivers/media/video/gspca/gspca.h
index 589009f..2aacfa3 100644
--- a/drivers/media/video/gspca/gspca.h
+++ b/drivers/media/video/gspca/gspca.h
@@ -6,6 +6,7 @@
 #include <linux/usb.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
+#include <media/v4l2-device.h>
 #include <linux/mutex.h>
 
 /* compilation option */
@@ -158,6 +159,7 @@ struct gspca_frame {
 struct gspca_dev {
 	struct video_device vdev;	/* !! must be the first item */
 	struct module *module;		/* subdriver handling the device */
+	struct v4l2_device v4l2_dev;
 	struct usb_device *dev;
 	struct file *capt_file;		/* file doing video capture */
 #if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
-- 
1.7.10

