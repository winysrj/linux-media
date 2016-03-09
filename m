Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:1578 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933151AbcCIQDb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Mar 2016 11:03:31 -0500
From: Antonio Ospite <ao2@ao2.it>
To: Linux Media <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, Antonio Ospite <ao2@ao2.it>
Subject: [PATCH 3/7] [media] gspca: rename wxh_to_mode() to wxh_to_nearest_mode()
Date: Wed,  9 Mar 2016 17:03:17 +0100
Message-Id: <1457539401-11515-4-git-send-email-ao2@ao2.it>
In-Reply-To: <1457539401-11515-1-git-send-email-ao2@ao2.it>
References: <1457539401-11515-1-git-send-email-ao2@ao2.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The name wxh_to_nearest_mode() reflects better what the function does.

Signed-off-by: Antonio Ospite <ao2@ao2.it>
---
 drivers/media/usb/gspca/gspca.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 9c8990f..1bb7901 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -991,7 +991,7 @@ static void gspca_set_default_mode(struct gspca_dev *gspca_dev)
 	v4l2_ctrl_handler_setup(gspca_dev->vdev.ctrl_handler);
 }
 
-static int wxh_to_mode(struct gspca_dev *gspca_dev,
+static int wxh_to_nearest_mode(struct gspca_dev *gspca_dev,
 			int width, int height)
 {
 	int i;
@@ -1125,8 +1125,8 @@ static int try_fmt_vid_cap(struct gspca_dev *gspca_dev,
 	PDEBUG_MODE(gspca_dev, D_CONF, "try fmt cap",
 		    fmt->fmt.pix.pixelformat, w, h);
 
-	/* search the closest mode for width and height */
-	mode = wxh_to_mode(gspca_dev, w, h);
+	/* search the nearest mode for width and height */
+	mode = wxh_to_nearest_mode(gspca_dev, w, h);
 
 	/* OK if right palette */
 	if (gspca_dev->cam.cam_mode[mode].pixelformat
@@ -1233,7 +1233,7 @@ static int vidioc_enum_frameintervals(struct file *filp, void *priv,
 				      struct v4l2_frmivalenum *fival)
 {
 	struct gspca_dev *gspca_dev = video_drvdata(filp);
-	int mode = wxh_to_mode(gspca_dev, fival->width, fival->height);
+	int mode = wxh_to_nearest_mode(gspca_dev, fival->width, fival->height);
 	__u32 i;
 
 	if (gspca_dev->cam.mode_framerates == NULL ||
-- 
2.7.0

