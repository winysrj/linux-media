Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4852 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab2D1PKP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 11:10:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 7/7] gspca: fix querycap and incorrect return codes.
Date: Sat, 28 Apr 2012 17:09:56 +0200
Message-Id: <fb111b7f33a15a12243606ad49f8702996915486.1335625085.git.hans.verkuil@cisco.com>
In-Reply-To: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl>
References: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea7e986dc0fa18da12c22048e9187e9933191d3d.1335625085.git.hans.verkuil@cisco.com>
References: <ea7e986dc0fa18da12c22048e9187e9933191d3d.1335625085.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add V4L2_CAP_DEVICE_CAPS support to querycap and replace -EINVAL by
-ENOTTY whenever an ioctl is not supported.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/gspca/gspca.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 7b03f36..734eacd 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -1066,10 +1066,10 @@ static int vidioc_g_register(struct file *file, void *priv,
 	struct gspca_dev *gspca_dev = video_drvdata(file);
 
 	if (!gspca_dev->sd_desc->get_chip_ident)
-		return -EINVAL;
+		return -ENOTTY;
 
 	if (!gspca_dev->sd_desc->get_register)
-		return -EINVAL;
+		return -ENOTTY;
 
 	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
 		return -ERESTARTSYS;
@@ -1090,10 +1090,10 @@ static int vidioc_s_register(struct file *file, void *priv,
 	struct gspca_dev *gspca_dev = video_drvdata(file);
 
 	if (!gspca_dev->sd_desc->get_chip_ident)
-		return -EINVAL;
+		return -ENOTTY;
 
 	if (!gspca_dev->sd_desc->set_register)
-		return -EINVAL;
+		return -ENOTTY;
 
 	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
 		return -ERESTARTSYS;
@@ -1115,7 +1115,7 @@ static int vidioc_g_chip_ident(struct file *file, void *priv,
 	struct gspca_dev *gspca_dev = video_drvdata(file);
 
 	if (!gspca_dev->sd_desc->get_chip_ident)
-		return -EINVAL;
+		return -ENOTTY;
 
 	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
 		return -ERESTARTSYS;
@@ -1410,9 +1410,10 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	}
 	usb_make_path(gspca_dev->dev, (char *) cap->bus_info,
 			sizeof(cap->bus_info));
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE
 			  | V4L2_CAP_STREAMING
 			  | V4L2_CAP_READWRITE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	ret = 0;
 out:
 	mutex_unlock(&gspca_dev->usb_lock);
@@ -1565,7 +1566,7 @@ static int vidioc_querymenu(struct file *file, void *priv,
 	struct gspca_dev *gspca_dev = video_drvdata(file);
 
 	if (!gspca_dev->sd_desc->querymenu)
-		return -EINVAL;
+		return -ENOTTY;
 	return gspca_dev->sd_desc->querymenu(gspca_dev, qmenu);
 }
 
@@ -1774,7 +1775,7 @@ static int vidioc_g_jpegcomp(struct file *file, void *priv,
 	int ret;
 
 	if (!gspca_dev->sd_desc->get_jcomp)
-		return -EINVAL;
+		return -ENOTTY;
 	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
 		return -ERESTARTSYS;
 	gspca_dev->usb_err = 0;
@@ -1793,7 +1794,7 @@ static int vidioc_s_jpegcomp(struct file *file, void *priv,
 	int ret;
 
 	if (!gspca_dev->sd_desc->set_jcomp)
-		return -EINVAL;
+		return -ENOTTY;
 	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
 		return -ERESTARTSYS;
 	gspca_dev->usb_err = 0;
-- 
1.7.10

