Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1157 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834Ab3DFL0F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Apr 2013 07:26:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 2/7] v4l2: drop V4L2_CHIP_MATCH_SUBDEV_NAME.
Date: Sat,  6 Apr 2013 13:25:47 +0200
Message-Id: <1365247552-26795-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365247552-26795-1-git-send-email-hverkuil@xs4all.nl>
References: <1365247552-26795-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

After using the new VIDIOC_DBG_G_CHIP_NAME ioctl I realized that the matching
by name possibility is useless. Just drop it and rename MATCH_SUBDEV_IDX to
just MATCH_SUBDEV.

The v4l2-dbg utility is much better placed to match by name by just enumerating
all bridge and subdev devices until chip_name.name matches.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml  |    7 +--
 .../DocBook/media/v4l/vidioc-dbg-g-chip-name.xml   |   18 +------
 .../DocBook/media/v4l/vidioc-dbg-g-register.xml    |   17 +-----
 drivers/media/v4l2-core/v4l2-common.c              |    3 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   55 +++++++-------------
 include/uapi/linux/videodev2.h                     |    3 +-
 6 files changed, 26 insertions(+), 77 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml
index 82e43c6..921e185 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml
@@ -221,13 +221,8 @@ the values from <xref linkend="chip-ids" />.</entry>
 	    <entry>Match the nth anciliary AC97 chip.</entry>
 	  </row>
 	  <row>
-	    <entry><constant>V4L2_CHIP_MATCH_SUBDEV_NAME</constant></entry>
+	    <entry><constant>V4L2_CHIP_MATCH_SUBDEV</constant></entry>
 	    <entry>4</entry>
-	    <entry>Match the sub-device by name. Can't be used with this ioctl.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_CHIP_MATCH_SUBDEV_IDX</constant></entry>
-	    <entry>5</entry>
 	    <entry>Match the nth sub-device. Can't be used with this ioctl.</entry>
 	  </row>
 	</tbody>
diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-name.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-name.xml
index 5fce8d8..fa3bd42 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-name.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-name.xml
@@ -87,16 +87,7 @@ connected to the PCI or USB bus. Non-zero numbers identify specific
 parts of the bridge chip such as an AC97 register block.</para>
 
     <para>When <structfield>match.type</structfield> is
-<constant>V4L2_CHIP_MATCH_SUBDEV_NAME</constant>,
-<structfield>match.name</structfield> contains the name of a sub-device.
-For instance
-<constant>"saa7127 6-0044"</constant> will match the saa7127 sub-device
-at the given i2c bus. This match type is not very useful for this ioctl
-and is here only for consistency.
-</para>
-
-    <para>When <structfield>match.type</structfield> is
-<constant>V4L2_CHIP_MATCH_SUBDEV_IDX</constant>,
+<constant>V4L2_CHIP_MATCH_SUBDEV</constant>,
 <structfield>match.addr</structfield> selects the nth sub-device. This
 allows you to enumerate over all sub-devices.</para>
 
@@ -207,13 +198,8 @@ is set, then the driver supports reading registers from the device. If
 	    <entry>Match the nth anciliary AC97 chip. Can't be used with this ioctl.</entry>
 	  </row>
 	  <row>
-	    <entry><constant>V4L2_CHIP_MATCH_SUBDEV_NAME</constant></entry>
+	    <entry><constant>V4L2_CHIP_MATCH_SUBDEV</constant></entry>
 	    <entry>4</entry>
-	    <entry>Match the sub-device by name.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_CHIP_MATCH_SUBDEV_IDX</constant></entry>
-	    <entry>5</entry>
 	    <entry>Match the nth sub-device.</entry>
 	  </row>
 	</tbody>
diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
index 3082b41..db7844f 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
@@ -123,15 +123,7 @@ bus address.</para>
 on the TV card.</para>
 
     <para>When <structfield>match.type</structfield> is
-<constant>V4L2_CHIP_MATCH_SUBDEV_NAME</constant>,
-<structfield>match.name</structfield> contains the sub-device name.
-For instance
-<constant>"saa7127 6-0044"</constant> will match this specific saa7127
-sub-device. Again with the &VIDIOC-DBG-G-CHIP-NAME; ioctl you can find
-out which sub-devices are present.</para>
-
-    <para>When <structfield>match.type</structfield> is
-<constant>V4L2_CHIP_MATCH_SUBDEV_IDX</constant>,
+<constant>V4L2_CHIP_MATCH_SUBDEV</constant>,
 <structfield>match.addr</structfield> selects the nth sub-device.</para>
 
     <note>
@@ -250,13 +242,8 @@ register.</entry>
 	    <entry>Match the nth anciliary AC97 chip.</entry>
 	  </row>
 	  <row>
-	    <entry><constant>V4L2_CHIP_MATCH_SUBDEV_NAME</constant></entry>
+	    <entry><constant>V4L2_CHIP_MATCH_SUBDEV</constant></entry>
 	    <entry>4</entry>
-	    <entry>Match the sub-device by name.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_CHIP_MATCH_SUBDEV_IDX</constant></entry>
-	    <entry>5</entry>
 	    <entry>Match the nth sub-device.</entry>
 	  </row>
 	</tbody>
diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index f8fac9c..3fed63f 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -254,8 +254,7 @@ int v4l2_chip_match_i2c_client(struct i2c_client *c, const struct v4l2_dbg_match
 		return len && !strncmp(c->driver->driver.name, match->name, len);
 	case V4L2_CHIP_MATCH_I2C_ADDR:
 		return c->addr == match->addr;
-	case V4L2_CHIP_MATCH_SUBDEV_IDX:
-	case V4L2_CHIP_MATCH_SUBDEV_NAME:
+	case V4L2_CHIP_MATCH_SUBDEV:
 		return 1;
 	default:
 		return 0;
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index feac07e..7a96162 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -629,8 +629,7 @@ static void v4l_print_dbg_chip_ident(const void *arg, bool write_only)
 	const struct v4l2_dbg_chip_ident *p = arg;
 
 	pr_cont("type=%u, ", p->match.type);
-	if (p->match.type == V4L2_CHIP_MATCH_I2C_DRIVER ||
-	    p->match.type == V4L2_CHIP_MATCH_SUBDEV_NAME)
+	if (p->match.type == V4L2_CHIP_MATCH_I2C_DRIVER)
 		pr_cont("name=%.*s, ",
 				(int)sizeof(p->match.name), p->match.name);
 	else
@@ -644,8 +643,7 @@ static void v4l_print_dbg_chip_name(const void *arg, bool write_only)
 	const struct v4l2_dbg_chip_name *p = arg;
 
 	pr_cont("type=%u, ", p->match.type);
-	if (p->match.type == V4L2_CHIP_MATCH_I2C_DRIVER ||
-	    p->match.type == V4L2_CHIP_MATCH_SUBDEV_NAME)
+	if (p->match.type == V4L2_CHIP_MATCH_I2C_DRIVER)
 		pr_cont("name=%.*s, ",
 				(int)sizeof(p->match.name), p->match.name);
 	else
@@ -658,8 +656,7 @@ static void v4l_print_dbg_register(const void *arg, bool write_only)
 	const struct v4l2_dbg_register *p = arg;
 
 	pr_cont("type=%u, ", p->match.type);
-	if (p->match.type == V4L2_CHIP_MATCH_I2C_DRIVER ||
-	    p->match.type == V4L2_CHIP_MATCH_SUBDEV_NAME)
+	if (p->match.type == V4L2_CHIP_MATCH_I2C_DRIVER)
 		pr_cont("name=%.*s, ",
 				(int)sizeof(p->match.name), p->match.name);
 	else
@@ -1791,14 +1788,6 @@ static int v4l_log_status(const struct v4l2_ioctl_ops *ops,
 	return ret;
 }
 
-static bool v4l_dbg_found_match(const struct v4l2_dbg_match *match,
-		struct v4l2_subdev *sd, int idx)
-{
-	if (match->type == V4L2_CHIP_MATCH_SUBDEV_IDX)
-		return match->addr == idx;
-	return !strcmp(match->name, sd->name);
-}
-
 static int v4l_dbg_g_register(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
@@ -1810,14 +1799,12 @@ static int v4l_dbg_g_register(const struct v4l2_ioctl_ops *ops,
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (p->match.type == V4L2_CHIP_MATCH_SUBDEV_IDX ||
-	    p->match.type == V4L2_CHIP_MATCH_SUBDEV_NAME) {
+	if (p->match.type == V4L2_CHIP_MATCH_SUBDEV) {
 		if (vfd->v4l2_dev == NULL)
 			return -EINVAL;
-		v4l2_device_for_each_subdev(sd, vfd->v4l2_dev) {
-			if (v4l_dbg_found_match(&p->match, sd, idx++))
+		v4l2_device_for_each_subdev(sd, vfd->v4l2_dev)
+			if (p->match.addr == idx++)
 				return v4l2_subdev_call(sd, core, g_register, p);
-		}
 		return -EINVAL;
 	}
 	if (ops->vidioc_g_register)
@@ -1839,14 +1826,12 @@ static int v4l_dbg_s_register(const struct v4l2_ioctl_ops *ops,
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (p->match.type == V4L2_CHIP_MATCH_SUBDEV_IDX ||
-	    p->match.type == V4L2_CHIP_MATCH_SUBDEV_NAME) {
+	if (p->match.type == V4L2_CHIP_MATCH_SUBDEV) {
 		if (vfd->v4l2_dev == NULL)
 			return -EINVAL;
-		v4l2_device_for_each_subdev(sd, vfd->v4l2_dev) {
-			if (v4l_dbg_found_match(&p->match, sd, idx++))
+		v4l2_device_for_each_subdev(sd, vfd->v4l2_dev)
+			if (p->match.addr == idx++)
 				return v4l2_subdev_call(sd, core, s_register, p);
-		}
 		return -EINVAL;
 	}
 	if (ops->vidioc_s_register)
@@ -1864,8 +1849,7 @@ static int v4l_dbg_g_chip_ident(const struct v4l2_ioctl_ops *ops,
 
 	p->ident = V4L2_IDENT_NONE;
 	p->revision = 0;
-	if (p->match.type == V4L2_CHIP_MATCH_SUBDEV_NAME ||
-	    p->match.type == V4L2_CHIP_MATCH_SUBDEV_IDX)
+	if (p->match.type == V4L2_CHIP_MATCH_SUBDEV)
 		return -EINVAL;
 	return ops->vidioc_g_chip_ident(file, fh, p);
 }
@@ -1897,19 +1881,18 @@ static int v4l_dbg_g_chip_name(const struct v4l2_ioctl_ops *ops,
 			strlcpy(p->name, "bridge", sizeof(p->name));
 		return 0;
 
-	case V4L2_CHIP_MATCH_SUBDEV_IDX:
-	case V4L2_CHIP_MATCH_SUBDEV_NAME:
+	case V4L2_CHIP_MATCH_SUBDEV:
 		if (vfd->v4l2_dev == NULL)
 			break;
 		v4l2_device_for_each_subdev(sd, vfd->v4l2_dev) {
-			if (v4l_dbg_found_match(&p->match, sd, idx++)) {
-				if (sd->ops->core && sd->ops->core->s_register)
-					p->flags |= V4L2_CHIP_FL_WRITABLE;
-				if (sd->ops->core && sd->ops->core->g_register)
-					p->flags |= V4L2_CHIP_FL_READABLE;
-				strlcpy(p->name, sd->name, sizeof(p->name));
-				return 0;
-			}
+			if (p->match.addr != idx++)
+				continue;
+			if (sd->ops->core && sd->ops->core->s_register)
+				p->flags |= V4L2_CHIP_FL_WRITABLE;
+			if (sd->ops->core && sd->ops->core->g_register)
+				p->flags |= V4L2_CHIP_FL_READABLE;
+			strlcpy(p->name, sd->name, sizeof(p->name));
+			return 0;
 		}
 		break;
 	}
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index e9c49c5..4c941c1 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1812,8 +1812,7 @@ struct v4l2_event_subscription {
 #define V4L2_CHIP_MATCH_I2C_DRIVER  1  /* Match against I2C driver name */
 #define V4L2_CHIP_MATCH_I2C_ADDR    2  /* Match against I2C 7-bit address */
 #define V4L2_CHIP_MATCH_AC97        3  /* Match against anciliary AC97 chip */
-#define V4L2_CHIP_MATCH_SUBDEV_NAME 4  /* Match against subdev name */
-#define V4L2_CHIP_MATCH_SUBDEV_IDX  5  /* Match against subdev index */
+#define V4L2_CHIP_MATCH_SUBDEV      4  /* Match against subdev index */
 
 struct v4l2_dbg_match {
 	__u32 type; /* Match type */
-- 
1.7.10.4

