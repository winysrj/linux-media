Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44588 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751395AbdCYRTc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Mar 2017 13:19:32 -0400
From: Helen Koike <helen.koike@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, jgebben@codeaurora.org,
        mchehab@osg.samsung.com,
        Helen Fornazier <helen.fornazier@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Koike <helen.koike@collabora.com>
Subject: [PATCH v7] [media] vimc: Virtual Media Controller core, capture and sensor
Date: Sat, 25 Mar 2017 14:11:36 -0300
Message-Id: <1490461896-19221-1-git-send-email-helen.koike@collabora.com>
In-Reply-To: <6c85eaf4-1f91-7964-1cf9-602005b62a94@collabora.co.uk>
References: <6c85eaf4-1f91-7964-1cf9-602005b62a94@collabora.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

First version of the Virtual Media Controller.
Add a simple version of the core of the driver, the capture and
sensor nodes in the topology, generating a grey image in a hardcoded
format.

Signed-off-by: Helen Koike <helen.koike@collabora.com>

---

Patch based in media/master tree, and available here:
https://github.com/helen-fornazier/opw-staging/tree/vimc/devel/v7

Changes since v6:
- add kernel-docs in vimc-core.h
- reorder list_del call in vimc_cap_return_all_buffers()
- call media_pipeline_stop in vimc_cap_start_streaming when fail
- remove DMA comment (left over from the sample driver)
- remove vb2_set_plane_payload call in vimc_cap_buffer_prepare
- remove format verification in vimc_cap_link_validate
- set vimc_pix_map_list as static
- use MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN in vimc_raw_create()
- register media device after creating the topology and unregister it before destroying the topology
- replace devm_kzalloc by kzalloc for allocating struct vimc_device
- uset TASK_UNINTERRUPTIBLE for vimc_thread_sen
- do not allow the creation of a sensor with no pads
- add more verbose description in Kconfig
- change copyright to 2017
- arrange includes: number before letters
- remove v4l2_dev pointer from vimc_cap_device structure
- coding style adjustments
- remove entity variable in vimc_cap_pipeline_s_stream
- declare and assign variables in vimc_cap_link_validate
- declare vimc_dev_release() and vimc_pdev closer to vimc_init()
- remove pad check in vimc_sen_enum_{mbus_code,frame_size} that is already performed by v4l2-subdev.c
- fix multiline comments to start with /*
- reorder variable declaration in functions
- remove pad and subdevice type check in vimc_cap_pipeline_s_stream
- add a note that sensor nodes can can have more then one source pad
- remove the use of entity->use_count in the core and attach the ved structure in sd or vd, use
  ent->obj_type to know which structure (sd or vd) to use
- rename vdev (video_device) to vd to be similar to sd (subdev)

Changes since v5:
- Fix message "Entity type for entity Sensor A was not initialized!"
  by initializing the sensor entity.function after the calling
  v4l2_subded_init
- populate device_caps in vimc_cap_create instead of in
  vimc_cap_querycap
- Fix typo in vimc-core.c s/de/the

Changes since v4:
- coding style fixes
- remove BUG_ON
- change copyright to 2016
- depens on VIDEO_V4L2_SUBDEV_API instead of select
- remove assignement of V4L2_CAP_DEVICE_CAPS
- s/vimc_cap_g_fmt_vid_cap/vimc_cap_fmt_vid_cap
- fix vimc_cap_queue_setup declaration type
- remove wrong buffer size check and add it in vimc_cap_buffer_prepare
- vimc_cap_create: remove unecessary check if v4l2_dev or v4l2_dev->dev is null
- vimc_cap_create: only allow a single pad
- vimc_sen_create: only allow source pads, remove unecessary source pads
checks in vimc_thread_sen

Changes since v3: fix rmmod crash and built-in compile
- Re-order unregister calls in vimc_device_unregister function (remove
rmmod issue)
- Call media_device_unregister_entity in vimc_raw_destroy
- Add depends on VIDEO_DEV && VIDEO_V4L2 and select VIDEOBUF2_VMALLOC
- Check *nplanes in queue_setup (this remove v4l2-compliance fail)
- Include <linux/kthread.h> in vimc-sensor.c
- Move include of <linux/slab.h> from vimc-core.c to vimc-core.h
- Generate 60 frames per sec instead of 1 in the sensor

Changes since v2: update with current media master tree
- Add struct media_pipeline in vimc_cap_device
- Use vb2_v4l2_buffer instead of vb2_buffer
- Typos
- Remove usage of entity->type and use entity->function instead
- Remove fmt argument from queue setup
- Use ktime_get_ns instead of v4l2_get_timestamp
- Iterate over link's list using list_for_each_entry
- Use media_device_{init, cleanup}
- Use entity->use_count to keep track of entities instead of the old
entity->id
- Replace media_entity_init by media_entity_pads_init
---
 drivers/media/platform/Kconfig             |   2 +
 drivers/media/platform/Makefile            |   1 +
 drivers/media/platform/vimc/Kconfig        |  14 +
 drivers/media/platform/vimc/Makefile       |   3 +
 drivers/media/platform/vimc/vimc-capture.c | 536 ++++++++++++++++++++++
 drivers/media/platform/vimc/vimc-capture.h |  28 ++
 drivers/media/platform/vimc/vimc-core.c    | 696 +++++++++++++++++++++++++++++
 drivers/media/platform/vimc/vimc-core.h    | 123 +++++
 drivers/media/platform/vimc/vimc-sensor.c  | 279 ++++++++++++
 drivers/media/platform/vimc/vimc-sensor.h  |  28 ++
 10 files changed, 1710 insertions(+)
 create mode 100644 drivers/media/platform/vimc/Kconfig
 create mode 100644 drivers/media/platform/vimc/Makefile
 create mode 100644 drivers/media/platform/vimc/vimc-capture.c
 create mode 100644 drivers/media/platform/vimc/vimc-capture.h
 create mode 100644 drivers/media/platform/vimc/vimc-core.c
 create mode 100644 drivers/media/platform/vimc/vimc-core.h
 create mode 100644 drivers/media/platform/vimc/vimc-sensor.c
 create mode 100644 drivers/media/platform/vimc/vimc-sensor.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 53f6f12..6dab7e6 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -466,6 +466,8 @@ menuconfig V4L_TEST_DRIVERS
 
 if V4L_TEST_DRIVERS
 
+source "drivers/media/platform/vimc/Kconfig"
+
 source "drivers/media/platform/vivid/Kconfig"
 
 config VIDEO_VIM2M
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 8959f6e..4af4cce 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_VIDEO_PXA27x)	+= pxa_camera.o
 
 obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
 
+obj-$(CONFIG_VIDEO_VIMC)		+= vimc/
 obj-$(CONFIG_VIDEO_VIVID)		+= vivid/
 obj-$(CONFIG_VIDEO_VIM2M)		+= vim2m.o
 
diff --git a/drivers/media/platform/vimc/Kconfig b/drivers/media/platform/vimc/Kconfig
new file mode 100644
index 0000000..dd285fa
--- /dev/null
+++ b/drivers/media/platform/vimc/Kconfig
@@ -0,0 +1,14 @@
+config VIDEO_VIMC
+	tristate "Virtual Media Controller Driver (VIMC)"
+	depends on VIDEO_DEV && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	select VIDEOBUF2_VMALLOC
+	default n
+	---help---
+	  Skeleton driver for Virtual Media Controller
+
+	  This drivers can be compared to the Vivid driver for emulating
+	  a media node that exposes a complex media topology. The topology
+	  is hard coded for now but is meant to be highly configurable in
+	  the future.
+
+	  When in doubt, say N.
diff --git a/drivers/media/platform/vimc/Makefile b/drivers/media/platform/vimc/Makefile
new file mode 100644
index 0000000..c45195e
--- /dev/null
+++ b/drivers/media/platform/vimc/Makefile
@@ -0,0 +1,3 @@
+vimc-objs := vimc-core.o vimc-capture.o vimc-sensor.o
+
+obj-$(CONFIG_VIDEO_VIMC) += vimc.o
diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
new file mode 100644
index 0000000..8f77fc8
--- /dev/null
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -0,0 +1,536 @@
+/*
+ * vimc-capture.c Virtual Media Controller Driver
+ *
+ * Copyright (C) 2017 Helen Koike F. <helen.fornazier@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-vmalloc.h>
+
+#include "vimc-capture.h"
+
+struct vimc_cap_device {
+	struct vimc_ent_device ved;
+	struct video_device vd;
+	struct device *dev;
+	struct v4l2_pix_format format;
+	struct vb2_queue queue;
+	struct list_head buf_list;
+	/*
+	 * NOTE: in a real driver, a spin lock must be used to access the
+	 * queue because the frames are generated from a hardware interruption
+	 * and the isr is not allowed to sleep.
+	 * Even if it is not necessary a spinlock in the vimc driver, we
+	 * use it here as a code reference
+	 */
+	spinlock_t qlock;
+	struct mutex lock;
+	u32 sequence;
+	struct media_pipeline pipe;
+};
+
+struct vimc_cap_buffer {
+	/*
+	 * struct vb2_v4l2_buffer must be the first element
+	 * the videobuf2 framework will allocate this struct based on
+	 * buf_struct_size and use the first sizeof(struct vb2_buffer) bytes of
+	 * memory as a vb2_buffer
+	 */
+	struct vb2_v4l2_buffer vb2;
+	struct list_head list;
+};
+
+static int vimc_cap_querycap(struct file *file, void *priv,
+			     struct v4l2_capability *cap)
+{
+	struct vimc_cap_device *vcap = video_drvdata(file);
+
+	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
+	strlcpy(cap->card, KBUILD_MODNAME, sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info),
+		 "platform:%s", vcap->vd.v4l2_dev->name);
+
+	return 0;
+}
+
+static int vimc_cap_enum_input(struct file *file, void *priv,
+			       struct v4l2_input *i)
+{
+	/* We only have one input */
+	if (i->index > 0)
+		return -EINVAL;
+
+	i->type = V4L2_INPUT_TYPE_CAMERA;
+	strlcpy(i->name, "VIMC capture", sizeof(i->name));
+
+	return 0;
+}
+
+static int vimc_cap_g_input(struct file *file, void *priv, unsigned int *i)
+{
+	/* We only have one input */
+	*i = 0;
+	return 0;
+}
+
+static int vimc_cap_s_input(struct file *file, void *priv, unsigned int i)
+{
+	/* We only have one input */
+	return i ? -EINVAL : 0;
+}
+
+static int vimc_cap_fmt_vid_cap(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct vimc_cap_device *vcap = video_drvdata(file);
+
+	f->fmt.pix = vcap->format;
+
+	return 0;
+}
+
+static int vimc_cap_enum_fmt_vid_cap(struct file *file, void *priv,
+				     struct v4l2_fmtdesc *f)
+{
+	struct vimc_cap_device *vcap = video_drvdata(file);
+
+	if (f->index > 0)
+		return -EINVAL;
+
+	/* We only support one format for now */
+	f->pixelformat = vcap->format.pixelformat;
+
+	return 0;
+}
+
+static const struct v4l2_file_operations vimc_cap_fops = {
+	.owner		= THIS_MODULE,
+	.open		= v4l2_fh_open,
+	.release	= vb2_fop_release,
+	.read           = vb2_fop_read,
+	.poll		= vb2_fop_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap           = vb2_fop_mmap,
+};
+
+static const struct v4l2_ioctl_ops vimc_cap_ioctl_ops = {
+	.vidioc_querycap = vimc_cap_querycap,
+
+	.vidioc_enum_input = vimc_cap_enum_input,
+	.vidioc_g_input = vimc_cap_g_input,
+	.vidioc_s_input = vimc_cap_s_input,
+
+	.vidioc_g_fmt_vid_cap = vimc_cap_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap = vimc_cap_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap = vimc_cap_fmt_vid_cap,
+	.vidioc_enum_fmt_vid_cap = vimc_cap_enum_fmt_vid_cap,
+
+	.vidioc_reqbufs = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs = vb2_ioctl_create_bufs,
+	.vidioc_querybuf = vb2_ioctl_querybuf,
+	.vidioc_qbuf = vb2_ioctl_qbuf,
+	.vidioc_dqbuf = vb2_ioctl_dqbuf,
+	.vidioc_expbuf = vb2_ioctl_expbuf,
+	.vidioc_streamon = vb2_ioctl_streamon,
+	.vidioc_streamoff = vb2_ioctl_streamoff,
+};
+
+static void vimc_cap_return_all_buffers(struct vimc_cap_device *vcap,
+					enum vb2_buffer_state state)
+{
+	struct vimc_cap_buffer *vbuf, *node;
+
+	spin_lock(&vcap->qlock);
+
+	list_for_each_entry_safe(vbuf, node, &vcap->buf_list, list) {
+		list_del(&vbuf->list);
+		vb2_buffer_done(&vbuf->vb2.vb2_buf, state);
+	}
+
+	spin_unlock(&vcap->qlock);
+}
+
+static int vimc_cap_pipeline_s_stream(struct vimc_cap_device *vcap, int enable)
+{
+	struct v4l2_subdev *sd;
+	struct media_pad *pad;
+	int ret;
+
+	/* Start the stream in the subdevice direct connected */
+	pad = media_entity_remote_pad(&vcap->vd.entity.pads[0]);
+
+	/*
+	 * if it is a raw node from vimc-core, there is nothing to activate
+	 * TODO: remove this when there are no more raw nodes in the
+	 * core and return error instead
+	 */
+	if (pad->entity->obj_type == MEDIA_ENTITY_TYPE_BASE)
+		return 0;
+
+	sd = media_entity_to_v4l2_subdev(pad->entity);
+	ret = v4l2_subdev_call(sd, video, s_stream, enable);
+	if (ret && ret != -ENOIOCTLCMD)
+		return ret;
+
+	return 0;
+}
+
+static int vimc_cap_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct vimc_cap_device *vcap = vb2_get_drv_priv(vq);
+	struct media_entity *entity = &vcap->vd.entity;
+	int ret;
+
+	vcap->sequence = 0;
+
+	/* Start the media pipeline */
+	ret = media_pipeline_start(entity, &vcap->pipe);
+	if (ret) {
+		vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_QUEUED);
+		return ret;
+	}
+
+	/* Enable streaming from the pipe */
+	ret = vimc_cap_pipeline_s_stream(vcap, 1);
+	if (ret) {
+		media_pipeline_stop(entity);
+		vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_QUEUED);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Stop the stream engine. Any remaining buffers in the stream queue are
+ * dequeued and passed on to the vb2 framework marked as STATE_ERROR.
+ */
+static void vimc_cap_stop_streaming(struct vb2_queue *vq)
+{
+	struct vimc_cap_device *vcap = vb2_get_drv_priv(vq);
+
+	/* Disable streaming from the pipe */
+	vimc_cap_pipeline_s_stream(vcap, 0);
+
+	/* Stop the media pipeline */
+	media_pipeline_stop(&vcap->vd.entity);
+
+	/* Release all active buffers */
+	vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_ERROR);
+}
+
+static void vimc_cap_buf_queue(struct vb2_buffer *vb2_buf)
+{
+	struct vimc_cap_device *vcap = vb2_get_drv_priv(vb2_buf->vb2_queue);
+	struct vimc_cap_buffer *buf = container_of(vb2_buf,
+						   struct vimc_cap_buffer,
+						   vb2.vb2_buf);
+
+	spin_lock(&vcap->qlock);
+	list_add_tail(&buf->list, &vcap->buf_list);
+	spin_unlock(&vcap->qlock);
+}
+
+static int vimc_cap_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
+				unsigned int *nplanes, unsigned int sizes[],
+				struct device *alloc_devs[])
+{
+	struct vimc_cap_device *vcap = vb2_get_drv_priv(vq);
+
+	if (*nplanes)
+		return sizes[0] < vcap->format.sizeimage ? -EINVAL : 0;
+	/* We don't support multiplanes for now */
+	*nplanes = 1;
+	sizes[0] = vcap->format.sizeimage;
+
+	return 0;
+}
+
+static int vimc_cap_buffer_prepare(struct vb2_buffer *vb)
+{
+	struct vimc_cap_device *vcap = vb2_get_drv_priv(vb->vb2_queue);
+	unsigned long size = vcap->format.sizeimage;
+
+	if (vb2_plane_size(vb, 0) < size) {
+		dev_err(vcap->dev, "buffer too small (%lu < %lu)\n",
+			vb2_plane_size(vb, 0), size);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static const struct vb2_ops vimc_cap_qops = {
+	.start_streaming	= vimc_cap_start_streaming,
+	.stop_streaming		= vimc_cap_stop_streaming,
+	.buf_queue		= vimc_cap_buf_queue,
+	.queue_setup		= vimc_cap_queue_setup,
+	.buf_prepare		= vimc_cap_buffer_prepare,
+	/*
+	 * Since q->lock is set we can use the standard
+	 * vb2_ops_wait_prepare/finish helper functions.
+	 */
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
+};
+
+/*
+ * NOTE: this function is a copy of v4l2_subdev_link_validate_get_format
+ * maybe the v4l2 function should be public
+ */
+static int vimc_cap_v4l2_subdev_link_validate_get_format(struct media_pad *pad,
+						struct v4l2_subdev_format *fmt)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(pad->entity);
+
+	fmt->which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	fmt->pad = pad->index;
+
+	return v4l2_subdev_call(sd, pad, get_fmt, NULL, fmt);
+}
+
+static int vimc_cap_link_validate(struct media_link *link)
+{
+	struct v4l2_subdev_format source_fmt;
+	const struct vimc_pix_map *vpix;
+	struct vimc_cap_device *vcap = container_of(link->sink->entity,
+						    struct vimc_cap_device,
+						    vd.entity);
+	struct v4l2_pix_format *sink_fmt = &vcap->format;
+	int ret;
+
+	/*
+	 * if it is a raw node from vimc-core, ignore the link for now
+	 * TODO: remove this when there are no more raw nodes in the
+	 * core and return error instead
+	 */
+	if (link->source->entity->obj_type == MEDIA_ENTITY_TYPE_BASE)
+		return 0;
+
+	/* Get the the format of the subdev */
+	ret = vimc_cap_v4l2_subdev_link_validate_get_format(link->source,
+							    &source_fmt);
+	if (ret)
+		return ret;
+
+	dev_dbg(vcap->dev,
+		"cap: %s: link validate formats src:%dx%d %d sink:%dx%d %d\n",
+		vcap->vd.name,
+		source_fmt.format.width, source_fmt.format.height,
+		source_fmt.format.code,
+		sink_fmt->width, sink_fmt->height,
+		sink_fmt->pixelformat);
+
+	/* The width, height and code must match. */
+	vpix = vimc_pix_map_by_pixelformat(sink_fmt->pixelformat);
+	if (source_fmt.format.width != sink_fmt->width
+	    || source_fmt.format.height != sink_fmt->height
+	    || vpix->code != source_fmt.format.code)
+		return -EINVAL;
+
+	/*
+	 * The field order must match, or the sink field order must be NONE
+	 * to support interlaced hardware connected to bridges that support
+	 * progressive formats only.
+	 */
+	if (source_fmt.format.field != sink_fmt->field &&
+	    sink_fmt->field != V4L2_FIELD_NONE)
+		return -EINVAL;
+
+	return 0;
+}
+
+static const struct media_entity_operations vimc_cap_mops = {
+	.link_validate		= vimc_cap_link_validate,
+};
+
+static void vimc_cap_destroy(struct vimc_ent_device *ved)
+{
+	struct vimc_cap_device *vcap = container_of(ved, struct vimc_cap_device,
+						    ved);
+
+	vb2_queue_release(&vcap->queue);
+	media_entity_cleanup(ved->ent);
+	video_unregister_device(&vcap->vd);
+	vimc_pads_cleanup(vcap->ved.pads);
+	kfree(vcap);
+}
+
+static void vimc_cap_process_frame(struct vimc_ent_device *ved,
+				   struct media_pad *sink, const void *frame)
+{
+	struct vimc_cap_device *vcap = container_of(ved, struct vimc_cap_device,
+						    ved);
+	struct vimc_cap_buffer *vimc_buf;
+	void *vbuf;
+
+	/* If the stream in this node is not active, just return */
+	mutex_lock(&vcap->lock);
+	if (!vb2_is_busy(&vcap->queue)) {
+		mutex_unlock(&vcap->lock);
+		return;
+	}
+	mutex_unlock(&vcap->lock);
+
+	spin_lock(&vcap->qlock);
+
+	/* Get the first entry of the list */
+	vimc_buf = list_first_entry_or_null(&vcap->buf_list,
+					    typeof(*vimc_buf), list);
+	if (!vimc_buf) {
+		spin_unlock(&vcap->qlock);
+		return;
+	}
+
+	/* Remove this entry from the list */
+	list_del(&vimc_buf->list);
+
+	spin_unlock(&vcap->qlock);
+
+	/* Fill the buffer */
+	vimc_buf->vb2.vb2_buf.timestamp = ktime_get_ns();
+	vimc_buf->vb2.sequence = vcap->sequence++;
+	vimc_buf->vb2.field = vcap->format.field;
+
+	vbuf = vb2_plane_vaddr(&vimc_buf->vb2.vb2_buf, 0);
+
+	memcpy(vbuf, frame, vcap->format.sizeimage);
+
+	/* Set it as ready */
+	vb2_set_plane_payload(&vimc_buf->vb2.vb2_buf, 0,
+			      vcap->format.sizeimage);
+	vb2_buffer_done(&vimc_buf->vb2.vb2_buf, VB2_BUF_STATE_DONE);
+}
+
+struct vimc_ent_device *vimc_cap_create(struct v4l2_device *v4l2_dev,
+					const char *const name,
+					u16 num_pads,
+					const unsigned long *pads_flag)
+{
+	const struct vimc_pix_map *vpix;
+	struct vimc_cap_device *vcap;
+	struct video_device *vd;
+	struct vb2_queue *q;
+	int ret;
+
+	/*
+	 * Check entity configuration params
+	 * NOTE: we only support a single sink pad
+	 */
+	if (!name || num_pads != 1 || !pads_flag ||
+	    !(pads_flag[0] & MEDIA_PAD_FL_SINK))
+		return ERR_PTR(-EINVAL);
+
+	/* Allocate the vimc_cap_device struct */
+	vcap = kzalloc(sizeof(*vcap), GFP_KERNEL);
+	if (!vcap)
+		return ERR_PTR(-ENOMEM);
+
+	/* Link the vimc_cap_device struct with dev parent */
+	vcap->dev = v4l2_dev->dev;
+
+	/* Allocate the pads */
+	vcap->ved.pads = vimc_pads_init(num_pads, pads_flag);
+	if (IS_ERR(vcap->ved.pads)) {
+		ret = PTR_ERR(vcap->ved.pads);
+		goto err_free_vcap;
+	}
+
+	/* Initialize the media entity */
+	vcap->vd.entity.name = name;
+	vcap->vd.entity.function = MEDIA_ENT_F_IO_V4L;
+	ret = media_entity_pads_init(&vcap->vd.entity,
+				     num_pads, vcap->ved.pads);
+	if (ret)
+		goto err_clean_pads;
+
+	/* Initialize the lock */
+	mutex_init(&vcap->lock);
+
+	/* Initialize the vb2 queue */
+	q = &vcap->queue;
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_DMABUF;
+	q->drv_priv = vcap;
+	q->buf_struct_size = sizeof(struct vimc_cap_buffer);
+	q->ops = &vimc_cap_qops;
+	q->mem_ops = &vb2_vmalloc_memops;
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->min_buffers_needed = 2;
+	q->lock = &vcap->lock;
+
+	ret = vb2_queue_init(q);
+	if (ret) {
+		dev_err(vcap->dev,
+			"vb2 queue init failed (err=%d)\n", ret);
+		goto err_clean_m_ent;
+	}
+
+	/* Initialize buffer list and its lock */
+	INIT_LIST_HEAD(&vcap->buf_list);
+	spin_lock_init(&vcap->qlock);
+
+	/* Set the frame format (this is hardcoded for now) */
+	vcap->format.width = 640;
+	vcap->format.height = 480;
+	vcap->format.pixelformat = V4L2_PIX_FMT_RGB24;
+	vcap->format.field = V4L2_FIELD_NONE;
+	vcap->format.colorspace = V4L2_COLORSPACE_SRGB;
+
+	vpix = vimc_pix_map_by_pixelformat(vcap->format.pixelformat);
+
+	vcap->format.bytesperline = vcap->format.width * vpix->bpp;
+	vcap->format.sizeimage = vcap->format.bytesperline *
+				 vcap->format.height;
+
+	/* Fill the vimc_ent_device struct */
+	vcap->ved.destroy = vimc_cap_destroy;
+	vcap->ved.ent = &vcap->vd.entity;
+	vcap->ved.process_frame = vimc_cap_process_frame;
+
+	/* Initialize the video_device struct */
+	vd = &vcap->vd;
+	vd->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	vd->entity.ops = &vimc_cap_mops;
+	vd->release = video_device_release_empty;
+	vd->fops = &vimc_cap_fops;
+	vd->ioctl_ops = &vimc_cap_ioctl_ops;
+	vd->lock = &vcap->lock;
+	vd->queue = q;
+	vd->v4l2_dev = v4l2_dev;
+	vd->vfl_dir = VFL_DIR_RX;
+	strlcpy(vd->name, name, sizeof(vd->name));
+	video_set_drvdata(vd, &vcap->ved);
+
+	/* Register the video_device with the v4l2 and the media framework */
+	ret = video_register_device(vd, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		dev_err(vcap->dev,
+			"video register failed (err=%d)\n", ret);
+		goto err_release_queue;
+	}
+
+	return &vcap->ved;
+
+err_release_queue:
+	vb2_queue_release(q);
+err_clean_m_ent:
+	media_entity_cleanup(&vcap->vd.entity);
+err_clean_pads:
+	vimc_pads_cleanup(vcap->ved.pads);
+err_free_vcap:
+	kfree(vcap);
+
+	return ERR_PTR(ret);
+}
diff --git a/drivers/media/platform/vimc/vimc-capture.h b/drivers/media/platform/vimc/vimc-capture.h
new file mode 100644
index 0000000..c7e633d
--- /dev/null
+++ b/drivers/media/platform/vimc/vimc-capture.h
@@ -0,0 +1,28 @@
+/*
+ * vimc-capture.h Virtual Media Controller Driver
+ *
+ * Copyright (C) 2017 Helen Koike F. <helen.fornazier@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _VIMC_CAPTURE_H_
+#define _VIMC_CAPTURE_H_
+
+#include "vimc-core.h"
+
+struct vimc_ent_device *vimc_cap_create(struct v4l2_device *v4l2_dev,
+					const char *const name,
+					u16 num_pads,
+					const unsigned long *pads_flag);
+
+#endif
diff --git a/drivers/media/platform/vimc/vimc-core.c b/drivers/media/platform/vimc/vimc-core.c
new file mode 100644
index 0000000..2dc2ca8
--- /dev/null
+++ b/drivers/media/platform/vimc/vimc-core.c
@@ -0,0 +1,696 @@
+/*
+ * vimc-core.c Virtual Media Controller Driver
+ *
+ * Copyright (C) 2017 Helen Koike F. <helen.fornazier@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <media/media-device.h>
+#include <media/v4l2-device.h>
+
+#include "vimc-capture.h"
+#include "vimc-core.h"
+#include "vimc-sensor.h"
+
+#define VIMC_PDEV_NAME "vimc"
+#define VIMC_MDEV_MODEL_NAME "VIMC MDEV"
+
+#define VIMC_ENT_LINK(src, srcpad, sink, sinkpad, link_flags) {	\
+	.src_ent = src,						\
+	.src_pad = srcpad,					\
+	.sink_ent = sink,					\
+	.sink_pad = sinkpad,					\
+	.flags = link_flags,					\
+}
+
+struct vimc_device {
+	/*
+	 * The pipeline configuration
+	 * (filled before calling vimc_device_register)
+	 */
+	const struct vimc_pipeline_config *pipe_cfg;
+
+	/* The Associated media_device parent */
+	struct media_device mdev;
+
+	/* Internal v4l2 parent device*/
+	struct v4l2_device v4l2_dev;
+
+	/* Internal topology */
+	struct vimc_ent_device **ved;
+};
+
+/**
+ * enum vimc_ent_node - Select the functionality of a node in the topology
+ * @VIMC_ENT_NODE_SENSOR:	A node of type SENSOR simulates a camera sensor
+ *				generating internal images in bayer format and
+ *				propagating those images through the pipeline
+ * @VIMC_ENT_NODE_CAPTURE:	A node of type CAPTURE is a v4l2 video_device
+ *				that exposes the received image from the
+ *				pipeline to the user space
+ * @VIMC_ENT_NODE_INPUT:	A node of type INPUT is a v4l2 video_device that
+ *				receives images from the user space and
+ *				propagates them through the pipeline
+ * @VIMC_ENT_NODE_DEBAYER:	A node type DEBAYER expects to receive a frame
+ *				in bayer format converts it to RGB
+ * @VIMC_ENT_NODE_SCALER:	A node of type SCALER scales the received image
+ *				by a given multiplier
+ *
+ * This enum is used in the entity configuration struct to allow the definition
+ * of a custom topology specifying the role of each node on it.
+ */
+enum vimc_ent_node {
+	VIMC_ENT_NODE_SENSOR,
+	VIMC_ENT_NODE_CAPTURE,
+	VIMC_ENT_NODE_INPUT,
+	VIMC_ENT_NODE_DEBAYER,
+	VIMC_ENT_NODE_SCALER,
+};
+
+/* Structure which describes individual configuration for each entity */
+struct vimc_ent_config {
+	const char *name;
+	size_t pads_qty;
+	const unsigned long *pads_flag;
+	enum vimc_ent_node node;
+};
+
+/* Structure which describes links between entities */
+struct vimc_ent_link {
+	unsigned int src_ent;
+	u16 src_pad;
+	unsigned int sink_ent;
+	u16 sink_pad;
+	u32 flags;
+};
+
+/* Structure which describes the whole topology */
+struct vimc_pipeline_config {
+	const struct vimc_ent_config *ents;
+	size_t num_ents;
+	const struct vimc_ent_link *links;
+	size_t num_links;
+};
+
+/* --------------------------------------------------------------------------
+ * Topology Configuration
+ */
+
+static const struct vimc_ent_config ent_config[] = {
+	{
+		.name = "Sensor A",
+		.pads_qty = 1,
+		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SOURCE},
+		.node = VIMC_ENT_NODE_SENSOR,
+	},
+	{
+		.name = "Sensor B",
+		.pads_qty = 1,
+		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SOURCE},
+		.node = VIMC_ENT_NODE_SENSOR,
+	},
+	{
+		.name = "Debayer A",
+		.pads_qty = 2,
+		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK,
+						     MEDIA_PAD_FL_SOURCE},
+		.node = VIMC_ENT_NODE_DEBAYER,
+	},
+	{
+		.name = "Debayer B",
+		.pads_qty = 2,
+		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK,
+						     MEDIA_PAD_FL_SOURCE},
+		.node = VIMC_ENT_NODE_DEBAYER,
+	},
+	{
+		.name = "Raw Capture 0",
+		.pads_qty = 1,
+		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK},
+		.node = VIMC_ENT_NODE_CAPTURE,
+	},
+	{
+		.name = "Raw Capture 1",
+		.pads_qty = 1,
+		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK},
+		.node = VIMC_ENT_NODE_CAPTURE,
+	},
+	{
+		.name = "RGB/YUV Input",
+		.pads_qty = 1,
+		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SOURCE},
+		.node = VIMC_ENT_NODE_INPUT,
+	},
+	{
+		.name = "Scaler",
+		.pads_qty = 2,
+		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK,
+						     MEDIA_PAD_FL_SOURCE},
+		.node = VIMC_ENT_NODE_SCALER,
+	},
+	{
+		.name = "RGB/YUV Capture",
+		.pads_qty = 1,
+		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK},
+		.node = VIMC_ENT_NODE_CAPTURE,
+	},
+};
+
+static const struct vimc_ent_link ent_links[] = {
+	/* Link: Sensor A (Pad 0)->(Pad 0) Debayer A */
+	VIMC_ENT_LINK(0, 0, 2, 0, MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE),
+	/* Link: Sensor A (Pad 0)->(Pad 0) Raw Capture 0 */
+	VIMC_ENT_LINK(0, 0, 4, 0, MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE),
+	/* Link: Sensor B (Pad 0)->(Pad 0) Debayer B */
+	VIMC_ENT_LINK(1, 0, 3, 0, MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE),
+	/* Link: Sensor B (Pad 0)->(Pad 0) Raw Capture 1 */
+	VIMC_ENT_LINK(1, 0, 5, 0, MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE),
+	/* Link: Debayer A (Pad 1)->(Pad 0) Scaler */
+	VIMC_ENT_LINK(2, 1, 7, 0, MEDIA_LNK_FL_ENABLED),
+	/* Link: Debayer B (Pad 1)->(Pad 0) Scaler */
+	VIMC_ENT_LINK(3, 1, 7, 0, 0),
+	/* Link: RGB/YUV Input (Pad 0)->(Pad 0) Scaler */
+	VIMC_ENT_LINK(6, 0, 7, 0, 0),
+	/* Link: Scaler (Pad 1)->(Pad 0) RGB/YUV Capture */
+	VIMC_ENT_LINK(7, 1, 8, 0, MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE),
+};
+
+static const struct vimc_pipeline_config pipe_cfg = {
+	.ents		= ent_config,
+	.num_ents	= ARRAY_SIZE(ent_config),
+	.links		= ent_links,
+	.num_links	= ARRAY_SIZE(ent_links)
+};
+
+/* -------------------------------------------------------------------------- */
+
+static const struct vimc_pix_map vimc_pix_map_list[] = {
+	/* TODO: add all missing formats */
+
+	/* RGB formats */
+	{
+		.code = MEDIA_BUS_FMT_BGR888_1X24,
+		.pixelformat = V4L2_PIX_FMT_BGR24,
+		.bpp = 3,
+	},
+	{
+		.code = MEDIA_BUS_FMT_RGB888_1X24,
+		.pixelformat = V4L2_PIX_FMT_RGB24,
+		.bpp = 3,
+	},
+	{
+		.code = MEDIA_BUS_FMT_ARGB8888_1X32,
+		.pixelformat = V4L2_PIX_FMT_ARGB32,
+		.bpp = 4,
+	},
+
+	/* Bayer formats */
+	{
+		.code = MEDIA_BUS_FMT_SBGGR8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SBGGR8,
+		.bpp = 1,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SGBRG8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SGBRG8,
+		.bpp = 1,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SGRBG8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SGRBG8,
+		.bpp = 1,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SRGGB8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SRGGB8,
+		.bpp = 1,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SBGGR10_1X10,
+		.pixelformat = V4L2_PIX_FMT_SBGGR10,
+		.bpp = 2,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SGBRG10_1X10,
+		.pixelformat = V4L2_PIX_FMT_SGBRG10,
+		.bpp = 2,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SGRBG10_1X10,
+		.pixelformat = V4L2_PIX_FMT_SGRBG10,
+		.bpp = 2,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SRGGB10_1X10,
+		.pixelformat = V4L2_PIX_FMT_SRGGB10,
+		.bpp = 2,
+	},
+
+	/* 10bit raw bayer a-law compressed to 8 bits */
+	{
+		.code = MEDIA_BUS_FMT_SBGGR10_ALAW8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SBGGR10ALAW8,
+		.bpp = 1,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SGBRG10_ALAW8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SGBRG10ALAW8,
+		.bpp = 1,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SGRBG10ALAW8,
+		.bpp = 1,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SRGGB10_ALAW8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SRGGB10ALAW8,
+		.bpp = 1,
+	},
+
+	/* 10bit raw bayer DPCM compressed to 8 bits */
+	{
+		.code = MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SBGGR10DPCM8,
+		.bpp = 1,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SGBRG10DPCM8,
+		.bpp = 1,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SGRBG10DPCM8,
+		.bpp = 1,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SRGGB10DPCM8,
+		.bpp = 1,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SBGGR12_1X12,
+		.pixelformat = V4L2_PIX_FMT_SBGGR12,
+		.bpp = 2,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SGBRG12_1X12,
+		.pixelformat = V4L2_PIX_FMT_SGBRG12,
+		.bpp = 2,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SGRBG12_1X12,
+		.pixelformat = V4L2_PIX_FMT_SGRBG12,
+		.bpp = 2,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SRGGB12_1X12,
+		.pixelformat = V4L2_PIX_FMT_SRGGB12,
+		.bpp = 2,
+	},
+};
+
+const struct vimc_pix_map *vimc_pix_map_by_code(u32 code)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(vimc_pix_map_list); i++) {
+		if (vimc_pix_map_list[i].code == code)
+			return &vimc_pix_map_list[i];
+	}
+	return NULL;
+}
+
+const struct vimc_pix_map *vimc_pix_map_by_pixelformat(u32 pixelformat)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(vimc_pix_map_list); i++) {
+		if (vimc_pix_map_list[i].pixelformat == pixelformat)
+			return &vimc_pix_map_list[i];
+	}
+	return NULL;
+}
+
+int vimc_propagate_frame(struct device *dev,
+			 struct media_pad *src, const void *frame)
+{
+	struct media_link *link;
+
+	if (!(src->flags & MEDIA_PAD_FL_SOURCE))
+		return -EINVAL;
+
+	/* Send this frame to all sink pads that are direct linked */
+	list_for_each_entry(link, &src->entity->links, list) {
+		if (link->source == src &&
+		    (link->flags & MEDIA_LNK_FL_ENABLED)) {
+			struct vimc_ent_device *ved = NULL;
+			struct media_entity *entity = link->sink->entity;
+
+			if (is_media_entity_v4l2_subdev(entity)) {
+				struct v4l2_subdev *sd =
+					container_of(entity, struct v4l2_subdev,
+						     entity);
+				ved = v4l2_get_subdevdata(sd);
+			} else if (is_media_entity_v4l2_video_device(entity)) {
+				struct video_device *vd =
+					container_of(entity,
+						     struct video_device,
+						     entity);
+				ved = video_get_drvdata(vd);
+			}
+			if (ved && ved->process_frame)
+				ved->process_frame(ved, link->sink, frame);
+		}
+	}
+
+	return 0;
+}
+
+static void vimc_device_unregister(struct vimc_device *vimc)
+{
+	unsigned int i;
+
+	media_device_unregister(&vimc->mdev);
+	/* Cleanup (only initialized) entities */
+	for (i = 0; i < vimc->pipe_cfg->num_ents; i++) {
+		if (vimc->ved[i] && vimc->ved[i]->destroy)
+			vimc->ved[i]->destroy(vimc->ved[i]);
+
+		vimc->ved[i] = NULL;
+	}
+	v4l2_device_unregister(&vimc->v4l2_dev);
+	media_device_cleanup(&vimc->mdev);
+}
+
+/* Helper function to allocate and initialize pads */
+struct media_pad *vimc_pads_init(u16 num_pads, const unsigned long *pads_flag)
+{
+	struct media_pad *pads;
+	unsigned int i;
+
+	/* Allocate memory for the pads */
+	pads = kcalloc(num_pads, sizeof(*pads), GFP_KERNEL);
+	if (!pads)
+		return ERR_PTR(-ENOMEM);
+
+	/* Initialize the pads */
+	for (i = 0; i < num_pads; i++) {
+		pads[i].index = i;
+		pads[i].flags = pads_flag[i];
+	}
+
+	return pads;
+}
+
+/*
+ * TODO: remove this function when all the
+ * entities specific code are implemented
+ */
+static void vimc_raw_destroy(struct vimc_ent_device *ved)
+{
+	media_device_unregister_entity(ved->ent);
+
+	media_entity_cleanup(ved->ent);
+
+	vimc_pads_cleanup(ved->pads);
+
+	kfree(ved->ent);
+
+	kfree(ved);
+}
+
+/*
+ * TODO: remove this function when all the
+ * entities specific code are implemented
+ */
+static struct vimc_ent_device *vimc_raw_create(struct v4l2_device *v4l2_dev,
+					       const char *const name,
+					       u16 num_pads,
+					       const unsigned long *pads_flag)
+{
+	struct vimc_ent_device *ved;
+	int ret;
+
+	/* Allocate the main ved struct */
+	ved = kzalloc(sizeof(*ved), GFP_KERNEL);
+	if (!ved)
+		return ERR_PTR(-ENOMEM);
+
+	/* Allocate the media entity */
+	ved->ent = kzalloc(sizeof(*ved->ent), GFP_KERNEL);
+	if (!ved->ent) {
+		ret = -ENOMEM;
+		goto err_free_ved;
+	}
+
+	/* Allocate the pads */
+	ved->pads = vimc_pads_init(num_pads, pads_flag);
+	if (IS_ERR(ved->pads)) {
+		ret = PTR_ERR(ved->pads);
+		goto err_free_ent;
+	}
+
+	/* Initialize the media entity */
+	ved->ent->name = name;
+	ved->ent->function = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
+	ret = media_entity_pads_init(ved->ent, num_pads, ved->pads);
+	if (ret)
+		goto err_cleanup_pads;
+
+	/* Register the media entity */
+	ret = media_device_register_entity(v4l2_dev->mdev, ved->ent);
+	if (ret)
+		goto err_cleanup_entity;
+
+	/* Fill out the destroy function and return */
+	ved->destroy = vimc_raw_destroy;
+	return ved;
+
+err_cleanup_entity:
+	media_entity_cleanup(ved->ent);
+err_cleanup_pads:
+	vimc_pads_cleanup(ved->pads);
+err_free_ent:
+	kfree(ved->ent);
+err_free_ved:
+	kfree(ved);
+
+	return ERR_PTR(ret);
+}
+
+static int vimc_device_register(struct vimc_device *vimc)
+{
+	unsigned int i;
+	int ret;
+
+	/* Allocate memory for the vimc_ent_devices pointers */
+	vimc->ved = devm_kcalloc(vimc->mdev.dev, vimc->pipe_cfg->num_ents,
+				 sizeof(*vimc->ved), GFP_KERNEL);
+	if (!vimc->ved)
+		return -ENOMEM;
+
+	/* Link the media device within the v4l2_device */
+	vimc->v4l2_dev.mdev = &vimc->mdev;
+
+	/* Register the v4l2 struct */
+	ret = v4l2_device_register(vimc->mdev.dev, &vimc->v4l2_dev);
+	if (ret) {
+		dev_err(vimc->mdev.dev,
+			"v4l2 device register failed (err=%d)\n", ret);
+		return ret;
+	}
+
+	/* Initialize entities */
+	for (i = 0; i < vimc->pipe_cfg->num_ents; i++) {
+		struct vimc_ent_device *(*create_func)(struct v4l2_device *,
+						       const char *const,
+						       u16,
+						       const unsigned long *);
+
+		/* Register the specific node */
+		switch (vimc->pipe_cfg->ents[i].node) {
+		case VIMC_ENT_NODE_SENSOR:
+			create_func = vimc_sen_create;
+			break;
+
+		case VIMC_ENT_NODE_CAPTURE:
+			create_func = vimc_cap_create;
+			break;
+
+		/* TODO: Instantiate the specific topology node */
+		case VIMC_ENT_NODE_INPUT:
+		case VIMC_ENT_NODE_DEBAYER:
+		case VIMC_ENT_NODE_SCALER:
+		default:
+			/*
+			 * TODO: remove this when all the entities specific
+			 * code are implemented
+			 */
+			create_func = vimc_raw_create;
+			break;
+		}
+
+		vimc->ved[i] = create_func(&vimc->v4l2_dev,
+					   vimc->pipe_cfg->ents[i].name,
+					   vimc->pipe_cfg->ents[i].pads_qty,
+					   vimc->pipe_cfg->ents[i].pads_flag);
+		if (IS_ERR(vimc->ved[i])) {
+			ret = PTR_ERR(vimc->ved[i]);
+			vimc->ved[i] = NULL;
+			goto err;
+		}
+	}
+
+	/* Initialize the links between entities */
+	for (i = 0; i < vimc->pipe_cfg->num_links; i++) {
+		const struct vimc_ent_link *link = &vimc->pipe_cfg->links[i];
+
+		ret = media_create_pad_link(vimc->ved[link->src_ent]->ent,
+					    link->src_pad,
+					    vimc->ved[link->sink_ent]->ent,
+					    link->sink_pad,
+					    link->flags);
+		if (ret)
+			goto err;
+	}
+
+	/* Register the media device */
+	ret = media_device_register(&vimc->mdev);
+	if (ret) {
+		dev_err(vimc->mdev.dev,
+			"media device register failed (err=%d)\n", ret);
+		return ret;
+	}
+
+	/* Expose all subdev's nodes*/
+	ret = v4l2_device_register_subdev_nodes(&vimc->v4l2_dev);
+	if (ret) {
+		dev_err(vimc->mdev.dev,
+			"vimc subdev nodes registration failed (err=%d)\n",
+			ret);
+		goto err;
+	}
+
+	return 0;
+
+err:
+	/* Destroy the so far created topology */
+	vimc_device_unregister(vimc);
+
+	return ret;
+}
+
+static int vimc_probe(struct platform_device *pdev)
+{
+	struct vimc_device *vimc;
+	int ret;
+
+	/* Prepare the vimc topology structure */
+
+	/* Allocate memory for the vimc structure */
+	vimc = kzalloc(sizeof(*vimc), GFP_KERNEL);
+	if (!vimc)
+		return -ENOMEM;
+
+	/* Set the pipeline configuration struct */
+	vimc->pipe_cfg = &pipe_cfg;
+
+	/* Initialize media device */
+	strlcpy(vimc->mdev.model, VIMC_MDEV_MODEL_NAME,
+		sizeof(vimc->mdev.model));
+	vimc->mdev.dev = &pdev->dev;
+	media_device_init(&vimc->mdev);
+
+	/* Create vimc topology */
+	ret = vimc_device_register(vimc);
+	if (ret) {
+		dev_err(vimc->mdev.dev,
+			"vimc device registration failed (err=%d)\n", ret);
+		kfree(vimc);
+		return ret;
+	}
+
+	/* Link the topology object with the platform device object */
+	platform_set_drvdata(pdev, vimc);
+
+	return 0;
+}
+
+static int vimc_remove(struct platform_device *pdev)
+{
+	struct vimc_device *vimc = platform_get_drvdata(pdev);
+
+	/* Destroy all the topology */
+	vimc_device_unregister(vimc);
+	kfree(vimc);
+
+	return 0;
+}
+
+static void vimc_dev_release(struct device *dev)
+{
+}
+
+static struct platform_device vimc_pdev = {
+	.name		= VIMC_PDEV_NAME,
+	.dev.release	= vimc_dev_release,
+};
+
+static struct platform_driver vimc_pdrv = {
+	.probe		= vimc_probe,
+	.remove		= vimc_remove,
+	.driver		= {
+		.name	= VIMC_PDEV_NAME,
+	},
+};
+
+static int __init vimc_init(void)
+{
+	int ret;
+
+	ret = platform_device_register(&vimc_pdev);
+	if (ret) {
+		dev_err(&vimc_pdev.dev,
+			"platform device registration failed (err=%d)\n", ret);
+		return ret;
+	}
+
+	ret = platform_driver_register(&vimc_pdrv);
+	if (ret) {
+		dev_err(&vimc_pdev.dev,
+			"platform driver registration failed (err=%d)\n", ret);
+
+		platform_device_unregister(&vimc_pdev);
+	}
+
+	return ret;
+}
+
+static void __exit vimc_exit(void)
+{
+	platform_driver_unregister(&vimc_pdrv);
+
+	platform_device_unregister(&vimc_pdev);
+}
+
+module_init(vimc_init);
+module_exit(vimc_exit);
+
+MODULE_DESCRIPTION("Virtual Media Controller Driver (VIMC)");
+MODULE_AUTHOR("Helen Fornazier <helen.fornazier@gmail.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/vimc/vimc-core.h b/drivers/media/platform/vimc/vimc-core.h
new file mode 100644
index 0000000..1d368e9
--- /dev/null
+++ b/drivers/media/platform/vimc/vimc-core.h
@@ -0,0 +1,123 @@
+/*
+ * vimc-core.h Virtual Media Controller Driver
+ *
+ * Copyright (C) 2017 Helen Koike F. <helen.fornazier@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _VIMC_CORE_H_
+#define _VIMC_CORE_H_
+
+#include <linux/slab.h>
+#include <media/v4l2-device.h>
+
+/**
+ * struct vimc_pix_map - maps media bus code with v4l2 pixel format
+ *
+ * @code:		media bus format code defined by MEDIA_BUS_FMT_* macros
+ * @bbp:		number of bytes each pixel occupies
+ * @pixelformat:	pixel format devined by V4L2_PIX_FMT_* macros
+ *
+ * Struct which matches the MEDIA_BUS_FMT_* codes with the corresponding
+ * V4L2_PIX_FMT_* fourcc pixelformat and its bytes per pixel (bpp)
+ */
+struct vimc_pix_map {
+	unsigned int code;
+	unsigned int bpp;
+	u32 pixelformat;
+};
+
+/**
+ * struct vimc_ent_device - core struct that represents a node in the topology
+ *
+ * @ent:		the pointer to struct media_entity for the node
+ * @pads:		the list of pads of the node
+ * @destroy:		callback to destroy the node
+ * @process_frame:	callback send a frame to that node
+ * @obj:		the object containing the struct media_entity. It can be
+ *			one of two different types: struct v4l2_subdev
+ *			struct video_device depending of the type of the node.
+ *			The struct vimc_ent_device must be embedded in the obj
+ *			by v4l2_set_subdevdata() or by video_set_drvdata()
+ *
+ * Each node of the topology must create a vimc_ent_device struct. Depending on
+ * the node it will be of an instance of v4l2_subdev or video_device struct
+ * where both contains a struct media_entity.
+ * Those structures should embedded the vimc_ent_device struct through
+ * v4l2_set_subdevdata() and video_set_drvdata() respectivaly, allowing the
+ * vimc_ent_device struct to be retrieved from the corresponding struct
+ * media_entity
+ */
+struct vimc_ent_device {
+	struct media_entity *ent;
+	struct media_pad *pads;
+	void (*destroy)(struct vimc_ent_device *);
+	void (*process_frame)(struct vimc_ent_device *ved,
+			      struct media_pad *sink, const void *frame);
+	union {
+		struct v4l2_subdev sd;
+		struct video_device vd;
+	} obj;
+};
+
+/**
+ * vimc_propagate_frame - propagate a frame through the topology
+ *
+ * @dev:	pointer to struct &device
+ * @src:	the source pad where the frame is being originated
+ * @frame:	the frame to be propagated
+ *
+ * This function will call the process_frame callback from the vimc_ent_device
+ * struct of the nodes directly connected to the @src pad
+ */
+int vimc_propagate_frame(struct device *dev,
+			 struct media_pad *src, const void *frame);
+
+/**
+ * vimc_pads_init - initialize pads
+ *
+ * @num_pads:	number of pads to initialize
+ * @pads_flags:	flags to use in each pad
+ *
+ * Helper functions to allocate/initialize pads
+ */
+struct media_pad *vimc_pads_init(u16 num_pads,
+				 const unsigned long *pads_flag);
+
+/**
+ * vimc_pads_cleanup - free pads
+ *
+ * @pads: pointer to the pads
+ *
+ * Helper function to free the pads initialized with vimc_pads_init
+ */
+static inline void vimc_pads_cleanup(struct media_pad *pads)
+{
+	kfree(pads);
+}
+
+/**
+ * vimc_pix_map_by_code - retrieve the vimc_pix_map struct by media code
+ *
+ * @code:		media bus format code defined by MEDIA_BUS_FMT_* macros
+ */
+const struct vimc_pix_map *vimc_pix_map_by_code(u32 code);
+
+/**
+ * vimc_pix_map_by_pixelformat - retrieve the vimc_pix_map struct by v4l2 pixel format
+ *
+ * @pixelformat:	pixel format devined by V4L2_PIX_FMT_* macros
+ */
+const struct vimc_pix_map *vimc_pix_map_by_pixelformat(u32 pixelformat);
+
+#endif
diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
new file mode 100644
index 0000000..45892d0
--- /dev/null
+++ b/drivers/media/platform/vimc/vimc-sensor.c
@@ -0,0 +1,279 @@
+/*
+ * vimc-sensor.c Virtual Media Controller Driver
+ *
+ * Copyright (C) 2017 Helen Koike F. <helen.fornazier@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/freezer.h>
+#include <linux/kthread.h>
+#include <linux/v4l2-mediabus.h>
+#include <linux/vmalloc.h>
+#include <media/v4l2-subdev.h>
+
+#include "vimc-sensor.h"
+
+struct vimc_sen_device {
+	struct vimc_ent_device ved;
+	struct v4l2_subdev sd;
+	struct v4l2_device *v4l2_dev;
+	struct device *dev;
+	struct task_struct *kthread_sen;
+	u8 *frame;
+	/* The active format */
+	struct v4l2_mbus_framefmt mbus_format;
+	int frame_size;
+};
+
+static int vimc_sen_enum_mbus_code(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_pad_config *cfg,
+				   struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct vimc_sen_device *vsen =
+				container_of(sd, struct vimc_sen_device, sd);
+
+	code->code = vsen->mbus_format.code;
+
+	return 0;
+}
+
+static int vimc_sen_enum_frame_size(struct v4l2_subdev *sd,
+				    struct v4l2_subdev_pad_config *cfg,
+				    struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct vimc_sen_device *vsen =
+				container_of(sd, struct vimc_sen_device, sd);
+
+	/* TODO: Add support to other formats */
+	if (fse->index)
+		return -EINVAL;
+
+	/* TODO: Add support for other codes */
+	if (fse->code != vsen->mbus_format.code)
+		return -EINVAL;
+
+	fse->min_width = vsen->mbus_format.width;
+	fse->max_width = vsen->mbus_format.width;
+	fse->min_height = vsen->mbus_format.height;
+	fse->max_height = vsen->mbus_format.height;
+
+	return 0;
+}
+
+static int vimc_sen_get_fmt(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *format)
+{
+	struct vimc_sen_device *vsen =
+				container_of(sd, struct vimc_sen_device, sd);
+
+	format->format = vsen->mbus_format;
+
+	return 0;
+}
+
+static const struct v4l2_subdev_pad_ops vimc_sen_pad_ops = {
+	.enum_mbus_code		= vimc_sen_enum_mbus_code,
+	.enum_frame_size	= vimc_sen_enum_frame_size,
+	.get_fmt		= vimc_sen_get_fmt,
+	/* TODO: Add support to other formats */
+	.set_fmt		= vimc_sen_get_fmt,
+};
+
+/* media operations */
+static const struct media_entity_operations vimc_sen_mops = {
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+static int vimc_thread_sen(void *data)
+{
+	struct vimc_sen_device *vsen = data;
+	unsigned int i;
+
+	set_freezable();
+	set_current_state(TASK_UNINTERRUPTIBLE);
+
+	for (;;) {
+		try_to_freeze();
+		if (kthread_should_stop())
+			break;
+
+		memset(vsen->frame, 100, vsen->frame_size);
+
+		/* Send the frame to all source pads */
+		for (i = 0; i < vsen->sd.entity.num_pads; i++)
+			vimc_propagate_frame(vsen->dev,
+					     &vsen->sd.entity.pads[i],
+					     vsen->frame);
+
+		/* 60 frames per second */
+		schedule_timeout(HZ/60);
+	}
+
+	return 0;
+}
+
+static int vimc_sen_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct vimc_sen_device *vsen =
+				container_of(sd, struct vimc_sen_device, sd);
+	int ret;
+
+	if (enable) {
+		const struct vimc_pix_map *vpix;
+
+		if (vsen->kthread_sen)
+			return -EINVAL;
+
+		/* Calculate the frame size */
+		vpix = vimc_pix_map_by_code(vsen->mbus_format.code);
+		vsen->frame_size = vsen->mbus_format.width * vpix->bpp *
+				   vsen->mbus_format.height;
+
+		/*
+		 * Allocate the frame buffer. Use vmalloc to be able to
+		 * allocate a large amount of memory
+		 */
+		vsen->frame = vmalloc(vsen->frame_size);
+		if (!vsen->frame)
+			return -ENOMEM;
+
+		/* Initialize the image generator thread */
+		vsen->kthread_sen = kthread_run(vimc_thread_sen, vsen,
+						"%s-sen", vsen->v4l2_dev->name);
+		if (IS_ERR(vsen->kthread_sen)) {
+			dev_err(vsen->dev, "kernel_thread() failed\n");
+			vfree(vsen->frame);
+			vsen->frame = NULL;
+			return PTR_ERR(vsen->kthread_sen);
+		}
+	} else {
+		if (!vsen->kthread_sen)
+			return -EINVAL;
+
+		/* Stop image generator */
+		ret = kthread_stop(vsen->kthread_sen);
+		vsen->kthread_sen = NULL;
+
+		vfree(vsen->frame);
+		vsen->frame = NULL;
+		return ret;
+	}
+
+	return 0;
+}
+
+struct v4l2_subdev_video_ops vimc_sen_video_ops = {
+	.s_stream = vimc_sen_s_stream,
+};
+
+static const struct v4l2_subdev_ops vimc_sen_ops = {
+	.pad = &vimc_sen_pad_ops,
+	.video = &vimc_sen_video_ops,
+};
+
+static void vimc_sen_destroy(struct vimc_ent_device *ved)
+{
+	struct vimc_sen_device *vsen =
+				container_of(ved, struct vimc_sen_device, ved);
+
+	media_entity_cleanup(ved->ent);
+	v4l2_device_unregister_subdev(&vsen->sd);
+	kfree(vsen);
+}
+
+struct vimc_ent_device *vimc_sen_create(struct v4l2_device *v4l2_dev,
+					const char *const name,
+					u16 num_pads,
+					const unsigned long *pads_flag)
+{
+	struct vimc_sen_device *vsen;
+	unsigned int i;
+	int ret;
+
+	/* NOTE: a sensor node may be created with more then one pad */
+	if (!name || !num_pads || !pads_flag)
+		return ERR_PTR(-EINVAL);
+
+	/* check if all pads are sources */
+	for (i = 0; i < num_pads; i++)
+		if (!(pads_flag[i] & MEDIA_PAD_FL_SOURCE))
+			return ERR_PTR(-EINVAL);
+
+	/* Allocate the vsen struct */
+	vsen = kzalloc(sizeof(*vsen), GFP_KERNEL);
+	if (!vsen)
+		return ERR_PTR(-ENOMEM);
+
+	/* Link the vimc_sen_device struct with the v4l2 parent */
+	vsen->v4l2_dev = v4l2_dev;
+	/* Link the vimc_sen_device struct with the dev parent */
+	vsen->dev = v4l2_dev->dev;
+
+	/* Allocate the pads */
+	vsen->ved.pads = vimc_pads_init(num_pads, pads_flag);
+	if (IS_ERR(vsen->ved.pads)) {
+		ret = PTR_ERR(vsen->ved.pads);
+		goto err_free_vsen;
+	}
+
+	/* Initialize the media entity */
+	vsen->sd.entity.name = name;
+	ret = media_entity_pads_init(&vsen->sd.entity,
+				     num_pads, vsen->ved.pads);
+	if (ret)
+		goto err_clean_pads;
+
+	/* Set the active frame format (this is hardcoded for now) */
+	vsen->mbus_format.width = 640;
+	vsen->mbus_format.height = 480;
+	vsen->mbus_format.code = MEDIA_BUS_FMT_RGB888_1X24;
+	vsen->mbus_format.field = V4L2_FIELD_NONE;
+	vsen->mbus_format.colorspace = V4L2_COLORSPACE_SRGB;
+	vsen->mbus_format.quantization = V4L2_QUANTIZATION_FULL_RANGE;
+	vsen->mbus_format.xfer_func = V4L2_XFER_FUNC_SRGB;
+
+	/* Fill the vimc_ent_device struct */
+	vsen->ved.destroy = vimc_sen_destroy;
+	vsen->ved.ent = &vsen->sd.entity;
+
+	/* Initialize the subdev */
+	v4l2_subdev_init(&vsen->sd, &vimc_sen_ops);
+	vsen->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
+	vsen->sd.entity.ops = &vimc_sen_mops;
+	vsen->sd.owner = THIS_MODULE;
+	strlcpy(vsen->sd.name, name, sizeof(vsen->sd.name));
+	v4l2_set_subdevdata(&vsen->sd, &vsen->ved);
+
+	/* Expose this subdev to user space */
+	vsen->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	/* Register the subdev with the v4l2 and the media framework */
+	ret = v4l2_device_register_subdev(vsen->v4l2_dev, &vsen->sd);
+	if (ret) {
+		dev_err(vsen->dev,
+			"subdev register failed (err=%d)\n", ret);
+		goto err_clean_m_ent;
+	}
+
+	return &vsen->ved;
+
+err_clean_m_ent:
+	media_entity_cleanup(&vsen->sd.entity);
+err_clean_pads:
+	vimc_pads_cleanup(vsen->ved.pads);
+err_free_vsen:
+	kfree(vsen);
+
+	return ERR_PTR(ret);
+}
diff --git a/drivers/media/platform/vimc/vimc-sensor.h b/drivers/media/platform/vimc/vimc-sensor.h
new file mode 100644
index 0000000..ef48362
--- /dev/null
+++ b/drivers/media/platform/vimc/vimc-sensor.h
@@ -0,0 +1,28 @@
+/*
+ * vimc-sensor.h Virtual Media Controller Driver
+ *
+ * Copyright (C) 2017 Helen Koike F. <helen.fornazier@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _VIMC_SENSOR_H_
+#define _VIMC_SENSOR_H_
+
+#include "vimc-core.h"
+
+struct vimc_ent_device *vimc_sen_create(struct v4l2_device *v4l2_dev,
+					const char *const name,
+					u16 num_pads,
+					const unsigned long *pads_flag);
+
+#endif
-- 
2.7.4
