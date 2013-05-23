Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:2090 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758576Ab3EWLg3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 07:36:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH] v4l2: remove g_chip_ident where it is easy to do so.
Date: Thu, 23 May 2013 13:36:10 +0200
Cc: Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Steven Toth <stoth@kernellabs.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201305231336.10889.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the introduction in 3.10 of the new superior VIDIOC_DBG_G_CHIP_INFO
ioctl there is no longer any need for the DBG_G_CHIP_IDENT ioctl or the
v4l2-chip-ident.h header.

Remove it in those bridge drivers where it is easy to do so.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/saa7146/saa7146_video.c     |   23 --------
 drivers/media/pci/bt8xx/bttv-driver.c            |   46 ++-------------
 drivers/media/pci/cx18/cx18-ioctl.c              |   62 +-------------------
 drivers/media/pci/cx23885/cx23885-417.c          |    1 -
 drivers/media/pci/cx23885/cx23885-video.c        |    1 -
 drivers/media/pci/cx88/cx88-video.c              |   13 -----
 drivers/media/pci/ivtv/ivtv-ioctl.c              |   32 +----------
 drivers/media/pci/saa7134/saa7134-empress.c      |   17 ------
 drivers/media/pci/saa7164/saa7164-encoder.c      |   43 --------------
 drivers/media/pci/saa7164/saa7164-vbi.c          |    9 ---
 drivers/media/pci/saa7164/saa7164.h              |    1 -
 drivers/media/platform/blackfin/bfin_capture.c   |   41 --------------
 drivers/media/platform/davinci/vpif_capture.c    |   66 ----------------------
 drivers/media/platform/davinci/vpif_display.c    |   66 ----------------------
 drivers/media/platform/marvell-ccic/mmp-driver.c |    1 -
 drivers/media/platform/sh_vou.c                  |   31 ----------
 drivers/media/platform/soc_camera/soc_camera.c   |   34 -----------
 drivers/media/platform/via-camera.c              |   16 ------
 drivers/media/radio/radio-si476x.c               |   11 ----
 drivers/media/usb/au0828/au0828-video.c          |   43 ++------------
 drivers/media/usb/cx231xx/cx231xx-417.c          |    1 -
 drivers/media/usb/em28xx/em28xx-video.c          |   39 -------------
 drivers/media/usb/gspca/gspca.c                  |   18 +-----
 drivers/media/usb/stk1160/stk1160-v4l.c          |   43 ++------------
 24 files changed, 18 insertions(+), 640 deletions(-)

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
index e7d0884..e85a7b2 100644
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
@@ -1936,15 +1913,8 @@ static int bttv_g_register(struct file *file, void *f,
 	struct bttv_fh *fh = f;
 	struct bttv *btv = fh->btv;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	if (!v4l2_chip_match_host(&reg->match)) {
-		/* TODO: subdev errors should not be ignored, this should become a
-		   subdev helper function. */
-		bttv_call_all(btv, core, g_register, reg);
-		return 0;
-	}
+	if (!v4l2_chip_match_host(&reg->match))
+		return -EINVAL;
 
 	/* bt848 has a 12-bit register space */
 	reg->reg &= 0xfff;
@@ -1960,15 +1930,8 @@ static int bttv_s_register(struct file *file, void *f,
 	struct bttv_fh *fh = f;
 	struct bttv *btv = fh->btv;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	if (!v4l2_chip_match_host(&reg->match)) {
-		/* TODO: subdev errors should not be ignored, this should become a
-		   subdev helper function. */
-		bttv_call_all(btv, core, s_register, reg);
-		return 0;
-	}
+	if (!v4l2_chip_match_host(&reg->match))
+		return -EINVAL;
 
 	/* bt848 has a 12-bit register space */
 	btwrite(reg->val, reg->reg & 0xfff);
@@ -3209,7 +3172,6 @@ static const struct v4l2_ioctl_ops bttv_ioctl_ops = {
 	.vidioc_querystd		= bttv_querystd,
 	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
-	.vidioc_g_chip_ident		= bttv_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register		= bttv_g_register,
 	.vidioc_s_register		= bttv_s_register,
diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index aee7b6d..cb4841c 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -39,7 +39,6 @@
 #include "cx18-cards.h"
 #include "cx18-av-core.h"
 #include <media/tveeprom.h>
-#include <media/v4l2-chip-ident.h>
 
 u16 cx18_service2vbi(int type)
 {
@@ -362,58 +361,6 @@ static int cx18_s_fmt_sliced_vbi_cap(struct file *file, void *fh,
 	return 0;
 }
 
-static int cx18_g_chip_ident(struct file *file, void *fh,
-				struct v4l2_dbg_chip_ident *chip)
-{
-	struct cx18 *cx = fh2id(fh)->cx;
-	int err = 0;
-
-	chip->ident = V4L2_IDENT_NONE;
-	chip->revision = 0;
-	switch (chip->match.type) {
-	case V4L2_CHIP_MATCH_HOST:
-		switch (chip->match.addr) {
-		case 0:
-			chip->ident = V4L2_IDENT_CX23418;
-			chip->revision = cx18_read_reg(cx, 0xC72028);
-			break;
-		case 1:
-			/*
-			 * The A/V decoder is always present, but in the rare
-			 * case that the card doesn't have analog, we don't
-			 * use it.  We find it w/o using the cx->sd_av pointer
-			 */
-			cx18_call_hw(cx, CX18_HW_418_AV,
-				     core, g_chip_ident, chip);
-			break;
-		default:
-			/*
-			 * Could return ident = V4L2_IDENT_UNKNOWN if we had
-			 * other host chips at higher addresses, but we don't
-			 */
-			err = -EINVAL; /* per V4L2 spec */
-			break;
-		}
-		break;
-	case V4L2_CHIP_MATCH_I2C_DRIVER:
-		/* If needed, returns V4L2_IDENT_AMBIGUOUS without extra work */
-		cx18_call_all(cx, core, g_chip_ident, chip);
-		break;
-	case V4L2_CHIP_MATCH_I2C_ADDR:
-		/*
-		 * We could return V4L2_IDENT_UNKNOWN, but we don't do the work
-		 * to look if a chip is at the address with no driver.  That's a
-		 * dangerous thing to do with EEPROMs anyway.
-		 */
-		cx18_call_all(cx, core, g_chip_ident, chip);
-		break;
-	default:
-		err = -EINVAL;
-		break;
-	}
-	return err;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int cx18_g_register(struct file *file, void *fh,
 				struct v4l2_dbg_register *reg)
@@ -427,9 +374,7 @@ static int cx18_g_register(struct file *file, void *fh,
 		reg->val = cx18_read_enc(cx, reg->reg);
 		return 0;
 	}
-	/* FIXME - errors shouldn't be ignored */
-	cx18_call_all(cx, core, g_register, reg);
-	return 0;
+	return -EINVAL;
 }
 
 static int cx18_s_register(struct file *file, void *fh,
@@ -443,9 +388,7 @@ static int cx18_s_register(struct file *file, void *fh,
 		cx18_write_enc(cx, reg->val, reg->reg);
 		return 0;
 	}
-	/* FIXME - errors shouldn't be ignored */
-	cx18_call_all(cx, core, s_register, reg);
-	return 0;
+	return -EINVAL;
 }
 #endif
 
@@ -1162,7 +1105,6 @@ static const struct v4l2_ioctl_ops cx18_ioctl_ops = {
 	.vidioc_try_fmt_vbi_cap         = cx18_try_fmt_vbi_cap,
 	.vidioc_try_fmt_sliced_vbi_cap  = cx18_try_fmt_sliced_vbi_cap,
 	.vidioc_g_sliced_vbi_cap        = cx18_g_sliced_vbi_cap,
-	.vidioc_g_chip_ident            = cx18_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register              = cx18_g_register,
 	.vidioc_s_register              = cx18_s_register,
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 6dea11a..0203118 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1690,7 +1690,6 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_log_status	 = vidioc_log_status,
 	.vidioc_querymenu	 = vidioc_querymenu,
 	.vidioc_queryctrl	 = vidioc_queryctrl,
-	.vidioc_g_chip_ident	 = cx23885_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register	 = cx23885_g_register,
 	.vidioc_s_register	 = cx23885_s_register,
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index ed08c89..38606fd 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -1757,7 +1757,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_tuner       = vidioc_s_tuner,
 	.vidioc_g_frequency   = vidioc_g_frequency,
 	.vidioc_s_frequency   = vidioc_s_frequency,
-	.vidioc_g_chip_ident  = cx23885_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register    = cx23885_g_register,
 	.vidioc_s_register    = cx23885_s_register,
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 1b00615..f57ccca 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -1355,16 +1355,6 @@ static int vidioc_s_frequency (struct file *file, void *priv,
 	return cx88_set_freq(core, f);
 }
 
-static int vidioc_g_chip_ident(struct file *file, void *priv,
-				struct v4l2_dbg_chip_ident *chip)
-{
-	if (!v4l2_chip_match_host(&chip->match))
-		return -EINVAL;
-	chip->revision = 0;
-	chip->ident = V4L2_IDENT_UNKNOWN;
-	return 0;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int vidioc_g_register (struct file *file, void *fh,
 				struct v4l2_dbg_register *reg)
@@ -1580,7 +1570,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_frequency   = vidioc_s_frequency,
 	.vidioc_subscribe_event      = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event    = v4l2_event_unsubscribe,
-	.vidioc_g_chip_ident  = vidioc_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register    = vidioc_g_register,
 	.vidioc_s_register    = vidioc_s_register,
@@ -1614,7 +1603,6 @@ static const struct v4l2_ioctl_ops vbi_ioctl_ops = {
 	.vidioc_s_tuner       = vidioc_s_tuner,
 	.vidioc_g_frequency   = vidioc_g_frequency,
 	.vidioc_s_frequency   = vidioc_s_frequency,
-	.vidioc_g_chip_ident  = vidioc_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register    = vidioc_g_register,
 	.vidioc_s_register    = vidioc_s_register,
@@ -1645,7 +1633,6 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_s_frequency   = vidioc_s_frequency,
 	.vidioc_subscribe_event      = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event    = v4l2_event_unsubscribe,
-	.vidioc_g_chip_ident  = vidioc_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register    = vidioc_g_register,
 	.vidioc_s_register    = vidioc_s_register,
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 9cbbce0..4c866b4 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -34,7 +34,6 @@
 #include "ivtv-cards.h"
 #include <media/saa7127.h>
 #include <media/tveeprom.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-event.h>
 #include <linux/dvb/audio.h>
 
@@ -692,31 +691,11 @@ static int ivtv_s_fmt_vid_out_overlay(struct file *file, void *fh, struct v4l2_f
 	return ret;
 }
 
-static int ivtv_g_chip_ident(struct file *file, void *fh, struct v4l2_dbg_chip_ident *chip)
-{
-	struct ivtv *itv = fh2id(fh)->itv;
-
-	chip->ident = V4L2_IDENT_NONE;
-	chip->revision = 0;
-	if (chip->match.type == V4L2_CHIP_MATCH_HOST) {
-		if (v4l2_chip_match_host(&chip->match))
-			chip->ident = itv->has_cx23415 ? V4L2_IDENT_CX23415 : V4L2_IDENT_CX23416;
-		return 0;
-	}
-	if (chip->match.type != V4L2_CHIP_MATCH_I2C_DRIVER &&
-	    chip->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
-		return -EINVAL;
-	/* TODO: is this correct? */
-	return ivtv_call_all_err(itv, core, g_chip_ident, chip);
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int ivtv_itvc(struct ivtv *itv, bool get, u64 reg, u64 *val)
 {
 	volatile u8 __iomem *reg_start;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	if (reg >= IVTV_REG_OFFSET && reg < IVTV_REG_OFFSET + IVTV_REG_SIZE)
 		reg_start = itv->reg_mem - IVTV_REG_OFFSET;
 	else if (itv->has_cx23415 && reg >= IVTV_DECODER_OFFSET &&
@@ -742,10 +721,7 @@ static int ivtv_g_register(struct file *file, void *fh, struct v4l2_dbg_register
 		reg->size = 4;
 		return ivtv_itvc(itv, true, reg->reg, &reg->val);
 	}
-	/* TODO: subdev errors should not be ignored, this should become a
-	   subdev helper function. */
-	ivtv_call_all(itv, core, g_register, reg);
-	return 0;
+	return -EINVAL;
 }
 
 static int ivtv_s_register(struct file *file, void *fh, const struct v4l2_dbg_register *reg)
@@ -757,10 +733,7 @@ static int ivtv_s_register(struct file *file, void *fh, const struct v4l2_dbg_re
 
 		return ivtv_itvc(itv, false, reg->reg, &val);
 	}
-	/* TODO: subdev errors should not be ignored, this should become a
-	   subdev helper function. */
-	ivtv_call_all(itv, core, s_register, reg);
-	return 0;
+	return -EINVAL;
 }
 #endif
 
@@ -1914,7 +1887,6 @@ static const struct v4l2_ioctl_ops ivtv_ioctl_ops = {
 	.vidioc_try_fmt_vid_out_overlay     = ivtv_try_fmt_vid_out_overlay,
 	.vidioc_try_fmt_sliced_vbi_out 	    = ivtv_try_fmt_sliced_vbi_out,
 	.vidioc_g_sliced_vbi_cap 	    = ivtv_g_sliced_vbi_cap,
-	.vidioc_g_chip_ident 		    = ivtv_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register 		    = ivtv_g_register,
 	.vidioc_s_register 		    = ivtv_s_register,
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
diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index 0b74fb2..e4f53a5 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -1288,44 +1288,6 @@ static const struct v4l2_file_operations mpeg_fops = {
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
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
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
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	return 0;
-}
-#endif
-
 static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_s_std		 = vidioc_s_std,
 	.vidioc_enum_input	 = vidioc_enum_input,
@@ -1346,11 +1308,6 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
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
index 03530bc..1b3425b 100644
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
index a1b42b0..90e1bdf 100644
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
index 7b17368..aa656d3 100644
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
 
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index c4c17fe..d3b8607 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -18,7 +18,6 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/mmp-camera.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
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
index 75ac994..36b0f34 100644
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
@@ -1779,15 +1758,8 @@ static int vidioc_g_register(struct file *file, void *priv,
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
+	if (!v4l2_chip_match_host(&reg->match))
+		return -EINVAL;
 	reg->val = au0828_read(dev, reg->reg);
 	return 0;
 }
@@ -1798,14 +1770,8 @@ static int vidioc_s_register(struct file *file, void *priv,
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
+	if (!v4l2_chip_match_host(&reg->match))
+		return -EINVAL;
 	return au0828_writereg(dev, reg->reg, reg->val);
 }
 #endif
@@ -1943,7 +1909,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_g_register          = vidioc_g_register,
 	.vidioc_s_register          = vidioc_s_register,
 #endif
-	.vidioc_g_chip_ident        = vidioc_g_chip_ident,
 	.vidioc_log_status	    = vidioc_log_status,
 	.vidioc_subscribe_event     = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event   = v4l2_event_unsubscribe,
diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index f548db8..2f63029 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1840,7 +1840,6 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_streamon	 = vidioc_streamon,
 	.vidioc_streamoff	 = vidioc_streamoff,
 	.vidioc_log_status	 = vidioc_log_status,
-	.vidioc_g_chip_ident	 = cx231xx_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register	 = cx231xx_g_register,
 	.vidioc_s_register	 = cx231xx_s_register,
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 32d60e5..4a46755 100644
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
@@ -1381,13 +1358,6 @@ static int vidioc_g_register(struct file *file, void *priv,
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
 	default:
 		return -EINVAL;
 	}
@@ -1430,13 +1400,6 @@ static int vidioc_s_register(struct file *file, void *priv,
 		/* fall-through */
 	case V4L2_CHIP_MATCH_AC97:
 		return em28xx_write_ac97(dev, reg->reg, reg->val);
-	case V4L2_CHIP_MATCH_I2C_DRIVER:
-		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_register, reg);
-		return 0;
-	case V4L2_CHIP_MATCH_I2C_ADDR:
-		/* TODO: is this correct? */
-		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_register, reg);
-		return 0;
 	default:
 		return -EINVAL;
 	}
@@ -1795,7 +1758,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_frequency         = vidioc_s_frequency,
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
-	.vidioc_g_chip_ident        = vidioc_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_chip_info         = vidioc_g_chip_info,
 	.vidioc_g_register          = vidioc_g_register,
@@ -1826,7 +1788,6 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_s_frequency   = vidioc_s_frequency,
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
-	.vidioc_g_chip_ident  = vidioc_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_chip_info   = vidioc_g_chip_info,
 	.vidioc_g_register    = vidioc_g_register,
diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 5995ec4..c354b7f 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1048,15 +1048,6 @@ static int vidioc_s_register(struct file *file, void *priv,
 }
 #endif
 
-static int vidioc_g_chip_ident(struct file *file, void *priv,
-			struct v4l2_dbg_chip_ident *chip)
-{
-	struct gspca_dev *gspca_dev = video_drvdata(file);
-
-	gspca_dev->usb_err = 0;
-	return gspca_dev->sd_desc->get_chip_ident(gspca_dev, chip);
-}
-
 static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 				struct v4l2_fmtdesc *fmtdesc)
 {
@@ -1977,7 +1968,6 @@ static const struct v4l2_ioctl_ops dev_ioctl_ops = {
 	.vidioc_g_register	= vidioc_g_register,
 	.vidioc_s_register	= vidioc_s_register,
 #endif
-	.vidioc_g_chip_ident	= vidioc_g_chip_ident,
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
@@ -2086,14 +2076,10 @@ int gspca_dev_probe2(struct usb_interface *intf,
 	v4l2_disable_ioctl_locking(&gspca_dev->vdev, VIDIOC_DQBUF);
 	v4l2_disable_ioctl_locking(&gspca_dev->vdev, VIDIOC_QBUF);
 	v4l2_disable_ioctl_locking(&gspca_dev->vdev, VIDIOC_QUERYBUF);
-	if (!gspca_dev->sd_desc->get_chip_ident)
-		v4l2_disable_ioctl(&gspca_dev->vdev, VIDIOC_DBG_G_CHIP_IDENT);
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-	if (!gspca_dev->sd_desc->get_chip_ident ||
-	    !gspca_dev->sd_desc->get_register)
+	if (!gspca_dev->sd_desc->get_register)
 		v4l2_disable_ioctl(&gspca_dev->vdev, VIDIOC_DBG_G_REGISTER);
-	if (!gspca_dev->sd_desc->get_chip_ident ||
-	    !gspca_dev->sd_desc->set_register)
+	if (!gspca_dev->sd_desc->set_register)
 		v4l2_disable_ioctl(&gspca_dev->vdev, VIDIOC_DBG_S_REGISTER);
 #endif
 	if (!gspca_dev->sd_desc->get_jcomp)
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index a59153d2..fa79f20 100644
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
@@ -475,18 +461,8 @@ static int vidioc_g_register(struct file *file, void *priv,
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
+	if (!v4l2_chip_match_host(&reg->match))
+		return -EINVAL;
 
 	/* Match host */
 	rc = stk1160_read_reg(dev, reg->reg, &val);
@@ -501,18 +477,8 @@ static int vidioc_s_register(struct file *file, void *priv,
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
+	if (!v4l2_chip_match_host(&reg->match))
+		return -EINVAL;
 
 	/* Match host */
 	return stk1160_write_reg(dev, reg->reg, cpu_to_le16(reg->val));
@@ -543,7 +509,6 @@ static const struct v4l2_ioctl_ops stk1160_ioctl_ops = {
 	.vidioc_log_status  = v4l2_ctrl_log_status,
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
-	.vidioc_g_chip_ident = vidioc_g_chip_ident,
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register = vidioc_g_register,
-- 
1.7.10.4

