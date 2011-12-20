Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:35787 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849Ab1LTU2P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 15:28:15 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com
Subject: [RFC 09/17] v4l: Add pad op for pipeline validation
Date: Tue, 20 Dec 2011 22:28:01 +0200
Message-Id: <1324412889-17961-9-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4EF0EFC9.6080501@maxwell.research.nokia.com>
References: <4EF0EFC9.6080501@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

smiapp_pad_ops.validate_pipeline is intended to validate the full pipeline
which is implemented by the driver to which the subdev implementing this op
belongs to. The validate_pipeline op must also call validate_pipeline on
any external entity which is linked to its sink pads.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 include/media/v4l2-subdev.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 26eeaa4..a5ebe86 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -470,6 +470,7 @@ struct v4l2_subdev_pad_ops {
 			     struct v4l2_subdev_selection *sel);
 	int (*set_selection)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 			     struct v4l2_subdev_selection *sel);
+	int (*validate_pipeline)(struct v4l2_subdev *sd);
 };
 
 struct v4l2_subdev_ops {
-- 
1.7.2.5

