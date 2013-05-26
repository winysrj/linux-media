Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3536 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab3EZN1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 May 2013 09:27:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 05/24] ivtv: remove g_chip_ident
Date: Sun, 26 May 2013 15:27:00 +0200
Message-Id: <1369574839-6687-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369574839-6687-1-git-send-email-hverkuil@xs4all.nl>
References: <1369574839-6687-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

g_chip_ident was used to determine if a saa7114 or saa7115 was used. Instead
just check the subdev name.

After that the g_chip_ident function can be removed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/ivtv/ivtv-driver.c |    8 +------
 drivers/media/pci/ivtv/ivtv-ioctl.c  |   41 ++++------------------------------
 2 files changed, 5 insertions(+), 44 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
index 07b8460..db61452 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.c
+++ b/drivers/media/pci/ivtv/ivtv-driver.c
@@ -58,7 +58,6 @@
 #include <linux/dma-mapping.h>
 #include <media/tveeprom.h>
 #include <media/saa7115.h>
-#include <media/v4l2-chip-ident.h>
 #include "tuner-xc2028.h"
 
 /* If you have already X v4l cards, then set this to X. This way
@@ -968,15 +967,10 @@ static void ivtv_load_and_init_modules(struct ivtv *itv)
 	}
 
 	if (hw & IVTV_HW_SAA711X) {
-		struct v4l2_dbg_chip_ident v;
-
 		/* determine the exact saa711x model */
 		itv->hw_flags &= ~IVTV_HW_SAA711X;
 
-		v.match.type = V4L2_CHIP_MATCH_I2C_DRIVER;
-		strlcpy(v.match.name, "saa7115", sizeof(v.match.name));
-		ivtv_call_hw(itv, IVTV_HW_SAA711X, core, g_chip_ident, &v);
-		if (v.ident == V4L2_IDENT_SAA7114) {
+		if (strstr(itv->sd_video->name, "saa7114")) {
 			itv->hw_flags |= IVTV_HW_SAA7114;
 			/* VBI is not yet supported by the saa7114 driver. */
 			itv->v4l2_cap &= ~(V4L2_CAP_SLICED_VBI_CAPTURE|V4L2_CAP_VBI_CAPTURE);
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 3e281ec..944300f 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -34,7 +34,6 @@
 #include "ivtv-cards.h"
 #include <media/saa7127.h>
 #include <media/tveeprom.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-event.h>
 #include <linux/dvb/audio.h>
 
@@ -692,24 +691,6 @@ static int ivtv_s_fmt_vid_out_overlay(struct file *file, void *fh, struct v4l2_f
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
@@ -736,29 +717,16 @@ static int ivtv_g_register(struct file *file, void *fh, struct v4l2_dbg_register
 {
 	struct ivtv *itv = fh2id(fh)->itv;
 
-	if (v4l2_chip_match_host(&reg->match)) {
-		reg->size = 4;
-		return ivtv_itvc(itv, true, reg->reg, &reg->val);
-	}
-	/* TODO: subdev errors should not be ignored, this should become a
-	   subdev helper function. */
-	ivtv_call_all(itv, core, g_register, reg);
-	return 0;
+	reg->size = 4;
+	return ivtv_itvc(itv, true, reg->reg, &reg->val);
 }
 
 static int ivtv_s_register(struct file *file, void *fh, const struct v4l2_dbg_register *reg)
 {
 	struct ivtv *itv = fh2id(fh)->itv;
+	u64 val = reg->val;
 
-	if (v4l2_chip_match_host(&reg->match)) {
-		u64 val = reg->val;
-
-		return ivtv_itvc(itv, false, reg->reg, &val);
-	}
-	/* TODO: subdev errors should not be ignored, this should become a
-	   subdev helper function. */
-	ivtv_call_all(itv, core, s_register, reg);
-	return 0;
+	return ivtv_itvc(itv, false, reg->reg, &val);
 }
 #endif
 
@@ -1912,7 +1880,6 @@ static const struct v4l2_ioctl_ops ivtv_ioctl_ops = {
 	.vidioc_try_fmt_vid_out_overlay     = ivtv_try_fmt_vid_out_overlay,
 	.vidioc_try_fmt_sliced_vbi_out 	    = ivtv_try_fmt_sliced_vbi_out,
 	.vidioc_g_sliced_vbi_cap 	    = ivtv_g_sliced_vbi_cap,
-	.vidioc_g_chip_ident 		    = ivtv_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register 		    = ivtv_g_register,
 	.vidioc_s_register 		    = ivtv_s_register,
-- 
1.7.10.4

