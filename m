Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:46642 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753199AbdCFLWX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 06:22:23 -0500
Subject: [PATCH] atomisp2: unify some ifdef cases caused by format changes
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 06 Mar 2017 11:21:04 +0000
Message-ID: <148879924465.10733.17814546240558419917.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The two drivers were originally merged by tools, and the tools didn't always
spot white space only changes. Fix a few of them found by zero-day and clean
up some more by hand.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |   29 -------
 .../media/atomisp/pci/atomisp2/atomisp_ioctl.c     |   21 -----
 .../media/atomisp/pci/atomisp2/atomisp_subdev.c    |   81 --------------------
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      |    8 --
 4 files changed, 6 insertions(+), 133 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index e99f7b8..d9a5c24 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -1099,15 +1099,9 @@ void atomisp_buf_done(struct atomisp_sub_device *asd, int error,
 		WARN_ON(!vb);
 		if (vb)
 			pipe->frame_config_id[vb->i] = frame->isp_config_id;
-#ifndef ISP2401
 		if (css_pipe_id == IA_CSS_PIPE_ID_CAPTURE &&
 		    asd->pending_capture_request > 0) {
 			err = atomisp_css_offline_capture_configure(asd,
-#else
-		if (css_pipe_id == IA_CSS_PIPE_ID_CAPTURE) {
-			if (asd->pending_capture_request > 0) {
-				err = atomisp_css_offline_capture_configure(asd,
-#endif
 					asd->params.offline_parm.num_captures,
 					asd->params.offline_parm.skip_frames,
 					asd->params.offline_parm.offset);
@@ -1298,9 +1292,7 @@ void atomisp_buf_done(struct atomisp_sub_device *asd, int error,
 		 */
 		wake_up(&vb->done);
 	}
-#ifndef ISP2401
-
-#else
+#ifdef ISP2401
 	atomic_set(&pipe->wdt_count, 0);
 #endif
 	/*
@@ -4995,26 +4987,15 @@ int atomisp_try_fmt(struct video_device *vdev, struct v4l2_format *f,
 {
 	struct atomisp_device *isp = video_get_drvdata(vdev);
 	struct atomisp_sub_device *asd = atomisp_to_video_pipe(vdev)->asd;
-#ifndef ISP2401
 	struct v4l2_subdev_pad_config pad_cfg;
-#else
-    struct v4l2_subdev_pad_config pad_cfg;
-#endif
 	struct v4l2_subdev_format format = {
 		.which = V4L2_SUBDEV_FORMAT_TRY,
-#ifndef ISP2401
 	};
-#else
-		};
-#endif
+
 	struct v4l2_mbus_framefmt *snr_mbus_fmt = &format.format;
 	const struct atomisp_format_bridge *fmt;
 	struct atomisp_input_stream_info *stream_info =
-#ifndef ISP2401
 	    (struct atomisp_input_stream_info *)snr_mbus_fmt->reserved;
-#else
-		(struct atomisp_input_stream_info *)snr_mbus_fmt->reserved;
-#endif
 	uint16_t stream_index;
 	int source_pad = atomisp_subdev_source_pad(vdev);
 	int ret;
@@ -5044,11 +5025,7 @@ int atomisp_try_fmt(struct video_device *vdev, struct v4l2_format *f,
 		snr_mbus_fmt->width, snr_mbus_fmt->height);
 
 	ret = v4l2_subdev_call(isp->inputs[asd->input_curr].camera,
-#ifndef ISP2401
 			       pad, set_fmt, &pad_cfg, &format);
-#else
-			pad, set_fmt, &pad_cfg, &format);
-#endif
 	if (ret)
 		return ret;
 
@@ -6454,9 +6431,7 @@ int atomisp_s_ae_window(struct atomisp_sub_device *asd,
 			struct atomisp_ae_window *arg)
 {
 	struct atomisp_device *isp = asd->isp;
-#ifndef ISP2401
 	/* Coverity CID 298071 - initialzize struct */
-#endif
 	struct v4l2_subdev_selection sel = { 0 };
 
 	sel.r.left = arg->x_left;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
index 1445279..6064bb8 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
@@ -530,13 +530,8 @@ const struct atomisp_format_bridge *atomisp_get_format_bridge(
 	return NULL;
 }
 
-#ifndef ISP2401
 const struct atomisp_format_bridge *atomisp_get_format_bridge_from_mbus(
 	u32 mbus_code)
-#else
-const struct atomisp_format_bridge *atomisp_get_format_bridge_from_mbus(u32
-									mbus_code)
-#endif
 {
 	unsigned int i;
 
@@ -1303,14 +1298,8 @@ static int atomisp_qbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 		/* this buffer will have a per-frame parameter */
 		pipe->frame_request_config_id[buf->index] = buf->reserved2 &
 					~ATOMISP_BUFFER_HAS_PER_FRAME_SETTING;
-#ifndef ISP2401
 		dev_dbg(isp->dev, "This buffer requires per_frame setting which has isp_config_id %d\n",
 			pipe->frame_request_config_id[buf->index]);
-#else
-		dev_dbg(isp->dev, "This buffer requires per_frame setting \
-				which has isp_config_id %d\n",
-				pipe->frame_request_config_id[buf->index]);
-#endif
 	} else {
 		pipe->frame_request_config_id[buf->index] = 0;
 	}
@@ -1494,12 +1483,7 @@ static int atomisp_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 	buf->reserved2 = pipe->frame_config_id[buf->index];
 	rt_mutex_unlock(&isp->mutex);
 
-#ifndef ISP2401
 	dev_dbg(isp->dev, "dqbuf buffer %d (%s) for asd%d with exp_id %d, isp_config_id %d\n",
-#else
-	dev_dbg(isp->dev, "dqbuf buffer %d (%s) for asd%d with exp_id %d, \
-			isp_config_id %d\n",
-#endif
 		buf->index, vdev->name, asd->index, buf->reserved >> 16,
 		buf->reserved2);
 	return 0;
@@ -1570,12 +1554,9 @@ static unsigned int atomisp_sensor_start_stream(struct atomisp_sub_device *asd)
 	else
 		return 1;
 }
-#ifndef ISP2401
-int atomisp_stream_on_master_slave_sensor(struct atomisp_device *isp, bool isp_timeout)
-#else
+
 int atomisp_stream_on_master_slave_sensor(struct atomisp_device *isp,
 	bool isp_timeout)
-#endif
 {
 	unsigned int master = -1, slave = -1, delay_slave = 0;
 	int i, ret;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
index eecd5fc..3d6bb16 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
@@ -322,17 +322,10 @@ static void isp_subdev_propagate(struct v4l2_subdev *sd,
 		r.width = ffmt[pad]->width;
 		r.height = ffmt[pad]->height;
 
-#ifndef ISP2401
-		atomisp_subdev_set_selection(sd, cfg, which, pad, target, flags,
-					     &r);
+		atomisp_subdev_set_selection(sd, cfg, which, pad,
+					     target, flags, &r);
 		break;
 	}
-#else
-			atomisp_subdev_set_selection(sd, cfg, which, pad,
-						     target, flags, &r);
-			break;
-		}
-#endif
 	}
 }
 
@@ -444,19 +437,10 @@ int atomisp_subdev_set_selection(struct v4l2_subdev *sd,
 			     i < ATOMISP_SUBDEV_PADS_NUM; i++) {
 				struct v4l2_rect tmp = *crop[pad];
 
-#ifndef ISP2401
 				atomisp_subdev_set_selection(
 					sd, cfg, which, i, V4L2_SEL_TGT_COMPOSE,
 					flags, &tmp);
 			}
-#else
-					atomisp_subdev_set_selection(sd, cfg,
-								     which, i,
-								     V4L2_SEL_TGT_COMPOSE,
-								     flags,
-								     &tmp);
-				}
-#endif
 		}
 
 		if (which == V4L2_SUBDEV_FORMAT_TRY)
@@ -611,24 +595,14 @@ static int atomisp_get_sensor_bin_factor(struct atomisp_sub_device *asd)
 	return hbin;
 }
 
-#ifndef ISP2401
-void atomisp_subdev_set_ffmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
-			     uint32_t which, uint32_t pad,
-			     struct v4l2_mbus_framefmt *ffmt)
-#else
 void atomisp_subdev_set_ffmt(struct v4l2_subdev *sd,
 			     struct v4l2_subdev_pad_config *cfg, uint32_t which,
 			     uint32_t pad, struct v4l2_mbus_framefmt *ffmt)
-#endif
 {
 	struct atomisp_sub_device *isp_sd = v4l2_get_subdevdata(sd);
 	struct atomisp_device *isp = isp_sd->isp;
 	struct v4l2_mbus_framefmt *__ffmt =
-#ifndef ISP2401
 		atomisp_subdev_get_ffmt(sd, cfg, which, pad);
-#else
-	    atomisp_subdev_get_ffmt(sd, cfg, which, pad);
-#endif
 	uint16_t vdev_pad = atomisp_subdev_source_pad(sd->devnode);
 	enum atomisp_input_stream_id stream_id;
 
@@ -692,12 +666,8 @@ void atomisp_subdev_set_ffmt(struct v4l2_subdev *sd,
  * to the format type.
  */
 static int isp_subdev_get_format(struct v4l2_subdev *sd,
-#ifndef ISP2401
-	struct v4l2_subdev_pad_config *cfg, struct v4l2_subdev_format *fmt)
-#else
 				 struct v4l2_subdev_pad_config *cfg,
 				 struct v4l2_subdev_format *fmt)
-#endif
 {
 	fmt->format = *atomisp_subdev_get_ffmt(sd, cfg, fmt->which, fmt->pad);
 
@@ -715,12 +685,8 @@ static int isp_subdev_get_format(struct v4l2_subdev *sd,
  * to the format type.
  */
 static int isp_subdev_set_format(struct v4l2_subdev *sd,
-#ifndef ISP2401
-	struct v4l2_subdev_pad_config *cfg, struct v4l2_subdev_format *fmt)
-#else
 				 struct v4l2_subdev_pad_config *cfg,
 				 struct v4l2_subdev_format *fmt)
-#endif
 {
 	atomisp_subdev_set_ffmt(sd, cfg, fmt->which, fmt->pad, &fmt->format);
 
@@ -736,30 +702,18 @@ static const struct v4l2_subdev_core_ops isp_subdev_v4l2_core_ops = {
 
 /* V4L2 subdev pad operations */
 static const struct v4l2_subdev_pad_ops isp_subdev_v4l2_pad_ops = {
-#ifndef ISP2401
-	 .enum_mbus_code = isp_subdev_enum_mbus_code,
-	 .get_fmt = isp_subdev_get_format, .set_fmt = isp_subdev_set_format,
-	 .get_selection = isp_subdev_get_selection,
-	 .set_selection = isp_subdev_set_selection,
-	 .link_validate = v4l2_subdev_link_validate_default,
-#else
 	.enum_mbus_code = isp_subdev_enum_mbus_code,
 	.get_fmt = isp_subdev_get_format,
 	.set_fmt = isp_subdev_set_format,
 	.get_selection = isp_subdev_get_selection,
 	.set_selection = isp_subdev_set_selection,
 	.link_validate = v4l2_subdev_link_validate_default,
-#endif
 };
 
 /* V4L2 subdev operations */
 static const struct v4l2_subdev_ops isp_subdev_v4l2_ops = {
-#ifndef ISP2401
-	 .core = &isp_subdev_v4l2_core_ops, .pad = &isp_subdev_v4l2_pad_ops,
-#else
 	.core = &isp_subdev_v4l2_core_ops,
 	.pad = &isp_subdev_v4l2_pad_ops,
-#endif
 };
 
 static void isp_subdev_init_params(struct atomisp_sub_device *asd)
@@ -1187,12 +1141,8 @@ static int isp_subdev_init_entities(struct atomisp_sub_device *asd)
 	pads[ATOMISP_SUBDEV_PAD_SOURCE_CAPTURE].flags = MEDIA_PAD_FL_SOURCE;
 	pads[ATOMISP_SUBDEV_PAD_SOURCE_VIDEO].flags = MEDIA_PAD_FL_SOURCE;
 
-#ifndef ISP2401
 	asd->fmt[ATOMISP_SUBDEV_PAD_SINK].fmt.code =
 		MEDIA_BUS_FMT_SBGGR10_1X10;
-#else
-	asd->fmt[ATOMISP_SUBDEV_PAD_SINK].fmt.code = MEDIA_BUS_FMT_SBGGR10_1X10;
-#endif
 	asd->fmt[ATOMISP_SUBDEV_PAD_SOURCE_PREVIEW].fmt.code =
 		MEDIA_BUS_FMT_SBGGR10_1X10;
 	asd->fmt[ATOMISP_SUBDEV_PAD_SOURCE_VF].fmt.code =
@@ -1209,39 +1159,19 @@ static int isp_subdev_init_entities(struct atomisp_sub_device *asd)
 		return ret;
 
 	atomisp_init_subdev_pipe(asd, &asd->video_in,
-#ifndef ISP2401
-			V4L2_BUF_TYPE_VIDEO_OUTPUT);
-#else
 				 V4L2_BUF_TYPE_VIDEO_OUTPUT);
-#endif
 
 	atomisp_init_subdev_pipe(asd, &asd->video_out_preview,
-#ifndef ISP2401
-			V4L2_BUF_TYPE_VIDEO_CAPTURE);
-#else
 				 V4L2_BUF_TYPE_VIDEO_CAPTURE);
-#endif
 
 	atomisp_init_subdev_pipe(asd, &asd->video_out_vf,
-#ifndef ISP2401
-			V4L2_BUF_TYPE_VIDEO_CAPTURE);
-#else
 				 V4L2_BUF_TYPE_VIDEO_CAPTURE);
-#endif
 
 	atomisp_init_subdev_pipe(asd, &asd->video_out_capture,
-#ifndef ISP2401
-			V4L2_BUF_TYPE_VIDEO_CAPTURE);
-#else
 				 V4L2_BUF_TYPE_VIDEO_CAPTURE);
-#endif
 
 	atomisp_init_subdev_pipe(asd, &asd->video_out_video_capture,
-#ifndef ISP2401
-			V4L2_BUF_TYPE_VIDEO_CAPTURE);
-#else
 				 V4L2_BUF_TYPE_VIDEO_CAPTURE);
-#endif
 
 	atomisp_init_acc_pipe(asd, &asd->video_acc);
 
@@ -1401,11 +1331,7 @@ void atomisp_subdev_cleanup_pending_events(struct atomisp_sub_device *asd)
 	unsigned int i, pending_event;
 
 	list_for_each_entry_safe(fh, fh_tmp,
-#ifndef ISP2401
 		&asd->subdev.devnode->fh_list, list) {
-#else
-				 &asd->subdev.devnode->fh_list, list) {
-#endif
 		pending_event = v4l2_event_pending(fh);
 		for (i = 0; i < pending_event; i++)
 			v4l2_event_dequeue(fh, &event, 1);
@@ -1471,9 +1397,6 @@ int atomisp_subdev_register_entities(struct atomisp_sub_device *asd,
 	return ret;
 }
 
-#ifndef ISP2401
-
-#endif
 /*
  * atomisp_subdev_init - ISP Subdevice  initialization.
  * @dev: Device pointer specific to the ATOM ISP.
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index 9d6d67c..800562d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -906,9 +906,7 @@ static int atomisp_register_entities(struct atomisp_device *isp)
 
 	strlcpy(isp->media_dev.model, "Intel Atom ISP",
 		sizeof(isp->media_dev.model));
-#ifndef ISP2401
 
-#endif
 	media_device_init(&isp->media_dev);
 	isp->v4l2_dev.mdev = &isp->media_dev;
 	ret = v4l2_device_register(isp->dev, &isp->v4l2_dev);
@@ -1545,16 +1543,12 @@ static int atomisp_pci_probe(struct pci_dev *dev,
 	atomisp_msi_irq_uninit(isp, dev);
 
 	atomisp_ospm_dphy_down(isp);
-#ifndef ISP2401
+
 	/* Address later when we worry about the ...field chips */
-#endif
 	if (ATOMISP_INTERNAL_PM) {
 		if (atomisp_mrfld_power_down(isp))
 			dev_err(&dev->dev, "Failed to switch off ISP\n");
 	}
-#ifdef ISP2401
-
-#endif
 	pci_dev_put(isp->pci_root);
 	return err;
 }
