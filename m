Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3188 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965542Ab3E2LAk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:00:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCHv1 03/38] cx18: remove g_chip_ident support.
Date: Wed, 29 May 2013 12:59:36 +0200
Message-Id: <1369825211-29770-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The av-core is really a subdev, so there is no need anymore to act as if it
is a 'second' bridge chip.

As a result of this the g_chip_ident implementation can be completely dropped.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/pci/cx18/cx18-av-core.c |   32 --------------
 drivers/media/pci/cx18/cx18-av-core.h |    1 -
 drivers/media/pci/cx18/cx18-ioctl.c   |   78 +++------------------------------
 3 files changed, 7 insertions(+), 104 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-av-core.c b/drivers/media/pci/cx18/cx18-av-core.c
index ba8caf0..c4890a4 100644
--- a/drivers/media/pci/cx18/cx18-av-core.c
+++ b/drivers/media/pci/cx18/cx18-av-core.c
@@ -22,7 +22,6 @@
  *  02110-1301, USA.
  */
 
-#include <media/v4l2-chip-ident.h>
 #include "cx18-driver.h"
 #include "cx18-io.h"
 #include "cx18-cards.h"
@@ -1231,31 +1230,12 @@ static int cx18_av_log_status(struct v4l2_subdev *sd)
 	return 0;
 }
 
-static inline int cx18_av_dbg_match(const struct v4l2_dbg_match *match)
-{
-	return match->type == V4L2_CHIP_MATCH_HOST && match->addr == 1;
-}
-
-static int cx18_av_g_chip_ident(struct v4l2_subdev *sd,
-				struct v4l2_dbg_chip_ident *chip)
-{
-	struct cx18_av_state *state = to_cx18_av_state(sd);
-
-	if (cx18_av_dbg_match(&chip->match)) {
-		chip->ident = state->id;
-		chip->revision = state->rev;
-	}
-	return 0;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int cx18_av_g_register(struct v4l2_subdev *sd,
 			      struct v4l2_dbg_register *reg)
 {
 	struct cx18 *cx = v4l2_get_subdevdata(sd);
 
-	if (!cx18_av_dbg_match(&reg->match))
-		return -EINVAL;
 	if ((reg->reg & 0x3) != 0)
 		return -EINVAL;
 	reg->size = 4;
@@ -1268,8 +1248,6 @@ static int cx18_av_s_register(struct v4l2_subdev *sd,
 {
 	struct cx18 *cx = v4l2_get_subdevdata(sd);
 
-	if (!cx18_av_dbg_match(&reg->match))
-		return -EINVAL;
 	if ((reg->reg & 0x3) != 0)
 		return -EINVAL;
 	cx18_av_write4(cx, reg->reg & 0x00000ffc, reg->val);
@@ -1282,17 +1260,9 @@ static const struct v4l2_ctrl_ops cx18_av_ctrl_ops = {
 };
 
 static const struct v4l2_subdev_core_ops cx18_av_general_ops = {
-	.g_chip_ident = cx18_av_g_chip_ident,
 	.log_status = cx18_av_log_status,
 	.load_fw = cx18_av_load_fw,
 	.reset = cx18_av_reset,
-	.g_ctrl = v4l2_subdev_g_ctrl,
-	.s_ctrl = v4l2_subdev_s_ctrl,
-	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
-	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
-	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
-	.queryctrl = v4l2_subdev_queryctrl,
-	.querymenu = v4l2_subdev_querymenu,
 	.s_std = cx18_av_s_std,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = cx18_av_g_register,
@@ -1340,8 +1310,6 @@ int cx18_av_probe(struct cx18 *cx)
 	int err;
 
 	state->rev = cx18_av_read4(cx, CXADEC_CHIP_CTRL) & 0xffff;
-	state->id = ((state->rev >> 4) == CXADEC_CHIP_TYPE_MAKO)
-		    ? V4L2_IDENT_CX23418_843 : V4L2_IDENT_UNKNOWN;
 
 	state->vid_input = CX18_AV_COMPOSITE7;
 	state->aud_input = CX18_AV_AUDIO8;
diff --git a/drivers/media/pci/cx18/cx18-av-core.h b/drivers/media/pci/cx18/cx18-av-core.h
index e9c69d9..4c559e8 100644
--- a/drivers/media/pci/cx18/cx18-av-core.h
+++ b/drivers/media/pci/cx18/cx18-av-core.h
@@ -104,7 +104,6 @@ struct cx18_av_state {
 	enum cx18_av_audio_input aud_input;
 	u32 audclk_freq;
 	int audmode;
-	u32 id;
 	u32 rev;
 	int is_initialized;
 
diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index aee7b6d..414b0ec 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -39,7 +39,6 @@
 #include "cx18-cards.h"
 #include "cx18-av-core.h"
 #include <media/tveeprom.h>
-#include <media/v4l2-chip-ident.h>
 
 u16 cx18_service2vbi(int type)
 {
@@ -362,73 +361,16 @@ static int cx18_s_fmt_sliced_vbi_cap(struct file *file, void *fh,
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
 {
 	struct cx18 *cx = fh2id(fh)->cx;
 
-	if (v4l2_chip_match_host(&reg->match)) {
-		if (reg->reg >= CX18_MEM_OFFSET + CX18_MEM_SIZE)
-			return -EINVAL;
-		reg->size = 4;
-		reg->val = cx18_read_enc(cx, reg->reg);
-		return 0;
-	}
-	/* FIXME - errors shouldn't be ignored */
-	cx18_call_all(cx, core, g_register, reg);
+	if (reg->reg >= CX18_MEM_OFFSET + CX18_MEM_SIZE)
+		return -EINVAL;
+	reg->size = 4;
+	reg->val = cx18_read_enc(cx, reg->reg);
 	return 0;
 }
 
@@ -437,14 +379,9 @@ static int cx18_s_register(struct file *file, void *fh,
 {
 	struct cx18 *cx = fh2id(fh)->cx;
 
-	if (v4l2_chip_match_host(&reg->match)) {
-		if (reg->reg >= CX18_MEM_OFFSET + CX18_MEM_SIZE)
-			return -EINVAL;
-		cx18_write_enc(cx, reg->val, reg->reg);
-		return 0;
-	}
-	/* FIXME - errors shouldn't be ignored */
-	cx18_call_all(cx, core, s_register, reg);
+	if (reg->reg >= CX18_MEM_OFFSET + CX18_MEM_SIZE)
+		return -EINVAL;
+	cx18_write_enc(cx, reg->val, reg->reg);
 	return 0;
 }
 #endif
@@ -1162,7 +1099,6 @@ static const struct v4l2_ioctl_ops cx18_ioctl_ops = {
 	.vidioc_try_fmt_vbi_cap         = cx18_try_fmt_vbi_cap,
 	.vidioc_try_fmt_sliced_vbi_cap  = cx18_try_fmt_sliced_vbi_cap,
 	.vidioc_g_sliced_vbi_cap        = cx18_g_sliced_vbi_cap,
-	.vidioc_g_chip_ident            = cx18_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register              = cx18_g_register,
 	.vidioc_s_register              = cx18_s_register,
-- 
1.7.10.4

