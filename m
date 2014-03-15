Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4304 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539AbaCONIW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Mar 2014 09:08:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, pawel@osciak.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH for v3.15 1/4] v4l2-subdev.h: fix sparse error with v4l2_subdev_notify
Date: Sat, 15 Mar 2014 14:08:00 +0100
Message-Id: <1394888883-46850-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394888883-46850-1-git-send-email-hverkuil@xs4all.nl>
References: <1394888883-46850-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The notify function is a void function, yet the v4l2_subdev_notify
define uses it in a ? : construction, which causes sparse warnings.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/v4l2-subdev.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 28f4d8c..0fbf669 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -692,9 +692,11 @@ void v4l2_subdev_init(struct v4l2_subdev *sd,
 		(sd)->ops->o->f((sd) , ##args) : -ENOIOCTLCMD))
 
 /* Send a notification to v4l2_device. */
-#define v4l2_subdev_notify(sd, notification, arg)			   \
-	((!(sd) || !(sd)->v4l2_dev || !(sd)->v4l2_dev->notify) ? -ENODEV : \
-	 (sd)->v4l2_dev->notify((sd), (notification), (arg)))
+#define v4l2_subdev_notify(sd, notification, arg)				\
+	do {									\
+		if ((sd) && (sd)->v4l2_dev && (sd)->v4l2_dev->notify)		\
+			(sd)->v4l2_dev->notify((sd), (notification), (arg));	\
+	} while (0)
 
 #define v4l2_subdev_has_op(sd, o, f) \
 	((sd)->ops->o && (sd)->ops->o->f)
-- 
1.9.0

