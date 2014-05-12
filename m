Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50126 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbaELI67 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 May 2014 04:58:59 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v4 2/2] media: davinci: vpif display: upgrade the driver with v4l offerings
Date: Mon, 12 May 2014 14:28:30 +0530
Message-Id: <1399885110-9899-3-git-send-email-prabhakar.csengg@gmail.com>
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
9: removes unneeded maodule params.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
root@da850-omapl138-evm:/usr# ./v4l2-compliance -d /dev/video2 -o -s -v
Driver Info:
        Driver name   : vpif_display
        Card type     : DA850/OMAP-L13vpif_display vpif_display: =================  START STATUS  =================
8 Video Display
        Bus info      : platform:vpif_adv7343 1-002a: Standard: f900
display
        Driveradv7343 1-002a: Output: Composite
 version: 3.15.0
        Capabilities vpif_display vpif_display: ==================  END STATUS  ==================
 : 0x84000002
                Video Output
                Streaming
                Device Capabilities
        Device Caps   : 0x04000002
                Video Output
                Streaming

Compliance test for device /dev/video2 (not using libv4l2):

Required ioctls:
        test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
        test second video open: OK
        test VIDIOC_QUERYCAP: OK
        test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
        test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
        test VIDIOC_LOG_STATUS: OK
vpif_display vpif_display: Invalid format index

Input ioctls:
        test VIDIOC_G/S_TUNER: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
        test VIDIOC_ENUMAvpif_display vpif_display: Invalid format index
UDIO: OK (Not Supported)
        test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
        test VIDIOC_G/S_AUDIO: OK (Not Supported)
        Inputs: 0 Audio Inputs: 0 Tuners: 0

Output ioctls:
        test VIDIOC_G/S_MODULATOR: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_ENUMAUDOUT: OK (Not Supported)
        test VIDIOC_G/S/ENUMOUTPUT: OK
        test VIDIOC_G/S_AUDOUT: OK (Not Supported)
        Outputs: 2 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
        test VIDIOC_ENUM/G/S/QUERY_STD: OK
        test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
        test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
        test VIDIOC_G/S_EDID: OK (Not Supported)

Test output 0:

        Control ioctls:
                test VIDIOC_QUERYCTRL/MENU: OK (Not Supported)
                test VIDIOC_G/S_CTRL: OK (Not Supported)
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 0 Private Controls: 0

        Format ioctls:
                info: found 1 formats for buftype 2
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                test VIDIOC_G/S_PARM: OK (Not Supported)
                test VIDIOC_G_FBUF: OK (Not Supported)
                fail: v4l2-test-formats.cpp(406): !pix.colorspace
                test VIDIOC_G_FMT: FAIL
                test VIDIOC_TRY_FMT: OK (Not Supported)
                test VIDIOC_S_FMT: OK (Not Supported)
                test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

        Codec ioctls:
                test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
                test VIDIOC_G_ENC_INDEX: OK (Not Supported)
                test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Test output 1:

        Control ioctls:
                test VIDIOC_QUERYCTRL/MENU: OK (Not Supported)
                test VIDIOC_G/S_CTRL: OK (Not Supported)
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 0 Private Controls: 0

        Format ioctls:
                info: found 1 formats for buftype 2
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                test VIDIOC_G/S_PARM: OK (Not Supported)
                test VIDIOC_G_FBUF: OK (Not Supported)
                fail: v4l2-test-formats.cpp(406): !pix.colorspace
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

Total: 53, Succeeded: 50, Failed: 3, Warnings: 0


 drivers/media/platform/davinci/vpif_display.c | 1257 ++++++++-----------------
 drivers/media/platform/davinci/vpif_display.h |   46 +-
 2 files changed, 406 insertions(+), 897 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index d03487f..b5cdfde 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -3,6 +3,7 @@
  * Display driver for TI DaVinci VPIF
  *
  * Copyright (C) 2009 Texas Instruments Incorporated - http://www.ti.com/
+ * Copyright (C) 2014 Lad, Prabhakar <prabhakar.csengg@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
@@ -18,7 +19,9 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/v4l2-dv-timings.h>
 
+#include <media/v4l2-dv-timings.h>
 #include <media/v4l2-ioctl.h>
 
 #include "vpif.h"
@@ -34,258 +37,182 @@ MODULE_VERSION(VPIF_DISPLAY_VERSION);
 #define vpif_dbg(level, debug, fmt, arg...)	\
 		v4l2_dbg(level, debug, &vpif_obj.v4l2_dev, fmt, ## arg)
 
+#define VPIF_DRIVER_NAME	"vpif_display"
+
 static int debug = 1;
-static u32 ch2_numbuffers = 3;
-static u32 ch3_numbuffers = 3;
-static u32 ch2_bufsize = 1920 * 1080 * 2;
-static u32 ch3_bufsize = 720 * 576 * 2;
 
 module_param(debug, int, 0644);
-module_param(ch2_numbuffers, uint, S_IRUGO);
-module_param(ch3_numbuffers, uint, S_IRUGO);
-module_param(ch2_bufsize, uint, S_IRUGO);
-module_param(ch3_bufsize, uint, S_IRUGO);
 
 MODULE_PARM_DESC(debug, "Debug level 0-1");
-MODULE_PARM_DESC(ch2_numbuffers, "Channel2 buffer count (default:3)");
-MODULE_PARM_DESC(ch3_numbuffers, "Channel3 buffer count (default:3)");
-MODULE_PARM_DESC(ch2_bufsize, "Channel2 buffer size (default:1920 x 1080 x 2)");
-MODULE_PARM_DESC(ch3_bufsize, "Channel3 buffer size (default:720 x 576 x 2)");
-
-static struct vpif_config_params config_params = {
-	.min_numbuffers		= 3,
-	.numbuffers[0]		= 3,
-	.numbuffers[1]		= 3,
-	.min_bufsize[0]		= 720 * 480 * 2,
-	.min_bufsize[1]		= 720 * 480 * 2,
-	.channel_bufsize[0]	= 1920 * 1080 * 2,
-	.channel_bufsize[1]	= 720 * 576 * 2,
-};
 
 static struct vpif_device vpif_obj = { {NULL} };
 static struct device *vpif_dev;
+static u8 channel_first_int[VPIF_NUMOBJECTS][2] = { {1, 1} };
+
+/*
+ * Is set to 1 in case of SDTV formats, 2 in case of HDTV formats.
+ */
+static int ycmux_mode;
+
 static void vpif_calculate_offsets(struct channel_obj *ch);
 static void vpif_config_addr(struct channel_obj *ch, int muxmode);
 
-/*
- * buffer_prepare: This is the callback function called from vb2_qbuf()
- * function the buffer is prepared and user space virtual address is converted
- * into physical address
+static inline struct vpif_disp_buffer *to_vpif_buffer(struct vb2_buffer *vb)
+{
+	return container_of(vb, struct vpif_disp_buffer, vb);
+}
+
+/**
+ * vpif_buffer_prepare :  callback function for buffer prepare
+ * @vb: ptr to vb2_buffer
+ *
+ * This is the callback function for buffer prepare when vb2_qbuf()
+ * function is called. The buffer is prepared and user space virtual address
+ * or user address is converted into  physical address
  */
 static int vpif_buffer_prepare(struct vb2_buffer *vb)
 {
-	struct vpif_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
 	struct vb2_queue *q = vb->vb2_queue;
+	struct channel_obj *ch = vb2_get_drv_priv(q);
 	struct common_obj *common;
 	unsigned long addr;
 
-	common = &fh->channel->common[VPIF_VIDEO_INDEX];
-	if (vb->state != VB2_BUF_STATE_ACTIVE &&
-		vb->state != VB2_BUF_STATE_PREPARED) {
-		vb2_set_plane_payload(vb, 0, common->fmt.fmt.pix.sizeimage);
-		if (vb2_plane_vaddr(vb, 0) &&
-		vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
-			goto buf_align_exit;
-
-		addr = vb2_dma_contig_plane_dma_addr(vb, 0);
-		if (q->streaming &&
-			(V4L2_BUF_TYPE_SLICED_VBI_OUTPUT != q->type)) {
-			if (!ISALIGNED(addr + common->ytop_off) ||
-			!ISALIGNED(addr + common->ybtm_off) ||
-			!ISALIGNED(addr + common->ctop_off) ||
-			!ISALIGNED(addr + common->cbtm_off))
-				goto buf_align_exit;
-		}
+	vpif_dbg(2, debug, "vpif_buffer_prepare\n");
+
+	common = &ch->common[VPIF_VIDEO_INDEX];
+
+	vb2_set_plane_payload(vb, 0, common->fmt.fmt.pix.sizeimage);
+	if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
+		return -EINVAL;
+
+	vb->v4l2_buf.field = common->fmt.fmt.pix.field;
+
+	addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	if (V4L2_BUF_TYPE_SLICED_VBI_OUTPUT != q->type &&
+		(!ISALIGNED(addr + common->ytop_off) ||
+		!ISALIGNED(addr + common->ybtm_off) ||
+		!ISALIGNED(addr + common->ctop_off) ||
+		!ISALIGNED(addr + common->cbtm_off))) {
+		vpif_err("buffer offset not aligned to 8 bytes\n");
+		return -EINVAL;
 	}
-	return 0;
 
-buf_align_exit:
-	vpif_err("buffer offset not aligned to 8 bytes\n");
-	return -EINVAL;
+	return 0;
 }
 
-/*
- * vpif_buffer_queue_setup: This function allocates memory for the buffers
+/**
+ * vpif_buffer_queue_setup : Callback function for buffer setup.
+ * @vq: vb2_queue ptr
+ * @fmt: v4l2 format
+ * @nbuffers: ptr to number of buffers requested by application
+ * @nplanes:: contains number of distinct video planes needed to hold a frame
+ * @sizes[]: contains the size (in bytes) of each plane.
+ * @alloc_ctxs: ptr to allocation context
+ *
+ * This callback function is called when reqbuf() is called to adjust
+ * the buffer count and buffer size
  */
 static int vpif_buffer_queue_setup(struct vb2_queue *vq,
 				const struct v4l2_format *fmt,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct vpif_fh *fh = vb2_get_drv_priv(vq);
-	struct channel_obj *ch = fh->channel;
+	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	unsigned long size;
-
-	if (V4L2_MEMORY_MMAP == common->memory) {
-		size = config_params.channel_bufsize[ch->channel_id];
-		/*
-		* Checking if the buffer size exceeds the available buffer
-		* ycmux_mode = 0 means 1 channel mode HD and
-		* ycmux_mode = 1 means 2 channels mode SD
-		*/
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
-	} else {
-		size = common->fmt.fmt.pix.sizeimage;
-	}
 
-	if (*nbuffers < config_params.min_numbuffers)
-			*nbuffers = config_params.min_numbuffers;
+	if (vq->num_buffers + *nbuffers < 3)
+		*nbuffers = 3 - vq->num_buffers;
 
 	*nplanes = 1;
-	sizes[0] = size;
+	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : common->fmt.fmt.pix.sizeimage;
 	alloc_ctxs[0] = common->alloc_ctx;
+
+	/* Calculate the offset for Y and C data  in the buffer */
+	vpif_calculate_offsets(ch);
+
 	return 0;
 }
 
-/*
- * vpif_buffer_queue: This function adds the buffer to DMA queue
+/**
+ * vpif_buffer_queue : Callback function to add buffer to DMA queue
+ * @vb: ptr to vb2_buffer
+ *
+ * This callback fucntion queues the buffer to DMA engine
  */
 static void vpif_buffer_queue(struct vb2_buffer *vb)
 {
-	struct vpif_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
-	struct vpif_disp_buffer *buf = container_of(vb,
-				struct vpif_disp_buffer, vb);
-	struct channel_obj *ch = fh->channel;
+	struct vpif_disp_buffer *buf = to_vpif_buffer(vb);
+	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2_queue);
 	struct common_obj *common;
 	unsigned long flags;
 
 	common = &ch->common[VPIF_VIDEO_INDEX];
-
 	/* add the buffer to the DMA queue */
 	spin_lock_irqsave(&common->irqlock, flags);
 	list_add_tail(&buf->list, &common->dma_queue);
 	spin_unlock_irqrestore(&common->irqlock, flags);
 }
 
-/*
- * vpif_buf_cleanup: This function is called from the videobuf2 layer to
- * free memory allocated to the buffers
+/**
+ * vpif_start_streaming : Starts the DMA engine for streaming
+ * @vb: ptr to vb2_buffer
+ * @count: number of buffers
  */
-static void vpif_buf_cleanup(struct vb2_buffer *vb)
-{
-	struct vpif_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
-	struct vpif_disp_buffer *buf = container_of(vb,
-					struct vpif_disp_buffer, vb);
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
-	struct vpif_disp_buffer *buf = container_of(vb,
-					struct vpif_disp_buffer, vb);
-
-	INIT_LIST_HEAD(&buf->list);
-
-	return 0;
-}
-
-static u8 channel_first_int[VPIF_NUMOBJECTS][2] = { {1, 1} };
-
 static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
-	struct vpif_display_config *vpif_config_data =
-					vpif_dev->platform_data;
-	struct vpif_fh *fh = vb2_get_drv_priv(vq);
-	struct channel_obj *ch = fh->channel;
+	struct vpif_display_config *vpif_config_data;
+	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct vpif_params *vpif = &ch->vpifparams;
-	unsigned long addr = 0;
-	unsigned long flags;
+	struct vpif_disp_buffer *buf, *tmp;
+	unsigned long addr, flags;
 	int ret;
 
 	spin_lock_irqsave(&common->irqlock, flags);
 
-	/* Get the next frame from the buffer queue */
-	common->next_frm = common->cur_frm =
-			    list_entry(common->dma_queue.next,
-				       struct vpif_disp_buffer, list);
-
-	list_del(&common->cur_frm->list);
-	spin_unlock_irqrestore(&common->irqlock, flags);
-	/* Mark state of the current frame to active */
-	common->cur_frm->vb.state = VB2_BUF_STATE_ACTIVE;
-
-	/* Initialize field_id and started member */
+	/* Initialize field_id */
 	ch->field_id = 0;
-	common->started = 1;
-	addr = vb2_dma_contig_plane_dma_addr(&common->cur_frm->vb, 0);
-	/* Calculate the offset for Y and C data  in the buffer */
-	vpif_calculate_offsets(ch);
-
-	if ((ch->vpifparams.std_info.frm_fmt &&
-		((common->fmt.fmt.pix.field != V4L2_FIELD_NONE)
-		&& (common->fmt.fmt.pix.field != V4L2_FIELD_ANY)))
-		|| (!ch->vpifparams.std_info.frm_fmt
-		&& (common->fmt.fmt.pix.field == V4L2_FIELD_NONE))) {
-		vpif_err("conflict in field format and std format\n");
-		return -EINVAL;
-	}
 
+	vpif_config_data = vpif_dev->platform_data;
 	/* clock settings */
 	if (vpif_config_data->set_clock) {
 		ret = vpif_config_data->set_clock(ch->vpifparams.std_info.
 		ycmux_mode, ch->vpifparams.std_info.hd_sd);
 		if (ret < 0) {
 			vpif_err("can't set clock\n");
-			return ret;
+			goto err;
 		}
 	}
 
 	/* set the parameters and addresses */
 	ret = vpif_set_video_params(vpif, ch->channel_id + 2);
 	if (ret < 0)
-		return ret;
+		goto err;
 
-	common->started = ret;
+	ycmux_mode = ret;
 	vpif_config_addr(ch, ret);
+
+	/* Get the next frame from the buffer queue */
+	common->next_frm = common->cur_frm =
+			    list_entry(common->dma_queue.next,
+				       struct vpif_disp_buffer, list);
+
+	list_del(&common->cur_frm->list);
+	spin_unlock_irqrestore(&common->irqlock, flags);
+	/* Mark state of the current frame to active */
+	common->cur_frm->vb.state = VB2_BUF_STATE_ACTIVE;
+
+	addr = vb2_dma_contig_plane_dma_addr(&common->cur_frm->vb, 0);
+
 	common->set_addr((addr + common->ytop_off),
 			    (addr + common->ybtm_off),
 			    (addr + common->ctop_off),
 			    (addr + common->cbtm_off));
 
-	/* Set interrupt for both the fields in VPIF
-	    Register enable channel in VPIF register */
+	/*
+	 * Set interrupt for both the fields in VPIF
+	 * Register enable channel in VPIF register
+	 */
 	channel_first_int[VPIF_VIDEO_INDEX][ch->channel_id] = 1;
 	if (VPIF_CHANNEL2_VIDEO == ch->channel_id) {
 		channel2_intr_assert();
@@ -295,8 +222,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 			channel2_clipping_enable(1);
 	}
 
-	if ((VPIF_CHANNEL3_VIDEO == ch->channel_id)
-		|| (common->started == 2)) {
+	if (VPIF_CHANNEL3_VIDEO == ch->channel_id || ycmux_mode == 2) {
 		channel3_intr_assert();
 		channel3_intr_enable(1);
 		enable_channel3(1);
@@ -305,19 +231,29 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
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
 
-	if (!vb2_is_streaming(vq))
-		return;
-
 	common = &ch->common[VPIF_VIDEO_INDEX];
 
 	/* Disable channel */
@@ -325,12 +261,12 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 		enable_channel2(0);
 		channel2_intr_enable(0);
 	}
-	if ((VPIF_CHANNEL3_VIDEO == ch->channel_id) ||
-		(2 == common->started)) {
+	if (VPIF_CHANNEL3_VIDEO == ch->channel_id || ycmux_mode == 2) {
 		enable_channel3(0);
 		channel3_intr_enable(0);
 	}
-	common->started = 0;
+
+	ycmux_mode = 0;
 
 	/* release all active buffers */
 	spin_lock_irqsave(&common->irqlock, flags);
@@ -356,19 +292,17 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 
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
 
 static void process_progressive_mode(struct common_obj *common)
 {
-	unsigned long addr = 0;
+	unsigned long addr;
 
 	spin_lock(&common->irqlock);
 	/* Get the next buffer from buffer queue */
@@ -443,10 +377,8 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 	field = ch->common[VPIF_VIDEO_INDEX].fmt.fmt.pix.field;
 	for (i = 0; i < VPIF_NUMOBJECTS; i++) {
 		common = &ch->common[i];
-		/* If streaming is started in this channel */
-		if (0 == common->started)
-			continue;
 
+		/* If streaming is started in this channel */
 		if (1 == ch->vpifparams.std_info.frm_fmt) {
 			spin_lock(&common->irqlock);
 			if (list_empty(&common->dma_queue)) {
@@ -550,6 +482,11 @@ static int vpif_update_resolution(struct channel_obj *ch)
 	common->height = std_info->height;
 	common->width = std_info->width;
 
+	common->fmt.fmt.pix.bytesperline = common->fmt.fmt.pix.width;
+	common->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV422P;
+	common->fmt.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+
+
 	return 0;
 }
 
@@ -565,21 +502,13 @@ static void vpif_calculate_offsets(struct channel_obj *ch)
 	struct video_obj *vid_ch = &ch->video;
 	unsigned int hpitch, vpitch, sizeimage;
 
-	if (V4L2_FIELD_ANY == common->fmt.fmt.pix.field) {
-		if (ch->vpifparams.std_info.frm_fmt)
-			vid_ch->buf_field = V4L2_FIELD_NONE;
-		else
-			vid_ch->buf_field = V4L2_FIELD_INTERLACED;
-	} else {
-		vid_ch->buf_field = common->fmt.fmt.pix.field;
-	}
-
+	vid_ch->buf_field = common->fmt.fmt.pix.field;
 	sizeimage = common->fmt.fmt.pix.sizeimage;
 
 	hpitch = common->fmt.fmt.pix.bytesperline;
 	vpitch = sizeimage / (hpitch * 2);
-	if ((V4L2_FIELD_NONE == vid_ch->buf_field) ||
-	    (V4L2_FIELD_INTERLACED == vid_ch->buf_field)) {
+	if (V4L2_FIELD_NONE == vid_ch->buf_field ||
+		V4L2_FIELD_INTERLACED == vid_ch->buf_field) {
 		common->ytop_off = 0;
 		common->ybtm_off = hpitch;
 		common->ctop_off = sizeimage / 2;
@@ -596,8 +525,8 @@ static void vpif_calculate_offsets(struct channel_obj *ch)
 		common->ctop_off = common->cbtm_off + sizeimage / 4;
 	}
 
-	if ((V4L2_FIELD_NONE == vid_ch->buf_field) ||
-	    (V4L2_FIELD_INTERLACED == vid_ch->buf_field)) {
+	if (V4L2_FIELD_NONE == vid_ch->buf_field ||
+		V4L2_FIELD_INTERLACED == vid_ch->buf_field) {
 		vpifparams->video_params.storage_mode = 1;
 	} else {
 		vpifparams->video_params.storage_mode = 0;
@@ -607,8 +536,8 @@ static void vpif_calculate_offsets(struct channel_obj *ch)
 		vpifparams->video_params.hpitch =
 		    common->fmt.fmt.pix.bytesperline;
 	} else {
-		if ((field == V4L2_FIELD_ANY) ||
-			(field == V4L2_FIELD_INTERLACED))
+		if (field == V4L2_FIELD_ANY ||
+			field == V4L2_FIELD_INTERLACED)
 			vpifparams->video_params.hpitch =
 			    common->fmt.fmt.pix.bytesperline * 2;
 		else
@@ -619,70 +548,6 @@ static void vpif_calculate_offsets(struct channel_obj *ch)
 	ch->vpifparams.video_params.stdid = ch->vpifparams.std_info.stdid;
 }
 
-static void vpif_config_format(struct channel_obj *ch)
-{
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-
-	common->fmt.fmt.pix.field = V4L2_FIELD_ANY;
-	if (config_params.numbuffers[ch->channel_id] == 0)
-		common->memory = V4L2_MEMORY_USERPTR;
-	else
-		common->memory = V4L2_MEMORY_MMAP;
-
-	common->fmt.fmt.pix.sizeimage =
-			config_params.channel_bufsize[ch->channel_id];
-	common->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV422P;
-	common->fmt.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-}
-
-static int vpif_check_format(struct channel_obj *ch,
-			     struct v4l2_pix_format *pixfmt)
-{
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	enum v4l2_field field = pixfmt->field;
-	u32 sizeimage, hpitch, vpitch;
-
-	if (pixfmt->pixelformat != V4L2_PIX_FMT_YUV422P)
-		goto invalid_fmt_exit;
-
-	if (!(VPIF_VALID_FIELD(field)))
-		goto invalid_fmt_exit;
-
-	if (pixfmt->bytesperline <= 0)
-		goto invalid_pitch_exit;
-
-	sizeimage = pixfmt->sizeimage;
-
-	if (vpif_update_resolution(ch))
-		return -EINVAL;
-
-	hpitch = pixfmt->bytesperline;
-	vpitch = sizeimage / (hpitch * 2);
-
-	/* Check for valid value of pitch */
-	if ((hpitch < ch->vpifparams.std_info.width) ||
-	    (vpitch < ch->vpifparams.std_info.height))
-		goto invalid_pitch_exit;
-
-	/* Check for 8 byte alignment */
-	if (!ISALIGNED(hpitch)) {
-		vpif_err("invalid pitch alignment\n");
-		return -EINVAL;
-	}
-	pixfmt->width = common->fmt.fmt.pix.width;
-	pixfmt->height = common->fmt.fmt.pix.height;
-
-	return 0;
-
-invalid_fmt_exit:
-	vpif_err("invalid field format\n");
-	return -EINVAL;
-
-invalid_pitch_exit:
-	vpif_err("invalid pitch\n");
-	return -EINVAL;
-}
-
 static void vpif_config_addr(struct channel_obj *ch, int muxmode)
 {
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
@@ -697,127 +562,6 @@ static void vpif_config_addr(struct channel_obj *ch, int muxmode)
 	}
 }
 
-/*
- * vpif_mmap: It is used to map kernel space buffers into user spaces
- */
-static int vpif_mmap(struct file *filep, struct vm_area_struct *vma)
-{
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
-/*
- * vpif_poll: It is used for select/poll system call
- */
-static unsigned int vpif_poll(struct file *filep, poll_table *wait)
-{
-	struct vpif_fh *fh = filep->private_data;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	unsigned int res = 0;
-
-	if (common->started) {
-		mutex_lock(&common->lock);
-		res = vb2_poll(&common->buffer_queue, filep, wait);
-		mutex_unlock(&common->lock);
-	}
-
-	return res;
-}
-
-/*
- * vpif_open: It creates object of file handle structure and stores it in
- * private_data member of filepointer
- */
-static int vpif_open(struct file *filep)
-{
-	struct video_device *vdev = video_devdata(filep);
-	struct channel_obj *ch = video_get_drvdata(vdev);
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	struct vpif_fh *fh;
-
-	/* Allocate memory for the file handle object */
-	fh = kzalloc(sizeof(struct vpif_fh), GFP_KERNEL);
-	if (fh == NULL) {
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
-	if (!ch->initialized) {
-		fh->initialized = 1;
-		ch->initialized = 1;
-		memset(&ch->vpifparams, 0, sizeof(ch->vpifparams));
-	}
-
-	/* Increment channel usrs counter */
-	atomic_inc(&ch->usrs);
-	/* Set io_allowed[VPIF_VIDEO_INDEX] member to false */
-	fh->io_allowed[VPIF_VIDEO_INDEX] = 0;
-	/* Initialize priority of this instance to default priority */
-	fh->prio = V4L2_PRIORITY_UNSET;
-	v4l2_prio_open(&ch->prio, &fh->prio);
-	mutex_unlock(&common->lock);
-
-	return 0;
-}
-
-/*
- * vpif_release: This function deletes buffer queue, frees the buffers and
- * the vpif file handle
- */
-static int vpif_release(struct file *filep)
-{
-	struct vpif_fh *fh = filep->private_data;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-
-	mutex_lock(&common->lock);
-	/* if this instance is doing IO */
-	if (fh->io_allowed[VPIF_VIDEO_INDEX]) {
-		/* Reset io_usrs member of channel object */
-		common->io_usrs = 0;
-		/* Free buffers allocated */
-		vb2_queue_release(&common->buffer_queue);
-		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
-
-		common->numbuffers =
-		    config_params.numbuffers[ch->channel_id];
-	}
-
-	/* Decrement channel usrs counter */
-	atomic_dec(&ch->usrs);
-	/* If this file handle has initialize encoder device, reset it */
-	if (fh->initialized)
-		ch->initialized = 0;
-
-	/* Close the priority */
-	v4l2_prio_close(&ch->prio, fh->prio);
-	filep->private_data = NULL;
-	fh->initialized = 0;
-	mutex_unlock(&common->lock);
-	kfree(fh);
-
-	return 0;
-}
-
 /* functions implementing ioctls */
 /**
  * vpif_querycap() - QUERYCAP handler
@@ -832,7 +576,7 @@ static int vpif_querycap(struct file *file, void  *priv,
 
 	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
-	snprintf(cap->driver, sizeof(cap->driver), "%s", dev_name(vpif_dev));
+	strlcpy(cap->driver, VPIF_DRIVER_NAME, sizeof(cap->driver));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 dev_name(vpif_dev));
 	strlcpy(cap->card, config->card_name, sizeof(cap->card));
@@ -859,8 +603,8 @@ static int vpif_enum_fmt_vid_out(struct file *file, void  *priv,
 static int vpif_g_fmt_vid_out(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 
 	/* Check the validity of the buffer type */
@@ -869,194 +613,122 @@ static int vpif_g_fmt_vid_out(struct file *file, void *priv,
 
 	if (vpif_update_resolution(ch))
 		return -EINVAL;
-	*fmt = common->fmt;
-	return 0;
-}
-
-static int vpif_s_fmt_vid_out(struct file *file, void *priv,
-				struct v4l2_format *fmt)
-{
-	struct vpif_fh *fh = priv;
-	struct v4l2_pix_format *pixfmt;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	int ret = 0;
-
-	if ((VPIF_CHANNEL2_VIDEO == ch->channel_id)
-	    || (VPIF_CHANNEL3_VIDEO == ch->channel_id)) {
-		if (!fh->initialized) {
-			vpif_dbg(1, debug, "Channel Busy\n");
-			return -EBUSY;
-		}
-
-		/* Check for the priority */
-		ret = v4l2_prio_check(&ch->prio, fh->prio);
-		if (0 != ret)
-			return ret;
-		fh->initialized = 1;
-	}
-
-	if (common->started) {
-		vpif_dbg(1, debug, "Streaming in progress\n");
-		return -EBUSY;
-	}
-
-	pixfmt = &fmt->fmt.pix;
-	/* Check for valid field format */
-	ret = vpif_check_format(ch, pixfmt);
-	if (ret)
-		return ret;
 
-	/* store the pix format in the channel object */
-	common->fmt.fmt.pix = *pixfmt;
-	/* store the format in the channel object */
-	common->fmt = *fmt;
+	*fmt = common->fmt;
 	return 0;
 }
 
 static int vpif_try_fmt_vid_out(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
-	int ret = 0;
-
-	ret = vpif_check_format(ch, pixfmt);
-	if (ret) {
-		*pixfmt = common->fmt.fmt.pix;
-		pixfmt->sizeimage = pixfmt->width * pixfmt->height * 2;
-	}
-
-	return ret;
-}
-
-static int vpif_reqbufs(struct file *file, void *priv,
-			struct v4l2_requestbuffers *reqbuf)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common;
-	enum v4l2_field field;
-	struct vb2_queue *q;
-	u8 index = 0;
-	int ret;
-
-	/* This file handle has not initialized the channel,
-	   It is not allowed to do settings */
-	if ((VPIF_CHANNEL2_VIDEO == ch->channel_id)
-	    || (VPIF_CHANNEL3_VIDEO == ch->channel_id)) {
-		if (!fh->initialized) {
-			vpif_err("Channel Busy\n");
-			return -EBUSY;
-		}
-	}
+	struct video_obj *vid_ch = &ch->video;
+	u32 sizeimage, hpitch, vpitch;
 
-	if (V4L2_BUF_TYPE_VIDEO_OUTPUT != reqbuf->type)
+	if (fmt->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		return -EINVAL;
 
-	index = VPIF_VIDEO_INDEX;
+	if (pixfmt->pixelformat != V4L2_PIX_FMT_YUV422P)
+		return -EINVAL;
 
-	common = &ch->common[index];
+	if (!(VPIF_VALID_FIELD(pixfmt->field)))
+		return -EINVAL;
 
-	if (common->fmt.type != reqbuf->type || !vpif_dev)
+	if (pixfmt->bytesperline <= 0)
 		return -EINVAL;
-	if (0 != common->io_usrs)
-		return -EBUSY;
 
-	if (reqbuf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		if (common->fmt.fmt.pix.field == V4L2_FIELD_ANY)
-			field = V4L2_FIELD_INTERLACED;
+	if (pixfmt->field == V4L2_FIELD_ANY) {
+		if (ch->vpifparams.std_info.frm_fmt)
+			common->fmt.fmt.pix.field = V4L2_FIELD_NONE;
 		else
-			field = common->fmt.fmt.pix.field;
+			common->fmt.fmt.pix.field = V4L2_FIELD_INTERLACED;
 	} else {
-		field = V4L2_VBI_INTERLACED;
-	}
-	/* Initialize videobuf2 queue as per the buffer type */
-	common->alloc_ctx = vb2_dma_contig_init_ctx(vpif_dev);
-	if (IS_ERR(common->alloc_ctx)) {
-		vpif_err("Failed to get the context\n");
-		return PTR_ERR(common->alloc_ctx);
-	}
-	q = &common->buffer_queue;
-	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-	q->io_modes = VB2_MMAP | VB2_USERPTR;
-	q->drv_priv = fh;
-	q->ops = &video_qops;
-	q->mem_ops = &vb2_dma_contig_memops;
-	q->buf_struct_size = sizeof(struct vpif_disp_buffer);
-	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	q->min_buffers_needed = 1;
-
-	ret = vb2_queue_init(q);
-	if (ret) {
-		vpif_err("vpif_display: vb2_queue_init() failed\n");
-		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
-		return ret;
+		common->fmt.fmt.pix.field = pixfmt->field;
 	}
-	/* Set io allowed member of file handle to TRUE */
-	fh->io_allowed[index] = 1;
-	/* Increment io usrs member of channel object to 1 */
-	common->io_usrs = 1;
-	/* Store type of memory requested in channel object */
-	common->memory = reqbuf->memory;
-	INIT_LIST_HEAD(&common->dma_queue);
-	/* Allocate buffers */
-	return vb2_reqbufs(&common->buffer_queue, reqbuf);
-}
 
-static int vpif_querybuf(struct file *file, void *priv,
-				struct v4l2_buffer *tbuf)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
+	sizeimage = pixfmt->sizeimage;
 
-	if (common->fmt.type != tbuf->type)
+	if (vpif_update_resolution(ch))
 		return -EINVAL;
 
-	return vb2_querybuf(&common->buffer_queue, tbuf);
-}
-
-static int vpif_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
-{
-	struct vpif_fh *fh = NULL;
-	struct channel_obj *ch = NULL;
-	struct common_obj *common = NULL;
+	hpitch = pixfmt->bytesperline;
+	vpitch = sizeimage / (hpitch * 2);
 
-	if (!buf || !priv)
+	/* Check for valid value of pitch */
+	if (hpitch < ch->vpifparams.std_info.width ||
+		vpitch < ch->vpifparams.std_info.height)
 		return -EINVAL;
 
-	fh = priv;
-	ch = fh->channel;
-	if (!ch)
+	/* Check for 8 byte alignment */
+	if (!ISALIGNED(hpitch)) {
+		vpif_err("invalid pitch alignment\n");
 		return -EINVAL;
+	}
+	pixfmt->width = common->fmt.fmt.pix.width;
+	pixfmt->height = common->fmt.fmt.pix.height;
 
-	common = &(ch->common[VPIF_VIDEO_INDEX]);
-	if (common->fmt.type != buf->type)
-		return -EINVAL;
+	if (vid_ch->stdid)
+		pixfmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	else
+		pixfmt->colorspace = V4L2_COLORSPACE_REC709;
 
-	if (!fh->io_allowed[VPIF_VIDEO_INDEX]) {
-		vpif_err("fh->io_allowed\n");
-		return -EACCES;
+	*pixfmt = common->fmt.fmt.pix;
+	pixfmt->sizeimage = pixfmt->width * pixfmt->height * 2;
+
+	return 0;
+}
+
+static int vpif_s_fmt_vid_out(struct file *file, void *priv,
+				struct v4l2_format *fmt)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
+	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
+	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
+	int ret;
+
+	if (vb2_is_busy(&common->buffer_queue)) {
+		vpif_err("Streaming in progress\n");
+		return -EBUSY;
 	}
 
-	return vb2_qbuf(&common->buffer_queue, buf);
+	ret = vpif_try_fmt_vid_out(file, priv, fmt);
+	if (ret)
+		return ret;
+
+	/* store the pix format in the channel object */
+	common->fmt.fmt.pix = *pixfmt;
+	/* store the format in the channel object */
+	common->fmt = *fmt;
+	return 0;
 }
 
 static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct vpif_display_config *config = vpif_dev->platform_data;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	int ret = 0;
+	struct vpif_display_chan_config *chan_cfg;
+	struct v4l2_output output;
+	int ret;
+
+	if (config->chan_config[ch->channel_id].outputs == NULL)
+		return -ENODATA;
+
+	chan_cfg = &config->chan_config[ch->channel_id];
+	output = chan_cfg->outputs[ch->output_idx].output;
+	if (output.capabilities != V4L2_OUT_CAP_STD)
+		return -ENODATA;
 
 	if (!(std_id & VPIF_V4L2_STD))
 		return -EINVAL;
 
-	if (common->started) {
-		vpif_err("streaming in progress\n");
+	if (vb2_is_busy(&common->buffer_queue)) {
+		vpif_err("Streaming in progress\n");
 		return -EBUSY;
 	}
 
@@ -1067,17 +739,6 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 	if (vpif_update_resolution(ch))
 		return -EINVAL;
 
-	if ((ch->vpifparams.std_info.width *
-		ch->vpifparams.std_info.height * 2) >
-		config_params.channel_bufsize[ch->channel_id]) {
-		vpif_err("invalid std for this size\n");
-		return -EINVAL;
-	}
-
-	common->fmt.fmt.pix.bytesperline = common->fmt.fmt.pix.width;
-	/* Configure the default format information */
-	vpif_config_format(ch);
-
 	ret = v4l2_device_call_until_err(&vpif_obj.v4l2_dev, 1, video,
 						s_std_output, std_id);
 	if (ret < 0) {
@@ -1094,132 +755,21 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 
 static int vpif_g_std(struct file *file, void *priv, v4l2_std_id *std)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-
-	*std = ch->video.stdid;
-	return 0;
-}
-
-static int vpif_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-
-	return vb2_dqbuf(&common->buffer_queue, p,
-					(file->f_flags & O_NONBLOCK));
-}
-
-static int vpif_streamon(struct file *file, void *priv,
-				enum v4l2_buf_type buftype)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	struct channel_obj *oth_ch = vpif_obj.dev[!ch->channel_id];
-	int ret = 0;
-
-	if (buftype != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		vpif_err("buffer type not supported\n");
-		return -EINVAL;
-	}
-
-	if (!fh->io_allowed[VPIF_VIDEO_INDEX]) {
-		vpif_err("fh->io_allowed\n");
-		return -EACCES;
-	}
-
-	/* If Streaming is already started, return error */
-	if (common->started) {
-		vpif_err("channel->started\n");
-		return -EBUSY;
-	}
-
-	if ((ch->channel_id == VPIF_CHANNEL2_VIDEO
-		&& oth_ch->common[VPIF_VIDEO_INDEX].started &&
-		ch->vpifparams.std_info.ycmux_mode == 0)
-		|| ((ch->channel_id == VPIF_CHANNEL3_VIDEO)
-		&& (2 == oth_ch->common[VPIF_VIDEO_INDEX].started))) {
-		vpif_err("other channel is using\n");
-		return -EBUSY;
-	}
-
-	ret = vpif_check_format(ch, &common->fmt.fmt.pix);
-	if (ret < 0)
-		return ret;
-
-	/* Call vb2_streamon to start streaming in videobuf2 */
-	ret = vb2_streamon(&common->buffer_queue, buftype);
-	if (ret < 0) {
-		vpif_err("vb2_streamon\n");
-		return ret;
-	}
-
-	return ret;
-}
-
-static int vpif_streamoff(struct file *file, void *priv,
-				enum v4l2_buf_type buftype)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	struct vpif_display_config *vpif_config_data =
-					vpif_dev->platform_data;
-
-	if (buftype != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		vpif_err("buffer type not supported\n");
-		return -EINVAL;
-	}
-
-	if (!fh->io_allowed[VPIF_VIDEO_INDEX]) {
-		vpif_err("fh->io_allowed\n");
-		return -EACCES;
-	}
-
-	if (!common->started) {
-		vpif_err("channel->started\n");
-		return -EINVAL;
-	}
-
-	if (buftype == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		/* disable channel */
-		if (VPIF_CHANNEL2_VIDEO == ch->channel_id) {
-			if (vpif_config_data->
-				chan_config[VPIF_CHANNEL2_VIDEO].clip_en)
-				channel2_clipping_enable(0);
-			enable_channel2(0);
-			channel2_intr_enable(0);
-		}
-		if ((VPIF_CHANNEL3_VIDEO == ch->channel_id) ||
-					(2 == common->started)) {
-			if (vpif_config_data->
-				chan_config[VPIF_CHANNEL3_VIDEO].clip_en)
-				channel3_clipping_enable(0);
-			enable_channel3(0);
-			channel3_intr_enable(0);
-		}
-	}
-
-	common->started = 0;
-	return vb2_streamoff(&common->buffer_queue, buftype);
-}
+	struct vpif_display_config *config = vpif_dev->platform_data;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
+	struct vpif_display_chan_config *chan_cfg;
+	struct v4l2_output output;
 
-static int vpif_cropcap(struct file *file, void *priv,
-			struct v4l2_cropcap *crop)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	if (V4L2_BUF_TYPE_VIDEO_OUTPUT != crop->type)
-		return -EINVAL;
+	if (config->chan_config[ch->channel_id].outputs == NULL)
+		return -ENODATA;
 
-	crop->bounds.left = crop->bounds.top = 0;
-	crop->defrect.left = crop->defrect.top = 0;
-	crop->defrect.height = crop->bounds.height = common->height;
-	crop->defrect.width = crop->bounds.width = common->width;
+	chan_cfg = &config->chan_config[ch->channel_id];
+	output = chan_cfg->outputs[ch->output_idx].output;
+	if (output.capabilities != V4L2_OUT_CAP_STD)
+		return -ENODATA;
 
+	*std = ch->video.stdid;
 	return 0;
 }
 
@@ -1229,8 +779,11 @@ static int vpif_enum_output(struct file *file, void *fh,
 
 	struct vpif_display_config *config = vpif_dev->platform_data;
 	struct vpif_display_chan_config *chan_cfg;
-	struct vpif_fh *vpif_handler = fh;
-	struct channel_obj *ch = vpif_handler->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
+
+	if (config->chan_config[ch->channel_id].outputs == NULL)
+		return -ENODATA;
 
 	chan_cfg = &config->chan_config[ch->channel_id];
 	if (output->index >= chan_cfg->output_count) {
@@ -1325,8 +878,8 @@ static int vpif_s_output(struct file *file, void *priv, unsigned int i)
 {
 	struct vpif_display_config *config = vpif_dev->platform_data;
 	struct vpif_display_chan_config *chan_cfg;
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 
 	chan_cfg = &config->chan_config[ch->channel_id];
@@ -1334,7 +887,7 @@ static int vpif_s_output(struct file *file, void *priv, unsigned int i)
 	if (i >= chan_cfg->output_count)
 		return -EINVAL;
 
-	if (common->started) {
+	if (vb2_is_busy(&common->buffer_queue)) {
 		vpif_err("Streaming in progress\n");
 		return -EBUSY;
 	}
@@ -1344,32 +897,14 @@ static int vpif_s_output(struct file *file, void *priv, unsigned int i)
 
 static int vpif_g_output(struct file *file, void *priv, unsigned int *i)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 
 	*i = ch->output_idx;
 
 	return 0;
 }
 
-static int vpif_g_priority(struct file *file, void *priv, enum v4l2_priority *p)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-
-	*p = v4l2_prio_max(&ch->prio);
-
-	return 0;
-}
-
-static int vpif_s_priority(struct file *file, void *priv, enum v4l2_priority p)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-
-	return v4l2_prio_change(&ch->prio, &fh->prio, p);
-}
-
 /**
  * vpif_enum_dv_timings() - ENUM_DV_TIMINGS handler
  * @file: file ptr
@@ -1380,10 +915,21 @@ static int
 vpif_enum_dv_timings(struct file *file, void *priv,
 		     struct v4l2_enum_dv_timings *timings)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct vpif_display_config *config = vpif_dev->platform_data;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
+	struct vpif_display_chan_config *chan_cfg;
+	struct v4l2_output output;
 	int ret;
 
+	if (config->chan_config[ch->channel_id].outputs == NULL)
+		return -ENODATA;
+
+	chan_cfg = &config->chan_config[ch->channel_id];
+	output = chan_cfg->outputs[ch->output_idx].output;
+	if (output.capabilities != V4L2_OUT_CAP_DV_TIMINGS)
+		return -ENODATA;
+
 	ret = v4l2_subdev_call(ch->sd, video, enum_dv_timings, timings);
 	if (ret == -ENOIOCTLCMD || ret == -ENODEV)
 		return -EINVAL;
@@ -1399,19 +945,37 @@ vpif_enum_dv_timings(struct file *file, void *priv,
 static int vpif_s_dv_timings(struct file *file, void *priv,
 		struct v4l2_dv_timings *timings)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct vpif_display_config *config = vpif_dev->platform_data;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
+	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct vpif_params *vpifparams = &ch->vpifparams;
 	struct vpif_channel_config_params *std_info = &vpifparams->std_info;
 	struct video_obj *vid_ch = &ch->video;
 	struct v4l2_bt_timings *bt = &vid_ch->dv_timings.bt;
+	struct vpif_display_chan_config *chan_cfg;
+	struct v4l2_output output;
 	int ret;
 
+	if (config->chan_config[ch->channel_id].outputs == NULL)
+		return -ENODATA;
+
+	chan_cfg = &config->chan_config[ch->channel_id];
+	output = chan_cfg->outputs[ch->output_idx].output;
+	if (output.capabilities != V4L2_OUT_CAP_DV_TIMINGS)
+		return -ENODATA;
+
+	if (vb2_is_busy(&common->buffer_queue))
+		return -EBUSY;
+
 	if (timings->type != V4L2_DV_BT_656_1120) {
 		vpif_dbg(2, debug, "Timing type not defined\n");
 		return -EINVAL;
 	}
 
+	if (v4l2_match_dv_timings(timings, &vid_ch->dv_timings, 0))
+		return 0;
+
 	/* Configure subdevice timings, if any */
 	ret = v4l2_subdev_call(ch->sd, video, s_dv_timings, timings);
 	if (ret == -ENOIOCTLCMD || ret == -ENODEV)
@@ -1488,9 +1052,20 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 static int vpif_g_dv_timings(struct file *file, void *priv,
 		struct v4l2_dv_timings *timings)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct vpif_display_config *config = vpif_dev->platform_data;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct video_obj *vid_ch = &ch->video;
+	struct vpif_display_chan_config *chan_cfg;
+	struct v4l2_output output;
+
+	if (config->chan_config[ch->channel_id].outputs == NULL)
+		return -ENODATA;
+
+	chan_cfg = &config->chan_config[ch->channel_id];
+	output = chan_cfg->outputs[ch->output_idx].output;
+	if (output.capabilities != V4L2_OUT_CAP_DV_TIMINGS)
+		return -ENODATA;
 
 	*timings = vid_ch->dv_timings;
 
@@ -1514,83 +1089,49 @@ static int vpif_log_status(struct file *filep, void *priv)
 
 /* vpif display ioctl operations */
 static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
-	.vidioc_querycap        	= vpif_querycap,
-	.vidioc_g_priority		= vpif_g_priority,
-	.vidioc_s_priority		= vpif_s_priority,
+	.vidioc_querycap		= vpif_querycap,
 	.vidioc_enum_fmt_vid_out	= vpif_enum_fmt_vid_out,
-	.vidioc_g_fmt_vid_out  		= vpif_g_fmt_vid_out,
-	.vidioc_s_fmt_vid_out   	= vpif_s_fmt_vid_out,
-	.vidioc_try_fmt_vid_out 	= vpif_try_fmt_vid_out,
-	.vidioc_reqbufs         	= vpif_reqbufs,
-	.vidioc_querybuf        	= vpif_querybuf,
-	.vidioc_qbuf            	= vpif_qbuf,
-	.vidioc_dqbuf           	= vpif_dqbuf,
-	.vidioc_streamon        	= vpif_streamon,
-	.vidioc_streamoff       	= vpif_streamoff,
-	.vidioc_s_std           	= vpif_s_std,
+	.vidioc_g_fmt_vid_out		= vpif_g_fmt_vid_out,
+	.vidioc_s_fmt_vid_out		= vpif_s_fmt_vid_out,
+	.vidioc_try_fmt_vid_out		= vpif_try_fmt_vid_out,
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
+	.vidioc_s_std			= vpif_s_std,
 	.vidioc_g_std			= vpif_g_std,
+
 	.vidioc_enum_output		= vpif_enum_output,
 	.vidioc_s_output		= vpif_s_output,
 	.vidioc_g_output		= vpif_g_output,
-	.vidioc_cropcap         	= vpif_cropcap,
-	.vidioc_enum_dv_timings         = vpif_enum_dv_timings,
-	.vidioc_s_dv_timings            = vpif_s_dv_timings,
-	.vidioc_g_dv_timings            = vpif_g_dv_timings,
+
+	.vidioc_enum_dv_timings		= vpif_enum_dv_timings,
+	.vidioc_s_dv_timings		= vpif_s_dv_timings,
+	.vidioc_g_dv_timings		= vpif_g_dv_timings,
+
 	.vidioc_log_status		= vpif_log_status,
 };
 
 static const struct v4l2_file_operations vpif_fops = {
 	.owner		= THIS_MODULE,
-	.open		= vpif_open,
-	.release	= vpif_release,
+	.open		= v4l2_fh_open,
+	.release	= vb2_fop_release,
 	.unlocked_ioctl	= video_ioctl2,
-	.mmap		= vpif_mmap,
-	.poll		= vpif_poll
-};
-
-static struct video_device vpif_video_template = {
-	.name		= "vpif",
-	.fops		= &vpif_fops,
-	.ioctl_ops	= &vpif_ioctl_ops,
+	.mmap		= vb2_fop_mmap,
+	.poll		= vb2_fop_poll,
 };
 
-/*Configure the channels, buffer sizei, request irq */
+/* Configure the channels, buffer size */
 static int initialize_vpif(void)
 {
 	int free_channel_objects_index;
-	int free_buffer_channel_index;
-	int free_buffer_index;
-	int err = 0, i, j;
-
-	/* Default number of buffers should be 3 */
-	if ((ch2_numbuffers > 0) &&
-	    (ch2_numbuffers < config_params.min_numbuffers))
-		ch2_numbuffers = config_params.min_numbuffers;
-	if ((ch3_numbuffers > 0) &&
-	    (ch3_numbuffers < config_params.min_numbuffers))
-		ch3_numbuffers = config_params.min_numbuffers;
-
-	/* Set buffer size to min buffers size if invalid buffer size is
-	 * given */
-	if (ch2_bufsize < config_params.min_bufsize[VPIF_CHANNEL2_VIDEO])
-		ch2_bufsize =
-		    config_params.min_bufsize[VPIF_CHANNEL2_VIDEO];
-	if (ch3_bufsize < config_params.min_bufsize[VPIF_CHANNEL3_VIDEO])
-		ch3_bufsize =
-		    config_params.min_bufsize[VPIF_CHANNEL3_VIDEO];
-
-	config_params.numbuffers[VPIF_CHANNEL2_VIDEO] = ch2_numbuffers;
-
-	if (ch2_numbuffers) {
-		config_params.channel_bufsize[VPIF_CHANNEL2_VIDEO] =
-							ch2_bufsize;
-	}
-	config_params.numbuffers[VPIF_CHANNEL3_VIDEO] = ch3_numbuffers;
-
-	if (ch3_numbuffers) {
-		config_params.channel_bufsize[VPIF_CHANNEL3_VIDEO] =
-							ch3_bufsize;
-	}
+	int err, i, j;
 
 	/* Allocate memory for six channel objects */
 	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
@@ -1604,10 +1145,6 @@ static int initialize_vpif(void)
 		}
 	}
 
-	free_channel_objects_index = VPIF_DISPLAY_MAX_DEVICES;
-	free_buffer_channel_index = VPIF_DISPLAY_NUM_CHANNELS;
-	free_buffer_index = config_params.numbuffers[i - 1];
-
 	return 0;
 
 vpif_init_free_channel_objects:
@@ -1635,22 +1172,21 @@ static int vpif_async_bound(struct v4l2_async_notifier *notifier,
 
 static int vpif_probe_complete(void)
 {
+	static const struct v4l2_dv_timings timings_defualt =
+		V4L2_DV_BT_CEA_1280X720P60;
 	struct common_obj *common;
+	struct video_device *vdev;
 	struct channel_obj *ch;
+	struct vb2_queue *q;
 	int j, err, k;
 
 	for (j = 0; j < VPIF_DISPLAY_MAX_DEVICES; j++) {
 		ch = vpif_obj.dev[j];
 		/* Initialize field of the channel objects */
-		atomic_set(&ch->usrs, 0);
 		for (k = 0; k < VPIF_NUMOBJECTS; k++) {
-			ch->common[k].numbuffers = 0;
 			common = &ch->common[k];
-			common->io_usrs = 0;
-			common->started = 0;
 			spin_lock_init(&common->irqlock);
 			mutex_init(&common->lock);
-			common->numbuffers = 0;
 			common->set_addr = NULL;
 			common->ytop_off = 0;
 			common->ybtm_off = 0;
@@ -1659,40 +1195,77 @@ static int vpif_probe_complete(void)
 			common->cur_frm = NULL;
 			common->next_frm = NULL;
 			memset(&common->fmt, 0, sizeof(common->fmt));
-			common->numbuffers = config_params.numbuffers[k];
 		}
-		ch->initialized = 0;
+
 		if (vpif_obj.config->subdev_count)
 			ch->sd = vpif_obj.sd[0];
+
 		ch->channel_id = j;
-		if (j < 2)
-			ch->common[VPIF_VIDEO_INDEX].numbuffers =
-			    config_params.numbuffers[ch->channel_id];
-		else
-			ch->common[VPIF_VIDEO_INDEX].numbuffers = 0;
 
 		memset(&ch->vpifparams, 0, sizeof(ch->vpifparams));
 
-		/* Initialize prio member of channel object */
-		v4l2_prio_init(&ch->prio);
 		ch->common[VPIF_VIDEO_INDEX].fmt.type =
 						V4L2_BUF_TYPE_VIDEO_OUTPUT;
-		ch->video_dev->lock = &common->lock;
-		video_set_drvdata(ch->video_dev, ch);
 
 		/* select output 0 */
 		err = vpif_set_output(vpif_obj.config, ch, 0);
 		if (err)
 			goto probe_out;
 
+		/* set default format */
+		ch->video.dv_timings = timings_defualt;
+		ch->video.stdid = V4L2_STD_525_60;
+		vpif_update_resolution(ch);
+
+		/* Initialize vb2 queue */
+		q = &common->buffer_queue;
+		q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+		q->drv_priv = ch;
+		q->ops = &video_qops;
+		q->mem_ops = &vb2_dma_contig_memops;
+		q->buf_struct_size = sizeof(struct vpif_disp_buffer);
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
+		vdev->vfl_dir = VFL_DIR_TX;
+		set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);
+		video_set_drvdata(vdev, ch);
+
 		/* register video device */
+		err = video_register_device(vdev,
+					    VFL_TYPE_GRABBER, (j ? 3 : 2));
+		if (err < 0)
+			goto probe_out;
 		vpif_dbg(1, debug, "channel=%x,channel->video_dev=%x\n",
 			 (int)ch, (int)&ch->video_dev);
 
-		err = video_register_device(ch->video_dev,
-					  VFL_TYPE_GRABBER, (j ? 3 : 2));
-		if (err < 0)
-			goto probe_out;
 	}
 
 	return 0;
@@ -1700,6 +1273,9 @@ static int vpif_probe_complete(void)
 probe_out:
 	for (k = 0; k < j; k++) {
 		ch = vpif_obj.dev[k];
+		common = &ch->common[k];
+
+		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
 		video_unregister_device(ch->video_dev);
 		video_device_release(ch->video_dev);
 		ch->video_dev = NULL;
@@ -1726,7 +1302,6 @@ static __init int vpif_probe(struct platform_device *pdev)
 	struct video_device *vfd;
 	struct resource *res;
 	int subdev_count;
-	size_t size;
 
 	vpif_dev = &pdev->dev;
 	err = initialize_vpif();
@@ -1744,7 +1319,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 
 	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, res_idx))) {
 		err = devm_request_irq(&pdev->dev, res->start, vpif_channel_isr,
-					IRQF_SHARED, "VPIF_Display",
+					IRQF_SHARED, VPIF_DRIVER_NAME,
 					(void *)(&vpif_obj.dev[res_idx]->
 					channel_id));
 		if (err) {
@@ -1770,36 +1345,10 @@ static __init int vpif_probe(struct platform_device *pdev)
 			goto vpif_unregister;
 		}
 
-		/* Initialize field of video device */
-		*vfd = vpif_video_template;
-		vfd->v4l2_dev = &vpif_obj.v4l2_dev;
-		vfd->release = video_device_release;
-		vfd->vfl_dir = VFL_DIR_TX;
-		snprintf(vfd->name, sizeof(vfd->name),
-			 "VPIF_Display_DRIVER_V%s",
-			 VPIF_DISPLAY_VERSION);
-
 		/* Set video_dev to the video device */
 		ch->video_dev = vfd;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res) {
-		size = resource_size(res);
-		/* The resources are divided into two equal memory and when
-		 * we have HD output we can add them together
-		 */
-		for (j = 0; j < VPIF_DISPLAY_MAX_DEVICES; j++) {
-			ch = vpif_obj.dev[j];
-			ch->channel_id = j;
-
-			/* only enabled if second resource exists */
-			config_params.video_limit[ch->channel_id] = 0;
-			if (size)
-				config_params.video_limit[ch->channel_id] =
-									size/2;
-		}
-	}
 	vpif_obj.config = pdev->dev.platform_data;
 	subdev_count = vpif_obj.config->subdev_count;
 	subdevdata = vpif_obj.config->subdevinfo;
@@ -1865,6 +1414,7 @@ vpif_unregister:
  */
 static int vpif_remove(struct platform_device *device)
 {
+	struct common_obj *common;
 	struct channel_obj *ch;
 	int i;
 
@@ -1875,9 +1425,11 @@ static int vpif_remove(struct platform_device *device)
 	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
+		common = &ch->common[i];
 		/* Unregister video device */
 		video_unregister_device(ch->video_dev);
 
+		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
 		ch->video_dev = NULL;
 		kfree(vpif_obj.dev[i]);
 	}
@@ -1885,7 +1437,7 @@ static int vpif_remove(struct platform_device *device)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int vpif_suspend(struct device *dev)
 {
 	struct common_obj *common;
@@ -1896,18 +1448,19 @@ static int vpif_suspend(struct device *dev)
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
 		common = &ch->common[VPIF_VIDEO_INDEX];
+
+		if (!vb2_is_streaming(&common->buffer_queue))
+			continue;
+
 		mutex_lock(&common->lock);
-		if (atomic_read(&ch->usrs) && common->io_usrs) {
-			/* Disable channel */
-			if (ch->channel_id == VPIF_CHANNEL2_VIDEO) {
-				enable_channel2(0);
-				channel2_intr_enable(0);
-			}
-			if (ch->channel_id == VPIF_CHANNEL3_VIDEO ||
-					common->started == 2) {
-				enable_channel3(0);
-				channel3_intr_enable(0);
-			}
+		/* Disable channel */
+		if (ch->channel_id == VPIF_CHANNEL2_VIDEO) {
+			enable_channel2(0);
+			channel2_intr_enable(0);
+		}
+		if (ch->channel_id == VPIF_CHANNEL3_VIDEO || ycmux_mode == 2) {
+			enable_channel3(0);
+			channel3_intr_enable(0);
 		}
 		mutex_unlock(&common->lock);
 	}
@@ -1926,40 +1479,34 @@ static int vpif_resume(struct device *dev)
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
 		common = &ch->common[VPIF_VIDEO_INDEX];
+
+		if (!vb2_is_streaming(&common->buffer_queue))
+			continue;
+
 		mutex_lock(&common->lock);
-		if (atomic_read(&ch->usrs) && common->io_usrs) {
-			/* Enable channel */
-			if (ch->channel_id == VPIF_CHANNEL2_VIDEO) {
-				enable_channel2(1);
-				channel2_intr_enable(1);
-			}
-			if (ch->channel_id == VPIF_CHANNEL3_VIDEO ||
-					common->started == 2) {
-				enable_channel3(1);
-				channel3_intr_enable(1);
-			}
+		/* Enable channel */
+		if (ch->channel_id == VPIF_CHANNEL2_VIDEO) {
+			enable_channel2(1);
+			channel2_intr_enable(1);
+		}
+		if (ch->channel_id == VPIF_CHANNEL3_VIDEO || ycmux_mode == 2) {
+			enable_channel3(1);
+			channel3_intr_enable(1);
 		}
 		mutex_unlock(&common->lock);
 	}
 
 	return 0;
 }
-
-static const struct dev_pm_ops vpif_pm = {
-	.suspend        = vpif_suspend,
-	.resume         = vpif_resume,
-};
-
-#define vpif_pm_ops (&vpif_pm)
-#else
-#define vpif_pm_ops NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(vpif_pm_ops, vpif_suspend, vpif_resume);
+
 static __refdata struct platform_driver vpif_driver = {
 	.driver	= {
-			.name	= "vpif_display",
+			.name	= VPIF_DRIVER_NAME,
 			.owner	= THIS_MODULE,
-			.pm	= vpif_pm_ops,
+			.pm	= &vpif_pm_ops,
 	},
 	.probe	= vpif_probe,
 	.remove	= vpif_remove,
diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
index 4d0485b..a5985d9 100644
--- a/drivers/media/platform/davinci/vpif_display.h
+++ b/drivers/media/platform/davinci/vpif_display.h
@@ -13,8 +13,8 @@
  * GNU General Public License for more details.
  */
 
-#ifndef DAVINCIHD_DISPLAY_H
-#define DAVINCIHD_DISPLAY_H
+#ifndef VPIF_DISPLAY_H
+#define VPIF_DISPLAY_H
 
 /* Header files */
 #include <media/videobuf2-dma-contig.h>
@@ -67,17 +67,10 @@ struct vpif_disp_buffer {
 };
 
 struct common_obj {
-	/* Buffer specific parameters */
-	u8 *fbuffers[VIDEO_MAX_FRAME];		/* List of buffer pointers for
-						 * storing frames */
-	u32 numbuffers;				/* number of buffers */
 	struct vpif_disp_buffer *cur_frm;	/* Pointer pointing to current
 						 * vb2_buffer */
 	struct vpif_disp_buffer *next_frm;	/* Pointer pointing to next
 						 * vb2_buffer */
-	enum v4l2_memory memory;		/* This field keeps track of
-						 * type of buffer exchange
-						 * method user has selected */
 	struct v4l2_format fmt;			/* Used to store the format */
 	struct vb2_queue buffer_queue;		/* Buffer queue used in
 						 * video-buf */
@@ -90,10 +83,6 @@ struct common_obj {
 	/* channel specific parameters */
 	struct mutex lock;			/* lock used to access this
 						 * structure */
-	u32 io_usrs;				/* number of users performing
-						 * IO */
-	u8 started;				/* Indicates whether streaming
-						 * started */
 	u32 ytop_off;				/* offset of Y top from the
 						 * starting of the buffer */
 	u32 ybtm_off;				/* offset of Y bottom from the
@@ -103,7 +92,7 @@ struct common_obj {
 	u32 cbtm_off;				/* offset of C bottom from the
 						 * starting of the buffer */
 	/* Function pointer to set the addresses */
-	void (*set_addr) (unsigned long, unsigned long,
+	void (*set_addr)(unsigned long, unsigned long,
 				unsigned long, unsigned long);
 	u32 height;
 	u32 width;
@@ -113,14 +102,8 @@ struct channel_obj {
 	/* V4l2 specific parameters */
 	struct video_device *video_dev;	/* Identifies video device for
 					 * this channel */
-	struct v4l2_prio_state prio;	/* Used to keep track of state of
-					 * the priority */
-	atomic_t usrs;			/* number of open instances of
-					 * the channel */
 	u32 field_id;			/* Indicates id of the field
 					 * which is being displayed */
-	u8 initialized;			/* flag to indicate whether
-					 * encoder is initialized */
 	u32 output_idx;			/* Current output index */
 	struct v4l2_subdev *sd;		/* Current output subdev(may be NULL) */
 
@@ -130,19 +113,6 @@ struct channel_obj {
 	struct video_obj video;
 };
 
-/* File handle structure */
-struct vpif_fh {
-	struct channel_obj *channel;	/* pointer to channel object for
-					 * opened device */
-	u8 io_allowed[VPIF_NUMOBJECTS];	/* Indicates whether this file handle
-					 * is doing IO */
-	enum v4l2_priority prio;	/* Used to keep track priority of
-					 * this instance */
-	u8 initialized;			/* Used to keep track of whether this
-					 * file handle has initialized
-					 * channel or not */
-};
-
 /* vpif device structure */
 struct vpif_device {
 	struct v4l2_device v4l2_dev;
@@ -152,12 +122,4 @@ struct vpif_device {
 	struct vpif_display_config *config;
 };
 
-struct vpif_config_params {
-	u32 min_bufsize[VPIF_DISPLAY_NUM_CHANNELS];
-	u32 channel_bufsize[VPIF_DISPLAY_NUM_CHANNELS];
-	u8 numbuffers[VPIF_DISPLAY_NUM_CHANNELS];
-	u32 video_limit[VPIF_DISPLAY_NUM_CHANNELS];
-	u8 min_numbuffers;
-};
-
-#endif				/* DAVINCIHD_DISPLAY_H */
+#endif				/* VPIF_DISPLAY_H */
-- 
1.7.9.5

