Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:49807 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753524AbbEFG5x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 May 2015 02:57:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 6/8] v4l2-ioctl: add MEDIA_IOC_DEVICE_INFO
Date: Wed,  6 May 2015 08:57:21 +0200
Message-Id: <1430895443-41839-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1430895443-41839-1-git-send-email-hverkuil@xs4all.nl>
References: <1430895443-41839-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Support the MEDIA_IOC_DEVICE_INFO ioctl for entities.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 38 +++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 343f3e2..02afffd 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -885,6 +885,19 @@ static void v4l_print_default(const void *arg, bool write_only)
 	pr_cont("driver-specific ioctl\n");
 }
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+static void media_print_device_info(const void *arg, bool write_only)
+{
+	const struct media_device_info *p = arg;
+
+	pr_cont("driver=%s, model=%s, serial=%s, bus_info=%s\n",
+		p->driver, p->model, p->serial, p->bus_info);
+	pr_cont("media_version=0x%08x, hw_revision=%u, driver_version=0x%08x, major=%u, minor=%u, entity_id=%u\n",
+		p->media_version, p->hw_revision, p->driver_version,
+		p->major, p->minor, p->entity_id);
+}
+#endif
+
 static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
 {
 	__u32 i;
@@ -2331,6 +2344,21 @@ static int v4l_enum_freq_bands(const struct v4l2_ioctl_ops *ops,
 	return -ENOTTY;
 }
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+static int media_device_info(const struct v4l2_ioctl_ops *ops,
+			     struct file *file, void *fh, void *arg)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct media_device_info *info = arg;
+
+	if (vdev->entity.parent == NULL)
+		return -ENOTTY;
+	media_device_fill_info(vdev->entity.parent, info);
+	info->entity_id = vdev->entity.id;
+	return 0;
+}
+#endif
+
 struct v4l2_ioctl_info {
 	unsigned int ioctl;
 	u32 flags;
@@ -2465,7 +2493,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 
 bool v4l2_is_known_ioctl(unsigned int cmd)
 {
-	if (_IOC_NR(cmd) >= V4L2_IOCTLS)
+	if (_IOC_TYPE(cmd) != 'V' || _IOC_NR(cmd) >= V4L2_IOCTLS)
 		return false;
 	return v4l2_ioctls[_IOC_NR(cmd)].ioctl == cmd;
 }
@@ -2553,6 +2581,14 @@ static long __video_do_ioctl(struct file *file,
 			if (ret)
 				goto done;
 		}
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	} else if (cmd == MEDIA_IOC_DEVICE_INFO) {
+		default_info.ioctl = cmd;
+		default_info.flags = INFO_FL_FUNC;
+		default_info.debug = media_print_device_info;
+		default_info.u.func = media_device_info;
+		info = &default_info;
+#endif
 	} else {
 		default_info.ioctl = cmd;
 		default_info.flags = 0;
-- 
2.1.4

