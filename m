Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:41325 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753922AbdLOH45 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 02:56:57 -0500
Received: by mail-pg0-f65.google.com with SMTP id o2so5287682pgc.8
        for <linux-media@vger.kernel.org>; Thu, 14 Dec 2017 23:56:57 -0800 (PST)
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
Subject: [RFC PATCH 3/9] media: request: add generic entity ops
Date: Fri, 15 Dec 2017 16:56:19 +0900
Message-Id: <20171215075625.27028-4-acourbot@chromium.org>
In-Reply-To: <20171215075625.27028-1-acourbot@chromium.org>
References: <20171215075625.27028-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add skeleton ops for generic entities. The intent is to provide a
generic mechanism to apply request parameters to entities using regular
media/v4l2 functions.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/Makefile                       |  3 +-
 drivers/media/media-request-entity-generic.c | 56 ++++++++++++++++++++++++++++
 include/media/media-request.h                |  5 +++
 3 files changed, 63 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/media-request-entity-generic.c

diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 90117fff1339..dea482f6ab72 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -4,7 +4,8 @@
 #
 
 media-objs	:= media-device.o media-devnode.o media-entity.o \
-		   media-request.o media-request-queue-generic.o
+		   media-request.o media-request-queue-generic.o \
+		   media-request-entity-generic.o
 
 #
 # I2C drivers should come before other drivers, otherwise they'll fail
diff --git a/drivers/media/media-request-entity-generic.c b/drivers/media/media-request-entity-generic.c
new file mode 100644
index 000000000000..18e53f9ce525
--- /dev/null
+++ b/drivers/media/media-request-entity-generic.c
@@ -0,0 +1,56 @@
+/*
+ * Media generic entity ops
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
+#include <media/media-entity.h>
+#include <media/media-request.h>
+
+struct media_request_entity_data_generic {
+	struct media_request_entity_data base;
+};
+
+static struct media_request_entity_data *
+alloc_req_data(struct media_request *req, struct media_entity *entity)
+{
+	struct media_request_entity_data_generic *ret;
+
+	ret = kzalloc(sizeof(*ret), GFP_KERNEL);
+	if (!ret)
+		return ERR_PTR(-ENOMEM);
+
+	return &ret->base;
+}
+
+static void release_req_data(struct media_request_entity_data *_data)
+{
+	struct media_request_entity_data_generic *data;
+
+	data = container_of(_data, typeof(*data), base);
+	kfree(data);
+}
+
+static int apply_req_data(struct media_request_entity_data *_data)
+{
+	return 0;
+}
+
+const struct media_request_entity_ops
+media_entity_request_generic_ops = {
+	.alloc_data = alloc_req_data,
+	.release_data = release_req_data,
+	.apply_data = apply_req_data,
+};
+EXPORT_SYMBOL_GPL(media_entity_request_generic_ops);
diff --git a/include/media/media-request.h b/include/media/media-request.h
index 583a1116f735..de3d6d824ffd 100644
--- a/include/media/media-request.h
+++ b/include/media/media-request.h
@@ -240,6 +240,11 @@ struct media_request_entity_ops {
 	int (*apply_data)(struct media_request_entity_data *data);
 };
 
+/*
+ * Generic entity request support, built on top of standard V4L2 functions
+ */
+extern const struct media_request_entity_ops media_entity_request_generic_ops;
+
 /**
  * media_device_request_cmd() - perform the REQUEST_CMD ioctl
  *
-- 
2.15.1.504.g5279b80103-goog
