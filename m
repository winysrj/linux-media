Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44651 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934369AbbLQIl3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 03:41:29 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH/RFC 48/48] v4l: vsp1: Support the request API
Date: Thu, 17 Dec 2015 10:40:26 +0200
Message-Id: <1450341626-6695-49-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement the request API on top of display lists. Queueing a request
creates and queues a display list containing the pipeline configuration
for processing, allowing back-to-back operation without waiting for
frame processing completion before preparing the pipeline for the next
frame.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/Makefile       |   3 +-
 drivers/media/platform/vsp1/vsp1_dl.c      |   3 +
 drivers/media/platform/vsp1/vsp1_dl.h      |   1 +
 drivers/media/platform/vsp1/vsp1_drv.c     |   9 +++
 drivers/media/platform/vsp1/vsp1_pipe.c    |  71 ++++++++++++++++
 drivers/media/platform/vsp1/vsp1_pipe.h    |   7 ++
 drivers/media/platform/vsp1/vsp1_request.c | 126 +++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_request.h |  41 ++++++++++
 drivers/media/platform/vsp1/vsp1_video.c   |  84 ++++++++-----------
 9 files changed, 295 insertions(+), 50 deletions(-)
 create mode 100644 drivers/media/platform/vsp1/vsp1_request.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_request.h

diff --git a/drivers/media/platform/vsp1/Makefile b/drivers/media/platform/vsp1/Makefile
index 95b3ac2ea7ef..5df1346290d6 100644
--- a/drivers/media/platform/vsp1/Makefile
+++ b/drivers/media/platform/vsp1/Makefile
@@ -1,5 +1,6 @@
 vsp1-y					:= vsp1_drv.o vsp1_entity.o vsp1_pipe.o
-vsp1-y					+= vsp1_dl.o vsp1_drm.o vsp1_video.o
+vsp1-y					+= vsp1_dl.o vsp1_request.o
+vsp1-y					+= vsp1_drm.o vsp1_video.o
 vsp1-y					+= vsp1_rpf.o vsp1_rwpf.o vsp1_wpf.o
 vsp1-y					+= vsp1_hsit.o vsp1_lif.o vsp1_lut.o
 vsp1-y					+= vsp1_bru.o vsp1_sru.o vsp1_uds.o
diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 43597b38a433..1181757d5081 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -15,9 +15,12 @@
 #include <linux/dma-mapping.h>
 #include <linux/gfp.h>
 
+#include <media/v4l2-device.h>
+
 #include "vsp1.h"
 #include "vsp1_dl.h"
 #include "vsp1_pipe.h"
+#include "vsp1_video.h"
 
 /*
  * Global resources
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
index 571ed6d8e7c2..bc77db7ad4d1 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.h
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -15,6 +15,7 @@
 
 #include <linux/types.h>
 
+struct v4l2_device;
 struct vsp1_device;
 struct vsp1_dl_list;
 struct vsp1_dl_manager;
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index e0bcc67e2d07..d8bc92b7d5de 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -30,6 +30,7 @@
 #include "vsp1_hsit.h"
 #include "vsp1_lif.h"
 #include "vsp1_lut.h"
+#include "vsp1_request.h"
 #include "vsp1_rwpf.h"
 #include "vsp1_sru.h"
 #include "vsp1_uds.h"
@@ -210,6 +211,12 @@ static void vsp1_destroy_entities(struct vsp1_device *vsp1)
 		vsp1_drm_cleanup(vsp1);
 }
 
+static const struct media_device_ops vsp1_media_device_ops = {
+	.req_alloc = vsp1_request_alloc,
+	.req_free = vsp1_request_free,
+	.req_queue = vsp1_request_queue,
+};
+
 static int vsp1_create_entities(struct vsp1_device *vsp1)
 {
 	struct media_device *mdev = &vsp1->media_dev;
@@ -219,6 +226,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	int ret;
 
 	mdev->dev = vsp1->dev;
+	mdev->ops = &vsp1_media_device_ops;
 	strlcpy(mdev->model, "VSP1", sizeof(mdev->model));
 	snprintf(mdev->bus_info, sizeof(mdev->bus_info), "platform:%s",
 		 dev_name(mdev->dev));
@@ -238,6 +246,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		vsp1->media_ops.link_validate = v4l2_subdev_link_validate;
 
 	vdev->mdev = mdev;
+
 	ret = v4l2_device_register(vsp1->dev, vdev);
 	if (ret < 0) {
 		dev_err(vsp1->dev, "V4L2 device registration failed (%d)\n",
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 38157a2e4cbc..b055b963e567 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -23,8 +23,10 @@
 #include "vsp1_dl.h"
 #include "vsp1_entity.h"
 #include "vsp1_pipe.h"
+#include "vsp1_request.h"
 #include "vsp1_rwpf.h"
 #include "vsp1_uds.h"
+#include "vsp1_video.h"
 
 /* -----------------------------------------------------------------------------
  * Helper Functions
@@ -136,6 +138,40 @@ const struct vsp1_format_info *vsp1_get_format_info(u32 fourcc)
 	return NULL;
 }
 
+
+/* -----------------------------------------------------------------------------
+ * Requests Management
+ */
+
+void vsp1_pipeline_queue_request(struct vsp1_pipeline *pipe,
+				 struct vsp1_request *req)
+{
+	struct vsp1_video *video;
+	unsigned long flags;
+	unsigned int i;
+
+	media_device_request_get(&req->req);
+
+	spin_lock_irqsave(&pipe->irqlock, flags);
+	list_add_tail(&req->list, &pipe->requests);
+	spin_unlock_irqrestore(&pipe->irqlock, flags);
+
+	for (i = 0; i < ARRAY_SIZE(pipe->inputs); ++i) {
+		if (!pipe->inputs[i])
+			continue;
+
+		video = pipe->inputs[i]->video;
+		mutex_lock(&video->lock);
+		vb2_qbuf_request(&video->queue, req->req.id, NULL);
+		mutex_unlock(&video->lock);
+	}
+
+	video = pipe->output->video;
+	mutex_lock(&video->lock);
+	vb2_qbuf_request(&video->queue, req->req.id, NULL);
+	mutex_unlock(&video->lock);
+}
+
 /* -----------------------------------------------------------------------------
  * Pipeline Management
  */
@@ -155,6 +191,7 @@ void vsp1_pipeline_reset(struct vsp1_pipeline *pipe)
 		pipe->inputs[i] = NULL;
 
 	INIT_LIST_HEAD(&pipe->entities);
+	INIT_LIST_HEAD(&pipe->requests);
 	pipe->state = VSP1_PIPELINE_STOPPED;
 	pipe->buffers_ready = 0;
 	pipe->num_inputs = 0;
@@ -171,6 +208,7 @@ void vsp1_pipeline_init(struct vsp1_pipeline *pipe)
 	init_waitqueue_head(&pipe->wq);
 
 	INIT_LIST_HEAD(&pipe->entities);
+	INIT_LIST_HEAD(&pipe->requests);
 	pipe->state = VSP1_PIPELINE_STOPPED;
 }
 
@@ -250,6 +288,39 @@ bool vsp1_pipeline_ready(struct vsp1_pipeline *pipe)
 	return pipe->buffers_ready == mask;
 }
 
+void vsp1_pipeline_setup(struct vsp1_pipeline *pipe, struct vsp1_dl_list *dl,
+			 struct media_device_request *req)
+{
+	struct vsp1_entity *entity;
+
+	if (pipe->uds) {
+		struct vsp1_uds *uds = to_uds(&pipe->uds->subdev);
+
+		/* If a BRU is present in the pipeline before the UDS, the alpha
+		 * component doesn't need to be scaled as the BRU output alpha
+		 * value is fixed to 255. Otherwise we need to scale the alpha
+		 * component only when available at the input RPF.
+		 */
+		if (pipe->uds_input->type == VSP1_ENTITY_BRU) {
+			uds->scale_alpha = false;
+		} else {
+			const struct vsp1_format_info *info;
+			struct vsp1_rwpf *rpf =
+				to_rwpf(&pipe->uds_input->subdev);
+
+			info = vsp1_get_format_info(rpf->format.pixelformat);
+			uds->scale_alpha = info->alpha;
+		}
+	}
+
+	list_for_each_entry(entity, &pipe->entities, list_pipe) {
+		vsp1_entity_route_setup(entity, dl);
+
+		if (entity->ops->configure)
+			entity->ops->configure(entity, dl, req);
+	}
+}
+
 void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 {
 	if (pipe == NULL)
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 1100229a1ed2..a26e4a7ae67d 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -20,6 +20,7 @@
 #include <media/media-entity.h>
 
 struct vsp1_dl_list;
+struct vsp1_request;
 struct vsp1_rwpf;
 
 /*
@@ -74,6 +75,7 @@ enum vsp1_pipeline_state {
  * @uds: UDS entity, if present
  * @uds_input: entity at the input of the UDS, if the UDS is present
  * @entities: list of entities in the pipeline
+ * @requests: list of pending requests
  * @dl: display list associated with the pipeline
  */
 struct vsp1_pipeline {
@@ -100,6 +102,7 @@ struct vsp1_pipeline {
 
 	struct list_head entities;
 
+	struct list_head requests;
 	struct vsp1_dl_list *dl;
 };
 
@@ -118,6 +121,10 @@ void vsp1_pipeline_run(struct vsp1_pipeline *pipe);
 bool vsp1_pipeline_stopped(struct vsp1_pipeline *pipe);
 int vsp1_pipeline_stop(struct vsp1_pipeline *pipe);
 bool vsp1_pipeline_ready(struct vsp1_pipeline *pipe);
+void vsp1_pipeline_setup(struct vsp1_pipeline *pipe, struct vsp1_dl_list *dl,
+			 struct media_device_request *req);
+void vsp1_pipeline_queue_request(struct vsp1_pipeline *pipe,
+				 struct vsp1_request *req);
 
 void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe);
 
diff --git a/drivers/media/platform/vsp1/vsp1_request.c b/drivers/media/platform/vsp1/vsp1_request.c
new file mode 100644
index 000000000000..d78289f18fc0
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_request.c
@@ -0,0 +1,126 @@
+/*
+ * vsp1_request.c  --  R-Car VSP1 Request Management
+ *
+ * Copyright (C) 2015 Renesas Electronics Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/delay.h>
+#include <linux/list.h>
+#include <linux/wait.h>
+
+#include <media/media-entity.h>
+#include <media/v4l2-subdev.h>
+
+#include "vsp1.h"
+#include "vsp1_dl.h"
+#include "vsp1_entity.h"
+#include "vsp1_pipe.h"
+#include "vsp1_request.h"
+#include "vsp1_rwpf.h"
+#include "vsp1_video.h"
+
+struct media_device_request *vsp1_request_alloc(struct media_device *mdev)
+{
+	struct vsp1_request *req;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return NULL;
+
+	return &req->req;
+}
+
+void vsp1_request_free(struct media_device *mdev,
+		       struct media_device_request *mreq)
+{
+	struct vsp1_request *req = to_vsp1_request(mreq);
+
+	kfree(req);
+}
+
+int vsp1_request_queue(struct media_device *mdev,
+		       struct media_device_request *mreq)
+{
+	struct vsp1_device *vsp1 =
+		container_of(mdev, struct vsp1_device, media_dev);
+	struct vsp1_request *req = to_vsp1_request(mreq);
+	struct vsp1_video *output = NULL;
+	struct vsp1_pipeline *pipe;
+	struct vsp1_video *video;
+	bool has_request;
+	unsigned int i;
+
+	/* 1. Find the capture video node for which a buffer corresponding to
+	 * the request has been prepared. This will be our main entry point to
+	 * the pipeline.
+	 *
+	 * TODO: Fix race condition. There would be no need to lock the list
+	 * walk as we don't add or remove video nodes at runtime. However, the
+	 * media device is registered before the video nodes, so userspace could
+	 * call us at probe time before all video nodes are registered.
+	 */
+	for (i = 0; i < ARRAY_SIZE(vsp1->wpf); ++i) {
+		if (!vsp1->wpf[i])
+			continue;
+
+		video = vsp1->wpf[i]->video;
+
+		if (mutex_lock_interruptible(&video->lock))
+			return -ERESTARTSYS;
+		has_request = vb2_is_streaming(&video->queue) &&
+			      vb2_queue_has_request(&video->queue, mreq->id);
+		mutex_unlock(&video->lock);
+
+		if (has_request) {
+			/* A pipeline has a single output. */
+			if (output)
+				return -EINVAL;
+			output = video;
+		}
+	}
+
+	if (!output)
+		return -EINVAL;
+
+	/* 2. Validate the pipeline. Verify streaming state, buffers and
+	 * formats.
+	 */
+	pipe = to_vsp1_pipeline(&output->video.entity);
+	if (!pipe)
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(pipe->inputs); ++i) {
+		if (!pipe->inputs[i])
+			continue;
+
+		video = pipe->inputs[i]->video;
+
+		if (mutex_lock_interruptible(&video->lock))
+			return -ERESTARTSYS;
+		has_request = vb2_is_streaming(&video->queue) &&
+			      vb2_queue_has_request(&video->queue, mreq->id);
+		mutex_unlock(&video->lock);
+
+		if (!has_request)
+			return -EINVAL;
+	}
+
+	/* 3. Allocate and fill the display list. */
+	req->dl = vsp1_dl_list_get(pipe->output->dlm);
+	if (!req->dl)
+		return -ENOMEM;
+
+	vsp1_pipeline_setup(pipe, req->dl, mreq);
+
+	/* 3. Queue the request. */
+	vsp1_pipeline_queue_request(pipe, req);
+
+	return 0;
+}
diff --git a/drivers/media/platform/vsp1/vsp1_request.h b/drivers/media/platform/vsp1/vsp1_request.h
new file mode 100644
index 000000000000..7cde04f86669
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_request.h
@@ -0,0 +1,41 @@
+/*
+ * vsp1_request.h  --  R-Car VSP1 Request Management
+ *
+ * Copyright (C) 2015 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef __VSP1_REQUEST_H__
+#define __VSP1_REQUEST_H__
+
+#include <linux/kernel.h>
+#include <linux/list.h>
+
+struct media_device;
+struct media_device_request;
+struct vsp1_dl_list;
+
+struct vsp1_request {
+	struct media_device_request req;
+	struct vsp1_dl_list *dl;
+	struct list_head list;
+};
+
+static inline struct vsp1_request *
+to_vsp1_request(struct media_device_request *req)
+{
+	return container_of(req, struct vsp1_request, req);
+}
+
+struct media_device_request *vsp1_request_alloc(struct media_device *mdev);
+void vsp1_request_free(struct media_device *mdev,
+		       struct media_device_request *req);
+int vsp1_request_queue(struct media_device *mdev,
+		       struct media_device_request *req);
+
+#endif /* __VSP1_REQUEST_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index c30e29a4eb07..10bd0c0a2d94 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -32,6 +32,7 @@
 #include "vsp1_dl.h"
 #include "vsp1_entity.h"
 #include "vsp1_pipe.h"
+#include "vsp1_request.h"
 #include "vsp1_rwpf.h"
 #include "vsp1_uds.h"
 #include "vsp1_video.h"
@@ -451,23 +452,44 @@ static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
 static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 {
 	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
+	struct vsp1_dl_list *dl;
 	unsigned int i;
 
-	if (!pipe->dl)
-		pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
+	/* Get the display list from first available location:
+	 *
+	 * - the next request (when the request API is in use)
+	 * - the pipeline if set (for the first run after streamon)
+	 * - the request pool (for subsequent runs)
+	 */
+	dl = pipe->dl;
+	pipe->dl = NULL;
+
+	if (!list_empty(&pipe->requests)) {
+		struct vsp1_request *req;
+
+		req = list_first_entry(&pipe->requests, typeof(*req), list);
+		list_del(&req->list);
+
+		vsp1_dl_list_put(dl);
+		dl = req->dl;
+		media_device_request_put(&req->req);
+
+	}
+
+	if (!dl)
+		dl = vsp1_dl_list_get(pipe->output->dlm);
 
 	for (i = 0; i < vsp1->info->rpf_count; ++i) {
 		struct vsp1_rwpf *rwpf = pipe->inputs[i];
 
 		if (rwpf)
-			vsp1_rwpf_set_memory(rwpf, pipe->dl);
+			vsp1_rwpf_set_memory(rwpf, dl);
 	}
 
 	if (!pipe->lif)
-		vsp1_rwpf_set_memory(pipe->output, pipe->dl);
+		vsp1_rwpf_set_memory(pipe->output, dl);
 
-	vsp1_dl_list_commit(pipe->dl);
-	pipe->dl = NULL;
+	vsp1_dl_list_commit(dl);
 
 	vsp1_pipeline_run(pipe);
 }
@@ -595,59 +617,22 @@ static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&pipe->irqlock, flags);
 }
 
-static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
-{
-	struct vsp1_entity *entity;
-
-	/* Prepare the display list. */
-	pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
-	if (!pipe->dl)
-		return -ENOMEM;
-
-	if (pipe->uds) {
-		struct vsp1_uds *uds = to_uds(&pipe->uds->subdev);
-
-		/* If a BRU is present in the pipeline before the UDS, the alpha
-		 * component doesn't need to be scaled as the BRU output alpha
-		 * value is fixed to 255. Otherwise we need to scale the alpha
-		 * component only when available at the input RPF.
-		 */
-		if (pipe->uds_input->type == VSP1_ENTITY_BRU) {
-			uds->scale_alpha = false;
-		} else {
-			const struct vsp1_format_info *info;
-			struct vsp1_rwpf *rpf =
-				to_rwpf(&pipe->uds_input->subdev);
-
-			info = vsp1_get_format_info(rpf->format.pixelformat);
-			uds->scale_alpha = info->alpha;
-		}
-	}
-
-	list_for_each_entry(entity, &pipe->entities, list_pipe) {
-		vsp1_entity_route_setup(entity, pipe->dl);
-
-		if (entity->ops->configure)
-			entity->ops->configure(entity, pipe->dl, NULL);
-	}
-
-	return 0;
-}
-
 static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct vsp1_video *video = vb2_get_drv_priv(vq);
 	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
 	unsigned long flags;
-	int ret;
 
 	mutex_lock(&pipe->lock);
 	if (pipe->stream_count == pipe->num_inputs) {
-		ret = vsp1_video_setup_pipeline(pipe);
-		if (ret < 0) {
+		/* Prepare the display list. */
+		pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
+		if (!pipe->dl) {
 			mutex_unlock(&pipe->lock);
-			return ret;
+			return -ENOMEM;
 		}
+
+		vsp1_pipeline_setup(pipe, pipe->dl, NULL);
 	}
 
 	pipe->stream_count++;
@@ -993,6 +978,7 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
 	video->queue.ops = &vsp1_video_queue_qops;
 	video->queue.mem_ops = &vb2_dma_contig_memops;
 	video->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	video->queue.allow_requests = true;
 	ret = vb2_queue_init(&video->queue);
 	if (ret < 0) {
 		dev_err(video->vsp1->dev, "failed to initialize vb2 queue\n");
-- 
2.4.10

