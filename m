Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1754 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3CRQih (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 12:38:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Frank Schaefer <fschaefer.oss@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/6] v4l2: add new VIDIOC_DBG_G_CHIP_NAME ioctl.
Date: Mon, 18 Mar 2013 17:38:16 +0100
Message-Id: <1363624700-29270-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363624700-29270-1-git-send-email-hverkuil@xs4all.nl>
References: <1363624700-29270-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Simplify the debugging ioctls by creating the VIDIOC_DBG_G_CHIP_NAME ioctl.
This will eventually replace VIDIOC_DBG_G_CHIP_IDENT. Chip matching is done
by the name or index of subdevices or an index to a bridge chip. Most of this
can all be done automatically, so most drivers just need to provide get/set
register ops.

In particular, it is now possible to get/set subdev registers without
requiring assistance of the bridge driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-common.c |    5 +-
 drivers/media/v4l2-core/v4l2-dev.c    |    5 +-
 drivers/media/v4l2-core/v4l2-ioctl.c  |  115 +++++++++++++++++++++++++++++++--
 include/media/v4l2-ioctl.h            |    3 +
 include/uapi/linux/videodev2.h        |   34 +++++++---
 5 files changed, 146 insertions(+), 16 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 46d2b9b..537be23 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -230,7 +230,7 @@ EXPORT_SYMBOL(v4l2_ctrl_next);
 int v4l2_chip_match_host(const struct v4l2_dbg_match *match)
 {
 	switch (match->type) {
-	case V4L2_CHIP_MATCH_HOST:
+	case V4L2_CHIP_MATCH_BRIDGE:
 		return match->addr == 0;
 	default:
 		return 0;
@@ -254,6 +254,9 @@ int v4l2_chip_match_i2c_client(struct i2c_client *c, const struct v4l2_dbg_match
 		return len && !strncmp(c->driver->driver.name, match->name, len);
 	case V4L2_CHIP_MATCH_I2C_ADDR:
 		return c->addr == match->addr;
+	case V4L2_CHIP_MATCH_SUBDEV_IDX:
+	case V4L2_CHIP_MATCH_SUBDEV_NAME:
+		return 1;
 	default:
 		return 0;
 	}
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index de1e9ab..c0c651d 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -591,9 +591,10 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	SET_VALID_IOCTL(ops, VIDIOC_G_FREQUENCY, vidioc_g_frequency);
 	SET_VALID_IOCTL(ops, VIDIOC_S_FREQUENCY, vidioc_s_frequency);
 	SET_VALID_IOCTL(ops, VIDIOC_LOG_STATUS, vidioc_log_status);
+	set_bit(_IOC_NR(VIDIOC_DBG_G_CHIP_NAME), valid_ioctls);
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-	SET_VALID_IOCTL(ops, VIDIOC_DBG_G_REGISTER, vidioc_g_register);
-	SET_VALID_IOCTL(ops, VIDIOC_DBG_S_REGISTER, vidioc_s_register);
+	set_bit(_IOC_NR(VIDIOC_DBG_G_REGISTER), valid_ioctls);
+	set_bit(_IOC_NR(VIDIOC_DBG_S_REGISTER), valid_ioctls);
 #endif
 	SET_VALID_IOCTL(ops, VIDIOC_DBG_G_CHIP_IDENT, vidioc_g_chip_ident);
 	/* yes, really vidioc_subscribe_event */
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index aa6e7c7..923ec95 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -622,7 +622,8 @@ static void v4l_print_dbg_chip_ident(const void *arg, bool write_only)
 	const struct v4l2_dbg_chip_ident *p = arg;
 
 	pr_cont("type=%u, ", p->match.type);
-	if (p->match.type == V4L2_CHIP_MATCH_I2C_DRIVER)
+	if (p->match.type == V4L2_CHIP_MATCH_I2C_DRIVER ||
+	    p->match.type == V4L2_CHIP_MATCH_SUBDEV_NAME)
 		pr_cont("name=%s, ", p->match.name);
 	else
 		pr_cont("addr=%u, ", p->match.addr);
@@ -630,12 +631,27 @@ static void v4l_print_dbg_chip_ident(const void *arg, bool write_only)
 			p->ident, p->revision);
 }
 
+static void v4l_print_dbg_chip_name(const void *arg, bool write_only)
+{
+	const struct v4l2_dbg_chip_name *p = arg;
+
+	pr_cont("type=%u, ", p->match.type);
+	if (p->match.type == V4L2_CHIP_MATCH_I2C_DRIVER ||
+	    p->match.type == V4L2_CHIP_MATCH_SUBDEV_NAME)
+		pr_cont("name=%.*s, ",
+				(int)sizeof(p->match.name), p->match.name);
+	else
+		pr_cont("addr=%u, ", p->match.addr);
+	pr_cont("name=%.*s\n", (int)sizeof(p->name), p->name);
+}
+
 static void v4l_print_dbg_register(const void *arg, bool write_only)
 {
 	const struct v4l2_dbg_register *p = arg;
 
 	pr_cont("type=%u, ", p->match.type);
-	if (p->match.type == V4L2_CHIP_MATCH_I2C_DRIVER)
+	if (p->match.type == V4L2_CHIP_MATCH_I2C_DRIVER ||
+	    p->match.type == V4L2_CHIP_MATCH_SUBDEV_NAME)
 		pr_cont("name=%s, ", p->match.name);
 	else
 		pr_cont("addr=%u, ", p->match.addr);
@@ -1787,15 +1803,38 @@ static int v4l_log_status(const struct v4l2_ioctl_ops *ops,
 	return ret;
 }
 
+static bool v4l_dbg_found_match(const struct v4l2_dbg_match *match,
+		struct v4l2_subdev *sd, int idx)
+{
+	if (match->type == V4L2_CHIP_MATCH_SUBDEV_IDX)
+		return match->addr == idx;
+	return !strcmp(match->name, sd->name);
+}
+
 static int v4l_dbg_g_register(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	struct v4l2_dbg_register *p = arg;
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_subdev *sd;
+	int idx = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	return ops->vidioc_g_register(file, fh, p);
+	if (p->match.type == V4L2_CHIP_MATCH_SUBDEV_IDX ||
+	    p->match.type == V4L2_CHIP_MATCH_SUBDEV_NAME) {
+		if (vfd->v4l2_dev == NULL)
+			return -EINVAL;
+		v4l2_device_for_each_subdev(sd, vfd->v4l2_dev) {
+			if (v4l_dbg_found_match(&p->match, sd, idx++))
+				return v4l2_subdev_call(sd, core, g_register, p);
+		}
+		return -EINVAL;
+	}
+	if (ops->vidioc_g_register)
+		return ops->vidioc_g_register(file, fh, p);
+	return -EINVAL;
 #else
 	return -ENOTTY;
 #endif
@@ -1806,10 +1845,25 @@ static int v4l_dbg_s_register(const struct v4l2_ioctl_ops *ops,
 {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	struct v4l2_dbg_register *p = arg;
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_subdev *sd;
+	int idx = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	return ops->vidioc_s_register(file, fh, p);
+	if (p->match.type == V4L2_CHIP_MATCH_SUBDEV_IDX ||
+	    p->match.type == V4L2_CHIP_MATCH_SUBDEV_NAME) {
+		if (vfd->v4l2_dev == NULL)
+			return -EINVAL;
+		v4l2_device_for_each_subdev(sd, vfd->v4l2_dev) {
+			if (v4l_dbg_found_match(&p->match, sd, idx++))
+				return v4l2_subdev_call(sd, core, s_register, p);
+		}
+		return -EINVAL;
+	}
+	if (ops->vidioc_s_register)
+		return ops->vidioc_s_register(file, fh, p);
+	return -EINVAL;
 #else
 	return -ENOTTY;
 #endif
@@ -1822,9 +1876,61 @@ static int v4l_dbg_g_chip_ident(const struct v4l2_ioctl_ops *ops,
 
 	p->ident = V4L2_IDENT_NONE;
 	p->revision = 0;
+	if (p->match.type == V4L2_CHIP_MATCH_SUBDEV_NAME ||
+	    p->match.type == V4L2_CHIP_MATCH_SUBDEV_IDX)
+		return -EINVAL;
 	return ops->vidioc_g_chip_ident(file, fh, p);
 }
 
+static int v4l_dbg_g_chip_name(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_dbg_chip_name *p = arg;
+	struct v4l2_subdev *sd;
+	int idx = 0;
+
+	switch (p->match.type) {
+	case V4L2_CHIP_MATCH_BRIDGE:
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+		if (ops->vidioc_s_register)
+			p->flags |= V4L2_CHIP_FL_WRITABLE;
+		if (ops->vidioc_g_register)
+			p->flags |= V4L2_CHIP_FL_READABLE;
+#endif
+		if (ops->vidioc_g_chip_name)
+			return ops->vidioc_g_chip_name(file, fh, arg);
+		if (p->match.addr)
+			return -EINVAL;
+		if (vfd->v4l2_dev)
+			strlcpy(p->name, vfd->v4l2_dev->name, sizeof(p->name));
+		else if (vfd->parent)
+			strlcpy(p->name, vfd->parent->driver->name, sizeof(p->name));
+		else
+			strlcpy(p->name, "bridge", sizeof(p->name));
+		return 0;
+
+	case V4L2_CHIP_MATCH_SUBDEV_IDX:
+	case V4L2_CHIP_MATCH_SUBDEV_NAME:
+		if (vfd->v4l2_dev == NULL)
+			break;
+		v4l2_device_for_each_subdev(sd, vfd->v4l2_dev) {
+			if (v4l_dbg_found_match(&p->match, sd, idx++)) {
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+				if (sd->ops->core && sd->ops->core->s_register)
+					p->flags |= V4L2_CHIP_FL_WRITABLE;
+				if (sd->ops->core && sd->ops->core->g_register)
+					p->flags |= V4L2_CHIP_FL_READABLE;
+#endif
+				strlcpy(p->name, sd->name, sizeof(p->name));
+				return 0;
+			}
+		}
+		break;
+	}
+	return -EINVAL;
+}
+
 static int v4l_dqevent(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
@@ -2043,6 +2149,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_STD(VIDIOC_QUERY_DV_TIMINGS, vidioc_query_dv_timings, v4l_print_dv_timings, 0),
 	IOCTL_INFO_STD(VIDIOC_DV_TIMINGS_CAP, vidioc_dv_timings_cap, v4l_print_dv_timings_cap, INFO_FL_CLEAR(v4l2_dv_timings_cap, type)),
 	IOCTL_INFO_FNC(VIDIOC_ENUM_FREQ_BANDS, v4l_enum_freq_bands, v4l_print_freq_band, 0),
+	IOCTL_INFO_FNC(VIDIOC_DBG_G_CHIP_NAME, v4l_dbg_g_chip_name, v4l_print_dbg_chip_name, INFO_FL_CLEAR(v4l2_dbg_chip_name, match)),
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
 
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 4118ad1..ad44cbf 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -247,6 +247,9 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_g_chip_ident)     (struct file *file, void *fh,
 					struct v4l2_dbg_chip_ident *chip);
 
+	int (*vidioc_g_chip_name)      (struct file *file, void *fh,
+					struct v4l2_dbg_chip_name *chip);
+
 	int (*vidioc_enum_framesizes)   (struct file *file, void *fh,
 					 struct v4l2_frmsizeenum *fsize);
 
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index b5f5cdd..6bea1ab 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1855,10 +1855,13 @@ struct v4l2_event_subscription {
 
 /* VIDIOC_DBG_G_REGISTER and VIDIOC_DBG_S_REGISTER */
 
-#define V4L2_CHIP_MATCH_HOST       0  /* Match against chip ID on host (0 for the host) */
-#define V4L2_CHIP_MATCH_I2C_DRIVER 1  /* Match against I2C driver name */
-#define V4L2_CHIP_MATCH_I2C_ADDR   2  /* Match against I2C 7-bit address */
-#define V4L2_CHIP_MATCH_AC97       3  /* Match against anciliary AC97 chip */
+#define V4L2_CHIP_MATCH_BRIDGE      0  /* Match against chip ID on the bridge (0 for the bridge) */
+#define V4L2_CHIP_MATCH_HOST V4L2_CHIP_MATCH_BRIDGE
+#define V4L2_CHIP_MATCH_I2C_DRIVER  1  /* Match against I2C driver name */
+#define V4L2_CHIP_MATCH_I2C_ADDR    2  /* Match against I2C 7-bit address */
+#define V4L2_CHIP_MATCH_AC97        3  /* Match against anciliary AC97 chip */
+#define V4L2_CHIP_MATCH_SUBDEV_NAME 4  /* Match against subdev name */
+#define V4L2_CHIP_MATCH_SUBDEV_IDX  5  /* Match against subdev index */
 
 struct v4l2_dbg_match {
 	__u32 type; /* Match type */
@@ -1882,6 +1885,17 @@ struct v4l2_dbg_chip_ident {
 	__u32 revision;    /* chip revision, chip specific */
 } __attribute__ ((packed));
 
+#define V4L2_CHIP_FL_READABLE (1 << 0)
+#define V4L2_CHIP_FL_WRITABLE (1 << 1)
+
+/* VIDIOC_DBG_G_CHIP_NAME */
+struct v4l2_dbg_chip_name {
+	struct v4l2_dbg_match match;
+	char name[32];
+	__u32 flags;
+	__u32 reserved[8];
+} __attribute__ ((packed));
+
 /**
  * struct v4l2_create_buffers - VIDIOC_CREATE_BUFS argument
  * @index:	on return, index of the first created buffer
@@ -1959,15 +1973,12 @@ struct v4l2_create_buffers {
 #define VIDIOC_G_EXT_CTRLS	_IOWR('V', 71, struct v4l2_ext_controls)
 #define VIDIOC_S_EXT_CTRLS	_IOWR('V', 72, struct v4l2_ext_controls)
 #define VIDIOC_TRY_EXT_CTRLS	_IOWR('V', 73, struct v4l2_ext_controls)
-#if 1
 #define VIDIOC_ENUM_FRAMESIZES	_IOWR('V', 74, struct v4l2_frmsizeenum)
 #define VIDIOC_ENUM_FRAMEINTERVALS _IOWR('V', 75, struct v4l2_frmivalenum)
 #define VIDIOC_G_ENC_INDEX       _IOR('V', 76, struct v4l2_enc_idx)
 #define VIDIOC_ENCODER_CMD      _IOWR('V', 77, struct v4l2_encoder_cmd)
 #define VIDIOC_TRY_ENCODER_CMD  _IOWR('V', 78, struct v4l2_encoder_cmd)
-#endif
 
-#if 1
 /* Experimental, meant for debugging, testing and internal use.
    Only implemented if CONFIG_VIDEO_ADV_DEBUG is defined.
    You must be root to use these ioctls. Never use these in applications! */
@@ -1975,9 +1986,10 @@ struct v4l2_create_buffers {
 #define	VIDIOC_DBG_G_REGISTER 	_IOWR('V', 80, struct v4l2_dbg_register)
 
 /* Experimental, meant for debugging, testing and internal use.
-   Never use this ioctl in applications! */
+   Never use this ioctl in applications!
+   Note: this ioctl is deprecated in favor of VIDIOC_DBG_G_CHIP_NAME and
+   will go away in the future. */
 #define VIDIOC_DBG_G_CHIP_IDENT _IOWR('V', 81, struct v4l2_dbg_chip_ident)
-#endif
 
 #define VIDIOC_S_HW_FREQ_SEEK	 _IOW('V', 82, struct v4l2_hw_freq_seek)
 
@@ -2017,6 +2029,10 @@ struct v4l2_create_buffers {
    versions. */
 #define VIDIOC_ENUM_FREQ_BANDS	_IOWR('V', 101, struct v4l2_frequency_band)
 
+/* Experimental, meant for debugging, testing and internal use.
+   Never use these in applications! */
+#define VIDIOC_DBG_G_CHIP_NAME  _IOWR('V', 102, struct v4l2_dbg_chip_name)
+
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
 
-- 
1.7.10.4

