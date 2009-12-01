Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out113.alice.it ([85.37.17.113]:2438 "EHLO
	smtp-out113.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbZLAPkX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 10:40:23 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>,
	Max Thrun <bear24rw@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] gspca: implement vidioc_enum_frameintervals
Date: Tue,  1 Dec 2009 16:39:31 +0100
Message-Id: <1259681971-10504-1-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <20091117114147.09889427.ospite@studenti.unina.it>
References: <20091117114147.09889427.ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some drivers support multiple frameintervals (framerates), make gspca able to
enumerate them.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
Changes since the initial RFC version:
 - 'i' is now a __u32 and the variable 'index' has been dropped.
 - some more comments in gspca.h

Thanks to Hans de Goede for the review.

For now I am postponing the patch to ov534 which uses this one, because I am
verifying what the actual framerates supported by the subdriver are.

Thanks,
   Antonio Ospite

diff -r 39c1be9a2ff8 -r ef8cca705478 linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Tue Dec 01 11:20:34 2009 +0100
+++ b/linux/drivers/media/video/gspca/gspca.c	Tue Dec 01 13:15:39 2009 +0100
@@ -998,6 +998,34 @@
 	return -EINVAL;
 }
 
+static int vidioc_enum_frameintervals(struct file *filp, void *priv,
+				      struct v4l2_frmivalenum *fival)
+{
+	struct gspca_dev *gspca_dev = priv;
+	int mode = wxh_to_mode(gspca_dev, fival->width, fival->height);
+	__u32 i;
+
+	if (gspca_dev->cam.mode_framerates == NULL ||
+			gspca_dev->cam.mode_framerates[mode].nrates == 0)
+		return -EINVAL;
+
+	if (fival->pixel_format !=
+			gspca_dev->cam.cam_mode[mode].pixelformat)
+		return -EINVAL;
+
+	for (i = 0; i < gspca_dev->cam.mode_framerates[mode].nrates; i++) {
+		if (fival->index == i) {
+			fival->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+			fival->discrete.numerator = 1;
+			fival->discrete.denominator =
+				gspca_dev->cam.mode_framerates[mode].rates[i];
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
 static void gspca_release(struct video_device *vfd)
 {
 	struct gspca_dev *gspca_dev = container_of(vfd, struct gspca_dev, vdev);
@@ -1990,6 +2018,7 @@
 	.vidioc_g_parm		= vidioc_g_parm,
 	.vidioc_s_parm		= vidioc_s_parm,
 	.vidioc_enum_framesizes = vidioc_enum_framesizes,
+	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register	= vidioc_g_register,
 	.vidioc_s_register	= vidioc_s_register,
diff -r 39c1be9a2ff8 -r ef8cca705478 linux/drivers/media/video/gspca/gspca.h
--- a/linux/drivers/media/video/gspca/gspca.h	Tue Dec 01 11:20:34 2009 +0100
+++ b/linux/drivers/media/video/gspca/gspca.h	Tue Dec 01 13:15:39 2009 +0100
@@ -45,11 +45,20 @@
 /* image transfers */
 #define MAX_NURBS 4		/* max number of URBs */
 
+
+/* used to list framerates supported by a camera mode (resolution) */
+struct framerates {
+	int *rates;
+	int nrates;
+};
+
 /* device information - set at probe time */
 struct cam {
 	int bulk_size;		/* buffer size when image transfer by bulk */
 	const struct v4l2_pix_format *cam_mode;	/* size nmodes */
 	char nmodes;
+	const struct framerates *mode_framerates; /* must have size nmode,
+						   * just like cam_mode */
 	__u8 bulk_nurbs;	/* number of URBs in bulk mode
 				 * - cannot be > MAX_NURBS
 				 * - when 0 and bulk_size != 0 means


