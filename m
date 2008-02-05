Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m15Hke1A007183
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 12:46:40 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.1/8.13.1) with SMTP id m15Hk2eM016579
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 12:46:08 -0500
Date: Tue, 5 Feb 2008 18:46:13 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0802051828290.5882@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/6] soc_camera V4L2 driver for directly-connected SoC-based
 cameras
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This driver provides an interface between platform-specific camera
busses and camera devices. It should be used if the camera is connected
not over a "proper" bus like PCI or USB, but over a special bus, like,
for example, the Quick Capture interface on PXA270 SoCs. Later it should
also be used for i.MX31 SoCs from Freescale.  It can handle multiple
cameras and / or multiple busses, which can be used, e.g., in
stereo-vision applications.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

 drivers/media/video/Kconfig      |    9 +
 drivers/media/video/Makefile     |    2 +
 drivers/media/video/soc_camera.c |  973 ++++++++++++++++++++++++++++++++++++++
 include/media/soc_camera.h       |  145 ++++++
 4 files changed, 1129 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/soc_camera.c
 create mode 100644 include/media/soc_camera.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index a2e8987..ba1e3ac 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -836,4 +836,13 @@ config USB_STKWEBCAM
 
 endif # V4L_USB_DRIVERS
 
+config SOC_CAMERA
+	tristate "SoC camera support"
+	depends on VIDEO_V4L2
+	select VIDEOBUF_DMA_SG
+	help
+	  SoC Camera is a common API to several cameras, not connecting
+	  over a bus like PCI or USB. For example some i2c camera connected
+	  directly to the data bus of an SoC.
+
 endif # VIDEO_CAPTURE_DRIVERS
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 28ddd14..bfc1457 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -135,5 +135,7 @@ obj-$(CONFIG_VIDEO_IVTV) += ivtv/
 obj-$(CONFIG_VIDEO_VIVI) += vivi.o
 obj-$(CONFIG_VIDEO_CX23885) += cx23885/
 
+obj-$(CONFIG_SOC_CAMERA)	+= soc_camera.o
+
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
 EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
new file mode 100644
index 0000000..904e9df
--- /dev/null
+++ b/drivers/media/video/soc_camera.c
@@ -0,0 +1,973 @@
+/*
+ * camera image capture (abstract) bus driver
+ *
+ * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
+ *
+ * This driver provides an interface between platform-specific camera
+ * busses and camera devices. It should be used if the camera is
+ * connected not over a "proper" bus like PCI or USB, but over a
+ * special bus, like, for example, the Quick Capture interface on PXA270
+ * SoCs. Later it should also be used for i.MX31 SoCs from Freescale.
+ * It can handle multiple cameras and / or multiple busses, which can
+ * be used, e.g., in stereo-vision applications.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/vmalloc.h>
+
+#include <media/v4l2-common.h>
+#include <media/v4l2-dev.h>
+#include <media/soc_camera.h>
+
+static LIST_HEAD(hosts);
+static LIST_HEAD(devices);
+static DEFINE_MUTEX(list_lock);
+static DEFINE_MUTEX(video_lock);
+
+const static struct soc_camera_data_format*
+format_by_fourcc(struct soc_camera_device *icd, unsigned int fourcc)
+{
+	unsigned int i;
+
+	for (i = 0; i < icd->ops->num_formats; i++)
+		if (icd->ops->formats[i].fourcc == fourcc)
+			return icd->ops->formats + i;
+	return NULL;
+}
+
+static int soc_camera_try_fmt_cap(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+	enum v4l2_field field;
+	const struct soc_camera_data_format *fmt;
+	int ret;
+
+	WARN_ON(priv != file->private_data);
+
+	fmt = format_by_fourcc(icd, f->fmt.pix.pixelformat);
+	if (!fmt) {
+		dev_dbg(&icd->dev, "invalid format 0x%08x\n",
+			f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+	dev_dbg(&icd->dev, "fmt: 0x%08x\n", fmt->fourcc);
+
+	field = f->fmt.pix.field;
+
+	if (field == V4L2_FIELD_ANY) {
+		field = V4L2_FIELD_NONE;
+	} else if (V4L2_FIELD_NONE != field) {
+		dev_err(&icd->dev, "Field type invalid.\n");
+		return -EINVAL;
+	}
+
+	/* limit to host capabilities */
+	ret = ici->try_fmt_cap(ici, f);
+
+	/* limit to sensor capabilities */
+	if (!ret)
+		ret = icd->ops->try_fmt_cap(icd, f);
+
+	/* calculate missing fields */
+	f->fmt.pix.field = field;
+	f->fmt.pix.bytesperline =
+		(f->fmt.pix.width * fmt->depth) >> 3;
+	f->fmt.pix.sizeimage =
+		f->fmt.pix.height * f->fmt.pix.bytesperline;
+
+	return ret;
+}
+
+static int soc_camera_enum_input(struct file *file, void *priv,
+				 struct v4l2_input *inp)
+{
+	if (inp->index != 0)
+		return -EINVAL;
+
+	inp->type = V4L2_INPUT_TYPE_CAMERA;
+	inp->std = V4L2_STD_UNKNOWN;
+	strcpy(inp->name, "Camera");
+
+	return 0;
+}
+
+static int soc_camera_g_input(struct file *file, void *priv, unsigned int *i)
+{
+	*i = 0;
+
+	return 0;
+}
+
+static int soc_camera_s_input(struct file *file, void *priv, unsigned int i)
+{
+	if (i > 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int soc_camera_s_std(struct file *file, void *priv, v4l2_std_id *a)
+{
+	return 0;
+}
+
+static int soc_camera_reqbufs(struct file *file, void *priv,
+			      struct v4l2_requestbuffers *p)
+{
+	int ret;
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+
+	WARN_ON(priv != file->private_data);
+
+	dev_dbg(&icd->dev, "%s: %d\n", __FUNCTION__, p->memory);
+
+	ret = videobuf_reqbufs(&icf->vb_vidq, p);
+	if (ret < 0)
+		return ret;
+
+	return ici->reqbufs(icf, p);
+
+	return ret;
+}
+
+static int soc_camera_querybuf(struct file *file, void *priv,
+			       struct v4l2_buffer *p)
+{
+	struct soc_camera_file *icf = file->private_data;
+
+	WARN_ON(priv != file->private_data);
+
+	return videobuf_querybuf(&icf->vb_vidq, p);
+}
+
+static int soc_camera_qbuf(struct file *file, void *priv,
+			   struct v4l2_buffer *p)
+{
+	struct soc_camera_file *icf = file->private_data;
+
+	WARN_ON(priv != file->private_data);
+
+	return videobuf_qbuf(&icf->vb_vidq, p);
+}
+
+static int soc_camera_dqbuf(struct file *file, void *priv,
+			    struct v4l2_buffer *p)
+{
+	struct soc_camera_file *icf = file->private_data;
+
+	WARN_ON(priv != file->private_data);
+
+	return videobuf_dqbuf(&icf->vb_vidq, p, file->f_flags & O_NONBLOCK);
+}
+
+static int soc_camera_open(struct inode *inode, struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct soc_camera_device *icd = container_of(vdev->dev,
+					     struct soc_camera_device, dev);
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_file *icf;
+	int ret;
+
+	icf = vmalloc(sizeof(*icf));
+	if (!icf)
+		return -ENOMEM;
+
+	icf->icd = icd;
+
+	if (!try_module_get(icd->ops->owner)) {
+		dev_err(&icd->dev, "Couldn't lock sensor driver.\n");
+		ret = -EINVAL;
+		goto emgd;
+	}
+
+	if (!try_module_get(ici->owner)) {
+		dev_err(&icd->dev, "Couldn't lock capture bus driver.\n");
+		ret = -EINVAL;
+		goto emgi;
+	}
+
+	file->private_data = icf;
+	dev_dbg(&icd->dev, "camera device open\n");
+
+	/* We must pass NULL as dev pointer, then all pci_* dma operations
+	 * transform to normal dma_* ones. Do we need an irqlock? */
+	videobuf_queue_pci_init(&icf->vb_vidq, ici->vbq_ops, NULL, NULL,
+				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
+				ici->msize, icd);
+
+	return 0;
+
+emgi:
+	module_put(icd->ops->owner);
+emgd:
+	vfree(icf);
+	return ret;
+}
+
+static int soc_camera_close(struct inode *inode, struct file *file)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct video_device *vdev = icd->vdev;
+
+	module_put(icd->ops->owner);
+	module_put(ici->owner);
+	vfree(file->private_data);
+
+	dev_dbg(vdev->dev, "camera device close\n");
+
+	return 0;
+}
+
+static int soc_camera_read(struct file *file, char __user *buf,
+			   size_t count, loff_t *ppos)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+	struct video_device *vdev = icd->vdev;
+	int err = -EINVAL;
+
+	dev_err(vdev->dev, "camera device read not implemented\n");
+
+	return err;
+}
+
+static int soc_camera_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+	int err;
+
+	dev_dbg(&icd->dev, "mmap called, vma=0x%08lx\n", (unsigned long)vma);
+
+	err = videobuf_mmap_mapper(&icf->vb_vidq, vma);
+
+	dev_dbg(&icd->dev, "vma start=0x%08lx, size=%ld, ret=%d\n",
+		(unsigned long)vma->vm_start,
+		(unsigned long)vma->vm_end - (unsigned long)vma->vm_start,
+		err);
+
+	return err;
+}
+
+static unsigned int soc_camera_poll(struct file *file, poll_table *pt)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+
+	if (list_empty(&icf->vb_vidq.stream)) {
+		dev_err(&icd->dev, "Trying to poll with no queued buffers!\n");
+		return POLLERR;
+	}
+
+	return ici->poll(file, pt);
+}
+
+
+static struct file_operations soc_camera_fops = {
+	.owner		= THIS_MODULE,
+	.open		= soc_camera_open,
+	.release	= soc_camera_close,
+	.ioctl		= video_ioctl2,
+	.read		= soc_camera_read,
+	.mmap		= soc_camera_mmap,
+	.poll		= soc_camera_poll,
+	.llseek		= no_llseek,
+};
+
+
+static int soc_camera_s_fmt_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+	int ret;
+	struct v4l2_rect rect;
+	const static struct soc_camera_data_format *data_fmt;
+
+	WARN_ON(priv != file->private_data);
+
+	data_fmt = format_by_fourcc(icd, f->fmt.pix.pixelformat);
+	if (!data_fmt)
+		return -EINVAL;
+
+	/* cached_datawidth may be further adjusted by the ici */
+	icd->cached_datawidth = data_fmt->depth;
+
+	ret = soc_camera_try_fmt_cap(file, icf, f);
+	if (ret < 0)
+		return ret;
+
+	rect.left	= icd->x_current;
+	rect.top	= icd->y_current;
+	rect.width	= f->fmt.pix.width;
+	rect.height	= f->fmt.pix.height;
+	ret = ici->set_capture_format(icd, f->fmt.pix.pixelformat, &rect);
+
+	if (!ret) {
+		icd->current_fmt	= data_fmt;
+		icd->width		= rect.width;
+		icd->height		= rect.height;
+		icf->vb_vidq.field	= f->fmt.pix.field;
+		if (V4L2_BUF_TYPE_VIDEO_CAPTURE != f->type)
+			dev_warn(&icd->dev, "Attention! Wrong buf-type %d\n",
+				 f->type);
+
+		dev_dbg(&icd->dev, "set width: %d height: %d\n",
+		       icd->width, icd->height);
+	}
+
+	return ret;
+}
+
+static int soc_camera_enum_fmt_cap(struct file *file, void  *priv,
+				   struct v4l2_fmtdesc *f)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+	const struct soc_camera_data_format *format;
+
+	WARN_ON(priv != file->private_data);
+
+	if (f->index >= icd->ops->num_formats)
+		return -EINVAL;
+
+	format = &icd->ops->formats[f->index];
+
+	strlcpy(f->description, format->name, sizeof(f->description));
+	f->pixelformat = format->fourcc;
+	return 0;
+}
+
+static int soc_camera_g_fmt_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+
+	WARN_ON(priv != file->private_data);
+
+	f->fmt.pix.width	= icd->width;
+	f->fmt.pix.height	= icd->height;
+	f->fmt.pix.field	= icf->vb_vidq.field;
+	f->fmt.pix.pixelformat	= icd->current_fmt->fourcc;
+	f->fmt.pix.bytesperline	=
+		(f->fmt.pix.width * icd->current_fmt->depth) >> 3;
+	f->fmt.pix.sizeimage	=
+		f->fmt.pix.height * f->fmt.pix.bytesperline;
+	dev_dbg(&icd->dev, "current_fmt->fourcc: 0x%08x\n",
+		icd->current_fmt->fourcc);
+	return 0;
+}
+
+static int soc_camera_querycap(struct file *file, void  *priv,
+			       struct v4l2_capability *cap)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+
+	WARN_ON(priv != file->private_data);
+
+	strlcpy(cap->driver, ici->drv_name, sizeof(cap->driver));
+	return ici->querycap(ici, cap);
+}
+
+static int soc_camera_streamon(struct file *file, void *priv,
+			       enum v4l2_buf_type i)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+
+	WARN_ON(priv != file->private_data);
+
+	dev_dbg(&icd->dev, "%s\n", __FUNCTION__);
+
+	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	icd->ops->start_capture(icd);
+
+	/* This calls buf_queue from host driver's videobuf_queue_ops */
+	return videobuf_streamon(&icf->vb_vidq);
+}
+
+static int soc_camera_streamoff(struct file *file, void *priv,
+				enum v4l2_buf_type i)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+
+	WARN_ON(priv != file->private_data);
+
+	dev_dbg(&icd->dev, "%s\n", __FUNCTION__);
+
+	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	/* This calls buf_release from host driver's videobuf_queue_ops for all
+	 * remaining buffers. When the last buffer is freed, stop capture */
+	videobuf_streamoff(&icf->vb_vidq);
+
+	icd->ops->stop_capture(icd);
+
+	return 0;
+}
+
+static int soc_camera_queryctrl(struct file *file, void *priv,
+				struct v4l2_queryctrl *qc)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+	int i;
+
+	WARN_ON(priv != file->private_data);
+
+	if (!qc->id)
+		return -EINVAL;
+
+	for (i = 0; i < icd->ops->num_controls; i++)
+		if (qc->id == icd->ops->controls[i].id) {
+			memcpy(qc, &(icd->ops->controls[i]),
+				sizeof(*qc));
+			return 0;
+		}
+
+	return -EINVAL;
+}
+
+static int soc_camera_g_ctrl(struct file *file, void *priv,
+			     struct v4l2_control *ctrl)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+
+	WARN_ON(priv != file->private_data);
+
+	switch (ctrl->id) {
+	case V4L2_CID_GAIN:
+		if (icd->gain == (unsigned short)~0)
+			return -EINVAL;
+		ctrl->value = icd->gain;
+		return 0;
+	case V4L2_CID_EXPOSURE:
+		if (icd->exposure == (unsigned short)~0)
+			return -EINVAL;
+		ctrl->value = icd->exposure;
+		return 0;
+	}
+
+	if (icd->ops->get_control)
+		return icd->ops->get_control(icd, ctrl);
+	return -EINVAL;
+}
+
+static int soc_camera_s_ctrl(struct file *file, void *priv,
+			     struct v4l2_control *ctrl)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+
+	WARN_ON(priv != file->private_data);
+
+	if (icd->ops->set_control)
+		return icd->ops->set_control(icd, ctrl);
+	return -EINVAL;
+}
+
+static int soc_camera_cropcap(struct file *file, void *fh,
+			      struct v4l2_cropcap *a)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+
+	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	a->bounds.left			= icd->x_min;
+	a->bounds.top			= icd->y_min;
+	a->bounds.width			= icd->width_max;
+	a->bounds.height		= icd->height_max;
+	a->defrect.left			= icd->x_min;
+	a->defrect.top			= icd->y_min;
+	a->defrect.width		= 640;
+	a->defrect.height		= 480;
+	a->pixelaspect.numerator	= 1;
+	a->pixelaspect.denominator	= 1;
+
+	return 0;
+}
+
+static int soc_camera_g_crop(struct file *file, void *fh,
+			     struct v4l2_crop *a)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+
+	a->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	a->c.left	= icd->x_current;
+	a->c.top	= icd->y_current;
+	a->c.width	= icd->width;
+	a->c.height	= icd->height;
+
+	return 0;
+}
+
+static int soc_camera_s_crop(struct file *file, void *fh,
+			     struct v4l2_crop *a)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+	int ret;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	ret = ici->set_capture_format(icd, 0, &a->c);
+	if (!ret) {
+		icd->width	= a->c.width;
+		icd->height	= a->c.height;
+		icd->x_current	= a->c.left;
+		icd->y_current	= a->c.top;
+	}
+
+	return ret;
+}
+
+static int soc_camera_g_chip_ident(struct file *file, void *fh,
+				   struct v4l2_chip_ident *id)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+
+	if (!icd->ops->get_chip_id)
+		return -EINVAL;
+
+	return icd->ops->get_chip_id(icd, id);
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int soc_camera_g_register(struct file *file, void *fh,
+				 struct v4l2_register *reg)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+
+	if (!icd->ops->get_register)
+		return -EINVAL;
+
+	return icd->ops->get_register(icd, reg);
+}
+
+static int soc_camera_s_register(struct file *file, void *fh,
+				 struct v4l2_register *reg)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+
+	if (!icd->ops->set_register)
+		return -EINVAL;
+
+	return icd->ops->set_register(icd, reg);
+}
+#endif
+
+static int device_register_link(struct soc_camera_device *icd)
+{
+	int ret = device_register(&icd->dev);
+
+	if (ret < 0) {
+		/* Prevent calling device_unregister() */
+		icd->dev.parent = NULL;
+		dev_err(&icd->dev, "Cannot register device: %d\n", ret);
+	/* Even if probe() was unsuccessful for all registered drivers,
+	 * device_register() returns 0, and we add the link, just to
+	 * document this camera's control device */
+	} else if (icd->control)
+		/* Have to sysfs_remove_link() before device_unregister()? */
+		if (sysfs_create_link(&icd->dev.kobj, &icd->control->kobj,
+				      "control"))
+			dev_warn(&icd->dev,
+				 "Failed creating the control symlink\n");
+	return ret;
+}
+
+/* So far this function cannot fail */
+static void scan_add_host(struct soc_camera_host *ici)
+{
+	struct soc_camera_device *icd;
+
+	mutex_lock(&list_lock);
+
+	list_for_each_entry(icd, &devices, list) {
+		if (icd->iface == ici->nr) {
+			icd->dev.parent = &ici->dev;
+			device_register_link(icd);
+		}
+	}
+
+	mutex_unlock(&list_lock);
+}
+
+/* return: 0 if no match found or a match found and
+ * device_register() successful, error code otherwise */
+static int scan_add_device(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici;
+	int ret = 0;
+
+	mutex_lock(&list_lock);
+
+	list_add_tail(&icd->list, &devices);
+
+	/* Watch out for class_for_each_device / class_find_device API by
+	 * Dave Young <hidave.darkstar@gmail.com> */
+	list_for_each_entry(ici, &hosts, list) {
+		if (icd->iface == ici->nr) {
+			ret = 1;
+			icd->dev.parent = &ici->dev;
+			break;
+		}
+	}
+
+	mutex_unlock(&list_lock);
+
+	if (ret)
+		ret = device_register_link(icd);
+
+	return ret;
+}
+
+static int soc_camera_probe(struct device *dev)
+{
+	struct soc_camera_device *icd = to_soc_camera_dev(dev);
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+	int ret;
+
+	if (!icd->probe)
+		return -ENODEV;
+
+	ret = ici->add(icd);
+	if (ret < 0)
+		return ret;
+
+	ret = icd->probe(icd);
+	if (ret < 0)
+		ici->remove(icd);
+	else {
+		const struct v4l2_queryctrl *qctrl;
+
+		qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_GAIN);
+		icd->gain = qctrl ? qctrl->default_value : (unsigned short)~0;
+		qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
+		icd->exposure = qctrl ? qctrl->default_value :
+			(unsigned short)~0;
+	}
+
+	return ret;
+}
+
+/* This is called on device_unregister, which only means we have to disconnect
+ * from the host, but not remove ourselves from the device list */
+static int soc_camera_remove(struct device *dev)
+{
+	struct soc_camera_device *icd = to_soc_camera_dev(dev);
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+
+	if (icd->remove)
+		icd->remove(icd);
+
+	ici->remove(icd);
+
+	return 0;
+}
+
+static struct bus_type soc_camera_bus_type = {
+	.name		= "soc-camera",
+	.probe		= soc_camera_probe,
+	.remove		= soc_camera_remove,
+};
+
+static struct device_driver ic_drv = {
+	.name	= "camera",
+	.bus	= &soc_camera_bus_type,
+	.owner	= THIS_MODULE,
+};
+
+/*
+ * Image capture host - this is a host device, not a bus device, so,
+ * no bus reference, no probing.
+ */
+static struct class soc_camera_host_class = {
+	.owner		= THIS_MODULE,
+	.name		= "camera_host",
+};
+
+static void dummy_release(struct device *dev)
+{
+}
+
+int soc_camera_host_register(struct soc_camera_host *ici, struct module *owner)
+{
+	int ret;
+	struct soc_camera_host *ix;
+
+	if (!ici->vbq_ops || !ici->add || !ici->remove || !owner)
+		return -EINVAL;
+
+	/* Number might be equal to the platform device ID */
+	sprintf(ici->dev.bus_id, "camera_host%d", ici->nr);
+	ici->dev.class = &soc_camera_host_class;
+
+	mutex_lock(&list_lock);
+	list_for_each_entry(ix, &hosts, list) {
+		if (ix->nr == ici->nr) {
+			mutex_unlock(&list_lock);
+			return -EBUSY;
+		}
+	}
+
+	list_add_tail(&ici->list, &hosts);
+	mutex_unlock(&list_lock);
+
+	ici->owner = owner;
+	ici->dev.release = dummy_release;
+
+	ret = device_register(&ici->dev);
+
+	if (ret)
+		goto edevr;
+
+	scan_add_host(ici);
+
+	return 0;
+
+edevr:
+	mutex_lock(&list_lock);
+	list_del(&ici->list);
+	mutex_unlock(&list_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(soc_camera_host_register);
+
+/* Unregister all clients! */
+void soc_camera_host_unregister(struct soc_camera_host *ici)
+{
+	struct soc_camera_device *icd;
+
+	mutex_lock(&list_lock);
+
+	list_del(&ici->list);
+
+	list_for_each_entry(icd, &devices, list) {
+		if (icd->dev.parent == &ici->dev) {
+			device_unregister(&icd->dev);
+			/* Not before device_unregister(), .remove
+			 * needs parent to call ici->remove() */
+			icd->dev.parent = NULL;
+			memset(&icd->dev.kobj, 0, sizeof(icd->dev.kobj));
+		}
+	}
+
+	mutex_unlock(&list_lock);
+
+	device_unregister(&ici->dev);
+}
+EXPORT_SYMBOL(soc_camera_host_unregister);
+
+/* Image capture device */
+int soc_camera_device_register(struct soc_camera_device *icd)
+{
+	struct soc_camera_device *ix;
+	int num = -1, i;
+
+	if (!icd)
+		return -EINVAL;
+
+	for (i = 0; i < 256 && num < 0; i++) {
+		num = i;
+		list_for_each_entry(ix, &devices, list) {
+			if (ix->iface == icd->iface && ix->devnum == i) {
+				num = -1;
+				break;
+			}
+		}
+	}
+
+	if (num < 0)
+		/* ok, we have 256 cameras on this host...
+		 * man, stay reasonable... */
+		return -ENOMEM;
+
+	icd->devnum = num;
+	icd->dev.bus = &soc_camera_bus_type;
+	snprintf(icd->dev.bus_id, sizeof(icd->dev.bus_id),
+		 "%u-%u", icd->iface, icd->devnum);
+
+	icd->dev.release = dummy_release;
+
+	if (icd->ops->get_datawidth)
+		icd->cached_datawidth = icd->ops->get_datawidth(icd);
+
+	return scan_add_device(icd);
+}
+EXPORT_SYMBOL(soc_camera_device_register);
+
+void soc_camera_device_unregister(struct soc_camera_device *icd)
+{
+	mutex_lock(&list_lock);
+	list_del(&icd->list);
+
+	/* The bus->remove will be eventually called */
+	if (icd->dev.parent)
+		device_unregister(&icd->dev);
+	mutex_unlock(&list_lock);
+}
+EXPORT_SYMBOL(soc_camera_device_unregister);
+
+int soc_camera_video_start(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	int err = -ENOMEM;
+	struct video_device *vdev;
+
+	if (!icd->dev.parent)
+		return -ENODEV;
+
+	vdev = video_device_alloc();
+	if (!vdev)
+		goto evidallocd;
+	dev_dbg(&ici->dev, "Allocated video_device %p\n", vdev);
+
+	strlcpy(vdev->name, ici->drv_name, sizeof(vdev->name));
+	/* Maybe better &ici->dev */
+	vdev->dev		= &icd->dev;
+	vdev->type		= VID_TYPE_CAPTURE;
+	vdev->current_norm	= V4L2_STD_UNKNOWN;
+	vdev->fops		= &soc_camera_fops;
+	vdev->release		= video_device_release;
+	vdev->minor		= -1;
+	vdev->tvnorms		= V4L2_STD_UNKNOWN,
+	vdev->vidioc_querycap	= soc_camera_querycap;
+	vdev->vidioc_g_fmt_cap	= soc_camera_g_fmt_cap;
+	vdev->vidioc_enum_fmt_cap = soc_camera_enum_fmt_cap;
+	vdev->vidioc_s_fmt_cap	= soc_camera_s_fmt_cap;
+	vdev->vidioc_enum_input	= soc_camera_enum_input;
+	vdev->vidioc_g_input	= soc_camera_g_input;
+	vdev->vidioc_s_input	= soc_camera_s_input;
+	vdev->vidioc_s_std	= soc_camera_s_std;
+	vdev->vidioc_reqbufs	= soc_camera_reqbufs;
+	vdev->vidioc_try_fmt_cap = soc_camera_try_fmt_cap;
+	vdev->vidioc_querybuf	= soc_camera_querybuf;
+	vdev->vidioc_qbuf	= soc_camera_qbuf;
+	vdev->vidioc_dqbuf	= soc_camera_dqbuf;
+	vdev->vidioc_streamon	= soc_camera_streamon;
+	vdev->vidioc_streamoff	= soc_camera_streamoff;
+	vdev->vidioc_queryctrl	= soc_camera_queryctrl;
+	vdev->vidioc_g_ctrl	= soc_camera_g_ctrl;
+	vdev->vidioc_s_ctrl	= soc_camera_s_ctrl;
+	vdev->vidioc_cropcap	= soc_camera_cropcap;
+	vdev->vidioc_g_crop	= soc_camera_g_crop;
+	vdev->vidioc_s_crop	= soc_camera_s_crop;
+	vdev->vidioc_g_chip_ident = soc_camera_g_chip_ident;
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	vdev->vidioc_g_register	= soc_camera_g_register;
+	vdev->vidioc_s_register	= soc_camera_s_register;
+#endif
+
+	icd->current_fmt = &icd->ops->formats[0];
+
+	err = video_register_device(vdev, VFL_TYPE_GRABBER, vdev->minor);
+	if (err < 0) {
+		dev_err(vdev->dev, "video_register_device failed\n");
+		goto evidregd;
+	}
+	icd->vdev = vdev;
+
+	return 0;
+
+evidregd:
+	video_device_release(vdev);
+evidallocd:
+	return err;
+}
+EXPORT_SYMBOL(soc_camera_video_start);
+
+void soc_camera_video_stop(struct soc_camera_device *icd)
+{
+	struct video_device *vdev = icd->vdev;
+
+	dev_dbg(&icd->dev, "%s\n", __FUNCTION__);
+
+	if (!icd->dev.parent || !vdev)
+		return;
+
+	mutex_lock(&video_lock);
+	video_unregister_device(vdev);
+	icd->vdev = NULL;
+	mutex_unlock(&video_lock);
+}
+EXPORT_SYMBOL(soc_camera_video_stop);
+
+static int __init soc_camera_init(void)
+{
+	int ret = bus_register(&soc_camera_bus_type);
+	if (ret)
+		return ret;
+	ret = driver_register(&ic_drv);
+	if (ret)
+		goto edrvr;
+	ret = class_register(&soc_camera_host_class);
+	if (ret)
+		goto eclr;
+
+	return 0;
+
+eclr:
+	driver_unregister(&ic_drv);
+edrvr:
+	bus_unregister(&soc_camera_bus_type);
+	return ret;
+}
+
+static void __exit soc_camera_exit(void)
+{
+	class_unregister(&soc_camera_host_class);
+	driver_unregister(&ic_drv);
+	bus_unregister(&soc_camera_bus_type);
+}
+
+module_init(soc_camera_init);
+module_exit(soc_camera_exit);
+
+MODULE_DESCRIPTION("Image capture bus driver");
+MODULE_AUTHOR("Guennadi Liakhovetski <kernel@pengutronix.de>");
+MODULE_LICENSE("GPL");
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
new file mode 100644
index 0000000..5e3f146
--- /dev/null
+++ b/include/media/soc_camera.h
@@ -0,0 +1,147 @@
+/*
+ * camera image capture (abstract) bus driver header
+ *
+ * Copyright (C) 2006, Sascha Hauer, Pengutronix
+ * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef SOC_CAMERA_H
+#define SOC_CAMERA_H
+
+#include <linux/videodev2.h>
+#include <media/videobuf-dma-sg.h>
+
+struct soc_camera_device {
+	struct list_head list;
+	struct device dev;
+	struct device *control;
+	unsigned short width;		/* Current window */
+	unsigned short height;		/* sizes */
+	unsigned short x_min;		/* Camera capabilities */
+	unsigned short y_min;
+	unsigned short x_current;	/* Current window location */
+	unsigned short y_current;
+	unsigned short width_min;
+	unsigned short width_max;
+	unsigned short height_min;
+	unsigned short height_max;
+	unsigned short y_skip_top;	/* Lines to skip at the top */
+	unsigned short gain;
+	unsigned short exposure;
+	unsigned char iface;		/* Host number */
+	unsigned char devnum;		/* Device number per host */
+	unsigned char cached_datawidth;	/* See comment in .c */
+	struct soc_camera_ops *ops;
+	struct video_device *vdev;
+	const struct soc_camera_data_format *current_fmt;
+	int (*probe)(struct soc_camera_device *icd);
+	void (*remove)(struct soc_camera_device *icd);
+	struct module *owner;
+};
+
+struct soc_camera_file {
+	struct soc_camera_device *icd;
+	struct videobuf_queue vb_vidq;
+};
+
+struct soc_camera_host {
+	struct list_head list;
+	struct device dev;
+	unsigned char nr;				/* Host number */
+	size_t msize;
+	struct videobuf_queue_ops *vbq_ops;
+	struct module *owner;
+	void *priv;
+	char *drv_name;
+	int (*add)(struct soc_camera_device *);
+	void (*remove)(struct soc_camera_device *);
+	int (*set_capture_format)(struct soc_camera_device *, __u32,
+				  struct v4l2_rect *);
+	int (*try_fmt_cap)(struct soc_camera_host *, struct v4l2_format *);
+	int (*reqbufs)(struct soc_camera_file *, struct v4l2_requestbuffers *);
+	int (*querycap)(struct soc_camera_host *, struct v4l2_capability *);
+	unsigned int (*poll)(struct file *, poll_table *);
+};
+
+struct soc_camera_link {
+	/* Camera bus id, used to match a camera and a bus */
+	int bus_id;
+	/* GPIO number to switch between 8 and 10 bit modes */
+	unsigned int gpio;
+};
+
+static inline struct soc_camera_device *to_soc_camera_dev(struct device *dev)
+{
+	return container_of(dev, struct soc_camera_device, dev);
+}
+
+static inline struct soc_camera_host *to_soc_camera_host(struct device *dev)
+{
+	return container_of(dev, struct soc_camera_host, dev);
+}
+
+extern int soc_camera_host_register(struct soc_camera_host *ici,
+				     struct module *owner);
+extern void soc_camera_host_unregister(struct soc_camera_host *ici);
+extern int soc_camera_device_register(struct soc_camera_device *icd);
+extern void soc_camera_device_unregister(struct soc_camera_device *icd);
+
+extern int soc_camera_video_start(struct soc_camera_device *icd);
+extern void soc_camera_video_stop(struct soc_camera_device *icd);
+
+struct soc_camera_data_format {
+	char *name;
+	unsigned int depth;
+	__u32 fourcc;
+	enum v4l2_colorspace colorspace;
+};
+
+struct soc_camera_ops {
+	struct module *owner;
+	int (*init)(struct soc_camera_device *);
+	int (*release)(struct soc_camera_device *);
+	int (*start_capture)(struct soc_camera_device *);
+	int (*stop_capture)(struct soc_camera_device *);
+	int (*set_capture_format)(struct soc_camera_device *, __u32,
+				  struct v4l2_rect *, unsigned int);
+	int (*try_fmt_cap)(struct soc_camera_device *, struct v4l2_format *);
+	int (*get_chip_id)(struct soc_camera_device *,
+			   struct v4l2_chip_ident *);
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	int (*get_register)(struct soc_camera_device *, struct v4l2_register *);
+	int (*set_register)(struct soc_camera_device *, struct v4l2_register *);
+#endif
+	const struct soc_camera_data_format *formats;
+	int num_formats;
+	int (*get_control)(struct soc_camera_device *, struct v4l2_control *);
+	int (*set_control)(struct soc_camera_device *, struct v4l2_control *);
+	const struct v4l2_queryctrl *controls;
+	int num_controls;
+	unsigned int(*get_datawidth)(struct soc_camera_device *icd);
+};
+
+static inline struct v4l2_queryctrl const *soc_camera_find_qctrl(
+	struct soc_camera_ops *ops, int id)
+{
+	int i;
+
+	for (i = 0; i < ops->num_controls; i++)
+		if (ops->controls[i].id == id)
+			return &ops->controls[i];
+
+	return NULL;
+}
+
+#define IS_MASTER		(1<<0)
+#define IS_HSYNC_ACTIVE_HIGH	(1<<1)
+#define IS_VSYNC_ACTIVE_HIGH	(1<<2)
+#define IS_DATAWIDTH_8		(1<<3)
+#define IS_DATAWIDTH_9		(1<<4)
+#define IS_DATAWIDTH_10		(1<<5)
+#define IS_PCLK_SAMPLE_RISING	(1<<6)
+
+#endif
-- 
1.5.3.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
