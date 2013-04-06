Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2795 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932835Ab3DFL0K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Apr 2013 07:26:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 1/7] v4l2: put VIDIOC_DBG_G_CHIP_NAME under ADV_DEBUG.
Date: Sat,  6 Apr 2013 13:25:46 +0200
Message-Id: <1365247552-26795-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365247552-26795-1-git-send-email-hverkuil@xs4all.nl>
References: <1365247552-26795-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Only enable this ioctl if the VIDEO_ADV_DEBUG config option is set. This
prevents abuse from both userspace and kernelspace (some bridge drivers
abuse DBG_G_CHIP_IDENT, lets prevent that from happening again with this
ioctl).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-name.xml |    3 +++
 drivers/media/usb/em28xx/em28xx-video.c                    |    4 ++--
 drivers/media/v4l2-core/v4l2-dev.c                         |    2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c                       |    8 ++++----
 include/media/v4l2-ioctl.h                                 |    6 +++---
 5 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-name.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-name.xml
index 4921346..5fce8d8 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-name.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-name.xml
@@ -63,6 +63,9 @@ card. Regular applications must not use it. When you found a chip
 specific bug, please contact the linux-media mailing list (&v4l-ml;)
 so it can be fixed.</para>
 
+    <para>Additionally the Linux kernel must be compiled with the
+<constant>CONFIG_VIDEO_ADV_DEBUG</constant> option to enable this ioctl.</para>
+
     <para>To query the driver applications must initialize the
 <structfield>match.type</structfield> and
 <structfield>match.addr</structfield> or <structfield>match.name</structfield>
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 792ead1..39951f5 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1331,6 +1331,7 @@ static int vidioc_g_chip_ident(struct file *file, void *priv,
 	return 0;
 }
 
+#ifdef CONFIG_VIDEO_ADV_DEBUG
 static int vidioc_g_chip_name(struct file *file, void *priv,
 	       struct v4l2_dbg_chip_name *chip)
 {
@@ -1346,7 +1347,6 @@ static int vidioc_g_chip_name(struct file *file, void *priv,
 	return 0;
 }
 
-#ifdef CONFIG_VIDEO_ADV_DEBUG
 static int em28xx_reg_len(int reg)
 {
 	switch (reg) {
@@ -1796,8 +1796,8 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 	.vidioc_g_chip_ident        = vidioc_g_chip_ident,
-	.vidioc_g_chip_name         = vidioc_g_chip_name,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_chip_name         = vidioc_g_chip_name,
 	.vidioc_g_register          = vidioc_g_register,
 	.vidioc_s_register          = vidioc_s_register,
 #endif
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 670b9ca..1c3b43c 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -591,8 +591,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	SET_VALID_IOCTL(ops, VIDIOC_G_FREQUENCY, vidioc_g_frequency);
 	SET_VALID_IOCTL(ops, VIDIOC_S_FREQUENCY, vidioc_s_frequency);
 	SET_VALID_IOCTL(ops, VIDIOC_LOG_STATUS, vidioc_log_status);
-	set_bit(_IOC_NR(VIDIOC_DBG_G_CHIP_NAME), valid_ioctls);
 #ifdef CONFIG_VIDEO_ADV_DEBUG
+	set_bit(_IOC_NR(VIDIOC_DBG_G_CHIP_NAME), valid_ioctls);
 	set_bit(_IOC_NR(VIDIOC_DBG_G_REGISTER), valid_ioctls);
 	set_bit(_IOC_NR(VIDIOC_DBG_S_REGISTER), valid_ioctls);
 #endif
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 336ed2d..feac07e 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1873,6 +1873,7 @@ static int v4l_dbg_g_chip_ident(const struct v4l2_ioctl_ops *ops,
 static int v4l_dbg_g_chip_name(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
+#ifdef CONFIG_VIDEO_ADV_DEBUG
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_dbg_chip_name *p = arg;
 	struct v4l2_subdev *sd;
@@ -1880,12 +1881,10 @@ static int v4l_dbg_g_chip_name(const struct v4l2_ioctl_ops *ops,
 
 	switch (p->match.type) {
 	case V4L2_CHIP_MATCH_BRIDGE:
-#ifdef CONFIG_VIDEO_ADV_DEBUG
 		if (ops->vidioc_s_register)
 			p->flags |= V4L2_CHIP_FL_WRITABLE;
 		if (ops->vidioc_g_register)
 			p->flags |= V4L2_CHIP_FL_READABLE;
-#endif
 		if (ops->vidioc_g_chip_name)
 			return ops->vidioc_g_chip_name(file, fh, arg);
 		if (p->match.addr)
@@ -1904,12 +1903,10 @@ static int v4l_dbg_g_chip_name(const struct v4l2_ioctl_ops *ops,
 			break;
 		v4l2_device_for_each_subdev(sd, vfd->v4l2_dev) {
 			if (v4l_dbg_found_match(&p->match, sd, idx++)) {
-#ifdef CONFIG_VIDEO_ADV_DEBUG
 				if (sd->ops->core && sd->ops->core->s_register)
 					p->flags |= V4L2_CHIP_FL_WRITABLE;
 				if (sd->ops->core && sd->ops->core->g_register)
 					p->flags |= V4L2_CHIP_FL_READABLE;
-#endif
 				strlcpy(p->name, sd->name, sizeof(p->name));
 				return 0;
 			}
@@ -1917,6 +1914,9 @@ static int v4l_dbg_g_chip_name(const struct v4l2_ioctl_ops *ops,
 		break;
 	}
 	return -EINVAL;
+#else
+	return -ENOTTY;
+#endif
 }
 
 static int v4l_dqevent(const struct v4l2_ioctl_ops *ops,
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index b273f0e..6b917d6 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -243,12 +243,12 @@ struct v4l2_ioctl_ops {
 					struct v4l2_dbg_register *reg);
 	int (*vidioc_s_register)       (struct file *file, void *fh,
 					const struct v4l2_dbg_register *reg);
-#endif
-	int (*vidioc_g_chip_ident)     (struct file *file, void *fh,
-					struct v4l2_dbg_chip_ident *chip);
 
 	int (*vidioc_g_chip_name)      (struct file *file, void *fh,
 					struct v4l2_dbg_chip_name *chip);
+#endif
+	int (*vidioc_g_chip_ident)     (struct file *file, void *fh,
+					struct v4l2_dbg_chip_ident *chip);
 
 	int (*vidioc_enum_framesizes)   (struct file *file, void *fh,
 					 struct v4l2_frmsizeenum *fsize);
-- 
1.7.10.4

