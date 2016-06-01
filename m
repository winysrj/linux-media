Return-path: <linux-media-owner@vger.kernel.org>
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:15434 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161258AbcFAQkL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2016 12:40:11 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com,
	Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH v3 4/8] Input: atmel_mxt_ts - output diagnostic debug via v4l2 device
Date: Wed,  1 Jun 2016 17:39:48 +0100
Message-Id: <1464799192-28034-5-git-send-email-nick.dyer@itdev.co.uk>
In-Reply-To: <1464799192-28034-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1464799192-28034-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Register a video device to output T37 diagnostic data.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/Kconfig        |   2 +
 drivers/input/touchscreen/atmel_mxt_ts.c | 247 +++++++++++++++++++++++++++++++
 2 files changed, 249 insertions(+)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 8ecdc38..73154b6 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -105,6 +105,8 @@ config TOUCHSCREEN_AR1021_I2C
 config TOUCHSCREEN_ATMEL_MXT
 	tristate "Atmel mXT I2C Touchscreen"
 	depends on I2C
+	depends on VIDEO_V4L2
+	select VIDEOBUF2_VMALLOC
 	select FW_LOADER
 	help
 	  Say Y here if you have Atmel mXT series I2C touchscreen,
diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 21f42ed..8608cb1 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -28,6 +28,10 @@
 #include <linux/of.h>
 #include <linux/slab.h>
 #include <asm/unaligned.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-v4l2.h>
+#include <media/videobuf2-vmalloc.h>
 
 /* Firmware files */
 #define MXT_FW_NAME		"maxtouch.fw"
@@ -222,6 +226,23 @@ struct mxt_dbg {
 	struct t37_debug *t37_buf;
 	unsigned int t37_pages;
 	unsigned int t37_nodes;
+
+	struct v4l2_device v4l2;
+	struct v4l2_pix_format format;
+	struct video_device vdev;
+	struct vb2_queue queue;
+	struct mutex lock;
+	int input;
+};
+
+static const struct v4l2_file_operations mxt_video_fops = {
+	.owner = THIS_MODULE,
+	.open = v4l2_fh_open,
+	.release = vb2_fop_release,
+	.unlocked_ioctl = video_ioctl2,
+	.read = vb2_fop_read,
+	.mmap = vb2_fop_mmap,
+	.poll = vb2_fop_poll,
 };
 
 /* Each client has this additional data */
@@ -277,6 +298,11 @@ struct mxt_data {
 	struct completion crc_completion;
 };
 
+struct mxt_vb2_buffer {
+	struct vb2_buffer	vb;
+	struct list_head	list;
+};
+
 static size_t mxt_obj_size(const struct mxt_object *obj)
 {
 	return obj->size_minus_one + 1;
@@ -1523,6 +1549,9 @@ static void mxt_free_input_device(struct mxt_data *data)
 
 static void mxt_free_object_table(struct mxt_data *data)
 {
+	video_unregister_device(&data->dbg.vdev);
+	v4l2_device_unregister(&data->dbg.v4l2);
+
 	kfree(data->object_table);
 	data->object_table = NULL;
 	kfree(data->msg_buf);
@@ -2154,10 +2183,191 @@ wait_cmd:
 	return mxt_convert_debug_pages(data, outbuf);
 }
 
+static int mxt_queue_setup(struct vb2_queue *q,
+		       unsigned int *nbuffers, unsigned int *nplanes,
+		       unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct mxt_data *data = q->drv_priv;
+	size_t size = data->dbg.t37_nodes * sizeof(u16);
+
+	if (*nplanes)
+		return sizes[0] < size ? -EINVAL : 0;
+
+	*nplanes = 1;
+	sizes[0] = size;
+
+	return 0;
+}
+
+static void mxt_buffer_queue(struct vb2_buffer *vb)
+{
+	struct mxt_data *data = vb2_get_drv_priv(vb->vb2_queue);
+	u16 *ptr;
+	int ret;
+
+	ptr = vb2_plane_vaddr(vb, 0);
+	if (!ptr) {
+		dev_err(&data->client->dev, "Error acquiring frame ptr\n");
+		goto fault;
+	}
+
+	ret = mxt_read_diagnostic_debug(data, MXT_DIAGNOSTIC_DELTAS, ptr);
+	if (ret)
+		goto fault;
+
+	vb2_set_plane_payload(vb, 0, data->dbg.t37_nodes * sizeof(u16));
+	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+	return;
+
+fault:
+	vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+}
+
+/* V4L2 structures */
+static const struct vb2_ops mxt_queue_ops = {
+	.queue_setup		= mxt_queue_setup,
+	.buf_queue		= mxt_buffer_queue,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
+};
+
+static const struct vb2_queue mxt_queue = {
+	.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
+	.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ,
+	.buf_struct_size = sizeof(struct mxt_vb2_buffer),
+	.ops = &mxt_queue_ops,
+	.mem_ops = &vb2_vmalloc_memops,
+	.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC,
+	.min_buffers_needed = 1,
+};
+
+static int mxt_vidioc_querycap(struct file *file, void *priv,
+				 struct v4l2_capability *cap)
+{
+	struct mxt_data *data = video_drvdata(file);
+
+	strlcpy(cap->driver, "atmel_mxt_ts", sizeof(cap->driver));
+	strlcpy(cap->card, "atmel_mxt_ts touch", sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info),
+		 "I2C:%s", dev_name(&data->client->dev));
+	return 0;
+}
+
+static int mxt_vidioc_enum_input(struct file *file, void *priv,
+				   struct v4l2_input *i)
+{
+	if (i->index > 0)
+		return -EINVAL;
+
+	i->type = V4L2_INPUT_TYPE_TOUCH_SENSOR;
+	strlcpy(i->name, "Mutual References", sizeof(i->name));
+	return 0;
+}
+
+static int mxt_set_input(struct mxt_data *data, unsigned int i)
+{
+	struct v4l2_pix_format *f = &data->dbg.format;
+
+	if (i > 0)
+		return -EINVAL;
+
+	f->width = data->info.matrix_xsize;
+	f->height = data->info.matrix_ysize;
+	f->pixelformat = V4L2_PIX_FMT_YS16;
+	f->field = V4L2_FIELD_NONE;
+	f->colorspace = V4L2_COLORSPACE_RAW;
+	f->bytesperline = f->width * sizeof(u16);
+	f->sizeimage = f->width * f->height * sizeof(u16);
+
+	data->dbg.input = i;
+
+	return 0;
+}
+
+static int mxt_vidioc_s_input(struct file *file, void *priv, unsigned int i)
+{
+	return mxt_set_input(video_drvdata(file), i);
+}
+
+static int mxt_vidioc_g_input(struct file *file, void *priv, unsigned int *i)
+{
+	struct mxt_data *data = video_drvdata(file);
+
+	*i = data->dbg.input;
+
+	return 0;
+}
+
+static int mxt_vidioc_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct mxt_data *data = video_drvdata(file);
+
+	f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	f->fmt.pix = data->dbg.format;
+
+	return 0;
+}
+
+static int mxt_vidioc_enum_fmt(struct file *file, void *priv,
+				 struct v4l2_fmtdesc *fmt)
+{
+	if (fmt->index > 0 || fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	fmt->pixelformat = V4L2_PIX_FMT_YS16;
+	return 0;
+}
+
+static int mxt_vidioc_g_parm(struct file *file, void *fh,
+			     struct v4l2_streamparm *a)
+{
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	a->parm.capture.readbuffers = 1;
+	a->parm.capture.timeperframe.numerator = 1;
+	a->parm.capture.timeperframe.denominator = 10;
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops mxt_video_ioctl_ops = {
+	.vidioc_querycap        = mxt_vidioc_querycap,
+
+	.vidioc_enum_fmt_vid_cap = mxt_vidioc_enum_fmt,
+	.vidioc_s_fmt_vid_cap   = mxt_vidioc_fmt,
+	.vidioc_g_fmt_vid_cap   = mxt_vidioc_fmt,
+	.vidioc_try_fmt_vid_cap	= mxt_vidioc_fmt,
+	.vidioc_g_parm		= mxt_vidioc_g_parm,
+
+	.vidioc_enum_input      = mxt_vidioc_enum_input,
+	.vidioc_g_input         = mxt_vidioc_g_input,
+	.vidioc_s_input         = mxt_vidioc_s_input,
+
+	.vidioc_reqbufs         = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs     = vb2_ioctl_create_bufs,
+	.vidioc_querybuf        = vb2_ioctl_querybuf,
+	.vidioc_qbuf            = vb2_ioctl_qbuf,
+	.vidioc_dqbuf           = vb2_ioctl_dqbuf,
+	.vidioc_expbuf          = vb2_ioctl_expbuf,
+
+	.vidioc_streamon        = vb2_ioctl_streamon,
+	.vidioc_streamoff       = vb2_ioctl_streamoff,
+};
+
+static const struct video_device mxt_video_device = {
+	.name = "Atmel maxTouch",
+	.fops = &mxt_video_fops,
+	.ioctl_ops = &mxt_video_ioctl_ops,
+	.release = video_device_release_empty,
+	.device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
+		       V4L2_CAP_STREAMING,
+};
+
 static void mxt_debug_init(struct mxt_data *data)
 {
 	struct mxt_dbg *dbg = &data->dbg;
 	struct mxt_object *object;
+	int error;
 
 	object = mxt_get_object(data, MXT_GEN_COMMAND_T6);
 	if (!object)
@@ -2187,8 +2397,45 @@ static void mxt_debug_init(struct mxt_data *data)
 	if (!dbg->t37_buf)
 		goto error;
 
+	/* init channel to zero */
+	mxt_set_input(data, 0);
+
+	/* register video device */
+	snprintf(dbg->v4l2.name, sizeof(dbg->v4l2.name), "%s", "atmel_mxt_ts");
+	error = v4l2_device_register(&data->client->dev, &dbg->v4l2);
+	if (error) {
+		dev_err(&data->client->dev, "Unable to register video master device.");
+		goto error;
+	}
+
+	/* initialize the queue */
+	mutex_init(&dbg->lock);
+	dbg->queue = mxt_queue;
+	dbg->queue.drv_priv = data;
+	dbg->queue.lock = &dbg->lock;
+
+	error = vb2_queue_init(&dbg->queue);
+	if (error)
+		goto error_unreg_v4l2;
+
+	dbg->vdev = mxt_video_device;
+	dbg->vdev.v4l2_dev = &dbg->v4l2;
+	dbg->vdev.lock = &dbg->lock;
+	dbg->vdev.vfl_dir = VFL_DIR_RX;
+	dbg->vdev.queue = &dbg->queue;
+	video_set_drvdata(&dbg->vdev, data);
+
+	error = video_register_device(&dbg->vdev, VFL_TYPE_TOUCH_SENSOR, -1);
+	if (error) {
+		dev_err(&data->client->dev,
+				"Unable to register video subdevice.");
+		goto error_unreg_v4l2;
+	}
+
 	return;
 
+error_unreg_v4l2:
+	v4l2_device_unregister(&dbg->v4l2);
 error:
 	dev_err(&data->client->dev, "Error initialising T37 diagnostic data\n");
 }
-- 
2.5.0

