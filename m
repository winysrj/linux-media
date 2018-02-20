Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:45404 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751600AbeBTEpl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 23:45:41 -0500
Received: by mail-pf0-f196.google.com with SMTP id j24so2063970pff.12
        for <linux-media@vger.kernel.org>; Mon, 19 Feb 2018 20:45:41 -0800 (PST)
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
Subject: [RFCv4 21/21] [WIP] media: media-device: support for creating requests
Date: Tue, 20 Feb 2018 13:44:25 +0900
Message-Id: <20180220044425.169493-22-acourbot@chromium.org>
In-Reply-To: <20180220044425.169493-1-acourbot@chromium.org>
References: <20180220044425.169493-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new MEDIA_IOC_NEW_REQUEST ioctl, which can be used to instantiate
a request suitable to control the media device topology as well as the
parameters and buffer flow of its entities.

This is still very early work, and mainly here to demonstrate that it is
still possible to bind requests to media entities.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/media-device.c | 11 +++++++++++
 include/media/mc-request.h   | 33 +++++++++++++++++++++++++++++++++
 include/media/media-device.h |  1 +
 include/media/media-entity.h |  5 +++++
 include/uapi/linux/media.h   |  2 ++
 5 files changed, 52 insertions(+)
 create mode 100644 include/media/mc-request.h

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index e79f72b8b858..2fb8b9c5ec85 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -32,6 +32,7 @@
 #include <media/media-device.h>
 #include <media/media-devnode.h>
 #include <media/media-entity.h>
+#include <media/media-request.h>
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 
@@ -359,6 +360,15 @@ static long media_device_get_topology(struct media_device *mdev,
 	return ret;
 }
 
+static long media_device_new_request(struct media_device *mdev,
+				     struct media_request_new *new)
+{
+	if (!mdev->req_mgr)
+		return -ENOTTY;
+
+	return media_request_ioctl_new(mdev->req_mgr, new);
+}
+
 static long copy_arg_from_user(void *karg, void __user *uarg, unsigned int cmd)
 {
 	/* All media IOCTLs are _IOWR() */
@@ -407,6 +417,7 @@ static const struct media_ioctl_info ioctl_info[] = {
 	MEDIA_IOC(ENUM_LINKS, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC(NEW_REQUEST, media_device_new_request, 0),
 };
 
 static long media_device_ioctl(struct file *filp, unsigned int cmd,
diff --git a/include/media/mc-request.h b/include/media/mc-request.h
new file mode 100644
index 000000000000..c14d38a93019
--- /dev/null
+++ b/include/media/mc-request.h
@@ -0,0 +1,33 @@
+/*
+ * Media requests support for media controller
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
+#ifndef _MEDIA_MC_REQUEST_H
+#define _MEDIA_MC_REQUEST_H
+
+#include <linux/kconfig.h>
+#include <media/media-request.h>
+
+#if IS_ENABLED(CONFIG_MEDIA_REQUEST_API)
+
+struct mc_request_entity {
+	struct media_request_entity base;
+	struct media_entity *entity;
+};
+
+#else  /* CONFIG_MEDIA_REQUEST_API */
+
+#endif  /* CONFIG_MEDIA_REQUEST_API */
+
+#endif
diff --git a/include/media/media-device.h b/include/media/media-device.h
index bcc6ec434f1f..e931e8b9f60e 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -127,6 +127,7 @@ struct media_device {
 	/* dev->driver_data points to this struct. */
 	struct device *dev;
 	struct media_devnode *devnode;
+	struct media_request_mgr *req_mgr;
 
 	char model[32];
 	char driver_name[32];
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index a732af1dbba0..e3525d1ec386 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -26,6 +26,8 @@
 #include <linux/list.h>
 #include <linux/media.h>
 
+struct mc_request_entity;
+
 /* Enums used internally at the media controller to represent graphs */
 
 /**
@@ -243,6 +245,7 @@ enum media_entity_type {
  *		re-used if entities are unregistered or registered again.
  * @pads:	Pads array with the size defined by @num_pads.
  * @links:	List of data links.
+ * @req_entity:	Pointer to the request entity representing this entity, if any
  * @ops:	Entity operations.
  * @stream_count: Stream count for the entity.
  * @use_count:	Use count for the entity.
@@ -279,6 +282,8 @@ struct media_entity {
 	struct media_pad *pads;
 	struct list_head links;
 
+	struct mc_request_entity *req_entity;
+
 	const struct media_entity_operations *ops;
 
 	int stream_count;
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index b9b9446095e9..eb0014c4eb40 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -30,6 +30,7 @@
 #include <linux/ioctl.h>
 #include <linux/types.h>
 #include <linux/version.h>
+#include <linux/media-request.h>
 
 struct media_device_info {
 	char driver[16];
@@ -413,5 +414,6 @@ struct media_v2_topology {
 #define MEDIA_IOC_ENUM_LINKS		_IOWR('|', 0x02, struct media_links_enum)
 #define MEDIA_IOC_SETUP_LINK		_IOWR('|', 0x03, struct media_link_desc)
 #define MEDIA_IOC_G_TOPOLOGY		_IOWR('|', 0x04, struct media_v2_topology)
+#define MEDIA_IOC_NEW_REQUEST		_IOR('|', 0x05, struct media_request_new)
 
 #endif /* __LINUX_MEDIA_H */
-- 
2.16.1.291.g4437f3f132-goog
