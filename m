Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3473 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab3EZN1i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 May 2013 09:27:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 11/24] marvell-ccic: remove g_chip_ident.
Date: Sun, 26 May 2013 15:27:06 +0200
Message-Id: <1369574839-6687-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369574839-6687-1-git-send-email-hverkuil@xs4all.nl>
References: <1369574839-6687-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Remove g_chip_ident. This driver used some of the V4L2_IDENT defines, replace
those with a driver-specific enum. This makes it possible to drop the
v4l2-chip-ident.h define as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/marvell-ccic/cafe-driver.c |    3 +-
 drivers/media/platform/marvell-ccic/mcam-core.c   |   55 +++------------------
 drivers/media/platform/marvell-ccic/mcam-core.h   |    8 ++-
 drivers/media/platform/marvell-ccic/mmp-driver.c  |    3 +-
 4 files changed, 16 insertions(+), 53 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/cafe-driver.c b/drivers/media/platform/marvell-ccic/cafe-driver.c
index d030f9b..7b07fc5 100644
--- a/drivers/media/platform/marvell-ccic/cafe-driver.c
+++ b/drivers/media/platform/marvell-ccic/cafe-driver.c
@@ -27,7 +27,6 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <linux/device.h>
 #include <linux/wait.h>
 #include <linux/delay.h>
@@ -469,7 +468,7 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 		goto out;
 	cam->pdev = pdev;
 	mcam = &cam->mcam;
-	mcam->chip_id = V4L2_IDENT_CAFE;
+	mcam->chip_id = MCAM_CAFE;
 	spin_lock_init(&mcam->dev_lock);
 	init_waitqueue_head(&cam->smbus_wait);
 	mcam->plat_power_up = cafe_ctlr_power_up;
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 64ab91e..a187161 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -23,7 +23,6 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/ov7670.h>
 #include <media/videobuf2-vmalloc.h>
 #include <media/videobuf2-dma-contig.h>
@@ -336,7 +335,7 @@ static void mcam_ctlr_dma_vmalloc(struct mcam_camera *cam)
 		mcam_reg_clear_bit(cam, REG_CTRL1, C1_TWOBUFS);
 	} else
 		mcam_reg_set_bit(cam, REG_CTRL1, C1_TWOBUFS);
-	if (cam->chip_id == V4L2_IDENT_CAFE)
+	if (cam->chip_id == MCAM_CAFE)
 		mcam_reg_write(cam, REG_UBAR, 0); /* 32 bits only */
 }
 
@@ -796,7 +795,6 @@ static int __mcam_cam_reset(struct mcam_camera *cam)
  */
 static int mcam_cam_init(struct mcam_camera *cam)
 {
-	struct v4l2_dbg_chip_ident chip;
 	int ret;
 
 	mutex_lock(&cam->s_mutex);
@@ -804,24 +802,8 @@ static int mcam_cam_init(struct mcam_camera *cam)
 		cam_warn(cam, "Cam init with device in funky state %d",
 				cam->state);
 	ret = __mcam_cam_reset(cam);
-	if (ret)
-		goto out;
-	chip.ident = V4L2_IDENT_NONE;
-	chip.match.type = V4L2_CHIP_MATCH_I2C_ADDR;
-	chip.match.addr = cam->sensor_addr;
-	ret = sensor_call(cam, core, g_chip_ident, &chip);
-	if (ret)
-		goto out;
-	cam->sensor_type = chip.ident;
-	if (cam->sensor_type != V4L2_IDENT_OV7670) {
-		cam_err(cam, "Unsupported sensor type 0x%x", cam->sensor_type);
-		ret = -EINVAL;
-		goto out;
-	}
-/* Get/set parameters? */
-	ret = 0;
+	/* Get/set parameters? */
 	cam->state = S_IDLE;
-out:
 	mcam_ctlr_power_down(cam);
 	mutex_unlock(&cam->s_mutex);
 	return ret;
@@ -1392,20 +1374,6 @@ static int mcam_vidioc_s_parm(struct file *filp, void *priv,
 	return ret;
 }
 
-static int mcam_vidioc_g_chip_ident(struct file *file, void *priv,
-		struct v4l2_dbg_chip_ident *chip)
-{
-	struct mcam_camera *cam = priv;
-
-	chip->ident = V4L2_IDENT_NONE;
-	chip->revision = 0;
-	if (v4l2_chip_match_host(&chip->match)) {
-		chip->ident = cam->chip_id;
-		return 0;
-	}
-	return sensor_call(cam, core, g_chip_ident, chip);
-}
-
 static int mcam_vidioc_enum_framesizes(struct file *filp, void *priv,
 		struct v4l2_frmsizeenum *sizes)
 {
@@ -1436,12 +1404,9 @@ static int mcam_vidioc_g_register(struct file *file, void *priv,
 {
 	struct mcam_camera *cam = priv;
 
-	if (v4l2_chip_match_host(&reg->match)) {
-		reg->val = mcam_reg_read(cam, reg->reg);
-		reg->size = 4;
-		return 0;
-	}
-	return sensor_call(cam, core, g_register, reg);
+	reg->val = mcam_reg_read(cam, reg->reg);
+	reg->size = 4;
+	return 0;
 }
 
 static int mcam_vidioc_s_register(struct file *file, void *priv,
@@ -1449,11 +1414,8 @@ static int mcam_vidioc_s_register(struct file *file, void *priv,
 {
 	struct mcam_camera *cam = priv;
 
-	if (v4l2_chip_match_host(&reg->match)) {
-		mcam_reg_write(cam, reg->reg, reg->val);
-		return 0;
-	}
-	return sensor_call(cam, core, s_register, reg);
+	mcam_reg_write(cam, reg->reg, reg->val);
+	return 0;
 }
 #endif
 
@@ -1477,7 +1439,6 @@ static const struct v4l2_ioctl_ops mcam_v4l_ioctl_ops = {
 	.vidioc_s_parm		= mcam_vidioc_s_parm,
 	.vidioc_enum_framesizes = mcam_vidioc_enum_framesizes,
 	.vidioc_enum_frameintervals = mcam_vidioc_enum_frameintervals,
-	.vidioc_g_chip_ident	= mcam_vidioc_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register	= mcam_vidioc_g_register,
 	.vidioc_s_register	= mcam_vidioc_s_register,
@@ -1695,7 +1656,7 @@ int mccic_register(struct mcam_camera *cam)
 	if (buffer_mode >= 0)
 		cam->buffer_mode = buffer_mode;
 	if (cam->buffer_mode == B_DMA_sg &&
-			cam->chip_id == V4L2_IDENT_CAFE) {
+			cam->chip_id == MCAM_CAFE) {
 		printk(KERN_ERR "marvell-cam: Cafe can't do S/G I/O, "
 			"attempting vmalloc mode instead\n");
 		cam->buffer_mode = B_vmalloc;
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index 01dec9e..46b6ea3 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -53,6 +53,11 @@ enum mcam_buffer_mode {
 	B_DMA_sg = 2
 };
 
+enum mcam_chip_id {
+	MCAM_CAFE,
+	MCAM_ARMADA610,
+};
+
 /*
  * Is a given buffer mode supported by the current kernel configuration?
  */
@@ -98,7 +103,7 @@ struct mcam_camera {
 	unsigned char __iomem *regs;
 	spinlock_t dev_lock;
 	struct device *dev; /* For messages, dma alloc */
-	unsigned int chip_id;
+	enum mcam_chip_id chip_id;
 	short int clock_speed;	/* Sensor clock speed, default 30 */
 	short int use_smbus;	/* SMBUS or straight I2c? */
 	enum mcam_buffer_mode buffer_mode;
@@ -152,7 +157,6 @@ struct mcam_camera {
 	void (*frame_complete)(struct mcam_camera *cam, int frame);
 
 	/* Current operating parameters */
-	u32 sensor_type;		/* Currently ov7670 only */
 	struct v4l2_pix_format pix_format;
 	enum v4l2_mbus_pixelcode mbus_code;
 
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index c4c17fe..cadad64 100644
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
@@ -185,7 +184,7 @@ static int mmpcam_probe(struct platform_device *pdev)
 	mcam->plat_power_down = mmpcam_power_down;
 	mcam->dev = &pdev->dev;
 	mcam->use_smbus = 0;
-	mcam->chip_id = V4L2_IDENT_ARMADA610;
+	mcam->chip_id = MCAM_ARMADA610;
 	mcam->buffer_mode = B_DMA_sg;
 	spin_lock_init(&mcam->dev_lock);
 	/*
-- 
1.7.10.4

