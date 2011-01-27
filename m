Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59832 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab1A0MbA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jan 2011 07:31:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v6 07/11] v4l: v4l2_subdev pad-level operations
Date: Thu, 27 Jan 2011 13:30:52 +0100
Message-Id: <1296131456-30000-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1296131456-30000-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1296131456-30000-1-git-send-email-laurent.pinchart@ideasonboard.com>
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
index af704df..4f6ddba 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -42,6 +42,7 @@ struct v4l2_ctrl_handler;
 struct v4l2_event_subscription;
 struct v4l2_fh;
 struct v4l2_subdev;
+struct v4l2_subdev_fh;
 struct tuner_setup;
 
 /* decode_vbi_line */
@@ -423,6 +424,9 @@ struct v4l2_subdev_ir_ops {
 				struct v4l2_subdev_ir_parameters *params);
 };
 
+struct v4l2_subdev_pad_ops {
+};
+
 struct v4l2_subdev_ops {
 	const struct v4l2_subdev_core_ops	*core;
 	const struct v4l2_subdev_file_ops	*file;
@@ -432,6 +436,7 @@ struct v4l2_subdev_ops {
 	const struct v4l2_subdev_vbi_ops	*vbi;
 	const struct v4l2_subdev_ir_ops		*ir;
 	const struct v4l2_subdev_sensor_ops	*sensor;
+	const struct v4l2_subdev_pad_ops	*pad;
 };
 
 #define V4L2_SUBDEV_NAME_SIZE 32
-- 
1.7.3.4

