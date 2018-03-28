Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:49961 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753473AbeC1OBr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 10:01:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 29/29] vivid: add request support
Date: Wed, 28 Mar 2018 16:01:40 +0200
Message-Id: <20180328140140.42096-13-hverkuil@xs4all.nl>
In-Reply-To: <20180328140140.42096-1-hverkuil@xs4all.nl>
References: <20180328140140.42096-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for requests to vivid.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.c        |  7 +++++++
 drivers/media/platform/vivid/vivid-kthread-cap.c | 12 ++++++++++++
 drivers/media/platform/vivid/vivid-kthread-out.c | 12 ++++++++++++
 drivers/media/platform/vivid/vivid-sdr-cap.c     |  8 ++++++++
 drivers/media/platform/vivid/vivid-vbi-cap.c     |  2 ++
 drivers/media/platform/vivid/vivid-vbi-out.c     |  2 ++
 drivers/media/platform/vivid/vivid-vid-cap.c     |  2 ++
 drivers/media/platform/vivid/vivid-vid-out.c     |  2 ++
 8 files changed, 47 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 69386b26d5dd..20e74d36b673 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -627,6 +627,12 @@ static void vivid_dev_release(struct v4l2_device *v4l2_dev)
 	kfree(dev);
 }
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+static const struct media_device_ops vivid_media_ops = {
+	.req_queue = vb2_request_queue,
+};
+#endif
+
 static int vivid_create_instance(struct platform_device *pdev, int inst)
 {
 	static const struct v4l2_dv_timings def_dv_timings =
@@ -664,6 +670,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 	strlcpy(dev->mdev.model, VIVID_MODULE_NAME, sizeof(dev->mdev.model));
 	dev->mdev.dev = &pdev->dev;
 	media_device_init(&dev->mdev);
+	dev->mdev.ops = &vivid_media_ops;
 #endif
 
 	/* register v4l2_device */
diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 3fdb280c36ca..c192b4b1b9de 100644
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
index 9981e7548019..5a14810eeb69 100644
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
index cfb7cb4d37a8..2c466cc4080d 100644
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
 
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index 92a852955173..c5601639a0f3 100644
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
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index 69486c130a7e..7c06bbf5fc7a 100644
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
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 01c703683657..73cdfa5349a6 100644
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
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 51fec66d8d45..b53805fca7b4 100644
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
-- 
2.15.1
