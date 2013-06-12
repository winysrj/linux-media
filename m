Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4220 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445Ab3FLPCQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jun 2013 11:02:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 07/12] pvrusb2: use v4l2_dev instead of the deprecated parent field.
Date: Wed, 12 Jun 2013 17:00:57 +0200
Message-Id: <1371049262-5799-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1371049262-5799-1-git-send-email-hverkuil@xs4all.nl>
References: <1371049262-5799-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c  |    4 ++++
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h  |    4 ++++
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c |    7 ++++---
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index d329209..c4d51d7 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -2704,6 +2704,10 @@ static void pvr2_hdw_remove_usb_stuff(struct pvr2_hdw *hdw)
 	pvr2_hdw_render_useless(hdw);
 }
 
+void pvr2_hdw_set_v4l2_dev(struct pvr2_hdw *hdw, struct video_device *vdev)
+{
+	vdev->v4l2_dev = &hdw->v4l2_dev;
+}
 
 /* Destroy hardware interaction structure */
 void pvr2_hdw_destroy(struct pvr2_hdw *hdw)
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.h b/drivers/media/usb/pvrusb2/pvrusb2-hdw.h
index 1a135cf..4184707 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.h
@@ -22,6 +22,7 @@
 
 #include <linux/usb.h>
 #include <linux/videodev2.h>
+#include <media/v4l2-dev.h>
 #include "pvrusb2-io.h"
 #include "pvrusb2-ctrl.h"
 
@@ -138,6 +139,9 @@ const char *pvr2_hdw_get_device_identifier(struct pvr2_hdw *);
 /* Called when hardware has been unplugged */
 void pvr2_hdw_disconnect(struct pvr2_hdw *);
 
+/* Sets v4l2_dev of a video_device struct */
+void pvr2_hdw_set_v4l2_dev(struct pvr2_hdw *, struct video_device *);
+
 /* Get the number of defined controls */
 unsigned int pvr2_hdw_get_ctrl_count(struct pvr2_hdw *);
 
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index 82f619b..d77069e 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -31,6 +31,7 @@
 #include <linux/videodev2.h>
 #include <linux/module.h>
 #include <media/v4l2-dev.h>
+#include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 
@@ -870,8 +871,8 @@ static void pvr2_v4l2_dev_destroy(struct pvr2_v4l2_dev *dip)
 static void pvr2_v4l2_dev_disassociate_parent(struct pvr2_v4l2_dev *dip)
 {
 	if (!dip) return;
-	if (!dip->devbase.parent) return;
-	dip->devbase.parent = NULL;
+	if (!dip->devbase.v4l2_dev->dev) return;
+	dip->devbase.v4l2_dev->dev = NULL;
 	device_move(&dip->devbase.dev, NULL, DPM_ORDER_NONE);
 }
 
@@ -1321,7 +1322,7 @@ static void pvr2_v4l2_dev_init(struct pvr2_v4l2_dev *dip,
 	if (nr_ptr && (unit_number >= 0) && (unit_number < PVR_NUM)) {
 		mindevnum = nr_ptr[unit_number];
 	}
-	dip->devbase.parent = &usbdev->dev;
+	pvr2_hdw_set_v4l2_dev(hdw, &dip->devbase);
 	if ((video_register_device(&dip->devbase,
 				   dip->v4l_type, mindevnum) < 0) &&
 	    (video_register_device(&dip->devbase,
-- 
1.7.10.4

