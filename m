Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1998 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab3CRQig (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 12:38:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Frank Schaefer <fschaefer.oss@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 4/6] em28xx: add support for g_chip_name.
Date: Mon, 18 Mar 2013 17:38:18 +0100
Message-Id: <1363624700-29270-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363624700-29270-1-git-send-email-hverkuil@xs4all.nl>
References: <1363624700-29270-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for vidioc_g_chip_name, allowing AC97 to be implemented as a
second chip on the bridge with the name "ac97". v4l2-dbg can just match the
name with that string in order to detect a ac97-compliant set of registers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   41 +++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 93fc620..99fcd50 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1242,9 +1242,9 @@ static int vidioc_g_chip_ident(struct file *file, void *priv,
 
 	chip->ident = V4L2_IDENT_NONE;
 	chip->revision = 0;
-	if (chip->match.type == V4L2_CHIP_MATCH_HOST) {
-		if (v4l2_chip_match_host(&chip->match))
-			chip->ident = V4L2_IDENT_NONE;
+	if (chip->match.type == V4L2_CHIP_MATCH_BRIDGE) {
+		if (chip->match.addr > 1)
+			return -EINVAL;
 		return 0;
 	}
 	if (chip->match.type != V4L2_CHIP_MATCH_I2C_DRIVER &&
@@ -1256,6 +1256,21 @@ static int vidioc_g_chip_ident(struct file *file, void *priv,
 	return 0;
 }
 
+static int vidioc_g_chip_name(struct file *file, void *priv,
+	       struct v4l2_dbg_chip_name *chip)
+{
+	struct em28xx_fh      *fh  = priv;
+	struct em28xx         *dev = fh->dev;
+
+	if (chip->match.addr > 1)
+		return -EINVAL;
+	if (chip->match.addr == 1)
+		strlcpy(chip->name, "ac97", sizeof(chip->name));
+	else
+		strlcpy(chip->name, dev->v4l2_dev.name, sizeof(chip->name));
+	return 0;
+}
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int em28xx_reg_len(int reg)
 {
@@ -1277,6 +1292,12 @@ static int vidioc_g_register(struct file *file, void *priv,
 	int ret;
 
 	switch (reg->match.type) {
+	case V4L2_CHIP_MATCH_BRIDGE:
+		if (reg->match.addr > 1)
+			return -EINVAL;
+		if (!reg->match.addr)
+			break;
+		/* fall-through */
 	case V4L2_CHIP_MATCH_AC97:
 		ret = em28xx_read_ac97(dev, reg->reg);
 		if (ret < 0)
@@ -1293,8 +1314,7 @@ static int vidioc_g_register(struct file *file, void *priv,
 		v4l2_device_call_all(&dev->v4l2_dev, 0, core, g_register, reg);
 		return 0;
 	default:
-		if (!v4l2_chip_match_host(&reg->match))
-			return -EINVAL;
+		return -EINVAL;
 	}
 
 	/* Match host */
@@ -1327,6 +1347,12 @@ static int vidioc_s_register(struct file *file, void *priv,
 	__le16 buf;
 
 	switch (reg->match.type) {
+	case V4L2_CHIP_MATCH_BRIDGE:
+		if (reg->match.addr > 1)
+			return -EINVAL;
+		if (!reg->match.addr)
+			break;
+		/* fall-through */
 	case V4L2_CHIP_MATCH_AC97:
 		return em28xx_write_ac97(dev, reg->reg, reg->val);
 	case V4L2_CHIP_MATCH_I2C_DRIVER:
@@ -1337,8 +1363,7 @@ static int vidioc_s_register(struct file *file, void *priv,
 		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_register, reg);
 		return 0;
 	default:
-		if (!v4l2_chip_match_host(&reg->match))
-			return -EINVAL;
+		return -EINVAL;
 	}
 
 	/* Match host */
@@ -1696,6 +1721,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 	.vidioc_g_chip_ident        = vidioc_g_chip_ident,
+	.vidioc_g_chip_name         = vidioc_g_chip_name,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register          = vidioc_g_register,
 	.vidioc_s_register          = vidioc_s_register,
@@ -1726,6 +1752,7 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 	.vidioc_g_chip_ident  = vidioc_g_chip_ident,
+	.vidioc_g_chip_name   = vidioc_g_chip_name,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register    = vidioc_g_register,
 	.vidioc_s_register    = vidioc_s_register,
-- 
1.7.10.4

