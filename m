Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:38754 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753830AbeAaK0i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 05:26:38 -0500
Received: by mail-pg0-f67.google.com with SMTP id y27so9692772pgc.5
        for <linux-media@vger.kernel.org>; Wed, 31 Jan 2018 02:26:38 -0800 (PST)
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
Subject: [RFCv2 12/17] v4l2: add request API support
Date: Wed, 31 Jan 2018 19:26:20 +0900
Message-Id: <20180131102625.208021-3-acourbot@chromium.org>
In-Reply-To: <20180131102625.208021-1-acourbot@chromium.org>
References: <20180131102625.208021-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a v4l2 request entity data structure that takes care of storing the
request-related state of a V4L2 device ; in this case, its controls.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/v4l2-core/Makefile       |  2 +-
 drivers/media/v4l2-core/v4l2-request.c | 54 ++++++++++++++++++++++++++++++++++
 include/media/v4l2-request.h           | 34 +++++++++++++++++++++
 3 files changed, 89 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/v4l2-core/v4l2-request.c
 create mode 100644 include/media/v4l2-request.h

diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 77303286aef7..5d885932f68f 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -15,7 +15,7 @@ obj-$(CONFIG_V4L2_FWNODE) += v4l2-fwnode.o
 ifeq ($(CONFIG_TRACEPOINTS),y)
   videodev-objs += vb2-trace.o v4l2-trace.o
 endif
-videodev-$(CONFIG_MEDIA_CONTROLLER) += v4l2-mc.o
+videodev-$(CONFIG_MEDIA_CONTROLLER) += v4l2-mc.o v4l2-request.o
 
 obj-$(CONFIG_VIDEO_V4L2) += videodev.o
 obj-$(CONFIG_VIDEO_V4L2) += v4l2-common.o
diff --git a/drivers/media/v4l2-core/v4l2-request.c b/drivers/media/v4l2-core/v4l2-request.c
new file mode 100644
index 000000000000..7bc29d3cc332
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-request.c
@@ -0,0 +1,54 @@
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
+#include <media/v4l2-request.h>
+
+struct media_request_entity_data *media_request_v4l2_entity_data_alloc(
+	struct v4l2_ctrl_handler *hdl)
+{
+	struct media_request_v4l2_entity_data *data;
+	int ret;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+
+	ret = v4l2_ctrl_request_init(&data->ctrls);
+	if (ret) {
+		kfree(data);
+		return ERR_PTR(ret);
+	}
+
+	ret = v4l2_ctrl_request_clone(&data->ctrls, hdl, NULL);
+	if (ret) {
+		kfree(data);
+		return ERR_PTR(ret);
+	}
+
+	return &data->base;
+}
+EXPORT_SYMBOL_GPL(media_request_v4l2_entity_data_alloc);
+
+void
+media_request_v4l2_entity_data_free(struct media_request_entity_data *_data)
+{
+	struct media_request_v4l2_entity_data *data;
+
+	data = to_v4l2_entity_data(_data);
+
+	v4l2_ctrl_handler_free(&data->ctrls);
+	kfree(data);
+}
+EXPORT_SYMBOL_GPL(media_request_v4l2_entity_data_free);
diff --git a/include/media/v4l2-request.h b/include/media/v4l2-request.h
new file mode 100644
index 000000000000..db38dc5fc460
--- /dev/null
+++ b/include/media/v4l2-request.h
@@ -0,0 +1,34 @@
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
+#ifndef _MEDIA_REQUEST_V4L2_H
+#define _MEDIA_REQUEST_V4L2_H
+
+#include <media/media-request.h>
+#include <media/v4l2-ctrls.h>
+
+struct media_request_v4l2_entity_data {
+	struct media_request_entity_data base;
+
+	struct v4l2_ctrl_handler ctrls;
+};
+#define to_v4l2_entity_data(d) \
+	container_of(d, struct media_request_v4l2_entity_data, base)
+
+struct media_request_entity_data *media_request_v4l2_entity_data_alloc(
+	struct v4l2_ctrl_handler *hdl);
+void media_request_v4l2_entity_data_free(struct media_request_entity_data *data);
+
+#endif
-- 
2.16.0.rc1.238.g530d649a79-goog
