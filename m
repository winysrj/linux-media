Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2012 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965674Ab3E2LAw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:00:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv1 13/38] v4l2: remove obsolete v4l2_chip_match_host().
Date: Wed, 29 May 2013 12:59:46 +0200
Message-Id: <1369825211-29770-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This function is no longer needed since it is now the responsibility of the
v4l2 core to check if the DBG_G/S_REGISTER and DBG_G_CHIP_INFO ioctls are
called for the bridge driver or not.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/usbvision/usbvision-video.c |    4 ----
 drivers/media/v4l2-core/v4l2-common.c         |   11 -----------
 include/media/v4l2-common.h                   |    1 -
 3 files changed, 16 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index d34c2af..f959197 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -467,8 +467,6 @@ static int vidioc_g_register(struct file *file, void *priv,
 	struct usb_usbvision *usbvision = video_drvdata(file);
 	int err_code;
 
-	if (!v4l2_chip_match_host(&reg->match))
-		return -EINVAL;
 	/* NT100x has a 8-bit register space */
 	err_code = usbvision_read_reg(usbvision, reg->reg&0xff);
 	if (err_code < 0) {
@@ -488,8 +486,6 @@ static int vidioc_s_register(struct file *file, void *priv,
 	struct usb_usbvision *usbvision = video_drvdata(file);
 	int err_code;
 
-	if (!v4l2_chip_match_host(&reg->match))
-		return -EINVAL;
 	/* NT100x has a 8-bit register space */
 	err_code = usbvision_write_reg(usbvision, reg->reg & 0xff, reg->val);
 	if (err_code < 0) {
diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 3fed63f..5fd7660 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -227,17 +227,6 @@ u32 v4l2_ctrl_next(const u32 * const * ctrl_classes, u32 id)
 }
 EXPORT_SYMBOL(v4l2_ctrl_next);
 
-int v4l2_chip_match_host(const struct v4l2_dbg_match *match)
-{
-	switch (match->type) {
-	case V4L2_CHIP_MATCH_BRIDGE:
-		return match->addr == 0;
-	default:
-		return 0;
-	}
-}
-EXPORT_SYMBOL(v4l2_chip_match_host);
-
 #if IS_ENABLED(CONFIG_I2C)
 int v4l2_chip_match_i2c_client(struct i2c_client *c, const struct v4l2_dbg_match *match)
 {
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 1d93c48..e7821fb 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -106,7 +106,6 @@ struct i2c_client; /* forward reference */
 int v4l2_chip_match_i2c_client(struct i2c_client *c, const struct v4l2_dbg_match *match);
 int v4l2_chip_ident_i2c_client(struct i2c_client *c, struct v4l2_dbg_chip_ident *chip,
 		u32 ident, u32 revision);
-int v4l2_chip_match_host(const struct v4l2_dbg_match *match);
 
 /* ------------------------------------------------------------------------- */
 
-- 
1.7.10.4

