Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:34970 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754162AbdLNTKF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 14:10:05 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [RFC 1/2] Synchronize with the Kernel headers for routing operations
Date: Thu, 14 Dec 2017 20:09:42 +0100
Message-Id: <20171214190943.8179-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171214190943.8179-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171214190943.8179-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 include/linux/v4l2-subdev.h | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/include/linux/v4l2-subdev.h b/include/linux/v4l2-subdev.h
index dbce2b554e026869..e19ee64075d6cbdf 100644
--- a/include/linux/v4l2-subdev.h
+++ b/include/linux/v4l2-subdev.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 /*
  * V4L2 subdev userspace API
  *
@@ -154,6 +155,44 @@ struct v4l2_subdev_selection {
 	__u32 reserved[8];
 };
 
+#define V4L2_SUBDEV_ROUTE_FL_ACTIVE	(1 << 0)
+#define V4L2_SUBDEV_ROUTE_FL_IMMUTABLE	(1 << 1)
+
+/**
+ * struct v4l2_subdev_route - A signal route inside a subdev
+ * @sink_pad: the sink pad
+ * @sink_stream: the sink stream
+ * @source_pad: the source pad
+ * @source_stream: the source stream
+ * @flags: route flags:
+ *
+ *	V4L2_SUBDEV_ROUTE_FL_ACTIVE: Is the stream in use or not? An
+ *	active stream will start when streaming is enabled on a video
+ *	node. Set by the user.
+ *
+ *	V4L2_SUBDEV_ROUTE_FL_IMMUTABLE: Is the stream immutable, i.e.
+ *	can it be activated and inactivated? Set by the driver.
+ */
+struct v4l2_subdev_route {
+	__u32 sink_pad;
+	__u32 sink_stream;
+	__u32 source_pad;
+	__u32 source_stream;
+	__u32 flags;
+	__u32 reserved[5];
+};
+
+/**
+ * struct v4l2_subdev_routing - Routing information
+ * @routes: the routes array
+ * @num_routes: the total number of routes in the routes array
+ */
+struct v4l2_subdev_routing {
+	struct v4l2_subdev_route *routes;
+	__u32 num_routes;
+	__u32 reserved[5];
+};
+
 /* Backwards compatibility define --- to be removed */
 #define v4l2_subdev_edid v4l2_edid
 
@@ -176,5 +215,7 @@ struct v4l2_subdev_selection {
 #define VIDIOC_SUBDEV_ENUM_DV_TIMINGS		_IOWR('V', 98, struct v4l2_enum_dv_timings)
 #define VIDIOC_SUBDEV_QUERY_DV_TIMINGS		_IOR('V', 99, struct v4l2_dv_timings)
 #define VIDIOC_SUBDEV_DV_TIMINGS_CAP		_IOWR('V', 100, struct v4l2_dv_timings_cap)
+#define VIDIOC_SUBDEV_G_ROUTING			_IOWR('V', 38, struct v4l2_subdev_routing)
+#define VIDIOC_SUBDEV_S_ROUTING			_IOWR('V', 39, struct v4l2_subdev_routing)
 
 #endif
-- 
2.14.2
