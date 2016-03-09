Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:11224 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933141AbcCIQDb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Mar 2016 11:03:31 -0500
From: Antonio Ospite <ao2@ao2.it>
To: Linux Media <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, Antonio Ospite <ao2@ao2.it>
Subject: [PATCH 4/7] [media] gspca: fix a v4l2-compliance failure about VIDIOC_ENUM_FRAMEINTERVALS
Date: Wed,  9 Mar 2016 17:03:18 +0100
Message-Id: <1457539401-11515-5-git-send-email-ao2@ao2.it>
In-Reply-To: <1457539401-11515-1-git-send-email-ao2@ao2.it>
References: <1457539401-11515-1-git-send-email-ao2@ao2.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to v4l2-compliance VIDIOC_ENUM_FRAMEINTERVALS should fail for
unsupported frame sizes, but gspca is too tolerant and tries to find
the frame intervals for the frame size nearest to the requested one.

This makes v4l2-compliance fail with this message:

  fail: v4l2-test-formats.cpp(123): \
      found frame intervals for invalid size 321x240
  test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: FAIL

Fix this by using an exact match for the frame size when enumerating
frame intervals, and retuning an error if the frame size for which the
frame intervals have been asked is not supported.

Signed-off-by: Antonio Ospite <ao2@ao2.it>
---
 drivers/media/usb/gspca/gspca.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 1bb7901..61cb16d 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -991,6 +991,19 @@ static void gspca_set_default_mode(struct gspca_dev *gspca_dev)
 	v4l2_ctrl_handler_setup(gspca_dev->vdev.ctrl_handler);
 }
 
+static int wxh_to_mode(struct gspca_dev *gspca_dev,
+			int width, int height)
+{
+	int i;
+
+	for (i = 0; i < gspca_dev->cam.nmodes; i++) {
+		if (width == gspca_dev->cam.cam_mode[i].width
+		    && height == gspca_dev->cam.cam_mode[i].height)
+			return i;
+	}
+	return -EINVAL;
+}
+
 static int wxh_to_nearest_mode(struct gspca_dev *gspca_dev,
 			int width, int height)
 {
@@ -1233,9 +1246,13 @@ static int vidioc_enum_frameintervals(struct file *filp, void *priv,
 				      struct v4l2_frmivalenum *fival)
 {
 	struct gspca_dev *gspca_dev = video_drvdata(filp);
-	int mode = wxh_to_nearest_mode(gspca_dev, fival->width, fival->height);
+	int mode;
 	__u32 i;
 
+	mode = wxh_to_mode(gspca_dev, fival->width, fival->height);
+	if (mode < 0)
+		return -EINVAL;
+
 	if (gspca_dev->cam.mode_framerates == NULL ||
 			gspca_dev->cam.mode_framerates[mode].nrates == 0)
 		return -EINVAL;
-- 
2.7.0

