Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:49935 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752743AbdI1JvZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Sep 2017 05:51:25 -0400
Received: by mail-pg0-f51.google.com with SMTP id v13so94023pgq.6
        for <linux-media@vger.kernel.org>; Thu, 28 Sep 2017 02:51:25 -0700 (PDT)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFC PATCH 8/9] [media] vivid: add jobs API support for capture device
Date: Thu, 28 Sep 2017 18:50:26 +0900
Message-Id: <20170928095027.127173-9-acourbot@chromium.org>
In-Reply-To: <20170928095027.127173-1-acourbot@chromium.org>
References: <20170928095027.127173-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for jobs in the vivid capture device, using the generic
state handler.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/platform/vivid/vivid-core.c        | 16 ++++++++++++++++
 drivers/media/platform/vivid/vivid-core.h        |  2 ++
 drivers/media/platform/vivid/vivid-kthread-cap.c |  5 +++++
 3 files changed, 23 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index ef344b9a48af..161c2199d2aa 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -35,6 +35,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
+#include <media/v4l2-job-generic.h>
 
 #include "vivid-core.h"
 #include "vivid-vid-common.h"
@@ -639,6 +640,14 @@ static void vivid_dev_release(struct v4l2_device *v4l2_dev)
 	kfree(dev);
 }
 
+void vivid_process_active_job(struct v4l2_job_state_handler *hdl)
+{
+	struct vivid_dev *dev = container_of(hdl, struct vivid_dev,
+					     state_hdl_vid_cap.base);
+
+	vb2_queue_active_job_buffers(&dev->vb_vid_cap_q);
+}
+
 static int vivid_create_instance(struct platform_device *pdev, int inst)
 {
 	static const struct v4l2_dv_timings def_dv_timings =
@@ -1071,6 +1080,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
 		q->dev = dev->v4l2_dev.dev;
+		q->state_handler = &dev->state_hdl_vid_cap.base;
 
 		ret = vb2_queue_init(q);
 		if (ret)
@@ -1185,6 +1195,12 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		vfd->lock = &dev->mutex;
 		video_set_drvdata(vfd, dev);
 
+		ret = v4l2_job_generic_init(&dev->state_hdl_vid_cap,
+					   vivid_process_active_job, NULL, vfd);
+		if (ret)
+			return ret;
+
+
 #ifdef CONFIG_VIDEO_VIVID_CEC
 		if (in_type_counter[HDMI]) {
 			struct cec_adapter *adap;
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 5cdf95bdc4d1..c4014816beb7 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -28,6 +28,7 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-tpg.h>
+#include <media/v4l2-job-generic.h>
 #include "vivid-rds-gen.h"
 #include "vivid-vbi-gen.h"
 
@@ -156,6 +157,7 @@ struct vivid_dev {
 	struct v4l2_ctrl_handler	ctrl_hdl_loop_cap;
 	struct video_device		vid_cap_dev;
 	struct v4l2_ctrl_handler	ctrl_hdl_vid_cap;
+	struct v4l2_generic_state_handler state_hdl_vid_cap;
 	struct video_device		vid_out_dev;
 	struct v4l2_ctrl_handler	ctrl_hdl_vid_out;
 	struct video_device		vbi_cap_dev;
diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 6ca71aabb576..b31ebfa55eca 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -683,6 +683,7 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
 {
 	struct vivid_buffer *vid_cap_buf = NULL;
 	struct vivid_buffer *vbi_cap_buf = NULL;
+	bool vid_job_complete;
 
 	dprintk(dev, 1, "Video Capture Thread Tick\n");
 
@@ -700,6 +701,7 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
 	if (!list_empty(&dev->vid_cap_active)) {
 		vid_cap_buf = list_entry(dev->vid_cap_active.next, struct vivid_buffer, list);
 		list_del(&vid_cap_buf->list);
+		vid_job_complete = list_empty(&dev->vid_cap_active);
 	}
 	if (!list_empty(&dev->vbi_cap_active)) {
 		if (dev->field_cap != V4L2_FIELD_ALTERNATE ||
@@ -729,6 +731,9 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
 				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vid_cap buffer %d done\n",
 				vid_cap_buf->vb.vb2_buf.index);
+
+		if (vid_job_complete)
+			v4l2_jobqueue_job_finish(&dev->state_hdl_vid_cap.base);
 	}
 
 	if (vbi_cap_buf) {
-- 
2.14.2.822.g60be5d43e6-goog
