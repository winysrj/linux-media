Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:61883 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZGSEKz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 00:10:55 -0400
Received: by qw-out-2122.google.com with SMTP id 8so596625qwh.37
        for <linux-media@vger.kernel.org>; Sat, 18 Jul 2009 21:10:54 -0700 (PDT)
From: Brian Johnson <brijohn@gmail.com>
To: linux-media@vger.kernel.org
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Brian Johnson <brijohn@gmail.com>
Subject: [PATCH 1/2] gspca: add support for v4l2 debugging ioctls
Date: Sun, 19 Jul 2009 00:10:51 -0400
Message-Id: <1247976652-17031-2-git-send-email-brijohn@gmail.com>
In-Reply-To: <1247976652-17031-1-git-send-email-brijohn@gmail.com>
References: <1247976652-17031-1-git-send-email-brijohn@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for dbg_g_chip_ident, dbg_g_register,
and dbg_s_register to the gspca core module.

Signed-off-by: Brian Johnson <brijohn@gmail.com>
---
 drivers/media/video/gspca/gspca.c |   73 +++++++++++++++++++++++++++++++++++++
 drivers/media/video/gspca/gspca.h |    9 +++++
 2 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 1e89600..b8561df 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -727,6 +727,74 @@ static int gspca_get_mode(struct gspca_dev *gspca_dev,
 	return -EINVAL;
 }
 
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int vidioc_g_register(struct file *file, void *priv,
+			struct v4l2_dbg_register *reg)
+{
+	int ret;
+	struct gspca_dev *gspca_dev = priv;
+
+	if (!gspca_dev->sd_desc->get_chip_ident)
+		return -EINVAL;
+
+	if (!gspca_dev->sd_desc->get_register)
+		return -EINVAL;
+
+	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
+		return -ERESTARTSYS;
+	if (gspca_dev->present)
+		ret = gspca_dev->sd_desc->get_register(gspca_dev, reg);
+	else
+		ret = -ENODEV;
+	mutex_unlock(&gspca_dev->usb_lock);
+
+	return ret;
+}
+
+static int vidioc_s_register(struct file *file, void *priv,
+			struct v4l2_dbg_register *reg)
+{
+	int ret;
+	struct gspca_dev *gspca_dev = priv;
+
+	if (!gspca_dev->sd_desc->get_chip_ident)
+		return -EINVAL;
+
+	if (!gspca_dev->sd_desc->set_register)
+		return -EINVAL;
+
+	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
+		return -ERESTARTSYS;
+	if (gspca_dev->present)
+		ret = gspca_dev->sd_desc->set_register(gspca_dev, reg);
+	else
+		ret = -ENODEV;
+	mutex_unlock(&gspca_dev->usb_lock);
+
+	return ret;
+}
+#endif
+
+static int vidioc_g_chip_ident(struct file *file, void *priv,
+			struct v4l2_dbg_chip_ident *chip)
+{
+	int ret;
+	struct gspca_dev *gspca_dev = priv;
+
+	if (!gspca_dev->sd_desc->get_chip_ident)
+		return -EINVAL;
+
+	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
+		return -ERESTARTSYS;
+	if (gspca_dev->present)
+		ret = gspca_dev->sd_desc->get_chip_ident(gspca_dev, chip);
+	else
+		ret = -ENODEV;
+	mutex_unlock(&gspca_dev->usb_lock);
+
+	return ret;
+}
+
 static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 				struct v4l2_fmtdesc *fmtdesc)
 {
@@ -1883,6 +1951,11 @@ static const struct v4l2_ioctl_ops dev_ioctl_ops = {
 	.vidioc_s_parm		= vidioc_s_parm,
 	.vidioc_s_std		= vidioc_s_std,
 	.vidioc_enum_framesizes = vidioc_enum_framesizes,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_register	= vidioc_g_register,
+	.vidioc_s_register	= vidioc_s_register,
+#endif
+	.vidioc_g_chip_ident	= vidioc_g_chip_ident,
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
 	.vidiocgmbuf          = vidiocgmbuf,
 #endif
diff --git a/drivers/media/video/gspca/gspca.h b/drivers/media/video/gspca/gspca.h
index bd1faff..46c4eff 100644
--- a/drivers/media/video/gspca/gspca.h
+++ b/drivers/media/video/gspca/gspca.h
@@ -69,6 +69,10 @@ typedef void (*cam_v_op) (struct gspca_dev *);
 typedef int (*cam_cf_op) (struct gspca_dev *, const struct usb_device_id *);
 typedef int (*cam_jpg_op) (struct gspca_dev *,
 				struct v4l2_jpegcompression *);
+typedef int (*cam_reg_op) (struct gspca_dev *,
+				struct v4l2_dbg_register *);
+typedef int (*cam_ident_op) (struct gspca_dev *,
+				struct v4l2_dbg_chip_ident *);
 typedef int (*cam_streamparm_op) (struct gspca_dev *,
 				  struct v4l2_streamparm *);
 typedef int (*cam_qmnu_op) (struct gspca_dev *,
@@ -105,6 +109,11 @@ struct sd_desc {
 	cam_qmnu_op querymenu;
 	cam_streamparm_op get_streamparm;
 	cam_streamparm_op set_streamparm;
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	cam_reg_op set_register;
+	cam_reg_op get_register;
+#endif
+	cam_ident_op get_chip_ident;
 };
 
 /* packet types when moving from iso buf to frame buf */
-- 
1.5.6.3

