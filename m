Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34638 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaELI6v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 May 2014 04:58:51 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v4 1/2] media: davinci: vpif capture: upgrade the driver with v4l offerings
Date: Mon, 12 May 2014 14:28:29 +0530
Message-Id: <1399885110-9899-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1399885110-9899-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1399885110-9899-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch upgrades the vpif display driver with
v4l helpers, this patch does the following,

1: initialize the vb2 queue and context at the time of probe
and removes context at remove() callback.
2: uses vb2_ioctl_*() helpers.
3: uses vb2_fop_*() helpers.
4: uses SIMPLE_DEV_PM_OPS.
5: uses vb2_ioctl_*() helpers.
6: vidioc_g/s_priority is now handled by v4l core.
7: removed driver specific fh and now using one provided by v4l.
8: fixes checkpatch warnings.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---

root@da850-omapl138-evm:/usr# ./v4l2-compliance -d /dev/video0 -i -s -v
Driver Info:
        Driver name   : vpif_capture
vpif_capture vpif_capture: =================  START STATUS  =================

        Bus info      : platform:vpif_capture
        Drivervpif_capture vpif_capture: ==================  END STATUS  ==================
 version: 3.15.0
        Capabilities  : 0x84000001
                Video Capture
                Streaming
                Device Capabilities
        Device Caps   : 0x04000001
                Video Capture
                Streaming

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
        test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
        test second video open: OK
        test VIDIOC_QUERYCAP: OK
        test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
        test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
        test VIDIOC_LOG_STATUS: OK

Input ioctls:
        test VIDIOC_G/S_TUNER: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
        test VIDIOC_ENUMAUDIO: OK (Not Supported)
        test VIDIOC_G/S/ENUMINPUT: OK
        test VIDIOC_G/S_AUDIO: OK (Not Supported)
        Inputs: 1 Audio Inputs: 0 Tuners: 0

Output ioctls:
        test VIDIOC_G/S_MODULATOR: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_ENUMAUDOUT: OK (Not Supported)
        test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
        test VIDIOC_G/S_AUDOUT: OK (Not Supported)
        Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
        test VIDIOC_ENUM/G/S/QUERY_STD: OK
        test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
        test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
        test VIDIOC_G/S_EDID: OK (Not Supported)

Test input 0:

        Control ioctls:
                test VIDIOC_QUERYCTRL/MENU: OK (Not Supported)
                test VIDIOC_G/S_CTRL: OK (Not Supported)
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 0 Private Controls: 0

        Format ioctls:
                info: found 1 formats for buftype 1
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                fail: v4l2-test-formats.cpp(1003): cap->readbuffers
                test VIDIOC_G/S_PARM: FAIL
                test VIDIOC_G_FBUF: OK (Not Supported)
                fail: v4l2-test-formats.cpp(405): !pix.sizeimage
                test VIDIOC_G_FMT: FAIL
                test VIDIOC_TRY_FMT: OK (Not Supported)
                test VIDIOC_S_FMT: OK (Not Supported)
                test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

        Codec ioctls:
                test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
                test VIDIOC_G_ENC_INDEX: OK (Not Supported)
                test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
        test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
                fail: v4l2-test-buffers.cpp(506): q.has_expbuf()
        test VIDIOC_EXPBUF: FAIL

Total: 38, Succeeded: 35, Failed: 3, Warnings: 0

 drivers/media/platform/davinci/vpif_capture.c | 1471 ++++++++-----------------
 drivers/media/platform/davinci/vpif_capture.h |   43 +-
 2 files changed, 436 insertions(+), 1078 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index d09a27a..2f012aa 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2009 Texas Instruments Inc
+ * Copyright (C) 2014 Lad, Prabhakar <prabhakar.csengg@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -37,33 +38,15 @@ MODULE_VERSION(VPIF_CAPTURE_VERSION);
 #define vpif_dbg(level, debug, fmt, arg...)	\
 		v4l2_dbg(level, debug, &vpif_obj.v4l2_dev, fmt, ## arg)
 
+#define VPIF_DRIVER_NAME	"vpif_capture"
+
 static int debug = 1;
-static u32 ch0_numbuffers = 3;
-static u32 ch1_numbuffers = 3;
-static u32 ch0_bufsize = 1920 * 1080 * 2;
-static u32 ch1_bufsize = 720 * 576 * 2;
 
 module_param(debug, int, 0644);
-module_param(ch0_numbuffers, uint, S_IRUGO);
-module_param(ch1_numbuffers, uint, S_IRUGO);
-module_param(ch0_bufsize, uint, S_IRUGO);
-module_param(ch1_bufsize, uint, S_IRUGO);
 
 MODULE_PARM_DESC(debug, "Debug level 0-1");
-MODULE_PARM_DESC(ch2_numbuffers, "Channel0 buffer count (default:3)");
-MODULE_PARM_DESC(ch3_numbuffers, "Channel1 buffer count (default:3)");
-MODULE_PARM_DESC(ch2_bufsize, "Channel0 buffer size (default:1920 x 1080 x 2)");
-MODULE_PARM_DESC(ch3_bufsize, "Channel1 buffer size (default:720 x 576 x 2)");
-
-static struct vpif_config_params config_params = {
-	.min_numbuffers = 3,
-	.numbuffers[0] = 3,
-	.numbuffers[1] = 3,
-	.min_bufsize[0] = 720 * 480 * 2,
-	.min_bufsize[1] = 720 * 480 * 2,
-	.channel_bufsize[0] = 1920 * 1080 * 2,
-	.channel_bufsize[1] = 720 * 576 * 2,
-};
+
+static u8 channel_first_int[VPIF_NUMBER_OF_OBJECTS][2] = { {1, 1} };
 
 /* global variables */
 static struct vpif_device vpif_obj = { {NULL} };
@@ -71,8 +54,18 @@ static struct device *vpif_dev;
 static void vpif_calculate_offsets(struct channel_obj *ch);
 static void vpif_config_addr(struct channel_obj *ch, int muxmode);
 
+/*
+ * Is set to 1 in case of SDTV formats, 2 in case of HDTV formats.
+ */
+static int ycmux_mode;
+
+static inline struct vpif_cap_buffer *to_vpif_buffer(struct vb2_buffer *vb)
+{
+	return container_of(vb, struct vpif_cap_buffer, vb);
+}
+
 /**
- * buffer_prepare :  callback function for buffer prepare
+ * vpif_buffer_prepare :  callback function for buffer prepare
  * @vb: ptr to vb2_buffer
  *
  * This is the callback function for buffer prepare when vb2_qbuf()
@@ -81,10 +74,8 @@ static void vpif_config_addr(struct channel_obj *ch, int muxmode);
  */
 static int vpif_buffer_prepare(struct vb2_buffer *vb)
 {
-	/* Get the file handle object and channel object */
-	struct vpif_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
 	struct vb2_queue *q = vb->vb2_queue;
-	struct channel_obj *ch = fh->channel;
+	struct channel_obj *ch = vb2_get_drv_priv(q);
 	struct common_obj *common;
 	unsigned long addr;
 
@@ -92,22 +83,21 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
 
 	common = &ch->common[VPIF_VIDEO_INDEX];
 
-	if (vb->state != VB2_BUF_STATE_ACTIVE &&
-		vb->state != VB2_BUF_STATE_PREPARED) {
-		vb2_set_plane_payload(vb, 0, common->fmt.fmt.pix.sizeimage);
-		if (vb2_plane_vaddr(vb, 0) &&
-		vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
-			goto exit;
-		addr = vb2_dma_contig_plane_dma_addr(vb, 0);
-
-		if (q->streaming) {
-			if (!IS_ALIGNED((addr + common->ytop_off), 8) ||
-				!IS_ALIGNED((addr + common->ybtm_off), 8) ||
-				!IS_ALIGNED((addr + common->ctop_off), 8) ||
-				!IS_ALIGNED((addr + common->cbtm_off), 8))
-				goto exit;
-		}
+	vb2_set_plane_payload(vb, 0, common->fmt.fmt.pix.sizeimage);
+	if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
+		return -EINVAL;
+
+	vb->v4l2_buf.field = common->fmt.fmt.pix.field;
+
+	addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+
+	if (!IS_ALIGNED((addr + common->ytop_off), 8) ||
+		!IS_ALIGNED((addr + common->ybtm_off), 8) ||
+		!IS_ALIGNED((addr + common->ctop_off), 8) ||
+		!IS_ALIGNED((addr + common->cbtm_off), 8)) {
+		goto exit;
 	}
+
 	return 0;
 exit:
 	vpif_dbg(1, debug, "buffer_prepare:offset is not aligned to 8 bytes\n");
@@ -131,63 +121,36 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
-	/* Get the file handle object and channel object */
-	struct vpif_fh *fh = vb2_get_drv_priv(vq);
-	struct channel_obj *ch = fh->channel;
+	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common;
-	unsigned long size;
 
 	common = &ch->common[VPIF_VIDEO_INDEX];
 
 	vpif_dbg(2, debug, "vpif_buffer_setup\n");
 
-	/* If memory type is not mmap, return */
-	if (V4L2_MEMORY_MMAP == common->memory) {
-		/* Calculate the size of the buffer */
-		size = config_params.channel_bufsize[ch->channel_id];
-		/*
-		 * Checking if the buffer size exceeds the available buffer
-		 * ycmux_mode = 0 means 1 channel mode HD and
-		 * ycmux_mode = 1 means 2 channels mode SD
-		 */
-		if (ch->vpifparams.std_info.ycmux_mode == 0) {
-			if (config_params.video_limit[ch->channel_id])
-				while (size * *nbuffers >
-					(config_params.video_limit[0]
-						+ config_params.video_limit[1]))
-					(*nbuffers)--;
-		} else {
-			if (config_params.video_limit[ch->channel_id])
-				while (size * *nbuffers >
-				config_params.video_limit[ch->channel_id])
-					(*nbuffers)--;
-		}
-
-	} else {
-		size = common->fmt.fmt.pix.sizeimage;
-	}
-
-	if (*nbuffers < config_params.min_numbuffers)
-		*nbuffers = config_params.min_numbuffers;
+	if (vq->num_buffers + *nbuffers < 3)
+		*nbuffers = 3 - vq->num_buffers;
 
 	*nplanes = 1;
-	sizes[0] = size;
+	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : common->fmt.fmt.pix.sizeimage;
 	alloc_ctxs[0] = common->alloc_ctx;
 
+	/* Calculate the offset for Y and C data  in the buffer */
+	vpif_calculate_offsets(ch);
+
 	return 0;
 }
 
 /**
  * vpif_buffer_queue : Callback function to add buffer to DMA queue
  * @vb: ptr to vb2_buffer
+ *
+ * This callback fucntion queues the buffer to DMA engine
  */
 static void vpif_buffer_queue(struct vb2_buffer *vb)
 {
-	/* Get the file handle object and channel object */
-	struct vpif_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
-	struct channel_obj *ch = fh->channel;
-	struct vpif_cap_buffer *buf = container_of(vb,
-				struct vpif_cap_buffer, vb);
+	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2_queue);
+	struct vpif_cap_buffer *buf = to_vpif_buffer(vb);
 	struct common_obj *common;
 	unsigned long flags;
 
@@ -202,124 +165,65 @@ static void vpif_buffer_queue(struct vb2_buffer *vb)
 }
 
 /**
- * vpif_buf_cleanup : Callback function to free buffer
+ * vpif_start_streaming : Starts the DMA engine for streaming
  * @vb: ptr to vb2_buffer
- *
- * This function is called from the videobuf2 layer to free memory
- * allocated to  the buffers
+ * @count: number of buffers
  */
-static void vpif_buf_cleanup(struct vb2_buffer *vb)
-{
-	/* Get the file handle object and channel object */
-	struct vpif_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
-	struct vpif_cap_buffer *buf = container_of(vb,
-					struct vpif_cap_buffer, vb);
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common;
-	unsigned long flags;
-
-	common = &ch->common[VPIF_VIDEO_INDEX];
-
-	spin_lock_irqsave(&common->irqlock, flags);
-	if (vb->state == VB2_BUF_STATE_ACTIVE)
-		list_del_init(&buf->list);
-	spin_unlock_irqrestore(&common->irqlock, flags);
-
-}
-
-static void vpif_wait_prepare(struct vb2_queue *vq)
-{
-	struct vpif_fh *fh = vb2_get_drv_priv(vq);
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common;
-
-	common = &ch->common[VPIF_VIDEO_INDEX];
-	mutex_unlock(&common->lock);
-}
-
-static void vpif_wait_finish(struct vb2_queue *vq)
-{
-	struct vpif_fh *fh = vb2_get_drv_priv(vq);
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common;
-
-	common = &ch->common[VPIF_VIDEO_INDEX];
-	mutex_lock(&common->lock);
-}
-
-static int vpif_buffer_init(struct vb2_buffer *vb)
-{
-	struct vpif_cap_buffer *buf = container_of(vb,
-					struct vpif_cap_buffer, vb);
-
-	INIT_LIST_HEAD(&buf->list);
-
-	return 0;
-}
-
-static u8 channel_first_int[VPIF_NUMBER_OF_OBJECTS][2] =
-	{ {1, 1} };
-
 static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
-	struct vpif_capture_config *vpif_config_data =
-					vpif_dev->platform_data;
-	struct vpif_fh *fh = vb2_get_drv_priv(vq);
-	struct channel_obj *ch = fh->channel;
+	struct vpif_capture_config *vpif_config_data;
+	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct vpif_params *vpif = &ch->vpifparams;
-	unsigned long addr = 0;
-	unsigned long flags;
+	struct vpif_cap_buffer *buf, *tmp;
+	unsigned long addr, flags;
 	int ret;
 
 	spin_lock_irqsave(&common->irqlock, flags);
 
-	/* Get the next frame from the buffer queue */
-	common->cur_frm = common->next_frm = list_entry(common->dma_queue.next,
-				    struct vpif_cap_buffer, list);
-	/* Remove buffer from the buffer queue */
-	list_del(&common->cur_frm->list);
-	spin_unlock_irqrestore(&common->irqlock, flags);
-	/* Mark state of the current frame to active */
-	common->cur_frm->vb.state = VB2_BUF_STATE_ACTIVE;
-	/* Initialize field_id and started member */
+	/* Initialize field_id */
 	ch->field_id = 0;
-	common->started = 1;
-	addr = vb2_dma_contig_plane_dma_addr(&common->cur_frm->vb, 0);
-
-	/* Calculate the offset for Y and C data in the buffer */
-	vpif_calculate_offsets(ch);
-
-	if ((vpif->std_info.frm_fmt &&
-	    ((common->fmt.fmt.pix.field != V4L2_FIELD_NONE) &&
-	     (common->fmt.fmt.pix.field != V4L2_FIELD_ANY))) ||
-	    (!vpif->std_info.frm_fmt &&
-	     (common->fmt.fmt.pix.field == V4L2_FIELD_NONE))) {
-		vpif_dbg(1, debug, "conflict in field format and std format\n");
-		return -EINVAL;
-	}
 
+	vpif_config_data = vpif_dev->platform_data;
 	/* configure 1 or 2 channel mode */
 	if (vpif_config_data->setup_input_channel_mode) {
 		ret = vpif_config_data->
 			setup_input_channel_mode(vpif->std_info.ycmux_mode);
 		if (ret < 0) {
 			vpif_dbg(1, debug, "can't set vpif channel mode\n");
-			return ret;
+			ret = -EINVAL;
+			goto err;
 		}
 	}
 
+	ret = v4l2_subdev_call(ch->sd, video, s_stream, 1);
+
+	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV) {
+		vpif_dbg(1, debug, "stream on failed in subdev\n");
+		goto err;
+	}
+
 	/* Call vpif_set_params function to set the parameters and addresses */
 	ret = vpif_set_video_params(vpif, ch->channel_id);
-
 	if (ret < 0) {
 		vpif_dbg(1, debug, "can't set video params\n");
-		return ret;
+		ret = -EINVAL;
+		goto err;
 	}
-
-	common->started = ret;
+	ycmux_mode = ret;
 	vpif_config_addr(ch, ret);
 
+	/* Get the next frame from the buffer queue */
+	common->cur_frm = common->next_frm = list_entry(common->dma_queue.next,
+				    struct vpif_cap_buffer, list);
+	/* Remove buffer from the buffer queue */
+	list_del(&common->cur_frm->list);
+	spin_unlock_irqrestore(&common->irqlock, flags);
+	/* Mark state of the current frame to active */
+	common->cur_frm->vb.state = VB2_BUF_STATE_ACTIVE;
+
+	addr = vb2_dma_contig_plane_dma_addr(&common->cur_frm->vb, 0);
+
 	common->set_addr(addr + common->ytop_off,
 			 addr + common->ybtm_off,
 			 addr + common->ctop_off,
@@ -330,31 +234,41 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	 * VPIF register
 	 */
 	channel_first_int[VPIF_VIDEO_INDEX][ch->channel_id] = 1;
-	if ((VPIF_CHANNEL0_VIDEO == ch->channel_id)) {
+	if (VPIF_CHANNEL0_VIDEO == ch->channel_id) {
 		channel0_intr_assert();
 		channel0_intr_enable(1);
 		enable_channel0(1);
 	}
-	if ((VPIF_CHANNEL1_VIDEO == ch->channel_id) ||
-	    (common->started == 2)) {
+	if (VPIF_CHANNEL1_VIDEO == ch->channel_id || ycmux_mode == 2) {
 		channel1_intr_assert();
 		channel1_intr_enable(1);
 		enable_channel1(1);
 	}
 
 	return 0;
+
+err:
+	list_for_each_entry_safe(buf, tmp, &common->dma_queue, list) {
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+	}
+
+	return ret;
 }
 
-/* abort streaming and wait for last buffer */
+/**
+ * vpif_stop_streaming : Stop the DMA engine
+ * @vq: ptr to vb2_queue
+ *
+ * This callback stops the DMA engine and any remaining buffers
+ * in the DMA queue are released.
+*/
 static void vpif_stop_streaming(struct vb2_queue *vq)
 {
-	struct vpif_fh *fh = vb2_get_drv_priv(vq);
-	struct channel_obj *ch = fh->channel;
+	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common;
 	unsigned long flags;
-
-	if (!vb2_is_streaming(vq))
-		return;
+	int ret;
 
 	common = &ch->common[VPIF_VIDEO_INDEX];
 
@@ -363,12 +277,17 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 		enable_channel0(0);
 		channel0_intr_enable(0);
 	}
-	if ((VPIF_CHANNEL1_VIDEO == ch->channel_id) ||
-		(2 == common->started)) {
+	if (VPIF_CHANNEL1_VIDEO == ch->channel_id || ycmux_mode == 2) {
 		enable_channel1(0);
 		channel1_intr_enable(0);
 	}
-	common->started = 0;
+
+	ycmux_mode = 0;
+
+	ret = v4l2_subdev_call(ch->sd, video, s_stream, 0);
+
+	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV)
+		vpif_dbg(1, debug, "stream off failed in subdev\n");
 
 	/* release all active buffers */
 	spin_lock_irqsave(&common->irqlock, flags);
@@ -394,13 +313,11 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 
 static struct vb2_ops video_qops = {
 	.queue_setup		= vpif_buffer_queue_setup,
-	.wait_prepare		= vpif_wait_prepare,
-	.wait_finish		= vpif_wait_finish,
-	.buf_init		= vpif_buffer_init,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 	.buf_prepare		= vpif_buffer_prepare,
 	.start_streaming	= vpif_start_streaming,
 	.stop_streaming		= vpif_stop_streaming,
-	.buf_cleanup		= vpif_buf_cleanup,
 	.buf_queue		= vpif_buffer_queue,
 };
 
@@ -415,8 +332,7 @@ static struct vb2_ops video_qops = {
 static void vpif_process_buffer_complete(struct common_obj *common)
 {
 	v4l2_get_timestamp(&common->cur_frm->vb.v4l2_buf.timestamp);
-	vb2_buffer_done(&common->cur_frm->vb,
-					    VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&common->cur_frm->vb, VB2_BUF_STATE_DONE);
 	/* Make curFrm pointing to nextFrm */
 	common->cur_frm = common->next_frm;
 }
@@ -431,7 +347,7 @@ static void vpif_process_buffer_complete(struct common_obj *common)
  */
 static void vpif_schedule_next_buffer(struct common_obj *common)
 {
-	unsigned long addr = 0;
+	unsigned long addr;
 
 	spin_lock(&common->irqlock);
 	common->next_frm = list_entry(common->dma_queue.next,
@@ -476,9 +392,6 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 
 	for (i = 0; i < VPIF_NUMBER_OF_OBJECTS; i++) {
 		common = &ch->common[i];
-		/* skip If streaming is not started in this channel */
-		if (0 == common->started)
-			continue;
 
 		/* Check the field format */
 		if (1 == ch->vpifparams.std_info.frm_fmt) {
@@ -615,21 +528,15 @@ static void vpif_calculate_offsets(struct channel_obj *ch)
 
 	vpif_dbg(2, debug, "vpif_calculate_offsets\n");
 
-	if (V4L2_FIELD_ANY == field) {
-		if (vpifparams->std_info.frm_fmt)
-			vid_ch->buf_field = V4L2_FIELD_NONE;
-		else
-			vid_ch->buf_field = V4L2_FIELD_INTERLACED;
-	} else
-		vid_ch->buf_field = common->fmt.fmt.pix.field;
+	vid_ch->buf_field = common->fmt.fmt.pix.field;
 
 	sizeimage = common->fmt.fmt.pix.sizeimage;
 
 	hpitch = common->fmt.fmt.pix.bytesperline;
 	vpitch = sizeimage / (hpitch * 2);
 
-	if ((V4L2_FIELD_NONE == vid_ch->buf_field) ||
-	    (V4L2_FIELD_INTERLACED == vid_ch->buf_field)) {
+	if (V4L2_FIELD_NONE == vid_ch->buf_field ||
+		V4L2_FIELD_INTERLACED == vid_ch->buf_field) {
 		/* Calculate offsets for Y top, Y Bottom, C top and C Bottom */
 		common->ytop_off = 0;
 		common->ybtm_off = hpitch;
@@ -648,599 +555,76 @@ static void vpif_calculate_offsets(struct channel_obj *ch)
 		common->cbtm_off = sizeimage / 2;
 		common->ctop_off = common->cbtm_off + sizeimage / 4;
 	}
-	if ((V4L2_FIELD_NONE == vid_ch->buf_field) ||
-	    (V4L2_FIELD_INTERLACED == vid_ch->buf_field))
+	if (V4L2_FIELD_NONE == vid_ch->buf_field ||
+		V4L2_FIELD_INTERLACED == vid_ch->buf_field)
 		vpifparams->video_params.storage_mode = 1;
 	else
 		vpifparams->video_params.storage_mode = 0;
 
-	if (1 == vpifparams->std_info.frm_fmt)
-		vpifparams->video_params.hpitch =
-		    common->fmt.fmt.pix.bytesperline;
-	else {
-		if ((field == V4L2_FIELD_ANY)
-		    || (field == V4L2_FIELD_INTERLACED))
-			vpifparams->video_params.hpitch =
-			    common->fmt.fmt.pix.bytesperline * 2;
-		else
-			vpifparams->video_params.hpitch =
-			    common->fmt.fmt.pix.bytesperline;
-	}
-
-	ch->vpifparams.video_params.stdid = vpifparams->std_info.stdid;
-}
-
-/**
- * vpif_config_format: configure default frame format in the device
- * ch : ptr to channel object
- */
-static void vpif_config_format(struct channel_obj *ch)
-{
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-
-	vpif_dbg(2, debug, "vpif_config_format\n");
-
-	common->fmt.fmt.pix.field = V4L2_FIELD_ANY;
-	if (config_params.numbuffers[ch->channel_id] == 0)
-		common->memory = V4L2_MEMORY_USERPTR;
-	else
-		common->memory = V4L2_MEMORY_MMAP;
-
-	common->fmt.fmt.pix.sizeimage
-	    = config_params.channel_bufsize[ch->channel_id];
-
-	if (ch->vpifparams.iface.if_type == VPIF_IF_RAW_BAYER)
-		common->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_SBGGR8;
-	else
-		common->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV422P;
-	common->fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-}
-
-/**
- * vpif_get_default_field() - Get default field type based on interface
- * @vpif_params - ptr to vpif params
- */
-static inline enum v4l2_field vpif_get_default_field(
-				struct vpif_interface *iface)
-{
-	return (iface->if_type == VPIF_IF_RAW_BAYER) ? V4L2_FIELD_NONE :
-						V4L2_FIELD_INTERLACED;
-}
-
-/**
- * vpif_check_format()  - check given pixel format for compatibility
- * @ch - channel  ptr
- * @pixfmt - Given pixel format
- * @update - update the values as per hardware requirement
- *
- * Check the application pixel format for S_FMT and update the input
- * values as per hardware limits for TRY_FMT. The default pixel and
- * field format is selected based on interface type.
- */
-static int vpif_check_format(struct channel_obj *ch,
-			     struct v4l2_pix_format *pixfmt,
-			     int update)
-{
-	struct common_obj *common = &(ch->common[VPIF_VIDEO_INDEX]);
-	struct vpif_params *vpif_params = &ch->vpifparams;
-	enum v4l2_field field = pixfmt->field;
-	u32 sizeimage, hpitch, vpitch;
-	int ret = -EINVAL;
-
-	vpif_dbg(2, debug, "vpif_check_format\n");
-	/**
-	 * first check for the pixel format. If if_type is Raw bayer,
-	 * only V4L2_PIX_FMT_SBGGR8 format is supported. Otherwise only
-	 * V4L2_PIX_FMT_YUV422P is supported
-	 */
-	if (vpif_params->iface.if_type == VPIF_IF_RAW_BAYER) {
-		if (pixfmt->pixelformat != V4L2_PIX_FMT_SBGGR8) {
-			if (!update) {
-				vpif_dbg(2, debug, "invalid pix format\n");
-				goto exit;
-			}
-			pixfmt->pixelformat = V4L2_PIX_FMT_SBGGR8;
-		}
-	} else {
-		if (pixfmt->pixelformat != V4L2_PIX_FMT_YUV422P) {
-			if (!update) {
-				vpif_dbg(2, debug, "invalid pixel format\n");
-				goto exit;
-			}
-			pixfmt->pixelformat = V4L2_PIX_FMT_YUV422P;
-		}
-	}
-
-	if (!(VPIF_VALID_FIELD(field))) {
-		if (!update) {
-			vpif_dbg(2, debug, "invalid field format\n");
-			goto exit;
-		}
-		/**
-		 * By default use FIELD_NONE for RAW Bayer capture
-		 * and FIELD_INTERLACED for other interfaces
-		 */
-		field = vpif_get_default_field(&vpif_params->iface);
-	} else if (field == V4L2_FIELD_ANY)
-		/* unsupported field. Use default */
-		field = vpif_get_default_field(&vpif_params->iface);
-
-	/* validate the hpitch */
-	hpitch = pixfmt->bytesperline;
-	if (hpitch < vpif_params->std_info.width) {
-		if (!update) {
-			vpif_dbg(2, debug, "invalid hpitch\n");
-			goto exit;
-		}
-		hpitch = vpif_params->std_info.width;
-	}
-
-	sizeimage = pixfmt->sizeimage;
-
-	vpitch = sizeimage / (hpitch * 2);
-
-	/* validate the vpitch */
-	if (vpitch < vpif_params->std_info.height) {
-		if (!update) {
-			vpif_dbg(2, debug, "Invalid vpitch\n");
-			goto exit;
-		}
-		vpitch = vpif_params->std_info.height;
-	}
-
-	/* Check for 8 byte alignment */
-	if (!ALIGN(hpitch, 8)) {
-		if (!update) {
-			vpif_dbg(2, debug, "invalid pitch alignment\n");
-			goto exit;
-		}
-		/* adjust to next 8 byte boundary */
-		hpitch = (((hpitch + 7) / 8) * 8);
-	}
-	/* if update is set, modify the bytesperline and sizeimage */
-	if (update) {
-		pixfmt->bytesperline = hpitch;
-		pixfmt->sizeimage = hpitch * vpitch * 2;
-	}
-	/**
-	 * Image width and height is always based on current standard width and
-	 * height
-	 */
-	pixfmt->width = common->fmt.fmt.pix.width;
-	pixfmt->height = common->fmt.fmt.pix.height;
-	return 0;
-exit:
-	return ret;
-}
-
-/**
- * vpif_config_addr() - function to configure buffer address in vpif
- * @ch - channel ptr
- * @muxmode - channel mux mode
- */
-static void vpif_config_addr(struct channel_obj *ch, int muxmode)
-{
-	struct common_obj *common;
-
-	vpif_dbg(2, debug, "vpif_config_addr\n");
-
-	common = &(ch->common[VPIF_VIDEO_INDEX]);
-
-	if (VPIF_CHANNEL1_VIDEO == ch->channel_id)
-		common->set_addr = ch1_set_videobuf_addr;
-	else if (2 == muxmode)
-		common->set_addr = ch0_set_videobuf_addr_yc_nmux;
-	else
-		common->set_addr = ch0_set_videobuf_addr;
-}
-
-/**
- * vpif_mmap : It is used to map kernel space buffers into user spaces
- * @filep: file pointer
- * @vma: ptr to vm_area_struct
- */
-static int vpif_mmap(struct file *filep, struct vm_area_struct *vma)
-{
-	/* Get the channel object and file handle object */
-	struct vpif_fh *fh = filep->private_data;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &(ch->common[VPIF_VIDEO_INDEX]);
-	int ret;
-
-	vpif_dbg(2, debug, "vpif_mmap\n");
-
-	if (mutex_lock_interruptible(&common->lock))
-		return -ERESTARTSYS;
-	ret = vb2_mmap(&common->buffer_queue, vma);
-	mutex_unlock(&common->lock);
-	return ret;
-}
-
-/**
- * vpif_poll: It is used for select/poll system call
- * @filep: file pointer
- * @wait: poll table to wait
- */
-static unsigned int vpif_poll(struct file *filep, poll_table * wait)
-{
-	struct vpif_fh *fh = filep->private_data;
-	struct channel_obj *channel = fh->channel;
-	struct common_obj *common = &(channel->common[VPIF_VIDEO_INDEX]);
-	unsigned int res = 0;
-
-	vpif_dbg(2, debug, "vpif_poll\n");
-
-	if (common->started) {
-		mutex_lock(&common->lock);
-		res = vb2_poll(&common->buffer_queue, filep, wait);
-		mutex_unlock(&common->lock);
-	}
-	return res;
-}
-
-/**
- * vpif_open : vpif open handler
- * @filep: file ptr
- *
- * It creates object of file handle structure and stores it in private_data
- * member of filepointer
- */
-static int vpif_open(struct file *filep)
-{
-	struct video_device *vdev = video_devdata(filep);
-	struct common_obj *common;
-	struct video_obj *vid_ch;
-	struct channel_obj *ch;
-	struct vpif_fh *fh;
-
-	vpif_dbg(2, debug, "vpif_open\n");
-
-	ch = video_get_drvdata(vdev);
-
-	vid_ch = &ch->video;
-	common = &ch->common[VPIF_VIDEO_INDEX];
-
-	/* Allocate memory for the file handle object */
-	fh = kzalloc(sizeof(struct vpif_fh), GFP_KERNEL);
-	if (NULL == fh) {
-		vpif_err("unable to allocate memory for file handle object\n");
-		return -ENOMEM;
-	}
-
-	if (mutex_lock_interruptible(&common->lock)) {
-		kfree(fh);
-		return -ERESTARTSYS;
-	}
-	/* store pointer to fh in private_data member of filep */
-	filep->private_data = fh;
-	fh->channel = ch;
-	fh->initialized = 0;
-	/* If decoder is not initialized. initialize it */
-	if (!ch->initialized) {
-		fh->initialized = 1;
-		ch->initialized = 1;
-		memset(&(ch->vpifparams), 0, sizeof(struct vpif_params));
-	}
-	/* Increment channel usrs counter */
-	ch->usrs++;
-	/* Set io_allowed member to false */
-	fh->io_allowed[VPIF_VIDEO_INDEX] = 0;
-	/* Initialize priority of this instance to default priority */
-	fh->prio = V4L2_PRIORITY_UNSET;
-	v4l2_prio_open(&ch->prio, &fh->prio);
-	mutex_unlock(&common->lock);
-	return 0;
-}
-
-/**
- * vpif_release : function to clean up file close
- * @filep: file pointer
- *
- * This function deletes buffer queue, frees the buffers and the vpif file
- * handle
- */
-static int vpif_release(struct file *filep)
-{
-	struct vpif_fh *fh = filep->private_data;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common;
-
-	vpif_dbg(2, debug, "vpif_release\n");
-
-	common = &ch->common[VPIF_VIDEO_INDEX];
-
-	mutex_lock(&common->lock);
-	/* if this instance is doing IO */
-	if (fh->io_allowed[VPIF_VIDEO_INDEX]) {
-		/* Reset io_usrs member of channel object */
-		common->io_usrs = 0;
-		/* Free buffers allocated */
-		vb2_queue_release(&common->buffer_queue);
-		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
-	}
-
-	/* Decrement channel usrs counter */
-	ch->usrs--;
-
-	/* Close the priority */
-	v4l2_prio_close(&ch->prio, fh->prio);
-
-	if (fh->initialized)
-		ch->initialized = 0;
-
-	mutex_unlock(&common->lock);
-	filep->private_data = NULL;
-	kfree(fh);
-	return 0;
-}
-
-/**
- * vpif_reqbufs() - request buffer handler
- * @file: file ptr
- * @priv: file handle
- * @reqbuf: request buffer structure ptr
- */
-static int vpif_reqbufs(struct file *file, void *priv,
-			struct v4l2_requestbuffers *reqbuf)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common;
-	u8 index = 0;
-	struct vb2_queue *q;
-	int ret;
-
-	vpif_dbg(2, debug, "vpif_reqbufs\n");
-
-	/**
-	 * This file handle has not initialized the channel,
-	 * It is not allowed to do settings
-	 */
-	if ((VPIF_CHANNEL0_VIDEO == ch->channel_id)
-	    || (VPIF_CHANNEL1_VIDEO == ch->channel_id)) {
-		if (!fh->initialized) {
-			vpif_dbg(1, debug, "Channel Busy\n");
-			return -EBUSY;
-		}
-	}
-
-	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != reqbuf->type || !vpif_dev)
-		return -EINVAL;
-
-	index = VPIF_VIDEO_INDEX;
-
-	common = &ch->common[index];
-
-	if (0 != common->io_usrs)
-		return -EBUSY;
-
-	/* Initialize videobuf2 queue as per the buffer type */
-	common->alloc_ctx = vb2_dma_contig_init_ctx(vpif_dev);
-	if (IS_ERR(common->alloc_ctx)) {
-		vpif_err("Failed to get the context\n");
-		return PTR_ERR(common->alloc_ctx);
-	}
-	q = &common->buffer_queue;
-	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	q->io_modes = VB2_MMAP | VB2_USERPTR;
-	q->drv_priv = fh;
-	q->ops = &video_qops;
-	q->mem_ops = &vb2_dma_contig_memops;
-	q->buf_struct_size = sizeof(struct vpif_cap_buffer);
-	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	q->min_buffers_needed = 1;
-
-	ret = vb2_queue_init(q);
-	if (ret) {
-		vpif_err("vpif_capture: vb2_queue_init() failed\n");
-		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
-		return ret;
-	}
-	/* Set io allowed member of file handle to TRUE */
-	fh->io_allowed[index] = 1;
-	/* Increment io usrs member of channel object to 1 */
-	common->io_usrs = 1;
-	/* Store type of memory requested in channel object */
-	common->memory = reqbuf->memory;
-	INIT_LIST_HEAD(&common->dma_queue);
-
-	/* Allocate buffers */
-	return vb2_reqbufs(&common->buffer_queue, reqbuf);
-}
-
-/**
- * vpif_querybuf() - query buffer handler
- * @file: file ptr
- * @priv: file handle
- * @buf: v4l2 buffer structure ptr
- */
-static int vpif_querybuf(struct file *file, void *priv,
-				struct v4l2_buffer *buf)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-
-	vpif_dbg(2, debug, "vpif_querybuf\n");
-
-	if (common->fmt.type != buf->type)
-		return -EINVAL;
-
-	if (common->memory != V4L2_MEMORY_MMAP) {
-		vpif_dbg(1, debug, "Invalid memory\n");
-		return -EINVAL;
-	}
-
-	return vb2_querybuf(&common->buffer_queue, buf);
-}
-
-/**
- * vpif_qbuf() - query buffer handler
- * @file: file ptr
- * @priv: file handle
- * @buf: v4l2 buffer structure ptr
- */
-static int vpif_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
-{
-
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	struct v4l2_buffer tbuf = *buf;
-
-	vpif_dbg(2, debug, "vpif_qbuf\n");
-
-	if (common->fmt.type != tbuf.type) {
-		vpif_err("invalid buffer type\n");
-		return -EINVAL;
-	}
-
-	if (!fh->io_allowed[VPIF_VIDEO_INDEX]) {
-		vpif_err("fh io not allowed\n");
-		return -EACCES;
-	}
-
-	return vb2_qbuf(&common->buffer_queue, buf);
-}
-
-/**
- * vpif_dqbuf() - query buffer handler
- * @file: file ptr
- * @priv: file handle
- * @buf: v4l2 buffer structure ptr
- */
-static int vpif_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-
-	vpif_dbg(2, debug, "vpif_dqbuf\n");
-
-	return vb2_dqbuf(&common->buffer_queue, buf,
-			 (file->f_flags & O_NONBLOCK));
-}
-
-/**
- * vpif_streamon() - streamon handler
- * @file: file ptr
- * @priv: file handle
- * @buftype: v4l2 buffer type
- */
-static int vpif_streamon(struct file *file, void *priv,
-				enum v4l2_buf_type buftype)
-{
-
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	struct channel_obj *oth_ch = vpif_obj.dev[!ch->channel_id];
-	struct vpif_params *vpif;
-	int ret = 0;
-
-	vpif_dbg(2, debug, "vpif_streamon\n");
-
-	vpif = &ch->vpifparams;
-
-	if (buftype != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		vpif_dbg(1, debug, "buffer type not supported\n");
-		return -EINVAL;
-	}
-
-	/* If file handle is not allowed IO, return error */
-	if (!fh->io_allowed[VPIF_VIDEO_INDEX]) {
-		vpif_dbg(1, debug, "io not allowed\n");
-		return -EACCES;
-	}
-
-	/* If Streaming is already started, return error */
-	if (common->started) {
-		vpif_dbg(1, debug, "channel->started\n");
-		return -EBUSY;
-	}
-
-	if ((ch->channel_id == VPIF_CHANNEL0_VIDEO &&
-	    oth_ch->common[VPIF_VIDEO_INDEX].started &&
-	    vpif->std_info.ycmux_mode == 0) ||
-	   ((ch->channel_id == VPIF_CHANNEL1_VIDEO) &&
-	    (2 == oth_ch->common[VPIF_VIDEO_INDEX].started))) {
-		vpif_dbg(1, debug, "other channel is being used\n");
-		return -EBUSY;
-	}
-
-	ret = vpif_check_format(ch, &common->fmt.fmt.pix, 0);
-	if (ret)
-		return ret;
-
-	/* Enable streamon on the sub device */
-	ret = v4l2_subdev_call(ch->sd, video, s_stream, 1);
-
-	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV) {
-		vpif_dbg(1, debug, "stream on failed in subdev\n");
-		return ret;
-	}
-
-	/* Call vb2_streamon to start streaming in videobuf2 */
-	ret = vb2_streamon(&common->buffer_queue, buftype);
-	if (ret) {
-		vpif_dbg(1, debug, "vb2_streamon\n");
-		return ret;
+	if (vpifparams->std_info.frm_fmt == 1)
+		vpifparams->video_params.hpitch =
+		    common->fmt.fmt.pix.bytesperline;
+	else {
+		if (field == V4L2_FIELD_ANY ||
+			field == V4L2_FIELD_INTERLACED)
+			vpifparams->video_params.hpitch =
+			    common->fmt.fmt.pix.bytesperline * 2;
+		else
+			vpifparams->video_params.hpitch =
+			    common->fmt.fmt.pix.bytesperline;
 	}
 
-	return ret;
+	ch->vpifparams.video_params.stdid = vpifparams->std_info.stdid;
 }
 
 /**
- * vpif_streamoff() - streamoff handler
- * @file: file ptr
- * @priv: file handle
- * @buftype: v4l2 buffer type
+ * vpif_config_format: configure default frame format in the device
+ * ch : ptr to channel object
  */
-static int vpif_streamoff(struct file *file, void *priv,
-				enum v4l2_buf_type buftype)
+static void vpif_config_format(struct channel_obj *ch)
 {
-
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	int ret;
-
-	vpif_dbg(2, debug, "vpif_streamoff\n");
 
-	if (buftype != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		vpif_dbg(1, debug, "buffer type not supported\n");
-		return -EINVAL;
-	}
+	vpif_dbg(2, debug, "vpif_config_format\n");
 
-	/* If io is allowed for this file handle, return error */
-	if (!fh->io_allowed[VPIF_VIDEO_INDEX]) {
-		vpif_dbg(1, debug, "io not allowed\n");
-		return -EACCES;
-	}
+	if (ch->vpifparams.iface.if_type == VPIF_IF_RAW_BAYER)
+		common->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_SBGGR8;
+	else
+		common->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV422P;
 
-	/* If streaming is not started, return error */
-	if (!common->started) {
-		vpif_dbg(1, debug, "channel->started\n");
-		return -EINVAL;
-	}
+	common->fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+}
 
-	/* disable channel */
-	if (VPIF_CHANNEL0_VIDEO == ch->channel_id) {
-		enable_channel0(0);
-		channel0_intr_enable(0);
-	} else {
-		enable_channel1(0);
-		channel1_intr_enable(0);
-	}
+/**
+ * vpif_get_default_field() - Get default field type based on interface
+ * @vpif_params - ptr to vpif params
+ */
+static inline enum v4l2_field vpif_get_default_field(
+				struct vpif_interface *iface)
+{
+	return (iface->if_type == VPIF_IF_RAW_BAYER) ? V4L2_FIELD_NONE :
+						V4L2_FIELD_INTERLACED;
+}
 
-	common->started = 0;
+/**
+ * vpif_config_addr() - function to configure buffer address in vpif
+ * @ch - channel ptr
+ * @muxmode - channel mux mode
+ */
+static void vpif_config_addr(struct channel_obj *ch, int muxmode)
+{
+	struct common_obj *common;
 
-	ret = v4l2_subdev_call(ch->sd, video, s_stream, 0);
+	vpif_dbg(2, debug, "vpif_config_addr\n");
 
-	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV)
-		vpif_dbg(1, debug, "stream off failed in subdev\n");
+	common = &(ch->common[VPIF_VIDEO_INDEX]);
 
-	return vb2_streamoff(&common->buffer_queue, buftype);
+	if (VPIF_CHANNEL1_VIDEO == ch->channel_id)
+		common->set_addr = ch1_set_videobuf_addr;
+	else if (2 == muxmode)
+		common->set_addr = ch0_set_videobuf_addr_yc_nmux;
+	else
+		common->set_addr = ch0_set_videobuf_addr;
 }
 
 /**
@@ -1346,9 +730,9 @@ static int vpif_set_input(
  */
 static int vpif_querystd(struct file *file, void *priv, v4l2_std_id *std_id)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-	int ret = 0;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
+	int ret;
 
 	vpif_dbg(2, debug, "vpif_querystd\n");
 
@@ -1373,11 +757,22 @@ static int vpif_querystd(struct file *file, void *priv, v4l2_std_id *std_id)
  */
 static int vpif_g_std(struct file *file, void *priv, v4l2_std_id *std)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct vpif_capture_config *config = vpif_dev->platform_data;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
+	struct vpif_capture_chan_config *chan_cfg;
+	struct v4l2_input input;
 
 	vpif_dbg(2, debug, "vpif_g_std\n");
 
+	if (config->chan_config[ch->channel_id].inputs == NULL)
+		return -ENODATA;
+
+	chan_cfg = &config->chan_config[ch->channel_id];
+	input = chan_cfg->inputs[ch->input_idx].input;
+	if (input.capabilities != V4L2_IN_CAP_STD)
+		return -ENODATA;
+
 	*std = ch->video.stdid;
 	return 0;
 }
@@ -1390,31 +785,26 @@ static int vpif_g_std(struct file *file, void *priv, v4l2_std_id *std)
  */
 static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct vpif_capture_config *config = vpif_dev->platform_data;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	int ret = 0;
+	struct vpif_capture_chan_config *chan_cfg;
+	struct v4l2_input input;
+	int ret;
 
 	vpif_dbg(2, debug, "vpif_s_std\n");
 
-	if (common->started) {
-		vpif_err("streaming in progress\n");
-		return -EBUSY;
-	}
-
-	if ((VPIF_CHANNEL0_VIDEO == ch->channel_id) ||
-	    (VPIF_CHANNEL1_VIDEO == ch->channel_id)) {
-		if (!fh->initialized) {
-			vpif_dbg(1, debug, "Channel Busy\n");
-			return -EBUSY;
-		}
-	}
+	if (config->chan_config[ch->channel_id].inputs == NULL)
+		return -ENODATA;
 
-	ret = v4l2_prio_check(&ch->prio, fh->prio);
-	if (0 != ret)
-		return ret;
+	chan_cfg = &config->chan_config[ch->channel_id];
+	input = chan_cfg->inputs[ch->input_idx].input;
+	if (input.capabilities != V4L2_IN_CAP_STD)
+		return -ENODATA;
 
-	fh->initialized = 1;
+	if (vb2_is_busy(&common->buffer_queue))
+		return -EBUSY;
 
 	/* Call encoder subdevice function to set the standard */
 	ch->video.stdid = std_id;
@@ -1450,8 +840,11 @@ static int vpif_enum_input(struct file *file, void *priv,
 
 	struct vpif_capture_config *config = vpif_dev->platform_data;
 	struct vpif_capture_chan_config *chan_cfg;
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
+
+	if (config->chan_config[ch->channel_id].inputs == NULL)
+		return -ENODATA;
 
 	chan_cfg = &config->chan_config[ch->channel_id];
 
@@ -1473,8 +866,8 @@ static int vpif_enum_input(struct file *file, void *priv,
  */
 static int vpif_g_input(struct file *file, void *priv, unsigned int *index)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 
 	*index = ch->input_idx;
 	return 0;
@@ -1490,34 +883,18 @@ static int vpif_s_input(struct file *file, void *priv, unsigned int index)
 {
 	struct vpif_capture_config *config = vpif_dev->platform_data;
 	struct vpif_capture_chan_config *chan_cfg;
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	int ret;
+
+	if (vb2_is_busy(&common->buffer_queue))
+		return -EBUSY;
 
 	chan_cfg = &config->chan_config[ch->channel_id];
 
 	if (index >= chan_cfg->input_count)
 		return -EINVAL;
 
-	if (common->started) {
-		vpif_err("Streaming in progress\n");
-		return -EBUSY;
-	}
-
-	if ((VPIF_CHANNEL0_VIDEO == ch->channel_id) ||
-	    (VPIF_CHANNEL1_VIDEO == ch->channel_id)) {
-		if (!fh->initialized) {
-			vpif_dbg(1, debug, "Channel Busy\n");
-			return -EBUSY;
-		}
-	}
-
-	ret = v4l2_prio_check(&ch->prio, fh->prio);
-	if (0 != ret)
-		return ret;
-
-	fh->initialized = 1;
 	return vpif_set_input(config, ch, index);
 }
 
@@ -1530,8 +907,8 @@ static int vpif_s_input(struct file *file, void *priv, unsigned int index)
 static int vpif_enum_fmt_vid_cap(struct file *file, void  *priv,
 					struct v4l2_fmtdesc *fmt)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 
 	if (fmt->index != 0) {
 		vpif_dbg(1, debug, "Invalid format index\n");
@@ -1551,6 +928,51 @@ static int vpif_enum_fmt_vid_cap(struct file *file, void  *priv,
 	return 0;
 }
 
+static void vpif_fill_pix_format(struct video_device *vdev,
+				 struct v4l2_pix_format *pixfmt)
+{
+	struct channel_obj *ch = video_get_drvdata(vdev);
+	struct vpif_params *vpif_params = &ch->vpifparams;
+	struct common_obj *common = &(ch->common[VPIF_VIDEO_INDEX]);
+	u32 sizeimage, hpitch, vpitch;
+
+	/* validate the hpitch */
+	hpitch = pixfmt->bytesperline;
+	if (hpitch < vpif_params->std_info.width)
+		hpitch = vpif_params->std_info.width;
+
+	if (ch->video.stdid)
+		pixfmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	else
+		pixfmt->colorspace = V4L2_COLORSPACE_REC709;
+
+	sizeimage = pixfmt->sizeimage;
+
+	vpitch = sizeimage / (hpitch * 2);
+
+	/* validate the vpitch */
+	if (vpitch < vpif_params->std_info.height)
+		vpitch = vpif_params->std_info.height;
+
+	/* Check for 8 byte alignment */
+	if (!ALIGN(hpitch, 8))
+		/* adjust to next 8 byte boundary */
+		hpitch = (((hpitch + 7) / 8) * 8);
+
+	pixfmt->bytesperline = hpitch;
+	pixfmt->sizeimage = hpitch * vpitch * 2;
+
+	pixfmt->width = common->fmt.fmt.pix.width;
+	pixfmt->height = common->fmt.fmt.pix.height;
+
+	if (pixfmt->field == V4L2_FIELD_ANY) {
+		if (vpif_params->std_info.frm_fmt)
+			common->fmt.fmt.pix.field = V4L2_FIELD_NONE;
+		else
+			common->fmt.fmt.pix.field = V4L2_FIELD_INTERLACED;
+	}
+}
+
 /**
  * vpif_try_fmt_vid_cap() - TRY_FMT handler
  * @file: file ptr
@@ -1560,11 +982,26 @@ static int vpif_enum_fmt_vid_cap(struct file *file, void  *priv,
 static int vpif_try_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
+	struct vpif_params *vpif_params = &ch->vpifparams;
+
+	vpif_dbg(2, debug, "vpif_try_fmt_vid_cap\n");
+	/**
+	 * first check for the pixel format. If if_type is Raw bayer,
+	 * only V4L2_PIX_FMT_SBGGR8 format is supported. Otherwise only
+	 * V4L2_PIX_FMT_YUV422P is supported
+	 */
+	if (vpif_params->iface.if_type == VPIF_IF_RAW_BAYER &&
+		pixfmt->pixelformat != V4L2_PIX_FMT_SBGGR8)
+		return -EINVAL;
+	else if (pixfmt->pixelformat != V4L2_PIX_FMT_YUV422P)
+		return -EINVAL;
+
+	vpif_fill_pix_format(vdev, pixfmt);
 
-	return vpif_check_format(ch, pixfmt, 1);
+	return 0;
 }
 
 
@@ -1577,8 +1014,8 @@ static int vpif_try_fmt_vid_cap(struct file *file, void *priv,
 static int vpif_g_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 
 	/* Check the validity of the buffer type */
@@ -1599,40 +1036,24 @@ static int vpif_g_fmt_vid_cap(struct file *file, void *priv,
 static int vpif_s_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	struct v4l2_pix_format *pixfmt;
 	int ret = 0;
 
 	vpif_dbg(2, debug, "%s\n", __func__);
 
 	/* If streaming is started, return error */
-	if (common->started) {
+	if (vb2_is_busy(&common->buffer_queue)) {
 		vpif_dbg(1, debug, "Streaming is started\n");
 		return -EBUSY;
 	}
 
-	if ((VPIF_CHANNEL0_VIDEO == ch->channel_id) ||
-	    (VPIF_CHANNEL1_VIDEO == ch->channel_id)) {
-		if (!fh->initialized) {
-			vpif_dbg(1, debug, "Channel Busy\n");
-			return -EBUSY;
-		}
-	}
-
-	ret = v4l2_prio_check(&ch->prio, fh->prio);
-	if (0 != ret)
-		return ret;
-
-	fh->initialized = 1;
-
-	pixfmt = &fmt->fmt.pix;
 	/* Check for valid field format */
-	ret = vpif_check_format(ch, pixfmt, 0);
-
+	ret = vpif_try_fmt_vid_cap(file, priv, fmt);
 	if (ret)
 		return ret;
+
 	/* store the format in the channel object */
 	common->fmt = *fmt;
 	return 0;
@@ -1651,7 +1072,7 @@ static int vpif_querycap(struct file *file, void  *priv,
 
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
-	snprintf(cap->driver, sizeof(cap->driver), "%s", dev_name(vpif_dev));
+	strlcpy(cap->driver, VPIF_DRIVER_NAME, sizeof(cap->driver));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 dev_name(vpif_dev));
 	strlcpy(cap->card, config->card_name, sizeof(cap->card));
@@ -1660,61 +1081,6 @@ static int vpif_querycap(struct file *file, void  *priv,
 }
 
 /**
- * vpif_g_priority() - get priority handler
- * @file: file ptr
- * @priv: file handle
- * @prio: ptr to v4l2_priority structure
- */
-static int vpif_g_priority(struct file *file, void *priv,
-			   enum v4l2_priority *prio)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-
-	*prio = v4l2_prio_max(&ch->prio);
-
-	return 0;
-}
-
-/**
- * vpif_s_priority() - set priority handler
- * @file: file ptr
- * @priv: file handle
- * @prio: ptr to v4l2_priority structure
- */
-static int vpif_s_priority(struct file *file, void *priv, enum v4l2_priority p)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-
-	return v4l2_prio_change(&ch->prio, &fh->prio, p);
-}
-
-/**
- * vpif_cropcap() - cropcap handler
- * @file: file ptr
- * @priv: file handle
- * @crop: ptr to v4l2_cropcap structure
- */
-static int vpif_cropcap(struct file *file, void *priv,
-			struct v4l2_cropcap *crop)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-
-	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != crop->type)
-		return -EINVAL;
-
-	crop->bounds.left = 0;
-	crop->bounds.top = 0;
-	crop->bounds.height = common->height;
-	crop->bounds.width = common->width;
-	crop->defrect = crop->bounds;
-	return 0;
-}
-
-/**
  * vpif_enum_dv_timings() - ENUM_DV_TIMINGS handler
  * @file: file ptr
  * @priv: file handle
@@ -1724,13 +1090,25 @@ static int
 vpif_enum_dv_timings(struct file *file, void *priv,
 		     struct v4l2_enum_dv_timings *timings)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct vpif_capture_config *config = vpif_dev->platform_data;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
+	struct vpif_capture_chan_config *chan_cfg;
+	struct v4l2_input input;
 	int ret;
 
+	if (config->chan_config[ch->channel_id].inputs == NULL)
+		return -ENODATA;
+
+	chan_cfg = &config->chan_config[ch->channel_id];
+	input = chan_cfg->inputs[ch->input_idx].input;
+	if (input.capabilities != V4L2_IN_CAP_DV_TIMINGS)
+		return -ENODATA;
+
 	ret = v4l2_subdev_call(ch->sd, video, enum_dv_timings, timings);
 	if (ret == -ENOIOCTLCMD || ret == -ENODEV)
 		return -EINVAL;
+
 	return ret;
 }
 
@@ -1744,10 +1122,21 @@ static int
 vpif_query_dv_timings(struct file *file, void *priv,
 		      struct v4l2_dv_timings *timings)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct vpif_capture_config *config = vpif_dev->platform_data;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
+	struct vpif_capture_chan_config *chan_cfg;
+	struct v4l2_input input;
 	int ret;
 
+	if (config->chan_config[ch->channel_id].inputs == NULL)
+		return -ENODATA;
+
+	chan_cfg = &config->chan_config[ch->channel_id];
+	input = chan_cfg->inputs[ch->input_idx].input;
+	if (input.capabilities != V4L2_IN_CAP_DV_TIMINGS)
+		return -ENODATA;
+
 	ret = v4l2_subdev_call(ch->sd, video, query_dv_timings, timings);
 	if (ret == -ENOIOCTLCMD || ret == -ENODEV)
 		return -ENODATA;
@@ -1763,14 +1152,29 @@ vpif_query_dv_timings(struct file *file, void *priv,
 static int vpif_s_dv_timings(struct file *file, void *priv,
 		struct v4l2_dv_timings *timings)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct vpif_capture_config *config = vpif_dev->platform_data;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct vpif_params *vpifparams = &ch->vpifparams;
 	struct vpif_channel_config_params *std_info = &vpifparams->std_info;
+	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct video_obj *vid_ch = &ch->video;
 	struct v4l2_bt_timings *bt = &vid_ch->dv_timings.bt;
+	struct vpif_capture_chan_config *chan_cfg;
+	struct v4l2_input input;
 	int ret;
 
+	if (config->chan_config[ch->channel_id].inputs == NULL)
+		return -ENODATA;
+
+	chan_cfg = &config->chan_config[ch->channel_id];
+	input = chan_cfg->inputs[ch->input_idx].input;
+	if (input.capabilities != V4L2_IN_CAP_DV_TIMINGS)
+		return -ENODATA;
+
+	if (vb2_is_busy(&common->buffer_queue))
+		return -EBUSY;
+
 	if (timings->type != V4L2_DV_BT_656_1120) {
 		vpif_dbg(2, debug, "Timing type not defined\n");
 		return -EINVAL;
@@ -1851,9 +1255,20 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 static int vpif_g_dv_timings(struct file *file, void *priv,
 		struct v4l2_dv_timings *timings)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct vpif_capture_config *config = vpif_dev->platform_data;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct video_obj *vid_ch = &ch->video;
+	struct vpif_capture_chan_config *chan_cfg;
+	struct v4l2_input input;
+
+	if (config->chan_config[ch->channel_id].inputs == NULL)
+		return -ENODATA;
+
+	chan_cfg = &config->chan_config[ch->channel_id];
+	input = chan_cfg->inputs[ch->input_idx].input;
+	if (input.capabilities != V4L2_IN_CAP_DV_TIMINGS)
+		return -ENODATA;
 
 	*timings = vid_ch->dv_timings;
 
@@ -1877,49 +1292,45 @@ static int vpif_log_status(struct file *filep, void *priv)
 
 /* vpif capture ioctl operations */
 static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
-	.vidioc_querycap        	= vpif_querycap,
-	.vidioc_g_priority		= vpif_g_priority,
-	.vidioc_s_priority		= vpif_s_priority,
+	.vidioc_querycap		= vpif_querycap,
 	.vidioc_enum_fmt_vid_cap	= vpif_enum_fmt_vid_cap,
-	.vidioc_g_fmt_vid_cap  		= vpif_g_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap		= vpif_g_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap		= vpif_s_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap		= vpif_try_fmt_vid_cap,
+
 	.vidioc_enum_input		= vpif_enum_input,
 	.vidioc_s_input			= vpif_s_input,
 	.vidioc_g_input			= vpif_g_input,
-	.vidioc_reqbufs         	= vpif_reqbufs,
-	.vidioc_querybuf        	= vpif_querybuf,
+
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_expbuf			= vb2_ioctl_expbuf,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
+
 	.vidioc_querystd		= vpif_querystd,
-	.vidioc_s_std           	= vpif_s_std,
+	.vidioc_s_std			= vpif_s_std,
 	.vidioc_g_std			= vpif_g_std,
-	.vidioc_qbuf            	= vpif_qbuf,
-	.vidioc_dqbuf           	= vpif_dqbuf,
-	.vidioc_streamon        	= vpif_streamon,
-	.vidioc_streamoff       	= vpif_streamoff,
-	.vidioc_cropcap         	= vpif_cropcap,
-	.vidioc_enum_dv_timings         = vpif_enum_dv_timings,
-	.vidioc_query_dv_timings        = vpif_query_dv_timings,
-	.vidioc_s_dv_timings            = vpif_s_dv_timings,
-	.vidioc_g_dv_timings            = vpif_g_dv_timings,
+
+	.vidioc_enum_dv_timings		= vpif_enum_dv_timings,
+	.vidioc_query_dv_timings	= vpif_query_dv_timings,
+	.vidioc_s_dv_timings		= vpif_s_dv_timings,
+	.vidioc_g_dv_timings		= vpif_g_dv_timings,
+
 	.vidioc_log_status		= vpif_log_status,
 };
 
 /* vpif file operations */
 static struct v4l2_file_operations vpif_fops = {
-	.owner = THIS_MODULE,
-	.open = vpif_open,
-	.release = vpif_release,
-	.unlocked_ioctl = video_ioctl2,
-	.mmap = vpif_mmap,
-	.poll = vpif_poll
-};
-
-/* vpif video template */
-static struct video_device vpif_video_template = {
-	.name		= "vpif",
-	.fops		= &vpif_fops,
-	.minor		= -1,
-	.ioctl_ops	= &vpif_ioctl_ops,
+	.owner		= THIS_MODULE,
+	.open		= v4l2_fh_open,
+	.release	= vb2_fop_release,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= vb2_fop_mmap,
+	.poll		= vb2_fop_poll
 };
 
 /**
@@ -1929,36 +1340,9 @@ static struct video_device vpif_video_template = {
  */
 static int initialize_vpif(void)
 {
-	int err = 0, i, j;
+	int err, i, j;
 	int free_channel_objects_index;
 
-	/* Default number of buffers should be 3 */
-	if ((ch0_numbuffers > 0) &&
-	    (ch0_numbuffers < config_params.min_numbuffers))
-		ch0_numbuffers = config_params.min_numbuffers;
-	if ((ch1_numbuffers > 0) &&
-	    (ch1_numbuffers < config_params.min_numbuffers))
-		ch1_numbuffers = config_params.min_numbuffers;
-
-	/* Set buffer size to min buffers size if it is invalid */
-	if (ch0_bufsize < config_params.min_bufsize[VPIF_CHANNEL0_VIDEO])
-		ch0_bufsize =
-		    config_params.min_bufsize[VPIF_CHANNEL0_VIDEO];
-	if (ch1_bufsize < config_params.min_bufsize[VPIF_CHANNEL1_VIDEO])
-		ch1_bufsize =
-		    config_params.min_bufsize[VPIF_CHANNEL1_VIDEO];
-
-	config_params.numbuffers[VPIF_CHANNEL0_VIDEO] = ch0_numbuffers;
-	config_params.numbuffers[VPIF_CHANNEL1_VIDEO] = ch1_numbuffers;
-	if (ch0_numbuffers) {
-		config_params.channel_bufsize[VPIF_CHANNEL0_VIDEO]
-		    = ch0_bufsize;
-	}
-	if (ch1_numbuffers) {
-		config_params.channel_bufsize[VPIF_CHANNEL1_VIDEO]
-		    = ch1_bufsize;
-	}
-
 	/* Allocate memory for six channel objects */
 	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
 		vpif_obj.dev[i] =
@@ -1997,7 +1381,9 @@ static int vpif_async_bound(struct v4l2_async_notifier *notifier,
 static int vpif_probe_complete(void)
 {
 	struct common_obj *common;
+	struct video_device *vdev;
 	struct channel_obj *ch;
+	struct vb2_queue *q;
 	int i, j, err, k;
 
 	for (j = 0; j < VPIF_CAPTURE_MAX_DEVICES; j++) {
@@ -2007,16 +1393,54 @@ static int vpif_probe_complete(void)
 		spin_lock_init(&common->irqlock);
 		mutex_init(&common->lock);
 		ch->video_dev->lock = &common->lock;
-		/* Initialize prio member of channel object */
-		v4l2_prio_init(&ch->prio);
-		video_set_drvdata(ch->video_dev, ch);
 
 		/* select input 0 */
 		err = vpif_set_input(vpif_obj.config, ch, 0);
 		if (err)
 			goto probe_out;
 
-		err = video_register_device(ch->video_dev,
+		/* Initialize vb2 queue */
+		q = &common->buffer_queue;
+		q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+		q->drv_priv = ch;
+		q->ops = &video_qops;
+		q->mem_ops = &vb2_dma_contig_memops;
+		q->buf_struct_size = sizeof(struct vpif_cap_buffer);
+		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+		q->min_buffers_needed = 1;
+		q->lock = &common->lock;
+
+		err = vb2_queue_init(q);
+		if (err) {
+			vpif_err("vpif_display: vb2_queue_init() failed\n");
+			vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
+			goto probe_out;
+		}
+
+		common->alloc_ctx = vb2_dma_contig_init_ctx(vpif_dev);
+		if (IS_ERR(common->alloc_ctx)) {
+			vpif_err("Failed to get the context\n");
+			err = PTR_ERR(common->alloc_ctx);
+			goto probe_out;
+		}
+
+		INIT_LIST_HEAD(&common->dma_queue);
+
+		/* Initialize the video_device structure */
+		vdev = ch->video_dev;
+		strlcpy(vdev->name, VPIF_DRIVER_NAME, sizeof(vdev->name));
+		vdev->release = video_device_release;
+		vdev->fops = &vpif_fops;
+		vdev->ioctl_ops = &vpif_ioctl_ops;
+		vdev->lock = &common->lock;
+		vdev->queue = q;
+		vdev->v4l2_dev = &vpif_obj.v4l2_dev;
+		vdev->vfl_dir = VFL_DIR_RX;
+		set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);
+		video_set_drvdata(vdev, ch);
+
+		err = video_register_device(vdev,
 					    VFL_TYPE_GRABBER, (j ? 1 : 0));
 		if (err)
 			goto probe_out;
@@ -2029,6 +1453,8 @@ probe_out:
 	for (k = 0; k < j; k++) {
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[k];
+		common = &ch->common[k];
+		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
 		/* Unregister video device */
 		video_unregister_device(ch->video_dev);
 	}
@@ -2065,7 +1491,6 @@ static __init int vpif_probe(struct platform_device *pdev)
 	struct video_device *vfd;
 	struct resource *res;
 	int subdev_count;
-	size_t size;
 
 	vpif_dev = &pdev->dev;
 
@@ -2083,7 +1508,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 
 	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, res_idx))) {
 		err = devm_request_irq(&pdev->dev, res->start, vpif_channel_isr,
-					IRQF_SHARED, "VPIF_Capture",
+					IRQF_SHARED, VPIF_DRIVER_NAME,
 					(void *)(&vpif_obj.dev[res_idx]->
 					channel_id));
 		if (err) {
@@ -2107,34 +1532,10 @@ static __init int vpif_probe(struct platform_device *pdev)
 			goto vpif_unregister;
 		}
 
-		/* Initialize field of video device */
-		*vfd = vpif_video_template;
-		vfd->v4l2_dev = &vpif_obj.v4l2_dev;
-		vfd->release = video_device_release;
-		snprintf(vfd->name, sizeof(vfd->name),
-			 "VPIF_Capture_DRIVER_V%s",
-			 VPIF_CAPTURE_VERSION);
 		/* Set video_dev to the video device */
 		ch->video_dev = vfd;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res) {
-		size = resource_size(res);
-		/* The resources are divided into two equal memory and when we
-		 * have HD output we can add them together
-		 */
-		for (j = 0; j < VPIF_CAPTURE_MAX_DEVICES; j++) {
-			ch = vpif_obj.dev[j];
-			ch->channel_id = j;
-			/* only enabled if second resource exists */
-			config_params.video_limit[ch->channel_id] = 0;
-			if (size)
-				config_params.video_limit[ch->channel_id] =
-									size/2;
-		}
-	}
-
 	vpif_obj.config = pdev->dev.platform_data;
 
 	subdev_count = vpif_obj.config->subdev_count;
@@ -2207,6 +1608,7 @@ vpif_unregister:
  */
 static int vpif_remove(struct platform_device *device)
 {
+	struct common_obj *common;
 	struct channel_obj *ch;
 	int i;
 
@@ -2217,6 +1619,8 @@ static int vpif_remove(struct platform_device *device)
 	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
+		common = &ch->common[i];
+		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
 		/* Unregister video device */
 		video_unregister_device(ch->video_dev);
 		kfree(vpif_obj.dev[i]);
@@ -2224,13 +1628,12 @@ static int vpif_remove(struct platform_device *device)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 /**
  * vpif_suspend: vpif device suspend
  */
 static int vpif_suspend(struct device *dev)
 {
-
 	struct common_obj *common;
 	struct channel_obj *ch;
 	int i;
@@ -2239,18 +1642,19 @@ static int vpif_suspend(struct device *dev)
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
 		common = &ch->common[VPIF_VIDEO_INDEX];
+
+		if (!vb2_is_streaming(&common->buffer_queue))
+			continue;
+
 		mutex_lock(&common->lock);
-		if (ch->usrs && common->io_usrs) {
-			/* Disable channel */
-			if (ch->channel_id == VPIF_CHANNEL0_VIDEO) {
-				enable_channel0(0);
-				channel0_intr_enable(0);
-			}
-			if (ch->channel_id == VPIF_CHANNEL1_VIDEO ||
-			    common->started == 2) {
-				enable_channel1(0);
-				channel1_intr_enable(0);
-			}
+		/* Disable channel */
+		if (ch->channel_id == VPIF_CHANNEL0_VIDEO) {
+			enable_channel0(0);
+			channel0_intr_enable(0);
+		}
+		if (ch->channel_id == VPIF_CHANNEL1_VIDEO || ycmux_mode == 2) {
+			enable_channel1(0);
+			channel1_intr_enable(0);
 		}
 		mutex_unlock(&common->lock);
 	}
@@ -2271,18 +1675,19 @@ static int vpif_resume(struct device *dev)
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
 		common = &ch->common[VPIF_VIDEO_INDEX];
+
+		if (!vb2_is_streaming(&common->buffer_queue))
+			continue;
+
 		mutex_lock(&common->lock);
-		if (ch->usrs && common->io_usrs) {
-			/* Disable channel */
-			if (ch->channel_id == VPIF_CHANNEL0_VIDEO) {
-				enable_channel0(1);
-				channel0_intr_enable(1);
-			}
-			if (ch->channel_id == VPIF_CHANNEL1_VIDEO ||
-			    common->started == 2) {
-				enable_channel1(1);
-				channel1_intr_enable(1);
-			}
+		/* Enable channel */
+		if (ch->channel_id == VPIF_CHANNEL0_VIDEO) {
+			enable_channel0(1);
+			channel0_intr_enable(1);
+		}
+		if (ch->channel_id == VPIF_CHANNEL1_VIDEO || ycmux_mode == 2) {
+			enable_channel1(1);
+			channel1_intr_enable(1);
 		}
 		mutex_unlock(&common->lock);
 	}
@@ -2290,21 +1695,15 @@ static int vpif_resume(struct device *dev)
 	return 0;
 }
 
-static const struct dev_pm_ops vpif_dev_pm_ops = {
-	.suspend = vpif_suspend,
-	.resume = vpif_resume,
-};
-
-#define vpif_pm_ops (&vpif_dev_pm_ops)
-#else
-#define vpif_pm_ops NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(vpif_pm_ops, vpif_suspend, vpif_resume);
+
 static __refdata struct platform_driver vpif_driver = {
 	.driver	= {
-		.name	= "vpif_capture",
+		.name	= VPIF_DRIVER_NAME,
 		.owner	= THIS_MODULE,
-		.pm	= vpif_pm_ops,
+		.pm	= &vpif_pm_ops,
 	},
 	.probe = vpif_probe,
 	.remove = vpif_remove,
diff --git a/drivers/media/platform/davinci/vpif_capture.h b/drivers/media/platform/davinci/vpif_capture.h
index 5a29d9a..421a356 100644
--- a/drivers/media/platform/davinci/vpif_capture.h
+++ b/drivers/media/platform/davinci/vpif_capture.h
@@ -19,8 +19,6 @@
 #ifndef VPIF_CAPTURE_H
 #define VPIF_CAPTURE_H
 
-#ifdef __KERNEL__
-
 /* Header files */
 #include <media/videobuf2-dma-contig.h>
 #include <media/v4l2-device.h>
@@ -63,11 +61,6 @@ struct common_obj {
 	struct vpif_cap_buffer *cur_frm;
 	/* Pointer pointing to current v4l2_buffer */
 	struct vpif_cap_buffer *next_frm;
-	/*
-	 * This field keeps track of type of buffer exchange mechanism
-	 * user has selected
-	 */
-	enum v4l2_memory memory;
 	/* Used to store pixel format */
 	struct v4l2_format fmt;
 	/* Buffer queue used in video-buf */
@@ -80,12 +73,8 @@ struct common_obj {
 	spinlock_t irqlock;
 	/* lock used to access this structure */
 	struct mutex lock;
-	/* number of users performing IO */
-	u32 io_usrs;
-	/* Indicates whether streaming started */
-	u8 started;
 	/* Function pointer to set the addresses */
-	void (*set_addr) (unsigned long, unsigned long, unsigned long,
+	void (*set_addr)(unsigned long, unsigned long, unsigned long,
 			  unsigned long);
 	/* offset where Y top starts from the starting of the buffer */
 	u32 ytop_off;
@@ -104,14 +93,8 @@ struct common_obj {
 struct channel_obj {
 	/* Identifies video device for this channel */
 	struct video_device *video_dev;
-	/* Used to keep track of state of the priority */
-	struct v4l2_prio_state prio;
-	/* number of open instances of the channel */
-	int usrs;
 	/* Indicates id of the field which is being displayed */
 	u32 field_id;
-	/* flag to indicate whether decoder is initialized */
-	u8 initialized;
 	/* Identifies channel */
 	enum vpif_channel_id channel_id;
 	/* Current input */
@@ -126,18 +109,6 @@ struct channel_obj {
 	struct video_obj video;
 };
 
-/* File handle structure */
-struct vpif_fh {
-	/* pointer to channel object for opened device */
-	struct channel_obj *channel;
-	/* Indicates whether this file handle is doing IO */
-	u8 io_allowed[VPIF_NUMBER_OF_OBJECTS];
-	/* Used to keep track priority of this instance */
-	enum v4l2_priority prio;
-	/* Used to indicate channel is initialize or not */
-	u8 initialized;
-};
-
 struct vpif_device {
 	struct v4l2_device v4l2_dev;
 	struct channel_obj *dev[VPIF_CAPTURE_NUM_CHANNELS];
@@ -146,16 +117,4 @@ struct vpif_device {
 	struct vpif_capture_config *config;
 };
 
-struct vpif_config_params {
-	u8 min_numbuffers;
-	u8 numbuffers[VPIF_CAPTURE_NUM_CHANNELS];
-	s8 device_type;
-	u32 min_bufsize[VPIF_CAPTURE_NUM_CHANNELS];
-	u32 channel_bufsize[VPIF_CAPTURE_NUM_CHANNELS];
-	u8 default_device[VPIF_CAPTURE_NUM_CHANNELS];
-	u32 video_limit[VPIF_CAPTURE_NUM_CHANNELS];
-	u8 max_device_type;
-};
-
-#endif				/* End of __KERNEL__ */
 #endif				/* VPIF_CAPTURE_H */
-- 
1.7.9.5

