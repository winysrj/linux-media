Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3211 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab2D1PKK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 11:10:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 1/7] gspca: allow subdrivers to use the control framework.
Date: Sat, 28 Apr 2012 17:09:50 +0200
Message-Id: <ea7e986dc0fa18da12c22048e9187e9933191d3d.1335625085.git.hans.verkuil@cisco.com>
In-Reply-To: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl>
References: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Make the necessary changes to allow subdrivers to use the control framework.
This does not add control event support, that needs more work.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/gspca/gspca.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index ca5a2b1..56dff10 100644
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
@@ -2347,6 +2351,10 @@ int gspca_dev_probe2(struct usb_interface *intf,
 	gspca_dev->sd_desc = sd_desc;
 	gspca_dev->nbufread = 2;
 	gspca_dev->empty_packet = -1;	/* don't check the empty packets */
+	gspca_dev->vdev = gspca_template;
+	gspca_dev->vdev.parent = &intf->dev;
+	gspca_dev->module = module;
+	gspca_dev->present = 1;
 
 	/* configure the subdriver and initialize the USB device */
 	ret = sd_desc->config(gspca_dev, id);
@@ -2368,10 +2376,6 @@ int gspca_dev_probe2(struct usb_interface *intf,
 	init_waitqueue_head(&gspca_dev->wq);
 
 	/* init video stuff */
-	memcpy(&gspca_dev->vdev, &gspca_template, sizeof gspca_template);
-	gspca_dev->vdev.parent = &intf->dev;
-	gspca_dev->module = module;
-	gspca_dev->present = 1;
 	ret = video_register_device(&gspca_dev->vdev,
 				  VFL_TYPE_GRABBER,
 				  -1);
@@ -2391,6 +2395,7 @@ out:
 	if (gspca_dev->input_dev)
 		input_unregister_device(gspca_dev->input_dev);
 #endif
+	v4l2_ctrl_handler_free(gspca_dev->vdev.ctrl_handler);
 	kfree(gspca_dev->usb_buf);
 	kfree(gspca_dev);
 	return ret;
-- 
1.7.10

