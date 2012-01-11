Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58504 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933161Ab2AKPST (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 10:18:19 -0500
Received: from localhost.localdomain (unknown [91.178.113.85])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 8611935B55
	for <linux-media@vger.kernel.org>; Wed, 11 Jan 2012 15:18:16 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 3/3] uvcvideo: Implement compat_ioctl32 for custom ioctls
Date: Wed, 11 Jan 2012 16:18:40 +0100
Message-Id: <1326295120-15391-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1326295120-15391-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1326295120-15391-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support 32-bit/64-bit compatibility for the the UVCIOC_ ioctls.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_v4l2.c |  205 ++++++++++++++++++++++++++++++++++++
 1 files changed, 205 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index f09ee8b..73ae152 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -11,6 +11,7 @@
  *
  */
 
+#include <linux/compat.h>
 #include <linux/kernel.h>
 #include <linux/version.h>
 #include <linux/list.h>
@@ -1030,6 +1031,207 @@ static long uvc_v4l2_ioctl(struct file *file,
 	return video_usercopy(file, cmd, arg, uvc_v4l2_do_ioctl);
 }
 
+#ifdef CONFIG_COMPAT
+struct uvc_xu_control_mapping32 {
+	__u32 id;
+	__u8 name[32];
+	__u8 entity[16];
+	__u8 selector;
+
+	__u8 size;
+	__u8 offset;
+	__u32 v4l2_type;
+	__u32 data_type;
+
+	compat_caddr_t menu_info;
+	__u32 menu_count;
+
+	__u32 reserved[4];
+};
+
+static int uvc_v4l2_get_xu_mapping(struct uvc_xu_control_mapping *kp,
+			const struct uvc_xu_control_mapping32 __user *up)
+{
+	struct uvc_menu_info __user *umenus;
+	struct uvc_menu_info __user *kmenus;
+	compat_caddr_t p;
+
+	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
+	    __copy_from_user(kp, up, offsetof(typeof(*up), menu_info)) ||
+	    __get_user(kp->menu_count, &up->menu_count))
+		return -EFAULT;
+
+	memset(kp->reserved, 0, sizeof(kp->reserved));
+
+	if (kp->menu_count == 0) {
+		kp->menu_info = NULL;
+		return 0;
+	}
+
+	if (__get_user(p, &up->menu_info))
+		return -EFAULT;
+	umenus = compat_ptr(p);
+	if (!access_ok(VERIFY_READ, umenus, kp->menu_count * sizeof(*umenus)))
+		return -EFAULT;
+
+	kmenus = compat_alloc_user_space(kp->menu_count * sizeof(*kmenus));
+	if (kmenus == NULL)
+		return -EFAULT;
+	kp->menu_info = kmenus;
+
+	if (copy_in_user(kmenus, umenus, kp->menu_count * sizeof(*umenus)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int uvc_v4l2_put_xu_mapping(const struct uvc_xu_control_mapping *kp,
+			struct uvc_xu_control_mapping32 __user *up)
+{
+	struct uvc_menu_info __user *umenus;
+	struct uvc_menu_info __user *kmenus = kp->menu_info;
+	compat_caddr_t p;
+
+	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
+	    __copy_to_user(up, kp, offsetof(typeof(*up), menu_info)) ||
+	    __put_user(kp->menu_count, &up->menu_count))
+		return -EFAULT;
+
+	__clear_user(up->reserved, sizeof(up->reserved));
+
+	if (kp->menu_count == 0)
+		return 0;
+
+	if (get_user(p, &up->menu_info))
+		return -EFAULT;
+	umenus = compat_ptr(p);
+	if (!access_ok(VERIFY_WRITE, umenus, kp->menu_count * sizeof(*umenus)))
+		return -EFAULT;
+
+	if (copy_in_user(umenus, kmenus, kp->menu_count * sizeof(*umenus)))
+		return -EFAULT;
+
+	return 0;
+}
+
+struct uvc_xu_control_query32 {
+	__u8 unit;
+	__u8 selector;
+	__u8 query;
+	__u16 size;
+	compat_caddr_t data;
+};
+
+static int uvc_v4l2_get_xu_query(struct uvc_xu_control_query *kp,
+			const struct uvc_xu_control_query32 __user *up)
+{
+	u8 __user *udata;
+	u8 __user *kdata;
+	compat_caddr_t p;
+
+	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
+	    __copy_from_user(kp, up, offsetof(typeof(*up), data)))
+		return -EFAULT;
+
+	if (kp->size == 0) {
+		kp->data = NULL;
+		return 0;
+	}
+
+	if (__get_user(p, &up->data))
+		return -EFAULT;
+	udata = compat_ptr(p);
+	if (!access_ok(VERIFY_READ, udata, kp->size))
+		return -EFAULT;
+
+	kdata = compat_alloc_user_space(kp->size);
+	if (kdata == NULL)
+		return -EFAULT;
+	kp->data = kdata;
+
+	if (copy_in_user(kdata, udata, kp->size))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int uvc_v4l2_put_xu_query(const struct uvc_xu_control_query *kp,
+			struct uvc_xu_control_query32 __user *up)
+{
+	u8 __user *udata;
+	u8 __user *kdata = kp->data;
+	compat_caddr_t p;
+
+	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
+	    __copy_to_user(up, kp, offsetof(typeof(*up), data)))
+		return -EFAULT;
+
+	if (kp->size == 0)
+		return 0;
+
+	if (get_user(p, &up->data))
+		return -EFAULT;
+	udata = compat_ptr(p);
+	if (!access_ok(VERIFY_READ, udata, kp->size))
+		return -EFAULT;
+
+	if (copy_in_user(udata, kdata, kp->size))
+		return -EFAULT;
+
+	return 0;
+}
+
+#define UVCIOC_CTRL_MAP32	_IOWR('u', 0x20, struct uvc_xu_control_mapping32)
+#define UVCIOC_CTRL_QUERY32	_IOWR('u', 0x21, struct uvc_xu_control_query32)
+
+static long uvc_v4l2_compat_ioctl32(struct file *file,
+		     unsigned int cmd, unsigned long arg)
+{
+	union {
+		struct uvc_xu_control_mapping xmap;
+		struct uvc_xu_control_query xqry;
+	} karg;
+	void __user *up = compat_ptr(arg);
+	mm_segment_t old_fs;
+	long ret;
+
+	switch (cmd) {
+	case UVCIOC_CTRL_MAP32:
+		cmd = UVCIOC_CTRL_MAP32;
+		ret = uvc_v4l2_get_xu_mapping(&karg.xmap, up);
+		break;
+
+	case UVCIOC_CTRL_QUERY32:
+		cmd = UVCIOC_CTRL_QUERY32;
+		ret = uvc_v4l2_get_xu_query(&karg.xqry, up);
+		break;
+
+	default:
+		return -ENOIOCTLCMD;
+	}
+
+	old_fs = get_fs();
+	set_fs(KERNEL_DS);
+	ret = uvc_v4l2_ioctl(file, cmd, (unsigned long)&karg);
+	set_fs(old_fs);
+
+	if (ret < 0)
+		return ret;
+
+	switch (cmd) {
+	case UVCIOC_CTRL_MAP:
+		ret = uvc_v4l2_put_xu_mapping(&karg.xmap, up);
+		break;
+
+	case UVCIOC_CTRL_QUERY:
+		ret = uvc_v4l2_put_xu_query(&karg.xqry, up);
+		break;
+	}
+
+	return ret;
+}
+#endif
+
 static ssize_t uvc_v4l2_read(struct file *file, char __user *data,
 		    size_t count, loff_t *ppos)
 {
@@ -1076,6 +1278,9 @@ const struct v4l2_file_operations uvc_fops = {
 	.open		= uvc_v4l2_open,
 	.release	= uvc_v4l2_release,
 	.unlocked_ioctl	= uvc_v4l2_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl32	= uvc_v4l2_compat_ioctl32,
+#endif
 	.read		= uvc_v4l2_read,
 	.mmap		= uvc_v4l2_mmap,
 	.poll		= uvc_v4l2_poll,
-- 
1.7.3.4

