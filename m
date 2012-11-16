Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40122 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab2KPOqs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 09:46:48 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 02/12] davinci: vpfe: add v4l2 video driver support
Date: Fri, 16 Nov 2012 20:15:04 +0530
Message-Id: <1353077114-19296-3-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1353077114-19296-1-git-send-email-prabhakar.lad@ti.com>
References: <1353077114-19296-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Manjunath Hadli <manjunath.hadli@ti.com>

Add a generic video driver functionality to be used by all the vpfe
drivers for davinci SoCs. The functionality includes all the
standard v4l2 interfaces including streaming. The video node
interface can be used both as an input and output node for both
continuous and single shot modes. Also supports dv_presets to include
HD modes, wth support for both user pointer IO and mmap. The buffering
mechanism is based on videobuf2 interface.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/platform/davinci/vpfe_video.c | 1620 +++++++++++++++++++++++++++
 drivers/media/platform/davinci/vpfe_video.h |  155 +++
 2 files changed, 1775 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/platform/davinci/vpfe_video.c
 create mode 100644 drivers/media/platform/davinci/vpfe_video.h

diff --git a/drivers/media/platform/davinci/vpfe_video.c b/drivers/media/platform/davinci/vpfe_video.c
new file mode 100644
index 0000000..6c57da0
--- /dev/null
+++ b/drivers/media/platform/davinci/vpfe_video.c
@@ -0,0 +1,1620 @@
+/*
+ * Copyright (C) 2012 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * Contributors:
+ *      Manjunath Hadli <manjunath.hadli@ti.com>
+ *      Prabhakar Lad <prabhakar.lad@ti.com>
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include <media/davinci/vpfe.h>
+#include <media/v4l2-ioctl.h>
+
+#include "vpfe_mc_capture.h"
+
+/* minimum number of buffers needed in cont-mode */
+#define MIN_NUM_BUFFERS			3
+
+static int debug;
+
+/* get v4l2 subdev pointer to external subdev which is active */
+static struct media_entity *vpfe_get_input_entity
+			(struct vpfe_video_device *video)
+{
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	struct media_pad *remote;
+
+	remote = media_entity_remote_source(&vpfe_dev->vpfe_isif.pads[0]);
+	if (remote == NULL) {
+		pr_err("Invalid media connection to isif/ccdc\n");
+		return NULL;
+	}
+	return remote->entity;
+}
+
+/* updates external subdev(sensor/decoder) which is active */
+static int vpfe_update_current_ext_subdev(struct vpfe_video_device *video)
+{
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	struct vpfe_config *vpfe_cfg;
+	struct v4l2_subdev *subdev;
+	struct media_pad *remote;
+	int i;
+
+	remote = media_entity_remote_source(&vpfe_dev->vpfe_isif.pads[0]);
+	if (remote == NULL) {
+		pr_err("Invalid media connection to isif/ccdc\n");
+		return -EINVAL;
+	}
+
+	subdev = media_entity_to_v4l2_subdev(remote->entity);
+	vpfe_cfg = vpfe_dev->pdev->platform_data;
+	for (i = 0; i < vpfe_cfg->num_subdevs; i++) {
+		if (!strcmp(vpfe_cfg->sub_devs[i].module_name, subdev->name)) {
+			video->current_ext_subdev = &vpfe_cfg->sub_devs[i];
+			break;
+		}
+	}
+
+	/* if user not linked decoder/sensor to isif/ccdc */
+	if (i == vpfe_cfg->num_subdevs) {
+		pr_err("Invalid media chain connection to isif/ccdc\n");
+		return -EINVAL;
+	}
+	/* find the v4l2 subdev pointer */
+	for (i = 0; i < vpfe_dev->num_ext_subdevs; i++) {
+		if (!strcmp(video->current_ext_subdev->module_name,
+			vpfe_dev->sd[i]->name))
+			video->current_ext_subdev->subdev = vpfe_dev->sd[i];
+	}
+	return 0;
+}
+
+/* get the subdev which is connected to the output video node */
+static struct v4l2_subdev *
+vpfe_video_remote_subdev(struct vpfe_video_device *video, u32 *pad)
+{
+	struct media_pad *remote = media_entity_remote_source(&video->pad);
+
+	if (remote == NULL || remote->entity->type != MEDIA_ENT_T_V4L2_SUBDEV)
+		return NULL;
+	if (pad)
+		*pad = remote->index;
+	return media_entity_to_v4l2_subdev(remote->entity);
+}
+
+/* get the format set at output pad of the adjacent subdev */
+static int
+__vpfe_video_get_format(struct vpfe_video_device *video,
+			struct v4l2_format *format)
+{
+	struct v4l2_subdev_format fmt;
+	struct v4l2_subdev *subdev;
+	struct media_pad *remote;
+	u32 pad;
+	int ret;
+
+	subdev = vpfe_video_remote_subdev(video, &pad);
+	if (subdev == NULL)
+		return -EINVAL;
+
+	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	remote = media_entity_remote_source(&video->pad);
+	fmt.pad = remote->index;
+
+	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
+	if (ret == -ENOIOCTLCMD)
+		return -EINVAL;
+
+	format->type = video->type;
+	/* convert mbus_format to v4l2_format */
+	v4l2_fill_pix_format(&format->fmt.pix, &fmt.format);
+	mbus_to_pix(&fmt.format, &format->fmt.pix);
+
+	return 0;
+}
+
+/* make a note of pipeline details */
+static void vpfe_prepare_pipeline(struct vpfe_video_device *video)
+{
+	struct media_entity *entity = &video->video_dev.entity;
+	struct media_device *mdev = entity->parent;
+	struct vpfe_pipeline *pipe = &video->pipe;
+	struct vpfe_video_device *far_end = NULL;
+	struct media_entity_graph graph;
+
+	pipe->input_num = 0;
+	pipe->output_num = 0;
+
+	if (video->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		pipe->inputs[pipe->input_num++] = video;
+	else
+		pipe->outputs[pipe->output_num++] = video;
+
+	mutex_lock(&mdev->graph_mutex);
+	media_entity_graph_walk_start(&graph, entity);
+	while ((entity = media_entity_graph_walk_next(&graph))) {
+		if (entity == &video->video_dev.entity)
+			continue;
+		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE)
+			continue;
+		far_end = to_vpfe_video(media_entity_to_video_device(entity));
+		if (far_end->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+			pipe->inputs[pipe->input_num++] = far_end;
+		else
+			pipe->outputs[pipe->output_num++] = far_end;
+	}
+	mutex_unlock(&mdev->graph_mutex);
+}
+
+/* update pipe state selected by user */
+static int vpfe_update_pipe_state(struct vpfe_video_device *video)
+{
+	struct vpfe_pipeline *pipe = &video->pipe;
+	int ret;
+
+	vpfe_prepare_pipeline(video);
+
+	/* Find out if there is any input video
+	  if yes, it is single shot.
+	*/
+	if (pipe->input_num == 0) {
+		pipe->state = VPFE_PIPELINE_STREAM_CONTINUOUS;
+		ret = vpfe_update_current_ext_subdev(video);
+		if (ret) {
+			pr_err("Invalid external subdev\n");
+			return ret;
+		}
+	} else {
+		pipe->state = VPFE_PIPELINE_STREAM_SINGLESHOT;
+	}
+	video->initialized = 1;
+	video->skip_frame_count = 1;
+	video->skip_frame_count_init = 1;
+	return 0;
+}
+
+/* checks wether pipeline is ready for enabling */
+int vpfe_video_is_pipe_ready(struct vpfe_pipeline *pipe)
+{
+	int i;
+
+	for (i = 0; i < pipe->input_num; i++)
+		if (!pipe->inputs[i]->started ||
+			pipe->inputs[i]->state != VPFE_VIDEO_BUFFER_QUEUED)
+			return 0;
+	for (i = 0; i < pipe->output_num; i++)
+		if (!pipe->outputs[i]->started ||
+			pipe->outputs[i]->state != VPFE_VIDEO_BUFFER_QUEUED)
+			return 0;
+	return 1;
+}
+
+/**
+ * Validate a pipeline by checking both ends of all links for format
+ * discrepancies.
+ *
+ * Return 0 if all formats match, or -EPIPE if at least one link is found with
+ * different formats on its two ends.
+ */
+static int vpfe_video_validate_pipeline(struct vpfe_pipeline *pipe)
+{
+	struct v4l2_subdev_format fmt_source;
+	struct v4l2_subdev_format fmt_sink;
+	struct v4l2_subdev *subdev;
+	struct media_pad *pad;
+	int ret;
+
+	/*
+	 * Should not matter if it is output[0] or 1 as
+	 * the general ideas is to traverse backwards and
+	 * the fact that the out video node always has the
+	 * format of the connected pad.
+	 */
+	subdev = vpfe_video_remote_subdev(pipe->outputs[0], NULL);
+	if (subdev == NULL)
+		return -EPIPE;
+
+	while (1) {
+		/* Retrieve the sink format */
+		pad = &subdev->entity.pads[0];
+		if (!(pad->flags & MEDIA_PAD_FL_SINK))
+			break;
+
+		fmt_sink.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+		fmt_sink.pad = pad->index;
+		ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL,
+				       &fmt_sink);
+
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			return -EPIPE;
+
+		/* Retrieve the source format */
+		pad = media_entity_remote_source(pad);
+		if (pad == NULL ||
+			pad->entity->type != MEDIA_ENT_T_V4L2_SUBDEV)
+			break;
+
+		subdev = media_entity_to_v4l2_subdev(pad->entity);
+
+		fmt_source.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+		fmt_source.pad = pad->index;
+		ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt_source);
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			return -EPIPE;
+
+		/* Check if the two ends match */
+		if (fmt_source.format.code != fmt_sink.format.code ||
+		    fmt_source.format.width != fmt_sink.format.width ||
+		    fmt_source.format.height != fmt_sink.format.height)
+			return -EPIPE;
+	}
+	return 0;
+}
+
+/*
+ * vpfe_pipeline_enable() - Enable streaming on a pipeline
+ * @vpfe_dev: vpfe device
+ * @pipe: vpfe pipeline
+ *
+ * Walk the entities chain starting at the pipeline output video node and start
+ * all modules in the chain in the given mode.
+ *
+ * Return 0 if successful, or the return value of the failed video::s_stream
+ * operation otherwise.
+ */
+static int vpfe_pipeline_enable(struct vpfe_pipeline *pipe)
+{
+	struct media_entity_graph graph;
+	struct media_entity *entity;
+	struct v4l2_subdev *subdev;
+	struct media_device *mdev;
+	int ret = 0;
+
+	if (pipe->state == VPFE_PIPELINE_STREAM_CONTINUOUS)
+		entity = vpfe_get_input_entity(pipe->outputs[0]);
+	else
+		entity = &pipe->inputs[0]->video_dev.entity;
+
+	mdev = entity->parent;
+	mutex_lock(&mdev->graph_mutex);
+	media_entity_graph_walk_start(&graph, entity);
+	while ((entity = media_entity_graph_walk_next(&graph))) {
+
+		if (media_entity_type(entity) == MEDIA_ENT_T_DEVNODE)
+			continue;
+		subdev = media_entity_to_v4l2_subdev(entity);
+		ret = v4l2_subdev_call(subdev, video, s_stream, 1);
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			break;
+	}
+	mutex_unlock(&mdev->graph_mutex);
+	return ret;
+}
+
+/*
+ * vpfe_pipeline_disable() - Disable streaming on a pipeline
+ * @vpfe_dev: vpfe device
+ * @pipe: VPFE pipeline
+ *
+ * Walk the entities chain starting at the pipeline output video node and stop
+ * all modules in the chain.
+ *
+ * Return 0 if all modules have been properly stopped, or -ETIMEDOUT if a module
+ * can't be stopped.
+ */
+static int vpfe_pipeline_disable(struct vpfe_pipeline *pipe)
+{
+	struct media_entity_graph graph;
+	struct media_entity *entity;
+	struct v4l2_subdev *subdev;
+	struct media_device *mdev;
+	int ret = 0;
+
+	if (pipe->state == VPFE_PIPELINE_STREAM_CONTINUOUS)
+		entity = vpfe_get_input_entity(pipe->outputs[0]);
+	else
+		entity = &pipe->inputs[0]->video_dev.entity;
+
+	mdev = entity->parent;
+	mutex_lock(&mdev->graph_mutex);
+	media_entity_graph_walk_start(&graph, entity);
+
+	while ((entity = media_entity_graph_walk_next(&graph))) {
+
+		if (media_entity_type(entity) == MEDIA_ENT_T_DEVNODE)
+			continue;
+		subdev = media_entity_to_v4l2_subdev(entity);
+		ret = v4l2_subdev_call(subdev, video, s_stream, 0);
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			break;
+	}
+	mutex_unlock(&mdev->graph_mutex);
+
+	return (ret == 0) ? ret : -ETIMEDOUT ;
+}
+
+/*
+ * vpfe_pipeline_set_stream() - Enable/disable streaming on a pipeline
+ * @vpfe_dev: VPFE device
+ * @pipe: VPFE pipeline
+ * @state: Stream state (stopped or active)
+ *
+ * Set the pipeline to the given stream state.
+ *
+ * Return 0 if successfull, or the return value of the failed video::s_stream
+ * operation otherwise.
+ */
+static int vpfe_pipeline_set_stream(struct vpfe_pipeline *pipe,
+			    enum vpfe_pipeline_stream_state state)
+{
+	if (state == VPFE_PIPELINE_STREAM_STOPPED)
+		return vpfe_pipeline_disable(pipe);
+
+	return vpfe_pipeline_enable(pipe);
+}
+
+static int all_videos_stopped(struct vpfe_video_device *video)
+{
+	struct vpfe_pipeline *pipe = &video->pipe;
+	int i;
+
+	for (i = 0; i < pipe->input_num; i++)
+		if (pipe->inputs[i]->started)
+			return 0;
+	for (i = 0; i < pipe->output_num; i++)
+		if (pipe->outputs[i]->started)
+			return 0;
+	return 1;
+}
+
+/*
+ * vpfe_open() - open video device
+ * @file: file pointer
+ *
+ * initialize media pipeline state, allocate memory for file handle
+ *
+ * Return 0 if successful, or the return -ENODEV otherwise.
+ */
+static int vpfe_open(struct file *file)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_fh *handle;
+
+	/* Allocate memory for the file handle object */
+	handle = kzalloc(sizeof(struct vpfe_fh), GFP_KERNEL);
+
+	if (handle == NULL)
+		return -ENOMEM;
+
+	v4l2_fh_init(&handle->vfh, &video->video_dev);
+	v4l2_fh_add(&handle->vfh);
+
+	mutex_lock(&video->lock);
+	/* If decoder is not initialized. initialize it */
+	if (!video->initialized && vpfe_update_pipe_state(video)) {
+		mutex_unlock(&video->lock);
+		return -ENODEV;
+	}
+	/* Increment device users counter */
+	video->usrs++;
+	/* Set io_allowed member to false */
+	handle->io_allowed = 0;
+	v4l2_prio_open(&video->prio, &handle->prio);
+	handle->video = video;
+	file->private_data = &handle->vfh;
+	mutex_unlock(&video->lock);
+
+	return 0;
+}
+
+/* get the next buffer available from dma queue */
+static unsigned long
+vpfe_video_get_next_buffer(struct vpfe_video_device *video)
+{
+	video->cur_frm = video->next_frm =
+		list_entry(video->dma_queue.next,
+			   struct vpfe_cap_buffer, list);
+
+	list_del(&video->next_frm->list);
+	video->next_frm->vb.state = VB2_BUF_STATE_ACTIVE;
+	return vb2_dma_contig_plane_dma_addr(&video->next_frm->vb, 0);
+}
+
+/* schedule the next buffer which is available on dma queue */
+void vpfe_video_schedule_next_buffer(struct vpfe_video_device *video)
+{
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	unsigned long addr;
+
+	if (list_empty(&video->dma_queue))
+		return;
+
+	video->next_frm = list_entry(video->dma_queue.next,
+					struct vpfe_cap_buffer, list);
+
+	if (VPFE_PIPELINE_STREAM_SINGLESHOT == video->pipe.state)
+		video->cur_frm = video->next_frm;
+
+	list_del(&video->next_frm->list);
+	video->next_frm->vb.state = VB2_BUF_STATE_ACTIVE;
+	addr = vb2_dma_contig_plane_dma_addr(&video->next_frm->vb, 0);
+	video->ops->queue(vpfe_dev, addr);
+	video->state = VPFE_VIDEO_BUFFER_QUEUED;
+}
+
+/* schedule the buffer for capturing bottom field */
+void vpfe_video_schedule_bottom_field(struct vpfe_video_device *video)
+{
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	unsigned long addr;
+
+	addr = vb2_dma_contig_plane_dma_addr(&video->cur_frm->vb, 0);
+	addr += video->field_off;
+	video->ops->queue(vpfe_dev, addr);
+}
+
+/* make buffer available for dequeue */
+void vpfe_video_process_buffer_complete(struct vpfe_video_device *video)
+{
+	struct vpfe_pipeline *pipe = &video->pipe;
+
+	do_gettimeofday(&video->cur_frm->vb.v4l2_buf.timestamp);
+	vb2_buffer_done(&video->cur_frm->vb, VB2_BUF_STATE_DONE);
+	if (pipe->state == VPFE_PIPELINE_STREAM_CONTINUOUS)
+		video->cur_frm = video->next_frm;
+}
+
+/* vpfe_stop_capture() - stop streaming */
+static void vpfe_stop_capture(struct vpfe_video_device *video)
+{
+	struct vpfe_pipeline *pipe = &video->pipe;
+
+	video->started = 0;
+
+	if (video->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		return;
+	if (all_videos_stopped(video))
+		vpfe_pipeline_set_stream(pipe,
+					 VPFE_PIPELINE_STREAM_STOPPED);
+}
+
+/*
+ * vpfe_release() - release video device
+ * @file: file pointer
+ *
+ * deletes buffer queue, frees the buffers and the vpfe file handle
+ *
+ * Return 0
+ */
+static int vpfe_release(struct file *file)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct v4l2_fh *vfh = file->private_data;
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	struct vpfe_fh *fh = container_of(vfh, struct vpfe_fh, vfh);
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_release\n");
+
+	/* Get the device lock */
+	mutex_lock(&video->lock);
+	/* if this instance is doing IO */
+	if (fh->io_allowed) {
+		if (video->started) {
+			vpfe_stop_capture(video);
+			/* mark pipe state as stopped in vpfe_release(),
+			   as app might call streamon() after streamoff()
+			   in which case driver has to start streaming.
+			*/
+			video->pipe.state = VPFE_PIPELINE_STREAM_STOPPED;
+			vb2_streamoff(&video->buffer_queue,
+				      video->buffer_queue.type);
+		}
+		video->io_usrs = 0;
+		/* Free buffers allocated */
+		vb2_queue_release(&video->buffer_queue);
+		vb2_dma_contig_cleanup_ctx(video->alloc_ctx);
+	}
+	/* Decrement device users counter */
+	video->usrs--;
+	/* Close the priority */
+	v4l2_prio_close(&video->prio, fh->prio);
+	/* If this is the last file handle */
+	if (!video->usrs)
+		video->initialized = 0;
+	mutex_unlock(&video->lock);
+	file->private_data = NULL;
+	/* Free memory allocated to file handle object */
+	v4l2_fh_del(vfh);
+	kzfree(fh);
+	return 0;
+}
+
+/*
+ * vpfe_mmap() - It is used to map kernel space buffers
+ * into user spaces
+ */
+static int vpfe_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_mmap\n");
+	return vb2_mmap(&video->buffer_queue, vma);
+}
+
+/*
+ * vpfe_poll() - It is used for select/poll system call
+ */
+static unsigned int vpfe_poll(struct file *file, poll_table *wait)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_poll\n");
+	if (video->started)
+		return vb2_poll(&video->buffer_queue, file, wait);
+	return 0;
+}
+
+/* vpfe capture driver file operations */
+static const struct v4l2_file_operations vpfe_fops = {
+	.owner = THIS_MODULE,
+	.open = vpfe_open,
+	.release = vpfe_release,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap = vpfe_mmap,
+	.poll = vpfe_poll
+};
+
+/*
+ * vpfe_querycap() - query capabilities of video device
+ * @file: file pointer
+ * @priv: void pointer
+ * @cap: pointer to v4l2_capability structure
+ *
+ * fills v4l2 capabilities structure
+ *
+ * Return 0
+ */
+static int vpfe_querycap(struct file *file, void  *priv,
+			       struct v4l2_capability *cap)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_querycap\n");
+
+	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	else
+		cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
+	cap->device_caps = cap->capabilities;
+	cap->version = VPFE_CAPTURE_VERSION_CODE;
+	strlcpy(cap->driver, CAPTURE_DRV_NAME, sizeof(cap->driver));
+	strlcpy(cap->bus_info, "VPFE", sizeof(cap->bus_info));
+	strlcpy(cap->card, vpfe_dev->cfg->card_name, sizeof(cap->card));
+
+	return 0;
+}
+
+/*
+ * vpfe_g_fmt() - get the format which is active on video device
+ * @file: file pointer
+ * @priv: void pointer
+ * @fmt: pointer to v4l2_format structure
+ *
+ * fills v4l2 format structure with active format
+ *
+ * Return 0
+ */
+static int vpfe_g_fmt(struct file *file, void *priv,
+				struct v4l2_format *fmt)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_fmt\n");
+	/* Fill in the information about format */
+	*fmt = video->fmt;
+	return 0;
+}
+
+/*
+ * vpfe_enum_fmt() - enum formats supported on media chain
+ * @file: file pointer
+ * @priv: void pointer
+ * @fmt: pointer to v4l2_fmtdesc structure
+ *
+ * fills v4l2_fmtdesc structure with output format set on adjacent subdev,
+ * only one format is enumearted as subdevs are already configured
+ *
+ * Return 0 if successfull, error code otherwise
+ */
+static int vpfe_enum_fmt(struct file *file, void  *priv,
+				   struct v4l2_fmtdesc *fmt)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	struct v4l2_subdev_format sd_fmt;
+	struct v4l2_mbus_framefmt mbus;
+	struct v4l2_subdev *subdev;
+	struct v4l2_format format;
+	struct media_pad *remote;
+	int ret;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_enum_fmt\n");
+
+	/* since already subdev pad format is set,
+	only one pixel format is available */
+	if (fmt->index > 0) {
+		v4l2_err(&vpfe_dev->v4l2_dev, "Invalid index\n");
+		return -EINVAL;
+	}
+	/* get the remote pad */
+	remote = media_entity_remote_source(&video->pad);
+	if (remote == NULL) {
+		v4l2_err(&vpfe_dev->v4l2_dev,
+			 "invalid remote pad for video node\n");
+		return -EINVAL;
+	}
+	/* get the remote subdev */
+	subdev = vpfe_video_remote_subdev(video, NULL);
+	if (subdev == NULL) {
+		v4l2_err(&vpfe_dev->v4l2_dev,
+			 "invalid remote subdev for video node\n");
+		return -EINVAL;
+	}
+	sd_fmt.pad = remote->index;
+	sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	/* get output format of remote subdev */
+	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &sd_fmt);
+	if (ret) {
+		v4l2_err(&vpfe_dev->v4l2_dev,
+			 "invalid remote subdev for video node\n");
+		return ret;
+	}
+	/* convert to pix format */
+	mbus.code = sd_fmt.format.code;
+	mbus_to_pix(&mbus, &format.fmt.pix);
+	/* copy the result */
+	fmt->pixelformat = format.fmt.pix.pixelformat;
+
+	return 0;
+}
+
+/*
+ * vpfe_s_fmt() - set the format on video device
+ * @file: file pointer
+ * @priv: void pointer
+ * @fmt: pointer to v4l2_format structure
+ *
+ * validate and set the format on video device
+ *
+ * Return 0 on success, error code otherwise
+ */
+static int vpfe_s_fmt(struct file *file, void *priv,
+				struct v4l2_format *fmt)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	struct v4l2_format format;
+	int ret;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_fmt\n");
+	/* If streaming is started, return error */
+	if (video->started) {
+		v4l2_err(&vpfe_dev->v4l2_dev, "Streaming is started\n");
+		return -EBUSY;
+	}
+	/* get adjacent subdev's output pad format */
+	ret = __vpfe_video_get_format(video, &format);
+	if (ret)
+		return ret;
+	*fmt = format;
+	video->fmt = *fmt;
+	return 0;
+}
+
+/*
+ * vpfe_try_fmt() - try the format on video device
+ * @file: file pointer
+ * @priv: void pointer
+ * @fmt: pointer to v4l2_format structure
+ *
+ * validate the format, update with correct format
+ * based on output format set on adjacent subdev
+ *
+ * Return 0 on success, error code otherwise
+ */
+static int vpfe_try_fmt(struct file *file, void *priv,
+				  struct v4l2_format *fmt)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	struct v4l2_format format;
+	int ret;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_try_fmt\n");
+	/* get adjacent subdev's output pad format */
+	ret = __vpfe_video_get_format(video, &format);
+	if (ret)
+		return ret;
+
+	*fmt = format;
+	return 0;
+}
+
+/*
+ * vpfe_enum_input() - enum inputs supported on media chain
+ * @file: file pointer
+ * @priv: void pointer
+ * @fmt: pointer to v4l2_fmtdesc structure
+ *
+ * fills v4l2_input structure with input available on media chain,
+ * only one input is enumearted as media chain is setup by this time
+ *
+ * Return 0 if successfull, -EINVAL is media chain is invalid
+ */
+static int vpfe_enum_input(struct file *file, void *priv,
+				 struct v4l2_input *inp)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_ext_subdev_info *sdinfo = video->current_ext_subdev;
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_enum_input\n");
+	/* enumerate from the subdev user has choosen through mc */
+	if (inp->index < sdinfo->num_inputs) {
+		memcpy(inp, &sdinfo->inputs[inp->index],
+		       sizeof(struct v4l2_input));
+		return 0;
+	}
+	return -EINVAL;
+}
+
+/*
+ * vpfe_g_input() - get index of the input which is active
+ * @file: file pointer
+ * @priv: void pointer
+ * @index: pointer to unsigned int
+ *
+ * set index with input index which is active
+ */
+static int vpfe_g_input(struct file *file, void *priv, unsigned int *index)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_input\n");
+
+	*index = video->current_input;
+	return 0;
+}
+
+/*
+ * vpfe_s_input() - set input which is pointed by input index
+ * @file: file pointer
+ * @priv: void pointer
+ * @index: pointer to unsigned int
+ *
+ * set input on external subdev
+ *
+ * Return 0 on success, error code otherwise
+ */
+static int vpfe_s_input(struct file *file, void *priv, unsigned int index)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	struct vpfe_ext_subdev_info *sdinfo;
+	struct vpfe_route *route;
+	struct v4l2_input *inps;
+	u32 output;
+	u32 input;
+	int ret;
+	int i;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_input\n");
+
+	ret = mutex_lock_interruptible(&video->lock);
+	if (ret)
+		return ret;
+	/*
+	 * If streaming is started return device busy
+	 * error
+	 */
+	if (video->started) {
+		v4l2_err(&vpfe_dev->v4l2_dev, "Streaming is on\n");
+		ret = -EBUSY;
+		goto unlock_out;
+	}
+
+	sdinfo = video->current_ext_subdev;
+	if (!sdinfo->registered) {
+		ret = -EINVAL;
+		goto unlock_out;
+	}
+	if (vpfe_dev->cfg->setup_input &&
+		vpfe_dev->cfg->setup_input(sdinfo->grp_id) < 0) {
+		ret = -EFAULT;
+		v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
+			  "couldn't setup input for %s\n",
+			  sdinfo->module_name);
+		goto unlock_out;
+	}
+	route = &sdinfo->routes[index];
+	if (route && sdinfo->can_route) {
+		input = route->input;
+		output = route->output;
+		ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev,
+						 sdinfo->grp_id, video,
+						 s_routing, input, output, 0);
+		if (ret) {
+			v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
+				"s_input:error in setting input in decoder\n");
+			ret = -EINVAL;
+			goto unlock_out;
+		}
+	}
+	/* set standards set by subdev in video device */
+	for (i = 0; i < sdinfo->num_inputs; i++) {
+		inps = &sdinfo->inputs[i];
+		video->video_dev.tvnorms |= inps->std;
+	}
+	video->current_input = index;
+unlock_out:
+	mutex_unlock(&video->lock);
+	return ret;
+}
+
+/*
+ * vpfe_querystd() - query std which is being input on external subdev
+ * @file: file pointer
+ * @priv: void pointer
+ * @std_id: pointer to v4l2_std_id structure
+ *
+ * call external subdev through v4l2_device_call_until_err to
+ * get the std that is being active.
+ *
+ * Return 0 on success, error code otherwise
+ */
+static int vpfe_querystd(struct file *file, void *priv, v4l2_std_id *std_id)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	struct vpfe_ext_subdev_info *sdinfo;
+	int ret;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_querystd\n");
+
+	ret = mutex_lock_interruptible(&video->lock);
+	sdinfo = video->current_ext_subdev;
+	if (ret)
+		return ret;
+	/* Call querystd function of decoder device */
+	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
+					 video, querystd, std_id);
+	mutex_unlock(&video->lock);
+	return ret;
+}
+
+/*
+ * vpfe_s_std() - set std on external subdev
+ * @file: file pointer
+ * @priv: void pointer
+ * @std_id: pointer to v4l2_std_id structure
+ *
+ * set std pointed by std_id on external subdev by calling it using
+ * v4l2_device_call_until_err
+ *
+ * Return 0 on success, error code otherwise
+ */
+static int vpfe_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	struct vpfe_ext_subdev_info *sdinfo;
+	int ret;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_std\n");
+
+	/* Call decoder driver function to set the standard */
+	ret = mutex_lock_interruptible(&video->lock);
+	if (ret)
+		return ret;
+	sdinfo = video->current_ext_subdev;
+	/* If streaming is started, return device busy error */
+	if (video->started) {
+		v4l2_err(&vpfe_dev->v4l2_dev, "streaming is started\n");
+		ret = -EBUSY;
+		goto unlock_out;
+	}
+	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
+					 core, s_std, *std_id);
+	if (ret < 0) {
+		v4l2_err(&vpfe_dev->v4l2_dev, "Failed to set standard\n");
+		video->stdid = V4L2_STD_UNKNOWN;
+		goto unlock_out;
+	}
+	video->stdid = *std_id;
+unlock_out:
+	mutex_unlock(&video->lock);
+	return ret;
+}
+
+static int vpfe_g_std(struct file *file, void *priv, v4l2_std_id *tvnorm)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_std\n");
+	*tvnorm = video->stdid;
+	return 0;
+}
+
+/*
+ * vpfe_enum_dv_timings() - enumerate dv_timings which are supported by
+ *			to external subdev
+ * @file: file pointer
+ * @priv: void pointer
+ * @timings: pointer to v4l2_enum_dv_timings structure
+ *
+ * enum dv_timings's which are supported by external subdev through
+ * v4l2_subdev_call
+ *
+ * Return 0 on success, error code otherwise
+ */
+static int
+vpfe_enum_dv_timings(struct file *file, void *fh,
+		  struct v4l2_enum_dv_timings *timings)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	struct v4l2_subdev *subdev = video->current_ext_subdev->subdev;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_enum_dv_timings\n");
+	return v4l2_subdev_call(subdev, video, enum_dv_timings, timings);
+}
+
+/*
+ * vpfe_query_dv_timings() - query the dv_timings which is being input
+ *			to external subdev
+ * @file: file pointer
+ * @priv: void pointer
+ * @timings: pointer to v4l2_dv_timings structure
+ *
+ * get dv_timings which is being input on external subdev through
+ * v4l2_subdev_call
+ *
+ * Return 0 on success, error code otherwise
+ */
+static int
+vpfe_query_dv_timings(struct file *file, void *fh,
+		   struct v4l2_dv_timings *timings)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	struct v4l2_subdev *subdev = video->current_ext_subdev->subdev;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_query_dv_timings\n");
+	return v4l2_subdev_call(subdev, video, query_dv_timings, timings);
+}
+
+/*
+ * vpfe_s_dv_timings() - set dv_preset on external subdev
+ * @file: file pointer
+ * @priv: void pointer
+ * @timings: pointer to v4l2_dv_timings structure
+ *
+ * set dv_timings pointed by preset on external subdev through
+ * v4l2_device_call_until_err, this configures amplifier also
+ *
+ * Return 0 on success, error code otherwise
+ */
+static int
+vpfe_s_dv_timings(struct file *file, void *fh,
+		  struct v4l2_dv_timings *timings)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_dv_timings\n");
+
+	video->stdid = V4L2_STD_UNKNOWN;
+	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev,
+					  video->current_ext_subdev->grp_id,
+					  video, s_dv_timings, timings);
+}
+
+/*
+ * vpfe_g_dv_timings() - get dv_preset which is set on external subdev
+ * @file: file pointer
+ * @priv: void pointer
+ * @timings: pointer to v4l2_dv_timings structure
+ *
+ * get dv_preset which is set on external subdev through
+ * v4l2_subdev_call
+ *
+ * Return 0 on success, error code otherwise
+ */
+static int
+vpfe_g_dv_timings(struct file *file, void *fh,
+	      struct v4l2_dv_timings *timings)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	struct v4l2_subdev *subdev = video->current_ext_subdev->subdev;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_dv_timings\n");
+	return v4l2_subdev_call(subdev, video, g_dv_timings, timings);
+}
+
+/*
+ *  Videobuf operations
+ */
+/*
+ * vpfe_buffer_queue_setup : Callback function for buffer setup.
+ * @vq: vb2_queue ptr
+ * @fmt: v4l2 format
+ * @nbuffers: ptr to number of buffers requested by application
+ * @nplanes:: contains number of distinct video planes needed to hold a frame
+ * @sizes[]: contains the size (in bytes) of each plane.
+ * @alloc_ctxs: ptr to allocation context
+ *
+ * This callback function is called when reqbuf() is called to adjust
+ * the buffer nbuffers and buffer size
+ */
+static int
+vpfe_buffer_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+			unsigned int *nbuffers, unsigned int *nplanes,
+			unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct vpfe_fh *fh = vb2_get_drv_priv(vq);
+	struct vpfe_video_device *video = fh->video;
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	struct vpfe_pipeline *pipe = &video->pipe;
+	unsigned long size;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_buffer_queue_setup\n");
+	size = video->fmt.fmt.pix.sizeimage;
+
+	if (vpfe_dev->video_limit) {
+		while (size * *nbuffers > vpfe_dev->video_limit)
+			(*nbuffers)--;
+	}
+	if (pipe->state == VPFE_PIPELINE_STREAM_CONTINUOUS) {
+		if (*nbuffers < MIN_NUM_BUFFERS)
+			*nbuffers = MIN_NUM_BUFFERS;
+	}
+	*nplanes = 1;
+	sizes[0] = size;
+	alloc_ctxs[0] = video->alloc_ctx;
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
+		 "nbuffers=%d, size=%lu\n", *nbuffers, size);
+	return 0;
+}
+
+/*
+ * vpfe_buffer_prepare : callback function for buffer prepare
+ * @vb: ptr to vb2_buffer
+ *
+ * This is the callback function for buffer prepare when vb2_qbuf()
+ * function is called. The buffer is prepared and user space virtual address
+ * or user address is converted into  physical address
+ */
+static int vpfe_buffer_prepare(struct vb2_buffer *vb)
+{
+	struct vpfe_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
+	struct vpfe_video_device *video = fh->video;
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	unsigned long addr;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_buffer_prepare\n");
+
+	if (vb->state != VB2_BUF_STATE_ACTIVE &&
+	    vb->state != VB2_BUF_STATE_PREPARED)
+		return 0;
+
+	/* Initialize buffer */
+	vb2_set_plane_payload(vb, 0, video->fmt.fmt.pix.sizeimage);
+	if (vb2_plane_vaddr(vb, 0) &&
+		vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
+			return -EINVAL;
+
+	addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	/* Make sure user addresses are aligned to 32 bytes */
+	if (!ALIGN(addr, 32))
+		return -EINVAL;
+
+	return 0;
+}
+
+static void vpfe_buffer_queue(struct vb2_buffer *vb)
+{
+	/* Get the file handle object and device object */
+	struct vpfe_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
+	struct vpfe_video_device *video = fh->video;
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	struct vpfe_pipeline *pipe = &video->pipe;
+	struct vpfe_cap_buffer *buf = container_of(vb,
+				struct vpfe_cap_buffer, vb);
+	unsigned long flags;
+	unsigned long empty;
+	unsigned long addr;
+
+	spin_lock_irqsave(&video->dma_queue_lock, flags);
+	empty = list_empty(&video->dma_queue);
+	/* add the buffer to the DMA queue */
+	list_add_tail(&buf->list, &video->dma_queue);
+	spin_unlock_irqrestore(&video->dma_queue_lock, flags);
+	/* this case happens in case of single shot */
+	if (empty && video->started && pipe->state ==
+		VPFE_PIPELINE_STREAM_SINGLESHOT &&
+		video->state == VPFE_VIDEO_BUFFER_NOT_QUEUED) {
+		spin_lock(&video->dma_queue_lock);
+		addr = vpfe_video_get_next_buffer(video);
+		video->ops->queue(vpfe_dev, addr);
+
+		video->state = VPFE_VIDEO_BUFFER_QUEUED;
+		spin_unlock(&video->dma_queue_lock);
+
+		/* enable h/w each time in single shot */
+		if (vpfe_video_is_pipe_ready(pipe))
+			vpfe_pipeline_set_stream(pipe,
+					VPFE_PIPELINE_STREAM_SINGLESHOT);
+	}
+}
+
+/* vpfe_start_capture() - start streaming on all the subdevs */
+static int vpfe_start_capture(struct vpfe_video_device *video)
+{
+	struct vpfe_pipeline *pipe = &video->pipe;
+	int ret = 0;
+
+	video->started = 1;
+	if (vpfe_video_is_pipe_ready(pipe))
+		ret = vpfe_pipeline_set_stream(pipe, pipe->state);
+
+	return ret;
+}
+
+static int vpfe_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct vpfe_fh *fh = vb2_get_drv_priv(vq);
+	struct vpfe_video_device *video = fh->video;
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	unsigned long addr;
+	int ret;
+
+	ret = mutex_lock_interruptible(&video->lock);
+	if (ret)
+		goto streamoff;
+
+	/* Get the next frame from the buffer queue */
+	video->cur_frm = video->next_frm =
+		list_entry(video->dma_queue.next, struct vpfe_cap_buffer, list);
+	/* Remove buffer from the buffer queue */
+	list_del(&video->cur_frm->list);
+	/* Mark state of the current frame to active */
+	video->cur_frm->vb.state = VB2_BUF_STATE_ACTIVE;
+	/* Initialize field_id and started member */
+	video->field_id = 0;
+	addr = vb2_dma_contig_plane_dma_addr(&video->cur_frm->vb, 0);
+	video->ops->queue(vpfe_dev, addr);
+	video->state = VPFE_VIDEO_BUFFER_QUEUED;
+
+	ret = vpfe_start_capture(video);
+	if (ret)
+		goto unlock_out;
+
+	mutex_unlock(&video->lock);
+
+	return ret;
+unlock_out:
+	mutex_unlock(&video->lock);
+streamoff:
+	ret = vb2_streamoff(&video->buffer_queue, video->buffer_queue.type);
+	return 0;
+}
+
+static int vpfe_buffer_init(struct vb2_buffer *vb)
+{
+	struct vpfe_cap_buffer *buf = container_of(vb,
+						   struct vpfe_cap_buffer, vb);
+
+	INIT_LIST_HEAD(&buf->list);
+	return 0;
+}
+
+/* abort streaming and wait for last buffer */
+static int vpfe_stop_streaming(struct vb2_queue *vq)
+{
+	struct vpfe_fh *fh = vb2_get_drv_priv(vq);
+	struct vpfe_video_device *video = fh->video;
+
+	if (!vb2_is_streaming(vq))
+		return 0;
+	/* release all active buffers */
+	while (!list_empty(&video->dma_queue)) {
+		video->next_frm = list_entry(video->dma_queue.next,
+						struct vpfe_cap_buffer, list);
+		list_del(&video->next_frm->list);
+		vb2_buffer_done(&video->next_frm->vb, VB2_BUF_STATE_ERROR);
+	}
+	return 0;
+}
+
+static void vpfe_buf_cleanup(struct vb2_buffer *vb)
+{
+	struct vpfe_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
+	struct vpfe_video_device *video = fh->video;
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	struct vpfe_cap_buffer *buf = container_of(vb,
+					struct vpfe_cap_buffer, vb);
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_buf_cleanup\n");
+	if (vb->state == VB2_BUF_STATE_ACTIVE)
+		list_del_init(&buf->list);
+}
+
+static struct vb2_ops video_qops = {
+	.queue_setup		= vpfe_buffer_queue_setup,
+	.buf_init		= vpfe_buffer_init,
+	.buf_prepare		= vpfe_buffer_prepare,
+	.start_streaming	= vpfe_start_streaming,
+	.stop_streaming		= vpfe_stop_streaming,
+	.buf_cleanup		= vpfe_buf_cleanup,
+	.buf_queue		= vpfe_buffer_queue,
+};
+
+/*
+ * vpfe_reqbufs() - supported REQBUF only once opening
+ * the device.
+ */
+static int vpfe_reqbufs(struct file *file, void *priv,
+			struct v4l2_requestbuffers *req_buf)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	struct vpfe_fh *fh = file->private_data;
+	struct vb2_queue *q;
+	int ret;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_reqbufs\n");
+
+	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != req_buf->type &&
+	    V4L2_BUF_TYPE_VIDEO_OUTPUT != req_buf->type) {
+		v4l2_err(&vpfe_dev->v4l2_dev, "Invalid buffer type\n");
+		return -EINVAL;
+	}
+
+	ret = mutex_lock_interruptible(&video->lock);
+	if (ret)
+		return ret;
+
+	if (video->io_usrs != 0) {
+		v4l2_err(&vpfe_dev->v4l2_dev, "Only one IO user allowed\n");
+		ret = -EBUSY;
+		goto unlock_out;
+	}
+	video->memory = req_buf->memory;
+
+	/* Initialize videobuf2 queue as per the buffer type */
+	video->alloc_ctx = vb2_dma_contig_init_ctx(vpfe_dev->pdev);
+	if (IS_ERR(video->alloc_ctx)) {
+		v4l2_err(&vpfe_dev->v4l2_dev, "Failed to get the context\n");
+		return PTR_ERR(video->alloc_ctx);
+	}
+
+	q = &video->buffer_queue;
+	q->type = req_buf->type;
+	q->io_modes = VB2_MMAP | VB2_USERPTR;
+	q->drv_priv = fh;
+	q->ops = &video_qops;
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->buf_struct_size = sizeof(struct vpfe_cap_buffer);
+
+	ret = vb2_queue_init(q);
+	if (ret) {
+		v4l2_err(&vpfe_dev->v4l2_dev, "vb2_queue_init() failed\n");
+		vb2_dma_contig_cleanup_ctx(vpfe_dev->pdev);
+		return ret;
+	}
+
+	fh->io_allowed = 1;
+	video->io_usrs = 1;
+	INIT_LIST_HEAD(&video->dma_queue);
+	ret = vb2_reqbufs(&video->buffer_queue, req_buf);
+
+unlock_out:
+	mutex_unlock(&video->lock);
+	return ret;
+}
+
+/*
+ * vpfe_querybuf() - query buffers for exchange
+ */
+static int vpfe_querybuf(struct file *file, void *priv,
+			 struct v4l2_buffer *buf)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_querybuf\n");
+
+	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != buf->type &&
+	    V4L2_BUF_TYPE_VIDEO_OUTPUT != buf->type) {
+		v4l2_err(&vpfe_dev->v4l2_dev, "Invalid buf type\n");
+		return  -EINVAL;
+	}
+
+	if (video->memory != V4L2_MEMORY_MMAP) {
+		v4l2_err(&vpfe_dev->v4l2_dev, "Invalid memory\n");
+		return -EINVAL;
+	}
+
+	/* Call vb2_querybuf to get information */
+	return vb2_querybuf(&video->buffer_queue, buf);
+}
+
+/*
+ * vpfe_qbuf() - queue buffers for capture or processing
+ */
+static int vpfe_qbuf(struct file *file, void *priv,
+		     struct v4l2_buffer *p)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	struct vpfe_fh *fh = file->private_data;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_qbuf\n");
+
+	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != p->type &&
+	    V4L2_BUF_TYPE_VIDEO_OUTPUT != p->type) {
+		v4l2_err(&vpfe_dev->v4l2_dev, "Invalid buf type\n");
+		return -EINVAL;
+	}
+	/*
+	 * If this file handle is not allowed to do IO,
+	 * return error
+	 */
+	if (!fh->io_allowed) {
+		v4l2_err(&vpfe_dev->v4l2_dev, "fh->io_allowed\n");
+		return -EACCES;
+	}
+
+	return vb2_qbuf(&video->buffer_queue, p);
+}
+
+/*
+ * vpfe_dqbuf() - deque buffer which is done with processing
+ */
+static int vpfe_dqbuf(struct file *file, void *priv,
+		      struct v4l2_buffer *buf)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_dqbuf\n");
+
+	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != buf->type &&
+	    V4L2_BUF_TYPE_VIDEO_OUTPUT != buf->type) {
+		v4l2_err(&vpfe_dev->v4l2_dev, "Invalid buf type\n");
+		return -EINVAL;
+	}
+
+	return vb2_dqbuf(&video->buffer_queue,
+			 buf, (file->f_flags & O_NONBLOCK));
+}
+
+/*
+ * vpfe_streamon() - get dv_preset which is set on external subdev
+ * @file: file pointer
+ * @priv: void pointer
+ * @buf_type: enum v4l2_buf_type
+ *
+ * queue buffer onto hardware for capture/processing and
+ * start all the subdevs which are in media chain
+ *
+ * Return 0 on success, error code otherwise
+ */
+static int vpfe_streamon(struct file *file, void *priv,
+			 enum v4l2_buf_type buf_type)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	struct vpfe_pipeline *pipe = &video->pipe;
+	struct vpfe_fh *fh = file->private_data;
+	struct vpfe_ext_subdev_info *sdinfo;
+	int ret = -EINVAL;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_streamon\n");
+
+	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != buf_type &&
+	    V4L2_BUF_TYPE_VIDEO_OUTPUT != buf_type) {
+		v4l2_err(&vpfe_dev->v4l2_dev, "Invalid buf type\n");
+		return ret;
+	}
+	/* If file handle is not allowed IO, return error */
+	if (!fh->io_allowed) {
+		v4l2_err(&vpfe_dev->v4l2_dev, "fh->io_allowed\n");
+		return -EACCES;
+	}
+	sdinfo = video->current_ext_subdev;
+	/* If buffer queue is empty, return error */
+	if (list_empty(&video->buffer_queue.queued_list)) {
+		v4l2_err(&vpfe_dev->v4l2_dev, "buffer queue is empty\n");
+		return -EIO;
+	}
+	/* Validate the pipeline */
+	if (V4L2_BUF_TYPE_VIDEO_CAPTURE == buf_type) {
+		ret = vpfe_video_validate_pipeline(pipe);
+		if (ret < 0)
+			return ret;
+	}
+	/* Call vb2_streamon to start streaming */
+	return vb2_streamon(&video->buffer_queue, buf_type);
+}
+
+/*
+ * vpfe_streamoff() - get dv_preset which is set on external subdev
+ * @file: file pointer
+ * @priv: void pointer
+ * @buf_type: enum v4l2_buf_type
+ *
+ * stop all the subdevs which are in media chain
+ *
+ * Return 0 on success, error code otherwise
+ */
+static int vpfe_streamoff(struct file *file, void *priv,
+			  enum v4l2_buf_type buf_type)
+{
+	struct vpfe_video_device *video = video_drvdata(file);
+	struct vpfe_device *vpfe_dev = video->vpfe_dev;
+	struct vpfe_fh *fh = file->private_data;
+	int ret = 0;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_streamoff\n");
+
+	if (buf_type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+	    buf_type != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "Invalid buf type\n");
+		return -EINVAL;
+	}
+
+	/* If io is allowed for this file handle, return error */
+	if (!fh->io_allowed) {
+		v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "fh->io_allowed\n");
+		return -EACCES;
+	}
+
+	/* If streaming is not started, return error */
+	if (!video->started) {
+		v4l2_err(&vpfe_dev->v4l2_dev, "device is not started\n");
+		return -EINVAL;
+	}
+
+	ret = mutex_lock_interruptible(&video->lock);
+	if (ret)
+		return ret;
+
+	vpfe_stop_capture(video);
+	ret = vb2_streamoff(&video->buffer_queue, buf_type);
+	mutex_unlock(&video->lock);
+
+	return ret;
+}
+
+/* vpfe capture ioctl operations */
+static const struct v4l2_ioctl_ops vpfe_ioctl_ops = {
+	.vidioc_querycap	 = vpfe_querycap,
+	.vidioc_g_fmt_vid_cap    = vpfe_g_fmt,
+	.vidioc_s_fmt_vid_cap    = vpfe_s_fmt,
+	.vidioc_try_fmt_vid_cap  = vpfe_try_fmt,
+	.vidioc_enum_fmt_vid_cap = vpfe_enum_fmt,
+	.vidioc_g_fmt_vid_out    = vpfe_g_fmt,
+	.vidioc_s_fmt_vid_out    = vpfe_s_fmt,
+	.vidioc_try_fmt_vid_out  = vpfe_try_fmt,
+	.vidioc_enum_fmt_vid_out = vpfe_enum_fmt,
+	.vidioc_enum_input	 = vpfe_enum_input,
+	.vidioc_g_input		 = vpfe_g_input,
+	.vidioc_s_input		 = vpfe_s_input,
+	.vidioc_querystd	 = vpfe_querystd,
+	.vidioc_s_std		 = vpfe_s_std,
+	.vidioc_g_std		 = vpfe_g_std,
+	.vidioc_enum_dv_timings	 = vpfe_enum_dv_timings,
+	.vidioc_query_dv_timings = vpfe_query_dv_timings,
+	.vidioc_s_dv_timings	 = vpfe_s_dv_timings,
+	.vidioc_g_dv_timings	 = vpfe_g_dv_timings,
+	.vidioc_reqbufs		 = vpfe_reqbufs,
+	.vidioc_querybuf	 = vpfe_querybuf,
+	.vidioc_qbuf		 = vpfe_qbuf,
+	.vidioc_dqbuf		 = vpfe_dqbuf,
+	.vidioc_streamon	 = vpfe_streamon,
+	.vidioc_streamoff	 = vpfe_streamoff,
+};
+
+/* VPFE video init function */
+int vpfe_video_init(struct vpfe_video_device *video, const char *name)
+{
+	const char *direction;
+	int ret;
+
+	switch (video->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		direction = "output";
+		video->pad.flags = MEDIA_PAD_FL_SINK;
+		video->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		break;
+
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		direction = "input";
+		video->pad.flags = MEDIA_PAD_FL_SOURCE;
+		video->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+	/* Initialize field of video device */
+	video->video_dev.release = video_device_release;
+	video->video_dev.fops = &vpfe_fops;
+	video->video_dev.ioctl_ops = &vpfe_ioctl_ops;
+	video->video_dev.minor = -1;
+	video->video_dev.tvnorms = 0;
+	snprintf(video->video_dev.name, sizeof(video->video_dev.name),
+		 "DAVINCI VIDEO %s %s", name, direction);
+
+	/* Initialize prio member of device object */
+	v4l2_prio_init(&video->prio);
+	spin_lock_init(&video->irqlock);
+	spin_lock_init(&video->dma_queue_lock);
+	mutex_init(&video->lock);
+	ret = media_entity_init(&video->video_dev.entity,
+				1, &video->pad, 0);
+	if (ret < 0)
+		return ret;
+
+	video_set_drvdata(&video->video_dev, video);
+
+	return 0;
+}
+
+/* vpfe video device register function */
+int vpfe_video_register(struct vpfe_video_device *video,
+			struct v4l2_device *vdev)
+{
+	int ret;
+
+	video->video_dev.v4l2_dev = vdev;
+
+	ret = video_register_device(&video->video_dev, VFL_TYPE_GRABBER, -1);
+	if (ret < 0)
+		pr_err("%s: could not register video device (%d)\n",
+		       __func__, ret);
+	return ret;
+}
+
+/* vpfe video device unregister function */
+void vpfe_video_unregister(struct vpfe_video_device *video)
+{
+	if (video_is_registered(&video->video_dev)) {
+		media_entity_cleanup(&video->video_dev.entity);
+		video_unregister_device(&video->video_dev);
+	}
+}
diff --git a/drivers/media/platform/davinci/vpfe_video.h b/drivers/media/platform/davinci/vpfe_video.h
new file mode 100644
index 0000000..bf8af01
--- /dev/null
+++ b/drivers/media/platform/davinci/vpfe_video.h
@@ -0,0 +1,155 @@
+/*
+ * Copyright (C) 2012 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * Contributors:
+ *      Manjunath Hadli <manjunath.hadli@ti.com>
+ *      Prabhakar Lad <prabhakar.lad@ti.com>
+ */
+
+#ifndef _DAVINCI_VPFE_VIDEO_H
+#define _DAVINCI_VPFE_VIDEO_H
+
+#include <media/videobuf2-dma-contig.h>
+
+struct vpfe_device;
+
+/*
+ * struct vpfe_video_operations - VPFE video operations
+ * @queue:	Resume streaming when a buffer is queued. Called on VIDIOC_QBUF
+ *		if there was no buffer previously queued.
+ */
+struct vpfe_video_operations {
+	int(*queue) (struct vpfe_device *vpfe_dev, unsigned long addr);
+};
+
+enum vpfe_pipeline_stream_state {
+	VPFE_PIPELINE_STREAM_STOPPED = 0,
+	VPFE_PIPELINE_STREAM_CONTINUOUS = 1,
+	VPFE_PIPELINE_STREAM_SINGLESHOT = 2,
+};
+
+enum vpfe_video_state {
+	/* indicates that buffer is not queued */
+	VPFE_VIDEO_BUFFER_NOT_QUEUED = 0,
+	/* indicates that buffer is queued */
+	VPFE_VIDEO_BUFFER_QUEUED = 1,
+};
+
+struct vpfe_pipeline {
+	/* media pipeline */
+	struct media_pipeline		*pipe;
+	/* state of the pipeline, continuous,
+	 * single-shot or stopped
+	 */
+	enum vpfe_pipeline_stream_state	state;
+	/* number of active input video entities */
+	unsigned int			input_num;
+	/* number of active output video entities */
+	unsigned int			output_num;
+	/* input video nodes in case of single-shot mode */
+	struct vpfe_video_device	*inputs[10];
+	/* capturing video nodes */
+	struct vpfe_video_device	*outputs[10];
+};
+
+#define to_vpfe_pipeline(__e) \
+	container_of((__e)->pipe, struct vpfe_pipeline, pipe)
+
+#define to_vpfe_video(vdev) \
+	container_of(vdev, struct vpfe_video_device, video_dev)
+
+struct vpfe_cap_buffer {
+	struct vb2_buffer vb;
+	struct list_head list;
+};
+
+struct vpfe_video_device {
+	/* vpfe device */
+	struct vpfe_device			*vpfe_dev;
+	/* video dev */
+	struct video_device			video_dev;
+	/* media pad of video entity */
+	struct media_pad			pad;
+	/* video operations supported by video device */
+	const struct vpfe_video_operations	*ops;
+	/* type of the video buffers used by user */
+	enum v4l2_buf_type			type;
+	/* Indicates id of the field which is being captured */
+	u32					field_id;
+	/* pipeline for which video device is part of */
+	struct vpfe_pipeline			pipe;
+	/* Indicates whether streaming started */
+	u8					started;
+	/* Indicates state of the stream */
+	unsigned int				state;
+	/* current input at the sub device */
+	int					current_input;
+	/*
+	 * This field keeps track of type of buffer exchange mechanism
+	 * user has selected
+	 */
+	enum v4l2_memory			memory;
+	/* Used to keep track of state of the priority */
+	struct v4l2_prio_state			prio;
+	/* number of open instances of the channel */
+	u32					usrs;
+	/* flag to indicate whether decoder is initialized */
+	u8					initialized;
+	/* skip frame count */
+	u8					skip_frame_count;
+	/* skip frame count init value */
+	u8					skip_frame_count_init;
+	/* time per frame for skipping */
+	struct v4l2_fract			timeperframe;
+	/* ptr to currently selected sub device */
+	struct vpfe_ext_subdev_info		*current_ext_subdev;
+	/* Pointer pointing to current vpfe_cap_buffer */
+	struct vpfe_cap_buffer			*cur_frm;
+	/* Pointer pointing to next vpfe_cap_buffer */
+	struct vpfe_cap_buffer			*next_frm;
+	/* Used to store pixel format */
+	struct v4l2_format			fmt;
+	struct vb2_queue			buffer_queue;
+	/* allocator-specific contexts for each plane */
+	struct vb2_alloc_ctx *alloc_ctx;
+	/* Queue of filled frames */
+	struct list_head			dma_queue;
+	spinlock_t				irqlock;
+	/* IRQ lock for DMA queue */
+	spinlock_t				dma_queue_lock;
+	/* lock used to access this structure */
+	struct mutex				lock;
+	/* number of users performing IO */
+	u32					io_usrs;
+	/* Currently selected or default standard */
+	v4l2_std_id				stdid;
+	/*
+	 * offset where second field starts from the starting of the
+	 * buffer for field seperated YCbCr formats
+	 */
+	u32					field_off;
+};
+
+int vpfe_video_is_pipe_ready(struct vpfe_pipeline *pipe);
+void vpfe_video_unregister(struct vpfe_video_device *video);
+int vpfe_video_register(struct vpfe_video_device *video,
+			struct v4l2_device *vdev);
+int vpfe_video_init(struct vpfe_video_device *video, const char *name);
+void vpfe_video_process_buffer_complete(struct vpfe_video_device *video);
+void vpfe_video_schedule_bottom_field(struct vpfe_video_device *video);
+void vpfe_video_schedule_next_buffer(struct vpfe_video_device *video);
+
+#endif		/* _DAVINCI_VPFE_VIDEO_H */
-- 
1.7.4.1

