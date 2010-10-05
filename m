Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:55203 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab0JENMs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Oct 2010 09:12:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v2 07/10] v4l: v4l2_subdev pad-level operations
Date: Tue,  5 Oct 2010 15:12:53 +0200
Message-Id: <1286284376-12217-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286284376-12217-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1286284376-12217-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add a v4l2_subdev_pad_ops structure for the operations that need to be
performed at the pad level such as format-related operations.

Pad format-related operations use v4l2_mbus_framefmt instead of
v4l2_format.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/v4l2-subdev.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 961ac4a..9a1e759 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -42,6 +42,7 @@ struct v4l2_ctrl_handler;
 struct v4l2_event_subscription;
 struct v4l2_fh;
 struct v4l2_subdev;
+struct v4l2_subdev_fh;
 struct tuner_setup;
 
 /* decode_vbi_line */
@@ -418,6 +419,9 @@ struct v4l2_subdev_ir_ops {
 				struct v4l2_subdev_ir_parameters *params);
 };
 
+struct v4l2_subdev_pad_ops {
+};
+
 struct v4l2_subdev_ops {
 	const struct v4l2_subdev_core_ops	*core;
 	const struct v4l2_subdev_tuner_ops	*tuner;
@@ -426,6 +430,7 @@ struct v4l2_subdev_ops {
 	const struct v4l2_subdev_vbi_ops	*vbi;
 	const struct v4l2_subdev_ir_ops		*ir;
 	const struct v4l2_subdev_sensor_ops	*sensor;
+	const struct v4l2_subdev_pad_ops	*pad;
 };
 
 #define V4L2_SUBDEV_NAME_SIZE 32
-- 
1.7.2.2

