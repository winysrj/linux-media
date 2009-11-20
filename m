Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:58859 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758254AbZKTDZR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 22:25:17 -0500
Received: by mail-yx0-f187.google.com with SMTP id 17so2630577yxe.33
        for <linux-media@vger.kernel.org>; Thu, 19 Nov 2009 19:25:23 -0800 (PST)
From: Huang Shijie <shijie8@gmail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, Huang Shijie <shijie8@gmail.com>
Subject: [PATCH 08/11] add vbi code for tlg2300
Date: Fri, 20 Nov 2009 11:24:50 +0800
Message-Id: <1258687493-4012-9-git-send-email-shijie8@gmail.com>
In-Reply-To: <1258687493-4012-8-git-send-email-shijie8@gmail.com>
References: <1258687493-4012-1-git-send-email-shijie8@gmail.com>
 <1258687493-4012-2-git-send-email-shijie8@gmail.com>
 <1258687493-4012-3-git-send-email-shijie8@gmail.com>
 <1258687493-4012-4-git-send-email-shijie8@gmail.com>
 <1258687493-4012-5-git-send-email-shijie8@gmail.com>
 <1258687493-4012-6-git-send-email-shijie8@gmail.com>
 <1258687493-4012-7-git-send-email-shijie8@gmail.com>
 <1258687493-4012-8-git-send-email-shijie8@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the vbi module for tlg2300.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 drivers/media/video/tlg2300/pd-vbi.c |  183 ++++++++++++++++++++++++++++++++++
 1 files changed, 183 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/tlg2300/pd-vbi.c

diff --git a/drivers/media/video/tlg2300/pd-vbi.c b/drivers/media/video/tlg2300/pd-vbi.c
new file mode 100644
index 0000000..fb9ee0d
--- /dev/null
+++ b/drivers/media/video/tlg2300/pd-vbi.c
@@ -0,0 +1,183 @@
+#include <linux/kernel.h>
+#include <linux/usb.h>
+#include <linux/kref.h>
+#include <linux/uaccess.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <linux/version.h>
+#include <media/v4l2-common.h>
+#include <linux/types.h>
+#include <media/v4l2-dev.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/unistd.h>
+
+#include "vendorcmds.h"
+#include "pd-common.h"
+
+int vbi_request_buf(struct vbi_data *vbi_data, size_t size)
+{
+	int i, count = 4;
+
+	pd_bufqueue_init(&vbi_data->vbi_queue, &count, size, KERNEL_MEM);
+
+	for (i = 0; i < count; i++)
+		pd_bufqueue_qbuf(&vbi_data->vbi_queue, i);
+
+	vbi_data->buf_count = count;
+	return 0;
+}
+
+int vbi_release_buf(struct vbi_data *vbi_data)
+{
+	if (vbi_data->buf_count) {
+		pd_bufqueue_cleanup(&vbi_data->vbi_queue);
+		pd_bufqueue_wakeup(&vbi_data->vbi_queue);
+		vbi_data->buf_count = 0;
+	}
+	return 0;
+}
+
+static long vbi_v4l2_ioctl(struct file *file,
+			u32 cmd, unsigned long argp)
+{
+	struct poseidon *pd = file->private_data;
+	int ret = 0;
+
+	mutex_lock(&pd->lock);
+	switch (cmd) {
+	case VIDIOC_QUERYCAP: {
+		struct v4l2_capability *t_cap = (struct v4l2_capability *)argp;
+
+		strcpy(t_cap->driver, "Telegent Driver");
+		strcpy(t_cap->card, "Telegent Poseidon");
+		strcpy(t_cap->bus_info, "USB bus");
+		t_cap->version = 0;
+		t_cap->capabilities = V4L2_CAP_VBI_CAPTURE;
+	}
+		break;
+
+	case VIDIOC_S_FMT:
+	case VIDIOC_G_FMT: {
+		struct v4l2_format *v4l2_f = (struct v4l2_format *)argp;
+
+		v4l2_f->fmt.vbi.sampling_rate = 6750000 * 4;
+		v4l2_f->fmt.vbi.samples_per_line = 720*2/* VBI_LINE_LENGTH */;
+		v4l2_f->fmt.vbi.sample_format = V4L2_PIX_FMT_GREY;
+		v4l2_f->fmt.vbi.offset = 64 * 4;  /*FIXME: why offset */
+		if (pd->video_data.tvnormid & V4L2_STD_525_60) {
+			v4l2_f->fmt.vbi.start[0] = 10;
+			v4l2_f->fmt.vbi.start[1] = 264;
+			v4l2_f->fmt.vbi.count[0] = V4L_NTSC_VBI_LINES;
+			v4l2_f->fmt.vbi.count[1] = V4L_NTSC_VBI_LINES;
+		} else {
+			v4l2_f->fmt.vbi.start[0] = 6;
+			v4l2_f->fmt.vbi.start[1] = 314;
+			v4l2_f->fmt.vbi.count[0] = V4L_PAL_VBI_LINES;
+			v4l2_f->fmt.vbi.count[1] = V4L_PAL_VBI_LINES;
+		}
+		/* VBI_UNSYNC VBI_INTERLACED */
+		v4l2_f->fmt.vbi.flags = V4L2_VBI_UNSYNC;
+	}
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+	mutex_unlock(&pd->lock);
+	return ret;
+}
+
+static ssize_t vbi_read(struct file *file, char __user *buffer,
+			size_t count, loff_t *ppos)
+{
+	struct poseidon *pd = file->private_data;
+	struct vbi_data *vbi = &pd->vbi_data;
+
+	return vbi->buf_count ?
+		pd_bufqueue_read(&vbi->vbi_queue, file->f_flags, buffer, count)
+		: -EINVAL;
+}
+
+static int vbi_open(struct file *file)
+{
+	int ret = 0;
+	struct video_device *vd = video_devdata(file);
+	struct poseidon *pd = video_get_drvdata(vd);
+
+	if (!pd)
+		return -ENODEV;
+
+	mutex_lock(&pd->lock);
+	if (pd->state & POSEIDON_STATE_DISCONNECT) {
+		ret = -ENODEV;
+		goto out;
+	}
+	kref_get(&pd->kref);
+	file->private_data = pd;
+	set_debug_mode(vd, debug_mode);
+out:
+	mutex_unlock(&pd->lock);
+	return ret;
+}
+
+static int vbi_release(struct file *file)
+{
+	struct poseidon *pd = file->private_data;
+
+	if (!pd)
+		return -ENODEV;
+
+	kref_put(&pd->kref, poseidon_delete);
+	return 0;
+}
+
+static const struct v4l2_file_operations vbi_file_ops = {
+	.owner        = THIS_MODULE,
+	.open         = vbi_open,
+	.release      = vbi_release,
+	.read         = vbi_read,
+	.ioctl        = vbi_v4l2_ioctl,
+};
+
+static struct video_device vbi_device = {
+	.name		= "poseidon_vbi",
+	.fops		= &vbi_file_ops,
+	.release	=  video_device_release,
+};
+
+int vbi_init(struct poseidon *pd)
+{
+	int ret = 0;
+
+	memset(&(pd->vbi_data), 0, sizeof(struct vbi_data));
+
+	pd->vbi_data.vbi_dev = vdev_init(pd, &vbi_device);
+	if (pd->vbi_data.vbi_dev == NULL) {
+		ret = -ENOMEM;
+		goto vbi_error;
+	}
+
+	if (video_register_device(pd->vbi_data.vbi_dev, VFL_TYPE_VBI, -1) < 0) {
+		video_device_release(pd->vbi_data.vbi_dev);
+		pd->vbi_data.vbi_dev = NULL;
+		printk(KERN_DEBUG"vbi_init : video device register failed\n");
+		ret = -1;
+	}
+
+vbi_error:
+	return ret;
+}
+
+int vbi_exit(struct poseidon *pd)
+{
+	struct vbi_data *vbi_data = &pd->vbi_data;
+
+	if (vbi_data->vbi_dev) {
+		video_unregister_device(vbi_data->vbi_dev);
+		vbi_data->vbi_dev = NULL;
+	}
+	return 0;
+}
-- 
1.6.0.6

