Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21746 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751286AbeEUIzY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 04:55:24 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v14 34/36] vivid: add request support
Date: Mon, 21 May 2018 11:54:59 +0300
Message-Id: <20180521085501.16861-35-sakari.ailus@linux.intel.com>
In-Reply-To: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
References: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for requests to vivid.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.c        |  8 ++++++++
 drivers/media/platform/vivid/vivid-kthread-cap.c | 12 ++++++++++++
 drivers/media/platform/vivid/vivid-kthread-out.c | 12 ++++++++++++
 drivers/media/platform/vivid/vivid-sdr-cap.c     | 16 ++++++++++++++++
 drivers/media/platform/vivid/vivid-vbi-cap.c     | 10 ++++++++++
 drivers/media/platform/vivid/vivid-vbi-out.c     | 10 ++++++++++
 drivers/media/platform/vivid/vivid-vid-cap.c     | 10 ++++++++++
 drivers/media/platform/vivid/vivid-vid-out.c     | 10 ++++++++++
 8 files changed, 88 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 69386b26d5dd1..a84c7e37c22b4 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -627,6 +627,13 @@ static void vivid_dev_release(struct v4l2_device *v4l2_dev)
 	kfree(dev);
 }
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+static const struct media_device_ops vivid_media_ops = {
+	.req_validate = vb2_request_validate,
+	.req_queue = vb2_request_queue,
+};
+#endif
+
 static int vivid_create_instance(struct platform_device *pdev, int inst)
 {
 	static const struct v4l2_dv_timings def_dv_timings =
@@ -664,6 +671,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 	strlcpy(dev->mdev.model, VIVID_MODULE_NAME, sizeof(dev->mdev.model));
 	dev->mdev.dev = &pdev->dev;
 	media_device_init(&dev->mdev);
+	dev->mdev.ops = &vivid_media_ops;
 #endif
 
 	/* register v4l2_device */
diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 3fdb280c36caf..c192b4b1b9ded 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -703,6 +703,8 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
 		goto update_mv;
 
 	if (vid_cap_buf) {
+		v4l2_ctrl_request_setup(vid_cap_buf->vb.vb2_buf.req_obj.req,
+					&dev->ctrl_hdl_vid_cap);
 		/* Fill buffer */
 		vivid_fillbuff(dev, vid_cap_buf);
 		dprintk(dev, 1, "filled buffer %d\n",
@@ -713,6 +715,8 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
 			dev->fb_cap.fmt.pixelformat == dev->fmt_cap->fourcc)
 			vivid_overlay(dev, vid_cap_buf);
 
+		v4l2_ctrl_request_complete(vid_cap_buf->vb.vb2_buf.req_obj.req,
+					   &dev->ctrl_hdl_vid_cap);
 		vb2_buffer_done(&vid_cap_buf->vb.vb2_buf, dev->dqbuf_error ?
 				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vid_cap buffer %d done\n",
@@ -720,10 +724,14 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
 	}
 
 	if (vbi_cap_buf) {
+		v4l2_ctrl_request_setup(vbi_cap_buf->vb.vb2_buf.req_obj.req,
+					&dev->ctrl_hdl_vbi_cap);
 		if (dev->stream_sliced_vbi_cap)
 			vivid_sliced_vbi_cap_process(dev, vbi_cap_buf);
 		else
 			vivid_raw_vbi_cap_process(dev, vbi_cap_buf);
+		v4l2_ctrl_request_complete(vbi_cap_buf->vb.vb2_buf.req_obj.req,
+					   &dev->ctrl_hdl_vbi_cap);
 		vb2_buffer_done(&vbi_cap_buf->vb.vb2_buf, dev->dqbuf_error ?
 				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vbi_cap %d done\n",
@@ -891,6 +899,8 @@ void vivid_stop_generating_vid_cap(struct vivid_dev *dev, bool *pstreaming)
 			buf = list_entry(dev->vid_cap_active.next,
 					 struct vivid_buffer, list);
 			list_del(&buf->list);
+			v4l2_ctrl_request_complete(buf->vb.vb2_buf.req_obj.req,
+						   &dev->ctrl_hdl_vid_cap);
 			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 			dprintk(dev, 2, "vid_cap buffer %d done\n",
 				buf->vb.vb2_buf.index);
@@ -904,6 +914,8 @@ void vivid_stop_generating_vid_cap(struct vivid_dev *dev, bool *pstreaming)
 			buf = list_entry(dev->vbi_cap_active.next,
 					 struct vivid_buffer, list);
 			list_del(&buf->list);
+			v4l2_ctrl_request_complete(buf->vb.vb2_buf.req_obj.req,
+						   &dev->ctrl_hdl_vbi_cap);
 			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 			dprintk(dev, 2, "vbi_cap buffer %d done\n",
 				buf->vb.vb2_buf.index);
diff --git a/drivers/media/platform/vivid/vivid-kthread-out.c b/drivers/media/platform/vivid/vivid-kthread-out.c
index 9981e7548019b..5a14810eeb691 100644
--- a/drivers/media/platform/vivid/vivid-kthread-out.c
+++ b/drivers/media/platform/vivid/vivid-kthread-out.c
@@ -75,6 +75,10 @@ static void vivid_thread_vid_out_tick(struct vivid_dev *dev)
 		return;
 
 	if (vid_out_buf) {
+		v4l2_ctrl_request_setup(vid_out_buf->vb.vb2_buf.req_obj.req,
+					&dev->ctrl_hdl_vid_out);
+		v4l2_ctrl_request_complete(vid_out_buf->vb.vb2_buf.req_obj.req,
+					   &dev->ctrl_hdl_vid_out);
 		vid_out_buf->vb.sequence = dev->vid_out_seq_count;
 		if (dev->field_out == V4L2_FIELD_ALTERNATE) {
 			/*
@@ -92,6 +96,10 @@ static void vivid_thread_vid_out_tick(struct vivid_dev *dev)
 	}
 
 	if (vbi_out_buf) {
+		v4l2_ctrl_request_setup(vbi_out_buf->vb.vb2_buf.req_obj.req,
+					&dev->ctrl_hdl_vbi_out);
+		v4l2_ctrl_request_complete(vbi_out_buf->vb.vb2_buf.req_obj.req,
+					   &dev->ctrl_hdl_vbi_out);
 		if (dev->stream_sliced_vbi_out)
 			vivid_sliced_vbi_out_process(dev, vbi_out_buf);
 
@@ -262,6 +270,8 @@ void vivid_stop_generating_vid_out(struct vivid_dev *dev, bool *pstreaming)
 			buf = list_entry(dev->vid_out_active.next,
 					 struct vivid_buffer, list);
 			list_del(&buf->list);
+			v4l2_ctrl_request_complete(buf->vb.vb2_buf.req_obj.req,
+						   &dev->ctrl_hdl_vid_out);
 			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 			dprintk(dev, 2, "vid_out buffer %d done\n",
 				buf->vb.vb2_buf.index);
@@ -275,6 +285,8 @@ void vivid_stop_generating_vid_out(struct vivid_dev *dev, bool *pstreaming)
 			buf = list_entry(dev->vbi_out_active.next,
 					 struct vivid_buffer, list);
 			list_del(&buf->list);
+			v4l2_ctrl_request_complete(buf->vb.vb2_buf.req_obj.req,
+						   &dev->ctrl_hdl_vbi_out);
 			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 			dprintk(dev, 2, "vbi_out buffer %d done\n",
 				buf->vb.vb2_buf.index);
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index cfb7cb4d37a87..76cf8810a9740 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -102,6 +102,10 @@ static void vivid_thread_sdr_cap_tick(struct vivid_dev *dev)
 
 	if (sdr_cap_buf) {
 		sdr_cap_buf->vb.sequence = dev->sdr_cap_seq_count;
+		v4l2_ctrl_request_setup(sdr_cap_buf->vb.vb2_buf.req_obj.req,
+					&dev->ctrl_hdl_sdr_cap);
+		v4l2_ctrl_request_complete(sdr_cap_buf->vb.vb2_buf.req_obj.req,
+					   &dev->ctrl_hdl_sdr_cap);
 		vivid_sdr_cap_process(dev, sdr_cap_buf);
 		sdr_cap_buf->vb.vb2_buf.timestamp =
 			ktime_get_ns() + dev->time_wrap_offset;
@@ -272,6 +276,8 @@ static int sdr_cap_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->sdr_cap_active, list) {
 			list_del(&buf->list);
+			v4l2_ctrl_request_complete(buf->vb.vb2_buf.req_obj.req,
+						   &dev->ctrl_hdl_sdr_cap);
 			vb2_buffer_done(&buf->vb.vb2_buf,
 					VB2_BUF_STATE_QUEUED);
 		}
@@ -293,6 +299,8 @@ static void sdr_cap_stop_streaming(struct vb2_queue *vq)
 		buf = list_entry(dev->sdr_cap_active.next,
 				struct vivid_buffer, list);
 		list_del(&buf->list);
+		v4l2_ctrl_request_complete(buf->vb.vb2_buf.req_obj.req,
+					   &dev->ctrl_hdl_sdr_cap);
 		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
@@ -303,12 +311,20 @@ static void sdr_cap_stop_streaming(struct vb2_queue *vq)
 	mutex_lock(&dev->mutex);
 }
 
+static void sdr_cap_buf_request_complete(struct vb2_buffer *vb)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+
+	v4l2_ctrl_request_complete(vb->req_obj.req, &dev->ctrl_hdl_sdr_cap);
+}
+
 const struct vb2_ops vivid_sdr_cap_qops = {
 	.queue_setup		= sdr_cap_queue_setup,
 	.buf_prepare		= sdr_cap_buf_prepare,
 	.buf_queue		= sdr_cap_buf_queue,
 	.start_streaming	= sdr_cap_start_streaming,
 	.stop_streaming		= sdr_cap_stop_streaming,
+	.buf_request_complete	= sdr_cap_buf_request_complete,
 	.wait_prepare		= vb2_ops_wait_prepare,
 	.wait_finish		= vb2_ops_wait_finish,
 };
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index 92a852955173e..903cebeb5ce50 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -204,6 +204,8 @@ static int vbi_cap_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vbi_cap_active, list) {
 			list_del(&buf->list);
+			v4l2_ctrl_request_complete(buf->vb.vb2_buf.req_obj.req,
+						   &dev->ctrl_hdl_vbi_cap);
 			vb2_buffer_done(&buf->vb.vb2_buf,
 					VB2_BUF_STATE_QUEUED);
 		}
@@ -220,12 +222,20 @@ static void vbi_cap_stop_streaming(struct vb2_queue *vq)
 	vivid_stop_generating_vid_cap(dev, &dev->vbi_cap_streaming);
 }
 
+static void vbi_cap_buf_request_complete(struct vb2_buffer *vb)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+
+	v4l2_ctrl_request_complete(vb->req_obj.req, &dev->ctrl_hdl_vbi_cap);
+}
+
 const struct vb2_ops vivid_vbi_cap_qops = {
 	.queue_setup		= vbi_cap_queue_setup,
 	.buf_prepare		= vbi_cap_buf_prepare,
 	.buf_queue		= vbi_cap_buf_queue,
 	.start_streaming	= vbi_cap_start_streaming,
 	.stop_streaming		= vbi_cap_stop_streaming,
+	.buf_request_complete	= vbi_cap_buf_request_complete,
 	.wait_prepare		= vb2_ops_wait_prepare,
 	.wait_finish		= vb2_ops_wait_finish,
 };
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index 69486c130a7e4..9357c07e30d64 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.c
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -96,6 +96,8 @@ static int vbi_out_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vbi_out_active, list) {
 			list_del(&buf->list);
+			v4l2_ctrl_request_complete(buf->vb.vb2_buf.req_obj.req,
+						   &dev->ctrl_hdl_vbi_out);
 			vb2_buffer_done(&buf->vb.vb2_buf,
 					VB2_BUF_STATE_QUEUED);
 		}
@@ -115,12 +117,20 @@ static void vbi_out_stop_streaming(struct vb2_queue *vq)
 	dev->vbi_out_have_cc[1] = false;
 }
 
+static void vbi_out_buf_request_complete(struct vb2_buffer *vb)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+
+	v4l2_ctrl_request_complete(vb->req_obj.req, &dev->ctrl_hdl_vbi_out);
+}
+
 const struct vb2_ops vivid_vbi_out_qops = {
 	.queue_setup		= vbi_out_queue_setup,
 	.buf_prepare		= vbi_out_buf_prepare,
 	.buf_queue		= vbi_out_buf_queue,
 	.start_streaming	= vbi_out_start_streaming,
 	.stop_streaming		= vbi_out_stop_streaming,
+	.buf_request_complete	= vbi_out_buf_request_complete,
 	.wait_prepare		= vb2_ops_wait_prepare,
 	.wait_finish		= vb2_ops_wait_finish,
 };
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 1599159f2574e..b2aad441a0711 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -240,6 +240,8 @@ static int vid_cap_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vid_cap_active, list) {
 			list_del(&buf->list);
+			v4l2_ctrl_request_complete(buf->vb.vb2_buf.req_obj.req,
+						   &dev->ctrl_hdl_vid_cap);
 			vb2_buffer_done(&buf->vb.vb2_buf,
 					VB2_BUF_STATE_QUEUED);
 		}
@@ -257,6 +259,13 @@ static void vid_cap_stop_streaming(struct vb2_queue *vq)
 	dev->can_loop_video = false;
 }
 
+static void vid_cap_buf_request_complete(struct vb2_buffer *vb)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+
+	v4l2_ctrl_request_complete(vb->req_obj.req, &dev->ctrl_hdl_vid_cap);
+}
+
 const struct vb2_ops vivid_vid_cap_qops = {
 	.queue_setup		= vid_cap_queue_setup,
 	.buf_prepare		= vid_cap_buf_prepare,
@@ -264,6 +273,7 @@ const struct vb2_ops vivid_vid_cap_qops = {
 	.buf_queue		= vid_cap_buf_queue,
 	.start_streaming	= vid_cap_start_streaming,
 	.stop_streaming		= vid_cap_stop_streaming,
+	.buf_request_complete	= vid_cap_buf_request_complete,
 	.wait_prepare		= vb2_ops_wait_prepare,
 	.wait_finish		= vb2_ops_wait_finish,
 };
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 51fec66d8d455..423a67133f280 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -162,6 +162,8 @@ static int vid_out_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vid_out_active, list) {
 			list_del(&buf->list);
+			v4l2_ctrl_request_complete(buf->vb.vb2_buf.req_obj.req,
+						   &dev->ctrl_hdl_vid_out);
 			vb2_buffer_done(&buf->vb.vb2_buf,
 					VB2_BUF_STATE_QUEUED);
 		}
@@ -179,12 +181,20 @@ static void vid_out_stop_streaming(struct vb2_queue *vq)
 	dev->can_loop_video = false;
 }
 
+static void vid_out_buf_request_complete(struct vb2_buffer *vb)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+
+	v4l2_ctrl_request_complete(vb->req_obj.req, &dev->ctrl_hdl_vid_out);
+}
+
 const struct vb2_ops vivid_vid_out_qops = {
 	.queue_setup		= vid_out_queue_setup,
 	.buf_prepare		= vid_out_buf_prepare,
 	.buf_queue		= vid_out_buf_queue,
 	.start_streaming	= vid_out_start_streaming,
 	.stop_streaming		= vid_out_stop_streaming,
+	.buf_request_complete	= vid_out_buf_request_complete,
 	.wait_prepare		= vb2_ops_wait_prepare,
 	.wait_finish		= vb2_ops_wait_finish,
 };
-- 
2.11.0
