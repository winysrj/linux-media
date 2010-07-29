Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:36476 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962Ab0G2QHM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 12:07:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [SAMPLE v3 04/12] v4l-subdev: Add pads operations
Date: Thu, 29 Jul 2010 18:06:48 +0200
Message-Id: <1280419616-7658-16-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a v4l2_subdev_pad_ops structure for the operations that need to be
performed at the pad level such as format-related operations.

The format at the output of a subdev usually depends on the format at
its input(s). The try format operation is thus not suitable for probing
format at individual pads, as it can't modify the device state and thus
can't remember the format probed at the input to compute the output
format.

To fix the problem, pass an extra argument to the get/set format
operations to select the 'probe' or 'active' format.

The probe format is used when probing the subdev. Setting the probe
format must not change the device configuration but can store data for
later reuse. Data storage is provided at the file-handle level so
applications probing the subdev concurently won't interfere with each
other.

The active format is used when configuring the subdev. It's identical to
the format handled by the usual get/set operations.

Pad format-related operations use v4l2_mbus_framefmt instead of
v4l2_format.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/v4l2-subdev.h |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 01b4135..684ab60 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -41,6 +41,7 @@ struct v4l2_device;
 struct v4l2_event_subscription;
 struct v4l2_fh;
 struct v4l2_subdev;
+struct v4l2_subdev_fh;
 struct tuner_setup;
 
 /* decode_vbi_line */
@@ -398,6 +399,25 @@ struct v4l2_subdev_ir_ops {
 				struct v4l2_subdev_ir_parameters *params);
 };
 
+enum v4l2_subdev_format {
+	V4L2_SUBDEV_FORMAT_PROBE = 0,
+	V4L2_SUBDEV_FORMAT_ACTIVE = 1,
+};
+
+struct v4l2_subdev_pad_ops {
+	int (*enum_mbus_code)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_pad_mbus_code_enum *code);
+	int (*enum_frame_size)(struct v4l2_subdev *sd,
+			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_frame_size_enum *fse);
+	int (*get_fmt)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+		       unsigned int pad, struct v4l2_mbus_framefmt *fmt,
+		       enum v4l2_subdev_format which);
+	int (*set_fmt)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+		       unsigned int pad, struct v4l2_mbus_framefmt *fmt,
+		       enum v4l2_subdev_format which);
+};
+
 struct v4l2_subdev_ops {
 	const struct v4l2_subdev_core_ops	*core;
 	const struct v4l2_subdev_tuner_ops	*tuner;
@@ -406,6 +426,7 @@ struct v4l2_subdev_ops {
 	const struct v4l2_subdev_vbi_ops	*vbi;
 	const struct v4l2_subdev_ir_ops		*ir;
 	const struct v4l2_subdev_sensor_ops	*sensor;
+	const struct v4l2_subdev_pad_ops	*pad;
 };
 
 #define V4L2_SUBDEV_NAME_SIZE 32
-- 
1.7.1

