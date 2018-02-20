Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35430 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751609AbeBTEpi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 23:45:38 -0500
Received: by mail-pf0-f193.google.com with SMTP id a6so3013680pfi.2
        for <linux-media@vger.kernel.org>; Mon, 19 Feb 2018 20:45:38 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Gustavo Padovan <gustavo.padovan@collabora.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFCv4 20/21] media: vivid: add request support for the video capture device
Date: Tue, 20 Feb 2018 13:44:24 +0900
Message-Id: <20180220044425.169493-21-acourbot@chromium.org>
In-Reply-To: <20180220044425.169493-1-acourbot@chromium.org>
References: <20180220044425.169493-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow to use requests with the video capture device.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/platform/vivid/Kconfig          |  1 +
 drivers/media/platform/vivid/vivid-core.c     | 63 ++++++++++++++++++-
 drivers/media/platform/vivid/vivid-core.h     |  3 +
 .../media/platform/vivid/vivid-kthread-cap.c  | 17 +++++
 4 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/Kconfig b/drivers/media/platform/vivid/Kconfig
index 154de92dd809..a6494dabae95 100644
--- a/drivers/media/platform/vivid/Kconfig
+++ b/drivers/media/platform/vivid/Kconfig
@@ -7,6 +7,7 @@ config VIDEO_VIVID
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select MEDIA_REQUEST_API
 	select VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEO_V4L2_TPG
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 82ec216f2ad8..c1cf8e7ca2c9 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -23,6 +23,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
+#include <media/v4l2-request.h>
 
 #include "vivid-core.h"
 #include "vivid-vid-common.h"
@@ -486,6 +487,33 @@ static const struct v4l2_file_operations vivid_fops = {
 	.mmap           = vb2_fop_mmap,
 };
 
+static int vivid_cap_open(struct file *filp)
+{
+	struct vivid_dev *dev;
+	struct v4l2_fh *fh;
+	int ret;
+
+	ret = v4l2_fh_open(filp);
+	if (ret)
+		return ret;
+
+	dev = container_of(video_devdata(filp), struct vivid_dev, vid_cap_dev);
+	fh = filp->private_data;
+	fh->entity = &dev->vid_cap_req_entity.base;
+
+	return ret;
+}
+
+static const struct v4l2_file_operations vivid_cap_fops = {
+	.owner		= THIS_MODULE,
+	.open           = vivid_cap_open,
+	.release        = vivid_fop_release,
+	.read           = vb2_fop_read,
+	.write          = vb2_fop_write,
+	.poll		= vb2_fop_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap           = vb2_fop_mmap,
+};
 static const struct v4l2_file_operations vivid_radio_fops = {
 	.owner		= THIS_MODULE,
 	.open           = v4l2_fh_open,
@@ -607,6 +635,31 @@ static const struct v4l2_ioctl_ops vivid_ioctl_ops = {
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
+struct media_request_entity_data *
+vid_cap_entity_data_alloc(struct media_request *req,
+			struct media_request_entity *entity)
+{
+	struct vivid_dev *dev;
+
+	dev = container_of(entity, struct vivid_dev, vid_cap_req_entity.base);
+	return v4l2_request_entity_data_alloc(req, &dev->ctrl_hdl_vid_cap);
+}
+
+static int vid_cap_request_submit(struct media_request *req,
+				struct media_request_entity_data *_data)
+{
+	struct v4l2_request_entity_data *data;
+
+	data = to_v4l2_entity_data(_data);
+	return vb2_request_submit(data);
+}
+
+static const struct media_request_entity_ops vivid_request_entity_ops = {
+	.data_alloc	= vid_cap_entity_data_alloc,
+	.data_free	= v4l2_request_entity_data_free,
+	.submit		= vid_cap_request_submit,
+};
+
 /* -----------------------------------------------------------------
 	Initialization and module stuff
    ------------------------------------------------------------------*/
@@ -1057,6 +1110,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->mem_ops = vivid_mem_ops[allocator];
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
+		q->allow_requests = true;
 		q->lock = &dev->mutex;
 		q->dev = dev->v4l2_dev.dev;
 
@@ -1158,13 +1212,19 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		vfd = &dev->vid_cap_dev;
 		snprintf(vfd->name, sizeof(vfd->name),
 			 "vivid-%03d-vid-cap", inst);
-		vfd->fops = &vivid_fops;
+		vfd->fops = &vivid_cap_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
 		vfd->device_caps = dev->vid_cap_caps;
 		vfd->release = video_device_release_empty;
 		vfd->v4l2_dev = &dev->v4l2_dev;
 		vfd->queue = &dev->vb_vid_cap_q;
 		vfd->tvnorms = tvnorms_cap;
+		vfd->req_mgr = &dev->vid_cap_req_mgr.base;
+		v4l2_request_mgr_init(&dev->vid_cap_req_mgr, vfd,
+				      &v4l2_request_ops);
+		v4l2_request_entity_init(&dev->vid_cap_req_entity,
+					 &vivid_request_entity_ops,
+					 vfd);
 
 		/*
 		 * Provide a mutex to v4l2 core. It will be used to protect
@@ -1448,6 +1508,7 @@ static int vivid_remove(struct platform_device *pdev)
 			v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
 				video_device_node_name(&dev->vid_cap_dev));
 			video_unregister_device(&dev->vid_cap_dev);
+			v4l2_request_mgr_free(&dev->vid_cap_req_mgr);
 		}
 		if (dev->has_vid_out) {
 			v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 477c80a4d44c..c8adcbb1c1d1 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -11,6 +11,7 @@
 #include <linux/fb.h>
 #include <linux/workqueue.h>
 #include <media/cec.h>
+#include <media/v4l2-request.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-dev.h>
@@ -145,6 +146,8 @@ struct vivid_dev {
 	struct v4l2_ctrl_handler	ctrl_hdl_fb;
 	struct video_device		vid_cap_dev;
 	struct v4l2_ctrl_handler	ctrl_hdl_vid_cap;
+	struct v4l2_request_mgr		vid_cap_req_mgr;
+	struct v4l2_request_entity	vid_cap_req_entity;
 	struct video_device		vid_out_dev;
 	struct v4l2_ctrl_handler	ctrl_hdl_vid_out;
 	struct video_device		vbi_cap_dev;
diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 3fdb280c36ca..0d0866dc11b3 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -19,6 +19,7 @@
 #include <linux/random.h>
 #include <linux/v4l2-dv-timings.h>
 #include <asm/div64.h>
+#include <media/media-request.h>
 #include <media/videobuf2-vmalloc.h>
 #include <media/v4l2-dv-timings.h>
 #include <media/v4l2-ioctl.h>
@@ -703,6 +704,17 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
 		goto update_mv;
 
 	if (vid_cap_buf) {
+		struct media_request *req = vid_cap_buf->vb.vb2_buf.request;
+
+		/* Using request? Apply its controls */
+		if (req) {
+			struct v4l2_request_entity_data *data;
+			data = to_v4l2_entity_data(
+				media_request_get_entity_data(req,
+						&dev->vid_cap_req_entity.base));
+			if (!WARN_ON(IS_ERR(data)))
+				v4l2_ctrl_request_setup(&data->ctrls);
+		}
 		/* Fill buffer */
 		vivid_fillbuff(dev, vid_cap_buf);
 		dprintk(dev, 1, "filled buffer %d\n",
@@ -717,6 +729,11 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
 				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vid_cap buffer %d done\n",
 				vid_cap_buf->vb.vb2_buf.index);
+		if (req)
+			media_request_entity_complete(req,
+						 &dev->vid_cap_req_entity.base);
+		dprintk(dev, 2, "vid_cap buffer %d request completed\n",
+				vid_cap_buf->vb.vb2_buf.index);
 	}
 
 	if (vbi_cap_buf) {
-- 
2.16.1.291.g4437f3f132-goog
