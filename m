Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:39316 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751391AbeBTEpI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 23:45:08 -0500
Received: by mail-pf0-f195.google.com with SMTP id c143so3014798pfb.6
        for <linux-media@vger.kernel.org>; Mon, 19 Feb 2018 20:45:08 -0800 (PST)
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
Subject: [RFCv4 09/21] v4l2: add request API support
Date: Tue, 20 Feb 2018 13:44:13 +0900
Message-Id: <20180220044425.169493-10-acourbot@chromium.org>
In-Reply-To: <20180220044425.169493-1-acourbot@chromium.org>
References: <20180220044425.169493-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a v4l2 request entity data structure that takes care of storing the
request-related state of a V4L2 device ; in this case, its controls.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/v4l2-core/Makefile       |   1 +
 drivers/media/v4l2-core/v4l2-request.c | 178 +++++++++++++++++++++++++
 include/media/v4l2-request.h           | 159 ++++++++++++++++++++++
 3 files changed, 338 insertions(+)
 create mode 100644 drivers/media/v4l2-core/v4l2-request.c
 create mode 100644 include/media/v4l2-request.h

diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 80de2cb9c476..13d0477535bd 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -16,6 +16,7 @@ ifeq ($(CONFIG_TRACEPOINTS),y)
   videodev-objs += vb2-trace.o v4l2-trace.o
 endif
 videodev-$(CONFIG_MEDIA_CONTROLLER) += v4l2-mc.o
+videodev-$(CONFIG_MEDIA_REQUEST_API) += v4l2-request.o
 
 obj-$(CONFIG_VIDEO_V4L2) += videodev.o
 obj-$(CONFIG_VIDEO_V4L2) += v4l2-common.o
diff --git a/drivers/media/v4l2-core/v4l2-request.c b/drivers/media/v4l2-core/v4l2-request.c
new file mode 100644
index 000000000000..e8ad10e2f525
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-request.c
@@ -0,0 +1,178 @@
+/*
+ * Media requests support for V4L2
+ *
+ * Copyright (C) 2018, The Chromium OS Authors.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/slab.h>
+
+#include <media/v4l2-dev.h>
+#include <media/v4l2-request.h>
+#include <media/videobuf2-v4l2.h>
+
+void v4l2_request_entity_init(struct v4l2_request_entity *entity,
+			      const struct media_request_entity_ops *ops,
+			      struct video_device *vdev)
+{
+	media_request_entity_init(&entity->base, MEDIA_REQUEST_ENTITY_TYPE_V4L2, ops);
+	entity->vdev = vdev;
+}
+EXPORT_SYMBOL_GPL(v4l2_request_entity_init);
+
+struct media_request_entity_data *
+v4l2_request_entity_data_alloc(struct media_request *req,
+			       struct v4l2_ctrl_handler *hdl)
+{
+	struct v4l2_request_entity_data *data;
+	int ret;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return ERR_PTR(-ENOMEM);
+
+	ret = v4l2_ctrl_request_init(&data->ctrls);
+	if (ret) {
+		kfree(data);
+		return ERR_PTR(ret);
+	}
+	ret = v4l2_ctrl_request_clone(&data->ctrls, hdl, NULL);
+	if (ret) {
+		kfree(data);
+		return ERR_PTR(ret);
+	}
+
+	INIT_LIST_HEAD(&data->queued_buffers);
+
+	return &data->base;
+}
+EXPORT_SYMBOL_GPL(v4l2_request_entity_data_alloc);
+
+void v4l2_request_entity_data_free(struct media_request_entity_data *_data)
+{
+	struct v4l2_request_entity_data *data;
+	struct v4l2_vb2_request_buffer *qb, *n;
+
+	data = to_v4l2_entity_data(_data);
+
+	list_for_each_entry_safe(qb, n, &data->queued_buffers, node) {
+		struct vb2_buffer *buf;
+		dev_warn(_data->request->mgr->dev,
+			 "entity data freed while buffer still queued!\n");
+
+		/* give buffer back to user-space */
+		buf = qb->queue->bufs[qb->v4l2_buf.index];
+		buf->state = qb->pre_req_state;
+		buf->request = NULL;
+
+		kfree(qb);
+	}
+
+	v4l2_ctrl_handler_free(&data->ctrls);
+	kfree(data);
+}
+EXPORT_SYMBOL_GPL(v4l2_request_entity_data_free);
+
+
+
+
+
+static struct media_request *v4l2_request_alloc(struct media_request_mgr *mgr)
+{
+	struct media_request *req;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return ERR_PTR(-ENOMEM);
+
+	req->mgr = mgr;
+	req->state = MEDIA_REQUEST_STATE_IDLE;
+	INIT_LIST_HEAD(&req->data);
+	init_waitqueue_head(&req->complete_wait);
+	mutex_init(&req->lock);
+
+	mutex_lock(&mgr->mutex);
+	list_add_tail(&req->list, &mgr->requests);
+	mutex_unlock(&mgr->mutex);
+
+	return req;
+}
+
+static void v4l2_request_free(struct media_request *req)
+{
+	struct media_request_mgr *mgr = req->mgr;
+	struct media_request_entity_data *data, *next;
+
+	mutex_lock(&mgr->mutex);
+	list_del(&req->list);
+	mutex_unlock(&mgr->mutex);
+
+	list_for_each_entry_safe(data, next, &req->data, list) {
+		list_del(&data->list);
+		data->entity->ops->data_free(data);
+	}
+
+	kfree(req);
+}
+
+static bool v4l2_entity_valid(const struct media_request *req,
+			      const struct media_request_entity *_entity)
+{
+	const struct v4l2_request_mgr *mgr;
+	const struct v4l2_request_entity *entity;
+
+	if (_entity->type != MEDIA_REQUEST_ENTITY_TYPE_V4L2)
+		return false;
+
+	entity = container_of(_entity, struct v4l2_request_entity, base);
+	mgr = container_of(req->mgr, struct v4l2_request_mgr, base);
+
+	/* Entity is valid if it is the video device that created the manager */
+	return entity->vdev == mgr->vdev;
+}
+
+static int v4l2_request_submit(struct media_request *req)
+{
+	struct media_request_entity_data *data;
+
+        /* Submit for each entity */
+	list_for_each_entry(data, &req->data, list) {
+		int ret = data->entity->ops->submit(req, data);
+		/* TODO proper error handling, abort on other entities? */
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+const struct media_request_ops v4l2_request_ops = {
+	.alloc = v4l2_request_alloc,
+	.release = v4l2_request_free,
+	.entity_valid = v4l2_entity_valid,
+	.submit = v4l2_request_submit,
+};
+EXPORT_SYMBOL_GPL(v4l2_request_ops);
+
+void v4l2_request_mgr_init(struct v4l2_request_mgr *mgr,
+			  struct video_device *vdev,
+			  const struct media_request_ops *ops)
+{
+	media_request_mgr_init(&mgr->base, &vdev->dev, ops);
+	mgr->vdev = vdev;
+}
+EXPORT_SYMBOL_GPL(v4l2_request_mgr_init);
+
+void v4l2_request_mgr_free(struct v4l2_request_mgr* mgr)
+{
+	media_request_mgr_free(&mgr->base);
+}
+EXPORT_SYMBOL_GPL(v4l2_request_mgr_free);
diff --git a/include/media/v4l2-request.h b/include/media/v4l2-request.h
new file mode 100644
index 000000000000..8a87ca455b74
--- /dev/null
+++ b/include/media/v4l2-request.h
@@ -0,0 +1,159 @@
+/*
+ * Media requests support for V4L2
+ *
+ * Copyright (C) 2018, The Chromium OS Authors.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _MEDIA_V4L2_REQUEST_H
+#define _MEDIA_V4L2_REQUEST_H
+
+#include <linux/kconfig.h>
+#include <media/media-request.h>
+
+#if IS_ENABLED(CONFIG_MEDIA_REQUEST_API)
+
+#include <linux/list.h>
+
+#include <media/videobuf2-core.h>
+#include <media/v4l2-ctrls.h>
+
+/**
+ * struct v4l2_request_entity - entity used with V4L2 instances
+ *
+ * @base:	base media_request_entity struct
+ * @vdev:	video device that this entity represents
+ *
+ * This structure is used by V4L2 devices that support being controlled
+ * by requests. If should be added to the device-specific structure that the
+ * driver wishes to control using requests.
+ *
+ * V4L2 request entities are able to receive queued buffers using vb2 queues,
+ * and control settings using the control framework.
+ *
+ */
+struct v4l2_request_entity {
+	struct media_request_entity base;
+	struct video_device *vdev;
+};
+#define to_v4l2_entity(e) container_of(e, struct v4l2_request_entity, base)
+
+/**
+ * v4l2_request_entity_init() - initialize a struct v4l2_request_entity
+ *
+ * @entity:	entity to initialize
+ * @ops:	entity ops to use
+ * @vdev:	video device represented by this entity
+ */
+void v4l2_request_entity_init(struct v4l2_request_entity *entity,
+			      const struct media_request_entity_ops *ops,
+			      struct video_device *vdev);
+
+/**
+ * struct v4l2_vb2_request_buffer - record buffer queue on behalf of a request
+ *
+ * @queue:		vb2 queue
+ * @pre_req_state:	keep track of the pre-QBUF state of the buffer
+ * @v4l2_buf:		user-space buffer queue ioctl data
+ * @node:		entry into v4l2_request_entity_data::queued_buffers
+ */
+struct v4l2_vb2_request_buffer {
+	struct vb2_queue *queue;
+	enum vb2_buffer_state pre_req_state;
+	struct v4l2_buffer v4l2_buf;
+	struct list_head node;
+};
+
+/**
+ * struct v4l2_request_entity_data - per-request data for V4L2 entities
+ *
+ * @base:		base entity data structure
+ * @ctrls:		record of controls set for this request
+ * @queued_buffers:	record of buffers queued for this request
+ */
+struct v4l2_request_entity_data {
+	struct media_request_entity_data base;
+	struct v4l2_ctrl_handler ctrls;
+	struct list_head queued_buffers;
+};
+static inline struct v4l2_request_entity_data *
+to_v4l2_entity_data(struct media_request_entity_data *data)
+{
+	if (IS_ERR(data))
+		return (struct v4l2_request_entity_data *)data;
+
+	return container_of(data, struct v4l2_request_entity_data, base);
+}
+
+/**
+ * v4l2_request_entity_data_alloc() - allocate data for a V4L2 entity
+ *
+ * @req:	request to allocate for
+ * @hdl:	control handler of the device we will be controlling
+ *
+ * Helper function to be used from the media_request_entity_ops::data_alloc
+ * hook.
+ */
+struct media_request_entity_data *
+v4l2_request_entity_data_alloc(struct media_request *req,
+			       struct v4l2_ctrl_handler *hdl);
+
+/**
+ * v4l2_request_entity_data_free() - free per-request data of an entity
+ *
+ * @data:	entity data to free
+ *
+ * Helper function to be usedfrom the media_request_entity_ops::data_free
+ * hook.
+ */
+void
+v4l2_request_entity_data_free(struct media_request_entity_data *_data);
+
+
+
+
+
+/**
+ * struct v4l2_request_mgr - request manager producing requests suitable
+ *			     for managing single v4l2 devices.
+ *
+ * @base:	base manager structure
+ * @vdev:	device that our requests can control
+ */
+struct v4l2_request_mgr {
+	struct media_request_mgr base;
+	struct video_device *vdev;
+};
+
+/**
+ * v4l2_request_mgr_init() - initialize a v4l2_request_mgr
+ *
+ * @mgr:	manager to initialize
+ * @vdev:	video device that our instances will control
+ * @ops:	used to override ops if needed. &v4l2_request_ops is a good
+ *		default
+ */
+void v4l2_request_mgr_init(struct v4l2_request_mgr *mgr,
+			  struct video_device *vdev,
+			  const struct media_request_ops *ops);
+
+/**
+ * v4l2_request_mgr_free() - free a v4l2 request manager
+ *
+ * @mgr:	manager to free
+ */
+void v4l2_request_mgr_free(struct v4l2_request_mgr *mgr);
+
+extern const struct media_request_ops v4l2_request_ops;
+
+#endif /* CONFIG_MEDIA_REQUEST_API */
+
+#endif
-- 
2.16.1.291.g4437f3f132-goog
