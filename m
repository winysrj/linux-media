Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58187 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab1BNMV2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:21:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v7 07/11] v4l: v4l2_subdev pad-level operations
Date: Mon, 14 Feb 2011 13:21:20 +0100
Message-Id: <1297686084-9715-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686084-9715-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1297686084-9715-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add a v4l2_subdev_pad_ops structure for the operations that need to be
performed at the pad level such as format-related operations.

Pad format-related operations use v4l2_mbus_framefmt instead of
v4l2_format.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/v4l2-subdev.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index ff42cc4..ce2f373 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -411,6 +411,9 @@ struct v4l2_subdev_ir_ops {
 				struct v4l2_subdev_ir_parameters *params);
 };
 
+struct v4l2_subdev_pad_ops {
+};
+
 struct v4l2_subdev_ops {
 	const struct v4l2_subdev_core_ops	*core;
 	const struct v4l2_subdev_tuner_ops	*tuner;
@@ -419,6 +422,7 @@ struct v4l2_subdev_ops {
 	const struct v4l2_subdev_vbi_ops	*vbi;
 	const struct v4l2_subdev_ir_ops		*ir;
 	const struct v4l2_subdev_sensor_ops	*sensor;
+	const struct v4l2_subdev_pad_ops	*pad;
 };
 
 /*
-- 
1.7.3.4

