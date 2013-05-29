Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1794 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965655Ab3E2LAt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:00:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Steven Toth <stoth@linuxtv.org>
Subject: [PATCHv1 06/38] cx23885: remove g_chip_ident.
Date: Wed, 29 May 2013 12:59:39 +0200
Message-Id: <1369825211-29770-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Replace g_chip_ident by g_chip_info. Note that the IR support is implemented
as a subdev, so this part no longer needs to be handled as a 'bridge' chip.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Steven Toth <stoth@linuxtv.org>
---
 drivers/media/pci/cx23885/cx23885-417.c   |    2 +-
 drivers/media/pci/cx23885/cx23885-ioctl.c |  139 ++++++-----------------------
 drivers/media/pci/cx23885/cx23885-ioctl.h |    4 +-
 drivers/media/pci/cx23885/cx23885-video.c |    2 +-
 drivers/media/pci/cx23885/cx23888-ir.c    |   27 ------
 5 files changed, 29 insertions(+), 145 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 6dea11a..68568d3 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1690,8 +1690,8 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_log_status	 = vidioc_log_status,
 	.vidioc_querymenu	 = vidioc_querymenu,
 	.vidioc_queryctrl	 = vidioc_queryctrl,
-	.vidioc_g_chip_ident	 = cx23885_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_chip_info	 = cx23885_g_chip_info,
 	.vidioc_g_register	 = cx23885_g_register,
 	.vidioc_s_register	 = cx23885_s_register,
 #endif
diff --git a/drivers/media/pci/cx23885/cx23885-ioctl.c b/drivers/media/pci/cx23885/cx23885-ioctl.c
index 00f5125..271d69d 100644
--- a/drivers/media/pci/cx23885/cx23885-ioctl.c
+++ b/drivers/media/pci/cx23885/cx23885-ioctl.c
@@ -24,93 +24,21 @@
 #include "cx23885.h"
 #include "cx23885-ioctl.h"
 
-#include <media/v4l2-chip-ident.h>
-
-int cx23885_g_chip_ident(struct file *file, void *fh,
-			 struct v4l2_dbg_chip_ident *chip)
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+int cx23885_g_chip_info(struct file *file, void *fh,
+			 struct v4l2_dbg_chip_info *chip)
 {
 	struct cx23885_dev *dev = ((struct cx23885_fh *)fh)->dev;
-	int err = 0;
-	u8 rev;
-
-	chip->ident = V4L2_IDENT_NONE;
-	chip->revision = 0;
-	switch (chip->match.type) {
-	case V4L2_CHIP_MATCH_HOST:
-		switch (chip->match.addr) {
-		case 0:
-			rev = cx_read(RDR_CFG2) & 0xff;
-			switch (dev->pci->device) {
-			case 0x8852:
-				/* rev 0x04 could be '885 or '888. Pick '888. */
-				if (rev == 0x04)
-					chip->ident = V4L2_IDENT_CX23888;
-				else
-					chip->ident = V4L2_IDENT_CX23885;
-				break;
-			case 0x8880:
-				if (rev == 0x0e || rev == 0x0f)
-					chip->ident = V4L2_IDENT_CX23887;
-				else
-					chip->ident = V4L2_IDENT_CX23888;
-				break;
-			default:
-				chip->ident = V4L2_IDENT_UNKNOWN;
-				break;
-			}
-			chip->revision = (dev->pci->device << 16) | (rev << 8) |
-					 (dev->hwrevision & 0xff);
-			break;
-		case 1:
-			if (dev->v4l_device != NULL) {
-				chip->ident = V4L2_IDENT_CX23417;
-				chip->revision = 0;
-			}
-			break;
-		case 2:
-			/*
-			 * The integrated IR controller on the CX23888 is
-			 * host chip 2.  It may not be used/initialized or sd_ir
-			 * may be pointing at the cx25840 subdevice for the
-			 * IR controller on the CX23885.  Thus we find it
-			 * without using the dev->sd_ir pointer.
-			 */
-			call_hw(dev, CX23885_HW_888_IR, core, g_chip_ident,
-				chip);
-			break;
-		default:
-			err = -EINVAL; /* per V4L2 spec */
-			break;
-		}
-		break;
-	case V4L2_CHIP_MATCH_I2C_DRIVER:
-		/* If needed, returns V4L2_IDENT_AMBIGUOUS without extra work */
-		call_all(dev, core, g_chip_ident, chip);
-		break;
-	case V4L2_CHIP_MATCH_I2C_ADDR:
-		/*
-		 * We could return V4L2_IDENT_UNKNOWN, but we don't do the work
-		 * to look if a chip is at the address with no driver.  That's a
-		 * dangerous thing to do with EEPROMs anyway.
-		 */
-		call_all(dev, core, g_chip_ident, chip);
-		break;
-	default:
-		err = -EINVAL;
-		break;
-	}
-	return err;
-}
 
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-static int cx23885_g_host_register(struct cx23885_dev *dev,
-				   struct v4l2_dbg_register *reg)
-{
-	if ((reg->reg & 0x3) != 0 || reg->reg >= pci_resource_len(dev->pci, 0))
+	if (chip->match.addr > 1)
 		return -EINVAL;
-
-	reg->size = 4;
-	reg->val = cx_read(reg->reg);
+	if (chip->match.addr == 1) {
+		if (dev->v4l_device == NULL)
+			return -EINVAL;
+		strlcpy(chip->name, "cx23417", sizeof(chip->name));
+	} else {
+		strlcpy(chip->name, dev->v4l2_dev.name, sizeof(chip->name));
+	}
 	return 0;
 }
 
@@ -138,29 +66,16 @@ int cx23885_g_register(struct file *file, void *fh,
 {
 	struct cx23885_dev *dev = ((struct cx23885_fh *)fh)->dev;
 
-	if (reg->match.type == V4L2_CHIP_MATCH_HOST) {
-		switch (reg->match.addr) {
-		case 0:
-			return cx23885_g_host_register(dev, reg);
-		case 1:
-			return cx23417_g_register(dev, reg);
-		default:
-			break;
-		}
-	}
-
-	/* FIXME - any error returns should not be ignored */
-	call_all(dev, core, g_register, reg);
-	return 0;
-}
+	if (reg->match.addr > 1)
+		return -EINVAL;
+	if (reg->match.addr)
+		return cx23417_g_register(dev, reg);
 
-static int cx23885_s_host_register(struct cx23885_dev *dev,
-				   const struct v4l2_dbg_register *reg)
-{
 	if ((reg->reg & 0x3) != 0 || reg->reg >= pci_resource_len(dev->pci, 0))
 		return -EINVAL;
 
-	cx_write(reg->reg, reg->val);
+	reg->size = 4;
+	reg->val = cx_read(reg->reg);
 	return 0;
 }
 
@@ -183,19 +98,15 @@ int cx23885_s_register(struct file *file, void *fh,
 {
 	struct cx23885_dev *dev = ((struct cx23885_fh *)fh)->dev;
 
-	if (reg->match.type == V4L2_CHIP_MATCH_HOST) {
-		switch (reg->match.addr) {
-		case 0:
-			return cx23885_s_host_register(dev, reg);
-		case 1:
-			return cx23417_s_register(dev, reg);
-		default:
-			break;
-		}
-	}
+	if (reg->match.addr > 1)
+		return -EINVAL;
+	if (reg->match.addr)
+		return cx23417_s_register(dev, reg);
+
+	if ((reg->reg & 0x3) != 0 || reg->reg >= pci_resource_len(dev->pci, 0))
+		return -EINVAL;
 
-	/* FIXME - any error returns should not be ignored */
-	call_all(dev, core, s_register, reg);
+	cx_write(reg->reg, reg->val);
 	return 0;
 }
 #endif
diff --git a/drivers/media/pci/cx23885/cx23885-ioctl.h b/drivers/media/pci/cx23885/cx23885-ioctl.h
index a608096..92d9f07 100644
--- a/drivers/media/pci/cx23885/cx23885-ioctl.h
+++ b/drivers/media/pci/cx23885/cx23885-ioctl.h
@@ -24,8 +24,8 @@
 #ifndef _CX23885_IOCTL_H_
 #define _CX23885_IOCTL_H_
 
-int cx23885_g_chip_ident(struct file *file, void *fh,
-			 struct v4l2_dbg_chip_ident *chip);
+int cx23885_g_chip_info(struct file *file, void *fh,
+			 struct v4l2_dbg_chip_info *chip);
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 int cx23885_g_register(struct file *file, void *fh,
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index ed08c89..ce05739 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -1757,8 +1757,8 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_tuner       = vidioc_s_tuner,
 	.vidioc_g_frequency   = vidioc_g_frequency,
 	.vidioc_s_frequency   = vidioc_s_frequency,
-	.vidioc_g_chip_ident  = cx23885_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_chip_info   = cx23885_g_chip_info,
 	.vidioc_g_register    = cx23885_g_register,
 	.vidioc_s_register    = cx23885_s_register,
 #endif
diff --git a/drivers/media/pci/cx23885/cx23888-ir.c b/drivers/media/pci/cx23885/cx23888-ir.c
index cd98651..2c951de 100644
--- a/drivers/media/pci/cx23885/cx23888-ir.c
+++ b/drivers/media/pci/cx23885/cx23888-ir.c
@@ -25,7 +25,6 @@
 #include <linux/slab.h>
 
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/rc-core.h>
 
 #include "cx23885.h"
@@ -131,8 +130,6 @@ union cx23888_ir_fifo_rec {
 struct cx23888_ir_state {
 	struct v4l2_subdev sd;
 	struct cx23885_dev *dev;
-	u32 id;
-	u32 rev;
 
 	struct v4l2_subdev_ir_parameters rx_params;
 	struct mutex rx_params_lock;
@@ -1086,23 +1083,6 @@ static int cx23888_ir_log_status(struct v4l2_subdev *sd)
 	return 0;
 }
 
-static inline int cx23888_ir_dbg_match(const struct v4l2_dbg_match *match)
-{
-	return match->type == V4L2_CHIP_MATCH_HOST && match->addr == 2;
-}
-
-static int cx23888_ir_g_chip_ident(struct v4l2_subdev *sd,
-				   struct v4l2_dbg_chip_ident *chip)
-{
-	struct cx23888_ir_state *state = to_state(sd);
-
-	if (cx23888_ir_dbg_match(&chip->match)) {
-		chip->ident = state->id;
-		chip->revision = state->rev;
-	}
-	return 0;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int cx23888_ir_g_register(struct v4l2_subdev *sd,
 				 struct v4l2_dbg_register *reg)
@@ -1110,8 +1090,6 @@ static int cx23888_ir_g_register(struct v4l2_subdev *sd,
 	struct cx23888_ir_state *state = to_state(sd);
 	u32 addr = CX23888_IR_REG_BASE + (u32) reg->reg;
 
-	if (!cx23888_ir_dbg_match(&reg->match))
-		return -EINVAL;
 	if ((addr & 0x3) != 0)
 		return -EINVAL;
 	if (addr < CX23888_IR_CNTRL_REG || addr > CX23888_IR_LEARN_REG)
@@ -1127,8 +1105,6 @@ static int cx23888_ir_s_register(struct v4l2_subdev *sd,
 	struct cx23888_ir_state *state = to_state(sd);
 	u32 addr = CX23888_IR_REG_BASE + (u32) reg->reg;
 
-	if (!cx23888_ir_dbg_match(&reg->match))
-		return -EINVAL;
 	if ((addr & 0x3) != 0)
 		return -EINVAL;
 	if (addr < CX23888_IR_CNTRL_REG || addr > CX23888_IR_LEARN_REG)
@@ -1139,7 +1115,6 @@ static int cx23888_ir_s_register(struct v4l2_subdev *sd,
 #endif
 
 static const struct v4l2_subdev_core_ops cx23888_ir_core_ops = {
-	.g_chip_ident = cx23888_ir_g_chip_ident,
 	.log_status = cx23888_ir_log_status,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = cx23888_ir_g_register,
@@ -1213,8 +1188,6 @@ int cx23888_ir_probe(struct cx23885_dev *dev)
 		return -ENOMEM;
 
 	state->dev = dev;
-	state->id = V4L2_IDENT_CX23888_IR;
-	state->rev = 0;
 	sd = &state->sd;
 
 	v4l2_subdev_init(sd, &cx23888_ir_controller_ops);
-- 
1.7.10.4

