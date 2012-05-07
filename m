Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941Ab2EGTUh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 15:20:37 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, Hans Verkuil <hans.verkuil@cisco.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 04/23] gspca: allow subdrivers to use the control framework.
Date: Mon,  7 May 2012 21:01:15 +0200
Message-Id: <1336417294-4566-5-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
References: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Make the necessary changes to allow subdrivers to use the control framework.
This does not add control event support, that comes later.

It add a init_control cam_op that is called after init in probe that allows
the subdriver to set up the controls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/gspca.c |   25 +++++++++++++++++--------
 drivers/media/video/gspca/gspca.h |    1 +
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index ca5a2b1..c4ac15d 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -38,6 +38,7 @@
 #include <linux/uaccess.h>
 #include <linux/ktime.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
 
 #include "gspca.h"
 
@@ -1006,6 +1007,8 @@ static void gspca_set_default_mode(struct gspca_dev *gspca_dev)
 
 	/* set the current control values to their default values
 	 * which may have changed in sd_init() */
+	/* does nothing if ctrl_handler == NULL */
+	v4l2_ctrl_handler_setup(gspca_dev->vdev.ctrl_handler);
 	ctrl = gspca_dev->cam.ctrls;
 	if (ctrl != NULL) {
 		for (i = 0;
@@ -1323,6 +1326,7 @@ static void gspca_release(struct video_device *vfd)
 	PDEBUG(D_PROBE, "%s released",
 		video_device_node_name(&gspca_dev->vdev));
 
+	v4l2_ctrl_handler_free(gspca_dev->vdev.ctrl_handler);
 	kfree(gspca_dev->usb_buf);
 	kfree(gspca_dev);
 }
@@ -2347,6 +2351,14 @@ int gspca_dev_probe2(struct usb_interface *intf,
 	gspca_dev->sd_desc = sd_desc;
 	gspca_dev->nbufread = 2;
 	gspca_dev->empty_packet = -1;	/* don't check the empty packets */
+	gspca_dev->vdev = gspca_template;
+	gspca_dev->vdev.parent = &intf->dev;
+	gspca_dev->module = module;
+	gspca_dev->present = 1;
+
+	mutex_init(&gspca_dev->usb_lock);
+	mutex_init(&gspca_dev->queue_lock);
+	init_waitqueue_head(&gspca_dev->wq);
 
 	/* configure the subdriver and initialize the USB device */
 	ret = sd_desc->config(gspca_dev, id);
@@ -2357,21 +2369,17 @@ int gspca_dev_probe2(struct usb_interface *intf,
 	ret = sd_desc->init(gspca_dev);
 	if (ret < 0)
 		goto out;
+	if (sd_desc->init_controls)
+		ret = sd_desc->init_controls(gspca_dev);
+	if (ret < 0)
+		goto out;
 	gspca_set_default_mode(gspca_dev);
 
 	ret = gspca_input_connect(gspca_dev);
 	if (ret)
 		goto out;
 
-	mutex_init(&gspca_dev->usb_lock);
-	mutex_init(&gspca_dev->queue_lock);
-	init_waitqueue_head(&gspca_dev->wq);
-
 	/* init video stuff */
-	memcpy(&gspca_dev->vdev, &gspca_template, sizeof gspca_template);
-	gspca_dev->vdev.parent = &intf->dev;
-	gspca_dev->module = module;
-	gspca_dev->present = 1;
 	ret = video_register_device(&gspca_dev->vdev,
 				  VFL_TYPE_GRABBER,
 				  -1);
@@ -2391,6 +2399,7 @@ out:
 	if (gspca_dev->input_dev)
 		input_unregister_device(gspca_dev->input_dev);
 #endif
+	v4l2_ctrl_handler_free(gspca_dev->vdev.ctrl_handler);
 	kfree(gspca_dev->usb_buf);
 	kfree(gspca_dev);
 	return ret;
diff --git a/drivers/media/video/gspca/gspca.h b/drivers/media/video/gspca/gspca.h
index 589009f..8140416 100644
--- a/drivers/media/video/gspca/gspca.h
+++ b/drivers/media/video/gspca/gspca.h
@@ -115,6 +115,7 @@ struct sd_desc {
 /* mandatory operations */
 	cam_cf_op config;	/* called on probe */
 	cam_op init;		/* called on probe and resume */
+	cam_op init_controls;	/* called on probe */
 	cam_op start;		/* called on stream on after URBs creation */
 	cam_pkt_op pkt_scan;
 /* optional operations */
-- 
1.7.10

