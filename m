Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2950 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386Ab3BFP4r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 10:56:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 03/17] bttv: add VIDIOC_DBG_G_CHIP_IDENT
Date: Wed,  6 Feb 2013 16:56:21 +0100
Message-Id: <e2f3405f21d160f0c0985b6b993dff6b35517106.1360165855.git.hans.verkuil@cisco.com>
In-Reply-To: <1360166195-18010-1-git-send-email-hverkuil@xs4all.nl>
References: <1360166195-18010-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c5d83e654c3cfd166ee832f83458c19904851980.1360165855.git.hans.verkuil@cisco.com>
References: <c5d83e654c3cfd166ee832f83458c19904851980.1360165855.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

VIDIOC_DBG_G_CHIP_IDENT is a prerequisite for the G/S_REGISTER ioctls.
In addition, add support to call G/S_REGISTER for supporting i2c devices.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |   40 +++++++++++++++++++++++++++++----
 drivers/media/pci/bt8xx/bttv.h        |    3 +++
 include/media/v4l2-chip-ident.h       |    8 +++++++
 3 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index cc7f58f..b36d675 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -49,6 +49,7 @@
 #include "bttvp.h"
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-chip-ident.h>
 #include <media/tvaudio.h>
 #include <media/msp3400.h>
 
@@ -2059,6 +2060,28 @@ static int bttv_log_status(struct file *file, void *f)
 	return 0;
 }
 
+static int bttv_g_chip_ident(struct file *file, void *f, struct v4l2_dbg_chip_ident *chip)
+{
+	struct bttv_fh *fh  = f;
+	struct bttv *btv = fh->btv;
+
+	chip->ident = V4L2_IDENT_NONE;
+	chip->revision = 0;
+	if (chip->match.type == V4L2_CHIP_MATCH_HOST) {
+		if (v4l2_chip_match_host(&chip->match)) {
+			chip->ident = btv->id;
+			if (chip->ident == PCI_DEVICE_ID_FUSION879)
+				chip->ident = V4L2_IDENT_BT879;
+		}
+		return 0;
+	}
+	if (chip->match.type != V4L2_CHIP_MATCH_I2C_DRIVER &&
+	    chip->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
+		return -EINVAL;
+	/* TODO: is this correct? */
+	return bttv_call_all_err(btv, core, g_chip_ident, chip);
+}
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int bttv_g_register(struct file *file, void *f,
 					struct v4l2_dbg_register *reg)
@@ -2069,8 +2092,12 @@ static int bttv_g_register(struct file *file, void *f,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!v4l2_chip_match_host(&reg->match))
-		return -EINVAL;
+	if (!v4l2_chip_match_host(&reg->match)) {
+		/* TODO: subdev errors should not be ignored, this should become a
+		   subdev helper function. */
+		bttv_call_all(btv, core, g_register, reg);
+		return 0;
+	}
 
 	/* bt848 has a 12-bit register space */
 	reg->reg &= 0xfff;
@@ -2089,8 +2116,12 @@ static int bttv_s_register(struct file *file, void *f,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!v4l2_chip_match_host(&reg->match))
-		return -EINVAL;
+	if (!v4l2_chip_match_host(&reg->match)) {
+		/* TODO: subdev errors should not be ignored, this should become a
+		   subdev helper function. */
+		bttv_call_all(btv, core, s_register, reg);
+		return 0;
+	}
 
 	/* bt848 has a 12-bit register space */
 	reg->reg &= 0xfff;
@@ -3394,6 +3425,7 @@ static const struct v4l2_ioctl_ops bttv_ioctl_ops = {
 	.vidioc_s_frequency             = bttv_s_frequency,
 	.vidioc_log_status		= bttv_log_status,
 	.vidioc_querystd		= bttv_querystd,
+	.vidioc_g_chip_ident		= bttv_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register		= bttv_g_register,
 	.vidioc_s_register		= bttv_s_register,
diff --git a/drivers/media/pci/bt8xx/bttv.h b/drivers/media/pci/bt8xx/bttv.h
index 79a1124..6139ce2 100644
--- a/drivers/media/pci/bt8xx/bttv.h
+++ b/drivers/media/pci/bt8xx/bttv.h
@@ -359,6 +359,9 @@ void bttv_gpio_bits(struct bttv_core *core, u32 mask, u32 bits);
 #define bttv_call_all(btv, o, f, args...) \
 	v4l2_device_call_all(&btv->c.v4l2_dev, 0, o, f, ##args)
 
+#define bttv_call_all_err(btv, o, f, args...) \
+	v4l2_device_call_until_err(&btv->c.v4l2_dev, 0, o, f, ##args)
+
 extern int bttv_I2CRead(struct bttv *btv, unsigned char addr, char *probe_for);
 extern int bttv_I2CWrite(struct bttv *btv, unsigned char addr, unsigned char b1,
 			 unsigned char b2, int both);
diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index 4ee125b..b5996f9 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -96,12 +96,20 @@ enum {
 	/* module au0828 */
 	V4L2_IDENT_AU0828 = 828,
 
+	/* module bttv: ident 848 + 849 */
+	V4L2_IDENT_BT848 = 848,
+	V4L2_IDENT_BT849 = 849,
+
 	/* module bt856: just ident 856 */
 	V4L2_IDENT_BT856 = 856,
 
 	/* module bt866: just ident 866 */
 	V4L2_IDENT_BT866 = 866,
 
+	/* module bttv: ident 878 + 879 */
+	V4L2_IDENT_BT878 = 878,
+	V4L2_IDENT_BT879 = 879,
+
 	/* module ks0127: reserved range 1120-1129 */
 	V4L2_IDENT_KS0122S = 1122,
 	V4L2_IDENT_KS0127  = 1127,
-- 
1.7.10.4

