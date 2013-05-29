Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3718 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965542Ab3E2LAr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:00:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	stoth@linuxtv.org, Scott Jiang <scott.jiang.linux@gmail.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Andrey Smirnov <andrew.smirnov@gmail.com>
Subject: [PATCHv1 02/38] v4l2: remove g_chip_ident from bridge drivers where it is easy to do so.
Date: Wed, 29 May 2013 12:59:35 +0200
Message-Id: <1369825211-29770-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

VIDIOC_DBG_G_CHIP_IDENT has been replaced by VIDIOC_DBG_G_CHIP_INFO. Remove
g_chip_ident support from bridge drivers since it is no longer needed.

This patch takes care of all the trivial cases.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: stoth@linuxtv.org
Cc: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Andrey Smirnov <andrew.smirnov@gmail.com>
---
 drivers/media/common/saa7146/saa7146_video.c   |   23 ---------
 drivers/media/pci/bt8xx/bttv-driver.c          |   38 --------------
 drivers/media/pci/saa7134/saa7134-empress.c    |   17 ------
 drivers/media/pci/saa7134/saa7134-video.c      |    4 --
 drivers/media/pci/saa7146/mxb.c                |   15 ++----
 drivers/media/pci/saa7164/saa7164-encoder.c    |   37 -------------
 drivers/media/pci/saa7164/saa7164-vbi.c        |    9 ----
 drivers/media/pci/saa7164/saa7164.h            |    1 -
 drivers/media/platform/blackfin/bfin_capture.c |   41 ---------------
 drivers/media/platform/davinci/vpif_capture.c  |   66 ------------------------
 drivers/media/platform/davinci/vpif_display.c  |   66 ------------------------
 drivers/media/platform/sh_vou.c                |   31 -----------
 drivers/media/platform/soc_camera/soc_camera.c |   34 ------------
 drivers/media/platform/via-camera.c            |   16 ------
 drivers/media/radio/radio-si476x.c             |   11 ----
 drivers/media/usb/au0828/au0828-video.c        |   39 --------------
 drivers/media/usb/em28xx/em28xx-video.c        |   66 +++---------------------
 drivers/media/usb/stk1160/stk1160-v4l.c        |   41 ---------------
 18 files changed, 10 insertions(+), 545 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
index fe907f2..3077949 100644
--- a/drivers/media/common/saa7146/saa7146_video.c
+++ b/drivers/media/common/saa7146/saa7146_video.c
@@ -1,7 +1,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <media/saa7146_vv.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-ctrls.h>
 #include <linux/module.h>
@@ -988,26 +987,6 @@ static int vidioc_streamoff(struct file *file, void *__fh, enum v4l2_buf_type ty
 	return err;
 }
 
-static int vidioc_g_chip_ident(struct file *file, void *__fh,
-		struct v4l2_dbg_chip_ident *chip)
-{
-	struct saa7146_fh *fh = __fh;
-	struct saa7146_dev *dev = fh->dev;
-
-	chip->ident = V4L2_IDENT_NONE;
-	chip->revision = 0;
-	if (chip->match.type == V4L2_CHIP_MATCH_HOST) {
-		if (v4l2_chip_match_host(&chip->match))
-			chip->ident = V4L2_IDENT_SAA7146;
-		return 0;
-	}
-	if (chip->match.type != V4L2_CHIP_MATCH_I2C_DRIVER &&
-	    chip->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
-		return -EINVAL;
-	return v4l2_device_call_until_err(&dev->v4l2_dev, 0,
-			core, g_chip_ident, chip);
-}
-
 const struct v4l2_ioctl_ops saa7146_video_ioctl_ops = {
 	.vidioc_querycap             = vidioc_querycap,
 	.vidioc_enum_fmt_vid_cap     = vidioc_enum_fmt_vid_cap,
@@ -1018,7 +997,6 @@ const struct v4l2_ioctl_ops saa7146_video_ioctl_ops = {
 	.vidioc_g_fmt_vid_overlay    = vidioc_g_fmt_vid_overlay,
 	.vidioc_try_fmt_vid_overlay  = vidioc_try_fmt_vid_overlay,
 	.vidioc_s_fmt_vid_overlay    = vidioc_s_fmt_vid_overlay,
-	.vidioc_g_chip_ident         = vidioc_g_chip_ident,
 
 	.vidioc_overlay 	     = vidioc_overlay,
 	.vidioc_g_fbuf  	     = vidioc_g_fbuf,
@@ -1039,7 +1017,6 @@ const struct v4l2_ioctl_ops saa7146_video_ioctl_ops = {
 const struct v4l2_ioctl_ops saa7146_vbi_ioctl_ops = {
 	.vidioc_querycap             = vidioc_querycap,
 	.vidioc_g_fmt_vbi_cap        = vidioc_g_fmt_vbi_cap,
-	.vidioc_g_chip_ident         = vidioc_g_chip_ident,
 
 	.vidioc_reqbufs              = vidioc_reqbufs,
 	.vidioc_querybuf             = vidioc_querybuf,
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index a334c94..bfcfa3e 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -50,7 +50,6 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/tvaudio.h>
 #include <media/msp3400.h>
 
@@ -1907,28 +1906,6 @@ static int bttv_log_status(struct file *file, void *f)
 	return 0;
 }
 
-static int bttv_g_chip_ident(struct file *file, void *f, struct v4l2_dbg_chip_ident *chip)
-{
-	struct bttv_fh *fh  = f;
-	struct bttv *btv = fh->btv;
-
-	chip->ident = V4L2_IDENT_NONE;
-	chip->revision = 0;
-	if (chip->match.type == V4L2_CHIP_MATCH_HOST) {
-		if (v4l2_chip_match_host(&chip->match)) {
-			chip->ident = btv->id;
-			if (chip->ident == PCI_DEVICE_ID_FUSION879)
-				chip->ident = V4L2_IDENT_BT879;
-		}
-		return 0;
-	}
-	if (chip->match.type != V4L2_CHIP_MATCH_I2C_DRIVER &&
-	    chip->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
-		return -EINVAL;
-	/* TODO: is this correct? */
-	return bttv_call_all_err(btv, core, g_chip_ident, chip);
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int bttv_g_register(struct file *file, void *f,
 					struct v4l2_dbg_register *reg)
@@ -1936,13 +1913,6 @@ static int bttv_g_register(struct file *file, void *f,
 	struct bttv_fh *fh = f;
 	struct bttv *btv = fh->btv;
 
-	if (!v4l2_chip_match_host(&reg->match)) {
-		/* TODO: subdev errors should not be ignored, this should become a
-		   subdev helper function. */
-		bttv_call_all(btv, core, g_register, reg);
-		return 0;
-	}
-
 	/* bt848 has a 12-bit register space */
 	reg->reg &= 0xfff;
 	reg->val = btread(reg->reg);
@@ -1957,13 +1927,6 @@ static int bttv_s_register(struct file *file, void *f,
 	struct bttv_fh *fh = f;
 	struct bttv *btv = fh->btv;
 
-	if (!v4l2_chip_match_host(&reg->match)) {
-		/* TODO: subdev errors should not be ignored, this should become a
-		   subdev helper function. */
-		bttv_call_all(btv, core, s_register, reg);
-		return 0;
-	}
-
 	/* bt848 has a 12-bit register space */
 	btwrite(reg->val, reg->reg & 0xfff);
 
@@ -3203,7 +3166,6 @@ static const struct v4l2_ioctl_ops bttv_ioctl_ops = {
 	.vidioc_querystd		= bttv_querystd,
 	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
-	.vidioc_g_chip_ident		= bttv_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register		= bttv_g_register,
 	.vidioc_s_register		= bttv_s_register,
diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 66a7081..05ab2cb 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -28,7 +28,6 @@
 
 #include <media/saa6752hs.h>
 #include <media/v4l2-common.h>
-#include <media/v4l2-chip-ident.h>
 
 /* ------------------------------------------------------------------ */
 
@@ -413,21 +412,6 @@ static int empress_querymenu(struct file *file, void *priv,
 	return saa_call_empress(dev, core, querymenu, c);
 }
 
-static int empress_g_chip_ident(struct file *file, void *fh,
-	       struct v4l2_dbg_chip_ident *chip)
-{
-	struct saa7134_dev *dev = file->private_data;
-
-	chip->ident = V4L2_IDENT_NONE;
-	chip->revision = 0;
-	if (chip->match.type == V4L2_CHIP_MATCH_I2C_DRIVER &&
-	    !strcmp(chip->match.name, "saa6752hs"))
-		return saa_call_empress(dev, core, g_chip_ident, chip);
-	if (chip->match.type == V4L2_CHIP_MATCH_I2C_ADDR)
-		return saa_call_empress(dev, core, g_chip_ident, chip);
-	return -EINVAL;
-}
-
 static int empress_s_std(struct file *file, void *priv, v4l2_std_id id)
 {
 	struct saa7134_dev *dev = file->private_data;
@@ -475,7 +459,6 @@ static const struct v4l2_ioctl_ops ts_ioctl_ops = {
 	.vidioc_querymenu		= empress_querymenu,
 	.vidioc_g_ctrl			= empress_g_ctrl,
 	.vidioc_s_ctrl			= empress_s_ctrl,
-	.vidioc_g_chip_ident 		= empress_g_chip_ident,
 	.vidioc_s_std			= empress_s_std,
 	.vidioc_g_std			= empress_g_std,
 };
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index cc40938..737e643 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2258,8 +2258,6 @@ static int vidioc_g_register (struct file *file, void *priv,
 	struct saa7134_fh *fh = priv;
 	struct saa7134_dev *dev = fh->dev;
 
-	if (!v4l2_chip_match_host(&reg->match))
-		return -EINVAL;
 	reg->val = saa_readb(reg->reg);
 	reg->size = 1;
 	return 0;
@@ -2271,8 +2269,6 @@ static int vidioc_s_register (struct file *file, void *priv,
 	struct saa7134_fh *fh = priv;
 	struct saa7134_dev *dev = fh->dev;
 
-	if (!v4l2_chip_match_host(&reg->match))
-		return -EINVAL;
 	saa_writeb(reg->reg&0xffffff, reg->val);
 	return 0;
 }
diff --git a/drivers/media/pci/saa7146/mxb.c b/drivers/media/pci/saa7146/mxb.c
index 52cbe7a0..8d17769 100644
--- a/drivers/media/pci/saa7146/mxb.c
+++ b/drivers/media/pci/saa7146/mxb.c
@@ -669,12 +669,8 @@ static int vidioc_g_register(struct file *file, void *fh, struct v4l2_dbg_regist
 {
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 
-	if (v4l2_chip_match_host(&reg->match)) {
-		reg->val = saa7146_read(dev, reg->reg);
-		reg->size = 4;
-		return 0;
-	}
-	call_all(dev, core, g_register, reg);
+	reg->val = saa7146_read(dev, reg->reg);
+	reg->size = 4;
 	return 0;
 }
 
@@ -682,11 +678,8 @@ static int vidioc_s_register(struct file *file, void *fh, const struct v4l2_dbg_
 {
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 
-	if (v4l2_chip_match_host(&reg->match)) {
-		saa7146_write(dev, reg->reg, reg->val);
-		return 0;
-	}
-	return call_all(dev, core, s_register, reg);
+	saa7146_write(dev, reg->reg, reg->val);
+	return 0;
 }
 #endif
 
diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index 63a72fb..e4f53a5 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -1288,38 +1288,6 @@ static const struct v4l2_file_operations mpeg_fops = {
 	.unlocked_ioctl	= video_ioctl2,
 };
 
-static int saa7164_g_chip_ident(struct file *file, void *fh,
-				struct v4l2_dbg_chip_ident *chip)
-{
-	struct saa7164_port *port = ((struct saa7164_encoder_fh *)fh)->port;
-	struct saa7164_dev *dev = port->dev;
-	dprintk(DBGLVL_ENC, "%s()\n", __func__);
-
-	return 0;
-}
-
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-static int saa7164_g_register(struct file *file, void *fh,
-			      struct v4l2_dbg_register *reg)
-{
-	struct saa7164_port *port = ((struct saa7164_encoder_fh *)fh)->port;
-	struct saa7164_dev *dev = port->dev;
-	dprintk(DBGLVL_ENC, "%s()\n", __func__);
-
-	return 0;
-}
-
-static int saa7164_s_register(struct file *file, void *fh,
-			      const struct v4l2_dbg_register *reg)
-{
-	struct saa7164_port *port = ((struct saa7164_encoder_fh *)fh)->port;
-	struct saa7164_dev *dev = port->dev;
-	dprintk(DBGLVL_ENC, "%s()\n", __func__);
-
-	return 0;
-}
-#endif
-
 static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_s_std		 = vidioc_s_std,
 	.vidioc_enum_input	 = vidioc_enum_input,
@@ -1340,11 +1308,6 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_s_ext_ctrls	 = vidioc_s_ext_ctrls,
 	.vidioc_try_ext_ctrls	 = vidioc_try_ext_ctrls,
 	.vidioc_queryctrl	 = vidioc_queryctrl,
-	.vidioc_g_chip_ident	 = saa7164_g_chip_ident,
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	.vidioc_g_register	 = saa7164_g_register,
-	.vidioc_s_register	 = saa7164_s_register,
-#endif
 };
 
 static struct video_device saa7164_mpeg_template = {
diff --git a/drivers/media/pci/saa7164/saa7164-vbi.c b/drivers/media/pci/saa7164/saa7164-vbi.c
index da224eb..5a1a69b 100644
--- a/drivers/media/pci/saa7164/saa7164-vbi.c
+++ b/drivers/media/pci/saa7164/saa7164-vbi.c
@@ -1254,15 +1254,6 @@ static const struct v4l2_ioctl_ops vbi_ioctl_ops = {
 	.vidioc_s_ext_ctrls	 = vidioc_s_ext_ctrls,
 	.vidioc_try_ext_ctrls	 = vidioc_try_ext_ctrls,
 	.vidioc_queryctrl	 = vidioc_queryctrl,
-#if 0
-	.vidioc_g_chip_ident	 = saa7164_g_chip_ident,
-#endif
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-#if 0
-	.vidioc_g_register	 = saa7164_g_register,
-	.vidioc_s_register	 = saa7164_s_register,
-#endif
-#endif
 	.vidioc_g_fmt_vbi_cap	 = saa7164_vbi_fmt,
 	.vidioc_try_fmt_vbi_cap	 = saa7164_vbi_fmt,
 	.vidioc_s_fmt_vbi_cap	 = saa7164_vbi_fmt,
diff --git a/drivers/media/pci/saa7164/saa7164.h b/drivers/media/pci/saa7164/saa7164.h
index 437284e..8d9c7e6 100644
--- a/drivers/media/pci/saa7164/saa7164.h
+++ b/drivers/media/pci/saa7164/saa7164.h
@@ -63,7 +63,6 @@
 #include <dmxdev.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
-#include <media/v4l2-chip-ident.h>
 
 #include "saa7164-reg.h"
 #include "saa7164-types.h"
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index ca8d56a..6652e71 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -32,7 +32,6 @@
 #include <linux/time.h>
 #include <linux/types.h>
 
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
@@ -876,41 +875,6 @@ static int bcap_s_parm(struct file *file, void *fh,
 	return v4l2_subdev_call(bcap_dev->sd, video, s_parm, a);
 }
 
-static int bcap_g_chip_ident(struct file *file, void *priv,
-		struct v4l2_dbg_chip_ident *chip)
-{
-	struct bcap_device *bcap_dev = video_drvdata(file);
-
-	chip->ident = V4L2_IDENT_NONE;
-	chip->revision = 0;
-	if (chip->match.type != V4L2_CHIP_MATCH_I2C_DRIVER &&
-			chip->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
-		return -EINVAL;
-
-	return v4l2_subdev_call(bcap_dev->sd, core,
-			g_chip_ident, chip);
-}
-
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-static int bcap_dbg_g_register(struct file *file, void *priv,
-		struct v4l2_dbg_register *reg)
-{
-	struct bcap_device *bcap_dev = video_drvdata(file);
-
-	return v4l2_subdev_call(bcap_dev->sd, core,
-			g_register, reg);
-}
-
-static int bcap_dbg_s_register(struct file *file, void *priv,
-		const struct v4l2_dbg_register *reg)
-{
-	struct bcap_device *bcap_dev = video_drvdata(file);
-
-	return v4l2_subdev_call(bcap_dev->sd, core,
-			s_register, reg);
-}
-#endif
-
 static int bcap_log_status(struct file *file, void *priv)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
@@ -943,11 +907,6 @@ static const struct v4l2_ioctl_ops bcap_ioctl_ops = {
 	.vidioc_streamoff        = bcap_streamoff,
 	.vidioc_g_parm           = bcap_g_parm,
 	.vidioc_s_parm           = bcap_s_parm,
-	.vidioc_g_chip_ident     = bcap_g_chip_ident,
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	.vidioc_g_register       = bcap_dbg_g_register,
-	.vidioc_s_register       = bcap_dbg_s_register,
-#endif
 	.vidioc_log_status       = bcap_log_status,
 };
 
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index caaf4fe..d004531 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -24,7 +24,6 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ioctl.h>
 
 #include "vpif.h"
@@ -1863,66 +1862,6 @@ static int vpif_g_dv_timings(struct file *file, void *priv,
 }
 
 /*
- * vpif_g_chip_ident() - Identify the chip
- * @file: file ptr
- * @priv: file handle
- * @chip: chip identity
- *
- * Returns zero or -EINVAL if read operations fails.
- */
-static int vpif_g_chip_ident(struct file *file, void *priv,
-		struct v4l2_dbg_chip_ident *chip)
-{
-	chip->ident = V4L2_IDENT_NONE;
-	chip->revision = 0;
-	if (chip->match.type != V4L2_CHIP_MATCH_I2C_DRIVER &&
-			chip->match.type != V4L2_CHIP_MATCH_I2C_ADDR) {
-		vpif_dbg(2, debug, "match_type is invalid.\n");
-		return -EINVAL;
-	}
-
-	return v4l2_device_call_until_err(&vpif_obj.v4l2_dev, 0, core,
-			g_chip_ident, chip);
-}
-
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-/*
- * vpif_dbg_g_register() - Read register
- * @file: file ptr
- * @priv: file handle
- * @reg: register to be read
- *
- * Debugging only
- * Returns zero or -EINVAL if read operations fails.
- */
-static int vpif_dbg_g_register(struct file *file, void *priv,
-		struct v4l2_dbg_register *reg){
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-
-	return v4l2_subdev_call(ch->sd, core, g_register, reg);
-}
-
-/*
- * vpif_dbg_s_register() - Write to register
- * @file: file ptr
- * @priv: file handle
- * @reg: register to be modified
- *
- * Debugging only
- * Returns zero or -EINVAL if write operations fails.
- */
-static int vpif_dbg_s_register(struct file *file, void *priv,
-		const struct v4l2_dbg_register *reg)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-
-	return v4l2_subdev_call(ch->sd, core, s_register, reg);
-}
-#endif
-
-/*
  * vpif_log_status() - Status information
  * @file: file ptr
  * @priv: file handle
@@ -1963,11 +1902,6 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 	.vidioc_query_dv_timings        = vpif_query_dv_timings,
 	.vidioc_s_dv_timings            = vpif_s_dv_timings,
 	.vidioc_g_dv_timings            = vpif_g_dv_timings,
-	.vidioc_g_chip_ident		= vpif_g_chip_ident,
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	.vidioc_g_register		= vpif_dbg_g_register,
-	.vidioc_s_register		= vpif_dbg_s_register,
-#endif
 	.vidioc_log_status		= vpif_log_status,
 };
 
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 5b6f906..6c521f2 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -19,7 +19,6 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ioctl.h>
 
 #include "vpif.h"
@@ -1501,66 +1500,6 @@ static int vpif_g_dv_timings(struct file *file, void *priv,
 }
 
 /*
- * vpif_g_chip_ident() - Identify the chip
- * @file: file ptr
- * @priv: file handle
- * @chip: chip identity
- *
- * Returns zero or -EINVAL if read operations fails.
- */
-static int vpif_g_chip_ident(struct file *file, void *priv,
-		struct v4l2_dbg_chip_ident *chip)
-{
-	chip->ident = V4L2_IDENT_NONE;
-	chip->revision = 0;
-	if (chip->match.type != V4L2_CHIP_MATCH_I2C_DRIVER &&
-			chip->match.type != V4L2_CHIP_MATCH_I2C_ADDR) {
-		vpif_dbg(2, debug, "match_type is invalid.\n");
-		return -EINVAL;
-	}
-
-	return v4l2_device_call_until_err(&vpif_obj.v4l2_dev, 0, core,
-			g_chip_ident, chip);
-}
-
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-/*
- * vpif_dbg_g_register() - Read register
- * @file: file ptr
- * @priv: file handle
- * @reg: register to be read
- *
- * Debugging only
- * Returns zero or -EINVAL if read operations fails.
- */
-static int vpif_dbg_g_register(struct file *file, void *priv,
-		struct v4l2_dbg_register *reg){
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-
-	return v4l2_subdev_call(ch->sd, core, g_register, reg);
-}
-
-/*
- * vpif_dbg_s_register() - Write to register
- * @file: file ptr
- * @priv: file handle
- * @reg: register to be modified
- *
- * Debugging only
- * Returns zero or -EINVAL if write operations fails.
- */
-static int vpif_dbg_s_register(struct file *file, void *priv,
-		const struct v4l2_dbg_register *reg)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-
-	return v4l2_subdev_call(ch->sd, core, s_register, reg);
-}
-#endif
-
-/*
  * vpif_log_status() - Status information
  * @file: file ptr
  * @priv: file handle
@@ -1599,11 +1538,6 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 	.vidioc_enum_dv_timings         = vpif_enum_dv_timings,
 	.vidioc_s_dv_timings            = vpif_s_dv_timings,
 	.vidioc_g_dv_timings            = vpif_g_dv_timings,
-	.vidioc_g_chip_ident		= vpif_g_chip_ident,
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	.vidioc_g_register		= vpif_dbg_g_register,
-	.vidioc_s_register		= vpif_dbg_s_register,
-#endif
 	.vidioc_log_status		= vpif_log_status,
 };
 
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 7d02350..fa8ae72 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -1248,32 +1248,6 @@ static unsigned int sh_vou_poll(struct file *file, poll_table *wait)
 	return res;
 }
 
-static int sh_vou_g_chip_ident(struct file *file, void *fh,
-				   struct v4l2_dbg_chip_ident *id)
-{
-	struct sh_vou_device *vou_dev = video_drvdata(file);
-
-	return v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, core, g_chip_ident, id);
-}
-
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-static int sh_vou_g_register(struct file *file, void *fh,
-				 struct v4l2_dbg_register *reg)
-{
-	struct sh_vou_device *vou_dev = video_drvdata(file);
-
-	return v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, core, g_register, reg);
-}
-
-static int sh_vou_s_register(struct file *file, void *fh,
-				 const struct v4l2_dbg_register *reg)
-{
-	struct sh_vou_device *vou_dev = video_drvdata(file);
-
-	return v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, core, s_register, reg);
-}
-#endif
-
 /* sh_vou display ioctl operations */
 static const struct v4l2_ioctl_ops sh_vou_ioctl_ops = {
 	.vidioc_querycap        	= sh_vou_querycap,
@@ -1292,11 +1266,6 @@ static const struct v4l2_ioctl_ops sh_vou_ioctl_ops = {
 	.vidioc_cropcap			= sh_vou_cropcap,
 	.vidioc_g_crop			= sh_vou_g_crop,
 	.vidioc_s_crop			= sh_vou_s_crop,
-	.vidioc_g_chip_ident		= sh_vou_g_chip_ident,
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	.vidioc_g_register		= sh_vou_g_register,
-	.vidioc_s_register		= sh_vou_s_register,
-#endif
 };
 
 static const struct v4l2_file_operations sh_vou_fops = {
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index eea832c..68efade 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1036,35 +1036,6 @@ static int soc_camera_s_parm(struct file *file, void *fh,
 	return -ENOIOCTLCMD;
 }
 
-static int soc_camera_g_chip_ident(struct file *file, void *fh,
-				   struct v4l2_dbg_chip_ident *id)
-{
-	struct soc_camera_device *icd = file->private_data;
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-
-	return v4l2_subdev_call(sd, core, g_chip_ident, id);
-}
-
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-static int soc_camera_g_register(struct file *file, void *fh,
-				 struct v4l2_dbg_register *reg)
-{
-	struct soc_camera_device *icd = file->private_data;
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-
-	return v4l2_subdev_call(sd, core, g_register, reg);
-}
-
-static int soc_camera_s_register(struct file *file, void *fh,
-				 const struct v4l2_dbg_register *reg)
-{
-	struct soc_camera_device *icd = file->private_data;
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-
-	return v4l2_subdev_call(sd, core, s_register, reg);
-}
-#endif
-
 static int soc_camera_probe(struct soc_camera_device *icd);
 
 /* So far this function cannot fail */
@@ -1495,11 +1466,6 @@ static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
 	.vidioc_s_selection	 = soc_camera_s_selection,
 	.vidioc_g_parm		 = soc_camera_g_parm,
 	.vidioc_s_parm		 = soc_camera_s_parm,
-	.vidioc_g_chip_ident     = soc_camera_g_chip_ident,
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	.vidioc_g_register	 = soc_camera_g_register,
-	.vidioc_s_register	 = soc_camera_s_register,
-#endif
 };
 
 static int video_dev_create(struct soc_camera_device *icd)
diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
index a794cd6..e343827 100644
--- a/drivers/media/platform/via-camera.c
+++ b/drivers/media/platform/via-camera.c
@@ -17,7 +17,6 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 #include <media/ov7670.h>
 #include <media/videobuf-dma-sg.h>
@@ -805,20 +804,6 @@ static const struct v4l2_file_operations viacam_fops = {
  * The long list of v4l2 ioctl ops
  */
 
-static int viacam_g_chip_ident(struct file *file, void *priv,
-		struct v4l2_dbg_chip_ident *ident)
-{
-	struct via_camera *cam = priv;
-
-	ident->ident = V4L2_IDENT_NONE;
-	ident->revision = 0;
-	if (v4l2_chip_match_host(&ident->match)) {
-		ident->ident = V4L2_IDENT_VIA_VX855;
-		return 0;
-	}
-	return sensor_call(cam, core, g_chip_ident, ident);
-}
-
 /*
  * Only one input.
  */
@@ -1174,7 +1159,6 @@ static int viacam_enum_frameintervals(struct file *filp, void *priv,
 
 
 static const struct v4l2_ioctl_ops viacam_ioctl_ops = {
-	.vidioc_g_chip_ident	= viacam_g_chip_ident,
 	.vidioc_enum_input	= viacam_enum_input,
 	.vidioc_g_input		= viacam_g_input,
 	.vidioc_s_input		= viacam_s_input,
diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
index 9430c6a..e039d03 100644
--- a/drivers/media/radio/radio-si476x.c
+++ b/drivers/media/radio/radio-si476x.c
@@ -1018,16 +1018,6 @@ static int si476x_radio_s_ctrl(struct v4l2_ctrl *ctrl)
 	return retval;
 }
 
-static int si476x_radio_g_chip_ident(struct file *file, void *fh,
-				     struct v4l2_dbg_chip_ident *chip)
-{
-	if (chip->match.type == V4L2_CHIP_MATCH_HOST &&
-	    v4l2_chip_match_host(&chip->match))
-		return 0;
-	return -EINVAL;
-}
-
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int si476x_radio_g_register(struct file *file, void *fh,
 				   struct v4l2_dbg_register *reg)
@@ -1203,7 +1193,6 @@ static const struct v4l2_ioctl_ops si4761_ioctl_ops = {
 	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 
-	.vidioc_g_chip_ident		= si476x_radio_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register		= si476x_radio_g_register,
 	.vidioc_s_register		= si476x_radio_s_register,
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 75ac994..4944a36 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -36,7 +36,6 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/tuner.h>
 #include "au0828.h"
 #include "au0828-reg.h"
@@ -1638,26 +1637,6 @@ static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_g_chip_ident(struct file *file, void *priv,
-	       struct v4l2_dbg_chip_ident *chip)
-{
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
-	chip->ident = V4L2_IDENT_NONE;
-	chip->revision = 0;
-
-	if (v4l2_chip_match_host(&chip->match)) {
-		chip->ident = V4L2_IDENT_AU0828;
-		return 0;
-	}
-
-	v4l2_device_call_all(&dev->v4l2_dev, 0, core, g_chip_ident, chip);
-	if (chip->ident == V4L2_IDENT_NONE)
-		return -EINVAL;
-
-	return 0;
-}
-
 static int vidioc_cropcap(struct file *file, void *priv,
 			  struct v4l2_cropcap *cc)
 {
@@ -1779,15 +1758,6 @@ static int vidioc_g_register(struct file *file, void *priv,
 	struct au0828_fh *fh = priv;
 	struct au0828_dev *dev = fh->dev;
 
-	switch (reg->match.type) {
-	case V4L2_CHIP_MATCH_I2C_DRIVER:
-		v4l2_device_call_all(&dev->v4l2_dev, 0, core, g_register, reg);
-		return 0;
-	default:
-		if (!v4l2_chip_match_host(&reg->match))
-			return -EINVAL;
-	}
-
 	reg->val = au0828_read(dev, reg->reg);
 	return 0;
 }
@@ -1798,14 +1768,6 @@ static int vidioc_s_register(struct file *file, void *priv,
 	struct au0828_fh *fh = priv;
 	struct au0828_dev *dev = fh->dev;
 
-	switch (reg->match.type) {
-	case V4L2_CHIP_MATCH_I2C_DRIVER:
-		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_register, reg);
-		return 0;
-	default:
-		if (!v4l2_chip_match_host(&reg->match))
-			return -EINVAL;
-	}
 	return au0828_writereg(dev, reg->reg, reg->val);
 }
 #endif
@@ -1943,7 +1905,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_g_register          = vidioc_g_register,
 	.vidioc_s_register          = vidioc_s_register,
 #endif
-	.vidioc_g_chip_ident        = vidioc_g_chip_ident,
 	.vidioc_log_status	    = vidioc_log_status,
 	.vidioc_subscribe_event     = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event   = v4l2_event_unsubscribe,
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 32d60e5..1a577ed 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -41,7 +41,6 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/msp3400.h>
 #include <media/tuner.h>
 
@@ -1309,28 +1308,6 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_g_chip_ident(struct file *file, void *priv,
-	       struct v4l2_dbg_chip_ident *chip)
-{
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
-
-	chip->ident = V4L2_IDENT_NONE;
-	chip->revision = 0;
-	if (chip->match.type == V4L2_CHIP_MATCH_BRIDGE) {
-		if (chip->match.addr > 1)
-			return -EINVAL;
-		return 0;
-	}
-	if (chip->match.type != V4L2_CHIP_MATCH_I2C_DRIVER &&
-	    chip->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
-		return -EINVAL;
-
-	v4l2_device_call_all(&dev->v4l2_dev, 0, core, g_chip_ident, chip);
-
-	return 0;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int vidioc_g_chip_info(struct file *file, void *priv,
 	       struct v4l2_dbg_chip_info *chip)
@@ -1366,14 +1343,9 @@ static int vidioc_g_register(struct file *file, void *priv,
 	struct em28xx         *dev = fh->dev;
 	int ret;
 
-	switch (reg->match.type) {
-	case V4L2_CHIP_MATCH_BRIDGE:
-		if (reg->match.addr > 1)
-			return -EINVAL;
-		if (!reg->match.addr)
-			break;
-		/* fall-through */
-	case V4L2_CHIP_MATCH_AC97:
+	if (reg->match.addr > 1)
+		return -EINVAL;
+	if (reg->match.addr) {
 		ret = em28xx_read_ac97(dev, reg->reg);
 		if (ret < 0)
 			return ret;
@@ -1381,15 +1353,6 @@ static int vidioc_g_register(struct file *file, void *priv,
 		reg->val = ret;
 		reg->size = 1;
 		return 0;
-	case V4L2_CHIP_MATCH_I2C_DRIVER:
-		v4l2_device_call_all(&dev->v4l2_dev, 0, core, g_register, reg);
-		return 0;
-	case V4L2_CHIP_MATCH_I2C_ADDR:
-		/* TODO: is this correct? */
-		v4l2_device_call_all(&dev->v4l2_dev, 0, core, g_register, reg);
-		return 0;
-	default:
-		return -EINVAL;
 	}
 
 	/* Match host */
@@ -1421,25 +1384,10 @@ static int vidioc_s_register(struct file *file, void *priv,
 	struct em28xx         *dev = fh->dev;
 	__le16 buf;
 
-	switch (reg->match.type) {
-	case V4L2_CHIP_MATCH_BRIDGE:
-		if (reg->match.addr > 1)
-			return -EINVAL;
-		if (!reg->match.addr)
-			break;
-		/* fall-through */
-	case V4L2_CHIP_MATCH_AC97:
-		return em28xx_write_ac97(dev, reg->reg, reg->val);
-	case V4L2_CHIP_MATCH_I2C_DRIVER:
-		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_register, reg);
-		return 0;
-	case V4L2_CHIP_MATCH_I2C_ADDR:
-		/* TODO: is this correct? */
-		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_register, reg);
-		return 0;
-	default:
+	if (reg->match.addr > 1)
 		return -EINVAL;
-	}
+	if (reg->match.addr)
+		return em28xx_write_ac97(dev, reg->reg, reg->val);
 
 	/* Match host */
 	buf = cpu_to_le16(reg->val);
@@ -1795,7 +1743,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_frequency         = vidioc_s_frequency,
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
-	.vidioc_g_chip_ident        = vidioc_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_chip_info         = vidioc_g_chip_info,
 	.vidioc_g_register          = vidioc_g_register,
@@ -1826,7 +1773,6 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_s_frequency   = vidioc_s_frequency,
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
-	.vidioc_g_chip_ident  = vidioc_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_chip_info   = vidioc_g_chip_info,
 	.vidioc_g_register    = vidioc_g_register,
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index a59153d2..876fc26 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -31,7 +31,6 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/videobuf2-vmalloc.h>
 
 #include <media/saa7115.h>
@@ -454,19 +453,6 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	return 0;
 }
 
-static int vidioc_g_chip_ident(struct file *file, void *priv,
-	       struct v4l2_dbg_chip_ident *chip)
-{
-	switch (chip->match.type) {
-	case V4L2_CHIP_MATCH_BRIDGE:
-		chip->ident = V4L2_IDENT_NONE;
-		chip->revision = 0;
-		return 0;
-	default:
-		return -EINVAL;
-	}
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int vidioc_g_register(struct file *file, void *priv,
 			     struct v4l2_dbg_register *reg)
@@ -475,19 +461,6 @@ static int vidioc_g_register(struct file *file, void *priv,
 	int rc;
 	u8 val;
 
-	switch (reg->match.type) {
-	case V4L2_CHIP_MATCH_I2C_DRIVER:
-		v4l2_device_call_all(&dev->v4l2_dev, 0, core, g_register, reg);
-		return 0;
-	case V4L2_CHIP_MATCH_I2C_ADDR:
-		/* TODO: is this correct? */
-		v4l2_device_call_all(&dev->v4l2_dev, 0, core, g_register, reg);
-		return 0;
-	default:
-		if (!v4l2_chip_match_host(&reg->match))
-			return -EINVAL;
-	}
-
 	/* Match host */
 	rc = stk1160_read_reg(dev, reg->reg, &val);
 	reg->val = val;
@@ -501,19 +474,6 @@ static int vidioc_s_register(struct file *file, void *priv,
 {
 	struct stk1160 *dev = video_drvdata(file);
 
-	switch (reg->match.type) {
-	case V4L2_CHIP_MATCH_I2C_DRIVER:
-		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_register, reg);
-		return 0;
-	case V4L2_CHIP_MATCH_I2C_ADDR:
-		/* TODO: is this correct? */
-		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_register, reg);
-		return 0;
-	default:
-		if (!v4l2_chip_match_host(&reg->match))
-			return -EINVAL;
-	}
-
 	/* Match host */
 	return stk1160_write_reg(dev, reg->reg, cpu_to_le16(reg->val));
 }
@@ -543,7 +503,6 @@ static const struct v4l2_ioctl_ops stk1160_ioctl_ops = {
 	.vidioc_log_status  = v4l2_ctrl_log_status,
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
-	.vidioc_g_chip_ident = vidioc_g_chip_ident,
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register = vidioc_g_register,
-- 
1.7.10.4

