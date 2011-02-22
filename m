Return-path: <mchehab@pedra>
Received: from ns.mm-sol.com ([213.240.235.226]:54411 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677Ab1BVKjz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Feb 2011 05:39:55 -0500
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	saaguirre@ti.com, Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [RFC/PATCH 1/1] v4l: Introduce sensor operation for getting interface configuration
Date: Tue, 22 Feb 2011 12:31:53 +0200
Message-Id: <fc5d1bbfedf641a7578aa6f9a4f556f829b61a1a.1298368924.git.svarbanov@mm-sol.com>
In-Reply-To: <cover.1298368924.git.svarbanov@mm-sol.com>
References: <cover.1298368924.git.svarbanov@mm-sol.com>
In-Reply-To: <cover.1298368924.git.svarbanov@mm-sol.com>
References: <cover.1298368924.git.svarbanov@mm-sol.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Introduce g_interface_parms sensor operation for getting sensor
interface parameters. These parameters are needed from the host side
to determine it's own configuration.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 include/media/v4l2-subdev.h |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index b0316a7..4186cad 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -322,15 +322,57 @@ struct v4l2_subdev_vbi_ops {
 	int (*s_sliced_fmt)(struct v4l2_subdev *sd, struct v4l2_sliced_vbi_format *fmt);
 };
 
+/* Which interface the sensor use to provide it's image data */
+enum v4l2_subdev_sensor_iface {
+	V4L2_SUBDEV_SENSOR_PARALLEL,
+	V4L2_SUBDEV_SENSOR_SERIAL,
+};
+
+/* Each interface could use the following modes */
+/* Image sensor provides horizontal and vertical sync signals */
+#define V4L2_SUBDEV_SENSOR_MODE_PARALLEL_SYNC	0
+/* BT.656 interface. Embedded sync */
+#define V4L2_SUBDEV_SENSOR_MODE_PARALLEL_ITU	1
+/* MIPI CSI1 */
+#define V4L2_SUBDEV_SENSOR_MODE_SERIAL_CSI1	2
+/* MIPI CSI2 */
+#define V4L2_SUBDEV_SENSOR_MODE_SERIAL_CSI2	3
+
+struct v4l2_subdev_sensor_serial_parms {
+	unsigned char lanes;		/* number of lanes used */
+	unsigned char channel;		/* virtual channel */
+	unsigned int phy_rate;		/* output rate at CSI phy in bps */
+	unsigned int pix_clk;		/* pixel clock in Hz */
+};
+
+struct v4l2_subdev_sensor_parallel_parms {
+	unsigned int pix_clk;		/* pixel clock in Hz */
+};
+
+struct v4l2_subdev_sensor_interface_parms {
+	enum v4l2_subdev_sensor_iface if_type;
+	unsigned int if_mode;
+	union {
+		struct v4l2_subdev_sensor_serial_parms serial;
+		struct v4l2_subdev_sensor_parallel_parms parallel;
+	} parms;
+};
+
 /**
  * struct v4l2_subdev_sensor_ops - v4l2-subdev sensor operations
  * @g_skip_top_lines: number of lines at the top of the image to be skipped.
  *		      This is needed for some sensors, which always corrupt
  *		      several top lines of the output image, or which send their
  *		      metadata in them.
+ * @g_interface_parms: get sensor interface parameters. The sensor subdev should
+ *		       fill this structure with current interface params. These
+ *		       interface parameters are needed on host side to configure
+ *		       it's own hardware receivers.
  */
 struct v4l2_subdev_sensor_ops {
 	int (*g_skip_top_lines)(struct v4l2_subdev *sd, u32 *lines);
+	int (*g_interface_parms)(struct v4l2_subdev *sd,
+			struct v4l2_subdev_sensor_interface_parms *parms);
 };
 
 /*
-- 
1.6.5

