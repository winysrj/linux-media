Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:50943 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513Ab2BBXzD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Feb 2012 18:55:03 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v2 14/31] v4l: Improve sub-device documentation for pad ops
Date: Fri,  3 Feb 2012 01:54:34 +0200
Message-Id: <1328226891-8968-14-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120202235231.GC841@valkosipuli.localdomain>
References: <20120202235231.GC841@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document that format related configuration is done through pad ops in case
the driver does use the media framework.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/video4linux/v4l2-framework.txt |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 659b2ba..f06c563 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -262,11 +262,16 @@ struct v4l2_subdev_video_ops {
 	...
 };
 
+struct v4l2_subdev_pad_ops {
+	...
+};
+
 struct v4l2_subdev_ops {
 	const struct v4l2_subdev_core_ops  *core;
 	const struct v4l2_subdev_tuner_ops *tuner;
 	const struct v4l2_subdev_audio_ops *audio;
 	const struct v4l2_subdev_video_ops *video;
+	const struct v4l2_subdev_pad_ops *video;
 };
 
 The core ops are common to all subdevs, the other categories are implemented
@@ -303,6 +308,10 @@ Don't forget to cleanup the media entity before the sub-device is destroyed:
 
 	media_entity_cleanup(&sd->entity);
 
+If the subdev driver intends to process video and integrate with the media
+framework, it must implement format related functionality using
+v4l2_subdev_pad_ops instead of v4l2_subdev_video_ops.
+
 A device (bridge) driver needs to register the v4l2_subdev with the
 v4l2_device:
 
-- 
1.7.2.5

