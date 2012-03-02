Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3010 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab2CBNgX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 08:36:23 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv1 PATCH] Expose controls in debugfs
Date: Fri, 2 Mar 2012 14:36:16 +0100
Cc: Communications nexus for pvrusb2 driver <pvrusb2@isely.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201203021436.16026.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've resumed work on something that was discussed ages ago: exposing controls
in debugfs. It's quite useful in pvrusb2, but that code is completely custom.
Creating a general method for this is the goal of this patch.

The old thread can be found here:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg17453.html

Although the original proposal in that thread was to do it in sysfs, the
overall preference was to use debugfs instead.

This patch is quite simple and does not touch any driver code. All drivers
that use the V4L2 control framework (which sadly does not include pvrusb2
at the moment) will get it for free.

It even implements poll(), so you can poll on a control waiting for the value
to change. It also honours the priority setting (VIDIOC_G/S_PRIORITY).

The control type information is not exposed. As mentioned in the thread above,
I think adding debugfs entries with the type information will make it very messy.

One possible idea is to have the control files support VIDIOC_QUERYCTRL and
VIDIOC_QUERYMENU and to create a small utility that will read out that
information and output it in a manner that can be easily parsed. It would be
trivial to do this.

This patch should also work fine for v4l2-subdevX nodes, although I don't
have the hardware at the moment to check this.

The git tree containing this patch is here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/debugfs

This patch only exposes controls, it does not add controls that emulate V4L2
ioctls (as pvrusb2 does). I would have to experiment with that a bit. I'm not
convinced it is that useful (as opposed to calling v4l2-ctl).

Comments are welcome!

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/Kconfig      |   14 ++-
 drivers/media/video/v4l2-ctrls.c |  373 +++++++++++++++++++++++++++++++++++---
 drivers/media/video/v4l2-dev.c   |   59 ++++++-
 include/media/v4l2-ctrls.h       |   11 +
 include/media/v4l2-dev.h         |    6 +
 5 files changed, 428 insertions(+), 35 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 9adada0..ca7c758 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -87,7 +87,19 @@ config VIDEO_ADV_DEBUG
 	---help---
 	  Say Y here to enable advanced debugging functionality on some
 	  V4L devices.
-	  In doubt, say N.
+	  When in doubt, say N.
+
+if DEBUG_FS
+
+config VIDEO_DEBUGFS
+	bool "Enable debug FS support"
+	default n
+	---help---
+	  Say Y here to enable debug FS support where controls can be read and
+	  written through files under /sys/kernel/debug/video4linux.
+	  When in doubt, say N.
+
+endif
 
 config VIDEO_FIXED_MINOR_RANGES
 	bool "Enable old-style fixed minor ranges for video devices"
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 9091172..4f49643 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -21,6 +21,7 @@
 #include <linux/ctype.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/debugfs.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
@@ -1035,7 +1036,7 @@ static int cluster_changed(struct v4l2_ctrl *master)
 }
 
 /* Validate integer-type control */
-static int validate_new_int(const struct v4l2_ctrl *ctrl, s32 *pval)
+static int validate_int(const struct v4l2_ctrl *ctrl, s32 *pval)
 {
 	s32 val = *pval;
 	u32 offset;
@@ -1080,35 +1081,16 @@ static int validate_new_int(const struct v4l2_ctrl *ctrl, s32 *pval)
 	}
 }
 
-/* Validate a new control */
-static int validate_new(const struct v4l2_ctrl *ctrl, struct v4l2_ext_control *c)
+/* Validate a string control */
+static int validate_string(const struct v4l2_ctrl *ctrl, const char *s)
 {
-	char *s = c->string;
-	size_t len;
+	size_t len = strlen(s);
 
-	switch (ctrl->type) {
-	case V4L2_CTRL_TYPE_INTEGER:
-	case V4L2_CTRL_TYPE_BOOLEAN:
-	case V4L2_CTRL_TYPE_MENU:
-	case V4L2_CTRL_TYPE_BITMASK:
-	case V4L2_CTRL_TYPE_BUTTON:
-	case V4L2_CTRL_TYPE_CTRL_CLASS:
-		return validate_new_int(ctrl, &c->value);
-
-	case V4L2_CTRL_TYPE_INTEGER64:
-		return 0;
-
-	case V4L2_CTRL_TYPE_STRING:
-		len = strlen(s);
-		if (len < ctrl->minimum)
-			return -ERANGE;
-		if ((len - ctrl->minimum) % ctrl->step)
-			return -ERANGE;
-		return 0;
-
-	default:
-		return -EINVAL;
-	}
+	if (len < ctrl->minimum)
+		return -ERANGE;
+	if ((len - ctrl->minimum) % ctrl->step)
+		return -ERANGE;
+	return 0;
 }
 
 static inline u32 node2id(struct list_head *node)
@@ -1269,6 +1251,9 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
 	if (!new_ref)
 		return handler_set_err(hdl, -ENOMEM);
 	new_ref->ctrl = ctrl;
+#ifdef CONFIG_VIDEO_DEBUGFS
+	new_ref->minor = -1;
+#endif
 	if (ctrl->handler == hdl) {
 		/* By default each control starts in a cluster of its own.
 		   new_ref->ctrl is basically a cluster array with one
@@ -2151,7 +2136,10 @@ static int validate_ctrls(struct v4l2_ext_controls *cs,
 		   best-effort to avoid that. */
 		if (set && (ctrl->flags & V4L2_CTRL_FLAG_GRABBED))
 			return -EBUSY;
-		ret = validate_new(ctrl, &cs->controls[i]);
+		if (ctrl->type == V4L2_CTRL_TYPE_STRING)
+			ret = validate_string(ctrl, cs->controls[i].string);
+		else if (ctrl->type != V4L2_CTRL_TYPE_INTEGER64)
+			ret = validate_int(ctrl, &cs->controls[i].value);
 		if (ret)
 			return ret;
 	}
@@ -2301,7 +2289,7 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, s32 *val)
 	int ret;
 	int i;
 
-	ret = validate_new_int(ctrl, val);
+	ret = validate_int(ctrl, val);
 	if (ret)
 		return ret;
 
@@ -2414,3 +2402,328 @@ unsigned int v4l2_ctrl_poll(struct file *file, struct poll_table_struct *wait)
 	return 0;
 }
 EXPORT_SYMBOL(v4l2_ctrl_poll);
+
+#ifdef CONFIG_VIDEO_DEBUGFS
+
+static const char *get_class_prefix(u32 id)
+{
+	switch (V4L2_CTRL_ID2CLASS(id)) {
+	case V4L2_CTRL_CLASS_USER:
+		return "";
+	case V4L2_CTRL_CLASS_CAMERA:
+		return "camera_";
+	case V4L2_CTRL_CLASS_MPEG:
+		return "mpeg_";
+	case V4L2_CTRL_CLASS_FM_TX:
+		return "fm_tx_";
+	default:
+		return "unknown_";
+	}
+}
+
+/* Helper function to make a proper debugfs filename from the control name */
+static void make_debugfs_name(char *src)
+{
+	char *dst = src;
+
+	while (*src) {
+		if (*src == ' ' || *src == '-' || *src == '_')
+			*dst++ = '_';
+		else if (isalnum(*src))
+			*dst++ = tolower(*src);
+		src++;
+	}
+	*dst = 0;
+}
+
+static ssize_t debugfs_read(struct file *filp, char __user *buf,
+		size_t sz, loff_t *off)
+{
+	struct v4l2_ctrl_ref *ref = filp->f_path.dentry->d_inode->i_private;
+	struct video_device *vdev = video_devdata(filp);
+	struct v4l2_ctrl *ctrl = ref->ctrl;
+	struct v4l2_ctrl *master = ctrl->cluster[0];
+	char str[32] = "";
+	char *p = str;
+	ssize_t ret = 0;
+	int i;
+
+	if (!video_is_registered(vdev))
+		return -EIO;
+
+	if (ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY)
+		return -EACCES;
+
+	v4l2_ctrl_lock(ctrl);
+	/* g_volatile_ctrl will update the current control values */
+	if (ctrl->flags & V4L2_CTRL_FLAG_VOLATILE) {
+		for (i = 0; i < master->ncontrols; i++)
+			cur_to_new(master->cluster[i]);
+		ret = call_op(master, g_volatile_ctrl);
+	} else {
+		cur_to_new(ctrl);
+	}
+	if (ret)
+		goto exit;
+
+	switch (ctrl->type) {
+	case V4L2_CTRL_TYPE_BOOLEAN:
+	case V4L2_CTRL_TYPE_MENU:
+	case V4L2_CTRL_TYPE_INTEGER:
+		ret = snprintf(str, sizeof(str), "%d", ctrl->val);
+		break;
+	case V4L2_CTRL_TYPE_BITMASK:
+		ret = snprintf(str, sizeof(str), "0x%08x", (u32)ctrl->val);
+		break;
+	case V4L2_CTRL_TYPE_INTEGER64:
+		ret = snprintf(str, sizeof(str), "%lld",
+				(long long)ctrl->val64);
+		break;
+	case V4L2_CTRL_TYPE_STRING:
+		/* Note: ctrl->maximum < PAGE_SIZE since string controls
+		   with larger sizes never appear in debugfs. */
+		p = ctrl->string;
+		ret = strlen(ctrl->string);
+		break;
+	default:
+		break;
+	}
+
+	if (ret > 0)
+		ret = simple_read_from_buffer(buf, sz, off, p, ret);
+
+exit:
+	v4l2_ctrl_unlock(ctrl);
+	return ret;
+}
+
+static ssize_t debugfs_write(struct file *filp, const char __user *buf,
+		size_t sz, loff_t *off)
+{
+	struct v4l2_ctrl_ref *ref = filp->f_path.dentry->d_inode->i_private;
+	struct video_device *vdev = video_devdata(filp);
+	struct v4l2_ctrl *ctrl = ref->ctrl;
+	struct v4l2_ctrl *master = ctrl->cluster[0];
+	char str[32];
+	int len = min(sizeof(str) - 1, sz);
+	s32 val;
+	s64 val64;
+	int i;
+	int ret = 0;
+
+	if (!video_is_registered(vdev))
+		return -EIO;
+	if (test_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags)) {
+		ret = v4l2_prio_check(vdev->prio, V4L2_PRIORITY_INTERACTIVE);
+		if (ret)
+			return ret;
+	}
+
+	switch (ctrl->type) {
+	case V4L2_CTRL_TYPE_BOOLEAN:
+	case V4L2_CTRL_TYPE_MENU:
+	case V4L2_CTRL_TYPE_INTEGER:
+		if (copy_from_user(str, buf, len))
+			return -EFAULT;
+		str[len] = '\0';
+		ret = kstrtos32(str, 0, &val);
+		break;
+	case V4L2_CTRL_TYPE_BITMASK:
+		if (copy_from_user(str, buf, len))
+			return -EFAULT;
+		str[len] = '\0';
+		ret = kstrtou32(str, 0, (u32 *)&val);
+		break;
+	case V4L2_CTRL_TYPE_INTEGER64:
+		if (copy_from_user(str, buf, len))
+			return -EFAULT;
+		str[len] = '\0';
+		ret = kstrtos64(buf, 0, &val64);
+		break;
+	case V4L2_CTRL_TYPE_BUTTON:
+		break;
+	case V4L2_CTRL_TYPE_STRING:
+		if (copy_from_user(str, buf, len))
+			return -EFAULT;
+		str[len] = '\0';
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (ret)
+		return ret;
+
+	if (ctrl->type == V4L2_CTRL_TYPE_STRING)
+		ret = validate_string(ctrl, str);
+	else if (ctrl->type != V4L2_CTRL_TYPE_INTEGER64)
+		ret = validate_int(ctrl, &val);
+	if (ret)
+		return ret;
+
+	v4l2_ctrl_lock(ctrl);
+
+	/* Reset the 'is_new' flags of the cluster */
+	for (i = 0; i < master->ncontrols; i++)
+		if (master->cluster[i])
+			master->cluster[i]->is_new = 0;
+
+	/* For autoclusters with volatiles that are switched from auto to
+	   manual mode we have to update the current volatile values since
+	   those will become the initial manual values after such a switch. */
+	if (master->is_auto && master->has_volatiles && ctrl == master &&
+	    !is_cur_manual(master) && val == master->manual_mode_value)
+		update_from_auto_cluster(master);
+	ctrl->is_new = 1;
+
+	switch (ctrl->type) {
+	case V4L2_CTRL_TYPE_BOOLEAN:
+	case V4L2_CTRL_TYPE_MENU:
+	case V4L2_CTRL_TYPE_INTEGER:
+	case V4L2_CTRL_TYPE_BITMASK:
+		ctrl->val = val;
+		break;
+	case V4L2_CTRL_TYPE_INTEGER64:
+		ctrl->val64 = val64;
+		break;
+	case V4L2_CTRL_TYPE_STRING:
+		if (sz > ctrl->maximum) {
+			ret = -ERANGE;
+			break;
+		}
+		ctrl->string[sz] = '\0';
+		if (copy_from_user(ctrl->string, buf, sz))
+			ret = -EFAULT;
+		break;
+	case V4L2_CTRL_TYPE_BUTTON:
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	ret = try_or_set_cluster(NULL, master, true);
+	v4l2_ctrl_unlock(ctrl);
+	return ret ? ret : sz;
+}
+
+static int debugfs_open(struct inode *inode, struct file *filp)
+{
+	int ret = v4l2_open(inode, filp);
+	struct v4l2_ctrl_ref *ref = filp->f_path.dentry->d_inode->i_private;
+	struct video_device *vdev = video_devdata(filp);
+
+	if (!ret && test_bit(V4L2_FL_USES_V4L2_FH, &vdev->flags)) {
+		struct v4l2_fh *fh = filp->private_data;
+		struct v4l2_event_subscription sub = {
+			.type = V4L2_EVENT_CTRL,
+			.id = ref->ctrl->id,
+		};
+
+		ret = v4l2_event_subscribe(fh, &sub, 1);
+		if (ret)
+			v4l2_release(inode, filp);
+	}
+	return ret;
+}
+
+static unsigned int debugfs_poll(struct file *file, struct poll_table_struct *wait)
+{
+	struct v4l2_ctrl_ref *ref = file->f_path.dentry->d_inode->i_private;
+	struct v4l2_ctrl *ctrl = ref->ctrl;
+	struct video_device *vdev = video_devdata(file);
+	unsigned int mask = 0;
+
+	if (test_bit(V4L2_FL_USES_V4L2_FH, &vdev->flags)) {
+		mask = v4l2_ctrl_poll(file, wait);
+
+		if (mask & POLLPRI) {
+			struct v4l2_fh *fh = file->private_data;
+			struct v4l2_event dummy;
+
+			v4l2_event_dequeue(fh, &dummy, 1);
+		}
+	}
+	if (!(ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY))
+		mask |= POLLIN | POLLRDNORM; /* readable */
+	if (!(ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY))
+		mask |= POLLOUT | POLLWRNORM; /* writable */
+	return mask;
+}
+
+const struct file_operations debugfs_fops = {
+	.owner = THIS_MODULE,
+	.read = debugfs_read,
+	.write = debugfs_write,
+	.open = debugfs_open,
+	.release = v4l2_release,
+	.poll = debugfs_poll,
+	.llseek = no_llseek,
+};
+
+/* Update the debugfs controls if something changed. */
+int v4l2_ctrl_debugfs_update_controls(struct video_device *vdev)
+{
+	struct v4l2_ctrl_handler *hdl = vdev->ctrl_handler;
+	struct v4l2_ctrl_ref *ref;
+	int err = 0;
+
+	if (hdl == NULL || vdev->debugfs_devnode == NULL)
+		return 0;
+
+	debugfs_remove_recursive(vdev->debugfs_controls);
+	vdev->debugfs_controls =
+		debugfs_create_dir("controls", vdev->debugfs_devnode);
+	if (IS_ERR_OR_NULL(vdev->debugfs_controls)) {
+		printk(KERN_ERR "%s: debugfs: could not create %s/%s\n",
+				__func__, video_device_node_name(vdev),
+				"controls");
+		vdev->debugfs_controls = NULL;
+		return -ENODEV;
+	}
+
+	list_for_each_entry(ref, &hdl->ctrl_refs, node) {
+		struct v4l2_ctrl *ctrl = ref->ctrl;
+		const char *prefix = get_class_prefix(ctrl->id);
+		char name[strlen(ctrl->name) + strlen(prefix) + 1];
+		mode_t mode = S_IRUGO | S_IWUGO;
+		struct dentry *debugfs_file;
+
+		if (ctrl->type == V4L2_CTRL_TYPE_CTRL_CLASS)
+			continue;
+		if (ctrl->flags & V4L2_CTRL_FLAG_DISABLED)
+			continue;
+
+		strcpy(name, prefix);
+		strcat(name, ctrl->name);
+		make_debugfs_name(name);
+
+		if (ref->minor < 0)
+			ref->minor = vdev->minor;
+
+		if (ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY)
+			mode = S_IWUGO;
+		else if (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY)
+			mode = S_IRUGO;
+
+		debugfs_file = debugfs_create_file(name,
+				mode, vdev->debugfs_controls, ref,
+				&debugfs_fops);
+		if (IS_ERR_OR_NULL(debugfs_file)) {
+			printk(KERN_ERR "%s: debugfs: could not create %s\n",
+					__func__, name);
+			err = -ENODEV;
+			break;
+		}
+	}
+	if (err) {
+		debugfs_remove_recursive(vdev->debugfs_controls);
+		vdev->debugfs_controls = NULL;
+		list_for_each_entry(ref, &hdl->ctrl_refs, node) {
+			if (ref->minor == vdev->minor)
+				ref->minor = -1;
+		}
+	}
+	return err;
+}
+EXPORT_SYMBOL(v4l2_ctrl_debugfs_update_controls);
+
+#endif
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 96e9615..0a59a75 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -25,16 +25,21 @@
 #include <linux/init.h>
 #include <linux/kmod.h>
 #include <linux/slab.h>
+#include <linux/debugfs.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
 
 #define VIDEO_NUM_DEVICES	256
 #define VIDEO_NAME              "video4linux"
 
+/* debugfs video4linux top directory */
+static struct dentry *debugfs_topdir;
+
 /*
  *	sysfs stuff
  */
@@ -199,6 +204,13 @@ static struct class video_class = {
 
 struct video_device *video_devdata(struct file *file)
 {
+#ifdef CONFIG_VIDEO_DEBUGFS
+	if (file->f_op == &debugfs_fops) {
+		struct v4l2_ctrl_ref *ref = file->f_path.dentry->d_inode->i_private;
+
+		return video_device[ref->minor];
+	}
+#endif
 	return video_device[iminor(file->f_path.dentry->d_inode)];
 }
 EXPORT_SYMBOL(video_devdata);
@@ -402,7 +414,7 @@ static int v4l2_mmap(struct file *filp, struct vm_area_struct *vm)
 }
 
 /* Override for the open function */
-static int v4l2_open(struct inode *inode, struct file *filp)
+int v4l2_open(struct inode *inode, struct file *filp)
 {
 	struct video_device *vdev;
 	int ret = 0;
@@ -439,7 +451,7 @@ err:
 }
 
 /* Override for the release function */
-static int v4l2_release(struct inode *inode, struct file *filp)
+int v4l2_release(struct inode *inode, struct file *filp)
 {
 	struct video_device *vdev = video_devdata(filp);
 	int ret = 0;
@@ -672,12 +684,29 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 		goto cleanup;
 	}
 
-	/* Part 4: register the device with sysfs */
+	/* Part 4: register the device with sysfs and debugfs */
 	vdev->dev.class = &video_class;
 	vdev->dev.devt = MKDEV(VIDEO_MAJOR, vdev->minor);
 	if (vdev->parent)
 		vdev->dev.parent = vdev->parent;
 	dev_set_name(&vdev->dev, "%s%d", name_base, vdev->num);
+
+#ifdef CONFIG_VIDEO_DEBUGFS
+	if (debugfs_topdir) {
+		vdev->debugfs_devnode =
+			debugfs_create_dir(video_device_node_name(vdev),
+							debugfs_topdir);
+		if (IS_ERR_OR_NULL(vdev->debugfs_devnode)) {
+			printk(KERN_ERR "%s: debugfs: could not create %s\n",
+					__func__, video_device_node_name(vdev));
+			goto cleanup;
+		}
+		ret = v4l2_ctrl_debugfs_update_controls(vdev);
+		if (ret)
+			goto cleanup;
+	}
+#endif
+
 	ret = device_register(&vdev->dev);
 	if (ret < 0) {
 		printk(KERN_ERR "%s: device_register failed\n", __func__);
@@ -720,6 +749,11 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 	return 0;
 
 cleanup:
+	if (!IS_ERR_OR_NULL(vdev->debugfs_devnode)) {
+		debugfs_remove_recursive(vdev->debugfs_devnode);
+		vdev->debugfs_devnode = NULL;
+		vdev->debugfs_controls = NULL;
+	}
 	mutex_lock(&videodev_lock);
 	if (vdev->cdev)
 		cdev_del(vdev->cdev);
@@ -744,6 +778,9 @@ void video_unregister_device(struct video_device *vdev)
 	if (!vdev || !video_is_registered(vdev))
 		return;
 
+	debugfs_remove_recursive(vdev->debugfs_devnode);
+	vdev->debugfs_devnode = NULL;
+	vdev->debugfs_controls = NULL;
 	mutex_lock(&videodev_lock);
 	/* This must be in a critical section to prevent a race with v4l2_open.
 	 * Once this bit has been cleared video_get may never be called again.
@@ -763,8 +800,20 @@ static int __init videodev_init(void)
 	int ret;
 
 	printk(KERN_INFO "Linux video capture interface: v2.00\n");
+
+	debugfs_topdir = debugfs_create_dir(VIDEO_NAME, NULL);
+	if (IS_ERR_OR_NULL(debugfs_topdir) &&
+			debugfs_topdir != ERR_PTR(-ENODEV)) {
+		printk(KERN_ERR "videodev: could not create %s debugfs dir\n",
+								VIDEO_NAME);
+		return -ENODEV;
+	}
+	if (IS_ERR(debugfs_topdir))
+		debugfs_topdir = NULL;
+
 	ret = register_chrdev_region(dev, VIDEO_NUM_DEVICES, VIDEO_NAME);
 	if (ret < 0) {
+		debugfs_remove_recursive(debugfs_topdir);
 		printk(KERN_WARNING "videodev: unable to get major %d\n",
 				VIDEO_MAJOR);
 		return ret;
@@ -772,8 +821,9 @@ static int __init videodev_init(void)
 
 	ret = class_register(&video_class);
 	if (ret < 0) {
+		debugfs_remove_recursive(debugfs_topdir);
 		unregister_chrdev_region(dev, VIDEO_NUM_DEVICES);
-		printk(KERN_WARNING "video_dev: class_register failed\n");
+		printk(KERN_WARNING "videodev: class_register failed\n");
 		return -EIO;
 	}
 
@@ -784,6 +834,7 @@ static void __exit videodev_exit(void)
 {
 	dev_t dev = MKDEV(VIDEO_MAJOR, 0);
 
+	debugfs_remove_recursive(debugfs_topdir);
 	class_unregister(&video_class);
 	unregister_chrdev_region(dev, VIDEO_NUM_DEVICES);
 }
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 3dbd066..54c0fcf 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -160,6 +160,9 @@ struct v4l2_ctrl_ref {
 	struct v4l2_ctrl_ref *next;
 	struct v4l2_ctrl *ctrl;
 	struct v4l2_ctrl_helper *helper;
+#ifdef CONFIG_VIDEO_DEBUGFS
+	int minor;
+#endif
 };
 
 /** struct v4l2_ctrl_handler - The control handler keeps track of all the
@@ -516,6 +519,12 @@ int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *
 int v4l2_s_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 						struct v4l2_ext_controls *c);
 
+/* Update debugfs control entries. Should be called by drivers if a new
+   control was added after the video device registration.
+   Returns 0 if vdev->ctrl_handler == NULL. */
+int v4l2_ctrl_debugfs_update_controls(struct video_device *vdev);
+
+
 /* Helpers for subdevices. If the associated ctrl_handler == NULL then they
    will all return -EINVAL. */
 int v4l2_subdev_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc);
@@ -526,4 +535,6 @@ int v4l2_subdev_s_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs
 int v4l2_subdev_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
 int v4l2_subdev_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
 
+extern const struct file_operations debugfs_fops;
+
 #endif
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index c7c40f1..6f21386 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -94,6 +94,10 @@ struct video_device
 	/* Control handler associated with this device node. May be NULL. */
 	struct v4l2_ctrl_handler *ctrl_handler;
 
+	/* debugfs directories */
+	struct dentry *debugfs_devnode;
+	struct dentry *debugfs_controls;
+
 	/* Priority state. If NULL, then v4l2_dev->prio will be used. */
 	struct v4l2_prio_state *prio;
 
@@ -199,5 +203,7 @@ static inline int video_is_registered(struct video_device *vdev)
 {
 	return test_bit(V4L2_FL_REGISTERED, &vdev->flags);
 }
+int v4l2_open(struct inode *inode, struct file *filp);
+int v4l2_release(struct inode *inode, struct file *filp);
 
 #endif /* _V4L2_DEV_H */
-- 
1.7.9.1

