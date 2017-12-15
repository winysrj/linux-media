Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:46518 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753744AbdLOH4z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 02:56:55 -0500
Received: by mail-pf0-f194.google.com with SMTP id c204so5604441pfc.13
        for <linux-media@vger.kernel.org>; Thu, 14 Dec 2017 23:56:54 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFC PATCH 2/9] media: request: add generic queue
Date: Fri, 15 Dec 2017 16:56:18 +0900
Message-Id: <20171215075625.27028-3-acourbot@chromium.org>
In-Reply-To: <20171215075625.27028-1-acourbot@chromium.org>
References: <20171215075625.27028-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a generic request queue that supports most use-case and should be
usable as-is by drivers without special hardware features.

The generic queue stores the requests into a FIFO list and executes them
sequentially.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/Makefile                      |   2 +-
 drivers/media/media-request-queue-generic.c | 150 ++++++++++++++++++++++++++++
 include/media/media-request.h               |   8 ++
 3 files changed, 159 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/media-request-queue-generic.c

diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 985d35ec6b29..90117fff1339 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -4,7 +4,7 @@
 #
 
 media-objs	:= media-device.o media-devnode.o media-entity.o \
-		   media-request.o
+		   media-request.o media-request-queue-generic.o
 
 #
 # I2C drivers should come before other drivers, otherwise they'll fail
diff --git a/drivers/media/media-request-queue-generic.c b/drivers/media/media-request-queue-generic.c
new file mode 100644
index 000000000000..780414b6d46a
--- /dev/null
+++ b/drivers/media/media-request-queue-generic.c
@@ -0,0 +1,150 @@
+/*
+ * Generic request queue implementation.
+ *
+ * Copyright (C) 2017, The Chromium OS Authors.  All rights reserved.
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
+#include <media/media-request.h>
+#include <media/media-entity.h>
+
+/**
+ * struct media_request_generic - request enabled for the generic queue
+ *
+ * @base:	base request member
+ * @queue:	entry in media_request_queue_generic::queued_requests
+ */
+struct media_request_generic {
+	struct media_request base;
+	struct list_head queue;
+};
+#define to_generic_request(r) \
+	container_of(r, struct media_request_generic, base)
+
+/**
+ * struct media_request_queue_generic - generic request queue implementation
+ *
+ * Implements a simple request queue, where the next queued request is executed
+ * as soon as the previous one completes.
+ *
+ * @base:		base request queue member
+ * @mutex:		protects the queue
+ * @queued_requests:	list of requests to be sequentially executed
+ */
+struct media_request_queue_generic {
+	struct media_request_queue base;
+
+	struct list_head queued_requests;
+};
+#define to_generic_queue(q) \
+	container_of(q, struct media_request_queue_generic, base)
+
+static struct media_request *
+media_request_generic_alloc(struct media_request_queue *queue)
+{
+	struct media_request_generic *req;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return ERR_PTR(-ENOMEM);
+
+	return &req->base;
+}
+
+static void media_request_generic_free(struct media_request_queue *queue,
+				       struct media_request *_req)
+{
+	struct media_request_generic *req = to_generic_request(_req);
+
+	kfree(req);
+}
+
+static void schedule_next_req(struct media_request_queue_generic *queue)
+{
+	struct media_request_generic *req;
+	struct media_request_entity_data *data;
+
+	req = list_first_entry_or_null(&queue->queued_requests, typeof(*req),
+				       queue);
+	if (!req)
+		return;
+
+	list_del(&req->queue);
+	queue->base.active_request = &req->base;
+
+	list_for_each_entry(data, &req->base.data, list) {
+		int ret;
+
+		ret = data->entity->req_ops->apply_data(data);
+	}
+
+	list_for_each_entry(data, &req->base.data, list) {
+		data->entity->ops->process_request(&req->base, data);
+	}
+}
+
+static void media_request_generic_complete(struct media_request_queue *_queue)
+{
+	struct media_request_queue_generic *queue = to_generic_queue(_queue);
+
+	queue->base.active_request = NULL;
+	schedule_next_req(queue);
+}
+
+static int media_request_generic_queue(struct media_request_queue *_queue,
+			   struct media_request *_req)
+{
+	struct media_request_queue_generic *queue = to_generic_queue(_queue);
+	struct media_request_generic *req = to_generic_request(_req);
+
+	list_add_tail(&req->queue, &queue->queued_requests);
+
+	if (!queue->base.active_request)
+		schedule_next_req(queue);
+
+	return 0;
+}
+
+static void
+media_request_generic_queue_release(struct media_request_queue *_queue)
+{
+	struct media_request_queue_generic *queue = to_generic_queue(_queue);
+
+	media_request_queue_release(&queue->base);
+	kfree(queue);
+}
+
+static const struct media_request_queue_ops request_queue_generic_ops = {
+	.release = media_request_generic_queue_release,
+	.req_alloc = media_request_generic_alloc,
+	.req_free = media_request_generic_free,
+	.req_queue = media_request_generic_queue,
+	.req_complete = media_request_generic_complete,
+};
+
+struct media_request_queue *
+media_request_queue_generic_alloc(struct media_device *mdev)
+{
+	struct media_request_queue_generic *ret;
+
+	ret = kzalloc(sizeof(*ret), GFP_KERNEL);
+	if (!ret)
+		return ERR_PTR(-ENOMEM);
+
+	media_request_queue_init(&ret->base, mdev, &request_queue_generic_ops);
+
+	INIT_LIST_HEAD(&ret->queued_requests);
+
+	return &ret->base;
+}
+EXPORT_SYMBOL(media_request_queue_generic_alloc);
diff --git a/include/media/media-request.h b/include/media/media-request.h
index ead7fd8898c4..583a1116f735 100644
--- a/include/media/media-request.h
+++ b/include/media/media-request.h
@@ -196,6 +196,14 @@ void media_request_queue_init(struct media_request_queue *queue,
  */
 void media_request_queue_release(struct media_request_queue *queue);
 
+/**
+ * media_request_queue_generic_alloc() - return an instance of the generic queue
+ *
+ * @mdev:	media device managing this queue
+ */
+struct media_request_queue *
+media_request_queue_generic_alloc(struct media_device *mdev);
+
 /**
  * struct media_request_entity_data - per-entity request data
  *
-- 
2.15.1.504.g5279b80103-goog
