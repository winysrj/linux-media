Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D642C00319
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DCAE21019
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbfCESv5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:51:57 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:46799 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfCESv4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 13:51:56 -0500
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 1174A200002;
        Tue,  5 Mar 2019 18:51:52 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH v3 18/31] v4l: subdev: Add [GS]_ROUTING subdev ioctls and operations
Date:   Tue,  5 Mar 2019 19:51:37 +0100
Message-Id: <20190305185150.20776-19-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>

- Add sink and source streams for multiplexed links
- Copy the argument back in case of an error. This is needed to let the
  caller know the number of routes.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

- Expand and refine documentation.
- Make the 'routes' pointer a __u64 __user pointer so that a compat32
  version of the ioctl is not required.
- Add struct v4l2_subdev_krouting to be used for subdevice operations.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c  | 25 ++++++++++++++++-
 drivers/media/v4l2-core/v4l2-subdev.c | 36 ++++++++++++++++++++++++
 include/media/v4l2-subdev.h           | 22 +++++++++++++++
 include/uapi/linux/v4l2-subdev.h      | 40 +++++++++++++++++++++++++++
 4 files changed, 122 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index f6d663934648..255f8aff5db8 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/version.h>
 
+#include <linux/v4l2-subdev.h>
 #include <linux/videodev2.h>
 
 #include <media/v4l2-common.h>
@@ -2967,6 +2968,21 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 		}
 		break;
 	}
+
+	case VIDIOC_SUBDEV_G_ROUTING:
+	case VIDIOC_SUBDEV_S_ROUTING: {
+		struct v4l2_subdev_routing *route = parg;
+
+		if (route->num_routes > 256)
+			return -EINVAL;
+
+		*user_ptr = (void __user *)route->routes;
+		*kernel_ptr = (void *)&route->routes;
+		*array_size = sizeof(struct v4l2_subdev_route)
+			    * route->num_routes;
+		ret = 1;
+		break;
+	}
 	}
 
 	return ret;
@@ -3075,8 +3091,15 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 	/*
 	 * Some ioctls can return an error, but still have valid
 	 * results that must be returned.
+	 *
+	 * FIXME: subdev IOCTLS are partially handled here and partially in
+	 * v4l2-subdev.c and the 'always_copy' flag can only be set for IOCTLS
+	 * defined here as part of the 'v4l2_ioctls' array. As
+	 * VIDIOC_SUBDEV_G_ROUTING needs to return results to applications even
+	 * in case of failure, but it is not defined here as part of the
+	 * 'v4l2_ioctls' array, insert an ad-hoc check to address that.
 	 */
-	if (err < 0 && !always_copy)
+	if (err < 0 && !always_copy && cmd != VIDIOC_SUBDEV_G_ROUTING)
 		goto out;
 
 out_array_args:
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index f5f0d71ec745..f845b0658913 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -519,6 +519,42 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 	case VIDIOC_SUBDEV_QUERYSTD:
 		return v4l2_subdev_call(sd, video, querystd, arg);
+
+	case VIDIOC_SUBDEV_G_ROUTING: {
+		struct v4l2_subdev_routing *routing = arg;
+		struct v4l2_subdev_krouting krouting = {
+			.num_routes = routing->num_routes,
+			.routes = (struct v4l2_subdev_route *)routing->routes,
+		};
+		int ret;
+
+		ret = v4l2_subdev_call(sd, pad, get_routing, &krouting);
+		if (ret)
+			return ret;
+
+		routing->num_routes = krouting.num_routes;
+
+		return 0;
+	}
+
+	case VIDIOC_SUBDEV_S_ROUTING: {
+		struct v4l2_subdev_routing *routing = arg;
+		struct v4l2_subdev_route *route = (struct v4l2_subdev_route *)
+						  routing->routes;
+		struct v4l2_subdev_krouting krouting = {};
+		unsigned int i;
+
+		for (i = 0; i < routing->num_routes; ++i) {
+			if (route[i].sink_pad >= sd->entity.num_pads ||
+			    route[i].source_pad >= sd->entity.num_pads)
+				return -EINVAL;
+		}
+
+		krouting.num_routes = routing->num_routes;
+		krouting.routes = route;
+
+		return v4l2_subdev_call(sd, pad, set_routing, &krouting);
+	}
 #endif
 	default:
 		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 03707d16d668..6311f670de3c 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -669,6 +669,20 @@ struct v4l2_subdev_pad_config {
 	struct v4l2_rect try_compose;
 };
 
+/**
+ * struct v4l2_subdev_krouting - subdev routing table
+ *
+ * @routes: &struct v4l2_subdev_route
+ * @num_routes: number of routes
+ *
+ * This structure is used to translate argument received from
+ * VIDIOC_SUBDEV_G/S_ROUTING() ioctl to sudev device drivers operations.
+ */
+struct v4l2_subdev_krouting {
+	struct v4l2_subdev_route *routes;
+	unsigned int num_routes;
+};
+
 /**
  * struct v4l2_subdev_pad_ops - v4l2-subdev pad level operations
  *
@@ -706,6 +720,10 @@ struct v4l2_subdev_pad_config {
  *
  * @set_frame_desc: set the low level media bus frame parameters, @fd array
  *                  may be adjusted by the subdev driver to device capabilities.
+ *
+ * @get_routing: get the subdevice routing table.
+ * @set_routing: enable or disable data connection routes described in the
+ *		 subdevice routing table.
  */
 struct v4l2_subdev_pad_ops {
 	int (*init_cfg)(struct v4l2_subdev *sd,
@@ -746,6 +764,10 @@ struct v4l2_subdev_pad_ops {
 			      struct v4l2_mbus_frame_desc *fd);
 	int (*set_frame_desc)(struct v4l2_subdev *sd, unsigned int pad,
 			      struct v4l2_mbus_frame_desc *fd);
+	int (*get_routing)(struct v4l2_subdev *sd,
+			   struct v4l2_subdev_krouting *route);
+	int (*set_routing)(struct v4l2_subdev *sd,
+			   struct v4l2_subdev_krouting *route);
 };
 
 /**
diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
index 03970ce30741..b8924a6a029c 100644
--- a/include/uapi/linux/v4l2-subdev.h
+++ b/include/uapi/linux/v4l2-subdev.h
@@ -155,6 +155,44 @@ struct v4l2_subdev_selection {
 	__u32 reserved[8];
 };
 
+#define V4L2_SUBDEV_ROUTE_FL_ACTIVE	(1 << 0)
+#define V4L2_SUBDEV_ROUTE_FL_IMMUTABLE	(1 << 1)
+
+/**
+ * struct v4l2_subdev_route - A route inside a subdev
+ * @sink_pad: the sink pad index
+ * @sink_stream: the sink stream identifier
+ * @source_pad: the source pad index
+ * @source_stream: the source stream identifier
+ * @flags: route flags:
+ *
+ *	V4L2_SUBDEV_ROUTE_FL_ACTIVE: Is the route active? An active
+ *	route will start when streaming is enabled on a video node.
+ *	Set by the user.
+ *
+ *	V4L2_SUBDEV_ROUTE_FL_IMMUTABLE: Is the route immutable, i.e.
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
+ * struct v4l2_subdev_routing - Subdev routing information
+ * @routes: pointer to the routes array
+ * @num_routes: the total number of routes in the routes array
+ */
+struct v4l2_subdev_routing {
+	__u64 routes;
+	__u32 num_routes;
+	__u32 reserved[5];
+};
+
 /* Backwards compatibility define --- to be removed */
 #define v4l2_subdev_edid v4l2_edid
 
@@ -181,5 +219,7 @@ struct v4l2_subdev_selection {
 #define VIDIOC_SUBDEV_ENUM_DV_TIMINGS		_IOWR('V', 98, struct v4l2_enum_dv_timings)
 #define VIDIOC_SUBDEV_QUERY_DV_TIMINGS		_IOR('V', 99, struct v4l2_dv_timings)
 #define VIDIOC_SUBDEV_DV_TIMINGS_CAP		_IOWR('V', 100, struct v4l2_dv_timings_cap)
+#define VIDIOC_SUBDEV_G_ROUTING			_IOWR('V', 38, struct v4l2_subdev_routing)
+#define VIDIOC_SUBDEV_S_ROUTING			_IOWR('V', 39, struct v4l2_subdev_routing)
 
 #endif
-- 
2.20.1

