Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:42240 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727592AbeHDOqJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Aug 2018 10:46:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv17 07/34] v4l2-device.h: add v4l2_device_supports_requests() helper
Date: Sat,  4 Aug 2018 14:44:59 +0200
Message-Id: <20180804124526.46206-8-hverkuil@xs4all.nl>
In-Reply-To: <20180804124526.46206-1-hverkuil@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a simple helper function that tests if the driver supports
the request API.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/v4l2-device.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index b330e4a08a6b..ac7677a183ff 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -211,6 +211,17 @@ static inline void v4l2_subdev_notify(struct v4l2_subdev *sd,
 		sd->v4l2_dev->notify(sd, notification, arg);
 }
 
+/**
+ * v4l2_device_supports_requests - Test if requests are supported.
+ *
+ * @v4l2_dev: pointer to struct v4l2_device
+ */
+static inline bool v4l2_device_supports_requests(struct v4l2_device *v4l2_dev)
+{
+	return v4l2_dev->mdev && v4l2_dev->mdev->ops &&
+	       v4l2_dev->mdev->ops->req_queue;
+}
+
 /* Helper macros to iterate over all subdevs. */
 
 /**
-- 
2.18.0
