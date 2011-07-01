Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:52119 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab1GARbd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2011 13:31:33 -0400
Date: Fri, 1 Jul 2011 19:31:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	saaguirre@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v5] V4L: add media bus configuration subdev operations
Message-ID: <Pine.LNX.4.64.1107011926400.17345@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add media bus configuration types and two subdev operations to get
supported mediabus configurations and to set a specific configuration.
Subdevs can support several configurations, e.g., they can send video data
on 1 or several lanes, can be configured to use a specific CSI-2 channel,
in such cases subdevice drivers return bitmasks with all respective bits
set. When a set-configuration operation is called, it has to specify a
non-ambiguous configuration.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Ok, no more RFC. This is the version I'd like to get into 3.1. Please, 
(n)ack vigorously;) Mauro, if this is accepted, would you like me to push 
it via my tree or would you take it from the mail?

v5: removed all traces of v4l2-mediabus.c and 
v4l2_mbus_config_compatible()

 include/media/v4l2-mediabus.h |   63 ++++++++++++++++++++++++++++++++++++++++++
 include/media/v4l2-subdev.h   |   10 ++++++
 2 files changed, 73 insertions(+)

diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 971c7fa..e0fb39a 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -13,6 +13,69 @@
 
 #include <linux/v4l2-mediabus.h>
 
+/* Parallel flags */
+/*
+ * Can the client run in master or in slave mode. By "Master mode" an operation
+ * mode is meant, when the client (e.g., a camera sensor) is producing
+ * horizontal and vertical synchronisation. In "Slave mode" the host is
+ * providing these signals to the slave.
+ */
+#define V4L2_MBUS_MASTER			(1 << 0)
+#define V4L2_MBUS_SLAVE				(1 << 1)
+/* Which signal polarities it supports */
+/* Note: in BT.656 mode HSYNC and VSYNC are unused */
+#define V4L2_MBUS_HSYNC_ACTIVE_HIGH		(1 << 2)
+#define V4L2_MBUS_HSYNC_ACTIVE_LOW		(1 << 3)
+#define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1 << 4)
+#define V4L2_MBUS_VSYNC_ACTIVE_LOW		(1 << 5)
+#define V4L2_MBUS_PCLK_SAMPLE_RISING		(1 << 6)
+#define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1 << 7)
+#define V4L2_MBUS_DATA_ACTIVE_HIGH		(1 << 8)
+#define V4L2_MBUS_DATA_ACTIVE_LOW		(1 << 9)
+
+/* Serial flags */
+/* How many lanes the client can use */
+#define V4L2_MBUS_CSI2_1_LANE			(1 << 0)
+#define V4L2_MBUS_CSI2_2_LANE			(1 << 1)
+#define V4L2_MBUS_CSI2_3_LANE			(1 << 2)
+#define V4L2_MBUS_CSI2_4_LANE			(1 << 3)
+/* On which channels it can send video data */
+#define V4L2_MBUS_CSI2_CHANNEL_0		(1 << 4)
+#define V4L2_MBUS_CSI2_CHANNEL_1		(1 << 5)
+#define V4L2_MBUS_CSI2_CHANNEL_2		(1 << 6)
+#define V4L2_MBUS_CSI2_CHANNEL_3		(1 << 7)
+/* Does it support only continuous or also non-continuous clock mode */
+#define V4L2_MBUS_CSI2_CONTINUOUS_CLOCK		(1 << 8)
+#define V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK	(1 << 9)
+
+#define V4L2_MBUS_CSI2_LANES		(V4L2_MBUS_CSI2_1_LANE | V4L2_MBUS_CSI2_2_LANE | \
+					 V4L2_MBUS_CSI2_3_LANE | V4L2_MBUS_CSI2_4_LANE)
+#define V4L2_MBUS_CSI2_CHANNELS		(V4L2_MBUS_CSI2_CHANNEL_0 | V4L2_MBUS_CSI2_CHANNEL_1 | \
+					 V4L2_MBUS_CSI2_CHANNEL_2 | V4L2_MBUS_CSI2_CHANNEL_3)
+
+/**
+ * v4l2_mbus_type - media bus type
+ * @V4L2_MBUS_PARALLEL:	parallel interface with hsync and vsync
+ * @V4L2_MBUS_BT656:	parallel interface with embedded synchronisation, can
+ *			also be used for BT.1120
+ * @V4L2_MBUS_CSI2:	MIPI CSI-2 serial interface
+ */
+enum v4l2_mbus_type {
+	V4L2_MBUS_PARALLEL,
+	V4L2_MBUS_BT656,
+	V4L2_MBUS_CSI2,
+};
+
+/**
+ * v4l2_mbus_config - media bus configuration
+ * @type:	in: interface type
+ * @flags:	in / out: configuration flags, depending on @type
+ */
+struct v4l2_mbus_config {
+	enum v4l2_mbus_type type;
+	unsigned int flags;
+};
+
 static inline void v4l2_fill_pix_format(struct v4l2_pix_format *pix_fmt,
 				const struct v4l2_mbus_framefmt *mbus_fmt)
 {
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 1562c4f..a42fb25 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -255,6 +255,12 @@ struct v4l2_subdev_audio_ops {
    try_mbus_fmt: try to set a pixel format on a video data source
 
    s_mbus_fmt: set a pixel format on a video data source
+
+   g_mbus_config: get supported mediabus configurations
+
+   s_mbus_config: set a certain mediabus configuration. This operation is added
+	for compatibility with soc-camera drivers and should not be used by new
+	software.
  */
 struct v4l2_subdev_video_ops {
 	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 config);
@@ -294,6 +300,10 @@ struct v4l2_subdev_video_ops {
 			    struct v4l2_mbus_framefmt *fmt);
 	int (*s_mbus_fmt)(struct v4l2_subdev *sd,
 			  struct v4l2_mbus_framefmt *fmt);
+	int (*g_mbus_config)(struct v4l2_subdev *sd,
+			     struct v4l2_mbus_config *cfg);
+	int (*s_mbus_config)(struct v4l2_subdev *sd,
+			     const struct v4l2_mbus_config *cfg);
 };
 
 /*
-- 
1.7.2.5

